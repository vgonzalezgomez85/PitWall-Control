import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/app_database.dart';

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
