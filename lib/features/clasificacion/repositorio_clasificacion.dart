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
import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import '../../domain/calculo_clasificacion.dart';

class DatosClasificacion {
  final List<Prueba> pruebas;
  final List<FilaClasificacion> filas;
  /// Clasificación independiente por copa: en cada prueba los puntos se
  /// recalculan SOLO entre los equipos de esa copa (copa → filas).
  final Map<String, List<FilaClasificacion>> porCopa;
  /// true cuando el campeonato está cerrado y se ordena por puntos NETOS;
  /// false durante la temporada (orden por BRUTOS).
  final bool ordenadoPorNeto;

  DatosClasificacion({
    required this.pruebas,
    required this.filas,
    this.porCopa = const {},
    this.ordenadoPorNeto = false,
  });
}

/// Stream que recalcula la clasificación cuando cambia cualquier resultado,
/// inscripción a campeonato, prueba o ajuste de campeonato.
final clasificacionProvider =
    StreamProvider.autoDispose<DatosClasificacion>((ref) async* {
  final db = ref.watch(dbProvider);
  final activo = ref.watch(campeonatoActivoProvider);
  if (activo == null) {
    yield DatosClasificacion(pruebas: const [], filas: const []);
    return;
  }

  // Combinamos varios streams en uno
  await for (final _ in _streamRefresco(db, activo.id)) {
    final pruebas = await (db.select(db.pruebas)
          ..where((t) => t.campeonatoId.equals(activo.id))
          ..orderBy([(t) => OrderingTerm.asc(t.orden)]))
        .get();
    final pruebaIds = pruebas.map((p) => p.id).toSet();

    // Pilotos inscritos en este campeonato
    final perfiles = await (db.select(db.pilotoCampeonato)
          ..where((t) => t.campeonatoId.equals(activo.id)))
        .get();

    // Equipos del campeonato para mapear piloto → equipo + copa
    final equipos = await (db.select(db.equipos)
          ..where((t) => t.campeonatoId.equals(activo.id)))
        .get();
    final equipoIdsCamp = equipos.map((e) => e.id).toSet();
    // Miembros de cada equipo (unión): incluye equipos de N pilotos.
    final unionMiembros = equipoIdsCamp.isEmpty
        ? <EquipoPiloto>[]
        : await (db.select(db.equipoPilotos)
              ..where((t) => t.equipoId.isIn(equipoIdsCamp.toList()))
              ..orderBy([(t) => OrderingTerm.asc(t.orden)]))
            .get();
    final miembrosPorEquipo = <int, List<int>>{};
    for (final m in unionMiembros) {
      (miembrosPorEquipo[m.equipoId] ??= []).add(m.pilotoId);
    }

    // Equipos con al menos una inscripción a alguna prueba del campeonato.
    final inscripcionesPrueba = pruebaIds.isEmpty
        ? <InscripcionesPruebaData>[]
        : await (db.select(db.inscripcionesPrueba)
              ..where((t) => t.pruebaId.isIn(pruebaIds)))
            .get();
    final equiposParticipantes =
        inscripcionesPrueba.map((i) => i.equipoId).toSet();

    // Mapa piloto → equipo. Un piloto puede estar en varios equipos (p. ej.
    // distintas copas); preferimos el equipo que PARTICIPA (tiene inscripción)
    // para que no se le excluya de la clasificación.
    final equipoPorPiloto = <int, Equipo>{};
    void asignarEquipo(int pilotoId, Equipo e) {
      final actual = equipoPorPiloto[pilotoId];
      if (actual == null) {
        equipoPorPiloto[pilotoId] = e;
        return;
      }
      final actualParticipa = equiposParticipantes.contains(actual.id);
      final nuevoParticipa = equiposParticipantes.contains(e.id);
      if (nuevoParticipa && !actualParticipa) equipoPorPiloto[pilotoId] = e;
    }

    for (final e in equipos) {
      // Todos los miembros del equipo (unión); si no hay, cae a piloto1/2.
      final ids = miembrosPorEquipo[e.id] ??
          [e.piloto1Id, if (e.piloto2Id != null) e.piloto2Id!];
      for (final pid in ids) {
        asignarEquipo(pid, e);
      }
    }

    final (porPiloto: byPiloto, disputadas: disputadas) =
        await resultadosPorPiloto(db, pruebaIds);

    // Nombre de cada piloto
    final pilotos = await db.select(db.pilotos).get();
    final nombrePorId = {for (final p in pilotos) p.id: p.nombre};

    // Copa a mostrar en la general: la de la última prueba (por orden) que ha
    // corrido el equipo según su inscripción; si no la fijó, la del equipo.
    final ordenPrueba = {for (final p in pruebas) p.id: p.orden};
    final copaGeneral = <int, (int, String)>{};
    for (final ins in inscripcionesPrueba) {
      final c = ins.copa;
      if (c == null || c.isEmpty) continue;
      final orden = ordenPrueba[ins.pruebaId] ?? 0;
      final previa = copaGeneral[ins.equipoId];
      if (previa == null || orden >= previa.$1) {
        copaGeneral[ins.equipoId] = (orden, c);
      }
    }

    final bases = <dynamic>[];
    for (final pf in perfiles) {
      final eq = equipoPorPiloto[pf.pilotoId];
      // Solo entran: pilotos con equipo cuyo equipo ha participado en alguna
      // prueba del campeonato (vía inscripcionesPrueba).
      if (eq == null) continue;
      if (!equiposParticipantes.contains(eq.id)) continue;
      bases.add(PilotoBase.crear(
        pilotoId: pf.pilotoId,
        nombre: nombrePorId[pf.pilotoId] ?? 'Piloto ${pf.pilotoId}',
        equipoId: eq.id,
        equipoNombre: eq.nombre,
        copa: copaGeneral[eq.id]?.$2 ?? eq.copa,
        categoria: pf.categoria,
        creditosIniciales: pf.creditosIniciales,
        creditosActuales: pf.creditosActuales,
      ));
    }

    // Durante la temporada se ordena por puntos brutos; cuando la ÚLTIMA
    // prueba del campeonato (mayor orden, no cancelada) está terminada,
    // se ordena por netos (los descartes ya son definitivos).
    final noCanceladas =
        pruebas.where((p) => p.estado != 'CANCELADA').toList();
    final campeonatoCerrado = activo.finalizado ||
        (noCanceladas.isNotEmpty && noCanceladas.last.estado == 'TERMINADA');

    final filas = CalculoClasificacion.calcular(
      pilotos: bases.cast(),
      resultadosPorPiloto: byPiloto,
      numDescartes: activo.numDescartes,
      pruebasDisputadas: disputadas,
      ordenarPorNeto: campeonatoCerrado,
    );

    // ===== Clasificaciones independientes por copa =====
    // Cada equipo tiene una copa (por prueba: snapshot en inscripciones; si
    // falta, la copa actual). En cada prueba se RECALCULAN los puntos solo
    // entre los equipos de esa copa: 1º de la copa = puntos máximos de la
    // tabla. Los dos pilotos de un equipo comparten puntos.
    final tp = await (db.select(db.tablaPuntos)
          ..where((t) => t.campeonatoId.equals(activo.id)))
        .get();
    final puntosPos = {for (final r in tp) r.posicion: r.puntos};
    int puntosDe(int pos) => puntosPos[pos] ?? 0;

    // Correcciones manuales por copa (prevalecen sobre el re-ranking).
    final overrides = await (db.select(db.overridesCopa)
          ..where((t) => t.campeonatoId.equals(activo.id)))
        .get();
    final overridesPorCopa = <String, List<OverridesCopaData>>{};
    for (final o in overrides) {
      (overridesPorCopa[o.copa] ??= []).add(o);
    }

    final equipoActualCopa = {for (final e in equipos) e.id: e.copa};
    final copaEnPrueba = <int, Map<int, String>>{};
    for (final ins in inscripcionesPrueba) {
      final c = ins.copa ?? equipoActualCopa[ins.equipoId];
      if (c == null) continue;
      (copaEnPrueba[ins.equipoId] ??= {})[ins.pruebaId] = c;
    }
    String copaDe(int equipoId, int pruebaId) =>
        copaEnPrueba[equipoId]?[pruebaId] ?? equipoActualCopa[equipoId] ?? '';

    final copas = <String>{
      ...equipoActualCopa.values,
      for (final m in copaEnPrueba.values) ...m.values,
      ...overridesPorCopa.keys,
    };

    final porCopa = <String, List<FilaClasificacion>>{};
    for (final copa in copas) {
      final byCopa = <int, FilaResultados>{};
      final miembros = <int>{};
      final disputadasCopa = <int>{};

      for (final p in pruebas) {
        // Puntos del equipo en P (los pilotos del equipo comparten resultado),
        // solo equipos que corrieron P EN esta copa.
        final puntosEquipo = <int, int>{};
        for (final b in bases) {
          final pid = b.pilotoId as int;
          final eqId = b.equipoId as int;
          if (copaDe(eqId, p.id) != copa) continue;
          final pts = byPiloto[pid]?.puntosPorPrueba[p.id];
          if (pts == null) continue;
          puntosEquipo[eqId] =
              puntosEquipo.containsKey(eqId) && puntosEquipo[eqId]! >= pts
                  ? puntosEquipo[eqId]!
                  : pts;
        }
        if (puntosEquipo.isEmpty) continue;
        disputadasCopa.add(p.id);
        // Ranking de competición por equipo: empatados comparten puntos.
        final copaPtsEquipo = <int, int>{};
        for (final eqId in puntosEquipo.keys) {
          final mejores =
              puntosEquipo.values.where((v) => v > puntosEquipo[eqId]!).length;
          copaPtsEquipo[eqId] = puntosDe(mejores + 1);
        }
        // Asignar a cada piloto los puntos de copa de su equipo.
        for (final b in bases) {
          final pid = b.pilotoId as int;
          final eqId = b.equipoId as int;
          if (copaDe(eqId, p.id) != copa) continue;
          if (!copaPtsEquipo.containsKey(eqId)) continue;
          (byCopa[pid] ??= FilaResultados(
                  {}, {...?byPiloto[pid]?.aRestarPorPrueba}))
              .puntosPorPrueba[p.id] = copaPtsEquipo[eqId]!;
          miembros.add(pid);
        }
      }
      // Correcciones manuales: prevalecen sobre el re-ranking automático.
      for (final o in overridesPorCopa[copa] ?? const []) {
        (byCopa[o.pilotoId] ??= FilaResultados(
                {}, {...?byPiloto[o.pilotoId]?.aRestarPorPrueba}))
            .puntosPorPrueba[o.pruebaId] = o.puntos;
        miembros.add(o.pilotoId);
        disputadasCopa.add(o.pruebaId);
      }
      if (miembros.isEmpty) continue;
      // En la pestaña de una copa, la columna Copa es esa copa (el piloto puede
      // haber corrido otras pruebas en otra copa).
      final pilotosCopa = bases
          .where((b) => miembros.contains(b.pilotoId as int))
          .map((b) => PilotoBase(
                pilotoId: b.pilotoId as int,
                nombre: b.nombre as String,
                equipoId: b.equipoId as int,
                equipoNombre: b.equipoNombre as String,
                copa: copa,
                categoria: b.categoria as String,
                creditosIniciales: b.creditosIniciales as int,
                creditosActuales: b.creditosActuales as int,
              ))
          .toList();
      porCopa[copa] = CalculoClasificacion.calcular(
        pilotos: pilotosCopa.cast(),
        resultadosPorPiloto: byCopa,
        numDescartes: activo.numDescartes,
        pruebasDisputadas: disputadasCopa,
        ordenarPorNeto: campeonatoCerrado,
      );
    }

    yield DatosClasificacion(
      pruebas: pruebas,
      filas: filas,
      porCopa: porCopa,
      ordenadoPorNeto: campeonatoCerrado,
    );
  }
});

