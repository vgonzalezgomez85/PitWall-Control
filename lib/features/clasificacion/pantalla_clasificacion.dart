import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import '../../domain/calculo_clasificacion.dart';
import 'repositorio_clasificacion.dart';

class PantallaClasificacion extends ConsumerWidget {
  const PantallaClasificacion({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final datosAsync = ref.watch(clasificacionProvider);
    final activo = ref.watch(campeonatoActivoProvider);

    return datosAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (datos) {
        if (datos.filas.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Clasificación')),
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
                      'Crea pilotos y registra al menos un resultado de manga '
                      'para que aparezca aquí.',
                      textAlign: TextAlign.center,
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
    final filas = copa == null
        ? List<FilaClasificacion>.from(datos.filas)
        : datos.filas.where((f) => f.copa == copa).toList();

    // Reasignar posiciones para esta vista
    for (var i = 0; i < filas.length; i++) {
      filas[i].posicion = i + 1;
    }

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
          ),
        ),
      ],
    );
  }
}

class _Filtros extends StatelessWidget {
  const _Filtros({
    required this.copas,
    required this.copaActiva,
    required this.onCambio,
    required this.totalPilotos,
  });

  final List<String> copas;
  final String copaActiva;
  final ValueChanged<String> onCambio;
  final int totalPilotos;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text('Copa:', style: Theme.of(context).textTheme.bodyMedium),
          ChoiceChip(
            label: const Text('Todas'),
            selected: copaActiva == 'TODAS',
            onSelected: (_) => onCambio('TODAS'),
          ),
          ...copas.map((c) => ChoiceChip(
                label: Text(c),
                selected: copaActiva == c,
                onSelected: (_) => onCambio(c),
              )),
          const Spacer(),
          Text('$totalPilotos pilotos',
              style: TextStyle(color: cs.outline)),
        ],
      ),
    );
  }
}

class _Tabla extends StatelessWidget {
  const _Tabla({required this.pruebas, required this.filas});
  final List<Prueba> pruebas;
  final List<FilaClasificacion> filas;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
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
            const DataColumn(label: Text('Bruto'), numeric: true),
            const DataColumn(label: Text('Desc.'), numeric: true),
            const DataColumn(label: Text('TOTAL'), numeric: true),
          ],
          rows: filas.map((f) => _filaDataRow(context, f, cs)).toList(),
        ),
      ),
    );
  }

  DataRow _filaDataRow(
      BuildContext context, FilaClasificacion f, ColorScheme cs) {
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
            puntos: f.puntosPorPrueba[p.id] ?? 0,
            descarte: f.pruebasDescartadas.contains(p.id),
          )),
        DataCell(Text('${f.totalBruto}',
            style: TextStyle(color: cs.outline))),
        DataCell(Text(
          f.totalDescarte > 0 ? '-${f.totalDescarte}' : '0',
          style: TextStyle(color: cs.outline),
        )),
        DataCell(Text('${f.totalNeto}',
            style: TextStyle(
                fontWeight: FontWeight.w700, color: cs.primary, fontSize: 16))),
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
  const _CeldaPrueba({required this.puntos, required this.descarte});
  final int puntos;
  final bool descarte;

  @override
  Widget build(BuildContext context) {
    if (puntos == 0 && !descarte) {
      return Text('—',
          style: TextStyle(color: Theme.of(context).colorScheme.outline));
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: descarte
          ? BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(6),
            )
          : null,
      child: Text(
        '$puntos',
        style: TextStyle(
          decoration: descarte ? TextDecoration.lineThrough : null,
          color: descarte
              ? Theme.of(context).colorScheme.onErrorContainer
              : null,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
