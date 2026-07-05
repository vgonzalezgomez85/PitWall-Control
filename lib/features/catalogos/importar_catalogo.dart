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
import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/google_auth_service.dart';
import '../../services/google_sheets_service.dart';
import '../google/pantalla_configuracion_google.dart';
import '../google/repositorio_hojas_vinculadas.dart';
import 'repositorio_catalogos.dart';

/// Tipo de catálogo a importar.
enum TipoCatalogo {
  coches,
  marcas,
  llantas,
  engranajes,
  motores,
  bancadas,
  chasis,
  neumaticos,
  copas,
  clubs,
}

/// Mapeo de columnas detectado para cada tipo de catálogo.
class MapeoCatalogo {
  // Coches
  String? colNombre, colMarca, colModelo, colPesoMin, colCreditos, colCopa;
  // Marcas
  String? colCodigo;
  // Llantas
  String? colDimension, colTipo;
  // Neumáticos
  String? colReferencia;
  // Engranajes
  String? colDientes;
  // Motores
  String? colRpm, colGauss;

  bool esValidoPara(TipoCatalogo t) {
    switch (t) {
      case TipoCatalogo.coches:
        return colNombre != null && colPesoMin != null;
      case TipoCatalogo.marcas:
        return colCodigo != null && colNombre != null;
      case TipoCatalogo.llantas:
        return colDimension != null;
      case TipoCatalogo.engranajes:
        return colMarca != null && colDientes != null;
      case TipoCatalogo.motores:
        return colNombre != null;
      case TipoCatalogo.bancadas:
      case TipoCatalogo.chasis:
      case TipoCatalogo.copas:
      case TipoCatalogo.clubs:
      case TipoCatalogo.neumaticos:
        return colNombre != null;
    }
  }
}

class PantallaImportarCatalogo extends ConsumerStatefulWidget {
  const PantallaImportarCatalogo({super.key, required this.tipo});
  final TipoCatalogo tipo;

  @override
  ConsumerState<PantallaImportarCatalogo> createState() =>
      _PantallaImportarCatalogoState();
}

