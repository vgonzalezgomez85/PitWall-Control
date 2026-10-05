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

// Aplica en la BD local el paquete de sincronización de otro Control
// (ver paquete_sync.dart). Todos los Controls son iguales: en cada registro
// gana el cambio más reciente (marca de tiempo en ms; si empatan, el nombre
// de dispositivo mayor, para que todos decidan lo mismo).
//
// Unidades que se fusionan por separado:
//  - Verificación de (manga, equipo), o su borrado.
//  - Copa de un equipo en la prueba.
//  - Tesorería de un equipo en la prueba (pago + wildcard + "Coord. total").
//
// Los créditos NO viajan: al cambiar una verificación validada, cada Control
// revierte y recalcula los suyos con RepositorioVerificaciones, como si la
// hubiera validado él.

import 'dart:convert';

import 'package:drift/drift.dart';

import '../../data/database/app_database.dart';
import '../verificaciones/repositorio_verificaciones.dart';
import 'paquete_sync.dart';

class ResultadoFusionSync {
  int verifNuevas = 0;
  int verifActualizadas = 0;
  int verifBorradas = 0;
  int copas = 0;
  int tesoreria = 0;
  final avisos = <String>[];

  /// Fotos que usan las verificaciones recibidas (hay que traer las que
  /// falten en este dispositivo).
  final fotos = <String>{};

  int get cambios =>
      verifNuevas + verifActualizadas + verifBorradas + copas + tesoreria;

  String resumen() {
    if (cambios == 0) return 'Sin cambios';
    final p = <String>[
      if (verifNuevas > 0) '$verifNuevas verificaciones nuevas',
      if (verifActualizadas > 0) '$verifActualizadas actualizadas',
      if (verifBorradas > 0) '$verifBorradas borradas',
      if (copas > 0) '$copas copas',
      if (tesoreria > 0) '$tesoreria cobros',
    ];
    return p.join(' · ');
  }
}

/// ¿Gana el cambio remoto (tsR, porR) sobre el local (tsL, porL)?
bool ganaRemoto(int tsR, String? porR, int tsL, String? porL) {
  if (tsR != tsL) return tsR > tsL;
  return (porR ?? '').compareTo(porL ?? '') > 0;
}

/// Busca la fila local que corresponde a [ref]: la del mismo id si se llama
/// igual (misma copia de BD) o, si no, la única con ese nombre.
T? casar<T>(RefSync? ref, List<T> filas, int Function(T) id,
    String Function(T) nombre) {
  if (ref == null) return null;
  for (final f in filas) {
    if (id(f) == ref.id && nombre(f) == ref.nombre) return f;
  }
  final mismos = filas.where((f) => nombre(f) == ref.nombre).toList();
  return mismos.length == 1 ? mismos.first : null;
}

class FusionadorSync {
  FusionadorSync(this.db) : _repo = RepositorioVerificaciones(db);
  final AppDatabase db;
  final RepositorioVerificaciones _repo;

