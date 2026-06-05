import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';

const estadosPrueba = ['PROGRAMADA', 'EN_CURSO', 'TERMINADA', 'CANCELADA'];

String etiquetaEstado(String e) => switch (e) {
      'PROGRAMADA' => 'Programada',
      'EN_CURSO' => 'En curso',
      'TERMINADA' => 'Terminada',
      'CANCELADA' => 'Cancelada',
      _ => e,
    };

// ============== PRUEBAS ==============

final pruebasCampeonatoProvider =
    StreamProvider.autoDispose<List<Prueba>>((ref) {
  final db = ref.watch(dbProvider);
  final activo = ref.watch(campeonatoActivoProvider);
  if (activo == null) return Stream.value([]);

  return (db.select(db.pruebas)
        ..where((t) => t.campeonatoId.equals(activo.id))
        ..orderBy([
          (t) => OrderingTerm.asc(t.orden),
          (t) => OrderingTerm.asc(t.fecha),
        ]))
      .watch();
});

class RepositorioPruebas {
  RepositorioPruebas(this.db);
  final AppDatabase db;

  Future<int> crear({
    required int campeonatoId,
    required String nombre,
    String? sede,
    DateTime? fecha,
    required int orden,
  }) {
    return db.into(db.pruebas).insert(
          PruebasCompanion.insert(
            campeonatoId: campeonatoId,
            nombre: nombre,
            sede: Value(sede),
            fecha: Value(fecha),
            orden: orden,
          ),
        );
  }

  Future<void> actualizar({
    required int id,
    required String nombre,
    String? sede,
    DateTime? fecha,
    required int orden,
    required String estado,
  }) async {
    await (db.update(db.pruebas)..where((t) => t.id.equals(id))).write(
      PruebasCompanion(
        nombre: Value(nombre),
        sede: Value(sede),
        fecha: Value(fecha),
        orden: Value(orden),
        estado: Value(estado),
      ),
    );
  }

  Future<void> borrar(int id) async {
    await (db.delete(db.pruebas)..where((t) => t.id.equals(id))).go();
  }

  Future<int> siguienteOrden(int campeonatoId) async {
    final filas = await (db.selectOnly(db.pruebas)
          ..addColumns([db.pruebas.orden.max()])
          ..where(db.pruebas.campeonatoId.equals(campeonatoId)))
        .get();
    final maxOrd = filas.first.read(db.pruebas.orden.max());
    return (maxOrd ?? 0) + 1;
  }
}

final repoPruebasProvider = Provider<RepositorioPruebas>((ref) {
  return RepositorioPruebas(ref.watch(dbProvider));
});

// ============== MANGAS ==============

final mangasPruebaProvider =
    StreamProvider.autoDispose.family<List<Manga>, int>((ref, pruebaId) {
  final db = ref.watch(dbProvider);
  return (db.select(db.mangas)
        ..where((t) => t.pruebaId.equals(pruebaId))
        ..orderBy([
          (t) => OrderingTerm.asc(t.fechaHora),
          (t) => OrderingTerm.asc(t.id),
        ]))
      .watch();
});

class RepositorioMangas {
  RepositorioMangas(this.db);
  final AppDatabase db;

  Future<int> crear({
    required int pruebaId,
    required String nombre,
    DateTime? fechaHora,
    int numCarriles = 8,
  }) {
    return db.into(db.mangas).insert(
          MangasCompanion.insert(
            pruebaId: pruebaId,
            nombre: nombre,
            fechaHora: Value(fechaHora),
            numCarriles: Value(numCarriles),
          ),
        );
  }

  Future<void> actualizar({
    required int id,
    required String nombre,
    DateTime? fechaHora,
    required int numCarriles,
    required String estado,
  }) async {
    await (db.update(db.mangas)..where((t) => t.id.equals(id))).write(
      MangasCompanion(
        nombre: Value(nombre),
        fechaHora: Value(fechaHora),
        numCarriles: Value(numCarriles),
        estado: Value(estado),
      ),
    );
  }

