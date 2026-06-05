import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import 'importador_resultados.dart';
import 'pantalla_resultados_prueba.dart';
import 'repositorio_resultados.dart';

class PantallaImportarResultadosPrueba extends ConsumerStatefulWidget {
  const PantallaImportarResultadosPrueba({super.key, required this.pruebaId});
  final int pruebaId;

  @override
  ConsumerState<PantallaImportarResultadosPrueba> createState() =>
      _PantallaImportarResultadosPruebaState();
}

class _PantallaImportarResultadosPruebaState
    extends ConsumerState<PantallaImportarResultadosPrueba> {
  String? _archivo;
  bool _trabajando = false;
  String? _error;
  List<FilaResultadoImportada> _filas = [];

  /// Por cada equipo del archivo, en qué manga está inscrito dentro de la prueba.
  Map<int, int> _mangaPorEquipo = {};
  bool _sinMangas = false;
  bool _crearMangaSiFalta = true;

  Future<void> _elegirArchivo() async {
    setState(() {
      _trabajando = true;
      _error = null;
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
      final filas = await ImportadorResultados.leerArchivo(xfile.path);
      if (filas.isEmpty) {
        _error =
            'No se encontraron resultados. El archivo debe tener columnas como '
            '"Posición" y "Nombre" (formato TicTacSlot o similar).';
        _filas = [];
      } else {
        await _cruzarConBD(filas);
      }
    } catch (e) {
      _error = 'No se pudo leer el archivo: $e';
    } finally {
      if (mounted) setState(() => _trabajando = false);
    }
  }

  Future<void> _cruzarConBD(List<FilaResultadoImportada> filas) async {
    final activo = ref.read(campeonatoActivoProvider);
    if (activo == null) return;
    final db = ref.read(dbProvider);

    final equipos = await (db.select(db.equipos)
          ..where((t) => t.campeonatoId.equals(activo.id)))
        .get();
    final porNombre = {for (final e in equipos) _norm(e.nombre): e};

    _mangaPorEquipo = await mangaPorEquipoEnPrueba(db, widget.pruebaId);
    final mangas = await (db.select(db.mangas)
          ..where((t) => t.pruebaId.equals(widget.pruebaId)))
        .get();
    _sinMangas = mangas.isEmpty;

    for (final f in filas) {
      final eq = porNombre[_norm(f.nombreEquipoNormalizado)];
      if (eq == null) {
        f.estado = 'equipo_no_existe';
        f.importar = false;
      } else if (_mangaPorEquipo.containsKey(eq.id)) {
        f.estado = 'ok';
        f.equipoIdCoincidente = eq.id;
      } else {
        f.estado = 'no_inscrito';
        f.equipoIdCoincidente = eq.id;
      }
    }
    _filas = filas;
  }

  static String _norm(String s) =>
      s.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();

  Future<int> _asegurarMangaGeneral() async {
    final db = ref.read(dbProvider);
    final mangas = await (db.select(db.mangas)
          ..where((t) => t.pruebaId.equals(widget.pruebaId)))
        .get();
    if (mangas.isNotEmpty) return mangas.first.id;
    final id = await db.into(db.mangas).insert(
          MangasCompanion.insert(
            pruebaId: widget.pruebaId,
            nombre: 'Resultados generales',
          ),
        );
    return id;
  }

  Future<void> _importar() async {
    final activo = ref.read(campeonatoActivoProvider)!;
    final db = ref.read(dbProvider);
    final repoRes = ref.read(repoResultadosProvider);
    setState(() => _trabajando = true);
    int ok = 0, saltados = 0, inscritosAuto = 0;
    try {
      // Si no hay ninguna manga aún, creamos una "generales" para alojar los resultados.
      int? mangaFallback;
      if (_sinMangas && _crearMangaSiFalta) {
        mangaFallback = await _asegurarMangaGeneral();
        _sinMangas = false;
      }

      for (final f in _filas) {
        if (!f.importar || f.equipoIdCoincidente == null) {
          saltados++;
          continue;
        }
        int? mangaId = _mangaPorEquipo[f.equipoIdCoincidente!];
        if (mangaId == null) {
          if (mangaFallback == null && _crearMangaSiFalta) {
            mangaFallback = await _asegurarMangaGeneral();
          }
          if (mangaFallback == null) {
            saltados++;
            continue;
          }
          // Inscribirlo en la manga fallback
          await db.into(db.inscripciones).insert(
                InscripcionesCompanion.insert(
                  mangaId: mangaFallback,
                  equipoId: f.equipoIdCoincidente!,
                ),
              );
          mangaId = mangaFallback;
          _mangaPorEquipo[f.equipoIdCoincidente!] = mangaId;
          inscritosAuto++;
        }
        await repoRes.asignarPosicionEquipo(
          mangaId: mangaId,
          equipoId: f.equipoIdCoincidente!,
          campeonatoId: activo.id,
          posicion: f.posicion,
        );
        ok++;
      }
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Importación completada'),
          content: Text(
            '✓ Resultados aplicados: $ok\n'
            '+ Inscritos automáticamente: $inscritosAuto\n'
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
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _trabajando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final n = _filas.where((f) => f.importar).length;
    final desconocidos =
        _filas.where((f) => f.estado == 'equipo_no_existe').length;

    return Scaffold(
      appBar: AppBar(title: const Text('Importar resultados de la prueba')),
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
                    'Importa el archivo del sistema de cronometraje (TicTacSlot, SloTime…). '
                    'Cada equipo del archivo se asigna a la manga de esta prueba '
                    'donde esté inscrito.',
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
                          child: Text(_archivo!.split('/').last,
                              overflow: TextOverflow.ellipsis),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Card(
              color: cs.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: cs.onErrorContainer),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(_error!,
                          style: TextStyle(color: cs.onErrorContainer)),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (_filas.isNotEmpty) ...[
            const SizedBox(height: 16),
            if (_sinMangas)
              SwitchListTile(
                value: _crearMangaSiFalta,
                onChanged: (v) => setState(() => _crearMangaSiFalta = v),
                title: const Text('Crear manga "Resultados generales"'),
                subtitle: const Text(
                    'La prueba no tiene mangas aún. Marcamos los resultados en una manga creada al vuelo.'),
              ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('2. Vista previa',
                            style: Theme.of(context).textTheme.titleMedium),
                        const Spacer(),
                        Text('$n de ${_filas.length} se aplicarán'),
                      ],
                    ),
                    if (desconocidos > 0) ...[
                      const SizedBox(height: 8),
                      Text(
                        '⚠️ $desconocidos equipos del archivo no existen en el campeonato.',
                        style: TextStyle(color: cs.error),
                      ),
                    ],
                    const SizedBox(height: 8),
                    ..._filas.map((f) => _FilaPrevia(
                          fila: f,
                          onToggle: () => setState(() {
                            if (f.estado != 'equipo_no_existe') {
                              f.importar = !f.importar;
                            }
                          }),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: (_trabajando || n == 0) ? null : _importar,
              icon: _trabajando
                  ? const SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.check),
              label: Text('Aplicar resultados a $n equipos'),
            ),
          ],
        ],
      ),
    );
  }
}

