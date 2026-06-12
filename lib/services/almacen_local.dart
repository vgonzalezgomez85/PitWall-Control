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
