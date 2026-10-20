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
import 'dart:typed_data';

import 'package:drift/drift.dart' show BooleanExpressionOperators, OrderingTerm, Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/idioma.dart';
import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import '../../data/database/seeds.dart';
import '../clasificacion/pantalla_editor_tabla_puntos.dart';
import '../creditos/repositorio_creditos.dart';
import 'pantalla_coches_campeonato.dart';
import 'repositorio_coches_campeonato.dart';
import 'selector_club_logo.dart';
import 'selector_marcas_permitidas.dart';
import 'selector_tipo_motor.dart';

/// Provider con todas las copas del catálogo global (para sugerirlas).
final _catalogoCopasProvider = FutureProvider<List<String>>((ref) async {
  final db = ref.watch(dbProvider);
  final lista = await db.select(db.catalogoCopas).get();
  return lista.map((c) => c.nombre).toList()..sort();
});

/// Campeonatos finalizados, candidatos para importar sus pilotos y saldos.
final _campeonatosFinalizadosProvider =
    FutureProvider<List<Campeonato>>((ref) async {
  final db = ref.watch(dbProvider);
  return (db.select(db.campeonatos)
        ..where((t) =>
            t.finalizado.equals(true) & t.esVerificacionLibre.equals(false))
        ..orderBy([(t) => OrderingTerm.desc(t.anio)]))
      .get();
});

/// Campeonatos de los que se pueden heredar puntos para ordenar la primera
/// prueba (todos menos las sesiones de verificación libre).
final _campeonatosSemillaProvider =
    FutureProvider.autoDispose<List<Campeonato>>((ref) async {
  final db = ref.watch(dbProvider);
  return (db.select(db.campeonatos)
        ..where((t) => t.esVerificacionLibre.equals(false))
        ..orderBy([
          (t) => OrderingTerm.desc(t.anio),
          (t) => OrderingTerm.asc(t.nombre),
        ]))
      .get();
});

class EditorCampeonato extends ConsumerStatefulWidget {
  const EditorCampeonato({super.key, this.campeonatoId});
  final int? campeonatoId;

  @override
  ConsumerState<EditorCampeonato> createState() => _EditorCampeonatoState();
}

class _EditorCampeonatoState extends ConsumerState<EditorCampeonato> {
  final _formKey = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _anio = TextEditingController(text: DateTime.now().year.toString());
  final _descartes = TextEditingController(text: '1');
  final _tope = TextEditingController(text: '28');
  final _nuevaCopa = TextEditingController();
  // Cuotas en blanco al crear: cada campeonato pone las suyas.
  final _cuotaPagat = TextEditingController();
  final _cuotaCoord = TextEditingController();
  final _cuotaClub = TextEditingController();
  final _motorMin = TextEditingController();
  final _motorMax = TextEditingController();
  /// Limitar fabricante: códigos de marca permitidos en la verificación.
  bool _limitarMarcas = false;
  Set<String> _marcasPermitidas = {};
  final _marcaTitulo = TextEditingController();
  final _marcaLema = TextEditingController();
  final _club = TextEditingController();

  /// Logo del club organizador (PNG ya reducido), o null.
  Uint8List? _logoClub;

  String _formato = 'PAREJAS';
  bool _activo = true;
  bool _usaCreditos = true;
  bool _usaTesoreria = true;
  bool _finalizado = false;
  bool _finalizadoOriginal = false;
  int? _importarDesdeId;
  /// Orden de la primera prueba: 'HEREDAR' (de [_semillaId], o de la
  /// puntuación previa importada si es null) o 'POLE'.
  String _ordenPrimera = 'HEREDAR';
  int? _semillaId;
  Set<String> _copasSel = {};
  /// Tipo de motor: 'ORGANIZACION', 'PROPIO' o 'MIXTO' (en BD, null). Al
  /// crear empieza sin elegir y hay que marcar uno para guardar.
  String? _tipoMotor;
  /// Un controlador de "anchura máxima de eje (mm)" por copa y lado
  /// (delantero/trasero), creado bajo demanda (las copas son dinámicas: se
  /// pueden añadir/quitar). Clave: "copa|del" o "copa|tra".
  final Map<String, TextEditingController> _anchuraEjeCtrl = {};
  TextEditingController _anchuraCtrl(String copa, String lado) =>
      _anchuraEjeCtrl.putIfAbsent('$copa|$lado', () => TextEditingController());
  bool _cargando = true;
  bool _guardando = false;

