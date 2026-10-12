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
import 'package:pitwall/core/widgets/acciones_barra.dart';

Future<void> _montar(WidgetTester tester, double ancho, List<String> pulsados) {
  tester.view.physicalSize = Size(ancho, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  return tester.pumpWidget(MaterialApp(
    home: Scaffold(
      appBar: AppBar(actions: [
        AccionesBarra([
          AccionBarra(
            icono: Icons.edit,
            etiqueta: 'Editar',
            onPressed: () => pulsados.add('editar'),
          ),
          AccionBarra(
            icono: Icons.ios_share,
            etiqueta: 'Exportar',
            opciones: [
              OpcionAccion(Icons.picture_as_pdf, 'PDF', () => pulsados.add('pdf')),
            ],
          ),
          AccionBarra(
            icono: Icons.delete,
            etiqueta: 'Eliminar',
            principal: false,
            onPressed: () => pulsados.add('eliminar'),
          ),
        ]),
      ]),
    ),
  ));
}

void main() {
  testWidgets('en ventana ancha las principales llevan texto', (tester) async {
    final pulsados = <String>[];
    await _montar(tester, 1200, pulsados);
    expect(find.text('Editar'), findsOneWidget);
    expect(find.text('Exportar'), findsOneWidget);
    expect(find.text('Eliminar'), findsNothing); // va al menú «⋯»

    await tester.tap(find.text('Editar'));
    await tester.tap(find.text('Exportar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('PDF'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Más opciones'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Eliminar'));
    await tester.pumpAndSettle();
    expect(pulsados, ['editar', 'pdf', 'eliminar']);
  });

  testWidgets('en ventana estrecha todo va al menú con su texto',
      (tester) async {
    final pulsados = <String>[];
    await _montar(tester, 400, pulsados);
    expect(find.text('Editar'), findsNothing);

    await tester.tap(find.byTooltip('Más opciones'));
    await tester.pumpAndSettle();
    expect(find.text('Editar'), findsOneWidget);
    expect(find.text('Exportar: PDF'), findsOneWidget);
    expect(find.text('Eliminar'), findsOneWidget);
    await tester.tap(find.text('Exportar: PDF'));
    await tester.pumpAndSettle();
    expect(pulsados, ['pdf']);
  });
}
