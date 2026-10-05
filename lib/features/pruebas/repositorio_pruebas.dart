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
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import '../../domain/generador_mangas.dart';

/// Puntos con los que se ordena a los pilotos al hacer mangas y carriles:
/// los puntos brutos acumulados en el campeonato y, si aún no hay ninguno,
/// la puntuación previa (saldo de la temporada anterior).
Future<Map<int, num>> puntosSemillaPorPiloto(
    AppDatabase db, int campeonatoId) async {
  final pruebas = await (db.select(db.pruebas)
        ..where((t) => t.campeonatoId.equals(campeonatoId)))
      .get();
  final mangas = await (db.select(db.mangas)
        ..where((t) => t.pruebaId.isIn(pruebas.map((p) => p.id))))
      .get();
  final mangaIds = mangas.map((m) => m.id).toSet();
  final resultados = mangaIds.isEmpty
      ? <Resultado>[]
      : await (db.select(db.resultados)
            ..where((t) => t.mangaId.isIn(mangaIds)))
          .get();
  final bruto = <int, num>{};
  for (final r in resultados) {
    bruto.update(r.pilotoId, (v) => v + r.puntos, ifAbsent: () => r.puntos);
  }
  if (bruto.values.any((v) => v > 0)) return bruto;
  final perfiles = await (db.select(db.pilotoCampeonato)
        ..where((t) => t.campeonatoId.equals(campeonatoId)))
      .get();
  return {for (final p in perfiles) p.pilotoId: p.saldoTemporadaAnterior};
}

const estadosPrueba = ['PROGRAMADA', 'EN_CURSO', 'TERMINADA', 'CANCELADA'];

String etiquetaEstado(String e) => switch (e) {
      'PROGRAMADA' => 'Programada',
      'EN_CURSO' => 'En curso',
      'TERMINADA' => 'Terminada',
      'CANCELADA' => 'Cancelada',
      _ => e,
    };

// ============== PRUEBAS ==============

final pruebasCampeonatoProvider =
    StreamProvider.autoDispose<List<Prueba>>((ref) {
  final db = ref.watch(dbProvider);
  final activo = ref.watch(campeonatoActivoProvider);
  if (activo == null) return Stream.value([]);

  return (db.select(db.pruebas)
        ..where((t) => t.campeonatoId.equals(activo.id))
        ..orderBy([
          (t) => OrderingTerm.asc(t.orden),
          (t) => OrderingTerm.asc(t.fecha),
        ]))
      .watch();
});

class RepositorioPruebas {
  RepositorioPruebas(this.db);
  final AppDatabase db;

  Future<int> crear({
    required int campeonatoId,
    required String nombre,
    String? sede,
    DateTime? fecha,
    required int orden,
  }) {
    return db.into(db.pruebas).insert(
          PruebasCompanion.insert(
            campeonatoId: campeonatoId,
            nombre: nombre,
            sede: Value(sede),
            fecha: Value(fecha),
            orden: orden,
          ),
        );
  }

  Future<void> actualizar({
    required int id,
    required String nombre,
    String? sede,
    DateTime? fecha,
    required int orden,
    required String estado,
  }) async {
    await (db.update(db.pruebas)..where((t) => t.id.equals(id))).write(
      PruebasCompanion(
        nombre: Value(nombre),
        sede: Value(sede),
        fecha: Value(fecha),
        orden: Value(orden),
        estado: Value(estado),
      ),
    );
  }

  Future<void> borrar(int id) async {
    await (db.delete(db.pruebas)..where((t) => t.id.equals(id))).go();
  }

  /// Guarda el id de carrera que PitWall Manager asignó a esta prueba (al
  /// enviar la tanda o las verificaciones), para poder ligar envíos futuros
  /// a la misma carrera en vez de que Manager tenga que adivinarla por nombre.
  Future<void> guardarManagerRaceId(int id, int managerRaceId) async {
    await (db.update(db.pruebas)..where((t) => t.id.equals(id))).write(
      PruebasCompanion(managerRaceId: Value(managerRaceId)),
    );
  }

  Future<int> siguienteOrden(int campeonatoId) async {
    final filas = await (db.selectOnly(db.pruebas)
          ..addColumns([db.pruebas.orden.max()])
          ..where(db.pruebas.campeonatoId.equals(campeonatoId)))
        .get();
    final maxOrd = filas.first.read(db.pruebas.orden.max());
    return (maxOrd ?? 0) + 1;
  }
}

final repoPruebasProvider = Provider<RepositorioPruebas>((ref) {
  return RepositorioPruebas(ref.watch(dbProvider));
});

// ============== MANGAS ==============

final mangasPruebaProvider =
    StreamProvider.autoDispose.family<List<Manga>, int>((ref, pruebaId) {
  final db = ref.watch(dbProvider);
  return (db.select(db.mangas)
        ..where((t) => t.pruebaId.equals(pruebaId))
        ..orderBy([
          (t) => OrderingTerm.asc(t.fechaHora),
          (t) => OrderingTerm.asc(t.id),
        ]))
      .watch();
});

