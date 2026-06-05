import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';

/// Combina varios streams en uno: emite un tick cuando cualquiera emite.
Stream<void> _mergeTick(List<Stream> streams) {
  final ctrl = StreamController<void>.broadcast();
  final subs = <StreamSubscription>[];
  for (final s in streams) {
    subs.add(s.listen((_) => ctrl.add(null), onError: ctrl.addError));
  }
  ctrl.onCancel = () async {
    for (final sub in subs) {
      await sub.cancel();
    }
  };
  return ctrl.stream;
}

/// Pago enriquecido con datos del equipo.
class PagoEquipo {
  final int equipoId;
  final String nombreEquipo;
  final String copa;
  final Piloto piloto1;
  final Piloto? piloto2;
  Pago? pago;
  /// El equipo es wildcard (invitado) en esta prueba.
  final bool wildcard;

  PagoEquipo({
    required this.equipoId,
    required this.nombreEquipo,
    required this.copa,
    required this.piloto1,
    this.piloto2,
    this.pago,
    this.wildcard = false,
  });

  String get pilotosTexto => piloto2 == null
      ? piloto1.nombre
      : '${piloto1.nombre} + ${piloto2!.nombre}';

  /// Número de pilotos que son coordinadora.
  int get coordinadorasCount =>
      (piloto1.esCoordinadora ? 1 : 0) +
      ((piloto2?.esCoordinadora ?? false) ? 1 : 0);

  int get totalPilotos => piloto2 == null ? 1 : 2;

  /// Equipo totalmente exento (wildcard, o TODOS sus pilotos son coordinadora).
  bool get exento =>
      wildcard || (coordinadorasCount > 0 && coordinadorasCount == totalPilotos);

  /// Paga la mitad (un piloto es coordinadora, otro no).
  bool get pagaMitad =>
      !exento && coordinadorasCount > 0 && coordinadorasCount < totalPilotos;

  /// Factor multiplicador sobre la cuota completa.
  /// 0 = exento, 0.5 = mitad, 1 = entero.
  double get factorPago {
    if (exento) return 0;
    if (pagaMitad) return 0.5;
    return 1.0;
  }

  String? get motivoExencion {
    if (wildcard) return 'Wildcard';
    if (coordinadorasCount > 0 && coordinadorasCount == totalPilotos) {
      return 'Pilotos de coordinadora';
    }
    return null;
  }

  String? get notaMitad {
    if (!pagaMitad) return null;
    final c = piloto1.esCoordinadora ? piloto1.nombre : piloto2!.nombre;
    return 'Paga mitad — $c es de coordinadora';
  }

  /// Total = PAGAT (los campos coordinadora y club son el desglose de PAGAT).
  double get total => pago?.pagat ?? 0;

  bool get hayPago => pago != null && total > 0;
}

/// Resumen por prueba con totales.
class ResumenPruebaPagos {
  final Prueba prueba;
  final int totalEquipos;
  final int pagados;
  final double sumaTotal;
  final double sumaPagat;
  final double sumaCoordinadora;
  final double sumaClub;

  ResumenPruebaPagos({
    required this.prueba,
    required this.totalEquipos,
    required this.pagados,
    required this.sumaTotal,
    required this.sumaPagat,
    required this.sumaCoordinadora,
    required this.sumaClub,
  });
}

