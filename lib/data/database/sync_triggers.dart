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
// Triggers de SQLite que firman los cambios sincronizables entre Controls
// (marca de tiempo en ms + nombre de este dispositivo) y apuntan los borrados.
// Así ninguna escritura de la app se queda sin firmar, se haga donde se haga.
//
// Reglas:
//  - Al insertar una fila sin `mod_ms`, el trigger le pone uuid (si no lo
//    trae), `mod_ms` = ahora y `mod_por` = este dispositivo. El fusionador
//    inserta con el `mod_ms` remoto, así que no se re-firma.
//  - Al actualizar alguna columna sincronizable sin tocar `mod_ms`, se firma.
//    El fusionador escribe a la vez el `mod_ms` remoto y no se re-firma.
//  - Los borrados se apuntan en `borrados_registro` con una clave portable.
//
// Los nombres llevan versión (sync1_…): si cambia la definición, se crean
// triggers nuevos y se borran los viejos.

/// Milisegundos desde 1970 según el reloj del sistema, en SQL.
const _ahora =
    "CAST((julianday('now') - 2440587.5) * 86400000 AS INTEGER)";

/// Nombre de este dispositivo, en SQL.
const _yo = "(SELECT valor FROM sync_local WHERE clave = 'dispositivo')";

/// Uuid nuevo aleatorio, en SQL.
const _uuidNuevo = 'lower(hex(randomblob(16)))';

String _distinto(List<String> cols) =>
    cols.map((c) => 'NEW.$c IS NOT OLD.$c').join(' OR ');

/// Triggers de versiones anteriores que se sustituyen (se borran al abrir).
const triggersSyncObsoletos = ['sync1_mangas_ins'];

/// Tandas especiales que la app crea sola, una por prueba, cuando le hacen
/// falta (clasificación manual / importada y resultados generales). Llevan un
/// uuid fijo derivado de la prueba: si dos Controls la crean cada uno por su
/// lado, es la misma tanda.
const tandasUnicasPorPrueba = ['IMPORTADA', 'Resultados generales'];

