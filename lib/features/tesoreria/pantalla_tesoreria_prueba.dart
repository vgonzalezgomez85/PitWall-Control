import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/proveedores.dart';
import 'repositorio_tesoreria.dart';

class PantallaTesoreriaPrueba extends ConsumerWidget {
  const PantallaTesoreriaPrueba({super.key, required this.pruebaId});

  final int pruebaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final dataAsync = ref.watch(pagosPruebaProvider(pruebaId));
    final eur = NumberFormat.currency(locale: 'es_ES', symbol: '€');

    return Scaffold(
      appBar: AppBar(title: const Text('Tesorería de la prueba')),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (lista) {
          if (lista.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.group_off_outlined,
                        size: 96, color: cs.outline),
                    const SizedBox(height: 16),
                    Text('Sin equipos inscritos',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    const Text(
                      'Primero inscribe equipos a la prueba.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          final totalRecaudado =
              lista.fold<double>(0, (s, p) => s + p.total);
          final pagados = lista.where((p) => p.hayPago).length;

          return ListView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
            children: [
              Card(
                color: cs.surfaceContainer,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Recaudado en la prueba',
                                style: TextStyle(
                                    color: cs.outline, fontSize: 13)),
                            Text(eur.format(totalRecaudado),
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                      Text('$pagados / ${lista.length} pagados',
                          style: TextStyle(color: cs.outline)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ...lista.map((p) => _FilaPago(
                    pruebaId: pruebaId,
                    pago: p,
                    eur: eur,
                  )),
            ],
          );
        },
      ),
    );
  }
}

class _FilaPago extends ConsumerStatefulWidget {
  const _FilaPago({
    required this.pruebaId,
    required this.pago,
    required this.eur,
  });
  final int pruebaId;
  final PagoEquipo pago;
  final NumberFormat eur;

  @override
  ConsumerState<_FilaPago> createState() => _FilaPagoState();
}

class _FilaPagoState extends ConsumerState<_FilaPago> {
  late TextEditingController _pagat;
  late TextEditingController _coord;
  late TextEditingController _club;
  late TextEditingController _obs;

  @override
  void initState() {
    super.initState();
    _pagat = TextEditingController(text: _v(widget.pago.pago?.pagat));
    _coord = TextEditingController(text: _v(widget.pago.pago?.coordinadora));
    _club = TextEditingController(text: _v(widget.pago.pago?.club));
    _obs = TextEditingController(text: widget.pago.pago?.observaciones ?? '');
  }

  String _v(double? n) => (n == null || n == 0) ? '' : n.toStringAsFixed(2);
  double _p(TextEditingController c) =>
      double.tryParse(c.text.trim().replaceAll(',', '.')) ?? 0;

  Future<void> _guardar() async {
    await ref.read(repoTesoreriaProvider).guardarPago(
          id: widget.pago.pago?.id,
          pruebaId: widget.pruebaId,
          equipoId: widget.pago.equipoId,
          pagat: _p(_pagat),
          coordinadora: _p(_coord),
          club: _p(_club),
          observaciones: _obs.text.trim().isEmpty ? null : _obs.text.trim(),
        );
  }

  void _rellenarRapido(double pagat, double coord, double club) {
    setState(() {
      _pagat.text = pagat.toStringAsFixed(2);
      _coord.text = coord.toStringAsFixed(2);
      _club.text = club.toStringAsFixed(2);
    });
    _guardar();
  }

  // Cuotas del campeonato activo (configurables por campeonato).
  double get _cuotaPagat =>
      ref.read(campeonatoActivoProvider)?.cuotaPagat ?? 25.0;
  double get _cuotaCoord =>
      ref.read(campeonatoActivoProvider)?.cuotaCoordinadora ?? 11.0;
  double get _cuotaClub =>
      ref.read(campeonatoActivoProvider)?.cuotaClub ?? 14.0;

