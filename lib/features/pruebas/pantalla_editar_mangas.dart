import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';

/// Datos enriquecidos de una manga con su lista de equipos inscritos.
class _MangaConEquipos {
  final Manga manga;
  final List<_EquipoInscrito> equipos;

  _MangaConEquipos({required this.manga, required this.equipos});
}

class _EquipoInscrito {
  final int inscripcionId;
  final int equipoId;
  final String nombre;
  final String pilotos;
  final String copa;

  _EquipoInscrito({
    required this.inscripcionId,
    required this.equipoId,
    required this.nombre,
    required this.pilotos,
    required this.copa,
  });
}

final _mangasConEquiposProvider = StreamProvider.autoDispose
    .family<List<_MangaConEquipos>, int>((ref, pruebaId) {
  final db = ref.watch(dbProvider);
  return (db.select(db.mangas)
        ..where((t) => t.pruebaId.equals(pruebaId))
        ..orderBy([(t) => d.OrderingTerm.asc(t.id)]))
      .watch()
      .asyncMap((mangas) async {
    final out = <_MangaConEquipos>[];
    for (final m in mangas) {
      final inscritos = await (db.select(db.inscripciones)
            ..where((t) => t.mangaId.equals(m.id)))
          .get();
      final lista = <_EquipoInscrito>[];
      for (final ins in inscritos) {
        final eq = await (db.select(db.equipos)
              ..where((t) => t.id.equals(ins.equipoId)))
            .getSingle();
        final p1 = await (db.select(db.pilotos)
              ..where((t) => t.id.equals(eq.piloto1Id)))
            .getSingle();
        String pilotos = p1.nombre;
        if (eq.piloto2Id != null) {
          final pid2 = eq.piloto2Id!;
          final p2 = await (db.select(db.pilotos)
                ..where((t) => t.id.equals(pid2)))
              .getSingleOrNull();
          if (p2 != null) pilotos = '${p1.nombre} + ${p2.nombre}';
        }
        lista.add(_EquipoInscrito(
          inscripcionId: ins.id,
          equipoId: eq.id,
          nombre: eq.nombre,
          pilotos: pilotos,
          copa: eq.copa,
        ));
      }
      out.add(_MangaConEquipos(manga: m, equipos: lista));
    }
    return out;
  });
});

class PantallaEditarMangas extends ConsumerWidget {
  const PantallaEditarMangas({super.key, required this.pruebaId});
  final int pruebaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final dataAsync = ref.watch(_mangasConEquiposProvider(pruebaId));

    return Scaffold(
      appBar: AppBar(title: const Text('Editar mangas')),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (mangas) {
          if (mangas.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.flag_outlined, size: 96, color: cs.outline),
                    const SizedBox(height: 16),
                    Text('Esta prueba no tiene mangas todavía',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    const Text('Generálas desde Inscritos → Generar mangas.',
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
            children: [
              Card(
                color: cs.surfaceContainer,
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                      'Tocá un equipo para moverlo a otra manga.'),
                ),
              ),
              const SizedBox(height: 12),
              ...mangas
                  .map((m) => _MangaCard(manga: m, todasLasMangas: mangas)),
            ],
          );
        },
      ),
    );
  }
}

class _MangaCard extends ConsumerWidget {
  const _MangaCard({required this.manga, required this.todasLasMangas});

  final _MangaConEquipos manga;
  final List<_MangaConEquipos> todasLasMangas;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.flag_outlined, color: cs.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(manga.manga.nombre,
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  Text('${manga.equipos.length} eq.',
                      style: TextStyle(color: cs.outline)),
                ],
              ),
              const Divider(),
              if (manga.equipos.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text('Sin equipos',
                      style: TextStyle(color: cs.outline)),
                )
              else
                ...manga.equipos.map((eq) => _FilaEquipo(
                      equipo: eq,
                      mangaActualId: manga.manga.id,
                      todasLasMangas: todasLasMangas,
                    )),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilaEquipo extends ConsumerWidget {
  const _FilaEquipo({
    required this.equipo,
    required this.mangaActualId,
    required this.todasLasMangas,
  });

  final _EquipoInscrito equipo;
  final int mangaActualId;
  final List<_MangaConEquipos> todasLasMangas;

  Future<void> _mover(BuildContext context, WidgetRef ref) async {
    final destino = await showDialog<int>(
      context: context,
      builder: (_) => SimpleDialog(
        title: Text('Mover "${equipo.nombre}" a…'),
        children: todasLasMangas
            .where((m) => m.manga.id != mangaActualId)
            .map((m) => SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, m.manga.id),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                        '${m.manga.nombre}  (${m.equipos.length} eq.)'),
                  ),
                ))
            .toList(),
      ),
    );
    if (destino == null) return;
    final db = ref.read(dbProvider);
    await (db.update(db.inscripciones)
          ..where((t) => t.id.equals(equipo.inscripcionId)))
        .write(InscripcionesCompanion(mangaId: d.Value(destino)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: todasLasMangas.length <= 1
          ? null
          : () => _mover(context, ref),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            Icon(Icons.swap_horiz, color: cs.outline, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(equipo.nombre,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(equipo.pilotos,
                      style: TextStyle(color: cs.outline, fontSize: 12)),
                ],
              ),
            ),
            Text(equipo.copa,
                style: TextStyle(color: cs.outline, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
