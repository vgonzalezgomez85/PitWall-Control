// PitWall Control — gestor de campeonatos de slot
// Copyright (C) 2026 Víctor González Gómez <vgonzalezgomez@outlook.es>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
//
// Additional permission under GPLv3 section 7: distribution through application
// stores (e.g. Apple App Store, Google Play) is permitted. See LICENSE-EXCEPTION.
//
// «Orden de la primera prueba»: con qué puntos se ordenan las tandas mientras
// el campeonato no tiene puntos propios.

import 'package:drift/drift.dart' show BooleanExpressionOperators, Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pitwall/data/database/app_database.dart';
import 'package:pitwall/features/creditos/repositorio_creditos.dart';
import 'package:pitwall/features/pilotos/repositorio_pilotos.dart';
import 'package:pitwall/features/pruebas/repositorio_pruebas.dart';

late AppDatabase db;

Future<int> _campeonato(String nombre,
    {String orden = 'HEREDAR', int? semilla, int descartes = 1}) {
  return db.into(db.campeonatos).insert(CampeonatosCompanion.insert(
        nombre: nombre,
        formato: 'PAREJAS',
        anio: 2026,
        numDescartes: Value(descartes),
        ordenPrimeraPrueba: Value(orden),
        campeonatoSemillaId: Value(semilla),
      ));
}

Future<int> _piloto(String nombre) =>
    db.into(db.pilotos).insert(PilotosCompanion.insert(nombre: nombre));

Future<void> _perfil(int pilotoId, int campeonatoId,
        {int creditos = 20, int saldoAnterior = 0}) =>
    db.into(db.pilotoCampeonato).insert(PilotoCampeonatoCompanion.insert(
          pilotoId: pilotoId,
          campeonatoId: campeonatoId,
          categoria: 'ORO',
          creditosIniciales: creditos,
          creditosActuales: creditos,
          saldoTemporadaAnterior: Value(saldoAnterior),
        ));

/// Crea una prueba con una manga [nombreManga] y los puntos de cada piloto.
Future<void> _prueba(int campeonatoId, int orden, Map<int, int> puntos,
    {String nombreManga = 'Viernes', int? pruebaId}) async {
  final pid = pruebaId ??
      await db.into(db.pruebas).insert(PruebasCompanion.insert(
          campeonatoId: campeonatoId, nombre: 'P$orden', orden: orden));
  final manga = await db
      .into(db.mangas)
      .insert(MangasCompanion.insert(pruebaId: pid, nombre: nombreManga));
  for (final e in puntos.entries) {
    final eq = await db.into(db.equipos).insert(EquiposCompanion.insert(
        campeonatoId: campeonatoId,
        nombre: 'E${e.key}',
        copa: 'GT',
        piloto1Id: e.key));
    await db.into(db.resultados).insert(ResultadosCompanion.insert(
        mangaId: manga, pilotoId: e.key, equipoId: eq, puntos: Value(e.value)));
  }
}

