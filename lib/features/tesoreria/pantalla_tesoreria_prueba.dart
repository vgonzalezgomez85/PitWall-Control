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
import 'package:intl/intl.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import 'repositorio_tesoreria.dart';

/// Minúsculas y sin acentos, para buscar "diaz" y encontrar "Díaz".
String _normalizar(String s) => s
    .toLowerCase()
    .replaceAll(RegExp('[áàä]'), 'a')
    .replaceAll(RegExp('[éèë]'), 'e')
    .replaceAll(RegExp('[íìï]'), 'i')
    .replaceAll(RegExp('[óòö]'), 'o')
    .replaceAll(RegExp('[úùü]'), 'u');

class PantallaTesoreriaPrueba extends ConsumerStatefulWidget {
  const PantallaTesoreriaPrueba({super.key, required this.pruebaId});

  final int pruebaId;

  @override
  ConsumerState<PantallaTesoreriaPrueba> createState() =>
      _PantallaTesoreriaPruebaState();
}

class _PantallaTesoreriaPruebaState
    extends ConsumerState<PantallaTesoreriaPrueba> {
  final _buscador = TextEditingController();
  String _busqueda = '';

  int get pruebaId => widget.pruebaId;

  @override
  void dispose() {
    _buscador.dispose();
    super.dispose();
  }

  bool _coincide(PagoEquipo p) {
    if (_busqueda.isEmpty) return true;
    return _normalizar([
      p.nombreEquipo,
      p.piloto1.nombre,
      p.piloto2?.nombre ?? '',
      p.copa,
    ].join(' '))
        .contains(_busqueda);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dataAsync = ref.watch(pagosPruebaProvider(pruebaId));
    final eur = NumberFormat.currency(locale: 'es_ES', symbol: '€');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tesorería de la prueba'),
        // Buscador fijo arriba: localizar rápido quién va a pagar.
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: TextField(
              controller: _buscador,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Buscar piloto o equipo…',
                suffixIcon: _busqueda.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Borrar',
                        icon: const Icon(Icons.close),
                        onPressed: () => setState(() {
                          _buscador.clear();
                          _busqueda = '';
                        }),
                      ),
              ),
              onChanged: (v) =>
                  setState(() => _busqueda = _normalizar(v.trim())),
            ),
          ),
        ),
      ),
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
          final exentos = lista.where((p) => p.exento).length;
          final aPagar = lista.length - exentos;
          final visibles = lista.where(_coincide).toList();

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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('$pagados / $aPagar pagados',
                              style: TextStyle(
                                  color: pagados >= aPagar
                                      ? Colors.green.shade700
                                      : cs.outline)),
                          if (exentos > 0)
                            Text('$exentos no pagan',
                                style: TextStyle(
                                    color: cs.outline, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (visibles.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text('Nadie coincide con "${_buscador.text.trim()}".',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: cs.outline)),
                ),
              // Con clave: al filtrar, cada fila conserva su propio estado.
              ...visibles.map((p) => _FilaPago(
                    key: ValueKey(p.equipoId),
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
    super.key,
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
    _pagat = TextEditingController();
    _coord = TextEditingController();
    _club = TextEditingController();
    _obs = TextEditingController();
    _cargarDe(widget.pago.pago);
  }

  void _cargarDe(Pago? pago) {
    _pagat.text = _v(pago?.pagat);
    _coord.text = _v(pago?.coordinadora);
    _club.text = _v(pago?.club);
    _obs.text = pago?.observaciones ?? '';
  }

  // Si el pago cambia en la base de datos (se guarda, se borra, se recalcula
  // el reparto…), los campos reflejan lo guardado.
  @override
  void didUpdateWidget(covariant _FilaPago old) {
    super.didUpdateWidget(old);
    if (old.pago.pago != widget.pago.pago) _cargarDe(widget.pago.pago);
  }

  String _v(double? n) => (n == null || n == 0) ? '' : n.toStringAsFixed(2);
  double _p(TextEditingController c) =>
      double.tryParse(c.text.trim().replaceAll(',', '.')) ?? 0;

  Future<void> _guardar() async {
    // Pagat escrito a mano sin desglose: se reparte solo con la proporción
    // de la cuota del campeonato.
    final pagat = _p(_pagat);
    if (pagat > 0 && _p(_coord) == 0 && _p(_club) == 0) {
      final (c, cl) = repartir(pagat,
          cuotaCoordinadora: _cuotaCoord, cuotaClub: _cuotaClub);
      _coord.text = c.toStringAsFixed(2);
      _club.text = cl.toStringAsFixed(2);
    }
    if (mounted) setState(() {});
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

  void _rellenarRapido(double pagat, double coord, double club,
      {String? observacion}) {
    setState(() {
      _pagat.text = pagat.toStringAsFixed(2);
      _coord.text = coord.toStringAsFixed(2);
      _club.text = club.toStringAsFixed(2);
      if (observacion != null && _obs.text.trim().isEmpty) {
        _obs.text = observacion;
      }
    });
    _guardar();
  }

  /// Guarda al salir del campo y le quita el foco (si no, cada clic fuera
  /// volvería a guardar).
  void _salir() {
    FocusManager.instance.primaryFocus?.unfocus();
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
    // Reconstruir si cambia el reparto de la cuota.
    ref.watch(campeonatoActivoProvider);
    final p = widget.pago;
    // Total = pagat (coord y club son desglose interno)
    final total = _p(_pagat);
    final descuadre = total > 0 &&
        ((_p(_coord) + _p(_club)) - total).abs() >= 0.01;
    if (p.exento) {
      // Qué se puede deshacer desde aquí: wildcard y "Coord. total". Si es
      // por la ficha de los pilotos, se cambia allí.
      final quitable = p.wildcard || p.exentoCoordinadora;
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
            tooltip: p.wildcard
                ? 'Quitar wildcard'
                : p.exentoCoordinadora
                    ? 'Quitar "Coord. total" (vuelve a pagar)'
                    : 'Los pilotos están marcados como coordinadora en su '
                        'ficha; cámbialo allí',
            icon: Icon(quitable ? Icons.close : Icons.info_outline),
            onPressed: !quitable
                ? null
                : () async {
                    final repo = ref.read(repoTesoreriaProvider);
                    if (p.wildcard) {
                      await repo.marcarWildcard(
                        pruebaId: widget.pruebaId,
                        equipoId: p.equipoId,
                        wildcard: false,
                      );
                    }
                    if (p.exentoCoordinadora) {
                      await repo.marcarCoordinadora(
                        pruebaId: widget.pruebaId,
                        equipoId: p.equipoId,
                        exento: false,
                      );
                    }
                  },
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
                      Text(
                          'Copa ${p.copa}'
                          '${p.mangaNombre == null ? '' : '  ·  ${p.mangaNombre}'}',
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
                    onTapOutside: (_) => _salir(),
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
                    onTapOutside: (_) => _salir(),
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
                    onTapOutside: (_) => _salir(),
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
              onTapOutside: (_) => _salir(),
              onSubmitted: (_) => _guardar(),
            ),
            if (descuadre) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      size: 16, color: cs.error),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Coordinadora + Club '
                      '(${widget.eur.format(_p(_coord) + _p(_club))}) '
                      'no suma el Pagat (${widget.eur.format(total)}).',
                      style: TextStyle(color: cs.error, fontSize: 12),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      final (c, cl) = repartir(total,
                          cuotaCoordinadora: _cuotaCoord,
                          cuotaClub: _cuotaClub);
                      _coord.text = c.toStringAsFixed(2);
                      _club.text = cl.toStringAsFixed(2);
                      _guardar();
                    },
                    child: const Text('Repartir'),
                  ),
                ],
              ),
            ],
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
                      // Mitad de todo: un piloto del equipo es de coordinadora.
                      ActionChip(
                        avatar: const Icon(Icons.group_outlined, size: 16),
                        label: const Text('Coord. + piloto'),
                        tooltip:
                            'Un piloto es de coordinadora: paga la mitad de todo '
                            '(€${(_cuotaPagat / 2).toStringAsFixed(2)})',
                        onPressed: () => _rellenarRapido(
                          _cuotaPagat / 2,
                          _cuotaCoord / 2,
                          _cuotaClub / 2,
                          observacion: 'Mitad — un piloto de coordinadora',
                        ),
                      ),
                      // Todo el equipo es de coordinadora: no paga.
                      ActionChip(
                        avatar: const Icon(Icons.groups_outlined, size: 16),
                        label: const Text('Coord. total'),
                        tooltip:
                            'Todos los pilotos son de coordinadora: no paga',
                        // Se guarda como exención de la prueba (igual que el
                        // wildcard), no como un pago de 0 €.
                        onPressed: () => ref
                            .read(repoTesoreriaProvider)
                            .marcarCoordinadora(
                              pruebaId: widget.pruebaId,
                              equipoId: p.equipoId,
                              exento: true,
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
                          // Por (prueba, equipo): el pago puede haberse
                          // creado hace un instante y aún no estar en p.pago.
                          ref.read(repoTesoreriaProvider).borrarDe(
                                pruebaId: widget.pruebaId,
                                equipoId: p.equipoId,
                              );
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