class RepositorioMangas {
  RepositorioMangas(this.db);
  final AppDatabase db;

  Future<int> crear({
    required int pruebaId,
    required String nombre,
    DateTime? fechaHora,
    int numCarriles = 8,
  }) {
    return db.into(db.mangas).insert(
          MangasCompanion.insert(
            pruebaId: pruebaId,
            nombre: nombre,
            fechaHora: Value(fechaHora),
            numCarriles: Value(numCarriles),
          ),
        );
  }

  Future<void> actualizar({
    required int id,
    required String nombre,
    DateTime? fechaHora,
    required int numCarriles,
    required String estado,
  }) async {
    await (db.update(db.mangas)..where((t) => t.id.equals(id))).write(
      MangasCompanion(
        nombre: Value(nombre),
        fechaHora: Value(fechaHora),
        numCarriles: Value(numCarriles),
        estado: Value(estado),
      ),
    );
  }

  /// Manga cuyos pilotos hacen de pisters en [id] (null = ninguna).
  Future<void> cambiarPisters(int id, int? pistersMangaId) async {
    await (db.update(db.mangas)..where((t) => t.id.equals(id)))
        .write(MangasCompanion(pistersMangaId: Value(pistersMangaId)));
  }

  Future<void> borrar(int id) async {
    // Las mangas que tenían a esta como pisters se quedan sin asignar.
    await (db.update(db.mangas)..where((t) => t.pistersMangaId.equals(id)))
        .write(const MangasCompanion(pistersMangaId: Value(null)));
    await (db.delete(db.mangas)..where((t) => t.id.equals(id))).go();
  }
}

final repoMangasProvider = Provider<RepositorioMangas>((ref) {
  return RepositorioMangas(ref.watch(dbProvider));
});

// ============== INSCRIPCIONES ==============

class InscripcionConEquipo {
  final Inscripcione inscripcion;
  final Equipo equipo;
  final Piloto piloto1;
  final Piloto? piloto2;

  InscripcionConEquipo({
    required this.inscripcion,
    required this.equipo,
    required this.piloto1,
    this.piloto2,
  });

  String get nombreEquipo => equipo.nombre;
  String get pilotos => piloto2 == null
      ? piloto1.nombre
      : '${piloto1.nombre} + ${piloto2!.nombre}';
}

final inscripcionesMangaProvider = StreamProvider.autoDispose
    .family<List<InscripcionConEquipo>, int>((ref, mangaId) {
  final db = ref.watch(dbProvider);
  return (db.select(db.inscripciones)
        ..where((t) => t.mangaId.equals(mangaId)))
      .watch()
      .asyncMap((lista) async {
    final out = <InscripcionConEquipo>[];
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
      out.add(InscripcionConEquipo(
        inscripcion: i, equipo: eq, piloto1: p1, piloto2: p2,
      ));
    }
    // Ordenar por carril (D1-D4 primero, luego numéricos)
    out.sort((a, b) {
      final ca = a.inscripcion.carrilSalida ?? '';
      final cb = b.inscripcion.carrilSalida ?? '';
      return _ordenCarril(ca).compareTo(_ordenCarril(cb));
    });
    return out;
  });
});

int _ordenCarril(String c) {
  if (c.isEmpty) return 9999;
  if (c.startsWith('D')) {
    return int.tryParse(c.substring(1)) ?? 9000;
  }
  return 100 + (int.tryParse(c) ?? 99);
}

class RepositorioInscripciones {
  RepositorioInscripciones(this.db);
  final AppDatabase db;

  /// Inscribe al equipo en la manga y, si aún no lo estaba, también en la
  /// prueba (tesorería, verificaciones e inscritos leen la de la prueba).
  Future<int> inscribir({
    required int mangaId,
    required int equipoId,
    String? carrilSalida,
    bool seedDirecto = false,
  }) async {
    final manga = await (db.select(db.mangas)
          ..where((t) => t.id.equals(mangaId)))
        .getSingle();
    await _asegurarInscripcionPrueba(manga.pruebaId, equipoId);
    return db.into(db.inscripciones).insert(
          InscripcionesCompanion.insert(
            mangaId: mangaId,
            equipoId: equipoId,
            carrilSalida: Value(carrilSalida),
            seedDirecto: Value(seedDirecto),
          ),
        );
  }

  Future<void> _asegurarInscripcionPrueba(int pruebaId, int equipoId) async {
    final existente = await (db.select(db.inscripcionesPrueba)
          ..where((t) =>
              t.pruebaId.equals(pruebaId) & t.equipoId.equals(equipoId)))
        .getSingleOrNull();
    if (existente != null) return;
    await db.into(db.inscripcionesPrueba).insert(
          InscripcionesPruebaCompanion.insert(
            pruebaId: pruebaId,
            equipoId: equipoId,
          ),
        );
  }

