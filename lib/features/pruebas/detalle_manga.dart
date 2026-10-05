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
import '../../data/database/app_database.dart';
import '../equipos/repositorio_equipos.dart';
import '../resultados/pantalla_resultados_manga.dart';
import '../verificaciones/lista_verificaciones.dart';
import 'editor_manga.dart';
import 'pantalla_inscritos.dart';
import 'repositorio_inscripciones_prueba.dart';
import 'repositorio_pruebas.dart';

class DetalleManga extends ConsumerWidget {
  const DetalleManga({super.key, required this.mangaId});

  final int mangaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mangaAsync = ref.watch(_mangaProvider(mangaId));
    final inscritosAsync = ref.watch(inscripcionesMangaProvider(mangaId));
    final esIndividual =
        maxPilotosEquipo(
          ref.watch(campeonatoActivoProvider)?.formato ?? 'PAREJAS',
        ) ==
        1;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: mangaAsync.maybeWhen(
          data: (m) => Text(m?.nombre ?? 'Manga'),
          orElse: () => const Text('Manga'),
        ),
        actions: [
          mangaAsync.maybeWhen(
            data: (m) => m == null
                ? const SizedBox.shrink()
                : Row(
                    children: [
                      if (esIndividual)
                        IconButton(
                          tooltip: 'Renumerar carriles',
                          icon: const Icon(Icons.format_list_numbered),
                          onPressed: () => _renumerar(context, ref, m),
                        ),
                      IconButton(
                        tooltip: 'Verificaciones',
                        icon: const Icon(Icons.fact_check_outlined),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                PantallaVerificaciones(mangaId: m.id),
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Resultados',
                        icon: const Icon(Icons.emoji_events_outlined),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                PantallaResultadosManga(mangaId: m.id),
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Editar manga',
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => EditorManga(
                              pruebaId: m.pruebaId,
                              mangaId: m.id,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      floatingActionButton: mangaAsync.maybeWhen(
        data: (m) => m == null
            ? null
            : FloatingActionButton.extended(
                onPressed: () => _abrirInscribir(context, ref, m),
                icon: const Icon(Icons.add),
                label: const Text('Inscribir equipo'),
              ),
        orElse: () => null,
      ),
      body: mangaAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (manga) {
          if (manga == null) return const Center(child: Text('No encontrada'));
          return inscritosAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (inscritos) {
              if (inscritos.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.group_off_outlined,
                          size: 96,
                          color: cs.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aún no hay equipos inscritos',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Pulsa "Inscribir equipo" para añadirlos uno a uno '
                          'asignando carril de salida.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                );
              }
              final filas = _filasManga(manga, inscritos, esIndividual);
              final lista = ListView.separated(
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 96),
                itemCount: filas.length,
                separatorBuilder: (_, _) => const SizedBox(height: 4),
                itemBuilder: (_, i) {
                  final f = filas[i];
                  if (f.cabecera != null) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
                      child: Text(
                        f.cabecera!,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    );
                  }
                  if (f.inscripcion == null) {
                    return _FilaCarrilLibre(
                      carril: f.carrilLibre!,
                      manga: manga,
                      inscritos: inscritos,
                    );
                  }
                  return _TarjetaInscripcion(
                    inscripcion: f.inscripcion!,
                    manga: manga,
                    inscritos: inscritos,
                    esIndividual: esIndividual,
                  );
                },
              );
              final repetidos = _carrilesRepetidos(inscritos);
              if (manga.pistersMangaId == null && repetidos.isEmpty) {
                return lista;
              }
              return Column(
                children: [
                  if (manga.pistersMangaId != null)
                    _BandaPisters(mangaId: manga.pistersMangaId!),
                  if (repetidos.isNotEmpty)
                    _AvisoRepetidos(repetidos: repetidos),
                  Expanded(child: lista),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _renumerar(
    BuildContext context,
    WidgetRef ref,
    Manga manga,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Renumerar carriles'),
        content: Text(
          'Se vuelven a asignar todos los carriles de "${manga.nombre}" '
          'por puntos, de más a menos: 1 a ${manga.numCarriles} y, si hay '
          'más pilotos, D1, D2… Se pierden los cambios hechos a mano.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Renumerar'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(repoInscripcionesProvider).renumerarCarriles(manga.id);
  }

  Future<void> _abrirInscribir(
    BuildContext context,
    WidgetRef ref,
    Manga manga,
  ) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _HojaInscribir(manga: manga),
    );
  }
}

/// Carriles con más de un piloto: carril → nombres.
Map<String, List<String>> _carrilesRepetidos(
  List<InscripcionConEquipo> inscritos,
) {
  final porCarril = <String, List<String>>{};
  for (final i in inscritos) {
    final c = (i.inscripcion.carrilSalida ?? '').trim().toUpperCase();
    if (c.isEmpty) continue;
    porCarril.putIfAbsent(c, () => []).add(i.nombreEquipo);
  }
  porCarril.removeWhere((_, v) => v.length < 2);
  return porCarril;
}

String _normCarril(String? c) => (c ?? '').trim().toUpperCase();

/// Carriles que se ofrecen en la manga: los de pista (1..numCarriles) y los
/// de descanso/seed (D1..Dk). k cubre a los pilotos que no caben en pista y
/// los D ya usados; en parejas se ofrecen al menos D1-D4 (seeds directos).
({List<String> pista, List<String> descanso}) _carrilesManga(
  Manga manga,
  List<InscripcionConEquipo> inscritos,
  bool esIndividual,
) {
  var k = inscritos.length - manga.numCarriles;
  for (final i in inscritos) {
    final c = _normCarril(i.inscripcion.carrilSalida);
    if (!c.startsWith('D')) continue;
    final n = int.tryParse(c.substring(1));
    if (n != null && n > k) k = n;
  }
  if (!esIndividual && k < 4) k = 4;
  return (
    pista: [for (var c = 1; c <= manga.numCarriles; c++) '$c'],
    descanso: [for (var d = 1; d <= k; d++) 'D$d'],
  );
}

/// Fila de la lista de la manga: un equipo, un carril de pista libre o una
/// cabecera de sección.
class _Fila {
  const _Fila.equipo(InscripcionConEquipo this.inscripcion)
    : carrilLibre = null,
      cabecera = null;
  const _Fila.libre(String this.carrilLibre)
    : inscripcion = null,
      cabecera = null;
  const _Fila.cabecera(String this.cabecera)
    : inscripcion = null,
      carrilLibre = null;
  final InscripcionConEquipo? inscripcion;
  final String? carrilLibre;
  final String? cabecera;
}

/// Lista de la manga con todos los carriles de pista, libres incluidos, para
/// ver la parrilla de un vistazo. Orden: D1.. (seeds/descanso), 1..N, carriles
/// fuera de rango y, al final, los equipos sin carril.
List<_Fila> _filasManga(
  Manga manga,
  List<InscripcionConEquipo> inscritos,
  bool esIndividual,
) {
  final carriles = _carrilesManga(manga, inscritos, esIndividual);
  final porCarril = <String, List<InscripcionConEquipo>>{};
  for (final i in inscritos) {
    porCarril
        .putIfAbsent(_normCarril(i.inscripcion.carrilSalida), () => [])
        .add(i);
  }
  final filas = <_Fila>[];
  for (final d in carriles.descanso) {
    for (final i in porCarril.remove(d) ?? const []) {
      filas.add(_Fila.equipo(i));
    }
  }
  for (final c in carriles.pista) {
    final ocupantes = porCarril.remove(c);
    if (ocupantes == null) {
      filas.add(_Fila.libre(c));
    } else {
      filas.addAll(ocupantes.map(_Fila.equipo));
    }
  }
  final sinCarril = porCarril.remove('') ?? const [];
  // Lo que queda son carriles escritos a mano fuera de rango (p. ej. "12").
  for (final i in inscritos) {
    if (porCarril.containsKey(_normCarril(i.inscripcion.carrilSalida))) {
      filas.add(_Fila.equipo(i));
    }
  }
  if (sinCarril.isNotEmpty) {
    filas.add(_Fila.cabecera('Sin carril (${sinCarril.length})'));
    filas.addAll(sinCarril.map(_Fila.equipo));
  }
  return filas;
}

/// Hoja para elegir el carril de [ins] en una cuadrícula. Un carril libre lo
/// mueve ahí; uno ocupado intercambia los dos equipos.
Future<void> _elegirCarril(
  BuildContext context,
  WidgetRef ref, {
  required Manga manga,
  required InscripcionConEquipo ins,
  required List<InscripcionConEquipo> inscritos,
  required bool esIndividual,
}) async {
  final carriles = _carrilesManga(manga, inscritos, esIndividual);
  final actual = _normCarril(ins.inscripcion.carrilSalida);
  final ocupante = <String, InscripcionConEquipo>{
    for (final o in inscritos)
      if (o.inscripcion.id != ins.inscripcion.id &&
          _normCarril(o.inscripcion.carrilSalida).isNotEmpty)
        _normCarril(o.inscripcion.carrilSalida): o,
  };

  // null = cancelado; '' = sin carril; '\u0000' = escribir a mano.
  const aMano = '\u0000';
  final elegido = await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) {
      final cs = Theme.of(ctx).colorScheme;
      Widget casilla(String c) {
        final o = ocupante[c];
        final esActual = c == actual;
        return SizedBox(
          width: 104,
          height: 72,
          child: Material(
            color: esActual
                ? cs.primary
                : o != null
                ? cs.surfaceContainerHighest
                : cs.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: esActual ? cs.primary : cs.outlineVariant,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => Navigator.pop(ctx, c),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      c,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: esActual ? cs.onPrimary : cs.onSurface,
                      ),
                    ),
                    Text(
                      esActual
                          ? 'actual'
                          : o != null
                          ? o.nombreEquipo
                          : 'libre',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: esActual
                            ? cs.onPrimary
                            : o != null
                            ? cs.onSurfaceVariant
                            : cs.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      Widget seccion(String titulo, List<String> lista) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Text(titulo, style: Theme.of(ctx).textTheme.labelLarge),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final c in lista) casilla(c)],
          ),
        ],
      );

      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Carril de ${ins.nombreEquipo}',
                style: Theme.of(ctx).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'Toca un carril libre para moverlo, o uno ocupado para '
                'intercambiarlos.',
                style: Theme.of(ctx).textTheme.bodySmall,
              ),
              seccion('Pista', carriles.pista),
              if (carriles.descanso.isNotEmpty)
                seccion(
                  esIndividual ? 'Descanso' : 'Seed directo',
                  carriles.descanso,
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  if (actual.isNotEmpty)
                    OutlinedButton.icon(
                      onPressed: () => Navigator.pop(ctx, ''),
                      icon: const Icon(Icons.block),
                      label: const Text('Sin carril'),
                    ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, aMano),
                    child: const Text('Escribir a mano…'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
  if (elegido == null || elegido == actual || !context.mounted) return;
  final repo = ref.read(repoInscripcionesProvider);
  if (elegido == aMano) {
    await _escribirCarril(context, ref, ins);
    return;
  }
  final o = ocupante[elegido];
  if (o != null) {
    await repo.intercambiarCarril(ins.inscripcion.id, o.inscripcion.id);
  } else {
    await repo.cambiarCarril(
      inscripcionId: ins.inscripcion.id,
      carrilSalida: elegido.isEmpty ? null : elegido,
      seedDirecto: elegido.startsWith('D'),
    );
  }
}

/// Carril escrito a mano (valores fuera de la cuadrícula).
Future<void> _escribirCarril(
  BuildContext context,
  WidgetRef ref,
  InscripcionConEquipo ins,
) async {
  final controller = TextEditingController(
    text: ins.inscripcion.carrilSalida ?? '',
  );
  final res = await showDialog<String?>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Carril de salida'),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Ej: D1, D2, 1, 2, 3…',
          helperText: 'D1-D4 para seeds directos, 1-N para sorteo',
        ),
        textCapitalization: TextCapitalization.characters,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, null),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.pop(ctx, controller.text.trim().toUpperCase()),
          child: const Text('Guardar'),
        ),
      ],
    ),
  );
  if (res == null) return;
  await ref
      .read(repoInscripcionesProvider)
      .cambiarCarril(
        inscripcionId: ins.inscripcion.id,
        carrilSalida: res.isEmpty ? null : res,
        seedDirecto: res.startsWith('D'),
      );
}

