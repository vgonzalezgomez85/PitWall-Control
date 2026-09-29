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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/proveedores.dart';
import '../campeonatos/editor_campeonato.dart' show RangoDientes;
import 'repositorio_verificacion_libre.dart';

final _catalogoCopasProvider =
    FutureProvider.autoDispose<List<String>>((ref) async {
  final db = ref.watch(dbProvider);
  final lista = await db.select(db.catalogoCopas).get();
  return lista.map((c) => c.nombre).toList()..sort();
});

/// Alta o edición de una sesión de verificación libre: datos de la sesión y
/// su reglamento de verificación (el mismo que un campeonato, por copa).
///
/// Al crear, cierra devolviendo el id de la prueba de la sesión nueva.
class EditorSesionLibre extends ConsumerStatefulWidget {
  const EditorSesionLibre({super.key, this.pruebaId});

  /// Null = sesión nueva.
  final int? pruebaId;

  @override
  ConsumerState<EditorSesionLibre> createState() => _EditorSesionLibreState();
}

class _EditorSesionLibreState extends ConsumerState<EditorSesionLibre> {
  final _formKey = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _sede = TextEditingController();
  final _motorMin = TextEditingController();
  final _motorMax = TextEditingController();
  final _pinonMin = TextEditingController();
  final _pinonMax = TextEditingController();
  final _coronaMin = TextEditingController();
  final _coronaMax = TextEditingController();
  bool _pinonFijo = true;
  bool _coronaFijo = false;
  DateTime? _fecha;
  final Set<String> _copasSel = {};
  final Map<String, TextEditingController> _anchuraEjeCtrl = {};
  TextEditingController _anchuraCtrl(String copa, String lado) =>
      _anchuraEjeCtrl.putIfAbsent('$copa|$lado', () => TextEditingController());

