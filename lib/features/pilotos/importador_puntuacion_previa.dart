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

/// Fila lista para importar: nombre de piloto + su puntuación de la
/// temporada anterior (usada como semilla de orden solo hasta que el
/// campeonato tenga resultados propios — a partir de la primera prueba
/// disputada, la clasificación real toma el relevo automáticamente).
class PuntuacionImportada {
  String nombre;
  int puntuacion;

  /// 'ok' (piloto inscrito en el campeonato activo, se actualizará) |
  /// 'no_existe' (no hay ningún piloto con ese nombre en el campeonato).
  String estado;
  int? pilotoId;
  bool importar;

  /// La celda tenía una fórmula (p.ej. VLOOKUP) sin valor calculado en
  /// caché, así que no se pudo leer un número real — [puntuacion] es 0
  /// por defecto pero probablemente no es el valor que buscabas.
  bool esFormulaSinValor;

  PuntuacionImportada({
    required this.nombre,
    required this.puntuacion,
    this.estado = 'ok',
    this.pilotoId,
    this.importar = true,
    this.esFormulaSinValor = false,
  });
}

class MapeoPuntuacion {
  String? colNombre;
  String? colPuntuacion;

  bool get esValido => colNombre != null && colPuntuacion != null;
}

class ImportadorPuntuacionPrevia {
  static Future<({List<String> columnas, List<Map<String, String>> filas})>
      leerArchivo(String path) async {
    final ext = path.toLowerCase().split('.').last;
    if (ext == 'csv') return _leerCsv(path);
    if (ext == 'xlsx' || ext == 'xls') return _leerExcel(path);
    throw Exception('Formato no soportado: $ext. Usa .csv o .xlsx');
  }

  static Future<({List<String> columnas, List<Map<String, String>> filas})>
      _leerCsv(String path) async {
    final contenido = await File(path).readAsString(encoding: utf8);
    final filas = Csv(skipEmptyLines: true).decode(contenido);
    return _normalizar(filas);
  }

  static Future<({List<String> columnas, List<Map<String, String>> filas})>
      _leerExcel(String path) async {
    final bytes = await File(path).readAsBytes();
    final libro = Excel.decodeBytes(bytes);
    if (libro.tables.isEmpty) {
      return (columnas: <String>[], filas: <Map<String, String>>[]);
    }
    final hoja = libro.tables.values.first;
    final filas = hoja.rows
        .map((fila) =>
            fila.map((c) => (c?.value?.toString() ?? '')).toList())
        .toList();
    return _normalizar(filas);
  }

  static ({List<String> columnas, List<Map<String, String>> filas})
      _normalizar(List<List<dynamic>> filas) {
    var idxCab = -1;
    for (var i = 0; i < filas.length; i++) {
      final llenas = filas[i]
          .map((c) => c?.toString().trim() ?? '')
          .where((c) => c.isNotEmpty)
          .length;
      if (llenas >= 2) {
        idxCab = i;
        break;
      }
    }
    if (idxCab == -1) {
      return (columnas: <String>[], filas: <Map<String, String>>[]);
    }
    final columnas =
        filas[idxCab].map((c) => c?.toString().trim() ?? '').toList();
    final out = <Map<String, String>>[];
    for (var i = idxCab + 1; i < filas.length; i++) {
      final celdas = filas[i].map((c) => c?.toString().trim() ?? '').toList();
      if (!celdas.any((c) => c.isNotEmpty)) continue;
      final mapa = <String, String>{};
      for (var j = 0; j < columnas.length && j < celdas.length; j++) {
        if (columnas[j].isEmpty) continue;
        mapa[columnas[j]] = celdas[j];
      }
      if (mapa.values.every((v) => v.isEmpty)) continue;
      out.add(mapa);
    }
    return (
      columnas: columnas.where((c) => c.isNotEmpty).toList(),
      filas: out,
    );
  }

  static MapeoPuntuacion detectarMapeo(List<String> columnas) {
    final m = MapeoPuntuacion();
    for (final col in columnas) {
      final n = _norm(col);
      if (m.colNombre == null &&
          _coincide(n, ['nombre piloto', 'nombre', 'piloto', 'pilot', 'driver'])) {
        m.colNombre = col;
      } else if (m.colPuntuacion == null &&
          _coincide(n, [
            'puntuacion', 'puntuación', 'puntos', 'points', 'saldo',
            'saldo anterior', 'seed', 'ranking',
          ])) {
        m.colPuntuacion = col;
      }
    }
    return m;
  }

  static String _norm(String s) => s
      .toLowerCase()
      .replaceAll(RegExp(r'[áàä]'), 'a')
      .replaceAll(RegExp(r'[éèë]'), 'e')
      .replaceAll(RegExp(r'[íìï]'), 'i')
      .replaceAll(RegExp(r'[óòö]'), 'o')
      .replaceAll(RegExp(r'[úùü]'), 'u')
      .replaceAll(RegExp(r'[^a-z0-9 ]'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  static bool _coincide(String n, List<String> alternativas) {
    for (final a in alternativas) {
      if (n == a || n.contains(a)) return true;
    }
    return false;
  }

  static List<PuntuacionImportada> transformar(
    List<Map<String, String>> filas,
    MapeoPuntuacion mapeo,
  ) {
    final out = <PuntuacionImportada>[];
    for (final fila in filas) {
      final nombre = (fila[mapeo.colNombre] ?? '').trim();
      if (nombre.isEmpty) continue;
      final raw = fila[mapeo.colPuntuacion];
      final parseado = _parseEntero(raw);
      // Si hay texto pero no se pudo leer como número, probablemente es una
      // fórmula (p.ej. VLOOKUP) sin valor calculado en caché en el archivo.
      final esFormula = parseado == null && (raw ?? '').trim().isNotEmpty;
      out.add(PuntuacionImportada(
        nombre: nombre,
        puntuacion: parseado ?? 0,
        esFormulaSinValor: esFormula,
        importar: !esFormula,
      ));
    }
    return out;
  }

  static int? _parseEntero(String? s) {
    if (s == null || s.trim().isEmpty) return null;
    final limpio = s.trim().replaceAll(',', '.').replaceAll(' ', '');
    return int.tryParse(limpio) ?? double.tryParse(limpio)?.round();
  }
}
