import 'package:drift/drift.dart' show Value;
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import '../pilotos/repositorio_pilotos.dart';
import 'importador_equipos.dart';
import 'repositorio_equipos.dart';

class PantallaImportarEquipos extends ConsumerStatefulWidget {
  const PantallaImportarEquipos({super.key});

  @override
  ConsumerState<PantallaImportarEquipos> createState() =>
      _PantallaImportarEquiposState();
}

class _PantallaImportarEquiposState
    extends ConsumerState<PantallaImportarEquipos> {
  String? _archivo;
  List<String> _columnas = [];
  List<Map<String, String>> _filasArchivo = [];
  MapeoColumnasEquipo _mapeo = MapeoColumnasEquipo();
  List<EquipoImportado> _previo = [];
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
      final res = await ImportadorEquipos.leerArchivo(xfile.path);
      _columnas = res.columnas;
      _filasArchivo = res.filas;
      _mapeo = ImportadorEquipos.detectarMapeo(_columnas);
      await _recalcular();
    } catch (e) {
      _error = 'No se pudo leer el archivo: $e';
    } finally {
      if (mounted) setState(() => _trabajando = false);
    }
  }

  Future<void> _recalcular() async {
    final filas = ImportadorEquipos.transformar(_filasArchivo, _mapeo);
    final activo = ref.read(campeonatoActivoProvider);
    if (activo == null) {
      setState(() => _previo = filas);
      return;
    }
    final db = ref.read(dbProvider);
    final equipos = await (db.select(db.equipos)
          ..where((t) => t.campeonatoId.equals(activo.id)))
        .get();
    final nombresEquipo = {for (final e in equipos) _norm(e.nombre)};

    final esPareja = activo.formato == 'PAREJAS';
    for (final f in filas) {
      if (f.piloto1Nombre.isEmpty) {
        f.estado = 'sin_piloto';
        f.importar = false;
        f.aviso = 'Sin piloto';
        continue;
      }
      if (esPareja && (f.piloto2Nombre == null || f.piloto2Nombre!.isEmpty)) {
        f.aviso = 'Falta el segundo piloto (campeonato por parejas)';
      }
      if (nombresEquipo.contains(_norm(f.nombreEquipo))) {
        f.estado = 'equipo_existe';
        f.importar = false;
      }
    }

    if (mounted) setState(() => _previo = filas);
  }

  static String _norm(String s) =>
      s.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();

  Future<void> _importar() async {
    final activo = ref.read(campeonatoActivoProvider)!;
    final db = ref.read(dbProvider);
    final repoEq = ref.read(repoEquiposProvider);
    final repoPi = ref.read(repoPilotosProvider);
    setState(() => _trabajando = true);

    int equiposCreados = 0, pilotosNuevos = 0, pilotosInscritos = 0, saltados = 0;
    try {
      final maestro = await db.select(db.pilotos).get();
      final porNombre = {for (final p in maestro) _norm(p.nombre): p};
      final inscritos = await (db.select(db.pilotoCampeonato)
            ..where((t) => t.campeonatoId.equals(activo.id)))
          .get();
      final idsInscritos = inscritos.map((e) => e.pilotoId).toSet();

      Future<int> obtenerOCrearPiloto({
        required String nombre,
        String? email,
        String? telefono,
        String? categoria,
        String? palmares,
      }) async {
        final existente = porNombre[_norm(nombre)];
        if (existente != null) {
          // Inscribir si no estaba en este campeonato
          if (!idsInscritos.contains(existente.id)) {
            final cat = (categoria != null && categorias.contains(categoria))
                ? categoria
                : 'BRONCE';
            final ini =
                creditosInicialesPorCategoria[cat] ?? 28;
            await repoPi.inscribirEnCampeonato(
              pilotoId: existente.id,
              campeonatoId: activo.id,
              categoria: cat,
              creditosIniciales: ini,
            );
            idsInscritos.add(existente.id);
            pilotosInscritos++;
          }
          // Completar campos vacíos del maestro
          if (((existente.email ?? '').isEmpty && (email ?? '').isNotEmpty) ||
              ((existente.telefono ?? '').isEmpty && (telefono ?? '').isNotEmpty) ||
              ((existente.palmaresGlobal ?? '').isEmpty &&
                  (palmares ?? '').isNotEmpty)) {
            await (db.update(db.pilotos)
                  ..where((t) => t.id.equals(existente.id)))
                .write(PilotosCompanion(
              email: Value(email ?? existente.email),
              telefono: Value(telefono ?? existente.telefono),
              palmaresGlobal: Value(palmares ?? existente.palmaresGlobal),
            ));
          }
          return existente.id;
        }
        final cat = (categoria != null && categorias.contains(categoria))
            ? categoria
            : 'BRONCE';
        final ini = creditosInicialesPorCategoria[cat] ?? 28;
        final id = await repoPi.crear(
          nombre: nombre,
          email: email,
          telefono: telefono,
          palmaresGlobal: palmares,
          campeonatoId: activo.id,
          categoria: cat,
          creditosIniciales: ini,
        );
        // Reflejar en mapa local
        porNombre[_norm(nombre)] = Piloto(
          id: id,
          nombre: nombre,
          palmaresGlobal: palmares,
          telefono: telefono,
          email: email,
          esCoordinadora: false,
          creadoEn: DateTime.now(),
        );
        idsInscritos.add(id);
        pilotosNuevos++;
        return id;
      }

      for (final f in _previo) {
        if (!f.importar) {
          saltados++;
          continue;
        }
        final p1Id = await obtenerOCrearPiloto(
          nombre: f.piloto1Nombre,
          email: f.piloto1Email,
          telefono: f.piloto1Telefono,
          categoria: f.piloto1Categoria,
          palmares: f.piloto1Palmares,
        );
        int? p2Id;
        if (f.piloto2Nombre != null && f.piloto2Nombre!.isNotEmpty) {
          p2Id = await obtenerOCrearPiloto(
            nombre: f.piloto2Nombre!,
            email: f.piloto2Email,
            telefono: f.piloto2Telefono,
            categoria: f.piloto2Categoria,
            palmares: f.piloto2Palmares,
          );
        }

        final copa = (f.copa != null && f.copa!.isNotEmpty) ? f.copa! : 'GT';
        await repoEq.crear(
          campeonatoId: activo.id,
          nombre: f.nombreEquipo,
          copa: copa,
          piloto1Id: p1Id,
          piloto2Id: p2Id,
        );
        equiposCreados++;
      }

      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Importación completada'),
          content: Text(
            '✓ Equipos creados: $equiposCreados\n'
            '✓ Pilotos nuevos: $pilotosNuevos\n'
            '✓ Pilotos inscritos al campeonato: $pilotosInscritos\n'
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
    final cs = Theme.of(context).colorScheme;
    final paraImportar = _previo.where((f) => f.importar).length;
    final activo = ref.watch(campeonatoActivoProvider);
    final esPareja = activo?.formato == 'PAREJAS';

    return Scaffold(
      appBar: AppBar(title: const Text('Importar equipos')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            color: cs.surfaceContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('1. Elige el archivo',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Sube el CSV o Excel del Google Form de pretemporada. '
                    'Cada fila debe ser un equipo con el nombre del equipo y '
                    '${esPareja ? "sus dos pilotos" : "su piloto"}.',
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
              color: cs.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: cs.onErrorContainer),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(_error!,
                          style: TextStyle(color: cs.onErrorContainer)),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (_columnas.isNotEmpty) ...[
            const SizedBox(height: 16),
            _MapeoEquipos(
              columnas: _columnas,
              mapeo: _mapeo,
              esPareja: esPareja,
              onCambio: _recalcular,
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
                        Text('$paraImportar de ${_previo.length} se importarán',
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (!_mapeo.esValido)
                      Text(
                        'Asigna al menos la columna del nombre del equipo y la del primer piloto.',
                        style: TextStyle(color: cs.error),
                      )
                    else if (_previo.isEmpty)
                      const Text('No se han encontrado filas válidas.')
                    else
                      ..._previo.asMap().entries.map(
                            (e) => _FilaPrevia(
                              fila: e.value,
                              onToggle: () => setState(() {
                                if (e.value.estado != 'equipo_existe' &&
                                    e.value.estado != 'sin_piloto') {
                                  e.value.importar = !e.value.importar;
                                }
                              }),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: (_trabajando || paraImportar == 0 || !_mapeo.esValido)
                  ? null
                  : _importar,
              icon: _trabajando
                  ? const SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cloud_download_outlined),
              label: Text('Importar $paraImportar equipos'),
            ),
          ],
        ],
      ),
    );
  }
}

class _MapeoEquipos extends StatelessWidget {
  const _MapeoEquipos({
    required this.columnas,
    required this.mapeo,
    required this.esPareja,
    required this.onCambio,
  });

  final List<String> columnas;
  final MapeoColumnasEquipo mapeo;
  final bool esPareja;
  final Future<void> Function() onCambio;

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
              'Hemos intentado detectarlas. Cambia las que no estén bien.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            _SecHead('Equipo'),
            _sel(context, 'Nombre del equipo *', mapeo.colEquipo,
                (v) { mapeo.colEquipo = v; onCambio(); }),
            _sel(context, 'Copa / categoría', mapeo.colCopa,
                (v) { mapeo.colCopa = v; onCambio(); }),
            const SizedBox(height: 12),
            _SecHead('Piloto 1'),
            _sel(context, 'Nombre *', mapeo.colP1Nombre,
                (v) { mapeo.colP1Nombre = v; onCambio(); }),
            _sel(context, 'Email', mapeo.colP1Email,
                (v) { mapeo.colP1Email = v; onCambio(); }),
            _sel(context, 'Teléfono', mapeo.colP1Telefono,
                (v) { mapeo.colP1Telefono = v; onCambio(); }),
            _sel(context, 'Categoría', mapeo.colP1Categoria,
                (v) { mapeo.colP1Categoria = v; onCambio(); }),
            _sel(context, 'Palmarés', mapeo.colP1Palmares,
                (v) { mapeo.colP1Palmares = v; onCambio(); }),
            const SizedBox(height: 12),
            _SecHead(esPareja ? 'Piloto 2' : 'Piloto 2 (opcional)'),
            _sel(context, 'Nombre', mapeo.colP2Nombre,
                (v) { mapeo.colP2Nombre = v; onCambio(); }),
            _sel(context, 'Email', mapeo.colP2Email,
                (v) { mapeo.colP2Email = v; onCambio(); }),
            _sel(context, 'Teléfono', mapeo.colP2Telefono,
                (v) { mapeo.colP2Telefono = v; onCambio(); }),
            _sel(context, 'Categoría', mapeo.colP2Categoria,
                (v) { mapeo.colP2Categoria = v; onCambio(); }),
            _sel(context, 'Palmarés', mapeo.colP2Palmares,
                (v) { mapeo.colP2Palmares = v; onCambio(); }),
          ],
        ),
      ),
    );
  }

  Widget _sel(BuildContext context, String label, String? actual,
      ValueChanged<String?> onChange) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: DropdownButtonFormField<String?>(
        initialValue: actual,
        isExpanded: true,
        decoration: InputDecoration(labelText: label, isDense: true),
        items: [
          const DropdownMenuItem(value: null, child: Text('— ninguna —')),
          ...columnas.map((c) => DropdownMenuItem(value: c, child: Text(c))),
        ],
        onChanged: onChange,
      ),
    );
  }
}

