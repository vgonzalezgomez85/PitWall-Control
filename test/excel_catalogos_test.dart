import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:excel/excel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pitwall/data/database/app_database.dart';
import 'package:pitwall/services/excel_catalogos.dart';

void main() {
  test('export -> editar -> reimport (ida y vuelta)', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());

    // Semilla mínima en varios catálogos
    final cocheId = await db.into(db.catalogoCoches).insert(
        CatalogoCochesCompanion.insert(
            nombre: 'BMW M8', marca: 'SCA', modelo: 'M8 GTE', pesoMin: 78.5,
            copasJson: const Value('["GT","GT2"]')));
    await db.into(db.catalogoLlantas).insert(CatalogoLlantasCompanion.insert(
        dimension: '15,8 x 8 PL', tipo: 'DELANTERA',
        copasJson: const Value('["GT"]')));
    await db.into(db.catalogoClubs).insert(CatalogoClubsCompanion.insert(nombre: 'EL SOT'));

    // 1) EXPORTAR
    final bytes = await exportarCatalogosExcel(db);
    final libro = Excel.decodeBytes(bytes);
    expect(libro.tables.keys, containsAll(
        ['Coches','Marcas','Llantas','Engranajes','Motores','Bancadas','Chasis','Neumaticos','Copas','Clubs']));
    expect(libro.tables['Coches']!.rows.length, 2); // cabecera + 1
    // el coche exportado lleva su ID y las copas como "GT;GT2"
    final filaCoche = libro.tables['Coches']!.rows[1];
    expect(filaCoche[0]!.value.toString(), '$cocheId');
    expect(filaCoche[6]!.value.toString(), 'GT;GT2');

    // 2) EDITAR en la hoja: cambiar el peso del coche existente (por ID)
    //    y añadir un club NUEVO sin ID.
    libro.updateCell('Coches', CellIndex.indexByString('E2'), DoubleCellValue(80.0));
    libro.appendRow('Clubs', [null, TextCellValue('SLOT FOR YOU')]);
    final editado = Uint8List.fromList(libro.save()!);

    // 3) REIMPORTAR
    final res = await importarCatalogosExcel(db, editado);

    final coche = await (db.select(db.catalogoCoches)..where((t) => t.id.equals(cocheId))).getSingle();
    expect(coche.pesoMin, 80.0, reason: 'la fila con ID se ACTUALIZA');
    expect(jsonDecode(coche.copasJson), ['GT','GT2'], reason: 'las copas sobreviven al ciclo');

    final clubs = await db.select(db.catalogoClubs).get();
    expect(clubs.map((c) => c.nombre), containsAll(['EL SOT','SLOT FOR YOU']));
    expect(clubs.length, 2, reason: 'la fila sin ID se CREA, no se duplica la existente');

    final llantas = await db.select(db.catalogoLlantas).get();
    expect(llantas.length, 1, reason: 'nada se borra ni se duplica');
    expect(jsonDecode(llantas.first.copasJson!), ['GT']);

    expect(res.totalCreados, 1);
    expect(res.errores, isEmpty);

    await db.close();
  });
}
