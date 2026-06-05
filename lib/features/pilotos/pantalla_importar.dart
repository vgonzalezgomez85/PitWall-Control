import 'package:drift/drift.dart' show Value;
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import 'importador_pilotos.dart';
import 'repositorio_pilotos.dart';

class PantallaImportarPilotos extends ConsumerStatefulWidget {
  const PantallaImportarPilotos({super.key});

  @override
  ConsumerState<PantallaImportarPilotos> createState() =>
      _PantallaImportarPilotosState();
}

class _PantallaImportarPilotosState
    extends ConsumerState<PantallaImportarPilotos> {
  String? _archivo;
  List<String> _columnas = [];
  List<Map<String, String>> _filasArchivo = [];
  MapeoColumnas _mapeo = MapeoColumnas();
  List<PilotoImportado> _previo = [];
  bool _trabajando = false;
  String? _error;

  Future<void> _elegirArchivo() async {
    setState(() {
      _error = null;
      _trabajando = true;
    });
    try {
      final tipo = XTypeGroup(
        label: 'Archivos',
        extensions: ['csv', 'xlsx', 'xls'],
      );
      final xfile = await openFile(acceptedTypeGroups: [tipo]);
      if (xfile == null) {
        setState(() => _trabajando = false);
        return;
      }
      _archivo = xfile.path;

      final res = await ImportadorPilotos.leerArchivo(xfile.path);
      _columnas = res.columnas;
      _filasArchivo = res.filas;
      _mapeo = ImportadorPilotos.detectarMapeo(_columnas);
      await _recalcularPrevio();
    } catch (e) {
      _error = 'No se pudo leer el archivo: $e';
    } finally {
      if (mounted) setState(() => _trabajando = false);
    }
  }

  Future<void> _recalcularPrevio() async {
    final filas = ImportadorPilotos.transformar(_filasArchivo, _mapeo);

    // Marcar estado contra BD
    final activo = ref.read(campeonatoActivoProvider);
    if (activo == null) {
      setState(() => _previo = filas);
      return;
    }
    final db = ref.read(dbProvider);
    final maestro = await db.select(db.pilotos).get();
    final inscritos = await (db.select(db.pilotoCampeonato)
          ..where((t) => t.campeonatoId.equals(activo.id)))
        .get();
    final idsInscritos = inscritos.map((e) => e.pilotoId).toSet();
    final porNombre = {for (final p in maestro) _norm(p.nombre): p};

    for (final f in filas) {
      final existente = porNombre[_norm(f.nombre)];
      if (existente == null) {
        f.estado = 'nuevo';
      } else if (idsInscritos.contains(existente.id)) {
        f.estado = 'ya_inscrito';
        f.importar = false;
      } else {
        f.estado = 'inscribir';
      }
    }

    if (mounted) setState(() => _previo = filas);
  }

  static String _norm(String s) =>
      s.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();

  Future<void> _importar() async {
    final activo = ref.read(campeonatoActivoProvider)!;
    final db = ref.read(dbProvider);
    final repo = ref.read(repoPilotosProvider);
    setState(() => _trabajando = true);

    int nuevos = 0, inscritos = 0, saltados = 0;
    try {
      final maestro = await db.select(db.pilotos).get();
      final porNombre = {for (final p in maestro) _norm(p.nombre): p};

      for (final f in _previo) {
        if (!f.importar) {
          saltados++;
          continue;
        }
        final categoria = (f.categoria != null &&
                categorias.contains(f.categoria))
            ? f.categoria!
            : 'BRONCE';
        final cIni = f.creditosIniciales ??
            creditosInicialesPorCategoria[categoria] ?? 28;
        final cAct = f.creditosActuales ?? cIni;

        final existente = porNombre[_norm(f.nombre)];
        if (existente == null) {
          await repo.crear(
            nombre: f.nombre,
            palmaresGlobal: f.palmares,
            campeonatoId: activo.id,
            categoria: categoria,
            creditosIniciales: cIni,
            creditosActuales: cAct,
          );
          nuevos++;
        } else {
          // Actualizar palmarés del maestro si llegó algo nuevo
          if ((f.palmares ?? '').isNotEmpty &&
              (existente.palmaresGlobal ?? '').isEmpty) {
            await (db.update(db.pilotos)
                  ..where((t) => t.id.equals(existente.id)))
                .write(PilotosCompanion(palmaresGlobal: Value(f.palmares)));
          }
          await repo.inscribirEnCampeonato(
            pilotoId: existente.id,
            campeonatoId: activo.id,
            categoria: categoria,
            creditosIniciales: cIni,
          );
          inscritos++;
        }
      }

      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Importación completada'),
          content: Text(
            '✓ Pilotos nuevos: $nuevos\n'
            '✓ Inscritos en este campeonato: $inscritos\n'
            '✗ Saltados: $saltados',
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error importando: $e')),
      );
    } finally {
      if (mounted) setState(() => _trabajando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final filasParaImportar = _previo.where((f) => f.importar).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Importar pilotos')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            color: color.surfaceContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('1. Elige el archivo',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Soporta archivos Excel (.xlsx) y CSV. Debe tener al menos '
                    'una columna con el nombre de los pilotos.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      FilledButton.icon(
                        onPressed: _trabajando ? null : _elegirArchivo,
                        icon: const Icon(Icons.folder_open),
                        label: const Text('Elegir archivo'),
                      ),
                      const SizedBox(width: 12),
                      if (_archivo != null)
                        Expanded(
                          child: Text(
                            _archivo!.split('/').last,
                            style: Theme.of(context).textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 16),
            Card(
              color: color.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: color.onErrorContainer),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(_error!,
                          style: TextStyle(color: color.onErrorContainer)),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (_columnas.isNotEmpty) ...[
            const SizedBox(height: 16),
            _Mapeo(
              columnas: _columnas,
              mapeo: _mapeo,
              onCambio: () => _recalcularPrevio(),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('3. Vista previa',
                            style: Theme.of(context).textTheme.titleMedium),
                        const Spacer(),
                        Text('$filasParaImportar de ${_previo.length} se importarán',
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (!_mapeo.esValido)
                      Text(
                        'Indica qué columna contiene el nombre del piloto.',
                        style: TextStyle(color: color.error),
                      )
                    else if (_previo.isEmpty)
                      const Text('No se han encontrado filas válidas.')
                    else
                      ..._previo.asMap().entries.map(
                            (e) => _FilaPrevia(
                              fila: e.value,
                              onToggle: () => setState(
                                  () => e.value.importar = !e.value.importar),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: (_trabajando || filasParaImportar == 0 || !_mapeo.esValido)
                  ? null
                  : _importar,
              icon: _trabajando
                  ? const SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cloud_download_outlined),
              label: Text('Importar $filasParaImportar pilotos'),
            ),
          ],
        ],
      ),
    );
  }
}

class _Mapeo extends StatelessWidget {
  const _Mapeo({
    required this.columnas,
    required this.mapeo,
    required this.onCambio,
  });

  final List<String> columnas;
  final MapeoColumnas mapeo;
  final VoidCallback onCambio;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('2. Asigna las columnas',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              'Hemos intentado detectarlas automáticamente. Cámbialas si hace falta.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            _selector(context, 'Nombre del piloto *', mapeo.colNombre,
                (v) { mapeo.colNombre = v; onCambio(); }),
            _selector(context, 'Categoría (metal)', mapeo.colCategoria,
                (v) { mapeo.colCategoria = v; onCambio(); }),
            _selector(context, 'Créditos iniciales', mapeo.colCreditosIniciales,
                (v) { mapeo.colCreditosIniciales = v; onCambio(); }),
            _selector(context, 'Créditos actuales', mapeo.colCreditosActuales,
                (v) { mapeo.colCreditosActuales = v; onCambio(); }),
            _selector(context, 'Palmarés', mapeo.colPalmares,
                (v) { mapeo.colPalmares = v; onCambio(); }),
          ],
        ),
      ),
    );
  }

  Widget _selector(BuildContext context, String label, String? actual,
      ValueChanged<String?> onCambio) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DropdownButtonFormField<String?>(
        initialValue: actual,
        isExpanded: true,
        decoration: InputDecoration(labelText: label, isDense: true),
        items: [
          const DropdownMenuItem(value: null, child: Text('— ninguna —')),
          ...columnas.map((c) => DropdownMenuItem(value: c, child: Text(c))),
        ],
        onChanged: onCambio,
      ),
    );
  }
}

