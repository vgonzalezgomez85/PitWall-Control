import 'dart:typed_data';

import 'package:drift/drift.dart' as d;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../core/proveedores.dart';
import '../data/database/app_database.dart';

/// Datos de una manga para el PDF.
class _MangaPdf {
  final Manga manga;
  final List<_FilaEquipo> filas;
  _MangaPdf(this.manga, this.filas);

  int get totalEquipos => filas.length;
  num get totalPuntos => filas.fold<num>(0, (s, f) => s + f.totalPuntos);
}

class _FilaEquipo {
  final int posicion;
  final String nombreEquipo;
  final String copa;
  final String? carril;
  final String piloto1Nombre;
  final num piloto1Puntos;
  final String? piloto2Nombre;
  final num piloto2Puntos;

  _FilaEquipo({
    required this.posicion,
    required this.nombreEquipo,
    required this.copa,
    this.carril,
    required this.piloto1Nombre,
    required this.piloto1Puntos,
    this.piloto2Nombre,
    required this.piloto2Puntos,
  });

  num get totalPuntos => piloto1Puntos + piloto2Puntos;
}

class GeneradorPdfMangas {
  GeneradorPdfMangas(this.ref);
  final Ref ref;

  // Paleta — diseño moderno
  static const _rojoOscuro = PdfColor.fromInt(0xFF1A0E0E);
  static const _rojoAcento = PdfColor.fromInt(0xFFD32F2F);
  static const _rojoSuave = PdfColor.fromInt(0xFFFCE4E4);
  static const _texto = PdfColor.fromInt(0xFF1A1A1A);
  static const _gris = PdfColor.fromInt(0xFF8A8A8A);
  static const _grisClaro = PdfColor.fromInt(0xFFE8E8E8);
  static const _fondo = PdfColor.fromInt(0xFFFAF7F4);