/// Carril de pista sin nadie: al tocarlo se elige qué equipo va ahí.
class _FilaCarrilLibre extends ConsumerWidget {
  const _FilaCarrilLibre({
    required this.carril,
    required this.manga,
    required this.inscritos,
  });
  final String carril;
  final Manga manga;
  final List<InscripcionConEquipo> inscritos;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: cs.outlineVariant),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        leading: Container(
          width: 48,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Text(
            carril,
            style: TextStyle(
              color: cs.outline,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ),
        title: Text(
          'Libre',
          style: TextStyle(color: cs.outline, fontStyle: FontStyle.italic),
        ),
        trailing: Icon(Icons.add_circle_outline, color: cs.primary),
        onTap: () => _elegirEquipo(context, ref),
      ),
    );
  }

  Future<void> _elegirEquipo(BuildContext context, WidgetRef ref) async {
    // Primero los que no tienen carril, luego el resto en su orden.
    final candidatos = [
      ...inscritos.where(
        (i) => _normCarril(i.inscripcion.carrilSalida).isEmpty,
      ),
      ...inscritos.where(
        (i) => _normCarril(i.inscripcion.carrilSalida).isNotEmpty,
      ),
    ];
    final elegido = await showModalBottomSheet<InscripcionConEquipo>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(ctx).size.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  '¿Quién sale en el carril $carril?',
                  style: Theme.of(ctx).textTheme.titleLarge,
                ),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final i in candidatos)
                      ListTile(
                        leading: SizedBox(
                          width: 40,
                          child: Text(
                            i.inscripcion.carrilSalida ?? '—',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        title: Text(i.nombreEquipo),
                        subtitle: Text(
                          _normCarril(i.inscripcion.carrilSalida).isEmpty
                              ? 'Sin carril'
                              : 'Deja libre el ${i.inscripcion.carrilSalida}',
                        ),
                        onTap: () => Navigator.pop(ctx, i),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (elegido == null) return;
    await ref
        .read(repoInscripcionesProvider)
        .cambiarCarril(
          inscripcionId: elegido.inscripcion.id,
          carrilSalida: carril,
          seedDirecto: false,
        );
  }
}

class _AvisoRepetidos extends StatelessWidget {
  const _AvisoRepetidos({required this.repetidos});
  final Map<String, List<String>> repetidos;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      color: cs.errorContainer,
      child: ListTile(
        leading: Icon(Icons.warning_amber_outlined, color: cs.onErrorContainer),
        title: Text(
          'Carriles repetidos',
          style: TextStyle(
            color: cs.onErrorContainer,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          repetidos.entries
              .map((e) => '${e.key}: ${e.value.join(', ')}')
              .join('\n'),
          style: TextStyle(color: cs.onErrorContainer),
        ),
      ),
    );
  }
}

