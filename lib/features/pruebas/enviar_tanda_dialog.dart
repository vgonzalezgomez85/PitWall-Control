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
// Diálogo "Enviar a PitWall": descubre managers en la LAN por mDNS
// (_voltrace-manager._tcp, que ya anuncia PitWall Manager por Bonjour), permite
// elegir uno o teclear la IP a mano, pide el PIN de emparejamiento y POSTea la
// tanda. Manager autocrea la carrera.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nsd/nsd.dart';

import '../../services/almacen_local.dart';
import '../../services/enviar_tanda_service.dart';
import '../../services/generador_tanda_json.dart';

const _kHostKey = 'pitwall_host';
const _kPinKey = 'pitwall_pin';
const _serviceType = '_voltrace-manager._tcp';

Future<void> mostrarEnviarTanda(
    BuildContext context, WidgetRef ref, int pruebaId) async {
  await showDialog<void>(
    context: context,
    builder: (_) => _EnviarTandaDialog(ref: ref, pruebaId: pruebaId),
  );
}

class _EnviarTandaDialog extends StatefulWidget {
  const _EnviarTandaDialog({required this.ref, required this.pruebaId});
  final WidgetRef ref;
  final int pruebaId;

  @override
  State<_EnviarTandaDialog> createState() => _EnviarTandaDialogState();
}

class _EnviarTandaDialogState extends State<_EnviarTandaDialog> {
  final _hostCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  Discovery? _disc;
  bool _buscando = true;
  bool _enviando = false;
  bool _pole = false; // ¿la carrera tiene pole? → PitWall crea la sesión

  @override
  void initState() {
    super.initState();
    final almacen = widget.ref.read(almacenSyncProvider);
    _hostCtrl.text = almacen.readSync(key: _kHostKey) ?? '';
    _pinCtrl.text = almacen.readSync(key: _kPinKey) ?? '';
    _iniciarDescubrimiento();
  }

  Future<void> _iniciarDescubrimiento() async {
    try {
      final d = await startDiscovery(_serviceType, ipLookupType: IpLookupType.v4);
      if (!mounted) {
        await stopDiscovery(d);
        return;
      }
      d.addListener(() {
        if (mounted) setState(() {});
      });
      setState(() {
        _disc = d;
        _buscando = false;
      });
    } catch (_) {
      // mDNS no disponible (permiso de red local, plataforma…): queda la IP manual.
      if (mounted) setState(() => _buscando = false);
    }
  }

  @override
  void dispose() {
    final d = _disc;
    if (d != null) {
      // stopDiscovery es async; se lanza sin esperar (el diálogo ya se cierra).
      stopDiscovery(d).catchError((_) {});
    }
    _hostCtrl.dispose();
    _pinCtrl.dispose();
    super.dispose();
  }

  // "ip:puerto" de un servicio descubierto (IPv4 preferida).
  String _hostDe(Service s) {
    final addrs = s.addresses;
    String host = s.host ?? '';
    if (addrs != null && addrs.isNotEmpty) {
      final v4 = addrs.firstWhere(
        (a) => a.type == InternetAddressType.IPv4,
        orElse: () => addrs.first,
      );
      host = v4.address;
    }
    final port = s.port ?? 3000;
    return '$host:$port';
  }

  Future<void> _enviar() async {
    final messenger = ScaffoldMessenger.of(context);
    final host = _hostCtrl.text.trim();
    if (host.isEmpty) {
      messenger.showSnackBar(const SnackBar(
          content: Text('Elige un PitWall o escribe su dirección.')));
      return;
    }
    setState(() => _enviando = true);
    try {
      final almacen = widget.ref.read(almacenSyncProvider);
      await almacen.write(key: _kHostKey, value: host);
      await almacen.write(key: _kPinKey, value: _pinCtrl.text.trim());

      // Con pole, el generador no envía el orden de carril (la parrilla se
      // decide en PitWall tras correr la pole) y entran todos los inscritos.
      final payload = await widget.ref
          .read(generadorTandaJsonProvider)
          .generar(pruebaId: widget.pruebaId, pole: _pole);
      final tandas = (payload['tandas'] as List?) ?? const [];
      if (tandas.isEmpty) {
        messenger.showSnackBar(SnackBar(
            content: Text(_pole
                ? 'No hay inscritos que enviar.'
                : 'No hay mangas con carriles asignados que enviar.')));
        setState(() => _enviando = false);
        return;
      }

      final res = await enviarTanda(
          host: host, pin: _pinCtrl.text, payload: payload);
      if (!mounted) return;
      if (res.ok) {
        Navigator.of(context).pop();
        messenger.showSnackBar(SnackBar(content: Text(res.mensaje)));
      } else {
        setState(() => _enviando = false);
        messenger.showSnackBar(SnackBar(content: Text(res.mensaje)));
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _enviando = false);
      messenger.showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final servicios = _disc?.services ?? const <Service>[];
    return AlertDialog(
      title: const Text('Enviar a PitWall'),
      content: SizedBox(
        width: 420,
        child: Column(
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
                      child: CircularProgressIndicator(strokeWidth: 2)),
              ],
            ),
            const SizedBox(height: 6),
            if (servicios.isEmpty && !_buscando)
              const Text('No se ha encontrado ningún PitWall. Escribe su dirección abajo.',
                  style: TextStyle(fontSize: 12, color: Colors.grey))
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 160),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final s in servicios)
                      ListTile(
                        dense: true,
                        leading: const Icon(Icons.dns_outlined),
                        title: Text(s.name ?? 'PitWall'),
                        subtitle: Text(_hostDe(s)),
                        onTap: () =>
                            setState(() => _hostCtrl.text = _hostDe(s)),
                      ),
                  ],
                ),
              ),
            const Divider(),
            TextField(
              controller: _hostCtrl,
              decoration: const InputDecoration(
                labelText: 'Dirección (IP:puerto)',
                hintText: '192.168.1.50:3000',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _pinCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'PIN de importación',
                helperText: 'El PIN que muestra PitWall en «Importar tanda».',
              ),
            ),
            const SizedBox(height: 4),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              value: _pole,
              onChanged: _enviando
                  ? null
                  : (v) => setState(() => _pole = v),
              title: const Text('La carrera tiene pole'),
              subtitle: const Text(
                  'No se envía el orden de carril: la parrilla se asigna en PitWall tras la pole'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _enviando ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: _enviando ? null : _enviar,
          icon: _enviando
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.send),
          label: const Text('Enviar'),
        ),
      ],
    );
  }
}
