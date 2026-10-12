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
import 'package:pitwall/data/database/sync_triggers.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    AppDatabase.nombreDispositivo = () => 'Mesa 1';
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });
  tearDown(() => db.close());

  Future<Piloto> piloto(int id) =>
      (db.select(db.pilotos)..where((t) => t.id.equals(id))).getSingle();

  test('una alta recibe uuid y queda firmada por este dispositivo', () async {
    final id = await db
        .into(db.pilotos)
        .insert(PilotosCompanion.insert(nombre: 'Ana'));
    final p = await piloto(id);
    expect(p.uuid, isNotNull);
    expect(p.uuid!.length, 32);
    expect(p.modPor, 'Mesa 1');
    expect(p.modMs, greaterThan(DateTime(2026).millisecondsSinceEpoch));
  });

  test('un cambio se firma; uno con la marca remota no', () async {
    final id = await db
        .into(db.pilotos)
        .insert(PilotosCompanion.insert(nombre: 'Ana'));
    await (db.update(db.pilotos)..where((t) => t.id.equals(id)))
        .write(const PilotosCompanion(modMs: Value(1), modPor: Value('x')));
    // Cambio local de un campo sincronizable: se vuelve a firmar.
    await (db.update(db.pilotos)..where((t) => t.id.equals(id)))
        .write(const PilotosCompanion(telefono: Value('600')));
    var p = await piloto(id);
    expect(p.modPor, 'Mesa 1');
    expect(p.modMs, greaterThan(1));

    // Lo que hace el fusionador: dato + marca remota a la vez.
    await (db.update(db.pilotos)..where((t) => t.id.equals(id))).write(
        const PilotosCompanion(
            nombre: Value('Ana B'), modMs: Value(5), modPor: Value('Tablet')));
    p = await piloto(id);
    expect(p.nombre, 'Ana B');
    expect((p.modMs, p.modPor), (5, 'Tablet'));
  });

  test('los créditos no firman el perfil; la categoría sí', () async {
    final campId = await db.into(db.campeonatos).insert(
        CampeonatosCompanion.insert(
            nombre: 'Liga', formato: 'PAREJAS', anio: 2026));
    final pid = await db
        .into(db.pilotos)
        .insert(PilotosCompanion.insert(nombre: 'Ana'));
    await db.into(db.pilotoCampeonato).insert(PilotoCampeonatoCompanion.insert(
        pilotoId: pid,
        campeonatoId: campId,
        categoria: 'BRONCE',
        creditosIniciales: 100,
        creditosActuales: 100));
    Future<PilotoCampeonatoData> perfil() => (db.select(db.pilotoCampeonato)
          ..where((t) => t.pilotoId.equals(pid)))
        .getSingle();
    await (db.update(db.pilotoCampeonato)..where((t) => t.pilotoId.equals(pid)))
        .write(const PilotoCampeonatoCompanion(modMs: Value(1)));
    await (db.update(db.pilotoCampeonato)..where((t) => t.pilotoId.equals(pid)))
        .write(const PilotoCampeonatoCompanion(creditosActuales: Value(80)));
    expect((await perfil()).modMs, 1);
    await (db.update(db.pilotoCampeonato)..where((t) => t.pilotoId.equals(pid)))
        .write(const PilotoCampeonatoCompanion(categoria: Value('PLATA')));
    expect((await perfil()).modMs, greaterThan(1));
  });

  test('los borrados se apuntan con una clave portable', () async {
    final campId = await db.into(db.campeonatos).insert(
        CampeonatosCompanion.insert(
            nombre: 'Liga', formato: 'PAREJAS', anio: 2026));
    final pruebaId = await db.into(db.pruebas).insert(
        PruebasCompanion.insert(campeonatoId: campId, nombre: 'P1', orden: 1));
    final pid = await db
        .into(db.pilotos)
        .insert(PilotosCompanion.insert(nombre: 'Ana'));
    final eid = await db.into(db.equipos).insert(EquiposCompanion.insert(
        campeonatoId: campId, nombre: 'Rojo', copa: 'GT', piloto1Id: pid));
    final insId = await db.into(db.inscripcionesPrueba).insert(
        InscripcionesPruebaCompanion.insert(pruebaId: pruebaId, equipoId: eid));
    final equipo = await (db.select(db.equipos)..where((t) => t.id.equals(eid)))
        .getSingle();
    final prueba = await (db.select(db.pruebas)
          ..where((t) => t.id.equals(pruebaId)))
        .getSingle();

    await (db.delete(db.inscripcionesPrueba)..where((t) => t.id.equals(insId)))
        .go();
    await (db.delete(db.equipos)..where((t) => t.id.equals(eid))).go();

    final reg = await db.select(db.borradosRegistro).get();
    expect(
        reg.map((r) => (r.tabla, r.clave, r.borradoPor)),
        unorderedEquals([
          ('inscripciones_prueba', '${prueba.uuid}|${equipo.uuid}', 'Mesa 1'),
          ('equipos', equipo.uuid, 'Mesa 1'),
        ]));
  });

  test('las filas antiguas reciben un uuid derivado de id y nombre', () async {
    // Simula una fila de antes de la sincronización.
    await db.customStatement(
        "INSERT INTO pilotos (nombre, uuid, mod_ms) VALUES ('Luis Gómez ', NULL, 0)");
    await db.customStatement(
        "UPDATE pilotos SET uuid = NULL WHERE nombre = 'Luis Gómez '");
    for (final sql in sentenciasUuidHeredado()) {
      await db.customStatement(sql);
    }
    final p = await (db.select(db.pilotos)
          ..where((t) => t.nombre.equals('Luis Gómez ')))
        .getSingle();
    expect(p.uuid, 'l:${p.id}:luis gómez');
  });
}
