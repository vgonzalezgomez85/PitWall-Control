import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/app_database.dart';
import '../services/almacen_local.dart';

/// Instancia única de la base de datos.
final dbProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Lista de campeonatos disponibles.
final campeonatosProvider = StreamProvider<List<Campeonato>>((ref) {
  final db = ref.watch(dbProvider);
  return db.select(db.campeonatos).watch();
});

/// Campeonato activo (seleccionado por el usuario).
class CampeonatoActivoNotifier extends Notifier<Campeonato?> {
  @override
  Campeonato? build() => null;

  void seleccionar(Campeonato c) => state = c;
}

final campeonatoActivoProvider =
    NotifierProvider<CampeonatoActivoNotifier, Campeonato?>(
        CampeonatoActivoNotifier.new);

/// Índice del módulo seleccionado en el shell de navegación.
class ShellIndiceNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void ir(int indice) => state = indice;
}

final shellIndiceProvider =
    NotifierProvider<ShellIndiceNotifier, int>(ShellIndiceNotifier.new);

/// Preferencia de modo oscuro, persistida en SharedPreferences.
class TemaOscuroNotifier extends Notifier<bool> {
  static const _clave = 'tema_oscuro';

  @override
  bool build() =>
      ref.read(almacenSyncProvider).readSync(key: _clave) == '1';

  Future<void> alternar() async {
    state = !state;
    await ref
        .read(almacenSyncProvider)
        .write(key: _clave, value: state ? '1' : '0');
  }
}

final temaOscuroProvider =
    NotifierProvider<TemaOscuroNotifier, bool>(TemaOscuroNotifier.new);
