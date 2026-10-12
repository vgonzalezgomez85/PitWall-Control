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
import 'package:intl/intl.dart';

import '../../data/database/app_database.dart';
import '../pruebas/repositorio_pruebas.dart';
import '../sincronizacion/pantalla_sincronizacion.dart';
import 'editor_verificacion.dart';
import 'lista_verificaciones.dart';
import 'pantalla_rejilla_verificaciones.dart';
import 'repositorio_verificaciones.dart';

/// Pestaña «Verificar» de una prueba: todas sus mangas con los equipos de
/// cada una. Pulsar un equipo abre directamente su verificación, sin pasar
/// por la lista de mangas.
class PestanaVerificarPrueba extends ConsumerWidget {
  const PestanaVerificarPrueba({super.key, required this.pruebaId});

  final int pruebaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final mangasAsync = ref.watch(mangasPruebaProvider(pruebaId));

    return mangasAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (mangas) => ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                icon: const Icon(Icons.table_chart_outlined),
                label: const Text('Resumen de verificaciones'),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) =>
                      PantallaRejillaVerificaciones(pruebaId: pruebaId),
                )),
              ),
              BotonSincronizacion(pruebaId: pruebaId, conTexto: true),
            ],
          ),
          const SizedBox(height: 12),
          if (mangas.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Column(
                children: [
                  Icon(Icons.fact_check_outlined, size: 64, color: cs.outline),
                  const SizedBox(height: 8),
                  Text('Aún no hay tandas',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  const Text(
                    'Inscribe equipos y crea las tandas en la pestaña Preparar.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            for (final m in mangas) _SeccionManga(manga: m),
        ],
      ),
    );
  }
}

/// Una manga: cabecera con el progreso y una tarjeta por equipo.
class _SeccionManga extends ConsumerWidget {
  const _SeccionManga({required this.manga});

  final Manga manga;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final filasAsync = ref.watch(verificacionesMangaProvider(manga.id));
    final filas = filasAsync.asData?.value ?? const <VerificacionConEquipo>[];
    final validadas = filas.where((f) => f.validada).length;
    final fmt = DateFormat("d MMM, HH:mm", 'es_ES');

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(
                          text: manga.nombre,
                          style: Theme.of(context).textTheme.titleMedium),
                      if (manga.fechaHora != null)
                        TextSpan(
                            text: '  ·  ${fmt.format(manga.fechaHora!)}',
                            style: TextStyle(color: cs.outline)),
                    ]),
                  ),
                ),
                if (filas.isNotEmpty)
                  Text('$validadas / ${filas.length} validadas',
                      style: TextStyle(
                        color: validadas == filas.length
                            ? Colors.green.shade700
                            : cs.outline,
                        fontWeight: FontWeight.w600,
                      )),
              ],
            ),
          ),
          filasAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text('Error: $e'),
            data: (filas) => filas.isEmpty
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
                    child: Text('Sin equipos en esta tanda.',
                        style: TextStyle(color: cs.outline)),
                  )
                : Column(children: [
                    for (final f in filas)
                      TarjetaVerificacion(
                        key: ValueKey(f.equipo.id),
                        fila: f,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => EditorVerificacion(
                              mangaId: manga.id,
                              equipoId: f.equipo.id,
                              verificacionId: f.verificacion?.id,
                            ),
                          ),
                        ),
                      ),
                  ]),
          ),
        ],
      ),
    );
  }
}
