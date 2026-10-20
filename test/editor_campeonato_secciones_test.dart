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
import 'package:pitwall/core/proveedores.dart';
import 'package:pitwall/data/database/app_database.dart';
import 'package:pitwall/features/campeonatos/editor_campeonato.dart';

Future<void> _asentar(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pump();
  }
}

Future<ProviderContainer> _montar(WidgetTester tester, AppDatabase db,
    {int? campeonatoId}) async {
  tester.view.physicalSize = const Size(1200, 3000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final contenedor =
      ProviderContainer(overrides: [dbProvider.overrideWithValue(db)]);
  addTearDown(contenedor.dispose);
  if (campeonatoId != null) {
    final c = await tester.runAsync(() => (db.select(db.campeonatos)
          ..where((t) => t.id.equals(campeonatoId)))
        .getSingle());
    contenedor.read(campeonatoActivoProvider.notifier).seleccionar(c!);
  }
  await tester.pumpWidget(UncontrolledProviderScope(
    container: contenedor,
    child: MaterialApp(home: EditorCampeonato(campeonatoId: campeonatoId)),
  ));
  await _asentar(tester);
  return contenedor;
}

void main() {
  testWidgets('al crear, lo opcional va plegado en «Más opciones»',
      (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    await _montar(tester, db);

    expect(find.text('Datos básicos'), findsOneWidget);
    expect(find.text('Categorías / copas *'), findsOneWidget);
    expect(find.text('Motor *'), findsOneWidget);
    expect(find.text('Créditos y tesorería'), findsOneWidget);
    expect(find.text('Orden de la primera prueba'), findsOneWidget);
    expect(find.text('Empezar sin puntos: se hace pole'), findsOneWidget);
    expect(find.text('Puntuación'), findsNothing);
    expect(find.text('Estado'), findsNothing);

    final mas = find.text('Más opciones: puntuación, verificación y PDF');
    await tester.ensureVisible(mas);
    await tester.tap(mas);
    await tester.pump();
    expect(find.text('Puntuación'), findsOneWidget);
    expect(find.text('Verificación'), findsOneWidget);
    expect(find.text('Marca en los PDF (opcional)'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('al editar el activo se ve todo y la tabla de puntos',
      (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final id = await tester.runAsync(() => db.into(db.campeonatos).insert(
        CampeonatosCompanion.insert(
            nombre: 'Liga', formato: 'PAREJAS', anio: 2026)));
    await _montar(tester, db, campeonatoId: id);

    expect(find.text('Más opciones: puntuación, verificación y PDF'),
        findsNothing);
    expect(find.text('Puntuación'), findsOneWidget);
    expect(find.text('Tabla de puntos'), findsOneWidget);
    expect(find.text('Estado'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
