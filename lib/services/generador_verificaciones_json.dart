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
// Genera el JSON `pitwall.verificaciones/v1` de una Prueba para enviarlo a
// PitWall Manager (a modo de solo consulta: Manager no debe permitir editarlas).
// `manga` numera igual que `numero` en `pitwall.tanda/v1` (posición 1-based de
// la Manga dentro de la Prueba, ordenada por id), para que Manager pueda casar
// una verificación con la tanda correspondiente si la tiene.

import 'dart:convert';

import 'package:drift/drift.dart' as d;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/proveedores.dart';
import '../data/database/app_database.dart';
import 'fotos_verificacion.dart';

class GeneradorVerificacionesJson {
  GeneradorVerificacionesJson(this.ref);
  final Ref ref;

  static const schema = 'pitwall.verificaciones/v1';

  /// Construye el mapa JSON `pitwall.verificaciones/v1` de la prueba.
  ///
  /// Incluye la copa/pilotos del equipo (Manager no comparte catálogos con
  /// Control) y, si [incluirFotos], las fotos de cada verificación en base64.
  ///
  /// [raceId] liga el envío a una carrera concreta de Manager (la que el
  /// usuario eligió en el diálogo). Si no se indica, cae en el
  /// `managerRaceId` guardado de un envío anterior de esta prueba, si lo hay.
  Future<Map<String, dynamic>> generar(
      {required int pruebaId, int? raceId, bool incluirFotos = true}) async {
    final db = ref.read(dbProvider);
    final prueba = await (db.select(db.pruebas)
          ..where((t) => t.id.equals(pruebaId)))
        .getSingle();
    final camp = await (db.select(db.campeonatos)
          ..where((t) => t.id.equals(prueba.campeonatoId)))
        .getSingle();

    final mangas = await (db.select(db.mangas)
          ..where((t) => t.pruebaId.equals(pruebaId))
          ..orderBy([(t) => d.OrderingTerm.asc(t.id)]))
        .get();

    final verificaciones = <Map<String, dynamic>>[];
    for (var mi = 0; mi < mangas.length; mi++) {
      final manga = mangas[mi];
      final filas = await (db.select(db.verificaciones)
            ..where((t) => t.mangaId.equals(manga.id)))
          .get();
      for (final v in filas) {
        final eq = await (db.select(db.equipos)
              ..where((t) => t.id.equals(v.equipoId)))
            .getSingleOrNull();
        if (eq == null) continue;
        final pilotos = await _pilotos(db, eq);
        CatalogoCoche? coche;
        if (v.cocheCatalogoId != null) {
          coche = await (db.select(db.catalogoCoches)
                ..where((t) => t.id.equals(v.cocheCatalogoId!)))
              .getSingleOrNull();
        }
        final fotos =
            incluirFotos ? await _fotosBase64(v.fotosJson) : const [];

        verificaciones.add({
          'manga': mi + 1,
          'equipo': {
            'nombre': eq.nombre,
            'copa': eq.copa,
            'pilotos': pilotos,
          },
          if (coche != null) 'coche': coche.nombre,
          'validado': v.validado,
          'peso_inicial': v.pesoInicial,
          'peso_final': v.pesoFinal,
          'peso_min': v.pesoMin,
          'peso_inicial_coche': v.pesoInicialCoche,
          'peso_final_coche': v.pesoFinalCoche,
          'motor': v.motor,
          'motor_tipo': v.motorTipo,
          'motor_rpm': v.motorRpm,
          'motor_ums': v.motorUms,
          'pinon': {
            'marca': v.pinonMarca,
            'dientes': v.pinonDientes,
            'diametro': v.pinonDiametro,
            'material': v.pinonMaterial,
          },
          'corona': {
            'marca': v.coronaMarca,
            'dientes': v.coronaDientes,
            'diametro': v.coronaDiametro,
            'material': v.coronaMaterial,
          },
          'llanta_delantera': {
            'marca': v.llantaDelMarca,
            'dimension': v.llantaDelDimension,
          },
          'llanta_trasera': {
            'marca': v.llantaTraMarca,
            'dimension': v.llantaTraDimension,
          },
          'trencilla': v.trencilla,
          'suspension': v.suspension,
          'bancada': v.bancada,
          'chasis': v.chasis,
          'neumatico': v.neumatico,
          'observaciones': v.observaciones,
          if (fotos.isNotEmpty) 'fotos': fotos,
        });
      }
    }

    return {
      'schema': schema,
      'prueba': {
        'nombre': prueba.nombre,
        'sede': prueba.sede,
        'fecha': prueba.fecha?.toIso8601String(),
        'formato': camp.formato, // 'INDIVIDUAL' | 'PAREJAS'
      },
      if ((raceId ?? prueba.managerRaceId) != null)
        'race_id': raceId ?? prueba.managerRaceId,
      'verificaciones': verificaciones,
    };
  }

  // Nombres de los pilotos del equipo: tabla de unión (resistencia >2) ordenada
  // por `orden`; si está vacía, cae a piloto1/piloto2.
  Future<List<String>> _pilotos(AppDatabase db, Equipo eq) async {
    final rows = await (db.select(db.equipoPilotos)
          ..where((t) => t.equipoId.equals(eq.id))
          ..orderBy([(t) => d.OrderingTerm.asc(t.orden)]))
        .get();
    final ids = rows.map((r) => r.pilotoId).toList();
    if (ids.isEmpty) {
      ids.add(eq.piloto1Id);
      if (eq.piloto2Id != null) ids.add(eq.piloto2Id!);
    }
    final nombres = <String>[];
    for (final id in ids) {
      final p = await (db.select(db.pilotos)..where((t) => t.id.equals(id)))
          .getSingleOrNull();
      if (p != null) nombres.add(p.nombre);
    }
    return nombres;
  }

  // Fotos de la verificación codificadas en base64 (solo las que existan en
  // este dispositivo; una foto borrada u otro dispositivo no la revienta).
  Future<List<Map<String, String>>> _fotosBase64(String fotosJson) async {
    List<String> nombres;
    try {
      final raw = jsonDecode(fotosJson);
      nombres = raw is List ? raw.map((e) => e.toString()).toList() : [];
    } catch (_) {
      nombres = [];
    }
    final out = <Map<String, String>>[];
    for (final n in nombres) {
      final f = await FotosVerificacion.resolver(n);
      if (!await f.exists()) continue;
      final bytes = await f.readAsBytes();
      out.add({
        'nombre': FotosVerificacion.nombreParaBd(n),
        'datos_base64': base64Encode(bytes),
      });
    }
    return out;
  }
}

final generadorVerificacionesJsonProvider =
    Provider<GeneradorVerificacionesJson>(
        (ref) => GeneradorVerificacionesJson(ref));
