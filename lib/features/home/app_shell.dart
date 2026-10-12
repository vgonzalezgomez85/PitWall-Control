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
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/entorno.dart';
import '../../core/proveedores.dart';
import '../../core/widgets/logo_pitwall.dart';
import '../../data/database/app_database.dart';
import '../ajustes/pantalla_ajustes.dart';
import '../ajustes/pantalla_changelog.dart';
import '../campeonatos/editor_campeonato.dart';
import '../campeonatos/pantalla_campeonatos.dart';
import '../catalogos/pantalla_catalogos.dart';
import '../clasificacion/pantalla_clasificacion.dart';
import '../creditos/pantalla_creditos.dart';
import '../participantes/pantalla_participantes.dart';
import '../pruebas/lista_pruebas.dart';
import '../tesoreria/pantalla_tesoreria.dart';
import '../verificacion_libre/pantalla_verificacion_libre.dart';
import 'pantalla_resumen.dart';

/// Bloque del menú lateral al que pertenece un destino.
enum _Grupo { campeonato, herramientas, ajustes }

/// Destino del shell (un icono + título en el menú lateral). Todos cambian la
/// vista sin apilar pantallas, también Herramientas y Ajustes.
class _Destino {
  const _Destino(
      this.icono, this.iconoSel, this.titulo, this.pantalla, this.grupo);
  final IconData icono;
  final IconData iconoSel;
  final String titulo;
  final Widget pantalla;
  final _Grupo grupo;
}

const _destinos = <_Destino>[
  _Destino(Icons.home_outlined, Icons.home, 'Inicio', PantallaResumen(),
      _Grupo.campeonato),
  _Destino(Icons.event_outlined, Icons.event, 'Pruebas', PantallaPruebas(),
      _Grupo.campeonato),
  _Destino(Icons.people_alt_outlined, Icons.people_alt, 'Participantes',
      PantallaParticipantes(), _Grupo.campeonato),
  _Destino(Icons.leaderboard_outlined, Icons.leaderboard, 'Clasificación',
      PantallaClasificacion(), _Grupo.campeonato),
  _Destino(Icons.payments_outlined, Icons.payments, 'Tesorería',
      PantallaTesoreria(), _Grupo.campeonato),
  _Destino(Icons.savings_outlined, Icons.savings, 'Créditos',
      PantallaCreditos(), _Grupo.campeonato),
  _Destino(Icons.fact_check_outlined, Icons.fact_check, 'Verificación libre',
      PantallaVerificacionLibre(), _Grupo.herramientas),
  _Destino(Icons.inventory_2_outlined, Icons.inventory_2, 'Catálogos',
      PantallaCatalogos(), _Grupo.herramientas),
  _Destino(Icons.emoji_events_outlined, Icons.emoji_events,
      'Gestionar campeonatos', PantallaCampeonatos(), _Grupo.herramientas),
  _Destino(Icons.settings_outlined, Icons.settings, 'Ajustes',
      PantallaAjustes(), _Grupo.ajustes),
];

const _titulosGrupo = {
  _Grupo.campeonato: 'CAMPEONATO',
  _Grupo.herramientas: 'HERRAMIENTAS',
};

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

class _ShellConContenido extends ConsumerStatefulWidget {
  const _ShellConContenido({required this.campeonatos});

  final List<Campeonato> campeonatos;

  @override
  ConsumerState<_ShellConContenido> createState() =>
      _ShellConContenidoState();
}

class _ShellConContenidoState extends ConsumerState<_ShellConContenido> {
  /// Destinos ya abiertos. Los demás no se construyen hasta la primera visita:
  /// Catálogos o Verificación libre no tienen por qué cargarse al arrancar.
  final _visitados = <String>{};

