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
import 'package:flutter_test/flutter_test.dart';
import 'package:pitwall/domain/generador_mangas.dart';

List<EquipoSemilla> _equipos(int n, {String? dia}) => [
      for (var i = 0; i < n; i++)
        EquipoSemilla(
            equipoId: i, nombre: 'E$i', copa: 'LMP',
            puntuacion: i, preferenciaDia: dia),
    ];

List<int> _tamanos(ResultadoGeneracion r) =>
    r.mangas.map((m) => m.equipos.length).toList();

void main() {
  test('17 el jueves con 6 carriles → 2 mangas de 9 + 8', () {
    final eqs = _equipos(17, dia: 'JUEVES');
    final nombres = GeneradorMangas.sugerirMangasPorPreferencia(
        equipos: eqs, tamMax: 6);
    expect(nombres.length, 2);
    final r = GeneradorMangas.generar(
        equipos: eqs,
        config: ConfigGenerador(nombresMangas: nombres, tamMaxManga: 6));
    expect(_tamanos(r), [9, 8]);
    expect(r.sinManga, isEmpty);
    // los de más puntos corren en la última manga
    expect(r.mangas.last.equipos.first.puntuacion, 16);
  });

  test('si se fuerzan 3 mangas, la última no deja carriles vacíos', () {
    final r = GeneradorMangas.generar(
        equipos: _equipos(17, dia: 'Jueves'),
        config: const ConfigGenerador(
            nombresMangas: ['Jueves 21:00', 'Jueves 21:36', 'Jueves 22:12'],
            tamMaxManga: 6));
    expect(_tamanos(r), [5, 6, 6]);
  });

  test('número de mangas sugerido', () {
    int n(int t) => GeneradorMangas.numMangasSugerido(totalEquipos: t, tamMax: 6);
    expect([n(4), n(6), n(11), n(12), n(13), n(16), n(17), n(18), n(20)],
        [1, 1, 1, 2, 2, 2, 2, 3, 3]);
  });

  test('11 en 2 mangas con 10 carriles sigue siendo 5 + 6', () {
    final r = GeneradorMangas.generar(
        equipos: _equipos(11, dia: 'Viernes'),
        config: const ConfigGenerador(
            nombresMangas: ['Viernes 21:00', 'Viernes 23:00']));
    expect(_tamanos(r), [5, 6]);
  });

  test('sin preferencia no se quedan fuera aunque las mangas estén llenas', () {
    final r = GeneradorMangas.generar(
        equipos: [..._equipos(12, dia: 'Jueves'), ..._equipos(2).map((e) =>
            EquipoSemilla(equipoId: 100 + e.equipoId, nombre: 'S${e.equipoId}',
                copa: 'LMP', puntuacion: 0))],
        config: const ConfigGenerador(
            nombresMangas: ['Jueves 21:00', 'Jueves 21:36'], tamMaxManga: 6));
    expect(r.sinManga, isEmpty);
    expect(_tamanos(r), [7, 7]);
  });

  test('carriles de salida: 1..N y luego D1, D2…', () {
    expect(GeneradorMangas.carrilesSalida(9, 6),
        ['1', '2', '3', '4', '5', '6', 'D1', 'D2', 'D3']);
    expect(GeneradorMangas.carrilesSalida(4, 6), ['1', '2', '3', '4']);
  });

  test('pisters por día: parejas, trío en ciclo', () {
    // 2 el jueves + 2 el viernes → 1↔2, 3↔4
    expect(
        GeneradorMangas.asignarPisters(
            ['Jueves 21:00', 'Jueves 21:36', 'Viernes 21:00', 'Viernes 21:36']),
        [1, 0, 3, 2]);
    // 3 mangas: 3ª→1ª, 1ª→2ª, 2ª→3ª
    expect(GeneradorMangas.asignarPisters(['Jueves A', 'Jueves B', 'Jueves C']),
        [2, 0, 1]);
    // 5 mangas: 1↔2 y trío 3,4,5
    expect(
        GeneradorMangas.asignarPisters(
            ['Sábado 1', 'Sábado 2', 'Sábado 3', 'Sábado 4', 'Sábado 5']),
        [1, 0, 4, 2, 3]);
    // una sola manga en su día → sin pisters
    expect(GeneradorMangas.asignarPisters(['Jueves 21:00', 'Viernes 21:00']),
        [null, null]);
  });
}
