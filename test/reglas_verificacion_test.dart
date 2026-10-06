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
import 'package:drift/drift.dart' show BooleanExpressionOperators, Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pitwall/data/database/app_database.dart';
import 'package:pitwall/domain/reglas_verificacion.dart';
import 'package:pitwall/features/campeonatos/repositorio_coches_campeonato.dart';
import 'package:pitwall/features/verificaciones/reglas_verificacion_bd.dart';
import 'package:pitwall/features/verificaciones/repositorio_verificaciones.dart';

/// Campeonato con créditos, una prueba en curso, una manga, un equipo de
/// copa GT (piloto con 10 créditos) y un coche de catálogo de 20 g y -2
/// créditos.
Future<
    ({
      int camp,
      int prueba,
      int manga,
      int equipo,
      int piloto,
      int coche,
    })> _escenario(AppDatabase db) async {
  final camp = await db.into(db.campeonatos).insert(
      CampeonatosCompanion.insert(
          nombre: 'Liga',
          formato: 'INDIVIDUAL',
          anio: 2026,
          copasJson: const Value('["GT"]'),
          anchuraEjeJson: const Value('{"GT": {"del": 65.0}}')));
  final prueba = await db.into(db.pruebas).insert(PruebasCompanion.insert(
      campeonatoId: camp,
      nombre: 'P1',
      orden: 1,
      estado: const Value('EN_CURSO')));
  final manga = await db
      .into(db.mangas)
      .insert(MangasCompanion.insert(pruebaId: prueba, nombre: 'Jueves'));
  final piloto =
      await db.into(db.pilotos).insert(PilotosCompanion.insert(nombre: 'Ana'));
  await db.into(db.pilotoCampeonato).insert(PilotoCampeonatoCompanion.insert(
      pilotoId: piloto,
      campeonatoId: camp,
      categoria: 'ORO',
      creditosIniciales: 10,
      creditosActuales: 10));
  final equipo = await db.into(db.equipos).insert(EquiposCompanion.insert(
      campeonatoId: camp, nombre: 'Ana', copa: 'GT', piloto1Id: piloto));
  await db.into(db.inscripcionesPrueba).insert(
      InscripcionesPruebaCompanion.insert(pruebaId: prueba, equipoId: equipo));
  final coche = await db.into(db.catalogoCoches).insert(
      CatalogoCochesCompanion.insert(
          nombre: 'BMW M8',
          marca: 'SCA',
          modelo: 'M8',
          pesoMin: 20,
          creditosCoche: const Value(-2),
          copasJson: const Value('["GT"]')));
  return (
    camp: camp,
    prueba: prueba,
    manga: manga,
    equipo: equipo,
    piloto: piloto,
    coche: coche,
  );
}

Future<int> _creditos(AppDatabase db, int piloto, int camp) async =>
    (await (db.select(db.pilotoCampeonato)
              ..where((t) =>
                  t.pilotoId.equals(piloto) & t.campeonatoId.equals(camp)))
            .getSingle())
        .creditosActuales;

