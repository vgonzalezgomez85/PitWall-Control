import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import '../../domain/generador_mangas.dart';

/// Inscripción enriquecida con datos del equipo y sus pilotos.
class InscritoPrueba {
  final InscripcionesPruebaData inscripcion;
  final Equipo equipo;
  final Piloto piloto1;
  final Piloto? piloto2;

  InscritoPrueba({
    required this.inscripcion,
    required this.equipo,
    required this.piloto1,
    this.piloto2,
  });

  String get nombrePilotos => piloto2 == null
      ? piloto1.nombre
      : '${piloto1.nombre} + ${piloto2!.nombre}';
}

final inscritosPruebaProvider =
    StreamProvider.autoDispose.family<List<InscritoPrueba>, int>((ref, id) {
  final db = ref.watch(dbProvider);
  return (db.select(db.inscripcionesPrueba)
        ..where((t) => t.pruebaId.equals(id))
        ..orderBy([(t) => OrderingTerm.asc(t.fechaInscripcion)]))
      .watch()
      .asyncMap((lista) async {
    final out = <InscritoPrueba>[];
    for (final i in lista) {
      final eq = await (db.select(db.equipos)
            ..where((t) => t.id.equals(i.equipoId)))
          .getSingle();
      final p1 = await (db.select(db.pilotos)
            ..where((t) => t.id.equals(eq.piloto1Id)))
          .getSingle();
      Piloto? p2;
      if (eq.piloto2Id != null) {
        p2 = await (db.select(db.pilotos)
              ..where((t) => t.id.equals(eq.piloto2Id!)))
            .getSingleOrNull();
      }
      out.add(InscritoPrueba(
        inscripcion: i, equipo: eq, piloto1: p1, piloto2: p2,
      ));
    }
    return out;
  });
});

class RepositorioInscripcionesPrueba {
  RepositorioInscripcionesPrueba(this.db);
  final AppDatabase db;

  Future<int> inscribir({
    required int pruebaId,
    required int equipoId,
    String? preferenciaDia,
    String? notas,
  }) async {
    // Evitar duplicado
    final existente = await (db.select(db.inscripcionesPrueba)
          ..where((t) =>
              t.pruebaId.equals(pruebaId) & t.equipoId.equals(equipoId)))
        .getSingleOrNull();
    if (existente != null) return existente.id;

    return db.into(db.inscripcionesPrueba).insert(
          InscripcionesPruebaCompanion.insert(
            pruebaId: pruebaId,
            equipoId: equipoId,
            preferenciaDia: Value(preferenciaDia),
            notas: Value(notas),
          ),
        );
  }

  Future<void> quitar(int id) async {
    await (db.delete(db.inscripcionesPrueba)..where((t) => t.id.equals(id)))
        .go();
  }

  Future<void> marcarAsignada(int id, bool asignada) async {
    await (db.update(db.inscripcionesPrueba)..where((t) => t.id.equals(id)))
        .write(InscripcionesPruebaCompanion(asignada: Value(asignada)));
  }

  /// Crea las mangas + inscripciones a partir del resultado del generador.
  Future<void> aplicarGeneracion({
    required int pruebaId,
    required List<MangaGenerada> mangasGeneradas,
    DateTime? fechaBase,
    int carrilesPorManga = 10,
    bool sustituirExistentes = false,
  }) async {
    await db.transaction(() async {
      if (sustituirExistentes) {
        // Borrar mangas (cascada manual: primero inscripciones, luego mangas)
        final mangas = await (db.select(db.mangas)
              ..where((t) => t.pruebaId.equals(pruebaId)))
            .get();
        for (final m in mangas) {
          await (db.delete(db.inscripciones)
                ..where((t) => t.mangaId.equals(m.id)))
              .go();
        }
        await (db.delete(db.mangas)..where((t) => t.pruebaId.equals(pruebaId)))
            .go();
      }

      // Crear las mangas y sus inscripciones SIN asignar carril
      for (final mg in mangasGeneradas) {
        final mangaId = await db.into(db.mangas).insert(
              MangasCompanion.insert(
                pruebaId: pruebaId,
                nombre: mg.nombre,
                numCarriles: Value(carrilesPorManga),
              ),
            );
        for (final eq in mg.equipos) {
          await db.into(db.inscripciones).insert(
                InscripcionesCompanion.insert(
                  mangaId: mangaId,
                  equipoId: eq.equipoId,
                  // sin carril ni seed por defecto
                ),
              );
        }
      }

      // Marcar inscritos como asignados
      final equiposEnGenerados = mangasGeneradas
          .expand((m) => m.equipos.map((e) => e.equipoId))
          .toSet();
      for (final id in equiposEnGenerados) {
        await (db.update(db.inscripcionesPrueba)
              ..where((t) =>
                  t.pruebaId.equals(pruebaId) & t.equipoId.equals(id)))
            .write(const InscripcionesPruebaCompanion(
              asignada: Value(true),
            ));
      }
    });
  }
}

final repoInscripcionesPruebaProvider =
    Provider<RepositorioInscripcionesPrueba>((ref) {
  return RepositorioInscripcionesPrueba(ref.watch(dbProvider));
});
