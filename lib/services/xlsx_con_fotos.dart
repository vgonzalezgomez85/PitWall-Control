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
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:image/image.dart' as img;

/// Celda de texto de [HojaConFotos]; [mal] la pinta en rojo (fuera de
/// reglamento).
class CeldaXlsx {
  const CeldaXlsx(this.texto, {this.mal = false});
  final String texto;
  final bool mal;
}

/// Una hoja de cálculo con texto y, al final de cada fila, sus fotos
/// incrustadas como miniaturas (una columna por foto).
class HojaConFotos {
  HojaConFotos({
    required this.nombre,
    required this.cabecera,
    required this.anchos,
    required this.filas,
    required this.fotos,
    this.fotoReferencia,
    this.tituloReferencia = 'Foto referencia',
  })  : assert(filas.length == fotos.length),
        assert(fotoReferencia == null || fotoReferencia.length == filas.length);

  /// Nombre de la pestaña (se sanea al generar).
  final String nombre;
  final List<String> cabecera;

  /// Ancho de cada columna de [cabecera], en caracteres.
  final List<double> anchos;
  final List<List<CeldaXlsx>> filas;

  /// Bytes originales de las fotos de cada fila (cualquier formato que sepa
  /// leer el paquete `image`; las que no, salen como texto).
  final List<List<Uint8List>> fotos;

  /// Foto opcional por fila en su propia columna, antes de [fotos] (p. ej.
  /// la del catálogo del coche); null en una fila = sin foto.
  final List<Uint8List?>? fotoReferencia;
  final String tituloReferencia;
}

/// Lado mayor (px) de las fotos incrustadas: se ven como miniatura en la
/// celda, pero al ampliarlas en Excel siguen siendo legibles.
const _ladoFoto = 800;

/// Alto de una fila con fotos (puntos) y de la miniatura (px).
const _altoFilaPt = 100.0;
const _altoFilaDefPt = 15.0;
const _altoMiniPx = 115;
const _anchoColFotoCar = 25.0;

/// Margen (px) de la miniatura dentro de su celda. Generoso a propósito: deja
/// holgura para los visores que la colocan por su posición absoluta.
const _margenX = 8;
const _margenY = 9;

/// Visores de Apple (Quick Look/Numbers en macOS e iOS): colocan las fotos
/// por `a:off` (posición absoluta), no por el ancla, y miden las columnas a
/// ~8,11 px por carácter (Excel usa 7). Además dibujan la rejilla ~11 px
/// desplazada respecto a las imágenes; se compensa la mitad, por si en el
/// móvil no lo hacen. Medido con Quick Look (oct 2026).
const _pxPorCaracterApple = 8.11;
const _desfaseApplePx = 5.5;

