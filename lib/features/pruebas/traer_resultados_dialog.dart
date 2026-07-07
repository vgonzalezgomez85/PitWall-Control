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
// Diálogo "Traer resultados de PitWall": descubre un PitWall Manager en la LAN
// (o IP manual), lista sus carreras, el usuario elige una, se muestra la
// PREVIEW (equipos casados por nombre contra el campeonato, como el import CSV)
// y al aplicar se escribe la posición por manga con asignarPosicionEquipo
// (los puntos los calcula Control con SU TablaPuntos).

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nsd/nsd.dart';

import '../../core/proveedores.dart';
import '../../services/almacen_local.dart';
import '../../services/traer_resultados_service.dart';
import '../resultados/pantalla_resultados_prueba.dart'
    show mangaPorEquipoEnPrueba;
import '../resultados/repositorio_resultados.dart';

const _kHostKey = 'pitwall_host';
const _serviceType = '_voltrace-manager._tcp';

Future<void> mostrarTraerResultados(
    BuildContext context, WidgetRef ref, int pruebaId) async {
  await showDialog<void>(
    context: context,
    builder: (_) => _TraerResultadosDialog(ref: ref, pruebaId: pruebaId),
  );
}

/// Fila de la preview: un resultado remoto casado (o no) con un equipo local.
class _FilaPreview {
  final ResultadoRemoto remoto;
  int? equipoId;
  int? mangaId;
  String estado; // ok | equipo_no_existe | no_inscrito
  bool importar;
  _FilaPreview(this.remoto,
      {this.equipoId, this.mangaId, this.estado = 'ok', this.importar = true});
}

class _TraerResultadosDialog extends StatefulWidget {
  const _TraerResultadosDialog({required this.ref, required this.pruebaId});
  final WidgetRef ref;
  final int pruebaId;

  @override
  State<_TraerResultadosDialog> createState() => _TraerResultadosDialogState();
}

class _TraerResultadosDialogState extends State<_TraerResultadosDialog> {
  final _hostCtrl = TextEditingController();
  Discovery? _disc;
  bool _buscando = true;
  bool _trabajando = false;

  int _paso = 0; // 0 = elegir PitWall, 1 = elegir carrera, 2 = preview
  List<CarreraManager> _carreras = [];
  String _raceName = '';
  List<_FilaPreview> _filas = [];

  @override
  void initState() {
    super.initState();
    final almacen = widget.ref.read(almacenSyncProvider);
    _hostCtrl.text = almacen.readSync(key: _kHostKey) ?? '';
    _iniciarDescubrimiento();
  }

  Future<void> _iniciarDescubrimiento() async {
    try {
      final d =
          await startDiscovery(_serviceType, ipLookupType: IpLookupType.v4);
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
      if (mounted) setState(() => _buscando = false);
    }
  }

