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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../data/database/app_database.dart';
import '../domain/calculo_clasificacion.dart';
import '../features/clasificacion/repositorio_clasificacion.dart';
import 'exportar_config.dart';
import 'pdf_marca.dart';
import 'pdf_util.dart';

/// Genera el PDF de la clasificación general (o de una copa concreta),
/// siempre en una sola hoja (A4 -> A3 si no cabe).
///
/// Diseño: cabecera con gradiente rojo y "RESISBARNA" en la fuente Base 02,
/// medallas oro/plata/bronce por prueba y en la general, y pie con los
/// logos de los patrocinadores.
class GeneradorPdfClasificacion {
  GeneradorPdfClasificacion(this.ref);
  final Ref ref;

  static const _texto = PdfColor.fromInt(0xFF1A1A1A);
  static const _gris = PdfColor.fromInt(0xFF8A8A8A);
  static const _grisClaro = PdfColor.fromInt(0xFFE8E8E8);
  static const _rojo = PdfColor.fromInt(0xFFD32F2F);
  static const _rojoOscuro = PdfColor.fromInt(0xFF1A0E0E);
  static const _rojoSuave = PdfColor.fromInt(0xFFFCE4E4);
  static const _fondoZebra = PdfColor.fromInt(0xFFFAF5F2);
  static const _oro = PdfColor.fromInt(0xFFF3D060);
  static const _plata = PdfColor.fromInt(0xFFD9D9D9);
  static const _bronce = PdfColor.fromInt(0xFFE3B584);
  static const _oroFg = PdfColor.fromInt(0xFF7A5C00);
  static const _plataFg = PdfColor.fromInt(0xFF555555);
  static const _bronceFg = PdfColor.fromInt(0xFF6E441A);

