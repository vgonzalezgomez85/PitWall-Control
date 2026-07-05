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

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';

/// Vínculo enriquecido que se usa en pantallas.
class VinculoHoja {
  final HojasVinculada fila;
  Map<String, String?> get mapeo {
    try {
      final m = json.decode(fila.mapeoJson) as Map<String, dynamic>;
      return m.map((k, v) => MapEntry(k, v?.toString()));
    } catch (_) {
      return {};
    }
  }

  VinculoHoja(this.fila);
}

/// Provider del vínculo para pilotos del campeonato activo.
final vinculoPilotosProvider =
    StreamProvider.autoDispose<VinculoHoja?>((ref) async* {
  final db = ref.watch(dbProvider);
  final activo = ref.watch(campeonatoActivoProvider);
  if (activo == null) {
    yield null;
    return;
  }
  yield* (db.select(db.hojasVinculadas)
        ..where((t) =>
            t.entidad.equals('pilotos') &
            t.campeonatoId.equals(activo.id)))
      .watchSingleOrNull()
      .map((f) => f == null ? null : VinculoHoja(f));
});

/// Provider del vínculo para equipos del campeonato activo.
final vinculoEquiposProvider =
    StreamProvider.autoDispose<VinculoHoja?>((ref) async* {
  final db = ref.watch(dbProvider);
  final activo = ref.watch(campeonatoActivoProvider);
  if (activo == null) {
    yield null;
    return;
  }
  yield* (db.select(db.hojasVinculadas)
        ..where((t) =>
            t.entidad.equals('equipos') &
            t.campeonatoId.equals(activo.id)))
      .watchSingleOrNull()
      .map((f) => f == null ? null : VinculoHoja(f));
});

/// Provider del vínculo para inscripciones de una prueba.
final vinculoInscripcionesProvider =
    StreamProvider.autoDispose.family<VinculoHoja?, int>((ref, pruebaId) {
  final db = ref.watch(dbProvider);
  return (db.select(db.hojasVinculadas)
        ..where((t) =>
            t.entidad.equals('inscripciones') &
            t.pruebaId.equals(pruebaId)))
      .watchSingleOrNull()
      .map((f) => f == null ? null : VinculoHoja(f));
});

/// Provider genérico: vínculo global (sin campeonato/prueba) por entidad.
/// Se usa p. ej. para catálogos: entidad = 'catalogo_coches', 'catalogo_engranajes'…
final vinculoEntidadProvider =
    StreamProvider.autoDispose.family<VinculoHoja?, String>((ref, entidad) {
  final db = ref.watch(dbProvider);
  return (db.select(db.hojasVinculadas)
        ..where((t) =>
            t.entidad.equals(entidad) &
            t.campeonatoId.isNull() &
            t.pruebaId.isNull()))
      .watchSingleOrNull()
      .map((f) => f == null ? null : VinculoHoja(f));
});

class RepositorioHojasVinculadas {
  RepositorioHojasVinculadas(this.db);
  final AppDatabase db;

  Future<int> guardarVinculo({
    required String entidad,
    int? campeonatoId,
    int? pruebaId,
    required String hojaId,
    required String hojaNombre,
    required String pestanaTitulo,
    required Map<String, String?> mapeo,
  }) async {
    final mapeoJson = json.encode(mapeo);
    // ¿ya existe vínculo para esta entidad+contexto?
    final existente = await (db.select(db.hojasVinculadas)
          ..where((t) =>
              t.entidad.equals(entidad) &
              (campeonatoId == null
                  ? t.campeonatoId.isNull()
                  : t.campeonatoId.equals(campeonatoId)) &
              (pruebaId == null
                  ? t.pruebaId.isNull()
                  : t.pruebaId.equals(pruebaId))))
        .getSingleOrNull();
    if (existente != null) {
      await (db.update(db.hojasVinculadas)
            ..where((t) => t.id.equals(existente.id)))
          .write(HojasVinculadasCompanion(
        hojaId: Value(hojaId),
        hojaNombre: Value(hojaNombre),
        pestanaTitulo: Value(pestanaTitulo),
        mapeoJson: Value(mapeoJson),
      ));
      return existente.id;
    }
    return db.into(db.hojasVinculadas).insert(HojasVinculadasCompanion.insert(
          entidad: entidad,
          campeonatoId: Value(campeonatoId),
          pruebaId: Value(pruebaId),
          hojaId: hojaId,
          hojaNombre: hojaNombre,
          pestanaTitulo: pestanaTitulo,
          mapeoJson: mapeoJson,
        ));
  }

  Future<void> marcarSync(int id, String resumen) async {
    await (db.update(db.hojasVinculadas)..where((t) => t.id.equals(id)))
        .write(HojasVinculadasCompanion(
      ultimaSync: Value(DateTime.now()),
      ultimoResumen: Value(resumen),
    ));
  }

  Future<void> borrar(int id) async {
    await (db.delete(db.hojasVinculadas)..where((t) => t.id.equals(id))).go();
  }
}

final repoHojasVinculadasProvider =
    Provider<RepositorioHojasVinculadas>((ref) {
  return RepositorioHojasVinculadas(ref.watch(dbProvider));
});
