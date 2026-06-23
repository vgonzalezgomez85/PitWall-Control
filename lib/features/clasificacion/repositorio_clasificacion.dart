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
      asignarEquipo(e.piloto1Id, e);
      if (e.piloto2Id != null) asignarEquipo(e.piloto2Id!, e);
    }

    // Resultados de todas las mangas de las pruebas del campeonato
    final mangasCamp = await (db.select(db.mangas)
          ..where((t) => t.pruebaId.isIn(pruebaIds)))
        .get();
    final pruebaPorManga = {for (final m in mangasCamp) m.id: m.pruebaId};
    final mangaIds = mangasCamp.map((m) => m.id).toSet();
    // Mangas "IMPORTADA": canal de edición manual. Su valor PISA (override) el
    // de la prueba en vez de sumarse a los resultados de las mangas reales.
    final importadaIds = mangasCamp
        .where((m) => m.nombre == 'IMPORTADA')
        .map((m) => m.id)
        .toSet();
    final resultados = await (db.select(db.resultados)
          ..where((t) => t.mangaId.isIn(mangaIds)))
        .get();

    // Pruebas ya disputadas: las que tienen algún resultado registrado. En
    // ellas, un piloto sin puntos cuenta 0 (su peor resultado → descarte).
    final disputadas = <int>{};
    for (final r in resultados) {
      final pid = pruebaPorManga[r.mangaId];
      if (pid != null) disputadas.add(pid);
    }

    // Agrupar resultados por pilotoId → prueba → (puntos, aRestar).
    // 1) Mangas reales: se suman. 2) Manga IMPORTADA: pisa el total.
    final byPiloto = <int, FilaResultados>{};
    for (final r in resultados) {
      if (importadaIds.contains(r.mangaId)) continue;
      final pruebaId = pruebaPorManga[r.mangaId];
      if (pruebaId == null) continue;
      final f = byPiloto.putIfAbsent(
          r.pilotoId, () => FilaResultados({}, {}));
      f.puntosPorPrueba
          .update(pruebaId, (v) => v + r.puntos, ifAbsent: () => r.puntos);
      f.aRestarPorPrueba
          .update(pruebaId, (v) => v + r.aRestar, ifAbsent: () => r.aRestar);
    }
    for (final r in resultados) {
      if (!importadaIds.contains(r.mangaId)) continue;
      final pruebaId = pruebaPorManga[r.mangaId];
      if (pruebaId == null) continue;
      final f = byPiloto.putIfAbsent(
          r.pilotoId, () => FilaResultados({}, {}));
      f.puntosPorPrueba[pruebaId] = r.puntos; // override manual
    }

    // Nombre de cada piloto
    final pilotos = await db.select(db.pilotos).get();
    final nombrePorId = {for (final p in pilotos) p.id: p.nombre};

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
        copa: eq.copa,
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
      final pilotosCopa = bases.where((b) => miembros.contains(b.pilotoId as int)).toList();
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
