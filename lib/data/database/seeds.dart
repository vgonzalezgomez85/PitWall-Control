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
import 'package:drift/drift.dart';

import 'app_database.dart';

class Seeds {
  static Future<void> sembrar(AppDatabase db) async {
    final yaSembrado = await (db.select(db.catalogoCopas)..limit(1)).get();
    if (yaSembrado.isNotEmpty) return;

    await db.transaction(() async {
      await _copas(db);
      await _clubs(db);
      await _marcas(db);
      await _llantas(db);
      await _bancadas(db);
      await _neumaticos(db);
      await _coches(db);
      await _campeonatos(db);
    });
  }

  static Future<void> _copas(AppDatabase db) async {
    for (final n in [
      'GT', 'GT2', 'GT3', 'GTE',
      'SLOT.IT',
      'LMP', 'LMP2', 'HYP', 'Hypercar',
      'Grupo C', 'Clásicos', 'Rally',
    ]) {
      await db.into(db.catalogoCopas).insert(CatalogoCopasCompanion.insert(nombre: n));
    }
  }

  static Future<void> _clubs(AppDatabase db) async {
    const clubs = [
      'EL SOT', 'SLOTMANIA', 'SLOTFORYOU', 'SLOTCAR', 'SCM', 'BUDELLETS',
      'GASCLAVAT', 'SLOTSAB', 'CRICRAC', 'Rodamon Slot Súria', 'RCT Vallès',
      'DREAM SLOT', 'CRONO', 'CM LES FRANQUESES', 'CMBSC', 'MASQUEFA SLOT', 'DPPF',
    ];
    for (final n in clubs) {
      await db.into(db.catalogoClubs).insert(CatalogoClubsCompanion.insert(nombre: n));
    }
  }

  static Future<void> _marcas(AppDatabase db) async {
    const marcas = {
      'SIT': 'SLOT.IT', 'SLP': 'SLOTING PLUS', 'SCA': 'SCALEAUTO',
      'MB': 'MB SLOT', 'REP': 'REPROTEC', 'SID': 'SIDEWAYS',
      'ARS': 'ARROW SLOT', 'SCX': 'SCALEXTRIC', 'NIN': 'NINCO',
      'BLA': 'BLACK ARROW', 'PINK': 'PINK CAR', 'HOB': 'HOBBY SLOT',
      'MR': 'MR SLOTCAR', 'SUP': 'SUPERSLOT', 'JP': 'JP-SLOT',
      '3DSRP': '3DSRP', 'PKS': 'PKS SLOT', 'PC': 'POLYCAR',
      'I3D': 'I3D', 'MOR': 'MORPHEUS', 'ACM': 'ACME',
      'SRC': 'SRC', 'DZR': 'DZERO SLOT', 'SCA 3D': 'SCA 3D',
      'MTS': 'MITOS', 'NSR': 'NSR', 'CCSLOT': 'CCSLOT',
      'MSC': 'MSC', 'ALF': 'ALFA SLOT',
    };
    for (final e in marcas.entries) {
      await db.into(db.catalogoMarcas).insert(
            CatalogoMarcasCompanion.insert(codigo: e.key, nombre: e.value),
          );
    }
  }

  static Future<void> _llantas(AppDatabase db) async {
    const delanteras = [
      '15,8 x 8 PL', '15,8 x 8 3D', '15,8 x 8 AL', '15,8 x 8 MG',
      '15,8 x 10 AL', '15,8 x 10 MG',
      '16,2 x 8 PL', '16,2 x 8 3D', '16,2 x 8 AL', '16,2 x 10 AL',
      '16,5 x 8 PL', '16,5 x 8 3D', '16,5 x 8 AL', '16,5 x 8 MG',
      '16,5 x 10 AL', '16,5 x 10 MG',
      '16,7 x 8 AL',
      '16,9 x 8 PL', '16,9 x 8 3D', '16,9 x 8 AL', '16,9 x 8 MG',
      '16,9 x 10 AL', '16,9 x 10 MG',
      '17,2 x 8 PL', '17,2 x 8 3D', '17,2 x 8 AL', '17,2 x 8 MG',
      '17,2 x 10 AL', '17,2 x 10 MG',
      '17,5 x 8 AL', '17,5 x 10 AL',
    ];
    const traseras = [
      '16,5 x 8 AL', '16,5 x 8 MG', '16,5 x 10 AL', '16,5 x 10 MG',
      '16,7 x 8 AL',
      '16,9 x 8 AL', '16,9 x 8 MG', '16,9 x 10 AL', '16,9 x 10 MG',
      '17,2 x 8 AL', '17,2 x 8 MG', '17,2 x 10 AL', '17,2 x 10 MG',
      '17,5 x 8 AL', '17,5 x 10 AL',
    ];
    for (final d in delanteras) {
      await db.into(db.catalogoLlantas).insert(
            CatalogoLlantasCompanion.insert(dimension: d, tipo: 'DELANTERA'),
          );
    }
    for (final t in traseras) {
      await db.into(db.catalogoLlantas).insert(
            CatalogoLlantasCompanion.insert(dimension: t, tipo: 'TRASERA'),
          );
    }
  }

