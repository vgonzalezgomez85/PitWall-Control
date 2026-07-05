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

/// Una fila del editor manual: un piloto (con equipo) y sus puntos por prueba.
class FilaEditorManual {
  final int pilotoId;
  final int equipoId;
  final String pilotoNombre;
  final String equipoNombre;
  final String copa;
  /// pruebaId → puntos introducidos a mano (manga "IMPORTADA").
  final Map<int, int> puntos;
  /// Pilotos a los que afecta la edición de esta fila. En la general es solo
  /// el piloto; en una copa (puntos por equipo) son los dos del equipo.
  final List<int> pilotosAfectados;

  FilaEditorManual({
    required this.pilotoId,
    required this.equipoId,
    required this.pilotoNombre,
    required this.equipoNombre,
    required this.copa,
    required this.puntos,
    List<int>? pilotosAfectados,
  }) : pilotosAfectados = pilotosAfectados ?? [pilotoId];
}

class DatosEditorManual {
  final List<Prueba> pruebas;
  final List<FilaEditorManual> filas;
  DatosEditorManual(this.pruebas, this.filas);
}

/// Permite editar la clasificación a mano: una rejilla de pilotos × pruebas.
/// Los puntos se guardan en una manga "IMPORTADA" por prueba (el mismo canal
/// que usa el importador de clasificación), por lo que conviven con esa vía.
class RepositorioClasificacionManual {
  RepositorioClasificacionManual(this.db);
  final AppDatabase db;

  Future<int> _mangaImportada(int pruebaId) async {
    final ex = await (db.select(db.mangas)
          ..where((t) =>
              t.pruebaId.equals(pruebaId) & t.nombre.equals('IMPORTADA')))
        .getSingleOrNull();
    if (ex != null) return ex.id;
    return db.into(db.mangas).insert(MangasCompanion.insert(
          pruebaId: pruebaId,
          nombre: 'IMPORTADA',
          estado: const Value('FINALIZADA'),
        ));
  }

  /// Garantiza que el equipo está inscrito en la prueba: si no, el piloto no
  /// aparecería en la clasificación aunque tenga puntos.
  Future<void> _asegurarInscripcion(int pruebaId, int equipoId) async {
    final ex = await (db.select(db.inscripcionesPrueba)
          ..where((t) =>
              t.pruebaId.equals(pruebaId) & t.equipoId.equals(equipoId)))
        .getSingleOrNull();
    if (ex == null) {
      await db.into(db.inscripcionesPrueba).insert(
            InscripcionesPruebaCompanion.insert(
              pruebaId: pruebaId,
              equipoId: equipoId,
              asignada: const Value(true),
            ),
          );
    }
  }

  /// Corrección manual de la clasificación de una COPA: prevalece sobre el
  /// re-ranking automático. Vacío ([puntos] null) borra la corrección y vuelve
  /// al cálculo automático.
  Future<void> guardarOverrideCopa({
    required int campeonatoId,
    required String copa,
    required int pruebaId,
    required int pilotoId,
    int? puntos,
  }) async {
    if (puntos == null) {
      await (db.delete(db.overridesCopa)
            ..where((t) =>
                t.campeonatoId.equals(campeonatoId) &
                t.copa.equals(copa) &
                t.pilotoId.equals(pilotoId) &
                t.pruebaId.equals(pruebaId)))
          .go();
      return;
    }
    await db.into(db.overridesCopa).insertOnConflictUpdate(
          OverridesCopaCompanion.insert(
            campeonatoId: campeonatoId,
            copa: copa,
            pilotoId: pilotoId,
            pruebaId: pruebaId,
            puntos: puntos,
          ),
        );
  }

  /// Guarda (o borra, si [puntos] es null) los puntos de un piloto en una
  /// prueba. Vacío = sin resultado (no cuenta); 0 = participó con 0 puntos.
  Future<void> guardarPunto({
    required int pruebaId,
    required int equipoId,
    required int pilotoId,
    int? puntos,
  }) async {
    final mangaId = await _mangaImportada(pruebaId);
    await (db.delete(db.resultados)
          ..where((t) =>
              t.mangaId.equals(mangaId) & t.pilotoId.equals(pilotoId)))
        .go();
    if (puntos != null) {
      await db.into(db.resultados).insert(ResultadosCompanion.insert(
            mangaId: mangaId,
            pilotoId: pilotoId,
            equipoId: equipoId,
            puntos: Value(puntos),
          ));
      await _asegurarInscripcion(pruebaId, equipoId);
    }
  }

