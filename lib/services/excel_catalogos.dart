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
//
// Exporta los 10 catálogos maestros a un .xlsx (una pestaña por catálogo) y
// vuelve a importarlo tras editarlo en Excel.
//
// Contrato de la hoja: la PRIMERA columna es el ID de la fila.
//   - Fila con ID existente  → se ACTUALIZA.
//   - Fila sin ID            → se CREA (Excel deja el ID en blanco).
//   - Fila que no está en la hoja → se deja como está (nunca se borra nada).
// La columna "Copas" lista las copas separadas por ';' (vacío = aplica a todas).

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:excel/excel.dart';

import '../data/database/app_database.dart';

/// Resultado de una reimportación, para enseñárselo al usuario.
class ResultadoImportCatalogos {
  final Map<String, int> creados = {};
  final Map<String, int> actualizados = {};
  final List<String> errores = [];

  int get totalCreados => creados.values.fold(0, (a, b) => a + b);
  int get totalActualizados => actualizados.values.fold(0, (a, b) => a + b);

  void suma(String hoja, {bool creado = false}) {
    final m = creado ? creados : actualizados;
    m[hoja] = (m[hoja] ?? 0) + 1;
  }

  String get resumen {
    final b = StringBuffer('✓ Creados: $totalCreados · Actualizados: $totalActualizados');
    if (errores.isNotEmpty) b.write('\n✗ ${errores.length} fila(s) con error');
    return b.toString();
  }
}

// ── Helpers de celdas ───────────────────────────────────────────────────────

CellValue? _txt(String? s) => (s == null || s.isEmpty) ? null : TextCellValue(s);
CellValue? _int(int? n) => n == null ? null : IntCellValue(n);
CellValue? _dbl(double? d) => d == null ? null : DoubleCellValue(d);

/// `["GT","GT2"]` → `"GT;GT2"`. Vacío/null → `''` (= aplica a todas).
String _copasATexto(String? copasJson) {
  if (copasJson == null || copasJson.isEmpty) return '';
  try {
    final l = jsonDecode(copasJson);
    if (l is List) return l.map((e) => e.toString()).join(';');
  } catch (_) {}
  return '';
}

/// `"GT;GT2"` → `["GT","GT2"]` como JSON. Vacío → `[]` (= aplica a todas).
String _textoACopas(String texto) {
  final partes = texto
      .split(RegExp(r'[;,]'))
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
  return jsonEncode(partes);
}

String _celda(List<Data?> fila, Map<String, int> cols, String nombre) {
  final i = cols[nombre.toLowerCase()];
  if (i == null || i >= fila.length) return '';
  return (fila[i]?.value?.toString() ?? '').trim();
}

int? _celdaInt(List<Data?> fila, Map<String, int> cols, String nombre) =>
    int.tryParse(_celda(fila, cols, nombre));

double? _celdaDbl(List<Data?> fila, Map<String, int> cols, String nombre) =>
    double.tryParse(_celda(fila, cols, nombre).replaceAll(',', '.'));

bool _celdaBool(List<Data?> fila, Map<String, int> cols, String nombre) {
  final v = _celda(fila, cols, nombre).toUpperCase();
  return v == 'SÍ' || v == 'SI' || v == 'TRUE' || v == '1' || v == 'X';
}

// ── Exportar ────────────────────────────────────────────────────────────────

