import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../services/google_auth_service.dart';
import '../../services/google_sheets_service.dart';
import 'importador_clasificacion.dart';

class PantallaImportarClasificacion extends ConsumerStatefulWidget {
  const PantallaImportarClasificacion({super.key});
  @override
  ConsumerState<PantallaImportarClasificacion> createState() =>
      _State();
}

class _State extends ConsumerState<PantallaImportarClasificacion>
    with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 2, vsync: this);

  // --- CSV/Excel ---
  String? _archivoPath;
  // --- Drive ---
  List<HojaResumen> _hojas = [];
  HojaResumen? _hojaSel;
  List<PestanaResumen> _pestanas = [];
  PestanaResumen? _pestanaSel;
  bool _cargandoDrive = false;

  AnalisisClasificacion? _analisis;
  bool _cargando = false;
  bool _aplicando = false;
  String? _error;
  String? _ok;

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  Future<void> _elegirArchivo() async {
    setState(() {
      _error = null;
      _ok = null;
    });
    final f = await openFile(acceptedTypeGroups: [
      const XTypeGroup(label: 'CSV / Excel', extensions: ['csv', 'xlsx', 'xls']),
    ]);
    if (f == null) return;
    setState(() => _archivoPath = f.path);
    await _procesar(() => ImportadorClasificacion.leerArchivo(f.path));
  }

  Future<void> _procesar(
      Future<List<List<String>>> Function() fuente) async {
    final activo = ref.read(campeonatoActivoProvider);
    if (activo == null) {
      setState(() => _error = 'No hay campeonato activo.');
      return;
    }
    setState(() {
      _cargando = true;
      _analisis = null;
      _error = null;
      _ok = null;
    });
    try {
      final tabla = await fuente();
      final analisis = await ref
          .read(importadorClasificacionProvider)
          .analizar(campeonatoId: activo.id, tabla: tabla);
      setState(() => _analisis = analisis);
    } catch (e) {
      setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  Future<void> _aplicar() async {
    final activo = ref.read(campeonatoActivoProvider);
    final a = _analisis;
    if (activo == null || a == null) return;
    setState(() {
      _aplicando = true;
      _error = null;
      _ok = null;
    });
    try {
      final r = await ref
          .read(importadorClasificacionProvider)
          .aplicar(campeonatoId: activo.id, analisis: a);
      setState(() {
        _ok =
            'Importados ${r.registros} resultados de ${r.pilotos} pilotos. '
            'Vuelve a la clasificación para verla actualizada.';
      });
    } catch (e) {
      setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _aplicando = false);
    }
  }

  // ---- Drive ----
  Future<void> _cargarHojas() async {
    setState(() {
      _cargandoDrive = true;
      _error = null;
    });
    try {
      final estado = await ref.read(estadoGoogleProvider.future);
      if (!estado.conectado) {
        throw 'Conecta tu cuenta de Google primero en Configuración → Google.';
      }
      _hojas = await ref.read(googleSheetsServiceProvider).listarHojas();
    } catch (e) {
      _error = '$e';
    } finally {
      if (mounted) setState(() => _cargandoDrive = false);
    }
  }

  Future<void> _elegirHoja(HojaResumen h) async {
    setState(() {
      _hojaSel = h;
      _pestanas = [];
      _pestanaSel = null;
      _cargandoDrive = true;
    });
    try {
      _pestanas =
          await ref.read(googleSheetsServiceProvider).listarPestanas(h.id);
      if (_pestanas.length == 1) {
        await _elegirPestana(_pestanas.first);
      }
    } catch (e) {
      _error = '$e';
    } finally {
      if (mounted) setState(() => _cargandoDrive = false);
    }
  }

  Future<void> _elegirPestana(PestanaResumen p) async {
    setState(() => _pestanaSel = p);
    await _procesar(() => ref
        .read(googleSheetsServiceProvider)
        .leerPestana(_hojaSel!.id, p.titulo));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Importar clasificación'),
        bottom: TabBar(
          controller: _tab,
          tabs: const [
            Tab(icon: Icon(Icons.upload_file_outlined), text: 'CSV / Excel'),
            Tab(icon: Icon(Icons.cloud_outlined), text: 'Google Sheets'),
          ],
        ),
      ),
      body: Column(
        children: [
          if (_error != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: cs.errorContainer,
              child: Text(_error!,
                  style: TextStyle(color: cs.onErrorContainer)),
            ),
          if (_ok != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.green.shade100,
              child: Text(_ok!,
                  style: TextStyle(
                      color: Colors.green.shade900,
                      fontWeight: FontWeight.w600)),
            ),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                _vistaCsv(),
                _vistaDrive(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _vistaCsv() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _archivoPath == null
                      ? 'Selecciona un archivo CSV o Excel con la clasificación. '
                          'La primera fila debe ser la cabecera, con una columna "Piloto" '
                          'y una columna por cada prueba.'
                      : 'Archivo: ${_archivoPath!.split('/').last}',
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: _cargando ? null : _elegirArchivo,
                icon: const Icon(Icons.folder_open),
                label: const Text('Elegir archivo'),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(child: _analisisWidget()),
      ],
    );
  }

  Widget _vistaDrive() {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _hojaSel == null
                      ? 'Selecciona la hoja de Drive con la clasificación.'
                      : 'Hoja: ${_hojaSel!.nombre}'
                          '${_pestanaSel == null ? '' : ' · ${_pestanaSel!.titulo}'}',
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: _cargandoDrive ? null : _cargarHojas,
                icon: const Icon(Icons.refresh),
                label: const Text('Listar hojas'),
              ),
            ],
          ),
        ),
        if (_hojas.isNotEmpty && _hojaSel == null)
          Expanded(
            child: ListView.builder(
              itemCount: _hojas.length,
              itemBuilder: (_, i) {
                final h = _hojas[i];
                return ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: Text(h.nombre),
                  onTap: () => _elegirHoja(h),
                );
              },
            ),
          )
        else if (_pestanas.isNotEmpty && _pestanaSel == null)
          Expanded(
            child: ListView.builder(
              itemCount: _pestanas.length,
              itemBuilder: (_, i) {
                final p = _pestanas[i];
                return ListTile(
                  leading: const Icon(Icons.tab),
                  title: Text(p.titulo),
                  onTap: () => _elegirPestana(p),
                );
              },
            ),
          )
        else if (_cargandoDrive)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          )
        else
          Expanded(
              child: _hojaSel == null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          'Pulsa "Listar hojas" para empezar.',
                          style: TextStyle(color: cs.outline),
                        ),
                      ),
                    )
                  : _analisisWidget()),
      ],
    );
  }

  Widget _analisisWidget() {
    if (_cargando) {
      return const Center(child: CircularProgressIndicator());
    }
    final a = _analisis;
    if (a == null) {
      return const SizedBox.shrink();
    }
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: cs.surfaceContainer,
          padding: const EdgeInsets.all(12),
          child: Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _chip('Pruebas reconocidas: ${a.pruebasReconocidas.length}',
                  Colors.green.shade700),
              if (a.columnasNoReconocidas.isNotEmpty)
                _chip(
                    'No reconocidas: ${a.columnasNoReconocidas.join(', ')}',
                    Colors.orange.shade800),
              _chip('Pilotos OK: ${a.pilotosOk}', cs.primary),
              if (a.pilotosKo > 0)
                _chip('Pilotos con problemas: ${a.pilotosKo}',
                    Colors.red.shade700),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: a.filas.length,
            itemBuilder: (_, i) {
              final f = a.filas[i];
              IconData ic;
              Color col;
              String estado;
              switch (f.estado) {
                case EstadoFila.ok:
                  ic = Icons.check_circle;
                  col = Colors.green.shade700;
                  estado = 'OK';
                case EstadoFila.pilotoNoEncontrado:
                  ic = Icons.person_off_outlined;
                  col = Colors.red.shade700;
                  estado = 'Piloto no encontrado';
                case EstadoFila.sinEquipo:
                  ic = Icons.group_off_outlined;
                  col = Colors.orange.shade800;
                  estado = 'Piloto sin equipo en este campeonato';
                case EstadoFila.sinDatos:
                  ic = Icons.remove_circle_outline;
                  col = Colors.grey.shade600;
                  estado = 'Sin puntos importables';
              }
              final desglose = f.puntosPorPrueba.entries
                  .map((e) => '${e.key}: ${e.value}')
                  .join(' · ');
              return CheckboxListTile(
                value: f.estado == EstadoFila.ok && f.importar,
                onChanged: f.estado == EstadoFila.ok
                    ? (v) =>
                        setState(() => f.importar = v ?? false)
                    : null,
                secondary: Icon(ic, color: col),
                title: Text(f.nombre),
                subtitle: Text(
                  desglose.isEmpty
                      ? estado
                      : f.estado == EstadoFila.ok
                          ? desglose
                          : '$estado  ·  $desglose',
                  style: TextStyle(color: cs.outline, fontSize: 12),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: FilledButton.icon(
            onPressed: _aplicando ||
                    a.filas.where((f) => f.importar).isEmpty
                ? null
                : _aplicar,
            icon: _aplicando
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.cloud_upload_outlined),
            label: Text(_aplicando
                ? 'Importando…'
                : 'Importar ${a.filas.where((f) => f.importar).length} pilotos'),
          ),
        ),
      ],
    );
  }

  Widget _chip(String texto, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(texto,
          style: TextStyle(
              color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}
