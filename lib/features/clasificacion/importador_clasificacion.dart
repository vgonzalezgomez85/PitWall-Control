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
import 'package:drift/drift.dart' as d;
import 'package:excel/excel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';

/// Estado de una fila tras analizar el archivo contra la BD.
enum EstadoFila { ok, pilotoNoEncontrado, sinEquipo, sinDatos }

class FilaClasificacionImport {
  /// Nombre tal como viene en el archivo.
  final String nombre;
  /// Piloto encontrado (null si no se reconoció).
  int? pilotoId;
  /// Equipo del piloto en este campeonato (null si no tiene).
  int? equipoId;
  /// Mapa de nombre de prueba → puntos importados.
  final Map<String, int> puntosPorPrueba;
  EstadoFila estado;
  bool importar;

  FilaClasificacionImport({
    required this.nombre,
    required this.puntosPorPrueba,
    this.pilotoId,
    this.equipoId,
    this.estado = EstadoFila.ok,
    this.importar = true,
  });
}

class AnalisisClasificacion {
  /// Pruebas a las que se mapean las columnas del archivo (ya existen en BD).
  final Map<String, Prueba> pruebasReconocidas;
  /// Nombres de columna que NO se han podido emparejar.
  final List<String> columnasNoReconocidas;
  /// Una fila por piloto del archivo.
  final List<FilaClasificacionImport> filas;

  AnalisisClasificacion({
    required this.pruebasReconocidas,
    required this.columnasNoReconocidas,
    required this.filas,
  });

  int get pilotosOk =>
      filas.where((f) => f.estado == EstadoFila.ok).length;
  int get pilotosKo => filas.length - pilotosOk;
}

class ImportadorClasificacion {
  ImportadorClasificacion(this.db);
  final AppDatabase db;

