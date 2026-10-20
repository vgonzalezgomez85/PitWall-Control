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
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pitwall/data/database/app_database.dart';

/// Una base con el esquema actual pero con `user_version` retrasado (pasa en
/// bases venidas de versiones antiguas o restauradas de copia) debe poder
/// abrirse: la migración repasa los pasos ya aplicados sin romper. Antes,
/// un `DROP COLUMN` de una columna que ya no estaba abortaba el arranque y
/// la app se quedaba cargando.
void main() {
  test('una BD con user_version retrasado se abre y migra sin romper',
      () async {
    final dir = Directory.systemTemp.createTempSync('pitwall_migracion');
    final fichero = File('${dir.path}/pitwall.sqlite');

    // 1) Base con el esquema actual.
    var db = AppDatabase.forTesting(NativeDatabase(fichero));
    await db.customSelect('SELECT 1').get();
    await db.customStatement('PRAGMA user_version = 29');
    await db.close();

    // 2) Se reabre como si fuera una base antigua: migra de 29 al actual.
    db = AppDatabase.forTesting(NativeDatabase(fichero));
    final campeonatos = await db.select(db.campeonatos).get();
    expect(campeonatos, isEmpty);
    final version = await db
        .customSelect('PRAGMA user_version')
        .getSingle();
    expect(version.data.values.first, db.schemaVersion);
    await db.close();

    dir.deleteSync(recursive: true);
  });
}
