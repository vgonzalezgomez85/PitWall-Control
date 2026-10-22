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
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pitwall/data/database/app_database.dart';
import 'package:pitwall/features/pruebas/repositorio_pruebas.dart';

void main() {
  late AppDatabase db;
  late int pruebaId, mangaId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    final camp = await db.into(db.campeonatos).insert(
        CampeonatosCompanion.insert(
            nombre: 'Test', formato: 'INDIVIDUAL', anio: 2026));
    pruebaId = await db.into(db.pruebas).insert(PruebasCompanion.insert(
        campeonatoId: camp, nombre: 'Prueba 1', orden: 1));
    mangaId = await db.into(db.mangas).insert(MangasCompanion.insert(
        pruebaId: pruebaId,
        nombre: 'Jueves 21:00',
        numCarriles: const Value(6)));
  });

  tearDown(() => db.close());

  Future<void> inscribir(int n, {bool conCarril = false}) async {
    final camp = (await db.select(db.pruebas).getSingle()).campeonatoId;
    for (var k = 1; k <= n; k++) {
      final p = await db
          .into(db.pilotos)
          .insert(PilotosCompanion.insert(nombre: 'Piloto ${k.toString().padLeft(2, '0')}'));
      final eq = await db.into(db.equipos).insert(EquiposCompanion.insert(
          campeonatoId: camp,
          nombre: 'Piloto ${k.toString().padLeft(2, '0')}',
          copa: 'GT',
          piloto1Id: p));
      await db.into(db.inscripciones).insert(InscripcionesCompanion.insert(
          mangaId: mangaId,
          equipoId: eq,
          carrilSalida: Value(conCarril ? '$k' : null)));
    }
  }

  Future<List<Inscripcione>> de(int id) =>
      (db.select(db.inscripciones)..where((t) => t.mangaId.equals(id))).get();

  test('12 en una tanda de 6 carriles se parten en 6 + 6', () async {
    await inscribir(12);
    final nueva = await RepositorioInscripciones(db)
        .dividirManga(mangaId, nombreNueva: 'Jueves 21:36');
    expect(await de(mangaId), hasLength(6));
    expect(await de(nueva), hasLength(6));
    final m = await (db.select(db.mangas)..where((t) => t.id.equals(nueva)))
        .getSingle();
    expect(m.nombre, 'Jueves 21:36');
    expect(m.numCarriles, 6);
    expect(m.pruebaId, pruebaId);
    // Sin carriles asignados antes, siguen sin carril.
    expect((await de(nueva)).every((i) => i.carrilSalida == null), isTrue);
  });

  test('11 con 6 carriles: 5 + 6 y se renumeran los carriles', () async {
    await inscribir(11, conCarril: true);
    final nueva = await RepositorioInscripciones(db)
        .dividirManga(mangaId, nombreNueva: 'B');
    final quedan = await de(mangaId);
    final pasan = await de(nueva);
    expect(quedan, hasLength(5));
    expect(pasan, hasLength(6));
    expect(pasan.map((i) => i.carrilSalida).toSet(),
        {'1', '2', '3', '4', '5', '6'});
    expect(quedan.map((i) => i.carrilSalida).toSet(),
        {'1', '2', '3', '4', '5'});
  });

  test('con menos de 2 no se divide', () async {
    await inscribir(1);
    expect(
        () => RepositorioInscripciones(db)
            .dividirManga(mangaId, nombreNueva: 'B'),
        throwsStateError);
  });
}
