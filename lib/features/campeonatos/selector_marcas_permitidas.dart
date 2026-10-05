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

import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';

/// Códigos de marca permitidos guardados en `marcasPermitidasJson`.
/// Vacío = sin limitación.
Set<String> marcasPermitidasDe(String? json) {
  if (json == null || json.isEmpty) return const {};
  try {
    final raw = jsonDecode(json);
    if (raw is List) return raw.map((e) => e.toString()).toSet();
  } catch (_) {}
  return const {};
}

String marcasPermitidasAJson(Set<String> codigos) =>
    jsonEncode(codigos.toList()..sort());

final _catalogoMarcasProvider =
    FutureProvider.autoDispose<List<CatalogoMarca>>((ref) {
  final db = ref.watch(dbProvider);
  return (db.select(db.catalogoMarcas)
        ..orderBy([(t) => OrderingTerm.asc(t.nombre)]))
      .get();
});

/// "Limitar fabricante": interruptor + chips con las marcas del catálogo.
/// Con el interruptor apagado, [seleccion] se ignora (sin limitación).
class SelectorMarcasPermitidas extends ConsumerWidget {
  const SelectorMarcasPermitidas({
    super.key,
    required this.activo,
    required this.seleccion,
    required this.onActivo,
    required this.onCambio,
  });

  final bool activo;
  final Set<String> seleccion;
  final ValueChanged<bool> onActivo;

  /// Recibe la selección nueva completa.
  final ValueChanged<Set<String>> onCambio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Limitar fabricante'),
          subtitle: const Text(
              'En la verificación, los desplegables de marca (piñón, corona, '
              'llantas y trencilla) solo muestran las marcas elegidas; '
              'cualquier otra es infracción.'),
          value: activo,
          onChanged: onActivo,
        ),
        if (activo)
          ref.watch(_catalogoMarcasProvider).when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Error: $e'),
                data: (marcas) {
                  final codigos = marcas.map((m) => m.codigo).toSet();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final m in marcas)
                            FilterChip(
                              label: Text(m.nombre == m.codigo
                                  ? m.nombre
                                  : '${m.nombre} (${m.codigo})'),
                              selected: seleccion.contains(m.codigo),
                              onSelected: (v) => onCambio(v
                                  ? {...seleccion, m.codigo}
                                  : ({...seleccion}..remove(m.codigo))),
                            ),
                          // Códigos guardados que ya no están en el catálogo.
                          for (final c in seleccion.difference(codigos))
                            FilterChip(
                              label: Text('$c (no catalogada)'),
                              selected: true,
                              onSelected: (_) =>
                                  onCambio({...seleccion}..remove(c)),
                            ),
                        ],
                      ),
                      if (seleccion.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text('Elige al menos una marca.',
                              style: TextStyle(color: cs.error)),
                        ),
                    ],
                  );
                },
              ),
      ],
    );
  }
}
