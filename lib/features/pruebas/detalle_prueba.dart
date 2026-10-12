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
import 'dart:convert';

import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import '../../services/exportar_pdf.dart';
import '../../services/generador_pdf_mangas.dart';
import '../../services/generador_tanda_json.dart';
import '../../services/generador_pdf_verificaciones.dart';
import '../campeonatos/selector_tipo_motor.dart';
import '../resultados/pantalla_importar_resultados_prueba.dart';
import '../resultados/pantalla_resultados_prueba.dart';
import '../tesoreria/pantalla_tesoreria_prueba.dart';
import '../verificaciones/pantalla_sorteo_motores.dart';
import '../verificaciones/pestana_verificar_prueba.dart';
import 'detalle_manga.dart';
import 'editor_manga.dart';
import 'enviar_tanda_dialog.dart';
import 'enviar_verificaciones_dialog.dart';
import 'traer_resultados_dialog.dart';
import 'editor_prueba.dart';
import 'pantalla_editar_mangas.dart';
import 'pantalla_inscritos.dart';
import 'repositorio_pruebas.dart';

/// Pestañas de una prueba, en el orden del día de carrera.
enum PestanaPrueba { preparar, verificar, resultados, caja }

/// Pantalla de una prueba organizada por fases: Preparar (inscritos y
/// mangas), Verificar, Resultados y Caja (solo si el campeonato usa
/// tesorería). Lo que saca datos fuera (PDF, archivo o envío a PitWall) va en
/// el botón «Compartir» de la barra superior.
class DetallePrueba extends ConsumerStatefulWidget {
  const DetallePrueba({
    super.key,
    required this.pruebaId,
    this.pestanaInicial = PestanaPrueba.preparar,
  });

  final int pruebaId;
  final PestanaPrueba pestanaInicial;

  @override
  ConsumerState<DetallePrueba> createState() => _DetallePruebaState();
}

