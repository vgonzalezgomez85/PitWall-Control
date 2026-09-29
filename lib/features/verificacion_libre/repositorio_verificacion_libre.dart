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

// Verificación libre: verificaciones técnicas sin campeonato ni prueba real
// (carrera esporádica, control suelto en el club…).
//
// Cada sesión se guarda con la misma estructura que una prueba normal para
// reutilizar tal cual el editor de verificaciones, las fotos, el sorteo de
// motores y el PDF:
//   campeonato oculto (`esVerificacionLibre`, guarda el reglamento)
//     └─ prueba (nombre, sede, fecha de la sesión)
//          └─ una única manga
//               └─ un equipo inscrito por participante
// Los campeonatos ocultos no salen en el selector ni en ningún listado, no
// usan créditos ni tesorería y no se envían a PitWall Manager.

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import '../equipos/repositorio_equipos.dart';
import '../verificaciones/repositorio_verificaciones.dart';

/// Nombre fijo del campeonato contenedor (sale en la cabecera del PDF).
const nombreContenedorVerificacionLibre = 'Verificación libre';

/// Datos editables de una sesión: identificación + reglamento de verificación.
class DatosSesionLibre {
  DatosSesionLibre({
    required this.nombre,
    this.sede,
    this.fecha,
    required this.copas,
    this.anchuraEjeJson = '{}',
    this.pinonDientesMin = 12,
    this.pinonDientesMax = 12,
    this.coronaDientesMin = 24,
    this.coronaDientesMax = 30,
    this.motorSorteoMin,
    this.motorSorteoMax,
  });

  final String nombre;
  final String? sede;
  final DateTime? fecha;
  final List<String> copas;
  final String anchuraEjeJson;
  final int pinonDientesMin;
  final int pinonDientesMax;
  final int coronaDientesMin;
  final int coronaDientesMax;
  final int? motorSorteoMin;
  final int? motorSorteoMax;

  CampeonatosCompanion _reglamento() => CampeonatosCompanion(
        copasJson: Value(json.encode(copas)),
        anchuraEjeJson: Value(anchuraEjeJson),
        pinonDientesMin: Value(pinonDientesMin),
        pinonDientesMax: Value(pinonDientesMax),
        coronaDientesMin: Value(coronaDientesMin),
        coronaDientesMax: Value(coronaDientesMax),
        motorSorteoMin: Value(motorSorteoMin),
        motorSorteoMax: Value(motorSorteoMax),
      );
}

/// Una sesión de verificación libre con sus totales.
class SesionLibre {
  SesionLibre({
    required this.reglamento,
    required this.prueba,
    required this.mangaId,
    required this.participantes,
    required this.conVerificacion,
    required this.validadas,
  });

  /// Campeonato oculto que contiene la sesión (reglamento de verificación).
  final Campeonato reglamento;
  final Prueba prueba;
  final int mangaId;
  final int participantes;
  final int conVerificacion;
  final int validadas;

  String get nombre => prueba.nombre;

  List<String> get copas => copasDeJson(reglamento.copasJson);
}

List<String> copasDeJson(String copasJson) {
  try {
    final raw = json.decode(copasJson);
    if (raw is List) return raw.map((e) => e.toString()).toList();
  } catch (_) {}
  return const [];
}

/// Todas las sesiones, de la más reciente a la más antigua.
final sesionesLibresProvider =
    StreamProvider.autoDispose<List<SesionLibre>>((ref) {
  final db = ref.watch(dbProvider);
  final repo = ref.watch(repoVerificacionLibreProvider);
  return ticksDeCualquiera([
    db.select(db.campeonatos).watch(),
    db.select(db.pruebas).watch(),
    db.select(db.inscripciones).watch(),
    db.select(db.verificaciones).watch(),
  ]).asyncMap((_) => repo.sesiones());
});

/// Una sesión concreta (por id de su prueba); null si ya no existe.
final sesionLibreProvider =
    StreamProvider.autoDispose.family<SesionLibre?, int>((ref, pruebaId) {
  final db = ref.watch(dbProvider);
  final repo = ref.watch(repoVerificacionLibreProvider);
  return ticksDeCualquiera([
    db.select(db.campeonatos).watch(),
    (db.select(db.pruebas)..where((t) => t.id.equals(pruebaId))).watch(),
  ]).asyncMap((_) => repo.cargar(pruebaId));
});

class RepositorioVerificacionLibre {
  RepositorioVerificacionLibre(this.db);
  final AppDatabase db;

  Future<List<SesionLibre>> sesiones() async {
    final contenedores = await (db.select(db.campeonatos)
          ..where((t) => t.esVerificacionLibre.equals(true)))
        .get();
    if (contenedores.isEmpty) return const [];
    final pruebas = await (db.select(db.pruebas)
          ..where((t) =>
              t.campeonatoId.isIn(contenedores.map((c) => c.id).toList())))
        .get();
    final out = <SesionLibre>[];
    for (final p in pruebas) {
      final s = await _sesionDe(
          contenedores.firstWhere((c) => c.id == p.campeonatoId), p);
      if (s != null) out.add(s);
    }
    out.sort((a, b) {
      final fa = a.prueba.fecha ?? a.reglamento.creadoEn;
      final fb = b.prueba.fecha ?? b.reglamento.creadoEn;
      final c = fb.compareTo(fa);
      return c != 0 ? c : b.prueba.id.compareTo(a.prueba.id);
    });
    return out;
  }