/// "Pisters: pilotos de (manga)" con sus nombres (solo individuales).
class _BandaPisters extends ConsumerWidget {
  const _BandaPisters({required this.mangaId});
  final int mangaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pisters = ref.watch(_mangaProvider(mangaId)).asData?.value;
    if (pisters == null) return const SizedBox.shrink();
    final nombres =
        ref
            .watch(inscripcionesMangaProvider(mangaId))
            .asData
            ?.value
            .map((i) => i.equipo.nombre)
            .join(', ') ??
        '';
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      color: cs.secondaryContainer,
      child: ListTile(
        leading: Icon(Icons.sports_outlined, color: cs.onSecondaryContainer),
        title: Text(
          'Pisters: pilotos de ${pisters.nombre}',
          style: TextStyle(
            color: cs.onSecondaryContainer,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: nombres.isEmpty
            ? null
            : Text(nombres, style: TextStyle(color: cs.onSecondaryContainer)),
      ),
    );
  }
}

final _mangaProvider = StreamProvider.autoDispose.family<Manga?, int>((
  ref,
  id,
) {
  final db = ref.watch(dbProvider);
  return (db.select(
    db.mangas,
  )..where((t) => t.id.equals(id))).watchSingleOrNull();
});

class _TarjetaInscripcion extends ConsumerWidget {
  const _TarjetaInscripcion({
    required this.inscripcion,
    required this.manga,
    required this.inscritos,
    required this.esIndividual,
  });

