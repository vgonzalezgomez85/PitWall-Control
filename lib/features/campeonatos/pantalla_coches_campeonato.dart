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
import '../../data/database/app_database.dart';
import 'repositorio_coches_campeonato.dart';

/// Peso mínimo y créditos de cada coche en UN campeonato. Lo que se deja
/// vacío sigue al catálogo; lo que se rellena manda en este campeonato
/// aunque después cambie el catálogo.
class PantallaCochesCampeonato extends ConsumerStatefulWidget {
  const PantallaCochesCampeonato({super.key, required this.campeonatoId});
  final int campeonatoId;

  @override
  ConsumerState<PantallaCochesCampeonato> createState() =>
      _PantallaCochesCampeonatoState();
}

class _PantallaCochesCampeonatoState
    extends ConsumerState<PantallaCochesCampeonato> {
  Campeonato? _camp;
  List<CatalogoCoche> _coches = [];
  final _peso = <int, TextEditingController>{};
  final _creditos = <int, TextEditingController>{};
  String _busqueda = '';
  bool _cargando = true;
  bool _guardando = false;

  RepositorioCochesCampeonato get _repo =>
      ref.read(repoCochesCampeonatoProvider);

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  @override
  void dispose() {
    for (final c in [..._peso.values, ..._creditos.values]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _cargar() async {
    final db = ref.read(dbProvider);
    final camp = await (db.select(db.campeonatos)
          ..where((t) => t.id.equals(widget.campeonatoId)))
        .getSingleOrNull();
    if (camp == null) {
      if (mounted) Navigator.of(context).pop();
      return;
    }
    final ajustes = await _repo.ajustes(camp.id);
    final coches = await _repo.cochesDelCampeonato(camp);
    // También los que tienen valores fijados aunque ya no encajen (coche
    // desactivado o sin la copa): no se pierden de vista.
    final faltan = ajustes.keys.where((id) => !coches.any((c) => c.id == id));
    if (faltan.isNotEmpty) {
      coches.addAll(await (db.select(db.catalogoCoches)
            ..where((t) => t.id.isIn(faltan)))
          .get());
    }
    coches.sort((a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()));
    for (final c in coches) {
      final a = ajustes[c.id];
      (_peso[c.id] ??= TextEditingController()).text =
          a?.pesoMin?.toStringAsFixed(2) ?? '';
      (_creditos[c.id] ??= TextEditingController()).text =
          a?.creditosCoche?.toString() ?? '';
    }
    if (mounted) {
      setState(() {
        _camp = camp;
        _coches = coches;
        _cargando = false;
      });
    }
  }

  Future<void> _guardar() async {
    // Validar todo antes de escribir nada.
    final valores = <int, (double?, int?)>{};
    for (final c in _coches) {
      final p = _peso[c.id]!.text.trim().replaceAll(',', '.');
      final cr = _creditos[c.id]!.text.trim();
      final peso = p.isEmpty ? null : double.tryParse(p);
      final cred = cr.isEmpty ? null : int.tryParse(cr);
      if ((p.isNotEmpty && peso == null) || (cr.isNotEmpty && cred == null)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Valor no válido en ${c.nombre}.')));
        return;
      }
      valores[c.id] = (peso, cred);
    }
    setState(() => _guardando = true);
    try {
      for (final e in valores.entries) {
        await _repo.fijar(
          widget.campeonatoId,
          e.key,
          pesoMin: e.value.$1,
          creditos: e.value.$2,
        );
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No se pudo guardar: $e')));
        setState(() => _guardando = false);
      }
    }
  }

  Future<void> _fijarDesdeCatalogo() async {
    final n = await _repo.fijarDesdeCatalogo(widget.campeonatoId);
    await _cargar();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(n == 0
              ? 'Todos los coches ya tenían sus valores fijados.'
              : 'Fijados los valores del catálogo en $n coches.')));
    }
  }

  Future<void> _volverAlCatalogo() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Volver al catálogo'),
        content: const Text('Se borran los valores fijados en este '
            'campeonato y todos los coches vuelven a usar el peso mínimo y '
            'los créditos del catálogo.\n\nLas verificaciones ya validadas '
            'no cambian: guardan el reglamento con el que se verificaron.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Volver al catálogo')),
        ],
      ),
    );
    if (ok != true) return;
    await _repo.quitarTodos(widget.campeonatoId);
    await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final cs = Theme.of(context).colorScheme;
    final usaCreditos = _camp!.usaCreditos;
    final q = _busqueda.trim().toLowerCase();
    final visibles = q.isEmpty
        ? _coches
        : _coches.where((c) => c.nombre.toLowerCase().contains(q)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coches del campeonato'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (op) {
              if (op == 'fijar') _fijarDesdeCatalogo();
              if (op == 'catalogo') _volverAlCatalogo();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'fijar',
                child: ListTile(
                  leading: Icon(Icons.push_pin_outlined),
                  title: Text('Fijar los valores actuales del catálogo'),
                ),
              ),
              PopupMenuItem(
                value: 'catalogo',
                child: ListTile(
                  leading: Icon(Icons.restore),
                  title: Text('Volver todos al catálogo'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Peso mínimo${usaCreditos ? ' y créditos' : ''} de cada coche '
                  'en ${_camp!.nombre}. Vacío = se usa el valor del catálogo. '
                  'Lo que fijes aquí no cambia aunque después se modifique el '
                  'catálogo (p. ej. para la temporada siguiente).',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'Las verificaciones validadas no cambian: guardan el '
                  'reglamento con el que se verificaron.',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: cs.outline),
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Buscar coche',
                    prefixIcon: Icon(Icons.search),
                    isDense: true,
                  ),
                  onChanged: (v) => setState(() => _busqueda = v),
                ),
              ],
            ),
          ),
          Expanded(
            child: _coches.isEmpty
                ? Center(
                    child: Text(
                      'No hay coches del catálogo con las copas de este '
                      'campeonato.',
                      style: TextStyle(color: cs.outline),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    itemCount: visibles.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final c = visibles[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(c.nombre,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  Text(
                                    'Catálogo: ${c.pesoMin.toStringAsFixed(2)} g'
                                    '${usaCreditos ? ' · ${c.creditosCoche >= 0 ? '+' : ''}${c.creditosCoche} créd' : ''}'
                                    '${c.activo ? '' : ' · inactivo'}',
                                    style: TextStyle(
                                        color: cs.outline, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: TextField(
                                controller: _peso[c.id],
                                decoration: InputDecoration(
                                  labelText: 'Peso mín. (g)',
                                  hintText: c.pesoMin.toStringAsFixed(2),
                                  isDense: true,
                                ),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                              ),
                            ),
                            if (usaCreditos) ...[
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 2,
                                child: TextField(
                                  controller: _creditos[c.id],
                                  decoration: InputDecoration(
                                    labelText: 'Créditos',
                                    hintText: '${c.creditosCoche}',
                                    isDense: true,
                                  ),
                                  keyboardType: const TextInputType
                                      .numberWithOptions(signed: true),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _guardando ? null : _guardar,
                  icon: _guardando
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.check),
                  label: const Text('Guardar'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
