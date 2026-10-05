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

// Sincronización por wifi entre Controls: fusión de paquetes entre dos BDs
// que parten de la misma copia (mismo campeonato, prueba, mangas y equipos).

import 'dart:convert';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pitwall/data/database/app_database.dart';
import 'package:pitwall/features/pruebas/repositorio_inscripciones_prueba.dart';
import 'package:pitwall/features/sincronizacion/fusionador_sync.dart';
import 'package:pitwall/features/sincronizacion/paquete_sync.dart';
import 'package:pitwall/features/sincronizacion/servicio_sync.dart';
import 'package:pitwall/features/tesoreria/repositorio_tesoreria.dart';
import 'package:pitwall/features/verificaciones/repositorio_verificaciones.dart';

/// Ids de la base común (iguales en las dos BDs).
const _prueba = 1, _manga = 1, _equipoA = 1, _equipoB = 2, _coche = 1;

Future<AppDatabase> _baseComun() async {
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  await db.into(db.campeonatos).insert(CampeonatosCompanion.insert(
      nombre: 'Resistencia 2026',
      formato: 'PAREJAS',
      anio: 2026,
      usaCreditos: const Value(true)));
  for (final n in ['Ana', 'Bea', 'Carlos', 'Dani']) {
    final id = await db.into(db.pilotos).insert(PilotosCompanion.insert(nombre: n));
    await db.into(db.pilotoCampeonato).insert(PilotoCampeonatoCompanion.insert(
        pilotoId: id,
        campeonatoId: 1,
        categoria: 'ORO',
        creditosIniciales: 10,
        creditosActuales: 10));
  }
  await db.into(db.equipos).insert(EquiposCompanion.insert(
      campeonatoId: 1, nombre: 'Equipo A', copa: 'GT', piloto1Id: 1,
      piloto2Id: const Value(2)));
  await db.into(db.equipos).insert(EquiposCompanion.insert(
      campeonatoId: 1, nombre: 'Equipo B', copa: 'GT', piloto1Id: 3,
      piloto2Id: const Value(4)));
  await db.into(db.pruebas).insert(PruebasCompanion.insert(
      campeonatoId: 1, nombre: 'EL SOT', orden: 1));
  await db.into(db.mangas).insert(
      MangasCompanion.insert(pruebaId: _prueba, nombre: 'Jueves 21:00'));
  for (final e in [_equipoA, _equipoB]) {
    await db.into(db.inscripcionesPrueba).insert(
        InscripcionesPruebaCompanion.insert(pruebaId: _prueba, equipoId: e));
  }
  await db.into(db.catalogoCoches).insert(CatalogoCochesCompanion.insert(
      nombre: 'SCALEAUTO-BMW M8', marca: 'SCA', modelo: 'M8', pesoMin: 70,
      creditosCoche: const Value(-4)));
  return db;
}

/// "Control 1 trae de Control 2": fusiona en [destino] el paquete de [origen].
Future<ResultadoFusionSync> _traer(AppDatabase destino, AppDatabase origen) async {
  // Pasa por JSON como en la red.
  final paquete = jsonDecode(jsonEncode(await generarPaqueteSync(origen, _prueba)))
      as Map<String, dynamic>;
  return FusionadorSync(destino).fusionar(_prueba, paquete);
}

Future<Verificacione?> _verif(AppDatabase db, int equipoId) =>
    (db.select(db.verificaciones)
          ..where((t) => t.mangaId.equals(_manga) & t.equipoId.equals(equipoId)))
        .getSingleOrNull();

Future<int> _creditos(AppDatabase db, int pilotoId) async =>
    (await (db.select(db.pilotoCampeonato)
              ..where((t) => t.pilotoId.equals(pilotoId)))
            .getSingle())
        .creditosActuales;

