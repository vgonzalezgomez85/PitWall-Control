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

import '../google/subidor_catalogo.dart';

/// Revisión de la subida al Google Sheet: muestra las filas nuevas que se
/// añadirán y los conflictos (la hoja tiene un valor distinto), donde se elige
/// fila a fila si prevalece lo de la app.
class PantallaSubirSheet extends ConsumerStatefulWidget {
  const PantallaSubirSheet({super.key, required this.plan});
  final PlanSubida plan;

  @override
  ConsumerState<PantallaSubirSheet> createState() => _State();
}

class _State extends ConsumerState<PantallaSubirSheet> {
  bool _trabajando = false;

  PlanSubida get plan => widget.plan;

  Future<void> _aplicar() async {
    setState(() => _trabajando = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final r = await ref.read(subidorCatalogoProvider).aplicar(plan);
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(
        content: Text(
            '✓ Subido al Sheet: ${r.anadidas} añadidas, ${r.actualizadas} actualizadas.'),
        duration: const Duration(seconds: 4),
      ));
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text('Error al subir: $e')));
      setState(() => _trabajando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final nuevas = plan.nuevas;
    final conflictos = plan.conflictos;
    final totalAplicar = nuevas.where((f) => f.aplicar).length +
        conflictos.where((f) => f.aplicar).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Subir al Sheet')),
      body: plan.vacio
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'No hay nada que subir: la hoja ya coincide con la app.\n\n'
                  '(${plan.identicas} filas idénticas)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: cs.outline),
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 96),
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Se subirán tus cambios al Google Sheet.\n'
                    '· ${nuevas.length} filas nuevas (se añaden)\n'
                    '· ${conflictos.length} con diferencias (elige cuáles pisan la hoja)\n'
                    '· ${plan.identicas} idénticas (se ignoran)',
                    style: TextStyle(color: cs.onSurface, fontSize: 13),
                  ),
                ),
                if (nuevas.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text('Filas nuevas',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  ...nuevas.map((f) => Card(
                        child: SwitchListTile(
                          dense: true,
                          value: f.aplicar,
                          onChanged: (v) => setState(() => f.aplicar = v),
                          secondary: const Icon(Icons.add_circle_outline),
                          title: Text(f.etiqueta),
                          subtitle: const Text('Se añadirá al Sheet'),
                        ),
                      )),
                ],
                if (conflictos.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text('Diferencias (conflictos)',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  ...conflictos.map((f) => _TarjetaConflicto(
                        fila: f,
                        onCambio: (v) => setState(() => f.aplicar = v),
                      )),
                ],
              ],
            ),
      bottomNavigationBar: plan.vacio
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: FilledButton.icon(
                  onPressed: (_trabajando || totalAplicar == 0) ? null : _aplicar,
                  icon: _trabajando
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.cloud_upload_outlined),
                  label: Text('Subir $totalAplicar al Sheet'),
                ),
              ),
            ),
    );
  }
}

class _TarjetaConflicto extends StatelessWidget {
  const _TarjetaConflicto({required this.fila, required this.onCambio});
  final FilaSubida fila;
  final ValueChanged<bool> onCambio;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(fila.etiqueta,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16)),
                ),
                Switch(value: fila.aplicar, onChanged: onCambio),
              ],
            ),
            Text(
              fila.aplicar
                  ? 'Se subirá tu versión (pisa la hoja)'
                  : 'Se mantiene lo del Sheet',
              style: TextStyle(
                  color: fila.aplicar ? cs.primary : cs.outline, fontSize: 12),
            ),
            const SizedBox(height: 8),
            ...fila.diffs.map((d) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 90,
                        child: Text(d.columna,
                            style: TextStyle(color: cs.outline, fontSize: 12)),
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style.copyWith(
                                  fontSize: 13,
                                ),
                            children: [
                              TextSpan(
                                text: 'app: ${d.app.isEmpty ? "(vacío)" : d.app}',
                                style: TextStyle(
                                    color: cs.primary,
                                    fontWeight: FontWeight.w600),
                              ),
                              const TextSpan(text: '   ·   '),
                              TextSpan(
                                text:
                                    'sheet: ${d.sheet.isEmpty ? "(vacío)" : d.sheet}',
                                style: TextStyle(color: cs.outline),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
