import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';

/// Categorías ordenadas de mayor a menor nivel.
const categorias = ['PLATINO', 'ORO', 'PLATA', 'BRONCE'];

/// Créditos iniciales sugeridos por categoría (mismo valor que bonif. 7 carreras).
const creditosInicialesPorCategoria = {
  'PLATINO': 12,
  'ORO': 14,
  'PLATA': 20,
  'BRONCE': 28,
};

/// Vista enriquecida: piloto + su perfil en un campeonato.
class PilotoConPerfil {
  final Piloto piloto;
  final PilotoCampeonatoData? perfil;

  PilotoConPerfil(this.piloto, this.perfil);
}

/// Stream de pilotos del campeonato activo (solo los inscritos en él).
final pilotosCampeonatoProvider =
    StreamProvider.autoDispose<List<PilotoConPerfil>>((ref) {
  final db = ref.watch(dbProvider);
  final activo = ref.watch(campeonatoActivoProvider);
  if (activo == null) return Stream.value([]);

  final query = db.select(db.pilotos).join([
    leftOuterJoin(
      db.pilotoCampeonato,
      db.pilotoCampeonato.pilotoId.equalsExp(db.pilotos.id) &
          db.pilotoCampeonato.campeonatoId.equals(activo.id),
    ),
  ]);

  return query.watch().map((rows) {
    final out = <PilotoConPerfil>[];
    for (final row in rows) {
      final p = row.readTable(db.pilotos);
      final perfil = row.readTableOrNull(db.pilotoCampeonato);
      // Solo mostrar pilotos inscritos en este campeonato
      if (perfil != null) out.add(PilotoConPerfil(p, perfil));
    }
    out.sort((a, b) => a.piloto.nombre.compareTo(b.piloto.nombre));
    return out;
  });
});

/// Todos los pilotos del maestro (para buscar/añadir).
final todosLosPilotosProvider =
    StreamProvider.autoDispose<List<Piloto>>((ref) {
  final db = ref.watch(dbProvider);
  return (db.select(db.pilotos)..orderBy([(t) => OrderingTerm.asc(t.nombre)]))
      .watch();
});

class RepositorioPilotos {
  RepositorioPilotos(this.db);
  final AppDatabase db;

  /// Crea un piloto nuevo y lo inscribe en el campeonato indicado.
  Future<int> crear({
    required String nombre,
    String? palmaresGlobal,
    String? telefono,
    String? email,
    required int campeonatoId,
    required String categoria,
    required int creditosIniciales,
    int? creditosActuales,
    String? palmaresLocal,
  }) async {
    return db.transaction(() async {
      final id = await db.into(db.pilotos).insert(
            PilotosCompanion.insert(
              nombre: nombre,
              palmaresGlobal: Value(palmaresGlobal),
              telefono: Value(telefono),
              email: Value(email),
            ),
          );
      await db.into(db.pilotoCampeonato).insert(
            PilotoCampeonatoCompanion.insert(
              pilotoId: id,
              campeonatoId: campeonatoId,
              categoria: categoria,
              creditosIniciales: creditosIniciales,
              creditosActuales: creditosActuales ?? creditosIniciales,
              palmaresLocal: Value(palmaresLocal),
            ),
          );
      return id;
    });
  }

  /// Actualiza datos del piloto y de su perfil en el campeonato.
  Future<void> actualizar({
    required int pilotoId,
    required int campeonatoId,
    required String nombre,
    String? palmaresGlobal,
    String? telefono,
    String? email,
    required String categoria,
    required int creditosIniciales,
    required int creditosActuales,
    String? palmaresLocal,
  }) async {
    await db.transaction(() async {
      await (db.update(db.pilotos)..where((t) => t.id.equals(pilotoId))).write(
        PilotosCompanion(
          nombre: Value(nombre),
          palmaresGlobal: Value(palmaresGlobal),
          telefono: Value(telefono),
          email: Value(email),
        ),
      );
      await (db.update(db.pilotoCampeonato)
            ..where((t) =>
                t.pilotoId.equals(pilotoId) &
                t.campeonatoId.equals(campeonatoId)))
          .write(
        PilotoCampeonatoCompanion(
          categoria: Value(categoria),
          creditosIniciales: Value(creditosIniciales),
          creditosActuales: Value(creditosActuales),
          palmaresLocal: Value(palmaresLocal),
        ),
      );
    });
  }

  /// Inscribe un piloto existente en otro campeonato.
  Future<void> inscribirEnCampeonato({
    required int pilotoId,
    required int campeonatoId,
    required String categoria,
    required int creditosIniciales,
  }) async {
    await db.into(db.pilotoCampeonato).insert(
          PilotoCampeonatoCompanion.insert(
            pilotoId: pilotoId,
            campeonatoId: campeonatoId,
            categoria: categoria,
            creditosIniciales: creditosIniciales,
            creditosActuales: creditosIniciales,
          ),
        );
  }

  /// Quita un piloto de un campeonato (no lo borra del maestro).
  Future<void> quitarDeCampeonato({
    required int pilotoId,
    required int campeonatoId,
  }) async {
    await (db.delete(db.pilotoCampeonato)
          ..where((t) =>
              t.pilotoId.equals(pilotoId) &
              t.campeonatoId.equals(campeonatoId)))
        .go();
  }
}

final repoPilotosProvider = Provider<RepositorioPilotos>((ref) {
  return RepositorioPilotos(ref.watch(dbProvider));
});