  @override
  Widget build(BuildContext context) {
    final activo = ref.watch(campeonatoActivoProvider);
    final destinos = _destinosVisibles(activo);
    final indice =
        ref.watch(shellIndiceProvider).clamp(0, destinos.length - 1);
    final ancho = MediaQuery.sizeOf(context).width;
    final extendida = ancho > 1100;
    _visitados.add(destinos[indice].titulo);

    final contenido = IndexedStack(
      index: indice,
      children: [
        for (final d in destinos)
          _visitados.contains(d.titulo) ? d.pantalla : const SizedBox.shrink(),
      ],
    );

    // Móvil: barra inferior en vez del menú lateral, que en un teléfono se
    // come el ancho de la pantalla.
    if (ancho < anchoMovil) {
      return _ShellMovil(
        indice: indice,
        destinos: destinos,
        campeonatos: widget.campeonatos,
        contenido: contenido,
      );
    }

    return Scaffold(
      body: Row(
        children: [
          _BarraLateral(
            indice: indice,
            extendida: extendida,
            campeonatos: widget.campeonatos,
            destinos: destinos,
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(child: contenido),
        ],
      ),
    );
  }
}

/// Por debajo de este ancho (móvil en vertical) el menú pasa abajo.
const anchoMovil = 600.0;

/// Destinos que van en la barra inferior del móvil; el resto, en «Más».
const _titulosBarraMovil = ['Inicio', 'Pruebas', 'Participantes', 'Clasificación'];

/// Navegación de móvil: barra inferior con los destinos de diario y «Más»
/// (campeonato activo, el resto de destinos y Ajustes) en una hoja.
class _ShellMovil extends ConsumerWidget {
  const _ShellMovil({
    required this.indice,
    required this.destinos,
    required this.campeonatos,
    required this.contenido,
  });

  final int indice;
  final List<_Destino> destinos;
  final List<Campeonato> campeonatos;
  final Widget contenido;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enBarra = [
      for (var i = 0; i < destinos.length; i++)
        if (_titulosBarraMovil.contains(destinos[i].titulo)) i
    ];
    final enMas = [
      for (var i = 0; i < destinos.length; i++)
        if (!enBarra.contains(i)) i
    ];
    final seleccion = enBarra.indexOf(indice);

    return Scaffold(
      body: contenido,
      bottomNavigationBar: NavigationBar(
        // Un destino de «Más» activo marca el botón «Más».
        selectedIndex: seleccion >= 0 ? seleccion : enBarra.length,
        onDestinationSelected: (i) {
          if (i < enBarra.length) {
            ref.read(shellIndiceProvider.notifier).ir(enBarra[i]);
          } else {
            _abrirMas(context, ref, enMas);
          }
        },
        destinations: [
          for (final i in enBarra)
            NavigationDestination(
              icon: Icon(destinos[i].icono),
              selectedIcon: Icon(destinos[i].iconoSel),
              label: destinos[i].titulo,
            ),
          const NavigationDestination(
            icon: Icon(Icons.menu),
            label: 'Más',
          ),
        ],
      ),
    );
  }

  void _abrirMas(BuildContext context, WidgetRef ref, List<int> enMas) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) {
        final activo = ref.read(campeonatoActivoProvider);
        void ir(int i) {
          Navigator.of(ctx).pop();
          ref.read(shellIndiceProvider.notifier).ir(i);
        }

        Widget cabecera(String t) => Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
              child: Text(t,
                  style: Theme.of(ctx).textTheme.labelSmall?.copyWith(
                        color: Theme.of(ctx).colorScheme.outline,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      )),
            );

        Widget item(int i) => ListTile(
              leading: Icon(i == indice
                  ? destinos[i].iconoSel
                  : destinos[i].icono),
              title: Text(destinos[i].titulo),
              selected: i == indice,
              onTap: () => ir(i),
            );

        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              cabecera('CAMPEONATO ACTIVO'),
              for (final c in campeonatos)
                ListTile(
                  leading: Icon(c.id == activo?.id
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked),
                  title: Text(c.nombre),
                  onTap: () {
                    ref.read(campeonatoActivoProvider.notifier).seleccionar(c);
                    Navigator.of(ctx).pop();
                  },
                ),
              for (final g in [_Grupo.campeonato, _Grupo.herramientas])
                if (enMas.any((i) => destinos[i].grupo == g)) ...[
                  cabecera(_titulosGrupo[g]!),
                  for (final i in enMas)
                    if (destinos[i].grupo == g) item(i),
                ],
              const Divider(),
              for (final i in enMas)
                if (destinos[i].grupo == _Grupo.ajustes) item(i),
            ],
          ),
        );
      },
    );
  }
}

