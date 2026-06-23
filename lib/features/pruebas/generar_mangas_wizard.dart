import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import '../../domain/generador_mangas.dart';
import 'repositorio_inscripciones_prueba.dart';

class GenerarMangasWizard extends ConsumerStatefulWidget {
  const GenerarMangasWizard({
    super.key,
    required this.pruebaId,
    required this.inscritos,
  });

  final int pruebaId;
  final List<InscritoPrueba> inscritos;

  @override
  ConsumerState<GenerarMangasWizard> createState() =>
      _GenerarMangasWizardState();
}

class _GenerarMangasWizardState extends ConsumerState<GenerarMangasWizard> {
  /// Carriles de la pista = máximo de equipos por manga (corren a la vez).
  int _carriles = 6;
  int _numMangas = 1;
  List<TextEditingController> _nombresControllers = [];
  bool _sustituir = true;
  bool _trabajando = false;

  /// Cache de puntuaciones por piloto.
  Map<int, num> _puntosPorPiloto = {};
  bool _listo = false;

  ResultadoGeneracion? _resultado;
  List<MangaGenerada> get _previa => _resultado?.mangas ?? const [];
  List<EquipoSemilla> get _sinManga => _resultado?.sinManga ?? const [];

  @override
  void initState() {
    super.initState();
    _inicializar();
  }

  Future<void> _inicializar() async {
    final db = ref.read(dbProvider);
    final activo = ref.read(campeonatoActivoProvider)!;

    // 1) Puntos BRUTOS acumulados en este campeonato
    final pruebas = await (db.select(db.pruebas)
          ..where((t) => t.campeonatoId.equals(activo.id)))
        .get();
    final pruebaIds = pruebas.map((p) => p.id).toSet();
    final mangas = await (db.select(db.mangas)
          ..where((t) => t.pruebaId.isIn(pruebaIds)))
        .get();
    final mangaIds = mangas.map((m) => m.id).toSet();
    final resultados = mangaIds.isEmpty
        ? <Resultado>[]
        : await (db.select(db.resultados)
              ..where((t) => t.mangaId.isIn(mangaIds)))
            .get();

    final brutoPorPiloto = <int, int>{};
    for (final r in resultados) {
      brutoPorPiloto.update(
          r.pilotoId, (v) => v + r.puntos,
          ifAbsent: () => r.puntos);
    }

    // 2) Si no hay puntos en este campeonato, fallback a saldo año anterior.
    final perfiles = await (db.select(db.pilotoCampeonato)
          ..where((t) => t.campeonatoId.equals(activo.id)))
        .get();
    final saldoAnterior = {
      for (final p in perfiles) p.pilotoId: p.saldoTemporadaAnterior,
    };

    final hayPuntosEsteAnio = brutoPorPiloto.values.any((v) => v > 0);
    if (hayPuntosEsteAnio) {
      _puntosPorPiloto = {...brutoPorPiloto};
    } else {
      _puntosPorPiloto = {...saldoAnterior};
    }

    // 3) Calcular sugerencia de mangas según las preferencias de día.
    final semillasTmp = widget.inscritos.map((i) {
      final puntos = (_puntosPorPiloto[i.piloto1.id] ?? 0) +
          (i.piloto2 != null ? (_puntosPorPiloto[i.piloto2!.id] ?? 0) : 0);
      return EquipoSemilla(
        equipoId: i.equipo.id,
        nombre: i.equipo.nombre,
        copa: i.equipo.copa,
        puntuacion: puntos,
        preferenciaDia: i.inscripcion.preferenciaDia,
      );
    }).toList();
    var nombres = GeneradorMangas.sugerirMangasPorPreferencia(
        equipos: semillasTmp, tamMax: _carriles);
    if (nombres.isEmpty) {
      // fallback: número sugerido sobre el total
      final n = GeneradorMangas.numMangasSugerido(
          totalEquipos: widget.inscritos.length, tamMax: _carriles);
      nombres = GeneradorMangas.sugerirNombresMangas(n);
    }
    _numMangas = nombres.length;
    _nombresControllers = nombres
        .map((n) => TextEditingController(text: n))
        .toList();

    setState(() => _listo = true);
    _recalcular();
  }

