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

import 'package:drift/drift.dart' hide Column;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import '../../services/generador_id.dart';
import '../../services/google_sheets_service.dart';
import '../catalogos/importar_catalogo.dart';
import '../catalogos/repositorio_catalogos.dart';
import '../equipos/importador_equipos.dart';
import '../equipos/repositorio_equipos.dart';
import '../pilotos/importador_pilotos.dart';
import '../pilotos/repositorio_pilotos.dart';
import '../pruebas/importador_inscripciones.dart';
import '../pruebas/repositorio_inscripciones_prueba.dart';
import 'repositorio_hojas_vinculadas.dart';

class ResultadoActualizacion {
  final bool ok;
  final String mensaje;
  final int nuevos;
  final int actualizados;
  final int saltados;

  ResultadoActualizacion({
    required this.ok,
    required this.mensaje,
    this.nuevos = 0,
    this.actualizados = 0,
    this.saltados = 0,
  });
}

/// Servicio que, dado un vínculo a una hoja de Drive, lee la pestaña y
/// aplica la importación correspondiente (pilotos / equipos / inscripciones).
class ActualizadorDrive {
  ActualizadorDrive(this.ref);
  final Ref ref;

  Future<
      ({
        List<String> columnas,
        List<Map<String, String>> filas,
        List<int> filaAbs
      })> _leerPestana(VinculoHoja v) async {
    final svc = ref.read(googleSheetsServiceProvider);
    final filas = await svc.leerPestana(v.fila.hojaId, v.fila.pestanaTitulo);
    return _normalizar(filas);
  }

  ({List<String> columnas, List<Map<String, String>> filas, List<int> filaAbs})
      _normalizar(List<List<String>> filas) {
    int idxCab = -1;
    for (var i = 0; i < filas.length; i++) {
      final llenas = filas[i].where((c) => c.trim().isNotEmpty).length;
      if (llenas >= 2) {
        idxCab = i;
        break;
      }
    }
    if (idxCab == -1) {
      return (columnas: <String>[], filas: <Map<String, String>>[], filaAbs: <int>[]);
    }
    final columnas = filas[idxCab].map((c) => c.trim()).toList();
    final out = <Map<String, String>>[];
    final filaAbs = <int>[];
    for (var i = idxCab + 1; i < filas.length; i++) {
      final celdas = filas[i].map((c) => c.trim()).toList();
      if (!celdas.any((c) => c.isNotEmpty)) continue;
      final mapa = <String, String>{};
      for (var j = 0; j < columnas.length && j < celdas.length; j++) {
        if (columnas[j].isEmpty) continue;
        mapa[columnas[j]] = celdas[j];
      }
      if (mapa.values.every((v) => v.isEmpty)) continue;
      out.add(mapa);
      filaAbs.add(i);
    }
    return (
      columnas: columnas.where((c) => c.isNotEmpty).toList(),
      filas: out,
      filaAbs: filaAbs,
    );
  }

  static String _norm(String s) =>
      s.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();

  /// Copas de un JSON normalizadas y ordenadas, para usarlas como clave.
  static String _copasClave(String? copasJson) {
    try {
      final raw = jsonDecode(copasJson ?? '[]');
      if (raw is List) {
        return (raw.map((e) => _norm(e.toString())).toList()..sort()).join(',');
      }
    } catch (_) {}
    return '';
  }

  /// Si una fila de la hoja no casa por ID, adopta una fila local sin id
  /// externo con la misma clave natural: le asigna el id de la hoja (o uno
  /// nuevo, que se escribe en la hoja) y la devuelve para actualizarla. Sin
  /// esto, la primera sincronización por ID duplicaba el catálogo entero.
  Future<T?> _adoptar<T>(
    _SinId<T> sinId,
    List<String> claves,
    int Function(T) idLocal,
    TipoCatalogo tipo,
    String idHoja,
    int Function() nuevoId,
    VinculoHoja v,
    int filaAbs,
    int idColIdx,
  ) async {
    final x = sinId.tomar(claves);
    if (x == null) return null;
    final idFinal = idHoja.isNotEmpty ? idHoja : nuevoId().toString();
    await ref
        .read(repoCatalogosProvider)
        .actualizarIdExterno(tipo, idLocal(x), idFinal);
    if (idHoja.isEmpty) {
      await ref.read(googleSheetsServiceProvider).escribirCelda(
          v.fila.hojaId, v.fila.pestanaTitulo, filaAbs + 1, idColIdx, idFinal);
    }
    return x;
  }

  /// Copas separadas por coma en la celda; vacío = aplica a todas. Se
  /// normaliza siempre a "[]" (nunca null) para poder comparar con lo ya
  /// guardado sin ambigüedad entre "sin copas" y "no sincronizado".
  static String _copasJsonDe(String? raw) {
    final copas = (raw ?? '')
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    return copas.isEmpty ? '[]' : json.encode(copas);
  }

