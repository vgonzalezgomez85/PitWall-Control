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
import 'package:drift/drift.dart' show innerJoin;
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/idioma.dart';
import '../../core/proveedores.dart';
import '../../domain/errores_importacion.dart';
import 'importador_puntuacion_previa.dart';
import 'repositorio_pilotos.dart';

/// Importa la puntuación de temporada anterior de los pilotos YA inscritos
/// en el campeonato activo (cruzando por nombre). Esa puntuación solo se
/// usa como semilla de orden para "Generar mangas" en la primera prueba;
/// en cuanto el campeonato tenga resultados propios, la clasificación real
/// toma el relevo automáticamente.
class PantallaImportarPuntuacion extends ConsumerStatefulWidget {
  const PantallaImportarPuntuacion({super.key});

  @override
  ConsumerState<PantallaImportarPuntuacion> createState() =>
      _PantallaImportarPuntuacionState();
}

class _PantallaImportarPuntuacionState
    extends ConsumerState<PantallaImportarPuntuacion> {
  String? _archivo;
  List<String> _columnas = [];
  List<Map<String, String>> _filasArchivo = [];
  MapeoPuntuacion _mapeo = MapeoPuntuacion();
  List<PuntuacionImportada> _previo = [];
  bool _trabajando = false;
  String? _error;

  Future<void> _elegirArchivo() async {
    final l = context.l;
    setState(() {
      _error = null;
      _trabajando = true;
    });
    try {
      final xfile = await openFile(acceptedTypeGroups: [
        XTypeGroup(
            label: l.archivos, extensions: ['csv', 'xlsx', 'xls']),
      ]);
      if (xfile == null) {
        setState(() => _trabajando = false);
        return;
      }
      _archivo = xfile.path;
      final res = await ImportadorPuntuacionPrevia.leerArchivo(xfile.path);
      _columnas = res.columnas;
      _filasArchivo = res.filas;
      _mapeo = ImportadorPuntuacionPrevia.detectarMapeo(_columnas);
      await _recalcularPrevio();
    } on FormatoNoSoportado catch (e) {
      _error = l.formatoNoSoportadoUsaCsv(e.extension);
    } catch (e) {
      _error = l.noSePudoLeerArchivo('$e');
    } finally {
      if (mounted) setState(() => _trabajando = false);
    }
  }

  Future<void> _recalcularPrevio() async {
    final filas = ImportadorPuntuacionPrevia.transformar(_filasArchivo, _mapeo);
    final activo = ref.read(campeonatoActivoProvider);
    if (activo == null) {
      setState(() => _previo = filas);
      return;
    }
    final db = ref.read(dbProvider);
    final inscritos = await (db.select(db.pilotoCampeonato).join([
      innerJoin(db.pilotos, db.pilotos.id.equalsExp(db.pilotoCampeonato.pilotoId)),
    ])
          ..where(db.pilotoCampeonato.campeonatoId.equals(activo.id)))
        .get();
    final porNombre = {
      for (final row in inscritos)
        _norm(row.readTable(db.pilotos).nombre): row.readTable(db.pilotos).id,
    };
    for (final f in filas) {
      final id = porNombre[_norm(f.nombre)];
      if (id == null) {
        f.estado = 'no_existe';
        f.importar = false;
      } else {
        f.estado = 'ok';
        f.pilotoId = id;
      }
    }
    if (mounted) setState(() => _previo = filas);
  }

  static String _norm(String s) =>
      s.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();

  Future<void> _importar() async {
    final activo = ref.read(campeonatoActivoProvider)!;
    final repo = ref.read(repoPilotosProvider);
    setState(() => _trabajando = true);
    var ok = 0, saltados = 0;
    try {
      for (final f in _previo) {
        if (!f.importar || f.pilotoId == null) {
          saltados++;
          continue;
        }
        await repo.actualizarSaldoAnterior(
          pilotoId: f.pilotoId!,
          campeonatoId: activo.id,
          saldo: f.puntuacion,
        );
        ok++;
      }
      if (!mounted) return;
      final l = context.l;
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(l.puntuacionImportada),
          content: Text(l.puntuacionImportadaTexto(ok, saltados)),
          actions: [
            FilledButton(
                onPressed: () => Navigator.pop(context), child: Text(l.ok)),
          ],
        ),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l.errorDetalle('$e'))));
    } finally {
      if (mounted) setState(() => _trabajando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final paraImportar = _previo.where((f) => f.importar).length;

    return Scaffold(
      appBar: AppBar(title: Text(context.l.importarPuntuacionPrevia)),
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
                  Text(context.l.paso1EligeArchivo,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    context.l.puntuacionPreviaTexto,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      FilledButton.icon(
                        onPressed: _trabajando ? null : _elegirArchivo,
                        icon: const Icon(Icons.folder_open),
                        label: Text(context.l.elegirArchivo),
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
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.l.paso2AsignaLasColumnas,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    _selector(context, context.l.nombreDelPilotoObligatorio,
                        _mapeo.colNombre, (v) {
                      setState(() => _mapeo.colNombre = v);
                      _recalcularPrevio();
                    }),
                    _selector(context, context.l.puntuacionObligatoria,
                        _mapeo.colPuntuacion, (v) {
                      setState(() => _mapeo.colPuntuacion = v);
                      _recalcularPrevio();
                    }),
                  ],
                ),
              ),
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
                        Text(context.l.paso3VistaPrevia,
                            style: Theme.of(context).textTheme.titleMedium),
                        const Spacer(),
                        Text(
                            context.l.nDeTotalSeActualizaran(
                                paraImportar, _previo.length),
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (!_mapeo.esValido)
                      Text(
                        context.l.indicaColumnaNombreYPuntuacion,
                        style: TextStyle(color: cs.error),
                      )
                    else if (_previo.isEmpty)
                      Text(context.l.noFilasValidas)
                    else
                      ..._previo.map((f) => _FilaPrevia(
                            fila: f,
                            onToggle: () =>
                                setState(() => f.importar = !f.importar),
                          )),
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
              label: Text(context.l.actualizarNPilotos(paraImportar)),
            ),
          ],
        ],
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
          DropdownMenuItem(value: null, child: Text(context.l.ninguna)),
          ..._columnas.map((c) => DropdownMenuItem(value: c, child: Text(c))),
        ],
        onChanged: onCambio,
      ),
    );
  }
}

class _FilaPrevia extends StatelessWidget {
  const _FilaPrevia({required this.fila, required this.onToggle});
  final PuntuacionImportada fila;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final noExiste = fila.estado == 'no_existe';
    final avisar = noExiste || fila.esFormulaSinValor;
    String etiqueta;
    if (noExiste) {
      etiqueta = context.l.noEstaEnCampeonato;
    } else if (fila.esFormulaSinValor) {
      etiqueta = context.l.formulaSinCalcular;
    } else {
      etiqueta = context.l.seActualizara;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Checkbox(
            value: fila.importar,
            onChanged: noExiste ? null : (_) => onToggle(),
          ),
          Expanded(
            child: Text(fila.nombre,
                style: TextStyle(
                    color: noExiste ? cs.outline : null,
                    decoration: noExiste ? TextDecoration.lineThrough : null)),
          ),
          Text(fila.esFormulaSinValor ? '—' : '${fila.puntuacion} pts',
              style: TextStyle(color: cs.outline, fontSize: 13)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: (avisar ? cs.errorContainer : cs.secondaryContainer)
                  .withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              etiqueta,
              style: TextStyle(
                  color: avisar ? cs.onErrorContainer : cs.onSecondaryContainer,
                  fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