class _PantallaImportarCatalogoState
    extends ConsumerState<PantallaImportarCatalogo> {
  String? _archivo;
  bool _trabajando = false;
  String? _error;

  List<String> _columnas = [];
  List<Map<String, String>> _filas = [];
  MapeoCatalogo _mapeo = MapeoCatalogo();
  bool _reemplazar = false;

  // Fuente Google Sheets (mismo flujo que pilotos/equipos/inscripciones).
  bool _modoSheets = false;
  bool _cargandoHojas = false;
  bool _cargandoPestanas = false;
  String _busqueda = '';
  List<HojaResumen> _hojas = [];
  HojaResumen? _hojaSel;
  List<PestanaResumen> _pestanas = [];
  PestanaResumen? _pestanaSel;

  String get _titulo {
    switch (widget.tipo) {
      case TipoCatalogo.coches:
        return 'Coches';
      case TipoCatalogo.marcas:
        return 'Marcas';
      case TipoCatalogo.llantas:
        return 'Llantas';
      case TipoCatalogo.engranajes:
        return 'Engranajes';
      case TipoCatalogo.motores:
        return 'Motores';
      case TipoCatalogo.bancadas:
        return 'Bancadas';
      case TipoCatalogo.chasis:
        return 'Chasis';
      case TipoCatalogo.neumaticos:
        return 'Neumáticos';
      case TipoCatalogo.copas:
        return 'Copas';
      case TipoCatalogo.clubs:
        return 'Clubs';
    }
  }

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
      _modoSheets = false;
      _hojaSel = null;
      _pestanaSel = null;
      final ext = xfile.path.toLowerCase().split('.').last;
      final raw = ext == 'csv'
          ? await _leerCsv(xfile.path)
          : await _leerExcel(xfile.path);
      final norm = _normalizar(raw);
      _columnas = norm.columnas;
      _filas = norm.filas;
      _mapeo = _detectarMapeo(_columnas, widget.tipo);
    } catch (e) {
      _error = 'No se pudo leer el archivo: $e';
    } finally {
      if (mounted) setState(() => _trabajando = false);
    }
  }

  Future<void> _activarSheets() async {
    final estado = await ref.read(estadoGoogleProvider.future);
    if (!mounted) return;
    if (!estado.conectado) {
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const PantallaConfiguracionGoogle()));
      return;
    }
    setState(() => _modoSheets = true);
    if (_hojas.isEmpty) await _cargarHojas();
  }

  Future<void> _cargarHojas() async {
    setState(() {
      _cargandoHojas = true;
      _error = null;
    });
    try {
      final svc = ref.read(googleSheetsServiceProvider);
      _hojas = await svc.listarHojas(buscar: _busqueda);
    } catch (e) {
      _error = 'No se pudieron listar tus hojas: $e';
    } finally {
      if (mounted) setState(() => _cargandoHojas = false);
    }
  }

  Future<void> _elegirHoja(HojaResumen h) async {
    setState(() {
      _hojaSel = h;
      _cargandoPestanas = true;
      _pestanaSel = null;
      _columnas = [];
      _filas = [];
    });
    try {
      _pestanas =
          await ref.read(googleSheetsServiceProvider).listarPestanas(h.id);
      if (_pestanas.length == 1) {
        await _elegirPestana(_pestanas.first);
      }
    } catch (e) {
      _error = 'No se pudieron listar pestañas: $e';
    } finally {
      if (mounted) setState(() => _cargandoPestanas = false);
    }
  }

  Future<void> _elegirPestana(PestanaResumen p) async {
    setState(() {
      _pestanaSel = p;
      _trabajando = true;
      _error = null;
    });
    try {
      final filas = await ref
          .read(googleSheetsServiceProvider)
          .leerPestana(_hojaSel!.id, p.titulo);
      final norm = _normalizar(filas);
      _archivo = null; // la fuente ya no es un archivo local
      _columnas = norm.columnas;
      _filas = norm.filas;
      _mapeo = _detectarMapeo(_columnas, widget.tipo);
    } catch (e) {
      _error = 'No se pudo leer la pestaña: $e';
    } finally {
      if (mounted) setState(() => _trabajando = false);
    }
  }

  Future<List<List<String>>> _leerCsv(String path) async {
    final contenido = await File(path).readAsString(encoding: utf8);
    final filas = Csv(skipEmptyLines: true).decode(contenido);
    return filas
        .map((f) => f.map((c) => (c ?? '').toString()).toList())
        .toList();
  }

  Future<List<List<String>>> _leerExcel(String path) async {
    final bytes = await File(path).readAsBytes();
    final libro = Excel.decodeBytes(bytes);
    if (libro.tables.isEmpty) return [];
    final hoja = libro.tables.values.first;
    return hoja.rows
        .map((f) => f.map((c) => (c?.value?.toString() ?? '')).toList())
        .toList();
  }

  ({List<String> columnas, List<Map<String, String>> filas}) _normalizar(
      List<List<String>> filas) {
    int idxCab = -1;
    for (var i = 0; i < filas.length; i++) {
      final llenas = filas[i].where((c) => c.trim().isNotEmpty).length;
      if (llenas >= 1) {
        idxCab = i;
        break;
      }
    }
    if (idxCab == -1) {
      return (columnas: <String>[], filas: <Map<String, String>>[]);
    }
    final columnas = filas[idxCab].map((c) => c.trim()).toList();
    final out = <Map<String, String>>[];
    for (var i = idxCab + 1; i < filas.length; i++) {
      final celdas = filas[i].map((c) => c.trim()).toList();
      if (!celdas.any((c) => c.isNotEmpty)) continue;
      final mapa = <String, String>{};
      for (var j = 0; j < columnas.length && j < celdas.length; j++) {
        if (columnas[j].isEmpty) continue;
        mapa[columnas[j]] = celdas[j];
      }
      if (mapa.values.every((v) => v.isEmpty)) continue;
      out.add(mapa);
    }
    return (columnas: columnas.where((c) => c.isNotEmpty).toList(), filas: out);
  }

  static String _norm(String s) => s
      .toLowerCase()
      .replaceAll(RegExp(r'[áàä]'), 'a')
      .replaceAll(RegExp(r'[éèë]'), 'e')
      .replaceAll(RegExp(r'[íìï]'), 'i')
      .replaceAll(RegExp(r'[óòö]'), 'o')
      .replaceAll(RegExp(r'[úùü]'), 'u')
      .replaceAll(RegExp(r'[^a-z0-9 ]'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  static bool _match(String n, List<String> alts) {
    for (final a in alts) {
      if (n == a || n.contains(a)) return true;
    }
    return false;
  }

  MapeoCatalogo _detectarMapeo(List<String> cols, TipoCatalogo t) {
    final m = MapeoCatalogo();
    for (final c in cols) {
      final n = _norm(c);
      switch (t) {
        case TipoCatalogo.coches:
          if (m.colNombre == null &&
              _match(n, ['nombre', 'coche', 'modelo completo'])) {
            m.colNombre = c;
          }
          if (m.colMarca == null && _match(n, ['marca'])) m.colMarca = c;
          if (m.colModelo == null && _match(n, ['modelo'])) m.colModelo = c;
          if (m.colPesoMin == null &&
              _match(n, ['peso min', 'peso minimo', 'peso'])) {
            m.colPesoMin = c;
          }
          if (m.colCreditos == null && _match(n, ['creditos', 'credits'])) {
            m.colCreditos = c;
          }
          if (m.colCopa == null && _match(n, ['copa', 'copas'])) {
            m.colCopa = c;
          }
        case TipoCatalogo.marcas:
          if (m.colCodigo == null && _match(n, ['codigo', 'cod', 'id'])) {
            m.colCodigo = c;
          }
          if (m.colNombre == null && _match(n, ['nombre', 'marca'])) {
            m.colNombre = c;
          }
        case TipoCatalogo.llantas:
          if (m.colDimension == null &&
              _match(n, ['dimension', 'medida', 'tamano', 'llanta'])) {
            m.colDimension = c;
          }
          if (m.colTipo == null &&
              _match(n, ['tipo', 'delantera trasera', 'd t'])) {
            m.colTipo = c;
          }
        case TipoCatalogo.engranajes:
          if (m.colMarca == null && _match(n, ['marca'])) m.colMarca = c;
          if (m.colDientes == null &&
              _match(n, ['dientes', 'teeth', 'z'])) {
            m.colDientes = c;
          }
          if (m.colTipo == null &&
              _match(n, ['tipo', 'pinon corona', 'pinon', 'corona'])) {
            m.colTipo = c;
          }
        case TipoCatalogo.motores:
          if (m.colNombre == null && _match(n, ['motor', 'nombre'])) {
            m.colNombre = c;
          }
          if (m.colRpm == null && _match(n, ['rpm'])) m.colRpm = c;
          if (m.colGauss == null && _match(n, ['gaus', 'gauss'])) {
            m.colGauss = c;
          }
          if (m.colCopa == null && _match(n, ['copa', 'copas'])) {
            m.colCopa = c;
          }
        case TipoCatalogo.neumaticos:
          if (m.colNombre == null && _match(n, ['nombre', 'neumatico'])) {
            m.colNombre = c;
          }
          if (m.colReferencia == null &&
              _match(n, ['referencia', 'ref', 'sku'])) {
            m.colReferencia = c;
          }
        case TipoCatalogo.bancadas:
        case TipoCatalogo.chasis:
        case TipoCatalogo.copas:
        case TipoCatalogo.clubs:
          if (m.colNombre == null &&
              _match(n, ['nombre', 'bancada', 'chasis', 'copa', 'club', 'categoria'])) {
            m.colNombre = c;
          }
      }
    }
    return m;
  }

  Future<void> _importar() async {
    setState(() => _trabajando = true);
    int ok = 0, saltados = 0;
    try {
      final repo = ref.read(repoCatalogosProvider);

      if (_reemplazar) {
        // Vaciar la tabla antes de importar
        await _vaciarCatalogo(widget.tipo, repo);
      }

      for (final fila in _filas) {
        try {
          switch (widget.tipo) {
            case TipoCatalogo.coches:
              final nombre = fila[_mapeo.colNombre]?.trim() ?? '';
              if (nombre.isEmpty) { saltados++; continue; }
              final marca = fila[_mapeo.colMarca]?.trim() ?? '';
              final modelo = fila[_mapeo.colModelo]?.trim() ?? nombre;
              final peso = double.tryParse(
                      (fila[_mapeo.colPesoMin] ?? '17')
                          .replaceAll(',', '.')) ??
                  17.0;
              final cred =
                  int.tryParse(fila[_mapeo.colCreditos]?.trim() ?? '0') ?? 0;
              // Copas separadas por coma; vacío = aplica a todas.
              final copas = (fila[_mapeo.colCopa] ?? '')
                  .split(',')
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty)
                  .toList();
              await repo.crearCoche(
                  nombre: nombre,
                  marca: marca,
                  modelo: modelo,
                  pesoMin: peso,
                  creditosCoche: cred,
                  copasJson: copas.isEmpty ? null : json.encode(copas));
            case TipoCatalogo.marcas:
              final cod = fila[_mapeo.colCodigo]?.trim() ?? '';
              final nom = fila[_mapeo.colNombre]?.trim() ?? '';
              if (cod.isEmpty || nom.isEmpty) { saltados++; continue; }
              await repo.crearMarca(cod, nom);
            case TipoCatalogo.llantas:
              final dim = fila[_mapeo.colDimension]?.trim() ?? '';
              if (dim.isEmpty) { saltados++; continue; }
              var tipo =
                  (fila[_mapeo.colTipo] ?? 'DELANTERA').trim().toUpperCase();
              if (!['DELANTERA', 'TRASERA', 'AMBAS'].contains(tipo)) {
                tipo = 'DELANTERA';
              }
              await repo.crearLlanta(dim, tipo);
            case TipoCatalogo.engranajes:
              final marca = fila[_mapeo.colMarca]?.trim() ?? '';
              final dientes =
                  int.tryParse(fila[_mapeo.colDientes]?.trim() ?? '');
              if (marca.isEmpty || dientes == null) { saltados++; continue; }
              final tipoTxt = _norm(fila[_mapeo.colTipo] ?? '');
              final tipoEng =
                  tipoTxt.contains('corona') ? 'CORONA' : 'PINON';
              await repo.crearEngranaje(
                  tipo: tipoEng, marca: marca, dientes: dientes);
            case TipoCatalogo.motores:
              final nombre = fila[_mapeo.colNombre]?.trim() ?? '';
              if (nombre.isEmpty) { saltados++; continue; }
              final rpm = int.tryParse(fila[_mapeo.colRpm]?.trim() ?? '');
              final gauss = double.tryParse(
                  (fila[_mapeo.colGauss] ?? '').trim().replaceAll(',', '.'));
              final copas = (fila[_mapeo.colCopa] ?? '')
                  .split(',')
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty)
                  .toList();
              await repo.crearMotor(
                  nombre: nombre,
                  rpm: rpm,
                  gauss: gauss,
                  copasJson: copas.isEmpty ? null : json.encode(copas));
            case TipoCatalogo.bancadas:
              final n = fila[_mapeo.colNombre]?.trim() ?? '';
              if (n.isEmpty) { saltados++; continue; }
              await repo.crearBancada(n);
            case TipoCatalogo.chasis:
              final n = fila[_mapeo.colNombre]?.trim() ?? '';
              if (n.isEmpty) { saltados++; continue; }
              await repo.crearChasis(n);
            case TipoCatalogo.neumaticos:
              final n = fila[_mapeo.colNombre]?.trim() ?? '';
              if (n.isEmpty) { saltados++; continue; }
              final r = fila[_mapeo.colReferencia]?.trim();
              await repo.crearNeumatico(
                  n, r == null || r.isEmpty ? null : r);
            case TipoCatalogo.copas:
              final n = fila[_mapeo.colNombre]?.trim() ?? '';
              if (n.isEmpty) { saltados++; continue; }
              await repo.crearCopa(n);
            case TipoCatalogo.clubs:
              final n = fila[_mapeo.colNombre]?.trim() ?? '';
              if (n.isEmpty) { saltados++; continue; }
              await repo.crearClub(n);
          }
          ok++;
        } catch (_) {
          saltados++;
        }
      }

      // Si la fuente es una hoja de Google, guardar el vínculo para poder
      // actualizar después con un solo botón desde la pantalla de catálogos.
      var vinculada = false;
      if (_hojaSel != null && _pestanaSel != null) {
        await ref.read(repoHojasVinculadasProvider).guardarVinculo(
              entidad: 'catalogo_${widget.tipo.name}',
              hojaId: _hojaSel!.id,
              hojaNombre: _hojaSel!.nombre,
              pestanaTitulo: _pestanaSel!.titulo,
              mapeo: {
                'colNombre': _mapeo.colNombre,
                'colCopa': _mapeo.colCopa,
                'colMarca': _mapeo.colMarca,
                'colModelo': _mapeo.colModelo,
                'colPesoMin': _mapeo.colPesoMin,
                'colCreditos': _mapeo.colCreditos,
                'colCodigo': _mapeo.colCodigo,
                'colDimension': _mapeo.colDimension,
                'colTipo': _mapeo.colTipo,
                'colReferencia': _mapeo.colReferencia,
                'colDientes': _mapeo.colDientes,
                'colRpm': _mapeo.colRpm,
                'colGauss': _mapeo.colGauss,
              },
            );
        vinculada = true;
      }

      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Importación completada'),
          content: Text('✓ Añadidos: $ok\n✗ Saltados: $saltados'
              '${vinculada ? '\n\nHoja vinculada: a partir de ahora pulsa '
                  '"Actualizar desde Drive" en la pestaña del catálogo '
                  'para traer cambios.' : ''}'),
          actions: [
            FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK')),
          ],
        ),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _trabajando = false);
    }
  }

  Future<void> _vaciarCatalogo(
      TipoCatalogo t, RepositorioCatalogos repo) async {
    // No proporcionamos vaciar masivo en el repo, así que hacemos uno a uno.
    final db = repo.db;
    switch (t) {
      case TipoCatalogo.coches:
        await db.delete(db.catalogoCoches).go();
      case TipoCatalogo.marcas:
        await db.delete(db.catalogoMarcas).go();
      case TipoCatalogo.llantas:
        await db.delete(db.catalogoLlantas).go();
      case TipoCatalogo.engranajes:
        await db.delete(db.catalogoEngranajes).go();
      case TipoCatalogo.motores:
        await db.delete(db.catalogoMotores).go();
      case TipoCatalogo.bancadas:
        await db.delete(db.catalogoBancadas).go();
      case TipoCatalogo.chasis:
        await db.delete(db.catalogoChasis).go();
      case TipoCatalogo.neumaticos:
        await db.delete(db.catalogoNeumaticos).go();
      case TipoCatalogo.copas:
        await db.delete(db.catalogoCopas).go();
      case TipoCatalogo.clubs:
        await db.delete(db.catalogoClubs).go();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text('Importar $_titulo')),
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
                  Text('1. Elige la fuente',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(_ayudaPorTipo(widget.tipo),
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      FilledButton.icon(
                        onPressed: _trabajando ? null : _elegirArchivo,
                        icon: const Icon(Icons.folder_open),
                        label: const Text('Archivo CSV / Excel'),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: _trabajando ? null : _activarSheets,
                        icon: const Icon(Icons.cloud_outlined),
                        label: const Text('Google Sheets'),
                      ),
                      if (_archivo != null)
                        Text(_archivo!.split('/').last,
                            overflow: TextOverflow.ellipsis),
                      if (_hojaSel != null)
                        Text(
                          '${_hojaSel!.nombre}'
                          '${_pestanaSel == null ? '' : ' · ${_pestanaSel!.titulo}'}',
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_modoSheets) ...[
            const SizedBox(height: 12),
            _seccionSheets(context),
          ],
          if (_error != null) ...[
            const SizedBox(height: 12),
            Card(
              color: cs.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(_error!,
                    style: TextStyle(color: cs.onErrorContainer)),
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
                    Text('2. Asigna las columnas',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    ..._selectoresPorTipo(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              value: _reemplazar,
              onChanged: (v) => setState(() => _reemplazar = v),
              title: const Text('Sustituir el catálogo existente'),
              subtitle: const Text(
                  'Si lo marcas, primero se vacía la tabla y luego se importa.'),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: (_trabajando ||
                      !_mapeo.esValidoPara(widget.tipo) ||
                      _filas.isEmpty)
                  ? null
                  : _importar,
              icon: _trabajando
                  ? const SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.cloud_download_outlined),
              label: Text('Importar ${_filas.length} filas'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _seccionSheets(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Elige la hoja de Google',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Buscar en tus hojas…',
                      isDense: true,
                    ),
                    onChanged: (v) => _busqueda = v,
                    onSubmitted: (_) => _cargarHojas(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _cargandoHojas ? null : _cargarHojas,
                  icon: _cargandoHojas
                      ? const SizedBox(
                          width: 16, height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh),
                  label: const Text('Buscar'),
                ),
              ],
            ),
            if (_hojas.isNotEmpty) ...[
              const SizedBox(height: 12),
              RadioGroup<String>(
                groupValue: _hojaSel?.id,
                onChanged: (id) {
                  if (id == null) return;
                  _elegirHoja(_hojas.firstWhere((h) => h.id == id));
                },
                child: Column(
                  children: [
                    for (final h in _hojas)
                      RadioListTile<String>(
                        value: h.id,
                        title: Text(h.nombre),
                        subtitle: h.modificada == null
                            ? null
                            : Text('Modificada: ${h.modificada}'),
                      ),
                  ],
                ),
              ),
            ],
            if (_cargandoPestanas)
              const Center(child: CircularProgressIndicator())
            else if (_pestanas.isNotEmpty) ...[
              const SizedBox(height: 8),
              DropdownButtonFormField<int?>(
                initialValue: _pestanaSel?.sheetId,
                isExpanded: true,
                decoration:
                    const InputDecoration(labelText: 'Pestaña', isDense: true),
                items: _pestanas
                    .map((p) => DropdownMenuItem(
                        value: p.sheetId, child: Text(p.titulo)))
                    .toList(),
                onChanged: (id) {
                  if (id == null) return;
                  _elegirPestana(
                      _pestanas.firstWhere((p) => p.sheetId == id));
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _ayudaPorTipo(TipoCatalogo t) {
    switch (t) {
      case TipoCatalogo.coches:
        return 'CSV/Excel o Google Sheets con columnas: Nombre, Marca, Modelo, '
            'Peso mínimo, Créditos, Copa(s) (separadas por coma; vacío = todas).';
      case TipoCatalogo.marcas:
        return 'CSV/Excel con columnas: Código, Nombre.';
      case TipoCatalogo.llantas:
        return 'CSV/Excel con columnas: Dimensión, Tipo (DELANTERA / TRASERA / AMBAS).';
      case TipoCatalogo.engranajes:
        return 'CSV/Excel o Google Sheets con columnas: Marca, Dientes, Tipo (PIÑÓN / CORONA).';
      case TipoCatalogo.motores:
        return 'CSV/Excel o Google Sheets con columnas: Motor, RPM, Gauss, '
            'Copa(s) (separadas por coma; vacío = todas).';
      case TipoCatalogo.bancadas:
      case TipoCatalogo.chasis:
      case TipoCatalogo.copas:
      case TipoCatalogo.clubs:
        return 'CSV/Excel con una columna: Nombre.';
      case TipoCatalogo.neumaticos:
        return 'CSV/Excel con columnas: Nombre, Referencia (opcional).';
    }
  }

  List<Widget> _selectoresPorTipo() {
    Widget sel(String label, String? actual, ValueChanged<String?> onChange) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: DropdownButtonFormField<String?>(
          initialValue: actual,
          isExpanded: true,
          decoration: InputDecoration(labelText: label, isDense: true),
          items: [
            const DropdownMenuItem(value: null, child: Text('— ninguna —')),
            ..._columnas.map((c) => DropdownMenuItem(value: c, child: Text(c))),
          ],
          onChanged: onChange,
        ),
      );
    }

    switch (widget.tipo) {
      case TipoCatalogo.coches:
        return [
          sel('Nombre *', _mapeo.colNombre,
              (v) => setState(() => _mapeo.colNombre = v)),
          sel('Marca', _mapeo.colMarca,
              (v) => setState(() => _mapeo.colMarca = v)),
          sel('Modelo', _mapeo.colModelo,
              (v) => setState(() => _mapeo.colModelo = v)),
          sel('Peso mínimo *', _mapeo.colPesoMin,
              (v) => setState(() => _mapeo.colPesoMin = v)),
          sel('Créditos', _mapeo.colCreditos,
              (v) => setState(() => _mapeo.colCreditos = v)),
          sel('Copa(s)', _mapeo.colCopa,
              (v) => setState(() => _mapeo.colCopa = v)),
        ];
      case TipoCatalogo.marcas:
        return [
          sel('Código *', _mapeo.colCodigo,
              (v) => setState(() => _mapeo.colCodigo = v)),
          sel('Nombre *', _mapeo.colNombre,
              (v) => setState(() => _mapeo.colNombre = v)),
        ];
      case TipoCatalogo.llantas:
        return [
          sel('Dimensión *', _mapeo.colDimension,
              (v) => setState(() => _mapeo.colDimension = v)),
          sel('Tipo', _mapeo.colTipo,
              (v) => setState(() => _mapeo.colTipo = v)),
        ];
      case TipoCatalogo.engranajes:
        return [
          sel('Marca *', _mapeo.colMarca,
              (v) => setState(() => _mapeo.colMarca = v)),
          sel('Dientes *', _mapeo.colDientes,
              (v) => setState(() => _mapeo.colDientes = v)),
          sel('Tipo (piñón/corona)', _mapeo.colTipo,
              (v) => setState(() => _mapeo.colTipo = v)),
        ];
      case TipoCatalogo.motores:
        return [
          sel('Motor *', _mapeo.colNombre,
              (v) => setState(() => _mapeo.colNombre = v)),
          sel('RPM', _mapeo.colRpm,
              (v) => setState(() => _mapeo.colRpm = v)),
          sel('Gauss', _mapeo.colGauss,
              (v) => setState(() => _mapeo.colGauss = v)),
          sel('Copa(s)', _mapeo.colCopa,
              (v) => setState(() => _mapeo.colCopa = v)),
        ];
      case TipoCatalogo.neumaticos:
        return [
          sel('Nombre *', _mapeo.colNombre,
              (v) => setState(() => _mapeo.colNombre = v)),
          sel('Referencia', _mapeo.colReferencia,
              (v) => setState(() => _mapeo.colReferencia = v)),
        ];
      case TipoCatalogo.bancadas:
      case TipoCatalogo.chasis:
      case TipoCatalogo.copas:
      case TipoCatalogo.clubs:
        return [
          sel('Nombre *', _mapeo.colNombre,
              (v) => setState(() => _mapeo.colNombre = v)),
        ];
    }
  }
}