class _FilaPrevia extends StatelessWidget {
  const _FilaPrevia({required this.fila, required this.onToggle});

  final PilotoImportado fila;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    Color colorEstado;
    String etiquetaEstado;
    switch (fila.estado) {
      case 'ya_inscrito':
        colorEstado = cs.outline;
        etiquetaEstado = 'Ya inscrito';
      case 'inscribir':
        colorEstado = cs.secondary;
        etiquetaEstado = 'Inscribir';
      default:
        colorEstado = cs.primary;
        etiquetaEstado = 'Nuevo';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Checkbox(
            value: fila.importar,
            onChanged: fila.estado == 'ya_inscrito' ? null : (_) => onToggle(),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fila.nombre,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          decoration: fila.importar
                              ? null
                              : TextDecoration.lineThrough,
                          color: fila.importar ? null : cs.outline,
                        )),
                Wrap(
                  spacing: 8,
                  children: [
                    if (fila.categoria != null)
                      Text(fila.categoria!,
                          style: TextStyle(color: cs.outline, fontSize: 13)),
                    if (fila.creditosIniciales != null)
                      Text('${fila.creditosIniciales} créd.',
                          style: TextStyle(color: cs.outline, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: colorEstado.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(etiquetaEstado,
                style: TextStyle(
                  color: colorEstado,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                )),
          ),
        ],
      ),
    );
  }
}
