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

import 'package:image/image.dart' as img;

/// Lado máximo (px) del logo del club guardado: basta para la cabecera de
/// un PDF y mantiene la base de datos (y las copias) ligeras.
const ladoMaximoLogoClub = 400;

/// Prepara el logo del club para guardarlo: lo decodifica, lo reduce para
/// que su lado mayor no pase de [ladoMaximoLogoClub] y lo guarda como PNG
/// (conserva la transparencia). Devuelve null si el formato no se puede leer
/// (p. ej. HEIC).
Uint8List? prepararLogoClub(Uint8List bytes) {
  img.Image? imagen;
  try {
    imagen = img.decodeImage(bytes);
  } catch (_) {
    // Con datos que no son imagen, algunos decodificadores lanzan en vez de
    // devolver null.
    imagen = null;
  }
  if (imagen == null) return null;
  final grande = imagen.width >= imagen.height
      ? imagen.width > ladoMaximoLogoClub
      : imagen.height > ladoMaximoLogoClub;
  final reducida = !grande
      ? imagen
      : imagen.width >= imagen.height
          ? img.copyResize(imagen,
              width: ladoMaximoLogoClub,
              interpolation: img.Interpolation.average)
          : img.copyResize(imagen,
              height: ladoMaximoLogoClub,
              interpolation: img.Interpolation.average);
  return Uint8List.fromList(img.encodePng(reducida));
}
