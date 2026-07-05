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

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Helpers para localizar las fotos de verificación.
///
/// Las fotos se guardan en `<docs>/fotos_verificaciones/<nombre>.jpg` y en la
/// base de datos solo se almacena el **nombre del archivo** (no la ruta
/// absoluta) para que la copia de seguridad sea portable entre dispositivos.
class FotosVerificacion {
  static const _carpeta = 'fotos_verificaciones';

  /// Carpeta donde viven las fotos en este dispositivo (la crea si no existe).
  static Future<Directory> carpeta() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, _carpeta));
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  /// Resuelve una entrada del `fotosJson` (puede ser nombre o ruta absoluta
  /// antigua) al archivo local actual de este dispositivo.
  static Future<File> resolver(String entrada) async {
    final dir = await carpeta();
    // Compatibilidad: si tiene separadores, nos quedamos solo con el basename.
    final nombre = p.basename(entrada);
    return File(p.join(dir.path, nombre));
  }

  /// Convierte una entrada (ruta absoluta antigua o nombre) al nombre que se
  /// guarda en la BD.
  static String nombreParaBd(String entrada) => p.basename(entrada);
}
