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
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import 'pantalla_tesoreria_prueba.dart';
import 'repositorio_tesoreria.dart';

class PantallaTesoreria extends ConsumerWidget {
  const PantallaTesoreria({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final dataAsync = ref.watch(tesoreriaCampeonatoProvider);
    final movsAsync = ref.watch(movimientosCampeonatoProvider);
    final activo = ref.watch(campeonatoActivoProvider);
    final eur = NumberFormat.currency(locale: 'es_ES', symbol: '€');

    return Scaffold(
      appBar: AppBar(title: const Text('Tesorería')),
      floatingActionButton: activo == null
          ? null
          : FloatingActionButton.extended(
              heroTag: 'fab_tesoreria',
              onPressed: () => _editarMovimiento(
                  context, ref, activo.id, null, null),
              icon: const Icon(Icons.add),
              label: const Text('Movimiento'),
            ),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (lista) {
          if (lista.isEmpty && activo == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.payments_outlined,
                        size: 96, color: cs.outline),
                    const SizedBox(height: 16),
                    Text('No hay campeonato activo',
                        style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              ),
            );
          }

          final totalPagos = lista.fold<double>(0, (s, r) => s + r.sumaTotal);
          final totalPagat =
              lista.fold<double>(0, (s, r) => s + r.sumaPagat);
          final totalCoord =
              lista.fold<double>(0, (s, r) => s + r.sumaCoordinadora);
          final totalClub = lista.fold<double>(0, (s, r) => s + r.sumaClub);

          final movs = movsAsync.asData?.value ?? const [];
          final ingresos = movs
              .where((m) => m.importe > 0)
              .fold<double>(0, (s, m) => s + m.importe);
          final gastos = movs
              .where((m) => m.importe < 0)
              .fold<double>(0, (s, m) => s + m.importe.abs());
          final balance = totalPagos + ingresos - gastos;

          return ListView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 96),
            children: [
              _ResumenGlobal(
                total: balance,
                pagat: totalPagat,
                coordinadora: totalCoord,
                club: totalClub,
                ingresos: ingresos,
                gastos: gastos,
                eur: eur,
              ),
              const SizedBox(height: 12),
              if (lista.isNotEmpty) ...[
                Text('Por prueba',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ...lista.map((r) => _TarjetaPrueba(resumen: r, eur: eur)),
                const SizedBox(height: 12),
              ],
              _SeccionMovimientos(
                movimientos: movs,
                eur: eur,
                onEditar: (m) =>
                    _editarMovimiento(context, ref, activo!.id, null, m),
              ),
            ],
          );
        },
      ),
    );
  }
}

Future<void> _editarMovimiento(
  BuildContext context,
  WidgetRef ref,
  int campeonatoId,
  int? pruebaId,
  MovimientosTesoreriaData? mov,
) async {
  final concepto = TextEditingController(text: mov?.concepto ?? '');
  final importe = TextEditingController(
      text: mov == null ? '' : mov.importe.toStringAsFixed(2));
  final notas = TextEditingController(text: mov?.notas ?? '');
  // tipo: true=ingreso, false=gasto
  bool ingreso = mov == null ? true : mov.importe >= 0;

  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setS) => AlertDialog(
        title: Text(mov == null ? 'Nuevo movimiento' : 'Editar movimiento'),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(
                    value: true,
                    label: Text('Ingreso'),
                    icon: Icon(Icons.arrow_downward),
                  ),
                  ButtonSegment(
                    value: false,
                    label: Text('Gasto'),
                    icon: Icon(Icons.arrow_upward),
                  ),
                ],
                selected: {ingreso},
                onSelectionChanged: (s) => setS(() => ingreso = s.first),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: concepto,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Concepto *',
                  helperText: 'Ej: Patrocinio, Material, Premio…',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: importe,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Importe (€) *',
                  helperText: 'Solo el número, sin signo',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: notas,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Notas'),
              ),
            ],
          ),
        ),
        actions: [
          if (mov != null)
            TextButton.icon(
              icon: const Icon(Icons.delete_outline),
              label: const Text('Eliminar'),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () async {
                await ref
                    .read(repoTesoreriaProvider)
                    .borrarMovimiento(mov.id);
                if (ctx.mounted) Navigator.pop(ctx, false);
              },
            ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Guardar'),
          ),
        ],
      ),
    ),
  );
  if (ok != true) return;
  final c = concepto.text.trim();
  final imp = double.tryParse(importe.text.replaceAll(',', '.')) ?? 0;
  if (c.isEmpty || imp <= 0) return;
  final repo = ref.read(repoTesoreriaProvider);
  final firmado = ingreso ? imp : -imp;
  if (mov == null) {
    await repo.crearMovimiento(
      campeonatoId: campeonatoId,
      pruebaId: pruebaId,
      concepto: c,
      importe: firmado,
      notas: notas.text.trim().isEmpty ? null : notas.text.trim(),
    );
  } else {
    await repo.actualizarMovimiento(
      mov.id,
      concepto: c,
      importe: firmado,
      notas: notas.text.trim().isEmpty ? null : notas.text.trim(),
    );
  }
}

