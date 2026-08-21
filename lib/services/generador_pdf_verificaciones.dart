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

import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../core/proveedores.dart';
import '../data/database/app_database.dart';
import 'exportar_config.dart';
import 'fotos_verificacion.dart';
import 'pdf_marca.dart';
import 'pdf_util.dart';

/// Dimensión máxima (en px) de las fotos incrustadas en el PDF. Las fotos
/// solo se muestran como miniaturas de 110x110pt, así que no hace falta
/// conservar la resolución completa capturada por la cámara.
const _maxDimFotoPdf = 500;

/// Redimensiona y recomprime una foto antes de incrustarla en el PDF. Sin
/// esto, las fotos se embeben con sus bytes originales (hasta 1600px/JPEG
/// q75 desde la cámara) aunque solo se vean como miniaturas, lo que puede
/// hacer que el PDF supere el tamaño que el share sheet nativo admite en
/// una sola llamada de canal de plataforma.
Uint8List _comprimirFotoParaPdf(Uint8List bytes) {
  try {
    final decodificada = img.decodeImage(bytes);
    if (decodificada == null) return bytes;
    final redimensionada = decodificada.width > _maxDimFotoPdf ||
            decodificada.height > _maxDimFotoPdf
        ? img.copyResize(
            decodificada,
            width: decodificada.width >= decodificada.height
                ? _maxDimFotoPdf
                : null,
            height: decodificada.height > decodificada.width
                ? _maxDimFotoPdf
                : null,
          )
        : decodificada;
    final comprimida = img.encodeJpg(redimensionada, quality: 80);
    return comprimida.length < bytes.length
        ? Uint8List.fromList(comprimida)
        : bytes;
  } catch (_) {
    return bytes;
  }
}

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
  final List<pw.MemoryImage> fotos;
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
  Future<Uint8List> generar(
      {required int pruebaId, IdiomaExport idioma = IdiomaExport.es}) async {
    final db = ref.read(dbProvider);
    String t(String k) => tr(idioma, k);
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
      // Todos los miembros del equipo (unión; cae a piloto1/2 si vacía).
      final union = await (db.select(db.equipoPilotos)
            ..where((t) => t.equipoId.equals(eq.id))
            ..orderBy([(t) => OrderingTerm.asc(t.orden)]))
          .get();
      var miembroIds = union.map((m) => m.pilotoId).toList();
      if (miembroIds.isEmpty) {
        miembroIds = [eq.piloto1Id, if (eq.piloto2Id != null) eq.piloto2Id!];
      }
      final nombresMiembros = <String>[];
      for (final id in miembroIds) {
        final p = await (db.select(db.pilotos)..where((t) => t.id.equals(id)))
            .getSingleOrNull();
        if (p != null) nombresMiembros.add(p.nombre);
      }
      CatalogoCoche? coche;
      if (v.cocheCatalogoId != null) {
        coche = await (db.select(db.catalogoCoches)
              ..where((t) => t.id.equals(v.cocheCatalogoId!)))
            .getSingleOrNull();
      }
      // Fotos (max 4). Una foto que la librería de PDF no sepa decodificar
      // (p. ej. HEIC en bruto de una versión antigua, antes de forzar JPEG
      // al capturar) se descarta en vez de tumbar la exportación entera.
      final fotos = <pw.MemoryImage>[];
      try {
        final decoded = jsonDecode(
            v.fotosJson.isEmpty ? '[]' : v.fotosJson);
        if (decoded is List) {
          for (final e in decoded.take(4)) {
            final f = await FotosVerificacion.resolver(e.toString());
            if (await f.exists()) {
              final bytes = _comprimirFotoParaPdf(await f.readAsBytes());
              try {
                fotos.add(pw.MemoryImage(bytes));
              } catch (_) {}
            }
          }
        }
      } catch (_) {}

      String motor = '-';
      if (v.motorTipo == 'PROPIO') {
        final rpm = v.motorRpm == null ? '-' : '${v.motorRpm} RPM';
        final ums = v.motorUms == null ? '-' : '${v.motorUms} uMs';
        motor = '${t('Propio')} · $rpm · $ums';
      } else if (v.motor != null && v.motor!.isNotEmpty) {
        motor = '${t('Organización')} · nº ${v.motor}';
      }

      String pinon = '-';
      if (v.pinonMarca != null || v.pinonDientes != null) {
        pinon =
            '${v.pinonMarca ?? "-"} · ${v.pinonDientes ?? "-"} ${t('dientes')}';
      }
      String corona = '-';
      if (v.coronaMarca != null || v.coronaDientes != null) {
        corona =
            '${v.coronaMarca ?? "-"} · ${v.coronaDientes ?? "-"} ${t('dientes')}';
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
        pilotos: nombresMiembros.join(' + '),
        coche: coche?.nombre,
        filas: [
          _Vrow(t('Peso carrocería'), _peso(v.pesoInicial, v.pesoMin)),
          _Vrow(t('Peso coche entero'),
              _pesoEntero(v.pesoInicialCoche, v.pesoFinalCoche, t)),
          _Vrow(t('Motor'), motor),
          _Vrow(t('Piñón'), pinon),
          _Vrow(t('Corona'), corona),
          _Vrow(t('Llanta delantera'), llanD),
          _Vrow(t('Llanta trasera'), llanT),
          _Vrow(t('Trencilla'), v.trencilla ?? '-'),
          _Vrow(t('Suspensión'), v.suspension ?? '-'),
          _Vrow(t('Bancada'), v.bancada ?? '-'),
          _Vrow(t('Chasis'), v.chasis ?? '-'),
          _Vrow(t('Neumático'), v.neumatico ?? '-'),
        ],
        observaciones: v.observaciones,
        validada: v.validado,
        fotos: fotos,
      ));
    }
    lista.sort((a, b) => a.equipo.compareTo(b.equipo));

    final df = DateFormat('d MMM y', idioma.intlLocale);
    final fechaTxt = prueba.fecha == null ? '' : df.format(prueba.fecha!);
    final pdf = pw.Document();

    // Identidad visual compartida (Base 02 + logos patrocinadores).
    final marca = await MarcaPdf.cargar();
    final tituloMarca = (campeonato?.marcaTitulo?.trim().isNotEmpty ?? false)
        ? campeonato!.marcaTitulo!.trim()
        : marcaTituloPorDefecto;
    final lemaMarca = (campeonato?.marcaLema?.trim().isNotEmpty ?? false)
        ? campeonato!.marcaLema!.trim()
        : marcaLemaPorDefecto;
    final subtitulo =
        '${t('Verificación')} · ${prueba.nombre} - ${campeonato?.nombre ?? ''}';

    // Una hoja por verificación (ficha de escrutineo por coche). Cada ficha
    // entra entera en su página (A4 y, si lleva fotos grandes, escalada).
    if (lista.isEmpty) {
      agregarHojaUnica(
        pdf,
        filas: 0,
        contenido: (ctx) => marca.hero(
          titulo: tituloMarca,
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
              titulo: tituloMarca,
              subtitulo: subtitulo,
              badge: '${t('Ficha')} ${i + 1} / ${lista.length}',
              nota: fechaTxt.isEmpty ? null : fechaTxt,
            ),
            pw.SizedBox(height: 12),
            _verifCard(v, t),
            pw.SizedBox(height: 12),
            marca.pie(lema: lemaMarca, conApoyo: t("Con el apoyo de")),
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

  String _pesoEntero(double? ini, double? fin, String Function(String) t) {
    if (ini == null && fin == null) return '-';
    final iniS = ini == null ? '-' : '${ini.toStringAsFixed(2)} g';
    final finS = fin == null ? '-' : '${fin.toStringAsFixed(2)} g';
    return '${t('inicio')}: $iniS · ${t('fin')}: $finS';
  }

  // ---- HERO ----
  // ---- FICHA (una por hoja) ----
  pw.Widget _verifCard(_VerifData v, String Function(String) t) {
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
                  child: pw.Text('${t('COPA')} ${v.copa}',
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
                    v.validada ? t('VALIDADA') : t('BORRADOR'),
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
                        pw.Text(t('OBSERVACIONES'),
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
                    children: v.fotos.map((imagen) {
                      return pw.Padding(
                        padding: const pw.EdgeInsets.only(right: 8),
                        child: pw.ClipRRect(
                          horizontalRadius: 6,
                          verticalRadius: 6,
                          child: pw.Image(imagen,
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
