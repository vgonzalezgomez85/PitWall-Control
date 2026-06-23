import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import 'repositorio_clasificacion.dart';
import 'repositorio_clasificacion_manual.dart';

/// Editor de clasificación a mano: rejilla pilotos × pruebas donde se teclean
/// los puntos. Cada casilla se guarda al salir del campo.
class PantallaEditorClasificacionManual extends ConsumerStatefulWidget {
  const PantallaEditorClasificacionManual({super.key, this.copa});

  /// Si no es null, el editor solo muestra los pilotos de esa copa.
  final String? copa;

  @override
  ConsumerState<PantallaEditorClasificacionManual> createState() => _State();
}

class _State extends ConsumerState<PantallaEditorClasificacionManual> {
  DatosEditorManual? _datos;
  bool _cargando = true;
  String? _error;

  // Un controlador por casilla, clave "pilotoId-pruebaId".
  final Map<String, TextEditingController> _ctrls = {};
  // Texto original de cada casilla, para guardar solo lo que cambie.
  final Map<String, String> _orig = {};
  final _scrollV = ScrollController();
  final _scrollH = ScrollController();

  String _k(int pilotoId, int pruebaId) => '$pilotoId-$pruebaId';

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final activo = ref.read(campeonatoActivoProvider);
    if (activo == null) {
      setState(() {
        _cargando = false;
        _error = 'No hay campeonato activo.';
      });
      return;
    }
    try {
      DatosEditorManual datos;
      if (widget.copa == null) {
        // General: puntos efectivos (resultados + override general).
        datos = await ref
            .read(repoClasificacionManualProvider)
            .cargar(activo.id);
      } else {
        // Copa: se editan los puntos YA calculados de la copa (re-ranking +
        // correcciones). Lo que se teclee se guarda como override de copa.
        // Una fila por PILOTO (clasificación individual): editar afecta solo
        // a ese piloto, aunque su compañero de equipo comparta puntos.
        final clasif = await ref.read(clasificacionProvider.future);
        final filasCopa = clasif.porCopa[widget.copa] ?? const [];
        datos = DatosEditorManual(
          clasif.pruebas,
          [
            for (final f in filasCopa)
              FilaEditorManual(
                pilotoId: f.pilotoId,
                equipoId: f.equipoId,
                pilotoNombre: f.pilotoNombre,
                equipoNombre: f.equipoNombre,
                copa: f.copa,
                puntos: Map<int, int>.from(f.puntosPorPrueba),
                pilotosAfectados: [f.pilotoId],
              ),
          ]..sort((a, b) => a.pilotoNombre
              .toLowerCase()
              .compareTo(b.pilotoNombre.toLowerCase())),
        );
      }
      for (final f in datos.filas) {
        for (final p in datos.pruebas) {
          final v = f.puntos[p.id];
          final txt = v?.toString() ?? '';
          _ctrls[_k(f.pilotoId, p.id)] = TextEditingController(text: txt);
          _orig[_k(f.pilotoId, p.id)] = txt;
        }
      }
      if (mounted) {
        setState(() {
          _datos = datos;
          _cargando = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = '$e';
          _cargando = false;
        });
      }
    }
  }

  @override
  void dispose() {
    for (final c in _ctrls.values) {
      c.dispose();
    }
    _scrollV.dispose();
    _scrollH.dispose();
    super.dispose();
  }

  Future<void> _guardarCasilla(FilaEditorManual f, Prueba p) async {
    final key = _k(f.pilotoId, p.id);
    final texto = _ctrls[key]!.text.trim();
    if (texto == (_orig[key] ?? '')) return; // sin cambios: no tocar nada
    int? puntos;
    if (texto.isNotEmpty) {
      puntos = int.tryParse(texto);
      if (puntos == null) return; // texto inválido: no tocar nada
    }
    final activo = ref.read(campeonatoActivoProvider);
    final repo = ref.read(repoClasificacionManualProvider);
    _orig[key] = texto;
    if (widget.copa != null && activo != null) {
      // Corrección manual de la copa: prevalece sobre el re-ranking, y afecta
      // a los dos pilotos del equipo (los puntos de copa son por equipo).
      for (final pid in f.pilotosAfectados) {
        await repo.guardarOverrideCopa(
          campeonatoId: activo.id,
          copa: widget.copa!,
          pruebaId: p.id,
          pilotoId: pid,
          puntos: puntos,
        );
      }
    } else {
      await repo.guardarPunto(
        pruebaId: p.id,
        equipoId: f.equipoId,
        pilotoId: f.pilotoId,
        puntos: puntos,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.copa == null
              ? 'Clasificación a mano'
              : 'Clasificación a mano · ${widget.copa}')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : _datos!.pruebas.isEmpty
                  ? _aviso('Este campeonato no tiene pruebas. Crea pruebas '
                      'primero para poder asignar puntos.')
                  : _datos!.filas.isEmpty
                      ? _aviso('No hay pilotos con equipo en este campeonato. '
                          'Asigna equipos a los pilotos primero.')
                      : Column(
                          children: [
                            Container(
                              width: double.infinity,
                              color: cs.surfaceContainer,
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Icon(Icons.edit_note,
                                      size: 18, color: cs.outline),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'Escribe los puntos de cada piloto por prueba. '
                                      'Se guardan solos al salir de cada casilla. '
                                      'Casilla vacía = no puntuó; 0 = participó con 0.',
                                      style: TextStyle(
                                          color: cs.outline, fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(child: _tabla(cs)),
                          ],
                        ),
    );
  }

  Widget _aviso(String texto) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(texto, textAlign: TextAlign.center),
        ),
      );

  Widget _tabla(ColorScheme cs) {
    final d = _datos!;
    return Scrollbar(
      controller: _scrollV,
      thumbVisibility: true,
      child: Scrollbar(
        controller: _scrollH,
        thumbVisibility: true,
        notificationPredicate: (n) => n.metrics.axis == Axis.horizontal,
        child: SingleChildScrollView(
          controller: _scrollV,
          child: SingleChildScrollView(
            controller: _scrollH,
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 14,
              headingRowColor: WidgetStatePropertyAll(cs.surfaceContainer),
              columns: [
                const DataColumn(label: Text('Piloto')),
                for (final p in d.pruebas)
                  DataColumn(
                    numeric: true,
                    label: SizedBox(
                      width: 64,
                      child: Text(
                        p.nombre,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
              ],
              rows: [
                for (final f in d.filas)
                  DataRow(cells: [
                    DataCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(f.pilotoNombre,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          Text('${f.equipoNombre} · ${f.copa}',
                              style: TextStyle(
                                  color: cs.outline, fontSize: 11)),
                        ],
                      ),
                    ),
                    for (final p in d.pruebas)
                      DataCell(_campo(f, p)),
                  ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _campo(FilaEditorManual f, Prueba p) {
    return SizedBox(
      width: 56,
      child: TextField(
        controller: _ctrls[_k(f.pilotoId, p.id)],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          hintText: '—',
        ),
        // Guardado inmediato al teclear (no depende de salir de la casilla).
        onChanged: (_) => _guardarCasilla(f, p),
        onTapOutside: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
          _guardarCasilla(f, p);
        },
        onSubmitted: (_) => _guardarCasilla(f, p),
      ),
    );
  }
}
