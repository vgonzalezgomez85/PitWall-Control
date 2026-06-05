import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import '../../services/generador_pdf_mangas.dart';
import '../../services/generador_pdf_verificaciones.dart';
import '../resultados/pantalla_resultados_prueba.dart';
import '../tesoreria/pantalla_tesoreria_prueba.dart';
import 'detalle_manga.dart';
import 'editor_manga.dart';
import 'editor_prueba.dart';
import 'pantalla_editar_mangas.dart';
import 'pantalla_inscritos.dart';
import 'repositorio_pruebas.dart';

class DetallePrueba extends ConsumerWidget {
  const DetallePrueba({super.key, required this.pruebaId});

  final int pruebaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(dbProvider);
    final pruebaAsync = ref.watch(_pruebaProvider(pruebaId));
    final mangasAsync = ref.watch(mangasPruebaProvider(pruebaId));
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: pruebaAsync.maybeWhen(
          data: (p) => Text(p?.nombre ?? 'Prueba'),
          orElse: () => const Text('Prueba'),
        ),
        actions: [
          IconButton(
            tooltip: 'Inscritos a la prueba',
            icon: const Icon(Icons.how_to_reg_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PantallaInscritos(pruebaId: pruebaId),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Resultados',
            icon: const Icon(Icons.emoji_events_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PantallaResultadosPrueba(pruebaId: pruebaId),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Editar mangas',
            icon: const Icon(Icons.swap_horiz),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PantallaEditarMangas(pruebaId: pruebaId),
              ),
            ),
          ),
          PopupMenuButton<String>(
            tooltip: 'Exportar PDF',
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onSelected: (op) async {
              final messenger = ScaffoldMessenger.of(context);
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
                    content: Text('Generando PDF…'),
                    duration: Duration(seconds: 2)));

                final bytes = op == 'mangas'
                    ? await ref
                        .read(generadorPdfMangasProvider)
                        .generar(pruebaId: pruebaId)
                    : await ref
                        .read(generadorPdfVerificacionesProvider)
                        .generar(pruebaId: pruebaId);

                var ruta = destino.path;
                if (!ruta.toLowerCase().endsWith('.pdf')) {
                  ruta = '$ruta.pdf';
                }
                await File(ruta).writeAsBytes(bytes);

                messenger.showSnackBar(
                    SnackBar(content: Text('PDF guardado en $ruta')));
              } catch (e) {
                messenger.showSnackBar(SnackBar(content: Text('Error: $e')));
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'mangas',
                child: ListTile(
                  leading: Icon(Icons.flag_outlined),
                  title: Text('PDF de mangas'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'verifs',
                child: ListTile(
                  leading: Icon(Icons.fact_check_outlined),
                  title: Text('PDF de verificaciones'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          IconButton(
            tooltip: 'Tesorería',
            icon: const Icon(Icons.payments_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    PantallaTesoreriaPrueba(pruebaId: pruebaId),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Editar',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => EditorPrueba(pruebaId: pruebaId),
              ),
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
      body: pruebaAsync.when(
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
