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

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Identidad visual compartida de todos los PDF que exporta la app:
/// cabecera con degradado rojo y el título en la fuente Base 02, pie con
/// el lema y los logos de los patrocinadores, y paleta común.
class MarcaPdf {
  MarcaPdf._(this.fuenteTitulo, this.logos);

  final pw.Font? fuenteTitulo;
  final List<pw.MemoryImage> logos;

  // Paleta de marca para PDFs.
  static const texto = PdfColor.fromInt(0xFF1A1A1A);
  static const gris = PdfColor.fromInt(0xFF8A8A8A);
  static const grisClaro = PdfColor.fromInt(0xFFE8E8E8);
  static const rojo = PdfColor.fromInt(0xFFD32F2F);
  static const rojoOscuro = PdfColor.fromInt(0xFF1A0E0E);
  static const rojoSuave = PdfColor.fromInt(0xFFFCE4E4);
  static const fondoZebra = PdfColor.fromInt(0xFFFAF5F2);
  static const verde = PdfColor.fromInt(0xFF2E7D32);
  static const oro = PdfColor.fromInt(0xFFF3D060);
  static const plata = PdfColor.fromInt(0xFFD9D9D9);
  static const bronce = PdfColor.fromInt(0xFFE3B584);
  static const oroFg = PdfColor.fromInt(0xFF7A5C00);
  static const plataFg = PdfColor.fromInt(0xFF555555);
  static const bronceFg = PdfColor.fromInt(0xFF6E441A);

  static Future<Uint8List?> _asset(String path) async {
    try {
      return (await rootBundle.load(path)).buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  /// Carga la fuente y los logos. Tolerante: si falta algún asset se sigue
  /// sin él (el PDF sale igualmente, con fuente estándar o sin logos).
  static Future<MarcaPdf> cargar() async {
    final fuenteData = await _asset('assets/fonts/Base_02.ttf');
    final fuente =
        fuenteData == null ? null : pw.Font.ttf(fuenteData.buffer.asByteData());
    final logoSlotIt = await _asset('assets/logos/slot-it.png');
    final logoPolicar = await _asset('assets/logos/policar.png');
    return MarcaPdf._(fuente, [
      if (logoSlotIt != null) pw.MemoryImage(logoSlotIt),
      if (logoPolicar != null) pw.MemoryImage(logoPolicar),
    ]);
  }

  /// Cabecera estándar: el título en Base 02 sobre degradado rojo,
  /// subtítulo en mayúsculas y, a la derecha, un badge opcional (p. ej.
  /// "34 PILOTOS", "FICHA 3/7") y una nota (p. ej. la fecha).
  pw.Widget hero({
    required String titulo,
    required String subtitulo,
    String? badge,
    String? nota,
  }) {
    return pw.Container(
      width: double.infinity,
      decoration: pw.BoxDecoration(
        gradient: pw.LinearGradient(
          begin: pw.Alignment.topLeft,
          end: pw.Alignment.bottomRight,
          colors: const [rojoOscuro, rojo],
        ),
        borderRadius: pw.BorderRadius.circular(12),
      ),
      padding: const pw.EdgeInsets.fromLTRB(20, 14, 20, 14),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  titulo.toUpperCase(),
                  style: pw.TextStyle(
                    font: fuenteTitulo,
                    color: PdfColors.white,
                    fontSize: 26,
                    letterSpacing: 2,
                  ),
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  subtitulo.toUpperCase(),
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              if (badge != null)
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.white,
                    borderRadius: pw.BorderRadius.circular(20),
                  ),
                  child: pw.Text(
                    badge.toUpperCase(),
                    style: pw.TextStyle(
                      color: rojo,
                      fontSize: 8,
                      letterSpacing: 1.2,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              if (nota != null) ...[
                pw.SizedBox(height: 4),
                pw.Text(nota,
                    style: const pw.TextStyle(
                        color: PdfColors.white, fontSize: 9)),
              ],
            ],
          ),
        ],
      ),
    );
  }

  /// Pie estándar: lema + logos de patrocinadores.
  pw.Widget pie({String lema = '', String conApoyo = 'Con el apoyo de'}) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Divider(color: grisClaro, height: 1),
        pw.SizedBox(height: 8),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(
              lema,
              style: pw.TextStyle(
                  fontSize: 8,
                  color: gris,
                  letterSpacing: 1,
                  fontWeight: pw.FontWeight.bold),
            ),
            if (logos.isNotEmpty)
              pw.Row(
                children: [
                  pw.Text('$conApoyo  ',
                      style: const pw.TextStyle(fontSize: 7, color: gris)),
                  for (final l in logos) ...[
                    pw.SizedBox(width: 10),
                    pw.Image(l, height: 22),
                  ],
                ],
              ),
          ],
        ),
      ],
    );
  }
}
