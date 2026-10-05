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
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/google_auth_service.dart';
import '../../services/google_sheets_service.dart';
import '../equipos/importador_equipos.dart';
import '../google/pantalla_configuracion_google.dart';
import 'importador_participantes.dart';
import 'repositorio_verificacion_libre.dart';

enum OrigenParticipantes { archivo, sheets }

/// Importa participantes a una sesión de verificación libre desde un CSV /
/// Excel o desde una pestaña de Google Sheets. Cierra devolviendo cuántos
/// se han añadido.
class PantallaImportarParticipantes extends ConsumerStatefulWidget {
  const PantallaImportarParticipantes({
    super.key,
    required this.sesion,
    required this.origen,
  });

  final SesionLibre sesion;
  final OrigenParticipantes origen;

  @override
  ConsumerState<PantallaImportarParticipantes> createState() =>
      _PantallaImportarParticipantesState();
}

class _PantallaImportarParticipantesState
    extends ConsumerState<PantallaImportarParticipantes> {
  bool _trabajando = false;
  bool _importando = false;
  String? _error;

  // Origen: archivo
  String? _nombreArchivo;

  // Origen: Google Sheets
  String _busqueda = '';
  List<HojaResumen> _hojas = [];
  HojaResumen? _hojaSel;
  List<PestanaResumen> _pestanas = [];
  PestanaResumen? _pestanaSel;

  // Tabla leída
  List<String> _columnas = [];
  List<Map<String, String>> _filas = [];
  MapeoParticipantes _mapeo = MapeoParticipantes();
  late String _copaPorDefecto = widget.sesion.copas.first;
  List<String> _yaEnSesion = [];
  List<ParticipanteImportado> _previo = [];

  bool get _esArchivo => widget.origen == OrigenParticipantes.archivo;

  @override
  void initState() {
    super.initState();
    ref
        .read(repoVerificacionLibreProvider)
        .nombresEquipos(widget.sesion)
        .then((n) {
      _yaEnSesion = n;
      if (mounted && _columnas.isNotEmpty) _recalcular();
    });
  }

  void _cargarTabla(
      ({List<String> columnas, List<Map<String, String>> filas}) t) {
    _columnas = t.columnas;
    _filas = t.filas;
    _mapeo = ImportadorParticipantes.detectarMapeo(_columnas);
    _recalcular();
  }

  void _recalcular() {
    setState(() {
      _previo = !_mapeo.esValido
          ? []
          : ImportadorParticipantes.transformar(
              _filas,
              _mapeo,
              copasSesion: widget.sesion.copas,
              copaPorDefecto: _copaPorDefecto,
              equiposEnSesion: _yaEnSesion,
            );
    });
  }

  Future<void> _elegirArchivo() async {
    final xfile = await openFile(acceptedTypeGroups: [
      const XTypeGroup(label: 'CSV / Excel', extensions: ['csv', 'xlsx', 'xls']),
    ]);
    if (xfile == null) return;
    setState(() {
      _trabajando = true;
      _error = null;
    });
    try {
      final t = await ImportadorEquipos.leerArchivo(xfile.path,
          minCeldasCabecera: 1);
      _nombreArchivo = xfile.name;
      _cargarTabla(t);
    } catch (e) {
      _error = 'No se pudo leer el archivo: $e';
    } finally {
      if (mounted) setState(() => _trabajando = false);
    }
  }

  Future<void> _buscarHojas() async {
    setState(() {
      _trabajando = true;
      _error = null;
    });
    try {
      _hojas = await ref
          .read(googleSheetsServiceProvider)
          .listarHojas(buscar: _busqueda);
    } catch (e) {
      _error = 'No se pudieron listar tus hojas: $e';
    } finally {
      if (mounted) setState(() => _trabajando = false);
    }
  }

  Future<void> _elegirHoja(HojaResumen h) async {
    setState(() {
      _hojaSel = h;
      _pestanas = [];
      _pestanaSel = null;
      _columnas = [];
      _previo = [];
      _trabajando = true;
    });
    try {
      _pestanas =
          await ref.read(googleSheetsServiceProvider).listarPestanas(h.id);
      if (_pestanas.length == 1) await _elegirPestana(_pestanas.first);
    } catch (e) {
      _error = 'No se pudieron listar las pestañas: $e';
    } finally {
      if (mounted) setState(() => _trabajando = false);
    }
  }

  Future<void> _elegirPestana(PestanaResumen p) async {
    setState(() {
      _pestanaSel = p;
      _trabajando = true;
    });
    try {
      final filas = await ref
          .read(googleSheetsServiceProvider)
          .leerPestana(_hojaSel!.id, p.titulo);
      _cargarTabla(
          ImportadorEquipos.normalizarFilas(filas, minCeldasCabecera: 1));
    } catch (e) {
      _error = 'No se pudo leer la pestaña: $e';
    } finally {
      if (mounted) setState(() => _trabajando = false);
    }
  }

  Future<void> _importar() async {
    setState(() => _importando = true);
    try {
      final n = await ref
          .read(repoVerificacionLibreProvider)
          .importarParticipantes(widget.sesion, _previo);
      if (mounted) Navigator.of(context).pop(n);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error al importar: $e')));
      setState(() => _importando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final titulo = _esArchivo
        ? 'Importar participantes (archivo)'
        : 'Importar participantes (Google Sheets)';
    if (_esArchivo) {
      return Scaffold(
          appBar: AppBar(title: Text(titulo)), body: _contenido(context));
    }
    final estadoAsync = ref.watch(estadoGoogleProvider);
    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: estadoAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (estado) =>
            estado.conectado ? _contenido(context) : const _NoConectado(),
      ),
    );
  }

  Widget _contenido(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final n = _previo.where((f) => f.importar).length;
    var paso = 1;

    Widget tarjeta(String titulo, List<Widget> hijos, {Widget? extra}) => Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(child: Text(titulo, style: tt.titleMedium)),
                  ?extra,
                ]),
                const SizedBox(height: 12),
                ...hijos,
              ],
            ),
          ),
        );

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (_esArchivo)
          tarjeta('${paso++}. Elige el archivo', [
            Text(
              'CSV o Excel con una fila de cabecera. Columnas reconocidas: '
              'Piloto 1 (o Piloto / Nombre), Piloto 2, Equipo y Copa. Hay '
              'una plantilla en "Plantillas CSV".',
              style: tt.bodySmall,
            ),
            const SizedBox(height: 12),
            Row(children: [
              FilledButton.icon(
                onPressed: _trabajando ? null : _elegirArchivo,
                icon: const Icon(Icons.upload_file),
                label: const Text('Elegir archivo'),
              ),
              const SizedBox(width: 12),
              if (_nombreArchivo != null)
                Expanded(
                    child: Text(_nombreArchivo!,
                        overflow: TextOverflow.ellipsis)),
            ]),
          ])
        else ...[
          tarjeta('${paso++}. Elige la hoja', [
            Row(children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Buscar en tus hojas…',
                    isDense: true,
                  ),
                  onChanged: (v) => _busqueda = v,
                  onSubmitted: (_) => _buscarHojas(),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: _trabajando ? null : _buscarHojas,
                icon: const Icon(Icons.refresh),
                label: const Text('Buscar'),
              ),
            ]),
            if (_hojas.isNotEmpty)
              RadioGroup<String>(
                groupValue: _hojaSel?.id,
                onChanged: (id) {
                  if (id != null) {
                    _elegirHoja(_hojas.firstWhere((h) => h.id == id));
                  }
                },
                child: Column(children: [
                  for (final h in _hojas)
                    RadioListTile<String>(value: h.id, title: Text(h.nombre)),
                ]),
              ),
          ]),
          if (_pestanas.length > 1) ...[
            const SizedBox(height: 16),
            tarjeta('${paso++}. Elige la pestaña', [
              DropdownButtonFormField<int>(
                initialValue: _pestanaSel?.sheetId,
                isExpanded: true,
                decoration:
                    const InputDecoration(labelText: 'Pestaña', isDense: true),
                items: [
                  for (final p in _pestanas)
                    DropdownMenuItem(value: p.sheetId, child: Text(p.titulo)),
                ],
                onChanged: (id) {
                  if (id != null) {
                    _elegirPestana(
                        _pestanas.firstWhere((p) => p.sheetId == id));
                  }
                },
              ),
            ]),
          ],
        ],
        if (_trabajando) ...[
          const SizedBox(height: 16),
          const Center(child: CircularProgressIndicator()),
        ],
        if (_columnas.isNotEmpty) ...[
          const SizedBox(height: 16),
          tarjeta('${paso++}. Asigna columnas', [
            _sel('Piloto 1 *', _mapeo.colPiloto1,
                (v) => _mapeo.colPiloto1 = v),
            _sel('Piloto 2', _mapeo.colPiloto2, (v) => _mapeo.colPiloto2 = v),
            _sel('Equipo', _mapeo.colEquipo, (v) => _mapeo.colEquipo = v),
            _sel('Copa', _mapeo.colCopa, (v) => _mapeo.colCopa = v),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _copaPorDefecto,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Copa por defecto',
                helperText:
                    'Para filas sin copa o con una copa que no está en la sesión',
                isDense: true,
              ),
              items: [
                for (final c in widget.sesion.copas)
                  DropdownMenuItem(value: c, child: Text(c)),
              ],
              onChanged: (v) {
                if (v == null) return;
                _copaPorDefecto = v;
                _recalcular();
              },
            ),
          ]),
          const SizedBox(height: 16),
          tarjeta(
            '${paso++}. Vista previa',
            [
              if (!_mapeo.esValido)
                Text('Asigna al menos la columna del piloto 1.',
                    style: TextStyle(color: cs.error))
              else if (_previo.isEmpty)
                const Text('No hay filas con piloto.')
              else
                for (final f in _previo)
                  CheckboxListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    value: f.importar,
                    onChanged: f.estado == 'duplicado'
                        ? null
                        : (v) => setState(() => f.importar = v ?? false),
                    title: Text(f.nombreEquipo,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          decoration: f.estado == 'duplicado'
                              ? TextDecoration.lineThrough
                              : null,
                        )),
                    subtitle: Text([
                      [f.piloto1, ?f.piloto2].join(' + '),
                      'Copa ${f.copa}',
                      ?f.aviso,
                    ].join(' · ')),
                  ),
            ],
            extra: Text('$n de ${_previo.length}'),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: (_importando || n == 0) ? null : _importar,
            icon: _importando
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.download_done),
            label: Text('Añadir $n participantes'),
          ),
        ],
        if (_error != null) ...[
          const SizedBox(height: 16),
          Text(_error!, style: TextStyle(color: cs.error)),
        ],
      ],
    );
  }

  Widget _sel(String label, String? actual, ValueChanged<String?> asignar) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: DropdownButtonFormField<String?>(
        // La clave cambia con la tabla: al leer otra, el campo se reinicia
        // con la columna detectada en vez de conservar una que ya no existe.
        key: ValueKey('$label|${_columnas.join('|')}'),
        initialValue: actual,
        isExpanded: true,
        decoration: InputDecoration(labelText: label, isDense: true),
        items: [
          const DropdownMenuItem(value: null, child: Text('— ninguna —')),
          for (final c in _columnas) DropdownMenuItem(value: c, child: Text(c)),
        ],
        onChanged: (v) {
          asignar(v);
          _recalcular();
        },
      ),
    );
  }
}

class _NoConectado extends StatelessWidget {
  const _NoConectado();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_outlined,
                size: 96, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text('Aún no estás conectado con Google',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            const Text(
              'Conecta tu cuenta una vez para poder leer tus hojas de cálculo.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const PantallaConfiguracionGoogle())),
              icon: const Icon(Icons.settings_outlined),
              label: const Text('Configurar Google'),
            ),
          ],
        ),
      ),
    );
  }
}
