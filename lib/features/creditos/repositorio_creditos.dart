import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';

final repoCreditosProvider = Provider<RepositorioCreditos>(
    (ref) => RepositorioCreditos(ref.watch(dbProvider)));

class RepositorioCreditos {
  RepositorioCreditos(this.db);
  final AppDatabase db;

  /// Nº de carreras (pruebas) en las que cada piloto ha competido en el
  /// campeonato: pruebas con al menos un resultado suyo.
  Future<Map<int, int>> carrerasPorPiloto(int campeonatoId) async {
    final pruebas = await (db.select(db.pruebas)
          ..where((t) => t.campeonatoId.equals(campeonatoId)))
        .get();
    final pruebaIds = pruebas.map((p) => p.id).toList();
    if (pruebaIds.isEmpty) return {};
    final mangas = await (db.select(db.mangas)
          ..where((t) => t.pruebaId.isIn(pruebaIds)))
        .get();
    if (mangas.isEmpty) return {};
    final mangaToPrueba = {for (final m in mangas) m.id: m.pruebaId};
    final resultados = await (db.select(db.resultados)
          ..where((t) => t.mangaId.isIn(mangas.map((m) => m.id).toList())))
        .get();
    final pruebasPorPiloto = <int, Set<int>>{};
    for (final r in resultados) {
      final pid = mangaToPrueba[r.mangaId];
      if (pid == null) continue;
      (pruebasPorPiloto[r.pilotoId] ??= {}).add(pid);
    }
    return {
      for (final e in pruebasPorPiloto.entries) e.key: e.value.length,
    };
  }

  /// Bonificación que corresponde a [categoria] con [carreras] disputadas,
  /// según la tabla de bonificación del campeonato (0 si no hay tramo).
  Future<int> bonificacionPara({
    required int campeonatoId,
    required String categoria,
    required int carreras,
  }) async {
    final filas = await (db.select(db.tablaBonificacion)
          ..where((t) =>
              t.campeonatoId.equals(campeonatoId) &
              t.categoria.equals(categoria)))
        .get();
    for (final f in filas) {
      if (carreras >= f.carrerasMin && carreras <= f.carrerasMax) {
        return f.bonificacion;
      }
    }
    return 0;
  }

  /// Aplica la bonificación de cierre del campeonato a los pilotos que aún no
  /// la tengan: saldo = min(actual + bonif(categoria, nº carreras), tope).
  /// El cambio se anota como movimiento. Devuelve el nº de pilotos afectados.
  Future<int> aplicarBonificacionCierre(int campeonatoId) async {
    final camp = await (db.select(db.campeonatos)
          ..where((t) => t.id.equals(campeonatoId)))
        .getSingle();
    final tope = camp.topeRegularizacion;
    final carreras = await carrerasPorPiloto(campeonatoId);
    final perfiles = await (db.select(db.pilotoCampeonato)
          ..where((t) => t.campeonatoId.equals(campeonatoId)))
        .get();

    var aplicados = 0;
    for (final pc in perfiles) {
      if (pc.bonificacionAplicada != 0) continue; // ya aplicada
      final n = carreras[pc.pilotoId] ?? 0;
      if (n == 0) continue; // no compitió: nada que regularizar
      // Categoría tras la revisión de cierre (promoción/descenso); si no se ha
      // revisado, la inicial.
      final categoria = pc.categoriaFinal ?? pc.categoria;
      final bonif = await bonificacionPara(
          campeonatoId: campeonatoId, categoria: categoria, carreras: n);
      final suma = pc.creditosActuales + bonif;
      final nuevo = suma > tope ? tope : suma;
      final delta = nuevo - pc.creditosActuales;

      await (db.update(db.pilotoCampeonato)
            ..where((t) =>
                t.pilotoId.equals(pc.pilotoId) &
                t.campeonatoId.equals(campeonatoId)))
          .write(PilotoCampeonatoCompanion(
            creditosActuales: Value(nuevo),
            bonificacionAplicada: Value(bonif == 0 ? -1 : bonif),
          ));
      // Registrar siempre el movimiento de cierre (aunque el tope deje delta
      // en 0), indicando claramente de qué bonificación se trata.
      final carrerasTxt = n == 1 ? '1 carrera' : '$n carreras';
      final motivo = suma > tope
          ? 'Bonificación de cierre por $carrerasTxt ($categoria): '
              '+$bonif, limitado al tope $tope'
          : 'Bonificación de cierre por $carrerasTxt ($categoria): +$bonif';
      await db.into(db.movimientosCreditos).insert(
            MovimientosCreditosCompanion.insert(
              pilotoId: pc.pilotoId,
              campeonatoId: campeonatoId,
              delta: delta,
              saldoResultante: nuevo,
              motivo: motivo,
            ),
          );
      aplicados++;
    }
    return aplicados;
  }

