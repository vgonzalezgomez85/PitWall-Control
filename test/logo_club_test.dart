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
import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:pdf/widgets.dart' as pw;
import 'package:pitwall/data/database/app_database.dart';
import 'package:pitwall/services/logo_club.dart';
import 'package:pitwall/services/pdf_marca.dart';

Uint8List _png(int ancho, int alto) =>
    Uint8List.fromList(img.encodePng(img.Image(width: ancho, height: alto)));

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('el logo se reduce a 400 px de lado mayor y se guarda en PNG', () {
    final logo = prepararLogoClub(_png(1200, 600))!;
    final leido = img.decodePng(logo)!;
    expect(leido.width, ladoMaximoLogoClub);
    expect(leido.height, 200);

    // Uno pequeño no se agranda.
    final pequeno = img.decodePng(prepararLogoClub(_png(120, 300))!)!;
    expect((pequeno.width, pequeno.height), (120, 300));
  });

  test('un archivo que no es imagen se rechaza', () {
    expect(prepararLogoClub(Uint8List.fromList([1, 2, 3, 4])), isNull);
  });

  test('la cabecera del PDF lleva el club y el logo del campeonato',
      () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final id = await db.into(db.campeonatos).insert(
        CampeonatosCompanion.insert(
            nombre: 'Liga',
            formato: 'PAREJAS',
            anio: 2026,
            clubOrganizador: const Value('Club Slot Test'),
            logoClub: Value(prepararLogoClub(_png(800, 400)))));
    final camp = await (db.select(db.campeonatos)
          ..where((t) => t.id.equals(id)))
        .getSingle();
    expect(camp.clubOrganizador, 'Club Slot Test');

    final marca = await MarcaPdf.cargar(campeonato: camp);
    expect(marca.club, 'Club Slot Test');
    expect(marca.logoClub, isNotNull);

    // Sin club ni logo, la cabecera queda como siempre.
    final sinClub = await MarcaPdf.cargar();
    expect(sinClub.club, isNull);
    expect(sinClub.logoClub, isNull);

    final pdf = pw.Document()
      ..addPage(pw.Page(
          build: (_) => marca.hero(titulo: 'PitWall', subtitulo: 'Prueba')));
    expect((await pdf.save()).length, greaterThan(1000));
  });
}
