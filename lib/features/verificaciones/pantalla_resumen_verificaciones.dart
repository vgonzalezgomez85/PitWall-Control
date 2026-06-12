import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import '../../services/exportar_pdf.dart';
import '../../services/generador_pdf_verificaciones.dart';
import 'lista_verificaciones.dart';

/// Cada fila: una manga del campeonato activo con totales de verificación.
class MangaResumen {
  final Prueba prueba;
  final Manga manga;
  final int totalInscritos;
  final int conVerificacion;
  final int validadas;

  MangaResumen({
    required this.prueba,
    required this.manga,
    required this.totalInscritos,
    required this.conVerificacion,
    required this.validadas,
  });
}

final _resumenProvider =
    StreamProvider.autoDispose<List<MangaResumen>>((ref) {
  final db = ref.watch(dbProvider);
  final activo = ref.watch(campeonatoActivoProvider);
  if (activo == null) return Stream.value([]);

  // Unimos mangas + pruebas y luego calculamos contadores por manga.
  final query = (db.select(db.mangas).join([
    d.innerJoin(db.pruebas, db.pruebas.id.equalsExp(db.mangas.pruebaId)),
  ])
    ..where(db.pruebas.campeonatoId.equals(activo.id))
    ..orderBy([
      d.OrderingTerm.asc(db.pruebas.orden),
      d.OrderingTerm.asc(db.mangas.fechaHora),
    ]));

  return query.watch().asyncMap((rows) async {
    final out = <MangaResumen>[];
    for (final r in rows) {
      final m = r.readTable(db.mangas);
      final p = r.readTable(db.pruebas);
      final inscritos = await (db.select(db.inscripciones)
            ..where((t) => t.mangaId.equals(m.id)))
          .get();
      final verifs = await (db.select(db.verificaciones)
            ..where((t) => t.mangaId.equals(m.id)))
          .get();
      out.add(MangaResumen(
        prueba: p,
        manga: m,
        totalInscritos: inscritos.length,
        conVerificacion: verifs.length,
        validadas: verifs.where((v) => v.validado).length,
      ));
    }
    return out;
  });
});

class PantallaResumenVerificaciones extends ConsumerWidget {
  const PantallaResumenVerificaciones({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final dataAsync = ref.watch(_resumenProvider);
    final fmt = DateFormat("d MMM, HH:mm", 'es_ES');

    // Pruebas con al menos una verificación (para el menú de exportar PDF).
    final pruebasConVerif = <int, Prueba>{};
    for (final m in (dataAsync.asData?.value ?? const <MangaResumen>[])) {
      if (m.conVerificacion > 0) pruebasConVerif[m.prueba.id] = m.prueba;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificaciones'),
        actions: [
          if (pruebasConVerif.isNotEmpty)
            PopupMenuButton<int>(
              tooltip: 'Exportar verificaciones (PDF)',
              icon: const Icon(Icons.picture_as_pdf_outlined),
              onSelected: (pruebaId) {
                final prueba = pruebasConVerif[pruebaId]!;
                guardarPdf(
                  context,
                  sugerido:
                      'verificaciones-${slugArchivo(prueba.nombre)}.pdf',
                  generar: () => ref
                      .read(generadorPdfVerificacionesProvider)
                      .generar(pruebaId: pruebaId),
                );
              },
              itemBuilder: (_) => [
                for (final p in pruebasConVerif.values)
                  PopupMenuItem(
                    value: p.id,
                    child: ListTile(
                      leading: const Icon(Icons.event_outlined),
                      title: Text(p.nombre),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
              ],
            ),
        ],
      ),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (lista) {
          if (lista.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.fact_check_outlined,
                        size: 96, color: cs.outline),
                    const SizedBox(height: 16),
                    Text('Aún no hay mangas',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      'Crea pruebas y genera sus mangas para empezar las verificaciones.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            );
          }
          // Agrupar por prueba
          final porPrueba = <int, List<MangaResumen>>{};
          for (final r in lista) {
            porPrueba.putIfAbsent(r.prueba.id, () => []).add(r);
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
            children: [
              for (final pid in porPrueba.keys)
                _GrupoPrueba(
                  prueba: porPrueba[pid]!.first.prueba,
                  mangas: porPrueba[pid]!,
                  fmt: fmt,
                ),
            ],
          );
        },
      ),
    );
  }
}

class _GrupoPrueba extends StatelessWidget {
  const _GrupoPrueba({
    required this.prueba,
    required this.mangas,
    required this.fmt,
  });

  final Prueba prueba;
  final List<MangaResumen> mangas;
  final DateFormat fmt;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('#${prueba.orden}',
                      style: TextStyle(
                          color: cs.onPrimaryContainer,
                          fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 8),
                Text(prueba.nombre,
                    style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
          ...mangas.map((m) => _TarjetaMangaResumen(resumen: m, fmt: fmt)),
        ],
      ),
    );
  }
}

class _TarjetaMangaResumen extends StatelessWidget {
  const _TarjetaMangaResumen({required this.resumen, required this.fmt});
  final MangaResumen resumen;
  final DateFormat fmt;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final m = resumen.manga;

    // Estado global de la manga
    Color color;
    String etiqueta;
    IconData icono;
    if (resumen.totalInscritos == 0) {
      color = cs.outline;
      etiqueta = 'Sin inscritos';
      icono = Icons.group_off_outlined;
    } else if (resumen.validadas == resumen.totalInscritos) {
      color = Colors.green.shade700;
      etiqueta = 'Todo validado';
      icono = Icons.check_circle;
    } else if (resumen.conVerificacion == 0) {
      color = cs.outline;
      etiqueta = 'Sin empezar';
      icono = Icons.hourglass_empty;
    } else {
      color = cs.secondary;
      etiqueta = 'En curso';
      icono = Icons.edit_note;
    }

    final progreso = resumen.totalInscritos == 0
        ? 0.0
        : resumen.validadas / resumen.totalInscritos;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PantallaVerificaciones(mangaId: m.id),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(icono, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(m.nombre,
                        style: Theme.of(context).textTheme.titleMedium),
                    if (m.fechaHora != null)
                      Text(fmt.format(m.fechaHora!),
                          style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          '${resumen.validadas} / ${resumen.totalInscritos} validadas',
                          style: TextStyle(color: cs.outline, fontSize: 13),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progreso,
                              minHeight: 6,
                              backgroundColor:
                                  cs.surfaceContainerHighest,
                              valueColor: AlwaysStoppedAnimation(color),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(etiqueta,
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w600,
                        fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
