import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import '../clasificacion/repositorio_clasificacion.dart';
import '../verificaciones/pantalla_elegir_prueba_sorteo.dart';
import 'app_shell.dart';

/// Datos agregados del campeonato activo para el dashboard de inicio.
class _DatosResumen {
  final int numPilotos;
  final int numEquipos;
  final int numPruebas;
  final int pruebasTerminadas;
  final Prueba? proxima;

  _DatosResumen({
    required this.numPilotos,
    required this.numEquipos,
    required this.numPruebas,
    required this.pruebasTerminadas,
    required this.proxima,
  });
}

final _resumenProvider =
    StreamProvider.autoDispose<_DatosResumen?>((ref) {
  final db = ref.watch(dbProvider);
  final activo = ref.watch(campeonatoActivoProvider);
  if (activo == null) return Stream.value(null);

  return (db.select(db.pruebas)
        ..where((t) => t.campeonatoId.equals(activo.id)))
      .watch()
      .asyncMap((pruebas) async {
    final perfiles = await (db.select(db.pilotoCampeonato)
          ..where((t) => t.campeonatoId.equals(activo.id)))
        .get();
    final equipos = await (db.select(db.equipos)
          ..where((t) =>
              t.campeonatoId.equals(activo.id) & t.activo.equals(true)))
        .get();
    pruebas.sort((a, b) => a.orden.compareTo(b.orden));
    final pendientes = pruebas
        .where((p) => p.estado == 'PROGRAMADA' || p.estado == 'EN_CURSO')
        .toList();
    return _DatosResumen(
      numPilotos: perfiles.length,
      numEquipos: equipos.length,
      numPruebas: pruebas.length,
      pruebasTerminadas:
          pruebas.where((p) => p.estado == 'TERMINADA').length,
      proxima: pendientes.isEmpty ? null : pendientes.first,
    );
  });
});

/// Pantalla de inicio del shell: resumen del campeonato + accesos rápidos.
///
/// Las tarjetas no abren pantallas nuevas: cambian el módulo activo del
/// shell mediante [shellIndiceProvider], evitando navegación apilada.
class PantallaResumen extends ConsumerWidget {
  const PantallaResumen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activo = ref.watch(campeonatoActivoProvider);
    final resumenAsync = ref.watch(_resumenProvider);
    final clasifAsync = ref.watch(clasificacionProvider);
    final color = Theme.of(context).colorScheme;
    final resumen = resumenAsync.asData?.value;

    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            color: color.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(Icons.emoji_events,
                      size: 40, color: color.onPrimaryContainer),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Campeonato activo',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: color.onPrimaryContainer
                                      .withValues(alpha: 0.8),
                                )),
                        const SizedBox(height: 4),
                        Text(
                          activo?.nombre ?? '—',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: color.onPrimaryContainer),
                        ),
                        if (activo != null)
                          Text(
                            activo.formato,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: color.onPrimaryContainer
                                      .withValues(alpha: 0.8),
                                ),
                          ),
                      ],
                    ),
                  ),
                  if (resumen != null)
                    Wrap(
                      spacing: 8,
                      children: [
                        _StatChip(
                            icono: Icons.people_alt_outlined,
                            valor: '${resumen.numPilotos}',
                            etiqueta: 'pilotos'),
                        _StatChip(
                            icono: Icons.groups_outlined,
                            valor: '${resumen.numEquipos}',
                            etiqueta: 'equipos'),
                        _StatChip(
                            icono: Icons.event_outlined,
                            valor:
                                '${resumen.pruebasTerminadas}/${resumen.numPruebas}',
                            etiqueta: 'pruebas'),
                      ],
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Próxima prueba + líder, lado a lado si hay anchura.
          LayoutBuilder(builder: (context, c) {
            final lider = clasifAsync.asData?.value.filas.firstOrNull;
            final tarjetas = <Widget>[
              _TarjetaProxima(prueba: resumen?.proxima),
              _TarjetaLider(
                nombre: lider?.pilotoNombre,
                equipo: lider?.equipoNombre,
                puntos: lider?.totalNeto,
              ),
            ];
            if (c.maxWidth > 640) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: tarjetas[0]),
                  const SizedBox(width: 12),
                  Expanded(child: tarjetas[1]),
                ],
              );
            }
            return Column(children: [
              tarjetas[0],
              const SizedBox(height: 12),
              tarjetas[1],
            ]);
          }),
          const SizedBox(height: 24),
          Text('Accesos rápidos',
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
              // Cada acceso resuelve su índice dentro de la lista de destinos
              // visible (oculta Tesorería/Créditos si el campeonato no los usa).
              for (final a in const [
                (Icons.people_alt_outlined, 'Pilotos', 'Pilotos'),
                (Icons.groups_outlined, 'Equipos', 'Equipos'),
                (Icons.event_outlined, 'Pruebas y mangas', 'Pruebas'),
                (Icons.fact_check_outlined, 'Verificaciones', 'Verificaciones'),
                (Icons.leaderboard_outlined, 'Clasificación', 'Clasificación'),
                (Icons.payments_outlined, 'Tesorería', 'Tesorería'),
                (Icons.savings_outlined, 'Créditos', 'Créditos'),
                (Icons.cloud_upload_outlined, 'Publicar en web', 'Publicar'),
              ])
                if (indiceDestinoVisible(a.$3, activo) >= 0)
                  _TarjetaAcceso(
                      a.$1, a.$2, indiceDestinoVisible(a.$3, activo)),
              const _TarjetaRuta(
                  Icons.casino_outlined, 'Sorteo de motor',
                  PantallaElegirPruebaSorteo()),
            ],
          ),
        ],
      ),
    );
  }

  int _columnas(BuildContext context) {
    final ancho = MediaQuery.sizeOf(context).width;
    if (ancho > 1100) return 4;
    if (ancho > 700) return 3;
    return 2;
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icono,
    required this.valor,
    required this.etiqueta,
  });
  final IconData icono;
  final String valor;
  final String etiqueta;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.onPrimaryContainer.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icono, size: 16, color: color.onPrimaryContainer),
              const SizedBox(width: 4),
              Text(valor,
                  style: TextStyle(
                      color: color.onPrimaryContainer,
                      fontWeight: FontWeight.w800,
                      fontSize: 16)),
            ],
          ),
          Text(etiqueta,
              style: TextStyle(
                  color: color.onPrimaryContainer.withValues(alpha: 0.8),
                  fontSize: 11)),
        ],
      ),
    );
  }
}

