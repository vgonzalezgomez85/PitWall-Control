import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/proveedores.dart';
import 'core/tema.dart';
import 'data/database/seeds.dart';
import 'features/home/pantalla_inicio.dart';
import 'services/almacen_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES');
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        almacenSyncProvider.overrideWithValue(AlmacenLocal(prefs)),
      ],
      child: const AppResisbarna(),
    ),
  );
}

class AppResisbarna extends ConsumerStatefulWidget {
  const AppResisbarna({super.key});

  @override
  ConsumerState<AppResisbarna> createState() => _AppResisbarnaState();
}

class _AppResisbarnaState extends ConsumerState<AppResisbarna> {
  bool _semillaLista = false;

  @override
  void initState() {
    super.initState();
    _sembrar();
  }

  Future<void> _sembrar() async {
    final db = ref.read(dbProvider);
    await Seeds.sembrar(db);
    if (mounted) setState(() => _semillaLista = true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resisbarna',
      debugShowCheckedModeBanner: false,
      theme: TemaApp.claro(),
      locale: const Locale('es', 'ES'),
      supportedLocales: const [Locale('es', 'ES'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: _semillaLista
          ? const PantallaInicio()
          : const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
