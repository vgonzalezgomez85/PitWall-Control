import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:excel/excel.dart';

/// Fila lista para importar como equipo + pilotos.
class EquipoImportado {
  String nombreEquipo;
  String piloto1Nombre;
  String? piloto2Nombre;
  String? copa;

  String? piloto1Email;
  String? piloto1Telefono;
  String? piloto1Categoria;
  String? piloto1Palmares;

  String? piloto2Email;
  String? piloto2Telefono;
  String? piloto2Categoria;
  String? piloto2Palmares;

  /// Estado calculado al cruzar con BD:
  /// - 'nuevo'          → equipo no existe → se crea
  /// - 'equipo_existe'  → ya hay un equipo con ese nombre en el campeonato (omitir)
  /// - 'sin_piloto'     → falta el nombre del piloto (omitir)
  String estado;
  bool importar;
  String? aviso;

  EquipoImportado({
    required this.nombreEquipo,
    required this.piloto1Nombre,
    this.piloto2Nombre,
    this.copa,
    this.piloto1Email,
    this.piloto1Telefono,
    this.piloto1Categoria,
    this.piloto1Palmares,
    this.piloto2Email,
    this.piloto2Telefono,
    this.piloto2Categoria,
    this.piloto2Palmares,
    this.estado = 'nuevo',
    this.importar = true,
    this.aviso,
  });
}

/// Mapeo de columnas del archivo a los campos del equipo/pilotos.
class MapeoColumnasEquipo {
  String? colEquipo;
  String? colCopa;

  String? colP1Nombre;
  String? colP1Email;
  String? colP1Telefono;
  String? colP1Categoria;
  String? colP1Palmares;

  String? colP2Nombre;
  String? colP2Email;
  String? colP2Telefono;
  String? colP2Categoria;
  String? colP2Palmares;

  bool get esValido => colEquipo != null && colP1Nombre != null;
}

class ImportadorEquipos {
  /// Lee CSV o XLSX y devuelve (cabeceras, filas como mapas).
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

