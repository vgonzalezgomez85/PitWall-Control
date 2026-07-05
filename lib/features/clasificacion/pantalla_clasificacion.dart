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
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import '../../domain/calculo_clasificacion.dart';
import '../../services/exportar_pdf.dart';
import '../../services/generador_pdf_clasificacion.dart';
import 'pantalla_editor_clasificacion_manual.dart';
import 'pantalla_importar_clasificacion.dart';
import 'repositorio_clasificacion.dart';

class PantallaClasificacion extends ConsumerWidget {
  const PantallaClasificacion({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final datosAsync = ref.watch(clasificacionProvider);
    final activo = ref.watch(campeonatoActivoProvider);

    return datosAsync.when(
      // Al recalcular (tras editar), mantener la vista actual en vez de
      // parpadear a "cargando" y perder la pestaña de copa seleccionada.
      skipLoadingOnReload: true,
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (datos) {
        if (datos.filas.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Clasificación'),
              actions: [
                IconButton(
                  tooltip: 'Clasificación a mano',
                  icon: const Icon(Icons.edit_note_outlined),
                  onPressed: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) =>
                          const PantallaEditorClasificacionManual(),
                    ));
                    ref.invalidate(clasificacionProvider);
                  },
                ),
                IconButton(
                  tooltip: 'Importar clasificación',
                  icon: const Icon(Icons.upload_outlined),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const PantallaImportarClasificacion(),
                  )),
                ),
              ],
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.leaderboard_outlined,
                        size: 96, color: cs.outline),
                    const SizedBox(height: 16),
                    Text('Aún no hay clasificación',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    const Text(
                      'Registra resultados de manga, impórtala desde un archivo '
                      'o rellénala a mano.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      icon: const Icon(Icons.edit_note_outlined),
                      label: const Text('Rellenar a mano'),
                      onPressed: () =>
                          Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) =>
                            const PantallaEditorClasificacionManual(),
                      )),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Copas configuradas en el campeonato (más fiable que extraerlas de
        // las filas, así aparecen aunque aún no haya pilotos en ellas).
        final copasDelCampeonato = <String>[];
        if (activo != null) {
          try {
            final raw = json.decode(activo.copasJson);
            if (raw is List) {
              copasDelCampeonato
                  .addAll(raw.map((e) => e.toString()));
            }
          } catch (_) {}
        }
        // Asegurar que se incluyan las copas que aparecen en datos aunque no
        // estén configuradas (por si hay equipos con copas distintas).
        for (final f in datos.filas) {
          if (!copasDelCampeonato.contains(f.copa)) {
            copasDelCampeonato.add(f.copa);
          }
        }

        return DefaultTabController(
          length: 1 + copasDelCampeonato.length,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Clasificación'),
              actions: [
                Builder(builder: (context) {
                  return IconButton(
                    tooltip: 'Clasificación a mano',
                    icon: const Icon(Icons.edit_note_outlined),
                    onPressed: () async {
                      // Copa de la pestaña activa: 0 = General (null).
                      final idx = DefaultTabController.of(context).index;
                      final copa = idx == 0
                          ? null
                          : copasDelCampeonato[idx - 1];
                      await Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => PantallaEditorClasificacionManual(
                            copa: copa),
                      ));
                      // Recalcular al volver, por si el stream no refrescó.
                      ref.invalidate(clasificacionProvider);
                    },
                  );
                }),
                PopupMenuButton<String>(
                  tooltip: 'Exportar PDF',
                  icon: const Icon(Icons.picture_as_pdf_outlined),
                  onSelected: (sel) async {
                    // '*' = clasificación general (un PopupMenuItem con
                    // value null no dispara onSelected, así que usamos
                    // un centinela).
                    final copa = sel == '*' ? null : sel;
                    final sufijo = copa == null
                        ? 'general'
                        : slugArchivo(copa).toLowerCase();
                    final idi = await elegirIdiomaExport(context, ref);
                    if (idi == null || !context.mounted) return;
                    guardarPdf(
                      context,
                      sugerido:
                          'clasificacion-${slugArchivo(activo?.nombre ?? '')}-$sufijo.pdf',
                      generar: () => ref
                          .read(generadorPdfClasificacionProvider)
                          .generar(
                            datos: datos,
                            campeonato: activo!,
                            copa: copa,
                            idioma: idi,
                          ),
                    );
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem<String>(
                      value: '*',
                      child: ListTile(
                        leading: Icon(Icons.leaderboard_outlined),
                        title: Text('General'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    if (copasDelCampeonato.isNotEmpty)
                      const PopupMenuDivider(),
                    for (final c in copasDelCampeonato)
                      PopupMenuItem<String>(
                        value: c,
                        child: ListTile(
                          leading: const Icon(Icons.emoji_events_outlined),
                          title: Text('Copa $c'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                  ],
                ),
                IconButton(
                  tooltip: 'Importar clasificación',
                  icon: const Icon(Icons.upload_outlined),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const PantallaImportarClasificacion(),
                  )),
                ),
              ],
              bottom: TabBar(
                isScrollable: true,
                tabs: [
                  const Tab(
                    icon: Icon(Icons.leaderboard_outlined),
                    text: 'General',
                  ),
                  ...copasDelCampeonato.map((c) => Tab(text: c)),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _VistaCopa(
                  datos: datos,
                  copa: null,
                  titulo: 'General',
                ),
                ...copasDelCampeonato.map(
                  (c) => _VistaCopa(
                    datos: datos,
                    copa: c,
                    titulo: c,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Una vista de tabla para una copa específica (o todas si copa==null).
class _VistaCopa extends StatelessWidget {
  const _VistaCopa({
    required this.datos,
    required this.copa,
    required this.titulo,
  });

  final DatosClasificacion datos;
  final String? copa;
  final String titulo;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // General = puntos globales. Copa = clasificación específica con los
    // puntos recalculados solo entre los pilotos de esa copa.
    final filas = copa == null
        ? List<FilaClasificacion>.from(datos.filas)
        : List<FilaClasificacion>.from(
            datos.porCopa[copa] ?? const <FilaClasificacion>[]);

    // Reasignar posiciones para esta vista (los empatados comparten posición)
    CalculoClasificacion.asignarPosiciones(filas);

    if (filas.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'No hay pilotos en "$titulo".',
            style: TextStyle(color: cs.outline),
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Row(
            children: [
              Text(
                copa == null
                    ? 'Todos los pilotos del campeonato'
                    : 'Pilotos de copa $copa',
                style: TextStyle(
                  color: cs.outline,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('${filas.length} pilotos',
                    style: TextStyle(
                      color: cs.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                    )),
              ),
            ],
          ),
        ),
        Expanded(
          child: _Tabla(
            pruebas: datos.pruebas,
            filas: filas,
            ordenadoPorNeto: datos.ordenadoPorNeto,
          ),
        ),
      ],
    );
  }
}

class _Tabla extends StatefulWidget {
  const _Tabla({
    required this.pruebas,
    required this.filas,
    this.ordenadoPorNeto = false,
  });
  final List<Prueba> pruebas;
  final List<FilaClasificacion> filas;
  /// Qué columna manda en el orden: TOTAL (neto) al cierre, Bruto en temporada.
  final bool ordenadoPorNeto;

  @override
  State<_Tabla> createState() => _TablaState();
}

class _TablaState extends State<_Tabla> {
  // Controladores propios para poder mostrar las barras de scroll
  // (en escritorio la tabla puede no caber ni a lo ancho ni a lo alto).
  final _ctrlH = ScrollController();
  final _ctrlV = ScrollController();

  List<Prueba> get pruebas => widget.pruebas;
  List<FilaClasificacion> get filas => widget.filas;

  @override
  void dispose() {
    _ctrlH.dispose();
    _ctrlV.dispose();
    super.dispose();
  }

  /// Top-3 de puntuaciones (>0) de cada prueba dentro de esta vista, para
  /// colorear oro/plata/bronce. Empates comparten medalla.
  Map<int, List<int>> get _medallasPorPrueba {
    final out = <int, List<int>>{};
    for (final p in pruebas) {
      final valores = filas
          .map((f) => f.puntosPorPrueba[p.id] ?? 0)
          .where((v) => v > 0)
          .toSet()
          .toList()
        ..sort((a, b) => b.compareTo(a));
      out[p.id] = valores.take(3).toList();
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final medallas = _medallasPorPrueba;
    return Scrollbar(
      controller: _ctrlV,
      thumbVisibility: true,
      child: Scrollbar(
        controller: _ctrlH,
        thumbVisibility: true,
        notificationPredicate: (n) => n.metrics.axis == Axis.horizontal,
        child: SingleChildScrollView(
          controller: _ctrlV,
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            controller: _ctrlH,
            scrollDirection: Axis.horizontal,
            child: DataTable(
          columnSpacing: 18,
          horizontalMargin: 16,
          dataRowMinHeight: 44,
          dataRowMaxHeight: 56,
          headingRowColor: WidgetStatePropertyAll(cs.surfaceContainer),
          columns: [
            const DataColumn(label: Text('#')),
            const DataColumn(label: Text('Piloto')),
            const DataColumn(label: Text('Equipo')),
            const DataColumn(label: Text('Copa')),
            const DataColumn(label: Text('Cat.')),
            for (final p in pruebas)
              DataColumn(
                label: SizedBox(
                  width: 60,
                  child: Text(
                    p.nombre,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                numeric: true,
              ),
            // La columna por la que se ordena va resaltada (Bruto durante la
            // temporada, TOTAL al cierre del campeonato).
            DataColumn(
              numeric: true,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!widget.ordenadoPorNeto)
                    Icon(Icons.arrow_downward, size: 14, color: cs.primary),
                  Text('Bruto',
                      style: !widget.ordenadoPorNeto
                          ? TextStyle(
                              color: cs.primary, fontWeight: FontWeight.w800)
                          : null),
                ],
              ),
            ),
            const DataColumn(label: Text('Desc.'), numeric: true),
            DataColumn(
              numeric: true,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.ordenadoPorNeto)
                    Icon(Icons.arrow_downward, size: 14, color: cs.primary),
                  Text('TOTAL',
                      style: widget.ordenadoPorNeto
                          ? TextStyle(
                              color: cs.primary, fontWeight: FontWeight.w800)
                          : null),
                ],
              ),
            ),
          ],
          rows: filas
              .map((f) => _filaDataRow(context, f, cs, medallas))
              .toList(),
            ),
          ),
        ),
      ),
    );
  }

  DataRow _filaDataRow(BuildContext context, FilaClasificacion f,
      ColorScheme cs, Map<int, List<int>> medallas) {
    return DataRow(
      cells: [
        DataCell(_Posicion(numero: f.posicion ?? 0)),
        DataCell(Text(f.pilotoNombre,
            style: const TextStyle(fontWeight: FontWeight.w600))),
        DataCell(Text(f.equipoNombre,
            style: TextStyle(color: cs.outline, fontSize: 13))),
        DataCell(Text(f.copa)),
        DataCell(Text(f.categoria,
            style: TextStyle(fontSize: 12, color: cs.outline))),
        for (final p in pruebas)
          DataCell(_CeldaPrueba(
            puntos: f.puntosPorPrueba[p.id],
            descarte: f.pruebasDescartadas.contains(p.id),
            medallas: medallas[p.id] ?? const [],
          )),
        DataCell(Text('${f.totalBruto}',
            style: widget.ordenadoPorNeto
                ? TextStyle(color: cs.outline)
                : TextStyle(
                    fontWeight: FontWeight.w700,
                    color: cs.primary,
                    fontSize: 16))),
        DataCell(Text(
          f.totalDescarte > 0 ? '-${f.totalDescarte}' : '0',
          style: TextStyle(color: cs.outline),
        )),
        DataCell(Text('${f.totalNeto}',
            style: widget.ordenadoPorNeto
                ? TextStyle(
                    fontWeight: FontWeight.w700,
                    color: cs.primary,
                    fontSize: 16)
                : TextStyle(color: cs.outline))),
      ],
    );
  }
}

class _Posicion extends StatelessWidget {
  const _Posicion({required this.numero});
  final int numero;

  @override
  Widget build(BuildContext context) {
    Color? bg;
    Color fg = Colors.white;
    if (numero == 1) {
      bg = const Color(0xFFE6A700); // oro
    } else if (numero == 2) {
      bg = const Color(0xFF9E9E9E); // plata
    } else if (numero == 3) {
      bg = const Color(0xFFB36A38); // bronce
    } else {
      bg = Theme.of(context).colorScheme.surfaceContainerHighest;
      fg = Theme.of(context).colorScheme.onSurface;
    }
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Text('$numero',
          style: TextStyle(color: fg, fontWeight: FontWeight.w700)),
    );
  }
}

class _CeldaPrueba extends StatelessWidget {
  const _CeldaPrueba({
    required this.puntos,
    required this.descarte,
    this.medallas = const [],
  });
  /// null = el piloto no tiene resultado en esa prueba (prueba no disputada);
  /// 0 = prueba disputada en la que no puntuó.
  final int? puntos;
  final bool descarte;
  /// Top-3 de puntuaciones de esta prueba (para oro/plata/bronce).
  final List<int> medallas;

  static const _oro = Color(0xFFF3D060);
  static const _plata = Color(0xFFD9D9D9);
  static const _bronce = Color(0xFFE3B584);
  static const _oroFg = Color(0xFF7A5C00);
  static const _plataFg = Color(0xFF555555);
  static const _bronceFg = Color(0xFF6E441A);

  @override
  Widget build(BuildContext context) {
    // Sin resultado en una prueba no disputada → guion.
    if (puntos == null && !descarte) {
      return Text('—',
          style: TextStyle(color: Theme.of(context).colorScheme.outline));
    }
    final v = puntos ?? 0;
    // Medalla de la prueba (los descartes mantienen su estilo tachado).
    Color? bg;
    Color? fg;
    if (!descarte && v > 0 && medallas.isNotEmpty) {
      if (v == medallas[0]) {
        bg = _oro;
        fg = _oroFg;
      } else if (medallas.length > 1 && v == medallas[1]) {
        bg = _plata;
        fg = _plataFg;
      } else if (medallas.length > 2 && v == medallas[2]) {
        bg = _bronce;
        fg = _bronceFg;
      }
    }
    if (descarte) {
      bg = Theme.of(context).colorScheme.errorContainer;
      fg = Theme.of(context).colorScheme.onErrorContainer;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: bg == null
          ? null
          : BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(6),
            ),
      child: Text(
        '$v',
        style: TextStyle(
          decoration: descarte ? TextDecoration.lineThrough : null,
          color: fg,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
