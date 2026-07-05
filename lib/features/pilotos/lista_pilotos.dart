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
import '../google/importar_pilotos_sheets.dart';
import '../google/repositorio_hojas_vinculadas.dart';
import 'editor_piloto.dart';
import 'pantalla_importar.dart';
import 'repositorio_pilotos.dart';

class PantallaPilotos extends ConsumerStatefulWidget {
  const PantallaPilotos({super.key});

  @override
  ConsumerState<PantallaPilotos> createState() => _PantallaPilotosState();
}

class _PantallaPilotosState extends ConsumerState<PantallaPilotos> {
  String _busqueda = '';

  @override
  Widget build(BuildContext context) {
    final activo = ref.watch(campeonatoActivoProvider);
    final pilotosAsync = ref.watch(pilotosCampeonatoProvider);
    final vinculoAsync = ref.watch(vinculoPilotosProvider);
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilotos'),
        actions: [
          vinculoAsync.maybeWhen(
            data: (v) => v == null
                ? const SizedBox.shrink()
                : IconButton(
                    tooltip:
                        'Actualizar desde Drive (${v.fila.hojaNombre} · ${v.fila.pestanaTitulo})',
                    icon: const Icon(Icons.sync),
                    onPressed: () => _actualizarDesdeDrive(v),
                  ),
            orElse: () => const SizedBox.shrink(),
          ),
          PopupMenuButton<String>(
            tooltip: 'Importar',
            icon: const Icon(Icons.file_upload_outlined),
            onSelected: (op) {
              if (op == 'archivo') {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const PantallaImportarPilotos(),
                ));
              } else if (op == 'sheets') {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const ImportarPilotosSheets(),
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
                hintText: 'Buscar por nombre…',
              ),
              onChanged: (v) => setState(() => _busqueda = v.trim().toLowerCase()),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'fab_pilotos',
        onPressed: () => _abrirEditor(),
        icon: const Icon(Icons.person_add),
        label: const Text('Nuevo piloto'),
      ),
      body: activo == null
          ? const Center(child: Text('Selecciona primero un campeonato'))
          : pilotosAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (pilotos) {
                final filtrados = _busqueda.isEmpty
                    ? pilotos
                    : pilotos
                        .where((p) => p.piloto.nombre.toLowerCase().contains(_busqueda))
                        .toList();

                if (filtrados.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.people_outline,
                              size: 96, color: color.outline),
                          const SizedBox(height: 16),
                          Text(
                            pilotos.isEmpty
                                ? 'Aún no hay pilotos en este campeonato'
                                : 'No hay coincidencias',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if (pilotos.isEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              'Pulsa el botón "Nuevo piloto" para añadir el primero.',
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
                    final p = filtrados[i];
                    return _TarjetaPiloto(
                      piloto: p,
                      onTap: () => _abrirEditor(pilotoId: p.piloto.id),
                    );
                  },
                );
              },
            ),
    );
  }

  Future<void> _abrirEditor({int? pilotoId}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EditorPiloto(pilotoId: pilotoId),
      ),
    );
  }

  Future<void> _actualizarDesdeDrive(VinculoHoja v) async {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(const SnackBar(
      content: Text('Actualizando desde Drive…'),
      duration: Duration(seconds: 2),
    ));
    final res = await ref.read(actualizadorDriveProvider).actualizarPilotos(v);
    if (!mounted) return;
    messenger.showSnackBar(SnackBar(
      content: Text(res.ok ? '✓ ${res.mensaje}' : '✗ ${res.mensaje}'),
      duration: const Duration(seconds: 5),
    ));
  }
}

class _TarjetaPiloto extends ConsumerWidget {
  const _TarjetaPiloto({required this.piloto, required this.onTap});

  final PilotoConPerfil piloto;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Theme.of(context).colorScheme;
    final perfil = piloto.perfil!;
    final colorCat = _colorCategoria(perfil.categoria, color);
    final usaCreditos =
        ref.watch(campeonatoActivoProvider)?.usaCreditos ?? true;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: colorCat.withValues(alpha: 0.15),
                child: Text(
                  _iniciales(piloto.piloto.nombre),
                  style: TextStyle(color: colorCat, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(piloto.piloto.nombre,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        if (usaCreditos)
                          _Chip(text: perfil.categoria, color: colorCat),
                        if (usaCreditos)
                          _Chip(
                            text: '${perfil.creditosActuales} créditos',
                            color: color.secondary,
                          ),
                        if ((piloto.piloto.palmaresGlobal ?? '').isNotEmpty)
                          _Chip(
                            text: piloto.piloto.palmaresGlobal!,
                            color: color.tertiary,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: color.outline),
            ],
          ),
        ),
      ),
    );
  }

  static String _iniciales(String nombre) {
    final partes = nombre.trim().split(RegExp(r'\s+'));
    if (partes.length == 1) return partes.first.characters.take(2).toString().toUpperCase();
    return (partes.first.characters.first + partes[1].characters.first).toUpperCase();
  }
}

Color _colorCategoria(String c, ColorScheme cs) {
  switch (c) {
    case 'PLATINO': return const Color(0xFF7B61FF);
    case 'ORO':     return const Color(0xFFE6A700);
    case 'PLATA':   return const Color(0xFF9E9E9E);
    case 'BRONCE':  return const Color(0xFFB36A38);
    default:        return cs.primary;
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
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }
}
