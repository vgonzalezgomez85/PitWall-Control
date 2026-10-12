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
import 'package:drift/drift.dart' show Value;
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/idioma.dart';
import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import '../../domain/errores_importacion.dart';
import '../pilotos/repositorio_pilotos.dart';
import 'importador_equipos.dart';
import 'repositorio_equipos.dart';

class PantallaImportarEquipos extends ConsumerStatefulWidget {
  const PantallaImportarEquipos({super.key});

  @override
  ConsumerState<PantallaImportarEquipos> createState() =>
      _PantallaImportarEquiposState();
}

class _PantallaImportarEquiposState
    extends ConsumerState<PantallaImportarEquipos> {
  String? _archivo;
  List<String> _columnas = [];
  List<Map<String, String>> _filasArchivo = [];
  MapeoColumnasEquipo _mapeo = MapeoColumnasEquipo();
  List<EquipoImportado> _previo = [];
  bool _trabajando = false;
  String? _error;

  Future<void> _elegirArchivo() async {
    final l = context.l;
    setState(() {
      _error = null;
      _trabajando = true;
    });
    try {
      final tipo = XTypeGroup(
        label: l.archivos,
        extensions: ['csv', 'xlsx', 'xls'],
      );
      final xfile = await openFile(acceptedTypeGroups: [tipo]);
      if (xfile == null) {
        setState(() => _trabajando = false);
        return;
      }
      _archivo = xfile.path;
      final res = await ImportadorEquipos.leerArchivo(xfile.path);
      _columnas = res.columnas;
      _filasArchivo = res.filas;
      _mapeo = ImportadorEquipos.detectarMapeo(_columnas);
      await _recalcular();
    } on FormatoNoSoportado catch (e) {
      _error = l.formatoNoSoportadoUsaCsv(e.extension);
    } catch (e) {
      _error = l.noSePudoLeerArchivo('$e');
    } finally {
      if (mounted) setState(() => _trabajando = false);
    }
  }

  Future<void> _recalcular() async {
    final l = context.l;
    final filas = ImportadorEquipos.transformar(_filasArchivo, _mapeo);
    final activo = ref.read(campeonatoActivoProvider);
    if (activo == null) {
      setState(() => _previo = filas);
      return;
    }
    final db = ref.read(dbProvider);
    final equipos = await (db.select(db.equipos)
          ..where((t) => t.campeonatoId.equals(activo.id)))
        .get();
    final nombresEquipo = {for (final e in equipos) _norm(e.nombre)};

    final esPareja = activo.formato == 'PAREJAS';
    for (final f in filas) {
      if (f.piloto1Nombre.isEmpty) {
        f.estado = 'sin_piloto';
        f.importar = false;
        f.aviso = l.sinPiloto;
        continue;
      }
      if (esPareja && (f.piloto2Nombre == null || f.piloto2Nombre!.isEmpty)) {
        f.aviso = l.faltaSegundoPiloto;
      }
      if (nombresEquipo.contains(_norm(f.nombreEquipo))) {
        f.estado = 'equipo_existe';
        f.importar = false;
      }
    }

    if (mounted) setState(() => _previo = filas);
  }

  static String _norm(String s) =>
      s.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();

  Future<void> _importar() async {
    final activo = ref.read(campeonatoActivoProvider)!;
    final db = ref.read(dbProvider);
    final repoEq = ref.read(repoEquiposProvider);
    final repoPi = ref.read(repoPilotosProvider);
    setState(() => _trabajando = true);

    int equiposCreados = 0, pilotosNuevos = 0, pilotosInscritos = 0, saltados = 0;
    try {
      final maestro = await db.select(db.pilotos).get();
      final porNombre = {for (final p in maestro) _norm(p.nombre): p};
      final inscritos = await (db.select(db.pilotoCampeonato)
            ..where((t) => t.campeonatoId.equals(activo.id)))
          .get();
      final idsInscritos = inscritos.map((e) => e.pilotoId).toSet();

      Future<int> obtenerOCrearPiloto({
        required String nombre,
        String? email,
        String? telefono,
        String? categoria,
        String? palmares,
      }) async {
        final existente = porNombre[_norm(nombre)];
        if (existente != null) {
          // Inscribir si no estaba en este campeonato
          if (!idsInscritos.contains(existente.id)) {
            final cat = (categoria != null && categorias.contains(categoria))
                ? categoria
                : 'BRONCE';
            final ini =
                creditosInicialesPorCategoria[cat] ?? 28;
            await repoPi.inscribirEnCampeonato(
              pilotoId: existente.id,
              campeonatoId: activo.id,
              categoria: cat,
              creditosIniciales: ini,
            );
            idsInscritos.add(existente.id);
            pilotosInscritos++;
          }
          // Completar campos vacíos del maestro
          if (((existente.email ?? '').isEmpty && (email ?? '').isNotEmpty) ||
              ((existente.telefono ?? '').isEmpty && (telefono ?? '').isNotEmpty) ||
              ((existente.palmaresGlobal ?? '').isEmpty &&
                  (palmares ?? '').isNotEmpty)) {
            await (db.update(db.pilotos)
                  ..where((t) => t.id.equals(existente.id)))
                .write(PilotosCompanion(
              email: Value(email ?? existente.email),
              telefono: Value(telefono ?? existente.telefono),
              palmaresGlobal: Value(palmares ?? existente.palmaresGlobal),
            ));
          }
          return existente.id;
        }
        final cat = (categoria != null && categorias.contains(categoria))
            ? categoria
            : 'BRONCE';
        final ini = creditosInicialesPorCategoria[cat] ?? 28;
        final id = await repoPi.crear(
          nombre: nombre,
          email: email,
          telefono: telefono,
          palmaresGlobal: palmares,
          campeonatoId: activo.id,
          categoria: cat,
          creditosIniciales: ini,
        );
        // Reflejar en mapa local
        porNombre[_norm(nombre)] = Piloto(
          id: id,
          nombre: nombre,
          palmaresGlobal: palmares,
          telefono: telefono,
          email: email,
          esCoordinadora: false,
          creadoEn: DateTime.now(),
        );
        idsInscritos.add(id);
        pilotosNuevos++;
        return id;
      }

      for (final f in _previo) {
        if (!f.importar) {
          saltados++;
          continue;
        }
        final p1Id = await obtenerOCrearPiloto(
          nombre: f.piloto1Nombre,
          email: f.piloto1Email,
          telefono: f.piloto1Telefono,
          categoria: f.piloto1Categoria,
          palmares: f.piloto1Palmares,
        );
        final miembros = <int>[p1Id];
        if (f.piloto2Nombre != null && f.piloto2Nombre!.isNotEmpty) {
          miembros.add(await obtenerOCrearPiloto(
            nombre: f.piloto2Nombre!,
            email: f.piloto2Email,
            telefono: f.piloto2Telefono,
            categoria: f.piloto2Categoria,
            palmares: f.piloto2Palmares,
          ));
        }
        // Pilotos 3+ (resistencia): solo nombre, categoría por defecto.
        for (final nombre in f.pilotosExtra) {
          final id = await obtenerOCrearPiloto(nombre: nombre);
          if (!miembros.contains(id)) miembros.add(id);
        }

        final copa = (f.copa != null && f.copa!.isNotEmpty) ? f.copa! : 'GT';
        await repoEq.crearN(
          campeonatoId: activo.id,
          nombre: f.nombreEquipo,
          copa: copa,
          pilotoIds: miembros,
        );
        equiposCreados++;
      }

      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(context.l.importacionCompletada),
          content: Text(context.l.resumenImportacionEquipos(
              equiposCreados, pilotosNuevos, pilotosInscritos, saltados)),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l.ok),
            ),
          ],
        ),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l.errorImportando('$e'))),
      );
    } finally {
      if (mounted) setState(() => _trabajando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final paraImportar = _previo.where((f) => f.importar).length;
    final activo = ref.watch(campeonatoActivoProvider);
    final esPareja = activo?.formato == 'PAREJAS';

    return Scaffold(
      appBar: AppBar(title: Text(context.l.importarEquipos)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            color: cs.surfaceContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l.paso1EligeArchivo,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    context.l.equipoImportTexto(esPareja
                        ? context.l.susDosPilotos
                        : context.l.suPiloto),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      FilledButton.icon(
                        onPressed: _trabajando ? null : _elegirArchivo,
                        icon: const Icon(Icons.folder_open),
                        label: Text(context.l.elegirArchivo),
                      ),
                      const SizedBox(width: 12),
                      if (_archivo != null)
                        Expanded(
                          child: Text(
                            _archivo!.split('/').last,
                            style: Theme.of(context).textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 16),
            Card(
              color: cs.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: cs.onErrorContainer),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(_error!,
                          style: TextStyle(color: cs.onErrorContainer)),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (_columnas.isNotEmpty) ...[
            const SizedBox(height: 16),
            _MapeoEquipos(
              columnas: _columnas,
              mapeo: _mapeo,
              esPareja: esPareja,
              onCambio: _recalcular,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(context.l.paso3VistaPrevia,
                            style: Theme.of(context).textTheme.titleMedium),
                        const Spacer(),
                        Text(
                            context.l.nDeTotalSeImportaran(
                                paraImportar, _previo.length),
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (!_mapeo.esValido)
                      Text(
                        context.l.asignaColumnaEquipoYPiloto,
                        style: TextStyle(color: cs.error),
                      )
                    else if (_previo.isEmpty)
                      Text(context.l.noFilasValidas)
                    else
                      ..._previo.asMap().entries.map(
                            (e) => _FilaPrevia(
                              fila: e.value,
                              onToggle: () => setState(() {
                                if (e.value.estado != 'equipo_existe' &&
                                    e.value.estado != 'sin_piloto') {
                                  e.value.importar = !e.value.importar;
                                }
                              }),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: (_trabajando || paraImportar == 0 || !_mapeo.esValido)
                  ? null
                  : _importar,
              icon: _trabajando
                  ? const SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cloud_download_outlined),
              label: Text(context.l.importarNEquipos(paraImportar)),
            ),
          ],
        ],
      ),
    );
  }
}

class _MapeoEquipos extends StatelessWidget {
  const _MapeoEquipos({
    required this.columnas,
    required this.mapeo,
    required this.esPareja,
    required this.onCambio,
  });

  final List<String> columnas;
  final MapeoColumnasEquipo mapeo;
  final bool esPareja;
  final Future<void> Function() onCambio;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l.paso2AsignaLasColumnas,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              context.l.columnasIntentadas,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            _SecHead(context.l.equipos),
            _sel(context, context.l.nombreDelEquipoObligatorio, mapeo.colEquipo,
                (v) { mapeo.colEquipo = v; onCambio(); }),
            _sel(context, context.l.copaCategoria, mapeo.colCopa,
                (v) { mapeo.colCopa = v; onCambio(); }),
            const SizedBox(height: 12),
            _SecHead(context.l.piloto1),
            _sel(context, context.l.nombreObligatorio, mapeo.colP1Nombre,
                (v) { mapeo.colP1Nombre = v; onCambio(); }),
            _sel(context, context.l.email, mapeo.colP1Email,
                (v) { mapeo.colP1Email = v; onCambio(); }),
            _sel(context, context.l.telefono, mapeo.colP1Telefono,
                (v) { mapeo.colP1Telefono = v; onCambio(); }),
            _sel(context, context.l.categoria, mapeo.colP1Categoria,
                (v) { mapeo.colP1Categoria = v; onCambio(); }),
            _sel(context, context.l.palmares, mapeo.colP1Palmares,
                (v) { mapeo.colP1Palmares = v; onCambio(); }),
            const SizedBox(height: 12),
            _SecHead(esPareja
                ? context.l.piloto2
                : context.l.piloto2Opcional),
            _sel(context, context.l.nombreCampo, mapeo.colP2Nombre,
                (v) { mapeo.colP2Nombre = v; onCambio(); }),
            _sel(context, context.l.email, mapeo.colP2Email,
                (v) { mapeo.colP2Email = v; onCambio(); }),
            _sel(context, context.l.telefono, mapeo.colP2Telefono,
                (v) { mapeo.colP2Telefono = v; onCambio(); }),
            _sel(context, context.l.categoria, mapeo.colP2Categoria,
                (v) { mapeo.colP2Categoria = v; onCambio(); }),
            _sel(context, context.l.palmares, mapeo.colP2Palmares,
                (v) { mapeo.colP2Palmares = v; onCambio(); }),
          ],
        ),
      ),
    );
  }

  Widget _sel(BuildContext context, String label, String? actual,
      ValueChanged<String?> onChange) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: DropdownButtonFormField<String?>(
        initialValue: actual,
        isExpanded: true,
        decoration: InputDecoration(labelText: label, isDense: true),
        items: [
          DropdownMenuItem(value: null, child: Text(context.l.ninguna)),
          ...columnas.map((c) => DropdownMenuItem(value: c, child: Text(c))),
        ],
        onChanged: onChange,
      ),
    );
  }
}

