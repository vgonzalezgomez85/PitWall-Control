import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import 'repositorio_creditos.dart';

/// Escalera de categorías, de menor a mayor "metal".
const _escalera = ['BRONCE', 'PLATA', 'ORO', 'PLATINO'];

/// Sube/baja [actual] un escalón dentro de [_escalera] (clamp en los extremos).
String _mover(String actual, int paso) {
  final i = _escalera.indexOf(actual);
  if (i < 0) return actual; // categoría fuera de la escalera estándar
  final j = (i + paso).clamp(0, _escalera.length - 1);
  return _escalera[j];
}

class _FilaRevision {
  final Piloto piloto;
  final PilotoCampeonatoData pc;
  final int carreras;
  _FilaRevision(this.piloto, this.pc, this.carreras);
  String get inicial => pc.categoria;
  String get efectiva => pc.categoriaFinal ?? pc.categoria;
}

/// Pilotos que han competido en el campeonato activo, con su categoría.
final _revisionProvider =
    StreamProvider.autoDispose<List<_FilaRevision>>((ref) {
  final db = ref.watch(dbProvider);
  final activo = ref.watch(campeonatoActivoProvider);
  if (activo == null) return Stream.value([]);
  return (db.select(db.pilotoCampeonato)
        ..where((t) => t.campeonatoId.equals(activo.id)))
      .watch()
      .asyncMap((pcs) async {
    // Pilotos que han corrido alguna prueba del campeonato (vía inscripción).
    final pruebas = await (db.select(db.pruebas)
          ..where((t) => t.campeonatoId.equals(activo.id)))
        .get();
    final participantes = <int>{};
    if (pruebas.isNotEmpty) {
      final inscripciones = await (db.select(db.inscripcionesPrueba)
            ..where((t) => t.pruebaId.isIn(pruebas.map((p) => p.id).toList())))
          .get();
      final equipoIds = inscripciones.map((i) => i.equipoId).toSet();
      if (equipoIds.isNotEmpty) {
        final equipos = await (db.select(db.equipos)
              ..where((t) => t.id.isIn(equipoIds.toList())))
            .get();
        for (final e in equipos) {
          participantes.add(e.piloto1Id);
          if (e.piloto2Id != null) participantes.add(e.piloto2Id!);
        }
      }
    }
    final carreras =
        await ref.read(repoCreditosProvider).carrerasPorPiloto(activo.id);
    final out = <_FilaRevision>[];
    for (final pc in pcs) {
      if (!participantes.contains(pc.pilotoId)) continue;
      final p = await (db.select(db.pilotos)
            ..where((t) => t.id.equals(pc.pilotoId)))
          .getSingleOrNull();
      if (p != null) {
        out.add(_FilaRevision(p, pc, carreras[pc.pilotoId] ?? 0));
      }
    }
    out.sort((a, b) =>
        a.piloto.nombre.toLowerCase().compareTo(b.piloto.nombre.toLowerCase()));
    return out;
  });
});

/// Revisión de categorías de cierre: por cada piloto se decide si promociona,
/// desciende o se mantiene. La categoría resultante se usa para la bonificación
/// de cierre y como categoría inicial al importar al siguiente campeonato.
class PantallaRevisionCategorias extends ConsumerStatefulWidget {
  const PantallaRevisionCategorias({super.key});

  @override
  ConsumerState<PantallaRevisionCategorias> createState() =>
      _PantallaRevisionCategoriasState();
}

class _PantallaRevisionCategoriasState
    extends ConsumerState<PantallaRevisionCategorias> {
  String _busqueda = '';

  Future<void> _guardar(_FilaRevision f, String nueva) async {
    final db = ref.read(dbProvider);
    await (db.update(db.pilotoCampeonato)
          ..where((t) =>
              t.pilotoId.equals(f.pc.pilotoId) &
              t.campeonatoId.equals(f.pc.campeonatoId)))
        .write(PilotoCampeonatoCompanion(
            categoriaFinal: drift.Value(nueva)));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final async = ref.watch(_revisionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Revisión de categorías (cierre)'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(72),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Buscar por nombre…',
              ),
              onChanged: (v) =>
                  setState(() => _busqueda = v.trim().toLowerCase()),
            ),
          ),
        ),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (todas) {
          final filas = _busqueda.isEmpty
              ? todas
              : todas
                  .where((f) =>
                      f.piloto.nombre.toLowerCase().contains(_busqueda))
                  .toList();
          if (filas.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  todas.isEmpty
                      ? 'No hay pilotos que hayan competido en este campeonato.'
                      : 'No hay coincidencias.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return Column(
            children: [
              Container(
                width: double.infinity,
                color: cs.surfaceContainer,
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.military_tech_outlined,
                        size: 18, color: cs.outline),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Ajusta la categoría de cada piloto antes de finalizar. '
                        'Se usará para la bonificación de cierre y como categoría '
                        'inicial del próximo campeonato.',
                        style: TextStyle(color: cs.outline, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: filas.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 6),
                  itemBuilder: (_, i) => _TarjetaRevision(
                    fila: filas[i],
                    onCambio: (nueva) => _guardar(filas[i], nueva),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TarjetaRevision extends StatelessWidget {
  const _TarjetaRevision({required this.fila, required this.onCambio});
  final _FilaRevision fila;
  final ValueChanged<String> onCambio;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final efectiva = fila.efectiva;
    final iIni = _escalera.indexOf(fila.inicial);
    final iEf = _escalera.indexOf(efectiva);

    String estado;
    Color estadoColor;
    IconData estadoIcon;
    if (iEf > iIni) {
      estado = 'Promociona';
      estadoColor = Colors.green.shade700;
      estadoIcon = Icons.arrow_upward;
    } else if (iEf < iIni) {
      estado = 'Desciende';
      estadoColor = Colors.red.shade700;
      estadoIcon = Icons.arrow_downward;
    } else {
      estado = 'Se mantiene';
      estadoColor = cs.outline;
      estadoIcon = Icons.drag_handle;
    }

    final enEscalera = iEf >= 0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(fila.piloto.nombre,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16)),
                      Text(
                        'Inicial: ${fila.inicial}  ·  ${fila.carreras} carreras',
                        style: TextStyle(color: cs.outline, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(efectiva,
                      style: TextStyle(
                          color: cs.onPrimaryContainer,
                          fontWeight: FontWeight.w800)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(estadoIcon, size: 16, color: estadoColor),
                const SizedBox(width: 4),
                Text(estado,
                    style: TextStyle(
                        color: estadoColor, fontWeight: FontWeight.w600)),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: (enEscalera && iEf > 0)
                      ? () => onCambio(_mover(efectiva, -1))
                      : null,
                  icon: const Icon(Icons.arrow_downward, size: 16),
                  label: const Text('Bajar'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: efectiva == fila.inicial
                      ? null
                      : () => onCambio(fila.inicial),
                  child: const Text('Mantener'),
                ),
                const SizedBox(width: 8),
                FilledButton.tonalIcon(
                  onPressed: (enEscalera && iEf < _escalera.length - 1)
                      ? () => onCambio(_mover(efectiva, 1))
                      : null,
                  icon: const Icon(Icons.arrow_upward, size: 16),
                  label: const Text('Subir'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
