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
import 'package:flutter_test/flutter_test.dart';
import 'package:pitwall/data/database/app_database.dart';
import 'package:pitwall/features/pruebas/repositorio_pruebas.dart';

void main() {
  late AppDatabase db;
  late int pruebaId, mangaId, equipoId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    final camp = await db.into(db.campeonatos).insert(
        CampeonatosCompanion.insert(
            nombre: 'Test', formato: 'INDIVIDUAL', anio: 2026));
    pruebaId = await db.into(db.pruebas).insert(PruebasCompanion.insert(
        campeonatoId: camp, nombre: 'Prueba 1', orden: 1));
    mangaId = await db.into(db.mangas).insert(
        MangasCompanion.insert(pruebaId: pruebaId, nombre: 'Jueves 21:00'));
    final piloto = await db
        .into(db.pilotos)
        .insert(PilotosCompanion.insert(nombre: 'Piloto Manual'));
    equipoId = await db.into(db.equipos).insert(EquiposCompanion.insert(
        campeonatoId: camp,
        nombre: 'Piloto Manual',
        copa: 'GT',
        piloto1Id: piloto));
  });

  tearDown(() => db.close());

  Future<List<InscripcionesPruebaData>> inscritosPrueba() =>
      (db.select(db.inscripcionesPrueba)
            ..where((t) => t.pruebaId.equals(pruebaId)))
          .get();

  test('inscribir en una manga inscribe también en la prueba', () async {
    final repo = RepositorioInscripciones(db);
    await repo.inscribir(mangaId: mangaId, equipoId: equipoId);
    final ins = await inscritosPrueba();
    expect(ins.map((i) => i.equipoId), [equipoId]);

    // Una segunda manga de la misma prueba no duplica.
    final manga2 = await db.into(db.mangas).insert(
        MangasCompanion.insert(pruebaId: pruebaId, nombre: 'Sábado 10:00'));
    await repo.inscribir(mangaId: manga2, equipoId: equipoId);
    expect(await inscritosPrueba(), hasLength(1));
  });

  test('la reparación añade a la prueba los inscritos solo en manga',
      () async {
    await db.into(db.inscripciones).insert(InscripcionesCompanion.insert(
        mangaId: mangaId, equipoId: equipoId));
    final repo = RepositorioInscripciones(db);
    expect(await repo.repararInscripcionesPrueba(), 1);
    expect(await inscritosPrueba(), hasLength(1));
    expect(await repo.repararInscripcionesPrueba(), 0);
  });
}
