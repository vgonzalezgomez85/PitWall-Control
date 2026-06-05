import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import 'repositorio_resultados.dart';

class PantallaResultadosManga extends ConsumerWidget {
  const PantallaResultadosManga({super.key, required this.mangaId});

  final int mangaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lista = ref.watch(resultadosMangaProvider(mangaId));
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Resultados de la manga')),
      body: lista.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (filas) {
          if (filas.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.event_busy_outlined,
                        size: 96, color: cs.outline),
                    const SizedBox(height: 16),
                    Text('No hay equipos en esta manga',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    const Text(
                      'Inscribe equipos para poder registrar sus resultados.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final puestas = filas.where((f) => f.posicion != null).length;

          return ListView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
            children: [
              Card(
                color: cs.surfaceContainer,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.emoji_events_outlined, color: cs.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Indica la posición final de cada equipo. '
                          'Los puntos se calculan solos según la tabla del campeonato.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('$puestas / ${filas.length}',
                          style: TextStyle(
                              color: cs.primary,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ...filas.map((f) => _FilaResultado(
                    mangaId: mangaId,
                    fila: f,
                    totalEquipos: filas.length,
                  )),
            ],
          );
        },
      ),
    );
  }
}

class _FilaResultado extends ConsumerStatefulWidget {
  const _FilaResultado({
    required this.mangaId,
    required this.fila,
    required this.totalEquipos,
  });

  final int mangaId;
  final ResultadoEquipo fila;
  final int totalEquipos;

  @override
  ConsumerState<_FilaResultado> createState() => _FilaResultadoState();
}

class _FilaResultadoState extends ConsumerState<_FilaResultado> {
  late TextEditingController _aRestar;

  @override
  void initState() {
    super.initState();
    _aRestar = TextEditingController(
      text: widget.fila.aRestar?.toString() ?? '0',
    );
  }

  @override
  void didUpdateWidget(covariant _FilaResultado old) {
    super.didUpdateWidget(old);
    final nuevo = widget.fila.aRestar?.toString() ?? '0';
    if (_aRestar.text != nuevo) _aRestar.text = nuevo;
  }

  @override
  void dispose() {
    _aRestar.dispose();
    super.dispose();
  }

  Future<void> _setPosicion(int? pos) async {
    final activo = ref.read(campeonatoActivoProvider)!;
    final repo = ref.read(repoResultadosProvider);
    if (pos == null) {
      await repo.borrarResultadoEquipo(
        mangaId: widget.mangaId,
        equipoId: widget.fila.equipoId,
      );
    } else {
      await repo.asignarPosicionEquipo(
        mangaId: widget.mangaId,
        equipoId: widget.fila.equipoId,
        campeonatoId: activo.id,
        posicion: pos,
        aRestar: int.tryParse(_aRestar.text) ?? 0,
      );
    }
  }

  Future<void> _setARestar() async {
    if (widget.fila.posicion == null) return;
    final activo = ref.read(campeonatoActivoProvider)!;
    await ref.read(repoResultadosProvider).asignarPosicionEquipo(
          mangaId: widget.mangaId,
          equipoId: widget.fila.equipoId,
          campeonatoId: activo.id,
          posicion: widget.fila.posicion!,
          aRestar: int.tryParse(_aRestar.text) ?? 0,
        );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fila = widget.fila;
    final tienePos = fila.posicion != null;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: tienePos
                        ? cs.primaryContainer
                        : cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(fila.carril ?? '—',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: tienePos
                            ? cs.onPrimaryContainer
                            : cs.outline,
                      )),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(fila.nombreEquipo,
                          style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        fila.piloto2 == null
                            ? fila.piloto1.nombre
                            : '${fila.piloto1.nombre} + ${fila.piloto2!.nombre}',
                        style: TextStyle(color: cs.outline, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 80,
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: tienePos
                        ? Colors.green.shade50
                        : cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        tienePos ? '${fila.puntos ?? 0}' : '—',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: tienePos
                              ? Colors.green.shade700
                              : cs.outline,
                        ),
                      ),
                      Text('puntos',
                          style: TextStyle(
                              fontSize: 11, color: cs.outline)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int?>(
                    initialValue: fila.posicion,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Posición',
                      isDense: true,
                    ),
                    items: [
                      const DropdownMenuItem(
                          value: null, child: Text('Sin asignar')),
                      for (var i = 1;
                          i <= widget.totalEquipos.clamp(1, 64);
                          i++)
                        DropdownMenuItem(value: i, child: Text('$iº')),
                    ],
                    onChanged: _setPosicion,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 110,
                  child: TextField(
                    controller: _aRestar,
                    decoration: const InputDecoration(
                      labelText: 'A restar',
                      isDense: true,
                      helperText: 'créditos',
                    ),
                    keyboardType: TextInputType.number,
                    onEditingComplete: _setARestar,
                    onTapOutside: (_) => _setARestar(),
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
