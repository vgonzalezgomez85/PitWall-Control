import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/proveedores.dart';
import '../../core/widgets/selector_buscable.dart';
import '../../data/database/app_database.dart';
import '../../domain/validador_verificacion.dart';
import '../../services/fotos_verificacion.dart';
import 'repositorio_verificaciones.dart';

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
  final _pinonDientes = TextEditingController(text: '12');
  final _coronaDientes = TextEditingController();
  final _suspension = TextEditingController();
  final _trencilla = TextEditingController();
  final _observaciones = TextEditingController();
  String? _chasis;
  String _motorTipo = 'ORGANIZACION';

  int? _cocheId;
  String? _pinonMarca;
  String? _coronaMarca;
  String? _llantaDelMarca;
  String? _llantaDelDim;
  String? _llantaTraMarca;
  String? _llantaTraDim;
  String? _bancada;
  String? _neumatico;

  bool _validada = false;
  bool _cargando = true;
  bool _guardando = false;
  Equipo? _equipo;
  Piloto? _piloto1;
  Piloto? _piloto2;
  int _creditosP1 = 0;
  int _creditosP2 = 0;
  List<String> _fotos = [];

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final db = ref.read(dbProvider);
    _equipo = await (db.select(db.equipos)
          ..where((t) => t.id.equals(widget.equipoId)))
        .getSingle();
    // Cargar pilotos del equipo y sus créditos en el campeonato activo
    final activo = ref.read(campeonatoActivoProvider);
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
    if (widget.verificacionId != null) {
      final v = await (db.select(db.verificaciones)
            ..where((t) => t.id.equals(widget.verificacionId!)))
          .getSingle();
      _cocheId = v.cocheCatalogoId;
      _pesoIni.text = v.pesoInicial?.toString() ?? '';
      _pesoFin.text = v.pesoFinal?.toString() ?? '';
      _pesoIniCoche.text = v.pesoInicialCoche?.toString() ?? '';
      _pesoFinCoche.text = v.pesoFinalCoche?.toString() ?? '';
      _motor.text = v.motor ?? '';
      _motorTipo = v.motorTipo;
      _motorRpm.text = v.motorRpm?.toString() ?? '';
      _motorUms.text = v.motorUms?.toString() ?? '';
      _pinonMarca = v.pinonMarca;
      _pinonDientes.text = v.pinonDientes?.toString() ?? '12';
      _coronaMarca = v.coronaMarca;
      _coronaDientes.text = v.coronaDientes?.toString() ?? '';
      _llantaDelMarca = v.llantaDelMarca;
      _llantaDelDim = v.llantaDelDimension;
      _llantaTraMarca = v.llantaTraMarca;
      _llantaTraDim = v.llantaTraDimension;
      _trencilla.text = v.trencilla ?? '';
      _suspension.text = v.suspension ?? '';
      _bancada = v.bancada;
      _chasis = v.chasis;
      _neumatico = v.neumatico;
      _observaciones.text = v.observaciones ?? '';
      _validada = v.validado;
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
    }
    if (mounted) setState(() => _cargando = false);
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
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo añadir la foto: $e')),
      );
    }
  }

  void _eliminarFoto(int idx) async {
    if (idx < 0 || idx >= _fotos.length) return;
    final entrada = _fotos[idx];
    setState(() => _fotos.removeAt(idx));
    try {
      final f = await FotosVerificacion.resolver(entrada);
      if (f.existsSync()) f.deleteSync();
    } catch (_) {}
  }

  @override
  void dispose() {
    _pesoIni.dispose();
    _pesoFin.dispose();
    _pesoIniCoche.dispose();
    _pesoFinCoche.dispose();
    _motor.dispose();
    _motorRpm.dispose();
    _motorUms.dispose();
    _pinonDientes.dispose();
    _coronaDientes.dispose();
    _suspension.dispose();
    _trencilla.dispose();
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

  Future<void> _guardar({bool validar = false}) async {
    setState(() => _guardando = true);
    try {
      final db = ref.read(dbProvider);
      double? pesoMin;
      if (_cocheId != null) {
        final c = await (db.select(db.catalogoCoches)
              ..where((t) => t.id.equals(_cocheId!)))
            .getSingleOrNull();
        pesoMin = c?.pesoMin;
      }
      await ref.read(repoVerificacionesProvider).guardar(
            id: widget.verificacionId,
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
            pinonMarca: _pinonMarca,
            pinonDientes: _parseInt(_pinonDientes.text),
            coronaMarca: _coronaMarca,
            coronaDientes: _parseInt(_coronaDientes.text),
            llantaDelMarca: _llantaDelMarca,
            llantaDelDimension: _llantaDelDim,
            llantaTraMarca: _llantaTraMarca,
            llantaTraDimension: _llantaTraDim,
            trencilla: _vacio(_trencilla),
            suspension: _vacio(_suspension),
            bancada: _bancada,
            chasis: _chasis,
            neumatico: _neumatico,
            observaciones: _vacio(_observaciones),
            validado: validar ? true : _validada,
            fotosJson: json.encode(_fotos),
          );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo guardar: $e')),
        );
        setState(() => _guardando = false);
      }
    }
  }

  String? _vacio(TextEditingController c) {
    final t = c.text.trim();
    return t.isEmpty ? null : t;
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final marcasAsync = ref.watch(marcasCodigosProvider);
    final llantasDelAsync = ref.watch(llantasDelProvider);
    final llantasTraAsync = ref.watch(llantasTraProvider);
    // ignore: unused_local_variable
    final bancadasAsync = ref.watch(bancadasProvider);
    final neumaticosAsync = ref.watch(neumaticosProvider);
    // Filtramos coches y bancadas por la copa del equipo
    final copaEquipo = _equipo?.copa;
    final cochesAsync = ref.watch(cochesFiltradosProvider(copaEquipo));
    final bancadasFiltAsync = ref.watch(bancadasFiltradasProvider(copaEquipo));

    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_equipo?.nombre ?? 'Verificación'),
        actions: [
          if (widget.verificacionId != null)
            IconButton(
              tooltip: 'Eliminar verificación',
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Eliminar verificación'),
                    content: const Text(
                        'Se perderán los datos introducidos. ¿Continuar?'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancelar')),
                      FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Eliminar')),
                    ],
                  ),
                );
                if (ok == true) {
                  await ref
                      .read(repoVerificacionesProvider)
                      .borrar(widget.verificacionId!);
                  if (mounted) Navigator.of(context).pop();
                }
              },
            ),
        ],
      ),
      body: cochesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (coches) {
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
            pesoMinCoche: cocheSel.id < 0 ? null : cocheSel.pesoMin,
            creditosCoche: cocheSel.id < 0 ? null : cocheSel.creditosCoche,
            motor: _vacio(_motor),
            pinonMarca: _pinonMarca,
            pinonDientes: _parseInt(_pinonDientes.text),
            coronaMarca: _coronaMarca,
            coronaDientes: _parseInt(_coronaDientes.text),
            llantaDelMarca: _llantaDelMarca,
            llantaDelDimension: _llantaDelDim,
            llantaTraMarca: _llantaTraMarca,
            llantaTraDimension: _llantaTraDim,
            trencilla: _vacio(_trencilla),
            suspension: _vacio(_suspension),
            bancada: _bancada,
            chasis: _chasis,
            neumatico: _neumatico,
            marcasValidas:
                marcasAsync.maybeWhen(data: (d) => d, orElse: () => {}),
            llantasDelValidas: llantasDelAsync.maybeWhen(
                data: (d) => d.map((l) => l.dimension).toSet(),
                orElse: () => {}),
            llantasTraValidas: llantasTraAsync.maybeWhen(
                data: (d) => d.map((l) => l.dimension).toSet(),
                orElse: () => {}),
            bancadasValidas: bancadasAsync.maybeWhen(
                data: (d) => d.map((b) => b.nombre).toSet(),
                orElse: () => {}),
            neumaticosValidos: neumaticosAsync.maybeWhen(
                data: (d) => d.map((n) => n.nombre).toSet(),
                orElse: () => {}),
          );
          final res = ValidadorVerificacion.validar(datos);

          final usaCreditos =
              ref.read(campeonatoActivoProvider)?.usaCreditos ?? false;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (usaCreditos && _piloto1 != null)
                _BloqueEquipoCreditos(
                  equipo: _equipo!,
                  piloto1: _piloto1!,
                  creditosP1: _creditosP1,
                  piloto2: _piloto2,
                  creditosP2: _creditosP2,
                ),
              if (usaCreditos && _piloto1 != null)
                const SizedBox(height: 12),
              _Resumen(resultado: res),
              const SizedBox(height: 16),

              _SecHead('Coche'),
              SelectorBuscable<CatalogoCoche>(
                etiqueta: 'Modelo de coche',
                titulo: 'Elegir coche',
                icono: Icons.directions_car_outlined,
                helper:
                    'Se muestran peso mínimo y créditos del coche al elegirlo',
                valor: coches.where((c) => c.id == _cocheId).firstOrNull,
                opciones: coches,
                etiquetaOpcion: (c) => c.nombre,
                subtituloOpcion: (c) =>
                    '${c.pesoMin.toStringAsFixed(2)}g · ${c.creditosCoche >= 0 ? "+" : ""}${c.creditosCoche} créd',
                onCambio: (c) => setState(() => _cocheId = c?.id),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _SecHead('Motor'),
                        SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(
                              value: 'ORGANIZACION',
                              label: Text('Organización'),
                              icon: Icon(Icons.business_outlined),
                            ),
                            ButtonSegment(
                              value: 'PROPIO',
                              label: Text('Propio'),
                              icon: Icon(Icons.engineering_outlined),
                            ),
                          ],
                          selected: {_motorTipo},
                          onSelectionChanged: (s) {
                            setState(() => _motorTipo = s.first);
                          },
                        ),
                        const SizedBox(height: 8),
                        if (_motorTipo == 'ORGANIZACION')
                          TextField(
                            controller: _motor,
                            decoration: const InputDecoration(
                              labelText: 'Número de motor',
                              prefixIcon: Icon(Icons.tag),
                            ),
                            keyboardType: TextInputType.number,
                          )
                        else
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _motorRpm,
                                  decoration: const InputDecoration(
                                    labelText: 'RPM',
                                    prefixIcon: Icon(Icons.speed_outlined),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _motorUms,
                                  decoration: const InputDecoration(
                                      labelText: 'uMs'),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _SecHead('Peso carrocería (gramos)'),
                        TextField(
                          controller: _pesoIni,
                          decoration: InputDecoration(
                            labelText: 'Peso carrocería',
                            helperText: cocheSel.id < 0
                                ? null
                                : 'Mínimo: ${cocheSel.pesoMin.toStringAsFixed(2)}g',
                          ),
                          keyboardType:
                              const TextInputType.numberWithOptions(
                                  decimal: true),
                          onChanged: (_) => setState(() {}),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _SecHead('Llanta delantera'),
                        Row(
                          children: [
                            Expanded(
                              child: marcasAsync.when(
                                loading: () => const SizedBox.shrink(),
                                error: (e, _) => Text('Error: $e'),
                                data: (marcas) => _MarcaSelector(
                                  label: 'Marca',
                                  valor: _llantaDelMarca,
                                  marcas: marcas,
                                  onChange: (v) =>
                                      setState(() => _llantaDelMarca = v),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 2,
                              child: llantasDelAsync.when(
                                loading: () => const SizedBox.shrink(),
                                error: (e, _) => Text('Error: $e'),
                                data: (lls) => _DimensionSelector(
                                  label: 'Dimensión',
                                  valor: _llantaDelDim,
                                  opciones:
                                      lls.map((l) => l.dimension).toList(),
                                  onChange: (v) =>
                                      setState(() => _llantaDelDim = v),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _SecHead('Llanta trasera'),
                        Row(
                          children: [
                            Expanded(
                              child: marcasAsync.when(
                                loading: () => const SizedBox.shrink(),
                                error: (e, _) => Text('Error: $e'),
                                data: (marcas) => _MarcaSelector(
                                  label: 'Marca',
                                  valor: _llantaTraMarca,
                                  marcas: marcas,
                                  onChange: (v) =>
                                      setState(() => _llantaTraMarca = v),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 2,
                              child: llantasTraAsync.when(
                                loading: () => const SizedBox.shrink(),
                                error: (e, _) => Text('Error: $e'),
                                data: (lls) => _DimensionSelector(
                                  label: 'Dimensión',
                                  valor: _llantaTraDim,
                                  opciones:
                                      lls.map((l) => l.dimension).toList(),
                                  onChange: (v) =>
                                      setState(() => _llantaTraDim = v),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _SecHead('Piñón'),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: marcasAsync.when(
                                loading: () => const SizedBox.shrink(),
                                error: (e, _) => Text('Error: $e'),
                                data: (marcas) => _MarcaSelector(
                                  label: 'Marca',
                                  valor: _pinonMarca,
                                  marcas: marcas,
                                  onChange: (v) =>
                                      setState(() => _pinonMarca = v),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 2,
                              child: TextField(
                                controller: _pinonDientes,
                                decoration: const InputDecoration(
                                  labelText: 'Dientes',
                                  helperText: 'Regla: 12',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (_) => setState(() {}),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _SecHead('Corona'),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: marcasAsync.when(
                                loading: () => const SizedBox.shrink(),
                                error: (e, _) => Text('Error: $e'),
                                data: (marcas) => _MarcaSelector(
                                  label: 'Marca',
                                  valor: _coronaMarca,
                                  marcas: marcas,
                                  onChange: (v) =>
                                      setState(() => _coronaMarca = v),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 2,
                              child: TextField(
                                controller: _coronaDientes,
                                decoration: const InputDecoration(
                                  labelText: 'Dientes',
                                  helperText: '24–30',
                                ),
                                keyboardType: TextInputType.number,
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

              // 4) Bancada / Chasis
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _SecHead('Bancada'),
                        bancadasFiltAsync.when(
                          loading: () => const SizedBox.shrink(),
                          error: (e, _) => Text('Error: $e'),
                          data: (bs) => _DimensionSelector(
                            label: 'Bancada',
                            valor: _bancada,
                            opciones: bs.map((b) => b.nombre).toList(),
                            onChange: (v) => setState(() => _bancada = v),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _SecHead('Chasis'),
                        Consumer(builder: (context, ref, _) {
                          final chasisAsync = ref
                              .watch(chasisFiltradosProvider(copaEquipo));
                          return chasisAsync.when(
                            loading: () => const SizedBox.shrink(),
                            error: (e, _) => Text('Error: $e'),
                            data: (cs) => _DimensionSelector(
                              label: 'Chasis',
                              valor: _chasis,
                              opciones: cs.map((c) => c.nombre).toList(),
                              onChange: (v) => setState(() => _chasis = v),
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
              _SecHead('Peso coche entero (gramos)'),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _pesoIniCoche,
                      decoration: const InputDecoration(
                        labelText: 'Inicial',
                        helperText: 'Coche entero',
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _pesoFinCoche,
                      decoration: const InputDecoration(labelText: 'Final'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 6) Otros: neumático + trencilla + suspensión (campos menores)
              _SecHead('Otros'),
              Row(
                children: [
                  Expanded(
                    child: neumaticosAsync.when(
                      loading: () => const SizedBox.shrink(),
                      error: (e, _) => Text('Error: $e'),
                      data: (ns) => _DimensionSelector(
                        label: 'Neumático',
                        valor: _neumatico,
                        opciones: ns.map((n) => n.nombre).toList(),
                        onChange: (v) => setState(() => _neumatico = v),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _trencilla,
                      decoration: const InputDecoration(labelText: 'Trencilla'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _suspension,
                      decoration:
                          const InputDecoration(labelText: 'Suspensión'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 7) Observaciones
              _SecHead('Observaciones'),
              TextField(
                controller: _observaciones,
                decoration: const InputDecoration(
                  labelText: 'Notas o avisos',
                  alignLabelWithHint: true,
                ),
                minLines: 2,
                maxLines: 5,
              ),
              const SizedBox(height: 16),

              // 8) Fotos
              _SecHead('Fotos (hasta 4)'),
              _GridFotos(
                fotos: _fotos,
                onAnadirCamara: () => _anadirFoto(ImageSource.camera),
                onAnadirGaleria: () => _anadirFoto(ImageSource.gallery),
                onEliminar: _eliminarFoto,
              ),
              const SizedBox(height: 24),

              CheckboxListTile(
                value: _validada,
                onChanged: (v) => setState(() => _validada = v ?? false),
                title: const Text('Marcar como validada',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text(
                    'Indica que la verificación está revisada y aprobada.'),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _guardando ? null : () => _guardar(),
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('Guardar borrador'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: (_guardando || res.hayInfracciones)
                          ? null
                          : () => _guardar(validar: true),
                      icon: _guardando
                          ? const SizedBox(
                              width: 18, height: 18,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.check),
                      label: const Text('Validar'),
                    ),
                  ),
                ],
              ),
              if (res.hayInfracciones) ...[
                const SizedBox(height: 8),
                Text(
                  'No puedes validar mientras haya infracciones marcadas en rojo arriba.',
                  style: TextStyle(color: cs.error, fontSize: 13),
                ),
              ],
            ],
          );
        },
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
        color: Colors.green.shade50,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green.shade700),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('Todo cumple las normas. Puedes validar.'),
              ),
            ],
          ),
        ),
      );
    }
    final color =
        resultado.hayInfracciones ? cs.errorContainer : Colors.orange.shade50;
    final colorTexto =
        resultado.hayInfracciones ? cs.onErrorContainer : Colors.orange.shade900;
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
                      ? 'Infracciones: ${resultado.numInfracciones}'
                      : 'Avisos: ${resultado.numAvisos}',
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
                            : Colors.orange.shade700,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(h.mensaje,
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

// ----- Mini-componentes reutilizables -----

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
  final Set<String> marcas;
  final ValueChanged<String?> onChange;

  @override
  Widget build(BuildContext context) {
    final lista = marcas.toList()..sort();
    return DropdownButtonFormField<String?>(
      initialValue: valor,
      isExpanded: true,
      decoration: InputDecoration(labelText: label),
      items: [
        const DropdownMenuItem(value: null, child: Text('— sin asignar —')),
        ...lista.map((m) => DropdownMenuItem(value: m, child: Text(m))),
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
    return DropdownButtonFormField<String?>(
      initialValue: valor,
      isExpanded: true,
      decoration: InputDecoration(labelText: label),
      items: [
        const DropdownMenuItem(value: null, child: Text('— sin asignar —')),
        ...opciones.map((o) => DropdownMenuItem(value: o, child: Text(o))),
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
  });

  final Equipo equipo;
  final Piloto piloto1;
  final int creditosP1;
  final Piloto? piloto2;
  final int creditosP2;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final total = creditosP1 + creditosP2;
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
                    '$total créditos',
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
          '$creditos créd',
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
                    title: const Text('Hacer foto'),
                    onTap: () => Navigator.pop(context, 'camara'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_library_outlined),
                    title: const Text('Elegir de galería'),
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
            Text('Añadir',
                style: TextStyle(
                    color: cs.onPrimaryContainer,
                    fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
