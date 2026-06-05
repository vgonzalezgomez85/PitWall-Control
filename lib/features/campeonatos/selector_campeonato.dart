import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';

class SelectorCampeonato extends ConsumerWidget {
  const SelectorCampeonato({
    super.key,
    required this.campeonatos,
    required this.activo,
  });

  final List<Campeonato> campeonatos;
  final Campeonato activo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Theme.of(context).colorScheme;
    return Card(
      color: color.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.emoji_events, size: 36, color: color.onPrimaryContainer),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Campeonato activo',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: color.onPrimaryContainer.withValues(alpha: 0.8),
                          )),
                  const SizedBox(height: 4),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      isExpanded: true,
                      value: activo.id,
                      borderRadius: BorderRadius.circular(12),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: color.onPrimaryContainer,
                            fontWeight: FontWeight.w700,
                          ),
                      iconEnabledColor: color.onPrimaryContainer,
                      items: campeonatos
                          .map((c) => DropdownMenuItem(
                                value: c.id,
                                child: Text('${c.nombre}  ·  ${c.formato}'),
                              ))
                          .toList(),
                      onChanged: (id) {
                        final nuevo = campeonatos.firstWhere((c) => c.id == id);
                        ref.read(campeonatoActivoProvider.notifier).seleccionar(nuevo);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
