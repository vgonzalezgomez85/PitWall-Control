import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';

// ============== Coches ==============
final cochesCatalogoProvider =
    StreamProvider.autoDispose<List<CatalogoCoche>>((ref) {
  final db = ref.watch(dbProvider);
  return (db.select(db.catalogoCoches)
        ..orderBy([(t) => OrderingTerm.asc(t.nombre)]))
      .watch();
});

// ============== Marcas ==============
final marcasCatalogoProvider =
    StreamProvider.autoDispose<List<CatalogoMarca>>((ref) {
  final db = ref.watch(dbProvider);
  return (db.select(db.catalogoMarcas)
        ..orderBy([(t) => OrderingTerm.asc(t.codigo)]))
      .watch();
});

// ============== Llantas ==============
final llantasCatalogoProvider =
    StreamProvider.autoDispose<List<CatalogoLlanta>>((ref) {
  final db = ref.watch(dbProvider);
  return (db.select(db.catalogoLlantas)
        ..orderBy([
          (t) => OrderingTerm.asc(t.tipo),
          (t) => OrderingTerm.asc(t.dimension),
        ]))
      .watch();
});

// ============== Bancadas ==============
final bancadasCatalogoProvider =
    StreamProvider.autoDispose<List<CatalogoBancada>>((ref) {
  final db = ref.watch(dbProvider);
  return (db.select(db.catalogoBancadas)
        ..orderBy([(t) => OrderingTerm.asc(t.nombre)]))
      .watch();
});

// ============== Chasis ==============
final chasisCatalogoProvider =
    StreamProvider.autoDispose<List<CatalogoChasi>>((ref) {
  final db = ref.watch(dbProvider);
  return (db.select(db.catalogoChasis)
        ..orderBy([(t) => OrderingTerm.asc(t.nombre)]))
      .watch();
});

// ============== Neumáticos ==============
final neumaticosCatalogoProvider =
    StreamProvider.autoDispose<List<CatalogoNeumatico>>((ref) {
  final db = ref.watch(dbProvider);
  return (db.select(db.catalogoNeumaticos)
        ..orderBy([(t) => OrderingTerm.asc(t.nombre)]))
      .watch();
});

// ============== Copas ==============
final copasCatalogoProvider =
    StreamProvider.autoDispose<List<CatalogoCopa>>((ref) {
  final db = ref.watch(dbProvider);
  return (db.select(db.catalogoCopas)
        ..orderBy([(t) => OrderingTerm.asc(t.nombre)]))
      .watch();
});

// ============== Clubs ==============
final clubsCatalogoProvider =
    StreamProvider.autoDispose<List<CatalogoClub>>((ref) {
  final db = ref.watch(dbProvider);
  return (db.select(db.catalogoClubs)
        ..orderBy([(t) => OrderingTerm.asc(t.nombre)]))
      .watch();
});

class RepositorioCatalogos {
  RepositorioCatalogos(this.db);
  final AppDatabase db;

  // ---- Coches ----
  Future<int> crearCoche({
    required String nombre,
    required String marca,
    required String modelo,
    required double pesoMin,
    int creditosCoche = 0,
  }) {
    return db.into(db.catalogoCoches).insert(CatalogoCochesCompanion.insert(
          nombre: nombre,
          marca: marca,
          modelo: modelo,
          pesoMin: pesoMin,
          creditosCoche: Value(creditosCoche),
        ));
  }

  Future<void> actualizarCoche(int id, CatalogoCochesCompanion c) async {
    await (db.update(db.catalogoCoches)..where((t) => t.id.equals(id)))
        .write(c);
  }

  Future<void> borrarCoche(int id) async {
    await (db.delete(db.catalogoCoches)..where((t) => t.id.equals(id))).go();
  }

  // ---- Marcas ----
  Future<int> crearMarca(String codigo, String nombre) {
    return db.into(db.catalogoMarcas).insert(
        CatalogoMarcasCompanion.insert(codigo: codigo, nombre: nombre));
  }

  Future<void> actualizarMarca(int id, String codigo, String nombre) async {
    await (db.update(db.catalogoMarcas)..where((t) => t.id.equals(id)))
        .write(CatalogoMarcasCompanion(
            codigo: Value(codigo), nombre: Value(nombre)));
  }

