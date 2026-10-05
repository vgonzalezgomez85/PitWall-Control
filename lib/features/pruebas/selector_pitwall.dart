// PitWall Control — gestor de campeonatos de slot
// Copyright (C) 2026 Víctor González Gómez <vgonzalezgomez@outlook.es>
//
// This program is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation, either version 3 of the License, or (at your option)
// any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along with
// this program. If not, see <https://www.gnu.org/licenses/>.
//
// Additional permission under GPLv3 section 7: distribution through application
// stores (e.g. Apple App Store, Google Play) is permitted. See LICENSE-EXCEPTION.
//
// Selector de PitWall Manager compartido por "Enviar a PitWall", "Enviar
// verificaciones a PitWall" y "Traer resultados de PitWall". Busca los Manager
// de la LAN por dos vías a la vez y deja escribir la IP:puerto a mano:
//  1. mDNS (_pitwall-manager._tcp, que anuncia Manager por Bonjour). Los
//     servicios se resuelven aquí con reintentos: el plugin, si la resolución
//     falla (en Android pasa a menudo), descarta el servicio sin avisar.
//  2. Barrido de la subred /24 de cada interfaz al puerto de Manager pidiendo
//     GET /link/races (sin token, accesible desde la LAN). Cubre routers y
//     tablets que filtran el multicast.
// Si el usuario no ha tocado el campo, se rellena solo con el primer PitWall
// encontrado (útil cuando la IP guardada de la última vez ha cambiado por DHCP).

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nsd/nsd.dart';

const _serviceType = '_pitwall-manager._tcp';
const _puertoManager = 3000;

// Tiempo mínimo que se muestra "Buscando…" (la discovery mDNS sigue viva
// después y añade los PitWall que aparezcan más tarde).
const _duracionBusqueda = Duration(seconds: 6);

class SelectorPitwall extends StatefulWidget {
  const SelectorPitwall({super.key, required this.hostCtrl});

  /// Controlador del campo "IP:puerto"; el diálogo lo lee al enviar.
  final TextEditingController hostCtrl;

  @override
  State<SelectorPitwall> createState() => _SelectorPitwallState();
}

class _SelectorPitwallState extends State<SelectorPitwall> {
  Discovery? _disc;
  Timer? _timer;
  // host "ip:puerto" → nombre mostrado, en orden de aparición.
  final Map<String, String> _encontrados = {};
  final Set<String> _resolviendo = {};
  int _ronda = 0; // invalida resultados de una búsqueda anterior
  bool _esperando = false; // aún no han pasado _duracionBusqueda
  bool _barriendo = false;
  bool _editadoAMano = false;

  bool get _buscando => _esperando || _barriendo;

  @override
  void initState() {
    super.initState();
    _buscar();
  }

  @override
  void dispose() {
    _ronda++;
    _timer?.cancel();
    _pararDiscovery();
    super.dispose();
  }

  void _pararDiscovery() {
    final d = _disc;
    _disc = null;
    // stopDiscovery es async; se lanza sin esperar (el widget ya se va).
    if (d != null) stopDiscovery(d).catchError((_) {});
  }

  Future<void> _buscar() async {
    final ronda = ++_ronda;
    _timer?.cancel();
    _pararDiscovery();
    setState(() {
      _encontrados.clear();
      _resolviendo.clear();
      _esperando = true;
    });
    _timer = Timer(_duracionBusqueda, () {
      if (mounted) setState(() => _esperando = false);
    });
    unawaited(_barrerSubred(ronda));
    try {
      final d = await startDiscovery(_serviceType, autoResolve: false);
      if (!mounted || ronda != _ronda) {
        await stopDiscovery(d);
        return;
      }
      _disc = d;
      d.addListener(() => _alCambiarServicios(ronda));
      _alCambiarServicios(ronda);
    } catch (_) {
      // mDNS no disponible (permiso de red local, plataforma…): queda el
      // barrido de la subred y la IP manual.
    }
  }

  void _alCambiarServicios(int ronda) {
    for (final s in _disc?.services ?? const <Service>[]) {
      final clave = s.name ?? '';
      if (_resolviendo.add(clave)) unawaited(_resolver(s, ronda));
    }
  }

  // Resuelve un servicio mDNS a "ip:puerto", con reintentos.
  Future<void> _resolver(Service s, int ronda) async {
    for (var intento = 0; intento < 4; intento++) {
      if (!mounted || ronda != _ronda) return;
      try {
        final r = await resolve(s).timeout(const Duration(seconds: 5));
        final host = await _ipDe(r);
        if (host != null) {
          _anadir('$host:${r.port ?? _puertoManager}', s.name ?? 'PitWall',
              ronda);
          return;
        }
      } catch (_) {
        // FAILURE_ALREADY_ACTIVE, timeout… se reintenta.
      }
      await Future<void>.delayed(Duration(milliseconds: 600 * (intento + 1)));
    }
  }

