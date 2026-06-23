import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import '../ajustes/pantalla_marca.dart';
import '../campeonatos/editor_campeonato.dart';
import '../campeonatos/pantalla_campeonatos.dart';
import '../catalogos/pantalla_catalogos.dart';
import '../clasificacion/pantalla_clasificacion.dart';
import '../creditos/pantalla_creditos.dart';
import '../equipos/lista_equipos.dart';
import '../google/pantalla_configuracion_google.dart';
import '../pilotos/lista_pilotos.dart';
import '../pruebas/lista_pruebas.dart';
import '../tesoreria/pantalla_tesoreria.dart';
import '../verificaciones/pantalla_elegir_prueba_sorteo.dart';
import '../verificaciones/pantalla_resumen_verificaciones.dart';
import '../wordpress/pantalla_wordpress.dart';
import 'pantalla_resumen.dart';

/// Destino principal del shell (un icono + título en la barra lateral).
class _Destino {
  const _Destino(this.icono, this.iconoSel, this.titulo, this.pantalla);
  final IconData icono;
  final IconData iconoSel;
  final String titulo;
  final Widget pantalla;
}

const _destinos = <_Destino>[
  _Destino(Icons.home_outlined, Icons.home, 'Inicio', PantallaResumen()),
  _Destino(Icons.people_alt_outlined, Icons.people_alt, 'Pilotos',
      PantallaPilotos()),
  _Destino(Icons.groups_outlined, Icons.groups, 'Equipos', PantallaEquipos()),
  _Destino(Icons.event_outlined, Icons.event, 'Pruebas', PantallaPruebas()),
  _Destino(Icons.fact_check_outlined, Icons.fact_check, 'Verificaciones',
      PantallaResumenVerificaciones()),
  _Destino(Icons.leaderboard_outlined, Icons.leaderboard, 'Clasificación',
      PantallaClasificacion()),
  _Destino(Icons.payments_outlined, Icons.payments, 'Tesorería',
      PantallaTesoreria()),
  _Destino(Icons.savings_outlined, Icons.savings, 'Créditos',
      PantallaCreditos()),
  _Destino(Icons.cloud_upload_outlined, Icons.cloud_upload, 'Publicar',
      PantallaWordpress()),
];

/// Destinos visibles según las reglas del campeonato activo: oculta Tesorería
/// y/o Créditos cuando el campeonato no los usa.
List<_Destino> _destinosVisibles(Campeonato? activo) => [
      for (final d in _destinos)
        if (!(d.titulo == 'Tesorería' && !(activo?.usaTesoreria ?? true)) &&
            !(d.titulo == 'Créditos' && !(activo?.usaCreditos ?? true)))
          d,
    ];

/// Índice del destino con [titulo] dentro de la lista visible para [activo],
/// o -1 si ese destino está oculto. Lo usan los accesos rápidos del dashboard
/// para navegar al módulo correcto aunque haya botones ocultos.
int indiceDestinoVisible(String titulo, Campeonato? activo) =>
    _destinosVisibles(activo).indexWhere((d) => d.titulo == titulo);

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campeonatosAsync = ref.watch(campeonatosProvider);

    return campeonatosAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (campeonatos) {
        if (campeonatos.isEmpty) {
          return const _Vacio();
        }
        // Auto-selecciona el primero si no hay activo.
        final activo = ref.watch(campeonatoActivoProvider);
        if (activo == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref
                .read(campeonatoActivoProvider.notifier)
                .seleccionar(campeonatos.first);
          });
        }
        return _ShellConContenido(campeonatos: campeonatos);
      },
    );
  }
}

class _ShellConContenido extends ConsumerWidget {
  const _ShellConContenido({required this.campeonatos});

  final List<Campeonato> campeonatos;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activo = ref.watch(campeonatoActivoProvider);
    final destinos = _destinosVisibles(activo);
    final indice =
        ref.watch(shellIndiceProvider).clamp(0, destinos.length - 1);
    final ancho = MediaQuery.sizeOf(context).width;
    final extendida = ancho > 1100;

    return Scaffold(
      body: Row(
        children: [
          _BarraLateral(
            indice: indice,
            extendida: extendida,
            campeonatos: campeonatos,
            destinos: destinos,
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(
            child: IndexedStack(
              index: indice,
              children: [for (final d in destinos) d.pantalla],
            ),
          ),
        ],
      ),
    );
  }
}

class _BarraLateral extends ConsumerWidget {
  const _BarraLateral({
    required this.indice,
    required this.extendida,
    required this.campeonatos,
    required this.destinos,
  });

