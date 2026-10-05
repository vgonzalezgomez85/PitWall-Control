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
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pitwall/core/proveedores.dart';
import 'package:pitwall/data/database/app_database.dart';
import 'package:pitwall/features/verificaciones/frecuencias_verificacion.dart';

void main() {
  test('ordenar: más usados primero y empates en el orden original', () {
    const f = FrecuenciasVerificacion({
      'pinonMarca': {'SIT': 1, 'NSR': 3},
    });
    expect(f.ordenar('pinonMarca', ['AAA', 'NSR', 'BBB', 'SIT']),
        ['NSR', 'SIT', 'AAA', 'BBB']);
    // Campo sin datos: lista intacta.
    expect(f.ordenar('coronaMarca', ['B', 'A']), ['B', 'A']);
  });

  test('cuenta los valores guardados en las verificaciones', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final campId = await db.into(db.campeonatos).insert(
        CampeonatosCompanion.insert(
            nombre: 'Test', formato: 'INDIVIDUAL', anio: 2026));
    final prueba = await db.into(db.pruebas).insert(PruebasCompanion.insert(
        campeonatoId: campId, nombre: 'Prueba 1', orden: 1));
    final manga = await db
        .into(db.mangas)
        .insert(MangasCompanion.insert(pruebaId: prueba, nombre: 'Jueves'));
    Future<void> verif(String nombre,
        {String? pinon, int? dientes, String? motor, String? tipo}) async {
      final p =
          await db.into(db.pilotos).insert(PilotosCompanion.insert(nombre: nombre));
      final e = await db.into(db.equipos).insert(EquiposCompanion.insert(
          campeonatoId: campId, nombre: nombre, copa: 'GT', piloto1Id: p));
      await db.into(db.verificaciones).insert(VerificacionesCompanion.insert(
            mangaId: manga,
            equipoId: e,
            pinonMarca: Value(pinon),
            pinonDientes: Value(dientes),
            motor: Value(motor),
            motorTipo: tipo == null ? const Value.absent() : Value(tipo),
          ));
    }

    await verif('A', pinon: 'NSR', dientes: 12, motor: 'Sprint', tipo: 'PROPIO');
    await verif('B', pinon: 'NSR', dientes: 11, motor: '7');
    await verif('C', pinon: 'SIT', dientes: 12);

    final c = ProviderContainer(overrides: [dbProvider.overrideWithValue(db)]);
    addTearDown(c.dispose);
    final sub = c.listen(frecuenciasVerificacionProvider, (_, _) {});
    addTearDown(sub.close);
    final f = await c.read(frecuenciasVerificacionProvider.future);

    expect(f.veces('pinonMarca', 'NSR'), 2);
    expect(f.veces('pinonDientes', 12), 2);
    expect(f.ordenar('pinonDientes', [10, 11, 12]), [12, 11, 10]);
    // Solo cuenta el motor propio (con organización es el número sorteado).
    expect(f.veces('motor', 'Sprint'), 1);
    expect(f.veces('motor', '7'), 0);
  });
}