Future<Uint8List> exportarCatalogosExcel(AppDatabase db) async {
  final libro = Excel.createExcel();
  final porDefecto = libro.getDefaultSheet();

  Future<void> hoja(String nombre, List<String> cabecera,
      Future<List<List<CellValue?>>> Function() filas) async {
    libro.appendRow(nombre, cabecera.map((c) => TextCellValue(c)).toList());
    for (final f in await filas()) {
      libro.appendRow(nombre, f);
    }
  }

  await hoja('Coches',
      ['ID', 'Nombre', 'Marca', 'Modelo', 'PesoMin', 'Creditos', 'Copas', 'Activo'],
      () async => (await db.select(db.catalogoCoches).get())
          .map((c) => [
                _int(c.id), _txt(c.nombre), _txt(c.marca), _txt(c.modelo),
                _dbl(c.pesoMin), _int(c.creditosCoche),
                _txt(_copasATexto(c.copasJson)), TextCellValue(c.activo ? 'SÍ' : 'NO'),
              ])
          .toList());

  await hoja('Marcas', ['ID', 'Codigo', 'Nombre'],
      () async => (await db.select(db.catalogoMarcas).get())
          .map((m) => [_int(m.id), _txt(m.codigo), _txt(m.nombre)])
          .toList());

  await hoja('Llantas', ['ID', 'Dimension', 'Tipo', 'Copas'],
      () async => (await db.select(db.catalogoLlantas).get())
          .map((l) => [
                _int(l.id), _txt(l.dimension), _txt(l.tipo),
                _txt(_copasATexto(l.copasJson)),
              ])
          .toList());

  await hoja('Engranajes', ['ID', 'Tipo', 'Marca', 'Dientes', 'Copas'],
      () async => (await db.select(db.catalogoEngranajes).get())
          .map((g) => [
                _int(g.id), _txt(g.tipo), _txt(g.marca), _int(g.dientes),
                _txt(_copasATexto(g.copasJson)),
              ])
          .toList());

  await hoja('Motores', ['ID', 'Nombre', 'RPM', 'Gauss', 'Copas'],
      () async => (await db.select(db.catalogoMotores).get())
          .map((m) => [
                _int(m.id), _txt(m.nombre), _int(m.rpm), _dbl(m.gauss),
                _txt(_copasATexto(m.copasJson)),
              ])
          .toList());

  await hoja('Bancadas', ['ID', 'Nombre', 'Copas'],
      () async => (await db.select(db.catalogoBancadas).get())
          .map((b) => [_int(b.id), _txt(b.nombre), _txt(_copasATexto(b.copasJson))])
          .toList());

  await hoja('Chasis', ['ID', 'Nombre', 'Copas'],
      () async => (await db.select(db.catalogoChasis).get())
          .map((c) => [_int(c.id), _txt(c.nombre), _txt(_copasATexto(c.copasJson))])
          .toList());

  await hoja('Neumaticos', ['ID', 'Nombre', 'Referencia', 'Copas'],
      () async => (await db.select(db.catalogoNeumaticos).get())
          .map((n) => [
                _int(n.id), _txt(n.nombre), _txt(n.referencia),
                _txt(_copasATexto(n.copasJson)),
              ])
          .toList());

  await hoja('Copas', ['ID', 'Nombre'],
      () async => (await db.select(db.catalogoCopas).get())
          .map((c) => [_int(c.id), _txt(c.nombre)])
          .toList());

  await hoja('Clubs', ['ID', 'Nombre'],
      () async => (await db.select(db.catalogoClubs).get())
          .map((c) => [_int(c.id), _txt(c.nombre)])
          .toList());

  // Quitar la hoja vacía que crea el paquete por defecto.
  if (porDefecto != null && libro.sheets.containsKey(porDefecto)) {
    libro.delete(porDefecto);
  }

  final bytes = libro.save();
  if (bytes == null) throw 'No se pudo generar el Excel.';
  return Uint8List.fromList(bytes);
}

// ── Reimportar ──────────────────────────────────────────────────────────────

