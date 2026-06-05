import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';

/// Verificación enriquecida (con datos del equipo y coche).
class VerificacionConEquipo {
  final Verificacione? verificacion;
  final Equipo equipo;
  final Piloto piloto1;
  final Piloto? piloto2;
  final CatalogoCoche? coche;

  VerificacionConEquipo({
    this.verificacion,
    required this.equipo,
    required this.piloto1,
    this.piloto2,
    this.coche,
  });

  String get pilotosTexto => piloto2 == null
      ? piloto1.nombre
      : '${piloto1.nombre} + ${piloto2!.nombre}';

  bool get tieneVerificacion => verificacion != null;
  bool get validada => verificacion?.validado ?? false;
}

/// Una verificación por cada equipo inscrito en la manga.
final verificacionesMangaProvider = StreamProvider.autoDispose
    .family<List<VerificacionConEquipo>, int>((ref, mangaId) {
  final db = ref.watch(dbProvider);
  return (db.select(db.inscripciones)
        ..where((t) => t.mangaId.equals(mangaId)))
      .watch()
      .asyncMap((inscritos) async {
    final out = <VerificacionConEquipo>[];
    for (final i in inscritos) {
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
      final ver = await (db.select(db.verificaciones)
            ..where((t) =>
                t.mangaId.equals(mangaId) & t.equipoId.equals(eq.id)))
          .getSingleOrNull();
      CatalogoCoche? coche;
      if (ver?.cocheCatalogoId != null) {
        coche = await (db.select(db.catalogoCoches)
              ..where((t) => t.id.equals(ver!.cocheCatalogoId!)))
            .getSingleOrNull();
      }
      out.add(VerificacionConEquipo(
        verificacion: ver,
        equipo: eq, piloto1: p1, piloto2: p2, coche: coche,
      ));
    }
    out.sort((a, b) => a.equipo.nombre.compareTo(b.equipo.nombre));
    return out;
  });
});

/// Catálogo de marcas del componente (códigos).
final marcasCodigosProvider = FutureProvider<Set<String>>((ref) async {
  final db = ref.watch(dbProvider);
  final lista = await db.select(db.catalogoMarcas).get();
  return lista.map((m) => m.codigo).toSet();
});

final llantasDelProvider = FutureProvider<List<CatalogoLlanta>>((ref) async {
  final db = ref.watch(dbProvider);
  return (db.select(db.catalogoLlantas)
        ..where((t) => t.tipo.equals('DELANTERA')))
      .get();
});
final llantasTraProvider = FutureProvider<List<CatalogoLlanta>>((ref) async {
  final db = ref.watch(dbProvider);
  return (db.select(db.catalogoLlantas)
        ..where((t) => t.tipo.equals('TRASERA')))
      .get();
});
/// Bancadas filtradas por la copa del equipo (parámetro `copa`).
/// Si el catálogo tiene copas marcadas, solo se devuelven las que aplican
/// a esa copa. Si no tiene copas marcadas, vale para todas.
final bancadasFiltradasProvider =
    FutureProvider.family<List<CatalogoBancada>, String?>((ref, copa) async {
  final db = ref.watch(dbProvider);
  final todas = await db.select(db.catalogoBancadas).get();
  if (copa == null || copa.isEmpty) return todas;
  return todas.where((b) => _aplicaA(b.copasJson, copa)).toList();
});
final bancadasProvider = FutureProvider<List<CatalogoBancada>>((ref) async {
  final db = ref.watch(dbProvider);
  return db.select(db.catalogoBancadas).get();
});

