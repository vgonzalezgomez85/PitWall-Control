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

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import '../equipos/repositorio_equipos.dart';
import '../resultados/pantalla_resultados_manga.dart';
import '../verificaciones/lista_verificaciones.dart';
import 'editor_manga.dart';
import 'repositorio_pruebas.dart';

class DetalleManga extends ConsumerWidget {
  const DetalleManga({super.key, required this.mangaId});

  final int mangaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mangaAsync = ref.watch(_mangaProvider(mangaId));
    final inscritosAsync = ref.watch(inscripcionesMangaProvider(mangaId));
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: mangaAsync.maybeWhen(
          data: (m) => Text(m?.nombre ?? 'Manga'),
          orElse: () => const Text('Manga'),
        ),
        actions: [
          mangaAsync.maybeWhen(
            data: (m) => m == null
                ? const SizedBox.shrink()
                : Row(
                    children: [
                      IconButton(
                        tooltip: 'Verificaciones',
                        icon: const Icon(Icons.fact_check_outlined),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                PantallaVerificaciones(mangaId: m.id),
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Resultados',
                        icon: const Icon(Icons.emoji_events_outlined),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                PantallaResultadosManga(mangaId: m.id),
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Editar manga',
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => EditorManga(
                                pruebaId: m.pruebaId, mangaId: m.id),
                          ),
                        ),
                      ),
                    ],
                  ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      floatingActionButton: mangaAsync.maybeWhen(
        data: (m) => m == null
            ? null
            : FloatingActionButton.extended(
                onPressed: () => _abrirInscribir(context, ref, m),
                icon: const Icon(Icons.add),
                label: const Text('Inscribir equipo'),
              ),
        orElse: () => null,
      ),
      body: mangaAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (manga) {
          if (manga == null) return const Center(child: Text('No encontrada'));
          return inscritosAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (inscritos) {
              if (inscritos.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.group_off_outlined,
                            size: 96, color: cs.outline),
                        const SizedBox(height: 16),
                        Text('Aún no hay equipos inscritos',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text(
                          'Pulsa "Inscribir equipo" para añadirlos uno a uno '
                          'asignando carril de salida.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 96),
                itemCount: inscritos.length,
                separatorBuilder: (_, _) => const SizedBox(height: 4),
                itemBuilder: (_, i) => _TarjetaInscripcion(
                  inscripcion: inscritos[i],
                  manga: manga,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _abrirInscribir(
      BuildContext context, WidgetRef ref, Manga manga) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _HojaInscribir(manga: manga),
    );
  }
}

final _mangaProvider = StreamProvider.autoDispose
    .family<Manga?, int>((ref, id) {
  final db = ref.watch(dbProvider);
  return (db.select(db.mangas)..where((t) => t.id.equals(id)))
      .watchSingleOrNull();
});

class _TarjetaInscripcion extends ConsumerWidget {
  const _TarjetaInscripcion({required this.inscripcion, required this.manga});

  final InscripcionConEquipo inscripcion;
  final Manga manga;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final carril = inscripcion.inscripcion.carrilSalida ?? '—';
    final esSeed = inscripcion.inscripcion.seedDirecto;

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          width: 48, height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: esSeed ? cs.primaryContainer : cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(carril,
              style: TextStyle(
                color: esSeed ? cs.onPrimaryContainer : cs.onSurface,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              )),
        ),
        title: Text(inscripcion.nombreEquipo),
        subtitle: Text(inscripcion.pilotos),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (op) async {
            if (op == 'carril') {
              await _editarCarril(context, ref);
            } else if (op == 'seed') {
              await ref.read(repoInscripcionesProvider).cambiarCarril(
                    inscripcionId: inscripcion.inscripcion.id,
                    carrilSalida: inscripcion.inscripcion.carrilSalida,
                    seedDirecto: !esSeed,
                  );
            } else if (op == 'quitar') {
              final ok = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Quitar inscripción'),
                  content: Text(
                      '¿Quitar a "${inscripcion.nombreEquipo}" de esta manga?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancelar')),
                    FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Quitar')),
                  ],
                ),
              );
              if (ok == true) {
                await ref
                    .read(repoInscripcionesProvider)
                    .quitar(inscripcion.inscripcion.id);
              }
            }
          },
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'carril', child: Text('Cambiar carril')),
            PopupMenuItem(
              value: 'seed',
              child:
                  Text(esSeed ? 'Quitar seed directo' : 'Marcar como seed directo'),
            ),
            const PopupMenuItem(value: 'quitar', child: Text('Quitar de la manga')),
          ],
        ),
      ),
    );
  }

  Future<void> _editarCarril(BuildContext context, WidgetRef ref) async {
    final controller =
        TextEditingController(text: inscripcion.inscripcion.carrilSalida ?? '');
    final res = await showDialog<String?>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Carril de salida'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Ej: D1, D2, 1, 2, 3…',
            helperText: 'D1-D4 para seeds directos, 1-N para sorteo',
          ),
          textCapitalization: TextCapitalization.characters,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () =>
                  Navigator.pop(context, controller.text.trim().toUpperCase()),
              child: const Text('Guardar')),
        ],
      ),
    );
    if (res == null) return;
    final esSeed = res.startsWith('D');
    await ref.read(repoInscripcionesProvider).cambiarCarril(
          inscripcionId: inscripcion.inscripcion.id,
          carrilSalida: res.isEmpty ? null : res,
          seedDirecto: esSeed,
        );
  }
}

