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
// Genera el JSON `pitwall.tanda/v1` de una Prueba para importarlo en PitWall
// Manager (que autocrea la carrera). Cada Manga → una tanda; cada inscrito
// aporta su equipo + carril de salida. Reutiliza el mismo bucle de carga que
// GeneradorPdfMangas (Prueba→Mangas→Inscripciones→Equipo→Pilotos).

import 'package:drift/drift.dart' as d;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/proveedores.dart';
import '../data/database/app_database.dart';

class GeneradorTandaJson {
  GeneradorTandaJson(this.ref);
  final Ref ref;

  static const schema = 'pitwall.tanda/v1';

  // carrilSalida es texto ("D3" o "5"): extrae el nº de carril. null si no hay.
  int? _carrilNum(String? c) {
    if (c == null) return null;
    final m = RegExp(r'\d+').firstMatch(c);
    return m == null ? null : int.tryParse(m.group(0)!);
  }

  /// Construye el mapa JSON `pitwall.tanda/v1` de la prueba.
  Future<Map<String, dynamic>> generar({required int pruebaId}) async {
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

    var maxCarril = 0;
    final tandas = <Map<String, dynamic>>[];

    for (var mi = 0; mi < mangas.length; mi++) {
      final m = mangas[mi];
      if (m.numCarriles > maxCarril) maxCarril = m.numCarriles;

      final inscritos = await (db.select(db.inscripciones)
            ..where((t) => t.mangaId.equals(m.id)))
          .get();

      final equipos = <Map<String, dynamic>>[];
      for (final ins in inscritos) {
        final carril = _carrilNum(ins.carrilSalida);
        if (carril == null) continue; // sin carril asignado → no se puede colocar
        if (carril > maxCarril) maxCarril = carril;

        final eq = await (db.select(db.equipos)
              ..where((t) => t.id.equals(ins.equipoId)))
            .getSingle();
        final pilotos = await _pilotos(db, eq);

        equipos.add({
          'nombre': eq.nombre,
          'copa': eq.copa,
          'carril_salida': carril,
          'pilotos': pilotos,
        });
      }
      // Orden por carril (legibilidad; Manager lo recoloca igualmente).
      equipos.sort((a, b) =>
          (a['carril_salida'] as int).compareTo(b['carril_salida'] as int));

      if (equipos.isNotEmpty) {
        tandas.add({'numero': mi + 1, 'equipos': equipos});
      }
    }

    return {
      'schema': schema,
      'prueba': {
        'nombre': prueba.nombre,
        'sede': prueba.sede,
        'formato': camp.formato, // 'INDIVIDUAL' | 'PAREJAS'
      },
      'carriles': maxCarril > 0 ? maxCarril : 8,
      'tandas': tandas,
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
}

final generadorTandaJsonProvider =
    Provider<GeneradorTandaJson>((ref) => GeneradorTandaJson(ref));
