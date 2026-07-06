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

/// IDs de todos los pilotos (miembros) de los equipos dados, usando la unión
/// equipo_pilotos y cayendo a piloto1/2 para equipos sin filas de unión.
Future<Set<int>> pilotosDeEquipos(
    AppDatabase db, Iterable<int> equipoIds) async {
  final ids = equipoIds.toList();
  if (ids.isEmpty) return {};
  final out = <int>{};
  final union = await (db.select(db.equipoPilotos)
        ..where((t) => t.equipoId.isIn(ids)))
      .get();
  final conUnion = <int>{};
  for (final m in union) {
    out.add(m.pilotoId);
    conUnion.add(m.equipoId);
  }
  final sinUnion = ids.where((e) => !conUnion.contains(e)).toList();
  if (sinUnion.isNotEmpty) {
    final eqs =
        await (db.select(db.equipos)..where((t) => t.id.isIn(sinUnion))).get();
    for (final e in eqs) {
      out.add(e.piloto1Id);
      if (e.piloto2Id != null) out.add(e.piloto2Id!);
    }
  }
  return out;
}

/// Nº máximo de pilotos por equipo según el formato del campeonato.
int maxPilotosEquipo(String formato) {
  switch (formato) {
    case 'INDIVIDUAL':
      return 1;
    case '24H':
    case '12H':
      return 6; // resistencia: 4-5 habitual, hasta 6
    default: // PAREJAS
      return 2;
  }
}

/// Equipo enriquecido con datos de pilotos (lista completa de miembros).
class EquipoConPilotos {
  final Equipo equipo;
  final List<Piloto> pilotos;

  EquipoConPilotos({required this.equipo, required this.pilotos});

  Piloto get piloto1 => pilotos.first;
  Piloto? get piloto2 => pilotos.length > 1 ? pilotos[1] : null;

  /// Resumen mostrable: todos los miembros unidos por " + ".
  String get pilotosTexto => pilotos.map((p) => p.nombre).join(' + ');
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
      final pilotos = await _miembrosDeEquipo(db, e);
      if (pilotos.isEmpty) continue;
      out.add(EquipoConPilotos(equipo: e, pilotos: pilotos));
    }
    return out;
  });
});

/// Pilotos de un equipo, ordenados: primero la unión (por orden); si estuviera
/// vacía, cae a piloto1/piloto2 (compatibilidad).
Future<List<Piloto>> _miembrosDeEquipo(AppDatabase db, Equipo e) async {
  final miembros = await (db.select(db.equipoPilotos)
        ..where((t) => t.equipoId.equals(e.id))
        ..orderBy([(t) => OrderingTerm.asc(t.orden)]))
      .get();
  var ids = miembros.map((m) => m.pilotoId).toList();
  if (ids.isEmpty) {
    ids = [e.piloto1Id, ?e.piloto2Id];
  }
  final out = <Piloto>[];
  for (final id in ids) {
    final p = await (db.select(db.pilotos)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (p != null) out.add(p);
  }
  return out;
}

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

  /// Crea un equipo con una lista ordenada de pilotos (1 o más). Sincroniza
  /// piloto1Id/piloto2Id con los dos primeros y guarda todos en la unión.
  Future<int> crearN({
    required int campeonatoId,
    required String nombre,
    required String copa,
    required List<int> pilotoIds,
  }) async {
    final id = await db.into(db.equipos).insert(
          EquiposCompanion.insert(
            campeonatoId: campeonatoId,
            nombre: nombre,
            copa: copa,
            piloto1Id: pilotoIds.first,
            piloto2Id:
                Value(pilotoIds.length > 1 ? pilotoIds[1] : null),
          ),
        );
    await _sincronizarMiembros(id, pilotoIds);
    return id;
  }

  /// Actualiza nombre/copa y la lista completa de pilotos.
  Future<void> actualizarN({
    required int id,
    required String nombre,
    required String copa,
    required List<int> pilotoIds,
  }) async {
    await (db.update(db.equipos)..where((t) => t.id.equals(id))).write(
      EquiposCompanion(
        nombre: Value(nombre),
        copa: Value(copa),
        piloto1Id: Value(pilotoIds.first),
        piloto2Id: Value(pilotoIds.length > 1 ? pilotoIds[1] : null),
      ),
    );
    await _sincronizarMiembros(id, pilotoIds);
  }

  // --- Compatibilidad con las llamadas antiguas (1-2 pilotos) ---
  Future<int> crear({
    required int campeonatoId,
    required String nombre,
    required String copa,
    required int piloto1Id,
    int? piloto2Id,
  }) =>
      crearN(
        campeonatoId: campeonatoId,
        nombre: nombre,
        copa: copa,
        pilotoIds: [piloto1Id, ?piloto2Id],
      );

  Future<void> actualizar({
    required int id,
    required String nombre,
    required String copa,
    required int piloto1Id,
    int? piloto2Id,
  }) =>
      actualizarN(
        id: id,
        nombre: nombre,
        copa: copa,
        pilotoIds: [piloto1Id, ?piloto2Id],
      );

  Future<void> _sincronizarMiembros(int equipoId, List<int> pilotoIds) async {
    await (db.delete(db.equipoPilotos)
          ..where((t) => t.equipoId.equals(equipoId)))
        .go();
    for (var i = 0; i < pilotoIds.length; i++) {
      await db.into(db.equipoPilotos).insert(
            EquipoPilotosCompanion.insert(
              equipoId: equipoId,
              pilotoId: pilotoIds[i],
              orden: Value(i),
            ),
            mode: InsertMode.insertOrReplace,
          );
    }
  }

  /// IDs de los pilotos de un equipo (unión; cae a piloto1/2 si vacía).
  Future<List<int>> miembros(int equipoId) async {
    final ms = await (db.select(db.equipoPilotos)
          ..where((t) => t.equipoId.equals(equipoId))
          ..orderBy([(t) => OrderingTerm.asc(t.orden)]))
        .get();
    if (ms.isNotEmpty) return ms.map((m) => m.pilotoId).toList();
    final e = await (db.select(db.equipos)..where((t) => t.id.equals(equipoId)))
        .getSingleOrNull();
    if (e == null) return [];
    return [e.piloto1Id, ?e.piloto2Id];
  }

  Future<void> borrar(int id) async {
    await (db.delete(db.equipoPilotos)..where((t) => t.equipoId.equals(id)))
        .go();
    await (db.delete(db.equipos)..where((t) => t.id.equals(id))).go();
  }
}

final repoEquiposProvider = Provider<RepositorioEquipos>((ref) {
  return RepositorioEquipos(ref.watch(dbProvider));
});
