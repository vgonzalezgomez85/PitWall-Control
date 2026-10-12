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

// Ajustes → Actualizaciones: la versión instalada y una búsqueda a mano de
// versiones nuevas en la web (la automática vive en `aviso_actualizacion.dart`).
import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/tema.dart';
import 'aviso_actualizacion.dart';
import 'servicio_actualizacion.dart';

enum _Estado { reposo, buscando, alDia, error }

class PantallaActualizacion extends StatefulWidget {
  const PantallaActualizacion({super.key});

  @override
  State<PantallaActualizacion> createState() => _PantallaActualizacionState();
}

class _PantallaActualizacionState extends State<PantallaActualizacion> {
  String? _version;
  _Estado _estado = _Estado.reposo;
  Actualizacion? _nueva;

  @override
  void initState() {
    super.initState();
    unawaited(_cargarVersion());
  }

  Future<void> _cargarVersion() async {
    try {
      final version = await versionInstalada();
      if (mounted) setState(() => _version = version);
    } catch (_) {
      // Sin el plugin de versión, se queda el «…».
    }
  }

  Future<void> _buscar() async {
    setState(() {
      _estado = _Estado.buscando;
      _nueva = null;
    });
    var actual = _version;
    if (actual == null) {
      try {
        actual = await versionInstalada();
      } catch (_) {
        // Sin la versión instalada no hay con qué comparar.
      }
    }
    if (actual == null) {
      if (mounted) setState(() => _estado = _Estado.error);
      return;
    }
    final resultado = await comprobarActualizacion(actual);
    if (!mounted) return;
    switch (resultado.estado) {
      case EstadoBusqueda.nueva:
        setState(() {
          _nueva = resultado.actualizacion;
          _estado = _Estado.reposo;
        });
      case EstadoBusqueda.alDia:
        setState(() => _estado = _Estado.alDia);
      case EstadoBusqueda.error:
        setState(() => _estado = _Estado.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final estado = context.estado;

    return Scaffold(
      appBar: AppBar(title: const Text('Actualizaciones')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Versión instalada',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _version == null ? '…' : 'v$_version',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      FilledButton.tonal(
                        onPressed: _estado == _Estado.buscando ? null : _buscar,
                        child: _estado == _Estado.buscando
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Buscar actualizaciones'),
                      ),
                    ],
                  ),
                  if (_estado == _Estado.alDia) ...[
                    const SizedBox(height: 12),
                    Text('Estás al día', style: TextStyle(color: estado.exito)),
                  ],
                  if (_estado == _Estado.error) ...[
                    const SizedBox(height: 12),
                    Text(
                      'No se pudo comprobar (¿sin conexión?)',
                      style: TextStyle(color: estado.aviso),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (_nueva != null) ...[
            const SizedBox(height: 16),
            TarjetaActualizacion(nueva: _nueva!),
          ],
        ],
      ),
    );
  }
}