  Future<Uint8List> generar({
    required DatosClasificacion datos,
    required Campeonato campeonato,
    String? copa,
    IdiomaExport idioma = IdiomaExport.es,
  }) async {
    final cfg = ref.read(marcaConfigProvider);
    String t(String k) => tr(idioma, k);
    final pruebas = datos.pruebas;
    // Copa = clasificación independiente (puntos recalculados dentro de la copa).
    final filas = (copa == null
        ? List<FilaClasificacion>.from(datos.filas)
        : List<FilaClasificacion>.from(
            datos.porCopa[copa] ?? const <FilaClasificacion>[]));
    // Posiciones dentro de la vista exportada (empates comparten posición).
    CalculoClasificacion.asignarPosiciones(filas);

    // Identidad visual compartida (Base 02 + logos patrocinadores).
    final marca = await MarcaPdf.cargar();
    final tituloMarca = (campeonato.marcaTitulo?.trim().isNotEmpty ?? false)
        ? campeonato.marcaTitulo!.trim()
        : cfg.titulo;
    final lemaMarca = (campeonato.marcaLema?.trim().isNotEmpty ?? false)
        ? campeonato.marcaLema!.trim()
        : cfg.lema;

    // Umbrales de medalla por prueba: oro/plata/bronce según los puntos de
    // ESA prueba dentro de la vista exportada (empates comparten medalla).
    final medallasPorPrueba = <int, List<int>>{};
    for (final p in pruebas) {
      final valores = filas
          .map((f) => f.puntosPorPrueba[p.id] ?? 0)
          .where((v) => v > 0)
          .toSet()
          .toList()
        ..sort((a, b) => b.compareTo(a));
      medallasPorPrueba[p.id] = valores.take(3).toList();
    }

    final df = DateFormat('dd/MM/yyyy HH:mm');
    final subtitulo = copa == null
        ? t('CLASIFICACIÓN GENERAL')
        : '${t('CLASIFICACIÓN · COPA')} $copa';
    final columnas = 8 + pruebas.length;

    return pdfUnaHoja(
      filas: filas.length + 4, // hero + leyenda + pie
      columnas: columnas,
      preferApaisado: pruebas.length >= 4,
      contenido: (ctx) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          marca.hero(
            titulo: tituloMarca,
            subtitulo: '$subtitulo - ${campeonato.nombre}',
            badge: '${filas.length} ${t('pilotos')}',
            nota: df.format(DateTime.now()),
          ),
          pw.SizedBox(height: 10),
          _tabla(pruebas, filas, medallasPorPrueba, t),
          pw.SizedBox(height: 8),
          _leyenda(t),
          pw.SizedBox(height: 10),
          marca.pie(lema: lemaMarca, conApoyo: t('Con el apoyo de')),
        ],
      ),
    );
  }

  // ---------- TABLA ----------

  pw.Widget _tabla(List<Prueba> pruebas, List<FilaClasificacion> filas,
      Map<int, List<int>> medallas, String Function(String) t) {
    final anchos = <int, pw.TableColumnWidth>{
      0: const pw.FixedColumnWidth(28),
      1: const pw.FlexColumnWidth(2.6),
      2: const pw.FlexColumnWidth(2.2),
      3: const pw.FlexColumnWidth(1.1),
      4: const pw.FlexColumnWidth(1),
    };
    for (var i = 0; i < pruebas.length; i++) {
      anchos[5 + i] = const pw.FlexColumnWidth(0.9);
    }
    final base = 5 + pruebas.length;
    anchos[base] = const pw.FlexColumnWidth(0.9);
    anchos[base + 1] = const pw.FlexColumnWidth(0.9);
    anchos[base + 2] = const pw.FlexColumnWidth(1.2);

    return pw.Table(
      border: pw.TableBorder.all(color: _grisClaro, width: 0.5),
      columnWidths: anchos,
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: _rojoOscuro),
          children: [
            _cab('#'),
            _cab(t('PILOTO'), align: pw.TextAlign.left),
            _cab(t('EQUIPO'), align: pw.TextAlign.left),
            _cab(t('COPA'), align: pw.TextAlign.left),
            _cab(t('CAT.')),
            for (final p in pruebas) _cab(p.nombre.toUpperCase()),
            _cab(t('BRUTO')),
            _cab(t('DESC.')),
            _cab(t('TOTAL')),
          ],
        ),
        ...filas.asMap().entries.map((e) {
          final i = e.key;
          final f = e.value;
          return pw.TableRow(
            decoration: pw.BoxDecoration(
                color: i.isEven ? PdfColors.white : _fondoZebra),
            children: [
              _posicion(f.posicion ?? 0),
              _celda(f.pilotoNombre, align: pw.TextAlign.left, bold: true),
              _celda(f.equipoNombre, align: pw.TextAlign.left, color: _gris),
              _celda(f.copa, align: pw.TextAlign.left),
              _celda(f.categoria, color: _gris, size: 8),
              for (final p in pruebas)
                _celdaPrueba(
                  f.puntosPorPrueba[p.id],
                  f.pruebasDescartadas.contains(p.id),
                  medallas[p.id] ?? const [],
                ),
              _celda('${f.totalBruto}', color: _gris),
              _celda(f.totalDescarte > 0 ? '-${f.totalDescarte}' : '0',
                  color: _gris),
              _celdaTotal('${f.totalNeto}'),
            ],
          );
        }),
      ],
    );
  }

  /// Posición de la general con medalla para el top-3.
  pw.Widget _posicion(int pos) {
    PdfColor? bg;
    PdfColor fg = _texto;
    if (pos == 1) {
      bg = _oro;
      fg = _oroFg;
    } else if (pos == 2) {
      bg = _plata;
      fg = _plataFg;
    } else if (pos == 3) {
      bg = _bronce;
      fg = _bronceFg;
    }
    return pw.Container(
      alignment: pw.Alignment.center,
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Container(
        width: 16,
        height: 16,
        alignment: pw.Alignment.center,
        decoration: bg == null
            ? null
            : pw.BoxDecoration(color: bg, shape: pw.BoxShape.circle),
        child: pw.Text('$pos',
            style: pw.TextStyle(
                fontSize: 9, fontWeight: pw.FontWeight.bold, color: fg)),
      ),
    );
  }

  /// Celda de puntos de una prueba con fondo oro/plata/bronce para el top-3
  /// de ESA prueba, y tachado rojo si es un descarte.
  pw.Widget _celdaPrueba(int? puntos, bool descarte, List<int> medallas) {
    // Sin resultado en prueba no disputada → guion. 0 disputado → "0".
    if (puntos == null && !descarte) return _celda('-', color: _gris);
    final v = puntos ?? 0;
    PdfColor? bg;
    PdfColor fg = _texto;
    if (v > 0 && medallas.isNotEmpty) {
      if (v == medallas[0]) {
        bg = _oro;
        fg = _oroFg;
      } else if (medallas.length > 1 && v == medallas[1]) {
        bg = _plata;
        fg = _plataFg;
      } else if (medallas.length > 2 && v == medallas[2]) {
        bg = _bronce;
        fg = _bronceFg;
      }
    }
    return pw.Container(
      color: bg,
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: pw.Text(
        '$v',
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: pw.FontWeight.bold,
          color: descarte ? _rojo : fg,
          decoration:
              descarte ? pw.TextDecoration.lineThrough : pw.TextDecoration.none,
        ),
      ),
    );
  }

  pw.Widget _celdaTotal(String t) => pw.Container(
        color: _rojoSuave,
        padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: pw.Text(t,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
                fontSize: 11, fontWeight: pw.FontWeight.bold, color: _rojo)),
      );

  pw.Widget _cab(String t, {pw.TextAlign align = pw.TextAlign.center}) =>
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 5),
        child: pw.Text(t,
            textAlign: align,
            style: pw.TextStyle(
                fontSize: 8,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
                letterSpacing: 0.5)),
      );

  pw.Widget _celda(
    String t, {
    pw.TextAlign align = pw.TextAlign.center,
    PdfColor color = _texto,
    bool bold = false,
    double size = 9,
  }) =>
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: pw.Text(t,
            textAlign: align,
            maxLines: 1,
            overflow: pw.TextOverflow.clip,
            style: pw.TextStyle(
                fontSize: size,
                color: color,
                fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal)),
      );

  // ---------- LEYENDA Y PIE ----------

  pw.Widget _leyenda(String Function(String) tf) {
    pw.Widget chip(PdfColor c, String t) => pw.Row(
          mainAxisSize: pw.MainAxisSize.min,
          children: [
            pw.Container(width: 8, height: 8, color: c),
            pw.SizedBox(width: 3),
            pw.Text(t, style: const pw.TextStyle(fontSize: 7, color: _gris)),
          ],
        );
    return pw.Row(
      children: [
        chip(_oro, '1º de la prueba'),
        pw.SizedBox(width: 10),
        chip(_plata, '2º'),
        pw.SizedBox(width: 10),
        chip(_bronce, '3º'),
        pw.SizedBox(width: 10),
        pw.Text(tf('Tachado en rojo = resultado descartado'),
            style: const pw.TextStyle(fontSize: 7, color: _gris)),
      ],
    );
  }

}

final generadorPdfClasificacionProvider =
    Provider<GeneradorPdfClasificacion>((ref) => GeneradorPdfClasificacion(ref));
