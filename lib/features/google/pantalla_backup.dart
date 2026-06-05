import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../services/drive_backup_service.dart';
import '../../services/google_auth_service.dart';
import 'pantalla_configuracion_google.dart';

class PantallaBackup extends ConsumerStatefulWidget {
  const PantallaBackup({super.key});

  @override
  ConsumerState<PantallaBackup> createState() => _PantallaBackupState();
}

class _PantallaBackupState extends ConsumerState<PantallaBackup> {
  bool _trabajando = false;
  String? _mensajeOk;
  String? _mensajeError;

  Future<void> _subir() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Subir copia a Drive'),
        content: const Text(
          'Se subirá una copia actual (BD + fotos) a tu Drive como '
          '"pitwall-backup.zip". Si ya había una versión anterior, se '
          'reemplaza por la nueva.\n\n¿Continuar?',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Subir')),
        ],
      ),
    );
    if (ok != true) return;
    setState(() {
      _trabajando = true;
      _mensajeOk = null;
      _mensajeError = null;
    });
    final r = await ref.read(driveBackupServiceProvider).subir();
    ref.invalidate(infoBackupProvider);
    if (mounted) {
      setState(() {
        _trabajando = false;
        _mensajeOk = r.ok ? r.mensaje : null;
        _mensajeError = r.ok ? null : r.mensaje;
      });
    }
  }

  Future<void> _descargar() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Descargar y restaurar'),
        content: const Text(
          'Se reemplazará tu base de datos local con la copia que hay en Drive. '
          '⚠️ Cualquier cambio local que no hayas subido se perderá.\n\n'
          'Después tendrás que cerrar y volver a abrir la app.',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Sí, restaurar')),
        ],
      ),
    );
    if (ok != true) return;
    setState(() {
      _trabajando = true;
      _mensajeOk = null;
      _mensajeError = null;
    });
    final r =
        await ref.read(driveBackupServiceProvider).descargarYRestaurar();
    if (mounted) {
      setState(() {
        _trabajando = false;
        _mensajeOk = r.ok ? r.mensaje : null;
        _mensajeError = r.ok ? null : r.mensaje;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final estadoAsync = ref.watch(estadoGoogleProvider);
    final infoAsync = ref.watch(infoBackupProvider);
    final fmt = DateFormat("d MMM y, HH:mm", 'es_ES');

    return Scaffold(
      appBar: AppBar(title: const Text('Copia compartida en Drive')),
      body: estadoAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (estado) {
          if (!estado.conectado) return const _NoConectado();
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Card(
                color: cs.surfaceContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.cloud_outlined, color: cs.primary),
                          const SizedBox(width: 8),
                          Text('Copia actual en Drive',
                              style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                      const SizedBox(height: 12),
                      infoAsync.when(
                        loading: () => const LinearProgressIndicator(),
                        error: (e, _) => Text('Error: $e',
                            style: TextStyle(color: cs.error)),
                        data: (info) {
                          if (info == null) {
                            return const Text(
                              'Aún no hay ninguna copia en Drive. '
                              'Pulsa "Subir copia" para crear la primera.',
                            );
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(info.nombre,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700)),
                              if (info.modificado != null)
                                Text(
                                    'Última subida: ${fmt.format(info.modificado!.toLocal())}'),
                              if (info.tamano != null)
                                Text(
                                    'Tamaño: ${(info.tamano! / 1024).toStringAsFixed(1)} KB'),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _trabajando ? null : _subir,
                icon: _trabajando
                    ? const SizedBox(
                        width: 18, height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.cloud_upload_outlined),
                label: const Text('Subir copia a Drive'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _trabajando ? null : _descargar,
                icon: _trabajando
                    ? const SizedBox(
                        width: 18, height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.cloud_download_outlined),
                label: const Text('Descargar y restaurar'),
              ),
              if (_mensajeOk != null) ...[
                const SizedBox(height: 16),
                Card(
                  color: Colors.green.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline,
                            color: Colors.green.shade700),
                        const SizedBox(width: 8),
                        Expanded(child: Text(_mensajeOk!)),
                      ],
                    ),
                  ),
                ),
              ],
              if (_mensajeError != null) ...[
                const SizedBox(height: 16),
                Card(
                  color: cs.errorContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: cs.onErrorContainer),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(_mensajeError!,
                              style: TextStyle(color: cs.onErrorContainer)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Card(
                color: cs.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: cs.outline),
                          const SizedBox(width: 8),
                          Text('Cómo trabajar en equipo',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: cs.onSurface)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• Al empezar a trabajar, pulsa "Descargar" para tener la última versión.\n'
                        '• Al terminar tus cambios, pulsa "Subir" para que los demás puedan recibirlos.\n'
                        '• Si dos personas editan a la vez, gana quien sube último (no hay fusión automática). '
                        'Lo más práctico: coordinar quién edita en cada momento.',
                        style: TextStyle(color: cs.onSurface),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NoConectado extends StatelessWidget {
  const _NoConectado();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_outlined,
                size: 96, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text('Sin conexión con Google',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            const Text(
              'Conéctate con Google para poder subir o descargar la copia.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const PantallaConfiguracionGoogle())),
              icon: const Icon(Icons.settings_outlined),
              label: const Text('Configurar Google'),
            ),
          ],
        ),
      ),
    );
  }
}