  @override
  void dispose() {
    final d = _disc;
    if (d != null) stopDiscovery(d).catchError((_) {});
    _hostCtrl.dispose();
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
    return '$host:${s.port ?? 3000}';
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  // Paso 0 → 1: pedir la lista de carreras a Manager.
  Future<void> _cargarCarreras() async {
    final host = _hostCtrl.text.trim();
    if (host.isEmpty) {
      _snack('Elige un PitWall o escribe su dirección.');
      return;
    }
    setState(() => _trabajando = true);
    try {
      await widget.ref
          .read(almacenSyncProvider)
          .write(key: _kHostKey, value: host);
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

  // Paso 1 → 2: bajar los resultados y casarlos con los equipos del campeonato.
  Future<void> _elegirCarrera(CarreraManager c) async {
    setState(() => _trabajando = true);
    try {
      final res = await traerResultados(_hostCtrl.text.trim(), c.id);
      final db = widget.ref.read(dbProvider);
      final activo = widget.ref.read(campeonatoActivoProvider);
      if (activo == null) throw 'No hay campeonato activo.';

      final equipos = await (db.select(db.equipos)
            ..where((t) => t.campeonatoId.equals(activo.id)))
          .get();
      final porNombre = {for (final e in equipos) _norm(e.nombre): e};
      final mangaPorEquipo = await mangaPorEquipoEnPrueba(db, widget.pruebaId);

      final filas = <_FilaPreview>[];
      for (final r in res.filas) {
        final eq = porNombre[_norm(r.nombre)];
        if (eq == null) {
          filas.add(_FilaPreview(r, estado: 'equipo_no_existe', importar: false));
        } else if (mangaPorEquipo.containsKey(eq.id)) {
          filas.add(_FilaPreview(r,
              equipoId: eq.id, mangaId: mangaPorEquipo[eq.id], estado: 'ok'));
        } else {
          filas.add(_FilaPreview(r,
              equipoId: eq.id, estado: 'no_inscrito', importar: false));
        }
      }
      if (!mounted) return;
      setState(() {
        _raceName = res.raceName;
        _filas = filas;
        _paso = 2;
      });
    } catch (e) {
      _snack('No se pudieron traer los resultados: $e');
    } finally {
      if (mounted) setState(() => _trabajando = false);
    }
  }

  static String _norm(String s) =>
      s.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();

  // Paso 2: aplicar posiciones (los puntos salen de la TablaPuntos de Control).
  Future<void> _aplicar() async {
    final activo = widget.ref.read(campeonatoActivoProvider)!;
    final repoRes = widget.ref.read(repoResultadosProvider);
    setState(() => _trabajando = true);
    int ok = 0, saltados = 0;
    try {
      for (final f in _filas) {
        if (!f.importar || f.equipoId == null || f.mangaId == null) {
          saltados++;
          continue;
        }
        await repoRes.asignarPosicionEquipo(
          mangaId: f.mangaId!,
          equipoId: f.equipoId!,
          campeonatoId: activo.id,
          posicion: f.remoto.posicion,
        );
        ok++;
      }
      if (!mounted) return;
      Navigator.of(context).pop();
      _snack('Resultados aplicados: $ok · saltados: $saltados');
    } catch (e) {
      _snack('Error al aplicar: $e');
      if (mounted) setState(() => _trabajando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(switch (_paso) {
        0 => 'Traer resultados de PitWall',
        1 => 'Elige la carrera',
        _ => 'Resultados: $_raceName',
      }),
      content: SizedBox(width: 480, child: _cuerpo()),
      actions: [
        TextButton(
          onPressed: _trabajando ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        if (_paso == 0)
          FilledButton.icon(
            onPressed: _trabajando ? null : _cargarCarreras,
            icon: _trabajando
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.list),
            label: const Text('Ver carreras'),
          ),
        if (_paso == 2)
          FilledButton.icon(
            onPressed: _trabajando ||
                    !_filas.any((f) => f.importar && f.equipoId != null)
                ? null
                : _aplicar,
            icon: _trabajando
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.check),
            label: Text(
                'Aplicar (${_filas.where((f) => f.importar && f.equipoId != null).length})'),
          ),
      ],
    );
  }

  Widget _cuerpo() {
    switch (_paso) {
      case 0:
        return _pasoHost();
      case 1:
        return _pasoCarreras();
      default:
        return _pasoPreview();
    }
  }

  Widget _pasoHost() {
    final servicios = _disc?.services ?? const <Service>[];
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
                  child: CircularProgressIndicator(strokeWidth: 2)),
          ],
        ),
        const SizedBox(height: 6),
        if (servicios.isEmpty && !_buscando)
          const Text(
              'No se ha encontrado ningún PitWall. Escribe su dirección abajo.',
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
      ],
    );
  }

  Widget _pasoCarreras() {
    if (_carreras.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('PitWall no tiene carreras.'),
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
              onTap: () => _elegirCarrera(c),
            ),
        ],
      ),
    );
  }

  Widget _pasoPreview() {
    if (_filas.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('La carrera no tiene resultados todavía.'),
      );
    }
    final multiTanda = _filas.map((f) => f.remoto.tanda).toSet().length > 1;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 380),
      child: ListView(
        shrinkWrap: true,
        children: [
          for (final f in _filas)
            CheckboxListTile(
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              value: f.importar,
              onChanged: f.equipoId == null || f.mangaId == null
                  ? null
                  : (v) => setState(() => f.importar = v ?? false),
              title: Text(
                  '${multiTanda ? 'T${f.remoto.tanda} · ' : ''}'
                  '${f.remoto.posicion}º  ${f.remoto.nombre}'),
              subtitle: Text(switch (f.estado) {
                'equipo_no_existe' => 'Equipo no encontrado en el campeonato',
                'no_inscrito' => 'No inscrito en esta prueba',
                _ =>
                  '${f.remoto.vueltas ?? '—'} vueltas · se aplicará posición ${f.remoto.posicion}',
              }),
              secondary: Icon(
                switch (f.estado) {
                  'equipo_no_existe' => Icons.error_outline,
                  'no_inscrito' => Icons.person_off_outlined,
                  _ => Icons.check_circle_outline,
                },
                color: f.estado == 'ok' ? Colors.green : Colors.orange,
              ),
            ),
        ],
      ),
    );
  }
}