/// Puntos de cada piloto por prueba (pilotoId → prueba → puntos y "a restar")
/// y las pruebas ya disputadas (con algún resultado: en ellas un piloto sin
/// puntos cuenta 0, su peor resultado → descarte).
/// Las mangas reales se suman; la manga "IMPORTADA" (canal de edición manual)
/// PISA el total de la prueba en vez de sumarse.
Future<({Map<int, FilaResultados> porPiloto, Set<int> disputadas})>
    resultadosPorPiloto(AppDatabase db, Set<int> pruebaIds) async {
  final mangas = pruebaIds.isEmpty
      ? <Manga>[]
      : await (db.select(db.mangas)..where((t) => t.pruebaId.isIn(pruebaIds)))
          .get();
  final pruebaPorManga = {for (final m in mangas) m.id: m.pruebaId};
  final importadaIds =
      mangas.where((m) => m.nombre == 'IMPORTADA').map((m) => m.id).toSet();
  final resultados = pruebaPorManga.isEmpty
      ? <Resultado>[]
      : await (db.select(db.resultados)
            ..where((t) => t.mangaId.isIn(pruebaPorManga.keys)))
          .get();

  final disputadas = <int>{};
  for (final r in resultados) {
    final pid = pruebaPorManga[r.mangaId];
    if (pid != null) disputadas.add(pid);
  }

  final porPiloto = <int, FilaResultados>{};
  for (final r in resultados) {
    if (importadaIds.contains(r.mangaId)) continue;
    final pruebaId = pruebaPorManga[r.mangaId];
    if (pruebaId == null) continue;
    final f = porPiloto.putIfAbsent(r.pilotoId, () => FilaResultados({}, {}));
    f.puntosPorPrueba
        .update(pruebaId, (v) => v + r.puntos, ifAbsent: () => r.puntos);
    f.aRestarPorPrueba
        .update(pruebaId, (v) => v + r.aRestar, ifAbsent: () => r.aRestar);
  }
  for (final r in resultados) {
    if (!importadaIds.contains(r.mangaId)) continue;
    final pruebaId = pruebaPorManga[r.mangaId];
    if (pruebaId == null) continue;
    final f = porPiloto.putIfAbsent(r.pilotoId, () => FilaResultados({}, {}));
    f.puntosPorPrueba[pruebaId] = r.puntos; // override manual
  }
  return (porPiloto: porPiloto, disputadas: disputadas);
}

