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

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pitwall/features/actualizacion/servicio_actualizacion.dart';

/// Cliente de mentira: la comprobación contra la web, sin salir a internet.
http.Client _cliente(int codigo, Object cuerpo) => MockClient(
      (_) async => http.Response(
        cuerpo is String ? cuerpo : jsonEncode(cuerpo),
        codigo,
        headers: {'content-type': 'application/json'},
      ),
    );

void main() {
  final plataforma = plataformaEscritorio();

  test('hay versión nueva: en Android, el APK con su tamaño; en escritorio, su instalador',
      () async {
    final r = await comprobarActualizacion(
      '1.32.0',
      cliente: _cliente(200, {
        'version': '1.33.0',
        'apk': 'PitWallControl.apk',
        'bytes': 83471681,
        'notas': 'Club organizador',
        if (plataforma != null) 'descargas': {plataforma: 'PitWallControl-1.33.0.zip'},
      }),
    );

    expect(r.estado, EstadoBusqueda.nueva);
    final nueva = r.actualizacion!;
    expect(nueva.version, '1.33.0');
    expect(nueva.notas, 'Club organizador');
    if (plataforma == null) {
      expect(nueva.esApk, isTrue);
      expect(nueva.bytes, 83471681);
      expect(nueva.url, contains('PitWallControl.apk?v=1.33.0'));
    } else {
      // En escritorio el APK no se descarga dentro de la app: se abre el
      // navegador en el instalador de esa plataforma.
      expect(nueva.esApk, isFalse);
      expect(nueva.url, contains('PitWallControl-1.33.0.zip'));
    }
  });

  test('la instalada es la última → al día', () async {
    final r = await comprobarActualizacion(
      '1.33.0',
      cliente: _cliente(200, {'version': '1.33.0'}),
    );
    expect(r.estado, EstadoBusqueda.alDia);
  });

  test('sin red o respuesta que no es el manifiesto → error', () async {
    expect((await comprobarActualizacion('1.32.0', cliente: _cliente(404, '<html/>'))).estado,
        EstadoBusqueda.error);
    expect((await comprobarActualizacion('1.32.0', cliente: _cliente(200, '<html/>'))).estado,
        EstadoBusqueda.error);

    final caido = MockClient((_) async => throw SocketExceptionFalsa());
    expect((await comprobarActualizacion('1.32.0', cliente: caido)).estado, EstadoBusqueda.error);
  });

  test('en escritorio, sin instalador publicado para esta plataforma no se avisa', () async {
    if (plataforma == null) return; // En Android el APK siempre vale.
    final r = await comprobarActualizacion(
      '1.32.0',
      cliente: _cliente(200, {
        'version': '1.33.0',
        'descargas': {'ventana': 'otro.exe'},
      }),
    );
    expect(r.estado, EstadoBusqueda.alDia);
  });

  test('en escritorio, con instalador de esta plataforma se ofrece su enlace', () async {
    if (plataforma == null) return;
    final r = await comprobarActualizacion(
      '1.32.0',
      cliente: _cliente(200, {
        'version': '1.33.0',
        'descargas': {plataforma: 'PitWallControl-1.33.0.zip'},
      }),
    );
    expect(r.estado, EstadoBusqueda.nueva);
    expect(r.actualizacion!.esApk, isFalse);
    expect(r.actualizacion!.url, endsWith('PitWallControl-1.33.0.zip'));
  });
}

/// Un fallo de red cualquiera (no se usa `SocketException` para no depender de
/// `dart:io` en el nombre).
class SocketExceptionFalsa implements Exception {
  SocketExceptionFalsa();
}