/// Sentencias que crean los triggers de sincronización (idempotentes).
List<String> sentenciasTriggersSync() {
  String firmarInsert(String tabla, String donde, {bool uuid = false}) => '''
CREATE TRIGGER IF NOT EXISTS sync1_${tabla}_ins AFTER INSERT ON $tabla
WHEN NEW.mod_ms IS NULL BEGIN
  UPDATE $tabla SET ${uuid ? 'uuid = coalesce(NEW.uuid, $_uuidNuevo), ' : ''}mod_ms = $_ahora, mod_por = $_yo
  WHERE $donde;
END''';
  String firmarUpdate(String tabla, List<String> cols, String donde) => '''
CREATE TRIGGER IF NOT EXISTS sync1_${tabla}_upd AFTER UPDATE OF ${cols.join(', ')} ON $tabla
WHEN NEW.mod_ms IS OLD.mod_ms AND (${_distinto(cols)}) BEGIN
  UPDATE $tabla SET mod_ms = $_ahora, mod_por = $_yo WHERE $donde;
END''';
  String borrado(String tabla, String clave) => '''
CREATE TRIGGER IF NOT EXISTS sync1_${tabla}_del AFTER DELETE ON $tabla BEGIN
  INSERT OR REPLACE INTO borrados_registro (tabla, clave, borrado_ms, borrado_por)
  SELECT '$tabla', k, $_ahora, $_yo FROM (SELECT $clave AS k) WHERE k IS NOT NULL;
END''';

  const colsPiloto = [
    'nombre', 'telefono', 'email', 'es_coordinadora', 'palmares_global'
  ];
  const colsEquipo = ['nombre', 'copa', 'piloto1_id', 'piloto2_id', 'activo'];
  const colsPerfil = [
    'categoria', 'categoria_final', 'creditos_iniciales',
    'saldo_temporada_anterior', 'palmares_local'
  ];
  const colsInscripcion = ['preferencia_dia', 'notas'];
  const colsManga = [
    'nombre', 'fecha_hora', 'num_carriles', 'estado', 'pisters_manga_id'
  ];
  const colsCarril = ['manga_id', 'equipo_id', 'carril_salida', 'seed_directo'];
  String firmarManga(String id) =>
      'UPDATE mangas SET mod_ms = $_ahora, mod_por = $_yo WHERE id = $id;';
  const pc = 'piloto_id = NEW.piloto_id AND campeonato_id = NEW.campeonato_id';

  return [
    firmarInsert('pilotos', 'id = NEW.id', uuid: true),
    firmarUpdate('pilotos', colsPiloto, 'id = NEW.id'),
    firmarInsert('equipos', 'id = NEW.id', uuid: true),
    firmarUpdate('equipos', colsEquipo, 'id = NEW.id'),
    borrado('equipos', 'OLD.uuid'),
    // Cambiar los miembros de un equipo es cambiar el equipo.
    '''
CREATE TRIGGER IF NOT EXISTS sync1_equipo_pilotos_ins AFTER INSERT ON equipo_pilotos BEGIN
  UPDATE equipos SET mod_ms = $_ahora, mod_por = $_yo WHERE id = NEW.equipo_id;
END''',
    '''
CREATE TRIGGER IF NOT EXISTS sync1_equipo_pilotos_del AFTER DELETE ON equipo_pilotos BEGIN
  UPDATE equipos SET mod_ms = $_ahora, mod_por = $_yo WHERE id = OLD.equipo_id;
END''',
    firmarInsert('piloto_campeonato', pc),
    firmarUpdate('piloto_campeonato', colsPerfil, pc),
    borrado('piloto_campeonato',
        "(SELECT uuid FROM pilotos WHERE id = OLD.piloto_id) || '|' || "
        '(SELECT uuid FROM campeonatos WHERE id = OLD.campeonato_id)'),
    firmarInsert('inscripciones_prueba', 'id = NEW.id'),
    firmarUpdate('inscripciones_prueba', colsInscripcion, 'id = NEW.id'),
    borrado('inscripciones_prueba',
        "(SELECT uuid FROM pruebas WHERE id = OLD.prueba_id) || '|' || "
        '(SELECT uuid FROM equipos WHERE id = OLD.equipo_id)'),
    // Tandas: la tanda y su parrilla (inscripciones = carriles) son una
    // sola unidad; cualquier cambio de carril firma la tanda.
    '''
CREATE TRIGGER IF NOT EXISTS sync2_mangas_ins AFTER INSERT ON mangas
WHEN NEW.mod_ms IS NULL BEGIN
  UPDATE mangas SET uuid = coalesce(NEW.uuid,
      CASE WHEN NEW.nombre IN (${tandasUnicasPorPrueba.map((n) => "'$n'").join(', ')})
        THEN lower(NEW.nombre) || ':' ||
             (SELECT uuid FROM pruebas WHERE id = NEW.prueba_id)
        ELSE $_uuidNuevo END),
    mod_ms = $_ahora, mod_por = $_yo
  WHERE id = NEW.id;
END''',
    firmarUpdate('mangas', colsManga, 'id = NEW.id'),
    borrado('mangas', 'OLD.uuid'),
    '''
CREATE TRIGGER IF NOT EXISTS sync1_inscripciones_ins AFTER INSERT ON inscripciones BEGIN
  ${firmarManga('NEW.manga_id')}
END''',
    '''
CREATE TRIGGER IF NOT EXISTS sync1_inscripciones_upd AFTER UPDATE OF ${colsCarril.join(', ')} ON inscripciones
WHEN ${_distinto(colsCarril)} BEGIN
  ${firmarManga('NEW.manga_id')}
  ${firmarManga('OLD.manga_id')}
END''',
    '''
CREATE TRIGGER IF NOT EXISTS sync1_inscripciones_del AFTER DELETE ON inscripciones BEGIN
  ${firmarManga('OLD.manga_id')}
END''',
    // Resultados: los de cada tanda son una unidad (firma aparte).
    for (final (ev, fila) in [
      ('INSERT', 'NEW'),
      ('UPDATE', 'NEW'),
      ('DELETE', 'OLD'),
    ])
      '''
CREATE TRIGGER IF NOT EXISTS sync1_resultados_${ev.toLowerCase()} AFTER $ev ON resultados BEGIN
  UPDATE mangas SET res_mod_ms = $_ahora, res_mod_por = $_yo
  WHERE id = $fila.manga_id${ev == 'UPDATE' ? ' OR id = OLD.manga_id' : ''};
END''',
    // Correcciones manuales por copa: una unidad por prueba.
    for (final (ev, fila) in [
      ('INSERT', 'NEW'),
      ('UPDATE', 'NEW'),
      ('DELETE', 'OLD'),
    ])
      '''
CREATE TRIGGER IF NOT EXISTS sync1_overrides_copa_${ev.toLowerCase()} AFTER $ev ON overrides_copa BEGIN
  UPDATE pruebas SET ovr_mod_ms = $_ahora, ovr_mod_por = $_yo
  WHERE id = $fila.prueba_id${ev == 'UPDATE' ? ' OR id = OLD.prueba_id' : ''};
END''',
    // Campeonatos y pruebas: de momento solo necesitan uuid.
    '''
CREATE TRIGGER IF NOT EXISTS sync1_campeonatos_ins AFTER INSERT ON campeonatos
WHEN NEW.uuid IS NULL BEGIN
  UPDATE campeonatos SET uuid = $_uuidNuevo WHERE id = NEW.id;
END''',
    '''
CREATE TRIGGER IF NOT EXISTS sync1_pruebas_ins AFTER INSERT ON pruebas
WHEN NEW.uuid IS NULL BEGIN
  UPDATE pruebas SET uuid = $_uuidNuevo WHERE id = NEW.id;
END''',
  ];
}

/// Uuid de las filas anteriores a la sincronización: derivado del id y del
/// nombre, para que todos los Controls que partieron de la misma copia le
/// den el mismo sin hablar entre ellos. Idempotente.
List<String> sentenciasUuidHeredado() => [
      for (final t in ['pilotos', 'equipos', 'campeonatos', 'pruebas', 'mangas'])
        "UPDATE $t SET uuid = 'l:' || id || ':' || lower(trim(nombre)) "
            'WHERE uuid IS NULL',
    ];
