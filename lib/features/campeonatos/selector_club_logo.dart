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

import 'package:flutter/material.dart';

import '../../services/elegir_imagen.dart';
import '../../services/logo_club.dart';

/// Nombre del club organizador y su logo, para la cabecera de las
/// exportaciones. Lo usan el editor de campeonato y el reglamento de la
/// verificación libre.
class SelectorClubLogo extends StatelessWidget {
  const SelectorClubLogo({
    super.key,
    required this.club,
    required this.logo,
    required this.onLogo,
  });

  final TextEditingController club;
  final Uint8List? logo;
  final ValueChanged<Uint8List?> onLogo;

  Future<void> _elegir(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final xfile = await elegirImagenDeArchivo();
      if (xfile == null) return;
      final preparado = prepararLogoClub(await xfile.readAsBytes());
      if (preparado == null) {
        messenger.showSnackBar(const SnackBar(
            content: Text('No se puede leer esa imagen. Usa un PNG o JPG.')));
        return;
      }
      onLogo(preparado);
    } catch (e) {
      messenger.showSnackBar(
          SnackBar(content: Text('No se pudo añadir el logo: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: club,
          decoration: const InputDecoration(
            labelText: 'Nombre del club',
            hintText: 'Ej: Club Slot Barcelona',
            prefixIcon: Icon(Icons.flag_outlined),
          ),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              width: 96,
              height: 72,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                // Blanco, como en la cabecera del PDF.
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: cs.outlineVariant),
              ),
              child: logo == null
                  ? Icon(Icons.image_outlined, color: cs.outline)
                  : Image.memory(logo!, fit: BoxFit.contain),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    icon: const Icon(Icons.upload_outlined),
                    label: Text(logo == null ? 'Elegir logo' : 'Cambiar logo'),
                    onPressed: () => _elegir(context),
                  ),
                  if (logo != null)
                    TextButton.icon(
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Quitar'),
                      onPressed: () => onLogo(null),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text('PNG o JPG. Se reduce a ${ladoMaximoLogoClub}px.',
            style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
