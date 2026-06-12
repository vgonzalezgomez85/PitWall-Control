import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import 'detalle_prueba.dart';
import 'editor_prueba.dart';
import 'repositorio_pruebas.dart';

class PantallaPruebas extends ConsumerWidget {
  const PantallaPruebas({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activo = ref.watch(campeonatoActivoProvider);
    final pruebasAsync = ref.watch(pruebasCampeonatoProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Pruebas')),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'fab_pruebas',
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const EditorPrueba()),
        ),
        icon: const Icon(Icons.event_outlined),
        label: const Text('Nueva prueba'),
      ),
      body: activo == null
          ? const Center(child: Text('Selecciona primero un campeonato'))
          : pruebasAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (pruebas) {
                if (pruebas.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.event_outlined,
                              size: 96, color: cs.outline),
                          const SizedBox(height: 16),
                          Text('Aún no hay pruebas',
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text(
                            'Crea la primera prueba del campeonato '
                            '(por ejemplo "EL SOT", "SLOTMANIA"…).',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
                  itemCount: pruebas.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 4),
                  itemBuilder: (_, i) => _TarjetaPrueba(prueba: pruebas[i]),
                );
              },
            ),
    );
  }
}

class _TarjetaPrueba extends StatelessWidget {
  const _TarjetaPrueba({required this.prueba});

  final Prueba prueba;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final colorEst = _colorEstado(prueba.estado, cs);
    final fmt = DateFormat("d MMM y", 'es_ES');

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => DetallePrueba(pruebaId: prueba.id)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text('#${prueba.orden}',
                        style: TextStyle(
                          color: cs.onPrimaryContainer,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        )),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(prueba.nombre,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    if (prueba.sede != null && prueba.sede!.isNotEmpty)
                      Text('📍 ${prueba.sede}',
                          style: Theme.of(context).textTheme.bodyMedium),
                    if (prueba.fecha != null)
                      Text('📅 ${fmt.format(prueba.fecha!)}',
                          style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: colorEst.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(etiquetaEstado(prueba.estado),
                    style: TextStyle(
                      color: colorEst,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    )),
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right, color: cs.outline),
            ],
          ),
        ),
      ),
    );
  }
}

Color _colorEstado(String e, ColorScheme cs) {
  switch (e) {
    case 'EN_CURSO':
      return Colors.orange.shade700;
    case 'TERMINADA':
      return Colors.green.shade700;
    case 'CANCELADA':
      return cs.outline;
    default:
      return cs.secondary;
  }
}
