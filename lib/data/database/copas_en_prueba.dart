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

/// Copa con la que corre cada equipo en una prueba concreta.
///
/// La copa elegida en la inscripción/verificación vale SOLO para esa prueba
/// (`inscripcionesPrueba.copa`); `equipos.copa` es solo el valor por defecto.
/// Toda vista o exportación de una prueba debe resolver la copa con
/// `copas[equipo.id] ?? equipo.copa`.
extension CopasEnPrueba on AppDatabase {
  /// equipoId → copa fijada en la inscripción de [pruebaId] (solo las que
  /// la tienen; si falta, el llamador cae a `equipo.copa`).
  Future<Map<int, String>> copasEnPrueba(int pruebaId) async {
    final ins = await (select(inscripcionesPrueba)
          ..where((t) => t.pruebaId.equals(pruebaId)))
        .get();
    return {
      for (final i in ins)
        if (i.copa != null && i.copa!.isNotEmpty) i.equipoId: i.copa!,
    };
  }
}
