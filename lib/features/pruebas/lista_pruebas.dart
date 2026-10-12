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

import '../../core/idioma.dart';
import '../../core/tema.dart';
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
      appBar: AppBar(title: Text(context.l.menuPruebas)),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'fab_pruebas',
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const EditorPrueba()),
        ),
        icon: const Icon(Icons.event_outlined),
        label: Text(context.l.nuevaPrueba),
      ),
      body: activo == null
          ? Center(child: Text(context.l.seleccionaCampeonato))
          : pruebasAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(context.l.errorDetalle('$e'))),
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
                          Text(context.l.aunNoHayPruebas,
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text(
                            context.l.aunNoHayPruebasTexto,
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
    final colorEst = _colorEstado(prueba.estado, context);
    final fmt = DateFormat.yMMMd(context.idiomaFechas);

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
                child: Text(etiquetaEstado(context, prueba.estado),
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

Color _colorEstado(String e, BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  switch (e) {
    case 'EN_CURSO':
      return context.estado.aviso;
    case 'TERMINADA':
      return context.estado.exito;
    case 'CANCELADA':
      return cs.outline;
    default:
      return cs.secondary;
  }
}
