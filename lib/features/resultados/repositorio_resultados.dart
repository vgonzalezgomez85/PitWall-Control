import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';

/// Resultado enriquecido para pintar en la pantalla.
class ResultadoEquipo {
  final int equipoId;
  final String nombreEquipo;
  final String copa;
  final Piloto piloto1;
  final Piloto? piloto2;
  final String? carril;

  /// Resultados existentes en BD (uno por piloto). Si no hay, queda null.
  int? posicion;
  int? puntos;
  int? aRestar;

  /// IDs del resultado en BD por piloto (para update).
  int? idResultadoP1;
  int? idResultadoP2;

  ResultadoEquipo({
    required this.equipoId,
    required this.nombreEquipo,
    required this.copa,
    required this.piloto1,
    this.piloto2,
    this.carril,
    this.posicion,
    this.puntos,
    this.aRestar,
    this.idResultadoP1,
    this.idResultadoP2,
  });
}

/// Stream de equipos inscritos en la manga + sus resultados.
final resultadosMangaProvider = StreamProvider.autoDispose
    .family<List<ResultadoEquipo>, int>((ref, mangaId) {
  final db = ref.watch(dbProvider);
  return (db.select(db.inscripciones)
        ..where((t) => t.mangaId.equals(mangaId)))
      .watch()
      .asyncMap((inscritos) async {
    final out = <ResultadoEquipo>[];
    for (final i in inscritos) {
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
      final r1 = await (db.select(db.resultados)
            ..where((t) =>
                t.mangaId.equals(mangaId) & t.pilotoId.equals(p1.id)))
          .getSingleOrNull();
      Resultado? r2;
      if (p2 != null) {
        final p2Id = p2.id;
        r2 = await (db.select(db.resultados)
              ..where((t) =>
                  t.mangaId.equals(mangaId) & t.pilotoId.equals(p2Id)))
            .getSingleOrNull();
      }

      out.add(ResultadoEquipo(
        equipoId: eq.id,
        nombreEquipo: eq.nombre,
        copa: eq.copa,
        piloto1: p1,
        piloto2: p2,
        carril: i.carrilSalida,
        posicion: r1?.posicion ?? r2?.posicion,
        puntos: r1?.puntos ?? r2?.puntos,
        aRestar: r1?.aRestar ?? r2?.aRestar,
        idResultadoP1: r1?.id,
        idResultadoP2: r2?.id,
      ));
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

class RepositorioResultados {
  RepositorioResultados(this.db);
  final AppDatabase db;

  /// Devuelve los puntos correspondientes a una posición según la tabla
  /// del campeonato. Si la posición está fuera, devuelve 0.
  Future<int> puntosParaPosicion({
    required int campeonatoId,
    required int posicion,
  }) async {
    final fila = await (db.select(db.tablaPuntos)
          ..where((t) =>
              t.campeonatoId.equals(campeonatoId) &
              t.posicion.equals(posicion)))
        .getSingleOrNull();
    return fila?.puntos ?? 0;
  }

  /// Asigna posición a un equipo en una manga. Crea (o actualiza) un
  /// resultado por cada piloto del equipo, con los puntos del campeonato.
  Future<void> asignarPosicionEquipo({
    required int mangaId,
    required int equipoId,
    required int campeonatoId,
    required int posicion,
    int? aRestar,
  }) async {
    final puntos = await puntosParaPosicion(
      campeonatoId: campeonatoId,
      posicion: posicion,
    );

    final eq = await (db.select(db.equipos)
          ..where((t) => t.id.equals(equipoId)))
        .getSingle();
    final pilotos = <int>[eq.piloto1Id, if (eq.piloto2Id != null) eq.piloto2Id!];

    await db.transaction(() async {
      for (final pid in pilotos) {
        final existente = await (db.select(db.resultados)
              ..where((t) =>
                  t.mangaId.equals(mangaId) & t.pilotoId.equals(pid)))
            .getSingleOrNull();
        if (existente == null) {
          await db.into(db.resultados).insert(
                ResultadosCompanion.insert(
                  mangaId: mangaId,
                  pilotoId: pid,
                  equipoId: equipoId,
                  puntos: Value(puntos),
                  posicion: Value(posicion),
                  aRestar: Value(aRestar ?? 0),
                ),
              );
        } else {
          await (db.update(db.resultados)
                ..where((t) => t.id.equals(existente.id)))
              .write(ResultadosCompanion(
            puntos: Value(puntos),
            posicion: Value(posicion),
            aRestar: aRestar != null ? Value(aRestar) : const Value.absent(),
          ));
        }
      }
    });
  }

  /// Borra resultado de un equipo en una manga (los dos pilotos).
  Future<void> borrarResultadoEquipo({
    required int mangaId,
    required int equipoId,
  }) async {
    await (db.delete(db.resultados)
          ..where((t) =>
              t.mangaId.equals(mangaId) & t.equipoId.equals(equipoId)))
        .go();
  }
}

final repoResultadosProvider = Provider<RepositorioResultados>((ref) {
  return RepositorioResultados(ref.watch(dbProvider));
});
