import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import '../campeonatos/pantalla_campeonatos.dart';
import '../campeonatos/selector_campeonato.dart';
import '../catalogos/pantalla_catalogos.dart';
import '../equipos/lista_equipos.dart';
import '../google/pantalla_configuracion_google.dart';
import '../pilotos/lista_pilotos.dart';
import '../pruebas/lista_pruebas.dart';
import '../clasificacion/pantalla_clasificacion.dart';
import '../creditos/pantalla_creditos.dart';
import '../tesoreria/pantalla_tesoreria.dart';
import '../verificaciones/pantalla_resumen_verificaciones.dart';
import '../wordpress/pantalla_wordpress.dart';

class PantallaInicio extends ConsumerWidget {
  const PantallaInicio({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campeonatosAsync = ref.watch(campeonatosProvider);
    final activo = ref.watch(campeonatoActivoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PitWall'),
        actions: [
          IconButton(
            tooltip: 'Gestionar campeonatos',
            icon: const Icon(Icons.emoji_events_outlined),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const PantallaCampeonatos())),
          ),
          IconButton(
            tooltip: 'Catálogos',
            icon: const Icon(Icons.inventory_2_outlined),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const PantallaCatalogos())),
          ),
          IconButton(
            tooltip: 'Google Sheets',
            icon: const Icon(Icons.cloud_outlined),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const PantallaConfiguracionGoogle())),
          ),
        ],
      ),
      body: campeonatosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (campeonatos) {
          if (campeonatos.isEmpty) {
            return const _Vacio();
          }
          // Auto-selecciona el primero si no hay activo
          if (activo == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(campeonatoActivoProvider.notifier).seleccionar(campeonatos.first);
            });
          }
          return _Contenido(campeonatos: campeonatos, activo: activo ?? campeonatos.first);
        },
      ),
    );
  }
}

class _Vacio extends StatelessWidget {
  const _Vacio();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events_outlined,
                size: 96, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 24),
            Text('Aún no hay campeonatos',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Crea el primer campeonato para empezar a gestionar pruebas y resultados.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _Contenido extends ConsumerWidget {
  const _Contenido({required this.campeonatos, required this.activo});

  final List<Campeonato> campeonatos;
  final Campeonato activo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        SelectorCampeonato(campeonatos: campeonatos, activo: activo),
        const SizedBox(height: 24),
        Text('¿Qué quieres hacer?',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: _columnas(context),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.4,
          children: [
            _TarjetaAccion(
              icono: Icons.people_alt_outlined,
              titulo: 'Pilotos',
              destino: (_) => const PantallaPilotos(),
            ),
            _TarjetaAccion(
              icono: Icons.groups_outlined,
              titulo: 'Equipos',
              destino: (_) => const PantallaEquipos(),
            ),
            _TarjetaAccion(
              icono: Icons.event_outlined,
              titulo: 'Pruebas y mangas',
              destino: (_) => const PantallaPruebas(),
            ),
            _TarjetaAccion(
              icono: Icons.fact_check_outlined,
              titulo: 'Verificaciones',
              destino: (_) => const PantallaResumenVerificaciones(),
            ),
            _TarjetaAccion(
              icono: Icons.leaderboard_outlined,
              titulo: 'Clasificación',
              destino: (_) => const PantallaClasificacion(),
            ),
            _TarjetaAccion(
              icono: Icons.payments_outlined,
              titulo: 'Tesorería',
              destino: (_) => const PantallaTesoreria(),
            ),
            _TarjetaAccion(
              icono: Icons.savings_outlined,
              titulo: 'Créditos',
              destino: (_) => const PantallaCreditos(),
            ),
            _TarjetaAccion(
              icono: Icons.cloud_upload_outlined,
              titulo: 'Publicar en web',
              destino: (_) => const PantallaWordpress(),
            ),
          ],
        ),
      ],
    );
  }

  int _columnas(BuildContext context) {
    final ancho = MediaQuery.sizeOf(context).width;
    if (ancho > 1100) return 4;
    if (ancho > 700) return 3;
    return 2;
  }
}

class _TarjetaAccion extends StatelessWidget {
  const _TarjetaAccion({
    required this.icono,
    required this.titulo,
    this.destino,
  });

  final IconData icono;
  final String titulo;
  final WidgetBuilder? destino;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (destino != null) {
            Navigator.of(context).push(MaterialPageRoute(builder: destino!));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Próximamente: $titulo')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icono, size: 44, color: color.primary),
              const SizedBox(height: 12),
              Text(titulo,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}
