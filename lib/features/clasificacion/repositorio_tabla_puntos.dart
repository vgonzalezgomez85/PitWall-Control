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

/// Tabla de puntos por posición del campeonato activo, ordenada por posición.
/// Cada campeonato tiene su propia tabla (personalizable desde
/// [PantallaEditorTablaPuntos]) — no hay un único criterio global de puntos.
final tablaPuntosProvider =
    StreamProvider.autoDispose<List<TablaPunto>>((ref) {
  final db = ref.watch(dbProvider);
  final activo = ref.watch(campeonatoActivoProvider);
  if (activo == null) return Stream.value(const []);
  final q = db.select(db.tablaPuntos)
    ..where((t) => t.campeonatoId.equals(activo.id))
    ..orderBy([(t) => OrderingTerm.asc(t.posicion)]);
  return q.watch();
});

final repositorioTablaPuntosProvider =
    Provider((ref) => RepositorioTablaPuntos(ref.watch(dbProvider)));

class RepositorioTablaPuntos {
  RepositorioTablaPuntos(this.db);
  final AppDatabase db;

  /// Sustituye toda la tabla de puntos del campeonato por [puntos] (índice 0
  /// = posición 1, etc.). Se hace en una transacción: si algo falla no se
  /// queda a medias.
  Future<void> guardar(int campeonatoId, List<int> puntos) async {
    await db.transaction(() async {
      await (db.delete(db.tablaPuntos)
            ..where((t) => t.campeonatoId.equals(campeonatoId)))
          .go();
      for (var i = 0; i < puntos.length; i++) {
        await db.into(db.tablaPuntos).insert(
              TablaPuntosCompanion.insert(
                campeonatoId: campeonatoId,
                posicion: i + 1,
                puntos: puntos[i],
              ),
            );
      }
    });
  }
}
