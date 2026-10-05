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
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pitwall/core/proveedores.dart';
import 'package:pitwall/data/database/app_database.dart';
import 'package:pitwall/features/tesoreria/repositorio_tesoreria.dart';

void main() {
  late AppDatabase db;
  late RepositorioTesoreria repo;
  late ProviderContainer container;
  late int campId, pruebaId, equipoA, equipoB;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = RepositorioTesoreria(db);
    container =
        ProviderContainer(overrides: [dbProvider.overrideWithValue(db)]);
    campId = await db.into(db.campeonatos).insert(CampeonatosCompanion.insert(
        nombre: 'Test', formato: 'PAREJAS', anio: 2026));
    pruebaId = await db.into(db.pruebas).insert(PruebasCompanion.insert(
        campeonatoId: campId, nombre: 'Prueba 1', orden: 1));
    Future<int> equipo(String nombre) async {
      final p1 = await db
          .into(db.pilotos)
          .insert(PilotosCompanion.insert(nombre: '$nombre 1'));
      final p2 = await db
          .into(db.pilotos)
          .insert(PilotosCompanion.insert(nombre: '$nombre 2'));
      final id = await db.into(db.equipos).insert(EquiposCompanion.insert(
          campeonatoId: campId,
          nombre: nombre,
          copa: 'GT',
          piloto1Id: p1,
          piloto2Id: Value(p2)));
      await db.into(db.inscripcionesPrueba).insert(
          InscripcionesPruebaCompanion.insert(
              pruebaId: pruebaId, equipoId: id));
      return id;
    }

    equipoA = await equipo('A');
    equipoB = await equipo('B');
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  Future<List<PagoEquipo>> pagos() {
    container.listen(pagosPruebaProvider(pruebaId), (_, _) {});
    container.invalidate(pagosPruebaProvider(pruebaId));
    return container.read(pagosPruebaProvider(pruebaId).future);
  }

  Future<List<ResumenPruebaPagos>> resumen() async {
    final camp = await (db.select(db.campeonatos)
          ..where((t) => t.id.equals(campId)))
        .getSingle();
    container.read(campeonatoActivoProvider.notifier).seleccionar(camp);
    container.listen(tesoreriaCampeonatoProvider, (_, _) {});
    container.invalidate(tesoreriaCampeonatoProvider);
    return container.read(tesoreriaCampeonatoProvider.future);
  }

  test('repartir respeta la proporción y siempre cuadra', () {
    expect(repartir(25, cuotaCoordinadora: 11, cuotaClub: 14), (11.0, 14.0));
    expect(repartir(12.5, cuotaCoordinadora: 11, cuotaClub: 14), (5.5, 7.0));
    final (c, cl) = repartir(10, cuotaCoordinadora: 1, cuotaClub: 2);
    expect(c + cl, closeTo(10, 0.001));
    expect(repartir(10, cuotaCoordinadora: 0, cuotaClub: 0), (0.0, 10.0));
    expect(repartir(0, cuotaCoordinadora: 11, cuotaClub: 14), (0.0, 0.0));
  });

  test('"Coord. total" queda guardado como exento y cuenta como saldado',
      () async {
    await repo.guardarPago(
        pruebaId: pruebaId, equipoId: equipoA, pagat: 25, coordinadora: 11,
        club: 14);
    await repo.marcarCoordinadora(
        pruebaId: pruebaId, equipoId: equipoA, exento: true);

    final lista = await pagos();
    final a = lista.firstWhere((p) => p.equipoId == equipoA);
    expect(a.exento, isTrue);
    expect(a.exentoCoordinadora, isTrue);
    expect(a.motivoExencion, 'Pilotos de coordinadora');
    expect(a.saldado, isTrue);
    // El pago previo se borra, como con el wildcard.
    expect(a.pago, isNull);

    final r = (await resumen()).single;
    expect(r.exentos, 1);
    expect(r.pagados, 0);
    expect(r.sumaPagat, 0);

    // Se puede deshacer.
    await repo.marcarCoordinadora(
        pruebaId: pruebaId, equipoId: equipoA, exento: false);
    final a2 = (await pagos()).firstWhere((p) => p.equipoId == equipoA);
    expect(a2.exento, isFalse);
  });

  test('el resumen ignora pagos de equipos exentos o no inscritos', () async {
    await repo.guardarPago(
        pruebaId: pruebaId, equipoId: equipoB, pagat: 25, coordinadora: 11,
        club: 14);
    // Pago huérfano: equipo que ya no está inscrito en la prueba.
    final huerfano = await db.into(db.equipos).insert(EquiposCompanion.insert(
        campeonatoId: campId,
        nombre: 'C',
        copa: 'GT',
        piloto1Id: (await pagos()).first.piloto1.id));
    await repo.guardarPago(
        pruebaId: pruebaId, equipoId: huerfano, pagat: 25, coordinadora: 11,
        club: 14);

    final r = (await resumen()).single;
    expect(r.totalEquipos, 2);
    expect(r.pagados, 1);
    expect(r.sumaPagat, 25);
    expect(r.sumaCoordinadora, 11);
    expect(r.sumaClub, 14);
  });

  test('guardarReparto cambia la cuota y, si se pide, redistribuye pagos',
      () async {
    await repo.guardarPago(
        pruebaId: pruebaId, equipoId: equipoA, pagat: 25, coordinadora: 11,
        club: 14);
    await repo.guardarPago(
        pruebaId: pruebaId, equipoId: equipoB, pagat: 12.5, coordinadora: 5.5,
        club: 7);

    // Sin recalcular: los pagos no cambian.
    var n = await repo.guardarReparto(
        campeonatoId: campId, pagat: 30, coordinadora: 10, club: 20);
    expect(n, 0);
    final camp = await (db.select(db.campeonatos)
          ..where((t) => t.id.equals(campId)))
        .getSingle();
    expect(
        (camp.cuotaPagat, camp.cuotaCoordinadora, camp.cuotaClub),
        (30.0, 10.0, 20.0));
    var lista = await pagos();
    expect(lista.firstWhere((p) => p.equipoId == equipoA).pago!.coordinadora,
        11);

    // Recalculando: un tercio a coordinadora, lo pagado se mantiene.
    n = await repo.guardarReparto(
        campeonatoId: campId,
        pagat: 30,
        coordinadora: 10,
        club: 20,
        recalcularPagos: true);
    expect(n, 2);
    lista = await pagos();
    final a = lista.firstWhere((p) => p.equipoId == equipoA).pago!;
    expect((a.pagat, a.coordinadora, a.club), (25.0, 8.33, 16.67));
    final b = lista.firstWhere((p) => p.equipoId == equipoB).pago!;
    expect(b.pagat, 12.5);
    expect(b.coordinadora + b.club, closeTo(12.5, 0.001));
  });
}
