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

import 'app_database.dart';

/// Valores por defecto para crear campeonatos. La base de datos de una
/// instalación nueva arranca vacía: no se siembra ningún campeonato ni catálogo.
class Seeds {
  /// Tabla de puntos por posición (1 → 70 ... 64 → 1).
  static const puntosPorPosicionPorDefecto = [
    70, 64, 59, 55, 52, 50, 48, 46, 44, 43,
    42, 41, 40, 39, 38, 37, 36, 35, 34, 33,
    32, 31, 30, 29, 28, 27, 26, 25, 24, 23,
    22, 21, 20, 19, 18, 17, 16, 15, 14, 13,
    12, 11, 10, 9, 8, 7, 6, 5, 4, 3,
    2, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1,
  ];

  /// Tabla de bonificación de cierre: [carrerasMin, carrerasMax, bonif]
  static const _bonifPorCategoria = {
    'PLATINO': [
      [7, 99, 12], [6, 6, 8], [4, 5, 6], [2, 3, 2], [1, 1, 0],
    ],
    'ORO': [
      [7, 99, 14], [6, 6, 10], [4, 5, 8], [2, 3, 4], [1, 1, 0],
    ],
    'PLATA': [
      [7, 99, 20], [6, 6, 16], [4, 5, 14], [2, 3, 6], [1, 1, 0],
    ],
    'BRONCE': [
      [7, 99, 28], [6, 6, 24], [4, 5, 16], [2, 3, 8], [1, 1, 0],
    ],
  };

  static Future<void> _sembrarTablasCampeonato(AppDatabase db, int campeonatoId) async {
    for (var i = 0; i < puntosPorPosicionPorDefecto.length; i++) {
      await db.into(db.tablaPuntos).insert(
            TablaPuntosCompanion.insert(
              campeonatoId: campeonatoId,
              posicion: i + 1,
              puntos: puntosPorPosicionPorDefecto[i],
            ),
          );
    }

    for (final cat in _bonifPorCategoria.entries) {
      for (final tramo in cat.value) {
        await db.into(db.tablaBonificacion).insert(
              TablaBonificacionCompanion.insert(
                campeonatoId: campeonatoId,
                categoria: cat.key,
                carrerasMin: tramo[0],
                carrerasMax: tramo[1],
                bonificacion: tramo[2],
              ),
            );
      }
    }
  }

  /// Crea un campeonato con las tablas de puntos y bonificación por defecto.
  static Future<int> crearCampeonato(
    AppDatabase db, {
    required String nombre,
    required String formato,
    required int anio,
  }) async {
    final id = await db.into(db.campeonatos).insert(
          CampeonatosCompanion.insert(
            nombre: nombre,
            formato: formato,
            anio: anio,
          ),
        );
    await _sembrarTablasCampeonato(db, id);
    return id;
  }
}