  /// Genera el PDF de las mangas de una prueba y devuelve los bytes.
  Future<Uint8List> generar({required int pruebaId}) async {
    final db = ref.read(dbProvider);
    final activo = ref.read(campeonatoActivoProvider);
    final prueba = await (db.select(db.pruebas)
          ..where((t) => t.id.equals(pruebaId)))
        .getSingle();

    // Obtener puntos brutos acumulados por piloto en este campeonato
    final puntosPiloto = await _puntosBrutosPorPiloto(db, prueba.campeonatoId);

    // Cargar mangas con sus inscritos
    final mangas = await (db.select(db.mangas)
          ..where((t) => t.pruebaId.equals(pruebaId))
          ..orderBy([(t) => d.OrderingTerm.asc(t.id)]))
        .get();

    final mangasPdf = <_MangaPdf>[];
    for (final m in mangas) {
      final inscritos = await (db.select(db.inscripciones)
            ..where((t) => t.mangaId.equals(m.id)))
          .get();
      final filas = <_FilaEquipo>[];
      for (final ins in inscritos) {
        final eq = await (db.select(db.equipos)
              ..where((t) => t.id.equals(ins.equipoId)))
            .getSingle();
        final p1 = await (db.select(db.pilotos)
              ..where((t) => t.id.equals(eq.piloto1Id)))
            .getSingle();
        final p1Pts = puntosPiloto[p1.id] ?? 0;
        Piloto? p2;
        num p2Pts = 0;
        if (eq.piloto2Id != null) {
          final pid2 = eq.piloto2Id!;
          p2 = await (db.select(db.pilotos)
                ..where((t) => t.id.equals(pid2)))
              .getSingleOrNull();
          if (p2 != null) p2Pts = puntosPiloto[p2.id] ?? 0;
        }
        filas.add(_FilaEquipo(
          posicion: 0, // se calcula tras ordenar
          nombreEquipo: eq.nombre,
          copa: eq.copa,
          carril: ins.carrilSalida,
          piloto1Nombre: p1.nombre,
          piloto1Puntos: p1Pts,
          piloto2Nombre: p2?.nombre,
          piloto2Puntos: p2Pts,
        ));
      }
      // Ordenar por totalPuntos desc; desempate por nombre
      filas.sort((a, b) {
        final c = b.totalPuntos.compareTo(a.totalPuntos);
        return c != 0 ? c : a.nombreEquipo.compareTo(b.nombreEquipo);
      });
      // Asignar posición
      final renum = <_FilaEquipo>[];
      for (var i = 0; i < filas.length; i++) {
        final f = filas[i];
        renum.add(_FilaEquipo(
          posicion: i + 1,
          nombreEquipo: f.nombreEquipo,
          copa: f.copa,
          carril: f.carril,
          piloto1Nombre: f.piloto1Nombre,
          piloto1Puntos: f.piloto1Puntos,
          piloto2Nombre: f.piloto2Nombre,
          piloto2Puntos: f.piloto2Puntos,
        ));
      }
      mangasPdf.add(_MangaPdf(m, renum));
    }

    final pdf = pw.Document(
      title: 'Mangas ${prueba.nombre}',
      author: 'Resisbarna',
    );

    final fmtFecha = DateFormat("EEEE d 'de' MMMM y", 'es_ES');
    final fechaTexto =
        prueba.fecha == null ? '' : fmtFecha.format(prueba.fecha!);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(22, 22, 22, 22),
        header: (ctx) => ctx.pageNumber == 1
            ? _hero(
                campeonato: activo?.nombre ?? '',
                prueba: prueba.nombre,
                fecha: fechaTexto,
                totalEquipos:
                    mangasPdf.fold<int>(0, (s, m) => s + m.totalEquipos),
                totalMangas: mangasPdf.length,
              )
            : _headerSecundario(prueba.nombre),
        footer: (ctx) => _footer(ctx.pageNumber, ctx.pagesCount),
        build: (ctx) {
          final children = <pw.Widget>[];
          children.add(pw.SizedBox(height: 10));
          for (final m in mangasPdf) {
            // Banda con título de la manga (se imprime una vez por manga)
            children.add(_bandaManga(m));
            // Cabecera de columnas
            children.add(pw.Container(
              color: PdfColors.white,
              padding: const pw.EdgeInsets.fromLTRB(10, 6, 10, 4),
              child: _cabeceraTabla(),
            ));
            children.add(pw.Container(
              color: _grisClaro,
              height: 0.5,
            ));
            // Filas — cada una un widget separado para que pueda paginarse
            for (var i = 0; i < m.filas.length; i++) {
              children.add(_filaTabla(m.filas[i], i));
            }
            children.add(pw.SizedBox(height: 12));
          }
          return children;
        },
      ),
    );

    return pdf.save();
  }

  Future<Map<int, num>> _puntosBrutosPorPiloto(
      AppDatabase db, int campeonatoId) async {
    final pruebas = await (db.select(db.pruebas)
          ..where((t) => t.campeonatoId.equals(campeonatoId)))
        .get();
    final pids = pruebas.map((p) => p.id).toSet();
    final mgs = await (db.select(db.mangas)
          ..where((t) => t.pruebaId.isIn(pids)))
        .get();
    final mids = mgs.map((m) => m.id).toSet();
    final res = mids.isEmpty
        ? <Resultado>[]
        : await (db.select(db.resultados)
              ..where((t) => t.mangaId.isIn(mids)))
            .get();
    final map = <int, num>{};
    for (final r in res) {
      map.update(r.pilotoId, (v) => v + r.puntos, ifAbsent: () => r.puntos);
    }
    // fallback: saldo año anterior si no hay puntos
    final hay = map.values.any((v) => v > 0);
    if (!hay) {
      final perfiles = await (db.select(db.pilotoCampeonato)
            ..where((t) => t.campeonatoId.equals(campeonatoId)))
          .get();
      for (final p in perfiles) {
        map[p.pilotoId] = p.saldoTemporadaAnterior;
      }
    }
    return map;
  }

  // ---- HERO ----

  pw.Widget _hero({
    required String campeonato,
    required String prueba,
    required String fecha,
    required int totalEquipos,
    required int totalMangas,
  }) {
    return pw.Container(
      width: double.infinity,
      decoration: pw.BoxDecoration(
        gradient: pw.LinearGradient(
          begin: pw.Alignment.topLeft,
          end: pw.Alignment.bottomRight,
          colors: const [_rojoOscuro, _rojoAcento],
        ),
        borderRadius: pw.BorderRadius.circular(12),
      ),
      padding: const pw.EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                campeonato.toUpperCase(),
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 9,
                  letterSpacing: 2.5,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                    horizontal: 7, vertical: 2),
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  borderRadius: pw.BorderRadius.circular(20),
                ),
                child: pw.Text(
                  'MANGAS',
                  style: pw.TextStyle(
                    color: _rojoAcento,
                    fontSize: 8,
                    letterSpacing: 1.2,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            prueba.toUpperCase(),
            style: pw.TextStyle(
              color: PdfColors.white,
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              letterSpacing: 0.4,
            ),
          ),
          if (fecha.isNotEmpty) ...[
            pw.SizedBox(height: 2),
            pw.Text(
              fecha,
              style: const pw.TextStyle(
                color: PdfColors.white,
                fontSize: 11,
              ),
            ),
          ],
          pw.SizedBox(height: 8),
          pw.Row(
            children: [
              _statHero('$totalMangas', totalMangas == 1 ? 'manga' : 'mangas'),
              pw.SizedBox(width: 20),
              _statHero(
                  '$totalEquipos', totalEquipos == 1 ? 'equipo' : 'equipos'),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _statHero(String numero, String etiqueta) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Text(
          numero,
          style: pw.TextStyle(
            color: PdfColors.white,
            fontSize: 22,
            fontWeight: pw.FontWeight.bold,
            height: 1,
          ),
        ),
        pw.SizedBox(width: 4),
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 2),
          child: pw.Text(
            etiqueta,
            style: const pw.TextStyle(
              color: PdfColors.white,
              fontSize: 9,
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _headerSecundario(String prueba) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.fromLTRB(20, 10, 20, 10),
      decoration: pw.BoxDecoration(
        color: _rojoOscuro,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(prueba.toUpperCase(),
              style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  letterSpacing: 1)),
          pw.Text('MANGAS',
              style: pw.TextStyle(
                  color: _rojoAcento,
                  fontSize: 10,
                  letterSpacing: 2,
                  fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }

  // ---- BANDA DE MANGA ----

  pw.Widget _bandaManga(_MangaPdf m) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.fromLTRB(14, 8, 14, 8),
      decoration: pw.BoxDecoration(
        gradient: pw.LinearGradient(
          begin: pw.Alignment.centerLeft,
          end: pw.Alignment.centerRight,
          colors: const [_rojoAcento, _rojoOscuro],
        ),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Row(
            children: [
              pw.Container(
                width: 8,
                height: 8,
                decoration: const pw.BoxDecoration(
                  color: PdfColors.white,
                  shape: pw.BoxShape.circle,
                ),
              ),
              pw.SizedBox(width: 8),
              pw.Text(
                m.manga.nombre.toUpperCase(),
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 13,
                  fontWeight: pw.FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          pw.Row(
            children: [
              _badgeBlanco('${m.totalEquipos} eq.'),
              pw.SizedBox(width: 6),
              _badgeBlanco('${m.totalPuntos} pts'),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _badgeBlanco(String texto) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Text(texto,
          style: pw.TextStyle(
              color: _rojoOscuro,
              fontSize: 9,
              fontWeight: pw.FontWeight.bold)),
    );
  }

  pw.Widget _cabeceraTabla() {
    pw.Widget col(String texto, int flex, {pw.TextAlign? align}) {
      return pw.Expanded(
        flex: flex,
        child: pw.Text(
          texto,
          textAlign: align,
          style: pw.TextStyle(
            color: _gris,
            fontSize: 8,
            fontWeight: pw.FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      );
    }

    return pw.Row(
      children: [
        col('#', 2),
        col('EQUIPO', 12),
        col('PILOTOS', 16),
        col('PUNTOS', 5, align: pw.TextAlign.right),
        col('COPA', 4, align: pw.TextAlign.right),
        col('CARRIL', 4, align: pw.TextAlign.right),
      ],
    );
  }

  pw.Widget _filaTabla(_FilaEquipo f, int idx) {
    final fondo = idx.isEven ? PdfColors.white : _fondo;
    final pos = f.posicion;
    PdfColor colorPos = _grisClaro;
    PdfColor colorPosFg = _texto;
    if (pos == 1) {
      colorPos = const PdfColor.fromInt(0xFFFFC107);
      colorPosFg = PdfColors.white;
    } else if (pos == 2) {
      colorPos = const PdfColor.fromInt(0xFFBDBDBD);
      colorPosFg = PdfColors.white;
    } else if (pos == 3) {
      colorPos = const PdfColor.fromInt(0xFFCD7F32);
      colorPosFg = PdfColors.white;
    }

    return pw.Container(
      color: fondo,
      padding: const pw.EdgeInsets.fromLTRB(10, 4, 10, 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Expanded(
            flex: 2,
            child: pw.Container(
              width: 18,
              height: 18,
              alignment: pw.Alignment.center,
              decoration: pw.BoxDecoration(
                color: colorPos,
                shape: pw.BoxShape.circle,
              ),
              child: pw.Text(
                '$pos',
                style: pw.TextStyle(
                  color: colorPosFg,
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 9,
                ),
              ),
            ),
          ),
          pw.Expanded(
            flex: 12,
            child: pw.Text(
              f.nombreEquipo,
              style: pw.TextStyle(
                color: _texto,
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.Expanded(
            flex: 16,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisSize: pw.MainAxisSize.min,
              children: [
                pw.Text(
                  '${f.piloto1Nombre}  ·  ${f.piloto1Puntos} pts',
                  style: const pw.TextStyle(color: _texto, fontSize: 8),
                ),
                if (f.piloto2Nombre != null)
                  pw.Text(
                    '${f.piloto2Nombre}  ·  ${f.piloto2Puntos} pts',
                    style: const pw.TextStyle(color: _texto, fontSize: 8),
                  ),
              ],
            ),
          ),
          pw.Expanded(
            flex: 5,
            child: pw.Text(
              '${f.totalPuntos}',
              textAlign: pw.TextAlign.right,
              style: pw.TextStyle(
                color: _rojoAcento,
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.Expanded(
            flex: 4,
            child: pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                    horizontal: 5, vertical: 1),
                decoration: pw.BoxDecoration(
                  color: _rojoSuave,
                  borderRadius: pw.BorderRadius.circular(3),
                ),
                child: pw.Text(
                  f.copa,
                  style: pw.TextStyle(
                    color: _rojoAcento,
                    fontSize: 8,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          pw.Expanded(
            flex: 4,
            child: pw.Text(
              f.carril ?? '—',
              textAlign: pw.TextAlign.right,
              style: pw.TextStyle(
                color: f.carril == null ? _gris : _texto,
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---- FOOTER ----

  pw.Widget _footer(int pag, int total) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 12),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'RESISBARNA',
            style: pw.TextStyle(
              color: _gris,
              fontSize: 8,
              letterSpacing: 2,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(
            'Página $pag / $total',
            style: const pw.TextStyle(color: _gris, fontSize: 8),
          ),
        ],
      ),
    );
  }
}

final generadorPdfMangasProvider = Provider<GeneradorPdfMangas>((ref) {
  return GeneradorPdfMangas(ref);
});