  /// Lee un archivo CSV/Excel y devuelve la tabla en bruto.
  static Future<List<List<String>>> leerArchivo(String path) async {
    final ext = path.toLowerCase().split('.').last;
    if (ext == 'csv') return _leerCsv(path);
    if (ext == 'xlsx' || ext == 'xls') return _leerExcel(path);
    throw Exception('Formato no soportado: $ext');
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
            fila.map((c) => (c?.value?.toString() ?? '')).toList())
        .toList();
  }

  /// Detecta la cabecera, mapea columnas a pruebas del campeonato activo y
  /// devuelve un análisis con preview. No escribe nada en la BD.
  Future<AnalisisClasificacion> analizar({
    required int campeonatoId,
    required List<List<String>> tabla,
  }) async {
    // 1) Buscar fila de cabecera: la primera que contiene una columna
    //    "piloto" / "nombre" / "equipo" o similar.
    int idxCab = -1;
    int colNombre = -1;
    for (var i = 0; i < tabla.length; i++) {
      final fila = tabla[i].map((c) => c.trim()).toList();
      for (var j = 0; j < fila.length; j++) {
        final n = _norm(fila[j]);
        if (n == 'piloto' || n == 'pilotos' || n == 'nombre' ||
            n == 'equipo' || n == 'driver') {
          idxCab = i;
          colNombre = j;
          break;
        }
      }
      if (idxCab >= 0) break;
    }
    if (idxCab < 0) {
      throw 'No encuentro la columna del piloto. La primera fila debe '
          'contener una columna llamada "Piloto", "Nombre" o "Equipo".';
    }

    final cabecera = tabla[idxCab].map((c) => c.trim()).toList();
    // 2) Pruebas del campeonato (para emparejar columnas por nombre).
    final pruebas = await (db.select(db.pruebas)
          ..where((t) => t.campeonatoId.equals(campeonatoId))
          ..orderBy([(t) => d.OrderingTerm.asc(t.orden)]))
        .get();
    final pruebasPorNombre = <String, Prueba>{
      for (final p in pruebas) _norm(p.nombre): p,
    };

    // 3) Mapear columnas → prueba (saltando la del piloto y la de "total").
    final colAPrueba = <int, Prueba>{};
    final columnasNoRec = <String>[];
    for (var j = 0; j < cabecera.length; j++) {
      if (j == colNombre) continue;
      final raw = cabecera[j];
      if (raw.isEmpty) continue;
      final n = _norm(raw);
      if (n == 'total' || n == 'puntos' || n == 'pts') continue;
      final p = pruebasPorNombre[n];
      if (p != null) {
        colAPrueba[j] = p;
      } else {
        columnasNoRec.add(raw);
      }
    }

    // 4) Resolver pilotos: con perfil en el campeonato + equipo.
    final perfiles = await (db.select(db.pilotoCampeonato)
          ..where((t) => t.campeonatoId.equals(campeonatoId)))
        .get();
    final pilotoIdsEnCamp = perfiles.map((p) => p.pilotoId).toSet();
    final pilotos = pilotoIdsEnCamp.isEmpty
        ? <Piloto>[]
        : await (db.select(db.pilotos)
              ..where((t) => t.id.isIn(pilotoIdsEnCamp.toList())))
            .get();
    final pilotosPorNombre = <String, Piloto>{
      for (final p in pilotos) _norm(p.nombre): p,
    };
    final equipos = await (db.select(db.equipos)
          ..where((t) => t.campeonatoId.equals(campeonatoId)))
        .get();
    final equipoPorPiloto = <int, int>{};
    for (final e in equipos) {
      equipoPorPiloto[e.piloto1Id] = e.id;
      if (e.piloto2Id != null) equipoPorPiloto[e.piloto2Id!] = e.id;
    }

    // 5) Procesar filas de datos.
    final filas = <FilaClasificacionImport>[];
    for (var i = idxCab + 1; i < tabla.length; i++) {
      final fila = tabla[i];
      if (colNombre >= fila.length) continue;
      final nombre = fila[colNombre].trim();
      if (nombre.isEmpty) continue;

      final puntos = <String, int>{};
      for (final entry in colAPrueba.entries) {
        final j = entry.key;
        if (j >= fila.length) continue;
        final v = _parseInt(fila[j]);
        if (v == null) continue;
        puntos[entry.value.nombre] = v;
      }

      final piloto = pilotosPorNombre[_norm(nombre)];
      EstadoFila estado;
      int? eqId;
      if (piloto == null) {
        estado = EstadoFila.pilotoNoEncontrado;
      } else {
        eqId = equipoPorPiloto[piloto.id];
        if (eqId == null) {
          estado = EstadoFila.sinEquipo;
        } else if (puntos.values.every((v) => v == 0) && puntos.isEmpty) {
          estado = EstadoFila.sinDatos;
        } else {
          estado = EstadoFila.ok;
        }
      }

      filas.add(FilaClasificacionImport(
        nombre: nombre,
        puntosPorPrueba: puntos,
        pilotoId: piloto?.id,
        equipoId: eqId,
        estado: estado,
        importar: estado == EstadoFila.ok,
      ));
    }

    return AnalisisClasificacion(
      pruebasReconocidas: {
        for (final e in colAPrueba.entries) e.value.nombre: e.value,
      },
      columnasNoReconocidas: columnasNoRec,
      filas: filas,
    );
  }

  /// Aplica el análisis: para cada prueba reconocida, asegura que existe una
  /// manga "IMPORTADA" donde colgar los resultados, borra los resultados
  /// previos importados para los pilotos seleccionados y los reinserta.
  Future<({int pilotos, int registros})> aplicar({
    required int campeonatoId,
    required AnalisisClasificacion analisis,
  }) async {
    var totalPilotos = 0, totalRegistros = 0;
    // Cache de mangaId por pruebaId.
    final mangaPorPrueba = <int, int>{};
    for (final p in analisis.pruebasReconocidas.values) {
      final existente = await (db.select(db.mangas)
            ..where((t) =>
                t.pruebaId.equals(p.id) & t.nombre.equals('IMPORTADA')))
          .getSingleOrNull();
      if (existente != null) {
        mangaPorPrueba[p.id] = existente.id;
      } else {
        final id = await db.into(db.mangas).insert(
              MangasCompanion.insert(
                pruebaId: p.id,
                nombre: 'IMPORTADA',
                estado: const d.Value('FINALIZADA'),
              ),
            );
        mangaPorPrueba[p.id] = id;
      }
    }

    for (final f in analisis.filas) {
      if (!f.importar) continue;
      if (f.pilotoId == null || f.equipoId == null) continue;
      var aplicadas = 0;
      for (final entry in f.puntosPorPrueba.entries) {
        final prueba = analisis.pruebasReconocidas[entry.key];
        if (prueba == null) continue;
        final mangaId = mangaPorPrueba[prueba.id]!;
        // Reemplazar el resultado previo de este piloto en esta manga.
        await (db.delete(db.resultados)
              ..where((t) =>
                  t.mangaId.equals(mangaId) &
                  t.pilotoId.equals(f.pilotoId!)))
            .go();
        await db.into(db.resultados).insert(
              ResultadosCompanion.insert(
                mangaId: mangaId,
                pilotoId: f.pilotoId!,
                equipoId: f.equipoId!,
                puntos: d.Value(entry.value),
              ),
            );
        aplicadas++;
        totalRegistros++;
      }
      if (aplicadas > 0) totalPilotos++;
    }
    return (pilotos: totalPilotos, registros: totalRegistros);
  }
}

String _norm(String s) {
  return s
      .toLowerCase()
      .trim()
      .replaceAll(RegExp(r'[áàä]'), 'a')
      .replaceAll(RegExp(r'[éèë]'), 'e')
      .replaceAll(RegExp(r'[íìï]'), 'i')
      .replaceAll(RegExp(r'[óòö]'), 'o')
      .replaceAll(RegExp(r'[úùü]'), 'u')
      .replaceAll(RegExp(r'\s+'), ' ');
}

int? _parseInt(String s) {
  final t = s.trim().replaceAll(',', '.');
  if (t.isEmpty) return null;
  final asInt = int.tryParse(t);
  if (asInt != null) return asInt;
  final asDouble = double.tryParse(t);
  return asDouble?.round();
}

final importadorClasificacionProvider =
    Provider<ImportadorClasificacion>((ref) {
  return ImportadorClasificacion(ref.watch(dbProvider));
});
