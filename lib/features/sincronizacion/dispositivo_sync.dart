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

// Identidad de este Control para la sincronización por wifi entre Controls.
// Los repositorios la usan para firmar cada cambio (quién y cuándo) sin
// depender de Riverpod; se carga en main() desde el almacén local.

import 'dart:async';
import 'dart:io';
import 'dart:math';

import '../../services/almacen_local.dart';

const claveNombreDispositivo = 'sync_nombre_dispositivo';

class DispositivoSync {
  DispositivoSync._();

  static String _nombre = 'Control';

  /// Nombre con el que este Control firma sus cambios y se anuncia en la red.
  /// Tiene que ser distinto en cada dispositivo.
  static String get nombre => _nombre;

  static void cargar(AlmacenLocal almacen) {
    final guardado = almacen.readSync(key: claveNombreDispositivo)?.trim();
    if (guardado != null && guardado.isNotEmpty) {
      _nombre = guardado;
      return;
    }
    // Primera vez: nombre del equipo y, si es genérico (en Android sale
    // "localhost"), uno aleatorio. Se guarda para que no cambie.
    _nombre = _nombrePorDefecto();
    unawaited(almacen.write(key: claveNombreDispositivo, value: _nombre));
  }

  static Future<void> cambiar(AlmacenLocal almacen, String nombre) async {
    final limpio = nombre.trim();
    if (limpio.isEmpty) return;
    _nombre = limpio;
    await almacen.write(key: claveNombreDispositivo, value: limpio);
  }

  static String _nombrePorDefecto() {
    try {
      final h = Platform.localHostname.replaceAll('.local', '').trim();
      if (h.isNotEmpty && h.toLowerCase() != 'localhost') return h;
    } catch (_) {}
    final n = Random().nextInt(9000) + 1000;
    return 'Control $n';
  }
}

/// Marca de tiempo de los cambios sincronizables (ms desde epoch, UTC).
int ahoraMsSync() => DateTime.now().millisecondsSinceEpoch;
