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
import 'package:intl/intl.dart';
import 'package:pitwall/core/proveedores.dart';
import 'package:pitwall/data/database/app_database.dart';
import 'package:pitwall/features/tesoreria/fila_pago_equipo.dart';
import 'package:pitwall/features/tesoreria/repositorio_tesoreria.dart';

void main() {
  testWidgets('pago rápido usa las cuotas del campeonato indicado y guarda',
      (tester) async {
    await initializeDateFormatting('es_ES');
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    late Campeonato camp;
    late int pruebaId, equipoId;
    late PagoEquipo pago;
    final c = ProviderContainer(overrides: [dbProvider.overrideWithValue(db)]);
    addTearDown(c.dispose);
    await tester.runAsync(() async {
      final campId = await db.into(db.campeonatos).insert(
          CampeonatosCompanion.insert(
              nombre: 'Liga',
              formato: 'INDIVIDUAL',
              anio: 2026,
              cuotaPagat: const Value(10),
              cuotaCoordinadora: const Value(3),
              cuotaClub: const Value(7)));
      camp = await (db.select(db.campeonatos)
            ..where((t) => t.id.equals(campId)))
          .getSingle();
      pruebaId = await db.into(db.pruebas).insert(PruebasCompanion.insert(
          campeonatoId: campId, nombre: 'Prueba 1', orden: 1));
      final p = await db
          .into(db.pilotos)
          .insert(PilotosCompanion.insert(nombre: 'Ana'));
      equipoId = await db.into(db.equipos).insert(EquiposCompanion.insert(
          campeonatoId: campId, nombre: 'Ana', copa: 'GT', piloto1Id: p));
      await db.into(db.inscripcionesPrueba).insert(
          InscripcionesPruebaCompanion.insert(
              pruebaId: pruebaId, equipoId: equipoId));
      c.listen(pagosPruebaProvider(pruebaId), (_, _) {});
      pago = (await c.read(pagosPruebaProvider(pruebaId).future)).single;
    });

    // Sin campeonato activo: las cuotas salen del campeonato pasado.
    await tester.pumpWidget(UncontrolledProviderScope(
      container: c,
      child: MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: FilaPagoEquipo(
              pruebaId: pruebaId,
              pago: pago,
              eur: NumberFormat.currency(locale: 'es_ES', symbol: '€'),
              campeonato: camp,
            ),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('10 / 3 / 7'));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pump();

    final guardado = await tester.runAsync(() => db.select(db.pagos).get());
    expect(guardado!.single.pagat, 10);
    expect(guardado.single.coordinadora, 3);
    expect(guardado.single.club, 7);
    expect(guardado.single.equipoId, equipoId);
    await tester.runAsync(() => db.close());
  });
}
