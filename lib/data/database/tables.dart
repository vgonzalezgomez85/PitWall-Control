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

// ============================================================
// CAMPEONATOS — varios bajo el paraguas Resisbarna
// ============================================================

class Campeonatos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  TextColumn get formato => text()(); // 'INDIVIDUAL' | 'PAREJAS'
  IntColumn get anio => integer()();
  TextColumn get organizacion => text().withDefault(const Constant('Resisbarna'))();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
  IntColumn get topeRegularizacion => integer().withDefault(const Constant(28))();
  IntColumn get numDescartes => integer().withDefault(const Constant(1))();
  /// Si true, el campeonato usa el sistema de créditos/handicap (Resisbarna).
  /// Si false, se ocultan todos los campos relacionados con créditos.
  BoolColumn get usaCreditos => boolean().withDefault(const Constant(true))();
  /// Si true, el campeonato gestiona tesorería (cuotas/pagos por prueba).
  BoolColumn get usaTesoreria => boolean().withDefault(const Constant(true))();
  /// Si true, el campeonato está finalizado (temporada cerrada).
  BoolColumn get finalizado => boolean().withDefault(const Constant(false))();
  /// Lista de copas/categorías activas para este campeonato (JSON array de strings).
  /// Ej: ["GT","GT2","SLOT.IT"] o ["Grupo C","Clásicos"].
  TextColumn get copasJson => text().withDefault(const Constant('[]'))();
  /// Cuota total que paga un equipo por prueba en este campeonato.
  RealColumn get cuotaPagat => real().withDefault(const Constant(25.0))();
  /// De esa cuota, la parte que va a coordinadora.
  RealColumn get cuotaCoordinadora => real().withDefault(const Constant(11.0))();
  /// De esa cuota, la parte que va al club.
  RealColumn get cuotaClub => real().withDefault(const Constant(14.0))();
  /// Rango de números de motor de organización para el sorteo (inclusive).
  /// Si están a null, el sorteo de motores no está configurado.
  IntColumn get motorSorteoMin => integer().nullable()();
  IntColumn get motorSorteoMax => integer().nullable()();
  /// Rango de dientes permitido en la verificación (inclusive). Por defecto el
  /// histórico de Resisbarna: piñón 12 fijo, corona 24-30.
  IntColumn get pinonDientesMin => integer().withDefault(const Constant(12))();
  IntColumn get pinonDientesMax => integer().withDefault(const Constant(12))();
  IntColumn get coronaDientesMin => integer().withDefault(const Constant(24))();
  IntColumn get coronaDientesMax => integer().withDefault(const Constant(30))();
  /// Marca propia del campeonato en los PDF (título de cabecera y lema del
  /// pie). Si están vacíos se usa la marca global de la app.
  TextColumn get marcaTitulo => text().nullable()();
  TextColumn get marcaLema => text().nullable()();
  DateTimeColumn get creadoEn => dateTime().withDefault(currentDateAndTime)();
}