class _SecHead extends StatelessWidget {
  const _SecHead(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary,
              )),
    );
  }
}

class _FilaPrevia extends StatelessWidget {
  const _FilaPrevia({required this.fila, required this.onToggle});
  final EquipoImportado fila;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    Color colorEstado;
    String etiqueta;
    switch (fila.estado) {
      case 'equipo_existe':
        colorEstado = cs.outline;
        etiqueta = context.l.yaExiste;
      case 'sin_piloto':
        colorEstado = cs.error;
        etiqueta = context.l.sinPiloto;
      default:
        colorEstado = cs.primary;
        etiqueta = context.l.nuevo;
    }

    final esBloqueado =
        fila.estado == 'equipo_existe' || fila.estado == 'sin_piloto';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: fila.importar,
            onChanged: esBloqueado ? null : (_) => onToggle(),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fila.nombreEquipo,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          decoration: fila.importar
                              ? null
                              : TextDecoration.lineThrough,
                          color: fila.importar ? null : cs.outline,
                        )),
                Text(
                  [
                    fila.piloto1Nombre,
                    if (fila.piloto2Nombre != null) fila.piloto2Nombre!,
                    ...fila.pilotosExtra,
                  ].join(' + '),
                  style: TextStyle(color: cs.onSurfaceVariant),
                ),
                if (fila.copa != null)
                  Text(context.l.copaDosPuntos(fila.copa!),
                      style: TextStyle(color: cs.outline, fontSize: 12)),
                if (fila.aviso != null)
                  Text(fila.aviso!,
                      style: TextStyle(color: cs.error, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: colorEstado.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(etiqueta,
                style: TextStyle(
                  color: colorEstado, fontSize: 12, fontWeight: FontWeight.w600,
                )),
          ),
        ],
      ),
    );
  }
}
