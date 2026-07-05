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
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import '../../services/google_auth_service.dart';
import '../../services/google_sheets_service.dart';
import '../equipos/importador_equipos.dart';
import '../equipos/repositorio_equipos.dart';
import '../pilotos/repositorio_pilotos.dart';
import 'pantalla_configuracion_google.dart';
import 'repositorio_hojas_vinculadas.dart';

class ImportarEquiposSheets extends ConsumerStatefulWidget {
  const ImportarEquiposSheets({super.key});

  @override
  ConsumerState<ImportarEquiposSheets> createState() =>
      _ImportarEquiposSheetsState();
}

class _ImportarEquiposSheetsState
    extends ConsumerState<ImportarEquiposSheets> {
  bool _cargandoHojas = false;
  bool _cargandoPestanas = false;
  bool _cargandoFilas = false;
  bool _importando = false;
  String? _error;

  List<HojaResumen> _hojas = [];
  String _busqueda = '';

  HojaResumen? _hojaSel;
  List<PestanaResumen> _pestanas = [];
  PestanaResumen? _pestanaSel;

  List<String> _columnas = [];
  List<Map<String, String>> _filasArchivo = [];
  MapeoColumnasEquipo _mapeo = MapeoColumnasEquipo();
  List<EquipoImportado> _previo = [];

  Future<void> _cargarHojas() async {
    setState(() {
      _cargandoHojas = true;
      _error = null;
    });
    try {
      _hojas = await ref
          .read(googleSheetsServiceProvider)
          .listarHojas(buscar: _busqueda);
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
      _filasArchivo = [];
      _previo = [];
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
      _cargandoFilas = true;
    });
    try {
      final filas = await ref
          .read(googleSheetsServiceProvider)
          .leerPestana(_hojaSel!.id, p.titulo);
      final norm = _normalizarFilas(filas);
      _columnas = norm.columnas;
      _filasArchivo = norm.filas;
      _mapeo = ImportadorEquipos.detectarMapeo(_columnas);
      await _recalcular();
    } catch (e) {
      _error = 'No se pudo leer la pestaña: $e';
    } finally {
      if (mounted) setState(() => _cargandoFilas = false);
    }
  }

  ({List<String> columnas, List<Map<String, String>> filas}) _normalizarFilas(
      List<List<String>> filas) {
    int idxCab = -1;
    for (var i = 0; i < filas.length; i++) {
      final llenas = filas[i].where((c) => c.trim().isNotEmpty).length;
      if (llenas >= 2) {
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
    setState(() => _importando = true);

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
          if (!idsInscritos.contains(existente.id)) {
            final cat = (categoria != null && categorias.contains(categoria))
                ? categoria
                : 'BRONCE';
            final ini = creditosInicialesPorCategoria[cat] ?? 28;
            await repoPi.inscribirEnCampeonato(
              pilotoId: existente.id,
              campeonatoId: activo.id,
              categoria: cat,
              creditosIniciales: ini,
            );
            idsInscritos.add(existente.id);
            pilotosInscritos++;
          }
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

      // Guarda el vínculo para futuras actualizaciones rápidas.
      if (_hojaSel != null && _pestanaSel != null) {
        await ref.read(repoHojasVinculadasProvider).guardarVinculo(
              entidad: 'equipos',
              campeonatoId: activo.id,
              hojaId: _hojaSel!.id,
              hojaNombre: _hojaSel!.nombre,
              pestanaTitulo: _pestanaSel!.titulo,
              mapeo: {
                'colEquipo': _mapeo.colEquipo,
                'colCopa': _mapeo.colCopa,
                'colP1Nombre': _mapeo.colP1Nombre,
                'colP1Email': _mapeo.colP1Email,
                'colP1Telefono': _mapeo.colP1Telefono,
                'colP1Categoria': _mapeo.colP1Categoria,
                'colP1Palmares': _mapeo.colP1Palmares,
                'colP2Nombre': _mapeo.colP2Nombre,
                'colP2Email': _mapeo.colP2Email,
                'colP2Telefono': _mapeo.colP2Telefono,
                'colP2Categoria': _mapeo.colP2Categoria,
                'colP2Palmares': _mapeo.colP2Palmares,
              },
            );
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
            '✗ Saltados: $saltados\n\n'
            'A partir de ahora, pulsa "Actualizar desde Drive" en Equipos.',
          ),
          actions: [
            FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK')),
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
      if (mounted) setState(() => _importando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final estadoAsync = ref.watch(estadoGoogleProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Importar equipos desde Sheets')),
      body: estadoAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (estado) {
          if (!estado.conectado) return _PantallaNoConectado();
          return _contenido(context);
        },
      ),
    );
  }

  Widget _contenido(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final n = _previo.where((f) => f.importar).length;
    final activo = ref.watch(campeonatoActivoProvider);
    final esPareja = activo?.formato == 'PAREJAS';

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Card(
          color: cs.surfaceContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('1. Elige la hoja',
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
                              child:
                                  CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.refresh),
                      label: const Text('Buscar'),
                    ),
                  ],
                ),
                if (_hojas.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  ..._hojas.map((h) => RadioListTile<String>(
                        value: h.id,
                        // ignore: deprecated_member_use
                        groupValue: _hojaSel?.id,
                        title: Text(h.nombre),
                        subtitle: h.modificada == null
                            ? null
                            : Text('Modificada: ${h.modificada}'),
                        // ignore: deprecated_member_use
                        onChanged: (_) => _elegirHoja(h),
                      )),
                ],
              ],
            ),
          ),
        ),
        if (_pestanas.isNotEmpty) ...[
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('2. Elige la pestaña',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  if (_cargandoPestanas)
                    const Center(child: CircularProgressIndicator())
                  else
                    DropdownButtonFormField<int?>(
                      initialValue: _pestanaSel?.sheetId,
                      isExpanded: true,
                      decoration: const InputDecoration(
                          labelText: 'Pestaña', isDense: true),
                      items: _pestanas
                          .map((p) => DropdownMenuItem(
                              value: p.sheetId, child: Text(p.titulo)))
                          .toList(),
                      onChanged: (id) {
                        if (id == null) return;
                        final p =
                            _pestanas.firstWhere((p) => p.sheetId == id);
                        _elegirPestana(p);
                      },
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
                  Text('3. Asigna columnas',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  _SecHead('Equipo'),
                  _sel('Nombre del equipo *', _mapeo.colEquipo,
                      (v) { _mapeo.colEquipo = v; _recalcular(); }),
                  _sel('Copa / categoría', _mapeo.colCopa,
                      (v) { _mapeo.colCopa = v; _recalcular(); }),
                  const SizedBox(height: 8),
                  _SecHead('Piloto 1'),
                  _sel('Nombre *', _mapeo.colP1Nombre,
                      (v) { _mapeo.colP1Nombre = v; _recalcular(); }),
                  _sel('Email', _mapeo.colP1Email,
                      (v) { _mapeo.colP1Email = v; _recalcular(); }),
                  _sel('Teléfono', _mapeo.colP1Telefono,
                      (v) { _mapeo.colP1Telefono = v; _recalcular(); }),
                  _sel('Categoría', _mapeo.colP1Categoria,
                      (v) { _mapeo.colP1Categoria = v; _recalcular(); }),
                  _sel('Palmarés', _mapeo.colP1Palmares,
                      (v) { _mapeo.colP1Palmares = v; _recalcular(); }),
                  const SizedBox(height: 8),
                  _SecHead(esPareja ? 'Piloto 2' : 'Piloto 2 (opcional)'),
                  _sel('Nombre', _mapeo.colP2Nombre,
                      (v) { _mapeo.colP2Nombre = v; _recalcular(); }),
                  _sel('Email', _mapeo.colP2Email,
                      (v) { _mapeo.colP2Email = v; _recalcular(); }),
                  _sel('Teléfono', _mapeo.colP2Telefono,
                      (v) { _mapeo.colP2Telefono = v; _recalcular(); }),
                  _sel('Categoría', _mapeo.colP2Categoria,
                      (v) { _mapeo.colP2Categoria = v; _recalcular(); }),
                  _sel('Palmarés', _mapeo.colP2Palmares,
                      (v) { _mapeo.colP2Palmares = v; _recalcular(); }),
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
                      Text('4. Vista previa',
                          style: Theme.of(context).textTheme.titleMedium),
                      const Spacer(),
                      Text('$n de ${_previo.length}'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_cargandoFilas)
                    const Center(child: CircularProgressIndicator())
                  else if (!_mapeo.esValido)
                    Text(
                        'Asigna al menos la columna del nombre del equipo y la del primer piloto.',
                        style: TextStyle(color: cs.error))
                  else
                    ..._previo.map((f) => _FilaPrevia(
                          fila: f,
                          onToggle: () => setState(() {
                            if (f.estado != 'equipo_existe' &&
                                f.estado != 'sin_piloto') {
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
            onPressed: (_importando || n == 0) ? null : _importar,
            icon: _importando
                ? const SizedBox(
                    width: 18, height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.cloud_download_outlined),
            label: Text('Importar $n equipos'),
          ),
        ],
        if (_error != null) ...[
          const SizedBox(height: 16),
          Text(_error!, style: TextStyle(color: cs.error)),
        ],
      ],
    );
  }

  Widget _sel(String label, String? actual, ValueChanged<String?> onChange) {
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

class _PantallaNoConectado extends StatelessWidget {
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
              'Conecta tu cuenta una sola vez para poder leer las hojas.',
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
    final bloqueado =
        fila.estado == 'equipo_existe' || fila.estado == 'sin_piloto';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: fila.importar,
            onChanged: bloqueado ? null : (_) => onToggle(),
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
                    color: colorEstado,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