/// Puntos NETOS (con descartes) de cada piloto que ha puntuado en el
/// campeonato: los de su clasificación general. Se usan para ordenar la
/// primera prueba del campeonato siguiente.
Future<Map<int, int>> puntosNetosPorPiloto(
    AppDatabase db, int campeonatoId) async {
  final camp = await (db.select(db.campeonatos)
        ..where((t) => t.id.equals(campeonatoId)))
      .getSingleOrNull();
  if (camp == null) return {};
  final pruebas = await (db.select(db.pruebas)
        ..where((t) => t.campeonatoId.equals(campeonatoId)))
      .get();
  final (:porPiloto, :disputadas) =
      await resultadosPorPiloto(db, pruebas.map((p) => p.id).toSet());
  final filas = CalculoClasificacion.calcular(
    pilotos: [
      for (final id in porPiloto.keys)
        PilotoBase(
          pilotoId: id,
          nombre: '',
          equipoId: 0,
          equipoNombre: '',
          copa: '',
          categoria: '',
          creditosIniciales: 0,
          creditosActuales: 0,
        ),
    ],
    resultadosPorPiloto: porPiloto,
    numDescartes: camp.numDescartes,
    pruebasDisputadas: disputadas,
    ordenarPorNeto: true,
  );
  return {for (final f in filas) f.pilotoId: f.totalNeto};
}

/// Combina los streams relevantes en un único tick.
Stream<void> _streamRefresco(AppDatabase db, int campeonatoId) async* {
  final s1 = db.select(db.resultados).watch();
  final s2 = (db.select(db.pruebas)
        ..where((t) => t.campeonatoId.equals(campeonatoId)))
      .watch();
  final s3 = (db.select(db.pilotoCampeonato)
        ..where((t) => t.campeonatoId.equals(campeonatoId)))
      .watch();
  final s4 = (db.select(db.equipos)
        ..where((t) => t.campeonatoId.equals(campeonatoId)))
      .watch();
  final s5 = db.select(db.inscripcionesPrueba).watch();
  // Emitir un primer tick y después cualquier cambio
  yield null;
  await for (final _ in _mergeAny([s1, s2, s3, s4, s5])) {
    yield null;
  }
}

Stream<void> _mergeAny(List<Stream> streams) async* {
  final ctrl = StreamController<void>();
  final subs = streams
      .map((s) => s.listen((_) => ctrl.add(null), onError: ctrl.addError))
      .toList();
  ctrl.onCancel = () async {
    for (final s in subs) {
      await s.cancel();
    }
  };
  yield* ctrl.stream;
}
