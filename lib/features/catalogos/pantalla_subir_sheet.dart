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

import '../../core/idioma.dart';
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
    final l = context.l;
    setState(() => _trabajando = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final r = await ref.read(subidorCatalogoProvider).aplicar(plan);
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(
        content: Text(
            '${l.subidoSheetResumen(r.anadidas, r.actualizadas, r.borradas)}'
            '${r.fotosFallidas.isEmpty ? '' : l.fotosSinSubir(r.fotosFallidas.join('; '))}'),
        duration: Duration(seconds: r.fotosFallidas.isEmpty ? 4 : 10),
      ));
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      messenger
          .showSnackBar(SnackBar(content: Text(l.errorAlSubir('$e'))));
      setState(() => _trabajando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final cs = Theme.of(context).colorScheme;
    final nuevas = plan.nuevas;
    final conflictos = plan.conflictos;
    final borrados = plan.borrados;
    final totalAplicar = nuevas.where((f) => f.aplicar).length +
        conflictos.where((f) => f.aplicar).length +
        borrados.where((f) => f.aplicar).length;

    return Scaffold(
      appBar: AppBar(title: Text(l.subirAlSheet)),
      body: plan.vacio
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  l.nadaQueSubir(plan.identicas),
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
                    '${l.subidaIntro}\n'
                    '${l.filasNuevasResumen(nuevas.length)}\n'
                    '${l.conDiferenciasResumen(conflictos.length)}\n'
                    '${borrados.isNotEmpty ? '${l.borradasResumen(borrados.length)}\n' : ''}'
                    '${l.identicasResumen(plan.identicas)}',
                    style: TextStyle(color: cs.onSurface, fontSize: 13),
                  ),
                ),
                if (borrados.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(l.borradasEnAppPregunta,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  ...borrados.map((f) => Card(
                        child: SwitchListTile(
                          dense: true,
                          value: f.aplicar,
                          onChanged: (v) => setState(() => f.aplicar = v),
                          secondary: Icon(Icons.delete_outline, color: cs.error),
                          title: Text(f.etiqueta),
                          subtitle: Text(f.aplicar
                              ? l.seBorraraEsaFila
                              : l.seDejaEnSheet),
                        ),
                      )),
                ],
                if (nuevas.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(l.filasNuevasTitulo,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  ...nuevas.map((f) => Card(
                        child: SwitchListTile(
                          dense: true,
                          value: f.aplicar,
                          onChanged: (v) => setState(() => f.aplicar = v),
                          secondary: const Icon(Icons.add_circle_outline),
                          title: Text(f.etiqueta),
                          subtitle: Text(l.seAnadiraAlSheet),
                        ),
                      )),
                ],
                if (conflictos.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(l.diferenciasConflictos,
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
                  label: Text(l.subirNAlSheet(totalAplicar)),
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
    final l = context.l;
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
                  ? l.seSubiraTuVersion
                  : l.seMantieneSheet,
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
                                text: l.appValor(
                                    d.app.isEmpty ? l.vacioParentesis : d.app),
                                style: TextStyle(
                                    color: cs.primary,
                                    fontWeight: FontWeight.w600),
                              ),
                              const TextSpan(text: '   ·   '),
                              TextSpan(
                                text: l.sheetValor(d.sheet.isEmpty
                                    ? l.vacioParentesis
                                    : d.sheet),
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
