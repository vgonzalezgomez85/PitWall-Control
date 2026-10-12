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
import 'dart:io';

import 'package:file_selector/file_selector.dart';
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
          'Se subirá una copia actual a tu Drive como "pitwall-backup.zip". '
          'Incluye la base de datos, las fotos de verificaciones y la '
          'configuración del programa (credenciales de Google, tema y '
          'preferencias); nunca la sesión conectada.\n\n'
          'Si ya había una versión anterior, se reemplaza por la nueva.'
          '\n\n¿Continuar?',
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

  /// Confirmación de restauración con la casilla de restaurar también la
  /// configuración que traiga la copia. Devuelve null si se cancela.
  Future<({bool aplicarConfig})?> _confirmarRestauracion({
    required String titulo,
    required String cuerpo,
    required bool configPorDefecto,
  }) async {
    var aplicarConfig = configPorDefecto;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (_, setEstadoDialogo) => AlertDialog(
          title: Text(titulo),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(cuerpo),
              const SizedBox(height: 12),
              CheckboxListTile(
                value: aplicarConfig,
                onChanged: (v) =>
                    setEstadoDialogo(() => aplicarConfig = v ?? false),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title:
                    const Text('Restaurar también la configuración de la copia'),
                subtitle: const Text(
                    'Credenciales de Google, tema y preferencias. Nunca la '
                    'sesión conectada.'),
              ),
            ],
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
      ),
    );
    if (ok != true) return null;
    return (aplicarConfig: aplicarConfig);
  }

  /// En un equipo sin credenciales de Google configuradas la casilla sale
  /// marcada; si ya hay unas propias, la copia solo las sustituye si el
  /// usuario lo marca a propósito.
  Future<bool> _configPorDefecto() async {
    final auth = ref.read(googleAuthServiceProvider);
    final id = await auth.obtenerClientId();
    final secret = await auth.obtenerClientSecret();
    return id == null || secret == null;
  }

  void _empezar() => setState(() {
        _trabajando = true;
        _mensajeOk = null;
        _mensajeError = null;
      });

  void _terminar(ResultadoBackup r) => setState(() {
        _trabajando = false;
        _mensajeOk = r.ok ? r.mensaje : null;
        _mensajeError = r.ok ? null : r.mensaje;
      });

  Future<void> _descargar() async {
    final r = await _confirmarRestauracion(
      titulo: 'Descargar y restaurar',
      cuerpo: 'Se reemplazará tu base de datos local con la copia que hay en '
          'Drive. ⚠️ Cualquier cambio local que no hayas subido se perderá.'
          '\n\nDespués tendrás que cerrar y volver a abrir la app.',
      configPorDefecto: await _configPorDefecto(),
    );
    if (r == null) return;
    _empezar();
    final res = await ref
        .read(driveBackupServiceProvider)
        .descargarYRestaurar(aplicarConfig: r.aplicarConfig);
    if (mounted) _terminar(res);
  }

  /// Restaura una copia guardada como archivo (.zip o .db), sin Google.
  Future<void> _restaurarArchivo() async {
    final xfile = await openFile(acceptedTypeGroups: [
      const XTypeGroup(label: 'Copia de PitWall', extensions: ['zip', 'db']),
    ]);
    if (xfile == null || !mounted) return;
    final nombre = xfile.name;
    final r = await _confirmarRestauracion(
      titulo: 'Restaurar desde archivo',
      cuerpo: 'Se reemplazará tu base de datos local con la copia de '
          '«$nombre». ⚠️ Cualquier cambio local que no hayas subido se '
          'perderá.\n\nNo hace falta conexión con Google para esto.'
          '\n\nDespués tendrás que cerrar y volver a abrir la app.',
      configPorDefecto: await _configPorDefecto(),
    );
    if (r == null) return;
    _empezar();
    final bytes = await File(xfile.path).readAsBytes();
    final res = await ref
        .read(driveBackupServiceProvider)
        .restaurarDesdeBytes(bytes, aplicarConfig: r.aplicarConfig);
    if (mounted) _terminar(res);
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
          if (!estado.conectado) {
            return _NoConectado(
              onRestaurarArchivo: _restaurarArchivo,
              trabajando: _trabajando,
              mensajeOk: _mensajeOk,
              mensajeError: _mensajeError,
            );
          }
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
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _trabajando ? null : _restaurarArchivo,
                icon: _trabajando
                    ? const SizedBox(
                        width: 18, height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.folder_open_outlined),
                label: const Text('Restaurar desde archivo…'),
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
  const _NoConectado({
    required this.onRestaurarArchivo,
    required this.trabajando,
    this.mensajeOk,
    this.mensajeError,
  });

  final VoidCallback onRestaurarArchivo;
  final bool trabajando;
  final String? mensajeOk;
  final String? mensajeError;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_outlined, size: 96, color: cs.outline),
            const SizedBox(height: 16),
            Text('Sin conexión con Google',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            const Text(
              'Conéctate con Google para poder subir o descargar la copia.\n\n'
              'También puedes restaurar una copia guardada como archivo '
              '(.zip), sin conexión.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const PantallaConfiguracionGoogle())),
              icon: const Icon(Icons.settings_outlined),
              label: const Text('Configurar Google'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: trabajando ? null : onRestaurarArchivo,
              icon: trabajando
                  ? const SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.folder_open_outlined),
              label: const Text('Restaurar desde archivo…'),
            ),
            if (mensajeOk != null) ...[
              const SizedBox(height: 16),
              Text(mensajeOk!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green.shade700)),
            ],
            if (mensajeError != null) ...[
              const SizedBox(height: 16),
              Text(mensajeError!,
                  textAlign: TextAlign.center, style: TextStyle(color: cs.error)),
            ],
          ],
        ),
      ),
    );
  }
}
