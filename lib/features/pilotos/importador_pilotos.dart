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

import 'package:characters/characters.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';

/// Representación de una fila lista para importar.
class PilotoImportado {
  String nombre;
  String? categoria;
  int? creditosIniciales;
  int? creditosActuales;
  String? palmares;

  /// Estado en BD: 'nuevo' (no existe) | 'actualizar' (existe en maestro) |
  /// 'ya_inscrito' (ya está en este campeonato).
  String estado;

  /// Si el usuario decide saltar esta fila.
  bool importar;

  PilotoImportado({
    required this.nombre,
    this.categoria,
    this.creditosIniciales,
    this.creditosActuales,
    this.palmares,
    this.estado = 'nuevo',
    this.importar = true,
  });
}

/// Mapeo de columnas detectado: campo → nombre de columna en el archivo.
class MapeoColumnas {
  String? colNombre;
  String? colCategoria;
  String? colCreditosIniciales;
  String? colCreditosActuales;
  String? colPalmares;

  bool get esValido => colNombre != null;
}

class ImportadorPilotos {
  /// Lee un archivo CSV o XLSX y devuelve (cabeceras, filas como mapas).
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
    final csvDec = Csv(skipEmptyLines: true);
    final filas = csvDec.decode(contenido);
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
    final filas = hoja.rows.map((fila) {
      return fila.map((celda) => (celda?.value?.toString() ?? '')).toList();
    }).toList();
    return _normalizar(filas);
  }

  /// Detecta la cabecera (primera fila con varias celdas no vacías) y devuelve
  /// columnas + mapa por fila.
  static ({List<String> columnas, List<Map<String, String>> filas})
      _normalizar(List<List<dynamic>> filas) {
    // Saltar filas vacías o casi vacías hasta encontrar cabecera
    int idxCabecera = -1;
    for (var i = 0; i < filas.length; i++) {
      final celdas = filas[i].map((c) => c?.toString().trim() ?? '').toList();
      final llenas = celdas.where((c) => c.isNotEmpty).length;
      if (llenas >= 2) {
        idxCabecera = i;
        break;
      }
    }
    if (idxCabecera == -1) {
      return (columnas: <String>[], filas: <Map<String, String>>[]);
    }

    final columnas = filas[idxCabecera]
        .map((c) => c?.toString().trim() ?? '')
        .toList()
        .cast<String>();

    final out = <Map<String, String>>[];
    for (var i = idxCabecera + 1; i < filas.length; i++) {
      final celdas = filas[i].map((c) => c?.toString().trim() ?? '').toList();
      final tieneAlgo = celdas.any((c) => c.isNotEmpty);
      if (!tieneAlgo) continue;

      final mapa = <String, String>{};
      for (var j = 0; j < columnas.length && j < celdas.length; j++) {
        if (columnas[j].isEmpty) continue;
        mapa[columnas[j]] = celdas[j].toString();
      }
      // Saltar filas sin nombre alguno (todo vacío)
      if (mapa.values.every((v) => v.isEmpty)) continue;
      out.add(mapa);
    }
    return (columnas: columnas.where((c) => c.isNotEmpty).toList(), filas: out);
  }

  /// Intenta detectar automáticamente qué columna del archivo corresponde a cada campo.
  static MapeoColumnas detectarMapeo(List<String> columnas) {
    final m = MapeoColumnas();
    for (final col in columnas) {
      final normal = _normalizar1(col);
      if (m.colNombre == null && _coincide(normal, [
            'nombre piloto', 'nombre', 'piloto', 'pilot', 'driver',
          ])) {
        m.colNombre = col;
      } else if (m.colCategoria == null && _coincide(normal, [
            'metal', 'categoria', 'category', 'cat',
          ])) {
        m.colCategoria = col;
      } else if (m.colCreditosIniciales == null && _coincide(normal, [
            'creditos iniciales', 'creditos inicial', 'creditos2026',
            'creditos 2026', 'creditos2025', 'creditos 2025',
            'creditos finales', 'creditos final',
          ])) {
        m.colCreditosIniciales = col;
      } else if (m.colCreditosActuales == null && _coincide(normal, [
            'creditos actuales', 'creditos actual', 'creditos',
            'saldo final', 'saldo',
          ])) {
        m.colCreditosActuales = col;
      } else if (m.colPalmares == null && _coincide(normal, [
            'palmares', 'palmares historico', 'logros', 'titulos',
          ])) {
        m.colPalmares = col;
      }
    }
    return m;
  }

  static String _normalizar1(String s) {
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

  static bool _coincide(String normal, List<String> alternativas) {
    for (final a in alternativas) {
      if (normal == a) return true;
      if (normal.contains(a)) return true;
    }
    return false;
  }

  /// Convierte las filas mapeadas en PilotoImportado validados.
  static List<PilotoImportado> transformar(
    List<Map<String, String>> filas,
    MapeoColumnas mapeo,
  ) {
    final out = <PilotoImportado>[];
    for (final fila in filas) {
      final nombre = (fila[mapeo.colNombre] ?? '').trim();
      if (nombre.isEmpty) continue;

      String? cat = (fila[mapeo.colCategoria ?? ''] ?? '').trim().toUpperCase();
      if (cat.isEmpty) cat = null;
      // Normalizar variantes
      if (cat == 'PLATINUM') cat = 'PLATINO';
      if (cat == 'GOLD') cat = 'ORO';
      if (cat == 'SILVER') cat = 'PLATA';
      if (cat == 'BRONZE') cat = 'BRONCE';

      int? cIni = _parseEntero(fila[mapeo.colCreditosIniciales ?? '']);
      int? cAct = _parseEntero(fila[mapeo.colCreditosActuales ?? '']);
      cAct ??= cIni;
      cIni ??= cAct;

      out.add(PilotoImportado(
        nombre: _formatearNombre(nombre),
        categoria: cat,
        creditosIniciales: cIni,
        creditosActuales: cAct,
        palmares: (fila[mapeo.colPalmares ?? ''] ?? '').trim().isEmpty
            ? null
            : fila[mapeo.colPalmares]!.trim(),
      ));
    }
    return out;
  }

  static int? _parseEntero(String? s) {
    if (s == null || s.trim().isEmpty) return null;
    final limpio = s.trim().replaceAll(',', '.').replaceAll(' ', '');
    return int.tryParse(limpio) ?? double.tryParse(limpio)?.round();
  }

  /// Pone Cada Palabra Con Inicial Mayúscula (más legible que TODO EN MAYÚS).
  static String _formatearNombre(String s) {
    return s
        .split(RegExp(r'\s+'))
        .map((p) => p.isEmpty
            ? p
            : '${p.characters.first.toUpperCase()}${p.characters.skip(1).toString().toLowerCase()}')
        .join(' ');
  }
}
