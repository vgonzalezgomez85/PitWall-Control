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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Almacén persistente sencillo basado en SharedPreferences.
/// Se usa para credenciales de Google/WordPress en lugar de Keychain
/// (el Keychain requiere firma de código que no tenemos en desarrollo).
class AlmacenLocal {
  AlmacenLocal(this._prefs);
  final SharedPreferences _prefs;

  Future<String?> read({required String key}) async {
    return _prefs.getString(key);
  }

  /// Lectura síncrona (SharedPreferences mantiene los valores en memoria).
  String? readSync({required String key}) => _prefs.getString(key);

  Future<void> write({required String key, required String? value}) async {
    if (value == null) {
      await _prefs.remove(key);
    } else {
      await _prefs.setString(key, value);
    }
  }

  Future<void> delete({required String key}) async {
    await _prefs.remove(key);
  }
}

/// Provider síncrono; se sobrescribe en main() con la instancia ya inicializada.
final almacenSyncProvider = Provider<AlmacenLocal>((_) {
  throw UnimplementedError('almacenSyncProvider no fue inicializado en main()');
});