class _FilaPrevia extends StatelessWidget {
  const _FilaPrevia({required this.fila, required this.onToggle});
  final FilaResultadoImportada fila;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    Color color;
    String etiqueta;
    switch (fila.estado) {
      case 'equipo_no_existe':
        color = cs.error;
        etiqueta = 'No existe';
      case 'no_inscrito':
        color = Colors.orange.shade700;
        etiqueta = 'Se inscribirá';
      default:
        color = cs.primary;
        etiqueta = 'Aplicar';
    }
    final bloqueado = fila.estado == 'equipo_no_existe';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Checkbox(
            value: fila.importar,
            onChanged: bloqueado ? null : (_) => onToggle(),
          ),
          Container(
            width: 32, height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Text('${fila.posicion}',
                style: TextStyle(
                    color: cs.onPrimaryContainer,
                    fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fila.nombreEquipoNormalizado,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    decoration:
                        fila.importar ? null : TextDecoration.lineThrough,
                    color: fila.importar ? null : cs.outline,
                  ),
                ),
                if (fila.copaDetectada != null || fila.vueltas != null)
                  Text(
                    [
                      if (fila.copaDetectada != null) 'Copa ${fila.copaDetectada}',
                      if (fila.vueltas != null) '${fila.vueltas} vueltas',
                    ].join('  ·  '),
                    style: TextStyle(color: cs.outline, fontSize: 12),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(etiqueta,
                style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
