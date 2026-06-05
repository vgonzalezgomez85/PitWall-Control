import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import '../../services/generador_pdf_creditos.dart';

/// Pilotos del campeonato activo con saldo de créditos.
class _ResumenPiloto {
  final Piloto piloto;
  final PilotoCampeonatoData pc;
  _ResumenPiloto(this.piloto, this.pc);
  int get inicial => pc.creditosIniciales;
  int get actual => pc.creditosActuales;
  int get usados => inicial - actual;
}

/// Solo pilotos que han participado al menos en una prueba del campeonato
/// (vía inscripción de su equipo). Para el listado general ya está la
/// pantalla de Pilotos.
final _pilotosCampeonatoProvider =
    StreamProvider.autoDispose<List<_ResumenPiloto>>((ref) {
  final db = ref.watch(dbProvider);
  final activo = ref.watch(campeonatoActivoProvider);
  if (activo == null) return Stream.value([]);
  return (db.select(db.pilotoCampeonato)
        ..where((t) => t.campeonatoId.equals(activo.id)))
      .watch()
      .asyncMap((pcs) async {
    // IDs de pilotos que han corrido alguna prueba del campeonato.
    final pruebas = await (db.select(db.pruebas)
          ..where((t) => t.campeonatoId.equals(activo.id)))
        .get();
    final participantes = <int>{};
    if (pruebas.isNotEmpty) {
      final pruebaIds = pruebas.map((p) => p.id).toList();
      final inscripciones = await (db.select(db.inscripcionesPrueba)
            ..where((t) => t.pruebaId.isIn(pruebaIds)))
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
    final out = <_ResumenPiloto>[];
    for (final pc in pcs) {
      if (!participantes.contains(pc.pilotoId)) continue;
      final p = await (db.select(db.pilotos)
            ..where((t) => t.id.equals(pc.pilotoId)))
          .getSingleOrNull();
      if (p != null) out.add(_ResumenPiloto(p, pc));
    }
    out.sort((a, b) => a.piloto.nombre.compareTo(b.piloto.nombre));
    return out;
  });
});

/// Movimientos de créditos para un piloto en el campeonato activo.
final _movimientosPilotoProvider = StreamProvider.autoDispose
    .family<List<MovimientosCredito>, int>((ref, pilotoId) {
  final db = ref.watch(dbProvider);
  final activo = ref.watch(campeonatoActivoProvider);
  if (activo == null) return Stream.value([]);
  return (db.select(db.movimientosCreditos)
        ..where((t) =>
            t.pilotoId.equals(pilotoId) &
            t.campeonatoId.equals(activo.id))
        ..orderBy([(t) => drift.OrderingTerm.asc(t.fecha)]))
      .watch();
});

class PantallaCreditos extends ConsumerWidget {
  const PantallaCreditos({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final activo = ref.watch(campeonatoActivoProvider);
    final pilotosAsync = ref.watch(_pilotosCampeonatoProvider);

    if (activo == null) {
      return const Scaffold(
        body: Center(child: Text('No hay campeonato activo')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Créditos'),
        actions: [
          IconButton(
            tooltip: 'Exportar PDF',
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              try {
                final destino = await getSaveLocation(
                  acceptedTypeGroups: [
                    XTypeGroup(label: 'PDF', extensions: ['pdf']),
                  ],
                  suggestedName:
                      'creditos-${activo.nombre.replaceAll(' ', '_')}.pdf',
                );
                if (destino == null) return;
                messenger.showSnackBar(const SnackBar(
                    content: Text('Generando PDF…'),
                    duration: Duration(seconds: 2)));
                final bytes =
                    await ref.read(generadorPdfCreditosProvider).generar();
                var ruta = destino.path;
                if (!ruta.toLowerCase().endsWith('.pdf')) ruta = '$ruta.pdf';
                await File(ruta).writeAsBytes(bytes);
                messenger.showSnackBar(SnackBar(
                    content: Text('PDF guardado en $ruta'),
                    duration: const Duration(seconds: 3)));
              } catch (e) {
                messenger.showSnackBar(
                    SnackBar(content: Text('Error al generar PDF: $e')));
              }
            },
          ),
        ],
      ),
      body: pilotosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (pilotos) {
          if (pilotos.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.savings_outlined,
                        size: 96, color: cs.outline),
                    const SizedBox(height: 16),
                    const Text(
                      'Aún no hay pilotos inscritos en este campeonato.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: pilotos.length,
            separatorBuilder: (_, _) => const SizedBox(height: 6),
            itemBuilder: (_, i) => _TarjetaPiloto(resumen: pilotos[i]),
          );
        },
      ),
    );
  }
}

class _TarjetaPiloto extends StatelessWidget {
  const _TarjetaPiloto({required this.resumen});
  final _ResumenPiloto resumen;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final r = resumen;
    final crit = r.actual < 0 || (r.inicial > 0 && r.actual < r.inicial * 0.2);
    final color = crit ? Colors.red.shade700 : cs.primary;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => _PantallaHistorialPiloto(resumen: r),
        )),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withValues(alpha: 0.15),
                child: Icon(Icons.person_outline, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.piloto.nombre,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16)),
                    const SizedBox(height: 2),
                    Text(
                      'Inicial ${r.inicial}  ·  Usados ${r.usados}',
                      style: TextStyle(color: cs.outline, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${r.actual}',
                    style: TextStyle(
                        color: color,
                        fontSize: 24,
                        fontWeight: FontWeight.w800),
                  ),
                  Text('créditos',
                      style: TextStyle(color: cs.outline, fontSize: 11)),
                ],
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _PantallaHistorialPiloto extends ConsumerWidget {
  const _PantallaHistorialPiloto({required this.resumen});
  final _ResumenPiloto resumen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final df = DateFormat('dd/MM/yyyy HH:mm');
    final movsAsync = ref.watch(_movimientosPilotoProvider(resumen.piloto.id));
    final pruebasAsync = ref.watch(_pruebasMapProvider);

    return Scaffold(
      appBar: AppBar(title: Text(resumen.piloto.nombre)),
      body: movsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (movs) {
          final pruebasMap = pruebasAsync.asData?.value ?? const {};
          final sumaMovs = movs.fold<int>(0, (s, m) => s + m.delta);
          final esperado = resumen.inicial + sumaMovs;
          final huecoCreditos = resumen.actual - esperado;
          final sumaSigno = sumaMovs >= 0 ? '+ $sumaMovs' : '− ${-sumaMovs}';
          final huecoSigno = '';
          return ListView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
            children: [
              Card(
                color: cs.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _Stat(
                          etiqueta: 'Inicial',
                          valor: resumen.inicial,
                          color: cs.onPrimaryContainer),
                      const SizedBox(width: 16),
                      _Stat(
                          etiqueta: 'Usados',
                          valor: resumen.usados,
                          color: cs.onPrimaryContainer),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('SALDO',
                              style: TextStyle(
                                  color: cs.onPrimaryContainer,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600)),
                          Text('${resumen.actual}',
                              style: TextStyle(
                                  color: cs.onPrimaryContainer,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text('Movimientos',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              _FilaTimeline(
                fecha: null,
                etiqueta: 'Créditos iniciales',
                detalle: 'Inscripción al campeonato',
                delta: resumen.inicial,
                saldo: resumen.inicial,
                inicial: true,
              ),
              if (huecoCreditos != 0)
                Card(
                  color: Colors.orange.shade50,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.orange.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.warning_amber_outlined,
                        color: Colors.orange.shade800),
                    title: Text(
                      '${huecoCreditos.abs()} créd. sin justificar',
                      style: TextStyle(
                          color: Colors.orange.shade900,
                          fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      'El saldo actual ($huecoSigno${resumen.actual}) no cuadra con '
                      'inicial ${resumen.inicial} $sumaSigno movimientos. '
                      'Probablemente venía así al importar o se editó a mano antes '
                      'de activar el log.',
                      style: TextStyle(
                          color: Colors.orange.shade900, fontSize: 12),
                    ),
                  ),
                ),
              if (movs.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Sin movimientos todavía.',
                      style: TextStyle(color: cs.outline)),
                ),
              ...movs.map((m) {
                final p = m.pruebaId == null ? null : pruebasMap[m.pruebaId!];
                return _FilaTimeline(
                  fecha: df.format(m.fecha),
                  etiqueta: p?.nombre ?? 'Movimiento',
                  detalle: m.motivo,
                  delta: m.delta,
                  saldo: m.saldoResultante,
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.etiqueta,
    required this.valor,
    required this.color,
  });
  final String etiqueta;
  final int valor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(etiqueta,
            style: TextStyle(
                color: color, fontSize: 11, fontWeight: FontWeight.w600)),
        Text('$valor',
            style: TextStyle(
                color: color, fontSize: 22, fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class _FilaTimeline extends StatelessWidget {
  const _FilaTimeline({
    required this.fecha,
    required this.etiqueta,
    required this.detalle,
    required this.delta,
    required this.saldo,
    this.inicial = false,
  });
  final String? fecha;
  final String etiqueta;
  final String detalle;
  final int delta;
  final int saldo;
  final bool inicial;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final positivo = delta >= 0;
    final color = inicial
        ? cs.primary
        : (positivo ? Colors.green.shade700 : Colors.red.shade700);
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(
            inicial
                ? Icons.flag_outlined
                : (positivo ? Icons.arrow_downward : Icons.arrow_upward),
            color: color,
          ),
        ),
        title: Text(etiqueta,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          fecha == null ? detalle : '$detalle  ·  $fecha',
          style: TextStyle(color: cs.outline, fontSize: 12),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${positivo ? '+' : '−'}${delta.abs()}',
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 18),
            ),
            Text('saldo $saldo',
                style: TextStyle(color: cs.outline, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

/// Mapa pruebaId → Prueba para mostrar nombres en el historial.
final _pruebasMapProvider =
    StreamProvider.autoDispose<Map<int, Prueba>>((ref) {
  final db = ref.watch(dbProvider);
  final activo = ref.watch(campeonatoActivoProvider);
  if (activo == null) return Stream.value({});
  return (db.select(db.pruebas)
        ..where((t) => t.campeonatoId.equals(activo.id)))
      .watch()
      .map((lst) => {for (final p in lst) p.id: p});
});