  static Future<void> _bancadas(AppDatabase db) async {
    const bancadas = [
      'AvantSlot 0,75',
      'Scaleauto RT3 0,25', 'Scaleauto RT3 0,5',
      'Scaleauto RT3 0,75', 'Scaleauto RT3 1,0',
      'Slot.it 0,0', 'Slot.it 0,5', 'Slot.it 1,0',
      'Slot.it 0,0 rodamientos', 'Slot.it 0,5 rodamientos', 'Slot.it 1,0 rodamientos',
      'Slot.it 0,0 carbono', 'Slot.it 0,5 carbono', 'Slot.it 1,0 carbono',
      'Slot.it 0,0 carbono rodamientos', 'Slot.it 0,5 carbono rodamientos',
      'Slot.it 1,0 carbono rodamientos',
    ];
    for (final n in bancadas) {
      await db.into(db.catalogoBancadas).insert(CatalogoBancadasCompanion.insert(nombre: n));
    }
  }

  static Future<void> _neumaticos(AppDatabase db) async {
    const neumaticos = {
      'AS25 19,0 NEGRO': 'SC 4752 AS25',
      'AS25 19,5 NEGRO': 'SC 4761 AS25',
      'AS25 20,0 NEGRO': 'SC 4756 AS25',
      'AS20 19,0 GRIS': 'SC 4752 AS20',
      'AS20 19,5 GRIS': 'SC 4761 AS20',
      'AS20 20,0 GRIS': 'SC 4756 AS20',
    };
    for (final e in neumaticos.entries) {
      await db.into(db.catalogoNeumaticos).insert(
            CatalogoNeumaticosCompanion.insert(
              nombre: e.key,
              referencia: Value(e.value),
            ),
          );
    }
  }

  static Future<void> _coches(AppDatabase db) async {
    // nombre, marca, modelo, peso_min, creditos_coche
    final coches = [
      ['AVANT SLOT-FERRARI 296 GT3 "FANTASY 2"', 'AVANT SLOT', 'FERRARI 296 GT3 "FANTASY 2"', 17.0, 8],
      ['COPA SLOT.IT-AUDI R8 LMS GT3 EVOII', 'COPA SLOT.IT', 'AUDI R8 LMS GT3 EVOII', 17.0, 0],
      ['SCALEAUTO-VIPER SRT', 'SCALEAUTO', 'VIPER SRT', 17.0, -8],
      ['SCALEAUTO-CORVETTE C7R', 'SCALEAUTO', 'CORVETTE C7R', 17.0, -6],
      ['SCALEAUTO-COVETTE CALLAWAY C7 GT-R', 'SCALEAUTO', 'COVETTE CALLAWAY C7 GT-R', 17.0, -6],
      ['SCALEAUTO-BMW M8 GTE', 'SCALEAUTO', 'BMW M8 GTE', 17.0, -4],
      ['SCALEAUTO-HONDA NSX GT3', 'SCALEAUTO', 'HONDA NSX GT3', 18.0, 0],
      ['SCALEAUTO-PORSCHE 911 (992) GT3 RSR "Nuevo"', 'SCALEAUTO', 'PORSCHE 911 (992) GT3 RSR "Nuevo"', 18.0, 0],
      ['SCALEAUTO-AUDI R8 LMS GT2 "Nuevo"', 'SCALEAUTO', 'AUDI R8 LMS GT2 "Nuevo"', 17.0, 0],
      ['SCALEAUTO-PORSCHE 991.2 RSR', 'SCALEAUTO', 'PORSCHE 991.2 RSR', 17.0, 4],
      ['SCALEAUTO-MERCEDES AMG GT3', 'SCALEAUTO', 'MERCEDES AMG GT3', 18.0, 4],
      ['SCALEAUTO-AUDI R8 LMS "Antiguo"', 'SCALEAUTO', 'AUDI R8 LMS "Antiguo"', 17.0, 6],
      ['SCALEAUTO-PORSCHE 991 RSR "Antiguo"', 'SCALEAUTO', 'PORSCHE 991 RSR "Antiguo"', 17.0, 6],
      ['SCALEAUTO-BMW Z4 GT3', 'SCALEAUTO', 'BMW Z4 GT3', 17.0, 8],
      ['SCALEAUTO-LAMBORGHINI SUPER TORFEO', 'SCALEAUTO', 'LAMBORGHINI SUPER TORFEO', 17.0, 0],
      ['SIDEWAYS-FORD GTE', 'SIDEWAYS', 'FORD GTE', 18.0, -8],
      ['SIDEWAYS-LAMBO HURACAN GT3', 'SIDEWAYS', 'LAMBO HURACAN GT3', 18.0, -6],
      ['SIDEWAYS-BMW M6 GT3', 'SIDEWAYS', 'BMW M6 GT3', 18.0, -4],
      ['SIDEWAYS-ASTON MARTIN GT3', 'SIDEWAYS', 'ASTON MARTIN GT3', 17.0, -2],
      ['SIDEWAYS-MCLAREN 720S GT3', 'SIDEWAYS', 'MCLAREN 720S GT3', 18.5, 0],
      ['SIDEWAYS-FERRARI 296 GT3 "FANTASY 2"', 'SIDEWAYS', 'FERRARI 296 GT3 "FANTASY 2"', 19.0, 2],
      ['SIDEWAYS-LEXUS RC F GT3', 'SIDEWAYS', 'LEXUS RC F GT3', 18.0, 2],
      ['SIDEWAYS-FERRARI 488 GT3 "FANTASY 1"', 'SIDEWAYS', 'FERRARI 488 GT3 "FANTASY 1"', 17.0, 4],
      ['SIDEWAYS-BENTLEY CONTINENTAL GT3', 'SIDEWAYS', 'BENTLEY CONTINENTAL GT3', 20.0, 8],
      ['SIDEWAYS-BMW M4 LM GT3', 'SIDEWAYS', 'BMW M4 LM GT3', 19.0, 8],
      ['SIDEWAYS-FORD MUSTANG GT3', 'SIDEWAYS', 'FORD MUSTANG GT3', 18.0, 8],
      ['SLOT.IT-MASERATI GT3', 'SLOT.IT', 'MASERATI GT3', 17.5, 8],
      ['SLOT.IT-NISSAN GTR GT3', 'SLOT.IT', 'NISSAN GTR GT3', 18.0, 8],
      ['SLOT.IT-AUDI R8 LMS GT3 EVOII', 'SLOT.IT', 'AUDI R8 LMS GT3 EVOII', 17.0, 8],
    ];
    for (final c in coches) {
      await db.into(db.catalogoCoches).insert(
            CatalogoCochesCompanion.insert(
              nombre: c[0] as String,
              marca: c[1] as String,
              modelo: c[2] as String,
              pesoMin: c[3] as double,
              creditosCoche: Value(c[4] as int),
            ),
          );
    }
  }

