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

/// Equipo enriquecido con datos de pilotos.
class EquipoConPilotos {
  final Equipo equipo;
  final Piloto piloto1;
  final Piloto? piloto2;

  EquipoConPilotos({
    required this.equipo,
    required this.piloto1,
    this.piloto2,
  });

  /// Resumen mostrable: "Piloto1 + Piloto2" o solo "Piloto1".
  String get pilotosTexto => piloto2 == null
      ? piloto1.nombre
      : '${piloto1.nombre} + ${piloto2!.nombre}';
}

/// Stream de equipos del campeonato activo, con datos de pilotos resueltos.
final equiposCampeonatoProvider =
    StreamProvider.autoDispose<List<EquipoConPilotos>>((ref) {
  final db = ref.watch(dbProvider);
  final activo = ref.watch(campeonatoActivoProvider);
  if (activo == null) return Stream.value([]);

  return (db.select(db.equipos)
        ..where((t) => t.campeonatoId.equals(activo.id))
        ..orderBy([(t) => OrderingTerm.asc(t.nombre)]))
      .watch()
      .asyncMap((lista) async {
    final out = <EquipoConPilotos>[];
    for (final e in lista) {
      final p1 = await (db.select(db.pilotos)
            ..where((t) => t.id.equals(e.piloto1Id)))
          .getSingle();
      Piloto? p2;
      if (e.piloto2Id != null) {
        p2 = await (db.select(db.pilotos)
              ..where((t) => t.id.equals(e.piloto2Id!)))
            .getSingleOrNull();
      }
      out.add(EquipoConPilotos(equipo: e, piloto1: p1, piloto2: p2));
    }
    return out;
  });
});

/// Lista de pilotos del campeonato activo (para asignar a equipos).
final pilotosDelCampeonatoProvider =
    StreamProvider.autoDispose<List<Piloto>>((ref) {
  final db = ref.watch(dbProvider);
  final activo = ref.watch(campeonatoActivoProvider);
  if (activo == null) return Stream.value([]);

  final query = db.select(db.pilotos).join([
    innerJoin(
      db.pilotoCampeonato,
      db.pilotoCampeonato.pilotoId.equalsExp(db.pilotos.id) &
          db.pilotoCampeonato.campeonatoId.equals(activo.id),
    ),
  ])
    ..orderBy([OrderingTerm.asc(db.pilotos.nombre)]);

  return query.watch().map((rows) =>
      rows.map((r) => r.readTable(db.pilotos)).toList());
});

final cochesProvider = StreamProvider<List<CatalogoCoche>>((ref) {
  final db = ref.watch(dbProvider);
  return (db.select(db.catalogoCoches)
        ..where((t) => t.activo.equals(true))
        ..orderBy([(t) => OrderingTerm.asc(t.nombre)]))
      .watch();
});

/// Copas configuradas en el campeonato activo (no el catálogo global).
final copasProvider = Provider<List<String>>((ref) {
  final activo = ref.watch(campeonatoActivoProvider);
  if (activo == null) return const [];
  try {
    final raw = json.decode(activo.copasJson);
    if (raw is List) return raw.map((e) => e.toString()).toList();
  } catch (_) {}
  return const [];
});

class RepositorioEquipos {
  RepositorioEquipos(this.db);
  final AppDatabase db;

  Future<int> crear({
    required int campeonatoId,
    required String nombre,
    required String copa,
    required int piloto1Id,
    int? piloto2Id,
  }) async {
    return db.into(db.equipos).insert(
          EquiposCompanion.insert(
            campeonatoId: campeonatoId,
            nombre: nombre,
            copa: copa,
            piloto1Id: piloto1Id,
            piloto2Id: Value(piloto2Id),
          ),
        );
  }

  Future<void> actualizar({
    required int id,
    required String nombre,
    required String copa,
    required int piloto1Id,
    int? piloto2Id,
  }) async {
    await (db.update(db.equipos)..where((t) => t.id.equals(id))).write(
      EquiposCompanion(
        nombre: Value(nombre),
        copa: Value(copa),
        piloto1Id: Value(piloto1Id),
        piloto2Id: Value(piloto2Id),
      ),
    );
  }

  Future<void> borrar(int id) async {
    await (db.delete(db.equipos)..where((t) => t.id.equals(id))).go();
  }
}

final repoEquiposProvider = Provider<RepositorioEquipos>((ref) {
  return RepositorioEquipos(ref.watch(dbProvider));
});
