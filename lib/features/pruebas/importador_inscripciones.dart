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

/// Resultado del parsing: una fila = un equipo que se inscribe.
class FilaInscripcion {
  String nombreEquipo;
  String? preferenciaDia;
  String? notas;

  /// Estado al cruzar con BD: 'ok' | 'equipo_no_existe' | 'ya_inscrito'
  String estado;
  int? equipoIdCoincidente; // si lo encontramos en el campeonato
  bool importar;

  FilaInscripcion({
    required this.nombreEquipo,
    this.preferenciaDia,
    this.notas,
    this.estado = 'ok',
    this.equipoIdCoincidente,
    this.importar = true,
  });
}

class MapeoInscripcion {
  String? colEquipo;
  String? colDia;
  String? colNotas;

  bool get esValido => colEquipo != null;
}

class ImportadorInscripciones {
  static Future<({List<String> columnas, List<Map<String, String>> filas})>
      leerArchivo(String path) async {
    final ext = path.toLowerCase().split('.').last;
    if (ext == 'csv') return _leerCsv(path);
    if (ext == 'xlsx' || ext == 'xls') return _leerExcel(path);
    throw Exception('Formato no soportado: $ext');
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
            fila.map((celda) => (celda?.value?.toString() ?? '')).toList())
        .toList();
    return _normalizar(filas);
  }

  static ({List<String> columnas, List<Map<String, String>> filas})
      _normalizar(List<List<dynamic>> filas) {
    int idxCab = -1;
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
    final columnas = filas[idxCab]
        .map((c) => c?.toString().trim() ?? '')
        .toList()
        .cast<String>();
    final out = <Map<String, String>>[];
    for (var i = idxCab + 1; i < filas.length; i++) {
      final celdas = filas[i].map((c) => c?.toString().trim() ?? '').toList();
      if (!celdas.any((c) => c.isNotEmpty)) continue;
      final mapa = <String, String>{};
      for (var j = 0; j < columnas.length && j < celdas.length; j++) {
        if (columnas[j].isEmpty) continue;
        mapa[columnas[j]] = celdas[j].toString();
      }
      if (mapa.values.every((v) => v.isEmpty)) continue;
      out.add(mapa);
    }
    return (columnas: columnas.where((c) => c.isNotEmpty).toList(), filas: out);
  }

  static MapeoInscripcion detectarMapeo(List<String> columnas) {
    final m = MapeoInscripcion();
    for (final col in columnas) {
      final n = _norm(col);
      if (m.colEquipo == null &&
          _match(n, ['nombre equipo', 'equipo', 'team', 'nombre del equipo'])) {
        m.colEquipo = col;
      } else if (m.colDia == null &&
          _match(n, ['dia', 'preferencia dia', 'dia preferido', 'day'])) {
        m.colDia = col;
      } else if (m.colNotas == null &&
          _match(n, ['notas', 'observaciones', 'comentarios', 'notes'])) {
        m.colNotas = col;
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

  static bool _match(String n, List<String> alts) {
    for (final a in alts) {
      if (n == a || n.contains(a)) return true;
    }
    return false;
  }

  static List<FilaInscripcion> transformar(
    List<Map<String, String>> filas,
    MapeoInscripcion m,
  ) {
    final out = <FilaInscripcion>[];
    for (final f in filas) {
      final eq = (f[m.colEquipo] ?? '').trim();
      if (eq.isEmpty) continue;
      String? norm(String? v) {
        if (v == null) return null;
        final t = v.trim();
        return t.isEmpty ? null : t;
      }
      out.add(FilaInscripcion(
        nombreEquipo: eq.toUpperCase(),
        preferenciaDia: norm(f[m.colDia]),
        notas: norm(f[m.colNotas]),
      ));
    }
    return out;
  }
}
