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
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Campeonatos,
    TablaPuntos,
    TablaBonificacion,
    Pilotos,
    PilotoCampeonato,
    Equipos,
    Pruebas,
    Mangas,
    Inscripciones,
    InscripcionesPrueba,
    Resultados,
    DescartesPrueba,
    OverridesCopa,
    Verificaciones,
    Pagos,
    MovimientosTesoreria,
    MovimientosCreditos,
    CatalogoCoches,
    CatalogoMarcas,
    CatalogoLlantas,
    CatalogoBancadas,
    CatalogoChasis,
    CatalogoNeumaticos,
    CatalogoEngranajes,
    CatalogoMotores,
    CatalogoCopas,
    CatalogoClubs,
    HojasVinculadas,
    SyncCola,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 25;

  /// Ejecuta un ALTER/CREATE que puede fallar si el cambio ya está aplicado.
  /// Tolera "duplicate column", "already exists" para no romper en DBs de dev
  /// cuyo `user_version` se haya quedado por debajo del schema real.
  Future<void> _aplicar(Future<void> Function() fn) async {
    try {
      await fn();
    } catch (e) {
      final msg = e.toString().toLowerCase();
      if (msg.contains('duplicate column') ||
          msg.contains('already exists')) {
        return;
      }
      rethrow;
    }
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await _aplicar(() => customStatement(
                'ALTER TABLE equipos DROP COLUMN coche_catalogo_id'));
          }
          if (from < 3) {
            await _aplicar(() => m.createTable(inscripcionesPrueba));
          }
          if (from < 4) {
            await _aplicar(() async {
              await customStatement('DROP TABLE IF EXISTS pagos');
              await m.createTable(pagos);
            });
          }
          if (from < 5) {
            await _aplicar(() => m.createTable(hojasVinculadas));
          }
          if (from < 6) {
            await _aplicar(() => customStatement(
                "ALTER TABLE campeonatos ADD COLUMN usa_creditos INTEGER NOT NULL DEFAULT 1"));
            await _aplicar(() => customStatement(
                "ALTER TABLE campeonatos ADD COLUMN copas_json TEXT NOT NULL DEFAULT '[\"GT\",\"GT2\",\"SLOT.IT\"]'"));
          }
          if (from < 7) {
            await _aplicar(() => customStatement(
                "ALTER TABLE catalogo_coches ADD COLUMN copas_json TEXT NOT NULL DEFAULT '[]'"));
            await _aplicar(() => customStatement(
                "ALTER TABLE catalogo_bancadas ADD COLUMN copas_json TEXT NOT NULL DEFAULT '[]'"));
          }
          if (from < 8) {
            await _aplicar(() => customStatement(
                'ALTER TABLE pilotos ADD COLUMN es_coordinadora INTEGER NOT NULL DEFAULT 0'));
            await _aplicar(() => customStatement(
                'ALTER TABLE inscripciones_prueba ADD COLUMN wildcard INTEGER NOT NULL DEFAULT 0'));
          }
          if (from < 9) {
            await _aplicar(() => customStatement(
                'ALTER TABLE campeonatos ADD COLUMN cuota_pagat REAL NOT NULL DEFAULT 25.0'));
            await _aplicar(() => customStatement(
                'ALTER TABLE campeonatos ADD COLUMN cuota_coordinadora REAL NOT NULL DEFAULT 11.0'));
            await _aplicar(() => customStatement(
                'ALTER TABLE campeonatos ADD COLUMN cuota_club REAL NOT NULL DEFAULT 14.0'));
          }
          if (from < 10) {
            await _aplicar(() => customStatement(
                "ALTER TABLE verificaciones ADD COLUMN fotos_json TEXT NOT NULL DEFAULT '[]'"));
          }
          if (from < 11) {
            await _aplicar(() => customStatement(
                'ALTER TABLE verificaciones ADD COLUMN peso_inicial_coche REAL'));
            await _aplicar(() => customStatement(
                'ALTER TABLE verificaciones ADD COLUMN peso_final_coche REAL'));
            await _aplicar(() => m.createTable(catalogoChasis));
          }
          if (from < 12) {
            await _aplicar(() => customStatement(
                "ALTER TABLE verificaciones ADD COLUMN motor_tipo TEXT NOT NULL DEFAULT 'ORGANIZACION'"));
            await _aplicar(() => customStatement(
                'ALTER TABLE verificaciones ADD COLUMN motor_rpm INTEGER'));
            await _aplicar(() => customStatement(
                'ALTER TABLE verificaciones ADD COLUMN motor_ums REAL'));
          }
          if (from < 13) {
            await _aplicar(() => m.createTable(movimientosTesoreria));
          }
          if (from < 14) {
            await _aplicar(() => customStatement(
                'ALTER TABLE verificaciones ADD COLUMN cred_aplicado_p1 INTEGER NOT NULL DEFAULT 0'));
            await _aplicar(() => customStatement(
                'ALTER TABLE verificaciones ADD COLUMN cred_aplicado_p2 INTEGER NOT NULL DEFAULT 0'));
          }
          if (from < 15) {
            await _aplicar(() => m.createTable(movimientosCreditos));
          }
          if (from < 16) {
            await _aplicar(() => customStatement(
                'ALTER TABLE campeonatos ADD COLUMN motor_sorteo_min INTEGER'));
            await _aplicar(() => customStatement(
                'ALTER TABLE campeonatos ADD COLUMN motor_sorteo_max INTEGER'));
          }
          if (from < 17) {
            await _aplicar(() => m.createTable(catalogoEngranajes));
          }
          if (from < 18) {
            await _aplicar(() => customStatement(
                'ALTER TABLE catalogo_coches ADD COLUMN foto_path TEXT'));
          }
          if (from < 19) {
            await _aplicar(() => m.createTable(catalogoMotores));
          }
          if (from < 20) {
            await _aplicar(() => customStatement(
                'ALTER TABLE inscripciones_prueba ADD COLUMN copa TEXT'));
            // Snapshot de la copa actual de cada equipo en sus inscripciones
            // existentes, para que un cambio de copa futuro no mueva el pasado.
            await _aplicar(() => customStatement(
                'UPDATE inscripciones_prueba SET copa = '
                '(SELECT copa FROM equipos WHERE equipos.id = '
                'inscripciones_prueba.equipo_id) WHERE copa IS NULL'));
          }
          if (from < 21) {
            await _aplicar(() => m.createTable(overridesCopa));
          }
          if (from < 22) {
            await _aplicar(() => customStatement(
                'ALTER TABLE campeonatos ADD COLUMN usa_tesoreria INTEGER NOT NULL DEFAULT 1'));
            await _aplicar(() => customStatement(
                'ALTER TABLE campeonatos ADD COLUMN finalizado INTEGER NOT NULL DEFAULT 0'));
          }
          if (from < 23) {
            await _aplicar(() => customStatement(
                'ALTER TABLE piloto_campeonato ADD COLUMN categoria_final TEXT'));
          }
          if (from < 24) {
            await _aplicar(() => customStatement(
                'ALTER TABLE campeonatos ADD COLUMN pinon_dientes_min INTEGER NOT NULL DEFAULT 12'));
            await _aplicar(() => customStatement(
                'ALTER TABLE campeonatos ADD COLUMN pinon_dientes_max INTEGER NOT NULL DEFAULT 12'));
            await _aplicar(() => customStatement(
                'ALTER TABLE campeonatos ADD COLUMN corona_dientes_min INTEGER NOT NULL DEFAULT 24'));
            await _aplicar(() => customStatement(
                'ALTER TABLE campeonatos ADD COLUMN corona_dientes_max INTEGER NOT NULL DEFAULT 30'));
          }
          if (from < 25) {
            await _aplicar(() => customStatement(
                'ALTER TABLE campeonatos ADD COLUMN marca_titulo TEXT'));
            await _aplicar(() => customStatement(
                'ALTER TABLE campeonatos ADD COLUMN marca_lema TEXT'));
          }
        },
      );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'pitwall');
  }
}