  static Future<String?> _ipDe(Service s) async {
    final addrs = s.addresses ?? const <InternetAddress>[];
    for (final a in addrs) {
      if (a.type == InternetAddressType.IPv4) return a.address;
    }
    final host = s.host;
    if (host == null || host.isEmpty) return null;
    if (InternetAddress.tryParse(host) != null) return host;
    try {
      final r = await InternetAddress.lookup(host,
              type: InternetAddressType.IPv4)
          .timeout(const Duration(seconds: 3));
      return r.isEmpty ? null : r.first.address;
    } catch (_) {
      return null;
    }
  }

  // Barre la /24 de cada interfaz IPv4 privada buscando Manager.
  Future<void> _barrerSubred(int ronda) async {
    setState(() => _barriendo = true);
    final cliente = HttpClient()
      ..connectionTimeout = const Duration(milliseconds: 700);
    try {
      final interfaces =
          await NetworkInterface.list(type: InternetAddressType.IPv4);
      final puertos = {_puertoManager, ?_puertoGuardado()};
      final candidatos = <String>[];
      for (final i in interfaces) {
        for (final a in i.addresses) {
          final o = a.rawAddress;
          final privada = o[0] == 10 ||
              (o[0] == 192 && o[1] == 168) ||
              (o[0] == 172 && o[1] >= 16 && o[1] <= 31);
          if (!privada || a.isLoopback) continue;
          for (var h = 1; h <= 254; h++) {
            for (final p in puertos) {
              candidatos.add('${o[0]}.${o[1]}.${o[2]}.$h:$p');
            }
          }
        }
      }
      // En tandas para no abrir cientos de sockets a la vez.
      for (var i = 0; i < candidatos.length; i += 64) {
        if (!mounted || ronda != _ronda) return;
        final tanda = candidatos.skip(i).take(64);
        await Future.wait(tanda.map((c) async {
          if (await _esManager(cliente, c)) _anadir(c, 'PitWall', ronda);
        }));
      }
    } catch (_) {
      // Sin acceso a las interfaces: queda mDNS y la IP manual.
    } finally {
      cliente.close(force: true);
      if (mounted && ronda == _ronda) setState(() => _barriendo = false);
    }
  }

  int? _puertoGuardado() {
    final u = Uri.tryParse('http://${widget.hostCtrl.text.trim()}');
    return (u != null && u.hasPort) ? u.port : null;
  }

  static Future<bool> _esManager(HttpClient cliente, String host) async {
    try {
      final req = await cliente.getUrl(Uri.parse('http://$host/link/races'));
      final res = await req.close().timeout(const Duration(seconds: 2));
      if (res.statusCode != 200) {
        await res.drain<void>();
        return false;
      }
      final cuerpo = await res
          .transform(utf8.decoder)
          .join()
          .timeout(const Duration(seconds: 2));
      final j = jsonDecode(cuerpo);
      return j is Map && j['races'] is List;
    } catch (_) {
      return false;
    }
  }

  void _anadir(String host, String nombre, int ronda) {
    if (!mounted || ronda != _ronda) return;
    // El nombre de mDNS manda sobre el genérico del barrido.
    if (_encontrados.containsKey(host) && nombre == 'PitWall') return;
    _encontrados[host] = nombre;
    if (!_editadoAMano &&
        !_encontrados.containsKey(widget.hostCtrl.text.trim())) {
      widget.hostCtrl.text = _encontrados.keys.first;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final actual = widget.hostCtrl.text.trim();
    final gris = TextStyle(fontSize: 12, color: Colors.grey.shade600);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('PitWall en la red',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const Spacer(),
            if (_buscando)
              const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2))
            else
              IconButton(
                tooltip: 'Buscar de nuevo',
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.refresh, size: 18),
                onPressed: _buscar,
              ),
          ],
        ),
        const SizedBox(height: 6),
        if (_encontrados.isEmpty)
          Text(
            _buscando
                ? 'Buscando PitWall en la red local…'
                : 'No se ha encontrado ningún PitWall. Comprueba que está '
                    'abierto y en la misma red Wi‑Fi, o escribe su dirección '
                    'abajo.',
            style: gris,
          )
        else
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 160),
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final e in _encontrados.entries)
                  ListTile(
                    dense: true,
                    selected: e.key == actual,
                    leading: const Icon(Icons.dns_outlined),
                    title: Text(e.value),
                    subtitle: Text(e.key),
                    trailing: e.key == actual
                        ? const Icon(Icons.check, size: 18)
                        : null,
                    onTap: () => setState(() {
                      _editadoAMano = false;
                      widget.hostCtrl.text = e.key;
                    }),
                  ),
              ],
            ),
          ),
        const Divider(),
        TextField(
          controller: widget.hostCtrl,
          onChanged: (_) => setState(() => _editadoAMano = true),
          decoration: const InputDecoration(
            labelText: 'Dirección (IP:puerto)',
            hintText: '192.168.1.50:3000',
          ),
        ),
      ],
    );
  }
}
