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
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../data/database/app_database.dart';
import '../../services/exportar_config.dart';
import '../../services/pdf_marca.dart';
import '../../services/pdf_util.dart';
import 'pantalla_rejilla_verificaciones.dart';

/// Las fuentes estándar del PDF solo cubren Latin-1: se sustituyen los
/// caracteres que saldrían como un cuadrado.
String _latin1(String s) => s
    .replaceAll(RegExp('[–—−]'), '-')
    .replaceAll(RegExp('[‘’]'), "'")
    .replaceAll(RegExp('[“”]'), '"')
    .replaceAll('…', '...')
    .replaceAll(RegExp(r'[^\x00-\xFF]'), '');

/// PDF de una sola hoja (A4/A3 apaisado) con la rejilla de verificaciones.
Future<Uint8List> generarPdfRejilla({
  required List<FilaRejilla> filas,
  required Campeonato campeonato,
  required Prueba prueba,
}) async {
  final marca = await MarcaPdf.cargar();
  final titulo = (campeonato.marcaTitulo?.trim().isNotEmpty ?? false)
      ? campeonato.marcaTitulo!.trim()
      : marcaTituloPorDefecto;
  final lema = (campeonato.marcaLema?.trim().isNotEmpty ?? false)
      ? campeonato.marcaLema!.trim()
      : marcaLemaPorDefecto;
  final fecha = prueba.fecha == null
      ? null
      : DateFormat('d MMM y', 'es_ES').format(prueba.fecha!);
  final validadas = filas.where((f) => f.v?.validado ?? false).length;

  const tam = 6.5;
  final estiloCab = pw.TextStyle(
      fontSize: tam, fontWeight: pw.FontWeight.bold, color: PdfColors.white);
  const estilo = pw.TextStyle(fontSize: tam, color: MarcaPdf.texto);

  pw.Widget celda(String texto,
          {PdfColor? fondo, pw.TextStyle? st, bool infraccion = false}) =>
      pw.Container(
        color: infraccion ? MarcaPdf.rojoSuave : fondo,
        padding: const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 2.5),
        child: pw.Text(_latin1(texto),
            style: infraccion
                ? estilo.copyWith(
                    color: MarcaPdf.rojo, fontWeight: pw.FontWeight.bold)
                : (st ?? estilo)),
      );

  // Cada columna mide lo que su contenido; Observaciones se queda con el
  // sobrante. Si no cabe, pdfUnaHoja escala la hoja entera.
  final anchos = <int, pw.TableColumnWidth>{
    for (var i = 0; i <= columnasRejilla.length; i++)
      i: i == columnasRejilla.length
          ? const pw.IntrinsicColumnWidth(flex: 1)
          : const pw.IntrinsicColumnWidth(),
  };

  final tabla = pw.Table(
    border: pw.TableBorder.all(color: MarcaPdf.grisClaro, width: 0.5),
    columnWidths: anchos,
    children: [
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: MarcaPdf.rojoOscuro),
        children: [
          celda('Piloto / equipo', st: estiloCab),
          for (final col in columnasRejilla) celda(col.titulo, st: estiloCab),
        ],
      ),
      for (var i = 0; i < filas.length; i++)
        pw.TableRow(
          children: [
            celda(nombreFilaRejilla(filas[i]),
                fondo: i.isOdd ? MarcaPdf.fondoZebra : null,
                st: estilo.copyWith(fontWeight: pw.FontWeight.bold)),
            for (final col in columnasRejilla)
              () {
                final c = col.celda(filas[i], campeonato);
                final esEstado = col.titulo == 'Estado';
                return celda(
                  c.texto,
                  fondo: i.isOdd ? MarcaPdf.fondoZebra : null,
                  infraccion: c.infraccion != null,
                  st: esEstado && filas[i].v?.validado == true
                      ? estilo.copyWith(color: MarcaPdf.verde)
                      : null,
                );
              }(),
          ],
        ),
    ],
  );

  return pdfUnaHoja(
    filas: filas.length,
    columnas: columnasRejilla.length + 1,
    preferApaisado: true,
    contenido: (ctx) => pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        marca.hero(
          titulo: titulo,
          subtitulo: _latin1(
              'Resumen de verificaciones · ${prueba.nombre} - ${campeonato.nombre}'),
          badge: '$validadas / ${filas.length} VALIDADAS',
          nota: fecha,
        ),
        pw.SizedBox(height: 10),
        tabla,
        pw.SizedBox(height: 6),
        pw.Text('En rojo: fuera de reglamento.',
            style: const pw.TextStyle(fontSize: 7, color: MarcaPdf.gris)),
        pw.SizedBox(height: 10),
        marca.pie(lema: _latin1(lema)),
      ],
    ),
  );
}

