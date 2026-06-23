import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import '../../services/google_sheets_service.dart';
import '../catalogos/importar_catalogo.dart';
import 'repositorio_hojas_vinculadas.dart';

/// Diferencia de una columna entre la app y la hoja.
class DiffColumna {
  final String columna;
  final String app;
  final String sheet;
  DiffColumna(this.columna, this.app, this.sheet);
}

/// Una fila a subir: nueva (append) o conflicto (la hoja tiene otro valor).
class FilaSubida {
  final String etiqueta; // nombre/clave para mostrar
  final bool esNueva;
  final int filaNum1; // fila 1-based en la hoja (solo updates)
  final List<String> valores; // fila completa a escribir
  final List<DiffColumna> diffs;
  bool aplicar;
  FilaSubida({
    required this.etiqueta,
    required this.esNueva,
    this.filaNum1 = 0,
    required this.valores,
    this.diffs = const [],
    this.aplicar = true,
  });
}

/// Plan de subida calculado a partir del diff app↔hoja.
class PlanSubida {
  final String? error;
  final VinculoHoja? vinculo;
  final String hojaId;
  final String pestana;
  final List<FilaSubida> nuevas;
  final List<FilaSubida> conflictos;
  final int identicas;
  PlanSubida({
    this.error,
    this.vinculo,
    this.hojaId = '',
    this.pestana = '',
    this.nuevas = const [],
    this.conflictos = const [],
    this.identicas = 0,
  });
  bool get vacio => nuevas.isEmpty && conflictos.isEmpty;
}

String _norm(String s) => s.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();

String _numStr(double d) =>
    d == d.roundToDouble() ? d.toInt().toString() : d.toString();

String _copasStr(String copasJson) {
  try {
    final raw = copasJson.isEmpty ? [] : (jsonDecode(copasJson) as List?);
    if (raw == null) return '';
    return raw.map((e) => e.toString()).where((s) => s.isNotEmpty).join(', ');
  } catch (_) {
    return '';
  }
}

class SubidorCatalogo {
  SubidorCatalogo(this.ref);
  final Ref ref;

  AppDatabase get _db => ref.read(dbProvider);

  /// Filas locales del catálogo: claves (campos del mapeo que forman la clave
  /// de coincidencia) y, por cada fila, mapeo-campo → valor.
  Future<({List<String> keyFields, List<Map<String, String>> rows})>
      _filasLocales(TipoCatalogo tipo) async {
    switch (tipo) {
      case TipoCatalogo.coches:
        final xs = await _db.select(_db.catalogoCoches).get();
        return (
          keyFields: ['colNombre'],
          rows: [
            for (final c in xs)
              {
                'colNombre': c.nombre,
                'colMarca': c.marca,
                'colModelo': c.modelo,
                'colPesoMin': _numStr(c.pesoMin),
                'colCreditos': '${c.creditosCoche}',
                'colCopa': _copasStr(c.copasJson),
              }
          ],
        );
      case TipoCatalogo.motores:
        final xs = await _db.select(_db.catalogoMotores).get();
        return (
          keyFields: ['colNombre'],
          rows: [
            for (final m in xs)
              {
                'colNombre': m.nombre,
                'colRpm': m.rpm?.toString() ?? '',
                'colGauss': m.gauss == null ? '' : _numStr(m.gauss!),
                'colCopa': _copasStr(m.copasJson),
              }
          ],
        );
      case TipoCatalogo.marcas:
        final xs = await _db.select(_db.catalogoMarcas).get();
        return (
          keyFields: ['colCodigo'],
          rows: [
            for (final x in xs) {'colCodigo': x.codigo, 'colNombre': x.nombre}
          ],
        );
      case TipoCatalogo.neumaticos:
        final xs = await _db.select(_db.catalogoNeumaticos).get();
        return (
          keyFields: ['colNombre'],
          rows: [
            for (final x in xs)
              {'colNombre': x.nombre, 'colReferencia': x.referencia ?? ''}
          ],
        );
      case TipoCatalogo.llantas:
        final xs = await _db.select(_db.catalogoLlantas).get();
        return (
          keyFields: ['colDimension', 'colTipo'],
          rows: [
            for (final x in xs)
              {'colDimension': x.dimension, 'colTipo': x.tipo}
          ],
        );
      case TipoCatalogo.engranajes:
        final xs = await _db.select(_db.catalogoEngranajes).get();
        return (
          keyFields: ['colTipo', 'colMarca', 'colDientes'],
          rows: [
            for (final x in xs)
              {
                'colTipo': x.tipo,
                'colMarca': x.marca,
                'colDientes': '${x.dientes}',
              }
          ],
        );
      case TipoCatalogo.bancadas:
        final xs = await _db.select(_db.catalogoBancadas).get();
        return (keyFields: ['colNombre'], rows: [for (final x in xs) {'colNombre': x.nombre}]);
      case TipoCatalogo.chasis:
        final xs = await _db.select(_db.catalogoChasis).get();
        return (keyFields: ['colNombre'], rows: [for (final x in xs) {'colNombre': x.nombre}]);
      case TipoCatalogo.copas:
        final xs = await _db.select(_db.catalogoCopas).get();
        return (keyFields: ['colNombre'], rows: [for (final x in xs) {'colNombre': x.nombre}]);
      case TipoCatalogo.clubs:
        final xs = await _db.select(_db.catalogoClubs).get();
        return (keyFields: ['colNombre'], rows: [for (final x in xs) {'colNombre': x.nombre}]);
    }
  }

