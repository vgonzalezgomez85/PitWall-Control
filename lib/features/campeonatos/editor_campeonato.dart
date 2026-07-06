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
import 'dart:convert';

import 'package:drift/drift.dart' show Value, OrderingTerm;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import '../../data/database/seeds.dart';
import '../creditos/repositorio_creditos.dart';

/// Provider con todas las copas del catálogo global (para sugerirlas).
final _catalogoCopasProvider = FutureProvider<List<String>>((ref) async {
  final db = ref.watch(dbProvider);
  final lista = await db.select(db.catalogoCopas).get();
  return lista.map((c) => c.nombre).toList()..sort();
});

/// Campeonatos finalizados, candidatos para importar sus pilotos y saldos.
final _campeonatosFinalizadosProvider =
    FutureProvider<List<Campeonato>>((ref) async {
  final db = ref.watch(dbProvider);
  return (db.select(db.campeonatos)
        ..where((t) => t.finalizado.equals(true))
        ..orderBy([(t) => OrderingTerm.desc(t.anio)]))
      .get();
});

class EditorCampeonato extends ConsumerStatefulWidget {
  const EditorCampeonato({super.key, this.campeonatoId});
  final int? campeonatoId;

  @override
  ConsumerState<EditorCampeonato> createState() => _EditorCampeonatoState();
}

class _EditorCampeonatoState extends ConsumerState<EditorCampeonato> {
  final _formKey = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _anio = TextEditingController(text: DateTime.now().year.toString());
  final _descartes = TextEditingController(text: '1');
  final _tope = TextEditingController(text: '28');
  final _nuevaCopa = TextEditingController();
  final _cuotaPagat = TextEditingController(text: '25');
  final _cuotaCoord = TextEditingController(text: '11');
  final _cuotaClub = TextEditingController(text: '14');
  final _motorMin = TextEditingController();
  final _motorMax = TextEditingController();
  final _pinonMin = TextEditingController(text: '12');
  final _pinonMax = TextEditingController(text: '12');
  final _coronaMin = TextEditingController(text: '24');
  final _coronaMax = TextEditingController(text: '30');
  bool _pinonFijo = true;
  bool _coronaFijo = false;
  final _marcaTitulo = TextEditingController();
  final _marcaLema = TextEditingController();

