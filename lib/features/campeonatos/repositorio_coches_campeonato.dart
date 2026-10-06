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
import '../verificaciones/reglas_verificacion_bd.dart';

/// Peso mínimo y créditos de los coches en un campeonato (tabla
/// `coches_campeonato`). Lo que se fija aquí manda sobre el catálogo para
/// ese campeonato; lo que no, sigue al catálogo.
class RepositorioCochesCampeonato {
  RepositorioCochesCampeonato(this.db);
  final AppDatabase db;

  Future<Map<int, CochesCampeonatoData>> ajustes(int campeonatoId) async => {
        for (final a in await (db.select(db.cochesCampeonato)
              ..where((t) => t.campeonatoId.equals(campeonatoId)))
            .get())
          a.cocheCatalogoId: a,
      };

  /// Coches activos del catálogo que se pueden usar en el campeonato (con
  /// alguna de sus copas; si el campeonato no tiene copas, todos).
  Future<List<CatalogoCoche>> cochesDelCampeonato(Campeonato c) async {
    final coches = await (db.select(db.catalogoCoches)
          ..where((t) => t.activo.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.nombre)]))
        .get();
    final copas = <String>[];
    try {
      final raw = jsonDecode(c.copasJson);
      if (raw is List) copas.addAll(raw.map((e) => e.toString()));
    } catch (_) {}
    if (copas.isEmpty) return coches;
    return coches
        .where((x) => copas.any((copa) => copaAplica(x.copasJson, copa)))
        .toList();
  }

  /// Fija (o quita, si ambos son null) los valores de un coche.
  Future<void> fijar(
    int campeonatoId,
    int cocheId, {
    required double? pesoMin,
    required int? creditos,
  }) async {
    if (pesoMin == null && creditos == null) {
      await (db.delete(db.cochesCampeonato)
            ..where((t) =>
                t.campeonatoId.equals(campeonatoId) &
                t.cocheCatalogoId.equals(cocheId)))
          .go();
      return;
    }
    await db.into(db.cochesCampeonato).insertOnConflictUpdate(
          CochesCampeonatoCompanion.insert(
            campeonatoId: campeonatoId,
            cocheCatalogoId: cocheId,
            pesoMin: Value(pesoMin),
            creditosCoche: Value(creditos),
          ),
        );
  }

  /// Copia al campeonato los valores actuales del catálogo de sus coches,
  /// sin tocar lo que ya esté fijado. A partir de ahí, cambiar el catálogo
  /// no afecta a este campeonato. Devuelve cuántos coches ha fijado.
  Future<int> fijarDesdeCatalogo(int campeonatoId) async {
    final c = await (db.select(db.campeonatos)
          ..where((t) => t.id.equals(campeonatoId)))
        .getSingleOrNull();
    if (c == null) return 0;
    final hechos = await ajustes(campeonatoId);
    var n = 0;
    for (final coche in await cochesDelCampeonato(c)) {
      final a = hechos[coche.id];
      if (a != null && a.pesoMin != null && a.creditosCoche != null) continue;
      await fijar(
        campeonatoId,
        coche.id,
        pesoMin: a?.pesoMin ?? coche.pesoMin,
        creditos: a?.creditosCoche ?? coche.creditosCoche,
      );
      n++;
    }
    return n;
  }

  /// Vuelve a usar el catálogo en todos los coches del campeonato.
  Future<void> quitarTodos(int campeonatoId) async {
    await (db.delete(db.cochesCampeonato)
          ..where((t) => t.campeonatoId.equals(campeonatoId)))
        .go();
  }

  /// Limpia los valores de un coche borrado del catálogo.
  Future<void> olvidarCoche(int cocheId) async {
    await (db.delete(db.cochesCampeonato)
          ..where((t) => t.cocheCatalogoId.equals(cocheId)))
        .go();
  }
}

final repoCochesCampeonatoProvider = Provider<RepositorioCochesCampeonato>(
    (ref) => RepositorioCochesCampeonato(ref.watch(dbProvider)));
