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
import 'package:pitwall/core/idioma.dart';
import 'package:pitwall/core/proveedores.dart';
import 'package:pitwall/data/database/app_database.dart';
import 'package:pitwall/features/home/app_shell.dart';
import 'package:pitwall/services/almacen_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ProviderContainer> _montar(WidgetTester tester, Locale? idioma) async {
  tester.view.physicalSize = const Size(1300, 900);
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
    child: Consumer(builder: (context, ref, _) => MaterialApp(
      locale: idioma ?? ref.watch(idiomaProvider),
      supportedLocales: Textos.supportedLocales,
      localizationsDelegates: Textos.localizationsDelegates,
      home: const AppShell(),
    )),
  ));
  for (var i = 0; i < 6; i++) {
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pump(const Duration(milliseconds: 300));
  }
  return contenedor;
}

Future<void> _desmontar(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(seconds: 1));
}

void main() {
  setUpAll(() => initializeDateFormatting());

  testWidgets('en catalán el menú y el Inicio salen en catalán',
      (tester) async {
    await _montar(tester, const Locale('ca'));
    expect(find.text('Proves'), findsOneWidget);
    expect(find.text('Participants'), findsOneWidget);
    expect(find.text('Classificació'), findsOneWidget);
    expect(find.text('EINES'), findsOneWidget);
    expect(find.text('Configuració'), findsOneWidget);
    expect(find.text('Campionat actiu'), findsWidgets);
    expect(find.text('Pruebas'), findsNothing);
    expect(tester.takeException(), isNull);
    await _desmontar(tester);
  });

  testWidgets('en inglés también', (tester) async {
    await _montar(tester, const Locale('en'));
    expect(find.text('Races'), findsOneWidget);
    expect(find.text('Standings'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await _desmontar(tester);
  });

  testWidgets('elegir Català en Ajustes cambia la app al momento',
      (tester) async {
    final c = await _montar(tester, null);
    // Sin elegir nada: español (aunque el sistema de los tests sea inglés).
    expect(find.text('Pruebas'), findsOneWidget);
    await tester.tap(find.text('Ajustes').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Idioma'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Català'));
    await tester.pumpAndSettle();
    expect(find.text('Proves'), findsOneWidget);
    expect(c.read(idiomaProvider), const Locale('ca'));
    expect(c.read(almacenSyncProvider).readSync(key: 'idioma_app'), 'ca');

    // «Automático» sigue al sistema (inglés en los tests).
    await tester.tap(find.text('Idioma'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Automàtic (idioma del sistema)'));
    await tester.pumpAndSettle();
    expect(find.text('Races'), findsOneWidget);
    expect(c.read(almacenSyncProvider).readSync(key: 'idioma_app'), 'auto');
    expect(tester.takeException(), isNull);
    await _desmontar(tester);
  });

  test('un idioma que la app no tiene cae en español', () {
    expect(resolverIdioma(const Locale('de'), Textos.supportedLocales),
        const Locale('es'));
    expect(resolverIdioma(const Locale('fr', 'BE'), Textos.supportedLocales),
        const Locale('fr'));
  });
}
