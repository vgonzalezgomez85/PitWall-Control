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
import 'package:pitwall/core/proveedores.dart';
import 'package:pitwall/data/database/app_database.dart';
import 'package:excel/excel.dart';
import 'package:pitwall/features/verificaciones/exportar_rejilla_verificaciones.dart';
import 'package:pitwall/features/verificaciones/pantalla_rejilla_verificaciones.dart';

void main() {
  testWidgets('la rejilla muestra inscritos, estado e infracciones',
      (tester) async {
    tester.view.physicalSize = const Size(1600, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final db = AppDatabase.forTesting(NativeDatabase.memory());
    late Campeonato camp;
    await tester.runAsync(() async {
      final campId = await db.into(db.campeonatos).insert(
          CampeonatosCompanion.insert(
              nombre: 'Test',
              formato: 'INDIVIDUAL',
              anio: 2026,
              anchuraEjeJson: const Value('{"GT": {"del": 65.0}}')));
      camp = await (db.select(db.campeonatos)
            ..where((t) => t.id.equals(campId)))
          .getSingle();
      final prueba = await db.into(db.pruebas).insert(PruebasCompanion.insert(
          campeonatoId: campId,
          nombre: 'Prueba 1',
          orden: 1,
          estado: const Value('EN_CURSO')));
      final manga = await db.into(db.mangas).insert(
          MangasCompanion.insert(pruebaId: prueba, nombre: 'Jueves'));
      Future<int> equipo(String nombre) async {
        final p = await db
            .into(db.pilotos)
            .insert(PilotosCompanion.insert(nombre: nombre));
        final e = await db.into(db.equipos).insert(EquiposCompanion.insert(
            campeonatoId: campId, nombre: nombre, copa: 'GT', piloto1Id: p));
        await db.into(db.inscripcionesPrueba).insert(
            InscripcionesPruebaCompanion.insert(
                pruebaId: prueba, equipoId: e));
        return e;
      }

      final ana = await equipo('Ana');
      await equipo('Bruno');
      await db.into(db.verificaciones).insert(VerificacionesCompanion.insert(
            mangaId: manga,
            equipoId: ana,
            pesoInicial: const Value(20),
            pesoMin: const Value(22),
            anchuraEjeDel: const Value(66),
            pinonDientes: const Value(12),
            validado: const Value(true),
          ));
    });

    final contenedor =
        ProviderContainer(overrides: [dbProvider.overrideWithValue(db)]);
    addTearDown(contenedor.dispose);
    contenedor.read(campeonatoActivoProvider.notifier).seleccionar(camp);
    await tester.pumpWidget(UncontrolledProviderScope(
      container: contenedor,
      child: const MaterialApp(home: PantallaRejillaVerificaciones()),
    ));
    for (var i = 0; i < 5; i++) {
      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 50)));
      await tester.pump();
    }

    expect(find.text('Ana'), findsOneWidget);
    expect(find.text('Bruno'), findsOneWidget);
    expect(find.text('Validada'), findsOneWidget);
    expect(find.text('Sin verificar'), findsWidgets);
    expect(find.text('Con infracción (1)'), findsOneWidget);
    expect(find.byTooltip('Por debajo del mínimo de 22 g'), findsOneWidget);
    expect(find.byTooltip('Supera el máximo de 65 mm'), findsOneWidget);
    expect(tester.takeException(), isNull);

    // Desmontar la pantalla y dejar que drift cierre sus streams (la BD es
    // en memoria; cerrarla aquí deja el test colgado).
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });

  test('exporta la rejilla a Excel y a PDF', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final campId = await db.into(db.campeonatos).insert(
        CampeonatosCompanion.insert(
            nombre: 'Test', formato: 'INDIVIDUAL', anio: 2026));
    final camp = await (db.select(db.campeonatos)
          ..where((t) => t.id.equals(campId)))
        .getSingle();
    final pruebaId = await db.into(db.pruebas).insert(PruebasCompanion.insert(
        campeonatoId: campId, nombre: 'El Sot: 1/3', orden: 1));
    final prueba = await (db.select(db.pruebas)
          ..where((t) => t.id.equals(pruebaId)))
        .getSingle();
    final manga = await db.into(db.mangas).insert(
        MangasCompanion.insert(pruebaId: pruebaId, nombre: 'Jueves'));
    final p = await db
        .into(db.pilotos)
        .insert(PilotosCompanion.insert(nombre: 'Ana'));
    final e = await db.into(db.equipos).insert(EquiposCompanion.insert(
        campeonatoId: campId, nombre: 'Ana', copa: 'GT', piloto1Id: p));
    await db.into(db.verificaciones).insert(VerificacionesCompanion.insert(
        mangaId: manga,
        equipoId: e,
        pesoInicial: const Value(20),
        pesoMin: const Value(22),
        observaciones: const Value('Todo correcto — revisar ✓')));

    final filas = await cargarRejilla(db, camp, pruebaId);
    expect(filas, hasLength(1));

    final xlsx =
        generarExcelRejilla(filas: filas, campeonato: camp, prueba: prueba);
    final libro = Excel.decodeBytes(xlsx);
    expect(libro.tables.keys, ['El Sot 1 3']);
    final hoja = libro.tables['El Sot 1 3']!;
    expect(hoja.rows.first.first?.value.toString(), 'Piloto / equipo');
    expect(hoja.rows[1].first?.value.toString(), 'Ana');
    expect(hoja.rows[1].last?.value.toString(),
        contains('Por debajo del mínimo de 22 g'));

    final pdf = await generarPdfRejilla(
        filas: filas, campeonato: camp, prueba: prueba);
    expect(String.fromCharCodes(pdf.take(4)), '%PDF');
    await db.close();
  });
}
