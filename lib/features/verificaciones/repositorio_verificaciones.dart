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
import '../../domain/reglas_verificacion.dart';
import '../sincronizacion/dispositivo_sync.dart';
import 'reglas_verificacion_bd.dart';

/// Verificación enriquecida (con datos del equipo y coche).
class VerificacionConEquipo {
  final Verificacione? verificacion;
  final Equipo equipo;
  final Piloto piloto1;
  final Piloto? piloto2;
  final CatalogoCoche? coche;

  /// Copa que corre el equipo en la prueba de esta manga (snapshot de
  /// inscripción); null = usa la copa actual del equipo.
  final String? copaPrueba;

  VerificacionConEquipo({
    this.verificacion,
    required this.equipo,
    required this.piloto1,
    this.piloto2,
    this.coche,
    this.copaPrueba,
  });

  /// Copa efectiva en esta prueba.
  String get copa => copaPrueba ?? equipo.copa;

  String get pilotosTexto => piloto2 == null
      ? piloto1.nombre
      : '${piloto1.nombre} + ${piloto2!.nombre}';

  bool get tieneVerificacion => verificacion != null;
  bool get validada => verificacion?.validado ?? false;
}

/// Una verificación por cada equipo inscrito en la manga.
///
/// Se refresca cuando cambian las inscripciones **o** las verificaciones de la
/// manga (clave para que el autoguardado actualice la lista al instante), y
/// también cuando cambia la copa de la prueba (editada desde la ficha).
final verificacionesMangaProvider = StreamProvider.autoDispose
    .family<List<VerificacionConEquipo>, int>((ref, mangaId) {
  final db = ref.watch(dbProvider);
  final insStream = (db.select(db.inscripciones)
        ..where((t) => t.mangaId.equals(mangaId)))
      .watch();
  final verStream = (db.select(db.verificaciones)
        ..where((t) => t.mangaId.equals(mangaId)))
      .watch();
  final insPruebaStream = db.select(db.inscripcionesPrueba).watch();

  return ticksDeCualquiera([insStream, verStream, insPruebaStream])
      .asyncMap((_) async {
    final inscritos = await (db.select(db.inscripciones)
          ..where((t) => t.mangaId.equals(mangaId)))
        .get();
    final manga = await (db.select(db.mangas)
          ..where((t) => t.id.equals(mangaId)))
        .getSingleOrNull();
    // Copa por equipo en la prueba de esta manga (snapshot de inscripción).
    final copasPrueba = <int, String>{};
    if (manga != null) {
      final insPrueba = await (db.select(db.inscripcionesPrueba)
            ..where((t) => t.pruebaId.equals(manga.pruebaId)))
          .get();
      for (final ip in insPrueba) {
        if (ip.copa != null) copasPrueba[ip.equipoId] = ip.copa!;
      }
    }
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
      // `limit(1)`: nunca revienta aunque (excepcionalmente) hubiera duplicados.
      final ver = await (db.select(db.verificaciones)
            ..where((t) =>
                t.mangaId.equals(mangaId) & t.equipoId.equals(eq.id))
            ..limit(1))
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
        copaPrueba: copasPrueba[eq.id],
      ));
    }
    out.sort((a, b) => a.equipo.nombre.compareTo(b.equipo.nombre));
    return out;
  });
});

/// Emite un primer tick y luego uno cada vez que cualquiera de [streams] emite.
Stream<void> ticksDeCualquiera(List<Stream> streams) {
  final ctrl = StreamController<void>();
  final subs = <StreamSubscription>[];
  ctrl.onListen = () {
    ctrl.add(null);
    for (final s in streams) {
      subs.add(s.listen((_) => ctrl.add(null), onError: ctrl.addError));
    }
  };
  ctrl.onCancel = () async {
    for (final s in subs) {
      await s.cancel();
    }
  };
  return ctrl.stream;
}

// NOTA: todos los providers de catálogo que alimentan los desplegables de la
// verificación son StreamProvider sobre la BD: así, cualquier alta o cambio
// en Catálogos aparece en los desplegables al instante, sin reiniciar.

/// Catálogo de marcas del componente (códigos).
final marcasCodigosProvider =
    StreamProvider.autoDispose<Set<String>>((ref) {
  final db = ref.watch(dbProvider);
  return db
      .select(db.catalogoMarcas)
      .watch()
      .map((lista) => lista.map((m) => m.codigo).toSet());
});

