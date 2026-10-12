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
//  - Piloto (por uuid): datos del maestro.
//  - Equipo del campeonato (por uuid), con sus miembros.
//  - Perfil del piloto en el campeonato (categoría, créditos iniciales…).
//  - Inscripción a la prueba (alta y preferencia/notas), o su baja.
//  - Tanda (por uuid) con su parrilla de carriles, o su borrado.
//  - Verificación de (manga, equipo), o su borrado.
//  - Copa de un equipo en la prueba.
//  - Tesorería de un equipo en la prueba (pago + wildcard + "Coord. total").
//  - Borrados de equipos, perfiles e inscripciones (`borrados_registro`).
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
  int pilotos = 0;
  int equipos = 0;
  int perfiles = 0;
  int inscritos = 0;
  int tandas = 0;
  int bajas = 0;
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
      pilotos +
      equipos +
      perfiles +
      inscritos +
      tandas +
      bajas +
      verifNuevas +
      verifActualizadas +
      verifBorradas +
      copas +
      tesoreria;

  String resumen() {
    if (cambios == 0) return 'Sin cambios';
    final p = <String>[
      if (pilotos > 0) '$pilotos pilotos',
      if (equipos > 0) '$equipos equipos',
      if (perfiles > 0) '$perfiles perfiles',
      if (inscritos > 0) '$inscritos inscritos',
      if (tandas > 0) '$tandas tandas',
      if (bajas > 0) '$bajas bajas',
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

/// Busca la fila local que corresponde a [ref]: la del mismo uuid si la
/// referencia lo trae; si no, la del mismo id si se llama igual (misma copia
/// de BD) o, si no, la única con ese nombre.
T? casar<T>(RefSync? ref, List<T> filas, int Function(T) id,
    String Function(T) nombre,
    {String? Function(T)? uuid}) {
  if (ref == null) return null;
  if (ref.uuid != null && uuid != null) {
    for (final f in filas) {
      if (uuid(f) == ref.uuid) return f;
    }
    return null;
  }
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
      final camp = await (db.select(db.campeonatos)
            ..where((t) => t.id.equals(prueba.campeonatoId)))
          .getSingle();
      // Las claves de borrados llevan los uuid de la prueba y el campeonato
      // del otro Control: son esta prueba y este campeonato.
      final pruebaRemota = RefSync.fromJson(paquete['prueba'])?.uuid;
      final campRemoto = RefSync.fromJson(paquete['campeonato'])?.uuid;
      String claveLocal(String clave) {
        final k = clave.split('|');
        if (k.length != 2) return clave;
        if (k[0] == pruebaRemota) k[0] = prueba.uuid ?? k[0];
        if (k[1] == campRemoto) k[1] = camp.uuid ?? k[1];
        return k.join('|');
      }

      // 0) Altas: pilotos, equipos y perfiles del campeonato.
      await _fusionarPilotos(r, paquete['pilotos'] as List? ?? const []);
      final pilotoPorUuid = {
        for (final p in await db.select(db.pilotos).get())
          if (p.uuid != null) p.uuid!: p,
      };
      await _fusionarEquipos(
          r, camp.id, paquete['equipos'] as List? ?? const [], pilotoPorUuid);
      await _fusionarPerfiles(
          r, camp, paquete['perfiles'] as List? ?? const [], pilotoPorUuid);
      // Tandas y parrillas (necesitan los equipos ya fusionados).
      await _fusionarMangas(r, prueba, paquete['mangas'] as List? ?? const []);

      final mangas = await (db.select(db.mangas)
            ..where((t) => t.pruebaId.equals(pruebaId)))
          .get();
      final equipos = await (db.select(db.equipos)
            ..where((t) => t.campeonatoId.equals(prueba.campeonatoId)))
          .get();
      final coches = await db.select(db.catalogoCoches).get();

      Manga? manga(Object? j) => casar(
          RefSync.fromJson(j), mangas, (m) => m.id, (m) => m.nombre,
          uuid: (m) => m.uuid);
      Equipo? equipo(Object? j) => casar(
          RefSync.fromJson(j), equipos, (e) => e.id, (e) => e.nombre,
          uuid: (e) => e.uuid);

      // 1) Verificaciones.
      for (final raw in (paquete['verificaciones'] as List? ?? const [])) {
        final j = raw as Map<String, dynamic>;
        final m = manga(j['manga']);
        final e = equipo(j['equipo']);
        if (m == null || e == null) {
          r.avisos.add('Verificación de «${RefSync.fromJson(j['equipo'])?.nombre}» '
              'en «${RefSync.fromJson(j['manga'])?.nombre}»: '
              'no existe aquí esa tanda o ese equipo.');
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
        await _fusionarInscripcion(r, prueba, e, j);
      }

      // 4) Bajas y borrados de equipos, perfiles e inscripciones.
      for (final raw in (paquete['borradosRegistro'] as List? ?? const [])) {
        final j = raw as Map<String, dynamic>;
        await _fusionarRegistro(
            r,
            prueba,
            camp,
            j['tabla'] as String,
            claveLocal(j['clave'] as String),
            (j['borradoMs'] as num).toInt(),
            j['borradoPor'] as String?);
      }

      // «Asignada» (tiene tanda) se deduce de las parrillas de este Control.
      if (r.tandas > 0 || r.bajas > 0) await _recalcularAsignadas(pruebaId);
    });
    return r;
  }

  // ----------------------------------------------------------------- tandas

  Future<void> _fusionarMangas(
      ResultadoFusionSync r, Prueba prueba, List lista) async {
    final equipoPorUuid = {
      for (final e in await (db.select(db.equipos)
            ..where((t) => t.campeonatoId.equals(prueba.campeonatoId)))
          .get())
        if (e.uuid != null) e.uuid!: e,
    };
    // uuid de la tanda de pisters de cada tanda cambiada, para enlazarlas al
    // final (la de pisters puede llegar después en la lista).
    final pistersPendientes = <int, (String?, int, String?)>{};
    for (final raw in lista) {
      final j = raw as Map<String, dynamic>;
      final uuid = j['uuid'] as String;
      final tsR = (j['modMs'] as num?)?.toInt() ?? 0;
      final porR = j['modPor'] as String?;
      final fechaMs = (j['fechaHoraMs'] as num?)?.toInt();
      final datos = MangasCompanion(
        nombre: Value(j['nombre'] as String),
        fechaHora: Value(fechaMs == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(fechaMs)),
        numCarriles: Value((j['numCarriles'] as num?)?.toInt() ?? 8),
        estado: Value(j['estado'] as String? ?? 'PROGRAMADA'),
        modMs: Value(tsR),
        modPor: Value(porR),
      );
      final local = await (db.select(db.mangas)
            ..where((t) => t.uuid.equals(uuid)))
          .getSingleOrNull();
      final int id;
      if (local == null) {
        if (await _borradoDespues('mangas', uuid, tsR, porR)) continue;
        id = await db.into(db.mangas).insert(datos.copyWith(
            pruebaId: Value(prueba.id), uuid: Value(uuid)));
      } else if (local.pruebaId == prueba.id &&
          ganaRemoto(tsR, porR, local.modMs ?? 0, local.modPor)) {
        id = local.id;
        await (db.update(db.mangas)..where((t) => t.id.equals(id)))
            .write(datos);
      } else {
        continue;
      }
      // Parrilla: se reescribe entera.
      await (db.delete(db.inscripciones)..where((t) => t.mangaId.equals(id)))
          .go();
      for (final c in (j['parrilla'] as List? ?? const [])) {
        final cj = c as Map<String, dynamic>;
        final e = equipoPorUuid[cj['equipo']];
        if (e == null) {
          r.avisos.add('Tanda «${j['nombre']}»: falta aquí un equipo; '
              'su carril queda vacío.');
          continue;
        }
        await db.into(db.inscripciones).insert(InscripcionesCompanion.insert(
              mangaId: id,
              equipoId: e.id,
              carrilSalida: Value(cj['carril'] as String?),
              seedDirecto: Value(cj['seedDirecto'] as bool? ?? false),
            ));
      }
      pistersPendientes[id] = (j['pisters'] as String?, tsR, porR);
      // Los triggers de la parrilla habrán firmado la tanda con la hora de
      // ahora: se vuelve a poner la remota.
      await (db.update(db.mangas)..where((t) => t.id.equals(id)))
          .write(MangasCompanion(modMs: Value(tsR), modPor: Value(porR)));
      r.tandas++;
    }
    for (final MapEntry(key: id, value: (pistersUuid, tsR, porR))
        in pistersPendientes.entries) {
      int? pistersId;
      if (pistersUuid != null) {
        pistersId = (await (db.select(db.mangas)
                  ..where((t) => t.uuid.equals(pistersUuid)))
                .getSingleOrNull())
            ?.id;
      }
      // Marca provisional y luego la remota junto con el dato: si la marca
      // ya fuera la remota, el trigger tomaría esto por un cambio local.
      await (db.update(db.mangas)..where((t) => t.id.equals(id)))
          .write(const MangasCompanion(modMs: Value(-1)));
      await (db.update(db.mangas)..where((t) => t.id.equals(id))).write(
          MangasCompanion(
              pistersMangaId: Value(pistersId),
              modMs: Value(tsR),
              modPor: Value(porR)));
    }
  }

  Future<void> _recalcularAsignadas(int pruebaId) async {
    final mangas = await (db.select(db.mangas)
          ..where((t) => t.pruebaId.equals(pruebaId)))
        .get();
    final enTanda = mangas.isEmpty
        ? <int>{}
        : {
            for (final c in await (db.select(db.inscripciones)
                  ..where((t) => t.mangaId.isIn(mangas.map((m) => m.id))))
                .get())
              c.equipoId,
          };
    for (final ins in await (db.select(db.inscripcionesPrueba)
          ..where((t) => t.pruebaId.equals(pruebaId)))
        .get()) {
      final asignada = enTanda.contains(ins.equipoId);
      if (ins.asignada != asignada) {
        await (db.update(db.inscripcionesPrueba)
              ..where((t) => t.id.equals(ins.id)))
            .write(InscripcionesPruebaCompanion(asignada: Value(asignada)));
      }
    }
  }

  // ---------------------------------------------------------------- altas

  /// ¿Hay aquí un borrado de esa fila posterior al cambio remoto?
  Future<bool> _borradoDespues(
      String tabla, String clave, int tsR, String? porR) async {
    final b = await (db.select(db.borradosRegistro)
          ..where((t) => t.tabla.equals(tabla) & t.clave.equals(clave)))
        .getSingleOrNull();
    return b != null && !ganaRemoto(tsR, porR, b.borradoMs, b.borradoPor);
  }

  Future<void> _fusionarPilotos(ResultadoFusionSync r, List lista) async {
    for (final raw in lista) {
      final j = raw as Map<String, dynamic>;
      final uuid = j['uuid'] as String;
      final tsR = (j['modMs'] as num?)?.toInt() ?? 0;
      final porR = j['modPor'] as String?;
      final datos = PilotosCompanion(
        nombre: Value(j['nombre'] as String),
        telefono: Value(j['telefono'] as String?),
        email: Value(j['email'] as String?),
        esCoordinadora: Value(j['esCoordinadora'] as bool? ?? false),
        palmaresGlobal: Value(j['palmaresGlobal'] as String?),
        modMs: Value(tsR),
        modPor: Value(porR),
      );
      final local = await (db.select(db.pilotos)
            ..where((t) => t.uuid.equals(uuid)))
          .getSingleOrNull();
      if (local == null) {
        await db.into(db.pilotos).insert(datos.copyWith(uuid: Value(uuid)));
        r.pilotos++;
      } else if (ganaRemoto(tsR, porR, local.modMs ?? 0, local.modPor)) {
        await (db.update(db.pilotos)..where((t) => t.id.equals(local.id)))
            .write(datos);
        r.pilotos++;
      }
    }
  }

  Future<void> _fusionarEquipos(ResultadoFusionSync r, int campeonatoId,
      List lista, Map<String, Piloto> pilotoPorUuid) async {
    for (final raw in lista) {
      final j = raw as Map<String, dynamic>;
      final uuid = j['uuid'] as String;
      final nombre = j['nombre'] as String;
      final tsR = (j['modMs'] as num?)?.toInt() ?? 0;
      final porR = j['modPor'] as String?;
      final ids = [
        for (final u in (j['miembros'] as List? ?? const []))
          pilotoPorUuid[u]?.id,
      ];
      if (ids.isEmpty || ids.contains(null)) {
        r.avisos.add('Equipo «$nombre»: faltan aquí algunos de sus pilotos; '
            'no se copia.');
        continue;
      }
      final miembros = ids.cast<int>();
      final local = await (db.select(db.equipos)
            ..where((t) => t.uuid.equals(uuid)))
          .getSingleOrNull();
      final int id;
      if (local == null) {
        if (await _borradoDespues('equipos', uuid, tsR, porR)) continue;
        id = await db.into(db.equipos).insert(EquiposCompanion.insert(
              campeonatoId: campeonatoId,
              nombre: nombre,
              copa: j['copa'] as String,
              piloto1Id: miembros.first,
              piloto2Id: Value(miembros.length > 1 ? miembros[1] : null),
              activo: Value(j['activo'] as bool? ?? true),
              uuid: Value(uuid),
              modMs: Value(tsR),
              modPor: Value(porR),
            ));
      } else if (ganaRemoto(tsR, porR, local.modMs ?? 0, local.modPor)) {
        id = local.id;
        await (db.update(db.equipos)..where((t) => t.id.equals(id)))
            .write(EquiposCompanion(
          nombre: Value(nombre),
          copa: Value(j['copa'] as String),
          piloto1Id: Value(miembros.first),
          piloto2Id: Value(miembros.length > 1 ? miembros[1] : null),
          activo: Value(j['activo'] as bool? ?? true),
          modMs: Value(tsR),
          modPor: Value(porR),
        ));
      } else {
        continue;
      }
      // Miembros: se reescriben y se vuelve a poner la marca remota (los
      // triggers de equipo_pilotos la habrán pisado con la de ahora).
      await (db.delete(db.equipoPilotos)
            ..where((t) => t.equipoId.equals(id)))
          .go();
      for (var i = 0; i < miembros.length; i++) {
        await db.into(db.equipoPilotos).insert(
            EquipoPilotosCompanion.insert(
                equipoId: id, pilotoId: miembros[i], orden: Value(i)),
            mode: InsertMode.insertOrReplace);
      }
      await (db.update(db.equipos)..where((t) => t.id.equals(id)))
          .write(EquiposCompanion(modMs: Value(tsR), modPor: Value(porR)));
      r.equipos++;
    }
  }

  Future<void> _fusionarPerfiles(ResultadoFusionSync r, Campeonato camp,
      List lista, Map<String, Piloto> pilotoPorUuid) async {
    for (final raw in lista) {
      final j = raw as Map<String, dynamic>;
      final pilotoUuid = j['piloto'] as String;
      final piloto = pilotoPorUuid[pilotoUuid];
      if (piloto == null) continue;
      final tsR = (j['modMs'] as num?)?.toInt() ?? 0;
      final porR = j['modPor'] as String?;
      final iniciales = (j['creditosIniciales'] as num).toInt();
      final local = await (db.select(db.pilotoCampeonato)
            ..where((t) =>
                t.pilotoId.equals(piloto.id) & t.campeonatoId.equals(camp.id)))
          .getSingleOrNull();
      final datos = PilotoCampeonatoCompanion(
        categoria: Value(j['categoria'] as String),
        categoriaFinal: Value(j['categoriaFinal'] as String?),
        creditosIniciales: Value(iniciales),
        saldoTemporadaAnterior:
            Value((j['saldoTemporadaAnterior'] as num?)?.toInt() ?? 0),
        palmaresLocal: Value(j['palmaresLocal'] as String?),
        modMs: Value(tsR),
        modPor: Value(porR),
      );
      if (local == null) {
        if (await _borradoDespues(
            'piloto_campeonato', '$pilotoUuid|${camp.uuid}', tsR, porR)) {
          continue;
        }
        // Los créditos actuales son contabilidad de cada Control: arrancan
        // en los iniciales y los ajustan las verificaciones validadas.
        await db.into(db.pilotoCampeonato).insert(datos.copyWith(
            pilotoId: Value(piloto.id),
            campeonatoId: Value(camp.id),
            creditosActuales: Value(iniciales)));
        r.perfiles++;
      } else if (ganaRemoto(tsR, porR, local.modMs ?? 0, local.modPor)) {
        await (db.update(db.pilotoCampeonato)
              ..where((t) =>
                  t.pilotoId.equals(piloto.id) &
                  t.campeonatoId.equals(camp.id)))
            .write(datos.copyWith(
                creditosActuales: Value(local.creditosActuales +
                    iniciales -
                    local.creditosIniciales)));
        r.perfiles++;
      }
    }
  }

  // -------------------------------------------------------------- borrados

  Future<void> _fusionarRegistro(ResultadoFusionSync r, Prueba prueba,
      Campeonato camp, String tabla, String clave, int ms, String? por) async {
    var borrado = false;
    switch (tabla) {
      case 'mangas':
        final m = await (db.select(db.mangas)
              ..where((t) => t.uuid.equals(clave)))
            .getSingleOrNull();
        if (m != null &&
            m.pruebaId == prueba.id &&
            ganaRemoto(ms, por, m.modMs ?? 0, m.modPor)) {
          // Como al borrar una tanda en la app: fuera su parrilla y las que
          // la tenían de pisters se quedan sin.
          await (db.delete(db.inscripciones)
                ..where((t) => t.mangaId.equals(m.id)))
              .go();
          await (db.update(db.mangas)
                ..where((t) => t.pistersMangaId.equals(m.id)))
              .write(const MangasCompanion(pistersMangaId: Value(null)));
          await (db.delete(db.mangas)..where((t) => t.id.equals(m.id))).go();
          borrado = true;
        }
      case 'equipos':
        final e = await (db.select(db.equipos)
              ..where((t) => t.uuid.equals(clave)))
            .getSingleOrNull();
        if (e != null && ganaRemoto(ms, por, e.modMs ?? 0, e.modPor)) {
          await (db.delete(db.equipoPilotos)
                ..where((t) => t.equipoId.equals(e.id)))
              .go();
          await (db.delete(db.equipos)..where((t) => t.id.equals(e.id))).go();
          borrado = true;
        }
      case 'piloto_campeonato':
        final k = clave.split('|');
        if (k.length != 2 || k[1] != camp.uuid) break;
        final p = await (db.select(db.pilotos)
              ..where((t) => t.uuid.equals(k[0])))
            .getSingleOrNull();
        if (p == null) break;
        final pc = await (db.select(db.pilotoCampeonato)
              ..where((t) =>
                  t.pilotoId.equals(p.id) & t.campeonatoId.equals(camp.id)))
            .getSingleOrNull();
        if (pc != null && ganaRemoto(ms, por, pc.modMs ?? 0, pc.modPor)) {
          await (db.delete(db.pilotoCampeonato)
                ..where((t) =>
                    t.pilotoId.equals(p.id) & t.campeonatoId.equals(camp.id)))
              .go();
          borrado = true;
        }
      case 'inscripciones_prueba':
        final k = clave.split('|');
        if (k.length != 2 || k[0] != prueba.uuid) break;
        final e = await (db.select(db.equipos)
              ..where((t) => t.uuid.equals(k[1])))
            .getSingleOrNull();
        if (e == null) break;
        final ins = await (db.select(db.inscripcionesPrueba)
              ..where((t) =>
                  t.pruebaId.equals(prueba.id) & t.equipoId.equals(e.id)))
            .getSingleOrNull();
        if (ins != null && ganaRemoto(ms, por, ins.modMs ?? 0, ins.modPor)) {
          // Como «Dar de baja»: también sale de su tanda.
          final mangas = await (db.select(db.mangas)
                ..where((t) => t.pruebaId.equals(prueba.id)))
              .get();
          await (db.delete(db.inscripciones)
                ..where((t) =>
                    t.equipoId.equals(e.id) &
                    t.mangaId.isIn(mangas.map((m) => m.id))))
              .go();
          await (db.delete(db.inscripcionesPrueba)
                ..where((t) => t.id.equals(ins.id)))
              .go();
          borrado = true;
        }
    }
    if (borrado) r.bajas++;
    // Se guarda con la marca remota (el trigger lo habrá apuntado con la de
    // ahora) para reenviarlo a los demás Controls.
    final previo = await (db.select(db.borradosRegistro)
          ..where((t) => t.tabla.equals(tabla) & t.clave.equals(clave)))
        .getSingleOrNull();
    if (borrado ||
        previo == null ||
        ganaRemoto(ms, por, previo.borradoMs, previo.borradoPor)) {
      await db.into(db.borradosRegistro).insertOnConflictUpdate(
          BorradosRegistroCompanion.insert(
              tabla: tabla,
              clave: clave,
              borradoMs: ms,
              borradoPor: Value(por)));
    }
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

  Future<void> _fusionarInscripcion(ResultadoFusionSync r, Prueba prueba,
      Equipo e, Map<String, dynamic> j) async {
    final pruebaId = prueba.id;
    var ins = await (db.select(db.inscripcionesPrueba)
          ..where((t) => t.pruebaId.equals(pruebaId) & t.equipoId.equals(e.id))
          ..limit(1))
        .getSingleOrNull();
    final tsR = (j['modMs'] as num?)?.toInt() ?? 0;
    final porR = j['modPor'] as String?;
    if (ins == null) {
      // Alta hecha en el otro Control (salvo que aquí se diera de baja
      // después).
      if (await _borradoDespues(
          'inscripciones_prueba', '${prueba.uuid}|${e.uuid}', tsR, porR)) {
        return;
      }
      final fechaMs = (j['fechaInscripcionMs'] as num?)?.toInt();
      await db.into(db.inscripcionesPrueba).insert(
          InscripcionesPruebaCompanion.insert(
            pruebaId: pruebaId,
            equipoId: e.id,
            fechaInscripcion: fechaMs == null
                ? const Value.absent()
                : Value(DateTime.fromMillisecondsSinceEpoch(fechaMs)),
            preferenciaDia: Value(j['preferenciaDia'] as String?),
            notas: Value(j['notas'] as String?),
            modMs: Value(tsR),
            modPor: Value(porR),
          ));
      ins = await (db.select(db.inscripcionesPrueba)
            ..where(
                (t) => t.pruebaId.equals(pruebaId) & t.equipoId.equals(e.id)))
          .getSingle();
      r.inscritos++;
    } else if (ganaRemoto(tsR, porR, ins.modMs ?? 0, ins.modPor)) {
      final idIns = ins.id;
      await (db.update(db.inscripcionesPrueba)
            ..where((t) => t.id.equals(idIns)))
          .write(InscripcionesPruebaCompanion(
        preferenciaDia: Value(j['preferenciaDia'] as String?),
        notas: Value(j['notas'] as String?),
        modMs: Value(tsR),
        modPor: Value(porR),
      ));
    }
    final idIns = ins.id;
    final copaMs = (j['copaModificadaMs'] as num?)?.toInt();
    if (copaMs != null && copaMs > (ins.copaModificadaMs ?? 0)) {
      await (db.update(db.inscripcionesPrueba)
            ..where((t) => t.id.equals(idIns)))
          .write(InscripcionesPruebaCompanion(
              copa: Value(j['copa'] as String?),
              copaModificadaMs: Value(copaMs)));
      r.copas++;
    }
    final tesMs = (j['tesoreriaModificadaMs'] as num?)?.toInt();
    if (tesMs != null && tesMs > (ins.tesoreriaModificadaMs ?? 0)) {
      await (db.update(db.inscripcionesPrueba)
            ..where((t) => t.id.equals(idIns)))
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
