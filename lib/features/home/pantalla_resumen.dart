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
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/idioma.dart';
import '../../core/tema.dart';
import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import '../actualizacion/aviso_actualizacion.dart';
import '../clasificacion/repositorio_clasificacion.dart';
import '../pruebas/detalle_prueba.dart';
import '../pruebas/pantalla_inscritos.dart';
import '../tesoreria/repositorio_tesoreria.dart';
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

/// Pendientes del campeonato activo para el Inicio.
class _DatosPendientes {
  _DatosPendientes({required this.verifSinValidar, required this.sinResultados});

  /// Equipos inscritos en las tandas de la próxima prueba sin verificación
  /// validada.
  final int verifSinValidar;

  /// Pruebas no canceladas con fecha anterior a hoy y ningún resultado.
  final List<Prueba> sinResultados;
}

final _pendientesProvider =
    StreamProvider.autoDispose<_DatosPendientes?>((ref) {
  final db = ref.watch(dbProvider);
  final activo = ref.watch(campeonatoActivoProvider);
  if (activo == null) return Stream.value(null);

  // Se recalcula cuando cambia cualquiera de estas tablas.
  final disparador = db.customSelect('SELECT 1', readsFrom: {
    db.pruebas,
    db.mangas,
    db.inscripciones,
    db.verificaciones,
    db.resultados,
  }).watch();

  return disparador.asyncMap((_) async {
    final pruebas = await (db.select(db.pruebas)
          ..where((t) => t.campeonatoId.equals(activo.id))
          ..orderBy([(t) => OrderingTerm.asc(t.orden)]))
        .get();
    // Misma «próxima prueba» que la tarjeta de arriba.
    final proxima = pruebas
        .where((p) => p.estado == 'PROGRAMADA' || p.estado == 'EN_CURSO')
        .firstOrNull;

    var verifSinValidar = 0;
    if (proxima != null) {
      final fila = await db.customSelect(
        'SELECT COUNT(*) AS n FROM inscripciones i '
        'JOIN mangas m ON m.id = i.manga_id '
        'WHERE m.prueba_id = ? AND NOT EXISTS ('
        '  SELECT 1 FROM verificaciones v '
        '  WHERE v.manga_id = i.manga_id AND v.equipo_id = i.equipo_id '
        '  AND v.validado = 1)',
        variables: [Variable.withInt(proxima.id)],
      ).getSingle();
      verifSinValidar = fila.read<int>('n');
    }

    final hoy = DateTime.now();
    final inicioHoy = DateTime(hoy.year, hoy.month, hoy.day);
    final sinResultados = <Prueba>[];
    for (final p in pruebas) {
      if (p.estado == 'CANCELADA') continue;
      if (p.fecha == null || !p.fecha!.isBefore(inicioHoy)) continue;
      final fila = await db.customSelect(
        'SELECT COUNT(*) AS n FROM resultados r '
        'JOIN mangas m ON m.id = r.manga_id WHERE m.prueba_id = ?',
        variables: [Variable.withInt(p.id)],
      ).getSingle();
      if (fila.read<int>('n') == 0) sinResultados.add(p);
    }
    return _DatosPendientes(
        verifSinValidar: verifSinValidar, sinResultados: sinResultados);
  });
});