class _DetallePruebaState extends ConsumerState<DetallePrueba>
    with TickerProviderStateMixin {
  TabController? _tab;
  List<PestanaPrueba> _pestanas = const [];
  late PestanaPrueba _actual = widget.pestanaInicial;

  /// Pestañas ya abiertas: las demás no se construyen hasta la primera visita.
  final _visitadas = <PestanaPrueba>{};

  int get pruebaId => widget.pruebaId;

  @override
  void dispose() {
    _tab?.dispose();
    super.dispose();
  }

  /// (Re)crea el controlador si cambia el número de pestañas (Caja aparece o
  /// desaparece según el campeonato), conservando la pestaña elegida.
  void _ajustarPestanas(List<PestanaPrueba> pestanas) {
    if (_tab != null && listEquals(pestanas, _pestanas)) return;
    // El TabBar todavía escucha al controlador viejo durante este frame.
    final viejo = _tab;
    if (viejo != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => viejo.dispose());
    }
    _pestanas = pestanas;
    if (!pestanas.contains(_actual)) _actual = PestanaPrueba.preparar;
    _tab = TabController(
      length: pestanas.length,
      initialIndex: pestanas.indexOf(_actual),
      vsync: this,
    )..addListener(() {
        final p = _pestanas[_tab!.index];
        if (p != _actual) setState(() => _actual = p);
      });
  }

  void _abrir(BuildContext context, Widget destino) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => destino));
  }

  Future<void> _exportarPdf(
      BuildContext context, WidgetRef ref, String op) async {
    if (op == 'tanda') {
      await _exportarTanda(context, ref);
      return;
    }
    final idi = await elegirIdiomaExport(context, ref);
    if (idi == null || !context.mounted) return;
    final sugerido = op == 'mangas'
        ? 'mangas-${DateTime.now().millisecondsSinceEpoch}.pdf'
        : 'verificaciones-${DateTime.now().millisecondsSinceEpoch}.pdf';
    await guardarPdf(
      context,
      sugerido: sugerido,
      generar: () => op == 'mangas'
          ? ref
              .read(generadorPdfMangasProvider)
              .generar(pruebaId: pruebaId, idioma: idi)
          : ref
              .read(generadorPdfVerificacionesProvider)
              .generar(pruebaId: pruebaId, idioma: idi),
    );
  }

  // Exporta la tanda como JSON `pitwall.tanda/v1` para importar en PitWall
  // Manager. En escritorio abre "guardar como…"; en móvil escribe en la carpeta
  // de documentos de la app y avisa de la ruta (el envío directo por LAN va en
  // "Enviar a PitWall").
  Future<void> _exportarTanda(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      // Con pole no se exporta el orden de carril: la parrilla se asigna en
      // PitWall después de correr la pole.
      final pole = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('¿La carrera tiene pole?'),
          content: const Text(
              'Con pole no se exporta el orden de carril: PitWall crea la '
              'sesión de pole y la parrilla se asigna tras correrla.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Sin pole'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Con pole'),
            ),
          ],
        ),
      );
      if (pole == null || !context.mounted) return;

      final data = await ref
          .read(generadorTandaJsonProvider)
          .generar(pruebaId: pruebaId, pole: pole);
      final tandas = (data['tandas'] as List?) ?? const [];
      if (tandas.isEmpty) {
        messenger.showSnackBar(SnackBar(
            content: Text(pole
                ? 'No hay inscritos que exportar.'
                : 'No hay mangas con carriles asignados que exportar.')));
        return;
      }
      final jsonStr = const JsonEncoder.withIndent('  ').convert(data);
      final bytes = utf8.encode(jsonStr);
      final nombre =
          ((data['prueba'] as Map?)?['nombre'] ?? 'tanda').toString();
      final sugerido = 'tanda-${slugArchivo(nombre)}.json';

      if (!context.mounted) return;
      await guardarArchivo(
        context,
        sugerido: sugerido,
        etiqueta: 'JSON',
        extension: 'json',
        mime: 'application/json',
        generar: () async => bytes,
      );
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }


  @override
  Widget build(BuildContext context) {
    final db = ref.watch(dbProvider);
    final pruebaAsync = ref.watch(_pruebaProvider(pruebaId));
    final mangasAsync = ref.watch(mangasPruebaProvider(pruebaId));
    final campeonato = ref.watch(campeonatoActivoProvider);
    final usaTesoreria = campeonato?.usaTesoreria ?? true;
    // Con motor propio no hay nada que sortear.
    final conSorteo =
        tipoMotorConSorteo(tipoMotorDeBd(campeonato?.tipoMotor));
    _ajustarPestanas([
      PestanaPrueba.preparar,
      PestanaPrueba.verificar,
      PestanaPrueba.resultados,
      if (usaTesoreria) PestanaPrueba.caja,
    ]);
    _visitadas.add(_actual);

    Widget contenido(PestanaPrueba p) {
      if (!_visitadas.contains(p)) return const SizedBox.shrink();
      switch (p) {
        case PestanaPrueba.preparar:
          return _ContenidoPrueba(
            pruebaId: pruebaId,
            db: db,
            pruebaAsync: pruebaAsync,
            mangasAsync: mangasAsync,
            conSorteo: conSorteo,
            onAbrir: (d) => _abrir(context, d),
          );
        case PestanaPrueba.verificar:
          return PestanaVerificarPrueba(pruebaId: pruebaId);
        case PestanaPrueba.resultados:
          return Column(
            children: [
              _BarraAcciones(children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.file_upload_outlined),
                  label: const Text('Importar del cronometraje'),
                  onPressed: () => _abrir(context,
                      PantallaImportarResultadosPrueba(pruebaId: pruebaId)),
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.cloud_download_outlined),
                  label: const Text('Traer resultados de PitWall'),
                  onPressed: () =>
                      mostrarTraerResultados(context, ref, pruebaId),
                ),
              ]),
              Expanded(
                child: PantallaResultadosPrueba(
                    pruebaId: pruebaId, embebida: true),
              ),
            ],
          );
        case PestanaPrueba.caja:
          return PantallaTesoreriaPrueba(pruebaId: pruebaId, embebida: true);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: pruebaAsync.maybeWhen(
          data: (p) => Text(p?.nombre ?? 'Prueba'),
          orElse: () => const Text('Prueba'),
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Editar'),
            onPressed: () =>
                _abrir(context, EditorPrueba(pruebaId: pruebaId)),
          ),
          const SizedBox(width: 4),
          _BotonCompartir(
            onElegir: (op) {
              switch (op) {
                case 'mangas':
                case 'verifs':
                case 'tanda':
                  _exportarPdf(context, ref, op);
                case 'enviar':
                  mostrarEnviarTanda(context, ref, pruebaId);
                case 'enviar_verifs':
                  mostrarEnviarVerificaciones(context, ref, pruebaId);
              }
            },
          ),
          const SizedBox(width: 12),
        ],
        bottom: TabBar(
          controller: _tab,
          tabs: [
            for (final p in _pestanas)
              switch (p) {
                PestanaPrueba.preparar => const Tab(
                    icon: Icon(Icons.how_to_reg_outlined), text: 'Preparar'),
                PestanaPrueba.verificar => const Tab(
                    icon: Icon(Icons.fact_check_outlined), text: 'Verificar'),
                PestanaPrueba.resultados => const Tab(
                    icon: Icon(Icons.emoji_events_outlined),
                    text: 'Resultados'),
                PestanaPrueba.caja => const Tab(
                    icon: Icon(Icons.payments_outlined), text: 'Caja'),
              },
          ],
        ),
      ),
      // IndexedStack y no TabBarView: cada pestaña conserva su estado
      // (búsquedas, scroll) al ir y volver.
      body: IndexedStack(
        index: _pestanas.indexOf(_actual),
        children: [for (final p in _pestanas) contenido(p)],
      ),
      floatingActionButton: _actual == PestanaPrueba.preparar
          ? FloatingActionButton.extended(
              heroTag: 'fab_nueva_manga',
              onPressed: () =>
                  _abrir(context, EditorManga(pruebaId: pruebaId)),
              icon: const Icon(Icons.add),
              label: const Text('Nueva manga'),
            )
          : null,
    );
  }
}