/// Resumen de tesorería del campeonato (lista de pruebas con totales).
/// Se refresca cuando cambian pruebas, inscripciones a prueba o pagos.
final tesoreriaCampeonatoProvider =
    StreamProvider.autoDispose<List<ResumenPruebaPagos>>((ref) {
  final db = ref.watch(dbProvider);
  final activo = ref.watch(campeonatoActivoProvider);
  if (activo == null) return Stream.value([]);

  Future<List<ResumenPruebaPagos>> calcular() async {
    final pruebas = await (db.select(db.pruebas)
          ..where((t) => t.campeonatoId.equals(activo.id))
          ..orderBy([(t) => OrderingTerm.asc(t.orden)]))
        .get();
    final out = <ResumenPruebaPagos>[];
    for (final p in pruebas) {
      final inscritos = await (db.select(db.inscripcionesPrueba)
            ..where((t) => t.pruebaId.equals(p.id)))
          .get();
      final pagos = await (db.select(db.pagos)
            ..where((t) => t.pruebaId.equals(p.id)))
          .get();
      double pagat = 0, coord = 0, club = 0;
      for (final pg in pagos) {
        pagat += pg.pagat;
        coord += pg.coordinadora;
        club += pg.club;
      }
      out.add(ResumenPruebaPagos(
        prueba: p,
        totalEquipos: inscritos.length,
        pagados: pagos.where((pg) => pg.pagat > 0).length,
        sumaTotal: pagat,
        sumaPagat: pagat,
        sumaCoordinadora: coord,
        sumaClub: club,
      ));
    }
    return out;
  }

  // Streams que disparan recálculo
  final triggers = _mergeTick([
    (db.select(db.pruebas)
          ..where((t) => t.campeonatoId.equals(activo.id)))
        .watch(),
    db.select(db.pagos).watch(),
    db.select(db.inscripcionesPrueba).watch(),
  ]);

  late StreamController<List<ResumenPruebaPagos>> ctrl;
  StreamSubscription? sub;
  ctrl = StreamController<List<ResumenPruebaPagos>>(
    onListen: () {
      // Emisión inicial
      calcular().then((v) {
        if (!ctrl.isClosed) ctrl.add(v);
      });
      sub = triggers.listen((_) {
        calcular().then((v) {
          if (!ctrl.isClosed) ctrl.add(v);
        });
      });
    },
    onCancel: () async {
      await sub?.cancel();
    },
  );
  ref.onDispose(() => ctrl.close());
  return ctrl.stream;
});

/// Lista de pagos (uno por equipo inscrito) de una prueba.
/// Se refresca cuando cambian las inscripciones, los pagos o los pilotos
/// (por si cambia el flag de coordinadora).
final pagosPruebaProvider = StreamProvider.autoDispose
    .family<List<PagoEquipo>, int>((ref, pruebaId) {
  final db = ref.watch(dbProvider);

  Future<List<PagoEquipo>> calcular() async {
    final inscritos = await (db.select(db.inscripcionesPrueba)
          ..where((t) => t.pruebaId.equals(pruebaId)))
        .get();
    return _construir(db, pruebaId, inscritos);
  }

  final triggers = _mergeTick([
    (db.select(db.inscripcionesPrueba)
          ..where((t) => t.pruebaId.equals(pruebaId)))
        .watch(),
    (db.select(db.pagos)..where((t) => t.pruebaId.equals(pruebaId)))
        .watch(),
    db.select(db.pilotos).watch(),
  ]);

  late StreamController<List<PagoEquipo>> ctrl;
  StreamSubscription? sub;
  ctrl = StreamController<List<PagoEquipo>>(
    onListen: () {
      calcular().then((v) {
        if (!ctrl.isClosed) ctrl.add(v);
      });
      sub = triggers.listen((_) {
        calcular().then((v) {
          if (!ctrl.isClosed) ctrl.add(v);
        });
      });
    },
    onCancel: () async {
      await sub?.cancel();
    },
  );
  ref.onDispose(() => ctrl.close());
  return ctrl.stream;
});

Future<List<PagoEquipo>> _construir(AppDatabase db, int pruebaId,
    List<InscripcionesPruebaData> inscritos) async {
    final out = <PagoEquipo>[];
    for (final i in inscritos) {
      final eq = await (db.select(db.equipos)
            ..where((t) => t.id.equals(i.equipoId)))
          .getSingle();
      final p1 = await (db.select(db.pilotos)
            ..where((t) => t.id.equals(eq.piloto1Id)))
          .getSingle();
      Piloto? p2;
      if (eq.piloto2Id != null) {
        final pid2 = eq.piloto2Id!;
        p2 = await (db.select(db.pilotos)
              ..where((t) => t.id.equals(pid2)))
            .getSingleOrNull();
      }
      final pago = await (db.select(db.pagos)
            ..where((t) =>
                t.pruebaId.equals(pruebaId) & t.equipoId.equals(eq.id)))
          .getSingleOrNull();
      out.add(PagoEquipo(
        equipoId: eq.id,
        nombreEquipo: eq.nombre,
        copa: eq.copa,
        piloto1: p1,
        piloto2: p2,
        pago: pago,
        wildcard: i.wildcard,
      ));
    }
    out.sort((a, b) => a.nombreEquipo.compareTo(b.nombreEquipo));
    return out;
}

class RepositorioTesoreria {
  RepositorioTesoreria(this.db);
  final AppDatabase db;

