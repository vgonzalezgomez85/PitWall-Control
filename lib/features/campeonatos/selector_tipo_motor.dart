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

import '../../core/idioma.dart';

/// Tipo de motor de un campeonato (o sesión libre) en el editor: 'ORGANIZACION'
/// (sorteo), 'PROPIO' o 'MIXTO' (en BD se guarda null). Null = sin elegir.
String? tipoMotorDeBd(String? tipoMotor) => tipoMotor ?? 'MIXTO';

/// Valor a guardar en BD para lo elegido en [SelectorTipoMotor].
String? tipoMotorABd(String? tipoMotor) =>
    tipoMotor == 'MIXTO' ? null : tipoMotor;

/// Hay rango de sorteo cuando los motores pueden ser de la organización.
bool tipoMotorConSorteo(String? tipoMotor) =>
    tipoMotor == 'ORGANIZACION' || tipoMotor == 'MIXTO';

/// Selector Sorteo / Propio / Mixto con su explicación debajo.
class SelectorTipoMotor extends StatelessWidget {
  const SelectorTipoMotor({
    super.key,
    required this.valor,
    required this.onCambio,
  });

  final String? valor;
  final ValueChanged<String?> onCambio;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          switch (valor) {
            'ORGANIZACION' => context.l.tipoMotorSorteoTexto,
            'PROPIO' => context.l.tipoMotorPropioTexto,
            'MIXTO' => context.l.tipoMotorMixtoTexto,
            _ => context.l.tipoMotorEligeTexto,
          },
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        SegmentedButton<String>(
          emptySelectionAllowed: true,
          segments: [
            ButtonSegment(
              value: 'ORGANIZACION',
              label: Text(context.l.sorteoEtiqueta),
              icon: const Icon(Icons.casino_outlined),
            ),
            ButtonSegment(
              value: 'PROPIO',
              label: Text(context.l.propio),
              icon: const Icon(Icons.engineering_outlined),
            ),
            ButtonSegment(
              value: 'MIXTO',
              label: Text(context.l.mixto),
              icon: const Icon(Icons.shuffle),
            ),
          ],
          selected: {?valor},
          onSelectionChanged: (s) => onCambio(s.firstOrNull),
        ),
      ],
    );
  }
}
