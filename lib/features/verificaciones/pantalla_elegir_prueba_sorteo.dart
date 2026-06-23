import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/proveedores.dart';
import '../pruebas/repositorio_pruebas.dart';
import 'pantalla_sorteo_motores.dart';

/// Punto de entrada del sorteo de motor desde el menú: primero se elige sobre
/// qué prueba se sortea y luego se abre la pantalla de sorteo de esa prueba.
class PantallaElegirPruebaSorteo extends ConsumerWidget {
  const PantallaElegirPruebaSorteo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activo = ref.watch(campeonatoActivoProvider);
    final pruebasAsync = ref.watch(pruebasCampeonatoProvider);
    final cs = Theme.of(context).colorScheme;
    final fmt = DateFormat("d MMM y", 'es_ES');

    return Scaffold(
      appBar: AppBar(title: const Text('Sorteo de motor')),
      body: activo == null
          ? const Center(child: Text('Selecciona primero un campeonato'))
          : pruebasAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (pruebas) {
                if (pruebas.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text(
                        'Aún no hay pruebas. Crea una prueba para poder '
                        'sortear los motores de organización.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      color: cs.surfaceContainer,
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(Icons.casino_outlined,
                              size: 18, color: cs.outline),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '¿Sobre qué prueba quieres sortear los motores '
                              'de organización?',
                              style:
                                  TextStyle(color: cs.outline, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
                        itemCount: pruebas.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 4),
                        itemBuilder: (_, i) {
                          final p = pruebas[i];
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: cs.primaryContainer,
                                child: Text('#${p.orden}',
                                    style: TextStyle(
                                      color: cs.onPrimaryContainer,
                                      fontWeight: FontWeight.w700,
                                    )),
                              ),
                              title: Text(p.nombre),
                              subtitle: Text([
                                if (p.fecha != null) fmt.format(p.fecha!),
                                if (p.sede != null && p.sede!.isNotEmpty)
                                  p.sede!,
                              ].join(' · ')),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      PantallaSorteoMotores(pruebaId: p.id),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
