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

// ============== Engranajes (piñones y coronas) ==============
final engranajesCatalogoProvider =
    StreamProvider.autoDispose<List<CatalogoEngranaje>>((ref) {
  final db = ref.watch(dbProvider);
  return (db.select(db.catalogoEngranajes)
        ..orderBy([
          (t) => OrderingTerm.asc(t.tipo),
          (t) => OrderingTerm.asc(t.marca),
          (t) => OrderingTerm.asc(t.dientes),
        ]))
      .watch();
});

// ============== Motores ==============
final motoresCatalogoProvider =
    StreamProvider.autoDispose<List<CatalogoMotore>>((ref) {
  final db = ref.watch(dbProvider);
  return (db.select(db.catalogoMotores)
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
    String? copasJson,
    String? fotoPath,
  }) {
    return db.into(db.catalogoCoches).insert(CatalogoCochesCompanion.insert(
          nombre: nombre,
          marca: marca,
          modelo: modelo,
          pesoMin: pesoMin,
          creditosCoche: Value(creditosCoche),
          copasJson:
              copasJson == null ? const Value.absent() : Value(copasJson),
          fotoPath: Value(fotoPath),
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
  Future<int> crearLlanta(String dimension, String tipo,
      {String? copasJson}) {
    return db.into(db.catalogoLlantas).insert(
        CatalogoLlantasCompanion.insert(
            dimension: dimension,
            tipo: tipo,
            copasJson:
                copasJson == null ? const Value.absent() : Value(copasJson)));
  }

  Future<void> actualizarLlanta(int id, String dimension, String tipo,
      {String? copasJson}) async {
    await (db.update(db.catalogoLlantas)..where((t) => t.id.equals(id)))
        .write(CatalogoLlantasCompanion(
            dimension: Value(dimension),
            tipo: Value(tipo),
            copasJson:
                copasJson == null ? const Value.absent() : Value(copasJson)));
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
  Future<int> crearNeumatico(String nombre, String? referencia,
      {String? copasJson}) {
    return db.into(db.catalogoNeumaticos).insert(
        CatalogoNeumaticosCompanion.insert(
            nombre: nombre,
            referencia: Value(referencia),
            copasJson:
                copasJson == null ? const Value.absent() : Value(copasJson)));
  }

  Future<void> actualizarNeumatico(
      int id, String nombre, String? referencia,
      {String? copasJson}) async {
    await (db.update(db.catalogoNeumaticos)..where((t) => t.id.equals(id)))
        .write(CatalogoNeumaticosCompanion(
            nombre: Value(nombre),
            referencia: Value(referencia),
            copasJson:
                copasJson == null ? const Value.absent() : Value(copasJson)));
  }

  Future<void> borrarNeumatico(int id) async {
    await (db.delete(db.catalogoNeumaticos)..where((t) => t.id.equals(id)))
        .go();
  }

  // ---- Engranajes (piñones y coronas) ----
  Future<int> crearEngranaje({
    required String tipo, // PINON | CORONA
    required String marca,
    required int dientes,
    String? copasJson,
  }) {
    return db.into(db.catalogoEngranajes).insert(
        CatalogoEngranajesCompanion.insert(
            tipo: tipo,
            marca: marca,
            dientes: dientes,
            copasJson:
                copasJson == null ? const Value.absent() : Value(copasJson)));
  }

  Future<void> actualizarEngranaje(
      int id, String tipo, String marca, int dientes,
      {String? copasJson}) async {
    await (db.update(db.catalogoEngranajes)..where((t) => t.id.equals(id)))
        .write(CatalogoEngranajesCompanion(
            tipo: Value(tipo),
            marca: Value(marca),
            dientes: Value(dientes),
            copasJson:
                copasJson == null ? const Value.absent() : Value(copasJson)));
  }

  Future<void> borrarEngranaje(int id) async {
    await (db.delete(db.catalogoEngranajes)..where((t) => t.id.equals(id)))
        .go();
  }

  // ---- Motores ----
  Future<int> crearMotor({
    required String nombre,
    int? rpm,
    double? gauss,
    String? copasJson,
  }) {
    return db.into(db.catalogoMotores).insert(CatalogoMotoresCompanion.insert(
          nombre: nombre,
          rpm: Value(rpm),
          gauss: Value(gauss),
          copasJson:
              copasJson == null ? const Value.absent() : Value(copasJson),
        ));
  }

  Future<void> actualizarMotor(int id, CatalogoMotoresCompanion c) async {
    await (db.update(db.catalogoMotores)..where((t) => t.id.equals(id)))
        .write(c);
  }

  Future<void> borrarMotor(int id) async {
    await (db.delete(db.catalogoMotores)..where((t) => t.id.equals(id))).go();
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