class _HojaInscribir extends ConsumerStatefulWidget {
  const _HojaInscribir({required this.manga});
  final Manga manga;

  @override
  ConsumerState<_HojaInscribir> createState() => _HojaInscribirState();
}

class _HojaInscribirState extends ConsumerState<_HojaInscribir> {
  String _busqueda = '';
  final _carril = TextEditingController();

  @override
  void dispose() {
    _carril.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final equiposAsync = ref.watch(equiposCampeonatoProvider);
    final inscritosAsync = ref.watch(inscripcionesMangaProvider(widget.manga.id));
    final cs = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Inscribir equipo en "${widget.manga.nombre}"',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Buscar equipo o piloto…',
              ),
              onChanged: (v) =>
                  setState(() => _busqueda = v.trim().toLowerCase()),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: equiposAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (equipos) {
                  final yaInscritos = inscritosAsync.maybeWhen(
                    data: (lista) =>
                        lista.map((i) => i.equipo.id).toSet(),
                    orElse: () => <int>{},
                  );
                  final candidatos = equipos
                      .where((e) => !yaInscritos.contains(e.equipo.id))
                      .where((e) {
                    if (_busqueda.isEmpty) return true;
                    final t = '${e.equipo.nombre} ${e.pilotosTexto}'
                        .toLowerCase();
                    return t.contains(_busqueda);
                  }).toList();

                  if (candidatos.isEmpty) {
                    return Center(
                      child: Text(
                        equipos.isEmpty
                            ? 'No hay equipos en este campeonato. Créalos primero.'
                            : 'Todos los equipos ya están inscritos.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: cs.outline),
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: scrollController,
                    itemCount: candidatos.length,
                    itemBuilder: (_, i) {
                      final eq = candidatos[i];
                      return Card(
                        child: ListTile(
                          title: Text(eq.equipo.nombre),
                          subtitle: Text(eq.pilotosTexto),
                          trailing: FilledButton(
                            onPressed: () => _inscribir(eq.equipo),
                            child: const Text('Inscribir'),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _inscribir(Equipo equipo) async {
    final carril = await showDialog<String?>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Carril de "${equipo.nombre}"'),
        content: TextField(
          controller: _carril,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Ej: D1, 3…',
            helperText: 'Deja vacío si aún no asignas carril',
          ),
          textCapitalization: TextCapitalization.characters,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () =>
                  Navigator.pop(context, _carril.text.trim().toUpperCase()),
              child: const Text('Inscribir')),
        ],
      ),
    );
    if (carril == null) return;
    final esSeed = carril.startsWith('D');
    await ref.read(repoInscripcionesProvider).inscribir(
          mangaId: widget.manga.id,
          equipoId: equipo.id,
          carrilSalida: carril.isEmpty ? null : carril,
          seedDirecto: esSeed,
        );
    _carril.clear();
    if (mounted) Navigator.of(context).pop();
  }
}
