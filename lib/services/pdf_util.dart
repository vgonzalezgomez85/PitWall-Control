import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Utilidades para generar PDF que **siempre caben en una sola hoja**.
///
/// Estrategia: se elige A4 y, si hay demasiados datos, se pasa a A3. Como red
/// de seguridad, el contenido se envuelve en un `FittedBox` que lo escala hacia
/// abajo si aún no cupiera, de modo que el resultado nunca desborda la página.

const double _margen = 24;

/// Elige el formato de página para que el contenido quepa en una hoja.
/// - [filas]: nº de filas de datos (para estimar la altura).
/// - [columnas]: nº de columnas (muchas columnas ⇒ apaisado).
PdfPageFormat elegirFormatoUnaHoja({
  required int filas,
  int columnas = 1,
  bool preferApaisado = false,
}) {
  final apaisado = preferApaisado || columnas >= 9;
  final a4 = apaisado ? PdfPageFormat.a4.landscape : PdfPageFormat.a4;
  final a3 = apaisado ? PdfPageFormat.a3.landscape : PdfPageFormat.a3;
  // Capacidad aproximada de filas de tabla antes de necesitar A3.
  final capacidadA4 = apaisado ? 24 : 38;
  return filas <= capacidadA4 ? a4 : a3;
}

/// Añade a [doc] una página que contiene [contenido] **garantizando que cabe**:
/// elige A4/A3 según los datos y escala el contenido hacia abajo si hiciera
/// falta. Útil para documentos con varias hojas (p. ej. una hoja por manga).
void agregarHojaUnica(
  pw.Document doc, {
  required pw.Widget Function(pw.Context contexto) contenido,
  required int filas,
  int columnas = 1,
  bool preferApaisado = false,
}) {
  final formato = elegirFormatoUnaHoja(
    filas: filas,
    columnas: columnas,
    preferApaisado: preferApaisado,
  );
  doc.addPage(
    pw.Page(
      pageFormat: formato,
      margin: const pw.EdgeInsets.all(_margen),
      build: (ctx) => pw.FittedBox(
        fit: pw.BoxFit.scaleDown,
        alignment: pw.Alignment.topCenter,
        child: pw.SizedBox(
          width: formato.width - 2 * _margen,
          child: contenido(ctx),
        ),
      ),
    ),
  );
}

/// Construye un documento PDF de **una sola página** con [contenido].
///
/// El [contenido] se renderiza al ancho disponible y, si su altura natural
/// supera la página elegida, se escala uniformemente para que entre.
Future<Uint8List> pdfUnaHoja({
  required pw.Widget Function(pw.Context contexto) contenido,
  required int filas,
  int columnas = 1,
  bool preferApaisado = false,
}) async {
  final doc = pw.Document();
  agregarHojaUnica(
    doc,
    contenido: contenido,
    filas: filas,
    columnas: columnas,
    preferApaisado: preferApaisado,
  );
  return doc.save();
}