  Future<void> borrar(int id) async {
    await (db.delete(db.mangas)..where((t) => t.id.equals(id))).go();
  }
}

final repoMangasProvider = Provider<RepositorioMangas>((ref) {
  return RepositorioMangas(ref.watch(dbProvider));
});

// ============== INSCRIPCIONES ==============

class InscripcionConEquipo {
  final Inscripcione inscripcion;
  final Equipo equipo;
  final Piloto piloto1;
  final Piloto? piloto2;

  InscripcionConEquipo({
    required this.inscripcion,
    required this.equipo,
    required this.piloto1,
    this.piloto2,
  });

  String get nombreEquipo => equipo.nombre;
  String get pilotos => piloto2 == null
      ? piloto1.nombre
      : '${piloto1.nombre} + ${piloto2!.nombre}';
}

final inscripcionesMangaProvider = StreamProvider.autoDispose
    .family<List<InscripcionConEquipo>, int>((ref, mangaId) {
  final db = ref.watch(dbProvider);
  return (db.select(db.inscripciones)
        ..where((t) => t.mangaId.equals(mangaId)))
      .watch()
      .asyncMap((lista) async {
    final out = <InscripcionConEquipo>[];
    for (final i in lista) {
      final eq = await (db.select(db.equipos)
            ..where((t) => t.id.equals(i.equipoId)))
          .getSingle();
      final p1 = await (db.select(db.pilotos)
            ..where((t) => t.id.equals(eq.piloto1Id)))
          .getSingle();
      Piloto? p2;
      if (eq.piloto2Id != null) {
        p2 = await (db.select(db.pilotos)
              ..where((t) => t.id.equals(eq.piloto2Id!)))
            .getSingleOrNull();
      }
      out.add(InscripcionConEquipo(
        inscripcion: i, equipo: eq, piloto1: p1, piloto2: p2,
      ));
    }
    // Ordenar por carril (D1-D4 primero, luego numéricos)
    out.sort((a, b) {
      final ca = a.inscripcion.carrilSalida ?? '';
      final cb = b.inscripcion.carrilSalida ?? '';
      return _ordenCarril(ca).compareTo(_ordenCarril(cb));
    });
    return out;
  });
});

int _ordenCarril(String c) {
  if (c.isEmpty) return 9999;
  if (c.startsWith('D')) {
    return int.tryParse(c.substring(1)) ?? 9000;
  }
  return 100 + (int.tryParse(c) ?? 99);
}

class RepositorioInscripciones {
  RepositorioInscripciones(this.db);
  final AppDatabase db;

  Future<int> inscribir({
    required int mangaId,
    required int equipoId,
    String? carrilSalida,
    bool seedDirecto = false,
  }) {
    return db.into(db.inscripciones).insert(
          InscripcionesCompanion.insert(
            mangaId: mangaId,
            equipoId: equipoId,
            carrilSalida: Value(carrilSalida),
            seedDirecto: Value(seedDirecto),
          ),
        );
  }

  Future<void> cambiarCarril({
    required int inscripcionId,
    String? carrilSalida,
    bool? seedDirecto,
  }) async {
    final companion = seedDirecto == null
        ? InscripcionesCompanion(carrilSalida: Value(carrilSalida))
        : InscripcionesCompanion(
            carrilSalida: Value(carrilSalida),
            seedDirecto: Value(seedDirecto),
          );
    await (db.update(db.inscripciones)
          ..where((t) => t.id.equals(inscripcionId)))
        .write(companion);
  }

  Future<void> quitar(int inscripcionId) async {
    await (db.delete(db.inscripciones)
          ..where((t) => t.id.equals(inscripcionId)))
        .go();
  }
}

final repoInscripcionesProvider = Provider<RepositorioInscripciones>((ref) {
  return RepositorioInscripciones(ref.watch(dbProvider));
});
