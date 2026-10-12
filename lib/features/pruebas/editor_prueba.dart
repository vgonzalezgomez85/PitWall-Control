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

import '../../core/idioma.dart';
import '../../core/proveedores.dart';
import 'repositorio_pruebas.dart';

class EditorPrueba extends ConsumerStatefulWidget {
  const EditorPrueba({super.key, this.pruebaId});

  final int? pruebaId;

  @override
  ConsumerState<EditorPrueba> createState() => _EditorPruebaState();
}

class _EditorPruebaState extends ConsumerState<EditorPrueba> {
  final _formKey = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _sede = TextEditingController();
  final _orden = TextEditingController();

  DateTime? _fecha;
  String _estado = 'PROGRAMADA';
  bool _cargando = true;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    if (widget.pruebaId == null) {
      final activo = ref.read(campeonatoActivoProvider)!;
      final repo = ref.read(repoPruebasProvider);
      final orden = await repo.siguienteOrden(activo.id);
      _orden.text = orden.toString();
      setState(() => _cargando = false);
      return;
    }
    final db = ref.read(dbProvider);
    final p = await (db.select(db.pruebas)
          ..where((t) => t.id.equals(widget.pruebaId!)))
        .getSingle();
    _nombre.text = p.nombre;
    _sede.text = p.sede ?? '';
    _orden.text = p.orden.toString();
    _fecha = p.fecha;
    _estado = p.estado;
    if (mounted) setState(() => _cargando = false);
  }

  @override
  void dispose() {
    _nombre.dispose();
    _sede.dispose();
    _orden.dispose();
    super.dispose();
  }

  Future<void> _elegirFecha() async {
    final hoy = DateTime.now();
    final res = await showDatePicker(
      context: context,
      initialDate: _fecha ?? hoy,
      firstDate: DateTime(hoy.year - 1),
      lastDate: DateTime(hoy.year + 5),
      locale: const Locale('es', 'ES'),
    );
    if (res != null) setState(() => _fecha = res);
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);
    final activo = ref.read(campeonatoActivoProvider)!;
    final repo = ref.read(repoPruebasProvider);
    try {
      if (widget.pruebaId == null) {
        await repo.crear(
          campeonatoId: activo.id,
          nombre: _nombre.text.trim(),
          sede: _sede.text.trim().isEmpty ? null : _sede.text.trim(),
          fecha: _fecha,
          orden: int.parse(_orden.text),
        );
      } else {
        await repo.actualizar(
          id: widget.pruebaId!,
          nombre: _nombre.text.trim(),
          sede: _sede.text.trim().isEmpty ? null : _sede.text.trim(),
          fecha: _fecha,
          orden: int.parse(_orden.text),
          estado: _estado,
        );
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l.noSePudoGuardar('$e'))),
        );
        setState(() => _guardando = false);
      }
    }
  }

  Future<void> _borrar() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(context.l.eliminarPrueba),
        content: Text(
          context.l.eliminarPruebaTexto(_nombre.text),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.l.cancelar)),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(context.l.eliminar)),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(repoPruebasProvider).borrar(widget.pruebaId!);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final esNuevo = widget.pruebaId == null;
    final fmt = DateFormat.yMMMMEEEEd(context.idiomaFechas);

    return Scaffold(
      appBar: AppBar(
        title: Text(esNuevo ? context.l.nuevaPrueba : context.l.editarPrueba),
        actions: [
          if (!esNuevo)
            IconButton(
              tooltip: context.l.eliminar,
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
              decoration: InputDecoration(
                labelText: context.l.nombrePruebaObligatorio,
                helperText: context.l.nombrePruebaAyuda,
                prefixIcon: Icon(Icons.label_outline),
              ),
              textCapitalization: TextCapitalization.characters,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? context.l.indicaElNombre : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _sede,
              decoration: InputDecoration(
                labelText: context.l.sedeClub,
                prefixIcon: Icon(Icons.place_outlined),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today_outlined),
                title: Text(_fecha == null
                    ? context.l.sinFechaAsignada
                    : fmt.format(_fecha!)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_fecha != null)
                      IconButton(
                        tooltip: context.l.quitarFecha,
                        icon: const Icon(Icons.close),
                        onPressed: () => setState(() => _fecha = null),
                      ),
                    TextButton(
                      onPressed: _elegirFecha,
                      child: Text(_fecha == null ? context.l.elegir : context.l.cambiar),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _orden,
              decoration: InputDecoration(
                labelText: context.l.ordenCampeonato,
                helperText: context.l.ordenCampeonatoAyuda,
                prefixIcon: Icon(Icons.format_list_numbered),
              ),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || int.tryParse(v) == null) return context.l.numeroEntero;
                return null;
              },
            ),
            if (!esNuevo) ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _estado,
                decoration: InputDecoration(
                  labelText: context.l.estado,
                  prefixIcon: Icon(Icons.flag_outlined),
                ),
                items: estadosPrueba
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(etiquetaEstado(context, e))))
                    .toList(),
                onChanged: (v) => setState(() => _estado = v ?? 'PROGRAMADA'),
              ),
            ],
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _guardando ? null : _guardar,
              icon: _guardando
                  ? const SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check),
              label: Text(esNuevo ? context.l.crearPrueba : context.l.guardarCambios),
            ),
          ],
        ),
      ),
    );
  }
}
