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
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

import '../../core/idioma.dart';
import '../../core/tema.dart';
import '../../core/proveedores.dart';
import '../../core/widgets/selector_buscable.dart';
import '../../data/database/app_database.dart';
import '../../domain/reglas_verificacion.dart';
import '../../domain/validador_verificacion.dart';
import '../../services/fotos_verificacion.dart';
import '../equipos/repositorio_equipos.dart';
import '../pruebas/repositorio_inscripciones_prueba.dart';
import '../sincronizacion/dispositivo_sync.dart';
import '../tesoreria/fila_pago_equipo.dart';
import '../tesoreria/repositorio_tesoreria.dart';
import 'frecuencias_verificacion.dart';
import 'reglas_verificacion_bd.dart';
import 'repositorio_verificaciones.dart';

/// Dientes distintos del catálogo de engranajes ya filtrado (tipo + copa).
List<int> _dientesDe(AsyncValue<List<CatalogoEngranaje>> async) {
  final lista = async.asData?.value ?? const [];
  return lista.map((e) => e.dientes).toSet().toList()..sort();
}

/// Copas del campeonato (`copasJson`); lista vacía si el JSON no es válido.
List<String> _copasDe(Campeonato c) {
  try {
    final raw = jsonDecode(c.copasJson);
    if (raw is List) return raw.map((e) => e.toString()).toList();
  } catch (_) {}
  return const [];
}

/// Materiales homologados (listas fijas del reglamento).
const _materialesPinon = ['PL', 'ERG', 'LAT', 'ACR', 'ALU'];
const _materialesCorona = ['PL', 'MET'];

class EditorVerificacion extends ConsumerStatefulWidget {
  const EditorVerificacion({
    super.key,
    required this.mangaId,
    required this.equipoId,
    this.verificacionId,
  });

  final int mangaId;
  final int equipoId;
  final int? verificacionId;

  @override
  ConsumerState<EditorVerificacion> createState() => _EditorVerificacionState();
}

class _EditorVerificacionState extends ConsumerState<EditorVerificacion> {
  final _pesoIni = TextEditingController();
  final _pesoFin = TextEditingController();
  final _pesoIniCoche = TextEditingController();
  final _pesoFinCoche = TextEditingController();
  final _motor = TextEditingController();
  final _motorRpm = TextEditingController();
  final _motorUms = TextEditingController();
  /// Check de altura de motor con la plancha: true = conforme, false = no
  /// conforme, null = no comprobado. No es una medida, es un sí/no.
  bool? _alturaMotorConforme;
  final _anchuraEjeDel = TextEditingController();
  final _anchuraEjeTra = TextEditingController();
  /// Estado estético de la carrocería: true = bien, false = le faltan
  /// piezas, null = no comprobado.
  bool? _carroceriaConforme;
  final _carroceriaPiezasFaltantes = TextEditingController();
  final _pinonDiametro = TextEditingController();
  final _coronaDiametro = TextEditingController();
  final _suspension = TextEditingController();
  final _observaciones = TextEditingController();
  String? _chasis;
  String _motorTipo = 'ORGANIZACION';
  int? _pruebaId;
  /// Campeonato de la prueba de esta manga: de él salen el reglamento
  /// (dientes, anchura de eje) y los créditos. No se usa el campeonato
  /// activo porque la manga puede ser de una sesión de verificación libre.
  Campeonato? _campeonato;
  /// Copa que corre el equipo EN esta prueba (snapshot); cae a la copa actual.
  String? _copaPrueba;

  int? _cocheId;
  String? _pinonMarca;
  /// Dientes del piñón: se eligen del catálogo de engranajes (tipo + copa).
  int? _pinonDientes;
  String? _pinonMaterial;
  String? _coronaMarca;
  int? _coronaDientes;
  String? _coronaMaterial;
  String? _llantaDelMarca;
  String? _llantaDelDim;
  String? _llantaTraMarca;
  String? _llantaTraDim;
  String? _bancada;
  String? _neumatico;
  /// Trencilla: marca del catálogo de marcas.
  String? _trencilla;

  bool _validada = false;
  /// Estado de validación tal como está guardado (no el del checkbox).
  bool _validadaGuardada = false;

  /// Reglamento guardado en la verificación (null = aún sin congelar) y el
  /// actual del catálogo/campeonato. Ver [_reglas].
  ReglasVerificacion? _reglasGuardadas;
  ReglasVerificacion? _reglasVivas;
  int _turnoReglas = 0;
  /// Fila del catálogo del coche elegido, aunque ya no esté activo o no
  /// tenga la copa (verificaciones antiguas).
  CatalogoCoche? _cocheFila;
  /// Peso mínimo y créditos de los coches fijados en el campeonato.
  Map<int, CochesCampeonatoData> _ajustesCoches = {};

  /// Bloqueo (campeonato finalizado o prueba terminada): la verificación
  /// se abre en solo lectura hasta que se desbloquea a propósito.
  MotivoBloqueo? _motivoBloqueo;
  bool _desbloqueada = false;

  bool _cargando = true;
  bool _guardando = false;

  // Autoguardado de borrador.
  int? _verifId;
  Timer? _debounce;
  bool _dirty = false;
  bool _autoguardando = false;
  _EstadoAuto _estado = _EstadoAuto.idle;

  // Sincronización entre Controls: si otro Control cambia esta verificación
  // mientras está abierta, se recarga (o se avisa si hay cambios sin guardar)
  // para no pisar lo que ha hecho el otro con datos viejos.
  StreamSubscription<List<Verificacione>>? _vigilancia;
  int _msVisto = 0;
  ScaffoldMessengerState? _messenger;

  Equipo? _equipo;
  Piloto? _piloto1;
  Piloto? _piloto2;
  int _creditosP1 = 0;
  int _creditosP2 = 0;
  List<String> _fotos = [];

  @override
  void initState() {
    super.initState();
    _verifId = widget.verificacionId;
    // Autoguardar al editar cualquier campo de texto.
    for (final c in _controllers) {
      c.addListener(_onCambio);
    }
    _cargar();
  }

  List<TextEditingController> get _controllers => [
        _pesoIni, _pesoFin, _pesoIniCoche, _pesoFinCoche,
        _motor, _motorRpm, _motorUms, _anchuraEjeDel, _anchuraEjeTra,
        _carroceriaPiezasFaltantes,
        _pinonDiametro, _coronaDiametro, _suspension, _observaciones,
      ];

  bool get _soloLectura => _motivoBloqueo != null && !_desbloqueada;

  /// Una verificación validada, o de un campeonato/prueba cerrados, se
  /// comprueba con el reglamento que se guardó al verificar, no con el
  /// catálogo actual.
  bool get _congelada =>
      _reglasGuardadas != null &&
      (_validadaGuardada || _motivoBloqueo != null);

  String? get _copaActual => _copaPrueba ?? _equipo?.copa;

  /// Motor que cuenta para el reglamento (solo el motor propio del catálogo).
  String? get _motorParaReglas {
    final m = _motor.text.trim();
    return _motorTipo == 'PROPIO' && m.isNotEmpty ? m : null;
  }

  /// Reglamento efectivo: el congelado si lo está (rehaciendo solo la parte
  /// que el verificador haya cambiado: coche, motor o copa), si no el actual.
  ReglasVerificacion? get _reglas {
    final g = _reglasGuardadas;
    final vivas = _reglasVivas;
    if (!_congelada || g == null) return vivas;
    if (vivas == null) return g;
    return g.combinar(
      vivas,
      coche: g.cocheId != _cocheId,
      motor: g.motor != _motorParaReglas,
      copa: g.copa != _copaActual,
    );
  }

  /// Recalcula el reglamento actual (catálogo + campeonato) para el coche,
  /// motor y copa que hay ahora en la ficha.
  Future<void> _refrescarReglas() async {
    final turno = ++_turnoReglas;
    final db = ref.read(dbProvider);
    final r = await CargadorReglas(db).actuales(
      mangaId: widget.mangaId,
      equipoId: widget.equipoId,
      cocheId: _cocheId,
      motorTipo: _motorTipo,
      motor: _motor.text,
      copa: _copaActual,
    );
    final coche = _cocheId == null
        ? null
        : await (db.select(db.catalogoCoches)
              ..where((t) => t.id.equals(_cocheId!)))
            .getSingleOrNull();
    if (!mounted || turno != _turnoReglas) return;
    setState(() {
      _reglasVivas = r;
      _cocheFila = coche;
    });
  }

  double _pesoMinDe(CatalogoCoche c) =>
      _ajustesCoches[c.id]?.pesoMin ?? c.pesoMin;
  int _creditosDe(CatalogoCoche c) =>
      _ajustesCoches[c.id]?.creditosCoche ?? c.creditosCoche;

