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
import 'package:flutter_test/flutter_test.dart';
import 'package:pitwall/data/database/app_database.dart';
import 'package:pitwall/domain/generador_mangas.dart';
import 'package:pitwall/features/pruebas/repositorio_inscripciones_prueba.dart';
import 'package:pitwall/features/pruebas/repositorio_pruebas.dart';

void main() {
  test('individual: casa por piloto y crea su equipo si no lo tiene', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final cId = await db.into(db.campeonatos).insert(CampeonatosCompanion.insert(
        nombre: 'Test', formato: 'INDIVIDUAL', anio: 2026));
    final c = await (db.select(db.campeonatos)..where((t) => t.id.equals(cId)))
        .getSingle();
    Future<int> piloto(String n) async {
      final id = await db.into(db.pilotos).insert(PilotosCompanion.insert(nombre: n));
      await db.into(db.pilotoCampeonato).insert(PilotoCampeonatoCompanion.insert(
          pilotoId: id, campeonatoId: cId, categoria: 'BRONCE',
          creditosIniciales: 28, creditosActuales: 28));
      return id;
    }
    final conEquipo = await piloto('Javier Texido');
    await db.into(db.equipos).insert(EquiposCompanion.insert(
        campeonatoId: cId, nombre: 'Javier Teixido', copa: 'LMP',
        piloto1Id: conEquipo));
    final sinEquipo = await piloto('Artur Valero');

    final b = await BuscadorInscritos.cargar(db, c, ['LMP']);
    expect(b.equipo('JAVIER TEIXIDO'), isNotNull); // por nombre de equipo
    expect(b.equipo('JAVIER TEXIDO')?.piloto1Id, conEquipo); // por piloto
    expect(b.pilotoSinEquipo('ARTUR VALERO')?.id, sinEquipo);
    expect(await b.resolver('NADIE'), isNull);

    final eqId = await b.resolver('ARTUR VALERO');
    final eq = await (db.select(db.equipos)..where((t) => t.id.equals(eqId!)))
        .getSingle();
    expect(eq.piloto1Id, sinEquipo);
    expect(eq.copa, 'LMP');
    // no se duplica al volver a resolverlo
    expect(await b.resolver('ARTUR VALERO'), eqId);
    expect((await db.select(db.equipos).get()).length, 2);
  });

  test('aplicarGeneracion asigna carriles y pisters', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final cId = await db.into(db.campeonatos).insert(CampeonatosCompanion.insert(
        nombre: 'Test', formato: 'INDIVIDUAL', anio: 2026));
    final pId = await db.into(db.pruebas).insert(
        PruebasCompanion.insert(campeonatoId: cId, nombre: 'P1', orden: 1));
    final semillas = <EquipoSemilla>[];
    for (var i = 0; i < 16; i++) {
      final pil = await db.into(db.pilotos).insert(PilotosCompanion.insert(nombre: 'P$i'));
      final eq = await db.into(db.equipos).insert(EquiposCompanion.insert(
          campeonatoId: cId, nombre: 'P$i', copa: 'LMP', piloto1Id: pil));
      semillas.add(EquipoSemilla(equipoId: eq, nombre: 'P$i', copa: 'LMP',
          puntuacion: i, preferenciaDia: 'Jueves'));
    }
    final r = GeneradorMangas.generar(
        equipos: semillas,
        config: const ConfigGenerador(
            nombresMangas: ['Jueves 21:00', 'Jueves 21:48'], tamMaxManga: 6));
    await RepositorioInscripcionesPrueba(db).aplicarGeneracion(
        pruebaId: pId, mangasGeneradas: r.mangas, carrilesPorManga: 6,
        asignarCarriles: true, asignarPisters: true);

    final mangas = await db.select(db.mangas).get();
    expect(mangas.map((m) => m.numCarriles), [6, 6]);
    expect(mangas[0].pistersMangaId, mangas[1].id);
    expect(mangas[1].pistersMangaId, mangas[0].id);
    final ins = await (db.select(db.inscripciones)
          ..where((t) => t.mangaId.equals(mangas[1].id)))
        .get();
    // manga de 8 con 6 carriles: 1..6, D1, D2; el de más puntos en el 1
    expect(ins.map((i) => i.carrilSalida),
        ['1', '2', '3', '4', '5', '6', 'D1', 'D2']);
    final primero = await (db.select(db.equipos)
          ..where((t) => t.id.equals(ins.first.equipoId)))
        .getSingle();
    expect(primero.nombre, 'P15');
  });

  test('cambios a mano: mover, intercambiar y renumerar carriles', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final cId = await db.into(db.campeonatos).insert(CampeonatosCompanion.insert(
        nombre: 'Test', formato: 'INDIVIDUAL', anio: 2026));
    final pId = await db.into(db.pruebas).insert(
        PruebasCompanion.insert(campeonatoId: cId, nombre: 'P1', orden: 1));
    final m1 = await db.into(db.mangas).insert(MangasCompanion.insert(
        pruebaId: pId, nombre: 'Jueves 21:00', numCarriles: const Value(2)));
    final m2 = await db.into(db.mangas).insert(
        MangasCompanion.insert(pruebaId: pId, nombre: 'Jueves 22:00'));
    final repo = RepositorioInscripciones(db);
    final ins = <int>[];
    for (final (nombre, pts) in [('A', 10), ('B', 30), ('C', 20)]) {
      final pil = await db.into(db.pilotos).insert(PilotosCompanion.insert(nombre: nombre));
      await db.into(db.pilotoCampeonato).insert(PilotoCampeonatoCompanion.insert(
          pilotoId: pil, campeonatoId: cId, categoria: 'BRONCE',
          creditosIniciales: 28, creditosActuales: 28,
          saldoTemporadaAnterior: Value(pts)));
      final eq = await db.into(db.equipos).insert(EquiposCompanion.insert(
          campeonatoId: cId, nombre: nombre, copa: 'LMP', piloto1Id: pil));
      ins.add(await repo.inscribir(mangaId: m1, equipoId: eq, carrilSalida: nombre));
    }
    Future<Map<int, String?>> carriles() async => {
          for (final i in await db.select(db.inscripciones).get())
            i.id: i.carrilSalida
        };

    await repo.renumerarCarriles(m1); // 2 carriles: B=1, C=2, A=D1
    expect(await carriles(), {ins[0]: 'D1', ins[1]: '1', ins[2]: '2'});

    await repo.intercambiarCarril(ins[0], ins[1]);
    expect(await carriles(), {ins[0]: '1', ins[1]: 'D1', ins[2]: '2'});

    await repo.moverAManga(ins[2], m2);
    final movida = await (db.select(db.inscripciones)
          ..where((t) => t.id.equals(ins[2])))
        .getSingle();
    expect(movida.mangaId, m2);
    expect(movida.carrilSalida, isNull);

    await RepositorioMangas(db).cambiarPisters(m1, m2);
    await RepositorioMangas(db).borrar(m2);
    final queda = await (db.select(db.mangas)..where((t) => t.id.equals(m1)))
        .getSingle();
    expect(queda.pistersMangaId, isNull);
  });

  test('dar de baja quita de Inscritos y de la manga; quitar de manga desasigna',
      () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final cId = await db.into(db.campeonatos).insert(CampeonatosCompanion.insert(
        nombre: 'Test', formato: 'INDIVIDUAL', anio: 2026));
    final pId = await db.into(db.pruebas).insert(
        PruebasCompanion.insert(campeonatoId: cId, nombre: 'P1', orden: 1));
    final mId = await db.into(db.mangas).insert(
        MangasCompanion.insert(pruebaId: pId, nombre: 'Jueves 21:00'));
    final repoPrueba = RepositorioInscripcionesPrueba(db);
    final repoManga = RepositorioInscripciones(db);
    final eqs = <int>[];
    for (final n in ['A', 'B']) {
      final pil = await db.into(db.pilotos).insert(PilotosCompanion.insert(nombre: n));
      final eq = await db.into(db.equipos).insert(EquiposCompanion.insert(
          campeonatoId: cId, nombre: n, copa: 'LMP', piloto1Id: pil));
      await repoPrueba.inscribir(pruebaId: pId, equipoId: eq);
      await repoPrueba.marcarAsignada(
          (await db.select(db.inscripcionesPrueba).get()).last.id, true);
      await repoManga.inscribir(mangaId: mId, equipoId: eq, carrilSalida: n);
      eqs.add(eq);
    }

    await repoPrueba.darDeBaja(pruebaId: pId, equipoId: eqs[0]);
    expect((await db.select(db.inscripcionesPrueba).get()).map((i) => i.equipoId),
        [eqs[1]]);
    expect((await db.select(db.inscripciones).get()).map((i) => i.equipoId),
        [eqs[1]]);

    final insB = (await db.select(db.inscripciones).get()).single;
    await repoManga.quitar(insB.id);
    expect(await db.select(db.inscripciones).get(), isEmpty);
    expect((await db.select(db.inscripcionesPrueba).get()).single.asignada,
        isFalse);
  });
}