  /// Tabla de puntos por posición (1 → 70 ... 64 → 1).
  static const _puntosPorPosicion = [
    70, 64, 59, 55, 52, 50, 48, 46, 44, 43,
    42, 41, 40, 39, 38, 37, 36, 35, 34, 33,
    32, 31, 30, 29, 28, 27, 26, 25, 24, 23,
    22, 21, 20, 19, 18, 17, 16, 15, 14, 13,
    12, 11, 10, 9, 8, 7, 6, 5, 4, 3,
    2, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1,
  ];

  /// Tabla de bonificación de cierre: [carrerasMin, carrerasMax, bonif]
  static const _bonifPorCategoria = {
    'PLATINO': [
      [7, 99, 12], [6, 6, 8], [4, 5, 6], [2, 3, 2], [1, 1, 0],
    ],
    'ORO': [
      [7, 99, 14], [6, 6, 10], [4, 5, 8], [2, 3, 4], [1, 1, 0],
    ],
    'PLATA': [
      [7, 99, 20], [6, 6, 16], [4, 5, 14], [2, 3, 6], [1, 1, 0],
    ],
    'BRONCE': [
      [7, 99, 28], [6, 6, 24], [4, 5, 16], [2, 3, 8], [1, 1, 0],
    ],
  };

  static Future<void> _campeonatos(AppDatabase db) async {
    final anioActual = DateTime.now().year;

    final resisbarnaId = await db.into(db.campeonatos).insert(
          CampeonatosCompanion.insert(
            nombre: 'Resisbarna $anioActual',
            formato: 'PAREJAS',
            anio: anioActual,
            copasJson: const Value('["GT","GT2","SLOT.IT"]'),
            usaCreditos: const Value(true),
          ),
        );

    await _sembrarTablasCampeonato(db, resisbarnaId);
  }

  static Future<void> _sembrarTablasCampeonato(AppDatabase db, int campeonatoId) async {
    for (var i = 0; i < _puntosPorPosicion.length; i++) {
      await db.into(db.tablaPuntos).insert(
            TablaPuntosCompanion.insert(
              campeonatoId: campeonatoId,
              posicion: i + 1,
              puntos: _puntosPorPosicion[i],
            ),
          );
    }

    for (final cat in _bonifPorCategoria.entries) {
      for (final tramo in cat.value) {
        await db.into(db.tablaBonificacion).insert(
              TablaBonificacionCompanion.insert(
                campeonatoId: campeonatoId,
                categoria: cat.key,
                carrerasMin: tramo[0],
                carrerasMax: tramo[1],
                bonificacion: tramo[2],
              ),
            );
      }
    }
  }

  /// Helper para crear un campeonato secundario con las mismas tablas de puntos/bonif.
  static Future<int> crearCampeonato(
    AppDatabase db, {
    required String nombre,
    required String formato,
    required int anio,
  }) async {
    final id = await db.into(db.campeonatos).insert(
          CampeonatosCompanion.insert(
            nombre: nombre,
            formato: formato,
            anio: anio,
          ),
        );
    await _sembrarTablasCampeonato(db, id);
    return id;
  }
}