/// Fila de botones con texto al principio de una pestaña.
class _BarraAcciones extends StatelessWidget {
  const _BarraAcciones({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Wrap(spacing: 8, runSpacing: 8, children: children),
      ),
    );
  }
}

/// «Compartir»: todo lo que saca datos de la prueba (PDF, archivo para
/// PitWall o envío por la red).
class _BotonCompartir extends StatelessWidget {
  const _BotonCompartir({required this.onElegir});
  final void Function(String op) onElegir;

  @override
  Widget build(BuildContext context) {
    PopupMenuItem<String> opcion(
            String valor, IconData icono, String titulo, String? sub) =>
        PopupMenuItem(
          value: valor,
          child: ListTile(
            leading: Icon(icono),
            title: Text(titulo),
            subtitle: sub == null ? null : Text(sub),
            contentPadding: EdgeInsets.zero,
          ),
        );

    return PopupMenuButton<String>(
      tooltip: 'Compartir',
      onSelected: onElegir,
      itemBuilder: (_) => [
        opcion('mangas', Icons.flag_outlined, 'PDF de mangas', null),
        opcion('verifs', Icons.fact_check_outlined, 'PDF de verificaciones',
            null),
        const PopupMenuDivider(),
        opcion('enviar', Icons.wifi_tethering, 'Enviar mangas a PitWall',
            'Por wifi, sin archivo'),
        opcion('enviar_verifs', Icons.fact_check_outlined,
            'Enviar verificaciones a PitWall', 'Solo consulta en Manager'),
        opcion('tanda', Icons.download_outlined, 'Archivo para PitWall (JSON)',
            'Para importarlo a mano en Manager'),
      ],
      child: IgnorePointer(
        child: FilledButton.tonalIcon(
          icon: const Icon(Icons.ios_share),
          label: const Text('Compartir'),
          onPressed: () {},
        ),
      ),
    );
  }
}