/// Llantas de un eje, filtradas por tipo y por la copa del equipo.
/// - Tipo: DELANTERA/TRASERA según el eje, más las AMBAS.
/// - Copa: solo se muestran las marcadas **explícitamente** con la copa del
///   equipo. Las llantas sin copa marcada no se pueden usar (no se enseñan).
Stream<List<CatalogoLlanta>> _llantasEje(
    AppDatabase db, String tipoEje, String? copa) {
  return db.select(db.catalogoLlantas).watch().map((todas) {
    var filtradas =
        todas.where((l) => l.tipo == tipoEje || l.tipo == 'AMBAS').toList();
    if (filtradas.isEmpty) filtradas = todas;
    if (copa == null || copa.isEmpty) return filtradas;
    return filtradas.where((l) => _tieneCopa(l.copasJson ?? '', copa)).toList();
  });
}

/// Llantas del eje delantero filtradas por la copa del equipo.
final llantasDelFiltradasProvider = StreamProvider.autoDispose
    .family<List<CatalogoLlanta>, String?>((ref, copa) {
  return _llantasEje(ref.watch(dbProvider), 'DELANTERA', copa);
});

/// Llantas del eje trasero filtradas por la copa del equipo.
final llantasTraFiltradasProvider = StreamProvider.autoDispose
    .family<List<CatalogoLlanta>, String?>((ref, copa) {
  return _llantasEje(ref.watch(dbProvider), 'TRASERA', copa);
});
/// Bancadas filtradas por la copa del equipo (parámetro `copa`).
/// Solo se devuelven las marcadas explícitamente con esa copa; las que no
/// tienen copa marcada no se pueden usar (no se enseñan).
final bancadasFiltradasProvider = StreamProvider.autoDispose
    .family<List<CatalogoBancada>, String?>((ref, copa) {
  final db = ref.watch(dbProvider);
  return db.select(db.catalogoBancadas).watch().map((todas) {
    if (copa == null || copa.isEmpty) return todas;
    return todas.where((b) => _aplicaA(b.copasJson, copa)).toList();
  });
});
final bancadasProvider =
    StreamProvider.autoDispose<List<CatalogoBancada>>((ref) {
  final db = ref.watch(dbProvider);
  return db.select(db.catalogoBancadas).watch();
});

bool _aplicaA(String copasJson, String copa) => copaAplica(copasJson, copa);

/// True si el coche tiene [copa] en su lista (NO cuenta la lista vacía).
bool _tieneCopa(String copasJson, String copa) => copaAplica(copasJson, copa);

final neumaticosProvider =
    StreamProvider.autoDispose<List<CatalogoNeumatico>>((ref) {
  final db = ref.watch(dbProvider);
  return db.select(db.catalogoNeumaticos).watch();
});

/// Neumáticos filtrados por la copa del equipo.
final neumaticosFiltradosProvider = StreamProvider.autoDispose
    .family<List<CatalogoNeumatico>, String?>((ref, copa) {
  final db = ref.watch(dbProvider);
  return (db.select(db.catalogoNeumaticos)
        ..orderBy([(t) => OrderingTerm.asc(t.nombre)]))
      .watch()
      .map((todos) {
    if (copa == null || copa.isEmpty) return todos;
    return todos.where((n) => _aplicaA(n.copasJson ?? '', copa)).toList();
  });
});

/// Engranajes (piñones/coronas) filtrados por copa y tipo.
final engranajesFiltradosProvider = StreamProvider.autoDispose
    .family<List<CatalogoEngranaje>, ({String? copa, String tipo})>(
        (ref, args) {
  final db = ref.watch(dbProvider);
  return (db.select(db.catalogoEngranajes)
        ..where((t) => t.tipo.equals(args.tipo))
        ..orderBy([(t) => OrderingTerm.asc(t.diametro)]))
      .watch()
      .map((todos) {
    final copa = args.copa;
    if (copa == null || copa.isEmpty) return todos;
    return todos.where((e) => _aplicaA(e.copasJson ?? '', copa)).toList();
  });
});
final cochesProvider =
    StreamProvider.autoDispose<List<CatalogoCoche>>((ref) {
  final db = ref.watch(dbProvider);
  return (db.select(db.catalogoCoches)..where((t) => t.activo.equals(true)))
      .watch();
});

/// Motores del catálogo filtrados por la copa del equipo.
final motoresFiltradosProvider = StreamProvider.autoDispose
    .family<List<CatalogoMotore>, String?>((ref, copa) {
  final db = ref.watch(dbProvider);
  return (db.select(db.catalogoMotores)
        ..orderBy([(t) => OrderingTerm.asc(t.nombre)]))
      .watch()
      .map((todos) {
    if (copa == null || copa.isEmpty) return todos;
    return todos.where((m) => _aplicaA(m.copasJson, copa)).toList();
  });
});

/// Chasis de la verificación. Sin copa: se usan siempre todos, sin filtrar.
final chasisProvider = StreamProvider.autoDispose<List<CatalogoChasi>>((ref) {
  final db = ref.watch(dbProvider);
  return (db.select(db.catalogoChasis)
        ..orderBy([(t) => OrderingTerm.asc(t.nombre)]))
      .watch();
});