bool _aplicaA(String copasJson, String copa) {
  try {
    final raw = (copasJson.isEmpty) ? [] : (jsonDecode(copasJson) as List?);
    if (raw == null || raw.isEmpty) return true; // sin marca = aplica a todas
    return raw.map((e) => e.toString()).contains(copa);
  } catch (_) {
    return true;
  }
}
final neumaticosProvider =
    FutureProvider<List<CatalogoNeumatico>>((ref) async {
  final db = ref.watch(dbProvider);
  return db.select(db.catalogoNeumaticos).get();
});
final cochesProvider =
    FutureProvider<List<CatalogoCoche>>((ref) async {
  final db = ref.watch(dbProvider);
  return (db.select(db.catalogoCoches)..where((t) => t.activo.equals(true)))
      .get();
});

/// Chasis filtrados por la copa del equipo.
final chasisFiltradosProvider =
    FutureProvider.family<List<CatalogoChasi>, String?>((ref, copa) async {
  final db = ref.watch(dbProvider);
  final todos = await db.select(db.catalogoChasis).get();
  if (copa == null || copa.isEmpty) return todos;
  return todos.where((c) => _aplicaA(c.copasJson, copa)).toList();
});

/// Coches filtrados por la copa del equipo.
final cochesFiltradosProvider =
    FutureProvider.family<List<CatalogoCoche>, String?>((ref, copa) async {
  final db = ref.watch(dbProvider);
  final todos = await (db.select(db.catalogoCoches)
        ..where((t) => t.activo.equals(true)))
      .get();
  if (copa == null || copa.isEmpty) return todos;
  return todos.where((c) => _aplicaA(c.copasJson, copa)).toList();
});

/// Resultado del cálculo de reparto de créditos.
/// `delta1` y `delta2` son los créditos que se SUMAN al piloto (positivos = gana,
/// negativos = pierde). El reparto es a partes iguales; si `valor` es impar,
/// p1 lleva 1 más.
class RepartoCreditos {
  final int delta1;
  final int delta2;
  final bool insuficiente;
  const RepartoCreditos(this.delta1, this.delta2, {this.insuficiente = false});
}

/// Reparte `valor` créditos del coche entre los dos pilotos.
///   - valor > 0 → los pilotos GANAN créditos. No hay restricción.
///   - valor < 0 → los pilotos PIERDEN. Si uno no llega a su mitad, paga lo
///     que tenga y el otro cubre el resto. Si ni con la suma llegan, queda
///     `insuficiente=true` y se descuenta solo lo posible.
RepartoCreditos repartirCreditos({
  required int valor,
  required int disp1,
  required int? disp2,
}) {
  if (valor == 0) return const RepartoCreditos(0, 0);

  // Caso individual: todo va al único piloto.
  if (disp2 == null) {
    if (valor > 0) return RepartoCreditos(valor, 0);
    // valor < 0: descontar hasta donde tenga.
    if (disp1 >= -valor) return RepartoCreditos(valor, 0);
    return RepartoCreditos(-disp1, 0, insuficiente: true);
  }

  // Reparto equitativo (p1 lleva el impar).
  final absVal = valor.abs();
  final m2 = absVal ~/ 2;
  final m1 = absVal - m2;

  if (valor > 0) {
    // Suma: sin restricciones.
    return RepartoCreditos(m1, m2);
  }

  // valor < 0: descuento con restricción de saldo.
  var p1 = m1, p2 = m2;
  if (disp1 < p1) {
    final faltan = p1 - disp1;
    p1 = disp1;
    p2 = m2 + faltan;
  } else if (disp2 < p2) {
    final faltan = p2 - disp2;
    p2 = disp2;
    p1 = m1 + faltan;
  }
  if (p1 > disp1) p1 = disp1;
  if (p2 > disp2) p2 = disp2;
  final ins = (p1 + p2) < absVal;
  return RepartoCreditos(-p1, -p2, insuficiente: ins);
}

class RepositorioVerificaciones {
  RepositorioVerificaciones(this.db);
  final AppDatabase db;

  Future<int?> _campeonatoIdDeManga(int mangaId) async {
    final m = await (db.select(db.mangas)..where((t) => t.id.equals(mangaId)))
        .getSingleOrNull();
    if (m == null) return null;
    final p = await (db.select(db.pruebas)
          ..where((t) => t.id.equals(m.pruebaId)))
        .getSingleOrNull();
    return p?.campeonatoId;
  }