// Tabla de puntos por posición: pos → puntos (por campeonato)
class TablaPuntos extends Table {
  IntColumn get campeonatoId => integer().references(Campeonatos, #id)();
  IntColumn get posicion => integer()();
  IntColumn get puntos => integer()();
  @override
  Set<Column> get primaryKey => {campeonatoId, posicion};
}

// Tabla de bonificación de cierre: categoría × tramo_carreras → bonif (por campeonato)
class TablaBonificacion extends Table {
  IntColumn get campeonatoId => integer().references(Campeonatos, #id)();
  TextColumn get categoria => text()(); // PLATINO | ORO | PLATA | BRONCE
  IntColumn get carrerasMin => integer()();
  IntColumn get carrerasMax => integer()();
  IntColumn get bonificacion => integer()();
  @override
  Set<Column> get primaryKey => {campeonatoId, categoria, carrerasMin};
}

// ============================================================
// PILOTOS — maestro único + perfil por campeonato
// ============================================================

class Pilotos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  TextColumn get palmaresGlobal => text().nullable()();
  TextColumn get telefono => text().nullable()();
  TextColumn get email => text().nullable()();
  /// Si true, este piloto es de coordinadora y su equipo no paga cuota.
  BoolColumn get esCoordinadora => boolean().withDefault(const Constant(false))();
  DateTimeColumn get creadoEn => dateTime().withDefault(currentDateAndTime)();
}

class PilotoCampeonato extends Table {
  IntColumn get pilotoId => integer().references(Pilotos, #id)();
  IntColumn get campeonatoId => integer().references(Campeonatos, #id)();
  TextColumn get categoria => text()(); // PLATINO | ORO | PLATA | BRONCE
  /// Categoría tras la revisión de cierre (promoción/descenso). Si es null no
  /// se ha revisado y se usa [categoria]. Se usa para la bonificación de cierre
  /// y como categoría inicial al importar al siguiente campeonato.
  TextColumn get categoriaFinal => text().nullable()();
  IntColumn get creditosIniciales => integer()();
  IntColumn get creditosActuales => integer()();
  IntColumn get saldoTemporadaAnterior => integer().withDefault(const Constant(0))();
  IntColumn get bonificacionAplicada => integer().withDefault(const Constant(0))();
  TextColumn get palmaresLocal => text().nullable()();
  @override
  Set<Column> get primaryKey => {pilotoId, campeonatoId};
}

// ============================================================
// EQUIPOS — agrupan a 1 (INDIVIDUAL) o 2 (PAREJAS) pilotos
// ============================================================

class Equipos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get campeonatoId => integer().references(Campeonatos, #id)();
  TextColumn get nombre => text()();
  TextColumn get copa => text()(); // GT | GT2 | SLOT.IT | LMP | LMP2
  IntColumn get piloto1Id => integer().references(Pilotos, #id)();
  IntColumn get piloto2Id => integer().references(Pilotos, #id).nullable()();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
}

// ============================================================
// PRUEBAS y MANGAS
// ============================================================

class Pruebas extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get campeonatoId => integer().references(Campeonatos, #id)();
  TextColumn get nombre => text()(); // EL SOT, SLOT FOR YOU, SLOT CAR…
  TextColumn get sede => text().nullable()();
  DateTimeColumn get fecha => dateTime().nullable()();
  IntColumn get orden => integer()();
  TextColumn get estado =>
      text().withDefault(const Constant('PROGRAMADA'))(); // PROGRAMADA | EN_CURSO | TERMINADA | CANCELADA
}

class Mangas extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get pruebaId => integer().references(Pruebas, #id)();
  TextColumn get nombre => text()(); // "Jueves 21:00"
  DateTimeColumn get fechaHora => dateTime().nullable()();
  IntColumn get numCarriles => integer().withDefault(const Constant(8))();
  TextColumn get estado => text().withDefault(const Constant('PROGRAMADA'))();
}

class Inscripciones extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get mangaId => integer().references(Mangas, #id)();
  IntColumn get equipoId => integer().references(Equipos, #id)();
  TextColumn get carrilSalida => text().nullable()(); // D1..D4 o 1..N
  BoolColumn get seedDirecto => boolean().withDefault(const Constant(false))();
}

/// Inscripción de un equipo a la PRUEBA (antes de asignarlo a una manga concreta).
class InscripcionesPrueba extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get pruebaId => integer().references(Pruebas, #id)();
  IntColumn get equipoId => integer().references(Equipos, #id)();
  DateTimeColumn get fechaInscripcion =>
      dateTime().withDefault(currentDateAndTime)();
  TextColumn get preferenciaDia => text().nullable()(); // p.ej. "Jueves"
  TextColumn get notas => text().nullable()();
  BoolColumn get asignada => boolean().withDefault(const Constant(false))();
  /// Si true, el equipo participa como invitado / wildcard y no paga.
  BoolColumn get wildcard => boolean().withDefault(const Constant(false))();
  /// Copa en la que el equipo compitió en ESTA prueba. Permite cambiar de copa
  /// a mitad de campeonato sin perder los puntos de las pruebas anteriores.
  /// Si es null, se usa la copa actual del equipo.
  TextColumn get copa => text().nullable()();
}

class Resultados extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get mangaId => integer().references(Mangas, #id)();
  IntColumn get pilotoId => integer().references(Pilotos, #id)();
  IntColumn get equipoId => integer().references(Equipos, #id)();
  IntColumn get puntos => integer().withDefault(const Constant(0))();
  IntColumn get posicion => integer().nullable()();
  IntColumn get aRestar => integer().withDefault(const Constant(0))();
}

class DescartesPrueba extends Table {
  IntColumn get pilotoId => integer().references(Pilotos, #id)();
  IntColumn get pruebaId => integer().references(Pruebas, #id)();
  @override
  Set<Column> get primaryKey => {pilotoId, pruebaId};
}

/// Corrección manual de puntos en la clasificación de una copa. Si existe,
/// PREVALECE sobre el cálculo automático (re-ranking) de esa copa para ese
/// piloto y prueba.
class OverridesCopa extends Table {
  IntColumn get campeonatoId => integer().references(Campeonatos, #id)();
  TextColumn get copa => text()();
  IntColumn get pilotoId => integer().references(Pilotos, #id)();
  IntColumn get pruebaId => integer().references(Pruebas, #id)();
  IntColumn get puntos => integer()();
  @override
  Set<Column> get primaryKey => {campeonatoId, copa, pilotoId, pruebaId};
}

// ============================================================
// VERIFICACIONES — scrutineering completo
// ============================================================

class Verificaciones extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get mangaId => integer().references(Mangas, #id)();
  IntColumn get equipoId => integer().references(Equipos, #id)();
  IntColumn get cocheCatalogoId => integer().references(CatalogoCoches, #id).nullable()();

  /// Peso de la carrocería (cumple con peso_min del coche).
  RealColumn get pesoInicial => real().nullable()();
  RealColumn get pesoFinal => real().nullable()();
  RealColumn get pesoMin => real().nullable()();
  /// Peso del coche entero (carrocería + chasis + componentes), al inicio
  /// y al final de la verificación.
  RealColumn get pesoInicialCoche => real().nullable()();
  RealColumn get pesoFinalCoche => real().nullable()();

  /// Identificador o número del motor (cuando es de organización).
  TextColumn get motor => text().nullable()();
  /// 'PROPIO' o 'ORGANIZACION'.
  TextColumn get motorTipo => text().withDefault(const Constant('ORGANIZACION'))();
  /// Si motor propio: RPM medidas.
  IntColumn get motorRpm => integer().nullable()();
  /// Si motor propio: uMs (medida específica).
  RealColumn get motorUms => real().nullable()();

  TextColumn get pinonMarca => text().nullable()();
  IntColumn get pinonDientes => integer().nullable()();

  TextColumn get coronaMarca => text().nullable()();
  IntColumn get coronaDientes => integer().nullable()();

  TextColumn get llantaDelMarca => text().nullable()();
  TextColumn get llantaDelDimension => text().nullable()();
  TextColumn get llantaTraMarca => text().nullable()();
  TextColumn get llantaTraDimension => text().nullable()();

  TextColumn get trencilla => text().nullable()();
  TextColumn get suspension => text().nullable()();
  TextColumn get bancada => text().nullable()();
  TextColumn get chasis => text().nullable()();
  TextColumn get neumatico => text().nullable()();

  TextColumn get observaciones => text().nullable()();
  BoolColumn get validado => boolean().withDefault(const Constant(false))();
  /// JSON array con rutas de hasta 4 fotos del coche/equipo.
  TextColumn get fotosJson => text().withDefault(const Constant('[]'))();
  DateTimeColumn get fecha => dateTime().withDefault(currentDateAndTime)();

  /// Créditos que se descontaron a piloto1 al validar la verificación.
  /// Se rellena solo cuando `validado` pasa a true. Sirve para devolverlos
  /// si la verificación se desvalida, se cambia de coche o se borra.
  IntColumn get credAplicadoP1 => integer().withDefault(const Constant(0))();
  IntColumn get credAplicadoP2 => integer().withDefault(const Constant(0))();
}

// ============================================================
// TESORERÍA
// ============================================================

class Pagos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get pruebaId => integer().references(Pruebas, #id)();
  IntColumn get equipoId => integer().references(Equipos, #id)();
  RealColumn get pagat => real().withDefault(const Constant(0))();
  RealColumn get coordinadora => real().withDefault(const Constant(0))();
  RealColumn get club => real().withDefault(const Constant(0))();
  DateTimeColumn get fecha => dateTime().withDefault(currentDateAndTime)();
  TextColumn get observaciones => text().nullable()();
}

/// Historial de movimientos de créditos de un piloto en un campeonato.
/// Cada vez que se valida o desvalida una verificación, o se borra, se
/// registra aquí un asiento. `delta` negativo = se gastan, positivo = devolución.
class MovimientosCreditos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get pilotoId => integer().references(Pilotos, #id)();
  IntColumn get campeonatoId => integer().references(Campeonatos, #id)();
  IntColumn get verificacionId =>
      integer().references(Verificaciones, #id).nullable()();
  IntColumn get equipoId => integer().references(Equipos, #id).nullable()();
  IntColumn get pruebaId => integer().references(Pruebas, #id).nullable()();
  IntColumn get delta => integer()();
  /// Saldo del piloto justo después del movimiento (snapshot).
  IntColumn get saldoResultante => integer()();
  TextColumn get motivo => text()();
  DateTimeColumn get fecha => dateTime().withDefault(currentDateAndTime)();
}

/// Movimientos extra de tesorería (ingresos/gastos que no son pagos de carrera).
/// Si `pruebaId` está vacío, es a nivel campeonato. Si tiene valor, es de esa prueba.
/// `importe` positivo = ingreso, negativo = gasto.
class MovimientosTesoreria extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get campeonatoId => integer().references(Campeonatos, #id)();
  IntColumn get pruebaId => integer().references(Pruebas, #id).nullable()();
  TextColumn get concepto => text()();
  RealColumn get importe => real()();
  DateTimeColumn get fecha => dateTime().withDefault(currentDateAndTime)();
  TextColumn get notas => text().nullable()();
}

// ============================================================
// CATÁLOGOS MAESTROS (alimentan dropdowns de verificación)
// ============================================================

class CatalogoCoches extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()(); // "SCALEAUTO-BMW M8 GTE"
  TextColumn get marca => text()();
  TextColumn get modelo => text()();
  RealColumn get pesoMin => real()();
  IntColumn get creditosCoche => integer().withDefault(const Constant(0))();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
  /// JSON array de copas donde aplica este coche. Vacío "[]" = aplica a todas.
  TextColumn get copasJson => text().withDefault(const Constant('[]'))();
  /// Nombre de archivo de la foto del coche (en la carpeta de fotos local).
  /// Sirve para comprobar en la verificación que el coche entregado coincide.
  TextColumn get fotoPath => text().nullable()();
}

class CatalogoMarcas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get codigo => text()(); // SIT, SCA, SLP…
  TextColumn get nombre => text()();
}

class CatalogoLlantas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get dimension => text()(); // "15,8 x 8 PL"
  TextColumn get tipo => text()(); // DELANTERA | TRASERA | AMBAS
}

class CatalogoBancadas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()(); // "Scaleauto RT3 1,0"
  /// JSON array de copas donde aplica. Vacío "[]" = aplica a todas.
  TextColumn get copasJson => text().withDefault(const Constant('[]'))();
}

class CatalogoChasis extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  /// JSON array de copas donde aplica. Vacío "[]" = aplica a todas.
  TextColumn get copasJson => text().withDefault(const Constant('[]'))();
}

class CatalogoNeumaticos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()(); // "AS25 19,0 NEGRO"
  TextColumn get referencia => text().nullable()();
}

/// Engranajes: piñones y coronas homologados.
class CatalogoEngranajes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tipo => text()(); // PINON | CORONA
  TextColumn get marca => text()();
  IntColumn get dientes => integer()();
}

/// Motores homologados (con sus medidas de referencia).
class CatalogoMotores extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()(); // identificador / modelo del motor
  IntColumn get rpm => integer().nullable()();
  RealColumn get gauss => real().nullable()();
  /// JSON array de copas donde aplica. Vacío "[]" = aplica a todas.
  TextColumn get copasJson => text().withDefault(const Constant('[]'))();
}

class CatalogoCopas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()(); // GT, GT2, SLOT.IT, LMP, LMP2
}

class CatalogoClubs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
}

// ============================================================
// HOJAS DE GOOGLE VINCULADAS — para auto-import
// ============================================================

/// Vincula una hoja de cálculo de Drive a una entidad de la app.
/// Cuando el usuario pulsa "Actualizar desde Drive", se relee la hoja
/// usando el mapeo guardado y se aplican los cambios.
class HojasVinculadas extends Table {
  IntColumn get id => integer().autoIncrement()();
  /// 'pilotos' | 'equipos' | 'inscripciones'
  TextColumn get entidad => text()();
  IntColumn get campeonatoId => integer().nullable()();
  IntColumn get pruebaId => integer().nullable()();
  TextColumn get hojaId => text()();
  TextColumn get hojaNombre => text()();
  TextColumn get pestanaTitulo => text()();
  TextColumn get mapeoJson => text()();
  DateTimeColumn get ultimaSync => dateTime().nullable()();
  TextColumn get ultimoResumen => text().nullable()();
}

// ============================================================
// SYNC WordPress — cola de pendientes
// ============================================================

class SyncCola extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entidad => text()(); // 'clasificacion' | 'prueba' | 'piloto'…
  IntColumn get entidadId => integer().nullable()();
  TextColumn get accion => text()(); // 'upsert' | 'delete'
  TextColumn get payloadJson => text()();
  TextColumn get estado => text().withDefault(const Constant('PENDIENTE'))(); // PENDIENTE | OK | ERROR
  TextColumn get error => text().nullable()();
  DateTimeColumn get creadoEn => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get sincronizadoEn => dateTime().nullable()();
}