class _SecHead extends StatelessWidget {
  const _SecHead(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary,
              )),
    );
  }
}

class _FilaPrevia extends StatelessWidget {
  const _FilaPrevia({required this.fila, required this.onToggle});
  final EquipoImportado fila;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    Color colorEstado;
    String etiqueta;
    switch (fila.estado) {
      case 'equipo_existe':
        colorEstado = cs.outline;
        etiqueta = 'Ya existe';
      case 'sin_piloto':
        colorEstado = cs.error;
        etiqueta = 'Sin piloto';
      default:
        colorEstado = cs.primary;
        etiqueta = 'Nuevo';
    }

    final esBloqueado =
        fila.estado == 'equipo_existe' || fila.estado == 'sin_piloto';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: fila.importar,
            onChanged: esBloqueado ? null : (_) => onToggle(),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fila.nombreEquipo,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          decoration: fila.importar
                              ? null
                              : TextDecoration.lineThrough,
                          color: fila.importar ? null : cs.outline,
                        )),
                Text(
                  fila.piloto2Nombre == null
                      ? fila.piloto1Nombre
                      : '${fila.piloto1Nombre} + ${fila.piloto2Nombre}',
                  style: TextStyle(color: cs.onSurfaceVariant),
                ),
                if (fila.copa != null)
                  Text('Copa: ${fila.copa}',
                      style: TextStyle(color: cs.outline, fontSize: 12)),
                if (fila.aviso != null)
                  Text(fila.aviso!,
                      style: TextStyle(color: cs.error, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: colorEstado.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(etiqueta,
                style: TextStyle(
                  color: colorEstado, fontSize: 12, fontWeight: FontWeight.w600,
                )),
          ),
        ],
      ),
    );
  }
}
