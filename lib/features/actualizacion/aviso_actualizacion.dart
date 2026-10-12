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

// Aviso de versión nueva, en dos piezas:
//   • TarjetaActualizacion: la tarjeta (título, Actualizar, Más tarde).
//   • AvisoActualizacion: en el Inicio; comprueba al abrir la app y al volver
//     a ella si han pasado unas horas.
// La comprobación a mano vive en `pantalla_actualizacion.dart` (Ajustes).
import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/entorno.dart';
import '../../core/tema.dart';
import 'actualizacion.dart';
import 'servicio_actualizacion.dart';

/// Tarjeta de «hay una versión nueva»: botón Actualizar (Android) o Descargar
/// (escritorio) con su progreso, «Más tarde» y la nota del permiso.
class TarjetaActualizacion extends StatefulWidget {
  const TarjetaActualizacion({super.key, required this.nueva, this.onMasTarde});

  final Actualizacion nueva;
  final VoidCallback? onMasTarde;

  @override
  State<TarjetaActualizacion> createState() => _TarjetaActualizacionState();
}

class _TarjetaActualizacionState extends State<TarjetaActualizacion> {
  bool _descargando = false;
  int? _pct;
  Descarga? _descarga;

  @override
  void dispose() {
    // Si se sale de la pantalla a mitad de descarga, se corta.
    _descarga?.cancelar();
    super.dispose();
  }

  Future<void> _actualizar() async {
    setState(() {
      _descargando = true;
      _pct = null;
    });
    final descarga = iniciarDescarga(widget.nueva, (pct) {
      if (mounted) setState(() => _pct = pct);
    });
    _descarga = descarga;
    try {
      await descarga.promesa;
    } on FalloDescarga catch (e) {
      // Cancelar a propósito no es un error.
      if (e.motivo != MotivoFallo.cancelada && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_mensajeError(e.motivo))),
        );
      }
    } finally {
      _descarga = null;
      if (mounted) setState(() => _descargando = false);
    }
  }

  String _mensajeError(MotivoFallo motivo) => switch (motivo) {
        MotivoFallo.apkIncompleto => 'La descarga no llegó completa. Inténtalo otra vez.',
        MotivoFallo.atascada => 'La descarga se ha atascado. Inténtalo otra vez.',
        _ => 'No se pudo descargar la actualización. Inténtalo de nuevo o descárgala desde pitwall.es.',
      };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final estado = context.estado;
    final nueva = widget.nueva;

    return Card(
      color: estado.avisoSuave,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: estado.aviso),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.system_update_alt, color: estado.aviso),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Hay una versión nueva: v${nueva.version}',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              nueva.notas ?? 'Descarga la nueva versión para tener las últimas mejoras.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                FilledButton.icon(
                  onPressed: _descargando ? null : _actualizar,
                  icon: _descargando
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.download),
                  label: Text(_textoBoton(nueva)),
                ),
                const SizedBox(width: 8),
                if (_descargando)
                  TextButton(
                    onPressed: () => _descarga?.cancelar(),
                    child: const Text('Cancelar'),
                  )
                else if (widget.onMasTarde != null)
                  TextButton(
                    onPressed: widget.onMasTarde,
                    child: const Text('Más tarde'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              nueva.esApk
                  ? 'Android pedirá permiso para instalar apps de esta fuente la primera vez. '
                      'Después, vuelve a pulsar «Actualizar».'
                  : 'Se abrirá el navegador para descargar el instalador de esta versión.',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  String _textoBoton(Actualizacion nueva) {
    if (!_descargando) return nueva.esApk ? 'Actualizar' : 'Descargar';
    return _pct == null ? 'Descargando…' : 'Descargando… $_pct %';
  }
}

/// Aviso para el Inicio: pregunta a la web al abrir la app y, al volver a ella,
/// si pasaron más de 6 horas. En Dev y en pruebas no hace nada.
class AvisoActualizacion extends StatefulWidget {
  const AvisoActualizacion({super.key});

  @override
  State<AvisoActualizacion> createState() => _AvisoActualizacionState();
}

class _AvisoActualizacionState extends State<AvisoActualizacion> {
  Actualizacion? _nueva;
  bool _descartada = false;
  DateTime? _ultima;
  AppLifecycleListener? _escucha;

  @override
  void initState() {
    super.initState();
    if (!compruebaActualizaciones) return;
    _escucha = AppLifecycleListener(onResume: _alVolver);
    unawaited(_comprobar());
  }

  @override
  void dispose() {
    _escucha?.dispose();
    super.dispose();
  }

  void _alVolver() {
    if (debeComprobar(_ultima, DateTime.now())) unawaited(_comprobar());
  }

  Future<void> _comprobar() async {
    try {
      final resultado = await comprobarActualizacion(await versionInstalada());
      if (!mounted) return;
      // Si no hubo respuesta (sin red), no se anota: se reintenta al volver.
      if (resultado.estado != EstadoBusqueda.error) _ultima = DateTime.now();
      if (resultado.estado == EstadoBusqueda.nueva) {
        setState(() => _nueva = resultado.actualizacion);
      }
    } catch (_) {
      // Sin la versión instalada (plugin no disponible) no hay nada que avisar.
    }
  }

  @override
  Widget build(BuildContext context) {
    final nueva = _nueva;
    if (!compruebaActualizaciones || nueva == null || _descartada) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TarjetaActualizacion(
        nueva: nueva,
        onMasTarde: () => setState(() => _descartada = true),
      ),
    );
  }
}
