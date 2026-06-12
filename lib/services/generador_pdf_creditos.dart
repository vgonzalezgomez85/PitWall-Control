import 'dart:typed_data';

import 'package:drift/drift.dart' as d;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../core/proveedores.dart';
import 'pdf_marca.dart';
import 'pdf_util.dart';

class _FilaPiloto {
  final String nombre;
  final int inicial;
  final int sumados;
  final int restados;
  final int actual;
  _FilaPiloto({
    required this.nombre,
    required this.inicial,
    required this.sumados,
    required this.restados,
    required this.actual,
  });
}

class GeneradorPdfCreditos {
  GeneradorPdfCreditos(this.ref);
  final Ref ref;

  static const _texto = PdfColor.fromInt(0xFF1A1A1A);
  static const _gris = PdfColor.fromInt(0xFF8A8A8A);
  static const _grisClaro = PdfColor.fromInt(0xFFE8E8E8);
  static const _rojo = PdfColor.fromInt(0xFFD32F2F);
  static const _verde = PdfColor.fromInt(0xFF2E7D32);

  Future<Uint8List> generar() async {
    final db = ref.read(dbProvider);
    final activo = ref.read(campeonatoActivoProvider);
    if (activo == null) return Uint8List(0);

    // Solo pilotos que han participado (con inscripción en alguna prueba).
    final pruebas = await (db.select(db.pruebas)
          ..where((t) => t.campeonatoId.equals(activo.id)))
        .get();
    final participantes = <int>{};
    if (pruebas.isNotEmpty) {
      final ids = pruebas.map((p) => p.id).toList();
      final inscritos = await (db.select(db.inscripcionesPrueba)
            ..where((t) => t.pruebaId.isIn(ids)))
          .get();
      final equipoIds = inscritos.map((i) => i.equipoId).toSet().toList();
      if (equipoIds.isNotEmpty) {
        final equipos = await (db.select(db.equipos)
              ..where((t) => t.id.isIn(equipoIds)))
            .get();
        for (final e in equipos) {
          participantes.add(e.piloto1Id);
          if (e.piloto2Id != null) participantes.add(e.piloto2Id!);
        }
      }
    }

    final pcs = await (db.select(db.pilotoCampeonato)
          ..where((t) => t.campeonatoId.equals(activo.id)))
        .get();

    final filas = <_FilaPiloto>[];
    for (final pc in pcs) {
      if (!participantes.contains(pc.pilotoId)) continue;
      final p = await (db.select(db.pilotos)
            ..where((t) => t.id.equals(pc.pilotoId)))
          .getSingleOrNull();
      if (p == null) continue;
      final movs = await (db.select(db.movimientosCreditos)
            ..where((t) =>
                t.pilotoId.equals(p.id) &
                t.campeonatoId.equals(activo.id))
            ..orderBy([(t) => d.OrderingTerm.asc(t.fecha)]))
          .get();
      final sumados = movs
          .where((m) => m.delta > 0)
          .fold<int>(0, (s, m) => s + m.delta);
      final restados = movs
          .where((m) => m.delta < 0)
          .fold<int>(0, (s, m) => s + m.delta.abs());
      filas.add(_FilaPiloto(
        nombre: p.nombre,
        inicial: pc.creditosIniciales,
        sumados: sumados,
        restados: restados,
        actual: pc.creditosActuales,
      ));
    }
    filas.sort((a, b) => b.actual.compareTo(a.actual));

    final df = DateFormat('dd/MM/yyyy HH:mm');
    final marca = await MarcaPdf.cargar();
    return pdfUnaHoja(
      filas: filas.length + 3, // hero + pie
      columnas: 5,
      contenido: (ctx) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
        marca.hero(
          organizacion: activo.organizacion,
          subtitulo: 'Control de créditos - ${activo.nombre}',
          badge: '${filas.length} pilotos',
          nota: df.format(DateTime.now()),
        ),
        pw.SizedBox(height: 12),
        pw.Table(
          border: pw.TableBorder.all(color: _grisClaro, width: 0.5),
          columnWidths: const {
            0: pw.FlexColumnWidth(3),
            1: pw.FlexColumnWidth(1.2),
            2: pw.FlexColumnWidth(1.2),
            3: pw.FlexColumnWidth(1.2),
            4: pw.FlexColumnWidth(1.4),
          },
          children: [
            pw.TableRow(
              decoration:
                  const pw.BoxDecoration(color: MarcaPdf.rojoOscuro),
              children: [
                _cabBlanca('PILOTO', align: pw.TextAlign.left),
                _cabBlanca('INICIAL'),
                _cabBlanca('SUMADOS'),
                _cabBlanca('RESTADOS'),
                _cabBlanca('SALDO'),
              ],
            ),
            ...filas.asMap().entries.map((e) => pw.TableRow(
                  decoration: pw.BoxDecoration(
                      color: e.key.isEven
                          ? PdfColors.white
                          : MarcaPdf.fondoZebra),
                  children: [
                    _celda(e.value.nombre,
                        align: pw.TextAlign.left, bold: true),
                    _celda('${e.value.inicial}'),
                    _celda(e.value.sumados > 0 ? '+${e.value.sumados}' : '0',
                        color: e.value.sumados > 0 ? _verde : _gris),
                    _celda(
                        e.value.restados > 0 ? '-${e.value.restados}' : '0',
                        color: e.value.restados > 0 ? _rojo : _gris),
                    _celda('${e.value.actual}',
                        bold: true,
                        color: e.value.actual < 0 ? _rojo : _texto,
                        size: 13),
                  ],
                )),
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: _grisClaro),
              children: [
                _cab('TOTAL (${filas.length} pilotos)', align: pw.TextAlign.left),
                _cab('${filas.fold<int>(0, (s, f) => s + f.inicial)}'),
                _cab('+${filas.fold<int>(0, (s, f) => s + f.sumados)}'),
                _cab('-${filas.fold<int>(0, (s, f) => s + f.restados)}'),
                _cab('${filas.fold<int>(0, (s, f) => s + f.actual)}'),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 12),
        marca.pie(),
        ],
      ),
    );
  }

  pw.Widget _cabBlanca(String t, {pw.TextAlign align = pw.TextAlign.center}) =>
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: pw.Text(t,
            textAlign: align,
            style: pw.TextStyle(
                fontSize: 9,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
                letterSpacing: 0.5)),
      );

  pw.Widget _cab(String t, {pw.TextAlign align = pw.TextAlign.center}) =>
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: pw.Text(t,
            textAlign: align,
            style: pw.TextStyle(
                fontSize: 10, fontWeight: pw.FontWeight.bold, color: _texto)),
      );

  pw.Widget _celda(
    String t, {
    pw.TextAlign align = pw.TextAlign.center,
    PdfColor color = _texto,
    bool bold = false,
    double size = 10,
  }) =>
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        child: pw.Text(t,
            textAlign: align,
            style: pw.TextStyle(
                fontSize: size,
                color: color,
                fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal)),
      );
}

final generadorPdfCreditosProvider = Provider<GeneradorPdfCreditos>(
    (ref) => GeneradorPdfCreditos(ref));