  static ({List<String> columnas, List<Map<String, String>> filas})
      _normalizar(List<List<dynamic>> filas) {
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

  static MapeoColumnasEquipo detectarMapeo(List<String> columnas) {
    final m = MapeoColumnasEquipo();
    for (final col in columnas) {
      final n = _norm(col);

      // Equipo
      if (m.colEquipo == null &&
          _match(n, ['nombre equipo', 'equipo', 'team', 'nombre del equipo'])) {
        m.colEquipo = col;
        continue;
      }
      if (m.colCopa == null && _match(n, ['copa', 'categoria equipo', 'cat equipo', 'class'])) {
        m.colCopa = col;
        continue;
      }

      // Piloto 1 — buscar primero campos específicos
      if (m.colP1Email == null &&
          _match(n, [
            'piloto 1 email', 'piloto1 email', 'p1 email', 'email piloto 1',
            'correo piloto 1', 'email 1',
          ])) {
        m.colP1Email = col;
        continue;
      }
      if (m.colP1Telefono == null &&
          _match(n, [
            'piloto 1 telefono', 'p1 telefono', 'telefono piloto 1',
            'movil piloto 1', 'tel 1',
          ])) {
        m.colP1Telefono = col;
        continue;
      }
      if (m.colP1Categoria == null &&
          _match(n, [
            'piloto 1 categoria', 'p1 categoria', 'metal piloto 1',
            'categoria piloto 1', 'nivel piloto 1',
          ])) {
        m.colP1Categoria = col;
        continue;
      }
      if (m.colP1Palmares == null &&
          _match(n, [
            'piloto 1 palmares', 'palmares piloto 1', 'p1 palmares',
          ])) {
        m.colP1Palmares = col;
        continue;
      }
      if (m.colP1Nombre == null &&
          _match(n, [
            'piloto 1', 'piloto1', 'pilot 1', 'p1', 'piloto a',
            'nombre piloto 1', 'piloto 1 nombre', 'driver 1',
          ])) {
        m.colP1Nombre = col;
        continue;
      }

      // Piloto 2 — análogo
      if (m.colP2Email == null &&
          _match(n, [
            'piloto 2 email', 'piloto2 email', 'p2 email', 'email piloto 2',
            'correo piloto 2', 'email 2',
          ])) {
        m.colP2Email = col;
        continue;
      }
      if (m.colP2Telefono == null &&
          _match(n, [
            'piloto 2 telefono', 'p2 telefono', 'telefono piloto 2',
            'movil piloto 2', 'tel 2',
          ])) {
        m.colP2Telefono = col;
        continue;
      }
      if (m.colP2Categoria == null &&
          _match(n, [
            'piloto 2 categoria', 'p2 categoria', 'metal piloto 2',
            'categoria piloto 2', 'nivel piloto 2',
          ])) {
        m.colP2Categoria = col;
        continue;
      }
      if (m.colP2Palmares == null &&
          _match(n, [
            'piloto 2 palmares', 'palmares piloto 2', 'p2 palmares',
          ])) {
        m.colP2Palmares = col;
        continue;
      }
      if (m.colP2Nombre == null &&
          _match(n, [
            'piloto 2', 'piloto2', 'pilot 2', 'p2', 'piloto b',
            'nombre piloto 2', 'piloto 2 nombre', 'driver 2',
          ])) {
        m.colP2Nombre = col;
        continue;
      }
    }
    return m;
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

  static bool _match(String n, List<String> alts) {
    for (final a in alts) {
      if (n == a) return true;
      if (n.startsWith('$a ') || n.endsWith(' $a') || n.contains(' $a ')) {
        return true;
      }
    }
    return false;
  }

  /// Construye los EquipoImportado a partir del mapeo.
  static List<EquipoImportado> transformar(
    List<Map<String, String>> filas,
    MapeoColumnasEquipo m,
  ) {
    final out = <EquipoImportado>[];
    for (final fila in filas) {
      final eq = (fila[m.colEquipo] ?? '').trim();
      final p1 = (fila[m.colP1Nombre] ?? '').trim();
      if (eq.isEmpty || p1.isEmpty) continue;

      String? norm(String? v) {
        if (v == null) return null;
        final t = v.trim();
        return t.isEmpty ? null : t;
      }

      String? categoria(String? raw) {
        if (raw == null) return null;
        var c = raw.trim().toUpperCase();
        if (c.isEmpty) return null;
        if (c == 'PLATINUM') c = 'PLATINO';
        if (c == 'GOLD') c = 'ORO';
        if (c == 'SILVER') c = 'PLATA';
        if (c == 'BRONZE') c = 'BRONCE';
        return c;
      }

      out.add(EquipoImportado(
        nombreEquipo: _capitalizarEquipo(eq),
        piloto1Nombre: _formatearNombre(p1),
        piloto2Nombre: norm(fila[m.colP2Nombre])?.let(_formatearNombre),
        copa: norm(fila[m.colCopa])?.toUpperCase(),
        piloto1Email: norm(fila[m.colP1Email]),
        piloto1Telefono: norm(fila[m.colP1Telefono]),
        piloto1Categoria: categoria(fila[m.colP1Categoria]),
        piloto1Palmares: norm(fila[m.colP1Palmares]),
        piloto2Email: norm(fila[m.colP2Email]),
        piloto2Telefono: norm(fila[m.colP2Telefono]),
        piloto2Categoria: categoria(fila[m.colP2Categoria]),
        piloto2Palmares: norm(fila[m.colP2Palmares]),
      ));
    }
    return out;
  }

  static String _capitalizarEquipo(String s) {
    // Equipos suelen ir en MAYUSCULAS en el Excel original — mantenemos.
    return s.trim().toUpperCase();
  }

  static String _formatearNombre(String s) {
    return s
        .split(RegExp(r'\s+'))
        .map((p) => p.isEmpty
            ? p
            : p[0].toUpperCase() + p.substring(1).toLowerCase())
        .join(' ');
  }
}

extension on String {
  String let(String Function(String) f) => f(this);
}