/// Pantalla de inicio del shell: qué toca ahora. Campeonato activo, próxima
/// prueba con accesos directos (Inscritos · Verificar · Resultados),
/// pendientes con su número y líder del campeonato.
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
      appBar: AppBar(title: Text(context.l.menuInicio)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const AvisoActualizacion(),
          Card(
            color: color.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(20),
              // En un móvil las cifras no caben junto al nombre: van debajo.
              child: LayoutBuilder(builder: (context, c) {
                final estrecha = c.maxWidth < 520;
                final cifras = resumen == null
                    ? null
                    : Wrap(
                        spacing: 8,
                        children: [
                          _StatChip(
                              icono: Icons.people_alt_outlined,
                              valor: '${resumen.numPilotos}',
                              etiqueta: context.l.statPilotos),
                          _StatChip(
                              icono: Icons.groups_outlined,
                              valor: '${resumen.numEquipos}',
                              etiqueta: context.l.statEquipos),
                          _StatChip(
                              icono: Icons.event_outlined,
                              valor:
                                  '${resumen.pruebasTerminadas}/${resumen.numPruebas}',
                              etiqueta: context.l.statPruebas),
                        ],
                      );
                final cabecera = Row(
                  children: [
                    Icon(Icons.emoji_events,
                        size: 40, color: color.onPrimaryContainer),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.l.campeonatoActivo,
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
                    if (!estrecha && cifras != null) cifras,
                  ],
                );
                if (!estrecha || cifras == null) return cabecera;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [cabecera, const SizedBox(height: 12), cifras],
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          _TarjetaProxima(prueba: resumen?.proxima),
          const SizedBox(height: 24),
          Text(context.l.pendientes, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          _Pendientes(proxima: resumen?.proxima),
          const SizedBox(height: 24),
          _TarjetaLider(
            nombre: clasifAsync.asData?.value.filas.firstOrNull?.pilotoNombre,
            equipo: clasifAsync.asData?.value.filas.firstOrNull?.equipoNombre,
            puntos: clasifAsync.asData?.value.filas.firstOrNull?.totalNeto,
          ),
        ],
      ),
    );
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

/// Próxima prueba con accesos directos a lo que se hace el día de carrera.
class _TarjetaProxima extends StatelessWidget {
  const _TarjetaProxima({required this.prueba});
  final Prueba? prueba;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fmt = DateFormat.MMMMEEEEd(context.idiomaFechas);
    final p = prueba;
    void abrir(Widget destino) => Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => destino));

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: p == null ? null : () => abrir(DetallePrueba(pruebaId: p.id)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                        Text(context.l.proximaPrueba,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(color: cs.outline)),
                        Text(
                          p?.nombre ?? context.l.noHayPruebasPendientes,
                          style: Theme.of(context).textTheme.titleLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (p != null)
                          Text(
                            [
                              if (p.fecha != null) fmt.format(p.fecha!),
                              if (p.sede != null && p.sede!.isNotEmpty)
                                p.sede!,
                            ].join(' · '),
                            style: TextStyle(color: cs.outline, fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  if (p != null) Icon(Icons.chevron_right, color: cs.outline),
                ],
              ),
              if (p != null) ...[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.how_to_reg_outlined),
                      label: Text(context.l.botonInscritos),
                      onPressed: () =>
                          abrir(PantallaInscritos(pruebaId: p.id)),
                    ),
                    FilledButton.icon(
                      icon: const Icon(Icons.fact_check_outlined),
                      label: Text(context.l.botonVerificar),
                      onPressed: () => abrir(DetallePrueba(
                          pruebaId: p.id,
                          pestanaInicial: PestanaPrueba.verificar)),
                    ),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.emoji_events_outlined),
                      label: Text(context.l.botonResultados),
                      onPressed: () => abrir(DetallePrueba(
                          pruebaId: p.id,
                          pestanaInicial: PestanaPrueba.resultados)),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Lo que falta por hacer, con su número. Cada tarjeta lleva a donde se
/// resuelve.
class _Pendientes extends ConsumerWidget {
  const _Pendientes({required this.proxima});
  final Prueba? proxima;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activo = ref.watch(campeonatoActivoProvider);
    final datos = ref.watch(_pendientesProvider).asData?.value;
    final p = proxima;
    final usaTesoreria = activo?.usaTesoreria ?? true;
    final pagos = p != null && usaTesoreria
        ? ref.watch(pagosPruebaProvider(p.id)).asData?.value
        : null;
    final sinCobrar = pagos?.where((x) => !x.saldado).length ?? 0;
    void abrir(Widget destino) => Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => destino));

    final tarjetas = <Widget>[
      if (p != null && (datos?.verifSinValidar ?? 0) > 0)
        _TarjetaPendiente(
          numero: datos!.verifSinValidar,
          texto: context.l.pendVerificaciones(datos.verifSinValidar),
          detalle: p.nombre,
          onTap: () => abrir(DetallePrueba(
              pruebaId: p.id, pestanaInicial: PestanaPrueba.verificar)),
        ),
      if (p != null && sinCobrar > 0)
        _TarjetaPendiente(
          numero: sinCobrar,
          texto: context.l.pendPagos(sinCobrar),
          detalle: p.nombre,
          onTap: () => abrir(DetallePrueba(
              pruebaId: p.id, pestanaInicial: PestanaPrueba.caja)),
        ),
      if ((datos?.sinResultados.length ?? 0) > 0)
        _TarjetaPendiente(
          numero: datos!.sinResultados.length,
          texto: context.l.pendSinResultados(datos.sinResultados.length),
          detalle: datos.sinResultados.map((x) => x.nombre).join(', '),
          // Con una sola, directo a sus resultados; si hay varias, a la lista.
          onTap: datos.sinResultados.length == 1
              ? () => abrir(DetallePrueba(
                  pruebaId: datos.sinResultados.first.id,
                  pestanaInicial: PestanaPrueba.resultados))
              : () => ref.read(shellIndiceProvider.notifier).ir(
                  indiceDestinoVisible('Pruebas', activo)),
        ),
    ];

    if (datos == null) return const SizedBox(height: 48);
    if (tarjetas.isEmpty) {
      final cs = Theme.of(context).colorScheme;
      return Card(
        child: ListTile(
          leading: Icon(Icons.check_circle_outline,
              color: context.estado.exito),
          title: Text(context.l.todoAlDia),
          subtitle: Text(p == null
              ? context.l.todoAlDiaSinPruebas
              : context.l.todoAlDiaEnPrueba(p.nombre),
              style: TextStyle(color: cs.outline)),
        ),
      );
    }
    return Wrap(spacing: 12, runSpacing: 12, children: tarjetas);
  }
}

class _TarjetaPendiente extends StatelessWidget {
  const _TarjetaPendiente({
    required this.numero,
    required this.texto,
    required this.detalle,
    required this.onTap,
  });

  final int numero;
  final String texto;
  final String detalle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: 240,
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$numero',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: cs.primary,
                        )),
                Text(texto, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(detalle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: cs.outline, fontSize: 13)),
              ],
            ),
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
        onTap: () => ref.read(shellIndiceProvider.notifier).ir(
            indiceDestinoVisible('Clasificación', ref.read(campeonatoActivoProvider))),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0x33E6A700),
                child: Icon(Icons.emoji_events, color: Color(0xFFE6A700)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.l.liderCampeonato,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: cs.outline)),
                    Text(
                      nombre ?? context.l.sinResultadosTodavia,
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (nombre != null)
                      Text(
                        '${equipo ?? ''}  ·  ${context.l.puntosAbrev(puntos ?? 0)}',
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
