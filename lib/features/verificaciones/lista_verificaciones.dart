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

import 'editor_verificacion.dart';
import 'repositorio_verificaciones.dart';

class PantallaVerificaciones extends ConsumerWidget {
  const PantallaVerificaciones({
    super.key,
    required this.mangaId,
    this.titulo = 'Verificaciones',
    this.subtitulo,
    this.acciones = const [],
    this.botonFlotante,
    this.vacioTitulo = 'Aún no hay equipos en esta manga',
    this.vacioTexto =
        'Inscribe equipos en la manga para poder hacerles la verificación.',
    this.onQuitar,
  });

  final int mangaId;

  // Personalización para reutilizar la lista fuera de una prueba (sesiones
  // de verificación libre).
  final String titulo;
  final String? subtitulo;
  final List<Widget> acciones;
  final Widget? botonFlotante;
  final String vacioTitulo;
  final String vacioTexto;

  /// Si no es null, mantener pulsada una tarjeta ofrece quitar el equipo.
  final Future<void> Function(VerificacionConEquipo fila)? onQuitar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lista = ref.watch(verificacionesMangaProvider(mangaId));
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: subtitulo == null
            ? Text(titulo)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(titulo),
                  Text(subtitulo!,
                      style: Theme.of(context).textTheme.labelMedium),
                ],
              ),
        actions: acciones,
      ),
      floatingActionButton: botonFlotante,
      body: lista.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (filas) {
          if (filas.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.fact_check_outlined,
                        size: 96, color: cs.outline),
                    const SizedBox(height: 16),
                    Text(vacioTitulo,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      vacioTexto,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            );
          }

          final hechas = filas.where((f) => f.tieneVerificacion).length;
          final validadas = filas.where((f) => f.validada).length;

          return ListView(
            // Hueco abajo para que el botón flotante no tape la última tarjeta.
            padding: EdgeInsets.fromLTRB(
                12, 12, 12, botonFlotante == null ? 24 : 96),
            children: [
              Card(
                color: cs.surfaceContainer,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      _Pildora(
                        icono: Icons.groups,
                        label: '${filas.length} equipos',
                        color: cs.primary,
                      ),
                      const SizedBox(width: 8),
                      _Pildora(
                        icono: Icons.edit_outlined,
                        label: '$hechas con verificación',
                        color: cs.secondary,
                      ),
                      const SizedBox(width: 8),
                      _Pildora(
                        icono: Icons.check_circle_outline,
                        label: '$validadas validadas',
                        color: Colors.green.shade700,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ...filas.map((f) => _TarjetaVerificacion(
                    fila: f,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => EditorVerificacion(
                          mangaId: mangaId,
                          equipoId: f.equipo.id,
                          verificacionId: f.verificacion?.id,
                        ),
                      ),
                    ),
                    onLongPress:
                        onQuitar == null ? null : () => _confirmarQuitar(context, f),
                  )),
            ],
          );
        },
      ),
    );
  }
}

extension on PantallaVerificaciones {
  Future<void> _confirmarQuitar(
      BuildContext context, VerificacionConEquipo fila) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Quitar participante'),
        content: Text(fila.tieneVerificacion
            ? 'Se quitará "${fila.equipo.nombre}" y se borrará su verificación. '
                '¿Continuar?'
            : 'Se quitará "${fila.equipo.nombre}". ¿Continuar?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Quitar')),
        ],
      ),
    );
    if (ok == true) await onQuitar!(fila);
  }
}

class _Pildora extends StatelessWidget {
  const _Pildora(
      {required this.icono, required this.label, required this.color});
  final IconData icono;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 16, color: color),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }
}

class _TarjetaVerificacion extends StatelessWidget {
  const _TarjetaVerificacion(
      {required this.fila, required this.onTap, this.onLongPress});

  final VerificacionConEquipo fila;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    IconData icono;
    Color color;
    String etiqueta;
    if (fila.validada) {
      icono = Icons.check_circle;
      color = Colors.green.shade700;
      etiqueta = 'Validada';
    } else if (fila.tieneVerificacion) {
      icono = Icons.edit_note;
      color = cs.secondary;
      etiqueta = 'En revisión';
    } else {
      icono = Icons.hourglass_empty;
      color = cs.outline;
      etiqueta = 'Pendiente';
    }

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icono, color: color),
        ),
        title: Text(fila.equipo.nombre),
        subtitle: Text(
            '${fila.pilotosTexto}\n${fila.coche?.modelo ?? "Sin coche asignado"}  ·  Copa ${fila.copa}'),
        isThreeLine: true,
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(etiqueta,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w600, fontSize: 12)),
        ),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }
}