void main() {
  // Este test abre a propósito varias BDs en memoria (una por Control).
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase uno, dos;
  setUp(() async {
    uno = await _baseComun();
    dos = await _baseComun();
  });
  tearDown(() async {
    await uno.close();
    await dos.close();
  });

  test('cada Control verifica un equipo y al sincronizar los dos tienen ambos',
      () async {
    await RepositorioVerificaciones(uno).guardar(
        mangaId: _manga, equipoId: _equipoA, pesoInicial: 71, validado: false,
        fotosJson: '["verif-1.jpg"]');
    await RepositorioVerificaciones(dos).guardar(
        mangaId: _manga, equipoId: _equipoB, pesoInicial: 72, validado: false);

    final r1 = await _traer(uno, dos);
    final r2 = await _traer(dos, uno);
    expect(r1.verifNuevas, 1);
    expect(r2.verifNuevas, 1);
    expect(r2.fotos, contains('verif-1.jpg'));
    for (final db in [uno, dos]) {
      expect((await _verif(db, _equipoA))!.pesoInicial, 71);
      expect((await _verif(db, _equipoB))!.pesoInicial, 72);
    }
    // Repetir no cambia nada.
    expect((await _traer(uno, dos)).cambios, 0);
  });

  test('gana el cambio más reciente', () async {
    await RepositorioVerificaciones(uno).guardar(
        mangaId: _manga, equipoId: _equipoA, pesoInicial: 71, validado: false);
    await _traer(dos, uno);
    await Future<void>.delayed(const Duration(milliseconds: 5));
    await RepositorioVerificaciones(dos).guardar(
        mangaId: _manga, equipoId: _equipoA, pesoInicial: 75, validado: false);

    // El viejo no pisa al nuevo...
    expect((await _traer(dos, uno)).cambios, 0);
    expect((await _verif(dos, _equipoA))!.pesoInicial, 75);
    // ...y el nuevo sí actualiza al viejo.
    expect((await _traer(uno, dos)).verifActualizadas, 1);
    expect((await _verif(uno, _equipoA))!.pesoInicial, 75);
  });

  test('los créditos se descuentan una sola vez en cada Control', () async {
    await RepositorioVerificaciones(uno).guardar(
        mangaId: _manga, equipoId: _equipoA, cocheCatalogoId: _coche,
        validado: true);
    expect(await _creditos(uno, 1) + await _creditos(uno, 2), 16);

    await _traer(dos, uno);
    expect(await _creditos(dos, 1) + await _creditos(dos, 2), 16);
    // Sincronizar otra vez (y de vuelta) no vuelve a descontar.
    await _traer(dos, uno);
    await _traer(uno, dos);
    expect(await _creditos(uno, 1) + await _creditos(uno, 2), 16);
    expect(await _creditos(dos, 1) + await _creditos(dos, 2), 16);
  });

  test('un borrado se propaga y devuelve los créditos', () async {
    final repo = RepositorioVerificaciones(uno);
    final id = await repo.guardar(
        mangaId: _manga, equipoId: _equipoA, cocheCatalogoId: _coche,
        validado: true);
    await _traer(dos, uno);
    await Future<void>.delayed(const Duration(milliseconds: 5));
    await repo.borrar(id);

    final r = await _traer(dos, uno);
    expect(r.verifBorradas, 1);
    expect(await _verif(dos, _equipoA), isNull);
    expect(await _creditos(dos, 1) + await _creditos(dos, 2), 20);
    // Y el borrado no "resucita" al traer en sentido contrario.
    await _traer(uno, dos);
    expect(await _verif(uno, _equipoA), isNull);
  });

  test('el borrado viaja en cadena (1 → 2 → 3)', () async {
    final tres = await _baseComun();
    final id = await RepositorioVerificaciones(uno).guardar(
        mangaId: _manga, equipoId: _equipoA, validado: false);
    await _traer(dos, uno);
    await _traer(tres, uno);
    await Future<void>.delayed(const Duration(milliseconds: 5));
    await RepositorioVerificaciones(uno).borrar(id);
    await _traer(dos, uno);
    await _traer(tres, dos);
    expect(await _verif(tres, _equipoA), isNull);
    await tres.close();
  });

  test('copa y cobro hechos en otro Control llegan', () async {
    await RepositorioInscripcionesPrueba(uno)
        .fijarCopaPrueba(pruebaId: _prueba, equipoId: _equipoB, copa: 'GT2');
    await RepositorioTesoreria(uno).guardarPago(
        pruebaId: _prueba, equipoId: _equipoB, pagat: 25, coordinadora: 11,
        club: 14);

    final r = await _traer(dos, uno);
    expect(r.copas, 1);
    expect(r.tesoreria, 1);
    final ins = await (dos.select(dos.inscripcionesPrueba)
          ..where((t) => t.equipoId.equals(_equipoB)))
        .getSingle();
    expect(ins.copa, 'GT2');
    final pago = await (dos.select(dos.pagos)).getSingle();
    expect(pago.pagat, 25);

    // Quitar el cobro en el otro Control también se propaga.
    await Future<void>.delayed(const Duration(milliseconds: 5));
    await RepositorioTesoreria(dos).borrarDe(pruebaId: _prueba, equipoId: _equipoB);
    await _traer(uno, dos);
    expect(await uno.select(uno.pagos).get(), isEmpty);
  });

  test('por la red: un Control trae la prueba del otro y la clave protege',
      () async {
    await RepositorioVerificaciones(dos).guardar(
        mangaId: _manga, equipoId: _equipoB, pesoInicial: 72, validado: false);
    final srv = ServidorSync(dos, '1234');
    await srv.arrancar();
    final host = '127.0.0.1:${srv.puerto}';
    try {
      final info = await ClienteSync.info(host, 'mala');
      expect(info, isNotNull);
      expect(info!.claveOk, isFalse);
      expect(
          () => ClienteSync.paquete(host, 'mala', const RefSync(1, 'Resistencia 2026'),
              const RefSync(_prueba, 'EL SOT')),
          throwsA(isA<ErrorSync>()));

      final paquete = await ClienteSync.paquete(host, '1234',
          const RefSync(1, 'Resistencia 2026'), const RefSync(_prueba, 'EL SOT'));
      final r = await FusionadorSync(uno).fusionar(_prueba, paquete);
      expect(r.verifNuevas, 1);
      expect((await _verif(uno, _equipoB))!.pesoInicial, 72);

      // Una prueba que el otro no tiene.
      expect(
          () => ClienteSync.paquete(host, '1234',
              const RefSync(1, 'Resistencia 2026'), const RefSync(99, 'NO EXISTE')),
          throwsA(isA<ErrorSync>()));
    } finally {
      await srv.parar();
    }
  });
}
