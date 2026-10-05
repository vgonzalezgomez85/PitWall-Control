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
  /// Marcado a mano como "Coord. total" en esta prueba: no paga.
  final bool exentoCoordinadora;
  /// Manga en la que corre el equipo (null si aún no está asignado).
  final String? mangaNombre;

  PagoEquipo({
    required this.equipoId,
    required this.nombreEquipo,
    required this.copa,
    required this.piloto1,
    this.piloto2,
    this.pago,
    this.wildcard = false,
    this.exentoCoordinadora = false,
    this.mangaNombre,
  });

  String get pilotosTexto => piloto2 == null
      ? piloto1.nombre
      : '${piloto1.nombre} + ${piloto2!.nombre}';

  /// Número de pilotos que son coordinadora.
  int get coordinadorasCount =>
      (piloto1.esCoordinadora ? 1 : 0) +
      ((piloto2?.esCoordinadora ?? false) ? 1 : 0);

  int get totalPilotos => piloto2 == null ? 1 : 2;

  /// TODOS los pilotos del equipo tienen la marca de coordinadora en su ficha.
  bool get todosCoordinadora =>
      coordinadorasCount > 0 && coordinadorasCount == totalPilotos;

  /// Equipo totalmente exento: wildcard, marcado "Coord. total" en esta
  /// prueba, o TODOS sus pilotos son coordinadora.
  bool get exento => wildcard || exentoCoordinadora || todosCoordinadora;

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
    if (exentoCoordinadora || todosCoordinadora) {
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
  /// Un equipo exento no aporta nada aunque le quede un pago antiguo.
  double get total => exento ? 0 : (pago?.pagat ?? 0);

  bool get hayPago => pago != null && total > 0;

  /// Ya no se le debe nada: ha pagado o está exento.
  bool get saldado => exento || hayPago;
}

/// Resumen por prueba con totales.
class ResumenPruebaPagos {
  final Prueba prueba;
  final int totalEquipos;
  /// Equipos que han pagado (los exentos van aparte).
  final int pagados;
  /// Equipos que no pagan (wildcard o coordinadora).
  final int exentos;
  final double sumaTotal;
  final double sumaPagat;
  final double sumaCoordinadora;
  final double sumaClub;

