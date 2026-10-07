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
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pitwall/data/database/app_database.dart';

void main() {
  test('una instalación nueva arranca con la base de datos vacía', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    expect(await db.select(db.campeonatos).get(), isEmpty);
    expect(await db.select(db.catalogoCopas).get(), isEmpty);
    expect(await db.select(db.catalogoClubs).get(), isEmpty);
    expect(await db.select(db.catalogoMarcas).get(), isEmpty);
    expect(await db.select(db.catalogoLlantas).get(), isEmpty);
    expect(await db.select(db.catalogoBancadas).get(), isEmpty);
    expect(await db.select(db.catalogoNeumaticos).get(), isEmpty);
    expect(await db.select(db.catalogoCoches).get(), isEmpty);
    expect(await db.select(db.pilotos).get(), isEmpty);
  });
}
