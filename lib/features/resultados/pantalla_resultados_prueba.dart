import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import 'pantalla_importar_resultados_prueba.dart';
import 'repositorio_resultados.dart';

/// Resultado consolidado de un equipo en una prueba (atravesando sus mangas).
class ResultadoPrueba {
  final int equipoId;
  final String nombreEquipo;
  final String copa;
  final Piloto piloto1;
  final Piloto? piloto2;
  final int mangaId;
  final String nombreManga;
  final int? posicion;
  final int? puntos;
  final int? aRestar;

  ResultadoPrueba({
    required this.equipoId,
    required this.nombreEquipo,
    required this.copa,
    required this.piloto1,
    this.piloto2,
    required this.mangaId,
    required this.nombreManga,
    this.posicion,
    this.puntos,
    this.aRestar,
  });

  String get pilotosTexto => piloto2 == null
      ? piloto1.nombre
      : '${piloto1.nombre} + ${piloto2!.nombre}';
}

/// Stream con todos los equipos inscritos a las mangas de la prueba +
/// su resultado actual (si existe).
final resultadosPruebaProvider = StreamProvider.autoDispose
    .family<List<ResultadoPrueba>, int>((ref, pruebaId) {
  final db = ref.watch(dbProvider);

  // Streams que disparan recálculo si cambia algo relevante
  final mangasStream = (db.select(db.mangas)
        ..where((t) => t.pruebaId.equals(pruebaId)))
      .watch();

  return mangasStream.asyncMap((mangas) async {
    final out = <ResultadoPrueba>[];
    for (final m in mangas) {
      final inscritos = await (db.select(db.inscripciones)
            ..where((t) => t.mangaId.equals(m.id)))
          .get();
      for (final ins in inscritos) {
        final eq = await (db.select(db.equipos)
              ..where((t) => t.id.equals(ins.equipoId)))
            .getSingle();
        final p1 = await (db.select(db.pilotos)
              ..where((t) => t.id.equals(eq.piloto1Id)))
            .getSingle();
        Piloto? p2;
        if (eq.piloto2Id != null) {
          final pid2 = eq.piloto2Id!;
          p2 = await (db.select(db.pilotos)
                ..where((t) => t.id.equals(pid2)))
              .getSingleOrNull();
        }
        final r = await (db.select(db.resultados)
              ..where((t) =>
                  t.mangaId.equals(m.id) & t.pilotoId.equals(p1.id)))
            .getSingleOrNull();
        out.add(ResultadoPrueba(
          equipoId: eq.id,
          nombreEquipo: eq.nombre,
          copa: eq.copa,
          piloto1: p1, piloto2: p2,
          mangaId: m.id,
          nombreManga: m.nombre,
          posicion: r?.posicion,
          puntos: r?.puntos,
          aRestar: r?.aRestar,
        ));
      }
    }
    out.sort((a, b) {
      final pa = a.posicion ?? 999;
      final pb = b.posicion ?? 999;
      if (pa != pb) return pa.compareTo(pb);
      return a.nombreEquipo.compareTo(b.nombreEquipo);
    });
    return out;
  });
});

class PantallaResultadosPrueba extends ConsumerWidget {
  const PantallaResultadosPrueba({super.key, required this.pruebaId});

  final int pruebaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final dataAsync = ref.watch(resultadosPruebaProvider(pruebaId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados de la prueba'),
        actions: [
          IconButton(
            tooltip: 'Importar desde archivo de cronometraje',
            icon: const Icon(Icons.file_upload_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    PantallaImportarResultadosPrueba(pruebaId: pruebaId),
              ),
            ),
          ),
        ],
      ),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (filas) {
          if (filas.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.emoji_events_outlined,
                        size: 96, color: cs.outline),
                    const SizedBox(height: 16),
                    Text('No hay inscritos en esta prueba',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    const Text(
                      'Inscribe equipos y genera las mangas. Luego podrás '
                      'importar los resultados del cronometraje aquí.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final conResultado = filas.where((f) => f.posicion != null).length;

          return ListView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
            children: [
              Card(
                color: cs.surfaceContainer,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.emoji_events_outlined, color: cs.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '$conResultado de ${filas.length} equipos con resultado registrado.',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ...filas.map((f) => _FilaResultadoPrueba(
                    fila: f, pruebaId: pruebaId,
                  )),
            ],
          );
        },
      ),
    );
  }
}

class _FilaResultadoPrueba extends ConsumerStatefulWidget {
  const _FilaResultadoPrueba({required this.fila, required this.pruebaId});
  final ResultadoPrueba fila;
  final int pruebaId;

  @override
  ConsumerState<_FilaResultadoPrueba> createState() =>
      _FilaResultadoPruebaState();
}

class _FilaResultadoPruebaState extends ConsumerState<_FilaResultadoPrueba> {
  Future<void> _setPosicion(int? pos) async {
    final activo = ref.read(campeonatoActivoProvider)!;
    final repo = ref.read(repoResultadosProvider);
    if (pos == null) {
      await repo.borrarResultadoEquipo(
        mangaId: widget.fila.mangaId,
        equipoId: widget.fila.equipoId,
      );
    } else {
      await repo.asignarPosicionEquipo(
        mangaId: widget.fila.mangaId,
        equipoId: widget.fila.equipoId,
        campeonatoId: activo.id,
        posicion: pos,
        aRestar: widget.fila.aRestar ?? 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fila = widget.fila;
    final tiene = fila.posicion != null;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 38, height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: tiene
                    ? _colorPodio(fila.posicion!, cs)
                    : cs.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Text(
                tiene ? '${fila.posicion}' : '—',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: tiene ? Colors.white : cs.outline,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(fila.nombreEquipo,
                      style: Theme.of(context).textTheme.titleMedium),
                  Text(fila.pilotosTexto,
                      style: TextStyle(color: cs.outline, fontSize: 13)),
                  Text(
                    'Copa ${fila.copa}  ·  ${fila.nombreManga}',
                    style: TextStyle(color: cs.outline, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (tiene)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${fila.puntos ?? 0} pts',
                  style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w700),
                ),
              ),
            const SizedBox(width: 8),
            SizedBox(
              width: 92,
              child: DropdownButtonFormField<int?>(
                initialValue: fila.posicion,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Pos.',
                  isDense: true,
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('—')),
                  for (var i = 1; i <= 64; i++)
                    DropdownMenuItem(value: i, child: Text('$i')),
                ],
                onChanged: _setPosicion,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _colorPodio(int p, ColorScheme cs) {
    if (p == 1) return const Color(0xFFE6A700);
    if (p == 2) return const Color(0xFF9E9E9E);
    if (p == 3) return const Color(0xFFB36A38);
    return cs.primary;
  }
}

/// Helper público para obtener un mapa equipoId → mangaId de los inscritos
/// de TODAS las mangas de una prueba (lo usa el importador a nivel prueba).
Future<Map<int, int>> mangaPorEquipoEnPrueba(
    AppDatabase db, int pruebaId) async {
  final mangas = await (db.select(db.mangas)
        ..where((t) => t.pruebaId.equals(pruebaId)))
      .get();
  final ids = mangas.map((m) => m.id).toList();
  if (ids.isEmpty) return {};
  final inscritos = await (db.select(db.inscripciones)
        ..where((t) => t.mangaId.isIn(ids)))
      .get();
  return {for (final i in inscritos) i.equipoId: i.mangaId};
}

