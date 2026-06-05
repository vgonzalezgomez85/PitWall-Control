import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
        title: const Text('Eliminar prueba'),
        content: Text(
          '¿Eliminar "${_nombre.text}"?\n\n'
          'Se borrarán también sus mangas, inscripciones, resultados y verificaciones. '
          'Esta acción no se puede deshacer.',
        ),
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
    await ref.read(repoPruebasProvider).borrar(widget.pruebaId!);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final esNuevo = widget.pruebaId == null;
    final fmt = DateFormat("EEEE d 'de' MMMM y", 'es_ES');

    return Scaffold(
      appBar: AppBar(
        title: Text(esNuevo ? 'Nueva prueba' : 'Editar prueba'),
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
                labelText: 'Nombre de la prueba *',
                helperText: 'Ej: EL SOT, SLOTMANIA, GASCLAVAT…',
                prefixIcon: Icon(Icons.label_outline),
              ),
              textCapitalization: TextCapitalization.characters,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Indica el nombre' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _sede,
              decoration: const InputDecoration(
                labelText: 'Sede / club',
                prefixIcon: Icon(Icons.place_outlined),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today_outlined),
                title: Text(_fecha == null
                    ? 'Sin fecha asignada'
                    : fmt.format(_fecha!)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_fecha != null)
                      IconButton(
                        tooltip: 'Quitar fecha',
                        icon: const Icon(Icons.close),
                        onPressed: () => setState(() => _fecha = null),
                      ),
                    TextButton(
                      onPressed: _elegirFecha,
                      child: Text(_fecha == null ? 'Elegir' : 'Cambiar'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _orden,
              decoration: const InputDecoration(
                labelText: 'Orden en el campeonato',
                helperText: 'Posición en el calendario (1, 2, 3…)',
                prefixIcon: Icon(Icons.format_list_numbered),
              ),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || int.tryParse(v) == null) return 'Número entero';
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
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(etiquetaEstado(e))))
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
              label: Text(esNuevo ? 'Crear prueba' : 'Guardar cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
