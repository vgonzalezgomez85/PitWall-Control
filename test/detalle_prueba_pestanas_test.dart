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
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pitwall/core/proveedores.dart';
import 'package:pitwall/data/database/app_database.dart';
import 'package:pitwall/features/pruebas/detalle_prueba.dart';
import 'package:pitwall/services/almacen_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Monta la pantalla de una prueba con un equipo inscrito en una tanda.
Future<void> _montar(WidgetTester tester,
    {required bool usaTesoreria, String? tipoMotor}) async {
  tester.view.physicalSize = const Size(1400, 1000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final db = AppDatabase.forTesting(NativeDatabase.memory());
  late Campeonato camp;
  late int pruebaId;
  await tester.runAsync(() async {
    final campId = await db.into(db.campeonatos).insert(
        CampeonatosCompanion.insert(
            nombre: 'Test',
            formato: 'INDIVIDUAL',
            anio: 2026,
            usaTesoreria: Value(usaTesoreria),
            tipoMotor: Value(tipoMotor)));
    camp = await (db.select(db.campeonatos)
          ..where((t) => t.id.equals(campId)))
        .getSingle();
    pruebaId = await db.into(db.pruebas).insert(PruebasCompanion.insert(
        campeonatoId: campId, nombre: 'Prueba 1', orden: 1));
    final manga = await db.into(db.mangas).insert(
        MangasCompanion.insert(pruebaId: pruebaId, nombre: 'Jueves'));
    final p = await db
        .into(db.pilotos)
        .insert(PilotosCompanion.insert(nombre: 'Ana'));
    final e = await db.into(db.equipos).insert(EquiposCompanion.insert(
        campeonatoId: campId, nombre: 'Equipo Ana', copa: 'GT', piloto1Id: p));
    await db.into(db.inscripcionesPrueba).insert(
        InscripcionesPruebaCompanion.insert(pruebaId: pruebaId, equipoId: e));
    await db
        .into(db.inscripciones)
        .insert(InscripcionesCompanion.insert(mangaId: manga, equipoId: e));
  });

  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final contenedor = ProviderContainer(overrides: [
    dbProvider.overrideWithValue(db),
    almacenSyncProvider.overrideWithValue(AlmacenLocal(prefs)),
  ]);
  addTearDown(contenedor.dispose);
  contenedor.read(campeonatoActivoProvider.notifier).seleccionar(camp);
  await tester.pumpWidget(UncontrolledProviderScope(
    container: contenedor,
    child: MaterialApp(home: DetallePrueba(pruebaId: pruebaId)),
  ));
  await _asentar(tester);
}

Future<void> _asentar(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pump(const Duration(milliseconds: 300));
  }
}

Future<void> _desmontar(WidgetTester tester) async {
  // Dejar que drift cierre sus streams (BD en memoria).
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(seconds: 1));
}

void main() {
  setUpAll(() => initializeDateFormatting('es_ES'));

  testWidgets('la prueba se organiza en pestañas y verifica desde Verificar',
      (tester) async {
    await _montar(tester, usaTesoreria: true);

    expect(find.text('Preparar'), findsOneWidget);
    expect(find.text('Verificar'), findsOneWidget);
    expect(find.text('Resultados'), findsOneWidget);
    expect(find.text('Caja'), findsOneWidget);
    expect(find.text('Compartir'), findsOneWidget);
    // Preparar: accesos y lista de tandas.
    expect(find.text('Inscritos'), findsOneWidget);
    // Sin tipo de motor elegido cuenta como mixto: hay sorteo.
    expect(find.text('Sorteo de motores'), findsOneWidget);
    expect(find.text('Jueves'), findsOneWidget);
    expect(find.text('Nueva tanda'), findsOneWidget);

    await tester.tap(find.text('Verificar'));
    await _asentar(tester);
    expect(find.text('Equipo Ana'), findsOneWidget);
    expect(find.text('Pendiente'), findsOneWidget);
    expect(find.text('0 / 1 validadas'), findsOneWidget);
    expect(find.text('Resumen de verificaciones'), findsOneWidget);
    // El botón de nueva tanda solo está en Preparar.
    expect(find.text('Nueva tanda'), findsNothing);

    await tester.tap(find.text('Resultados'));
    await _asentar(tester);
    expect(find.text('Traer resultados de PitWall'), findsOneWidget);
    expect(find.text('0 de 1 equipos con resultado registrado.'),
        findsOneWidget);

    await tester.tap(find.text('Compartir'));
    await _asentar(tester);
    expect(find.text('PDF de tandas'), findsOneWidget);
    expect(find.text('Enviar tandas a PitWall'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await _desmontar(tester);
  });

  testWidgets('sin tesorería no hay Caja y con motor propio no hay sorteo',
      (tester) async {
    await _montar(tester, usaTesoreria: false, tipoMotor: 'PROPIO');
    expect(find.text('Sorteo de motores'), findsNothing);
    expect(find.text('Caja'), findsNothing);
    expect(find.text('Resultados'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await _desmontar(tester);
  });
}
