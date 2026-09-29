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
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../domain/generador_mangas.dart';
import '../equipos/repositorio_equipos.dart';
import 'repositorio_inscripciones_prueba.dart';
import 'repositorio_pruebas.dart';

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
  /// Carriles de la pista. Una manga intenta llenarlos todos; si sobran
  /// equipos, puede llevar alguno más (rotan).
  int _carriles = 6;
  /// Minutos que dura el turno de cada equipo en un carril. Junto a
  /// [_carriles] determina la duración real de una manga, usada para
  /// espaciar los horarios sugeridos.
  int _minutosPorCarril = 6;
  int _numMangas = 1;
  List<TextEditingController> _nombresControllers = [];
  bool _sustituir = true;
  bool _trabajando = false;
  /// Solo individuales: carril de salida 1..N / D1.. por puntos, y pisters
  /// entre mangas del mismo día.
  bool _asignarCarriles = false;
  bool _asignarPisters = false;

  bool get _esIndividual =>
      maxPilotosEquipo(ref.read(campeonatoActivoProvider)?.formato ?? 'PAREJAS') ==
      1;
  bool get _conCarriles => _esIndividual && _asignarCarriles;
  bool get _conPisters => _esIndividual && _asignarPisters;

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

    // 1) Puntos del campeonato (o puntuación previa si aún no hay).
    _puntosPorPiloto = await puntosSemillaPorPiloto(db, activo.id);

    // 3) Calcular sugerencia de mangas según las preferencias de día.
    final semillasTmp = widget.inscritos.map((i) {
      final puntos = (_puntosPorPiloto[i.piloto1.id] ?? 0) +
          (i.piloto2 != null ? (_puntosPorPiloto[i.piloto2!.id] ?? 0) : 0);
      return EquipoSemilla(
        equipoId: i.equipo.id,
        nombre: i.equipo.nombre,
        copa: i.copa,
        puntuacion: puntos,
        preferenciaDia: i.inscripcion.preferenciaDia,
      );
    }).toList();
    var nombres = GeneradorMangas.sugerirMangasPorPreferencia(
        equipos: semillasTmp,
        tamMax: _carriles,
        duracionMangaMinutos: _duracionMangaMinutos);
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

  /// Duración real de una manga: cada equipo pasa por todos los carriles,
  /// [_minutosPorCarril] minutos en cada uno.
  int get _duracionMangaMinutos => _carriles * _minutosPorCarril;

  void _ajustarCarriles(int n) {
    final clamped = n.clamp(2, 32);
    setState(() => _carriles = clamped);
    _regenerarSugerencias();
  }

  void _ajustarMinutosPorCarril(int n) {
    final clamped = n.clamp(1, 60);
    setState(() => _minutosPorCarril = clamped);
    _regenerarSugerencias();
  }

  /// Recalcula el número de mangas sugerido y sus nombres/horarios a partir
  /// de los carriles y minutos por carril actuales, sustituyendo lo que
  /// hubiera en los campos de nombre (se llama solo desde los pasos 1, antes
  /// de que el usuario personalice nombres en el paso 3).
  void _regenerarSugerencias() {
    final semillasTmp = widget.inscritos.map((i) {
      final puntos = (_puntosPorPiloto[i.piloto1.id] ?? 0) +
          (i.piloto2 != null ? (_puntosPorPiloto[i.piloto2!.id] ?? 0) : 0);
      return EquipoSemilla(
        equipoId: i.equipo.id,
        nombre: i.equipo.nombre,
        copa: i.copa,
        puntuacion: puntos,
        preferenciaDia: i.inscripcion.preferenciaDia,
      );
    }).toList();
    var nombres = GeneradorMangas.sugerirMangasPorPreferencia(
        equipos: semillasTmp,
        tamMax: _carriles,
        duracionMangaMinutos: _duracionMangaMinutos);
    if (nombres.isEmpty) {
      final n = GeneradorMangas.numMangasSugerido(
          totalEquipos: widget.inscritos.length, tamMax: _carriles);
      nombres = GeneradorMangas.sugerirNombresMangas(n);
    }
    for (final c in _nombresControllers) {
      c.dispose();
    }
    _nombresControllers =
        nombres.map((n) => TextEditingController(text: n)).toList();
    _numMangas = _nombresControllers.length;
    _recalcular();
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
        copa: i.copa,
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
            carrilesPorManga: _carriles,
            sustituirExistentes: _sustituir,
            asignarCarriles: _conCarriles,
            asignarPisters: _conPisters,
          );
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Mangas creadas'),
          content: Text(
              'Se han creado ${_previa.length} mangas con '
              '${_previa.fold<int>(0, (n, m) => n + m.equipos.length)} equipos.\n\n'
              '${_conCarriles ? 'Con carril de salida asignado.' : 'Los carriles se asignarán antes de la carrera.'}'
              '${_conPisters ? '\nPisters asignados entre las mangas de cada día.' : ''}'),
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
          const SizedBox(height: 16),
          Text(
            'Minutos por carril (cuánto dura el turno de un equipo en '
            'cada carril, para calcular la duración de la manga).',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton.filledTonal(
                onPressed: _minutosPorCarril > 1
                    ? () => _ajustarMinutosPorCarril(_minutosPorCarril - 1)
                    : null,
                icon: const Icon(Icons.remove),
              ),
              const SizedBox(width: 16),
              Text('$_minutosPorCarril',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w700)),
              const SizedBox(width: 16),
              IconButton.filledTonal(
                onPressed: _minutosPorCarril < 60
                    ? () => _ajustarMinutosPorCarril(_minutosPorCarril + 1)
                    : null,
                icon: const Icon(Icons.add),
              ),
              const SizedBox(width: 8),
              Text('min/carril',
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Cada manga durará ~$_duracionMangaMinutos min '
            '($_carriles carriles × $_minutosPorCarril min).',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontWeight: FontWeight.w600, color: cs.primary),
          ),
          const SizedBox(height: 20),
          Text('2. Número de mangas',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Sugerido: ${GeneradorMangas.numMangasSugerido(totalEquipos: total, tamMax: _carriles)} '
            '(sin carriles vacíos con $_carriles carriles: si sobran '
            'equipos, las mangas pasan de $_carriles). Puedes cambiarlo.',
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
          if (_esIndividual) ...[
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Asignar carril automáticamente'),
              subtitle: Text(
                  'Por puntos, de más a menos: carriles 1 a $_carriles y, '
                  'si hay más pilotos, D1, D2…'),
              value: _asignarCarriles,
              onChanged: (v) => setState(() => _asignarCarriles = v),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Asignar pisters'),
              subtitle: const Text(
                  'Entre las mangas del mismo día. 2 mangas: 1ª↔2ª. '
                  '3: la 3ª hace de pisters en la 1ª, la 1ª en la 2ª y la '
                  '2ª en la 3ª. 4: 1ª↔2ª y 3ª↔4ª.'),
              value: _asignarPisters,
              onChanged: (v) => setState(() => _asignarPisters = v),
            ),
          ],
          const SizedBox(height: 24),
          Text('4. Vista previa',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            _conCarriles
                ? 'El número de la izquierda es el carril de salida.'
                : 'Los carriles los asignarás después, antes de la carrera.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          ...() {
            final pisters = _conPisters
                ? GeneradorMangas.asignarPisters(
                    _previa.map((m) => m.nombre).toList())
                : null;
            return _previa.asMap().entries.map((e) => _MangaPreview(
                  manga: e.value,
                  carriles: _conCarriles
                      ? GeneradorMangas.carrilesSalida(
                          e.value.equipos.length, _carriles)
                      : null,
                  pisters: pisters?[e.key] == null
                      ? null
                      : _previa[pisters![e.key]!].nombre,
                ));
          }(),
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
  const _MangaPreview({required this.manga, this.carriles, this.pisters});
  final MangaGenerada manga;
  /// Carril de salida de cada equipo (mismo orden), si se asigna.
  final List<String>? carriles;
  /// Nombre de la manga que hace de pisters en esta, si se asigna.
  final String? pisters;

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
              if (pisters != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    children: [
                      Icon(Icons.sports_outlined, size: 16, color: cs.outline),
                      const SizedBox(width: 6),
                      Text('Pisters: pilotos de $pisters',
                          style: TextStyle(color: cs.outline, fontSize: 13)),
                    ],
                  ),
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
                          child: Text(carriles?[e.key] ?? '${e.key + 1}',
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