/// Menú lateral en tres bloques: Campeonato, Herramientas y, abajo, Ajustes.
/// Extendido (ventana ancha) muestra títulos de bloque y nombres; plegado,
/// solo iconos con su nombre al pasar el ratón.
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
    void ir(int i) => ref.read(shellIndiceProvider.notifier).ir(i);

    Widget item(int i) => _ItemMenu(
          destino: destinos[i],
          seleccionado: i == indice,
          extendida: extendida,
          onTap: () => ir(i),
        );

    final principales = <Widget>[];
    _Grupo? grupoAnterior;
    for (var i = 0; i < destinos.length; i++) {
      final g = destinos[i].grupo;
      if (g == _Grupo.ajustes) continue;
      if (g != grupoAnterior) {
        principales.add(_CabeceraGrupo(
          titulo: _titulosGrupo[g]!,
          extendida: extendida,
          primera: grupoAnterior == null,
        ));
        grupoAnterior = g;
      }
      principales.add(item(i));
    }
    final iAjustes = destinos.indexWhere((d) => d.grupo == _Grupo.ajustes);

    return SizedBox(
      width: extendida ? 232 : 72,
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        child: SafeArea(
          right: false,
          child: Column(
            children: [
              const SizedBox(height: 14),
              _EncabezadoLogo(extendida: extendida),
              const SizedBox(height: 6),
              _SelectorCampeonatoRail(
                campeonatos: campeonatos,
                extendida: extendida,
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 8),
                  children: principales,
                ),
              ),
              const Divider(height: 1, indent: 12, endIndent: 12),
              const SizedBox(height: 6),
              if (iAjustes >= 0) item(iAjustes),
              if (extendida) const _VersionPie(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

/// Título de un bloque del menú (o un separador si está plegado).
class _CabeceraGrupo extends StatelessWidget {
  const _CabeceraGrupo({
    required this.titulo,
    required this.extendida,
    required this.primera,
  });

  final String titulo;
  final bool extendida;
  final bool primera;

  @override
  Widget build(BuildContext context) {
    if (!extendida) {
      return primera
          ? const SizedBox(height: 8)
          : const Divider(height: 24, indent: 16, endIndent: 16);
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(24, primera ? 12 : 20, 16, 6),
      child: Text(titulo,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              )),
    );
  }
}

class _ItemMenu extends StatelessWidget {
  const _ItemMenu({
    required this.destino,
    required this.seleccionado,
    required this.extendida,
    required this.onTap,
  });

  final _Destino destino;
  final bool seleccionado;
  final bool extendida;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final icono = Icon(
      seleccionado ? destino.iconoSel : destino.icono,
      color: seleccionado ? cs.onSecondaryContainer : cs.onSurfaceVariant,
    );
    final fondo = seleccionado ? cs.secondaryContainer : Colors.transparent;

    if (!extendida) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        child: Tooltip(
          message: destino.titulo,
          child: Material(
            color: fondo,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onTap,
              child: SizedBox(height: 40, child: Center(child: icono)),
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
      child: Material(
        color: fondo,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            child: Row(
              children: [
                icono,
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    destino.titulo,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: seleccionado
                              ? cs.onSecondaryContainer
                              : cs.onSurfaceVariant,
                          fontWeight:
                              seleccionado ? FontWeight.w700 : FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Logo + wordmark de PitWall Control en la cabecera del menú lateral.
class _EncabezadoLogo extends StatelessWidget {
  const _EncabezadoLogo({required this.extendida});
  final bool extendida;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (!extendida) {
      return const LogoPitwall(size: 34);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const LogoPitwall(size: 34),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PitWall',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          height: 1,
                        )),
                Text('CONTROL',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 3,
                      fontWeight: FontWeight.w700,
                      color: cs.primary,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Valor del selector que abre «Gestionar campeonatos» (los id son > 0).
const _gestionar = -1;

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

    // `_gestionar` no es un campeonato: abre la lista para crear o editar.
    void elegir(int? id) {
      if (id == _gestionar) {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const PantallaCampeonatos()));
        return;
      }
      ref
          .read(campeonatoActivoProvider.notifier)
          .seleccionar(campeonatos.firstWhere((c) => c.id == id));
    }

    if (!extendida) {
      // Solo el trofeo; al pulsar, menú para cambiar de campeonato.
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: PopupMenuButton<int>(
          tooltip: 'Campeonato: ${activo.nombre}',
          icon: Icon(Icons.emoji_events, color: color.primary),
          onSelected: elegir,
          itemBuilder: (_) => [
            for (final c in campeonatos)
              PopupMenuItem(value: c.id, child: Text(c.nombre)),
            const PopupMenuDivider(),
            const PopupMenuItem(
                value: _gestionar, child: Text('Gestionar campeonatos…')),
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
                DropdownMenuItem(
                  value: _gestionar,
                  child: Text('Gestionar campeonatos…',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: color.onPrimaryContainer.withValues(alpha: 0.8),
                      )),
                ),
              ],
              onChanged: elegir,
            ),
          ),
        ],
      ),
    );
  }
}

/// Acceso de la pantalla sin campeonatos: abre [destino] encima.
class _AccionSecundaria extends StatelessWidget {
  const _AccionSecundaria({
    required this.icono,
    required this.etiqueta,
    required this.destino,
  });

  final IconData icono;
  final String etiqueta;
  final Widget destino;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListTile(
        dense: true,
        leading: Icon(icono),
        title: Text(etiqueta),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => destino)),
      ),
    );
  }
}