  @override
  void dispose() {
    _pagat.dispose();
    _coord.dispose();
    _club.dispose();
    _obs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final p = widget.pago;
    // Total = pagat (coord y club son desglose interno)
    final total = _p(_pagat);
    if (p.exento) {
      return Card(
        color: cs.surfaceContainer,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: cs.tertiaryContainer,
            child: Icon(Icons.card_giftcard, color: cs.onTertiaryContainer),
          ),
          title: Text(p.nombreEquipo,
              style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text(
            '${p.pilotosTexto}\n'
            '${p.motivoExencion!} — no paga esta prueba',
          ),
          isThreeLine: true,
          trailing: IconButton(
            tooltip: 'Quitar wildcard',
            icon: const Icon(Icons.close),
            onPressed: p.wildcard
                ? () => ref.read(repoTesoreriaProvider).marcarWildcard(
                      pruebaId: widget.pruebaId,
                      equipoId: p.equipoId,
                      wildcard: false,
                    )
                : null,
          ),
        ),
      );
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: total > 0
                      ? Colors.green.shade100
                      : cs.surfaceContainerHighest,
                  child: Icon(
                    total > 0 ? Icons.check : Icons.attach_money,
                    color: total > 0 ? Colors.green.shade700 : cs.outline,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.nombreEquipo,
                          style:
                              Theme.of(context).textTheme.titleMedium),
                      Text(p.pilotosTexto,
                          style: TextStyle(
                              color: cs.outline, fontSize: 13)),
                      Text('Copa ${p.copa}',
                          style: TextStyle(
                              color: cs.outline, fontSize: 12)),
                    ],
                  ),
                ),
                Text(widget.eur.format(total),
                    style: TextStyle(
                      color: total > 0 ? Colors.green.shade700 : cs.outline,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    )),
                IconButton(
                  tooltip: 'Marcar como wildcard (no paga)',
                  icon: const Icon(Icons.card_giftcard_outlined),
                  onPressed: () =>
                      ref.read(repoTesoreriaProvider).marcarWildcard(
                            pruebaId: widget.pruebaId,
                            equipoId: p.equipoId,
                            wildcard: true,
                          ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Desglose de los €${total.toStringAsFixed(2)} pagados',
              style: TextStyle(color: cs.outline, fontSize: 12),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _pagat,
                    decoration: const InputDecoration(
                      labelText: 'Pagat',
                      isDense: true,
                      prefixText: '€ ',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    onTapOutside: (_) => _guardar(),
                    onSubmitted: (_) => _guardar(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _coord,
                    decoration: const InputDecoration(
                      labelText: 'Coordinadora',
                      isDense: true,
                      prefixText: '€ ',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    onTapOutside: (_) => _guardar(),
                    onSubmitted: (_) => _guardar(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _club,
                    decoration: const InputDecoration(
                      labelText: 'Club',
                      isDense: true,
                      prefixText: '€ ',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    onTapOutside: (_) => _guardar(),
                    onSubmitted: (_) => _guardar(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _obs,
              decoration: const InputDecoration(
                labelText: 'Observaciones (opcional)',
                isDense: true,
              ),
              onTapOutside: (_) => _guardar(),
              onSubmitted: (_) => _guardar(),
            ),
            if (p.pagaMitad) ...[
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: cs.tertiaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        size: 16, color: cs.onTertiaryContainer),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        p.notaMitad ?? '',
                        style: TextStyle(
                            color: cs.onTertiaryContainer, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Pago rápido:',
                    style: TextStyle(color: cs.outline, fontSize: 13)),
                const SizedBox(width: 8),
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    children: [
                      ActionChip(
                        avatar: const Icon(Icons.flash_on, size: 16),
                        label: Text(
                          '${(_cuotaPagat * p.factorPago).toStringAsFixed(p.pagaMitad ? 2 : 0)} / '
                          '${(_cuotaCoord * p.factorPago).toStringAsFixed(p.pagaMitad ? 2 : 0)} / '
                          '${(_cuotaClub * p.factorPago).toStringAsFixed(p.pagaMitad ? 2 : 0)}',
                        ),
                        onPressed: () => _rellenarRapido(
                          _cuotaPagat * p.factorPago,
                          _cuotaCoord * p.factorPago,
                          _cuotaClub * p.factorPago,
                        ),
                      ),
                      ActionChip(
                        label: const Text('Limpiar'),
                        onPressed: () {
                          setState(() {
                            _pagat.clear();
                            _coord.clear();
                            _club.clear();
                            _obs.clear();
                          });
                          if (p.pago != null) {
                            ref
                                .read(repoTesoreriaProvider)
                                .borrar(p.pago!.id);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
