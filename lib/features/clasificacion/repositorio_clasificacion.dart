import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import '../../domain/calculo_clasificacion.dart';

class DatosClasificacion {
  final List<Prueba> pruebas;
  final List<FilaClasificacion> filas;
  /// true cuando el campeonato está cerrado y se ordena por puntos NETOS;
  /// false durante la temporada (orden por BRUTOS).
  final bool ordenadoPorNeto;

  DatosClasificacion({
    required this.pruebas,
    required this.filas,
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
    final equipoPorPiloto = <int, Equipo>{};
    for (final e in equipos) {
      equipoPorPiloto[e.piloto1Id] = e;
      if (e.piloto2Id != null) equipoPorPiloto[e.piloto2Id!] = e;
    }

    // Equipos con al menos una inscripción a alguna prueba del campeonato.
    final inscripcionesPrueba = pruebaIds.isEmpty
        ? <InscripcionesPruebaData>[]
        : await (db.select(db.inscripcionesPrueba)
              ..where((t) => t.pruebaId.isIn(pruebaIds)))
            .get();
    final equiposParticipantes =
        inscripcionesPrueba.map((i) => i.equipoId).toSet();

    // Resultados de todas las mangas de las pruebas del campeonato
    final mangasCamp = await (db.select(db.mangas)
          ..where((t) => t.pruebaId.isIn(pruebaIds)))
        .get();
    final pruebaPorManga = {for (final m in mangasCamp) m.id: m.pruebaId};
    final mangaIds = mangasCamp.map((m) => m.id).toSet();
    final resultados = await (db.select(db.resultados)
          ..where((t) => t.mangaId.isIn(mangaIds)))
        .get();

    // Agrupar resultados por pilotoId → prueba → (puntos, aRestar)
    final byPiloto = <int, FilaResultados>{};
    for (final r in resultados) {
      final pruebaId = pruebaPorManga[r.mangaId];
      if (pruebaId == null) continue;
      final f = byPiloto.putIfAbsent(
          r.pilotoId, () => FilaResultados({}, {}));
      f.puntosPorPrueba
          .update(pruebaId, (v) => v + r.puntos, ifAbsent: () => r.puntos);
      f.aRestarPorPrueba
          .update(pruebaId, (v) => v + r.aRestar, ifAbsent: () => r.aRestar);
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
    final campeonatoCerrado =
        noCanceladas.isNotEmpty && noCanceladas.last.estado == 'TERMINADA';

    final filas = CalculoClasificacion.calcular(
      pilotos: bases.cast(),
      resultadosPorPiloto: byPiloto,
      numDescartes: activo.numDescartes,
      ordenarPorNeto: campeonatoCerrado,
    );
    yield DatosClasificacion(
      pruebas: pruebas,
      filas: filas,
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
