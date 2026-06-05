import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import '../../services/google_auth_service.dart';
import '../../services/google_sheets_service.dart';
import '../pilotos/importador_pilotos.dart';
import '../pilotos/repositorio_pilotos.dart';
import 'pantalla_configuracion_google.dart';
import 'repositorio_hojas_vinculadas.dart';

class ImportarPilotosSheets extends ConsumerStatefulWidget {
  const ImportarPilotosSheets({super.key});

  @override
  ConsumerState<ImportarPilotosSheets> createState() =>
      _ImportarPilotosSheetsState();
}

class _ImportarPilotosSheetsState
    extends ConsumerState<ImportarPilotosSheets> {
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
  MapeoColumnas _mapeo = MapeoColumnas();
  List<PilotoImportado> _previo = [];

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
      final svc = ref.read(googleSheetsServiceProvider);
      final filas = await svc.leerPestana(_hojaSel!.id, p.titulo);
      final norm = _normalizarFilas(filas);
      _columnas = norm.columnas;
      _filasArchivo = norm.filas;
      _mapeo = ImportadorPilotos.detectarMapeo(_columnas);
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
    final filas = ImportadorPilotos.transformar(_filasArchivo, _mapeo);
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
    setState(() => _importando = true);

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

      // Guarda el vínculo para futuras actualizaciones con un solo botón.
      if (_hojaSel != null && _pestanaSel != null) {
        await ref.read(repoHojasVinculadasProvider).guardarVinculo(
              entidad: 'pilotos',
              campeonatoId: activo.id,
              hojaId: _hojaSel!.id,
              hojaNombre: _hojaSel!.nombre,
              pestanaTitulo: _pestanaSel!.titulo,
              mapeo: {
                'colNombre': _mapeo.colNombre,
                'colCategoria': _mapeo.colCategoria,
                'colCreditosIniciales': _mapeo.colCreditosIniciales,
                'colCreditosActuales': _mapeo.colCreditosActuales,
                'colPalmares': _mapeo.colPalmares,
              },
            );
      }

      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Importación completada'),
          content: Text(
            '✓ Pilotos nuevos: $nuevos\n'
            '✓ Inscritos en este campeonato: $inscritos\n'
            '✗ Saltados: $saltados\n\n'
            'A partir de ahora, pulsa "Actualizar desde Drive" en Pilotos '
            'para traer cambios sin tener que volver a configurar nada.',
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
      if (mounted) setState(() => _importando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final estadoAsync = ref.watch(estadoGoogleProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Importar pilotos desde Sheets')),
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
                        final p = _pestanas.firstWhere((p) => p.sheetId == id);
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
                  const SizedBox(height: 4),
                  Text('Detectadas automáticamente. Cámbialas si hace falta.',
                      style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 12),
                  _sel('Nombre del piloto *', _mapeo.colNombre,
                      (v) { _mapeo.colNombre = v; _recalcular(); }),
                  _sel('Categoría (metal)', _mapeo.colCategoria,
                      (v) { _mapeo.colCategoria = v; _recalcular(); }),
                  _sel('Créditos iniciales', _mapeo.colCreditosIniciales,
                      (v) { _mapeo.colCreditosIniciales = v; _recalcular(); }),
                  _sel('Créditos actuales', _mapeo.colCreditosActuales,
                      (v) { _mapeo.colCreditosActuales = v; _recalcular(); }),
                  _sel('Palmarés', _mapeo.colPalmares,
                      (v) { _mapeo.colPalmares = v; _recalcular(); }),
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
                    Text('Asigna la columna del nombre del piloto.',
                        style: TextStyle(color: cs.error))
                  else
                    ..._previo.map((f) => _FilaPrevia(
                          fila: f,
                          onToggle: () => setState(() {
                            if (f.estado != 'ya_inscrito') {
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
            label: Text('Importar $n pilotos'),
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
              'Conecta tu cuenta una sola vez para poder leer las hojas '
              'donde llegan las respuestas del Google Form.',
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
                  color: colorEstado, fontSize: 12, fontWeight: FontWeight.w600,
                )),
          ),
        ],
      ),
    );
  }
}