  Future<void> _sumarCreditos(
    int pilotoId,
    int campeonatoId,
    int delta, {
    int? verificacionId,
    int? equipoId,
    int? pruebaId,
    required String motivo,
  }) async {
    final pc = await (db.select(db.pilotoCampeonato)
          ..where((t) =>
              t.pilotoId.equals(pilotoId) &
              t.campeonatoId.equals(campeonatoId)))
        .getSingleOrNull();
    if (pc == null) return;
    final nuevo = pc.creditosActuales + delta;
    await (db.update(db.pilotoCampeonato)
          ..where((t) =>
              t.pilotoId.equals(pilotoId) &
              t.campeonatoId.equals(campeonatoId)))
        .write(PilotoCampeonatoCompanion(creditosActuales: Value(nuevo)));
    await db.into(db.movimientosCreditos).insert(
          MovimientosCreditosCompanion.insert(
            pilotoId: pilotoId,
            campeonatoId: campeonatoId,
            verificacionId: Value(verificacionId),
            equipoId: Value(equipoId),
            pruebaId: Value(pruebaId),
            delta: delta,
            saldoResultante: nuevo,
            motivo: motivo,
          ),
        );
  }

  /// Devuelve los créditos que la verificación tenía aplicados y aplica un
  /// nuevo descuento si toca (validada + coche con créditos). Persiste lo
  /// aplicado en la propia verificación para poder revertirlo después.
  Future<({int p1, int p2, bool insuficiente})> _reaplicarCreditos(
      int verificacionId) async {
    final ver = await (db.select(db.verificaciones)
          ..where((t) => t.id.equals(verificacionId)))
        .getSingle();
    final eq = await (db.select(db.equipos)
          ..where((t) => t.id.equals(ver.equipoId)))
        .getSingle();
    final campId = await _campeonatoIdDeManga(ver.mangaId);
    if (campId == null) {
      return (p1: 0, p2: 0, insuficiente: false);
    }
    final camp = await (db.select(db.campeonatos)
          ..where((t) => t.id.equals(campId)))
        .getSingle();
    final manga = await (db.select(db.mangas)
          ..where((t) => t.id.equals(ver.mangaId)))
        .getSingle();
    final pruebaId = manga.pruebaId;

    // 1) Revertir lo aplicado previamente (delta firmado: revertimos con -delta).
    if (ver.credAplicadoP1 != 0) {
      await _sumarCreditos(eq.piloto1Id, campId, -ver.credAplicadoP1,
          verificacionId: verificacionId,
          equipoId: eq.id,
          pruebaId: pruebaId,
          motivo: 'Reversión (verificación modificada)');
    }
    if (ver.credAplicadoP2 != 0 && eq.piloto2Id != null) {
      await _sumarCreditos(eq.piloto2Id!, campId, -ver.credAplicadoP2,
          verificacionId: verificacionId,
          equipoId: eq.id,
          pruebaId: pruebaId,
          motivo: 'Reversión (verificación modificada)');
    }

    int aplicarP1 = 0, aplicarP2 = 0;
    bool insuf = false;
    if (camp.usaCreditos && ver.validado && ver.cocheCatalogoId != null) {
      final coche = await (db.select(db.catalogoCoches)
            ..where((t) => t.id.equals(ver.cocheCatalogoId!)))
          .getSingleOrNull();
      final valor = coche?.creditosCoche ?? 0;
      if (valor != 0) {
        final pc1 = await (db.select(db.pilotoCampeonato)
              ..where((t) =>
                  t.pilotoId.equals(eq.piloto1Id) &
                  t.campeonatoId.equals(campId)))
            .getSingleOrNull();
        PilotoCampeonatoData? pc2;
        if (eq.piloto2Id != null) {
          pc2 = await (db.select(db.pilotoCampeonato)
                ..where((t) =>
                    t.pilotoId.equals(eq.piloto2Id!) &
                    t.campeonatoId.equals(campId)))
              .getSingleOrNull();
        }
        final disp1 = pc1?.creditosActuales ?? 0;
        final disp2 =
            eq.piloto2Id == null ? null : (pc2?.creditosActuales ?? 0);
        final r =
            repartirCreditos(valor: valor, disp1: disp1, disp2: disp2);
        aplicarP1 = r.delta1;
        aplicarP2 = r.delta2;
        insuf = r.insuficiente;
        // Nombres legibles para el motivo del movimiento.
        final p1Nom = (await (db.select(db.pilotos)
                  ..where((t) => t.id.equals(eq.piloto1Id)))
                .getSingleOrNull())
            ?.nombre;
        String? p2Nom;
        if (eq.piloto2Id != null) {
          p2Nom = (await (db.select(db.pilotos)
                    ..where((t) => t.id.equals(eq.piloto2Id!)))
                  .getSingleOrNull())
              ?.nombre;
        }
        String motivoFor(int parte, String? otroNombre) {
          final signo = valor > 0 ? '+$valor' : '$valor';
          final tu = parte > 0 ? '+$parte' : '$parte';
          final base = 'Coche ${coche?.nombre ?? ''} · valor $signo';
          if (otroNombre == null) return '$base · tu parte $tu';
          return '$base · tu parte $tu (con $otroNombre)';
        }

        if (aplicarP1 != 0) {
          await _sumarCreditos(eq.piloto1Id, campId, aplicarP1,
              verificacionId: verificacionId,
              equipoId: eq.id,
              pruebaId: pruebaId,
              motivo: motivoFor(aplicarP1, p2Nom));
        }
        if (aplicarP2 != 0 && eq.piloto2Id != null) {
          await _sumarCreditos(eq.piloto2Id!, campId, aplicarP2,
              verificacionId: verificacionId,
              equipoId: eq.id,
              pruebaId: pruebaId,
              motivo: motivoFor(aplicarP2, p1Nom));
        }
      }
    }
    await (db.update(db.verificaciones)
          ..where((t) => t.id.equals(verificacionId)))
        .write(VerificacionesCompanion(
      credAplicadoP1: Value(aplicarP1),
      credAplicadoP2: Value(aplicarP2),
    ));
    return (p1: aplicarP1, p2: aplicarP2, insuficiente: insuf);
  }

