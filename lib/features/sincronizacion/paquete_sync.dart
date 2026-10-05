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
// de verificaciones, copa por prueba y tesorería de cada inscrito. Como es el
// estado completo (incluido lo que ese Control recibió de otros), los cambios
// se propagan en cadena aunque no todos se hayan sincronizado entre sí.
//
// Mangas, equipos y coches viajan con su id Y su nombre: todos los Controls
// deberían partir de la misma copia de la BD, pero si los ids no cuadran se
// casan por nombre (ver fusionador_sync.dart).

import 'dart:convert';

import '../../data/database/app_database.dart';
import 'dispositivo_sync.dart';

const schemaPaqueteSync = 'pitwall.sync/v1';

/// Referencia portable a una fila: id en el Control de origen + nombre.
class RefSync {
  const RefSync(this.id, this.nombre);
  final int id;
  final String nombre;

  Map<String, dynamic> toJson() => {'id': id, 'nombre': nombre};
  static RefSync? fromJson(Object? j) {
    if (j is! Map) return null;
    return RefSync((j['id'] as num).toInt(), j['nombre'] as String);
  }
}

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
      'manga': RefSync(m.id, m.nombre).toJson(),
      'equipo': RefSync(e.id, e.nombre).toJson(),
      'coche': coche == null ? null : RefSync(coche.id, coche.nombre).toJson(),
      'datos': v.toJson(),
    });
  }

  return {
    'schema': schemaPaqueteSync,
    'schemaVersion': db.schemaVersion,
    'dispositivo': DispositivoSync.nombre,
    'ahoraMs': ahoraMsSync(),
    'campeonato': RefSync(camp.id, camp.nombre).toJson(),
    'prueba': RefSync(prueba.id, prueba.nombre).toJson(),
    'verificaciones': listaVerifs,
    'borrados': [
      for (final b in borrados)
        if (mangaPorId[b.mangaId] != null && equipoPorId[b.equipoId] != null)
          {
            'manga': RefSync(b.mangaId, mangaPorId[b.mangaId]!.nombre).toJson(),
            'equipo':
                RefSync(b.equipoId, equipoPorId[b.equipoId]!.nombre).toJson(),
            'borradoMs': b.borradoMs,
            'borradoPor': b.borradoPor,
          },
    ],
    'inscripciones': [
      for (final i in inscripciones)
        if (equipoPorId[i.equipoId] != null)
          {
            'equipo': RefSync(i.equipoId, equipoPorId[i.equipoId]!.nombre)
                .toJson(),
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