  /// Calcula el plan de subida: filas nuevas (no están en la hoja) y conflictos
  /// (están pero con algún valor distinto). Las idénticas se ignoran.
  Future<PlanSubida> preparar(VinculoHoja v, TipoCatalogo tipo) async {
    final svc = ref.read(googleSheetsServiceProvider);
    final raw = await svc.leerPestana(v.fila.hojaId, v.fila.pestanaTitulo);

    // Cabecera = primera fila con ≥2 celdas no vacías.
    var idxCab = -1;
    for (var i = 0; i < raw.length; i++) {
      if (raw[i].where((c) => c.trim().isNotEmpty).length >= 2) {
        idxCab = i;
        break;
      }
    }
    if (idxCab < 0) {
      return PlanSubida(error: 'No encuentro la cabecera en la hoja.');
    }
    final headers = raw[idxCab];
    final width = headers.length;
    final headerIdx = <String, int>{};
    for (var j = 0; j < headers.length; j++) {
      final h = _norm(headers[j]);
      if (h.isNotEmpty && !headerIdx.containsKey(h)) headerIdx[h] = j;
    }

    int? colDe(String field) {
      final hn = v.mapeo[field];
      if (hn == null) return null;
      return headerIdx[_norm(hn.toString())];
    }

    String celda(List<String> fila, int c) => c < fila.length ? fila[c] : '';

    final local = await _filasLocales(tipo);
    final keyCols = local.keyFields.map(colDe).toList();
    if (keyCols.any((c) => c == null)) {
      return PlanSubida(
          error: 'Faltan columnas clave en el mapeo de la hoja. '
              'Revisa el vínculo (Importar) para que las columnas cuadren.');
    }

    // Índice de la hoja por clave.
    final sheetPorClave = <String, int>{}; // clave → fila absoluta (0-based)
    for (var i = idxCab + 1; i < raw.length; i++) {
      final fila = raw[i];
      if (!fila.any((c) => c.trim().isNotEmpty)) continue;
      final clave = keyCols.map((c) => _norm(celda(fila, c!))).join('|');
      if (clave.replaceAll('|', '').isEmpty) continue;
      sheetPorClave.putIfAbsent(clave, () => i);
    }

    final nuevas = <FilaSubida>[];
    final conflictos = <FilaSubida>[];
    var identicas = 0;

    for (final campos in local.rows) {
      final clave =
          local.keyFields.map((k) => _norm(campos[k] ?? '')).join('|');
      if (clave.replaceAll('|', '').isEmpty) continue;
      final etiqueta = campos[local.keyFields.first] ?? clave;
      final rowIdx = sheetPorClave[clave];

      if (rowIdx == null) {
        // Nueva → append.
        final fila = List<String>.filled(width, '');
        campos.forEach((field, val) {
          final c = colDe(field);
          if (c != null && c < width) fila[c] = val;
        });
        nuevas.add(FilaSubida(etiqueta: etiqueta, esNueva: true, valores: fila));
      } else {
        final existente = List<String>.from(raw[rowIdx]);
        while (existente.length < width) {
          existente.add('');
        }
        final fila = List<String>.from(existente);
        final diffs = <DiffColumna>[];
        campos.forEach((field, val) {
          final c = colDe(field);
          if (c == null || c >= width) return;
          if (_norm(existente[c]) != _norm(val)) {
            diffs.add(DiffColumna(v.mapeo[field].toString(), val, existente[c]));
            fila[c] = val;
          }
        });
        if (diffs.isEmpty) {
          identicas++;
        } else {
          conflictos.add(FilaSubida(
            etiqueta: etiqueta,
            esNueva: false,
            filaNum1: rowIdx + 1,
            valores: fila,
            diffs: diffs,
          ));
        }
      }
    }

    return PlanSubida(
      vinculo: v,
      hojaId: v.fila.hojaId,
      pestana: v.fila.pestanaTitulo,
      nuevas: nuevas,
      conflictos: conflictos,
      identicas: identicas,
    );
  }

  /// Aplica el plan: añade las nuevas marcadas y sobrescribe los conflictos
  /// marcados. Devuelve (añadidas, actualizadas).
  Future<({int anadidas, int actualizadas})> aplicar(PlanSubida plan) async {
    final svc = ref.read(googleSheetsServiceProvider);
    final appendRows =
        plan.nuevas.where((f) => f.aplicar).map((f) => f.valores).toList();
    if (appendRows.isNotEmpty) {
      await svc.anadirFilas(plan.hojaId, plan.pestana, appendRows);
    }
    var act = 0;
    for (final f in plan.conflictos.where((f) => f.aplicar)) {
      await svc.escribirFila(plan.hojaId, plan.pestana, f.filaNum1, f.valores);
      act++;
    }
    return (anadidas: appendRows.length, actualizadas: act);
  }
}

final subidorCatalogoProvider =
    Provider<SubidorCatalogo>((ref) => SubidorCatalogo(ref));
