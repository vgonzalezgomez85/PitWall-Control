import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../core/proveedores.dart';
import '../data/database/app_database.dart';
import 'fotos_verificacion.dart';
import 'pdf_marca.dart';
import 'pdf_util.dart';

class _Vrow {
  final String etiqueta;
  final String valor;
  const _Vrow(this.etiqueta, this.valor);
}

class _VerifData {
  final String equipo;
  final String copa;
  final String pilotos;
  final String? coche;
  final List<_Vrow> filas;
  final String? observaciones;
  final bool validada;
  final List<Uint8List> fotos;
  _VerifData({
    required this.equipo,
    required this.copa,
    required this.pilotos,
    required this.coche,
    required this.filas,
    required this.observaciones,
    required this.validada,
    required this.fotos,
  });
}

class GeneradorPdfVerificaciones {
  GeneradorPdfVerificaciones(this.ref);
  final Ref ref;

  static const _negro = PdfColor.fromInt(0xFF1A1A1A);
  static const _gris = PdfColor.fromInt(0xFF8A8A8A);
  static const _grisCl = PdfColor.fromInt(0xFFE8E8E8);
  static const _rojoOscuro = PdfColor.fromInt(0xFF1A0E0E);
  static const _rojoSuave = PdfColor.fromInt(0xFFFCE4E4);
  static const _verde = PdfColor.fromInt(0xFF2E7D32);