  /// Carga la rejilla. Si [copa] no es null, solo los pilotos de esa copa.
  Future<DatosEditorManual> cargar(int campeonatoId, {String? copa}) async {
    final pruebas = await (db.select(db.pruebas)
          ..where((t) => t.campeonatoId.equals(campeonatoId))
          ..orderBy([(t) => OrderingTerm.asc(t.orden)]))
        .get();

    final perfiles = await (db.select(db.pilotoCampeonato)
          ..where((t) => t.campeonatoId.equals(campeonatoId)))
        .get();
    final equipos = await (db.select(db.equipos)
          ..where((t) => t.campeonatoId.equals(campeonatoId)))
        .get();
    final equipoPorPiloto = <int, Equipo>{};
    for (final e in equipos) {
      equipoPorPiloto[e.piloto1Id] = e;
      if (e.piloto2Id != null) equipoPorPiloto[e.piloto2Id!] = e;
    }
    final pilotos = await db.select(db.pilotos).get();
    final nombrePorId = {for (final p in pilotos) p.id: p.nombre};

    // Puntos EFECTIVOS actuales (los que ve la clasificación): suma de las
    // mangas reales y, si hay manga IMPORTADA, su valor pisa el de la prueba.
    final pruebaIds = pruebas.map((p) => p.id).toList();
    final mangas = pruebaIds.isEmpty
        ? <Manga>[]
        : await (db.select(db.mangas)
              ..where((t) => t.pruebaId.isIn(pruebaIds)))
            .get();
    final pruebaPorManga = {for (final m in mangas) m.id: m.pruebaId};
    final importadaIds = mangas
        .where((m) => m.nombre == 'IMPORTADA')
        .map((m) => m.id)
        .toSet();
    final mangaIds = mangas.map((m) => m.id).toList();
    final res = mangaIds.isEmpty
        ? <Resultado>[]
        : await (db.select(db.resultados)
              ..where((t) => t.mangaId.isIn(mangaIds)))
            .get();
    // efectivo[pilotoId][pruebaId] = puntos
    final efectivo = <int, Map<int, int>>{};
    for (final r in res) {
      if (importadaIds.contains(r.mangaId)) continue;
      final pid = pruebaPorManga[r.mangaId];
      if (pid == null) continue;
      final m = (efectivo[r.pilotoId] ??= {});
      m[pid] = (m[pid] ?? 0) + r.puntos;
    }
    for (final r in res) {
      if (!importadaIds.contains(r.mangaId)) continue;
      final pid = pruebaPorManga[r.mangaId];
      if (pid == null) continue;
      (efectivo[r.pilotoId] ??= {})[pid] = r.puntos; // override
    }

    final filas = <FilaEditorManual>[];
    for (final pf in perfiles) {
      final eq = equipoPorPiloto[pf.pilotoId];
      if (eq == null) continue; // sin equipo no puede puntuar
      if (copa != null && eq.copa != copa) continue; // filtro por copa
      final puntos = <int, int>{...?efectivo[pf.pilotoId]};
      filas.add(FilaEditorManual(
        pilotoId: pf.pilotoId,
        equipoId: eq.id,
        pilotoNombre: nombrePorId[pf.pilotoId] ?? 'Piloto ${pf.pilotoId}',
        equipoNombre: eq.nombre,
        copa: eq.copa,
        puntos: puntos,
      ));
    }
    filas.sort((a, b) =>
        a.pilotoNombre.toLowerCase().compareTo(b.pilotoNombre.toLowerCase()));
    return DatosEditorManual(pruebas, filas);
  }
}

final repoClasificacionManualProvider =
    Provider<RepositorioClasificacionManual>(
        (ref) => RepositorioClasificacionManual(ref.watch(dbProvider)));