  /// Al crear: muestra las secciones opcionales (puntuación, verificación,
  /// PDF), que empiezan plegadas.
  bool _masOpciones = false;

  /// La tabla de puntos se edita sobre el campeonato activo: solo se ofrece
  /// al editar ese campeonato.
  bool get _esElActivo =>
      widget.campeonatoId != null &&
      ref.read(campeonatoActivoProvider)?.id == widget.campeonatoId;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    if (widget.campeonatoId == null) {
      // Sin copas marcadas: el usuario elige las suyas (guardar exige una).
      setState(() => _cargando = false);
      return;
    }
    final db = ref.read(dbProvider);
    final c = await (db.select(db.campeonatos)
          ..where((t) => t.id.equals(widget.campeonatoId!)))
        .getSingle();
    _nombre.text = c.nombre;
    _anio.text = c.anio.toString();
    _descartes.text = c.numDescartes.toString();
    _tope.text = c.topeRegularizacion.toString();
    _cuotaPagat.text = c.cuotaPagat.toStringAsFixed(c.cuotaPagat % 1 == 0 ? 0 : 2);
    _cuotaCoord.text =
        c.cuotaCoordinadora.toStringAsFixed(c.cuotaCoordinadora % 1 == 0 ? 0 : 2);
    _cuotaClub.text =
        c.cuotaClub.toStringAsFixed(c.cuotaClub % 1 == 0 ? 0 : 2);
    _motorMin.text = c.motorSorteoMin?.toString() ?? '';
    _motorMax.text = c.motorSorteoMax?.toString() ?? '';
    _tipoMotor = tipoMotorDeBd(c.tipoMotor);
    _marcasPermitidas = {...marcasPermitidasDe(c.marcasPermitidasJson)};
    _limitarMarcas = _marcasPermitidas.isNotEmpty;
    _marcaTitulo.text = c.marcaTitulo ?? '';
    _marcaLema.text = c.marcaLema ?? '';
    _club.text = c.clubOrganizador ?? '';
    _logoClub = c.logoClub;
    _formato = c.formato;
    _activo = c.activo;
    _usaCreditos = c.usaCreditos;
    _usaTesoreria = c.usaTesoreria;
    _finalizado = c.finalizado;
    _finalizadoOriginal = c.finalizado;
    _ordenPrimera = c.ordenPrimeraPrueba;
    _semillaId = c.campeonatoSemillaId;
    try {
      final raw = json.decode(c.copasJson);
      if (raw is List) {
        _copasSel = raw.map((e) => e.toString()).toSet();
      }
    } catch (_) {}
    try {
      final raw = json.decode(c.anchuraEjeJson);
      if (raw is Map) {
        raw.forEach((copa, lados) {
          if (lados is Map) {
            if (lados['del'] != null) {
              _anchuraCtrl(copa, 'del').text = '${lados['del']}';
            }
            if (lados['tra'] != null) {
              _anchuraCtrl(copa, 'tra').text = '${lados['tra']}';
            }
          }
        });
      }
    } catch (_) {}
    if (mounted) setState(() => _cargando = false);
  }

  @override
  void dispose() {
    _nombre.dispose();
    _anio.dispose();
    _descartes.dispose();
    _tope.dispose();
    _nuevaCopa.dispose();
    _cuotaPagat.dispose();
    _cuotaCoord.dispose();
    _cuotaClub.dispose();
    _motorMin.dispose();
    _motorMax.dispose();
    for (final c in _anchuraEjeCtrl.values) {
      c.dispose();
    }
    _marcaTitulo.dispose();
    _marcaLema.dispose();
    _club.dispose();
    super.dispose();
  }

  /// Selector para importar pilotos (y su saldo de cierre) de un campeonato
  /// finalizado al crear este. Solo aparece si hay campeonatos finalizados.
  Widget _selectorImportarPilotos() {
    final finalizadosAsync = ref.watch(_campeonatosFinalizadosProvider);
    return finalizadosAsync.maybeWhen(
      data: (finalizados) {
        if (finalizados.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 4),
          child: DropdownButtonFormField<int?>(
            initialValue: _importarDesdeId,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: context.l.importarPilotosFinalizado,
              helperText: context.l.importarPilotosFinalizadoAyuda,
              prefixIcon: const Icon(Icons.download_outlined),
            ),
            items: [
              DropdownMenuItem<int?>(
                value: null,
                child: Text(context.l.noImportar),
              ),
              for (final c in finalizados)
                DropdownMenuItem<int?>(
                  value: c.id,
                  child: Text('${c.nombre} (${c.anio})'),
                ),
            ],
            onChanged: (v) => setState(() {
              _importarDesdeId = v;
              // Lo normal es heredar los puntos del mismo campeonato.
              _semillaId ??= v;
            }),
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  /// Sección «Orden de la primera prueba»: heredar los puntos de otro
  /// campeonato (solo para ordenar las tandas) o empezar sin puntos con pole.
  Widget _seccionOrdenPrimeraPrueba() {
    final l = context.l;
    final candidatos = (ref.watch(_campeonatosSemillaProvider).value ??
            const <Campeonato>[])
        .where((c) => c.id != widget.campeonatoId)
        .toList();
    return _Seccion(
      titulo: l.ordenPrimeraPrueba,
      descripcion: l.ordenPrimeraPruebaAyuda,
      children: [
        RadioGroup<String>(
          groupValue: _ordenPrimera,
          onChanged: (v) => setState(() => _ordenPrimera = v ?? 'HEREDAR'),
          child: Column(
            children: [
              RadioListTile<String>(
                value: 'HEREDAR',
                title: Text(l.ordenHeredarPuntos),
                subtitle: Text(l.ordenHeredarPuntosAyuda),
              ),
              if (_ordenPrimera == 'HEREDAR')
                Padding(
                  padding: const EdgeInsets.fromLTRB(56, 0, 16, 8),
                  child: DropdownButtonFormField<int?>(
                    // La key fuerza a reconstruir al cambiar desde fuera
                    // (al elegir de dónde importar pilotos).
                    key: ValueKey(
                        'semilla-$_semillaId-${candidatos.length}'),
                    initialValue: candidatos.any((c) => c.id == _semillaId)
                        ? _semillaId
                        : null,
                    isExpanded: true,
                    decoration:
                        InputDecoration(labelText: l.campeonatoDeOrigen),
                    items: [
                      DropdownMenuItem<int?>(
                        value: null,
                        child: Text(l.puntuacionPreviaImportada),
                      ),
                      for (final c in candidatos)
                        DropdownMenuItem<int?>(
                          value: c.id,
                          child: Text('${c.nombre} (${c.anio})'),
                        ),
                    ],
                    onChanged: (v) => setState(() => _semillaId = v),
                  ),
                ),
              RadioListTile<String>(
                value: 'POLE',
                title: Text(l.ordenEmpezarSinPuntos),
                subtitle: Text(l.ordenEmpezarSinPuntosAyuda),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _anadirCopaNueva() async {
    final t = _nuevaCopa.text.trim();
    if (t.isEmpty) return;
    final db = ref.read(dbProvider);
    final existe = await (db.select(db.catalogoCopas)
          ..where((c) => c.nombre.equals(t)))
        .getSingleOrNull();
    if (existe == null) {
      await db.into(db.catalogoCopas)
          .insert(CatalogoCopasCompanion.insert(nombre: t));
    }
    setState(() {
      _copasSel.add(t);
      _nuevaCopa.clear();
    });
    ref.invalidate(_catalogoCopasProvider);
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) {
      // Un error en una sección plegada no se vería: se despliega todo.
      if (!_masOpciones) setState(() => _masOpciones = true);
      return;
    }
    final l = context.l;
    if (_copasSel.isEmpty) {
      _aviso(l.seleccionaUnaCopa);
      return;
    }
    if (_tipoMotor == null) {
      _aviso(l.eligeTipoMotor);
      return;
    }
    if (_limitarMarcas && _marcasPermitidas.isEmpty) {
      _aviso(l.limitarFabricanteError);
      return;
    }
    setState(() => _guardando = true);
    final db = ref.read(dbProvider);
    try {
      final copasJson = json.encode(_copasSel.toList());
      double parseD(TextEditingController c, double def) {
        return double.tryParse(c.text.trim().replaceAll(',', '.')) ?? def;
      }
      // Anchura máxima de eje por copa y lado: solo se guardan los valores
      // indicados (vacío = no se comprueba ese lado en esa copa).
      final anchuraEjeMap = <String, Map<String, double>>{};
      for (final copa in _copasSel) {
        final del = double.tryParse(
            _anchuraCtrl(copa, 'del').text.trim().replaceAll(',', '.'));
        final tra = double.tryParse(
            _anchuraCtrl(copa, 'tra').text.trim().replaceAll(',', '.'));
        if (del != null || tra != null) {
          anchuraEjeMap[copa] = {
            'del': ?del,
            'tra': ?tra,
          };
        }
      }
      final anchuraEjeJson = json.encode(anchuraEjeMap);
      // Vacío = 0 (el Pagat ya se exige en el formulario si hay tesorería).
      final cuotaP = parseD(_cuotaPagat, 0);
      final cuotaC = parseD(_cuotaCoord, 0);
      final cuotaCl = parseD(_cuotaClub, 0);
      // El desglose tiene que cuadrar con la cuota, o la tesorería no suma.
      if (_usaTesoreria && (cuotaC + cuotaCl - cuotaP).abs() >= 0.01) {
        _aviso(l.tesoreriaNoCuadra((cuotaC + cuotaCl).toStringAsFixed(2),
            cuotaP.toStringAsFixed(2)));
        setState(() => _guardando = false);
        return;
      }
      // Con motor propio no hay sorteo: el rango no aplica.
      final sinSorteo = _tipoMotor == 'PROPIO';
      final motorMin = sinSorteo ? null : int.tryParse(_motorMin.text.trim());
      final motorMax = sinSorteo ? null : int.tryParse(_motorMax.text.trim());
      final tipoMotor = tipoMotorABd(_tipoMotor);
      // Marca propia del campeonato en los PDF (vacío = valor por defecto).
      final mTitulo = _marcaTitulo.text.trim();
      final mLema = _marcaLema.text.trim();
      final club = _club.text.trim();
      final marcasJson =
          marcasPermitidasAJson(_limitarMarcas ? _marcasPermitidas : {});

      if (widget.campeonatoId == null) {
        final id = await Seeds.crearCampeonato(
          db,
          nombre: _nombre.text.trim(),
          formato: _formato,
          anio: int.parse(_anio.text.trim()),
        );
        await (db.update(db.campeonatos)..where((t) => t.id.equals(id))).write(
          CampeonatosCompanion(
            numDescartes: Value(int.parse(_descartes.text.trim())),
            topeRegularizacion: Value(int.parse(_tope.text.trim())),
            usaCreditos: Value(_usaCreditos),
            usaTesoreria: Value(_usaTesoreria),
            finalizado: Value(_finalizado),
            copasJson: Value(copasJson),
            anchuraEjeJson: Value(anchuraEjeJson),
            cuotaPagat: Value(cuotaP),
            cuotaCoordinadora: Value(cuotaC),
            cuotaClub: Value(cuotaCl),
            motorSorteoMin: Value(motorMin),
            motorSorteoMax: Value(motorMax),
            tipoMotor: Value(tipoMotor),
            marcasPermitidasJson: Value(marcasJson),
            marcaTitulo: Value(mTitulo.isEmpty ? null : mTitulo),
            marcaLema: Value(mLema.isEmpty ? null : mLema),
            clubOrganizador: Value(club.isEmpty ? null : club),
            logoClub: Value(_logoClub),
            ordenPrimeraPrueba: Value(_ordenPrimera),
            campeonatoSemillaId: Value(_semillaId),
          ),
        );
        if (_usaCreditos && _importarDesdeId != null) {
          await ref.read(repoCreditosProvider).importarDesdeCampeonato(
                origenId: _importarDesdeId!,
                destinoId: id,
              );
        }
        if (_activo) {
          final c = await (db.select(db.campeonatos)
                ..where((t) => t.id.equals(id)))
              .getSingle();
          ref.read(campeonatoActivoProvider.notifier).seleccionar(c);
        }
      } else {
        await (db.update(db.campeonatos)
              ..where((t) => t.id.equals(widget.campeonatoId!)))
            .write(CampeonatosCompanion(
          nombre: Value(_nombre.text.trim()),
          formato: Value(_formato),
          anio: Value(int.parse(_anio.text.trim())),
          numDescartes: Value(int.parse(_descartes.text.trim())),
          topeRegularizacion: Value(int.parse(_tope.text.trim())),
          activo: Value(_activo),
          usaCreditos: Value(_usaCreditos),
          usaTesoreria: Value(_usaTesoreria),
          finalizado: Value(_finalizado),
          copasJson: Value(copasJson),
          anchuraEjeJson: Value(anchuraEjeJson),
          cuotaPagat: Value(cuotaP),
          cuotaCoordinadora: Value(cuotaC),
          cuotaClub: Value(cuotaCl),
          motorSorteoMin: Value(motorMin),
          motorSorteoMax: Value(motorMax),
          tipoMotor: Value(tipoMotor),
          marcasPermitidasJson: Value(marcasJson),
          marcaTitulo: Value(mTitulo.isEmpty ? null : mTitulo),
          marcaLema: Value(mLema.isEmpty ? null : mLema),
          clubOrganizador: Value(club.isEmpty ? null : club),
          logoClub: Value(_logoClub),
          ordenPrimeraPrueba: Value(_ordenPrimera),
          campeonatoSemillaId: Value(_semillaId),
        ));
        // Al finalizar, el peso mínimo y los créditos de sus coches quedan
        // fijados con los del catálogo (lo ya fijado no se toca): cambiar
        // el catálogo para otra temporada no altera este campeonato.
        if (_finalizado && !_finalizadoOriginal) {
          await ref
              .read(repoCochesCampeonatoProvider)
              .fijarDesdeCatalogo(widget.campeonatoId!);
        }
        // Acaba de marcarse como finalizado: ofrecer la bonificación de cierre.
        if (_usaCreditos && _finalizado && !_finalizadoOriginal && mounted) {
          await _ofrecerBonificacionCierre(widget.campeonatoId!);
        }
        // Si es el campeonato activo, refrescar la copia en memoria para que
        // los cambios (rangos de dientes, etc.) se reflejen al instante.
        if (ref.read(campeonatoActivoProvider)?.id == widget.campeonatoId) {
          final fresh = await (db.select(db.campeonatos)
                ..where((t) => t.id.equals(widget.campeonatoId!)))
              .getSingleOrNull();
          if (fresh != null) {
            ref.read(campeonatoActivoProvider.notifier).seleccionar(fresh);
          }
        }
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        _aviso(l.noSePudoGuardar('$e'));
        setState(() => _guardando = false);
      }
    }
  }

  void _aviso(String m) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  /// Al marcar finalizado un campeonato con créditos, ofrece aplicar ya la
  /// bonificación de cierre (cada piloto recibe un movimiento que indica la
  /// bonificación por su nº de carreras y categoría).
  Future<void> _ofrecerBonificacionCierre(int campeonatoId) async {
    final l = context.l;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.bonificacionCierre),
        content: Text(l.bonifCierrePregunta(_tope.text.trim())),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l.ahoraNo)),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l.aplicar)),
        ],
      ),
    );
    if (ok != true) return;
    final n = await ref
        .read(repoCreditosProvider)
        .aplicarBonificacionCierre(campeonatoId, l);
    if (mounted) {
      _aviso(l.bonificacionAplicada(n));
    }
  }

  Future<void> _borrar() async {
    final l = context.l;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.eliminarCampeonato),
        content: Text(l.eliminarCampeonatoTexto(_nombre.text)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l.cancelar)),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l.eliminar)),
        ],
      ),
    );
    if (ok != true) return;
    final db = ref.read(dbProvider);
    await ref
        .read(repoCochesCampeonatoProvider)
        .quitarTodos(widget.campeonatoId!);
    await (db.delete(db.campeonatos)
          ..where((t) => t.id.equals(widget.campeonatoId!)))
        .go();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final esNuevo = widget.campeonatoId == null;
    final catalogoAsync = ref.watch(_catalogoCopasProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
            esNuevo ? context.l.nuevoCampeonato : context.l.editarCampeonato),
        actions: [
          if (!esNuevo)
            IconButton(
              tooltip: context.l.eliminar,
              icon: const Icon(Icons.delete_outline),
              onPressed: _borrar,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (esNuevo)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  context.l.obligatoriosAviso,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            _Seccion(
              titulo: context.l.datosBasicos,
              children: [
                TextFormField(
                  controller: _nombre,
                  decoration: InputDecoration(
                    labelText: context.l.nombreCampeonatoObligatorio,
                    helperText: context.l.nombreCampeonatoEjemplo,
                    prefixIcon: const Icon(Icons.emoji_events_outlined),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? context.l.indicaUnNombre
                      : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _formato,
                  decoration: InputDecoration(
                    labelText: context.l.formato,
                    prefixIcon: const Icon(Icons.groups_outlined),
                    helperText: context.l.formatoAyuda,
                  ),
                  items: [
                    DropdownMenuItem(
                        value: 'PAREJAS',
                        child: Text(context.l.formatoParejas)),
                    DropdownMenuItem(
                        value: 'INDIVIDUAL',
                        child: Text(context.l.formatoIndividual)),
                    const DropdownMenuItem(value: '24H', child: Text('24h')),
                    const DropdownMenuItem(value: '12H', child: Text('12h')),
                  ],
                  onChanged: (v) => setState(() => _formato = v ?? 'PAREJAS'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _anio,
                  decoration: InputDecoration(
                    labelText: context.l.anio,
                    prefixIcon: const Icon(Icons.calendar_today_outlined),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    final n = int.tryParse(v ?? '');
                    if (n == null || n < 2000 || n > 2100) {
                      return context.l.anioInvalido;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 4),
                SwitchListTile(
                  value: _activo,
                  onChanged: (v) => setState(() => _activo = v),
                  title: Text(esNuevo
                      ? context.l.activarCampeonatoAlCrear
                      : context.l.campeonatoVisible),
                  subtitle: Text(context.l.campeonatoVisibleAyuda),
                ),
              ],
            ),
            _Seccion(
              titulo: context.l.clubOrganizador,
              descripcion: context.l.clubOrgAyudaExportaciones,
              children: [
                SelectorClubLogo(
                  club: _club,
                  logo: _logoClub,
                  onLogo: (l) => setState(() => _logoClub = l),
                ),
              ],
            ),
            _Seccion(
              titulo: context.l.categoriasCopasObligatorio,
              children: [
                Text(
                  context.l.seleccionaCopasTexto,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                catalogoAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) =>
                      Text(context.l.errorDetalle('$e')),
                  data: (copas) {
                    // Asegurar que las copas ya seleccionadas (aunque no estén
                    // en el catálogo) aparezcan también
                    final todas = {...copas, ..._copasSel}.toList()..sort();
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: todas
                          .map((c) => FilterChip(
                                label: Text(c),
                                selected: _copasSel.contains(c),
                                onSelected: (v) => setState(() {
                                  if (v) {
                                    _copasSel.add(c);
                                  } else {
                                    _copasSel.remove(c);
                                  }
                                }),
                              ))
                          .toList(),
                    );
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _nuevaCopa,
                        decoration: InputDecoration(
                          labelText: context.l.anadirNuevaCategoria,
                          helperText: context.l.anadirNuevaCategoriaAyuda,
                          isDense: true,
                        ),
                        onSubmitted: (_) => _anadirCopaNueva(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      onPressed: _anadirCopaNueva,
                      icon: const Icon(Icons.add),
                      label: Text(context.l.anadir),
                    ),
                  ],
                ),
              ],
            ),
            _Seccion(
              titulo: context.l.motorObligatorio,
              children: [
                SelectorTipoMotor(
                  valor: _tipoMotor,
                  onCambio: (v) => setState(() => _tipoMotor = v),
                ),
                if (tipoMotorConSorteo(_tipoMotor)) ...[
                const SizedBox(height: 16),
                Text(
                  context.l.rangoMotorCampeonatoTexto,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _motorMin,
                        decoration: InputDecoration(
                          labelText: context.l.motorDesde,
                          prefixIcon: const Icon(Icons.tag),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _motorMax,
                        decoration: InputDecoration(
                          labelText: context.l.motorHasta,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          final min = int.tryParse(_motorMin.text.trim());
                          final max = int.tryParse(v?.trim() ?? '');
                          if (min == null && max == null) return null;
                          if (min == null || max == null) {
                            return context.l.indicaAmbos;
                          }
                          if (max < min) return context.l.hastaMayorQueDesde;
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                ],
              ],
            ),
            _Seccion(
              titulo: context.l.creditosYTesoreria,
              descripcion: context.l.creditosTesoreriaAyuda,
              children: [
                // --- Créditos (handicap) ---
                Text(context.l.menuCreditos,
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                SwitchListTile(
                  value: _usaCreditos,
                  onChanged: (v) => setState(() => _usaCreditos = v),
                  title: Text(context.l.usaCreditos),
                  subtitle: Text(context.l.usaCreditosAyuda),
                ),
                if (esNuevo && _usaCreditos) _selectorImportarPilotos(),
                if (_usaCreditos) ...[
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _tope,
                    decoration: InputDecoration(
                      labelText: context.l.topeRegularizacion,
                      helperText: context.l.topeRegularizacionAyuda,
                      prefixIcon: const Icon(Icons.toll_outlined),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      final n = int.tryParse(v ?? '');
                      if (n == null || n < 1) return context.l.numeroPositivo;
                      return null;
                    },
                  ),
                ],

                const SizedBox(height: 24),

                // --- Tesorería (cuotas/pagos) ---
                Text(context.l.menuTesoreria,
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                SwitchListTile(
                  value: _usaTesoreria,
                  onChanged: (v) => setState(() => _usaTesoreria = v),
                  title: Text(context.l.gestionaTesoreria),
                  subtitle: Text(context.l.gestionaTesoreriaAyuda),
                ),
                if (_usaTesoreria) ...[
                  const SizedBox(height: 12),
                  Text(
                    context.l.pagatTexto,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _cuotaPagat,
                          decoration: InputDecoration(
                            labelText: context.l.pagatObligatorio,
                            prefixIcon: const Icon(Icons.payments_outlined),
                          ),
                          validator: (v) {
                            final t = v?.trim() ?? '';
                            if (t.isEmpty) return context.l.indicaLaCuota;
                            if (double.tryParse(t.replaceAll(',', '.')) == null) {
                              return context.l.numeroNoValido;
                            }
                            return null;
                          },
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _cuotaCoord,
                          decoration: InputDecoration(
                            labelText: context.l.coordinadoraEurParentesis,
                          ),
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _cuotaClub,
                          decoration: InputDecoration(
                            labelText: context.l.clubEurParentesis,
                          ),
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 24),
              ],
            ),
            _seccionOrdenPrimeraPrueba(),
            // Al crear, lo opcional queda plegado. Visibility mantiene los
            // campos montados para que el formulario los siga validando.
            if (esNuevo && !_masOpciones)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.expand_more),
                  label: Text(context.l.masOpcionesPuntuacion),
                  onPressed: () => setState(() => _masOpciones = true),
                ),
              ),
            Visibility(
              visible: !esNuevo || _masOpciones,
              maintainState: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Seccion(
                    titulo: context.l.puntuacion,
                    children: [
                      TextFormField(
                        controller: _descartes,
                        decoration: InputDecoration(
                          labelText: context.l.numeroDescartes,
                          helperText: context.l.numeroDescartesAyuda,
                          prefixIcon: const Icon(Icons.delete_outline),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          final n = int.tryParse(v ?? '');
                          if (n == null || n < 0 || n > 5) {
                            return context.l.entreCeroYCinco;
                          }
                          return null;
                        },
                      ),
                      if (_esElActivo) ...[
                        const SizedBox(height: 8),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.format_list_numbered_outlined),
                          title: Text(context.l.tablaDePuntos),
                          subtitle: Text(context.l.tablaDePuntosAyuda),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => const PantallaEditorTablaPuntos())),
                        ),
                      ],
                    ],
                  ),
                  _Seccion(
                    titulo: context.l.verificacion,
                    descripcion: context.l.verificacionAyuda,
                    children: [
                      if (_copasSel.isNotEmpty) ...[
                        Text(context.l.anchuraEje,
                            style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: 4),
                        Text(
                          context.l.anchuraEjeCategoriasAyuda,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 8),
                        for (final copa in _copasSel.toList()..sort()) ...[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(context.l.copaTexto(copa),
                                style: Theme.of(context).textTheme.labelMedium),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _anchuraCtrl(copa, 'del'),
                                    decoration: InputDecoration(
                                      labelText: context.l.maxDelanteroMm,
                                      prefixIcon:
                                          const Icon(Icons.straighten_outlined),
                                      isDense: true,
                                    ),
                                    keyboardType: const TextInputType.numberWithOptions(
                                        decimal: true),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextFormField(
                                    controller: _anchuraCtrl(copa, 'tra'),
                                    decoration: InputDecoration(
                                      labelText: context.l.maxTraseroMm,
                                      prefixIcon:
                                          const Icon(Icons.straighten_outlined),
                                      isDense: true,
                                    ),
                                    keyboardType: const TextInputType.numberWithOptions(
                                        decimal: true),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],

                      if (!esNuevo) ...[
                        const SizedBox(height: 16),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.directions_car_outlined),
                          title: Text(_usaCreditos
                              ? context.l.pesoMinCreditos
                              : context.l.pesoMinCampeonato),
                          subtitle: Text(context.l.pesoMinCampeonatoAyuda),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => PantallaCochesCampeonato(
                                  campeonatoId: widget.campeonatoId!))),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Text(context.l.fabricante,
                          style: Theme.of(context).textTheme.titleSmall),
                      SelectorMarcasPermitidas(
                        activo: _limitarMarcas,
                        seleccion: _marcasPermitidas,
                        onActivo: (v) => setState(() => _limitarMarcas = v),
                        onCambio: (sel) => setState(() => _marcasPermitidas = sel),
                      ),
                    ],
                  ),
                  _Seccion(
                    titulo: context.l.marcaPdf,
                    children: [
                      Text(
                        context.l.marcaPdfTexto,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _marcaTitulo,
                        decoration: InputDecoration(
                          labelText: context.l.tituloCabecera,
                          hintText: context.l.tituloCabeceraEjemplo,
                          prefixIcon: const Icon(Icons.title),
                        ),
                        textCapitalization: TextCapitalization.characters,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _marcaLema,
                        decoration: InputDecoration(
                          labelText: context.l.lemaPie,
                          hintText: context.l.lemaPieEjemplo,
                          prefixIcon: const Icon(Icons.notes),
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (!esNuevo)
              _Seccion(
                titulo: context.l.estado,
                children: [
                  SwitchListTile(
                    value: _finalizado,
                    onChanged: (v) => setState(() => _finalizado = v),
                    title: Text(context.l.campeonatoFinalizadoTitulo),
                    subtitle: Text(context.l.campeonatoFinalizadoAyuda),
                  ),
                ],
              ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _guardando ? null : _guardar,
              icon: _guardando
                  ? const SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.check),
              label: Text(esNuevo
                  ? context.l.crearCampeonato
                  : context.l.guardarCambios),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tarjeta de una sección del editor, con su título y una explicación
/// opcional.
class _Seccion extends StatelessWidget {
  const _Seccion({
    required this.titulo,
    this.descripcion,
    required this.children,
  });

  final String titulo;
  final String? descripcion;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(titulo,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w700,
                    )),
            if (descripcion != null) ...[
              const SizedBox(height: 4),
              Text(descripcion!,
                  style: Theme.of(context).textTheme.bodySmall),
            ],
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}