  String _formato = 'PAREJAS';
  bool _activo = true;
  bool _usaCreditos = true;
  bool _usaTesoreria = true;
  bool _finalizado = false;
  bool _finalizadoOriginal = false;
  int? _importarDesdeId;
  Set<String> _copasSel = {};
  bool _cargando = true;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    if (widget.campeonatoId == null) {
      _copasSel = {'GT', 'GT2', 'SLOT.IT'};
      setState(() => _cargando = false);
      return;
    }
    final db = ref.read(dbProvider);
    final c = await (db.select(db.campeonatos)
          ..where((t) => t.id.equals(widget.campeonatoId!)))
        .getSingle();
    _nombre.text = c.nombre;
    _anio.text = c.anio.toString();
    _descartes.text = c.numDescartes.toString();
    _tope.text = c.topeRegularizacion.toString();
    _cuotaPagat.text = c.cuotaPagat.toStringAsFixed(c.cuotaPagat % 1 == 0 ? 0 : 2);
    _cuotaCoord.text =
        c.cuotaCoordinadora.toStringAsFixed(c.cuotaCoordinadora % 1 == 0 ? 0 : 2);
    _cuotaClub.text =
        c.cuotaClub.toStringAsFixed(c.cuotaClub % 1 == 0 ? 0 : 2);
    _motorMin.text = c.motorSorteoMin?.toString() ?? '';
    _motorMax.text = c.motorSorteoMax?.toString() ?? '';
    _pinonMin.text = c.pinonDientesMin.toString();
    _pinonMax.text = c.pinonDientesMax.toString();
    _coronaMin.text = c.coronaDientesMin.toString();
    _coronaMax.text = c.coronaDientesMax.toString();
    _pinonFijo = c.pinonDientesMin == c.pinonDientesMax;
    _coronaFijo = c.coronaDientesMin == c.coronaDientesMax;
    _marcaTitulo.text = c.marcaTitulo ?? '';
    _marcaLema.text = c.marcaLema ?? '';
    _formato = c.formato;
    _activo = c.activo;
    _usaCreditos = c.usaCreditos;
    _usaTesoreria = c.usaTesoreria;
    _finalizado = c.finalizado;
    _finalizadoOriginal = c.finalizado;
    try {
      final raw = json.decode(c.copasJson);
      if (raw is List) {
        _copasSel = raw.map((e) => e.toString()).toSet();
      }
    } catch (_) {}
    if (mounted) setState(() => _cargando = false);
  }

  @override
  void dispose() {
    _nombre.dispose();
    _anio.dispose();
    _descartes.dispose();
    _tope.dispose();
    _nuevaCopa.dispose();
    _cuotaPagat.dispose();
    _cuotaCoord.dispose();
    _cuotaClub.dispose();
    _motorMin.dispose();
    _motorMax.dispose();
    _pinonMin.dispose();
    _pinonMax.dispose();
    _coronaMin.dispose();
    _coronaMax.dispose();
    _marcaTitulo.dispose();
    _marcaLema.dispose();
    super.dispose();
  }

  /// Selector para importar pilotos (y su saldo de cierre) de un campeonato
  /// finalizado al crear este. Solo aparece si hay campeonatos finalizados.
  Widget _selectorImportarPilotos() {
    final finalizadosAsync = ref.watch(_campeonatosFinalizadosProvider);
    return finalizadosAsync.maybeWhen(
      data: (finalizados) {
        if (finalizados.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 4),
          child: DropdownButtonFormField<int?>(
            initialValue: _importarDesdeId,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Importar pilotos de un campeonato finalizado',
              helperText:
                  'Trae sus pilotos con el saldo de cierre como créditos iniciales.',
              prefixIcon: Icon(Icons.download_outlined),
            ),
            items: [
              const DropdownMenuItem<int?>(
                value: null,
                child: Text('No importar'),
              ),
              for (final c in finalizados)
                DropdownMenuItem<int?>(
                  value: c.id,
                  child: Text('${c.nombre} (${c.anio})'),
                ),
            ],
            onChanged: (v) => setState(() => _importarDesdeId = v),
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  Future<void> _anadirCopaNueva() async {
    final t = _nuevaCopa.text.trim();
    if (t.isEmpty) return;
    final db = ref.read(dbProvider);
    final existe = await (db.select(db.catalogoCopas)
          ..where((c) => c.nombre.equals(t)))
        .getSingleOrNull();
    if (existe == null) {
      await db.into(db.catalogoCopas)
          .insert(CatalogoCopasCompanion.insert(nombre: t));
    }
    setState(() {
      _copasSel.add(t);
      _nuevaCopa.clear();
    });
    ref.invalidate(_catalogoCopasProvider);
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_copasSel.isEmpty) {
      _aviso('Selecciona al menos una copa / categoría.');
      return;
    }
    setState(() => _guardando = true);
    final db = ref.read(dbProvider);
    try {
      final copasJson = json.encode(_copasSel.toList());
      double parseD(TextEditingController c, double def) {
        return double.tryParse(c.text.trim().replaceAll(',', '.')) ?? def;
      }
      final cuotaP = parseD(_cuotaPagat, 25);
      final cuotaC = parseD(_cuotaCoord, 11);
      final cuotaCl = parseD(_cuotaClub, 14);
      final motorMin = int.tryParse(_motorMin.text.trim());
      final motorMax = int.tryParse(_motorMax.text.trim());
      // Piñón/corona: si es "tamaño fijo", máx = mín.
      final pinMin = int.tryParse(_pinonMin.text.trim()) ?? 12;
      final pinMax = _pinonFijo ? pinMin : (int.tryParse(_pinonMax.text.trim()) ?? pinMin);
      final corMin = int.tryParse(_coronaMin.text.trim()) ?? 24;
      final corMax = _coronaFijo ? corMin : (int.tryParse(_coronaMax.text.trim()) ?? corMin);
      // Marca propia del campeonato en los PDF (vacío = valor por defecto).
      final mTitulo = _marcaTitulo.text.trim();
      final mLema = _marcaLema.text.trim();

      if (widget.campeonatoId == null) {
        final id = await Seeds.crearCampeonato(
          db,
          nombre: _nombre.text.trim(),
          formato: _formato,
          anio: int.parse(_anio.text.trim()),
        );
        await (db.update(db.campeonatos)..where((t) => t.id.equals(id))).write(
          CampeonatosCompanion(
            numDescartes: Value(int.parse(_descartes.text.trim())),
            topeRegularizacion: Value(int.parse(_tope.text.trim())),
            usaCreditos: Value(_usaCreditos),
            usaTesoreria: Value(_usaTesoreria),
            finalizado: Value(_finalizado),
            copasJson: Value(copasJson),
            cuotaPagat: Value(cuotaP),
            cuotaCoordinadora: Value(cuotaC),
            cuotaClub: Value(cuotaCl),
            motorSorteoMin: Value(motorMin),
            motorSorteoMax: Value(motorMax),
            pinonDientesMin: Value(pinMin),
            pinonDientesMax: Value(pinMax),
            coronaDientesMin: Value(corMin),
            coronaDientesMax: Value(corMax),
            marcaTitulo: Value(mTitulo.isEmpty ? null : mTitulo),
            marcaLema: Value(mLema.isEmpty ? null : mLema),
          ),
        );
        if (_usaCreditos && _importarDesdeId != null) {
          await ref.read(repoCreditosProvider).importarDesdeCampeonato(
                origenId: _importarDesdeId!,
                destinoId: id,
              );
        }
        if (_activo) {
          final c = await (db.select(db.campeonatos)
                ..where((t) => t.id.equals(id)))
              .getSingle();
          ref.read(campeonatoActivoProvider.notifier).seleccionar(c);
        }
      } else {
        await (db.update(db.campeonatos)
              ..where((t) => t.id.equals(widget.campeonatoId!)))
            .write(CampeonatosCompanion(
          nombre: Value(_nombre.text.trim()),
          formato: Value(_formato),
          anio: Value(int.parse(_anio.text.trim())),
          numDescartes: Value(int.parse(_descartes.text.trim())),
          topeRegularizacion: Value(int.parse(_tope.text.trim())),
          activo: Value(_activo),
          usaCreditos: Value(_usaCreditos),
          usaTesoreria: Value(_usaTesoreria),
          finalizado: Value(_finalizado),
          copasJson: Value(copasJson),
          cuotaPagat: Value(cuotaP),
          cuotaCoordinadora: Value(cuotaC),
          cuotaClub: Value(cuotaCl),
          motorSorteoMin: Value(motorMin),
          motorSorteoMax: Value(motorMax),
          pinonDientesMin: Value(pinMin),
          pinonDientesMax: Value(pinMax),
          coronaDientesMin: Value(corMin),
          coronaDientesMax: Value(corMax),
          marcaTitulo: Value(mTitulo.isEmpty ? null : mTitulo),
          marcaLema: Value(mLema.isEmpty ? null : mLema),
        ));
        // Acaba de marcarse como finalizado: ofrecer la bonificación de cierre.
        if (_usaCreditos && _finalizado && !_finalizadoOriginal && mounted) {
          await _ofrecerBonificacionCierre(widget.campeonatoId!);
        }
        // Si es el campeonato activo, refrescar la copia en memoria para que
        // los cambios (rangos de dientes, etc.) se reflejen al instante.
        if (ref.read(campeonatoActivoProvider)?.id == widget.campeonatoId) {
          final fresh = await (db.select(db.campeonatos)
                ..where((t) => t.id.equals(widget.campeonatoId!)))
              .getSingleOrNull();
          if (fresh != null) {
            ref.read(campeonatoActivoProvider.notifier).seleccionar(fresh);
          }
        }
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        _aviso('No se pudo guardar: $e');
        setState(() => _guardando = false);
      }
    }
  }

  void _aviso(String m) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  /// Al marcar finalizado un campeonato con créditos, ofrece aplicar ya la
  /// bonificación de cierre (cada piloto recibe un movimiento que indica la
  /// bonificación por su nº de carreras y categoría).
  Future<void> _ofrecerBonificacionCierre(int campeonatoId) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Bonificación de cierre'),
        content: Text(
          'Has marcado el campeonato como finalizado.\n\n'
          'Se regularizará el saldo de cada piloto que haya competido: '
          'saldo = mín(saldo actual + bonificación según categoría y nº de '
          'carreras, ${_tope.text.trim()}). Cada ajuste queda registrado como '
          'movimiento indicando la bonificación aplicada.\n\n'
          'Importante: la bonificación usa la categoría de cierre (revísala '
          'antes en Créditos → Revisión de categorías si hay promociones o '
          'descensos).\n\n'
          '¿Aplicarla ahora?',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Ahora no')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Aplicar')),
        ],
      ),
    );
    if (ok != true) return;
    final n = await ref
        .read(repoCreditosProvider)
        .aplicarBonificacionCierre(campeonatoId);
    if (mounted) {
      _aviso('Bonificación de cierre aplicada a $n pilotos.');
    }
  }

  Future<void> _borrar() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar campeonato'),
        content: Text(
            '¿Eliminar "${_nombre.text}"?\n\n'
            'Se borrarán también sus pruebas, mangas, inscripciones, '
            'resultados, verificaciones y pagos. No se puede deshacer.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Eliminar')),
        ],
      ),
    );
    if (ok != true) return;
    final db = ref.read(dbProvider);
    await (db.delete(db.campeonatos)
          ..where((t) => t.id.equals(widget.campeonatoId!)))
        .go();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final esNuevo = widget.campeonatoId == null;
    final cs = Theme.of(context).colorScheme;
    final catalogoAsync = ref.watch(_catalogoCopasProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(esNuevo ? 'Nuevo campeonato' : 'Editar campeonato'),
        actions: [
          if (!esNuevo)
            IconButton(
              tooltip: 'Eliminar',
              icon: const Icon(Icons.delete_outline),
              onPressed: _borrar,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _nombre,
              decoration: const InputDecoration(
                labelText: 'Nombre del campeonato *',
                helperText: 'Ej: Liga 2026, Individual LMP-HYP-GT3 Otoño',
                prefixIcon: Icon(Icons.emoji_events_outlined),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Indica un nombre' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _formato,
              decoration: const InputDecoration(
                labelText: 'Formato',
                prefixIcon: Icon(Icons.groups_outlined),
                helperText:
                    'Parejas = 2 pilotos por equipo. Individual = 1 piloto',
              ),
              items: const [
                DropdownMenuItem(value: 'PAREJAS', child: Text('Parejas')),
                DropdownMenuItem(value: 'INDIVIDUAL', child: Text('Individual')),
                DropdownMenuItem(value: '24H', child: Text('24h')),
                DropdownMenuItem(value: '12H', child: Text('12h')),
              ],
              onChanged: (v) => setState(() => _formato = v ?? 'PAREJAS'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _anio,
              decoration: const InputDecoration(
                labelText: 'Año',
                prefixIcon: Icon(Icons.calendar_today_outlined),
              ),
              keyboardType: TextInputType.number,
              validator: (v) {
                final n = int.tryParse(v ?? '');
                if (n == null || n < 2000 || n > 2100) return 'Año inválido';
                return null;
              },
            ),

            const SizedBox(height: 28),
            Text('Categorías / copas',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w700,
                    )),
            const SizedBox(height: 4),
            Text(
              'Selecciona las que se usan en este campeonato. Pueden ser una sola '
              '(p.ej. "Grupo C") o varias (p.ej. "LMP + HYP + GT3").',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            catalogoAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
              data: (copas) {
                // Asegurar que las copas ya seleccionadas (aunque no estén
                // en el catálogo) aparezcan también
                final todas = {...copas, ..._copasSel}.toList()..sort();
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: todas
                      .map((c) => FilterChip(
                            label: Text(c),
                            selected: _copasSel.contains(c),
                            onSelected: (v) => setState(() {
                              if (v) {
                                _copasSel.add(c);
                              } else {
                                _copasSel.remove(c);
                              }
                            }),
                          ))
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nuevaCopa,
                    decoration: const InputDecoration(
                      labelText: 'Añadir nueva categoría',
                      helperText: 'Si no la encuentras arriba',
                      isDense: true,
                    ),
                    onSubmitted: (_) => _anadirCopaNueva(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _anadirCopaNueva,
                  icon: const Icon(Icons.add),
                  label: const Text('Añadir'),
                ),
              ],
            ),

            const SizedBox(height: 28),
            Text('Reglas',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w700,
                    )),
            const SizedBox(height: 12),
            SwitchListTile(
              value: _usaCreditos,
              onChanged: (v) => setState(() => _usaCreditos = v),
              title: const Text('Usa sistema de créditos (handicap)'),
              subtitle: const Text(
                  'Sistema de handicap por créditos. Apágalo si el campeonato no lo usa.'),
            ),
            SwitchListTile(
              value: _usaTesoreria,
              onChanged: (v) => setState(() => _usaTesoreria = v),
              title: const Text('Gestiona tesorería (cuotas/pagos)'),
              subtitle: const Text(
                  'Apágalo si este campeonato no controla el dinero.'),
            ),
            if (esNuevo && _usaCreditos) _selectorImportarPilotos(),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descartes,
              decoration: const InputDecoration(
                labelText: 'Número de descartes',
                helperText: 'Cuántas peores pruebas se descartan al piloto',
                prefixIcon: Icon(Icons.delete_outline),
              ),
              keyboardType: TextInputType.number,
              validator: (v) {
                final n = int.tryParse(v ?? '');
                if (n == null || n < 0 || n > 5) return 'Entre 0 y 5';
                return null;
              },
            ),
            if (_usaCreditos) ...[
              const SizedBox(height: 12),
              TextFormField(
                controller: _tope,
                decoration: const InputDecoration(
                  labelText: 'Tope regularización créditos',
                  helperText:
                      'Máximo de créditos al regularizar al cierre de temporada',
                  prefixIcon: Icon(Icons.toll_outlined),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  if (n == null || n < 1) return 'Número positivo';
                  return null;
                },
              ),
            ],
            if (_usaTesoreria) ...[
              const SizedBox(height: 20),
              Text('Cuotas por prueba (tesorería)',
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 4),
              Text(
                'PAGAT es la cuota total. APORTACIÓN COORDINADORA + APORTACIÓN CLUB '
                'deben sumar el PAGAT (es el desglose de a dónde va el dinero).',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cuotaPagat,
                      decoration: const InputDecoration(
                        labelText: 'Pagat (€) *',
                        prefixIcon: Icon(Icons.payments_outlined),
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _cuotaCoord,
                      decoration: const InputDecoration(
                        labelText: 'Coordinadora (€)',
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _cuotaClub,
                      decoration: const InputDecoration(
                        labelText: 'Club (€)',
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 28),
            Text('Sorteo de motores (organización)',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w700,
                    )),
            const SizedBox(height: 4),
            Text(
              'Rango de números de motor que la organización sortea entre los '
              'equipos en cada prueba. Déjalo vacío si no usáis sorteo.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _motorMin,
                    decoration: const InputDecoration(
                      labelText: 'Motor desde',
                      prefixIcon: Icon(Icons.tag),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _motorMax,
                    decoration: const InputDecoration(
                      labelText: 'Motor hasta',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      final min = int.tryParse(_motorMin.text.trim());
                      final max = int.tryParse(v?.trim() ?? '');
                      if (min == null && max == null) return null;
                      if (min == null || max == null) {
                        return 'Indica ambos';
                      }
                      if (max < min) return 'Hasta ≥ desde';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text('Transmisión (verificación)',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w700,
                    )),
            const SizedBox(height: 4),
            Text(
              'Dientes permitidos en piñón y corona. En la verificación, fuera '
              'de este rango salta infracción. Activa "Tamaño fijo" si solo se '
              'permite un valor.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            _RangoDientes(
              etiqueta: 'Piñón',
              fijo: _pinonFijo,
              min: _pinonMin,
              max: _pinonMax,
              onFijo: (v) => setState(() => _pinonFijo = v),
            ),
            const SizedBox(height: 8),
            _RangoDientes(
              etiqueta: 'Corona',
              fijo: _coronaFijo,
              min: _coronaMin,
              max: _coronaMax,
              onFijo: (v) => setState(() => _coronaFijo = v),
            ),
            const SizedBox(height: 28),
            Text('Marca en los PDF (opcional)',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w700,
                    )),
            const SizedBox(height: 4),
            Text(
              'Título de cabecera y lema del pie en las exportaciones (PDF) de '
              'ESTE campeonato. Si lo dejas vacío, se usa un valor por defecto.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _marcaTitulo,
              decoration: const InputDecoration(
                labelText: 'Título de cabecera',
                hintText: 'Ej: PITWALL o el nombre de tu club',
                prefixIcon: Icon(Icons.title),
              ),
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _marcaLema,
              decoration: const InputDecoration(
                labelText: 'Lema del pie',
                hintText: 'Ej: tu club · localidad',
                prefixIcon: Icon(Icons.notes),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              value: _activo,
              onChanged: (v) => setState(() => _activo = v),
              title: Text(esNuevo
                  ? 'Activar este campeonato al crearlo'
                  : 'Campeonato visible'),
              subtitle: const Text(
                  'Solo los campeonatos visibles aparecen en el selector'),
            ),
            if (!esNuevo)
              SwitchListTile(
                value: _finalizado,
                onChanged: (v) => setState(() => _finalizado = v),
                title: const Text('Campeonato finalizado'),
                subtitle: const Text(
                    'Temporada cerrada: la clasificación ordena por netos y se '
                    'habilita la bonificación de cierre.'),
              ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _guardando ? null : _guardar,
              icon: _guardando
                  ? const SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.check),
              label: Text(esNuevo ? 'Crear campeonato' : 'Guardar cambios'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Configurador del rango de dientes (piñón o corona): interruptor "Tamaño
/// fijo" (un campo) o rango mín-máx (dos campos).
class _RangoDientes extends StatelessWidget {
  const _RangoDientes({
    required this.etiqueta,
    required this.fijo,
    required this.min,
    required this.max,
    required this.onFijo,
  });

  final String etiqueta;
  final bool fijo;
  final TextEditingController min;
  final TextEditingController max;
  final ValueChanged<bool> onFijo;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextFormField(
            controller: min,
            decoration: InputDecoration(
              labelText: fijo ? '$etiqueta · dientes' : '$etiqueta · mín',
              prefixIcon: const Icon(Icons.settings_outlined),
            ),
            keyboardType: TextInputType.number,
            validator: (v) {
              final n = int.tryParse(v?.trim() ?? '');
              if (n == null || n < 1) return 'Nº positivo';
              if (!fijo) {
                final mx = int.tryParse(max.text.trim());
                if (mx != null && mx < n) return 'máx ≥ mín';
              }
              return null;
            },
          ),
        ),
        if (!fijo) ...[
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: max,
              decoration: InputDecoration(labelText: '$etiqueta · máx'),
              keyboardType: TextInputType.number,
              validator: (v) {
                final n = int.tryParse(v?.trim() ?? '');
                if (n == null || n < 1) return 'Nº positivo';
                return null;
              },
            ),
          ),
        ],
        const SizedBox(width: 8),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Fijo', style: TextStyle(fontSize: 11)),
            Switch(value: fijo, onChanged: onFijo),
          ],
        ),
      ],
    );
  }
}
