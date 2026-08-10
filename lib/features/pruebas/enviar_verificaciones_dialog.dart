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
// Diálogo "Enviar verificaciones a PitWall": descubre Manager en la LAN (o IP
// manual + PIN), pide la lista de sus carreras (mismo `/link/races` que usa
// "Traer resultados") y, al elegir una, envía las verificaciones LIGADAS a
// esa carrera (a modo de solo consulta en Manager). Guarda el raceId elegido
// como el de esta prueba para la próxima vez.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nsd/nsd.dart';
import 'dart:io';

import '../../services/almacen_local.dart';
import '../../services/enviar_verificaciones_service.dart';
import '../../services/generador_verificaciones_json.dart';
import '../../services/traer_resultados_service.dart'
    show listarCarreras, CarreraManager;
import 'repositorio_pruebas.dart';

const _kHostKey = 'pitwall_host';
const _kPinKey = 'pitwall_pin';
const _serviceType = '_voltrace-manager._tcp';

Future<void> mostrarEnviarVerificaciones(
    BuildContext context, WidgetRef ref, int pruebaId) async {
  await showDialog<void>(
    context: context,
    builder: (_) => _EnviarVerificacionesDialog(ref: ref, pruebaId: pruebaId),
  );
}

class _EnviarVerificacionesDialog extends StatefulWidget {
  const _EnviarVerificacionesDialog(
      {required this.ref, required this.pruebaId});
  final WidgetRef ref;
  final int pruebaId;

  @override
  State<_EnviarVerificacionesDialog> createState() =>
      _EnviarVerificacionesDialogState();
}

class _EnviarVerificacionesDialogState
    extends State<_EnviarVerificacionesDialog> {
  final _hostCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  Discovery? _disc;
  bool _buscando = true;
  bool _trabajando = false; // listando carreras o enviando

  int _paso = 0; // 0 = elegir PitWall, 1 = elegir carrera
  List<CarreraManager> _carreras = [];

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
      stopDiscovery(d).catchError((_) {});
    }
    _hostCtrl.dispose();
    _pinCtrl.dispose();
    super.dispose();
  }

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

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  // Paso 0 → 1: guardar host/PIN y pedir la lista de carreras a Manager.
  Future<void> _verCarreras() async {
    final host = _hostCtrl.text.trim();
    if (host.isEmpty) {
      _snack('Elige un PitWall o escribe su dirección.');
      return;
    }
    setState(() => _trabajando = true);
    try {
      final almacen = widget.ref.read(almacenSyncProvider);
      await almacen.write(key: _kHostKey, value: host);
      await almacen.write(key: _kPinKey, value: _pinCtrl.text.trim());
      final carreras = await listarCarreras(host);
      if (!mounted) return;
      setState(() {
        _carreras = carreras;
        _paso = 1;
      });
    } catch (e) {
      _snack('No se pudo conectar: $e');
    } finally {
      if (mounted) setState(() => _trabajando = false);
    }
  }

  // Paso 1: al elegir una carrera, se envían las verificaciones ligadas a ella.
  Future<void> _enviarACarrera(CarreraManager carrera) async {
    setState(() => _trabajando = true);
    try {
      final payload = await widget.ref
          .read(generadorVerificacionesJsonProvider)
          .generar(pruebaId: widget.pruebaId, raceId: carrera.id);
      final verificaciones = (payload['verificaciones'] as List?) ?? const [];
      if (verificaciones.isEmpty) {
        _snack('No hay verificaciones que enviar en esta prueba.');
        setState(() => _trabajando = false);
        return;
      }

      final res = await enviarVerificaciones(
          host: _hostCtrl.text.trim(), pin: _pinCtrl.text, payload: payload);
      if (res.ok) {
        await widget.ref
            .read(repoPruebasProvider)
            .guardarManagerRaceId(widget.pruebaId, carrera.id);
      }
      if (!mounted) return;
      if (res.ok) {
        Navigator.of(context).pop();
        _snack(res.mensaje);
      } else {
        setState(() => _trabajando = false);
        _snack(res.mensaje);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _trabajando = false);
      _snack('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_paso == 0
          ? 'Enviar verificaciones a PitWall'
          : 'Elige la carrera'),
      content: SizedBox(width: 420, child: _cuerpo()),
      actions: [
        TextButton(
          onPressed: _trabajando ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        if (_paso == 1)
          TextButton(
            onPressed: _trabajando ? null : () => setState(() => _paso = 0),
            child: const Text('Atrás'),
          ),
        if (_paso == 0)
          FilledButton.icon(
            onPressed: _trabajando ? null : _verCarreras,
            icon: _trabajando
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.list),
            label: const Text('Ver carreras'),
          ),
      ],
    );
  }

  Widget _cuerpo() => _paso == 0 ? _pasoHost() : _pasoCarreras();

  Widget _pasoHost() {
    final servicios = _disc?.services ?? const <Service>[];
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Se envían a modo de consulta: en PitWall se podrán ver pero no editar.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 8),
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
                    onTap: () => setState(() => _hostCtrl.text = _hostDe(s)),
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
      ],
    );
  }

  Widget _pasoCarreras() {
    if (_carreras.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('PitWall no tiene carreras. Envía antes una tanda '
            '(«Enviar a PitWall») o crea la carrera en Manager.'),
      );
    }
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 340),
      child: ListView(
        shrinkWrap: true,
        children: [
          for (final c in _carreras)
            ListTile(
              leading: const Icon(Icons.flag_outlined),
              title: Text(c.nombre),
              subtitle: Text(
                  '${c.tandas} tanda(s)${c.creada != null ? ' · ${c.creada}' : ''}'),
              enabled: !_trabajando,
              onTap: () => _enviarACarrera(c),
            ),
          if (_trabajando)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                  child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2))),
            ),
        ],
      ),
    );
  }
}
