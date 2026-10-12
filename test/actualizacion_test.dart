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
import 'package:flutter_test/flutter_test.dart';
import 'package:pitwall/features/actualizacion/actualizacion.dart';

void main() {
  group('compararVersiones', () {
    test('compara número a número, no como texto', () {
      expect(compararVersiones('1.33.0', '1.9.0'), greaterThan(0));
      expect(compararVersiones('1.9.0', '1.33.0'), lessThan(0));
      expect(compararVersiones('2.0.0', '1.99.99'), greaterThan(0));
      expect(compararVersiones('1.32.0', '1.32.0'), 0);
    });

    test('tolera versiones incompletas o con sufijo', () {
      expect(compararVersiones('1.32', '1.32.0'), 0);
      expect(compararVersiones('1.32.1-beta', '1.32.0'), greaterThan(0));
    });
  });

  group('leerManifiesto', () {
    test('lee un manifiesto completo', () {
      final m = leerManifiesto({
        'version': '1.33.0',
        'apk': 'PitWallControl.apk',
        'bytes': 83306429,
        'sha256': 'abc',
        'notas': ' Club organizador ',
      });
      expect(m, isNotNull);
      expect(m!.version, '1.33.0');
      expect(m.apk, 'PitWallControl.apk');
      expect(m.bytes, 83306429);
      expect(m.notas, 'Club organizador');
      expect(m.descargas, isEmpty);
    });

    test('rellena lo que falte con valores razonables', () {
      final m = leerManifiesto({'version': '1.33.0'});
      expect(m, isNotNull);
      expect(m!.apk, apkPorDefecto);
      expect(m.bytes, isNull);
      expect(m.notas, isNull);
      expect(m.descargas, isEmpty);
    });

    test('rechaza lo que no es un manifiesto', () {
      expect(leerManifiesto(null), isNull);
      expect(leerManifiesto({}), isNull);
      expect(leerManifiesto({'version': 'nueva'}), isNull);
      expect(leerManifiesto({'version': 133}), isNull);
      expect(leerManifiesto('<html>404</html>'), isNull);
    });

    test('lee las descargas de escritorio válidas', () {
      final m = leerManifiesto({
        'version': '1.33.0',
        'descargas': {
          'macos': 'PitWallControl-1.33.0-macOS-arm64.zip',
          'windows': 'PitWallControl-Setup-1.33.0.exe',
          'linux': 'PitWallControl-1.33.0-linux-x64.tar.gz',
        },
      });
      expect(m!.descargas, hasLength(3));
      expect(m.descargas['macos'], 'PitWallControl-1.33.0-macOS-arm64.zip');
    });

    test('ignora descargas con valores o claves inválidas', () {
      final m = leerManifiesto({
        'version': '1.33.0',
        'descargas': {
          'macos': 12,
          'windows': '   ',
          7: 'algo.exe',
          'linux': 'linux.tar.gz',
        },
      });
      expect(m!.descargas, {'linux': 'linux.tar.gz'});
    });

    test('sin descargas, el mapa queda vacío', () {
      expect(leerManifiesto({'version': '1.33.0'})!.descargas, isEmpty);
    });
  });

  group('hayVersionNueva', () {
    test('solo con manifiesto y versión posterior', () {
      expect(hayVersionNueva('1.32.0', leerManifiesto({'version': '1.33.0'})), isTrue);
      expect(hayVersionNueva('1.33.0', leerManifiesto({'version': '1.33.0'})), isFalse);
      expect(hayVersionNueva('1.34.0', leerManifiesto({'version': '1.33.0'})), isFalse);
      expect(hayVersionNueva('1.32.0', null), isFalse);
    });
  });

  group('urlDelApk y urlDeDescarga', () {
    const carpeta = 'https://www.pitwall.es/software/pitwall-control/';

    test('la del APK cuelga de la carpeta y lleva ?v para saltar la caché', () {
      final m = leerManifiesto({'version': '1.33.0'})!;
      expect(urlDelApk(carpeta, m), '$carpeta$apkPorDefecto?v=1.33.0');
    });

    test('respeta una URL absoluta', () {
      final m = leerManifiesto({'version': '1.33.0', 'apk': 'https://otro.example/x.apk'})!;
      expect(urlDelApk(carpeta, m), 'https://otro.example/x.apk');
    });

    test('la de escritorio no lleva ?v (no ensucia el nombre del fichero)', () {
      final m = leerManifiesto({
        'version': '1.33.0',
        'descargas': {'macos': 'PitWallControl-1.33.0-macOS-arm64.zip'},
      })!;
      expect(
        urlDeDescarga(carpeta, m, 'macos'),
        '${carpeta}PitWallControl-1.33.0-macOS-arm64.zip',
      );
      expect(urlDeDescarga(carpeta, m, 'windows'), isNull);
    });
  });

  group('debeComprobar', () {
    test('la primera vez, siempre', () {
      expect(debeComprobar(null, DateTime(2026, 10, 12)), isTrue);
    });

    test('cada 6 horas; antes, no', () {
      final ahora = DateTime(2026, 10, 12, 12);
      expect(debeComprobar(ahora.subtract(const Duration(hours: 5, minutes: 59)), ahora), isFalse);
      expect(debeComprobar(ahora.subtract(const Duration(hours: 6)), ahora), isTrue);
    });

    test('con el reloj hacia atrás, también', () {
      final ahora = DateTime(2026, 10, 12, 12);
      expect(debeComprobar(ahora.add(const Duration(hours: 1)), ahora), isTrue);
    });
  });

  group('estaAtascada', () {
    final t0 = DateTime(2026, 10, 12, 12);
    test('a los 29,9 s no; a los 30 s sí', () {
      expect(estaAtascada(t0, t0.add(const Duration(milliseconds: 29900))), isFalse);
      expect(estaAtascada(t0, t0.add(const Duration(seconds: 30))), isTrue);
    });
  });

  group('porcentaje', () {
    test('entero 0–100, con tope', () {
      expect(porcentaje(0, 1000), 0);
      expect(porcentaje(420, 1000), 42);
      expect(porcentaje(1000, 1000), 100);
      expect(porcentaje(1200, 1000), 100);
    });

    test('null si no se conoce el tamaño', () {
      expect(porcentaje(10, null), isNull);
      expect(porcentaje(10, 0), isNull);
    });
  });
}