class _SeccionMovimientos extends StatelessWidget {
  const _SeccionMovimientos({
    required this.movimientos,
    required this.eur,
    required this.onEditar,
  });
  final List<MovimientosTesoreriaData> movimientos;
  final NumberFormat eur;
  final void Function(MovimientosTesoreriaData) onEditar;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final df = DateFormat('dd/MM/yyyy');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Movimientos extras',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(width: 8),
            Text('(ingresos y gastos sueltos)',
                style: TextStyle(color: cs.outline, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 8),
        if (movimientos.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Sin movimientos. Usa el botón "+ Movimiento" para añadir patrocinios, gastos de material, etc.',
                style: TextStyle(color: cs.outline),
              ),
            ),
          )
        else
          ...movimientos.map((m) {
            final esIngreso = m.importe >= 0;
            final color = esIngreso ? Colors.green.shade700 : Colors.red.shade700;
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.15),
                  child: Icon(
                    esIngreso ? Icons.arrow_downward : Icons.arrow_upward,
                    color: color,
                  ),
                ),
                title: Text(m.concepto,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(
                  '${df.format(m.fecha)}'
                  '${m.notas != null && m.notas!.isNotEmpty ? ' · ${m.notas}' : ''}',
                  style: TextStyle(color: cs.outline, fontSize: 12),
                ),
                trailing: Text(
                  '${esIngreso ? '+' : '−'}${eur.format(m.importe.abs())}',
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                ),
                onTap: () => onEditar(m),
              ),
            );
          }),
      ],
    );
  }
}

class _ResumenGlobal extends StatelessWidget {
  const _ResumenGlobal({
    required this.total,
    required this.pagat,
    required this.coordinadora,
    required this.club,
    required this.ingresos,
    required this.gastos,
    required this.eur,
  });

  final double total;
  final double pagat;
  final double coordinadora;
  final double club;
  final double ingresos;
  final double gastos;
  final NumberFormat eur;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      color: cs.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.payments_outlined,
                    color: cs.onPrimaryContainer),
                const SizedBox(width: 8),
                Text('Balance del campeonato',
                    style: TextStyle(
                        color: cs.onPrimaryContainer,
                        fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 8),
            Text(eur.format(total),
                style: TextStyle(
                  color: cs.onPrimaryContainer,
                  fontWeight: FontWeight.w800,
                  fontSize: 28,
                )),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _Mini(label: 'Pagat', valor: pagat, eur: eur),
                _Mini(label: 'Coordinadora', valor: coordinadora, eur: eur),
                _Mini(label: 'Club', valor: club, eur: eur),
                if (ingresos > 0)
                  _Mini(label: '+ Ingresos', valor: ingresos, eur: eur),
                if (gastos > 0)
                  _Mini(label: '− Gastos', valor: gastos, eur: eur),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Mini extends StatelessWidget {
  const _Mini({required this.label, required this.valor, required this.eur});
  final String label;
  final double valor;
  final NumberFormat eur;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$label: ', style: TextStyle(color: cs.outline, fontSize: 13)),
          Text(eur.format(valor),
              style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _TarjetaPrueba extends StatelessWidget {
  const _TarjetaPrueba({required this.resumen, required this.eur});
  final ResumenPruebaPagos resumen;
  final NumberFormat eur;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final p = resumen.prueba;
    final progreso = resumen.totalEquipos == 0
        ? 0.0
        : resumen.pagados / resumen.totalEquipos;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PantallaTesoreriaPrueba(pruebaId: p.id),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text('#${p.orden}',
                        style: TextStyle(
                            color: cs.onPrimaryContainer,
                            fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(p.nombre,
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  Text(eur.format(resumen.sumaTotal),
                      style: TextStyle(
                          color: cs.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '${resumen.pagados} / ${resumen.totalEquipos} pagados',
                    style: TextStyle(color: cs.outline, fontSize: 13),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progreso,
                        minHeight: 6,
                        backgroundColor: cs.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation(
                          progreso >= 1
                              ? Colors.green.shade700
                              : cs.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  _ChipMini(
                      texto: 'Pagat ${eur.format(resumen.sumaPagat)}',
                      color: cs.secondary),
                  _ChipMini(
                      texto:
                          'Coord. ${eur.format(resumen.sumaCoordinadora)}',
                      color: cs.tertiary),
                  _ChipMini(
                      texto: 'Club ${eur.format(resumen.sumaClub)}',
                      color: cs.outline),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChipMini extends StatelessWidget {
  const _ChipMini({required this.texto, required this.color});
  final String texto;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(texto,
          style: TextStyle(
              color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}
