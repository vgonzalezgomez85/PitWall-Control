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

// Paquete de sincronización entre Controls (schema `pitwall.sync/v1`).
//
// Un Control sirve el estado COMPLETO de una prueba: verificaciones, borrados
// de verificaciones, copa por prueba y tesorería de cada inscrito y, desde la
// v2, las altas: pilotos y equipos del campeonato (con sus miembros), el
// perfil de cada piloto en el campeonato, las inscripciones a la prueba y los
// borrados de todo ello. Como es el estado completo (incluido lo que ese
// Control recibió de otros), los cambios se propagan en cadena aunque no
// todos se hayan sincronizado entre sí.
//
// Pilotos y equipos se identifican por su uuid (igual en todos los Controls,
// ver sync_triggers.dart), igual que las tandas (con su parrilla de carriles
// desde la v3). Los coches viajan con su id Y su nombre: si los ids no
// cuadran se casan por nombre (ver fusionador_sync.dart).

import 'dart:convert';

import 'package:drift/drift.dart';

import '../../data/database/app_database.dart';
import 'dispositivo_sync.dart';

const schemaPaqueteSync = 'pitwall.sync/v4';

/// Referencia portable a una fila: id en el Control de origen + nombre y,
/// si la tabla lo tiene, su uuid (que manda al casar).
class RefSync {
  const RefSync(this.id, this.nombre, [this.uuid]);
  final int id;
  final String nombre;
  final String? uuid;

  Map<String, dynamic> toJson() =>
      {'id': id, 'nombre': nombre, 'uuid': ?uuid};
  static RefSync? fromJson(Object? j) {
    if (j is! Map) return null;
    return RefSync((j['id'] as num).toInt(), j['nombre'] as String,
        j['uuid'] as String?);
  }
}

/// Tablas cuyos borrados viajan (ver `borrados_registro`).
const tablasBorradosSync = [
  'mangas',
  'equipos',
  'piloto_campeonato',
  'inscripciones_prueba',
];