  /// Fusiona [paquete] en la prueba local [pruebaId].
  Future<ResultadoFusionSync> fusionar(
      int pruebaId, Map<String, dynamic> paquete) async {
    if (paquete['schema'] != schemaPaqueteSync) {
      throw const FormatException('Formato de sincronización desconocido.');
    }
    if (paquete['schemaVersion'] != db.schemaVersion) {
      throw const FormatException(
          'El otro Control tiene otra versión de PitWall Control. '
          'Actualizad todos a la misma versión.');
    }
    final r = ResultadoFusionSync();
    await db.transaction(() async {
      final prueba = await (db.select(db.pruebas)
            ..where((t) => t.id.equals(pruebaId)))
          .getSingle();
      final mangas = await (db.select(db.mangas)
            ..where((t) => t.pruebaId.equals(pruebaId)))
          .get();
      final equipos = await (db.select(db.equipos)
            ..where((t) => t.campeonatoId.equals(prueba.campeonatoId)))
          .get();
      final coches = await db.select(db.catalogoCoches).get();

      Manga? manga(Object? j) =>
          casar(RefSync.fromJson(j), mangas, (m) => m.id, (m) => m.nombre);
      Equipo? equipo(Object? j) =>
          casar(RefSync.fromJson(j), equipos, (e) => e.id, (e) => e.nombre);

      // 1) Verificaciones.
      for (final raw in (paquete['verificaciones'] as List? ?? const [])) {
        final j = raw as Map<String, dynamic>;
        final m = manga(j['manga']);
        final e = equipo(j['equipo']);
        if (m == null || e == null) {
          r.avisos.add('Verificación de «${RefSync.fromJson(j['equipo'])?.nombre}» '
              'en «${RefSync.fromJson(j['manga'])?.nombre}»: '
              'no existe aquí esa manga o ese equipo.');
          continue;
        }
        final cocheRef = RefSync.fromJson(j['coche']);
        final coche = casar(cocheRef, coches, (c) => c.id, (c) => c.nombre);
        if (cocheRef != null && coche == null) {
          r.avisos.add('${e.nombre}: el coche «${cocheRef.nombre}» no está '
              'en el catálogo de este Control; se deja sin coche.');
        }
        await _fusionarVerificacion(
            r, m, e, coche?.id, j['datos'] as Map<String, dynamic>);
      }

      // 2) Borrados de verificaciones.
      for (final raw in (paquete['borrados'] as List? ?? const [])) {
        final j = raw as Map<String, dynamic>;
        final m = manga(j['manga']);
        final e = equipo(j['equipo']);
        if (m == null || e == null) continue;
        await _fusionarBorrado(r, m, e, (j['borradoMs'] as num).toInt(),
            j['borradoPor'] as String?);
      }

      // 3) Copa y tesorería por inscrito.
      for (final raw in (paquete['inscripciones'] as List? ?? const [])) {
        final j = raw as Map<String, dynamic>;
        final e = equipo(j['equipo']);
        if (e == null) continue;
        await _fusionarInscripcion(r, pruebaId, e, j);
      }
    });
    return r;
  }

  Future<void> _fusionarVerificacion(ResultadoFusionSync r, Manga m,
      Equipo e, int? cocheId, Map<String, dynamic> datos) async {
    final local = await (db.select(db.verificaciones)
          ..where((t) => t.mangaId.equals(m.id) & t.equipoId.equals(e.id))
          ..limit(1))
        .getSingleOrNull();
    final tsR = (datos['modificadoMs'] as num?)?.toInt() ?? 0;
    final porR = datos['modificadoPor'] as String?;

    if (local == null) {
      final borrado = await _borradoLocal(m.id, e.id);
      if (borrado != null &&
          !ganaRemoto(tsR, porR, borrado.borradoMs, borrado.borradoPor)) {
        return; // aquí se borró después de ese cambio
      }
    } else if (!ganaRemoto(
        tsR, porR, local.modificadoMs ?? 0, local.modificadoPor)) {
      return;
    }

    // Se adaptan los datos remotos a los ids locales. Los créditos
    // aplicados son contabilidad de ESTE Control: se conservan.
    final j = Map<String, dynamic>.of(datos)
      ..['id'] = local?.id ?? 0
      ..['mangaId'] = m.id
      ..['equipoId'] = e.id
      ..['cocheCatalogoId'] = cocheId
      ..['credAplicadoP1'] = local?.credAplicadoP1 ?? 0
      ..['credAplicadoP2'] = local?.credAplicadoP2 ?? 0
      ..['fotosJson'] = jsonEncode(nombresFotos(datos['fotosJson'] as String? ?? '[]'));
    final remota = Verificacione.fromJson(j);
    r.fotos.addAll(nombresFotos(remota.fotosJson));

    int id;
    if (local == null) {
      id = await db
          .into(db.verificaciones)
          .insert(remota.toCompanion(false).copyWith(id: const Value.absent()));
      await (db.delete(db.borradosSync)
            ..where((t) => t.mangaId.equals(m.id) & t.equipoId.equals(e.id)))
          .go();
      r.verifNuevas++;
    } else {
      id = local.id;
      await db.update(db.verificaciones).replace(remota);
      r.verifActualizadas++;
    }
    // Créditos: solo si la validación o el coche pueden haberlos cambiado.
    final antes = local;
    if (remota.validado ||
        (antes != null && (antes.credAplicadoP1 != 0 || antes.credAplicadoP2 != 0))) {
      if (antes == null ||
          antes.validado != remota.validado ||
          antes.cocheCatalogoId != remota.cocheCatalogoId) {
        await _repo.recalcularCreditos(id);
      }
    }
  }

