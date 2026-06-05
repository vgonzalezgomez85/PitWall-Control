import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../core/proveedores.dart';
import '../data/database/app_database.dart';
import 'fotos_verificacion.dart';

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
  static const _rojoAcento = PdfColor.fromInt(0xFFD32F2F);
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

      String motor = '—';
      if (v.motorTipo == 'PROPIO') {
        final rpm = v.motorRpm == null ? '—' : '${v.motorRpm} RPM';
        final ums = v.motorUms == null ? '—' : '${v.motorUms} uMs';
        motor = 'Propio · $rpm · $ums';
      } else if (v.motor != null && v.motor!.isNotEmpty) {
        motor = 'Organización · nº ${v.motor}';
      }

      String pinon = '—';
      if (v.pinonMarca != null || v.pinonDientes != null) {
        pinon =
            '${v.pinonMarca ?? "—"} · ${v.pinonDientes ?? "—"} dientes';
      }
      String corona = '—';
      if (v.coronaMarca != null || v.coronaDientes != null) {
        corona =
            '${v.coronaMarca ?? "—"} · ${v.coronaDientes ?? "—"} dientes';
      }
      String llanD = '—';
      if (v.llantaDelMarca != null || v.llantaDelDimension != null) {
        llanD =
            '${v.llantaDelMarca ?? "—"} · ${v.llantaDelDimension ?? "—"}';
      }
      String llanT = '—';
      if (v.llantaTraMarca != null || v.llantaTraDimension != null) {
        llanT =
            '${v.llantaTraMarca ?? "—"} · ${v.llantaTraDimension ?? "—"}';
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
          _Vrow('Trencilla', v.trencilla ?? '—'),
          _Vrow('Suspensión', v.suspension ?? '—'),
          _Vrow('Bancada', v.bancada ?? '—'),
          _Vrow('Chasis', v.chasis ?? '—'),
          _Vrow('Neumático', v.neumatico ?? '—'),
        ],
        observaciones: v.observaciones,
        validada: v.validado,
        fotos: fotos,
      ));
    }
    lista.sort((a, b) => a.equipo.compareTo(b.equipo));

    final df = DateFormat('d MMM y', 'es_ES');
    final pdf = pw.Document();

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(20, 16, 20, 16),
      header: (ctx) => ctx.pageNumber == 1
          ? pw.SizedBox()
          : pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 8),
              child: pw.Text(
                '${campeonato?.nombre ?? "Campeonato"} · ${prueba.nombre}',
                style: pw.TextStyle(color: _gris, fontSize: 9),
              ),
            ),
      footer: (ctx) => pw.Container(
        alignment: pw.Alignment.centerRight,
        padding: const pw.EdgeInsets.only(top: 6),
        child: pw.Text(
          'Página ${ctx.pageNumber} / ${ctx.pagesCount}',
          style: pw.TextStyle(color: _gris, fontSize: 9),
        ),
      ),
      build: (ctx) {
        final children = <pw.Widget>[
          _hero(
            campeonato: campeonato?.nombre ?? 'Campeonato',
            prueba: prueba.nombre,
            fecha: prueba.fecha == null
                ? ''
                : df.format(prueba.fecha!),
            totalVerifs: lista.length,
          ),
          pw.SizedBox(height: 12),
        ];
        // 2 por página (en filas de 2 con altura fija ~ media página útil)
        for (var i = 0; i < lista.length; i += 2) {
          final a = lista[i];
          final b = (i + 1 < lista.length) ? lista[i + 1] : null;
          children.add(pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(child: _verifCard(a)),
              pw.SizedBox(width: 10),
              pw.Expanded(
                child: b == null ? pw.SizedBox() : _verifCard(b),
              ),
            ],
          ));
          children.add(pw.SizedBox(height: 10));
        }
        return children;
      },
    ));
    return pdf.save();
  }

  String _peso(double? ini, double? min) {
    if (ini == null) return '—';
    final cumple = (min == null) ? '' : (ini >= min ? '  ✓' : '  ✗');
    return '${ini.toStringAsFixed(2)} g${min == null ? '' : ' (min ${min.toStringAsFixed(2)})'}$cumple';
  }

  String _pesoEntero(double? ini, double? fin) {
    if (ini == null && fin == null) return '—';
    final iniS = ini == null ? '—' : '${ini.toStringAsFixed(2)} g';
    final finS = fin == null ? '—' : '${fin.toStringAsFixed(2)} g';
    return 'inicio: $iniS · fin: $finS';
  }

  // ---- HERO ----
  pw.Widget _hero({
    required String campeonato,
    required String prueba,
    required String fecha,
    required int totalVerifs,
  }) {
    return pw.Container(
      width: double.infinity,
      decoration: pw.BoxDecoration(
        gradient: pw.LinearGradient(
          begin: pw.Alignment.topLeft,
          end: pw.Alignment.bottomRight,
          colors: const [_rojoOscuro, _rojoAcento],
        ),
        borderRadius: pw.BorderRadius.circular(10),
      ),
      padding: const pw.EdgeInsets.fromLTRB(18, 12, 18, 12),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            campeonato.toUpperCase(),
            style: pw.TextStyle(
                color: PdfColors.white,
                fontSize: 9,
                letterSpacing: 2.0,
                fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'VERIFICACIONES · ${prueba.toUpperCase()}',
            style: pw.TextStyle(
                color: PdfColors.white,
                fontSize: 20,
                fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            (fecha.isEmpty ? '' : '$fecha  ·  ') +
                '$totalVerifs verificaciones',
            style: pw.TextStyle(
                color: PdfColors.white.shade(0.85), fontSize: 11),
          ),
        ],
      ),
    );
  }

  // ---- CARD ----
  pw.Widget _verifCard(_VerifData v) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _grisCl, width: 0.6),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      padding: const pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Cabecera
          pw.Row(
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(v.equipo,
                        maxLines: 2,
                        style: pw.TextStyle(
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                            color: _negro)),
                    pw.SizedBox(height: 1),
                    pw.Text(v.pilotos,
                        maxLines: 2,
                        style: pw.TextStyle(fontSize: 9, color: _gris)),
                  ],
                ),
              ),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                    horizontal: 6, vertical: 2),
                decoration: pw.BoxDecoration(
                  color: _rojoSuave,
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Text(v.copa,
                    style: pw.TextStyle(
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                        color: _rojoOscuro)),
              ),
            ],
          ),
          pw.SizedBox(height: 4),
          if (v.coche != null)
            pw.Text('Coche: ${v.coche}',
                style: pw.TextStyle(fontSize: 9, color: _negro)),
          pw.SizedBox(height: 6),
          pw.Divider(height: 0.6, color: _grisCl),
          pw.SizedBox(height: 4),
          // Filas de datos
          ...v.filas.map((r) => pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1.5),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(
                      width: 80,
                      child: pw.Text(r.etiqueta,
                          style: pw.TextStyle(
                              fontSize: 8.5, color: _gris)),
                    ),
                    pw.Expanded(
                      child: pw.Text(r.valor,
                          maxLines: 2,
                          style: pw.TextStyle(fontSize: 8.5, color: _negro)),
                    ),
                  ],
                ),
              )),
          if (v.observaciones != null && v.observaciones!.isNotEmpty) ...[
            pw.SizedBox(height: 4),
            pw.Container(
              padding: const pw.EdgeInsets.all(5),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: pw.BorderRadius.circular(4),
              ),
              child: pw.Text(v.observaciones!,
                  maxLines: 3,
                  style: pw.TextStyle(fontSize: 8, color: _negro)),
            ),
          ],
          if (v.fotos.isNotEmpty) ...[
            pw.SizedBox(height: 6),
            pw.Row(
              children: v.fotos.map((bytes) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(right: 4),
                  child: pw.ClipRRect(
                    horizontalRadius: 4,
                    verticalRadius: 4,
                    child: pw.Image(pw.MemoryImage(bytes),
                        width: 56, height: 56, fit: pw.BoxFit.cover),
                  ),
                );
              }).toList(),
            ),
          ],
          pw.SizedBox(height: 4),
          pw.Row(
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                    horizontal: 5, vertical: 1),
                decoration: pw.BoxDecoration(
                  color: v.validada ? _verde : _gris,
                  borderRadius: pw.BorderRadius.circular(3),
                ),
                child: pw.Text(
                  v.validada ? 'VALIDADA' : 'BORRADOR',
                  style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 7,
                      fontWeight: pw.FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final generadorPdfVerificacionesProvider =
    Provider<GeneradorPdfVerificaciones>(
        (ref) => GeneradorPdfVerificaciones(ref));