  Future<int> guardar({
    int? id,
    required int mangaId,
    required int equipoId,
    int? cocheCatalogoId,
    double? pesoInicial,
    double? pesoFinal,
    double? pesoMin,
    double? pesoInicialCoche,
    double? pesoFinalCoche,
    String? motor,
    String? motorTipo,
    int? motorRpm,
    double? motorUms,
    String? pinonMarca,
    int? pinonDientes,
    String? coronaMarca,
    int? coronaDientes,
    String? llantaDelMarca,
    String? llantaDelDimension,
    String? llantaTraMarca,
    String? llantaTraDimension,
    String? trencilla,
    String? suspension,
    String? bancada,
    String? chasis,
    String? neumatico,
    String? observaciones,
    required bool validado,
    String? fotosJson,
  }) async {
    if (id == null) {
      final nuevoId = await db.into(db.verificaciones).insert(
            VerificacionesCompanion.insert(
              mangaId: mangaId,
              equipoId: equipoId,
              cocheCatalogoId: Value(cocheCatalogoId),
              pesoInicial: Value(pesoInicial),
              pesoFinal: Value(pesoFinal),
              pesoMin: Value(pesoMin),
              pesoInicialCoche: Value(pesoInicialCoche),
              pesoFinalCoche: Value(pesoFinalCoche),
              motor: Value(motor),
              motorTipo: motorTipo == null
                  ? const Value.absent()
                  : Value(motorTipo),
              motorRpm: Value(motorRpm),
              motorUms: Value(motorUms),
              pinonMarca: Value(pinonMarca),
              pinonDientes: Value(pinonDientes),
              coronaMarca: Value(coronaMarca),
              coronaDientes: Value(coronaDientes),
              llantaDelMarca: Value(llantaDelMarca),
              llantaDelDimension: Value(llantaDelDimension),
              llantaTraMarca: Value(llantaTraMarca),
              llantaTraDimension: Value(llantaTraDimension),
              trencilla: Value(trencilla),
              suspension: Value(suspension),
              bancada: Value(bancada),
              chasis: Value(chasis),
              neumatico: Value(neumatico),
              observaciones: Value(observaciones),
              validado: Value(validado),
              fotosJson:
                  fotosJson == null ? const Value.absent() : Value(fotosJson),
            ),
          );
      await _reaplicarCreditos(nuevoId);
      return nuevoId;
    }
    await (db.update(db.verificaciones)..where((t) => t.id.equals(id))).write(
      VerificacionesCompanion(
        cocheCatalogoId: Value(cocheCatalogoId),
        pesoInicial: Value(pesoInicial),
        pesoFinal: Value(pesoFinal),
        pesoMin: Value(pesoMin),
        pesoInicialCoche: Value(pesoInicialCoche),
        pesoFinalCoche: Value(pesoFinalCoche),
        motor: Value(motor),
        motorTipo: motorTipo == null ? const Value.absent() : Value(motorTipo),
        motorRpm: Value(motorRpm),
        motorUms: Value(motorUms),
        pinonMarca: Value(pinonMarca),
        pinonDientes: Value(pinonDientes),
        coronaMarca: Value(coronaMarca),
        coronaDientes: Value(coronaDientes),
        llantaDelMarca: Value(llantaDelMarca),
        llantaDelDimension: Value(llantaDelDimension),
        llantaTraMarca: Value(llantaTraMarca),
        llantaTraDimension: Value(llantaTraDimension),
        trencilla: Value(trencilla),
        suspension: Value(suspension),
        bancada: Value(bancada),
        chasis: Value(chasis),
        neumatico: Value(neumatico),
        observaciones: Value(observaciones),
        validado: Value(validado),
        fotosJson:
            fotosJson == null ? const Value.absent() : Value(fotosJson),
      ),
    );
    await _reaplicarCreditos(id);
    return id;
  }

