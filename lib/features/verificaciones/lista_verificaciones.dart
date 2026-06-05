import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'editor_verificacion.dart';
import 'repositorio_verificaciones.dart';

class PantallaVerificaciones extends ConsumerWidget {
  const PantallaVerificaciones({super.key, required this.mangaId});

  final int mangaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lista = ref.watch(verificacionesMangaProvider(mangaId));
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Verificaciones')),
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
                    Text('Aún no hay equipos en esta manga',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      'Inscribe equipos en la manga para poder hacerles la verificación.',
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
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
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
                  )),
            ],
          );
        },
      ),
    );
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
  const _TarjetaVerificacion({required this.fila, required this.onTap});

  final VerificacionConEquipo fila;
  final VoidCallback onTap;

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
            '${fila.pilotosTexto}\n${fila.coche?.modelo ?? "Sin coche asignado"}  ·  Copa ${fila.equipo.copa}'),
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
      ),
    );
  }
}
