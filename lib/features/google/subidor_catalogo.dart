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

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import '../../services/fotos_coches_drive.dart';
import '../../services/generador_id.dart';
import '../../services/google_sheets_service.dart';
import '../catalogos/importar_catalogo.dart';
import '../catalogos/repositorio_catalogos.dart';
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
  final List<Object?> valores; // fila completa a escribir (num o String)
  final List<DiffColumna> diffs;
  bool aplicar;
  // Si esta fila estrena id externo, aquí va (id local, id nuevo) para
  // guardarlo tras aplicar — solo si el usuario no la descarta.
  final int? dbId;
  final String? idExternoNuevo;
  // Si esta fila representa un borrado pendiente (ver [PlanSubida.borrados]),
  // el id (local, de la tabla de borrados) a limpiar tras aplicar.
  final int? tombstoneId;
  // Coche con foto solo en local: se sube a Drive al aplicar y su enlace se
  // escribe en la columna [col] de la fila.
  final ({int cocheId, String fotoPath, int col})? fotoPendiente;
  FilaSubida({
    required this.etiqueta,
    required this.esNueva,
    this.filaNum1 = 0,
    required this.valores,
    this.diffs = const [],
    this.aplicar = true,
    this.dbId,
    this.idExternoNuevo,
    this.tombstoneId,
    this.fotoPendiente,
  });
}

/// Plan de subida calculado a partir del diff app↔hoja.
class PlanSubida {
  final String? error;
  final VinculoHoja? vinculo;
  final TipoCatalogo? tipo;
  final String hojaId;
  final String pestana;
  final List<FilaSubida> nuevas;
  final List<FilaSubida> conflictos;
  final List<FilaSubida> borrados;
  final int identicas;
  final int ancho;
  final int primeraCol;
  PlanSubida({
    this.error,
    this.vinculo,
    this.tipo,
    this.hojaId = '',
    this.pestana = '',
    this.nuevas = const [],
    this.conflictos = const [],
    this.borrados = const [],
    this.identicas = 0,
    this.ancho = 0,
    this.primeraCol = 0,
  });
  bool get vacio => nuevas.isEmpty && conflictos.isEmpty && borrados.isEmpty;
}

String _norm(Object? s) =>
    (s ?? '').toString().toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();

/// Números de la hoja ("17,00") y de la app (17.0) son el mismo valor aunque
/// se escriban distinto; el resto se compara como texto normalizado.
final _reNumero = RegExp(r'^-?\d+([.,]\d+)?$');

