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

import 'fila_pago_equipo.dart';
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
              ...visibles.map((p) => FilaPagoEquipo(
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