/// Genera el paquete de la prueba [pruebaId] de este Control.
Future<Map<String, dynamic>> generarPaqueteSync(
    AppDatabase db, int pruebaId) async {
  final prueba = await (db.select(db.pruebas)
        ..where((t) => t.id.equals(pruebaId)))
      .getSingle();
  final camp = await (db.select(db.campeonatos)
        ..where((t) => t.id.equals(prueba.campeonatoId)))
      .getSingle();
  final mangas = await (db.select(db.mangas)
        ..where((t) => t.pruebaId.equals(pruebaId)))
      .get();
  final mangaPorId = {for (final m in mangas) m.id: m};
  final equipos = await (db.select(db.equipos)
        ..where((t) => t.campeonatoId.equals(camp.id)))
      .get();
  final equipoPorId = {for (final e in equipos) e.id: e};
  RefSync refEquipo(Equipo e) => RefSync(e.id, e.nombre, e.uuid);
  RefSync refManga(Manga m) => RefSync(m.id, m.nombre, m.uuid);

  // Miembros de cada equipo (tabla de unión; si está vacía, piloto1/2).
  final miembros = await (db.select(db.equipoPilotos)
        ..where((t) => t.equipoId.isIn(equipoPorId.keys))
        ..orderBy([(t) => OrderingTerm.asc(t.orden)]))
      .get();
  final miembrosDe = <int, List<int>>{};
  for (final m in miembros) {
    miembrosDe.putIfAbsent(m.equipoId, () => []).add(m.pilotoId);
  }
  List<int> pilotosDe(Equipo e) =>
      miembrosDe[e.id] ?? [e.piloto1Id, ?e.piloto2Id];
  final perfiles = await (db.select(db.pilotoCampeonato)
        ..where((t) => t.campeonatoId.equals(camp.id)))
      .get();
  final idsPilotos = {
    for (final e in equipos) ...pilotosDe(e),
    for (final p in perfiles) p.pilotoId,
  };
  final pilotos = await (db.select(db.pilotos)
        ..where((t) => t.id.isIn(idsPilotos)))
      .get();
  final pilotoPorId = {for (final p in pilotos) p.id: p};
  // Resultados de cada tanda y correcciones manuales por copa de la prueba.
  final resultados = mangaPorId.isEmpty
      ? <Resultado>[]
      : await (db.select(db.resultados)
            ..where((t) => t.mangaId.isIn(mangaPorId.keys))
            ..orderBy([(t) => OrderingTerm.asc(t.id)]))
          .get();
  final overrides = await (db.select(db.overridesCopa)
        ..where((t) =>
            t.pruebaId.equals(pruebaId) & t.campeonatoId.equals(camp.id)))
      .get();
  final todosPilotos = {
    for (final p in await db.select(db.pilotos).get()) p.id: p,
  };

  // Parrilla de cada tanda: quién va en qué carril.
  final carriles = mangaPorId.isEmpty
      ? <Inscripcione>[]
      : await (db.select(db.inscripciones)
            ..where((t) => t.mangaId.isIn(mangaPorId.keys))
            ..orderBy([(t) => OrderingTerm.asc(t.id)]))
          .get();
  final registro = await (db.select(db.borradosRegistro)
        ..where((t) => t.tabla.isIn(tablasBorradosSync)))
      .get();
  final coches = await db.select(db.catalogoCoches).get();
  final cochePorId = {for (final c in coches) c.id: c};

  final mangaIds = mangaPorId.keys.toList();
  final verifs = mangaIds.isEmpty
      ? <Verificacione>[]
      : await (db.select(db.verificaciones)
            ..where((t) => t.mangaId.isIn(mangaIds)))
          .get();
  final borrados = mangaIds.isEmpty
      ? <BorradosSyncData>[]
      : await (db.select(db.borradosSync)
            ..where((t) => t.mangaId.isIn(mangaIds)))
          .get();
  final inscripciones = await (db.select(db.inscripcionesPrueba)
        ..where((t) => t.pruebaId.equals(pruebaId)))
      .get();
  final pagos = await (db.select(db.pagos)
        ..where((t) => t.pruebaId.equals(pruebaId)))
      .get();
  final pagoPorEquipo = {for (final p in pagos) p.equipoId: p};

  final fotos = <String>{};
  final listaVerifs = <Map<String, dynamic>>[];
  for (final v in verifs) {
    final m = mangaPorId[v.mangaId];
    final e = equipoPorId[v.equipoId];
    if (m == null || e == null) continue;
    final coche = v.cocheCatalogoId == null ? null : cochePorId[v.cocheCatalogoId];
    fotos.addAll(nombresFotos(v.fotosJson));
    listaVerifs.add({
      'manga': refManga(m).toJson(),
      'equipo': refEquipo(e).toJson(),
      'coche': coche == null ? null : RefSync(coche.id, coche.nombre).toJson(),
      'datos': v.toJson(),
    });
  }

  return {
    'schema': schemaPaqueteSync,
    'schemaVersion': db.schemaVersion,
    'dispositivo': DispositivoSync.nombre,
    'ahoraMs': ahoraMsSync(),
    'campeonato': RefSync(camp.id, camp.nombre, camp.uuid).toJson(),
    'prueba': RefSync(prueba.id, prueba.nombre, prueba.uuid).toJson(),
    'pilotos': [
      for (final p in pilotos)
        if (p.uuid != null)
          {
            'uuid': p.uuid,
            'nombre': p.nombre,
            'telefono': p.telefono,
            'email': p.email,
            'esCoordinadora': p.esCoordinadora,
            'palmaresGlobal': p.palmaresGlobal,
            'modMs': p.modMs ?? 0,
            'modPor': p.modPor,
          },
    ],
    'equipos': [
      for (final e in equipos)
        if (e.uuid != null)
          {
            'uuid': e.uuid,
            'nombre': e.nombre,
            'copa': e.copa,
            'activo': e.activo,
            'miembros': [
              for (final id in pilotosDe(e))
                if (pilotoPorId[id]?.uuid != null) pilotoPorId[id]!.uuid,
            ],
            'modMs': e.modMs ?? 0,
            'modPor': e.modPor,
          },
    ],
    'perfiles': [
      for (final pc in perfiles)
        if (pilotoPorId[pc.pilotoId]?.uuid != null)
          {
            'piloto': pilotoPorId[pc.pilotoId]!.uuid,
            'categoria': pc.categoria,
            'categoriaFinal': pc.categoriaFinal,
            'creditosIniciales': pc.creditosIniciales,
            'saldoTemporadaAnterior': pc.saldoTemporadaAnterior,
            'palmaresLocal': pc.palmaresLocal,
            'modMs': pc.modMs ?? 0,
            'modPor': pc.modPor,
          },
    ],
    'mangas': [
      for (final m in mangas)
        if (m.uuid != null)
          {
            'uuid': m.uuid,
            'nombre': m.nombre,
            'fechaHoraMs': m.fechaHora?.millisecondsSinceEpoch,
            'numCarriles': m.numCarriles,
            'estado': m.estado,
            'pisters': mangaPorId[m.pistersMangaId]?.uuid,
            'parrilla': [
              for (final c in carriles)
                if (c.mangaId == m.id && equipoPorId[c.equipoId]?.uuid != null)
                  {
                    'equipo': equipoPorId[c.equipoId]!.uuid,
                    'carril': c.carrilSalida,
                    'seedDirecto': c.seedDirecto,
                  },
            ],
            'modMs': m.modMs ?? 0,
            'modPor': m.modPor,
            'resultados': [
              for (final x in resultados)
                if (x.mangaId == m.id &&
                    todosPilotos[x.pilotoId]?.uuid != null &&
                    equipoPorId[x.equipoId]?.uuid != null)
                  {
                    'piloto': todosPilotos[x.pilotoId]!.uuid,
                    'equipo': equipoPorId[x.equipoId]!.uuid,
                    'puntos': x.puntos,
                    'posicion': x.posicion,
                    'aRestar': x.aRestar,
                  },
            ],
            'resModMs': m.resModMs ?? 0,
            'resModPor': m.resModPor,
          },
    ],
    'overrides': [
      for (final o in overrides)
        if (todosPilotos[o.pilotoId]?.uuid != null)
          {
            'copa': o.copa,
            'piloto': todosPilotos[o.pilotoId]!.uuid,
            'puntos': o.puntos,
          },
    ],
    'ovrModMs': prueba.ovrModMs ?? 0,
    'ovrModPor': prueba.ovrModPor,
    'borradosRegistro': [
      for (final b in registro)
        {
          'tabla': b.tabla,
          'clave': b.clave,
          'borradoMs': b.borradoMs,
          'borradoPor': b.borradoPor,
        },
    ],
    'verificaciones': listaVerifs,
    'borrados': [
      for (final b in borrados)
        if (mangaPorId[b.mangaId] != null && equipoPorId[b.equipoId] != null)
          {
            'manga': refManga(mangaPorId[b.mangaId]!).toJson(),
            'equipo': refEquipo(equipoPorId[b.equipoId]!).toJson(),
            'borradoMs': b.borradoMs,
            'borradoPor': b.borradoPor,
          },
    ],
    'inscripciones': [
      for (final i in inscripciones)
        if (equipoPorId[i.equipoId] != null)
          {
            'equipo': refEquipo(equipoPorId[i.equipoId]!).toJson(),
            'preferenciaDia': i.preferenciaDia,
            'notas': i.notas,
            'fechaInscripcionMs': i.fechaInscripcion.millisecondsSinceEpoch,
            'modMs': i.modMs ?? 0,
            'modPor': i.modPor,
            'copa': i.copa,
            'copaModificadaMs': i.copaModificadaMs,
            'tesoreriaModificadaMs': i.tesoreriaModificadaMs,
            'wildcard': i.wildcard,
            'exentoCoordinadora': i.exentoCoordinadora,
            'pago': _pagoJson(pagoPorEquipo[i.equipoId]),
          },
    ],
    'fotos': fotos.toList(),
  };
}

Map<String, dynamic>? _pagoJson(Pago? p) => p == null
    ? null
    : {
        'pagat': p.pagat,
        'coordinadora': p.coordinadora,
        'club': p.club,
        'observaciones': p.observaciones,
        'fechaMs': p.fecha.millisecondsSinceEpoch,
      };

/// Nombres de archivo de las fotos de un `fotosJson` de verificación.
List<String> nombresFotos(String fotosJson) {
  try {
    final l = jsonDecode(fotosJson);
    if (l is! List) return const [];
    return [
      for (final e in l)
        if (e is String && e.isNotEmpty) e.split(RegExp(r'[\\/]')).last,
    ];
  } catch (_) {
    return const [];
  }
}
