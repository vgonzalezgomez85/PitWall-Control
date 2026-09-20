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
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import '../equipos/editor_equipo.dart';
import '../equipos/repositorio_equipos.dart';
import '../google/actualizador_drive.dart';
import '../google/importar_inscripciones_sheets.dart';
import '../google/repositorio_hojas_vinculadas.dart';
import 'generar_mangas_wizard.dart';
import 'importador_inscripciones.dart';
import 'repositorio_inscripciones_prueba.dart';

class PantallaInscritos extends ConsumerWidget {
  const PantallaInscritos({super.key, required this.pruebaId});

  final int pruebaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inscritosAsync = ref.watch(inscritosPruebaProvider(pruebaId));
    final activo = ref.watch(campeonatoActivoProvider);
    final esIndividual = maxPilotosEquipo(activo?.formato ?? 'PAREJAS') == 1;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscritos a la prueba'),
        actions: [
          Consumer(builder: (context, ref, _) {
            final vinculoAsync = ref.watch(vinculoInscripcionesProvider(pruebaId));
            return vinculoAsync.maybeWhen(
              data: (v) => v == null
                  ? const SizedBox.shrink()
                  : IconButton(
                      tooltip:
                          'Actualizar desde Drive (${v.fila.hojaNombre})',
                      icon: const Icon(Icons.sync),
                      onPressed: () async {
                        final m = ScaffoldMessenger.of(context);
                        m.showSnackBar(const SnackBar(
                          content: Text('Actualizando desde Drive…'),
                          duration: Duration(seconds: 2),
                        ));
                        final r = await ref
                            .read(actualizadorDriveProvider)
                            .actualizarInscripciones(v);
                        m.showSnackBar(SnackBar(
                          content: Text(
                              r.ok ? '✓ ${r.mensaje}' : '✗ ${r.mensaje}'),
                          duration: const Duration(seconds: 5),
                        ));
                      },
                    ),
              orElse: () => const SizedBox.shrink(),
            );
          }),
          PopupMenuButton<String>(
            tooltip: 'Importar',
            icon: const Icon(Icons.file_upload_outlined),
            onSelected: (op) {
              if (op == 'archivo') {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => _PantallaImportarInscripciones(pruebaId: pruebaId),
                ));
              } else if (op == 'sheets') {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => ImportarInscripcionesSheets(pruebaId: pruebaId),
                ));
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'sheets',
                child: ListTile(
                  leading: Icon(Icons.cloud_outlined),
                  title: Text('Vincular Google Sheet'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'archivo',
                child: ListTile(
                  leading: Icon(Icons.upload_file_outlined),
                  title: Text('Desde archivo CSV / Excel'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: inscritosAsync.maybeWhen(
        data: (lista) => lista.isEmpty
            ? FloatingActionButton.extended(
                onPressed: () => _abrirAnadirManual(context, ref),
                icon: const Icon(Icons.add),
                label: Text(esIndividual ? 'Añadir piloto' : 'Añadir equipo'),
              )
            : FloatingActionButton.extended(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => GenerarMangasWizard(
                      pruebaId: pruebaId,
                      inscritos: lista,
                    ),
                  ),
                ),
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Generar mangas'),
              ),
        orElse: () => null,
      ),
      body: inscritosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (inscritos) {
          if (inscritos.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.how_to_reg_outlined,
                        size: 96, color: cs.outline),
                    const SizedBox(height: 16),
                    Text(
                        esIndividual
                            ? 'Aún no hay pilotos inscritos a esta prueba'
                            : 'Aún no hay equipos inscritos a esta prueba',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      esIndividual
                          ? 'Importa el CSV/Excel del Google Form '
                              'o añade pilotos a mano.'
                          : 'Importa el CSV/Excel del Google Form '
                              'o añade equipos a mano.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FilledButton.icon(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => _PantallaImportarInscripciones(
                                pruebaId: pruebaId),
                            ),
                          ),
                          icon: const Icon(Icons.file_upload_outlined),
                          label: const Text('Importar CSV/Excel'),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: () => _abrirAnadirManual(context, ref),
                          icon: const Icon(Icons.add),
                          label: const Text('Añadir a mano'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 96),
            children: [
              Card(
                color: cs.surfaceContainer,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(
                          esIndividual
                              ? Icons.person_outline
                              : Icons.groups_outlined,
                          color: cs.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          esIndividual
                              ? '${inscritos.length} pilotos inscritos. Cuando los tengas todos, '
                                  'pulsa "Generar mangas".'
                              : '${inscritos.length} equipos inscritos. Cuando los tengas todos, '
                                  'pulsa "Generar mangas".',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ...inscritos.map((i) => _TarjetaInscrito(inscrito: i)),
            ],
          );
        },
      ),
    );
  }

  Future<void> _abrirAnadirManual(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _HojaAnadirManual(pruebaId: pruebaId),
    );
  }
}