/// Número de versión al pie de la barra lateral, como en PitWall Manager:
/// enlaza al historial de "Novedades". Solo en el rail extendido — en el
/// colapsado (72px) no cabe con margen para ser legible.
class _VersionPie extends StatelessWidget {
  const _VersionPie();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snap) {
        final v = snap.data?.version;
        if (v == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(top: 4),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const PantallaChangelog(),
            )),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(esEntornoDev ? 'v$v DEV' : 'v$v',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      )),
            ),
          ),
        );
      },
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
              const LogoPitwall(size: 96),
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
              const SizedBox(height: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.fact_check_outlined),
                label: const Text('Solo verificar coches'),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const PantallaVerificacionLibre())),
              ),
              const SizedBox(height: 28),
              // Sin campeonato también hay que poder preparar el catálogo y,
              // desde Ajustes, conectar Google o restaurar una copia.
              const Wrap(
                alignment: WrapAlignment.center,
                children: [
                  _OpcionVacio(
                    child: _AccionSecundaria(
                      icono: Icons.inventory_2_outlined,
                      etiqueta: 'Catálogos',
                      destino: PantallaCatalogos(),
                    ),
                  ),
                  _OpcionVacio(
                    child: _AccionSecundaria(
                      icono: Icons.settings_outlined,
                      etiqueta: 'Ajustes y copias',
                      destino: PantallaAjustes(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Ancho fijo para las opciones de la pantalla sin campeonatos.
class _OpcionVacio extends StatelessWidget {
  const _OpcionVacio({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => SizedBox(width: 220, child: child);
}