  /// Programa un autoguardado de borrador tras una breve pausa sin cambios.
  void _onCambio() {
    if (_cargando || _soloLectura) return;
    _dirty = true;
    if (_estado != _EstadoAuto.guardando && mounted) {
      setState(() => _estado = _EstadoAuto.pendiente);
    }
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), _autoguardar);
  }

  /// `setState` + programar autoguardado, para campos no-texto (desplegables).
  /// Sortea un nº de motor de organización entre los disponibles de la prueba
  /// (rango del campeonato menos los ya asignados), sin salir de la verificación.
  Future<void> _sortearMotor() async {
    final l = context.l;
    final pruebaId = _pruebaId;
    if (pruebaId == null) return;
    final db = ref.read(dbProvider);
    final prueba = await (db.select(db.pruebas)
          ..where((t) => t.id.equals(pruebaId)))
        .getSingleOrNull();
    if (prueba == null) return;
    final camp = await (db.select(db.campeonatos)
          ..where((t) => t.id.equals(prueba.campeonatoId)))
        .getSingleOrNull();
    final min = camp?.motorSorteoMin, max = camp?.motorSorteoMax;
    if (!mounted) return;
    if (min == null || max == null || max < min) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(camp?.esVerificacionLibre ?? false
              ? l.configuraRangoSesion
              : l.configuraRangoCampeonato)));
      return;
    }
    // Motores ya asignados en la prueba (verificaciones de organización).
    final mangas = await (db.select(db.mangas)
          ..where((t) => t.pruebaId.equals(pruebaId)))
        .get();
    final mangaIds = mangas.map((m) => m.id).toList();
    final verifs = mangaIds.isEmpty
        ? <Verificacione>[]
        : await (db.select(db.verificaciones)
              ..where((t) => t.mangaId.isIn(mangaIds)))
            .get();
    final asignados = <int>{};
    for (final v in verifs) {
      if (v.motorTipo == 'ORGANIZACION' &&
          (v.motor?.trim().isNotEmpty ?? false)) {
        final n = int.tryParse(v.motor!.trim());
        if (n != null) asignados.add(n);
      }
    }
    // El motor actual del equipo vuelve a estar disponible (para re-sortear).
    final actual = int.tryParse(_motor.text.trim());
    final candidatos = <int>{
      for (var n = min; n <= max; n++)
        if (!asignados.contains(n)) n,
      ?actual,
    }.toList();
    if (!mounted) return;
    if (candidatos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.noQuedanMotores)),
      );
      return;
    }
    final rng = Random();
    final elegido = await showDialog<int>(
      context: context,
      builder: (ctx) {
        var n = candidatos[rng.nextInt(candidatos.length)];
        return StatefulBuilder(
          builder: (ctx, setSt) => AlertDialog(
            title: Text(l.sorteoDeMotor),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l.motorSorteado,
                    style: Theme.of(ctx).textTheme.labelLarge),
                const SizedBox(height: 8),
                Text('$n',
                    style: Theme.of(ctx).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Theme.of(ctx).colorScheme.primary)),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(l.cancelar)),
              if (candidatos.length > 1)
                TextButton.icon(
                  onPressed: () =>
                      setSt(() => n = candidatos[rng.nextInt(candidatos.length)]),
                  icon: const Icon(Icons.refresh),
                  label: Text(l.repetir),
                ),
              FilledButton(
                  onPressed: () => Navigator.pop(ctx, n),
                  child: Text(l.asignar)),
            ],
          ),
        );
      },
    );
    if (elegido == null) return;
    _cambiar(() => _motor.text = '$elegido');
  }

  /// [reglas]: el cambio afecta al reglamento (coche, motor o copa).
  void _cambiar(VoidCallback fn, {bool reglas = false}) {
    setState(fn);
    _onCambio();
    if (reglas) _refrescarReglas();
  }

  Future<void> _autoguardar() async {
    if (!mounted || _cargando || _guardando || _autoguardando || !_dirty) return;
    _autoguardando = true;
    // Optimista: si el usuario edita durante el guardado, _dirty volverá a
    // true y se reprogramará otro autoguardado (no se pierde el cambio).
    _dirty = false;
    if (mounted) setState(() => _estado = _EstadoAuto.guardando);
    try {
      // Guarda conservando el estado (borrador o validada) sin recalcular
      // créditos: eso solo ocurre al pulsar "Validar" o al borrar.
      await _persistir(validado: _validada, recalcularCreditos: false);
      if (mounted) setState(() => _estado = _EstadoAuto.guardado);
    } catch (_) {
      _dirty = true;
      if (mounted) setState(() => _estado = _EstadoAuto.error);
    } finally {
      _autoguardando = false;
    }
  }

  Future<void> _cargar() async {
    final db = ref.read(dbProvider);
    final manga = await (db.select(db.mangas)
          ..where((t) => t.id.equals(widget.mangaId)))
        .getSingleOrNull();
    _pruebaId = manga?.pruebaId;
    if (_pruebaId != null) {
      final prueba = await (db.select(db.pruebas)
            ..where((t) => t.id.equals(_pruebaId!)))
          .getSingleOrNull();
      if (prueba != null) {
        _campeonato = await (db.select(db.campeonatos)
              ..where((t) => t.id.equals(prueba.campeonatoId)))
            .getSingleOrNull();
      }
      _motivoBloqueo = motivoBloqueo(_campeonato, prueba);
    }
    if (_campeonato != null) {
      _ajustesCoches = {
        for (final a in await (db.select(db.cochesCampeonato)
              ..where((t) => t.campeonatoId.equals(_campeonato!.id)))
            .get())
          a.cocheCatalogoId: a,
      };
    }
    _equipo = await (db.select(db.equipos)
          ..where((t) => t.id.equals(widget.equipoId)))
        .getSingle();
    // Copa que corre el equipo en ESTA prueba (snapshot de inscripción).
    if (_pruebaId != null) {
      final ins = await (db.select(db.inscripcionesPrueba)
            ..where((t) =>
                t.pruebaId.equals(_pruebaId!) &
                t.equipoId.equals(widget.equipoId)))
          .getSingleOrNull();
      _copaPrueba = ins?.copa;
    }
    await _cargarCreditos();
    if (widget.verificacionId != null) {
      final v = await (db.select(db.verificaciones)
            ..where((t) => t.id.equals(widget.verificacionId!)))
          .getSingle();
      _aplicar(v);
    }
    // Si el campeonato fija el tipo de motor, manda sobre lo guardado.
    final tipoFijo =
        (_campeonato ?? ref.read(campeonatoActivoProvider))?.tipoMotor;
    if (tipoFijo != null) _motorTipo = tipoFijo;
    await _refrescarReglas();
    if (mounted) setState(() => _cargando = false);
    _vigilar();
  }

  /// Pilotos del equipo y sus créditos en el campeonato de la prueba.
  Future<void> _cargarCreditos() async {
    final db = ref.read(dbProvider);
    final activo = _campeonato ?? ref.read(campeonatoActivoProvider);
    _piloto1 = await (db.select(db.pilotos)
          ..where((t) => t.id.equals(_equipo!.piloto1Id)))
        .getSingle();
    if (_equipo!.piloto2Id != null) {
      _piloto2 = await (db.select(db.pilotos)
            ..where((t) => t.id.equals(_equipo!.piloto2Id!)))
          .getSingleOrNull();
    }
    if (activo != null) {
      final pc1 = await (db.select(db.pilotoCampeonato)
            ..where((t) =>
                t.pilotoId.equals(_piloto1!.id) &
                t.campeonatoId.equals(activo.id)))
          .getSingleOrNull();
      _creditosP1 = pc1?.creditosActuales ?? 0;
      if (_piloto2 != null) {
        final pc2 = await (db.select(db.pilotoCampeonato)
              ..where((t) =>
                  t.pilotoId.equals(_piloto2!.id) &
                  t.campeonatoId.equals(activo.id)))
            .getSingleOrNull();
        _creditosP2 = pc2?.creditosActuales ?? 0;
      }
    }
  }

  /// Vuelca en el formulario los datos guardados de [v].
  void _aplicar(Verificacione v) {
    _cocheId = v.cocheCatalogoId;
    _pesoIni.text = v.pesoInicial?.toString() ?? '';
    _pesoFin.text = v.pesoFinal?.toString() ?? '';
    _pesoIniCoche.text = v.pesoInicialCoche?.toString() ?? '';
    _pesoFinCoche.text = v.pesoFinalCoche?.toString() ?? '';
    _motor.text = v.motor ?? '';
    _motorTipo = v.motorTipo;
    _motorRpm.text = v.motorRpm?.toString() ?? '';
    _motorUms.text = v.motorUms?.toString() ?? '';
    _alturaMotorConforme = v.alturaMotorConforme;
    _anchuraEjeDel.text = v.anchuraEjeDel?.toString() ?? '';
    _anchuraEjeTra.text = v.anchuraEjeTra?.toString() ?? '';
    _carroceriaConforme = v.carroceriaConforme;
    _carroceriaPiezasFaltantes.text = v.carroceriaPiezasFaltantes ?? '';
    _pinonMarca = v.pinonMarca;
    _pinonDientes = v.pinonDientes;
    _pinonDiametro.text = v.pinonDiametro ?? '';
    _pinonMaterial = v.pinonMaterial;
    _coronaMarca = v.coronaMarca;
    _coronaDientes = v.coronaDientes;
    _coronaDiametro.text = v.coronaDiametro ?? '';
    _coronaMaterial = v.coronaMaterial;
    _llantaDelMarca = v.llantaDelMarca;
    _llantaDelDim = v.llantaDelDimension;
    _llantaTraMarca = v.llantaTraMarca;
    _llantaTraDim = v.llantaTraDimension;
    _trencilla = v.trencilla;
    _suspension.text = v.suspension ?? '';
    _bancada = v.bancada;
    _chasis = v.chasis;
    _neumatico = v.neumatico;
    _observaciones.text = v.observaciones ?? '';
    _validada = v.validado;
    _validadaGuardada = v.validado;
    _reglasGuardadas = ReglasVerificacion.decodificar(v.reglasJson);
    try {
      final raw = json.decode(v.fotosJson);
      if (raw is List) {
        // Normalizar entradas a solo el basename (rutas absolutas antiguas
        // dejan de tener sentido al restaurar backup en otro equipo).
        _fotos = raw
            .map((e) => FotosVerificacion.nombreParaBd(e.toString()))
            .toList();
      }
    } catch (_) {}
    _msVisto = v.modificadoMs ?? 0;
  }

  void _vigilar() {
    final db = ref.read(dbProvider);
    _vigilancia = (db.select(db.verificaciones)
          ..where((t) =>
              t.mangaId.equals(widget.mangaId) &
              t.equipoId.equals(widget.equipoId))
          ..limit(1))
        .watch()
        .listen((l) {
      if (l.isNotEmpty) _alCambiarFuera(l.first);
    });
  }

  /// La fila ha cambiado en la BD: si lo ha hecho otro Control (llegado por
  /// la sincronización), se recarga el formulario.
  void _alCambiarFuera(Verificacione v) {
    if (!mounted || _cargando) return;
    final ms = v.modificadoMs ?? 0;
    if (v.modificadoPor == DispositivoSync.nombre || ms <= _msVisto) return;
    final l = context.l;
    final quien = v.modificadoPor ?? l.otroControl;
    if (_dirty || _autoguardando || _guardando) {
      _messenger?.showMaterialBanner(MaterialBanner(
        content: Text(l.cambiadaFueraTexto(quien)),
        leading: const Icon(Icons.sync_problem_outlined),
        actions: [
          TextButton(
            onPressed: () {
              _messenger?.hideCurrentMaterialBanner();
              _msVisto = ms;
            },
            child: Text(l.seguirConLoMio),
          ),
          TextButton(
            onPressed: () {
              _messenger?.hideCurrentMaterialBanner();
              _recargarDesde(v);
            },
            child: Text(l.verLoDe(quien)),
          ),
        ],
      ));
      return;
    }
    _recargarDesde(v);
    _messenger?.showSnackBar(SnackBar(
        content: Text(l.actualizadaConCambios(quien))));
  }

  void _recargarDesde(Verificacione v) {
    _debounce?.cancel();
    // Con _cargando los listeners de los campos no programan autoguardado.
    _cargando = true;
    _aplicar(v);
    final tipoFijo =
        (_campeonato ?? ref.read(campeonatoActivoProvider))?.tipoMotor;
    if (tipoFijo != null) _motorTipo = tipoFijo;
    _verifId = v.id;
    _dirty = false;
    _cargando = false;
    if (mounted) setState(() => _estado = _EstadoAuto.guardado);
    _refrescarReglas();
  }

  Future<void> _anadirFoto(ImageSource source) async {
    if (_fotos.length >= 4) return;
    try {
      final picker = ImagePicker();
      final xfile = await picker.pickImage(
        source: source,
        imageQuality: 75,
        maxWidth: 1600,
      );
      if (xfile == null) return;
      // Copiar a la carpeta persistente. En la BD guardamos solo el nombre
      // del archivo (para que la copia de seguridad sea portable entre
      // dispositivos).
      final dir = await FotosVerificacion.carpeta();
      final ts = DateTime.now().millisecondsSinceEpoch;
      final ext = p.extension(xfile.path).isEmpty
          ? '.jpg'
          : p.extension(xfile.path);
      final nombre = 'verif-$ts$ext';
      final destino = File(p.join(dir.path, nombre));
      await File(xfile.path).copy(destino.path);
      setState(() => _fotos.add(nombre));
      _onCambio();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l.noSePudoAnadirFoto('$e'))),
      );
    }
  }

  void _eliminarFoto(int idx) async {
    if (idx < 0 || idx >= _fotos.length) return;
    final entrada = _fotos[idx];
    setState(() => _fotos.removeAt(idx));
    _onCambio();
    try {
      final f = await FotosVerificacion.resolver(entrada);
      if (f.existsSync()) f.deleteSync();
    } catch (_) {}
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _messenger = ScaffoldMessenger.maybeOf(context);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _vigilancia?.cancel();
    _messenger?.hideCurrentMaterialBanner();
    for (final c in _controllers) {
      c.removeListener(_onCambio);
    }
    _pesoIni.dispose();
    _pesoFin.dispose();
    _pesoIniCoche.dispose();
    _pesoFinCoche.dispose();
    _motor.dispose();
    _motorRpm.dispose();
    _motorUms.dispose();
    _anchuraEjeDel.dispose();
    _anchuraEjeTra.dispose();
    _carroceriaPiezasFaltantes.dispose();
    _pinonDiametro.dispose();
    _coronaDiametro.dispose();
    _suspension.dispose();
    _observaciones.dispose();
    super.dispose();
  }

  double? _parseDouble(String s) {
    if (s.trim().isEmpty) return null;
    return double.tryParse(s.trim().replaceAll(',', '.'));
  }

  int? _parseInt(String s) {
    if (s.trim().isEmpty) return null;
    return int.tryParse(s.trim());
  }

  /// Guarda (o actualiza) la verificación y memoriza el id para reusarlo en
  /// los siguientes autoguardados.
  Future<int> _persistir({
    required bool validado,
    bool recalcularCreditos = true,
  }) async {
    // Reglamento con el que queda la verificación: el actual mientras es un
    // borrador; el congelado (con lo que se haya cambiado) si ya lo estaba.
    await _refrescarReglas();
    final reglas = _reglas;
    final pesoMin = _cocheId == null ? null : reglas?.pesoMin;
    final id = await ref.read(repoVerificacionesProvider).guardar(
          id: _verifId,
          recalcularCreditos: recalcularCreditos,
          mangaId: widget.mangaId,
          equipoId: widget.equipoId,
          cocheCatalogoId: _cocheId,
          pesoInicial: _parseDouble(_pesoIni.text),
          pesoFinal: _parseDouble(_pesoFin.text),
          pesoMin: pesoMin,
          pesoInicialCoche: _parseDouble(_pesoIniCoche.text),
          pesoFinalCoche: _parseDouble(_pesoFinCoche.text),
          motor: _vacio(_motor),
          motorTipo: _motorTipo,
          motorRpm: _parseInt(_motorRpm.text),
          motorUms: _parseDouble(_motorUms.text),
          alturaMotorConforme: _alturaMotorConforme,
          anchuraEjeDel: _parseDouble(_anchuraEjeDel.text),
          anchuraEjeTra: _parseDouble(_anchuraEjeTra.text),
          carroceriaConforme: _carroceriaConforme,
          carroceriaPiezasFaltantes: _carroceriaConforme == false
              ? _vacio(_carroceriaPiezasFaltantes)
              : null,
          pinonMarca: _pinonMarca,
          pinonDientes: _pinonDientes,
          pinonDiametro: _vacio(_pinonDiametro),
          pinonMaterial: _pinonMaterial,
          coronaMarca: _coronaMarca,
          coronaDientes: _coronaDientes,
          coronaDiametro: _vacio(_coronaDiametro),
          coronaMaterial: _coronaMaterial,
          llantaDelMarca: _llantaDelMarca,
          llantaDelDimension: _llantaDelDim,
          llantaTraMarca: _llantaTraMarca,
          llantaTraDimension: _llantaTraDim,
          trencilla: _trencilla,
          suspension: _vacio(_suspension),
          bancada: _bancada,
          chasis: _chasis,
          neumatico: _neumatico,
          observaciones: _vacio(_observaciones),
          validado: validado,
          fotosJson: json.encode(_fotos),
          reglasJson: reglas?.codificar(),
        );
    _verifId = id;
    _reglasGuardadas = reglas;
    _validadaGuardada = validado;
    return id;
  }

  Future<void> _guardar({bool validar = false}) async {
    _debounce?.cancel();
    setState(() => _guardando = true);
    try {
      await _persistir(validado: validar ? true : _validada);
      _dirty = false;
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l.noSePudoGuardar('$e'))),
        );
        setState(() => _guardando = false);
      }
    }
  }

  String? _vacio(TextEditingController c) {
    final t = c.text.trim();
    return t.isEmpty ? null : t;
  }

  /// Edita la copa del equipo/piloto SOLO para esta prueba (no toca la copa
  /// del equipo ni otras pruebas): es la que se usa para filtrar catálogos
  /// y comprobaciones aquí. Actualiza `_copaPrueba` al guardar, lo que
  /// recalcula en vivo los desplegables y validaciones de la ficha.
  Future<void> _editarCopa() async {
    final pruebaId = _pruebaId;
    final equipo = _equipo;
    if (pruebaId == null || equipo == null) return;
    final copas = _campeonato == null
        ? ref.read(copasProvider)
        : _copasDe(_campeonato!);
    final l = context.l;
    String? seleccion = _copaPrueba ?? equipo.copa;
    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSt) => AlertDialog(
          title: Text(l.copaEnEstaPrueba),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.copaEnEstaPruebaTexto,
                style: Theme.of(ctx).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: seleccion,
                decoration: InputDecoration(
                  labelText: l.copaCategoria,
                  prefixIcon: const Icon(Icons.flag_outlined),
                ),
                items: copas
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setSt(() => seleccion = v),
              ),
              if (_copaPrueba != null) ...[
                const SizedBox(height: 8),
                Text(l.copaDelEquipo(equipo.copa),
                    style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                        color: Theme.of(ctx).colorScheme.outline)),
              ],
            ],
          ),
          actions: [
            if (_copaPrueba != null)
              TextButton(
                onPressed: () async {
                  await ref
                      .read(repoInscripcionesPruebaProvider)
                      .fijarCopaPrueba(
                          pruebaId: pruebaId,
                          equipoId: widget.equipoId,
                          copa: null);
                  if (mounted) _alCambiarCopa(null);
                  if (ctx.mounted) Navigator.pop(ctx);
                },
                child: Text(l.usarLaDelEquipo),
              ),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l.cancelar),
            ),
            FilledButton(
              onPressed: seleccion == null
                  ? null
                  : () async {
                      await ref
                          .read(repoInscripcionesPruebaProvider)
                          .fijarCopaPrueba(
                              pruebaId: pruebaId,
                              equipoId: widget.equipoId,
                              copa: seleccion);
                      if (mounted) _alCambiarCopa(seleccion);
                      if (ctx.mounted) Navigator.pop(ctx);
                    },
              child: Text(l.guardar),
            ),
          ],
        ),
      ),
    );
  }

  /// La copa en la prueba cambia el reglamento (anchura de eje, llantas,
  /// neumáticos…): se recalcula y, si ya hay verificación, se guarda.
  void _alCambiarCopa(String? copa) {
    setState(() => _copaPrueba = copa);
    if (_verifId != null) _onCambio();
    _refrescarReglas();
  }

  /// Pasa una verificación congelada al reglamento actual (catálogo y
  /// campeonato de hoy), previa confirmación. Si estaba validada, también
  /// se recalculan sus créditos.
  Future<void> _usarReglamentoActual(List<String> diferencias) async {
    final l = context.l;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.usarReglamentoActual),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.usarReglamentoActualTexto),
            const SizedBox(height: 8),
            for (final d in diferencias) Text('• $d'),
            if (_validadaGuardada) ...[
              const SizedBox(height: 8),
              Text(l.recalcularanCreditos),
            ],
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l.cancelar)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l.usarElActual)),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    _debounce?.cancel();
    setState(() {
      _reglasGuardadas = _reglasVivas;
      _estado = _EstadoAuto.guardando;
    });
    try {
      await _persistir(validado: _validadaGuardada);
      _dirty = false;
      await _cargarCreditos();
      if (mounted) setState(() => _estado = _EstadoAuto.guardado);
    } catch (e) {
      if (mounted) setState(() => _estado = _EstadoAuto.error);
    }
  }

  /// Quita el bloqueo de solo lectura (campeonato finalizado / prueba
  /// terminada) para corregir algo, previa confirmación.
  Future<void> _desbloquear() async {
    final l = context.l;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.desbloquearVerificacion),
        content: Text(l.desbloquearTexto(_motivoBloqueo?.texto(l) ?? '')),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l.cancelar)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l.desbloquear)),
        ],
      ),
    );
    if (ok == true && mounted) setState(() => _desbloqueada = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final marcasAsync = ref.watch(marcasCodigosProvider);
    // Los desplegables ponen primero lo más elegido en verificaciones previas.
    final uso = ref.watch(frecuenciasVerificacionProvider).asData?.value ??
        FrecuenciasVerificacion.vacia;
    // Filtramos coches, bancadas, motores, neumáticos y llantas por la copa del equipo
    // Copa que corre el equipo EN esta prueba (snapshot); cae a la copa actual.
    final copaEquipo = _copaPrueba ?? _equipo?.copa;
    final llantasDelAsync = ref.watch(llantasDelFiltradasProvider(copaEquipo));
    final llantasTraAsync = ref.watch(llantasTraFiltradasProvider(copaEquipo));
    final neumaticosAsync = ref.watch(neumaticosFiltradosProvider(copaEquipo));
    final campActivo = _campeonato ?? ref.watch(campeonatoActivoProvider);
    // Reglamento contra el que se comprueba (congelado o actual).
    final reglas = _reglas;
    final anchuraEjeDelMax = reglas?.anchuraEjeDelMax;
    final anchuraEjeTraMax = reglas?.anchuraEjeTraMax;
    // Limitar fabricante: los desplegables de marca solo ofrecen las
    // permitidas por el campeonato (vacío = todas las del catálogo).
    final marcasPermitidas = reglas?.marcasPermitidas ?? const <String>{};
    final marcasSelAsync = marcasPermitidas.isEmpty
        ? marcasAsync
        : marcasAsync.whenData((_) => marcasPermitidas);
    final cochesAsync = ref.watch(
        cochesFiltradosProvider(copaEquipo));
    final bancadasFiltAsync = ref.watch(bancadasFiltradasProvider(copaEquipo));
    final motoresAsync = ref.watch(motoresFiltradosProvider(copaEquipo));
    // Marcas de piñón/corona homologadas para la copa (si hay catálogo de
    // engranajes con copa; si no, se usan todas las marcas del componente).
    final pinonesAsync = ref
        .watch(engranajesFiltradosProvider((copa: copaEquipo, tipo: 'PINON')));
    final coronasAsync = ref
        .watch(engranajesFiltradosProvider((copa: copaEquipo, tipo: 'CORONA')));
    final motores =
        motoresAsync.maybeWhen(data: (d) => d, orElse: () => <CatalogoMotore>[]);
    // Motor del catálogo seleccionado (se guarda su nombre en `motor`).
    final motorSel = _motorTipo == 'PROPIO'
        ? motores
            .where((m) => m.nombre == _motor.text.trim())
            .firstOrNull
        : null;

    final cs = Theme.of(context).colorScheme;

    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final nav = Navigator.of(context);
        _debounce?.cancel();
        if (_dirty) await _autoguardar();
        if (mounted) nav.pop();
      },
      child: Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_equipo?.nombre ?? context.l.verificacion),
            if (_equipo != null)
              InkWell(
                onTap: _pruebaId == null || _soloLectura ? null : _editarCopa,
                borderRadius: BorderRadius.circular(4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.l.copaTexto(_copaPrueba ?? _equipo!.copa),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    if (_pruebaId != null && !_soloLectura) ...[
                      const SizedBox(width: 4),
                      Icon(Icons.edit_outlined,
                          size: 14,
                          color: Theme.of(context).colorScheme.primary),
                    ],
                  ],
                ),
              ),
          ],
        ),
        actions: [
          _IndicadorGuardado(estado: _estado),
          if (_soloLectura)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Icon(Icons.lock_outline),
            ),
          if (_verifId != null && !_soloLectura)
            IconButton(
              tooltip: context.l.eliminarVerificacion,
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                final l = context.l;
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(l.eliminarVerificacion),
                    content: Text(l.eliminarVerificacionTexto),
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
                if (!context.mounted) return;
                if (ok == true && _verifId != null) {
                  final nav = Navigator.of(context);
                  // Evitar que un autoguardado pendiente resucite la verificación.
                  _debounce?.cancel();
                  _dirty = false;
                  await ref
                      .read(repoVerificacionesProvider)
                      .borrar(_verifId!);
                  if (mounted) nav.pop();
                }
              },
            ),
        ],
      ),
      body: cochesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(context.l.errorDetalle('$e'))),
        data: (cochesCopa) {
          // El coche guardado sigue apareciendo aunque ya no esté activo o
          // no tenga la copa (verificaciones antiguas).
          final coches = [
            ...cochesCopa,
            if (_cocheFila != null &&
                _cocheFila!.id == _cocheId &&
                !cochesCopa.any((c) => c.id == _cocheId))
              _cocheFila!,
          ];
          final cocheSel = coches.firstWhere(
            (c) => c.id == _cocheId,
            orElse: () => CatalogoCoche(
              id: -1, nombre: '', marca: '', modelo: '',
              pesoMin: 0, creditosCoche: 0, activo: true, copasJson: '[]',
            ),
          );

          final datos = DatosVerificacion(
            pesoInicial: _parseDouble(_pesoIni.text),
            pesoFinal: _parseDouble(_pesoFin.text),
            pesoMinCoche: _cocheId == null ? null : reglas?.pesoMin,
            creditosCoche: _cocheId == null ? null : reglas?.creditosCoche,
            motor: _vacio(_motor),
            motorTipo: _motorTipo,
            motorRpm: _parseInt(_motorRpm.text),
            motorUms: _parseDouble(_motorUms.text),
            motorRefNombre: reglas?.motorRefNombre,
            motorRefRpm: reglas?.motorRefRpm,
            motorRefGauss: reglas?.motorRefGauss,
            alturaMotorConforme: _alturaMotorConforme,
            anchuraEjeDel: _parseDouble(_anchuraEjeDel.text),
            anchuraEjeDelMax: anchuraEjeDelMax,
            anchuraEjeTra: _parseDouble(_anchuraEjeTra.text),
            anchuraEjeTraMax: anchuraEjeTraMax,
            pinonMarca: _pinonMarca,
            pinonDientes: _pinonDientes,
            coronaMarca: _coronaMarca,
            coronaDientes: _coronaDientes,
            llantaDelMarca: _llantaDelMarca,
            llantaDelDimension: _llantaDelDim,
            llantaTraMarca: _llantaTraMarca,
            llantaTraDimension: _llantaTraDim,
            trencilla: _trencilla,
            suspension: _vacio(_suspension),
            bancada: _bancada,
            chasis: _chasis,
            neumatico: _neumatico,
            marcasValidas: reglas?.marcasValidas ?? const {},
            marcasPermitidas: marcasPermitidas,
            llantasDelValidas: reglas?.llantasDelValidas ?? const {},
            llantasTraValidas: reglas?.llantasTraValidas ?? const {},
            bancadasValidas: reglas?.bancadasValidas ?? const {},
            neumaticosValidos: reglas?.neumaticosValidos ?? const {},
          );
          final res = ValidadorVerificacion.validar(datos);

          // Qué le falta a cada bloque, para marcarlo y no saltarse nada.
          bool lleno(TextEditingController c) => c.text.trim().isNotEmpty;
          bool hay(Object? v) => v != null && '$v'.isNotEmpty;
          // Las claves son estables (no dependen del idioma): el nombre
          // visible lo pone _etiquetaBloque.
          final bloques = <String, _InfoBloque>{
            'coche': _InfoBloque.de(res, [_cocheId != null], const []),
            'peso': _InfoBloque.de(
                res, [lleno(_pesoIni)], const ['pesoInicial', 'pesoFinal']),
            'estetica':
                _InfoBloque.de(res, [_carroceriaConforme != null], const []),
            'motor': _InfoBloque.de(
              res,
              [
                lleno(_motor),
                if (_motorTipo == 'PROPIO') ...[
                  lleno(_motorRpm),
                  lleno(_motorUms),
                ],
                _alturaMotorConforme != null,
              ],
              const ['motor', 'motorRpm', 'motorUms', 'alturaMotorConforme'],
            ),
            // Solo cuenta el lado con máximo configurado para la copa.
            'eje': _InfoBloque.de(
              res,
              [
                if (anchuraEjeDelMax != null) lleno(_anchuraEjeDel),
                if (anchuraEjeTraMax != null) lleno(_anchuraEjeTra),
              ],
              const ['anchuraEjeDel', 'anchuraEjeTra'],
            ),
            'llantaDel': _InfoBloque.de(
                res,
                [hay(_llantaDelMarca), hay(_llantaDelDim)],
                const ['llantaDelMarca', 'llantaDelDimension']),
            'llantaTra': _InfoBloque.de(
                res,
                [hay(_llantaTraMarca), hay(_llantaTraDim)],
                const ['llantaTraMarca', 'llantaTraDimension']),
            'pinon': _InfoBloque.de(
                res,
                [hay(_pinonMarca), hay(_pinonDientes), hay(_pinonMaterial)],
                const ['pinonMarca', 'pinonDientes']),
            'corona': _InfoBloque.de(
                res,
                [hay(_coronaMarca), hay(_coronaDientes), hay(_coronaMaterial)],
                const ['coronaMarca', 'coronaDientes']),
            'bancada': _InfoBloque.de(res, [hay(_bancada)], const ['bancada']),
            'chasis': _InfoBloque.de(res, [hay(_chasis)], const []),
            'pesoCoche':
                _InfoBloque.de(res, [lleno(_pesoIniCoche)], const []),
            'otros': _InfoBloque.de(
                res,
                [hay(_neumatico), hay(_trencilla), lleno(_suspension)],
                const ['neumatico', 'trencilla']),
          };

          final usaCreditos = campActivo?.usaCreditos ?? false;
          final diferencias =
              _congelada && reglas != null && _reglasVivas != null
                  ? reglas.diferenciasCon(_reglasVivas!, context.l)
                  : const <String>[];
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (_motivoBloqueo != null) ...[
                _AvisoBloqueo(
                  motivo: _motivoBloqueo!.texto(context.l),
                  soloLectura: _soloLectura,
                  onDesbloquear: _desbloquear,
                ),
                const SizedBox(height: 12),
              ],
              if (_congelada && reglas != null) ...[
                _AvisoReglamento(
                  reglas: reglas,
                  diferencias: diferencias,
                  onUsarActual: _soloLectura || diferencias.isEmpty
                      ? null
                      : () => _usarReglamentoActual(diferencias),
                ),
                const SizedBox(height: 12),
              ],
              // Solo lectura: se ve todo, pero no se puede tocar nada.
              IgnorePointer(
                ignoring: _soloLectura,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
              if (usaCreditos && _piloto1 != null)
                _BloqueEquipoCreditos(
                  equipo: _equipo!,
                  piloto1: _piloto1!,
                  creditosP1: _creditosP1,
                  piloto2: _piloto2,
                  creditosP2: _creditosP2,
                  creditosCoche: cocheSel.id < 0 ? null : reglas?.creditosCoche,
                  validada: _validada,
                ),
              if (usaCreditos && _piloto1 != null)
                const SizedBox(height: 12),
              _Resumen(resultado: res),
              const SizedBox(height: 12),
              _ProgresoBloques(bloques: bloques),
              const SizedBox(height: 16),

              // Cobrar la cuota aquí mismo, sin salir a la tesorería.
              if (_pruebaId != null &&
                  (campActivo?.usaTesoreria ?? false) &&
                  !(campActivo?.esVerificacionLibre ?? false)) ...[
                _Bloque(
                  titulo: context.l.menuTesoreria,
                  info: null,
                  children: [
                    _PagoEnVerificacion(
                      pruebaId: _pruebaId!,
                      equipoId: widget.equipoId,
                      campeonato: campActivo!,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              _Bloque(
                titulo: context.l.coche,
                info: bloques['coche'],
                children: [
                SelectorBuscable<CatalogoCoche>(
                  etiqueta: context.l.modeloCoche,
                  titulo: context.l.elegirCoche,
                  icono: Icons.directions_car_outlined,
                  helper: coches.isEmpty && copaEquipo != null
                      ? context.l.noHayCochesConCopa(copaEquipo)
                      : context.l.ayudaSelectorCoche,
                  valor: coches.where((c) => c.id == _cocheId).firstOrNull,
                  opciones: uso.ordenar('coche', coches, (c) => c.id),
                  etiquetaOpcion: (c) => c.nombre,
                  subtituloOpcion: (c) =>
                      '${_pesoMinDe(c).toStringAsFixed(2)}g · '
                      '${_creditosDe(c) >= 0 ? "+" : ""}${_creditosDe(c)} '
                      '${context.l.creditosAbrev}',
                  onCambio: (c) =>
                      _cambiar(() => _cocheId = c?.id, reglas: true),
                ),
                if (cocheSel.id >= 0) ...[
                  const SizedBox(height: 8),
                  if (cocheSel.fotoPath != null)
                    _FotoCocheReferencia(fotoPath: cocheSel.fotoPath!)
                  else
                    const _SinFotoCoche(),
                ],
                ],
              ),
              const SizedBox(height: 16),

              _SecHead(context.l.carroceria),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _Bloque(
                      titulo: context.l.pesoGramos,
                      info: bloques['peso'],
                      children: [
                        TextField(
                          controller: _pesoIni,
                          decoration: InputDecoration(
                            labelText: context.l.pesoCarroceria,
                            helperText: cocheSel.id < 0 || reglas?.pesoMin == null
                                ? null
                                : context.l.minimoG(
                                    reglas!.pesoMin!.toStringAsFixed(2)),
                          ),
                          keyboardType:
                              const TextInputType.numberWithOptions(
                                  decimal: true),
                          onChanged: (_) => setState(() {}),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _Bloque(
                      titulo: context.l.estetica,
                      info: bloques['estetica'],
                      children: [
                        SegmentedButton<bool?>(
                          segments: [
                            ButtonSegment(
                              value: null,
                              label: Text(context.l.sinComprobar),
                            ),
                            ButtonSegment(
                              value: true,
                              label: Text(context.l.bien),
                              icon: const Icon(Icons.check_circle_outline),
                            ),
                            ButtonSegment(
                              value: false,
                              label: Text(context.l.faltanPiezas),
                              icon: const Icon(Icons.report_problem_outlined),
                            ),
                          ],
                          selected: {_carroceriaConforme},
                          onSelectionChanged: (s) =>
                              _cambiar(() => _carroceriaConforme = s.first),
                        ),
                        if (_carroceriaConforme == false) ...[
                          const SizedBox(height: 8),
                          TextField(
                            controller: _carroceriaPiezasFaltantes,
                            decoration: InputDecoration(
                              labelText: context.l.quePiezasFaltan,
                            ),
                            maxLines: 2,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Orden de verificación según flujo solicitado:
              // motor | peso carrocería · llantas D|T · piñón|corona ·
              // bancada|chasis · peso coche entero · otros (neumático,
              // trencilla, suspensión) · observaciones · fotos · validar.

              // 1) Motor / Peso carrocería
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _Bloque(
                      titulo: context.l.motor,
                      info: bloques['motor'],
                      children: [
                        // El campeonato puede fijar el tipo; solo en los
                        // mixtos se elige aquí.
                        if (campActivo?.tipoMotor == null)
                        SegmentedButton<String>(
                          segments: [
                            ButtonSegment(
                              value: 'ORGANIZACION',
                              label: Text(context.l.organizacion),
                              icon: const Icon(Icons.business_outlined),
                            ),
                            ButtonSegment(
                              value: 'PROPIO',
                              label: Text(context.l.propio),
                              icon: const Icon(Icons.engineering_outlined),
                            ),
                          ],
                          selected: {_motorTipo},
                          onSelectionChanged: (s) {
                            _cambiar(() => _motorTipo = s.first, reglas: true);
                          },
                        ),
                        if (campActivo?.tipoMotor == null)
                          const SizedBox(height: 8),
                        if (_motorTipo == 'ORGANIZACION')
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _motor,
                                  decoration: InputDecoration(
                                    labelText: context.l.numeroDeMotor,
                                    prefixIcon: const Icon(Icons.tag),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 8),
                              FilledButton.tonalIcon(
                                onPressed: _sortearMotor,
                                icon: const Icon(Icons.casino_outlined),
                                label: Text(context.l.sortear),
                              ),
                            ],
                          )
                        else ...[
                          SelectorBuscable<CatalogoMotore>(
                            etiqueta: context.l.motorDelCatalogo,
                            titulo: context.l.elegirMotor,
                            icono: Icons.bolt_outlined,
                            helper: reglas?.motorRefNombre != null
                                ? '${motorSel == null ? '${context.l.yaNoEnCatalogo(reglas!.motorRefNombre!)} · ' : ''}'
                                    '${context.l.refMotor('${reglas!.motorRefRpm ?? "—"}', '${reglas.motorRefGauss ?? "—"}')}'
                                : context.l.motoresHomologadosCopa(copaEquipo ?? ''),
                            valor: motorSel,
                            opciones: uso.ordenar('motor', motores, (m) => m.nombre),
                            etiquetaOpcion: (m) => m.nombre,
                            subtituloOpcion: (m) => context.l.rpmYGauss(
                                '${m.rpm ?? "—"}', '${m.gauss ?? "—"}'),
                            onCambio: (m) => _cambiar(
                                () => _motor.text = m?.nombre ?? '',
                                reglas: true),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _motorRpm,
                                  decoration: InputDecoration(
                                    labelText: 'RPM',
                                    prefixIcon:
                                        const Icon(Icons.speed_outlined),
                                    helperText: reglas?.motorRefRpm == null
                                        ? null
                                        : context.l
                                            .maxN('${reglas!.motorRefRpm}'),
                                    // ✓/✗ en vivo contra la referencia del
                                    // catálogo (la infracción real, si la
                                    // hay, también sale en el resumen de
                                    // arriba, pero aquí se ve al momento).
                                    suffixIcon: _iconoCumpleMotor(
                                        context,
                                        cs,
                                        _parseInt(_motorRpm.text),
                                        reglas?.motorRefRpm,
                                        maximo: true),
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _motorUms,
                                  decoration: InputDecoration(
                                    labelText: 'uMs',
                                    helperText: reglas?.motorRefGauss == null
                                        ? null
                                        : context.l
                                            .maxN('${reglas!.motorRefGauss}'),
                                    suffixIcon: _iconoCumpleMotor(
                                        context,
                                        cs,
                                        _parseDouble(_motorUms.text),
                                        reglas?.motorRefGauss,
                                        maximo: true),
                                  ),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 12),
                        Text(context.l.alturaMotorAPista,
                            style: Theme.of(context).textTheme.labelLarge),
                        const SizedBox(height: 4),
                        Text(
                          context.l.alturaMotorTexto,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 8),
                        SegmentedButton<bool?>(
                          segments: [
                            ButtonSegment(
                              value: null,
                              label: Text(context.l.sinComprobar),
                            ),
                            ButtonSegment(
                              value: true,
                              label: Text(context.l.conforme),
                              icon: const Icon(Icons.check_circle_outline),
                            ),
                            ButtonSegment(
                              value: false,
                              label: Text(context.l.noConforme),
                              icon: const Icon(Icons.cancel_outlined),
                            ),
                          ],
                          selected: {_alturaMotorConforme},
                          onSelectionChanged: (s) =>
                              _cambiar(() => _alturaMotorConforme = s.first),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _Bloque(
                      titulo: context.l.anchuraEjeMm,
                      info: bloques['eje'],
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _anchuraEjeDel,
                                decoration: InputDecoration(
                                  labelText: context.l.delantero,
                                  prefixIcon:
                                      const Icon(Icons.straighten_outlined),
                                  helperText: anchuraEjeDelMax == null
                                      ? null
                                      : context.l.maxN('$anchuraEjeDelMax'),
                                  suffixIcon: _iconoCumpleMotor(
                                      context,
                                      cs,
                                      _parseDouble(_anchuraEjeDel.text),
                                      anchuraEjeDelMax,
                                      maximo: true),
                                ),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                onChanged: (_) => setState(() {}),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _anchuraEjeTra,
                                decoration: InputDecoration(
                                  labelText: context.l.trasero,
                                  helperText: anchuraEjeTraMax == null
                                      ? null
                                      : context.l.maxN('$anchuraEjeTraMax'),
                                  suffixIcon: _iconoCumpleMotor(
                                      context,
                                      cs,
                                      _parseDouble(_anchuraEjeTra.text),
                                      anchuraEjeTraMax,
                                      maximo: true),
                                ),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                onChanged: (_) => setState(() {}),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 2) Llanta delantera / Llanta trasera
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _Bloque(
                      titulo: context.l.llantaDelantera,
                      info: bloques['llantaDel'],
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: marcasSelAsync.when(
                                loading: () => const SizedBox.shrink(),
                                error: (e, _) =>
                                    Text(context.l.errorDetalle('$e')),
                                data: (marcas) => _MarcaSelector(
                                  label: context.l.marca,
                                  valor: _llantaDelMarca,
                                  marcas: uso.ordenar('llantaDelMarca', marcas.toList()..sort()),
                                  onChange: (v) =>
                                      _cambiar(() => _llantaDelMarca = v),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 2,
                              child: llantasDelAsync.when(
                                loading: () => const SizedBox.shrink(),
                                error: (e, _) =>
                                    Text(context.l.errorDetalle('$e')),
                                data: (lls) => _DimensionSelector(
                                  label: context.l.dimension,
                                  valor: _llantaDelDim,
                                  opciones: uso.ordenar('llantaDelDimension',
                                      lls.map((l) => l.dimension)),
                                  onChange: (v) =>
                                      _cambiar(() => _llantaDelDim = v),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _Bloque(
                      titulo: context.l.llantaTrasera,
                      info: bloques['llantaTra'],
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: marcasSelAsync.when(
                                loading: () => const SizedBox.shrink(),
                                error: (e, _) =>
                                    Text(context.l.errorDetalle('$e')),
                                data: (marcas) => _MarcaSelector(
                                  label: context.l.marca,
                                  valor: _llantaTraMarca,
                                  marcas: uso.ordenar('llantaTraMarca', marcas.toList()..sort()),
                                  onChange: (v) =>
                                      _cambiar(() => _llantaTraMarca = v),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 2,
                              child: llantasTraAsync.when(
                                loading: () => const SizedBox.shrink(),
                                error: (e, _) =>
                                    Text(context.l.errorDetalle('$e')),
                                data: (lls) => _DimensionSelector(
                                  label: context.l.dimension,
                                  valor: _llantaTraDim,
                                  opciones: uso.ordenar('llantaTraDimension',
                                      lls.map((l) => l.dimension)),
                                  onChange: (v) =>
                                      _cambiar(() => _llantaTraDim = v),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 3) Piñón / Corona
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _Bloque(
                      titulo: context.l.pinon,
                      info: bloques['pinon'],
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: marcasSelAsync.when(
                                loading: () => const SizedBox.shrink(),
                                error: (e, _) =>
                                    Text(context.l.errorDetalle('$e')),
                                data: (marcas) => _MarcaSelector(
                                  label: context.l.marca,
                                  valor: _pinonMarca,
                                  marcas: uso.ordenar('pinonMarca', marcas.toList()..sort()),
                                  onChange: (v) =>
                                      _cambiar(() => _pinonMarca = v),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 2,
                              child: _DientesSelector(
                                label: context.l.dientes,
                                valor: _pinonDientes,
                                opciones: uso.ordenar(
                                    'pinonDientes', _dientesDe(pinonesAsync)),
                                onChange: (v) =>
                                    _cambiar(() => _pinonDientes = v),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _pinonDiametro,
                                decoration: InputDecoration(
                                    labelText: context.l.diametro),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _DimensionSelector(
                                label: context.l.material,
                                valor: _pinonMaterial,
                                opciones: uso.ordenar('pinonMaterial', _materialesPinon),
                                onChange: (v) =>
                                    _cambiar(() => _pinonMaterial = v),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _Bloque(
                      titulo: context.l.corona,
                      info: bloques['corona'],
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: marcasSelAsync.when(
                                loading: () => const SizedBox.shrink(),
                                error: (e, _) =>
                                    Text(context.l.errorDetalle('$e')),
                                data: (marcas) => _MarcaSelector(
                                  label: context.l.marca,
                                  valor: _coronaMarca,
                                  marcas: uso.ordenar('coronaMarca', marcas.toList()..sort()),
                                  onChange: (v) =>
                                      _cambiar(() => _coronaMarca = v),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 2,
                              child: _DientesSelector(
                                label: context.l.dientes,
                                valor: _coronaDientes,
                                opciones: uso.ordenar(
                                    'coronaDientes', _dientesDe(coronasAsync)),
                                onChange: (v) =>
                                    _cambiar(() => _coronaDientes = v),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _coronaDiametro,
                                decoration: InputDecoration(
                                    labelText: context.l.diametro),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _DimensionSelector(
                                label: context.l.material,
                                valor: _coronaMaterial,
                                opciones: uso.ordenar('coronaMaterial', _materialesCorona),
                                onChange: (v) =>
                                    _cambiar(() => _coronaMaterial = v),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 4) Bancada / Chasis
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _Bloque(
                      titulo: context.l.bancada,
                      info: bloques['bancada'],
                      children: [
                        bancadasFiltAsync.when(
                          loading: () => const SizedBox.shrink(),
                          error: (e, _) =>
                              Text(context.l.errorDetalle('$e')),
                          data: (bs) => _DimensionSelector(
                            label: context.l.bancada,
                            valor: _bancada,
                            opciones: uso.ordenar('bancada', bs.map((b) => b.nombre)),
                            onChange: (v) => _cambiar(() => _bancada = v),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _Bloque(
                      titulo: context.l.chasis,
                      info: bloques['chasis'],
                      children: [
                        Consumer(builder: (context, ref, _) {
                          // Chasis sin copa: siempre la lista completa.
                          final chasisAsync = ref.watch(chasisProvider);
                          return chasisAsync.when(
                            loading: () => const SizedBox.shrink(),
                            error: (e, _) =>
                                Text(context.l.errorDetalle('$e')),
                            data: (cs) => _DimensionSelector(
                              label: context.l.chasis,
                              valor: _chasis,
                              opciones: uso.ordenar('chasis', cs.map((c) => c.nombre)),
                              onChange: (v) => _cambiar(() => _chasis = v),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 5) Peso coche entero
              _Bloque(
                titulo: context.l.pesoCocheEntero,
                info: bloques['pesoCoche'],
                children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _pesoIniCoche,
                        decoration: InputDecoration(
                          labelText: context.l.inicial,
                          helperText: context.l.cocheEntero,
                        ),
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _pesoFinCoche,
                        decoration:
                            InputDecoration(labelText: context.l.etiquetaFinal),
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                  ],
                ),
                ],
              ),
              const SizedBox(height: 16),

              // 6) Otros: neumático + trencilla + suspensión (campos menores)
              _Bloque(
                titulo: context.l.otros,
                info: bloques['otros'],
                children: [
                Row(
                  children: [
                    Expanded(
                      child: neumaticosAsync.when(
                        loading: () => const SizedBox.shrink(),
                        error: (e, _) =>
                            Text(context.l.errorDetalle('$e')),
                        data: (ns) => _DimensionSelector(
                          label: context.l.neumatico,
                          valor: _neumatico,
                          opciones: uso.ordenar('neumatico', ns.map((n) => n.nombre)),
                          onChange: (v) => _cambiar(() => _neumatico = v),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: marcasSelAsync.when(
                        loading: () => const SizedBox.shrink(),
                        error: (e, _) =>
                            Text(context.l.errorDetalle('$e')),
                        data: (marcas) => _DimensionSelector(
                          label: context.l.trencilla,
                          valor: _trencilla,
                          opciones: uso.ordenar('trencilla', marcas.toList()..sort()),
                          onChange: (v) => _cambiar(() => _trencilla = v),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _suspension,
                        decoration: InputDecoration(
                            labelText: context.l.suspension),
                      ),
                    ),
                  ],
                ),
                ],
              ),
              const SizedBox(height: 16),

              // 7) Observaciones
              _Bloque(
                titulo: context.l.observaciones,
                info: bloques['observaciones'],
                children: [
                TextField(
                  controller: _observaciones,
                  decoration: InputDecoration(
                    labelText: context.l.notasOAvisos,
                    alignLabelWithHint: true,
                  ),
                  minLines: 2,
                  maxLines: 5,
                ),
                ],
              ),
              const SizedBox(height: 16),

              // 8) Fotos
              _Bloque(
                titulo: context.l.fotosHasta4,
                info: bloques['fotos'],
                children: [
                _GridFotos(
                  fotos: _fotos,
                  onAnadirCamara: () => _anadirFoto(ImageSource.camera),
                  onAnadirGaleria: () => _anadirFoto(ImageSource.gallery),
                  onEliminar: _eliminarFoto,
                ),
                ],
              ),
              const SizedBox(height: 24),

              CheckboxListTile(
                value: _validada,
                onChanged: (v) => setState(() => _validada = v ?? false),
                title: Text(context.l.marcarComoValidada,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(context.l.marcarComoValidadaTexto),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.cloud_done_outlined,
                      size: 18, color: cs.outline),
                  const SizedBox(width: 6),
                  Text(
                    context.l.autoguardadoTexto,
                    style: TextStyle(color: cs.outline, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: (_guardando || res.hayInfracciones)
                      ? null
                      : () => _guardar(validar: true),
                  icon: _guardando
                      ? const SizedBox(
                          width: 18, height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.check),
                  label: Text(context.l.validar),
                ),
              ),
              if (res.hayInfracciones) ...[
                const SizedBox(height: 8),
                Text(
                  context.l.noPuedesValidar,
                  style: TextStyle(color: cs.error, fontSize: 13),
                ),
              ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
      ),
    );
  }
}

/// Foto de referencia del coche del catálogo, para comprobar que el coche
/// entregado en la verificación coincide con el seleccionado.
class _FotoCocheReferencia extends StatelessWidget {
  const _FotoCocheReferencia({required this.fotoPath});
  final String fotoPath;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: FutureBuilder<File>(
        future: FotosVerificacion.resolver(fotoPath),
        builder: (ctx, snap) {
          final f = snap.data;
          if (f == null || !f.existsSync()) return const SizedBox.shrink();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 220),
                child: Image.file(f, fit: BoxFit.contain, width: double.infinity),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
                child: Row(
                  children: [
                    Icon(Icons.fact_check_outlined,
                        size: 16, color: cs.outline),
                    const SizedBox(width: 6),
                    Text(
                      context.l.fotoReferenciaTexto,
                      style: TextStyle(color: cs.outline, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Aviso cuando el coche seleccionado no tiene foto de referencia en el catálogo.
class _SinFotoCoche extends StatelessWidget {
  const _SinFotoCoche();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      color: cs.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.image_not_supported_outlined,
                size: 18, color: cs.outline),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                context.l.sinFotoCocheTexto,
                style: TextStyle(color: cs.outline, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----- Estado de autoguardado -----

enum _EstadoAuto { idle, pendiente, guardando, guardado, error }

class _IndicadorGuardado extends StatelessWidget {
  const _IndicadorGuardado({required this.estado});
  final _EstadoAuto estado;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l = context.l;
    final (IconData? icono, String texto, Color color) = switch (estado) {
      _EstadoAuto.idle => (null, '', cs.outline),
      _EstadoAuto.pendiente =>
        (Icons.edit_outlined, l.sinGuardar, cs.outline),
      _EstadoAuto.guardando => (null, l.guardando, cs.outline),
      _EstadoAuto.guardado =>
        (Icons.cloud_done_outlined, l.guardado, cs.primary),
      _EstadoAuto.error => (Icons.error_outline, l.errorCorto, cs.error),
    };
    if (estado == _EstadoAuto.idle) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (estado == _EstadoAuto.guardando)
            const SizedBox(
                width: 14, height: 14,
                child: CircularProgressIndicator(strokeWidth: 2))
          else if (icono != null)
            Icon(icono, size: 16, color: color),
          const SizedBox(width: 6),
          Text(texto, style: TextStyle(color: color, fontSize: 13)),
        ],
      ),
    );
  }
}

// ----- Bloqueo y reglamento congelado -----

/// Aviso de verificación bloqueada (campeonato finalizado o prueba
/// terminada): en solo lectura, con botón para desbloquear.
class _AvisoBloqueo extends StatelessWidget {
  const _AvisoBloqueo({
    required this.motivo,
    required this.soloLectura,
    required this.onDesbloquear,
  });
  final String motivo;
  final bool soloLectura;
  final VoidCallback onDesbloquear;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fondo = soloLectura
        ? cs.surfaceContainerHighest
        : context.estado.avisoSuave;
    final texto = soloLectura
        ? cs.onSurface
        : context.estado.aviso;
    return Card(
      color: fondo,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(soloLectura ? Icons.lock_outline : Icons.lock_open_outlined,
                color: texto),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                soloLectura
                    ? context.l.soloLecturaTexto(motivo)
                    : context.l.desbloqueadaTexto(motivo),
                style: TextStyle(color: texto),
              ),
            ),
            if (soloLectura)
              TextButton.icon(
                onPressed: onDesbloquear,
                icon: const Icon(Icons.lock_open_outlined),
                label: Text(context.l.desbloquear),
              ),
          ],
        ),
      ),
    );
  }
}

/// Reglamento congelado: cuándo se tomó y, si el catálogo o el campeonato
/// han cambiado desde entonces, qué ha cambiado (sin aplicarlo).
class _AvisoReglamento extends StatelessWidget {
  const _AvisoReglamento({
    required this.reglas,
    required this.diferencias,
    required this.onUsarActual,
  });
  final ReglasVerificacion reglas;
  final List<String> diferencias;
  final VoidCallback? onUsarActual;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fecha = reglas.fechaMs == null
        ? null
        : DateFormat('dd/MM/yyyy HH:mm')
            .format(DateTime.fromMillisecondsSinceEpoch(reglas.fechaMs!));
    return Card(
      color: cs.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.ac_unit, size: 18, color: cs.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    fecha == null
                        ? context.l.reglamentoCongeladoSinFecha
                        : context.l.reglamentoCongelado(fecha),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            if (diferencias.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(context.l.haCambiadoDesdeEntonces,
                  style: TextStyle(color: cs.outline, fontSize: 13)),
              const SizedBox(height: 4),
              for (final d in diferencias)
                Text('• $d', style: const TextStyle(fontSize: 13)),
              if (onUsarActual != null) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: onUsarActual,
                    icon: const Icon(Icons.update),
                    label: Text(context.l.usarReglamentoActual),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

// ----- Resumen de validación arriba del formulario -----

class _Resumen extends StatelessWidget {
  const _Resumen({required this.resultado});
  final ResultadoValidacion resultado;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (resultado.todoOk) {
      return Card(
        color: context.estado.exitoSuave,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: context.estado.exito),
              const SizedBox(width: 12),
              Expanded(
                child: Text(context.l.todoCumple),
              ),
            ],
          ),
        ),
      );
    }
    final color =
        resultado.hayInfracciones ? cs.errorContainer : context.estado.avisoSuave;
    final colorTexto =
        resultado.hayInfracciones ? cs.onErrorContainer : context.estado.aviso;
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  resultado.hayInfracciones
                      ? Icons.error_outline
                      : Icons.warning_amber_outlined,
                  color: colorTexto,
                ),
                const SizedBox(width: 8),
                Text(
                  resultado.hayInfracciones
                      ? context.l.infraccionesN(resultado.numInfracciones)
                      : context.l.avisosN(resultado.numAvisos),
                  style: TextStyle(
                      color: colorTexto, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...resultado.hallazgos.map((h) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        h.nivel == NivelValidacion.infraccion
                            ? Icons.cancel
                            : Icons.info_outline,
                        size: 16,
                        color: h.nivel == NivelValidacion.infraccion
                            ? cs.error
                            : context.estado.aviso,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(textoHallazgo(context.l, h),
                            style: TextStyle(color: colorTexto, fontSize: 13)),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

/// Icono ✓/✗ para los campos de RPM/uMs del motor propio, comparando en
/// vivo el valor medido contra la referencia del catálogo. [maximo] = true
/// para RPM (no puede superar la referencia); false para uMs/gauss (no
/// puede ser menor). null si no hay valor o no hay motor de catálogo
/// elegido, para no mostrar nada.
Widget? _iconoCumpleMotor(
    BuildContext context, ColorScheme cs, num? medido, num? referencia,
    {required bool maximo}) {
  if (medido == null || referencia == null) return null;
  final cumple = maximo ? medido <= referencia : medido >= referencia;
  return Icon(
    cumple ? Icons.check_circle : Icons.cancel,
    color: cumple ? context.estado.exito : cs.error,
  );
}

// ----- Mini-componentes reutilizables -----

enum _EstadoBloque { neutro, pendiente, hecho, infraccion }

/// Nombre visible de un bloque de la verificación (las claves de `bloques`
/// son estables y no dependen del idioma).
String _etiquetaBloque(Textos l, String id) => switch (id) {
      'coche' => l.coche,
      'peso' => l.pesoGramos,
      'estetica' => l.estetica,
      'motor' => l.motor,
      'eje' => l.anchuraEjeMm,
      'llantaDel' => l.llantaDelantera,
      'llantaTra' => l.llantaTrasera,
      'pinon' => l.pinon,
      'corona' => l.corona,
      'bancada' => l.bancada,
      'chasis' => l.chasis,
      'pesoCoche' => l.pesoCocheEntero,
      'otros' => l.otros,
      'observaciones' => l.observaciones,
      'fotos' => l.fotosHasta4,
      _ => id,
    };

/// Texto de un hallazgo del validador, en el idioma de la app.
String textoHallazgo(Textos l, HallazgoValidacion h) => switch (h.codigo) {
      'pesoInicialBajo' => l.vPesoInicialBajo(
          '${h.datos['valor']}', '${h.datos['minimo']}'),
      'pesoFinalBajo' => l.vPesoFinalBajo(
          '${h.datos['valor']}', '${h.datos['minimo']}'),
      'motorSinCatalogo' => l.vMotorSinCatalogo,
      'motorRpmAlto' => l.vMotorRpmAlto('${h.datos['motor']}',
          '${h.datos['max']}', '${h.datos['medido']}'),
      'motorUmsAlto' => l.vMotorUmsAlto('${h.datos['motor']}',
          '${h.datos['max']}', '${h.datos['medido']}'),
      'alturaNoConforme' => l.vAlturaNoConforme,
      'ejeDelAncho' =>
        l.vEjeDelAncho('${h.datos['medido']}', '${h.datos['max']}'),
      'ejeTraAncho' =>
        l.vEjeTraAncho('${h.datos['medido']}', '${h.datos['max']}'),
      'marcaNoPermitidaLista' =>
        l.vMarcaNoPermitidaLista('${h.datos['marca']}', '${h.datos['lista']}'),
      'marcaFueraCatalogo' => l.vMarcaFueraCatalogo('${h.datos['marca']}'),
      'llantaDelNoCatalogada' => l.vLlantaDelNoCatalogada('${h.datos['valor']}'),
      'llantaTraNoCatalogada' => l.vLlantaTraNoCatalogada('${h.datos['valor']}'),
      'bancadaNoCatalogada' => l.vBancadaNoCatalogada('${h.datos['valor']}'),
      'neumaticoNoCatalogado' => l.vNeumaticoNoCatalogado('${h.datos['valor']}'),
      'balanceNegativo' => l.vBalanceNegativo('${h.datos['equipo']}',
          '${h.datos['coche']}', '${h.datos['balance']}'),
      _ => h.codigo,
    };

/// Lo que lleva rellenado un bloque de la verificación y si tiene algún
/// dato fuera de reglamento.
class _InfoBloque {
  const _InfoBloque(this.hechos, this.total, this.infraccion);

  /// [campos]: un bool por dato que hay que rellenar en el bloque.
  /// [claves]: campos del validador que pertenecen al bloque.
  factory _InfoBloque.de(
      ResultadoValidacion res, List<bool> campos, List<String> claves) {
    final infraccion = res.hallazgos.any((h) =>
        h.nivel == NivelValidacion.infraccion && claves.contains(h.campo));
    return _InfoBloque(
        campos.where((c) => c).length, campos.length, infraccion);
  }

  final int hechos;
  final int total;
  final bool infraccion;

  _EstadoBloque get estado {
    if (infraccion) return _EstadoBloque.infraccion;
    if (total == 0) return _EstadoBloque.neutro;
    return hechos >= total ? _EstadoBloque.hecho : _EstadoBloque.pendiente;
  }
}

/// Bloque de la verificación sombreado y con su estado (pendiente, hecho o
/// fuera de reglamento), para no saltarse nada al verificar. Sin [info] es
/// un bloque opcional (observaciones, fotos): sombreado pero sin estado.
/// Pago del equipo en la prueba (el mismo de la tesorería de la prueba).
class _PagoEnVerificacion extends ConsumerWidget {
  const _PagoEnVerificacion({
    required this.pruebaId,
    required this.equipoId,
    required this.campeonato,
  });
  final int pruebaId;
  final int equipoId;
  final Campeonato campeonato;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eur = NumberFormat.currency(locale: 'es_ES', symbol: '€');
    return ref.watch(pagosPruebaProvider(pruebaId)).when(
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => Text(context.l.errorDetalle('$e')),
          data: (lista) {
            final pago =
                lista.where((p) => p.equipoId == equipoId).firstOrNull;
            if (pago == null) {
              return Text(
                context.l.equipoNoInscritoPrueba,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.outline),
              );
            }
            return FilaPagoEquipo(
              key: ValueKey(equipoId),
              pruebaId: pruebaId,
              pago: pago,
              eur: eur,
              campeonato: campeonato,
            );
          },
        );
  }
}

class _Bloque extends StatelessWidget {
  const _Bloque({
    required this.titulo,
    required this.info,
    required this.children,
  });
  final String titulo;
  final _InfoBloque? info;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final oscuro = Theme.of(context).brightness == Brightness.dark;
    final estado = info?.estado ?? _EstadoBloque.neutro;
    final ambar = context.estado.aviso;
    final verde = context.estado.exito;
    final (Color color, IconData? icono, String? etiqueta) = switch (estado) {
      _EstadoBloque.pendiente => (
          ambar,
          Icons.radio_button_unchecked,
          context.l.pendienteHechosDeTotal(info!.hechos, info!.total),
        ),
      _EstadoBloque.hecho =>
        (verde, Icons.check_circle, context.l.hecho),
      _EstadoBloque.infraccion =>
        (cs.error, Icons.error, context.l.revisar),
      _EstadoBloque.neutro => (cs.outlineVariant, null, null),
    };
    final fondo = estado == _EstadoBloque.neutro
        ? cs.surfaceContainerLow
        : Color.alphaBlend(
            color.withValues(alpha: oscuro ? 0.10 : 0.07),
            cs.surfaceContainerLow);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: estado == _EstadoBloque.neutro
              ? cs.outlineVariant
              : color.withValues(alpha: 0.8),
          width: estado == _EstadoBloque.pendiente ? 2 : 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(titulo,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: cs.primary, fontWeight: FontWeight.w700)),
                ),
                if (etiqueta != null) ...[
                  Icon(icono, size: 18, color: color),
                  const SizedBox(width: 4),
                  Text(etiqueta,
                      style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w700,
                          fontSize: 13)),
                ],
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

/// Barra de progreso de la verificación: bloques completos y cuáles faltan.
class _ProgresoBloques extends StatelessWidget {
  const _ProgresoBloques({required this.bloques});
  final Map<String, _InfoBloque> bloques;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final cuentan =
        bloques.entries.where((e) => e.value.total > 0).toList();
    final hechos =
        cuentan.where((e) => e.value.estado == _EstadoBloque.hecho).length;
    final faltan = cuentan
        .where((e) => e.value.estado == _EstadoBloque.pendiente)
        .map((e) => _etiquetaBloque(context.l, e.key))
        .toList();
    final completo = cuentan.isNotEmpty && faltan.isEmpty;
    final color = completo ? context.estado.exito : context.estado.aviso;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
                context.l.bloquesCompletos(hechos, cuentan.length),
                style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: cuentan.isEmpty ? 0 : hechos / cuentan.length,
            minHeight: 8,
            color: color,
            backgroundColor: cs.surfaceContainerHighest,
          ),
        ),
        if (faltan.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(context.l.faltaLista(faltan.join(' · ')),
              style: TextStyle(color: cs.outline, fontSize: 13)),
        ],
      ],
    );
  }
}

class _SecHead extends StatelessWidget {
  const _SecHead(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700)),
    );
  }
}

class _MarcaSelector extends StatelessWidget {
  const _MarcaSelector({
    required this.label,
    required this.valor,
    required this.marcas,
    required this.onChange,
  });

  final String label;
  final String? valor;
  /// Marcas en el orden en que se muestran (más usadas primero).
  final List<String> marcas;
  final ValueChanged<String?> onChange;

  @override
  Widget build(BuildContext context) {
    final lista = marcas.toSet().toList();
    // Tolerar valores guardados que no están en el catálogo (datos
    // importados/antiguos): se muestran como opción extra en vez de fallar.
    final desconocido = valor != null && !lista.contains(valor);
    return DropdownButtonFormField<String?>(
      initialValue: valor,
      isExpanded: true,
      decoration: InputDecoration(labelText: label),
      items: [
        DropdownMenuItem(
            value: null, child: Text(context.l.sinAsignarGuiones)),
        if (desconocido)
          DropdownMenuItem(
              value: valor, child: Text(context.l.fueraDeLaLista(valor!))),
        ...lista.map((m) => DropdownMenuItem(value: m, child: Text(m))),
      ],
      onChanged: onChange,
    );
  }
}

/// Desplegable de dientes: las opciones vienen del catálogo de engranajes ya
/// filtrado por tipo (piñón/corona) y por la copa del equipo. Un valor guardado
/// que no esté en el catálogo se muestra igualmente, para no perder datos.
class _DientesSelector extends StatelessWidget {
  const _DientesSelector({
    required this.label,
    required this.valor,
    required this.opciones,
    required this.onChange,
  });

  final String label;
  final int? valor;
  final List<int> opciones;
  final ValueChanged<int?> onChange;

  @override
  Widget build(BuildContext context) {
    // El catálogo puede tener nombres duplicados (import/alta manual sin
    // deduplicar); un valor repetido en items también rompe el desplegable,
    // igual que uno ausente, así que hay que quitar duplicados aquí.
    final lista = opciones.toSet().toList();
    final desconocido = valor != null && !lista.contains(valor);
    return DropdownButtonFormField<int?>(
      initialValue: valor,
      isExpanded: true,
      decoration: InputDecoration(labelText: label),
      items: [
        const DropdownMenuItem(value: null, child: Text('—')),
        if (desconocido)
          DropdownMenuItem(
              value: valor, child: Text(context.l.noCatalogado('$valor'))),
        ...lista.map((d) => DropdownMenuItem(value: d, child: Text('$d'))),
      ],
      onChanged: onChange,
    );
  }
}

class _DimensionSelector extends StatelessWidget {
  const _DimensionSelector({
    required this.label,
    required this.valor,
    required this.opciones,
    required this.onChange,
  });

  final String label;
  final String? valor;
  final List<String> opciones;
  final ValueChanged<String?> onChange;

  @override
  Widget build(BuildContext context) {
    // Tolerar valores guardados que no están en el catálogo (datos
    // importados/antiguos): se muestran como opción extra en vez de fallar.
    // El catálogo puede tener nombres duplicados (import/alta manual sin
    // deduplicar); un valor repetido en items también rompe el desplegable,
    // igual que uno ausente, así que hay que quitar duplicados aquí.
    final lista = opciones.toSet().toList();
    final desconocido = valor != null && !lista.contains(valor);
    return DropdownButtonFormField<String?>(
      initialValue: valor,
      isExpanded: true,
      decoration: InputDecoration(labelText: label),
      items: [
        DropdownMenuItem(
            value: null, child: Text(context.l.sinAsignarGuiones)),
        if (desconocido)
          DropdownMenuItem(
              value: valor, child: Text(context.l.noCatalogado(valor!))),
        ...lista.map((o) => DropdownMenuItem(value: o, child: Text(o))),
      ],
      onChanged: onChange,
    );
  }
}

class _BloqueEquipoCreditos extends StatelessWidget {
  const _BloqueEquipoCreditos({
    required this.equipo,
    required this.piloto1,
    required this.creditosP1,
    this.piloto2,
    required this.creditosP2,
    this.creditosCoche,
    this.validada = false,
  });

  final Equipo equipo;
  final Piloto piloto1;
  final int creditosP1;
  final Piloto? piloto2;
  final int creditosP2;
  /// Créditos del coche elegido (del reglamento de la verificación).
  final int? creditosCoche;
  final bool validada;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final total = creditosP1 + creditosP2;

    // Previsión de créditos al validar con el coche seleccionado.
    // Si ya está validada, los saldos mostrados ya incluyen el descuento.
    RepartoCreditos? reparto;
    final valor = creditosCoche ?? 0;
    if (!validada && valor != 0) {
      reparto = repartirCreditos(
        valor: valor,
        disp1: creditosP1,
        disp2: piloto2 == null ? null : creditosP2,
      );
    }
    return Card(
      color: cs.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.groups_outlined, color: cs.onPrimaryContainer),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    equipo.nombre,
                    style: TextStyle(
                      color: cs.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: cs.onPrimaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    context.l.nCreditos(total),
                    style: TextStyle(
                      color: cs.primaryContainer,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _FilaPiloto(
              nombre: piloto1.nombre,
              creditos: creditosP1,
              color: cs.onPrimaryContainer,
            ),
            if (piloto2 != null) ...[
              const SizedBox(height: 4),
              _FilaPiloto(
                nombre: piloto2!.nombre,
                creditos: creditosP2,
                color: cs.onPrimaryContainer,
              ),
            ],
            if (reparto != null) ...[
              const SizedBox(height: 10),
              Divider(
                  height: 1,
                  color: cs.onPrimaryContainer.withValues(alpha: 0.25)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    valor > 0
                        ? Icons.trending_up
                        : Icons.trending_down,
                    size: 18,
                    color: cs.onPrimaryContainer,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${context.l.conEsteCoche('${valor > 0 ? '+' : ''}$valor')} '
                      '${piloto1.nombre} $creditosP1→${creditosP1 + reparto.delta1}'
                      '${piloto2 == null ? '' : ' · ${piloto2!.nombre} $creditosP2→${creditosP2 + reparto.delta2}'}'
                      ' · ${context.l.total} $total→${total + reparto.delta1 + reparto.delta2}',
                      style: TextStyle(
                        color: cs.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              if (reparto.insuficiente)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    context.l.sinCreditosSuficientes,
                    style: TextStyle(
                      color: cs.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FilaPiloto extends StatelessWidget {
  const _FilaPiloto({
    required this.nombre,
    required this.creditos,
    required this.color,
  });
  final String nombre;
  final int creditos;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.person_outline, color: color, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            nombre,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          '$creditos ${context.l.creditosAbrev}',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _GridFotos extends StatelessWidget {
  const _GridFotos({
    required this.fotos,
    required this.onAnadirCamara,
    required this.onAnadirGaleria,
    required this.onEliminar,
  });

  final List<String> fotos;
  final VoidCallback onAnadirCamara;
  final VoidCallback onAnadirGaleria;
  final void Function(int) onEliminar;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final slots = <Widget>[];
    for (var i = 0; i < 4; i++) {
      if (i < fotos.length) {
        slots.add(_SlotFoto(
          path: fotos[i],
          onEliminar: () => onEliminar(i),
        ));
      } else if (i == fotos.length) {
        slots.add(_SlotAnadir(
          onCamara: onAnadirCamara,
          onGaleria: onAnadirGaleria,
        ));
      } else {
        slots.add(Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.outlineVariant),
          ),
        ));
      }
    }
    return GridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1,
      children: slots,
    );
  }
}

class _SlotFoto extends StatelessWidget {
  const _SlotFoto({required this.path, required this.onEliminar});
  final String path;
  final VoidCallback onEliminar;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        fit: StackFit.expand,
        children: [
          FutureBuilder<File>(
            future: FotosVerificacion.resolver(path),
            builder: (ctx, snap) {
              final file = snap.data;
              if (file == null || !file.existsSync()) {
                return Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image_outlined),
                );
              }
              return Image.file(file, fit: BoxFit.cover);
            },
          ),
          Positioned(
            top: 4,
            right: 4,
            child: Material(
              color: Colors.black54,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onEliminar,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SlotAnadir extends StatelessWidget {
  const _SlotAnadir({required this.onCamara, required this.onGaleria});
  final VoidCallback onCamara;
  final VoidCallback onGaleria;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.primary, width: 1.5),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          final accion = await showModalBottomSheet<String>(
            context: context,
            builder: (_) => SafeArea(
              child: Wrap(
                children: [
                  ListTile(
                    leading: const Icon(Icons.camera_alt_outlined),
                    title: Text(context.l.hacerFoto),
                    onTap: () => Navigator.pop(context, 'camara'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_library_outlined),
                    title: Text(context.l.elegirDeGaleria),
                    onTap: () => Navigator.pop(context, 'galeria'),
                  ),
                ],
              ),
            ),
          );
          if (accion == 'camara') onCamara();
          if (accion == 'galeria') onGaleria();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo_outlined,
                size: 32, color: cs.onPrimaryContainer),
            const SizedBox(height: 4),
            Text(context.l.anadir,
                style: TextStyle(
                    color: cs.onPrimaryContainer,
                    fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
