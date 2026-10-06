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
import 'dart:convert';

import 'package:drift/drift.dart';

import '../../data/database/app_database.dart';
import '../../domain/reglas_verificacion.dart';
import '../campeonatos/selector_marcas_permitidas.dart';

/// Normaliza un nombre de copa para compararlo: ignora mayúsculas, espacios
/// y signos ("LMP-2", "LMP 2" y "lmp2" son la misma copa).
String normCopa(String s) =>
    s.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9ÁÉÍÓÚÜÑ]'), '');

/// True si la fila de catálogo (su `copasJson`) está marcada con [copa]. La
/// lista vacía NO aplica a ninguna copa.
bool copaAplica(String copasJson, String copa) {
  try {
    final raw = (copasJson.isEmpty) ? [] : (jsonDecode(copasJson) as List?);
    if (raw == null || raw.isEmpty) return false;
    final objetivo = normCopa(copa);
    return raw.map((e) => normCopa(e.toString())).contains(objetivo);
  } catch (_) {
    return false;
  }
}

/// Anchura máxima de eje (mm) configurada para [copa] en el JSON
/// `{"GT": {"del": 65.0, "tra": 63.0}, ...}` del campeonato: (delantero,
/// trasero). Cada valor es null si no hay copa o no está configurado ese
/// lado (no se comprueba).
(double?, double?) anchuraEjeMaxDe(String? anchuraEjeJson, String? copa) {
  if (anchuraEjeJson == null || copa == null) return (null, null);
  try {
    final raw = jsonDecode(anchuraEjeJson);
    if (raw is Map && raw[copa] is Map) {
      final lados = raw[copa] as Map;
      final del = lados['del'] == null ? null : (lados['del'] as num).toDouble();
      final tra = lados['tra'] == null ? null : (lados['tra'] as num).toDouble();
      return (del, tra);
    }
  } catch (_) {}
  return (null, null);
}

/// Por qué no se deben tocar las verificaciones de una prueba (campeonato
/// finalizado o prueba terminada); null = se pueden editar.
String? motivoBloqueo(Campeonato? campeonato, Prueba? prueba) {
  if (campeonato?.finalizado ?? false) {
    return campeonato!.esVerificacionLibre
        ? 'La sesión está cerrada.'
        : 'El campeonato está finalizado.';
  }
  if (prueba?.estado == 'TERMINADA') return 'La prueba está terminada.';
  return null;
}

/// Calcula el reglamento ACTUAL de una verificación leyendo el catálogo y el
/// campeonato. Guarda en memoria lo que lee, así que para muchas
/// verificaciones seguidas (relleno al arrancar) conviene reutilizar el
/// mismo cargador; para una sola, uno nuevo cada vez (datos frescos).
class CargadorReglas {
  CargadorReglas(this.db);
  final AppDatabase db;

  final _mangas = <int, Manga?>{};
  final _pruebas = <int, Prueba?>{};
  final _camps = <int, Campeonato?>{};
  final _ajustes = <int, Map<int, CochesCampeonatoData>>{};
  final _coches = <int, CatalogoCoche?>{};
  List<CatalogoMarca>? _marcas;
  List<CatalogoLlanta>? _llantas;
  List<CatalogoBancada>? _bancadas;
  List<CatalogoNeumatico>? _neumaticos;
  List<CatalogoMotore>? _motores;

