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
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pitwall/core/proveedores.dart';
import 'package:pitwall/data/database/app_database.dart';
import 'package:pitwall/features/home/app_shell.dart';
import 'package:pitwall/services/almacen_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _asentar(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pump(const Duration(milliseconds: 300));
  }
}

Future<void> _montar(WidgetTester tester, Size tam) async {
  tester.view.physicalSize = tam;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  await tester.runAsync(() => db.into(db.campeonatos).insert(
      CampeonatosCompanion.insert(
          nombre: 'Liga Test', formato: 'PAREJAS', anio: 2026)));
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final contenedor = ProviderContainer(overrides: [
    dbProvider.overrideWithValue(db),
    almacenSyncProvider.overrideWithValue(AlmacenLocal(prefs)),
  ]);
  addTearDown(contenedor.dispose);
  await tester.pumpWidget(UncontrolledProviderScope(
    container: contenedor,
    child: const MaterialApp(home: AppShell()),
  ));
  await _asentar(tester);
}

Future<void> _desmontar(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(seconds: 1));
}

void main() {
  setUpAll(() => initializeDateFormatting('es_ES'));

  testWidgets('en móvil el menú va abajo y el resto en «Más»',
      (tester) async {
    await _montar(tester, const Size(400, 850));

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Más'), findsOneWidget);
    expect(find.text('Participantes'), findsOneWidget);
    expect(find.text('Catálogos'), findsNothing);

    await tester.tap(find.text('Más'));
    await _asentar(tester);
    expect(find.text('CAMPEONATO ACTIVO'), findsOneWidget);
    expect(find.text('Liga Test'), findsWidgets);
    expect(find.text('Tesorería'), findsOneWidget);
    expect(find.text('Créditos'), findsOneWidget);
    expect(find.text('Catálogos'), findsOneWidget);
    expect(find.text('Gestionar campeonatos'), findsOneWidget);

    await tester.tap(find.text('Ajustes'));
    await _asentar(tester);
    expect(find.text('Copias de seguridad'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await _desmontar(tester);
  });

  testWidgets('en escritorio sigue el menú lateral', (tester) async {
    await _montar(tester, const Size(1300, 900));
    expect(find.byType(NavigationBar), findsNothing);
    expect(find.text('HERRAMIENTAS'), findsOneWidget);
    expect(find.text('Catálogos'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await _desmontar(tester);
  });
}