  Future<void> borrarMarca(int id) async {
    await (db.delete(db.catalogoMarcas)..where((t) => t.id.equals(id))).go();
  }

  // ---- Llantas ----
  Future<int> crearLlanta(String dimension, String tipo) {
    return db.into(db.catalogoLlantas).insert(
        CatalogoLlantasCompanion.insert(dimension: dimension, tipo: tipo));
  }

  Future<void> actualizarLlanta(int id, String dimension, String tipo) async {
    await (db.update(db.catalogoLlantas)..where((t) => t.id.equals(id)))
        .write(CatalogoLlantasCompanion(
            dimension: Value(dimension), tipo: Value(tipo)));
  }

  Future<void> borrarLlanta(int id) async {
    await (db.delete(db.catalogoLlantas)..where((t) => t.id.equals(id))).go();
  }

  // ---- Bancadas ----
  Future<int> crearBancada(String nombre) {
    return db.into(db.catalogoBancadas)
        .insert(CatalogoBancadasCompanion.insert(nombre: nombre));
  }

  Future<void> actualizarBancada(int id, String nombre) async {
    await (db.update(db.catalogoBancadas)..where((t) => t.id.equals(id)))
        .write(CatalogoBancadasCompanion(nombre: Value(nombre)));
  }

  Future<void> borrarBancada(int id) async {
    await (db.delete(db.catalogoBancadas)..where((t) => t.id.equals(id))).go();
  }

  // ---- Chasis ----
  Future<int> crearChasis(String nombre) {
    return db.into(db.catalogoChasis)
        .insert(CatalogoChasisCompanion.insert(nombre: nombre));
  }

  Future<void> actualizarChasis(int id, String nombre) async {
    await (db.update(db.catalogoChasis)..where((t) => t.id.equals(id)))
        .write(CatalogoChasisCompanion(nombre: Value(nombre)));
  }

  Future<void> borrarChasis(int id) async {
    await (db.delete(db.catalogoChasis)..where((t) => t.id.equals(id))).go();
  }

  // ---- Neumáticos ----
  Future<int> crearNeumatico(String nombre, String? referencia) {
    return db.into(db.catalogoNeumaticos).insert(
        CatalogoNeumaticosCompanion.insert(
            nombre: nombre, referencia: Value(referencia)));
  }

  Future<void> actualizarNeumatico(
      int id, String nombre, String? referencia) async {
    await (db.update(db.catalogoNeumaticos)..where((t) => t.id.equals(id)))
        .write(CatalogoNeumaticosCompanion(
            nombre: Value(nombre), referencia: Value(referencia)));
  }

  Future<void> borrarNeumatico(int id) async {
    await (db.delete(db.catalogoNeumaticos)..where((t) => t.id.equals(id)))
        .go();
  }

  // ---- Copas ----
  Future<int> crearCopa(String nombre) {
    return db.into(db.catalogoCopas)
        .insert(CatalogoCopasCompanion.insert(nombre: nombre));
  }

  Future<void> actualizarCopa(int id, String nombre) async {
    await (db.update(db.catalogoCopas)..where((t) => t.id.equals(id)))
        .write(CatalogoCopasCompanion(nombre: Value(nombre)));
  }

  Future<void> borrarCopa(int id) async {
    await (db.delete(db.catalogoCopas)..where((t) => t.id.equals(id))).go();
  }

  // ---- Clubs ----
  Future<int> crearClub(String nombre) {
    return db.into(db.catalogoClubs)
        .insert(CatalogoClubsCompanion.insert(nombre: nombre));
  }

  Future<void> actualizarClub(int id, String nombre) async {
    await (db.update(db.catalogoClubs)..where((t) => t.id.equals(id)))
        .write(CatalogoClubsCompanion(nombre: Value(nombre)));
  }

  Future<void> borrarClub(int id) async {
    await (db.delete(db.catalogoClubs)..where((t) => t.id.equals(id))).go();
  }
}

final repoCatalogosProvider = Provider<RepositorioCatalogos>((ref) {
  return RepositorioCatalogos(ref.watch(dbProvider));
});