  /// Actualizar pilotos del campeonato activo desde el vínculo.
  Future<ResultadoActualizacion> actualizarPilotos(VinculoHoja v) async {
    final activo = ref.read(campeonatoActivoProvider);
    if (activo == null) {
      return ResultadoActualizacion(ok: false, mensaje: 'Sin campeonato activo');
    }
    try {
      final datos = await _leerPestana(v);
      final m = MapeoColumnas()
        ..colNombre = v.mapeo['colNombre']
        ..colCategoria = v.mapeo['colCategoria']
        ..colCreditosIniciales = v.mapeo['colCreditosIniciales']
        ..colCreditosActuales = v.mapeo['colCreditosActuales']
        ..colPalmares = v.mapeo['colPalmares'];
      final filas = ImportadorPilotos.transformar(datos.filas, m);
      final db = ref.read(dbProvider);
      final repo = ref.read(repoPilotosProvider);

      final maestro = await db.select(db.pilotos).get();
      final porNombre = {for (final p in maestro) _norm(p.nombre): p};
      final inscritos = await (db.select(db.pilotoCampeonato)
            ..where((t) => t.campeonatoId.equals(activo.id)))
          .get();
      final idsInscritos = inscritos.map((e) => e.pilotoId).toSet();

      int nuevos = 0, ya = 0, saltados = 0;
      for (final f in filas) {
        final cat = (f.categoria != null && categorias.contains(f.categoria))
            ? f.categoria!
            : 'BRONCE';
        final cIni = f.creditosIniciales ??
            creditosInicialesPorCategoria[cat] ?? 28;
        final cAct = f.creditosActuales ?? cIni;
        final existente = porNombre[_norm(f.nombre)];
        if (existente == null) {
          await repo.crear(
            nombre: f.nombre,
            palmaresGlobal: f.palmares,
            campeonatoId: activo.id,
            categoria: cat,
            creditosIniciales: cIni,
            creditosActuales: cAct,
          );
          nuevos++;
        } else if (idsInscritos.contains(existente.id)) {
          saltados++;
        } else {
          await repo.inscribirEnCampeonato(
            pilotoId: existente.id,
            campeonatoId: activo.id,
            categoria: cat,
            creditosIniciales: cIni,
          );
          ya++;
        }
      }
      final resumen =
          'Nuevos: $nuevos · Inscritos al campeonato: $ya · Saltados: $saltados';
      await ref
          .read(repoHojasVinculadasProvider)
          .marcarSync(v.fila.id, resumen);
      return ResultadoActualizacion(
        ok: true, mensaje: resumen,
        nuevos: nuevos, actualizados: ya, saltados: saltados,
      );
    } catch (e) {
      return ResultadoActualizacion(ok: false, mensaje: '$e');
    }
  }

  /// Actualizar equipos + sus pilotos.
  Future<ResultadoActualizacion> actualizarEquipos(VinculoHoja v) async {
    final activo = ref.read(campeonatoActivoProvider);
    if (activo == null) {
      return ResultadoActualizacion(ok: false, mensaje: 'Sin campeonato activo');
    }
    try {
      final datos = await _leerPestana(v);
      final m = MapeoColumnasEquipo()
        ..colEquipo = v.mapeo['colEquipo']
        ..colCopa = v.mapeo['colCopa']
        ..colP1Nombre = v.mapeo['colP1Nombre']
        ..colP1Email = v.mapeo['colP1Email']
        ..colP1Telefono = v.mapeo['colP1Telefono']
        ..colP1Categoria = v.mapeo['colP1Categoria']
        ..colP1Palmares = v.mapeo['colP1Palmares']
        ..colP2Nombre = v.mapeo['colP2Nombre']
        ..colP2Email = v.mapeo['colP2Email']
        ..colP2Telefono = v.mapeo['colP2Telefono']
        ..colP2Categoria = v.mapeo['colP2Categoria']
        ..colP2Palmares = v.mapeo['colP2Palmares'];
      final filas = ImportadorEquipos.transformar(datos.filas, m);
      final db = ref.read(dbProvider);
      final repoEq = ref.read(repoEquiposProvider);
      final repoPi = ref.read(repoPilotosProvider);

      final equipos = await (db.select(db.equipos)
            ..where((t) => t.campeonatoId.equals(activo.id)))
          .get();
      final nombresEq = {for (final e in equipos) _norm(e.nombre)};
      final maestro = await db.select(db.pilotos).get();
      final porNombre = {for (final p in maestro) _norm(p.nombre): p};
      final inscritos = await (db.select(db.pilotoCampeonato)
            ..where((t) => t.campeonatoId.equals(activo.id)))
          .get();
      final idsIns = inscritos.map((e) => e.pilotoId).toSet();

      Future<int> obtenerPiloto(String nombre, String? email, String? tel,
          String? cat, String? palm) async {
        final ex = porNombre[_norm(nombre)];
        if (ex != null) {
          if (!idsIns.contains(ex.id)) {
            final c = (cat != null && categorias.contains(cat)) ? cat : 'BRONCE';
            final ini = creditosInicialesPorCategoria[c] ?? 28;
            await repoPi.inscribirEnCampeonato(
              pilotoId: ex.id,
              campeonatoId: activo.id,
              categoria: c,
              creditosIniciales: ini,
            );
            idsIns.add(ex.id);
          }
          return ex.id;
        }
        final c = (cat != null && categorias.contains(cat)) ? cat : 'BRONCE';
        final ini = creditosInicialesPorCategoria[c] ?? 28;
        final id = await repoPi.crear(
          nombre: nombre,
          email: email,
          telefono: tel,
          palmaresGlobal: palm,
          campeonatoId: activo.id,
          categoria: c,
          creditosIniciales: ini,
        );
        porNombre[_norm(nombre)] = Piloto(
          id: id,
          nombre: nombre,
          palmaresGlobal: palm,
          telefono: tel,
          email: email,
          esCoordinadora: false,
          creadoEn: DateTime.now(),
        );
        idsIns.add(id);
        return id;
      }

      int nuevos = 0, saltados = 0;
      for (final f in filas) {
        if (nombresEq.contains(_norm(f.nombreEquipo))) {
          saltados++;
          continue;
        }
        if (f.piloto1Nombre.isEmpty) {
          saltados++;
          continue;
        }
        final p1 = await obtenerPiloto(
          f.piloto1Nombre, f.piloto1Email, f.piloto1Telefono,
          f.piloto1Categoria, f.piloto1Palmares,
        );
        int? p2;
        if ((f.piloto2Nombre ?? '').isNotEmpty) {
          p2 = await obtenerPiloto(
            f.piloto2Nombre!, f.piloto2Email, f.piloto2Telefono,
            f.piloto2Categoria, f.piloto2Palmares,
          );
        }
        final copa = (f.copa != null && f.copa!.isNotEmpty) ? f.copa! : 'GT';
        await repoEq.crear(
          campeonatoId: activo.id,
          nombre: f.nombreEquipo,
          copa: copa,
          piloto1Id: p1,
          piloto2Id: p2,
        );
        nombresEq.add(_norm(f.nombreEquipo));
        nuevos++;
      }
      final resumen = 'Equipos nuevos: $nuevos · Saltados: $saltados';
      await ref.read(repoHojasVinculadasProvider).marcarSync(v.fila.id, resumen);
      return ResultadoActualizacion(
        ok: true, mensaje: resumen, nuevos: nuevos, saltados: saltados,
      );
    } catch (e) {
      return ResultadoActualizacion(ok: false, mensaje: '$e');
    }
  }