Future<ResultadoImportCatalogos> importarCatalogosExcel(
    AppDatabase db, Uint8List bytes) async {
  final libro = Excel.decodeBytes(bytes);
  final res = ResultadoImportCatalogos();

  /// Recorre una hoja: cabecera → índices, y una acción por fila de datos.
  Future<void> hoja(String nombre,
      Future<void> Function(List<Data?> fila, Map<String, int> cols, int? id) fn) async {
    final tabla = libro.tables[nombre];
    if (tabla == null || tabla.rows.length < 2) return;

    final cabecera = tabla.rows.first;
    final cols = <String, int>{};
    for (var i = 0; i < cabecera.length; i++) {
      final k = (cabecera[i]?.value?.toString() ?? '').trim().toLowerCase();
      if (k.isNotEmpty) cols[k] = i;
    }

    for (var f = 1; f < tabla.rows.length; f++) {
      final fila = tabla.rows[f];
      // Fila totalmente vacía → se ignora (Excel deja filas fantasma al final).
      if (fila.every((c) => (c?.value?.toString() ?? '').trim().isEmpty)) continue;
      try {
        await fn(fila, cols, _celdaInt(fila, cols, 'id'));
      } catch (e) {
        res.errores.add('$nombre fila ${f + 1}: $e');
      }
    }
  }

  await db.transaction(() async {
    await hoja('Coches', (fila, cols, id) async {
      final nombre = _celda(fila, cols, 'nombre');
      if (nombre.isEmpty) return;
      final c = CatalogoCochesCompanion(
        nombre: Value(nombre),
        marca: Value(_celda(fila, cols, 'marca')),
        modelo: Value(_celda(fila, cols, 'modelo')),
        pesoMin: Value(_celdaDbl(fila, cols, 'pesomin') ?? 0),
        creditosCoche: Value(_celdaInt(fila, cols, 'creditos') ?? 0),
        copasJson: Value(_textoACopas(_celda(fila, cols, 'copas'))),
        activo: Value(_celdaBool(fila, cols, 'activo')),
      );
      if (id != null) {
        await (db.update(db.catalogoCoches)..where((t) => t.id.equals(id))).write(c);
        res.suma('Coches');
      } else {
        await db.into(db.catalogoCoches).insert(c.copyWith(id: const Value.absent()),
            mode: InsertMode.insert);
        res.suma('Coches', creado: true);
      }
    });

    await hoja('Marcas', (fila, cols, id) async {
      final nombre = _celda(fila, cols, 'nombre');
      if (nombre.isEmpty) return;
      final c = CatalogoMarcasCompanion(
        codigo: Value(_celda(fila, cols, 'codigo')),
        nombre: Value(nombre),
      );
      if (id != null) {
        await (db.update(db.catalogoMarcas)..where((t) => t.id.equals(id))).write(c);
        res.suma('Marcas');
      } else {
        await db.into(db.catalogoMarcas).insert(c);
        res.suma('Marcas', creado: true);
      }
    });

    await hoja('Llantas', (fila, cols, id) async {
      final dim = _celda(fila, cols, 'dimension');
      if (dim.isEmpty) return;
      final c = CatalogoLlantasCompanion(
        dimension: Value(dim),
        tipo: Value(_celda(fila, cols, 'tipo').toUpperCase()),
        copasJson: Value(_textoACopas(_celda(fila, cols, 'copas'))),
      );
      if (id != null) {
        await (db.update(db.catalogoLlantas)..where((t) => t.id.equals(id))).write(c);
        res.suma('Llantas');
      } else {
        await db.into(db.catalogoLlantas).insert(c);
        res.suma('Llantas', creado: true);
      }
    });

    await hoja('Engranajes', (fila, cols, id) async {
      final marca = _celda(fila, cols, 'marca');
      final dientes = _celdaInt(fila, cols, 'dientes');
      if (marca.isEmpty || dientes == null) return;
      final c = CatalogoEngranajesCompanion(
        tipo: Value(_celda(fila, cols, 'tipo').toUpperCase()),
        marca: Value(marca),
        dientes: Value(dientes),
        copasJson: Value(_textoACopas(_celda(fila, cols, 'copas'))),
      );
      if (id != null) {
        await (db.update(db.catalogoEngranajes)..where((t) => t.id.equals(id))).write(c);
        res.suma('Engranajes');
      } else {
        await db.into(db.catalogoEngranajes).insert(c);
        res.suma('Engranajes', creado: true);
      }
    });

    await hoja('Motores', (fila, cols, id) async {
      final nombre = _celda(fila, cols, 'nombre');
      if (nombre.isEmpty) return;
      final c = CatalogoMotoresCompanion(
        nombre: Value(nombre),
        rpm: Value(_celdaInt(fila, cols, 'rpm')),
        gauss: Value(_celdaDbl(fila, cols, 'gauss')),
        copasJson: Value(_textoACopas(_celda(fila, cols, 'copas'))),
      );
      if (id != null) {
        await (db.update(db.catalogoMotores)..where((t) => t.id.equals(id))).write(c);
        res.suma('Motores');
      } else {
        await db.into(db.catalogoMotores).insert(c);
        res.suma('Motores', creado: true);
      }
    });

    await hoja('Bancadas', (fila, cols, id) async {
      final nombre = _celda(fila, cols, 'nombre');
      if (nombre.isEmpty) return;
      final c = CatalogoBancadasCompanion(
        nombre: Value(nombre),
        copasJson: Value(_textoACopas(_celda(fila, cols, 'copas'))),
      );
      if (id != null) {
        await (db.update(db.catalogoBancadas)..where((t) => t.id.equals(id))).write(c);
        res.suma('Bancadas');
      } else {
        await db.into(db.catalogoBancadas).insert(c);
        res.suma('Bancadas', creado: true);
      }
    });

    await hoja('Chasis', (fila, cols, id) async {
      final nombre = _celda(fila, cols, 'nombre');
      if (nombre.isEmpty) return;
      final c = CatalogoChasisCompanion(
        nombre: Value(nombre),
        copasJson: Value(_textoACopas(_celda(fila, cols, 'copas'))),
      );
      if (id != null) {
        await (db.update(db.catalogoChasis)..where((t) => t.id.equals(id))).write(c);
        res.suma('Chasis');
      } else {
        await db.into(db.catalogoChasis).insert(c);
        res.suma('Chasis', creado: true);
      }
    });

    await hoja('Neumaticos', (fila, cols, id) async {
      final nombre = _celda(fila, cols, 'nombre');
      if (nombre.isEmpty) return;
      final ref = _celda(fila, cols, 'referencia');
      final c = CatalogoNeumaticosCompanion(
        nombre: Value(nombre),
        referencia: Value(ref.isEmpty ? null : ref),
        copasJson: Value(_textoACopas(_celda(fila, cols, 'copas'))),
      );
      if (id != null) {
        await (db.update(db.catalogoNeumaticos)..where((t) => t.id.equals(id))).write(c);
        res.suma('Neumáticos');
      } else {
        await db.into(db.catalogoNeumaticos).insert(c);
        res.suma('Neumáticos', creado: true);
      }
    });

    await hoja('Copas', (fila, cols, id) async {
      final nombre = _celda(fila, cols, 'nombre');
      if (nombre.isEmpty) return;
      final c = CatalogoCopasCompanion(nombre: Value(nombre));
      if (id != null) {
        await (db.update(db.catalogoCopas)..where((t) => t.id.equals(id))).write(c);
        res.suma('Copas');
      } else {
        await db.into(db.catalogoCopas).insert(c);
        res.suma('Copas', creado: true);
      }
    });

    await hoja('Clubs', (fila, cols, id) async {
      final nombre = _celda(fila, cols, 'nombre');
      if (nombre.isEmpty) return;
      final c = CatalogoClubsCompanion(nombre: Value(nombre));
      if (id != null) {
        await (db.update(db.catalogoClubs)..where((t) => t.id.equals(id))).write(c);
        res.suma('Clubs');
      } else {
        await db.into(db.catalogoClubs).insert(c);
        res.suma('Clubs', creado: true);
      }
    });
  });

  return res;
}