  Future<BorradosSyncData?> _borradoLocal(int mangaId, int equipoId) async {
    final l = await (db.select(db.borradosSync)
          ..where(
              (t) => t.mangaId.equals(mangaId) & t.equipoId.equals(equipoId))
          ..orderBy([(t) => OrderingTerm.desc(t.borradoMs)])
          ..limit(1))
        .get();
    return l.isEmpty ? null : l.first;
  }

  Future<void> _fusionarBorrado(ResultadoFusionSync r, Manga m, Equipo e,
      int borradoMs, String? borradoPor) async {
    final local = await (db.select(db.verificaciones)
          ..where((t) => t.mangaId.equals(m.id) & t.equipoId.equals(e.id)))
        .get();
    if (local.isNotEmpty) {
      final v = local.first;
      if (!ganaRemoto(borradoMs, borradoPor, v.modificadoMs ?? 0, v.modificadoPor)) {
        return; // aquí se modificó después del borrado
      }
      for (final v in local) {
        // Devuelve los créditos y deja apuntado el borrado para reenviarlo.
        await _repo.borrar(v.id, borradoMs: borradoMs, borradoPor: borradoPor);
      }
      r.verifBorradas++;
      return;
    }
    final previo = await _borradoLocal(m.id, e.id);
    if (previo != null && previo.borradoMs >= borradoMs) return;
    await (db.delete(db.borradosSync)
          ..where((t) => t.mangaId.equals(m.id) & t.equipoId.equals(e.id)))
        .go();
    await db.into(db.borradosSync).insert(BorradosSyncCompanion.insert(
        mangaId: m.id,
        equipoId: e.id,
        borradoMs: borradoMs,
        borradoPor: Value(borradoPor)));
  }

  Future<void> _fusionarInscripcion(ResultadoFusionSync r, int pruebaId,
      Equipo e, Map<String, dynamic> j) async {
    final ins = await (db.select(db.inscripcionesPrueba)
          ..where((t) => t.pruebaId.equals(pruebaId) & t.equipoId.equals(e.id))
          ..limit(1))
        .getSingleOrNull();
    if (ins == null) {
      r.avisos.add('${e.nombre} no está inscrito en esta prueba en este '
          'Control; no se copian su copa ni su cobro.');
      return;
    }
    final copaMs = (j['copaModificadaMs'] as num?)?.toInt();
    if (copaMs != null && copaMs > (ins.copaModificadaMs ?? 0)) {
      await (db.update(db.inscripcionesPrueba)
            ..where((t) => t.id.equals(ins.id)))
          .write(InscripcionesPruebaCompanion(
              copa: Value(j['copa'] as String?),
              copaModificadaMs: Value(copaMs)));
      r.copas++;
    }
    final tesMs = (j['tesoreriaModificadaMs'] as num?)?.toInt();
    if (tesMs != null && tesMs > (ins.tesoreriaModificadaMs ?? 0)) {
      await (db.update(db.inscripcionesPrueba)
            ..where((t) => t.id.equals(ins.id)))
          .write(InscripcionesPruebaCompanion(
              wildcard: Value(j['wildcard'] as bool? ?? false),
              exentoCoordinadora:
                  Value(j['exentoCoordinadora'] as bool? ?? false),
              tesoreriaModificadaMs: Value(tesMs)));
      final pago = j['pago'] as Map<String, dynamic>?;
      await (db.delete(db.pagos)
            ..where(
                (t) => t.pruebaId.equals(pruebaId) & t.equipoId.equals(e.id)))
          .go();
      if (pago != null) {
        await db.into(db.pagos).insert(PagosCompanion.insert(
              pruebaId: pruebaId,
              equipoId: e.id,
              pagat: Value((pago['pagat'] as num).toDouble()),
              coordinadora: Value((pago['coordinadora'] as num).toDouble()),
              club: Value((pago['club'] as num).toDouble()),
              observaciones: Value(pago['observaciones'] as String?),
              fecha: Value(DateTime.fromMillisecondsSinceEpoch(
                  (pago['fechaMs'] as num).toInt())),
            ));
      }
      r.tesoreria++;
    }
  }
}
