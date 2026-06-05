import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/proveedores.dart';
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
  bool _cargando = true;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    if (widget.mangaId == null) {
      setState(() => _cargando = false);
      return;
    }
    final db = ref.read(dbProvider);
    final m = await (db.select(db.mangas)
          ..where((t) => t.id.equals(widget.mangaId!)))
        .getSingle();
    _nombre.text = m.nombre;
    _numCarriles.text = m.numCarriles.toString();
    _fechaHora = m.fechaHora;
    _estado = m.estado;
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
        await repo.crear(
          pruebaId: widget.pruebaId,
          nombre: _nombre.text.trim(),
          fechaHora: _fechaHora,
          numCarriles: int.parse(_numCarriles.text),
        );
      } else {
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
          SnackBar(content: Text('No se pudo guardar: $e')),
        );
        setState(() => _guardando = false);
      }
    }
  }

  Future<void> _borrar() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar manga'),
        content: Text(
            '¿Eliminar la manga "${_nombre.text}"? Se borrarán también las inscripciones, resultados y verificaciones de la manga.'),
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
    await ref.read(repoMangasProvider).borrar(widget.mangaId!);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final esNuevo = widget.mangaId == null;
    final fmt = DateFormat("EEEE d 'de' MMMM, HH:mm", 'es_ES');

    return Scaffold(
      appBar: AppBar(
        title: Text(esNuevo ? 'Nueva manga' : 'Editar manga'),
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
                labelText: 'Nombre de la manga *',
                helperText: 'Ej: Jueves 21:00, Viernes 23:00…',
                prefixIcon: Icon(Icons.label_outline),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Indica el nombre'
                  : null,
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.event_outlined),
                title: Text(_fechaHora == null
                    ? 'Sin fecha y hora asignadas'
                    : fmt.format(_fechaHora!)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_fechaHora != null)
                      IconButton(
                        icon: const Icon(Icons.close),
                        tooltip: 'Quitar',
                        onPressed: () => setState(() => _fechaHora = null),
                      ),
                    TextButton(
                      onPressed: _elegirFechaHora,
                      child: Text(_fechaHora == null ? 'Elegir' : 'Cambiar'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _numCarriles,
              decoration: const InputDecoration(
                labelText: 'Número de carriles',
                helperText: 'Habitualmente 6, 7 u 8',
                prefixIcon: Icon(Icons.linear_scale),
              ),
              keyboardType: TextInputType.number,
              validator: (v) {
                final n = int.tryParse(v ?? '');
                if (n == null || n < 1 || n > 16) {
                  return 'Indica un número entre 1 y 16';
                }
                return null;
              },
            ),
            if (!esNuevo) ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _estado,
                decoration: const InputDecoration(
                  labelText: 'Estado',
                  prefixIcon: Icon(Icons.flag_outlined),
                ),
                items: estadosPrueba
                    .map((e) => DropdownMenuItem(
                        value: e, child: Text(etiquetaEstado(e))))
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
              label: Text(esNuevo ? 'Crear manga' : 'Guardar cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