  Future<SesionLibre?> cargar(int pruebaId) async {
    final p = await (db.select(db.pruebas)
          ..where((t) => t.id.equals(pruebaId)))
        .getSingleOrNull();
    if (p == null) return null;
    final c = await (db.select(db.campeonatos)
          ..where((t) =>
              t.id.equals(p.campeonatoId) &
              t.esVerificacionLibre.equals(true)))
        .getSingleOrNull();
    if (c == null) return null;
    return _sesionDe(c, p);
  }

  Future<SesionLibre?> _sesionDe(Campeonato c, Prueba p) async {
    final manga = await (db.select(db.mangas)
          ..where((t) => t.pruebaId.equals(p.id))
          ..orderBy([(t) => OrderingTerm.asc(t.id)])
          ..limit(1))
        .getSingleOrNull();
    if (manga == null) return null;
    final inscritos = await (db.select(db.inscripciones)
          ..where((t) => t.mangaId.equals(manga.id)))
        .get();
    final verifs = await (db.select(db.verificaciones)
          ..where((t) => t.mangaId.equals(manga.id)))
        .get();
    final equiposConVerif = verifs.map((v) => v.equipoId).toSet();
    final equiposValidados =
        verifs.where((v) => v.validado).map((v) => v.equipoId).toSet();
    return SesionLibre(
      reglamento: c,
      prueba: p,
      mangaId: manga.id,
      participantes: inscritos.length,
      conVerificacion: equiposConVerif.length,
      validadas: equiposValidados.length,
    );
  }

  /// Valores de partida para una sesión nueva: copia el reglamento de la
  /// última sesión creada (lo habitual es verificar siempre igual); si no
  /// hay ninguna, los valores por defecto de un campeonato.
  Future<DatosSesionLibre> plantillaNueva() async {
    final ultima = await (db.select(db.campeonatos)
          ..where((t) => t.esVerificacionLibre.equals(true))
          ..orderBy([(t) => OrderingTerm.desc(t.id)])
          ..limit(1))
        .getSingleOrNull();
    final hoy = DateTime.now();
    final fecha = DateTime(hoy.year, hoy.month, hoy.day);
    if (ultima == null) {
      return DatosSesionLibre(nombre: '', fecha: fecha, copas: const []);
    }
    return DatosSesionLibre(
      nombre: '',
      fecha: fecha,
      copas: copasDeJson(ultima.copasJson),
      anchuraEjeJson: ultima.anchuraEjeJson,
      pinonDientesMin: ultima.pinonDientesMin,
      pinonDientesMax: ultima.pinonDientesMax,
      coronaDientesMin: ultima.coronaDientesMin,
      coronaDientesMax: ultima.coronaDientesMax,
      motorSorteoMin: ultima.motorSorteoMin,
      motorSorteoMax: ultima.motorSorteoMax,
    );
  }

  /// Crea la sesión (contenedor + prueba + manga). Devuelve el id de la prueba.
  Future<int> crearSesion(DatosSesionLibre d) {
    return db.transaction(() async {
      final campId = await db.into(db.campeonatos).insert(
            CampeonatosCompanion.insert(
              nombre: nombreContenedorVerificacionLibre,
              formato: 'INDIVIDUAL',
              anio: (d.fecha ?? DateTime.now()).year,
              activo: const Value(false),
              usaCreditos: const Value(false),
              usaTesoreria: const Value(false),
              esVerificacionLibre: const Value(true),
            ),
          );
      await (db.update(db.campeonatos)..where((t) => t.id.equals(campId)))
          .write(d._reglamento());
      final pruebaId = await db.into(db.pruebas).insert(
            PruebasCompanion.insert(
              campeonatoId: campId,
              nombre: d.nombre,
              sede: Value(d.sede),
              fecha: Value(d.fecha),
              orden: 1,
              estado: const Value('EN_CURSO'),
            ),
          );
      await db.into(db.mangas).insert(
            MangasCompanion.insert(pruebaId: pruebaId, nombre: 'Verificación'),
          );
      return pruebaId;
    });
  }

  Future<void> actualizarSesion(int pruebaId, DatosSesionLibre d) async {
    final s = await cargar(pruebaId);
    if (s == null) return;
    await db.transaction(() async {
      await (db.update(db.pruebas)..where((t) => t.id.equals(pruebaId)))
          .write(PruebasCompanion(
        nombre: Value(d.nombre),
        sede: Value(d.sede),
        fecha: Value(d.fecha),
      ));
      await (db.update(db.campeonatos)
            ..where((t) => t.id.equals(s.reglamento.id)))
          .write(d._reglamento());
    });
  }