  /// Genera el PDF de todas las verificaciones de una prueba.
  Future<Uint8List> generar({required int pruebaId}) async {
    final db = ref.read(dbProvider);
    final prueba = await (db.select(db.pruebas)
          ..where((t) => t.id.equals(pruebaId)))
        .getSingle();
    final campeonato = await (db.select(db.campeonatos)
          ..where((t) => t.id.equals(prueba.campeonatoId)))
        .getSingleOrNull();

    // Recoger verificaciones únicas por equipo (puede haber varias mangas →
    // misma verificación). Tomamos la primera no nula que encontramos por
    // equipo.
    final mangas = await (db.select(db.mangas)
          ..where((t) => t.pruebaId.equals(pruebaId)))
        .get();
    final mangaIds = mangas.map((m) => m.id).toList();
    final verifs = mangaIds.isEmpty
        ? <Verificacione>[]
        : await (db.select(db.verificaciones)
              ..where((t) => t.mangaId.isIn(mangaIds)))
            .get();
    final verifPorEquipo = <int, Verificacione>{};
    for (final v in verifs) {
      verifPorEquipo[v.equipoId] ??= v;
    }

    // Datos enriquecidos por equipo
    final lista = <_VerifData>[];
    for (final entrada in verifPorEquipo.entries) {
      final v = entrada.value;
      final eq = await (db.select(db.equipos)
            ..where((t) => t.id.equals(v.equipoId)))
          .getSingle();
      final p1 = await (db.select(db.pilotos)
            ..where((t) => t.id.equals(eq.piloto1Id)))
          .getSingle();
      Piloto? p2;
      if (eq.piloto2Id != null) {
        p2 = await (db.select(db.pilotos)
              ..where((t) => t.id.equals(eq.piloto2Id!)))
            .getSingleOrNull();
      }
      CatalogoCoche? coche;
      if (v.cocheCatalogoId != null) {
        coche = await (db.select(db.catalogoCoches)
              ..where((t) => t.id.equals(v.cocheCatalogoId!)))
            .getSingleOrNull();
      }
      // Fotos (max 4)
      final fotos = <Uint8List>[];
      try {
        final decoded = jsonDecode(
            v.fotosJson.isEmpty ? '[]' : v.fotosJson);
        if (decoded is List) {
          for (final e in decoded.take(4)) {
            final f = await FotosVerificacion.resolver(e.toString());
            if (await f.exists()) {
              fotos.add(await f.readAsBytes());
            }
          }
        }
      } catch (_) {}

      String motor = '-';
      if (v.motorTipo == 'PROPIO') {
        final rpm = v.motorRpm == null ? '-' : '${v.motorRpm} RPM';
        final ums = v.motorUms == null ? '-' : '${v.motorUms} uMs';
        motor = 'Propio · $rpm · $ums';
      } else if (v.motor != null && v.motor!.isNotEmpty) {
        motor = 'Organización · nº ${v.motor}';
      }

      String pinon = '-';
      if (v.pinonMarca != null || v.pinonDientes != null) {
        pinon =
            '${v.pinonMarca ?? "-"} · ${v.pinonDientes ?? "-"} dientes';
      }
      String corona = '-';
      if (v.coronaMarca != null || v.coronaDientes != null) {
        corona =
            '${v.coronaMarca ?? "-"} · ${v.coronaDientes ?? "-"} dientes';
      }
      String llanD = '-';
      if (v.llantaDelMarca != null || v.llantaDelDimension != null) {
        llanD =
            '${v.llantaDelMarca ?? "-"} · ${v.llantaDelDimension ?? "-"}';
      }
      String llanT = '-';
      if (v.llantaTraMarca != null || v.llantaTraDimension != null) {
        llanT =
            '${v.llantaTraMarca ?? "-"} · ${v.llantaTraDimension ?? "-"}';
      }

      lista.add(_VerifData(
        equipo: eq.nombre,
        copa: eq.copa,
        pilotos: p2 == null ? p1.nombre : '${p1.nombre} + ${p2.nombre}',
        coche: coche?.nombre,
        filas: [
          _Vrow('Peso carrocería', _peso(v.pesoInicial, v.pesoMin)),
          _Vrow('Peso coche entero',
              _pesoEntero(v.pesoInicialCoche, v.pesoFinalCoche)),
          _Vrow('Motor', motor),
          _Vrow('Piñón', pinon),
          _Vrow('Corona', corona),
          _Vrow('Llanta delantera', llanD),
          _Vrow('Llanta trasera', llanT),
          _Vrow('Trencilla', v.trencilla ?? '-'),
          _Vrow('Suspensión', v.suspension ?? '-'),
          _Vrow('Bancada', v.bancada ?? '-'),
          _Vrow('Chasis', v.chasis ?? '-'),
          _Vrow('Neumático', v.neumatico ?? '-'),
        ],
        observaciones: v.observaciones,
        validada: v.validado,
        fotos: fotos,
      ));
    }
    lista.sort((a, b) => a.equipo.compareTo(b.equipo));

    final df = DateFormat('d MMM y', 'es_ES');
    final fechaTxt = prueba.fecha == null ? '' : df.format(prueba.fecha!);
    final pdf = pw.Document();

    // Identidad visual compartida (Base 02 + logos patrocinadores).
    final marca = await MarcaPdf.cargar();
    final organizacion = campeonato?.organizacion ?? 'Resisbarna';
    final subtitulo =
        'Verificación · ${prueba.nombre} - ${campeonato?.nombre ?? ''}';

    // Una hoja por verificación (ficha de escrutineo por coche). Cada ficha
    // entra entera en su página (A4 y, si lleva fotos grandes, escalada).
    if (lista.isEmpty) {
      agregarHojaUnica(
        pdf,
        filas: 0,
        contenido: (ctx) => marca.hero(
          organizacion: organizacion,
          subtitulo: subtitulo,
          nota: fechaTxt.isEmpty ? null : fechaTxt,
        ),
      );
    }
    for (var i = 0; i < lista.length; i++) {
      final v = lista[i];
      agregarHojaUnica(
        pdf,
        filas: v.filas.length + (v.fotos.isNotEmpty ? 8 : 0),
        contenido: (ctx) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            marca.hero(
              organizacion: organizacion,
              subtitulo: subtitulo,
              badge: 'Ficha ${i + 1} / ${lista.length}',
              nota: fechaTxt.isEmpty ? null : fechaTxt,
            ),
            pw.SizedBox(height: 12),
            _verifCard(v),
            pw.SizedBox(height: 12),
            marca.pie(),
          ],
        ),
      );
    }
    return pdf.save();
  }

  String _peso(double? ini, double? min) {
    if (ini == null) return '-';
    final cumple = (min == null) ? '' : (ini >= min ? '  OK' : '  ¡NO!');
    return '${ini.toStringAsFixed(2)} g${min == null ? '' : ' (min ${min.toStringAsFixed(2)})'}$cumple';
  }

  String _pesoEntero(double? ini, double? fin) {
    if (ini == null && fin == null) return '-';
    final iniS = ini == null ? '-' : '${ini.toStringAsFixed(2)} g';
    final finS = fin == null ? '-' : '${fin.toStringAsFixed(2)} g';
    return 'inicio: $iniS · fin: $finS';
  }

  // ---- HERO ----
  // ---- FICHA (una por hoja) ----
  pw.Widget _verifCard(_VerifData v) {
    // Datos en dos columnas para aprovechar la hoja.
    final mitad = (v.filas.length + 1) ~/ 2;
    final colIzq = v.filas.take(mitad).toList();
    final colDer = v.filas.skip(mitad).toList();

    pw.Widget fila(_Vrow r) => pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 3),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(
                width: 95,
                child: pw.Text(r.etiqueta.toUpperCase(),
                    style: pw.TextStyle(
                        fontSize: 8,
                        color: _gris,
                        letterSpacing: 0.5,
                        fontWeight: pw.FontWeight.bold)),
              ),
              pw.Expanded(
                child: pw.Text(r.valor,
                    maxLines: 2,
                    style: pw.TextStyle(
                        fontSize: 10,
                        color: _negro,
                        fontWeight: pw.FontWeight.bold)),
              ),
            ],
          ),
        );

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _grisCl, width: 0.8),
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          // Cabecera de la ficha: equipo + copa + estado
          pw.Container(
            decoration: const pw.BoxDecoration(
              color: _rojoOscuro,
              borderRadius: pw.BorderRadius.only(
                topLeft: pw.Radius.circular(10),
                topRight: pw.Radius.circular(10),
              ),
            ),
            padding: const pw.EdgeInsets.fromLTRB(14, 10, 14, 10),
            child: pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(v.equipo,
                          maxLines: 1,
                          style: pw.TextStyle(
                              fontSize: 15,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.white)),
                      pw.Text(v.pilotos,
                          maxLines: 1,
                          style: pw.TextStyle(
                              fontSize: 9,
                              color: PdfColors.white.shade(0.85))),
                    ],
                  ),
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.white,
                    borderRadius: pw.BorderRadius.circular(12),
                  ),
                  child: pw.Text('COPA ${v.copa}',
                      style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                          color: _rojoOscuro)),
                ),
                pw.SizedBox(width: 6),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: pw.BoxDecoration(
                    color: v.validada ? _verde : _gris,
                    borderRadius: pw.BorderRadius.circular(12),
                  ),
                  child: pw.Text(
                    v.validada ? 'VALIDADA' : 'BORRADOR',
                    style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(14),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (v.coche != null) ...[
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: pw.BoxDecoration(
                      color: _rojoSuave,
                      borderRadius: pw.BorderRadius.circular(6),
                    ),
                    child: pw.Text(v.coche!,
                        style: pw.TextStyle(
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                            color: _rojoOscuro)),
                  ),
                  pw.SizedBox(height: 10),
                ],
                // Datos en dos columnas
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                        child: pw.Column(
                            children: colIzq.map(fila).toList())),
                    pw.SizedBox(width: 18),
                    pw.Expanded(
                        child: pw.Column(
                            children: colDer.map(fila).toList())),
                  ],
                ),
                if (v.observaciones != null &&
                    v.observaciones!.isNotEmpty) ...[
                  pw.SizedBox(height: 10),
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey100,
                      borderRadius: pw.BorderRadius.circular(6),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('OBSERVACIONES',
                            style: pw.TextStyle(
                                fontSize: 7,
                                color: _gris,
                                letterSpacing: 1,
                                fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 2),
                        pw.Text(v.observaciones!,
                            maxLines: 4,
                            style:
                                pw.TextStyle(fontSize: 9, color: _negro)),
                      ],
                    ),
                  ),
                ],
                if (v.fotos.isNotEmpty) ...[
                  pw.SizedBox(height: 10),
                  pw.Row(
                    children: v.fotos.map((bytes) {
                      return pw.Padding(
                        padding: const pw.EdgeInsets.only(right: 8),
                        child: pw.ClipRRect(
                          horizontalRadius: 6,
                          verticalRadius: 6,
                          child: pw.Image(pw.MemoryImage(bytes),
                              width: 110, height: 110, fit: pw.BoxFit.cover),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final generadorPdfVerificacionesProvider =
    Provider<GeneradorPdfVerificaciones>(
        (ref) => GeneradorPdfVerificaciones(ref));
