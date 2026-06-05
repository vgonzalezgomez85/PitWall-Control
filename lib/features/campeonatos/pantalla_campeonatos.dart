import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import 'editor_campeonato.dart';

class PantallaCampeonatos extends ConsumerWidget {
  const PantallaCampeonatos({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final listaAsync = ref.watch(campeonatosProvider);
    final activo = ref.watch(campeonatoActivoProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Campeonatos')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const EditorCampeonato()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo campeonato'),
      ),
      body: listaAsync.when(
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
                    Icon(Icons.emoji_events_outlined,
                        size: 96, color: cs.outline),
                    const SizedBox(height: 16),
                    Text('Aún no hay campeonatos',
                        style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 96),
            itemCount: lista.length,
            separatorBuilder: (_, _) => const SizedBox(height: 4),
            itemBuilder: (_, i) {
              final c = lista[i];
              final esActivo = activo?.id == c.id;
              return Card(
                color: esActivo ? cs.primaryContainer : null,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        esActivo ? cs.primary : cs.surfaceContainerHighest,
                    child: Icon(Icons.emoji_events,
                        color: esActivo ? Colors.white : cs.outline),
                  ),
                  title: Text(c.nombre,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: esActivo ? cs.onPrimaryContainer : null,
                      )),
                  subtitle: Text(
                    '${c.formato}  ·  Año ${c.anio}  ·  Descartes: ${c.numDescartes}',
                    style: TextStyle(
                      color: esActivo
                          ? cs.onPrimaryContainer.withValues(alpha: 0.8)
                          : cs.outline,
                    ),
                  ),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      if (!esActivo)
                        TextButton(
                          onPressed: () => ref
                              .read(campeonatoActivoProvider.notifier)
                              .seleccionar(c),
                          child: const Text('Activar'),
                        ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                EditorCampeonato(campeonatoId: c.id),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
