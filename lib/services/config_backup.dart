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
import 'dart:convert';

import 'package:archive/archive.dart';

import 'almacen_local.dart';
import 'google_auth_service.dart';

/// Configuración del programa que acompaña a la copia (BD + fotos):
/// credenciales del proyecto Google Cloud y preferencias básicas.
///
/// Nunca incluye la *sesión* conectada (tokens ni cuenta de correo): cada
/// dispositivo autoriza su propia cuenta de Google, y una copia compartida
/// entre personas no debe arrastrar la conexión de quien la subió.
class ConfigBackup {
  ConfigBackup._();

  /// Nombre del archivo de configuración dentro del ZIP de la copia.
  static const nombreEnZip = 'config.json';

  /// Versión del formato de este archivo.
  static const schema = 1;

  /// Preferencias que viajan en la copia. A propósito NO están:
  /// - la sesión de Google (`google_access_token`, `google_refresh_token`…),
  /// - `sync_nombre_dispositivo` ni la clave/grupo de "verificar entre
  ///   varios": el nombre identifica a un dispositivo físico, y dos equipos
  ///   con el mismo nombre se pisan al sincronizar.
  static const clavesPreferencias = [
    'tema_oscuro',
    'export_idioma',
    // Última conexión con el servidor PitWall Manager (mismos nombres que
    // usan los diálogos de enviar tanda / traer resultados).
    'pitwall_host',
    'pitwall_pin',
  ];

  /// Construye el contenido de `config.json` con la configuración guardada
  /// en este equipo.
  static List<int> construir(AlmacenLocal almacen) {
    final google = <String, String>{};
    for (final clave in [
      GoogleAuthService.claveClientId,
      GoogleAuthService.claveClientSecret,
    ]) {
      final valor = almacen.readSync(key: clave);
      if (valor != null && valor.isNotEmpty) {
        google[clave] = valor;
      }
    }
    final preferencias = <String, String>{};
    for (final clave in clavesPreferencias) {
      final valor = almacen.readSync(key: clave);
      if (valor != null) {
        preferencias[clave] = valor;
      }
    }
    final json = <String, Object>{
      'schema': schema,
      'generado': DateTime.now().toUtc().toIso8601String(),
      'google': google,
      'preferencias': preferencias,
    };
    return utf8.encode(jsonEncode(json));
  }

  /// Lee `config.json` de un ZIP ya decodificado. Devuelve `null` si no
  /// existe (copias anteriores a este formato) o no se puede interpretar.
  static Map<String, dynamic>? leerDeZip(Archive archive) {
    for (final f in archive) {
      if (!f.isFile) continue;
      if (f.name != nombreEnZip && !f.name.endsWith('/$nombreEnZip')) {
        continue;
      }
      try {
        final json = jsonDecode(utf8.decode(f.content as List<int>));
        if (json is Map<String, dynamic>) return json;
      } catch (_) {}
      return null;
    }
    return null;
  }

  /// Aplica la configuración de la copia sobre este equipo.
  ///
  /// Las credenciales de Google solo se escriben si la copia las trae (las
  /// locales nunca se borran por una copia sin credenciales). Si cambian
  /// respecto a las que había, se cierra la sesión anterior — sus tokens ya
  /// no sirven para las credenciales nuevas — y hay que volver a conectar.
  ///
  /// Devuelve `true` si hay que reconectar con Google.
  static Future<bool> aplicar(
      AlmacenLocal almacen, Map<String, dynamic> json) async {
    final google =
        (json['google'] as Map?)?.cast<String, Object?>() ?? const {};
    final id = (google[GoogleAuthService.claveClientId] as String?)?.trim() ?? '';
    final secret =
        (google[GoogleAuthService.claveClientSecret] as String?)?.trim() ?? '';
    var hayQueReconectar = false;
    if (id.isNotEmpty && secret.isNotEmpty) {
      final idActual = almacen.readSync(key: GoogleAuthService.claveClientId);
      final secretActual =
          almacen.readSync(key: GoogleAuthService.claveClientSecret);
      if (idActual != id || secretActual != secret) {
        await almacen.write(key: GoogleAuthService.claveClientId, value: id);
        await almacen.write(
            key: GoogleAuthService.claveClientSecret, value: secret);
        for (final clave in GoogleAuthService.clavesSesion) {
          await almacen.delete(key: clave);
        }
        hayQueReconectar = true;
      }
    }
    final preferencias =
        (json['preferencias'] as Map?)?.cast<String, Object?>() ?? const {};
    for (final clave in clavesPreferencias) {
      final valor = preferencias[clave];
      if (valor is String) await almacen.write(key: clave, value: valor);
    }
    return hayQueReconectar;
  }
}
