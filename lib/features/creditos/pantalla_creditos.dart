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
import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import '../../services/exportar_pdf.dart';
import '../../services/generador_pdf_creditos.dart';
import 'pantalla_revision_categorias.dart';
import 'repositorio_creditos.dart';

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

class PantallaCreditos extends ConsumerStatefulWidget {
  const PantallaCreditos({super.key});

  @override
  ConsumerState<PantallaCreditos> createState() => _PantallaCreditosState();
}

class _PantallaCreditosState extends ConsumerState<PantallaCreditos> {
  String _busqueda = '';

  @override
  Widget build(BuildContext context) {
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
            tooltip: 'Revisión de categorías (cierre)',
            icon: const Icon(Icons.military_tech_outlined),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const PantallaRevisionCategorias(),
            )),
          ),
          if (activo.finalizado)
            IconButton(
              tooltip: 'Aplicar bonificación de cierre',
              icon: const Icon(Icons.workspace_premium_outlined),
              onPressed: () => _aplicarBonificacionCierre(context, ref, activo),
            ),
          IconButton(
            tooltip: 'Exportar CSV',
            icon: const Icon(Icons.table_view_outlined),
            onPressed: () => _exportarCsv(context, ref, activo),
          ),
          IconButton(
            tooltip: 'Exportar PDF',
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final idi = await elegirIdiomaExport(context, ref);
              if (idi == null) return;
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
                final bytes = await ref
                    .read(generadorPdfCreditosProvider)
                    .generar(idioma: idi);
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
      body: pilotosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (todos) {
          final pilotos = _busqueda.isEmpty
              ? todos
              : todos
                  .where((p) =>
                      p.piloto.nombre.toLowerCase().contains(_busqueda))
                  .toList();
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
                    Text(
                      todos.isEmpty
                          ? 'Aún no hay pilotos inscritos en este campeonato.'
                          : 'No hay coincidencias.',
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

/// Aplica la bonificación de cierre a todos los pilotos del campeonato
/// finalizado, previa confirmación.
Future<void> _aplicarBonificacionCierre(
    BuildContext context, WidgetRef ref, Campeonato activo) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Bonificación de cierre'),
      content: Text(
        'Se regularizará el saldo de cada piloto que haya competido:\n\n'
        'saldo = mín(saldo actual + bonificación según categoría y nº de '
        'carreras, ${activo.topeRegularizacion}).\n\n'
        'Solo se aplica a quien aún no la tenga. ¿Continuar?',
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar')),
        FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Aplicar')),
      ],
    ),
  );
  if (ok != true || !context.mounted) return;
  final messenger = ScaffoldMessenger.of(context);
  try {
    final n = await ref
        .read(repoCreditosProvider)
        .aplicarBonificacionCierre(activo.id);
    messenger.showSnackBar(
        SnackBar(content: Text('Bonificación aplicada a $n pilotos.')));
  } catch (e) {
    messenger.showSnackBar(SnackBar(content: Text('Error: $e')));
  }
}

/// Exporta el estado de créditos del campeonato a un CSV.
Future<void> _exportarCsv(
    BuildContext context, WidgetRef ref, Campeonato activo) async {
  final messenger = ScaffoldMessenger.of(context);
  try {
    final destino = await getSaveLocation(
      acceptedTypeGroups: [
        XTypeGroup(label: 'CSV', extensions: ['csv']),
      ],
      suggestedName: 'creditos-${activo.nombre.replaceAll(' ', '_')}.csv',
    );
    if (destino == null) return;
    final csv = await ref.read(repoCreditosProvider).exportarCsv(activo.id);
    var ruta = destino.path;
    if (!ruta.toLowerCase().endsWith('.csv')) ruta = '$ruta.csv';
    // BOM para que Excel reconozca UTF-8.
    await File(ruta).writeAsString('﻿$csv');
    messenger.showSnackBar(
        SnackBar(content: Text('CSV guardado en $ruta')));
  } catch (e) {
    messenger.showSnackBar(SnackBar(content: Text('Error: $e')));
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

/// Ajuste manual de créditos: permite fijar el saldo (y los créditos
/// iniciales) de un piloto, p. ej. para quitar créditos que vinieron de una
/// verificación. El cambio del saldo se registra como movimiento "Ajuste
/// manual" para que el historial siga cuadrando.
Future<void> _ajustarCreditos(
    BuildContext context, WidgetRef ref, _ResumenPiloto r) async {
  final iniCtrl = TextEditingController(text: '${r.inicial}');
  final actCtrl = TextEditingController(text: '${r.actual}');
  final fmt = [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
  ];
  final ok = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('Ajustar créditos · ${r.piloto.nombre}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: iniCtrl,
            decoration: const InputDecoration(labelText: 'Créditos iniciales'),
            keyboardType: TextInputType.number,
            inputFormatters: fmt,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: actCtrl,
            decoration: const InputDecoration(labelText: 'Créditos actuales (saldo)'),
            keyboardType: TextInputType.number,
            inputFormatters: fmt,
          ),
          const SizedBox(height: 8),
          const Text(
            'El cambio del saldo se anota como "Ajuste manual" en el historial.',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar')),
        FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Guardar')),
      ],
    ),
  );
  if (ok != true) return;
  final newIni = int.tryParse(iniCtrl.text.trim()) ?? r.inicial;
  final newAct = int.tryParse(actCtrl.text.trim()) ?? r.actual;
  final db = ref.read(dbProvider);
  final pid = r.piloto.id;
  final campId = r.pc.campeonatoId;

  if (newIni != r.inicial) {
    await (db.update(db.pilotoCampeonato)
          ..where((t) =>
              t.pilotoId.equals(pid) & t.campeonatoId.equals(campId)))
        .write(PilotoCampeonatoCompanion(
            creditosIniciales: drift.Value(newIni)));
  }
  final delta = newAct - r.actual;
  if (delta != 0) {
    await (db.update(db.pilotoCampeonato)
          ..where((t) =>
              t.pilotoId.equals(pid) & t.campeonatoId.equals(campId)))
        .write(PilotoCampeonatoCompanion(
            creditosActuales: drift.Value(newAct)));
    await db.into(db.movimientosCreditos).insert(
          MovimientosCreditosCompanion.insert(
            pilotoId: pid,
            campeonatoId: campId,
            delta: delta,
            saldoResultante: newAct,
            motivo: 'Ajuste manual',
          ),
        );
  }
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Créditos ajustados')),
    );
    Navigator.of(context).pop();
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
      appBar: AppBar(
        title: Text(resumen.piloto.nombre),
        actions: [
          IconButton(
            tooltip: 'Ajustar créditos a mano',
            icon: const Icon(Icons.tune),
            onPressed: () => _ajustarCreditos(context, ref, resumen),
          ),
        ],
      ),
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