  /// Repara equipos que están en una manga sin estar inscritos en su prueba
  /// (inscritos a mano desde la manga antes de la 1.15.2). Idempotente.
  Future<int> repararInscripcionesPrueba() async {
    final huerfanas = await db.customSelect('''
      SELECT DISTINCT m.prueba_id AS prueba_id, i.equipo_id AS equipo_id
      FROM inscripciones i
      JOIN mangas m ON m.id = i.manga_id
      WHERE NOT EXISTS (
        SELECT 1 FROM inscripciones_prueba ip
        WHERE ip.prueba_id = m.prueba_id AND ip.equipo_id = i.equipo_id
      )
    ''').get();
    for (final r in huerfanas) {
      await _asegurarInscripcionPrueba(
          r.read<int>('prueba_id'), r.read<int>('equipo_id'));
    }
    return huerfanas.length;
  }

  Future<void> cambiarCarril({
    required int inscripcionId,
    String? carrilSalida,
    bool? seedDirecto,
  }) async {
    final companion = seedDirecto == null
        ? InscripcionesCompanion(carrilSalida: Value(carrilSalida))
        : InscripcionesCompanion(
            carrilSalida: Value(carrilSalida),
            seedDirecto: Value(seedDirecto),
          );
    await (db.update(db.inscripciones)
          ..where((t) => t.id.equals(inscripcionId)))
        .write(companion);
  }

  /// Mueve la inscripción a otra manga. Se queda sin carril: el que tenía
  /// era de la manga de origen y en la nueva podría estar ocupado.
  Future<void> moverAManga(int inscripcionId, int mangaId) async {
    await (db.update(db.inscripciones)
          ..where((t) => t.id.equals(inscripcionId)))
        .write(InscripcionesCompanion(
      mangaId: Value(mangaId),
      carrilSalida: const Value(null),
      seedDirecto: const Value(false),
    ));
  }

  /// Intercambia carril (y marca de seed) entre dos inscripciones.
  Future<void> intercambiarCarril(int aId, int bId) async {
    await db.transaction(() async {
      final a = await (db.select(db.inscripciones)
            ..where((t) => t.id.equals(aId)))
          .getSingle();
      final b = await (db.select(db.inscripciones)
            ..where((t) => t.id.equals(bId)))
          .getSingle();
      await cambiarCarril(
          inscripcionId: a.id,
          carrilSalida: b.carrilSalida,
          seedDirecto: b.seedDirecto);
      await cambiarCarril(
          inscripcionId: b.id,
          carrilSalida: a.carrilSalida,
          seedDirecto: a.seedDirecto);
    });
  }

  /// Vuelve a numerar los carriles de la manga como el generador: por
  /// puntos de más a menos, 1..numCarriles y luego D1, D2…
  Future<void> renumerarCarriles(int mangaId) async {
    await db.transaction(() async {
      final manga = await (db.select(db.mangas)
            ..where((t) => t.id.equals(mangaId)))
          .getSingle();
      final prueba = await (db.select(db.pruebas)
            ..where((t) => t.id.equals(manga.pruebaId)))
          .getSingle();
      final puntos = await puntosSemillaPorPiloto(db, prueba.campeonatoId);
      final ins = await (db.select(db.inscripciones)
            ..where((t) => t.mangaId.equals(mangaId)))
          .get();
      final filas = <(Inscripcione, num, String)>[];
      for (final i in ins) {
        final eq = await (db.select(db.equipos)
              ..where((t) => t.id.equals(i.equipoId)))
            .getSingle();
        final pts = (puntos[eq.piloto1Id] ?? 0) +
            (eq.piloto2Id == null ? 0 : (puntos[eq.piloto2Id!] ?? 0));
        filas.add((i, pts, eq.nombre));
      }
      filas.sort((a, b) {
        final c = b.$2.compareTo(a.$2);
        return c != 0 ? c : a.$3.compareTo(b.$3);
      });
      final carriles =
          GeneradorMangas.carrilesSalida(filas.length, manga.numCarriles);
      for (var k = 0; k < filas.length; k++) {
        await cambiarCarril(
            inscripcionId: filas[k].$1.id,
            carrilSalida: carriles[k],
            seedDirecto: false);
      }
    });
  }

  /// Quita al equipo de la manga. Sigue inscrito a la prueba, pero vuelve a
  /// quedar "sin manga" en Inscritos.
  Future<void> quitar(int inscripcionId) async {
    await db.transaction(() async {
      final ins = await (db.select(db.inscripciones)
            ..where((t) => t.id.equals(inscripcionId)))
          .getSingleOrNull();
      if (ins == null) return;
      final manga = await (db.select(db.mangas)
            ..where((t) => t.id.equals(ins.mangaId)))
          .getSingle();
      await (db.delete(db.inscripciones)
            ..where((t) => t.id.equals(inscripcionId)))
          .go();
      await (db.update(db.inscripcionesPrueba)
            ..where((t) =>
                t.pruebaId.equals(manga.pruebaId) &
                t.equipoId.equals(ins.equipoId)))
          .write(const InscripcionesPruebaCompanion(asignada: Value(false)));
    });
  }
}

final repoInscripcionesProvider = Provider<RepositorioInscripciones>((ref) {
  return RepositorioInscripciones(ref.watch(dbProvider));
});