void main() {
  late int ana, bea;
  late int anterior;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    ana = await _piloto('Ana');
    bea = await _piloto('Bea');
    // Campeonato anterior, 1 descarte. Ana: 50 + 10 + 40 → neto 90.
    // Bea: 30 + 30 y no corre la 3ª (cuenta 0 → descarte) → neto 60.
    anterior = await _campeonato('Liga 2026');
    await _prueba(anterior, 1, {ana: 50, bea: 30});
    await _prueba(anterior, 2, {ana: 10, bea: 30});
    await _prueba(anterior, 3, {ana: 40});
  });

  tearDown(() => db.close());

  test('heredar: puntos netos (con descartes) del campeonato de origen',
      () async {
    final nuevo = await _campeonato('Liga 2027', semilla: anterior);
    final s = await semillaOrden(db, nuevo);
    expect(s.origen, OrigenSemilla.heredados);
    expect(s.campeonatoOrigen, 'Liga 2026');
    expect(s.puntos, {ana: 90, bea: 60});
  });

  test('heredar: la manga IMPORTADA pisa el total de la prueba', () async {
    final p1 = await (db.select(db.pruebas)
          ..where((t) => t.campeonatoId.equals(anterior) & t.orden.equals(1)))
        .getSingle();
    // Corrección manual: en la 1ª prueba Bea tiene 70, no 30.
    await _prueba(anterior, 1, {bea: 70},
        nombreManga: 'IMPORTADA', pruebaId: p1.id);
    final nuevo = await _campeonato('Liga 2027', semilla: anterior);
    expect((await semillaOrden(db, nuevo)).puntos[bea], 100);
  });

  test('pole: sin puntos para ordenar', () async {
    final nuevo =
        await _campeonato('Liga 2027', orden: 'POLE', semilla: anterior);
    final s = await semillaOrden(db, nuevo);
    expect(s.origen, OrigenSemilla.pole);
    expect(s.puntos, isEmpty);
  });

  test('sin campeonato de origen: puntuación previa importada', () async {
    final nuevo = await _campeonato('Liga 2027');
    await _perfil(ana, nuevo, saldoAnterior: 12);
    final s = await semillaOrden(db, nuevo);
    expect(s.origen, OrigenSemilla.puntuacionPrevia);
    expect(s.puntos, {ana: 12});
  });

  test('con resultados propios se ordena por los brutos del campeonato',
      () async {
    final nuevo = await _campeonato('Liga 2027', semilla: anterior);
    await _prueba(nuevo, 1, {bea: 20});
    final s = await semillaOrden(db, nuevo);
    expect(s.origen, OrigenSemilla.campeonato);
    expect(s.puntos, {bea: 20});
  });

  test('importar pilotos no guarda los créditos como puntuación previa',
      () async {
    await _perfil(ana, anterior, creditos: 25);
    final nuevo = await _campeonato('Liga 2027');
    await RepositorioCreditos(db)
        .importarDesdeCampeonato(origenId: anterior, destinoId: nuevo);
    final pc = await (db.select(db.pilotoCampeonato)
          ..where((t) => t.campeonatoId.equals(nuevo)))
        .getSingle();
    expect(pc.creditosIniciales, 25);
    expect(pc.saldoTemporadaAnterior, 0);
  });

  test('puntos iniciales a mano: mandan sobre los heredados; null vuelve',
      () async {
    final nuevo = await _campeonato('Liga 2027', semilla: anterior);
    await _perfil(ana, nuevo);
    await _perfil(bea, nuevo);
    final repo = RepositorioPilotos(db);
    await repo.fijarPuntosIniciales(
        pilotoId: bea, campeonatoId: nuevo, puntos: 200);
    var s = await semillaOrden(db, nuevo);
    expect(s.puntos, {ana: 90, bea: 200});
    // La ficha muestra lo heredado sin la corrección.
    final heredados = await puntosIniciales(db, nuevo, soloHeredados: true);
    expect(heredados.puntos[bea], 60);

    await repo.fijarPuntosIniciales(
        pilotoId: bea, campeonatoId: nuevo, puntos: null);
    s = await semillaOrden(db, nuevo);
    expect(s.puntos[bea], 60);
  });

  test('cambiar los puntos iniciales firma el perfil para sincronizar',
      () async {
    final nuevo = await _campeonato('Liga 2027', semilla: anterior);
    await _perfil(ana, nuevo);
    Future<int?> firma() async => (await (db.select(db.pilotoCampeonato)
              ..where((t) => t.campeonatoId.equals(nuevo)))
            .getSingle())
        .modMs;
    await db.customStatement(
        'UPDATE piloto_campeonato SET mod_ms = 1 WHERE campeonato_id = $nuevo');
    await RepositorioPilotos(db)
        .fijarPuntosIniciales(pilotoId: ana, campeonatoId: nuevo, puntos: 5);
    expect(await firma(), greaterThan(1));
  });
}
