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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pitwall/core/proveedores.dart';
import 'package:pitwall/data/database/app_database.dart';
import 'package:pitwall/features/equipos/importador_equipos.dart';
import 'package:pitwall/features/verificacion_libre/importador_participantes.dart';
import 'package:pitwall/features/verificacion_libre/repositorio_verificacion_libre.dart';

void main() {
  late AppDatabase db;
  late RepositorioVerificacionLibre repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = RepositorioVerificacionLibre(db);
  });
  tearDown(() => db.close());

  test('la sesión no aparece como campeonato y guarda su reglamento', () async {
    await db.into(db.campeonatos).insert(CampeonatosCompanion.insert(
        nombre: 'Liga real', formato: 'PAREJAS', anio: 2026));
    final pruebaId = await repo.crearSesion(DatosSesionLibre(
      nombre: 'Control club',
      sede: 'El Sot',
      copas: ['GT', 'LMP'],
      tipoMotor: 'ORGANIZACION',
      motorSorteoMin: 1,
      motorSorteoMax: 20,
      marcasPermitidasJson: '["SIT"]',
    ));

    final container = ProviderContainer(
        overrides: [dbProvider.overrideWithValue(db)]);
    addTearDown(container.dispose);
    // Riverpod 3 pausa los providers sin oyentes: hay que escucharlo.
    container.listen(campeonatosProvider, (_, _) {});
    final visibles = await container.read(campeonatosProvider.future);
    expect(visibles.map((c) => c.nombre), ['Liga real']);

    final s = (await repo.cargar(pruebaId))!;
    expect(s.nombre, 'Control club');
    expect(s.copas, ['GT', 'LMP']);
    expect(s.reglamento.esVerificacionLibre, isTrue);
    expect(s.reglamento.usaCreditos, isFalse);
    expect(s.reglamento.tipoMotor, 'ORGANIZACION');
    expect(s.participantes, 0);

    // La siguiente sesión empieza en blanco (como un campeonato nuevo).
    final plantilla = await repo.plantillaNueva();
    expect(plantilla.copas, isEmpty);
    expect(plantilla.tipoMotor, isNull);
    expect(plantilla.motorSorteoMax, isNull);
  });

  test('participantes: reutiliza pilotos por nombre y se pueden quitar',
      () async {
    final existente = await db
        .into(db.pilotos)
        .insert(PilotosCompanion.insert(nombre: 'Artur Valero'));
    final pruebaId = await repo
        .crearSesion(DatosSesionLibre(nombre: 'Carrera', copas: ['GT']));
    var s = (await repo.cargar(pruebaId))!;

    final eq1 = await repo.anadirParticipante(
        sesion: s, piloto1: 'artur valero', copa: 'GT');
    final eq2 = await repo.anadirParticipante(
        sesion: s,
        piloto1: 'Nuevo Piloto',
        piloto2: 'Otro',
        equipo: 'Escudería X',
        copa: 'GT');

    final e1 = await (db.select(db.equipos)..where((t) => t.id.equals(eq1)))
        .getSingle();
    expect(e1.piloto1Id, existente);
    expect(e1.nombre, 'artur valero');
    final e2 = await (db.select(db.equipos)..where((t) => t.id.equals(eq2)))
        .getSingle();
    expect(e2.nombre, 'Escudería X');
    expect(e2.piloto2Id, isNotNull);

    await db.into(db.verificaciones).insert(VerificacionesCompanion.insert(
        mangaId: s.mangaId, equipoId: eq2));
    s = (await repo.cargar(pruebaId))!;
    expect(s.participantes, 2);
    expect(s.conVerificacion, 1);

    await repo.quitarParticipante(sesion: s, equipoId: eq2);
    s = (await repo.cargar(pruebaId))!;
    expect(s.participantes, 1);
    expect(s.conVerificacion, 0);
    expect(await db.select(db.verificaciones).get(), isEmpty);
  });

  test('borrar la sesión limpia todo menos los pilotos', () async {
    final pruebaId = await repo
        .crearSesion(DatosSesionLibre(nombre: 'Borrable', copas: ['GT']));
    final s = (await repo.cargar(pruebaId))!;
    final eq = await repo.anadirParticipante(
        sesion: s, piloto1: 'Piloto', copa: 'GT');
    await db.into(db.verificaciones).insert(
        VerificacionesCompanion.insert(mangaId: s.mangaId, equipoId: eq));

    await repo.borrarSesion(pruebaId);

    expect(await repo.sesiones(), isEmpty);
    expect(await db.select(db.campeonatos).get(), isEmpty);
    expect(await db.select(db.pruebas).get(), isEmpty);
    expect(await db.select(db.mangas).get(), isEmpty);
    expect(await db.select(db.equipos).get(), isEmpty);
    expect(await db.select(db.inscripciones).get(), isEmpty);
    expect(await db.select(db.verificaciones).get(), isEmpty);
    expect(await db.select(db.pilotos).get(), hasLength(1));
  });

  group('importar participantes', () {
    test('detecta columnas, incluida la de piloto genérico', () {
      var m = ImportadorParticipantes.detectarMapeo(
          ['Nombre', 'Piloto 2', 'Escudería', 'Categoría', 'Email']);
      expect(m.colPiloto1, 'Nombre');
      expect(m.colPiloto2, 'Piloto 2');
      expect(m.colEquipo, 'Escudería');
      expect(m.colCopa, 'Categoría');

      m = ImportadorParticipantes.detectarMapeo(
          ['Piloto 1', 'Piloto 2', 'Equipo', 'Copa']);
      expect(m.colPiloto1, 'Piloto 1');
      expect(m.colPiloto2, 'Piloto 2');

      m = ImportadorParticipantes.detectarMapeo(['Corredores']);
      expect(m.colPiloto1, 'Corredores');
    });

    test('lista de una columna se lee con cabecera de una celda', () {
      final t = ImportadorEquipos.normalizarFilas([
        ['Piloto'],
        ['Ana'],
        ['Luis'],
      ], minCeldasCabecera: 1);
      expect(t.columnas, ['Piloto']);
      expect(t.filas.map((f) => f['Piloto']), ['Ana', 'Luis']);
    });

    test('copa, duplicados y filas sin piloto', () {
      final m = MapeoParticipantes()
        ..colPiloto1 = 'P1'
        ..colPiloto2 = 'P2'
        ..colEquipo = 'Eq'
        ..colCopa = 'Copa';
      final filas = ImportadorParticipantes.transformar(
        [
          {'P1': 'Ana', 'Copa': 'lmp-2'},
          {'P1': 'Luis', 'P2': 'Eva', 'Copa': 'F1'},
          {'P1': 'Juan', 'Eq': 'Rojos', 'Copa': ''},
          {'P1': 'ana'}, // repetido en la tabla
          {'P1': 'Marc'}, // ya en la sesión
          {'P1': '', 'Eq': 'Sin piloto'},
        ],
        m,
        copasSesion: ['GT', 'LMP2'],
        copaPorDefecto: 'GT',
        equiposEnSesion: ['MARC'],
      );
      expect(filas.map((f) => f.nombreEquipo),
          ['Ana', 'Luis / Eva', 'Rojos', 'ana', 'Marc']);
      expect(filas.map((f) => f.copa), ['LMP2', 'GT', 'GT', 'GT', 'GT']);
      expect(filas[1].aviso, contains('F1'));
      expect(filas[2].aviso, isNull);
      expect(filas.map((f) => f.importar), [true, true, true, false, false]);
    });

    test('importa solo las filas marcadas', () async {
      final pruebaId = await repo
          .crearSesion(DatosSesionLibre(nombre: 'Import', copas: ['GT']));
      final s = (await repo.cargar(pruebaId))!;
      final filas = ImportadorParticipantes.transformar(
        [
          {'P': 'Ana'},
          {'P': 'Luis'},
          {'P': 'Eva'},
        ],
        MapeoParticipantes()..colPiloto1 = 'P',
        copasSesion: s.copas,
        copaPorDefecto: 'GT',
        equiposEnSesion: await repo.nombresEquipos(s),
      );
      filas[1].importar = false;
      expect(await repo.importarParticipantes(s, filas), 2);
      final despues = (await repo.cargar(pruebaId))!;
      expect(despues.participantes, 2);
      expect(await repo.nombresEquipos(despues),
          unorderedEquals(['Ana', 'Eva']));
    });
  });
}
