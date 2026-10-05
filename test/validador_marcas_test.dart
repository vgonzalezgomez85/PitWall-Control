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
import 'package:pitwall/domain/validador_verificacion.dart';
import 'package:pitwall/features/campeonatos/selector_marcas_permitidas.dart';

void main() {
  test('limitar fabricante: otra marca es infracción', () {
    final r = ValidadorVerificacion.validar(DatosVerificacion(
      pinonMarca: 'SIT',
      coronaMarca: 'SCA',
      trencilla: 'NSR',
      marcasValidas: {'SIT', 'SCA', 'NSR'},
      marcasPermitidas: {'SIT'},
    ));
    final fabricante = r.hallazgos
        .where((h) => h.mensaje.contains('no permitida'))
        .toList();
    expect(fabricante.map((h) => h.campo), ['coronaMarca', 'trencilla']);
    expect(fabricante.every((h) => h.nivel == NivelValidacion.infraccion),
        isTrue);
  });

  test('sin limitación no hay hallazgos de fabricante', () {
    final r = ValidadorVerificacion.validar(DatosVerificacion(
      coronaMarca: 'SCA',
      marcasValidas: {'SIT', 'SCA'},
    ));
    expect(r.hallazgos.where((h) => h.mensaje.contains('no permitida')),
        isEmpty);
  });

  test('dientes: sin rango no hay regla (campeonatos usan el catálogo)', () {
    final r = ValidadorVerificacion.validar(DatosVerificacion(
      pinonDientes: 9,
      coronaDientes: 40,
    ));
    expect(r.hallazgos.where((h) => h.mensaje.contains('dientes')), isEmpty);
  });

  test('dientes: con rango (verificación libre) fuera es infracción', () {
    final r = ValidadorVerificacion.validar(DatosVerificacion(
      pinonDientes: 11,
      coronaDientes: 31,
      pinonDientesMin: 12,
      pinonDientesMax: 12,
      coronaDientesMin: 24,
      coronaDientesMax: 30,
    ));
    final dientes =
        r.hallazgos.where((h) => h.mensaje.contains('dientes')).toList();
    expect(dientes.map((h) => h.campo), ['pinonDientes', 'coronaDientes']);
    expect(dientes.every((h) => h.nivel == NivelValidacion.infraccion),
        isTrue);
  });

  test('json de marcas permitidas', () {
    expect(marcasPermitidasDe('["SIT","NSR"]'), {'SIT', 'NSR'});
    expect(marcasPermitidasDe('[]'), isEmpty);
    expect(marcasPermitidasDe('roto'), isEmpty);
    expect(marcasPermitidasAJson({'SIT', 'NSR'}), '["NSR","SIT"]');
  });
}