  bool _cargando = true;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  @override
  void dispose() {
    for (final c in [
      _nombre, _sede, _motorMin, _motorMax,
      _pinonMin, _pinonMax, _coronaMin, _coronaMax,
      ..._anchuraEjeCtrl.values,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _cargar() async {
    final repo = ref.read(repoVerificacionLibreProvider);
    final DatosSesionLibre d;
    if (widget.pruebaId == null) {
      d = await repo.plantillaNueva();
    } else {
      final s = await repo.cargar(widget.pruebaId!);
      if (s == null) {
        if (mounted) Navigator.of(context).pop();
        return;
      }
      final c = s.reglamento;
      d = DatosSesionLibre(
        nombre: s.prueba.nombre,
        sede: s.prueba.sede,
        fecha: s.prueba.fecha,
        copas: s.copas,
        anchuraEjeJson: c.anchuraEjeJson,
        pinonDientesMin: c.pinonDientesMin,
        pinonDientesMax: c.pinonDientesMax,
        coronaDientesMin: c.coronaDientesMin,
        coronaDientesMax: c.coronaDientesMax,
        motorSorteoMin: c.motorSorteoMin,
        motorSorteoMax: c.motorSorteoMax,
      );
    }
    _nombre.text = d.nombre;
    _sede.text = d.sede ?? '';
    _fecha = d.fecha;
    _copasSel.addAll(d.copas);
    _pinonMin.text = '${d.pinonDientesMin}';
    _pinonMax.text = '${d.pinonDientesMax}';
    _coronaMin.text = '${d.coronaDientesMin}';
    _coronaMax.text = '${d.coronaDientesMax}';
    _pinonFijo = d.pinonDientesMin == d.pinonDientesMax;
    _coronaFijo = d.coronaDientesMin == d.coronaDientesMax;
    _motorMin.text = d.motorSorteoMin?.toString() ?? '';
    _motorMax.text = d.motorSorteoMax?.toString() ?? '';
    try {
      final raw = json.decode(d.anchuraEjeJson);
      if (raw is Map) {
        raw.forEach((copa, lados) {
          if (lados is Map) {
            if (lados['del'] != null) {
              _anchuraCtrl('$copa', 'del').text = '${lados['del']}';
            }
            if (lados['tra'] != null) {
              _anchuraCtrl('$copa', 'tra').text = '${lados['tra']}';
            }
          }
        });
      }
    } catch (_) {}
    if (mounted) setState(() => _cargando = false);
  }

  Future<void> _elegirFecha() async {
    final hoy = DateTime.now();
    final f = await showDatePicker(
      context: context,
      initialDate: _fecha ?? hoy,
      firstDate: DateTime(2000),
      lastDate: DateTime(hoy.year + 5),
    );
    if (f != null) setState(() => _fecha = f);
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_copasSel.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Selecciona al menos una copa / categoría.')));
      return;
    }
    setState(() => _guardando = true);
    // Anchura máxima de eje por copa y lado: vacío = no se comprueba.
    final anchuraEjeMap = <String, Map<String, double>>{};
    for (final copa in _copasSel) {
      final del = double.tryParse(
          _anchuraCtrl(copa, 'del').text.trim().replaceAll(',', '.'));
      final tra = double.tryParse(
          _anchuraCtrl(copa, 'tra').text.trim().replaceAll(',', '.'));
      if (del != null || tra != null) {
        anchuraEjeMap[copa] = {'del': ?del, 'tra': ?tra};
      }
    }
    final pinMin = int.tryParse(_pinonMin.text.trim()) ?? 12;
    final pinMax =
        _pinonFijo ? pinMin : (int.tryParse(_pinonMax.text.trim()) ?? pinMin);
    final corMin = int.tryParse(_coronaMin.text.trim()) ?? 24;
    final corMax =
        _coronaFijo ? corMin : (int.tryParse(_coronaMax.text.trim()) ?? corMin);
    final sede = _sede.text.trim();
    final datos = DatosSesionLibre(
      nombre: _nombre.text.trim(),
      sede: sede.isEmpty ? null : sede,
      fecha: _fecha,
      copas: _copasSel.toList()..sort(),
      anchuraEjeJson: json.encode(anchuraEjeMap),
      pinonDientesMin: pinMin,
      pinonDientesMax: pinMax,
      coronaDientesMin: corMin,
      coronaDientesMax: corMax,
      motorSorteoMin: int.tryParse(_motorMin.text.trim()),
      motorSorteoMax: int.tryParse(_motorMax.text.trim()),
    );
    final repo = ref.read(repoVerificacionLibreProvider);
    try {
      if (widget.pruebaId == null) {
        final id = await repo.crearSesion(datos);
        if (mounted) Navigator.of(context).pop(id);
      } else {
        await repo.actualizarSesion(widget.pruebaId!, datos);
        if (mounted) Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('No se pudo guardar: $e')));
        setState(() => _guardando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final esNueva = widget.pruebaId == null;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final catalogoAsync = ref.watch(_catalogoCopasProvider);
    Widget seccion(String titulo, String ayuda) => Padding(
          padding: const EdgeInsets.only(top: 28, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titulo,
                  style: tt.titleMedium?.copyWith(
                      color: cs.primary, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(ayuda, style: tt.bodySmall),
            ],
          ),
        );

    return Scaffold(
      appBar: AppBar(
        title: Text(esNueva ? 'Nueva sesión de verificación' : 'Editar sesión'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _nombre,
              autofocus: esNueva,
              decoration: const InputDecoration(
                labelText: 'Nombre de la sesión *',
                helperText: 'Ej: Control club jueves, Carrera GT Sant Joan',
                prefixIcon: Icon(Icons.fact_check_outlined),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Obligatorio' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _sede,
              decoration: const InputDecoration(
                labelText: 'Lugar (opcional)',
                prefixIcon: Icon(Icons.place_outlined),
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event_outlined),
              title: Text(_fecha == null
                  ? 'Sin fecha'
                  : DateFormat('dd/MM/yyyy').format(_fecha!)),
              subtitle: const Text('Fecha de la sesión'),
              trailing: _fecha == null
                  ? null
                  : IconButton(
                      tooltip: 'Quitar fecha',
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() => _fecha = null),
                    ),
              onTap: _elegirFecha,
            ),

            seccion('Copas / categorías',
                'Las que se pueden verificar en esta sesión. La copa de cada '
                'participante filtra el catálogo y las comprobaciones, igual '
                'que en un campeonato.'),
            catalogoAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
              data: (copas) {
                final todas = {...copas, ..._copasSel}.toList()..sort();
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final c in todas)
                      FilterChip(
                        label: Text(c),
                        selected: _copasSel.contains(c),
                        onSelected: (v) => setState(() =>
                            v ? _copasSel.add(c) : _copasSel.remove(c)),
                      ),
                  ],
                );
              },
            ),

            if (_copasSel.isNotEmpty) ...[
              seccion('Anchura de eje',
                  'Anchura máxima de eje (mm) por copa. Deja vacío si en esa '
                  'copa no se comprueba.'),
              for (final copa in _copasSel.toList()..sort()) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('Copa $copa', style: tt.labelMedium),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      for (final (lado, etiqueta) in [
                        ('del', 'Máx delantero (mm)'),
                        ('tra', 'Máx trasero (mm)'),
                      ]) ...[
                        if (lado == 'tra') const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _anchuraCtrl(copa, lado),
                            decoration: InputDecoration(
                              labelText: etiqueta,
                              prefixIcon:
                                  const Icon(Icons.straighten_outlined),
                              isDense: true,
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],

            seccion('Transmisión',
                'Dientes permitidos en piñón y corona. Fuera de este rango '
                'salta infracción.'),
            RangoDientes(
              etiqueta: 'Piñón',
              fijo: _pinonFijo,
              min: _pinonMin,
              max: _pinonMax,
              onFijo: (v) => setState(() => _pinonFijo = v),
            ),
            const SizedBox(height: 12),
            RangoDientes(
              etiqueta: 'Corona',
              fijo: _coronaFijo,
              min: _coronaMin,
              max: _coronaMax,
              onFijo: (v) => setState(() => _coronaFijo = v),
            ),

            seccion('Sorteo de motores (organización)',
                'Rango de números de motor para sortear desde la '
                'verificación. Déjalo vacío si no hay sorteo.'),
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
                    decoration: const InputDecoration(labelText: 'Motor hasta'),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      final min = int.tryParse(_motorMin.text.trim());
                      final max = int.tryParse(v?.trim() ?? '');
                      if (min == null && max == null) return null;
                      if (min == null || max == null) return 'Indica ambos';
                      if (max < min) return 'Hasta ≥ desde';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _guardando ? null : _guardar,
              icon: const Icon(Icons.save_outlined),
              label: Text(esNueva ? 'Crear sesión' : 'Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