  final InscripcionConEquipo inscripcion;
  final Manga manga;
  final List<InscripcionConEquipo> inscritos;
  final bool esIndividual;

  Future<void> _elegir(BuildContext context, WidgetRef ref) => _elegirCarril(
    context,
    ref,
    manga: manga,
    ins: inscripcion,
    inscritos: inscritos,
    esIndividual: esIndividual,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final carril = inscripcion.inscripcion.carrilSalida ?? '—';
    final esSeed = inscripcion.inscripcion.seedDirecto;

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: esSeed ? cs.primaryContainer : cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            carril,
            style: TextStyle(
              color: esSeed ? cs.onPrimaryContainer : cs.onSurface,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ),
        title: Text(inscripcion.nombreEquipo),
        subtitle: Text(inscripcion.pilotos),
        // Tocar el equipo abre la cuadrícula de carriles.
        onTap: () => _elegir(context, ref),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (op) async {
            if (op == 'carril') {
              await _elegir(context, ref);
            } else if (op == 'baja') {
              if (await confirmarBajaPrueba(
                context,
                inscripcion.nombreEquipo,
              )) {
                await ref
                    .read(repoInscripcionesPruebaProvider)
                    .darDeBaja(
                      pruebaId: manga.pruebaId,
                      equipoId: inscripcion.equipo.id,
                    );
              }
            } else if (op == 'seed') {
              await ref
                  .read(repoInscripcionesProvider)
                  .cambiarCarril(
                    inscripcionId: inscripcion.inscripcion.id,
                    carrilSalida: inscripcion.inscripcion.carrilSalida,
                    seedDirecto: !esSeed,
                  );
            } else if (op == 'quitar') {
              final ok = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Quitar inscripción'),
                  content: Text(
                    '¿Quitar a "${inscripcion.nombreEquipo}" de esta manga?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Quitar'),
                    ),
                  ],
                ),
              );
              if (ok == true) {
                await ref
                    .read(repoInscripcionesProvider)
                    .quitar(inscripcion.inscripcion.id);
              }
            }
          },
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'carril', child: Text('Cambiar carril')),
            PopupMenuItem(
              value: 'seed',
              child: Text(
                esSeed ? 'Quitar seed directo' : 'Marcar como seed directo',
              ),
            ),
            const PopupMenuItem(
              value: 'quitar',
              child: Text('Quitar de la manga'),
            ),
            const PopupMenuItem(
              value: 'baja',
              child: Text('Dar de baja de la prueba'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HojaInscribir extends ConsumerStatefulWidget {
  const _HojaInscribir({required this.manga});
  final Manga manga;

  @override
  ConsumerState<_HojaInscribir> createState() => _HojaInscribirState();
}

class _HojaInscribirState extends ConsumerState<_HojaInscribir> {
  String _busqueda = '';
  final _carril = TextEditingController();

  @override
  void dispose() {
    _carril.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final equiposAsync = ref.watch(equiposCampeonatoProvider);
    final inscritosAsync = ref.watch(
      inscripcionesMangaProvider(widget.manga.id),
    );
    final cs = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Inscribir equipo en "${widget.manga.nombre}"',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Buscar equipo o piloto…',
              ),
              onChanged: (v) =>
                  setState(() => _busqueda = v.trim().toLowerCase()),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: equiposAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (equipos) {
                  final yaInscritos = inscritosAsync.maybeWhen(
                    data: (lista) => lista.map((i) => i.equipo.id).toSet(),
                    orElse: () => <int>{},
                  );
                  final candidatos = equipos
                      .where((e) => !yaInscritos.contains(e.equipo.id))
                      .where((e) {
                        if (_busqueda.isEmpty) return true;
                        final t = '${e.equipo.nombre} ${e.pilotosTexto}'
                            .toLowerCase();
                        return t.contains(_busqueda);
                      })
                      .toList();

                  if (candidatos.isEmpty) {
                    return Center(
                      child: Text(
                        equipos.isEmpty
                            ? 'No hay equipos en este campeonato. Créalos primero.'
                            : 'Todos los equipos ya están inscritos.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: cs.outline),
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: scrollController,
                    itemCount: candidatos.length,
                    itemBuilder: (_, i) {
                      final eq = candidatos[i];
                      return Card(
                        child: ListTile(
                          title: Text(eq.equipo.nombre),
                          subtitle: Text(eq.pilotosTexto),
                          trailing: FilledButton(
                            onPressed: () => _inscribir(eq.equipo),
                            child: const Text('Inscribir'),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _inscribir(Equipo equipo) async {
    final carril = await showDialog<String?>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Carril de "${equipo.nombre}"'),
        content: TextField(
          controller: _carril,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Ej: D1, 3…',
            helperText: 'Deja vacío si aún no asignas carril',
          ),
          textCapitalization: TextCapitalization.characters,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(context, _carril.text.trim().toUpperCase()),
            child: const Text('Inscribir'),
          ),
        ],
      ),
    );
    if (carril == null) return;
    final esSeed = carril.startsWith('D');
    await ref
        .read(repoInscripcionesProvider)
        .inscribir(
          mangaId: widget.manga.id,
          equipoId: equipo.id,
          carrilSalida: carril.isEmpty ? null : carril,
          seedDirecto: esSeed,
        );
    _carril.clear();
    if (mounted) Navigator.of(context).pop();
  }
}