  /// Borra la sesión entera: verificaciones, participantes y contenedor.
  /// Los pilotos (maestro global) se conservan.
  Future<void> borrarSesion(int pruebaId) async {
    final s = await cargar(pruebaId);
    if (s == null) return;
    await db.transaction(() async {
      final mangaIds = (await (db.select(db.mangas)
                ..where((t) => t.pruebaId.equals(pruebaId)))
              .get())
          .map((m) => m.id)
          .toList();
      final equipoIds = (await (db.select(db.equipos)
                ..where((t) => t.campeonatoId.equals(s.reglamento.id)))
              .get())
          .map((e) => e.id)
          .toList();
      await (db.delete(db.verificaciones)
            ..where((t) => t.mangaId.isIn(mangaIds)))
          .go();
      await (db.delete(db.inscripciones)
            ..where((t) => t.mangaId.isIn(mangaIds)))
          .go();
      await (db.delete(db.inscripcionesPrueba)
            ..where((t) => t.pruebaId.equals(pruebaId)))
          .go();
      await (db.delete(db.mangas)..where((t) => t.pruebaId.equals(pruebaId)))
          .go();
      await (db.delete(db.pruebas)..where((t) => t.id.equals(pruebaId))).go();
      await (db.delete(db.equipoPilotos)
            ..where((t) => t.equipoId.isIn(equipoIds)))
          .go();
      await (db.delete(db.equipos)
            ..where((t) => t.campeonatoId.equals(s.reglamento.id)))
          .go();
      await (db.delete(db.campeonatos)
            ..where((t) => t.id.equals(s.reglamento.id)))
          .go();
    });
  }

  /// Da de alta un participante en la sesión y lo deja inscrito en su manga.
  /// Los pilotos se buscan por nombre en el maestro (sin distinguir
  /// mayúsculas) y se crean si no existen. Devuelve el id del equipo.
  Future<int> anadirParticipante({
    required SesionLibre sesion,
    required String piloto1,
    String? piloto2,
    String? equipo,
    required String copa,
  }) {
    return db.transaction(() async {
      final p1 = await _pilotoPorNombre(piloto1);
      final p2 = (piloto2 == null || piloto2.trim().isEmpty)
          ? null
          : await _pilotoPorNombre(piloto2);
      final nombreEquipo = (equipo == null || equipo.trim().isEmpty)
          ? [piloto1.trim(), if (piloto2 != null && piloto2.trim().isNotEmpty) piloto2.trim()]
              .join(' / ')
          : equipo.trim();
      final equipoId = await RepositorioEquipos(db).crearN(
        campeonatoId: sesion.reglamento.id,
        nombre: nombreEquipo,
        copa: copa,
        pilotoIds: [p1, ?p2],
      );
      await db.into(db.inscripcionesPrueba).insert(
            InscripcionesPruebaCompanion.insert(
              pruebaId: sesion.prueba.id,
              equipoId: equipoId,
              asignada: const Value(true),
              copa: Value(copa),
            ),
          );
      await db.into(db.inscripciones).insert(
            InscripcionesCompanion.insert(
                mangaId: sesion.mangaId, equipoId: equipoId),
          );
      return equipoId;
    });
  }

  /// Quita un participante de la sesión junto con su verificación.
  Future<void> quitarParticipante({
    required SesionLibre sesion,
    required int equipoId,
  }) async {
    await db.transaction(() async {
      await (db.delete(db.verificaciones)
            ..where((t) =>
                t.mangaId.equals(sesion.mangaId) & t.equipoId.equals(equipoId)))
          .go();
      await (db.delete(db.inscripciones)
            ..where((t) =>
                t.mangaId.equals(sesion.mangaId) & t.equipoId.equals(equipoId)))
          .go();
      await (db.delete(db.inscripcionesPrueba)
            ..where((t) =>
                t.pruebaId.equals(sesion.prueba.id) &
                t.equipoId.equals(equipoId)))
          .go();
      await (db.delete(db.equipoPilotos)
            ..where((t) => t.equipoId.equals(equipoId)))
          .go();
      // Solo equipos del contenedor: nunca uno de un campeonato real.
      await (db.delete(db.equipos)
            ..where((t) =>
                t.id.equals(equipoId) &
                t.campeonatoId.equals(sesion.reglamento.id)))
          .go();
    });
  }

  Future<int> _pilotoPorNombre(String nombre) async {
    final limpio = nombre.trim();
    final existente = await (db.select(db.pilotos)
          ..where((t) => t.nombre.lower().equals(limpio.toLowerCase()))
          ..limit(1))
        .getSingleOrNull();
    if (existente != null) return existente.id;
    return db
        .into(db.pilotos)
        .insert(PilotosCompanion.insert(nombre: limpio));
  }
}

final repoVerificacionLibreProvider =
    Provider<RepositorioVerificacionLibre>((ref) {
  return RepositorioVerificacionLibre(ref.watch(dbProvider));
});