/// Pestaña Preparar: cabecera, accesos a inscritos y mangas, y lista de
/// mangas.
class _ContenidoPrueba extends StatelessWidget {
  const _ContenidoPrueba({
    required this.pruebaId,
    required this.db,
    required this.pruebaAsync,
    required this.mangasAsync,
    required this.conSorteo,
    required this.onAbrir,
  });

  final int pruebaId;
  final dynamic db;
  final AsyncValue<Prueba?> pruebaAsync;
  final AsyncValue<List<Manga>> mangasAsync;
  final void Function(Widget destino) onAbrir;

  /// Solo se muestra «Sorteo de motores» si el campeonato es de sorteo o
  /// mixto.
  final bool conSorteo;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return pruebaAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (prueba) {
        if (prueba == null) return const Center(child: Text('No encontrada'));
        return mangasAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (mangas) => ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            children: [
              _CabeceraPrueba(prueba: prueba),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.tonalIcon(
                    icon: const Icon(Icons.how_to_reg_outlined),
                    label: const Text('Inscritos'),
                    onPressed: () =>
                        onAbrir(PantallaInscritos(pruebaId: pruebaId)),
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.swap_horiz),
                    label: const Text('Editar mangas'),
                    onPressed: () =>
                        onAbrir(PantallaEditarMangas(pruebaId: pruebaId)),
                  ),
                  if (conSorteo)
                    OutlinedButton.icon(
                      icon: const Icon(Icons.casino_outlined),
                      label: const Text('Sorteo de motores'),
                      onPressed: () =>
                          onAbrir(PantallaSorteoMotores(pruebaId: pruebaId)),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Text('Mangas',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: cs.secondaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('${mangas.length}',
                        style: TextStyle(
                          color: cs.onSecondaryContainer,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (mangas.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.flag_outlined, size: 64, color: cs.outline),
                        const SizedBox(height: 8),
                        Text('Aún no hay mangas',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text(
                          'Crea las mangas que tendrá esta prueba '
                          '(Jueves 21:00, Viernes 21:00…).',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...mangas.map((m) => _TarjetaManga(manga: m, db: db)),
            ],
          ),
        );
      },
    );
  }
}


final _pruebaProvider = StreamProvider.autoDispose
    .family<Prueba?, int>((ref, id) {
  final db = ref.watch(dbProvider);
  return (db.select(db.pruebas)..where((t) => t.id.equals(id)))
      .watchSingleOrNull();
});

class _CabeceraPrueba extends StatelessWidget {
  const _CabeceraPrueba({required this.prueba});
  final Prueba prueba;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fmt = DateFormat("EEEE d 'de' MMMM y", 'es_ES');
    return Card(
      color: cs.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('Prueba #${prueba.orden}',
                      style: TextStyle(
                        color: cs.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                      )),
                ),
                Text(etiquetaEstado(prueba.estado),
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 12),
            if (prueba.sede != null && prueba.sede!.isNotEmpty)
              Row(children: [
                Icon(Icons.place_outlined, size: 18, color: cs.outline),
                const SizedBox(width: 6),
                Text(prueba.sede!,
                    style: Theme.of(context).textTheme.bodyLarge),
              ]),
            if (prueba.fecha != null) ...[
              const SizedBox(height: 6),
              Row(children: [
                Icon(Icons.calendar_today_outlined, size: 18, color: cs.outline),
                const SizedBox(width: 6),
                Text(fmt.format(prueba.fecha!),
                    style: Theme.of(context).textTheme.bodyLarge),
              ]),
            ],
          ],
        ),
      ),
    );
  }
}

class _TarjetaManga extends StatelessWidget {
  const _TarjetaManga({required this.manga, required this.db});
  final Manga manga;
  final dynamic db;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fmt = DateFormat("d MMM, HH:mm", 'es_ES');
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => DetalleManga(mangaId: manga.id),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Icon(Icons.flag_outlined, color: cs.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(manga.nombre,
                          style: Theme.of(context).textTheme.titleMedium),
                      if (manga.fechaHora != null)
                        Text(fmt.format(manga.fechaHora!),
                            style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 2),
                      Text('${manga.numCarriles} carriles',
                          style: TextStyle(color: cs.outline, fontSize: 13)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: cs.outline),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