  Future<void> borrar(int id) async {
    // Devolver créditos aplicados antes de borrar.
    final ver = await (db.select(db.verificaciones)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (ver != null) {
      final eq = await (db.select(db.equipos)
            ..where((t) => t.id.equals(ver.equipoId)))
          .getSingleOrNull();
      final campId = await _campeonatoIdDeManga(ver.mangaId);
      if (eq != null && campId != null) {
        final manga = await (db.select(db.mangas)
              ..where((t) => t.id.equals(ver.mangaId)))
            .getSingleOrNull();
        final pruebaId = manga?.pruebaId;
        if (ver.credAplicadoP1 != 0) {
          await _sumarCreditos(eq.piloto1Id, campId, -ver.credAplicadoP1,
              equipoId: eq.id,
              pruebaId: pruebaId,
              motivo: 'Reversión (verificación eliminada)');
        }
        if (ver.credAplicadoP2 != 0 && eq.piloto2Id != null) {
          await _sumarCreditos(eq.piloto2Id!, campId, -ver.credAplicadoP2,
              equipoId: eq.id,
              pruebaId: pruebaId,
              motivo: 'Reversión (verificación eliminada)');
        }
      }
    }
    await (db.delete(db.verificaciones)..where((t) => t.id.equals(id))).go();
  }
}

final repoVerificacionesProvider = Provider<RepositorioVerificaciones>((ref) {
  return RepositorioVerificaciones(ref.watch(dbProvider));
});
