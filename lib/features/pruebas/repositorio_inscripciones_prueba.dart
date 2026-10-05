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
import '../sincronizacion/dispositivo_sync.dart';
import '../../domain/generador_mangas.dart';
import '../equipos/repositorio_equipos.dart';

/// Empareja los nombres de una hoja/archivo de inscripciones con los equipos
/// del campeonato. En formato individual la hoja trae el nombre del piloto:
/// se busca también por piloto y, si está en el campeonato pero aún no tiene
/// su equipo de un piloto, se le crea (igual que al inscribirlo a mano).
class BuscadorInscritos {
  BuscadorInscritos._(this._db, this._campeonato, this._copas);

  final AppDatabase _db;
  final Campeonato _campeonato;
  final List<String> _copas;
  final _porNombre = <String, Equipo>{};
  final _pilotosPorNombre = <String, Piloto>{};
  final _equipoPorPiloto = <int, Equipo>{};

  static Future<BuscadorInscritos> cargar(
      AppDatabase db, Campeonato campeonato, List<String> copas) async {
    final b = BuscadorInscritos._(db, campeonato, copas);
    final equipos = await (db.select(db.equipos)
          ..where((t) => t.campeonatoId.equals(campeonato.id)))
        .get();
    for (final e in equipos) {
      b._porNombre[_norm(e.nombre)] = e;
    }
    if (maxPilotosEquipo(campeonato.formato) == 1) {
      final ids = (await (db.select(db.pilotoCampeonato)
                ..where((t) => t.campeonatoId.equals(campeonato.id)))
              .get())
          .map((pc) => pc.pilotoId)
          .toSet();
      for (final p in await db.select(db.pilotos).get()) {
        if (ids.contains(p.id)) b._pilotosPorNombre[_norm(p.nombre)] = p;
      }
      for (final e in equipos) {
        b._equipoPorPiloto.putIfAbsent(e.piloto1Id, () => e);
      }
    }
    return b;
  }

  static String _norm(String s) =>
      s.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();

  /// Equipo ya existente para [nombre] (por nombre de equipo o, en
  /// individual, por nombre de su piloto).
  Equipo? equipo(String nombre) {
    final e = _porNombre[_norm(nombre)];
    if (e != null) return e;
    final p = _pilotosPorNombre[_norm(nombre)];
    return p == null ? null : _equipoPorPiloto[p.id];
  }

  /// Piloto del campeonato (individual) que aún no tiene equipo. Solo si
  /// hay copa con la que crearlo.
  Piloto? pilotoSinEquipo(String nombre) {
    if (_copas.isEmpty || equipo(nombre) != null) return null;
    return _pilotosPorNombre[_norm(nombre)];
  }

  /// Crea el equipo de un piloto para [pilotoId] con la primera copa.
  Future<int> crearEquipoDePiloto(int pilotoId) async {
    final existente = _equipoPorPiloto[pilotoId];
    if (existente != null) return existente.id;
    final p = _pilotosPorNombre.values.firstWhere((p) => p.id == pilotoId);
    final id = await RepositorioEquipos(_db).crearN(
      campeonatoId: _campeonato.id,
      nombre: p.nombre,
      copa: _copas.first,
      pilotoIds: [p.id],
    );
    final eq = await (_db.select(_db.equipos)..where((t) => t.id.equals(id)))
        .getSingle();
    _equipoPorPiloto[p.id] = eq;
    _porNombre[_norm(eq.nombre)] = eq;
    return id;
  }

