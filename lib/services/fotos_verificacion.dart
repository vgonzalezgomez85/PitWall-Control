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