/// Excel (.xlsx) con la rejilla de verificaciones: una fila por inscrito,
/// celdas fuera de reglamento en rojo y una última columna con los motivos.
Uint8List generarExcelRejilla({
  required List<FilaRejilla> filas,
  required Campeonato campeonato,
  required Prueba prueba,
}) {
  final libro = Excel.createExcel();
  final porDefecto = libro.getDefaultSheet();
  final nombreHoja = _nombreHoja(prueba.nombre);
  final hoja = libro[nombreHoja];

  final estiloCab = CellStyle(
    bold: true,
    fontColorHex: ExcelColor.white,
    backgroundColorHex: ExcelColor.fromHexString('#1A0E0E'),
  );
  final estiloMal = CellStyle(
    fontColorHex: ExcelColor.fromHexString('#9C0006'),
    backgroundColorHex: ExcelColor.fromHexString('#FFC7CE'),
  );

  final cabecera = [
    'Piloto / equipo',
    for (final c in columnasRejilla) c.titulo,
    'Fuera de reglamento',
  ];
  for (var x = 0; x < cabecera.length; x++) {
    hoja.updateCell(CellIndex.indexByColumnRow(columnIndex: x, rowIndex: 0),
        TextCellValue(cabecera[x]),
        cellStyle: estiloCab);
  }

  for (var y = 0; y < filas.length; y++) {
    final f = filas[y];
    final fila = y + 1;
    hoja.updateCell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: fila),
        TextCellValue(nombreFilaRejilla(f)));
    final motivos = <String>[];
    for (var x = 0; x < columnasRejilla.length; x++) {
      final col = columnasRejilla[x];
      final c = col.celda(f, campeonato);
      if (c.infraccion != null) motivos.add('${col.titulo}: ${c.infraccion}');
      if (c.texto.isEmpty && c.infraccion == null) continue;
      hoja.updateCell(
          CellIndex.indexByColumnRow(columnIndex: x + 1, rowIndex: fila),
          TextCellValue(c.texto),
          cellStyle: c.infraccion != null ? estiloMal : null);
    }
    if (motivos.isNotEmpty) {
      hoja.updateCell(
          CellIndex.indexByColumnRow(
              columnIndex: columnasRejilla.length + 1, rowIndex: fila),
          TextCellValue(motivos.join('; ')),
          cellStyle: estiloMal);
    }
  }

  // Anchos aproximados a los de la pantalla (px → caracteres).
  hoja.setColumnWidth(0, 32);
  for (var x = 0; x < columnasRejilla.length; x++) {
    hoja.setColumnWidth(x + 1, columnasRejilla[x].ancho / 7);
  }
  hoja.setColumnWidth(columnasRejilla.length + 1, 50);

  if (porDefecto != null && porDefecto != nombreHoja) {
    libro.delete(porDefecto);
  }
  final bytes = libro.save();
  if (bytes == null) throw 'No se pudo generar el Excel.';
  return Uint8List.fromList(bytes);
}

/// Nombre de pestaña válido en Excel: sin []:*?/\ y como mucho 31 caracteres.
String _nombreHoja(String nombre) {
  final limpio = nombre
      .replaceAll(RegExp(r'[\[\]:*?/\\]'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  if (limpio.isEmpty) return 'Verificaciones';
  return limpio.length > 31 ? limpio.substring(0, 31) : limpio;
}