  /// Actualizar un catálogo desde su hoja vinculada.
  /// Upsert por clave natural: añade lo nuevo y actualiza lo existente,
  /// sin borrar nada (re-sincronizar nunca duplica).
  Future<ResultadoActualizacion> actualizarCatalogo(
      VinculoHoja v, TipoCatalogo tipo) async {
    try {
      final datos = await _leerPestana(v);
      final m = MapeoCatalogo()
        ..colNombre = v.mapeo['colNombre']
        ..colCopa = v.mapeo['colCopa']
        ..colMarca = v.mapeo['colMarca']
        ..colModelo = v.mapeo['colModelo']
        ..colPesoMin = v.mapeo['colPesoMin']
        ..colCreditos = v.mapeo['colCreditos']
        ..colCodigo = v.mapeo['colCodigo']
        ..colDimension = v.mapeo['colDimension']
        ..colTipo = v.mapeo['colTipo']
        ..colReferencia = v.mapeo['colReferencia']
        ..colDientes = v.mapeo['colDientes']
        ..colDiametro = v.mapeo['colDiametro']
        ..colRpm = v.mapeo['colRpm']
        ..colGauss = v.mapeo['colGauss'];

      final db = ref.read(dbProvider);
      final repo = ref.read(repoCatalogosProvider);
      final svc = ref.read(googleSheetsServiceProvider);
      int nuevos = 0, actualizados = 0, saltados = 0;

      // Columna "ID" (convención fija, igual que al subir): si la hoja ya
      // la tiene, se empareja por id en vez de por nombre/clave — hace
      // falta cuando el nombre solo no distingue filas (p.ej. un motor
      // repetido en varias copas).
      final idHeader =
          datos.columnas.firstWhere((c) => _norm(c) == 'id', orElse: () => '');
      final idColIdx = idHeader.isEmpty ? -1 : datos.columnas.indexOf(idHeader);

      switch (tipo) {
        case TipoCatalogo.coches:
          final actuales = await db.select(db.catalogoCoches).get();
          if (idColIdx < 0) {
            final porNombre = {for (final c in actuales) _norm(c.nombre): c};
            for (final fila in datos.filas) {
              final nombre = fila[m.colNombre]?.trim() ?? '';
              if (nombre.isEmpty) { saltados++; continue; }
              final marca = fila[m.colMarca]?.trim() ?? '';
              final modelo = fila[m.colModelo]?.trim() ?? nombre;
              final peso = double.tryParse(
                      (fila[m.colPesoMin] ?? '17').replaceAll(',', '.')) ??
                  17.0;
              final cred =
                  int.tryParse(fila[m.colCreditos]?.trim() ?? '0') ?? 0;
              final copas = (fila[m.colCopa] ?? '')
                  .split(',')
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty)
                  .toList();
              final copasJson = copas.isEmpty ? null : json.encode(copas);
              final ex = porNombre[_norm(nombre)];
              if (ex == null) {
                await repo.crearCoche(
                    nombre: nombre, marca: marca, modelo: modelo,
                    pesoMin: peso, creditosCoche: cred,
                    copasJson: copasJson);
                nuevos++;
              } else if (ex.marca != marca ||
                  ex.modelo != modelo ||
                  ex.pesoMin != peso ||
                  ex.creditosCoche != cred ||
                  (ex.copasJson) != (copasJson ?? '[]')) {
                await repo.actualizarCoche(
                    ex.id,
                    CatalogoCochesCompanion(
                      marca: Value(marca),
                      modelo: Value(modelo),
                      pesoMin: Value(peso),
                      creditosCoche: Value(cred),
                      copasJson: Value(copasJson ?? '[]'),
                    ));
                actualizados++;
              } else {
                saltados++;
              }
            }
          } else {
            final porId = {
              for (final x in actuales)
                if ((x.idExterno ?? '').isNotEmpty) x.idExterno!: x
            };
            // Filas locales aún sin id (primera sincronización por ID): se
            // adoptan por clave natural en vez de duplicarlas.
            final sinId = _SinId(actuales, (x) => x.idExterno,
                (x) => ['${_norm(x.nombre)}|${_norm(x.marca)}', _norm(x.nombre)]);
            var siguienteId = [
              maxIdExterno(datos.filas.map((f) => f[idHeader])),
              maxIdExterno(actuales.map((x) => x.idExterno)),
            ].reduce((a, b) => a > b ? a : b);
            for (var k = 0; k < datos.filas.length; k++) {
              final fila = datos.filas[k];
              final nombre = fila[m.colNombre]?.trim() ?? '';
              if (nombre.isEmpty) { saltados++; continue; }
              final marca = fila[m.colMarca]?.trim() ?? '';
              final modelo = fila[m.colModelo]?.trim() ?? nombre;
              final peso = double.tryParse(
                      (fila[m.colPesoMin] ?? '17').replaceAll(',', '.')) ??
                  17.0;
              final cred =
                  int.tryParse(fila[m.colCreditos]?.trim() ?? '0') ?? 0;
              final copas = (fila[m.colCopa] ?? '')
                  .split(',')
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty)
                  .toList();
              final copasJson = copas.isEmpty ? null : json.encode(copas);
              final idHoja = fila[idHeader]?.trim() ?? '';
              final ex = (idHoja.isEmpty ? null : porId[idHoja]) ??
                  await _adoptar(sinId, ['${_norm(nombre)}|${_norm(marca)}', _norm(nombre)], (x) => x.id,
                      tipo, idHoja, () => ++siguienteId, v,
                      datos.filaAbs[k], idColIdx);
              if (ex != null) {
                if (ex.nombre != nombre ||
                    ex.marca != marca ||
                    ex.modelo != modelo ||
                    ex.pesoMin != peso ||
                    ex.creditosCoche != cred ||
                    (ex.copasJson) != (copasJson ?? '[]')) {
                  await repo.actualizarCoche(
                      ex.id,
                      CatalogoCochesCompanion(
                        nombre: Value(nombre),
                        marca: Value(marca),
                        modelo: Value(modelo),
                        pesoMin: Value(peso),
                        creditosCoche: Value(cred),
                        copasJson: Value(copasJson ?? '[]'),
                      ));
                  actualizados++;
                } else {
                  saltados++;
                }
              } else {
                String idFinal;
                if (idHoja.isEmpty) {
                  siguienteId++;
                  idFinal = siguienteId.toString();
                } else {
                  idFinal = idHoja;
                }
                await repo.crearCoche(
                    nombre: nombre, marca: marca, modelo: modelo,
                    pesoMin: peso, creditosCoche: cred,
                    copasJson: copasJson, idExterno: idFinal);
                if (idHoja.isEmpty) {
                  await svc.escribirCelda(v.fila.hojaId, v.fila.pestanaTitulo,
                      datos.filaAbs[k] + 1, idColIdx, idFinal);
                }
                nuevos++;
              }
            }
          }
        case TipoCatalogo.marcas:
          final actuales = await db.select(db.catalogoMarcas).get();
          if (idColIdx < 0) {
            final porCodigo = {for (final x in actuales) _norm(x.codigo): x};
            for (final fila in datos.filas) {
              final cod = fila[m.colCodigo]?.trim() ?? '';
              final nom = fila[m.colNombre]?.trim() ?? '';
              if (cod.isEmpty || nom.isEmpty) { saltados++; continue; }
              final ex = porCodigo[_norm(cod)];
              if (ex == null) {
                await repo.crearMarca(cod, nom);
                nuevos++;
              } else if (ex.nombre != nom) {
                await repo.actualizarMarca(ex.id, ex.codigo, nom);
                actualizados++;
              } else {
                saltados++;
              }
            }
          } else {
            final porId = {
              for (final x in actuales)
                if ((x.idExterno ?? '').isNotEmpty) x.idExterno!: x
            };
            // Filas locales aún sin id (primera sincronización por ID): se
            // adoptan por clave natural en vez de duplicarlas.
            final sinId = _SinId(actuales, (x) => x.idExterno,
                (x) => [_norm(x.codigo)]);
            var siguienteId = [
              maxIdExterno(datos.filas.map((f) => f[idHeader])),
              maxIdExterno(actuales.map((x) => x.idExterno)),
            ].reduce((a, b) => a > b ? a : b);
            for (var k = 0; k < datos.filas.length; k++) {
              final fila = datos.filas[k];
              final cod = fila[m.colCodigo]?.trim() ?? '';
              final nom = fila[m.colNombre]?.trim() ?? '';
              if (cod.isEmpty || nom.isEmpty) { saltados++; continue; }
              final idHoja = fila[idHeader]?.trim() ?? '';
              final ex = (idHoja.isEmpty ? null : porId[idHoja]) ??
                  await _adoptar(sinId, [_norm(cod)], (x) => x.id,
                      tipo, idHoja, () => ++siguienteId, v,
                      datos.filaAbs[k], idColIdx);
              if (ex != null) {
                if (ex.codigo != cod || ex.nombre != nom) {
                  await repo.actualizarMarca(ex.id, cod, nom);
                  actualizados++;
                } else {
                  saltados++;
                }
              } else {
                String idFinal;
                if (idHoja.isEmpty) {
                  siguienteId++;
                  idFinal = siguienteId.toString();
                } else {
                  idFinal = idHoja;
                }
                await repo.crearMarca(cod, nom, idExterno: idFinal);
                if (idHoja.isEmpty) {
                  await svc.escribirCelda(v.fila.hojaId, v.fila.pestanaTitulo,
                      datos.filaAbs[k] + 1, idColIdx, idFinal);
                }
                nuevos++;
              }
            }
          }
        case TipoCatalogo.llantas:
          final actuales = await db.select(db.catalogoLlantas).get();
          if (idColIdx < 0) {
            final claves = {
              for (final x in actuales) '${_norm(x.dimension)}|${x.tipo}'
            };
            for (final fila in datos.filas) {
              final dim = fila[m.colDimension]?.trim() ?? '';
              if (dim.isEmpty) { saltados++; continue; }
              var t = (fila[m.colTipo] ?? 'DELANTERA').trim().toUpperCase();
              if (!['DELANTERA', 'TRASERA', 'AMBAS'].contains(t)) {
                t = 'DELANTERA';
              }
              if (claves.contains('${_norm(dim)}|$t')) { saltados++; continue; }
              await repo.crearLlanta(dim, t,
                  copasJson: _copasJsonDe(fila[m.colCopa]));
              claves.add('${_norm(dim)}|$t');
              nuevos++;
            }
          } else {
            final porId = {
              for (final x in actuales)
                if ((x.idExterno ?? '').isNotEmpty) x.idExterno!: x
            };
            // Filas locales aún sin id (primera sincronización por ID): se
            // adoptan por clave natural en vez de duplicarlas.
            final sinId = _SinId(actuales, (x) => x.idExterno,
                (x) => ['${_norm(x.dimension)}|${x.tipo}']);
            var siguienteId = [
              maxIdExterno(datos.filas.map((f) => f[idHeader])),
              maxIdExterno(actuales.map((x) => x.idExterno)),
            ].reduce((a, b) => a > b ? a : b);
            for (var k = 0; k < datos.filas.length; k++) {
              final fila = datos.filas[k];
              final dim = fila[m.colDimension]?.trim() ?? '';
              if (dim.isEmpty) { saltados++; continue; }
              var t = (fila[m.colTipo] ?? 'DELANTERA').trim().toUpperCase();
              if (!['DELANTERA', 'TRASERA', 'AMBAS'].contains(t)) {
                t = 'DELANTERA';
              }
              final copasJson = _copasJsonDe(fila[m.colCopa]);
              final idHoja = fila[idHeader]?.trim() ?? '';
              final ex = (idHoja.isEmpty ? null : porId[idHoja]) ??
                  await _adoptar(sinId, ['${_norm(dim)}|$t'], (x) => x.id,
                      tipo, idHoja, () => ++siguienteId, v,
                      datos.filaAbs[k], idColIdx);
              if (ex != null) {
                if (ex.dimension != dim ||
                    ex.tipo != t ||
                    (ex.copasJson ?? '[]') != copasJson) {
                  await repo.actualizarLlanta(ex.id, dim, t,
                      copasJson: copasJson);
                  actualizados++;
                } else {
                  saltados++;
                }
              } else {
                String idFinal;
                if (idHoja.isEmpty) {
                  siguienteId++;
                  idFinal = siguienteId.toString();
                } else {
                  idFinal = idHoja;
                }
                await repo.crearLlanta(dim, t,
                    copasJson: copasJson, idExterno: idFinal);
                if (idHoja.isEmpty) {
                  await svc.escribirCelda(v.fila.hojaId, v.fila.pestanaTitulo,
                      datos.filaAbs[k] + 1, idColIdx, idFinal);
                }
                nuevos++;
              }
            }
          }
        case TipoCatalogo.engranajes:
          final actualesEngr = await db.select(db.catalogoEngranajes).get();
          if (idColIdx < 0) {
            final claves = {
              for (final x in actualesEngr)
                '${x.tipo}|${x.diametro}|${x.dientes}'
            };
            for (final fila in datos.filas) {
              final dientes = int.tryParse(fila[m.colDientes]?.trim() ?? '');
              if (dientes == null) { saltados++; continue; }
              final diametro = double.tryParse(
                  (fila[m.colDiametro] ?? '').trim().replaceAll(',', '.'));
              final tNorm = _norm(fila[m.colTipo] ?? '');
              final t = tNorm.contains('corona') ? 'CORONA' : 'PINON';
              final clave = '$t|$diametro|$dientes';
              if (claves.contains(clave)) { saltados++; continue; }
              await repo.crearEngranaje(
                  tipo: t,
                  diametro: diametro,
                  dientes: dientes,
                  copasJson: _copasJsonDe(fila[m.colCopa]));
              claves.add(clave);
              nuevos++;
            }
          } else {
            final porId = {
              for (final x in actualesEngr)
                if ((x.idExterno ?? '').isNotEmpty) x.idExterno!: x
            };
            // Filas locales aún sin id (primera sincronización por ID): se
            // adoptan por clave natural en vez de duplicarlas.
            final sinId = _SinId(actualesEngr, (x) => x.idExterno,
                (x) => ['${x.tipo}|${x.diametro}|${x.dientes}']);
            var siguienteId = [
              maxIdExterno(datos.filas.map((f) => f[idHeader])),
              maxIdExterno(actualesEngr.map((x) => x.idExterno)),
            ].reduce((a, b) => a > b ? a : b);
            for (var k = 0; k < datos.filas.length; k++) {
              final fila = datos.filas[k];
              final dientes = int.tryParse(fila[m.colDientes]?.trim() ?? '');
              if (dientes == null) { saltados++; continue; }
              final diametro = double.tryParse(
                  (fila[m.colDiametro] ?? '').trim().replaceAll(',', '.'));
              final tNorm = _norm(fila[m.colTipo] ?? '');
              final t = tNorm.contains('corona') ? 'CORONA' : 'PINON';
              final copasJson = _copasJsonDe(fila[m.colCopa]);
              final idHoja = fila[idHeader]?.trim() ?? '';
              final ex = (idHoja.isEmpty ? null : porId[idHoja]) ??
                  await _adoptar(sinId, ['$t|$diametro|$dientes'], (x) => x.id,
                      tipo, idHoja, () => ++siguienteId, v,
                      datos.filaAbs[k], idColIdx);
              if (ex != null) {
                if (ex.tipo != t ||
                    ex.diametro != diametro ||
                    ex.dientes != dientes ||
                    (ex.copasJson ?? '[]') != copasJson) {
                  await repo.actualizarEngranaje(ex.id, t, diametro, dientes,
                      copasJson: copasJson);
                  actualizados++;
                } else {
                  saltados++;
                }
              } else {
                String idFinal;
                if (idHoja.isEmpty) {
                  siguienteId++;
                  idFinal = siguienteId.toString();
                } else {
                  idFinal = idHoja;
                }
                await repo.crearEngranaje(
                    tipo: t,
                    diametro: diametro,
                    dientes: dientes,
                    copasJson: copasJson,
                    idExterno: idFinal);
                if (idHoja.isEmpty) {
                  await svc.escribirCelda(v.fila.hojaId, v.fila.pestanaTitulo,
                      datos.filaAbs[k] + 1, idColIdx, idFinal);
                }
                nuevos++;
              }
            }
          }
        case TipoCatalogo.motores:
          final actuales = await db.select(db.catalogoMotores).get();
          if (idColIdx < 0) {
            // Sin columna ID todavía: comportamiento de siempre (por nombre).
            final porNombre = {for (final x in actuales) _norm(x.nombre): x};
            for (final fila in datos.filas) {
              final n = fila[m.colNombre]?.trim() ?? '';
              if (n.isEmpty) { saltados++; continue; }
              final rpm = int.tryParse(fila[m.colRpm]?.trim() ?? '');
              final gauss = double.tryParse(
                  (fila[m.colGauss] ?? '').trim().replaceAll(',', '.'));
              final ex = porNombre[_norm(n)];
              if (ex == null) {
                final copas = (fila[m.colCopa] ?? '')
                    .split(',')
                    .map((s) => s.trim())
                    .where((s) => s.isNotEmpty)
                    .toList();
                await repo.crearMotor(
                    nombre: n,
                    rpm: rpm,
                    gauss: gauss,
                    copasJson: copas.isEmpty ? null : json.encode(copas));
                nuevos++;
              } else if (ex.rpm != rpm || ex.gauss != gauss) {
                await repo.actualizarMotor(
                    ex.id,
                    CatalogoMotoresCompanion(
                        rpm: Value(rpm), gauss: Value(gauss)));
                actualizados++;
              } else {
                saltados++;
              }
            }
          } else {
            final porId = {
              for (final x in actuales)
                if ((x.idExterno ?? '').isNotEmpty) x.idExterno!: x
            };
            // Filas locales aún sin id (primera sincronización por ID): se
            // adoptan por clave natural en vez de duplicarlas.
            final sinId = _SinId(actuales, (x) => x.idExterno,
                (x) => ['${_norm(x.nombre)}|${_copasClave(x.copasJson)}', _norm(x.nombre)]);
            // Contador correlativo para ids nuevos (filas tecleadas a mano
            // en la hoja sin id): arranca en el mayor visto entre la hoja y
            // lo local, y sigue subiendo dentro de esta misma pasada.
            var siguienteId = [
              maxIdExterno(datos.filas.map((f) => f[idHeader])),
              maxIdExterno(actuales.map((x) => x.idExterno)),
            ].reduce((a, b) => a > b ? a : b);
            for (var k = 0; k < datos.filas.length; k++) {
              final fila = datos.filas[k];
              final n = fila[m.colNombre]?.trim() ?? '';
              if (n.isEmpty) { saltados++; continue; }
              final rpm = int.tryParse(fila[m.colRpm]?.trim() ?? '');
              final gauss = double.tryParse(
                  (fila[m.colGauss] ?? '').trim().replaceAll(',', '.'));
              final copas = (fila[m.colCopa] ?? '')
                  .split(',')
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty)
                  .toList();
              final copasJson = copas.isEmpty ? '[]' : json.encode(copas);
              final idHoja = fila[idHeader]?.trim() ?? '';
              final ex = (idHoja.isEmpty ? null : porId[idHoja]) ??
                  await _adoptar(sinId, ['${_norm(n)}|${_copasClave(copasJson)}', _norm(n)], (x) => x.id,
                      tipo, idHoja, () => ++siguienteId, v,
                      datos.filaAbs[k], idColIdx);
              if (ex != null) {
                if (ex.nombre != n ||
                    ex.rpm != rpm ||
                    ex.gauss != gauss ||
                    ex.copasJson != copasJson) {
                  await repo.actualizarMotor(
                      ex.id,
                      CatalogoMotoresCompanion(
                        nombre: Value(n),
                        rpm: Value(rpm),
                        gauss: Value(gauss),
                        copasJson: Value(copasJson),
                      ));
                  actualizados++;
                } else {
                  saltados++;
                }
              } else {
                // Fila que no reclama ningún motor local: viene nueva de la
                // hoja (tecleada a mano). Se crea localmente y, si no traía
                // id, se le asigna uno y se escribe de vuelta en la celda
                // para que quede emparejada a partir de ahora.
                String idFinal;
                if (idHoja.isEmpty) {
                  siguienteId++;
                  idFinal = siguienteId.toString();
                } else {
                  idFinal = idHoja;
                }
                await repo.crearMotor(
                    nombre: n,
                    rpm: rpm,
                    gauss: gauss,
                    copasJson: copasJson == '[]' ? null : copasJson,
                    idExterno: idFinal);
                if (idHoja.isEmpty) {
                  await svc.escribirCelda(v.fila.hojaId, v.fila.pestanaTitulo,
                      datos.filaAbs[k] + 1, idColIdx, idFinal);
                }
                nuevos++;
              }
            }
          }
        case TipoCatalogo.neumaticos:
          final actuales = await db.select(db.catalogoNeumaticos).get();
          if (idColIdx < 0) {
            final porNombre = {for (final x in actuales) _norm(x.nombre): x};
            for (final fila in datos.filas) {
              final n = fila[m.colNombre]?.trim() ?? '';
              if (n.isEmpty) { saltados++; continue; }
              final r = fila[m.colReferencia]?.trim();
              final ex = porNombre[_norm(n)];
              if (ex == null) {
                await repo.crearNeumatico(
                    n, (r == null || r.isEmpty) ? null : r,
                    copasJson: _copasJsonDe(fila[m.colCopa]));
                nuevos++;
              } else {
                saltados++;
              }
            }
          } else {
            final porId = {
              for (final x in actuales)
                if ((x.idExterno ?? '').isNotEmpty) x.idExterno!: x
            };
            // Filas locales aún sin id (primera sincronización por ID): se
            // adoptan por clave natural en vez de duplicarlas.
            final sinId = _SinId(actuales, (x) => x.idExterno,
                (x) => [_norm(x.nombre)]);
            var siguienteId = [
              maxIdExterno(datos.filas.map((f) => f[idHeader])),
              maxIdExterno(actuales.map((x) => x.idExterno)),
            ].reduce((a, b) => a > b ? a : b);
            for (var k = 0; k < datos.filas.length; k++) {
              final fila = datos.filas[k];
              final n = fila[m.colNombre]?.trim() ?? '';
              if (n.isEmpty) { saltados++; continue; }
              final r = fila[m.colReferencia]?.trim();
              final copasJson = _copasJsonDe(fila[m.colCopa]);
              final idHoja = fila[idHeader]?.trim() ?? '';
              final ex = (idHoja.isEmpty ? null : porId[idHoja]) ??
                  await _adoptar(sinId, [_norm(n)], (x) => x.id,
                      tipo, idHoja, () => ++siguienteId, v,
                      datos.filaAbs[k], idColIdx);
              if (ex != null) {
                if (ex.nombre != n ||
                    (ex.referencia ?? '') != (r ?? '') ||
                    (ex.copasJson ?? '[]') != copasJson) {
                  await repo.actualizarNeumatico(ex.id, n, r,
                      copasJson: copasJson);
                  actualizados++;
                } else {
                  saltados++;
                }
              } else {
                String idFinal;
                if (idHoja.isEmpty) {
                  siguienteId++;
                  idFinal = siguienteId.toString();
                } else {
                  idFinal = idHoja;
                }
                await repo.crearNeumatico(
                    n, (r == null || r.isEmpty) ? null : r,
                    copasJson: copasJson, idExterno: idFinal);
                if (idHoja.isEmpty) {
                  await svc.escribirCelda(v.fila.hojaId, v.fila.pestanaTitulo,
                      datos.filaAbs[k] + 1, idColIdx, idFinal);
                }
                nuevos++;
              }
            }
          }
        case TipoCatalogo.chasis:
          // Sin columna ID: catálogo sin hoja vinculada todavía.
          final nombresChasis = (await db.select(db.catalogoChasis).get())
              .map((x) => _norm(x.nombre))
              .toSet();
          for (final fila in datos.filas) {
            final n = fila[m.colNombre]?.trim() ?? '';
            if (n.isEmpty || nombresChasis.contains(_norm(n))) {
              saltados++;
              continue;
            }
            await repo.crearChasis(n);
            nombresChasis.add(_norm(n));
            nuevos++;
          }
        case TipoCatalogo.bancadas:
          final actualesBanc = await db.select(db.catalogoBancadas).get();
          if (idColIdx < 0) {
            final nombres = actualesBanc.map((x) => _norm(x.nombre)).toSet();
            for (final fila in datos.filas) {
              final n = fila[m.colNombre]?.trim() ?? '';
              if (n.isEmpty || nombres.contains(_norm(n))) {
                saltados++;
                continue;
              }
              await repo.crearBancada(n,
                  copasJson: _copasJsonDe(fila[m.colCopa]));
              nombres.add(_norm(n));
              nuevos++;
            }
          } else {
            final porId = {
              for (final x in actualesBanc)
                if ((x.idExterno ?? '').isNotEmpty) x.idExterno!: x
            };
            // Filas locales aún sin id (primera sincronización por ID): se
            // adoptan por clave natural en vez de duplicarlas.
            final sinId = _SinId(actualesBanc, (x) => x.idExterno,
                (x) => [_norm(x.nombre)]);
            var siguienteId = [
              maxIdExterno(datos.filas.map((f) => f[idHeader])),
              maxIdExterno(actualesBanc.map((x) => x.idExterno)),
            ].reduce((a, b) => a > b ? a : b);
            for (var k = 0; k < datos.filas.length; k++) {
              final fila = datos.filas[k];
              final n = fila[m.colNombre]?.trim() ?? '';
              if (n.isEmpty) { saltados++; continue; }
              final copasJson = _copasJsonDe(fila[m.colCopa]);
              final idHoja = fila[idHeader]?.trim() ?? '';
              final ex = (idHoja.isEmpty ? null : porId[idHoja]) ??
                  await _adoptar(sinId, [_norm(n)], (x) => x.id,
                      tipo, idHoja, () => ++siguienteId, v,
                      datos.filaAbs[k], idColIdx);
              if (ex != null) {
                if (ex.nombre != n || ex.copasJson != copasJson) {
                  await repo.actualizarBancada(ex.id, n,
                      copasJson: copasJson);
                  actualizados++;
                } else {
                  saltados++;
                }
              } else {
                String idFinal;
                if (idHoja.isEmpty) {
                  siguienteId++;
                  idFinal = siguienteId.toString();
                } else {
                  idFinal = idHoja;
                }
                await repo.crearBancada(n,
                    copasJson: copasJson, idExterno: idFinal);
                if (idHoja.isEmpty) {
                  await svc.escribirCelda(v.fila.hojaId, v.fila.pestanaTitulo,
                      datos.filaAbs[k] + 1, idColIdx, idFinal);
                }
                nuevos++;
              }
            }
          }
        case TipoCatalogo.copas:
        case TipoCatalogo.clubs:
          Future<int> crear(String n, {String? idExterno}) => switch (tipo) {
                TipoCatalogo.copas => repo.crearCopa(n, idExterno: idExterno),
                _ => repo.crearClub(n, idExterno: idExterno),
              };
          Future<void> actualizar(int id, String n) => switch (tipo) {
                TipoCatalogo.copas => repo.actualizarCopa(id, n),
                _ => repo.actualizarClub(id, n),
              };
          final actualesSimple = switch (tipo) {
            TipoCatalogo.copas => (await db.select(db.catalogoCopas).get())
                .map((x) => (id: x.id, nombre: x.nombre, idExterno: x.idExterno))
                .toList(),
            _ => (await db.select(db.catalogoClubs).get())
                .map((x) => (id: x.id, nombre: x.nombre, idExterno: x.idExterno))
                .toList(),
          };
          if (idColIdx < 0) {
            final nombres = actualesSimple.map((x) => _norm(x.nombre)).toSet();
            for (final fila in datos.filas) {
              final n = fila[m.colNombre]?.trim() ?? '';
              if (n.isEmpty || nombres.contains(_norm(n))) {
                saltados++;
                continue;
              }
              await crear(n);
              nombres.add(_norm(n));
              nuevos++;
            }
          } else {
            final porId = {
              for (final x in actualesSimple)
                if ((x.idExterno ?? '').isNotEmpty) x.idExterno!: x
            };
            // Filas locales aún sin id (primera sincronización por ID): se
            // adoptan por clave natural en vez de duplicarlas.
            final sinId = _SinId(actualesSimple, (x) => x.idExterno,
                (x) => [_norm(x.nombre)]);
            var siguienteId = [
              maxIdExterno(datos.filas.map((f) => f[idHeader])),
              maxIdExterno(actualesSimple.map((x) => x.idExterno)),
            ].reduce((a, b) => a > b ? a : b);
            for (var k = 0; k < datos.filas.length; k++) {
              final fila = datos.filas[k];
              final n = fila[m.colNombre]?.trim() ?? '';
              if (n.isEmpty) { saltados++; continue; }
              final idHoja = fila[idHeader]?.trim() ?? '';
              final ex = (idHoja.isEmpty ? null : porId[idHoja]) ??
                  await _adoptar(sinId, [_norm(n)], (x) => x.id,
                      tipo, idHoja, () => ++siguienteId, v,
                      datos.filaAbs[k], idColIdx);
              if (ex != null) {
                if (ex.nombre != n) {
                  await actualizar(ex.id, n);
                  actualizados++;
                } else {
                  saltados++;
                }
              } else {
                String idFinal;
                if (idHoja.isEmpty) {
                  siguienteId++;
                  idFinal = siguienteId.toString();
                } else {
                  idFinal = idHoja;
                }
                await crear(n, idExterno: idFinal);
                if (idHoja.isEmpty) {
                  await svc.escribirCelda(v.fila.hojaId, v.fila.pestanaTitulo,
                      datos.filaAbs[k] + 1, idColIdx, idFinal);
                }
                nuevos++;
              }
            }
          }
      }

      final resumen =
          'Nuevos: $nuevos · Actualizados: $actualizados · Sin cambios: $saltados';
      await ref.read(repoHojasVinculadasProvider).marcarSync(v.fila.id, resumen);
      return ResultadoActualizacion(
        ok: true, mensaje: resumen,
        nuevos: nuevos, actualizados: actualizados, saltados: saltados,
      );
    } catch (e) {
      return ResultadoActualizacion(ok: false, mensaje: '$e');
    }
  }

  /// Actualizar inscripciones a una prueba.
  Future<ResultadoActualizacion> actualizarInscripciones(VinculoHoja v) async {
    final pruebaId = v.fila.pruebaId;
    if (pruebaId == null) {
      return ResultadoActualizacion(ok: false, mensaje: 'Sin prueba asignada al vínculo');
    }
    final activo = ref.read(campeonatoActivoProvider);
    if (activo == null) {
      return ResultadoActualizacion(ok: false, mensaje: 'Sin campeonato activo');
    }
    try {
      final datos = await _leerPestana(v);
      final m = MapeoInscripcion()
        ..colEquipo = v.mapeo['colEquipo']
        ..colDia = v.mapeo['colDia']
        ..colNotas = v.mapeo['colNotas'];
      final filas = ImportadorInscripciones.transformar(datos.filas, m);
      final db = ref.read(dbProvider);
      final repo = ref.read(repoInscripcionesPruebaProvider);

      final equipos = await (db.select(db.equipos)
            ..where((t) => t.campeonatoId.equals(activo.id)))
          .get();
      final porNombre = {for (final e in equipos) _norm(e.nombre): e};
      final yaIns = await (db.select(db.inscripcionesPrueba)
            ..where((t) => t.pruebaId.equals(pruebaId)))
          .get();
      final idsYa = yaIns.map((i) => i.equipoId).toSet();

      int nuevos = 0, ya = 0, sin = 0;
      for (final f in filas) {
        final eq = porNombre[_norm(f.nombreEquipo)];
        if (eq == null) { sin++; continue; }
        if (idsYa.contains(eq.id)) {
          // actualizar día/notas si llegan nuevos valores
          if ((f.preferenciaDia ?? '').isNotEmpty ||
              (f.notas ?? '').isNotEmpty) {
            await (db.update(db.inscripcionesPrueba)
                  ..where((t) =>
                      t.pruebaId.equals(pruebaId) &
                      t.equipoId.equals(eq.id)))
                .write(InscripcionesPruebaCompanion(
              preferenciaDia: f.preferenciaDia == null
                  ? const Value.absent()
                  : Value(f.preferenciaDia),
              notas: f.notas == null
                  ? const Value.absent()
                  : Value(f.notas),
            ));
          }
          ya++;
          continue;
        }
        await repo.inscribir(
          pruebaId: pruebaId,
          equipoId: eq.id,
          preferenciaDia: f.preferenciaDia,
          notas: f.notas,
        );
        idsYa.add(eq.id);
        nuevos++;
      }
      final resumen =
          'Nuevas inscripciones: $nuevos · Ya inscritos: $ya · No reconocidos: $sin';
      await ref.read(repoHojasVinculadasProvider).marcarSync(v.fila.id, resumen);
      return ResultadoActualizacion(
        ok: true, mensaje: resumen,
        nuevos: nuevos, actualizados: ya, saltados: sin,
      );
    } catch (e) {
      return ResultadoActualizacion(ok: false, mensaje: '$e');
    }
  }
}

final actualizadorDriveProvider = Provider<ActualizadorDrive>((ref) {
  return ActualizadorDrive(ref);
});

/// Filas locales sin id externo, indexadas por una o más claves naturales
/// (de más a menos específica). Cada fila se adopta como mucho una vez.
class _SinId<T> {
  _SinId(Iterable<T> filas, String? Function(T) idExterno,
      List<String> Function(T) claves) {
    for (final f in filas) {
      if ((idExterno(f) ?? '').isNotEmpty) continue;
      final cs = claves(f);
      for (var i = 0; i < cs.length; i++) {
        _porClave.putIfAbsent('$i:${cs[i]}', () => []).add(f);
      }
    }
  }

  final _porClave = <String, List<T>>{};
  final _tomadas = <T>{};

  T? tomar(List<String> claves) {
    for (var i = 0; i < claves.length; i++) {
      for (final f in _porClave['$i:${claves[i]}'] ?? <T>[]) {
        if (_tomadas.add(f)) return f;
      }
    }
    return null;
  }
}
