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

  // carrilSalida es texto. "1".."N" = carril de CARRERA. "D1".."Dk" = DESCANSO:
  // cuando una manga tiene más equipos que carriles, esos equipos descansan esa
  // manga (D1 = descanso 1, D2 = descanso 2…). Los descansos NO ocupan carril;
  // se marcan con carril_salida 0 (+ nº de descanso) y Manager los rota con su
  // motor de resistencia.
  int? _carrilCarrera(String? c) {
    final t = (c ?? '').trim();
    if (t.isEmpty || t.toUpperCase().startsWith('D')) return null;
    return int.tryParse(t);
  }

  int? _numeroDescanso(String? c) {
    final t = (c ?? '').trim().toUpperCase();
    if (!t.startsWith('D')) return null;
    return int.tryParse(t.substring(1)) ?? 0;
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

      final inscritos = await (db.select(db.inscripciones)
            ..where((t) => t.mangaId.equals(m.id)))
          .get();

      final equipos = <Map<String, dynamic>>[];
      for (final ins in inscritos) {
        final carril = _carrilCarrera(ins.carrilSalida);
        final descanso = _numeroDescanso(ins.carrilSalida);
        if (carril == null && descanso == null) continue; // sin asignar → fuera
        if (carril != null && carril > maxCarril) maxCarril = carril;

        final eq = await (db.select(db.equipos)
              ..where((t) => t.id.equals(ins.equipoId)))
            .getSingle();
        final pilotos = await _pilotos(db, eq);

        equipos.add({
          'nombre': eq.nombre,
          'copa': eq.copa,
          'carril_salida': carril ?? 0, // 0 = descanso
          'descanso': ?descanso,
          'pilotos': pilotos,
        });
      }
      // Primero los que corren (por carril), luego los descansos (por su nº).
      equipos.sort((a, b) {
        final ca = a['carril_salida'] as int, cb = b['carril_salida'] as int;
        if (ca == 0 && cb == 0) {
          return ((a['descanso'] ?? 0) as int)
              .compareTo((b['descanso'] ?? 0) as int);
        }
        if (ca == 0) return 1;
        if (cb == 0) return -1;
        return ca.compareTo(cb);
      });

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