void main() {
  group('ReglasVerificacion', () {
    const congeladas = ReglasVerificacion(
      fechaMs: 1,
      copa: 'GT',
      cocheId: 1,
      cocheNombre: 'BMW',
      pesoMin: 20,
      creditosCoche: -2,
      anchuraEjeDelMax: 65,
      marcasValidas: {'SIT', 'SCA'},
    );
    const actuales = ReglasVerificacion(
      fechaMs: 2,
      copa: 'GT',
      cocheId: 1,
      cocheNombre: 'BMW',
      pesoMin: 22,
      creditosCoche: -2,
      anchuraEjeDelMax: 64,
      marcasValidas: {'SIT', 'SCA', 'NSR'},
    );

    test('ida y vuelta por JSON', () {
      final r = ReglasVerificacion.decodificar(congeladas.codificar())!;
      expect(r.toJson(), congeladas.toJson());
      expect(ReglasVerificacion.decodificar(null), isNull);
      expect(ReglasVerificacion.decodificar('no es json'), isNull);
    });

    test('combinar solo rehace la parte indicada', () {
      final soloCoche = congeladas.combinar(actuales, coche: true);
      expect(soloCoche.pesoMin, 22);
      expect(soloCoche.anchuraEjeDelMax, 65, reason: 'la copa sigue congelada');
      final nada = congeladas.combinar(actuales);
      expect(nada.toJson(), congeladas.toJson());
    });

    test('diferencias legibles', () {
      final d = congeladas.diferenciasCon(actuales);
      expect(d, contains('Peso mínimo: 20 g (ahora 22 g)'));
      expect(d, contains('Eje delantero máx.: 65 mm (ahora 64 mm)'));
      expect(d.any((x) => x.contains('añadidas: NSR')), isTrue);
      expect(congeladas.diferenciasCon(congeladas), isEmpty);
    });
  });

  test('motivoBloqueo: campeonato finalizado o prueba terminada', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final e = await _escenario(db);
    Future<String?> motivo() async {
      final c = await (db.select(db.campeonatos)
            ..where((t) => t.id.equals(e.camp)))
          .getSingle();
      final p = await (db.select(db.pruebas)
            ..where((t) => t.id.equals(e.prueba)))
          .getSingle();
      return motivoBloqueo(c, p);
    }

    expect(await motivo(), isNull);
    await (db.update(db.pruebas)..where((t) => t.id.equals(e.prueba)))
        .write(const PruebasCompanion(estado: Value('TERMINADA')));
    expect(await motivo(), contains('prueba'));
    await (db.update(db.campeonatos)..where((t) => t.id.equals(e.camp)))
        .write(const CampeonatosCompanion(finalizado: Value(true)));
    expect(await motivo(), contains('campeonato'));
    await db.close();
  });

  test('el valor fijado en el campeonato manda sobre el catálogo', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final e = await _escenario(db);
    Future<ReglasVerificacion> reglas() => CargadorReglas(db).actuales(
        mangaId: e.manga, equipoId: e.equipo, cocheId: e.coche);

    var r = await reglas();
    expect(r.pesoMin, 20);
    expect(r.creditosCoche, -2);
    expect(r.copa, 'GT');
    expect(r.anchuraEjeDelMax, 65);

    final repo = RepositorioCochesCampeonato(db);
    expect(await repo.fijarDesdeCatalogo(e.camp), 1);
    // Cambia el catálogo (temporada siguiente): este campeonato no se entera.
    await (db.update(db.catalogoCoches)..where((t) => t.id.equals(e.coche)))
        .write(const CatalogoCochesCompanion(
            pesoMin: Value(25), creditosCoche: Value(-5)));
    r = await reglas();
    expect(r.pesoMin, 20);
    expect(r.creditosCoche, -2);

    // Solo el peso fijado a mano; los créditos fijados se mantienen.
    await repo.fijar(e.camp, e.coche, pesoMin: 21, creditos: null);
    r = await reglas();
    expect(r.pesoMin, 21);
    expect(r.creditosCoche, -5, reason: 'créditos sin fijar = catálogo');

    await repo.quitarTodos(e.camp);
    expect((await reglas()).pesoMin, 25);
    await db.close();
  });

  test('los créditos se recalculan con los congelados, no con el catálogo',
      () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final e = await _escenario(db);
    final repo = RepositorioVerificaciones(db);
    final reglas = await CargadorReglas(db).actuales(
        mangaId: e.manga, equipoId: e.equipo, cocheId: e.coche);
    final id = await repo.guardar(
      mangaId: e.manga,
      equipoId: e.equipo,
      cocheCatalogoId: e.coche,
      pesoMin: reglas.pesoMin,
      validado: true,
      reglasJson: reglas.codificar(),
    );
    expect(await _creditos(db, e.piloto, e.camp), 8);

    // El catálogo cambia y la verificación se vuelve a guardar validada
    // (p. ej. llega por la sincronización): los créditos no se mueven.
    await (db.update(db.catalogoCoches)..where((t) => t.id.equals(e.coche)))
        .write(const CatalogoCochesCompanion(creditosCoche: Value(-6)));
    await repo.recalcularCreditos(id);
    expect(await _creditos(db, e.piloto, e.camp), 8);
    await db.close();
  });

  test('relleno al arrancar: conserva el peso mínimo guardado e idempotente',
      () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final e = await _escenario(db);
    // Verificación antigua: sin reglas_json y con el mínimo de entonces.
    final id = await db.into(db.verificaciones).insert(
        VerificacionesCompanion.insert(
            mangaId: e.manga,
            equipoId: e.equipo,
            cocheCatalogoId: Value(e.coche),
            pesoMin: const Value(18),
            validado: const Value(true)));

    expect(await rellenarReglasPendientes(db), 1);
    final v = await (db.select(db.verificaciones)
          ..where((t) => t.id.equals(id)))
        .getSingle();
    final r = ReglasVerificacion.decodificar(v.reglasJson)!;
    expect(r.pesoMin, 18, reason: 'el mínimo con el que se verificó');
    expect(r.creditosCoche, -2);
    expect(r.cocheNombre, 'BMW M8');
    expect(v.modificadoMs, isNull, reason: 'no es un cambio a sincronizar');

    expect(await rellenarReglasPendientes(db), 0);
    await db.close();
  });
}