  Future<Manga?> _manga(int id) async => _mangas.containsKey(id)
      ? _mangas[id]
      : _mangas[id] = await (db.select(db.mangas)
            ..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<Prueba?> _prueba(int id) async => _pruebas.containsKey(id)
      ? _pruebas[id]
      : _pruebas[id] = await (db.select(db.pruebas)
            ..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<Campeonato?> _camp(int id) async => _camps.containsKey(id)
      ? _camps[id]
      : _camps[id] = await (db.select(db.campeonatos)
            ..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  /// Prueba y campeonato de una manga.
  Future<({Prueba? prueba, Campeonato? campeonato})> contexto(
      int mangaId) async {
    final m = await _manga(mangaId);
    final p = m == null ? null : await _prueba(m.pruebaId);
    final c = p == null ? null : await _camp(p.campeonatoId);
    return (prueba: p, campeonato: c);
  }

  /// Peso mínimo, créditos y nombre de un coche en un campeonato: los
  /// fijados en el campeonato si los hay, si no los del catálogo.
  Future<({String? nombre, double? pesoMin, int? creditos})> valoresCoche(
      int? campeonatoId, int cocheId) async {
    final coche = _coches.containsKey(cocheId)
        ? _coches[cocheId]
        : _coches[cocheId] = await (db.select(db.catalogoCoches)
              ..where((t) => t.id.equals(cocheId)))
            .getSingleOrNull();
    CochesCampeonatoData? ajuste;
    if (campeonatoId != null) {
      final porCoche = _ajustes[campeonatoId] ??= {
        for (final a in await (db.select(db.cochesCampeonato)
              ..where((t) => t.campeonatoId.equals(campeonatoId)))
            .get())
          a.cocheCatalogoId: a,
      };
      ajuste = porCoche[cocheId];
    }
    return (
      nombre: coche?.nombre,
      pesoMin: ajuste?.pesoMin ?? coche?.pesoMin,
      creditos: ajuste?.creditosCoche ?? coche?.creditosCoche,
    );
  }

  /// Reglamento actual para la verificación de [equipoId] en [mangaId] con
  /// el coche y motor indicados. [copa] = copa en la prueba; si es null se
  /// busca (inscripción a la prueba, o copa del equipo).
  Future<ReglasVerificacion> actuales({
    required int mangaId,
    required int equipoId,
    int? cocheId,
    String? motorTipo,
    String? motor,
    String? copa,
  }) async {
    final ctx = await contexto(mangaId);
    final camp = ctx.campeonato;
    if (copa == null) {
      if (ctx.prueba != null) {
        final ins = await (db.select(db.inscripcionesPrueba)
              ..where((t) =>
                  t.pruebaId.equals(ctx.prueba!.id) &
                  t.equipoId.equals(equipoId))
              ..limit(1))
            .getSingleOrNull();
        copa = ins?.copa;
      }
      copa ??= (await (db.select(db.equipos)
                ..where((t) => t.id.equals(equipoId)))
              .getSingleOrNull())
          ?.copa;
    }
    final conCopa = copa != null && copa.isNotEmpty;

    final coche =
        cocheId == null ? null : await valoresCoche(camp?.id, cocheId);

    // Referencia del motor propio: el del catálogo de la copa con ese nombre.
    CatalogoMotore? ref;
    final nombreMotor = motor?.trim() ?? '';
    if (motorTipo == 'PROPIO' && nombreMotor.isNotEmpty) {
      _motores ??= await db.select(db.catalogoMotores).get();
      ref = _motores!
          .where((m) =>
              m.nombre == nombreMotor &&
              (!conCopa || copaAplica(m.copasJson, copa!)))
          .firstOrNull;
    }

    final (ejeDel, ejeTra) = anchuraEjeMaxDe(camp?.anchuraEjeJson, copa);

    _marcas ??= await db.select(db.catalogoMarcas).get();
    _llantas ??= await db.select(db.catalogoLlantas).get();
    _bancadas ??= await db.select(db.catalogoBancadas).get();
    _neumaticos ??= await db.select(db.catalogoNeumaticos).get();

    // Mismos filtros que los desplegables de la verificación.
    Set<String> llantas(String eje) {
      var l = _llantas!.where((x) => x.tipo == eje || x.tipo == 'AMBAS').toList();
      if (l.isEmpty) l = _llantas!;
      if (conCopa) l = l.where((x) => copaAplica(x.copasJson ?? '', copa!)).toList();
      return l.map((x) => x.dimension).toSet();
    }

    return ReglasVerificacion(
      fechaMs: DateTime.now().millisecondsSinceEpoch,
      copa: copa,
      cocheId: cocheId,
      cocheNombre: coche?.nombre,
      pesoMin: coche?.pesoMin,
      creditosCoche: coche?.creditos,
      motor: motorTipo == 'PROPIO' && nombreMotor.isNotEmpty ? nombreMotor : null,
      motorRefNombre: ref?.nombre,
      motorRefRpm: ref?.rpm,
      motorRefGauss: ref?.gauss,
      anchuraEjeDelMax: ejeDel,
      anchuraEjeTraMax: ejeTra,
      marcasPermitidas: marcasPermitidasDe(camp?.marcasPermitidasJson),
      marcasValidas: _marcas!.map((m) => m.codigo).toSet(),
      llantasDelValidas: llantas('DELANTERA'),
      llantasTraValidas: llantas('TRASERA'),
      bancadasValidas: _bancadas!.map((b) => b.nombre).toSet(),
      neumaticosValidos: (conCopa
              ? _neumaticos!
                  .where((n) => copaAplica(n.copasJson ?? '', copa!))
              : _neumaticos!)
          .map((n) => n.nombre)
          .toSet(),
    );
  }
}

/// Congela el reglamento de las verificaciones que aún no lo tienen
/// (creadas antes de existir `reglas_json`). Se toman los valores actuales
/// del catálogo, salvo el peso mínimo, que ya se guardaba en la propia
/// verificación. Idempotente: solo toca las que tienen `reglas_json` vacío.
/// Devuelve cuántas ha rellenado.
Future<int> rellenarReglasPendientes(AppDatabase db) async {
  final pendientes = await (db.select(db.verificaciones)
        ..where((t) => t.reglasJson.isNull()))
      .get();
  if (pendientes.isEmpty) return 0;
  final cargador = CargadorReglas(db);
  var n = 0;
  for (final v in pendientes) {
    var r = await cargador.actuales(
      mangaId: v.mangaId,
      equipoId: v.equipoId,
      cocheId: v.cocheCatalogoId,
      motorTipo: v.motorTipo,
      motor: v.motor,
    );
    if (v.pesoMin != null) {
      final j = r.toJson()..['pesoMin'] = v.pesoMin;
      r = ReglasVerificacion.fromJson(j);
    }
    // Sin tocar modificadoMs: no es un cambio que haya que sincronizar.
    await (db.update(db.verificaciones)..where((t) => t.id.equals(v.id)))
        .write(VerificacionesCompanion(
      reglasJson: Value(r.codificar()),
      pesoMin: Value(r.pesoMin),
    ));
    n++;
  }
  return n;
}
