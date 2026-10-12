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
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:image_picker/image_picker.dart';

/// Extensiones que se ofrecen al elegir una imagen desde un archivo.
const extensionesImagen = ['png', 'jpg', 'jpeg', 'webp', 'gif', 'bmp'];

/// Elige una imagen ya guardada. En Android/iOS abre la galería; en
/// escritorio, el selector de archivos del sistema: `image_picker` no tiene
/// implementación registrada en macOS y la llamada se queda esperando sin
/// abrir nada.
Future<XFile?> elegirImagenDeArchivo({String? etiqueta}) async {
  if (Platform.isAndroid || Platform.isIOS) {
    return ImagePicker().pickImage(source: ImageSource.gallery);
  }
  return openFile(acceptedTypeGroups: [
    XTypeGroup(
        label: etiqueta ?? 'Imágenes', extensions: extensionesImagen),
  ]);
}
