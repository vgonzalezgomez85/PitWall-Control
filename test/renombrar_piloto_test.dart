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
import 'package:pitwall/features/equipos/repositorio_equipos.dart';
import 'package:pitwall/features/pilotos/repositorio_pilotos.dart';

void main() {
  test('renombrar piloto renombra su equipo individual si se llamaba igual',
      () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final pilotos = RepositorioPilotos(db);
    final equipos = RepositorioEquipos(db);
    final cId = await db.into(db.campeonatos).insert(CampeonatosCompanion.insert(
        nombre: 'Test', formato: 'INDIVIDUAL', anio: 2026));
    final toni = await pilotos.crear(
        nombre: 'Antonio Santos',
        campeonatoId: cId,
        categoria: 'BRONCE',
        creditosIniciales: 28);
    final otro = await pilotos.crear(
        nombre: 'Josepe',
        campeonatoId: cId,
        categoria: 'BRONCE',
        creditosIniciales: 28);
    final individual = await equipos.crear(
        campeonatoId: cId, nombre: 'Antonio Santos', copa: 'LMP', piloto1Id: toni);
    final apodo = await equipos.crear(
        campeonatoId: cId, nombre: 'Los Rápidos', copa: 'LMP', piloto1Id: toni);
    final pareja = await equipos.crear(
        campeonatoId: cId,
        nombre: 'Antonio Santos',
        copa: 'GT',
        piloto1Id: toni,
        piloto2Id: otro);

    await pilotos.actualizar(
        pilotoId: toni,
        campeonatoId: cId,
        nombre: 'Toni Santos',
        categoria: 'BRONCE',
        creditosIniciales: 28,
        creditosActuales: 28);

    Future<String> nombre(int id) async =>
        (await (db.select(db.equipos)..where((t) => t.id.equals(id)))
                .getSingle())
            .nombre;
    expect(await nombre(individual), 'Toni Santos');
    expect(await nombre(apodo), 'Los Rápidos');
    expect(await nombre(pareja), 'Antonio Santos');
  });
}