/// Genera el .xlsx a mano (es un zip de XML): el paquete `excel` no sabe
/// incrustar imágenes. Es CPU pura (decodifica y recomprime las fotos):
/// conviene llamarlo con `Isolate.run`.
Uint8List generarXlsxConFotos(HojaConFotos h) {
  final zip = Archive();
  void fichero(String ruta, List<int> bytes) =>
      zip.addFile(ArchiveFile(ruta, bytes.length, bytes));
  void xml(String ruta, String contenido) =>
      fichero(ruta, Uint8List.fromList(_utf8(contenido)));

  // Huecos de foto de cada fila: [referencia?] + fotos; null = celda vacía.
  final hayReferencia = h.fotoReferencia?.any((f) => f != null) ?? false;
  final huecos = [
    for (var y = 0; y < h.fotos.length; y++)
      <Uint8List?>[if (hayReferencia) h.fotoReferencia![y], ...h.fotos[y]],
  ];
  final maxFotos =
      h.fotos.fold<int>(0, (m, l) => l.length > m ? l.length : m);
  final nCols = h.cabecera.length + (hayReferencia ? 1 : 0) + maxFotos;
  final colPrimeraFoto = h.cabecera.length;
  final titulosFoto = [
    if (hayReferencia) h.tituloReferencia,
    for (var i = 1; i <= maxFotos; i++) 'Foto $i',
  ];

  // --- Fotos: a JPEG reducido; la que no se pueda leer queda como texto.
  final medios = <Uint8List>[];
  final anclas = StringBuffer();
  final textosFoto = <(int, int), String>{};
  final anchoColPx = (_anchoColFotoCar * 7 + 5).round();
  // Posición absoluta (EMU) de cada columna y fila: algunos visores (Quick
  // Look/Numbers en iOS y macOS) colocan la foto por `a:off` y no por el
  // ancla; con 0,0 las apilan todas en A1.
  final xCol = <int>[_emu(_desfaseApplePx.round())];
  for (var x = 0; x < nCols; x++) {
    final w = x < h.anchos.length ? h.anchos[x] : _anchoColFotoCar;
    xCol.add(xCol.last + _emu((w * _pxPorCaracterApple).round()));
  }
  // Con fotos, todas las filas de datos miden lo mismo (fijo): si una fila
  // sin fotos creciera por su texto, desplazaría las fotos de debajo.
  final altoDatosPt = huecos.any((f) => f.any((x) => x != null))
      ? _altoFilaPt
      : null;
  final yFila = <int>[
    _emu(_desfaseApplePx.round()),
    _emu(_desfaseApplePx.round()) + _pt(_altoFilaDefPt),
  ];
  for (var y = 0; y < huecos.length; y++) {
    yFila.add(yFila.last + _pt(altoDatosPt ?? _altoFilaDefPt));
  }
  for (var y = 0; y < huecos.length; y++) {
    for (var i = 0; i < huecos[y].length; i++) {
      final original = huecos[y][i];
      if (original == null) continue;
      final foto = _reducir(original);
      if (foto == null) {
        textosFoto[(y, i)] = '(foto no compatible)';
        continue;
      }
      medios.add(foto.bytes);
      final n = medios.length;
      // Miniatura: alto fijo, ancho según proporción (sin pasar de la celda).
      var alto = _altoMiniPx;
      var ancho = (foto.ancho * alto / foto.alto).round();
      if (ancho > anchoColPx - 2 * _margenX) {
        ancho = anchoColPx - 2 * _margenX;
        alto = (foto.alto * ancho / foto.ancho).round();
      }
      // twoCellAnchor (desde-hasta dentro de la misma celda), como lo guarda
      // Excel: los visores de móvil (Quick Look/Numbers en iOS, etc.) no
      // entienden oneCellAnchor y apilan todas las fotos en A1.
      final col = colPrimeraFoto + i, fila = y + 1;
      anclas.write('<xdr:twoCellAnchor editAs="oneCell">'
          '<xdr:from><xdr:col>$col</xdr:col>'
          '<xdr:colOff>${_emu(_margenX)}</xdr:colOff>'
          '<xdr:row>$fila</xdr:row><xdr:rowOff>${_emu(_margenY)}</xdr:rowOff>'
          '</xdr:from>'
          '<xdr:to><xdr:col>$col</xdr:col>'
          '<xdr:colOff>${_emu(_margenX + ancho)}</xdr:colOff>'
          '<xdr:row>$fila</xdr:row>'
          '<xdr:rowOff>${_emu(_margenY + alto)}</xdr:rowOff>'
          '</xdr:to>'
          '<xdr:pic><xdr:nvPicPr><xdr:cNvPr id="${n + 1}" name="Foto $n"/>'
          '<xdr:cNvPicPr><a:picLocks noChangeAspect="1"/></xdr:cNvPicPr>'
          '</xdr:nvPicPr>'
          '<xdr:blipFill><a:blip r:embed="rId$n"/>'
          '<a:stretch><a:fillRect/></a:stretch></xdr:blipFill>'
          '<xdr:spPr><a:xfrm>'
          '<a:off x="${xCol[col] + _emu(_margenX)}" '
          'y="${yFila[fila] + _emu(_margenY)}"/>'
          '<a:ext cx="${_emu(ancho)}" cy="${_emu(alto)}"/></a:xfrm>'
          '<a:prstGeom prst="rect"><a:avLst/></a:prstGeom></xdr:spPr>'
          '</xdr:pic><xdr:clientData/></xdr:twoCellAnchor>');
    }
  }
  final hayFotos = medios.isNotEmpty;

  // --- Hoja
  final sd = StringBuffer();
  String celda(int x, int y, String texto, int estilo) =>
      '<c r="${_col(x)}${y + 1}" t="inlineStr" s="$estilo">'
      '<is><t xml:space="preserve">${_esc(texto)}</t></is></c>';
  // Alto fijo también en la cabecera: sin él, Apple le da otro alto y
  // descuadra la posición absoluta de las fotos.
  sd.write('<row r="1" ht="$_altoFilaDefPt" customHeight="1">');
  for (var x = 0; x < nCols; x++) {
    final t = x < h.cabecera.length
        ? h.cabecera[x]
        : titulosFoto[x - h.cabecera.length];
    sd.write(celda(x, 0, t, 1));
  }
  sd.write('</row>');
  for (var y = 0; y < h.filas.length; y++) {
    sd.write('<row r="${y + 2}"'
        '${altoDatosPt != null ? ' ht="$altoDatosPt" customHeight="1"' : ''}>');
    final fila = h.filas[y];
    for (var x = 0; x < fila.length; x++) {
      final c = fila[x];
      if (c.texto.isEmpty && !c.mal) continue;
      sd.write(celda(x, y + 1, c.texto, c.mal ? 2 : 3));
    }
    for (var i = 0; i < huecos[y].length; i++) {
      final t = textosFoto[(y, i)];
      if (t != null) sd.write(celda(colPrimeraFoto + i, y + 1, t, 3));
    }
    sd.write('</row>');
  }
  final cols = StringBuffer();
  for (var x = 0; x < nCols; x++) {
    final w = x < h.anchos.length ? h.anchos[x] : _anchoColFotoCar;
    cols.write('<col min="${x + 1}" max="${x + 1}" width="$w" customWidth="1"/>');
  }

  xml('xl/worksheets/sheet1.xml', '$_cabXml'
      '<worksheet xmlns="$_nsMain" xmlns:r="$_nsRel">'
      '<sheetViews><sheetView workbookViewId="0">'
      '<pane xSplit="1" ySplit="1" topLeftCell="B2" activePane="bottomRight" state="frozen"/>'
      '</sheetView></sheetViews>'
      '<sheetFormatPr defaultRowHeight="$_altoFilaDefPt"/>'
      '<cols>$cols</cols>'
      '<sheetData>$sd</sheetData>'
      '${hayFotos ? '<drawing r:id="rId1"/>' : ''}'
      '</worksheet>');

  if (hayFotos) {
    xml('xl/worksheets/_rels/sheet1.xml.rels', '$_cabXml'
        '<Relationships xmlns="$_nsPkgRel">'
        '<Relationship Id="rId1" Type="$_tipoRel/drawing" '
        'Target="../drawings/drawing1.xml"/></Relationships>');
    xml('xl/drawings/drawing1.xml', '$_cabXml'
        '<xdr:wsDr xmlns:xdr="http://schemas.openxmlformats.org/drawingml/2006/spreadsheetDrawing" '
        'xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" '
        'xmlns:r="$_nsRel">$anclas</xdr:wsDr>');
    final rels = StringBuffer();
    for (var n = 1; n <= medios.length; n++) {
      rels.write('<Relationship Id="rId$n" Type="$_tipoRel/image" '
          'Target="../media/foto$n.jpeg"/>');
      fichero('xl/media/foto$n.jpeg', medios[n - 1]);
    }
    xml('xl/drawings/_rels/drawing1.xml.rels', '$_cabXml'
        '<Relationships xmlns="$_nsPkgRel">$rels</Relationships>');
  }

  // --- Libro, estilos y tipos
  xml('[Content_Types].xml', '$_cabXml'
      '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">'
      '<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>'
      '<Default Extension="xml" ContentType="application/xml"/>'
      '<Default Extension="jpeg" ContentType="image/jpeg"/>'
      '<Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>'
      '<Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>'
      '<Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>'
      '${hayFotos ? '<Override PartName="/xl/drawings/drawing1.xml" ContentType="application/vnd.openxmlformats-officedocument.drawing+xml"/>' : ''}'
      '</Types>');
  xml('_rels/.rels', '$_cabXml'
      '<Relationships xmlns="$_nsPkgRel">'
      '<Relationship Id="rId1" Type="$_tipoRel/officeDocument" Target="xl/workbook.xml"/>'
      '</Relationships>');
  xml('xl/workbook.xml', '$_cabXml'
      '<workbook xmlns="$_nsMain" xmlns:r="$_nsRel"><sheets>'
      '<sheet name="${_esc(nombreHojaXlsx(h.nombre))}" sheetId="1" r:id="rId1"/>'
      '</sheets></workbook>');
  xml('xl/_rels/workbook.xml.rels', '$_cabXml'
      '<Relationships xmlns="$_nsPkgRel">'
      '<Relationship Id="rId1" Type="$_tipoRel/worksheet" Target="worksheets/sheet1.xml"/>'
      '<Relationship Id="rId2" Type="$_tipoRel/styles" Target="styles.xml"/>'
      '</Relationships>');
  // Estilos: 0 normal · 1 cabecera · 2 fuera de reglamento · 3 texto.
  xml('xl/styles.xml', '$_cabXml'
      '<styleSheet xmlns="$_nsMain">'
      '<fonts count="3">'
      '<font><sz val="11"/><name val="Calibri"/></font>'
      '<font><b/><sz val="11"/><color rgb="FFFFFFFF"/><name val="Calibri"/></font>'
      '<font><sz val="11"/><color rgb="FF9C0006"/><name val="Calibri"/></font>'
      '</fonts>'
      '<fills count="4">'
      '<fill><patternFill patternType="none"/></fill>'
      '<fill><patternFill patternType="gray125"/></fill>'
      '<fill><patternFill patternType="solid"><fgColor rgb="FF1A0E0E"/></patternFill></fill>'
      '<fill><patternFill patternType="solid"><fgColor rgb="FFFFC7CE"/></patternFill></fill>'
      '</fills>'
      '<borders count="1"><border/></borders>'
      '<cellStyleXfs count="1"><xf/></cellStyleXfs>'
      '<cellXfs count="4">'
      '<xf/>'
      '<xf fontId="1" fillId="2" applyFont="1" applyFill="1" applyAlignment="1">'
      '<alignment vertical="center"/></xf>'
      '<xf fontId="2" fillId="3" applyFont="1" applyFill="1" applyAlignment="1">'
      '<alignment vertical="center" wrapText="1"/></xf>'
      '<xf applyAlignment="1"><alignment vertical="center" wrapText="1"/></xf>'
      '</cellXfs>'
      '<cellStyles count="1"><cellStyle name="Normal" xfId="0" builtinId="0"/></cellStyles>'
      '</styleSheet>');

  return Uint8List.fromList(ZipEncoder().encode(zip)!);
}