  void _ajustarCarriles(int n) {
    final clamped = n.clamp(2, 32);
    // Al cambiar los carriles, re-sugiere el número de mangas para que quepan
    // todos los equipos respetando el nuevo máximo por manga.
    final sugerido = GeneradorMangas.numMangasSugerido(
        totalEquipos: widget.inscritos.length, tamMax: clamped);
    setState(() => _carriles = clamped);
    _ajustarNumMangas(sugerido);
  }

  void _ajustarNumMangas(int n) {
    final clamped = n.clamp(1, 10);
    while (_nombresControllers.length < clamped) {
      _nombresControllers.add(TextEditingController(
        text: 'Manga ${_nombresControllers.length + 1}',
      ));
    }
    while (_nombresControllers.length > clamped) {
      _nombresControllers.removeLast().dispose();
    }
    _numMangas = clamped;
    _recalcular();
  }

  void _recalcular() {
    final nombres = _nombresControllers.map((c) => c.text.trim()).toList();
    final semillas = widget.inscritos.map((i) {
      final puntos = (_puntosPorPiloto[i.piloto1.id] ?? 0) +
          (i.piloto2 != null ? (_puntosPorPiloto[i.piloto2!.id] ?? 0) : 0);
      return EquipoSemilla(
        equipoId: i.equipo.id,
        nombre: i.equipo.nombre,
        copa: i.equipo.copa,
        puntuacion: puntos,
        preferenciaDia: i.inscripcion.preferenciaDia,
      );
    }).toList();

    setState(() {
      _resultado = GeneradorMangas.generar(
        equipos: semillas,
        config: ConfigGenerador(
          nombresMangas: nombres,
          tamMaxManga: _carriles,
        ),
      );
    });
  }

  Future<void> _aplicar() async {
    setState(() => _trabajando = true);
    try {
      await ref.read(repoInscripcionesPruebaProvider).aplicarGeneracion(
            pruebaId: widget.pruebaId,
            mangasGeneradas: _previa,
            sustituirExistentes: _sustituir,
          );
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Mangas creadas'),
          content: Text(
              'Se han creado ${_previa.length} mangas con '
              '${_previa.fold<int>(0, (n, m) => n + m.equipos.length)} equipos.\n\n'
              'Los carriles se asignarán antes de la carrera.'),
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
      if (mounted) setState(() => _trabajando = false);
    }
  }