bool igualCeldaHoja(String hoja, Object? app) {
  if (_norm(hoja) == _norm(app)) return true;
  final a = hoja.trim();
  final b = (app ?? '').toString().trim();
  if (!_reNumero.hasMatch(a) || !_reNumero.hasMatch(b)) return false;
  return double.parse(a.replaceAll(',', '.')) ==
      double.parse(b.replaceAll(',', '.'));
}

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
  /// de coincidencia), el id local (drift) de cada fila y, por cada fila,
  /// mapeo-campo → valor.
  Future<
      ({
        List<String> keyFields,
        List<int> ids,
        List<Map<String, Object>> rows
      })> _filasLocales(TipoCatalogo tipo) async {
    switch (tipo) {
      case TipoCatalogo.coches:
        final xs = await _db.select(_db.catalogoCoches).get();
        return (
          keyFields: ['colNombre'],
          ids: [for (final c in xs) c.id],
          rows: [
            for (final c in xs)
              {
                'colNombre': c.nombre,
                'colMarca': c.marca,
                'colModelo': c.modelo,
                'colPesoMin': c.pesoMin,
                'colCreditos': c.creditosCoche,
                'colCopa': _copasStr(c.copasJson),
                'colId': c.idExterno ?? '',
                // No es un valor de celda: la foto local, que [preparar]
                // trata aparte (ver _fotoCoche).
                'colFoto': c.fotoPath ?? '',
              }
          ],
        );
      case TipoCatalogo.motores:
        final xs = await _db.select(_db.catalogoMotores).get();
        return (
          keyFields: ['colNombre'],
          ids: [for (final m in xs) m.id],
          rows: [
            for (final m in xs)
              {
                'colNombre': m.nombre,
                'colRpm': m.rpm ?? '',
                'colGauss': m.gauss ?? '',
                'colCopa': _copasStr(m.copasJson),
                'colId': m.idExterno ?? '',
              }
          ],
        );
      case TipoCatalogo.marcas:
        final xs = await _db.select(_db.catalogoMarcas).get();
        return (
          keyFields: ['colCodigo'],
          ids: [for (final x in xs) x.id],
          rows: [
            for (final x in xs)
              {
                'colCodigo': x.codigo,
                'colNombre': x.nombre,
                'colId': x.idExterno ?? '',
              }
          ],
        );
      case TipoCatalogo.neumaticos:
        final xs = await _db.select(_db.catalogoNeumaticos).get();
        return (
          keyFields: ['colNombre'],
          ids: [for (final x in xs) x.id],
          rows: [
            for (final x in xs)
              {
                'colNombre': x.nombre,
                'colReferencia': x.referencia ?? '',
                'colCopa': _copasStr(x.copasJson ?? '[]'),
                'colId': x.idExterno ?? '',
              }
          ],
        );
      case TipoCatalogo.llantas:
        final xs = await _db.select(_db.catalogoLlantas).get();
        return (
          keyFields: ['colDimension', 'colTipo'],
          ids: [for (final x in xs) x.id],
          rows: [
            for (final x in xs)
              {
                'colDimension': x.dimension,
                'colTipo': x.tipo,
                'colCopa': _copasStr(x.copasJson ?? '[]'),
                'colId': x.idExterno ?? '',
              }
          ],
        );
      case TipoCatalogo.engranajes:
        final xs = await _db.select(_db.catalogoEngranajes).get();
        return (
          keyFields: ['colTipo', 'colDiametro', 'colDientes'],
          ids: [for (final x in xs) x.id],
          rows: [
            for (final x in xs)
              {
                'colTipo': x.tipo,
                'colDiametro': x.diametro ?? '',
                'colDientes': x.dientes,
                'colCopa': _copasStr(x.copasJson ?? '[]'),
                'colId': x.idExterno ?? '',
              }
          ],
        );
      case TipoCatalogo.bancadas:
        final xs = await _db.select(_db.catalogoBancadas).get();
        return (
          keyFields: ['colNombre'],
          ids: [for (final x in xs) x.id],
          rows: [
            for (final x in xs)
              {
                'colNombre': x.nombre,
                'colCopa': _copasStr(x.copasJson),
                'colId': x.idExterno ?? '',
              }
          ],
        );
      case TipoCatalogo.chasis:
        final xs = await _db.select(_db.catalogoChasis).get();
        return (
          keyFields: ['colNombre'],
          ids: [for (final x in xs) x.id],
          rows: [for (final x in xs) {'colNombre': x.nombre}],
        );
      case TipoCatalogo.copas:
        final xs = await _db.select(_db.catalogoCopas).get();
        return (
          keyFields: ['colNombre'],
          ids: [for (final x in xs) x.id],
          rows: [
            for (final x in xs)
              {'colNombre': x.nombre, 'colId': x.idExterno ?? ''}
          ],
        );
      case TipoCatalogo.clubs:
        final xs = await _db.select(_db.catalogoClubs).get();
        return (
          keyFields: ['colNombre'],
          ids: [for (final x in xs) x.id],
          rows: [
            for (final x in xs)
              {'colNombre': x.nombre, 'colId': x.idExterno ?? ''}
          ],
        );
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
    // Primera columna con contenido en la cabecera: el "append" de Sheets
    // detecta la tabla a partir de ahí y coloca la fila enviada en relativo
    // a esa columna, así que hay que recortar el relleno de columnas vacías
    // de la izquierda para no desplazar los datos.
    var primeraCol = headers.indexWhere((h) => h.trim().isNotEmpty);
    if (primeraCol < 0) primeraCol = 0;
    // Columna "ID": convención fija (no depende del mapeo guardado) para
    // poder emparejar filas sin ambigüedad, incluso si el nombre se repite
    // (p.ej. el mismo motor homologado en varias copas).
    final idColIdx = headerIdx['id'];

    int? colDe(String field) {
      if (field == 'colId') return idColIdx;
      // Vínculos anteriores a la columna FOTO: se busca por la cabecera.
      if (field == 'colFoto' && v.mapeo['colFoto'] == null) {
        return headerIdx['foto'] ?? headerIdx['imagen'];
      }
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

    // Índice de la hoja por clave (nombre/etc., para catálogos sin columna
    // ID todavía) y por id externo (columna "ID", si existe).
    final sheetPorClave = <String, int>{}; // clave → fila absoluta (0-based)
    final sheetPorId = <String, int>{}; // idExterno → fila absoluta (0-based)
    for (var i = idxCab + 1; i < raw.length; i++) {
      final fila = raw[i];
      if (!fila.any((c) => c.trim().isNotEmpty)) continue;
      final clave = keyCols.map((c) => _norm(celda(fila, c!))).join('|');
      if (clave.replaceAll('|', '').isNotEmpty) {
        sheetPorClave.putIfAbsent(clave, () => i);
      }
      if (idColIdx != null) {
        final id = celda(fila, idColIdx).trim();
        if (id.isNotEmpty) sheetPorId.putIfAbsent(id, () => i);
      }
    }

    final nuevas = <FilaSubida>[];
    final conflictos = <FilaSubida>[];
    final borrados = <FilaSubida>[];
    var identicas = 0;

    // Borrados locales pendientes de confirmar en la hoja. Si el tombstone
    // ya no está en la hoja (alguien la borró a mano), se limpia
    // directamente sin pedir nada.
    if (idColIdx != null) {
      final entidad = 'catalogo_${tipo.name}';
      final nombreCol = colDe('colNombre');
      final tombstones = await (_db.select(_db.catalogoBorrados)
            ..where((t) => t.entidad.equals(entidad)))
          .get();
      for (final t in tombstones) {
        final rowIdx = sheetPorId[t.idExterno];
        if (rowIdx == null) {
          await (_db.delete(_db.catalogoBorrados)
                ..where((x) => x.id.equals(t.id)))
              .go();
          continue;
        }
        final etiquetaBorrado = nombreCol != null
            ? celda(raw[rowIdx], nombreCol)
            : 'ID ${t.idExterno}';
        borrados.add(FilaSubida(
          etiqueta: etiquetaBorrado,
          esNueva: false,
          filaNum1: rowIdx + 1,
          valores: const [],
          tombstoneId: t.id,
        ));
      }
    }

    // Contador correlativo para ids nuevos: arranca en el mayor id visto
    // (tanto en la hoja como ya asignado localmente) + 1, y sigue subiendo
    // dentro de esta misma subida para no repetir número entre filas nuevas.
    var siguienteId = idColIdx == null
        ? 0
        : [
            maxIdExterno(sheetPorId.keys),
            maxIdExterno(local.rows.map((r) => r['colId'] as String?)),
          ].reduce((a, b) => a > b ? a : b);

    for (var i = 0; i < local.rows.length; i++) {
      final campos = local.rows[i];
      final clave = local.keyFields.map((k) => _norm(campos[k])).join('|');
      if (clave.replaceAll('|', '').isEmpty) continue;
      final etiqueta = (campos[local.keyFields.first] ?? clave).toString();

      // Emparejamiento: por id externo si la hoja tiene columna ID (fiable
      // incluso con nombres repetidos); si no, por la clave de siempre.
      int? rowIdx;
      String? idNuevoGenerado;
      if (idColIdx != null) {
        final idLocal = (campos['colId'] as String?) ?? '';
        if (idLocal.isNotEmpty) {
          rowIdx = sheetPorId[idLocal];
        } else {
          // Nunca sincronizada: se le asigna id nuevo ahora mismo y se
          // sube como fila nueva (evita reengancharla por nombre, que es
          // justo lo ambiguo que la columna ID viene a resolver). Solo se
          // guarda localmente si la fila realmente se termina subiendo.
          siguienteId++;
          idNuevoGenerado = siguienteId.toString();
          campos['colId'] = idNuevoGenerado;
          rowIdx = null;
        }
      } else {
        rowIdx = sheetPorClave[clave];
      }

      if (rowIdx == null) {
        // Nueva → append.
        final fila = List<Object?>.filled(width, '');
        campos.forEach((field, val) {
          if (field == 'colFoto') return;
          final c = colDe(field);
          if (c != null && c < width) fila[c] = val;
        });
        final foto = _fotoCoche(campos, colDe('colFoto'), '', width,
            local.ids[i], fila);
        nuevas.add(FilaSubida(
          etiqueta: etiqueta,
          esNueva: true,
          valores: fila,
          dbId: idNuevoGenerado != null ? local.ids[i] : null,
          idExternoNuevo: idNuevoGenerado,
          fotoPendiente: foto.pendiente,
        ));
      } else {
        final existente = List<String>.from(raw[rowIdx]);
        while (existente.length < width) {
          existente.add('');
        }
        final fila = List<Object?>.from(existente);
        final diffs = <DiffColumna>[];
        campos.forEach((field, val) {
          if (field == 'colFoto') return;
          final c = colDe(field);
          if (c == null || c >= width) return;
          if (!igualCeldaHoja(existente[c], val)) {
            diffs.add(DiffColumna(
                field == 'colId' ? 'ID' : v.mapeo[field].toString(),
                val.toString(),
                existente[c]));
            fila[c] = val;
          }
        });
        final cFoto = colDe('colFoto');
        final foto = _fotoCoche(campos, cFoto,
            cFoto == null || cFoto >= width ? '' : existente[cFoto], width,
            local.ids[i], fila);
        if (foto.diff != null) diffs.add(foto.diff!);
        if (diffs.isEmpty) {
          identicas++;
        } else {
          conflictos.add(FilaSubida(
            etiqueta: etiqueta,
            esNueva: false,
            filaNum1: rowIdx + 1,
            valores: fila,
            diffs: diffs,
            fotoPendiente: foto.pendiente,
          ));
        }
      }
    }

    return PlanSubida(
      vinculo: v,
      tipo: tipo,
      hojaId: v.fila.hojaId,
      pestana: v.fila.pestanaTitulo,
      nuevas: nuevas,
      conflictos: conflictos,
      borrados: borrados,
      identicas: identicas,
      ancho: width,
      primeraCol: primeraCol,
    );
  }

  /// Foto de coche al subir: solo rellena la celda FOTO si en la hoja está
  /// vacía, o si la foto local se puso a mano (no viene de Drive) y sustituye
  /// al enlace; si viene de Drive, la hoja manda. Si la foto
  /// ya viene de Drive se escribe su enlace; si solo está en local, queda
  /// pendiente de subir a Drive al aplicar.
  ({DiffColumna? diff, ({int cocheId, String fotoPath, int col})? pendiente})
      _fotoCoche(Map<String, Object?> campos, int? col, String celdaHoja,
          int width, int cocheId, List<Object?> fila) {
    final fotoPath = (campos['colFoto'] as String?) ?? '';
    if (col == null || col >= width || fotoPath.isEmpty) {
      return (diff: null, pendiente: null);
    }
    final idDrive = FotosCochesDrive.idDeFotoLocal(fotoPath);
    if (celdaHoja.trim().isNotEmpty) {
      // Foto que viene de Drive: la hoja manda. Foto puesta a mano en la app
      // (no tiene nombre de Drive): se cambió, y sustituye al enlace.
      if (idDrive != null) return (diff: null, pendiente: null);
      return (
        diff: DiffColumna(
            'FOTO', '(foto nueva: se sube a Drive y sustituye al enlace)',
            celdaHoja),
        pendiente: (cocheId: cocheId, fotoPath: fotoPath, col: col),
      );
    }
    if (idDrive != null) {
      final enlace = FotosCochesDrive.enlace(idDrive);
      fila[col] = enlace;
      return (diff: DiffColumna('FOTO', enlace, ''), pendiente: null);
    }
    return (
      diff: DiffColumna('FOTO', '(se sube la foto a Drive)', ''),
      pendiente: (cocheId: cocheId, fotoPath: fotoPath, col: col),
    );
  }

  /// Sube a Drive las fotos pendientes de las filas marcadas y escribe su
  /// enlace en la fila. Devuelve las que fallan (la fila se sube igual, sin
  /// enlace).
  Future<List<String>> _subirFotos(List<FilaSubida> filas) async {
    final pendientes = filas.where((f) => f.fotoPendiente != null).toList();
    if (pendientes.isEmpty) return const [];
    final fotos = ref.read(fotosCochesDriveProvider);
    final repo = ref.read(repoCatalogosProvider);
    final fallidas = <String>[];
    await fotos.conDrive((api) async {
      for (final f in pendientes) {
        final fp = f.fotoPendiente!;
        try {
          final idDrive = await fotos.subir(api, fp.fotoPath, f.etiqueta);
          final nombre = await fotos.renombrarLocal(fp.fotoPath, idDrive);
          await repo.actualizarCoche(
              fp.cocheId, CatalogoCochesCompanion(fotoPath: Value(nombre)));
          f.valores[fp.col] = FotosCochesDrive.enlace(idDrive);
        } catch (e) {
          // La celda se deja como estaba (el enlace anterior, si lo había).
          fallidas.add('${f.etiqueta}: $e');
        }
      }
    });
    return fallidas;
  }

  /// Aplica el plan: añade las nuevas marcadas, sobrescribe los conflictos
  /// marcados y borra en la hoja los borrados confirmados.
  Future<
      ({
        int anadidas,
        int actualizadas,
        int borradas,
        List<String> fotosFallidas
      })> aplicar(PlanSubida plan) async {
    final svc = ref.read(googleSheetsServiceProvider);
    // Primero las fotos: su enlace va dentro de la fila que se escribe.
    final fotosFallidas = await _subirFotos([
      ...plan.nuevas.where((f) => f.aplicar),
      ...plan.conflictos.where((f) => f.aplicar),
    ]);
    // Se recorta el relleno de columnas vacías de la izquierda (antes de
    // primeraCol): el "append" de Sheets ya detecta la tabla a partir de esa
    // columna, así que enviar ese relleno duplicaría el desplazamiento.
    final appendRows = plan.nuevas
        .where((f) => f.aplicar)
        .map((f) => f.valores.sublist(plan.primeraCol))
        .toList();
    if (appendRows.isNotEmpty) {
      await svc.anadirFilas(plan.hojaId, plan.pestana, appendRows,
          primeraColumna: plan.primeraCol,
          ultimaColumna: plan.ancho > 0 ? plan.ancho - 1 : null);
    }
    // Una sola petición para todas las filas: ver [escribirFilas].
    final aActualizar = plan.conflictos.where((f) => f.aplicar).toList();
    await svc.escribirFilas(plan.hojaId, plan.pestana,
        {for (final f in aActualizar) f.filaNum1: f.valores});
    final act = aActualizar.length;
    // Las filas nuevas que estrenaban id externo ya están en la hoja: se
    // guarda ese id en el catálogo local para que la próxima subida/bajada
    // las reconozca por id en vez de volver a tratarlas como nuevas.
    if (plan.tipo != null) {
      final repo = ref.read(repoCatalogosProvider);
      for (final f in plan.nuevas) {
        if (!f.aplicar || f.dbId == null || f.idExternoNuevo == null) {
          continue;
        }
        await repo.actualizarIdExterno(plan.tipo!, f.dbId!, f.idExternoNuevo!);
      }
    }
    // Borrados en una sola petición (ver [borrarFilas]).
    final aBorrar = plan.borrados.where((f) => f.aplicar).toList();
    await svc.borrarFilas(
        plan.hojaId, plan.pestana, [for (final f in aBorrar) f.filaNum1]);
    for (final f in aBorrar) {
      if (f.tombstoneId != null) {
        await (_db.delete(_db.catalogoBorrados)
              ..where((t) => t.id.equals(f.tombstoneId!)))
            .go();
      }
    }
    final borr = aBorrar.length;
    return (
      anadidas: appendRows.length,
      actualizadas: act,
      borradas: borr,
      fotosFallidas: fotosFallidas,
    );
  }
}

final subidorCatalogoProvider =
    Provider<SubidorCatalogo>((ref) => SubidorCatalogo(ref));
