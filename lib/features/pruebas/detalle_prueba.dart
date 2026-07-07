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
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import '../../services/exportar_pdf.dart';
import '../../services/generador_pdf_mangas.dart';
import '../../services/generador_tanda_json.dart';
import '../../services/generador_pdf_verificaciones.dart';
import '../resultados/pantalla_resultados_prueba.dart';
import '../tesoreria/pantalla_tesoreria_prueba.dart';
import '../verificaciones/pantalla_sorteo_motores.dart';
import 'detalle_manga.dart';
import 'editor_manga.dart';
import 'enviar_tanda_dialog.dart';
import 'traer_resultados_dialog.dart';
import 'editor_prueba.dart';
import 'pantalla_editar_mangas.dart';
import 'pantalla_inscritos.dart';
import 'repositorio_pruebas.dart';

class DetallePrueba extends ConsumerWidget {
  const DetallePrueba({super.key, required this.pruebaId});

  final int pruebaId;

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
    final messenger = ScaffoldMessenger.of(context);
    final idi = await elegirIdiomaExport(context, ref);
    if (idi == null) return;
    try {
      final sugerido = op == 'mangas'
          ? 'mangas-${DateTime.now().millisecondsSinceEpoch}.pdf'
          : 'verificaciones-${DateTime.now().millisecondsSinceEpoch}.pdf';
      final destino = await getSaveLocation(
        acceptedTypeGroups: [
          XTypeGroup(label: 'PDF', extensions: ['pdf']),
        ],
        suggestedName: sugerido,
      );
      if (destino == null) return;

      messenger.showSnackBar(const SnackBar(
          content: Text('Generando PDF…'), duration: Duration(seconds: 2)));

      final bytes = op == 'mangas'
          ? await ref
              .read(generadorPdfMangasProvider)
              .generar(pruebaId: pruebaId, idioma: idi)
          : await ref
              .read(generadorPdfVerificacionesProvider)
              .generar(pruebaId: pruebaId, idioma: idi);

      var ruta = destino.path;
      if (!ruta.toLowerCase().endsWith('.pdf')) {
        ruta = '$ruta.pdf';
      }
      await File(ruta).writeAsBytes(bytes);

      messenger.showSnackBar(SnackBar(content: Text('PDF guardado en $ruta')));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // Exporta la tanda como JSON `pitwall.tanda/v1` para importar en PitWall
  // Manager. En escritorio abre "guardar como…"; en móvil escribe en la carpeta
  // de documentos de la app y avisa de la ruta (el envío directo por LAN va en
  // "Enviar a PitWall").
  Future<void> _exportarTanda(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final data =
          await ref.read(generadorTandaJsonProvider).generar(pruebaId: pruebaId);
      final tandas = (data['tandas'] as List?) ?? const [];
      if (tandas.isEmpty) {
        messenger.showSnackBar(const SnackBar(
            content: Text('No hay mangas con carriles asignados que exportar.')));
        return;
      }
      final jsonStr = const JsonEncoder.withIndent('  ').convert(data);
      final bytes = utf8.encode(jsonStr);
      final nombre =
          ((data['prueba'] as Map?)?['nombre'] ?? 'tanda').toString();
      final sugerido = 'tanda-${slugArchivo(nombre)}.json';

      if (Platform.isAndroid || Platform.isIOS) {
        final dir = await getApplicationDocumentsDirectory();
        final ruta = '${dir.path}/$sugerido';
        await File(ruta).writeAsBytes(bytes);
        messenger.showSnackBar(SnackBar(content: Text('JSON guardado en $ruta')));
        return;
      }

      final destino = await getSaveLocation(
        acceptedTypeGroups: [
          const XTypeGroup(label: 'JSON', extensions: ['json']),
        ],
        suggestedName: sugerido,
      );
      if (destino == null) return;
      var ruta = destino.path;
      if (!ruta.toLowerCase().endsWith('.json')) ruta = '$ruta.json';
      await File(ruta).writeAsBytes(bytes);
      messenger.showSnackBar(SnackBar(content: Text('Tanda exportada en $ruta')));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _irAlInicio(BuildContext context, WidgetRef ref) {
    Navigator.of(context).popUntil((r) => r.isFirst);
    ref.read(shellIndiceProvider.notifier).ir(0);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(dbProvider);
    final pruebaAsync = ref.watch(_pruebaProvider(pruebaId));
    final mangasAsync = ref.watch(mangasPruebaProvider(pruebaId));

    return Scaffold(
      appBar: AppBar(
        title: pruebaAsync.maybeWhen(
          data: (p) => Text(p?.nombre ?? 'Prueba'),
          orElse: () => const Text('Prueba'),
        ),
      ),
      body: Row(
        children: [
          _PanelPrueba(
            pruebaId: pruebaId,
            onInicio: () => _irAlInicio(context, ref),
            onAbrir: (d) => _abrir(context, d),
            onExportar: (op) => _exportarPdf(context, ref, op),
            onEnviar: () => mostrarEnviarTanda(context, ref, pruebaId),
            onTraerResultados: () =>
                mostrarTraerResultados(context, ref, pruebaId),
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(
            child: _ContenidoPrueba(
              pruebaId: pruebaId,
              db: db,
              pruebaAsync: pruebaAsync,
              mangasAsync: mangasAsync,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => EditorManga(pruebaId: pruebaId),
          ),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Nueva manga'),
      ),
    );
  }
}

/// Contenido principal de la prueba (cabecera + lista de mangas).
class _ContenidoPrueba extends StatelessWidget {
  const _ContenidoPrueba({
    required this.pruebaId,
    required this.db,
    required this.pruebaAsync,
    required this.mangasAsync,
  });

  final int pruebaId;
  final dynamic db;
  final AsyncValue<Prueba?> pruebaAsync;
  final AsyncValue<List<Manga>> mangasAsync;

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

/// Panel lateral fijo de la prueba: replica las acciones de la barra superior
/// para tenerlas siempre accesibles, con un acceso para volver al inicio.
class _PanelPrueba extends StatelessWidget {
  const _PanelPrueba({
    required this.pruebaId,
    required this.onInicio,
    required this.onAbrir,
    required this.onExportar,
    required this.onEnviar,
    required this.onTraerResultados,
  });

  final int pruebaId;
  final VoidCallback onInicio;
  final void Function(Widget destino) onAbrir;
  final Future<void> Function(String op) onExportar;
  final VoidCallback onEnviar;
  final VoidCallback onTraerResultados;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    void abrir(Widget destino) => onAbrir(destino);
    Future<void> exportar(String op) => onExportar(op);

    return SizedBox(
      width: 250,
      child: Material(
        color: cs.surface,
        child: SafeArea(
          right: false,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                width: double.infinity,
                color: cs.primaryContainer,
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                child: Text('Opciones de la prueba',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: cs.onPrimaryContainer,
                          fontWeight: FontWeight.w700,
                        )),
              ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Inicio'),
              onTap: onInicio,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.how_to_reg_outlined),
              title: const Text('Inscritos a la prueba'),
              onTap: () => abrir(PantallaInscritos(pruebaId: pruebaId)),
            ),
            ListTile(
              leading: const Icon(Icons.emoji_events_outlined),
              title: const Text('Resultados'),
              onTap: () =>
                  abrir(PantallaResultadosPrueba(pruebaId: pruebaId)),
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: const Text('Editar mangas'),
              onTap: () => abrir(PantallaEditarMangas(pruebaId: pruebaId)),
            ),
            ListTile(
              leading: const Icon(Icons.casino_outlined),
              title: const Text('Sorteo de motores'),
              onTap: () => abrir(PantallaSorteoMotores(pruebaId: pruebaId)),
            ),
            ListTile(
              leading: const Icon(Icons.payments_outlined),
              title: const Text('Tesorería de la prueba'),
              onTap: () => abrir(PantallaTesoreriaPrueba(pruebaId: pruebaId)),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.flag_outlined),
              title: const Text('PDF de mangas'),
              onTap: () => exportar('mangas'),
            ),
            ListTile(
              leading: const Icon(Icons.fact_check_outlined),
              title: const Text('PDF de verificaciones'),
              onTap: () => exportar('verifs'),
            ),
            ListTile(
              leading: const Icon(Icons.download_outlined),
              title: const Text('Exportar tanda (JSON)'),
              subtitle: const Text('Para importar en PitWall'),
              onTap: () => exportar('tanda'),
            ),
            ListTile(
              leading: const Icon(Icons.wifi_tethering),
              title: const Text('Enviar a PitWall'),
              subtitle: const Text('Por WiFi/LAN, sin fichero'),
              onTap: onEnviar,
            ),
            ListTile(
              leading: const Icon(Icons.cloud_download_outlined),
              title: const Text('Traer resultados de PitWall'),
              subtitle: const Text('Posiciones → puntos del campeonato'),
              onTap: onTraerResultados,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Editar prueba'),
              onTap: () => abrir(EditorPrueba(pruebaId: pruebaId)),
            ),
            ],
          ),
        ),
      ),
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