  @override
  void dispose() {
    for (final c in _nombresControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_listo) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final cs = Theme.of(context).colorScheme;
    final total = widget.inscritos.length;
    final hayPuntos = _puntosPorPiloto.values.any((v) => v > 0);

    return Scaffold(
      appBar: AppBar(title: const Text('Generar mangas')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            color: cs.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.groups, color: cs.onPrimaryContainer),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$total equipos inscritos a repartir',
                          style: TextStyle(
                              color: cs.onPrimaryContainer,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          hayPuntos
                              ? 'Ordenados por puntos brutos acumulados.'
                              : 'Sin puntos este año → ordenados por saldo año anterior (0 si no hay).',
                          style: TextStyle(
                              color: cs.onPrimaryContainer.withValues(alpha: 0.8),
                              fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('1. Carriles de la pista',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Cuántos coches corren a la vez. Marca el máximo de equipos por '
            'manga para repartirlos bien.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton.filledTonal(
                onPressed: _carriles > 2
                    ? () => _ajustarCarriles(_carriles - 1)
                    : null,
                icon: const Icon(Icons.remove),
              ),
              const SizedBox(width: 16),
              Text('$_carriles',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w700)),
              const SizedBox(width: 16),
              IconButton.filledTonal(
                onPressed: _carriles < 32
                    ? () => _ajustarCarriles(_carriles + 1)
                    : null,
                icon: const Icon(Icons.add),
              ),
              const SizedBox(width: 8),
              Text('carriles', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: 20),
          Text('2. Número de mangas',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Sugerido: ${GeneradorMangas.numMangasSugerido(totalEquipos: total, tamMax: _carriles)} '
            '(máximo $_carriles equipos por manga). Puedes cambiarlo.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton.filledTonal(
                onPressed:
                    _numMangas > 1 ? () => _ajustarNumMangas(_numMangas - 1) : null,
                icon: const Icon(Icons.remove),
              ),
              const SizedBox(width: 16),
              Text('$_numMangas',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w700)),
              const SizedBox(width: 16),
              IconButton.filledTonal(
                onPressed: _numMangas < 10
                    ? () => _ajustarNumMangas(_numMangas + 1)
                    : null,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text('3. Nombres y horarios',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ..._nombresControllers.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TextField(
                  controller: e.value,
                  decoration: InputDecoration(
                    labelText: 'Manga ${e.key + 1}',
                    prefixIcon: const Icon(Icons.flag_outlined),
                  ),
                  onChanged: (_) => _recalcular(),
                ),
              )),
          const SizedBox(height: 24),
          Text('4. Vista previa',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Los carriles los asignarás después, antes de la carrera.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          ..._previa.map((m) => _MangaPreview(manga: m)),
          if (_sinManga.isNotEmpty) ...[
            const SizedBox(height: 8),
            _BloqueSinManga(equipos: _sinManga),
          ],
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Sustituir mangas existentes'),
            subtitle: const Text(
                'Si esta prueba ya tenía mangas, se eliminan y se reemplazan.'),
            value: _sustituir,
            onChanged: (v) => setState(() => _sustituir = v),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: (_trabajando || _previa.isEmpty) ? null : _aplicar,
            icon: _trabajando
                ? const SizedBox(
                    width: 18, height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check),
            label: const Text('Crear estas mangas'),
          ),
        ],
      ),
    );
  }
}

class _BloqueSinManga extends StatelessWidget {
  const _BloqueSinManga({required this.equipos});
  final List<EquipoSemilla> equipos;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      color: cs.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber_outlined,
                    color: cs.onErrorContainer),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Sin manga (${equipos.length})',
                    style: TextStyle(
                      color: cs.onErrorContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Estos equipos prefieren un día que no tiene ninguna manga en este reparto. '
              'Añade una manga de ese día arriba o cambia su preferencia.',
              style: TextStyle(color: cs.onErrorContainer, fontSize: 13),
            ),
            const SizedBox(height: 8),
            ...equipos.map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Icon(Icons.person_off_outlined,
                          size: 16, color: cs.onErrorContainer),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          e.nombre,
                          style: TextStyle(
                              color: cs.onErrorContainer,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        'Prefiere: ${e.preferenciaDia ?? "?"}',
                        style: TextStyle(
                          color: cs.onErrorContainer,
                          fontSize: 12,
                        ),
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

class _MangaPreview extends StatelessWidget {
  const _MangaPreview({required this.manga});
  final MangaGenerada manga;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.flag_outlined, color: cs.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(manga.nombre,
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  Text(
                    '${manga.equipos.length} eq.  ·  ${manga.puntuacionTotal} pts',
                    style: TextStyle(color: cs.outline, fontSize: 13),
                  ),
                ],
              ),
              const Divider(),
              ...manga.equipos.asMap().entries.map((e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 24,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: cs.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text('${e.key + 1}',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: cs.onSurface,
                                fontSize: 12,
                              )),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(e.value.nombre,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: cs.primary.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${e.value.puntuacion} pts',
                            style: TextStyle(
                                color: cs.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(e.value.copa,
                            style: TextStyle(
                                color: cs.outline, fontSize: 12)),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
