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
import '../../data/database/seeds.dart';
import 'repositorio_tabla_puntos.dart';

/// Editor de la tabla de puntos por posición del campeonato activo. Cada
/// campeonato tiene su propio criterio (no todos reparten puntos igual), así
/// que aquí se puede personalizar entera: cuántas posiciones puntúan y
/// cuántos puntos da cada una.
class PantallaEditorTablaPuntos extends ConsumerStatefulWidget {
  const PantallaEditorTablaPuntos({super.key});

  @override
  ConsumerState<PantallaEditorTablaPuntos> createState() =>
      _PantallaEditorTablaPuntosState();
}

class _PantallaEditorTablaPuntosState
    extends ConsumerState<PantallaEditorTablaPuntos> {
  /// Un controlador de texto por posición (índice 0 = posición 1).
  List<TextEditingController> _controladores = [];
  bool _guardando = false;
  bool _cargado = false;

  @override
  void dispose() {
    for (final c in _controladores) {
      c.dispose();
    }
    super.dispose();
  }

  void _inicializar(List<int> puntos) {
    for (final c in _controladores) {
      c.dispose();
    }
    _controladores = [
      for (final p in puntos) TextEditingController(text: '$p'),
    ];
    _cargado = true;
  }

  void _anadirPosicion() {
    setState(() {
      final ultimo = _controladores.isEmpty
          ? 1
          : int.tryParse(_controladores.last.text) ?? 1;
      _controladores.add(TextEditingController(text: '$ultimo'));
    });
  }

  void _quitarUltimaPosicion() {
    if (_controladores.isEmpty) return;
    setState(() => _controladores.removeLast().dispose());
  }

  Future<void> _restaurarPorDefecto() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Restaurar valores por defecto'),
        content: const Text(
            'Se sustituirá la tabla de puntos actual por la de PitWall Control '
            '(70, 64, 59… hasta 1 punto). Los cambios no se guardan hasta que '
            'pulses "Guardar".'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Restaurar')),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => _inicializar(Seeds.puntosPorPosicionPorDefecto));
  }

  Future<void> _guardar() async {
    final activo = ref.read(campeonatoActivoProvider);
    if (activo == null) return;
    final puntos = <int>[];
    for (final c in _controladores) {
      final v = int.tryParse(c.text.trim());
      if (v == null || v < 0) {
        _aviso('Hay una posición con un valor de puntos no válido.');
        return;
      }
      puntos.add(v);
    }
    setState(() => _guardando = true);
    try {
      await ref
          .read(repositorioTablaPuntosProvider)
          .guardar(activo.id, puntos);
      if (mounted) {
        _aviso('Tabla de puntos guardada.');
        Navigator.of(context).pop();
      }
    } catch (e) {
      _aviso('No se pudo guardar: $e');
      if (mounted) setState(() => _guardando = false);
    }
  }

  void _aviso(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final tablaAsync = ref.watch(tablaPuntosProvider);
    final activo = ref.watch(campeonatoActivoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabla de puntos'),
        actions: [
          IconButton(
            tooltip: 'Restaurar valores por defecto',
            icon: const Icon(Icons.restore_outlined),
            onPressed: _restaurarPorDefecto,
          ),
        ],
      ),
      body: tablaAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (filas) {
          if (!_cargado) {
            final puntos = filas.isEmpty
                ? Seeds.puntosPorPosicionPorDefecto
                : filas.map((f) => f.puntos).toList();
            // No se puede llamar setState durante build; se inicializa aquí
            // (fuera de build) en el primer frame.
            WidgetsBinding.instance
                .addPostFrameCallback((_) => setState(() => _inicializar(puntos)));
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Card(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: Theme.of(context).colorScheme.outline),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Solo para "${activo?.nombre ?? ''}". Cada campeonato '
                            'tiene su propio criterio de puntos: el 1º de la '
                            'posición ${_controladores.length + 1} en adelante no '
                            'puntúa (0 puntos).',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                  itemCount: _controladores.length,
                  itemBuilder: (context, i) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 72,
                          child: Text('Pos. ${i + 1}',
                              style: Theme.of(context).textTheme.bodyMedium),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _controladores[i],
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Puntos',
                              isDense: true,
                            ),
                          ),
                        ),
                        if (i == _controladores.length - 1)
                          IconButton(
                            tooltip: 'Quitar última posición',
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: _quitarUltimaPosicion,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: _anadirPosicion,
                    icon: const Icon(Icons.add),
                    label: const Text('Añadir posición'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: FilledButton.icon(
                  onPressed: _guardando ? null : _guardar,
                  icon: _guardando
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check),
                  label: const Text('Guardar'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