/// Coches a mostrar en la verificación, filtrados por la copa que corre el
/// equipo en la prueba. Solo los marcados con esa copa: si no hay ninguno,
/// la lista sale vacía (antes caía a los coches de todas las copas del
/// campeonato, lo que escondía copas mal escritas). Sin copa → todos.
final cochesFiltradosProvider = StreamProvider.autoDispose
    .family<List<CatalogoCoche>, String?>((ref, copa) {
  final db = ref.watch(dbProvider);
  return (db.select(db.catalogoCoches)..where((t) => t.activo.equals(true)))
      .watch()
      .map((todos) {
    if (copa == null || copa.isEmpty) return todos;
    return todos.where((c) => _aplicaA(c.copasJson, copa)).toList();
  });
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
      // Créditos del coche con los que se verificó (reglamento congelado);
      // si aún no lo tiene, los actuales del campeonato o del catálogo.
      final reglas = ReglasVerificacion.decodificar(ver.reglasJson);
      final congeladas =
          reglas != null && reglas.cocheId == ver.cocheCatalogoId;
      final actuales = congeladas
          ? null
          : await CargadorReglas(db).valoresCoche(campId, ver.cocheCatalogoId!);
      final valor =
          (congeladas ? reglas.creditosCoche : actuales!.creditos) ?? 0;
      final nombreCoche = congeladas ? reglas.cocheNombre : actuales!.nombre;
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
          final base = 'Coche ${nombreCoche ?? ''} · valor $signo';
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

  /// Revierte y vuelve a aplicar los créditos de la verificación según su
  /// estado actual. Lo usa la sincronización al recibir cambios de otro
  /// Control: cada dispositivo calcula sus propios movimientos.
  Future<void> recalcularCreditos(int verificacionId) =>
      _reaplicarCreditos(verificacionId);

  /// Quita la marca de "borrada" de (manga, equipo): la verificación vuelve
  /// a existir y no hay que propagar el borrado.
  Future<void> _olvidarBorrado(int mangaId, int equipoId) async {
    await (db.delete(db.borradosSync)
          ..where((t) =>
              t.mangaId.equals(mangaId) & t.equipoId.equals(equipoId)))
        .go();
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
    bool? alturaMotorConforme,
    double? anchuraEjeDel,
    double? anchuraEjeTra,
    bool? carroceriaConforme,
    String? carroceriaPiezasFaltantes,
    String? pinonMarca,
    int? pinonDientes,
    String? pinonDiametro,
    String? pinonMaterial,
    String? coronaMarca,
    int? coronaDientes,
    String? coronaDiametro,
    String? coronaMaterial,
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
    String? reglasJson,
    bool recalcularCreditos = true,
  }) async {
    // Garantiza una sola verificación por (manga, equipo): si llega sin id
    // pero ya existe una, se actualiza en lugar de crear un duplicado.
    if (id == null) {
      final existente = await (db.select(db.verificaciones)
            ..where((t) =>
                t.mangaId.equals(mangaId) & t.equipoId.equals(equipoId))
            ..limit(1))
          .getSingleOrNull();
      id = existente?.id;
    }
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
              alturaMotorConforme: Value(alturaMotorConforme),
              anchuraEjeDel: Value(anchuraEjeDel),
              anchuraEjeTra: Value(anchuraEjeTra),
              carroceriaConforme: Value(carroceriaConforme),
              carroceriaPiezasFaltantes: Value(carroceriaPiezasFaltantes),
              pinonMarca: Value(pinonMarca),
              pinonDientes: Value(pinonDientes),
              pinonDiametro: Value(pinonDiametro),
              pinonMaterial: Value(pinonMaterial),
              coronaMarca: Value(coronaMarca),
              coronaDientes: Value(coronaDientes),
              coronaDiametro: Value(coronaDiametro),
              coronaMaterial: Value(coronaMaterial),
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
              reglasJson: reglasJson == null
                  ? const Value.absent()
                  : Value(reglasJson),
              modificadoMs: Value(ahoraMsSync()),
              modificadoPor: Value(DispositivoSync.nombre),
            ),
          );
      await _olvidarBorrado(mangaId, equipoId);
      if (recalcularCreditos) await _reaplicarCreditos(nuevoId);
      return nuevoId;
    }
    final idActual = id;
    await (db.update(db.verificaciones)..where((t) => t.id.equals(idActual)))
        .write(
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
        alturaMotorConforme: Value(alturaMotorConforme),
        anchuraEjeDel: Value(anchuraEjeDel),
        anchuraEjeTra: Value(anchuraEjeTra),
        carroceriaConforme: Value(carroceriaConforme),
        carroceriaPiezasFaltantes: Value(carroceriaPiezasFaltantes),
        pinonMarca: Value(pinonMarca),
        pinonDientes: Value(pinonDientes),
        pinonDiametro: Value(pinonDiametro),
        pinonMaterial: Value(pinonMaterial),
        coronaMarca: Value(coronaMarca),
        coronaDientes: Value(coronaDientes),
        coronaDiametro: Value(coronaDiametro),
        coronaMaterial: Value(coronaMaterial),
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
        reglasJson:
            reglasJson == null ? const Value.absent() : Value(reglasJson),
        modificadoMs: Value(ahoraMsSync()),
        modificadoPor: Value(DispositivoSync.nombre),
      ),
    );
    if (recalcularCreditos) await _reaplicarCreditos(idActual);
    return idActual;
  }

  /// Elimina verificaciones duplicadas (misma manga+equipo), conservando la
  /// validada si la hay, o la de menor id. Repara datos creados antes de
  /// garantizar la unicidad. Devuelve cuántas eliminó.
  Future<int> limpiarDuplicados() async {
    final todas = await db.select(db.verificaciones).get();
    final grupos = <String, List<Verificacione>>{};
    for (final v in todas) {
      grupos.putIfAbsent('${v.mangaId}-${v.equipoId}', () => []).add(v);
    }
    var eliminadas = 0;
    for (final grupo in grupos.values) {
      if (grupo.length <= 1) continue;
      grupo.sort((a, b) {
        if (a.validado != b.validado) return a.validado ? -1 : 1;
        return a.id.compareTo(b.id);
      });
      for (final v in grupo.skip(1)) {
        // borrar() revierte créditos si los tuviera. No se propaga: la
        // verificación de (manga, equipo) que queda sigue existiendo.
        await borrar(v.id, registrarBorrado: false);
        eliminadas++;
      }
    }
    return eliminadas;
  }

  /// Asigna un motor de organización a la verificación de (manga, equipo) sin
  /// tocar el resto de campos. Crea la verificación si aún no existe.
  Future<void> asignarMotor({
    required int mangaId,
    required int equipoId,
    required String motor,
  }) async {
    final existente = await (db.select(db.verificaciones)
          ..where((t) =>
              t.mangaId.equals(mangaId) & t.equipoId.equals(equipoId))
          ..limit(1))
        .getSingleOrNull();
    if (existente == null) {
      await db.into(db.verificaciones).insert(
            VerificacionesCompanion.insert(
              mangaId: mangaId,
              equipoId: equipoId,
              motor: Value(motor),
              motorTipo: const Value('ORGANIZACION'),
              modificadoMs: Value(ahoraMsSync()),
              modificadoPor: Value(DispositivoSync.nombre),
            ),
          );
      await _olvidarBorrado(mangaId, equipoId);
    } else {
      await (db.update(db.verificaciones)
            ..where((t) => t.id.equals(existente.id)))
          .write(VerificacionesCompanion(
        motor: Value(motor),
        motorTipo: const Value('ORGANIZACION'),
        modificadoMs: Value(ahoraMsSync()),
        modificadoPor: Value(DispositivoSync.nombre),
      ));
    }
  }

  /// Quita el motor asignado a (manga, equipo) (deja el campo vacío).
  Future<void> quitarMotor({
    required int mangaId,
    required int equipoId,
  }) async {
    final existente = await (db.select(db.verificaciones)
          ..where((t) =>
              t.mangaId.equals(mangaId) & t.equipoId.equals(equipoId))
          ..limit(1))
        .getSingleOrNull();
    if (existente == null) return;
    await (db.update(db.verificaciones)..where((t) => t.id.equals(existente.id)))
        .write(VerificacionesCompanion(
          motor: const Value(null),
          modificadoMs: Value(ahoraMsSync()),
          modificadoPor: Value(DispositivoSync.nombre),
        ));
  }

  /// Borra la verificación devolviendo sus créditos. Con [registrarBorrado]
  /// queda apuntado para que el borrado llegue a los demás Controls al
  /// sincronizar (o, con [borradoMs]/[borradoPor], se copia el borrado que
  /// llegó de otro Control).
  Future<void> borrar(
    int id, {
    bool registrarBorrado = true,
    int? borradoMs,
    String? borradoPor,
  }) async {
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
    if (ver != null && registrarBorrado) {
      await _olvidarBorrado(ver.mangaId, ver.equipoId);
      await db.into(db.borradosSync).insert(BorradosSyncCompanion.insert(
            mangaId: ver.mangaId,
            equipoId: ver.equipoId,
            borradoMs: borradoMs ?? ahoraMsSync(),
            borradoPor: Value(borradoPor ?? DispositivoSync.nombre),
          ));
    }
    await (db.delete(db.verificaciones)..where((t) => t.id.equals(id))).go();
  }
}

final repoVerificacionesProvider = Provider<RepositorioVerificaciones>((ref) {
  return RepositorioVerificaciones(ref.watch(dbProvider));
});