  Future<void> guardarPago({
    int? id,
    required int pruebaId,
    required int equipoId,
    double pagat = 0,
    double coordinadora = 0,
    double club = 0,
    String? observaciones,
    DateTime? fecha,
  }) async {
    if (id == null) {
      // ¿Ya existe uno para este (prueba, equipo)?
      final existente = await (db.select(db.pagos)
            ..where((t) =>
                t.pruebaId.equals(pruebaId) & t.equipoId.equals(equipoId)))
          .getSingleOrNull();
      if (existente != null) id = existente.id;
    }
    if (id == null) {
      await db.into(db.pagos).insert(PagosCompanion.insert(
            pruebaId: pruebaId,
            equipoId: equipoId,
            pagat: Value(pagat),
            coordinadora: Value(coordinadora),
            club: Value(club),
            observaciones: Value(observaciones),
            fecha: fecha == null ? const Value.absent() : Value(fecha),
          ));
    } else {
      await (db.update(db.pagos)..where((t) => t.id.equals(id!))).write(
        PagosCompanion(
          pagat: Value(pagat),
          coordinadora: Value(coordinadora),
          club: Value(club),
          observaciones: Value(observaciones),
          fecha: fecha == null ? const Value.absent() : Value(fecha),
        ),
      );
    }
  }

  Future<void> borrar(int id) async {
    await (db.delete(db.pagos)..where((t) => t.id.equals(id))).go();
  }

  /// Marca un equipo como wildcard (no paga) en una prueba.
  Future<void> marcarWildcard({
    required int pruebaId,
    required int equipoId,
    required bool wildcard,
  }) async {
    await (db.update(db.inscripcionesPrueba)
          ..where((t) =>
              t.pruebaId.equals(pruebaId) & t.equipoId.equals(equipoId)))
        .write(InscripcionesPruebaCompanion(
            wildcard: Value(wildcard)));
    // Si pasa a wildcard, borrar cualquier pago existente
    if (wildcard) {
      await (db.delete(db.pagos)
            ..where((t) =>
                t.pruebaId.equals(pruebaId) & t.equipoId.equals(equipoId)))
          .go();
    }
  }
}

final repoTesoreriaProvider = Provider<RepositorioTesoreria>((ref) {
  return RepositorioTesoreria(ref.watch(dbProvider));
});

// ============================================================
// Movimientos extra (ingresos/gastos sueltos)
// ============================================================

/// Movimientos del campeonato activo (todos, con o sin prueba).
final movimientosCampeonatoProvider =
    StreamProvider.autoDispose<List<MovimientosTesoreriaData>>((ref) {
  final db = ref.watch(dbProvider);
  final activo = ref.watch(campeonatoActivoProvider);
  if (activo == null) return Stream.value([]);
  return (db.select(db.movimientosTesoreria)
        ..where((t) => t.campeonatoId.equals(activo.id))
        ..orderBy([(t) => OrderingTerm.desc(t.fecha)]))
      .watch();
});

/// Movimientos de una prueba concreta.
final movimientosPruebaProvider = StreamProvider.autoDispose
    .family<List<MovimientosTesoreriaData>, int>((ref, pruebaId) {
  final db = ref.watch(dbProvider);
  return (db.select(db.movimientosTesoreria)
        ..where((t) => t.pruebaId.equals(pruebaId))
        ..orderBy([(t) => OrderingTerm.desc(t.fecha)]))
      .watch();
});

extension RepositorioMovimientos on RepositorioTesoreria {
  Future<int> crearMovimiento({
    required int campeonatoId,
    int? pruebaId,
    required String concepto,
    required double importe,
    String? notas,
    DateTime? fecha,
  }) {
    return db.into(db.movimientosTesoreria).insert(
          MovimientosTesoreriaCompanion.insert(
            campeonatoId: campeonatoId,
            pruebaId: Value(pruebaId),
            concepto: concepto,
            importe: importe,
            notas: Value(notas),
            fecha: fecha == null ? const Value.absent() : Value(fecha),
          ),
        );
  }

  Future<void> actualizarMovimiento(
    int id, {
    required String concepto,
    required double importe,
    String? notas,
  }) async {
    await (db.update(db.movimientosTesoreria)..where((t) => t.id.equals(id)))
        .write(MovimientosTesoreriaCompanion(
      concepto: Value(concepto),
      importe: Value(importe),
      notas: Value(notas),
    ));
  }

  Future<void> borrarMovimiento(int id) async {
    await (db.delete(db.movimientosTesoreria)..where((t) => t.id.equals(id)))
        .go();
  }
}