class _TarjetaInscrito extends ConsumerWidget {
  const _TarjetaInscrito({required this.inscrito});

  final InscritoPrueba inscrito;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final activo = ref.watch(campeonatoActivoProvider);
    final esIndividual = maxPilotosEquipo(activo?.formato ?? 'PAREJAS') == 1;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              inscrito.inscripcion.asignada ? cs.secondary : cs.primary,
          child: Icon(
            inscrito.inscripcion.asignada
                ? Icons.check
                : Icons.flag_outlined,
            color: Colors.white,
          ),
        ),
        title: Text(inscrito.equipo.nombre),
        subtitle: Text(
          esIndividual
              ? 'Copa: ${inscrito.equipo.copa}'
                  '${inscrito.inscripcion.preferenciaDia != null ? "  ·  ${inscrito.inscripcion.preferenciaDia}" : ""}'
              : '${inscrito.nombrePilotos}\nCopa: ${inscrito.equipo.copa}'
                  '${inscrito.inscripcion.preferenciaDia != null ? "  ·  ${inscrito.inscripcion.preferenciaDia}" : ""}',
        ),
        isThreeLine: !esIndividual,
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (op) async {
            if (op == 'quitar') {
              final ok = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Quitar inscripción'),
                  content: Text(
                      '¿Quitar a "${inscrito.equipo.nombre}" de esta prueba?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancelar')),
                    FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Quitar')),
                  ],
                ),
              );
              if (ok == true) {
                await ref
                    .read(repoInscripcionesPruebaProvider)
                    .quitar(inscrito.inscripcion.id);
              }
            }
          },
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'quitar', child: Text('Quitar')),
          ],
        ),
      ),
    );
  }
}

// ---- Añadir a mano ----

class _HojaAnadirManual extends ConsumerStatefulWidget {
  const _HojaAnadirManual({required this.pruebaId});
  final int pruebaId;

  @override
  ConsumerState<_HojaAnadirManual> createState() => _HojaAnadirManualState();
}

class _HojaAnadirManualState extends ConsumerState<_HojaAnadirManual> {
  String _busqueda = '';
  final Set<int> _equiposSeleccionados = {};
  final Set<int> _pilotosSeleccionados = {};
  String? _copaNueva;
  bool _guardando = false;

  int get _totalSeleccionados =>
      _equiposSeleccionados.length + _pilotosSeleccionados.length;

