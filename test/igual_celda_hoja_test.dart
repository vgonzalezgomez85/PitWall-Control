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
import 'package:flutter_test/flutter_test.dart';
import 'package:pitwall/features/google/subidor_catalogo.dart';

void main() {
  test('el mismo número escrito distinto no es una diferencia', () {
    expect(igualCeldaHoja('17,00', 17.0), isTrue);
    expect(igualCeldaHoja('17', 17.0), isTrue);
    expect(igualCeldaHoja('-8', -8), isTrue);
    expect(igualCeldaHoja('18,5', 18.5), isTrue);
  });

  test('números distintos y textos distintos sí lo son', () {
    expect(igualCeldaHoja('17,00', 18.0), isFalse);
    expect(igualCeldaHoja('GT3', 'GT2'), isFalse);
    expect(igualCeldaHoja('', 17.0), isFalse);
  });

  test('el texto se compara sin mayúsculas ni espacios de más', () {
    expect(igualCeldaHoja(' Slot.it  GT ', 'slot.it gt'), isTrue);
  });
}
