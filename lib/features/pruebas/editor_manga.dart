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
import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/idioma.dart';
import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import '../equipos/repositorio_equipos.dart';
import 'repositorio_pruebas.dart';

class EditorManga extends ConsumerStatefulWidget {
  const EditorManga({super.key, required this.pruebaId, this.mangaId});

  final int pruebaId;
  final int? mangaId;

  @override
  ConsumerState<EditorManga> createState() => _EditorMangaState();
}

class _EditorMangaState extends ConsumerState<EditorManga> {
  final _formKey = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _numCarriles = TextEditingController(text: '8');

  DateTime? _fechaHora;
  String _estado = 'PROGRAMADA';
  /// Solo individuales: manga cuyos pilotos hacen de pisters en esta.
  int? _pistersMangaId;
  List<Manga> _otrasMangas = const [];
  bool _cargando = true;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final db = ref.read(dbProvider);
    _otrasMangas = (await (db.select(db.mangas)
              ..where((t) => t.pruebaId.equals(widget.pruebaId))
              ..orderBy([(t) => OrderingTerm.asc(t.id)]))
            .get())
        .where((m) => m.id != widget.mangaId)
        .toList();
    if (widget.mangaId == null) {
      setState(() => _cargando = false);
      return;
    }
    final m = await (db.select(db.mangas)
          ..where((t) => t.id.equals(widget.mangaId!)))
        .getSingle();
    _nombre.text = m.nombre;
    _numCarriles.text = m.numCarriles.toString();
    _fechaHora = m.fechaHora;
    _estado = m.estado;
    _pistersMangaId =
        _otrasMangas.any((o) => o.id == m.pistersMangaId) ? m.pistersMangaId : null;
    if (mounted) setState(() => _cargando = false);
  }

  @override
  void dispose() {
    _nombre.dispose();
    _numCarriles.dispose();
    super.dispose();
  }

  Future<void> _elegirFechaHora() async {
    final hoy = DateTime.now();
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fechaHora ?? hoy,
      firstDate: DateTime(hoy.year - 1),
      lastDate: DateTime(hoy.year + 5),
      locale: const Locale('es', 'ES'),
    );
    if (fecha == null || !mounted) return;
    final hora = await showTimePicker(
      // ignore: use_build_context_synchronously
      context: context,
      initialTime: TimeOfDay.fromDateTime(_fechaHora ?? hoy),
    );
    if (hora == null) return;
    setState(() {
      _fechaHora = DateTime(
        fecha.year, fecha.month, fecha.day, hora.hour, hora.minute,
      );
    });
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);
    final repo = ref.read(repoMangasProvider);
    try {
      if (widget.mangaId == null) {
        final id = await repo.crear(
          pruebaId: widget.pruebaId,
          nombre: _nombre.text.trim(),
          fechaHora: _fechaHora,
          numCarriles: int.parse(_numCarriles.text),
        );
        if (_pistersMangaId != null) {
          await repo.cambiarPisters(id, _pistersMangaId);
        }
      } else {
        await repo.cambiarPisters(widget.mangaId!, _pistersMangaId);
        await repo.actualizar(
          id: widget.mangaId!,
          nombre: _nombre.text.trim(),
          fechaHora: _fechaHora,
          numCarriles: int.parse(_numCarriles.text),
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
        title: Text(context.l.eliminarTanda),
        content: Text(
            context.l.eliminarTandaTexto(_nombre.text)),
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
    await ref.read(repoMangasProvider).borrar(widget.mangaId!);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final esNuevo = widget.mangaId == null;
    final fmt = DateFormat.MMMMEEEEd(context.idiomaFechas).add_Hm();

    return Scaffold(
      appBar: AppBar(
        title: Text(esNuevo ? context.l.nuevaTanda : context.l.editarTanda),
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
                labelText: context.l.nombreTandaObligatorio,
                helperText: context.l.nombreTandaAyuda,
                prefixIcon: Icon(Icons.label_outline),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? context.l.indicaElNombre
                  : null,
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.event_outlined),
                title: Text(_fechaHora == null
                    ? context.l.sinFechaHora
                    : fmt.format(_fechaHora!)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_fechaHora != null)
                      IconButton(
                        icon: const Icon(Icons.close),
                        tooltip: context.l.quitar,
                        onPressed: () => setState(() => _fechaHora = null),
                      ),
                    TextButton(
                      onPressed: _elegirFechaHora,
                      child: Text(_fechaHora == null ? context.l.elegir : context.l.cambiar),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _numCarriles,
              decoration: InputDecoration(
                labelText: context.l.numeroCarriles,
                helperText: context.l.numeroCarrilesAyuda,
                prefixIcon: Icon(Icons.linear_scale),
              ),
              keyboardType: TextInputType.number,
              validator: (v) {
                final n = int.tryParse(v ?? '');
                if (n == null || n < 1 || n > 32) {
                  return context.l.numeroCarrilesError;
                }
                return null;
              },
            ),
            if (maxPilotosEquipo(
                        ref.watch(campeonatoActivoProvider)?.formato ??
                            'PAREJAS') ==
                    1 &&
                _otrasMangas.isNotEmpty) ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<int?>(
                initialValue: _pistersMangaId,
                decoration: InputDecoration(
                  labelText: context.l.pisters,
                  helperText: context.l.pistersAyuda,
                  prefixIcon: Icon(Icons.sports_outlined),
                ),
                items: [
                  DropdownMenuItem<int?>(
                      value: null, child: Text(context.l.sinPisters)),
                  for (final o in _otrasMangas)
                    DropdownMenuItem<int?>(
                        value: o.id, child: Text(context.l.pilotosDe(o.nombre))),
                ],
                onChanged: (v) => setState(() => _pistersMangaId = v),
              ),
            ],
            if (!esNuevo) ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _estado,
                decoration: InputDecoration(
                  labelText: context.l.estado,
                  prefixIcon: Icon(Icons.flag_outlined),
                ),
                items: estadosPrueba
                    .map((e) => DropdownMenuItem(
                        value: e, child: Text(etiquetaEstado(context, e))))
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
              label: Text(esNuevo ? context.l.crearTanda : context.l.guardarCambios),
            ),
          ],
        ),
      ),
    );
  }
}