class _TarjetaProxima extends ConsumerWidget {
  const _TarjetaProxima({required this.prueba});
  final Prueba? prueba;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final fmt = DateFormat("EEEE d 'de' MMMM", 'es_ES');
    final p = prueba;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => ref.read(shellIndiceProvider.notifier).ir(3),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: cs.secondaryContainer,
                child: Icon(Icons.flag_outlined,
                    color: cs.onSecondaryContainer),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Próxima prueba',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: cs.outline)),
                    Text(
                      p?.nombre ?? 'No hay pruebas pendientes',
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (p != null)
                      Text(
                        [
                          if (p.fecha != null) fmt.format(p.fecha!),
                          if (p.sede != null && p.sede!.isNotEmpty) p.sede!,
                        ].join(' · '),
                        style: TextStyle(color: cs.outline, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: cs.outline),
            ],
          ),
        ),
      ),
    );
  }
}

class _TarjetaLider extends ConsumerWidget {
  const _TarjetaLider({
    required this.nombre,
    required this.equipo,
    required this.puntos,
  });
  final String? nombre;
  final String? equipo;
  final int? puntos;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => ref.read(shellIndiceProvider.notifier).ir(5),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFFFFF3CD),
                child: Icon(Icons.emoji_events, color: Color(0xFFE6A700)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Líder del campeonato',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: cs.outline)),
                    Text(
                      nombre ?? 'Sin resultados todavía',
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (nombre != null)
                      Text(
                        '${equipo ?? ''}  ·  $puntos pts',
                        style: TextStyle(color: cs.outline, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: cs.outline),
            ],
          ),
        ),
      ),
    );
  }
}

/// Acceso rápido que empuja una pantalla nueva (no un módulo del shell).
class _TarjetaRuta extends StatelessWidget {
  const _TarjetaRuta(this.icono, this.titulo, this.destino);

  final IconData icono;
  final String titulo;
  final Widget destino;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => destino)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
      ),
    );
  }
}

class _TarjetaAcceso extends ConsumerWidget {
  const _TarjetaAcceso(this.icono, this.titulo, this.indice);

  final IconData icono;
  final String titulo;
  final int indice;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => ref.read(shellIndiceProvider.notifier).ir(indice),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
      ),
    );
  }
}