  final int indice;
  final bool extendida;
  final List<Campeonato> campeonatos;
  final List<_Destino> destinos;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: NavigationRail(
                extended: extendida,
                minWidth: 72,
                minExtendedWidth: 220,
                selectedIndex: indice,
                onDestinationSelected: (i) =>
                    ref.read(shellIndiceProvider.notifier).ir(i),
                leading: _SelectorCampeonatoRail(
                  campeonatos: campeonatos,
                  extendida: extendida,
                ),
                trailing: Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: extendida ? 220 : 72,
                      child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Divider(indent: 12, endIndent: 12),
                          _AccionSecundaria(
                            icono: Icons.casino_outlined,
                            etiqueta: 'Sorteo de motor',
                            extendida: extendida,
                            destino: const PantallaElegirPruebaSorteo(),
                          ),
                          _AccionSecundaria(
                            icono: Icons.emoji_events_outlined,
                            etiqueta: 'Campeonatos',
                            extendida: extendida,
                            destino: const PantallaCampeonatos(),
                          ),
                          _AccionSecundaria(
                            icono: Icons.inventory_2_outlined,
                            etiqueta: 'Catálogos',
                            extendida: extendida,
                            destino: const PantallaCatalogos(),
                          ),
                          _AccionSecundaria(
                            icono: Icons.cloud_outlined,
                            etiqueta: 'Google Sheets',
                            extendida: extendida,
                            destino: const PantallaConfiguracionGoogle(),
                          ),
                          _AccionSecundaria(
                            icono: Icons.branding_watermark_outlined,
                            etiqueta: 'Marca / Exportaciones',
                            extendida: extendida,
                            destino: const PantallaMarca(),
                          ),
                          _BotonTema(extendida: extendida),
                        ],
                      ),
                    ),
                    ),
                  ),
                ),
                destinations: [
                  for (final d in destinos)
                    NavigationRailDestination(
                      icon: Icon(d.icono),
                      selectedIcon: Icon(d.iconoSel, color: color.primary),
                      label: Text(d.titulo),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Selector compacto del campeonato activo, en la cabecera de la barra.
class _SelectorCampeonatoRail extends ConsumerWidget {
  const _SelectorCampeonatoRail({
    required this.campeonatos,
    required this.extendida,
  });

  final List<Campeonato> campeonatos;
  final bool extendida;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Theme.of(context).colorScheme;
    final activo = ref.watch(campeonatoActivoProvider) ?? campeonatos.first;

    void elegir(Campeonato c) =>
        ref.read(campeonatoActivoProvider.notifier).seleccionar(c);

    if (!extendida) {
      // Solo el trofeo; al pulsar, menú para cambiar de campeonato.
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: PopupMenuButton<int>(
          tooltip: 'Campeonato: ${activo.nombre}',
          icon: Icon(Icons.emoji_events, color: color.primary),
          onSelected: (id) =>
              elegir(campeonatos.firstWhere((c) => c.id == id)),
          itemBuilder: (_) => [
            for (final c in campeonatos)
              PopupMenuItem(value: c.id, child: Text(c.nombre)),
          ],
        ),
      );
    }

    return Container(
      width: 200,
      margin: const EdgeInsets.fromLTRB(8, 12, 8, 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Campeonato activo',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color.onPrimaryContainer.withValues(alpha: 0.8),
                  )),
          DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              isExpanded: true,
              value: activo.id,
              borderRadius: BorderRadius.circular(12),
              iconEnabledColor: color.onPrimaryContainer,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: color.onPrimaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
              items: [
                for (final c in campeonatos)
                  DropdownMenuItem(value: c.id, child: Text(c.nombre)),
              ],
              onChanged: (id) =>
                  elegir(campeonatos.firstWhere((c) => c.id == id)),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccionSecundaria extends StatelessWidget {
  const _AccionSecundaria({
    required this.icono,
    required this.etiqueta,
    required this.extendida,
    required this.destino,
  });

  final IconData icono;
  final String etiqueta;
  final bool extendida;
  final Widget destino;

  @override
  Widget build(BuildContext context) {
    void abrir() => Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => destino));

    if (!extendida) {
      return IconButton(
        tooltip: etiqueta,
        icon: Icon(icono),
        onPressed: abrir,
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListTile(
        dense: true,
        leading: Icon(icono),
        title: Text(etiqueta),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: abrir,
      ),
    );
  }
}

/// Conmutador de modo claro/oscuro.
class _BotonTema extends ConsumerWidget {
  const _BotonTema({required this.extendida});
  final bool extendida;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final oscuro = ref.watch(temaOscuroProvider);
    final icono = oscuro ? Icons.light_mode_outlined : Icons.dark_mode_outlined;
    final etiqueta = oscuro ? 'Modo claro' : 'Modo oscuro';
    void alternar() => ref.read(temaOscuroProvider.notifier).alternar();

    if (!extendida) {
      return IconButton(
        tooltip: etiqueta,
        icon: Icon(icono),
        onPressed: alternar,
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListTile(
        dense: true,
        leading: Icon(icono),
        title: Text(etiqueta),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: alternar,
      ),
    );
  }
}

/// Estado cuando todavía no hay ningún campeonato creado.
class _Vacio extends StatelessWidget {
  const _Vacio();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
              const SizedBox(height: 24),
              FilledButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Crear campeonato'),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const EditorCampeonato())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
