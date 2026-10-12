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
import 'package:pitwall/features/home/pantalla_resumen.dart';

void main() {
  setUpAll(() => initializeDateFormatting('es_ES'));

  testWidgets('Inicio muestra la próxima prueba y los pendientes',
      (tester) async {
    tester.view.physicalSize = const Size(1400, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final db = AppDatabase.forTesting(NativeDatabase.memory());
    late Campeonato camp;
    await tester.runAsync(() async {
      final campId = await db.into(db.campeonatos).insert(
          CampeonatosCompanion.insert(
              nombre: 'Test', formato: 'INDIVIDUAL', anio: 2026));
      camp = await (db.select(db.campeonatos)
            ..where((t) => t.id.equals(campId)))
          .getSingle();
      // Prueba ya disputada (ayer) y sin resultados.
      await db.into(db.pruebas).insert(PruebasCompanion.insert(
          campeonatoId: campId,
          nombre: 'Prueba pasada',
          orden: 1,
          estado: const Value('TERMINADA'),
          fecha: Value(DateTime.now().subtract(const Duration(days: 1)))));
      // Próxima prueba: dos equipos en una tanda, uno validado.
      final proxima = await db.into(db.pruebas).insert(PruebasCompanion.insert(
          campeonatoId: campId,
          nombre: 'Prueba próxima',
          orden: 2,
          fecha: Value(DateTime.now().add(const Duration(days: 4)))));
      final tanda = await db.into(db.mangas).insert(
          MangasCompanion.insert(pruebaId: proxima, nombre: 'Jueves'));
      for (final (nombre, validado) in [('Ana', true), ('Bruno', false)]) {
        final p = await db
            .into(db.pilotos)
            .insert(PilotosCompanion.insert(nombre: nombre));
        final e = await db.into(db.equipos).insert(EquiposCompanion.insert(
            campeonatoId: campId, nombre: nombre, copa: 'GT', piloto1Id: p));
        await db.into(db.inscripcionesPrueba).insert(
            InscripcionesPruebaCompanion.insert(pruebaId: proxima, equipoId: e));
        await db
            .into(db.inscripciones)
            .insert(InscripcionesCompanion.insert(mangaId: tanda, equipoId: e));
        if (validado) {
          await db.into(db.verificaciones).insert(VerificacionesCompanion.insert(
              mangaId: tanda, equipoId: e, validado: const Value(true)));
        }
      }
    });

    final contenedor =
        ProviderContainer(overrides: [dbProvider.overrideWithValue(db)]);
    addTearDown(contenedor.dispose);
    contenedor.read(campeonatoActivoProvider.notifier).seleccionar(camp);
    await tester.pumpWidget(UncontrolledProviderScope(
      container: contenedor,
      child: const MaterialApp(home: PantallaResumen()),
    ));
    for (var i = 0; i < 6; i++) {
      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 50)));
      await tester.pump();
    }

    // En la tarjeta y como detalle de los dos pendientes.
    expect(find.text('Prueba próxima'), findsNWidgets(3));
    expect(find.text('Inscritos'), findsOneWidget);
    expect(find.text('Verificar'), findsOneWidget);
    expect(find.text('Resultados'), findsOneWidget);

    expect(find.text('verificación sin validar'), findsOneWidget);
    expect(find.text('pagos sin cobrar'), findsOneWidget);
    expect(find.text('prueba ya disputada sin resultados'), findsOneWidget);
    expect(find.text('Prueba pasada'), findsOneWidget);
    expect(find.text('Accesos rápidos'), findsNothing);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