  ResumenPruebaPagos({
    required this.prueba,
    required this.totalEquipos,
    required this.pagados,
    required this.exentos,
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
      // Mismo cálculo que la pantalla de la prueba: solo cuentan los pagos
      // de equipos inscritos y que no estén exentos.
      final lista = await _construir(db, p.id, inscritos);
      double pagat = 0, coord = 0, club = 0;
      for (final pe in lista) {
        if (pe.exento || pe.pago == null) continue;
        pagat += pe.pago!.pagat;
        coord += pe.pago!.coordinadora;
        club += pe.pago!.club;
      }
      out.add(ResumenPruebaPagos(
        prueba: p,
        totalEquipos: lista.length,
        pagados: lista.where((pe) => pe.hayPago).length,
        exentos: lista.where((pe) => pe.exento).length,
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
    // Exención por pilotos de coordinadora.
    db.select(db.pilotos).watch(),
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
    // El orden depende de la manga asignada a cada equipo.
    (db.select(db.mangas)..where((t) => t.pruebaId.equals(pruebaId))).watch(),
    db.select(db.inscripciones).watch(),
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
    // Manga en la que corre cada equipo, para ordenar por día de carrera.
    final mangas = await (db.select(db.mangas)
          ..where((t) => t.pruebaId.equals(pruebaId)))
        .get();
    final mangaPorId = {for (final m in mangas) m.id: m};
    final insMangas = mangas.isEmpty
        ? <Inscripcione>[]
        : await (db.select(db.inscripciones)
              ..where((t) => t.mangaId.isIn(mangaPorId.keys.toList())))
            .get();
    final mangaDeEquipo = <int, Manga>{};
    for (final i in insMangas) {
      final m = mangaPorId[i.mangaId];
      if (m != null) mangaDeEquipo.putIfAbsent(i.equipoId, () => m);
    }

    final out = <PagoEquipo>[];
    final clave = <int, num>{};
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
      final manga = mangaDeEquipo[eq.id];
      clave[eq.id] = _claveOrdenManga(manga);
      out.add(PagoEquipo(
        equipoId: eq.id,
        nombreEquipo: eq.nombre,
        copa: i.copa ?? eq.copa,
        piloto1: p1,
        piloto2: p2,
        pago: pago,
        wildcard: i.wildcard,
        exentoCoordinadora: i.exentoCoordinadora,
        mangaNombre: manga?.nombre,
      ));
    }
    // Orden: día/hora de la manga (sin manga al final); desempate por nombre.
    out.sort((a, b) {
      final c = clave[a.equipoId]!.compareTo(clave[b.equipoId]!);
      return c != 0 ? c : a.nombreEquipo.compareTo(b.nombreEquipo);
    });
    return out;
}

/// Clave de orden de una manga: día de la semana (por el nombre) y hora
/// (de `fechaHora` o del propio nombre, p. ej. "Jueves 21:00").
/// Equipos sin manga van al final.
num _claveOrdenManga(Manga? m) {
  if (m == null) return double.maxFinite;
  final nombre = m.nombre
      .toLowerCase()
      .replaceAll(RegExp(r'[áàä]'), 'a')
      .replaceAll(RegExp(r'[éèë]'), 'e')
      .replaceAll(RegExp(r'[íìï]'), 'i')
      .replaceAll(RegExp(r'[óòö]'), 'o')
      .replaceAll(RegExp(r'[úùü]'), 'u');
  const dias = ['lunes', 'martes', 'miercoles', 'jueves',
      'viernes', 'sabado', 'domingo'];
  var dia = dias.length; // sin día reconocido: tras los días conocidos
  for (var i = 0; i < dias.length; i++) {
    if (nombre.contains(dias[i])) {
      dia = i;
      break;
    }
  }
  var minutos = 0;
  if (m.fechaHora != null) {
    minutos = m.fechaHora!.hour * 60 + m.fechaHora!.minute;
  } else {
    final hm = RegExp(r'(\d{1,2})[:.h](\d{2})').firstMatch(nombre);
    if (hm != null) {
      minutos = int.parse(hm.group(1)!) * 60 + int.parse(hm.group(2)!);
    }
  }
  return dia * 10000 + minutos;
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

  /// Borra el pago de un equipo en una prueba, si lo hay.
  Future<void> borrarDe({required int pruebaId, required int equipoId}) async {
    await (db.delete(db.pagos)
          ..where((t) =>
              t.pruebaId.equals(pruebaId) & t.equipoId.equals(equipoId)))
        .go();
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

  /// Marca un equipo como "Coord. total" (no paga) en una prueba.
  Future<void> marcarCoordinadora({
    required int pruebaId,
    required int equipoId,
    required bool exento,
  }) async {
    await (db.update(db.inscripcionesPrueba)
          ..where((t) =>
              t.pruebaId.equals(pruebaId) & t.equipoId.equals(equipoId)))
        .write(InscripcionesPruebaCompanion(
            exentoCoordinadora: Value(exento)));
    // Igual que el wildcard: si pasa a exento, fuera el pago que hubiera.
    if (exento) {
      await (db.delete(db.pagos)
            ..where((t) =>
                t.pruebaId.equals(pruebaId) & t.equipoId.equals(equipoId)))
          .go();
    }
  }

  /// Cambia el reparto de la cuota de un campeonato (PAGAT y su desglose
  /// coordinadora/club). Si [recalcularPagos], los pagos ya registrados en
  /// sus pruebas se vuelven a desglosar con la nueva proporción (se respeta
  /// lo que pagó cada equipo; solo cambia cuánto va a cada lado).
  /// Devuelve cuántos pagos se recalcularon.
  Future<int> guardarReparto({
    required int campeonatoId,
    required double pagat,
    required double coordinadora,
    required double club,
    bool recalcularPagos = false,
  }) async {
    return db.transaction(() async {
      await (db.update(db.campeonatos)
            ..where((t) => t.id.equals(campeonatoId)))
          .write(CampeonatosCompanion(
        cuotaPagat: Value(pagat),
        cuotaCoordinadora: Value(coordinadora),
        cuotaClub: Value(club),
      ));
      if (!recalcularPagos) return 0;
      final idsPruebas = await (db.selectOnly(db.pruebas)
            ..addColumns([db.pruebas.id])
            ..where(db.pruebas.campeonatoId.equals(campeonatoId)))
          .map((r) => r.read(db.pruebas.id)!)
          .get();
      if (idsPruebas.isEmpty) return 0;
      final pagos = await (db.select(db.pagos)
            ..where((t) => t.pruebaId.isIn(idsPruebas)))
          .get();
      var n = 0;
      for (final pg in pagos) {
        if (pg.pagat <= 0) continue;
        final (c, cl) = repartir(pg.pagat,
            cuotaCoordinadora: coordinadora, cuotaClub: club);
        if (c == pg.coordinadora && cl == pg.club) continue;
        await (db.update(db.pagos)..where((t) => t.id.equals(pg.id))).write(
            PagosCompanion(coordinadora: Value(c), club: Value(cl)));
        n++;
      }
      return n;
    });
  }
}

/// Reparte un importe pagado entre coordinadora y club con la misma
/// proporción que la cuota del campeonato. Redondea a céntimos y deja el
/// resto en el club para que la suma cuadre siempre con [importe].
(double, double) repartir(
  double importe, {
  required double cuotaCoordinadora,
  required double cuotaClub,
}) {
  final base = cuotaCoordinadora + cuotaClub;
  if (importe <= 0) return (0, 0);
  // Sin reparto configurado: todo al club.
  if (base <= 0) return (0, importe);
  final coord = (importe * cuotaCoordinadora / base * 100).round() / 100;
  final club = ((importe - coord) * 100).round() / 100;
  return (coord, club);
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
