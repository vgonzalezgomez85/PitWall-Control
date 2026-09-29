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
import 'package:pitwall/services/fotos_coches_drive.dart';

void main() {
  const id = '1AbC-dEf_GhIjKlMnOpQrStUvWxYz0123';

  test('extrae el id de los formatos de enlace de Drive', () {
    for (final enlace in [
      'https://drive.google.com/file/d/$id/view?usp=sharing',
      'https://drive.google.com/file/d/$id/view',
      'https://drive.google.com/open?id=$id',
      'https://drive.google.com/uc?export=view&id=$id',
      ' https://docs.google.com/uc?id=$id ',
    ]) {
      expect(FotosCochesDrive.idDeEnlace(enlace), id, reason: enlace);
    }
  });

  test('sin enlace de Drive no hay id', () {
    expect(FotosCochesDrive.idDeEnlace(null), isNull);
    expect(FotosCochesDrive.idDeEnlace(''), isNull);
    expect(FotosCochesDrive.idDeEnlace('foto.jpg'), isNull);
  });

  test('reconoce las fotos locales que vienen de Drive', () {
    expect(FotosCochesDrive.idDeFotoLocal('coche-drive-$id.jpg'), id);
    expect(FotosCochesDrive.idDeFotoLocal('coche-1700000000000.jpg'), isNull);
    expect(FotosCochesDrive.idDeFotoLocal(null), isNull);
    expect(FotosCochesDrive.idDeEnlace(FotosCochesDrive.enlace(id)), id);
  });
}
