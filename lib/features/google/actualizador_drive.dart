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

  Future<({List<String> columnas, List<Map<String, String>> filas})>
      _leerPestana(VinculoHoja v) async {
    final svc = ref.read(googleSheetsServiceProvider);
    final filas = await svc.leerPestana(v.fila.hojaId, v.fila.pestanaTitulo);
    return _normalizar(filas);
  }

  ({List<String> columnas, List<Map<String, String>> filas}) _normalizar(
      List<List<String>> filas) {
    int idxCab = -1;
    for (var i = 0; i < filas.length; i++) {
      final llenas = filas[i].where((c) => c.trim().isNotEmpty).length;
      if (llenas >= 2) {
        idxCab = i;
        break;
      }
    }
    if (idxCab == -1) {
      return (columnas: <String>[], filas: <Map<String, String>>[]);
    }
    final columnas = filas[idxCab].map((c) => c.trim()).toList();
    final out = <Map<String, String>>[];
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
    }
    return (columnas: columnas.where((c) => c.isNotEmpty).toList(), filas: out);
  }

  static String _norm(String s) =>
      s.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();

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
        ..colRpm = v.mapeo['colRpm']
        ..colGauss = v.mapeo['colGauss'];

      final db = ref.read(dbProvider);
      final repo = ref.read(repoCatalogosProvider);
      int nuevos = 0, actualizados = 0, saltados = 0;

      switch (tipo) {
        case TipoCatalogo.coches:
          final actuales = await db.select(db.catalogoCoches).get();
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
            final ex = porNombre[_norm(nombre)];
            if (ex == null) {
              await repo.crearCoche(
                  nombre: nombre, marca: marca, modelo: modelo,
                  pesoMin: peso, creditosCoche: cred,
                  copasJson: copas.isEmpty ? null : json.encode(copas));
              nuevos++;
            } else if (ex.marca != marca ||
                ex.modelo != modelo ||
                ex.pesoMin != peso ||
                ex.creditosCoche != cred) {
              await repo.actualizarCoche(
                  ex.id,
                  CatalogoCochesCompanion(
                    marca: Value(marca),
                    modelo: Value(modelo),
                    pesoMin: Value(peso),
                    creditosCoche: Value(cred),
                  ));
              actualizados++;
            } else {
              saltados++;
            }
          }
        case TipoCatalogo.marcas:
          final actuales = await db.select(db.catalogoMarcas).get();
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
        case TipoCatalogo.llantas:
          final actuales = await db.select(db.catalogoLlantas).get();
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
            await repo.crearLlanta(dim, t);
            claves.add('${_norm(dim)}|$t');
            nuevos++;
          }
        case TipoCatalogo.engranajes:
          final actuales = await db.select(db.catalogoEngranajes).get();
          final claves = {
            for (final x in actuales)
              '${x.tipo}|${_norm(x.marca)}|${x.dientes}'
          };
          for (final fila in datos.filas) {
            final marca = fila[m.colMarca]?.trim() ?? '';
            final dientes = int.tryParse(fila[m.colDientes]?.trim() ?? '');
            if (marca.isEmpty || dientes == null) { saltados++; continue; }
            final tNorm = _norm(fila[m.colTipo] ?? '');
            final t = tNorm.contains('corona') ? 'CORONA' : 'PINON';
            final clave = '$t|${_norm(marca)}|$dientes';
            if (claves.contains(clave)) { saltados++; continue; }
            await repo.crearEngranaje(tipo: t, marca: marca, dientes: dientes);
            claves.add(clave);
            nuevos++;
          }
        case TipoCatalogo.motores:
          final actuales = await db.select(db.catalogoMotores).get();
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
              await ref.read(repoCatalogosProvider).crearMotor(
                  nombre: n,
                  rpm: rpm,
                  gauss: gauss,
                  copasJson: copas.isEmpty ? null : json.encode(copas));
              nuevos++;
            } else if (ex.rpm != rpm || ex.gauss != gauss) {
              await ref.read(repoCatalogosProvider).actualizarMotor(
                  ex.id,
                  CatalogoMotoresCompanion(
                      rpm: Value(rpm), gauss: Value(gauss)));
              actualizados++;
            } else {
              saltados++;
            }
          }
        case TipoCatalogo.neumaticos:
          final actuales = await db.select(db.catalogoNeumaticos).get();
          final porNombre = {for (final x in actuales) _norm(x.nombre): x};
          for (final fila in datos.filas) {
            final n = fila[m.colNombre]?.trim() ?? '';
            if (n.isEmpty) { saltados++; continue; }
            final r = fila[m.colReferencia]?.trim();
            final ex = porNombre[_norm(n)];
            if (ex == null) {
              await repo.crearNeumatico(
                  n, (r == null || r.isEmpty) ? null : r);
              nuevos++;
            } else {
              saltados++;
            }
          }
        case TipoCatalogo.bancadas:
        case TipoCatalogo.chasis:
        case TipoCatalogo.copas:
        case TipoCatalogo.clubs:
          final nombres = switch (tipo) {
            TipoCatalogo.bancadas => (await db
                    .select(db.catalogoBancadas)
                    .get())
                .map((x) => _norm(x.nombre))
                .toSet(),
            TipoCatalogo.chasis => (await db.select(db.catalogoChasis).get())
                .map((x) => _norm(x.nombre))
                .toSet(),
            TipoCatalogo.copas => (await db.select(db.catalogoCopas).get())
                .map((x) => _norm(x.nombre))
                .toSet(),
            _ => (await db.select(db.catalogoClubs).get())
                .map((x) => _norm(x.nombre))
                .toSet(),
          };
          for (final fila in datos.filas) {
            final n = fila[m.colNombre]?.trim() ?? '';
            if (n.isEmpty || nombres.contains(_norm(n))) {
              saltados++;
              continue;
            }
            switch (tipo) {
              case TipoCatalogo.bancadas:
                await repo.crearBancada(n);
              case TipoCatalogo.chasis:
                await repo.crearChasis(n);
              case TipoCatalogo.copas:
                await repo.crearCopa(n);
              default:
                await repo.crearClub(n);
            }
            nombres.add(_norm(n));
            nuevos++;
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
