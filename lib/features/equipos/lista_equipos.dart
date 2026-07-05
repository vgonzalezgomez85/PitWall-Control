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
import '../google/actualizador_drive.dart';
import '../google/importar_equipos_sheets.dart';
import '../google/repositorio_hojas_vinculadas.dart';
import 'editor_equipo.dart';
import 'pantalla_importar_equipos.dart';
import 'repositorio_equipos.dart';

class PantallaEquipos extends ConsumerStatefulWidget {
  const PantallaEquipos({super.key});

  @override
  ConsumerState<PantallaEquipos> createState() => _PantallaEquiposState();
}

class _PantallaEquiposState extends ConsumerState<PantallaEquipos> {
  String _busqueda = '';

  @override
  Widget build(BuildContext context) {
    final activo = ref.watch(campeonatoActivoProvider);
    final equiposAsync = ref.watch(equiposCampeonatoProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Equipos'),
        actions: [
          Consumer(builder: (context, ref, _) {
            final vinculoAsync = ref.watch(vinculoEquiposProvider);
            return vinculoAsync.maybeWhen(
              data: (v) => v == null
                  ? const SizedBox.shrink()
                  : IconButton(
                      tooltip:
                          'Actualizar desde Drive (${v.fila.hojaNombre})',
                      icon: const Icon(Icons.sync),
                      onPressed: () async {
                        final m = ScaffoldMessenger.of(context);
                        m.showSnackBar(const SnackBar(
                          content: Text('Actualizando desde Drive…'),
                          duration: Duration(seconds: 2),
                        ));
                        final r = await ref
                            .read(actualizadorDriveProvider)
                            .actualizarEquipos(v);
                        m.showSnackBar(SnackBar(
                          content: Text(
                              r.ok ? '✓ ${r.mensaje}' : '✗ ${r.mensaje}'),
                          duration: const Duration(seconds: 5),
                        ));
                      },
                    ),
              orElse: () => const SizedBox.shrink(),
            );
          }),
          PopupMenuButton<String>(
            tooltip: 'Importar',
            icon: const Icon(Icons.file_upload_outlined),
            onSelected: (op) {
              if (op == 'archivo') {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const PantallaImportarEquipos(),
                ));
              } else if (op == 'sheets') {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const ImportarEquiposSheets(),
                ));
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'sheets',
                child: ListTile(
                  leading: Icon(Icons.cloud_outlined),
                  title: Text('Vincular Google Sheet'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'archivo',
                child: ListTile(
                  leading: Icon(Icons.upload_file_outlined),
                  title: Text('Desde archivo CSV / Excel'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(72),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Buscar equipo o piloto…',
              ),
              onChanged: (v) =>
                  setState(() => _busqueda = v.trim().toLowerCase()),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'fab_equipos',
        onPressed: () => _abrirEditor(),
        icon: const Icon(Icons.group_add),
        label: const Text('Nuevo equipo'),
      ),
      body: activo == null
          ? const Center(child: Text('Selecciona primero un campeonato'))
          : equiposAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (equipos) {
                final filtrados = _busqueda.isEmpty
                    ? equipos
                    : equipos.where((e) {
                        final t = '${e.equipo.nombre} ${e.pilotosTexto}'
                            .toLowerCase();
                        return t.contains(_busqueda);
                      }).toList();

                if (filtrados.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.groups_outlined,
                              size: 96, color: cs.outline),
                          const SizedBox(height: 16),
                          Text(
                            equipos.isEmpty
                                ? 'Aún no hay equipos'
                                : 'No hay coincidencias',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if (equipos.isEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              activo.formato == 'PAREJAS'
                                  ? 'Crea un equipo con dos pilotos para empezar.'
                                  : 'Crea una inscripción individual para empezar.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
                  itemCount: filtrados.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 4),
                  itemBuilder: (_, i) {
                    final e = filtrados[i];
                    return _TarjetaEquipo(
                      equipo: e,
                      onTap: () => _abrirEditor(equipoId: e.equipo.id),
                    );
                  },
                );
              },
            ),
    );
  }

  Future<void> _abrirEditor({int? equipoId}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => EditorEquipo(equipoId: equipoId)),
    );
  }
}

class _TarjetaEquipo extends StatelessWidget {
  const _TarjetaEquipo({required this.equipo, required this.onTap});

  final EquipoConPilotos equipo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.flag_outlined, color: cs.onPrimaryContainer),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(equipo.equipo.nombre,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(equipo.pilotosTexto,
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 6),
                    _Chip(text: equipo.equipo.copa, color: cs.secondary),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: cs.outline),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text,
          style: TextStyle(
            color: color, fontSize: 13, fontWeight: FontWeight.w600,
          )),
    );
  }
}