  /// CSV con el estado de créditos del campeonato: piloto, categoría, carreras,
  /// inicial, usados, actual.
  Future<String> exportarCsv(int campeonatoId) async {
    final carreras = await carrerasPorPiloto(campeonatoId);
    final perfiles = await (db.select(db.pilotoCampeonato)
          ..where((t) => t.campeonatoId.equals(campeonatoId)))
        .get();
    final pilotos = {
      for (final p in await db.select(db.pilotos).get()) p.id: p,
    };
    final filas = <List<String>>[
      [
        'Piloto',
        'Categoria',
        'Categoria cierre',
        'Carreras',
        'Iniciales',
        'Usados',
        'Actuales',
      ],
    ];
    final ordenadas = perfiles
        .where((pc) => pilotos[pc.pilotoId] != null)
        .toList()
      ..sort((a, b) => (pilotos[a.pilotoId]!.nombre)
          .toLowerCase()
          .compareTo(pilotos[b.pilotoId]!.nombre.toLowerCase()));
    for (final pc in ordenadas) {
      final nombre = pilotos[pc.pilotoId]!.nombre;
      filas.add([
        nombre,
        pc.categoria,
        pc.categoriaFinal ?? pc.categoria,
        '${carreras[pc.pilotoId] ?? 0}',
        '${pc.creditosIniciales}',
        '${pc.creditosIniciales - pc.creditosActuales}',
        '${pc.creditosActuales}',
      ]);
    }
    return filas.map(_filaCsv).join('\r\n');
  }

  String _filaCsv(List<String> campos) =>
      campos.map((c) => '"${c.replaceAll('"', '""')}"').join(',');

  /// Importa los pilotos de un campeonato finalizado a [destinoId], usando su
  /// saldo de cierre como créditos iniciales del nuevo campeonato. Conserva la
  /// categoría y guarda el saldo de origen en saldoTemporadaAnterior.
  /// Devuelve el nº de pilotos importados (no duplica los ya presentes).
  Future<int> importarDesdeCampeonato({
    required int origenId,
    required int destinoId,
  }) async {
    final origen = await (db.select(db.pilotoCampeonato)
          ..where((t) => t.campeonatoId.equals(origenId)))
        .get();
    final yaPresentes = (await (db.select(db.pilotoCampeonato)
              ..where((t) => t.campeonatoId.equals(destinoId)))
            .get())
        .map((p) => p.pilotoId)
        .toSet();

    var importados = 0;
    for (final pc in origen) {
      if (yaPresentes.contains(pc.pilotoId)) continue;
      final saldoCierre = pc.creditosActuales;
      await db.into(db.pilotoCampeonato).insert(
            PilotoCampeonatoCompanion.insert(
              pilotoId: pc.pilotoId,
              campeonatoId: destinoId,
              // La categoría de cierre (promoción/descenso) pasa a ser la
              // inicial del nuevo campeonato.
              categoria: pc.categoriaFinal ?? pc.categoria,
              creditosIniciales: saldoCierre,
              creditosActuales: saldoCierre,
              saldoTemporadaAnterior: Value(saldoCierre),
            ),
          );
      importados++;
    }
    return importados;
  }
}
