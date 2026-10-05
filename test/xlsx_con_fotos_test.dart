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
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:excel/excel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:pitwall/services/xlsx_con_fotos.dart';

void main() {
  test('xlsx con fotos: texto legible, fotos incrustadas, foto rota como texto',
      () {
    final foto = Uint8List.fromList(
        img.encodePng(img.fill(img.Image(width: 1600, height: 1200),
            color: img.ColorRgb8(200, 30, 40))));
    final bytes = generarXlsxConFotos(HojaConFotos(
      nombre: 'Control: club [jueves]',
      cabecera: ['Piloto', 'Peso'],
      anchos: [20, 10],
      filas: [
        [const CeldaXlsx('Ana & Bea'), const CeldaXlsx('20g', mal: true)],
        [const CeldaXlsx('Carlos <C>'), const CeldaXlsx('')],
      ],
      fotos: [
        [foto, Uint8List.fromList([1, 2, 3])],
        [],
      ],
    ));

    final zip = ZipDecoder().decodeBytes(bytes);
    final nombres = zip.files.map((f) => f.name).toSet();
    expect(nombres, contains('xl/media/foto1.jpeg'));
    expect(nombres, isNot(contains('xl/media/foto2.jpeg')));
    expect(nombres, contains('xl/drawings/drawing1.xml'));
    // La foto se reduce a 800 px de lado mayor.
    final media = zip.findFile('xl/media/foto1.jpeg')!.content as List<int>;
    expect(img.decodeJpg(Uint8List.fromList(media))!.width, 800);

    // Otro lector de xlsx lo abre y lee el texto.
    final libro = Excel.decodeBytes(bytes);
    final hoja = libro.tables.values.single;
    expect(libro.tables.keys.single, 'Control club jueves');
    expect(hoja.rows[0].map((c) => c?.value.toString()),
        ['Piloto', 'Peso', 'Foto 1', 'Foto 2']);
    expect(hoja.rows[1][0]?.value.toString(), 'Ana & Bea');
    expect(hoja.rows[1][3]?.value.toString(), '(foto no compatible)');
    expect(hoja.rows[2][0]?.value.toString(), 'Carlos <C>');

    final dir = Platform.environment['XLSX_SALIDA'];
    if (dir != null) File('$dir/prueba_fotos.xlsx').writeAsBytesSync(bytes);
    expect(utf8.decode(zip.findFile('xl/workbook.xml')!.content as List<int>),
        contains('Control club jueves'));
  });
}
