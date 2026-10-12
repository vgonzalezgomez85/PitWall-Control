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
import 'package:flutter_test/flutter_test.dart';
import 'package:pitwall/services/almacen_local.dart';
import 'package:pitwall/services/config_backup.dart';
import 'package:pitwall/services/google_auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<AlmacenLocal> almacenNuevo() async {
    SharedPreferences.setMockInitialValues({});
    return AlmacenLocal(await SharedPreferences.getInstance());
  }

  Archive zipCon(Map<String, String> archivos) {
    final archive = Archive();
    for (final e in archivos.entries) {
      final bytes = utf8.encode(e.value);
      archive.addFile(ArchiveFile(e.key, bytes.length, bytes));
    }
    return archive;
  }

  test('la copia incluye credenciales y preferencias, y nunca la sesión',
      () async {
    final a = await almacenNuevo();
    await a.write(key: GoogleAuthService.claveClientId, value: 'id-123');
    await a.write(key: GoogleAuthService.claveClientSecret, value: 'secreto-456');
    await a.write(key: 'google_refresh_token', value: 'token-de-sesion');
    await a.write(key: 'sync_nombre_dispositivo', value: 'Mesa 1');
    await a.write(key: 'tema_oscuro', value: '0');
    await a.write(key: 'pitwall_host', value: 'http://192.168.1.50');

    final texto = utf8.decode(ConfigBackup.construir(a));
    final json = jsonDecode(texto) as Map<String, dynamic>;

    expect(json['schema'], ConfigBackup.schema);
    expect((json['google'] as Map)['google_client_id'], 'id-123');
    expect((json['google'] as Map)['google_client_secret'], 'secreto-456');
    expect((json['preferencias'] as Map)['tema_oscuro'], '0');
    expect((json['preferencias'] as Map)['pitwall_host'], 'http://192.168.1.50');
    // La sesión y el nombre del dispositivo no viajan jamás.
    expect(texto, isNot(contains('token-de-sesion')));
    expect(texto, isNot(contains('Mesa 1')));
  });

  test('leerDeZip encuentra config.json y descarta lo ilegible', () {
    final conConfig = zipCon({
      'pitwall.sqlite': 'no-es-json',
      ConfigBackup.nombreEnZip:
          jsonEncode({'schema': 1, 'google': {}, 'preferencias': {}}),
    });
    expect(ConfigBackup.leerDeZip(conConfig)?['schema'], 1);

    final sinConfig = zipCon({'pitwall.sqlite': 'no-es-json'});
    expect(ConfigBackup.leerDeZip(sinConfig), isNull);

    final configRota = zipCon({ConfigBackup.nombreEnZip: '{no es json'});
    expect(ConfigBackup.leerDeZip(configRota), isNull);
  });

  test('aplicar restaura credenciales y preferencias y cierra la sesión vieja',
      () async {
    final a = await almacenNuevo();
    await a.write(key: GoogleAuthService.claveClientId, value: 'cliente-viejo');
    await a.write(
        key: GoogleAuthService.claveClientSecret, value: 'secreto-viejo');
    await a.write(key: 'google_refresh_token', value: 'sesion-vieja');
    await a.write(key: 'google_account_email', value: 'viejo@correo.com');

    final reconectar = await ConfigBackup.aplicar(a, {
      'schema': 1,
      'google': {
        'google_client_id': 'cliente-nuevo',
        'google_client_secret': 'secreto-nuevo',
      },
      'preferencias': {'tema_oscuro': '0', 'pitwall_host': 'http://10.0.0.9'},
    });

    expect(reconectar, isTrue);
    expect(a.readSync(key: GoogleAuthService.claveClientId), 'cliente-nuevo');
    expect(
        a.readSync(key: GoogleAuthService.claveClientSecret), 'secreto-nuevo');
    // La sesión era de las credenciales anteriores: se cierra.
    expect(a.readSync(key: 'google_refresh_token'), isNull);
    expect(a.readSync(key: 'google_account_email'), isNull);
    expect(a.readSync(key: 'tema_oscuro'), '0');
    expect(a.readSync(key: 'pitwall_host'), 'http://10.0.0.9');
  });

  test('con las mismas credenciales no se toca la sesión', () async {
    final a = await almacenNuevo();
    await a.write(key: GoogleAuthService.claveClientId, value: 'mismo-id');
    await a.write(
        key: GoogleAuthService.claveClientSecret, value: 'mismo-secreto');
    await a.write(key: 'google_refresh_token', value: 'sesion-viva');

    final reconectar = await ConfigBackup.aplicar(a, {
      'google': {
        'google_client_id': 'mismo-id',
        'google_client_secret': 'mismo-secreto',
      },
    });

    expect(reconectar, isFalse);
    expect(a.readSync(key: 'google_refresh_token'), 'sesion-viva');
  });

  test('una copia sin credenciales no pisa las locales', () async {
    final a = await almacenNuevo();
    await a.write(key: GoogleAuthService.claveClientId, value: 'mia');
    await a.write(key: GoogleAuthService.claveClientSecret, value: 'mi-secreto');
    await a.write(key: 'google_refresh_token', value: 'sesion');

    // Sin bloque google, con él vacío y con el secreto en blanco: ninguno
    // de los tres debe tocar nada.
    for (final google in [
      null,
      <String, Object?>{},
      {'google_client_id': 'otra', 'google_client_secret': ' '},
    ]) {
      final json = <String, Object?>{
        'schema': 1,
        'preferencias': <String, Object?>{},
      };
      if (google != null) json['google'] = google;
      final reconectar = await ConfigBackup.aplicar(a, json);
      expect(reconectar, isFalse);
    }

    expect(a.readSync(key: GoogleAuthService.claveClientId), 'mia');
    expect(a.readSync(key: GoogleAuthService.claveClientSecret), 'mi-secreto');
    expect(a.readSync(key: 'google_refresh_token'), 'sesion');
  });
}
