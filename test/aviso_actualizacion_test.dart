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
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pitwall/features/actualizacion/aviso_actualizacion.dart';
import 'package:pitwall/features/actualizacion/servicio_actualizacion.dart';

void main() {
  const nueva = Actualizacion(
    version: '1.33.0',
    url: 'https://www.pitwall.es/software/pitwall-control/PitWallControl.apk',
    bytes: 83471681,
    notas: 'Club organizador y logo',
  );

  testWidgets('la tarjeta enseña la versión nueva, las notas y sus botones',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: TarjetaActualizacion(nueva: nueva, onMasTarde: () {}),
      ),
    ));

    expect(find.text('Hay una versión nueva: v1.33.0'), findsOneWidget);
    expect(find.text('Club organizador y logo'), findsOneWidget);
    expect(find.text('Actualizar'), findsOneWidget);
    expect(find.text('Más tarde'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('en pruebas el aviso automático no consulta la web ni pinta nada',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(body: AvisoActualizacion()),
    ));

    expect(find.byType(TarjetaActualizacion), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