  /// Equipo para [nombre], creándolo si es un piloto sin equipo.
  Future<int?> resolver(String nombre) async {
    final e = equipo(nombre);
    if (e != null) return e.id;
    final p = pilotoSinEquipo(nombre);
    return p == null ? null : crearEquipoDePiloto(p.id);
  }
}

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

  /// Copa que corre el equipo en esta prueba (snapshot); cae a la del equipo.
  String get copa => inscripcion.copa ?? equipo.copa;
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

  /// Da de baja la inscripción a la prueba: también quita al equipo de la
  /// manga de esa prueba en la que estuviera (el resto de carriles no se
  /// tocan; se puede renumerar la manga después).
  Future<void> quitar(int id) async {
    await db.transaction(() async {
      final ins = await (db.select(db.inscripcionesPrueba)
            ..where((t) => t.id.equals(id)))
          .getSingleOrNull();
      if (ins == null) return;
      final mangas = await (db.select(db.mangas)
            ..where((t) => t.pruebaId.equals(ins.pruebaId)))
          .get();
      await (db.delete(db.inscripciones)
            ..where((t) =>
                t.equipoId.equals(ins.equipoId) &
                t.mangaId.isIn(mangas.map((m) => m.id))))
          .go();
      await (db.delete(db.inscripcionesPrueba)..where((t) => t.id.equals(id)))
          .go();
    });
  }

  /// Igual que [quitar], buscando la inscripción por prueba y equipo.
  Future<void> darDeBaja({required int pruebaId, required int equipoId}) async {
    final ins = await (db.select(db.inscripcionesPrueba)
          ..where((t) =>
              t.pruebaId.equals(pruebaId) & t.equipoId.equals(equipoId)))
        .getSingleOrNull();
    if (ins != null) {
      await quitar(ins.id);
    } else {
      // Metido a mano en una manga sin estar en Inscritos.
      final mangas = await (db.select(db.mangas)
            ..where((t) => t.pruebaId.equals(pruebaId)))
          .get();
      await (db.delete(db.inscripciones)
            ..where((t) =>
                t.equipoId.equals(equipoId) &
                t.mangaId.isIn(mangas.map((m) => m.id))))
          .go();
    }
  }

  Future<void> marcarAsignada(int id, bool asignada) async {
    await (db.update(db.inscripcionesPrueba)..where((t) => t.id.equals(id)))
        .write(InscripcionesPruebaCompanion(asignada: Value(asignada)));
  }

  /// Fija (o quita, con `copa: null`) la copa del equipo SOLO para esta
  /// prueba, sin tocar la copa del equipo ni otras pruebas. Si aún no hay
  /// inscripción para (pruebaId, equipoId), la crea.
  Future<void> fijarCopaPrueba({
    required int pruebaId,
    required int equipoId,
    required String? copa,
  }) async {
    final existente = await (db.select(db.inscripcionesPrueba)
          ..where((t) =>
              t.pruebaId.equals(pruebaId) & t.equipoId.equals(equipoId)))
        .getSingleOrNull();
    if (existente == null) {
      await db.into(db.inscripcionesPrueba).insert(
            InscripcionesPruebaCompanion.insert(
              pruebaId: pruebaId,
              equipoId: equipoId,
              copa: Value(copa),
              copaModificadaMs: Value(ahoraMsSync()),
            ),
          );
      return;
    }
    await (db.update(db.inscripcionesPrueba)
          ..where((t) => t.id.equals(existente.id)))
        .write(InscripcionesPruebaCompanion(
            copa: Value(copa), copaModificadaMs: Value(ahoraMsSync())));
  }

  /// Crea las mangas + inscripciones a partir del resultado del generador.
  Future<void> aplicarGeneracion({
    required int pruebaId,
    required List<MangaGenerada> mangasGeneradas,
    DateTime? fechaBase,
    int carrilesPorManga = 10,
    bool sustituirExistentes = false,
    // Solo individuales: carril de salida 1..N / D1.. por orden de puntos,
    // y qué manga hace de pisters en cada una.
    bool asignarCarriles = false,
    bool asignarPisters = false,
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

      // Crear las mangas y sus inscripciones (con carril si se pide)
      final ids = <int>[];
      for (final mg in mangasGeneradas) {
        final mangaId = await db.into(db.mangas).insert(
              MangasCompanion.insert(
                pruebaId: pruebaId,
                nombre: mg.nombre,
                numCarriles: Value(carrilesPorManga),
              ),
            );
        ids.add(mangaId);
        final carriles = asignarCarriles
            ? GeneradorMangas.carrilesSalida(
                mg.equipos.length, carrilesPorManga)
            : null;
        for (var i = 0; i < mg.equipos.length; i++) {
          await db.into(db.inscripciones).insert(
                InscripcionesCompanion.insert(
                  mangaId: mangaId,
                  equipoId: mg.equipos[i].equipoId,
                  carrilSalida: Value(carriles?[i]),
                ),
              );
        }
      }

      if (asignarPisters) {
        final pisters = GeneradorMangas.asignarPisters(
            mangasGeneradas.map((m) => m.nombre).toList());
        for (var i = 0; i < ids.length; i++) {
          final j = pisters[i];
          if (j == null) continue;
          await (db.update(db.mangas)..where((t) => t.id.equals(ids[i])))
              .write(MangasCompanion(pistersMangaId: Value(ids[j])));
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