  Future<void> _inscribirSeleccionados(String? copaNuevasInscripciones) async {
    if (_totalSeleccionados == 0) return;
    setState(() => _guardando = true);
    final repoIns = ref.read(repoInscripcionesPruebaProvider);
    for (final id in _equiposSeleccionados) {
      await repoIns.inscribir(pruebaId: widget.pruebaId, equipoId: id);
    }
    if (_pilotosSeleccionados.isNotEmpty && copaNuevasInscripciones != null) {
      final repoEq = ref.read(repoEquiposProvider);
      final db = ref.read(dbProvider);
      final activo = ref.read(campeonatoActivoProvider)!;
      for (final pilotoId in _pilotosSeleccionados) {
        final piloto = await (db.select(db.pilotos)
              ..where((t) => t.id.equals(pilotoId)))
            .getSingle();
        final equipoId = await repoEq.crearN(
          campeonatoId: activo.id,
          nombre: piloto.nombre,
          copa: copaNuevasInscripciones,
          pilotoIds: [pilotoId],
        );
        await repoIns.inscribir(pruebaId: widget.pruebaId, equipoId: equipoId);
      }
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final equiposAsync = ref.watch(equiposCampeonatoProvider);
    final pilotosAsync = ref.watch(pilotosDelCampeonatoProvider);
    final inscritosAsync = ref.watch(inscritosPruebaProvider(widget.pruebaId));
    final activo = ref.watch(campeonatoActivoProvider);
    final esIndividual = maxPilotosEquipo(activo?.formato ?? 'PAREJAS') == 1;
    final copas = ref.watch(copasProvider);
    final copaEfectiva =
        _copaNueva ?? (copas.isNotEmpty ? copas.first : null);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      builder: (_, scroll) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    _totalSeleccionados == 0
                        ? (esIndividual ? 'Inscribir pilotos' : 'Inscribir equipos')
                        : '$_totalSeleccionados seleccionado${_totalSeleccionados == 1 ? "" : "s"}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                if (_totalSeleccionados > 0)
                  TextButton.icon(
                    onPressed: () => setState(() {
                      _equiposSeleccionados.clear();
                      _pilotosSeleccionados.clear();
                    }),
                    icon: const Icon(Icons.clear),
                    label: const Text('Limpiar'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: esIndividual ? 'Buscar piloto…' : 'Buscar equipo o piloto…',
              ),
              onChanged: (v) =>
                  setState(() => _busqueda = v.trim().toLowerCase()),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: equiposAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (equipos) {
                  final ya = inscritosAsync.maybeWhen(
                    data: (l) => l.map((i) => i.equipo.id).toSet(),
                    orElse: () => <int>{},
                  );
                  final candEquipos = equipos
                      .where((e) => !ya.contains(e.equipo.id))
                      .where((e) {
                    if (_busqueda.isEmpty) return true;
                    return '${e.equipo.nombre} ${e.pilotosTexto}'
                        .toLowerCase()
                        .contains(_busqueda);
                  }).toList();

                  // En individual, además de los equipos (inscripciones) ya
                  // creados, se puede elegir directamente un piloto del
                  // campeonato que aún no tenga inscripción: se crea al vuelo
                  // al confirmar, con la copa elegida arriba.
                  final pilotosTodos = esIndividual && copas.isNotEmpty
                      ? (pilotosAsync.asData?.value ?? const <Piloto>[])
                      : const <Piloto>[];
                  final idsConEquipo =
                      equipos.map((e) => e.equipo.piloto1Id).toSet();
                  final candPilotos = pilotosTodos
                      .where((p) => !idsConEquipo.contains(p.id))
                      .where((p) =>
                          _busqueda.isEmpty ||
                          p.nombre.toLowerCase().contains(_busqueda))
                      .toList();

                  if (candEquipos.isEmpty && candPilotos.isEmpty) {
                    final sinNada = equipos.isEmpty && pilotosTodos.isEmpty;
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            sinNada
                                ? (esIndividual
                                    ? 'No hay pilotos en este campeonato.'
                                    : 'No hay equipos en este campeonato.')
                                : 'Todos están ya inscritos.',
                            style: TextStyle(color: cs.outline),
                          ),
                          if (sinNada) ...[
                            const SizedBox(height: 12),
                            OutlinedButton.icon(
                              onPressed: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const EditorEquipo(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add),
                              label: Text(esIndividual
                                  ? 'Nueva inscripción'
                                  : 'Nuevo equipo'),
                            ),
                          ],
                        ],
                      ),
                    );
                  }
                  final visiblesEquipos =
                      candEquipos.map((e) => e.equipo.id).toSet();
                  final visiblesPilotos =
                      candPilotos.map((p) => p.id).toSet();
                  final totalVisibles =
                      visiblesEquipos.length + visiblesPilotos.length;
                  final marcados = visiblesEquipos
                          .where(_equiposSeleccionados.contains)
                          .length +
                      visiblesPilotos
                          .where(_pilotosSeleccionados.contains)
                          .length;
                  final todosMarcados =
                      totalVisibles > 0 && marcados == totalVisibles;
                  return Column(
                    children: [
                      if (candPilotos.isNotEmpty && copas.length > 1) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Row(
                            children: [
                              Text('Copa para pilotos nuevos:',
                                  style: TextStyle(color: cs.outline)),
                              const SizedBox(width: 8),
                              DropdownButton<String>(
                                value: copaEfectiva,
                                isDense: true,
                                items: copas
                                    .map((c) => DropdownMenuItem(
                                        value: c, child: Text(c)))
                                    .toList(),
                                onChanged: (v) =>
                                    setState(() => _copaNueva = v),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            Checkbox(
                              value: todosMarcados,
                              tristate: false,
                              onChanged: (v) {
                                setState(() {
                                  if (v == true) {
                                    _equiposSeleccionados
                                        .addAll(visiblesEquipos);
                                    _pilotosSeleccionados
                                        .addAll(visiblesPilotos);
                                  } else {
                                    _equiposSeleccionados
                                        .removeAll(visiblesEquipos);
                                    _pilotosSeleccionados
                                        .removeAll(visiblesPilotos);
                                  }
                                });
                              },
                            ),
                            Text(
                              todosMarcados
                                  ? 'Desmarcar todos'
                                  : 'Marcar todos ($totalVisibles)',
                              style: TextStyle(color: cs.outline),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      Expanded(
                        child: ListView(
                          controller: scroll,
                          children: [
                            for (final eq in candEquipos)
                              CheckboxListTile(
                                value: _equiposSeleccionados
                                    .contains(eq.equipo.id),
                                onChanged: (v) {
                                  setState(() {
                                    if (v == true) {
                                      _equiposSeleccionados.add(eq.equipo.id);
                                    } else {
                                      _equiposSeleccionados
                                          .remove(eq.equipo.id);
                                    }
                                  });
                                },
                                title: Text(eq.equipo.nombre),
                                subtitle: Text(esIndividual
                                    ? 'Copa ${eq.equipo.copa}'
                                    : '${eq.pilotosTexto}\nCopa ${eq.equipo.copa}'),
                                isThreeLine: !esIndividual,
                              ),
                            for (final p in candPilotos)
                              CheckboxListTile(
                                value: _pilotosSeleccionados.contains(p.id),
                                onChanged: (v) {
                                  setState(() {
                                    if (v == true) {
                                      _pilotosSeleccionados.add(p.id);
                                    } else {
                                      _pilotosSeleccionados.remove(p.id);
                                    }
                                  });
                                },
                                title: Text(p.nombre),
                                subtitle: copaEfectiva == null
                                    ? null
                                    : Text('Nueva inscripción · Copa $copaEfectiva'),
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: (_totalSeleccionados == 0 || _guardando)
                    ? null
                    : () => _inscribirSeleccionados(copaEfectiva),
                icon: _guardando
                    ? const SizedBox(
                        width: 18, height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.check),
                label: Text(_totalSeleccionados == 0
                    ? (esIndividual
                        ? 'Marca los pilotos que quieras inscribir'
                        : 'Marca los equipos que quieras inscribir')
                    : (esIndividual
                        ? 'Inscribir $_totalSeleccionados piloto${_totalSeleccionados == 1 ? "" : "s"}'
                        : 'Inscribir $_totalSeleccionados equipo${_totalSeleccionados == 1 ? "" : "s"}')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---- Importador desde CSV/Excel ----

class _PantallaImportarInscripciones extends ConsumerStatefulWidget {
  const _PantallaImportarInscripciones({required this.pruebaId});
  final int pruebaId;

  @override
  ConsumerState<_PantallaImportarInscripciones> createState() =>
      _PantallaImportarInscripcionesState();
}

class _PantallaImportarInscripcionesState
    extends ConsumerState<_PantallaImportarInscripciones> {
  String? _archivo;
  List<String> _columnas = [];
  List<Map<String, String>> _filasArchivo = [];
  MapeoInscripcion _mapeo = MapeoInscripcion();
  List<FilaInscripcion> _previo = [];
  bool _trabajando = false;
  String? _error;

  Future<void> _elegirArchivo() async {
    setState(() {
      _trabajando = true;
      _error = null;
    });
    try {
      final tipo = XTypeGroup(
          label: 'Archivos', extensions: ['csv', 'xlsx', 'xls']);
      final xfile = await openFile(acceptedTypeGroups: [tipo]);
      if (xfile == null) {
        setState(() => _trabajando = false);
        return;
      }
      _archivo = xfile.path;
      final res = await ImportadorInscripciones.leerArchivo(xfile.path);
      _columnas = res.columnas;
      _filasArchivo = res.filas;
      _mapeo = ImportadorInscripciones.detectarMapeo(_columnas);
      await _recalcular();
    } catch (e) {
      _error = 'No se pudo leer: $e';
    } finally {
      if (mounted) setState(() => _trabajando = false);
    }
  }

  Future<void> _recalcular() async {
    final filas = ImportadorInscripciones.transformar(_filasArchivo, _mapeo);
    final activo = ref.read(campeonatoActivoProvider);
    if (activo == null) return;
    final db = ref.read(dbProvider);
    final equipos = await (db.select(db.equipos)
          ..where((t) => t.campeonatoId.equals(activo.id)))
        .get();
    final porNombre = {for (final e in equipos) _norm(e.nombre): e};

    final yaInscritos = await (db.select(db.inscripcionesPrueba)
          ..where((t) => t.pruebaId.equals(widget.pruebaId)))
        .get();
    final idsYa = yaInscritos.map((i) => i.equipoId).toSet();

    for (final f in filas) {
      final eq = porNombre[_norm(f.nombreEquipo)];
      if (eq == null) {
        f.estado = 'equipo_no_existe';
        f.importar = false;
      } else if (idsYa.contains(eq.id)) {
        f.estado = 'ya_inscrito';
        f.importar = false;
        f.equipoIdCoincidente = eq.id;
      } else {
        f.estado = 'ok';
        f.equipoIdCoincidente = eq.id;
      }
    }
    if (mounted) setState(() => _previo = filas);
  }

  static String _norm(String s) =>
      s.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();

  Future<void> _importar() async {
    setState(() => _trabajando = true);
    int ok = 0, saltados = 0;
    try {
      final repo = ref.read(repoInscripcionesPruebaProvider);
      for (final f in _previo) {
        if (!f.importar || f.equipoIdCoincidente == null) {
          saltados++;
          continue;
        }
        await repo.inscribir(
          pruebaId: widget.pruebaId,
          equipoId: f.equipoIdCoincidente!,
          preferenciaDia: f.preferenciaDia,
          notas: f.notas,
        );
        ok++;
      }
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Importación completada'),
          content: Text(
              '✓ Inscritos: $ok\n✗ Saltados: $saltados'),
          actions: [
            FilledButton(
                onPressed: () => Navigator.pop(context), child: const Text('OK'))
          ],
        ),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _trabajando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final n = _previo.where((f) => f.importar).length;
    final inexistentes = _previo.where((f) => f.estado == 'equipo_no_existe').length;
    final activo = ref.watch(campeonatoActivoProvider);
    final esIndividual = maxPilotosEquipo(activo?.formato ?? 'PAREJAS') == 1;

    return Scaffold(
      appBar: AppBar(title: const Text('Importar inscripciones')),
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
                  Text('1. Elige el archivo',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    esIndividual
                        ? 'CSV/Excel del Google Form de inscripción a la prueba. '
                            'Las inscripciones se vinculan a pilotos existentes por nombre.'
                        : 'CSV/Excel del Google Form de inscripción a la prueba. '
                            'Las inscripciones se vinculan a equipos existentes por nombre.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      FilledButton.icon(
                        onPressed: _trabajando ? null : _elegirArchivo,
                        icon: const Icon(Icons.folder_open),
                        label: const Text('Elegir archivo'),
                      ),
                      const SizedBox(width: 12),
                      if (_archivo != null)
                        Expanded(
                          child: Text(
                            _archivo!.split('/').last,
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
            const SizedBox(height: 12),
            Text(_error!, style: TextStyle(color: cs.error)),
          ],
          if (_columnas.isNotEmpty) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('2. Asigna columnas',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    _sel(esIndividual ? 'Nombre del piloto *' : 'Nombre del equipo *',
                        _mapeo.colEquipo,
                        (v) { _mapeo.colEquipo = v; _recalcular(); }),
                    _sel('Día preferido (opcional)', _mapeo.colDia,
                        (v) { _mapeo.colDia = v; _recalcular(); }),
                    _sel('Notas (opcional)', _mapeo.colNotas,
                        (v) { _mapeo.colNotas = v; _recalcular(); }),
                  ],
                ),
              ),
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
                        Text('3. Vista previa',
                            style: Theme.of(context).textTheme.titleMedium),
                        const Spacer(),
                        Text('$n de ${_previo.length} se importarán'),
                      ],
                    ),
                    if (inexistentes > 0) ...[
                      const SizedBox(height: 8),
                      Text(
                        esIndividual
                            ? '⚠️ $inexistentes pilotos no existen en el campeonato. '
                                'Créalos primero o revisa el nombre.'
                            : '⚠️ $inexistentes equipos no existen en el campeonato. '
                                'Créalos primero o revisa el nombre.',
                        style: TextStyle(color: cs.error),
                      ),
                    ],
                    const SizedBox(height: 8),
                    if (!_mapeo.esValido)
                      Text(
                          esIndividual
                              ? 'Asigna la columna del nombre del piloto.'
                              : 'Asigna la columna del nombre del equipo.',
                          style: TextStyle(color: cs.error))
                    else
                      ..._previo.map((f) => _FilaPrevia(fila: f)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: (_trabajando || n == 0) ? null : _importar,
              icon: _trabajando
                  ? const SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cloud_download_outlined),
              label: Text(esIndividual ? 'Inscribir $n pilotos' : 'Inscribir $n equipos'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _sel(String label, String? actual, ValueChanged<String?> onChange) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: DropdownButtonFormField<String?>(
        initialValue: actual,
        isExpanded: true,
        decoration: InputDecoration(labelText: label, isDense: true),
        items: [
          const DropdownMenuItem(value: null, child: Text('— ninguna —')),
          ..._columnas.map((c) => DropdownMenuItem(value: c, child: Text(c))),
        ],
        onChanged: onChange,
      ),
    );
  }
}

class _FilaPrevia extends StatelessWidget {
  const _FilaPrevia({required this.fila});
  final FilaInscripcion fila;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    Color color;
    String etiqueta;
    switch (fila.estado) {
      case 'equipo_no_existe':
        color = cs.error;
        etiqueta = 'No existe';
      case 'ya_inscrito':
        color = cs.outline;
        etiqueta = 'Ya inscrito';
      default:
        color = cs.primary;
        etiqueta = 'Inscribir';
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fila.nombreEquipo,
                    style: TextStyle(
                      decoration:
                          fila.importar ? null : TextDecoration.lineThrough,
                      color: fila.importar ? null : cs.outline,
                      fontWeight: FontWeight.w600,
                    )),
                if (fila.preferenciaDia != null)
                  Text('Día: ${fila.preferenciaDia}',
                      style: TextStyle(color: cs.outline, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(etiqueta,
                style: TextStyle(
                  color: color, fontSize: 12, fontWeight: FontWeight.w600,
                )),
          ),
        ],
      ),
    );
  }
}
