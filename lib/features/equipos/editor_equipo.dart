import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../core/widgets/selector_buscable.dart';
import '../../data/database/app_database.dart';
import 'repositorio_equipos.dart';

class EditorEquipo extends ConsumerStatefulWidget {
  const EditorEquipo({super.key, this.equipoId});

  final int? equipoId;

  @override
  ConsumerState<EditorEquipo> createState() => _EditorEquipoState();
}

class _EditorEquipoState extends ConsumerState<EditorEquipo> {
  final _formKey = GlobalKey<FormState>();
  final _nombre = TextEditingController();

  String? _copa;
  String? _copaOriginal;
  int? _piloto1Id;
  int? _piloto2Id;
  bool _cargando = true;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    if (widget.equipoId == null) {
      setState(() => _cargando = false);
      return;
    }
    final db = ref.read(dbProvider);
    final e = await (db.select(db.equipos)
          ..where((t) => t.id.equals(widget.equipoId!)))
        .getSingle();
    _nombre.text = e.nombre;
    _copa = e.copa;
    _copaOriginal = e.copa;
    _piloto1Id = e.piloto1Id;
    _piloto2Id = e.piloto2Id;
    if (mounted) setState(() => _cargando = false);
  }

  @override
  void dispose() {
    _nombre.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_piloto1Id == null) {
      _aviso('Selecciona al menos un piloto.');
      return;
    }
    if (_copa == null) {
      _aviso('Selecciona la copa.');
      return;
    }
    final activo = ref.read(campeonatoActivoProvider)!;
    if (activo.formato == 'PAREJAS' && _piloto2Id == null) {
      _aviso('En este campeonato (parejas) el equipo necesita dos pilotos.');
      return;
    }
    if (_piloto2Id != null && _piloto1Id == _piloto2Id) {
      _aviso('Los dos pilotos del equipo no pueden ser la misma persona.');
      return;
    }

    setState(() => _guardando = true);
    final repo = ref.read(repoEquiposProvider);
    try {
      if (widget.equipoId == null) {
        await repo.crear(
          campeonatoId: activo.id,
          nombre: _nombre.text.trim(),
          copa: _copa!,
          piloto1Id: _piloto1Id!,
          piloto2Id: _piloto2Id,
        );
      } else {
        // Si cambia la copa a mitad de campeonato, congelar la copa anterior
        // en TODAS las pruebas donde el equipo ya ha competido (tenga o no
        // inscripción), para que esos puntos sigan contando en la copa antigua.
        if (_copaOriginal != null && _copa != _copaOriginal) {
          await _congelarCopaAnterior(widget.equipoId!, _copaOriginal!);
        }
        await repo.actualizar(
          id: widget.equipoId!,
          nombre: _nombre.text.trim(),
          copa: _copa!,
          piloto1Id: _piloto1Id!,
          piloto2Id: _piloto2Id,
        );
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      _aviso('No se pudo guardar: $e');
      if (mounted) setState(() => _guardando = false);
    }
  }

  void _aviso(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  /// Congela [copaAnterior] en todas las pruebas donde el equipo ya compitió
  /// (por resultados o inscripción) y que aún no tengan copa propia, para que
  /// esos puntos se mantengan en su copa al cambiar de copa el equipo.
  Future<void> _congelarCopaAnterior(int equipoId, String copaAnterior) async {
    final db = ref.read(dbProvider);
    // Pruebas donde el equipo tiene resultados.
    final res = await (db.select(db.resultados)
          ..where((t) => t.equipoId.equals(equipoId)))
        .get();
    final mangaIds = res.map((r) => r.mangaId).toSet().toList();
    final mangas = mangaIds.isEmpty
        ? []
        : await (db.select(db.mangas)..where((t) => t.id.isIn(mangaIds))).get();
    final pruebasConResultado = mangas.map((m) => m.pruebaId).toSet();
    // Inscripciones existentes del equipo.
    final ins = await (db.select(db.inscripcionesPrueba)
          ..where((t) => t.equipoId.equals(equipoId)))
        .get();
    final insPorPrueba = {for (final i in ins) i.pruebaId: i};

    final pruebas = {...pruebasConResultado, ...insPorPrueba.keys};
    for (final pruebaId in pruebas) {
      final existente = insPorPrueba[pruebaId];
      if (existente == null) {
        await db.into(db.inscripcionesPrueba).insert(
              InscripcionesPruebaCompanion.insert(
                pruebaId: pruebaId,
                equipoId: equipoId,
                copa: drift.Value(copaAnterior),
                asignada: const drift.Value(true),
              ),
            );
      } else if (existente.copa == null) {
        await (db.update(db.inscripcionesPrueba)
              ..where((t) => t.id.equals(existente.id)))
            .write(InscripcionesPruebaCompanion(
                copa: drift.Value(copaAnterior)));
      }
    }
  }

  Future<void> _borrar() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar equipo'),
        content: Text(
            '¿Eliminar el equipo "${_nombre.text}"? Esta acción no se puede deshacer.'),
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
    await ref.read(repoEquiposProvider).borrar(widget.equipoId!);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final esNuevo = widget.equipoId == null;
    final activo = ref.watch(campeonatoActivoProvider);
    final esPareja = activo?.formato == 'PAREJAS';
    final pilotosAsync = ref.watch(pilotosDelCampeonatoProvider);
    final copas = ref.watch(copasProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(esNuevo ? 'Nuevo equipo' : 'Editar equipo'),
        actions: [
          if (!esNuevo)
            IconButton(
              tooltip: 'Eliminar',
              icon: const Icon(Icons.delete_outline),
              onPressed: _borrar,
            ),
        ],
      ),
      body: pilotosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (pilotos) {
          if (pilotos.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'Primero añade pilotos al campeonato para poder crear equipos.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                TextFormField(
                  controller: _nombre,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del equipo *',
                    prefixIcon: Icon(Icons.label_outline),
                  ),
                  textCapitalization: TextCapitalization.characters,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Indica un nombre'
                      : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _copa,
                  decoration: const InputDecoration(
                    labelText: 'Copa / categoría *',
                    prefixIcon: Icon(Icons.flag_outlined),
                  ),
                  items: copas
                      .map((c) =>
                          DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => _copa = v),
                ),
                const SizedBox(height: 24),
                Text(esPareja ? 'Pilotos del equipo' : 'Piloto',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        )),
                const SizedBox(height: 12),
                _SelectorPiloto(
                  label: esPareja ? 'Piloto 1 *' : 'Piloto *',
                  pilotos: pilotos,
                  valor: _piloto1Id,
                  onChange: (v) => setState(() => _piloto1Id = v),
                ),
                if (esPareja) ...[
                  const SizedBox(height: 12),
                  _SelectorPiloto(
                    label: 'Piloto 2 *',
                    pilotos: pilotos,
                    valor: _piloto2Id,
                    onChange: (v) => setState(() => _piloto2Id = v),
                  ),
                ],
                const SizedBox(height: 16),
                Card(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: Theme.of(context).colorScheme.outline),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'El coche se indica en la verificación de cada manga. '
                            'Un equipo puede usar coches diferentes en distintas pruebas.',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: _guardando ? null : _guardar,
                  icon: _guardando
                      ? const SizedBox(
                          width: 18, height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check),
                  label: Text(esNuevo ? 'Crear equipo' : 'Guardar cambios'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SelectorPiloto extends StatelessWidget {
  const _SelectorPiloto({
    required this.label,
    required this.pilotos,
    required this.valor,
    required this.onChange,
  });

  final String label;
  final List<Piloto> pilotos;
  final int? valor;
  final ValueChanged<int?> onChange;

  @override
  Widget build(BuildContext context) {
    final sel = pilotos.where((p) => p.id == valor).firstOrNull;
    return SelectorBuscable<Piloto>(
      etiqueta: label,
      icono: Icons.person_outline,
      titulo: label,
      valor: sel,
      opciones: pilotos,
      etiquetaOpcion: (p) => p.nombre,
      subtituloOpcion: (p) => p.email,
      textoVacio: '— elegir piloto —',
      onCambio: (p) => onChange(p?.id),
    );
  }
}
