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
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:excel/excel.dart';

/// Una fila parseada del archivo de resultados.
class FilaResultadoImportada {
  int posicion;
  String nombreEquipoCsv; // como aparece en el CSV, p.ej. "APR SPORT GT"
  String nombreEquipoNormalizado; // sin el sufijo de copa
  String? copaDetectada;
  int? vueltas;
  int? milesimas; // de la columna "Coma"
  int? pole;

  /// Estado contra BD:
  /// - 'ok'                  → equipo encontrado, se importará
  /// - 'no_inscrito'         → existe equipo pero no está en esta manga
  /// - 'equipo_no_existe'    → no se encuentra
  String estado;
  int? equipoIdCoincidente;
  bool importar;

  FilaResultadoImportada({
    required this.posicion,
    required this.nombreEquipoCsv,
    required this.nombreEquipoNormalizado,
    this.copaDetectada,
    this.vueltas,
    this.milesimas,
    this.pole,
    this.estado = 'ok',
    this.equipoIdCoincidente,
    this.importar = true,
  });
}

class ImportadorResultados {
  static const _copas = ['SLOT.IT', 'GT2', 'GT', 'LMP2', 'LMP'];

  /// Lee un archivo (CSV o Excel) y extrae las filas de resultados.
  static Future<List<FilaResultadoImportada>> leerArchivo(String path) async {
    final ext = path.toLowerCase().split('.').last;
    final filas = ext == 'csv'
        ? await _leerCsv(path)
        : (ext == 'xlsx' || ext == 'xls'
            ? await _leerExcel(path)
            : throw Exception('Formato no soportado: $ext'));
    return _extraer(filas);
  }

  static Future<List<List<String>>> _leerCsv(String path) async {
    final contenido = await File(path).readAsString(encoding: utf8);
    final raw = Csv(skipEmptyLines: false).decode(contenido);
    return raw
        .map((fila) => fila.map((c) => (c ?? '').toString()).toList())
        .toList();
  }

  static Future<List<List<String>>> _leerExcel(String path) async {
    final bytes = await File(path).readAsBytes();
    final libro = Excel.decodeBytes(bytes);
    if (libro.tables.isEmpty) return [];
    final hoja = libro.tables.values.first;
    return hoja.rows
        .map((fila) =>
            fila.map((celda) => (celda?.value?.toString() ?? '')).toList())
        .toList();
  }

  /// Detecta la cabecera (fila que empieza por "Posición") y parsea las
  /// filas de datos. Soporta el formato TicTacSlot con 4 filas por equipo.
  static List<FilaResultadoImportada> _extraer(List<List<String>> filas) {
    int idxCab = -1;
    int colPos = -1;
    int colNombre = -1;
    int colVueltas = -1;
    int colComa = -1;
    int colPole = -1;

    for (var i = 0; i < filas.length; i++) {
      final fila = filas[i].map((c) => c.trim()).toList();
      for (var j = 0; j < fila.length; j++) {
        final n = _norm(fila[j]);
        if (n == 'posicion' || n == 'pos') {
          idxCab = i;
          colPos = j;
        }
      }
      if (idxCab != -1) {
        for (var j = 0; j < fila.length; j++) {
          final n = _norm(fila[j]);
          if (colNombre == -1 && (n == 'nombre' || n == 'equipo')) colNombre = j;
          if (colVueltas == -1 && (n == 'vueltas' || n == 'laps')) colVueltas = j;
          if (colComa == -1 && (n == 'coma' || n == 'decimal' || n == 'ms')) {
            colComa = j;
          }
          if (colPole == -1 && n == 'pole') colPole = j;
        }
        break;
      }
    }
    if (idxCab == -1 || colPos == -1 || colNombre == -1) return [];

    final out = <FilaResultadoImportada>[];
    for (var i = idxCab + 1; i < filas.length; i++) {
      final fila = filas[i];
      if (colPos >= fila.length) continue;
      final celdaPos = fila[colPos].trim();
      final pos = int.tryParse(celdaPos);
      if (pos == null) continue; // saltamos vuelta rápida/media/lenta y filas vacías
      final nombreCrudo = colNombre < fila.length
          ? fila[colNombre].trim()
          : '';
      if (nombreCrudo.isEmpty) continue;
      final detec = _quitarCopa(nombreCrudo);
      final vueltas = colVueltas != -1 && colVueltas < fila.length
          ? int.tryParse(fila[colVueltas].trim())
          : null;
      final coma = colComa != -1 && colComa < fila.length
          ? _parseMilesimas(fila[colComa].trim())
          : null;
      final pole = colPole != -1 && colPole < fila.length
          ? _parsePole(fila[colPole].trim())
          : null;

      out.add(FilaResultadoImportada(
        posicion: pos,
        nombreEquipoCsv: nombreCrudo,
        nombreEquipoNormalizado: detec.nombre,
        copaDetectada: detec.copa,
        vueltas: vueltas,
        milesimas: coma,
        pole: pole,
      ));
    }
    return out;
  }

  static ({String nombre, String? copa}) _quitarCopa(String s) {
    final up = s.toUpperCase().trim();
    for (final c in _copas) {
      if (up.endsWith(' $c')) {
        return (
          nombre: s.substring(0, s.length - c.length - 1).trim(),
          copa: c,
        );
      }
    }
    return (nombre: s.trim(), copa: null);
  }

  static int? _parseMilesimas(String s) {
    if (s.isEmpty) return null;
    // Acepta ",061" o "0,061" o "0.061"
    final t = s.replaceAll(',', '.').replaceAll(' ', '');
    if (t.startsWith('.')) {
      return ((double.tryParse('0$t') ?? 0) * 1000).round();
    }
    final d = double.tryParse(t);
    if (d == null) return null;
    return (d * 1000).round();
  }

  static int? _parsePole(String s) {
    if (s.isEmpty) return null;
    final t = s.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(t);
  }

  static String _norm(String s) {
    return s
        .toLowerCase()
        .replaceAll(RegExp(r'[áàä]'), 'a')
        .replaceAll(RegExp(r'[éèë]'), 'e')
        .replaceAll(RegExp(r'[íìï]'), 'i')
        .replaceAll(RegExp(r'[óòö]'), 'o')
        .replaceAll(RegExp(r'[úùü]'), 'u')
        .replaceAll(RegExp(r'[^a-z0-9 ]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