/// Nombre de pestaña válido en Excel: sin []:*?/\ y como mucho 31 caracteres.
String nombreHojaXlsx(String nombre) {
  final limpio = nombre
      .replaceAll(RegExp(r'[\[\]:*?/\\]'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  if (limpio.isEmpty) return 'Verificaciones';
  return limpio.length > 31 ? limpio.substring(0, 31) : limpio;
}

({Uint8List bytes, int ancho, int alto})? _reducir(Uint8List original) {
  try {
    final d = img.decodeImage(original);
    if (d == null) return null;
    final r = d.width > _ladoFoto || d.height > _ladoFoto
        ? img.copyResize(d,
            width: d.width >= d.height ? _ladoFoto : null,
            height: d.height > d.width ? _ladoFoto : null)
        : d;
    return (
      bytes: Uint8List.fromList(img.encodeJpg(r, quality: 80)),
      ancho: r.width,
      alto: r.height,
    );
  } catch (_) {
    return null;
  }
}

const _cabXml =
    '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n';
const _nsMain = 'http://schemas.openxmlformats.org/spreadsheetml/2006/main';
const _nsRel =
    'http://schemas.openxmlformats.org/officeDocument/2006/relationships';
const _nsPkgRel = 'http://schemas.openxmlformats.org/package/2006/relationships';
const _tipoRel = _nsRel;

int _emu(int px) => px * 9525;
int _pt(double pt) => (pt * 12700).round();

/// Letra(s) de columna: 0 → A, 25 → Z, 26 → AA.
String _col(int x) {
  var n = x + 1;
  var s = '';
  while (n > 0) {
    final r = (n - 1) % 26;
    s = String.fromCharCode(65 + r) + s;
    n = (n - 1) ~/ 26;
  }
  return s;
}

/// Escapa XML y quita caracteres de control que Excel no admite.
String _esc(String s) => s
    .replaceAll(RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F]'), '')
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');

List<int> _utf8(String s) => const Utf8Codec().encode(s);
