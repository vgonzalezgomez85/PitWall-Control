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
import 'dart:math';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import '../campeonatos/editor_campeonato.dart';
import 'repositorio_verificaciones.dart';

/// Una fila del sorteo: un equipo inscrito en una manga de la prueba, con el
/// motor de organización que tenga asignado (si lo tiene).
class FilaSorteo {
  final int mangaId;
  final int equipoId;
  final String equipoNombre;
  final String pilotoNombre;
  final String copa;
  final String mangaNombre;
  final int? motor;

  FilaSorteo({
    required this.mangaId,
    required this.equipoId,
    required this.equipoNombre,
    required this.pilotoNombre,
    required this.copa,
    required this.mangaNombre,
    required this.motor,
  });
}

class DatosSorteo {
  final Campeonato campeonato;
  final List<FilaSorteo> filas;
  final List<int> disponibles; // motores del rango aún sin asignar en la prueba
  final int total; // tamaño del rango

  DatosSorteo({
    required this.campeonato,
    required this.filas,
    required this.disponibles,
    required this.total,
  });

  bool get individual => campeonato.formato == 'INDIVIDUAL';
  bool get rangoConfigurado => total > 0;
  int get asignados => filas.where((f) => f.motor != null).length;
}

/// Combina varios streams en un único tick (emite uno inicial y luego en cada
/// cambio de cualquiera de ellos).
Stream<void> _ticks(List<Stream> streams) {
  final ctrl = StreamController<void>();
  final subs = <StreamSubscription>[];
  ctrl.onListen = () {
    ctrl.add(null);
    for (final s in streams) {
      subs.add(s.listen((_) => ctrl.add(null), onError: ctrl.addError));
    }
  };
  ctrl.onCancel = () async {
    for (final s in subs) {
      await s.cancel();
    }
  };
  return ctrl.stream;
}

final sorteoMotoresProvider =
    StreamProvider.autoDispose.family<DatosSorteo?, int>((ref, pruebaId) {
  final db = ref.watch(dbProvider);
  final s1 = db.select(db.inscripciones).watch();
  final s2 = db.select(db.verificaciones).watch();
  final s3 = (db.select(db.mangas)..where((t) => t.pruebaId.equals(pruebaId)))
      .watch();

  return _ticks([s1, s2, s3]).asyncMap((_) async {
    final prueba = await (db.select(db.pruebas)
          ..where((t) => t.id.equals(pruebaId)))
        .getSingleOrNull();
    if (prueba == null) return null;
    final camp = await (db.select(db.campeonatos)
          ..where((t) => t.id.equals(prueba.campeonatoId)))
        .getSingle();

    final mangas = await (db.select(db.mangas)
          ..where((t) => t.pruebaId.equals(pruebaId)))
        .get();
    final mangaIds = mangas.map((m) => m.id).toList();
    final mangaNombre = {for (final m in mangas) m.id: m.nombre};

    final inscritos = mangaIds.isEmpty
        ? <Inscripcione>[]
        : await (db.select(db.inscripciones)
              ..where((t) => t.mangaId.isIn(mangaIds)))
            .get();

    final filas = <FilaSorteo>[];
    final asignados = <int>{};
    for (final ins in inscritos) {
      final eq = await (db.select(db.equipos)
            ..where((t) => t.id.equals(ins.equipoId)))
          .getSingleOrNull();
      if (eq == null) continue;
      final p1 = await (db.select(db.pilotos)
            ..where((t) => t.id.equals(eq.piloto1Id)))
          .getSingleOrNull();
      final ver = await (db.select(db.verificaciones)
            ..where((t) =>
                t.mangaId.equals(ins.mangaId) & t.equipoId.equals(eq.id))
            ..limit(1))
          .getSingleOrNull();
      int? motor;
      if (ver != null &&
          ver.motorTipo == 'ORGANIZACION' &&
          (ver.motor?.trim().isNotEmpty ?? false)) {
        motor = int.tryParse(ver.motor!.trim());
      }
      if (motor != null) asignados.add(motor);
      filas.add(FilaSorteo(
        mangaId: ins.mangaId,
        equipoId: eq.id,
        equipoNombre: eq.nombre,
        pilotoNombre: p1?.nombre ?? '',
        copa: eq.copa,
        mangaNombre: mangaNombre[ins.mangaId] ?? '',
        motor: motor,
      ));
    }

    String disp(FilaSorteo f) =>
        camp.formato == 'INDIVIDUAL' ? f.pilotoNombre : f.equipoNombre;
    filas.sort((a, b) => disp(a).toLowerCase().compareTo(disp(b).toLowerCase()));

    final todos = <int>[];
    final min = camp.motorSorteoMin, max = camp.motorSorteoMax;
    if (min != null && max != null && max >= min) {
      for (var n = min; n <= max; n++) {
        todos.add(n);
      }
    }
    final disponibles = todos.where((n) => !asignados.contains(n)).toList();

    return DatosSorteo(
      campeonato: camp,
      filas: filas,
      disponibles: disponibles,
      total: todos.length,
    );
  });
});

class PantallaSorteoMotores extends ConsumerWidget {
  const PantallaSorteoMotores({super.key, required this.pruebaId});

  final int pruebaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final datosAsync = ref.watch(sorteoMotoresProvider(pruebaId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sorteo de motores'),
        actions: [
          datosAsync.maybeWhen(
            data: (d) => (d != null && d.rangoConfigurado && d.disponibles.isNotEmpty
                    && d.filas.any((f) => f.motor == null))
                ? TextButton.icon(
                    onPressed: () => _sortearRestantes(context, ref, d),
                    icon: const Icon(Icons.casino_outlined),
                    label: const Text('Sortear restantes'),
                  )
                : const SizedBox.shrink(),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: datosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (d) {
          if (d == null) return const Center(child: Text('Prueba no encontrada'));
          if (!d.rangoConfigurado) {
            return _SinRango(campeonato: d.campeonato);
          }
          if (d.filas.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'No hay equipos inscritos en las mangas de esta prueba.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: cs.outline),
                ),
              ),
            );
          }
          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                _Cabecera(datos: d),
                TabBar(
                  labelColor: cs.primary,
                  tabs: const [
                    Tab(text: 'Equipos'),
                    Tab(text: 'Números'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      ListView.separated(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
                        itemCount: d.filas.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 4),
                        itemBuilder: (_, i) => _FilaTarjeta(
                          fila: d.filas[i],
                          individual: d.individual,
                          onSortear: () =>
                              _sortearUno(context, ref, d, d.filas[i]),
                          onQuitar: d.filas[i].motor == null
                              ? null
                              : () => _quitar(ref, d.filas[i]),
                        ),
                      ),
                      _VistaNumeros(datos: d),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _nombre(DatosSorteo d, FilaSorteo f) =>
      d.individual ? f.pilotoNombre : f.equipoNombre;

  Future<void> _sortearUno(
      BuildContext context, WidgetRef ref, DatosSorteo d, FilaSorteo f) async {
    // Para re-sortear, el motor actual del equipo vuelve a estar disponible.
    final candidatos = [...d.disponibles, if (f.motor != null) f.motor!];
    if (candidatos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No quedan motores disponibles.')),
      );
      return;
    }
    final rng = Random();
    final elegido = await showDialog<int>(
      context: context,
      builder: (ctx) {
        var actual = candidatos[rng.nextInt(candidatos.length)];
        return StatefulBuilder(
          builder: (ctx, setSt) => AlertDialog(
            title: Text(_nombre(d, f)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Motor sorteado', style: Theme.of(ctx).textTheme.labelLarge),
                const SizedBox(height: 8),
                Text('$actual',
                    style: Theme.of(ctx).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Theme.of(ctx).colorScheme.primary)),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancelar'),
              ),
              if (candidatos.length > 1)
                TextButton.icon(
                  onPressed: () =>
                      setSt(() => actual = candidatos[rng.nextInt(candidatos.length)]),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Repetir'),
                ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, actual),
                child: const Text('Asignar'),
              ),
            ],
          ),
        );
      },
    );
    if (elegido == null) return;
    await ref.read(repoVerificacionesProvider).asignarMotor(
          mangaId: f.mangaId,
          equipoId: f.equipoId,
          motor: '$elegido',
        );
  }

  Future<void> _sortearRestantes(
      BuildContext context, WidgetRef ref, DatosSorteo d) async {
    final pendientes = d.filas.where((f) => f.motor == null).toList();
    final pool = [...d.disponibles]..shuffle(Random());
    if (pool.length < pendientes.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
            'Faltan motores: ${pendientes.length} equipos y solo '
            '${pool.length} motores disponibles.')),
      );
    }
    final repo = ref.read(repoVerificacionesProvider);
    final n = pendientes.length < pool.length ? pendientes.length : pool.length;
    for (var i = 0; i < n; i++) {
      await repo.asignarMotor(
        mangaId: pendientes[i].mangaId,
        equipoId: pendientes[i].equipoId,
        motor: '${pool[i]}',
      );
    }
  }

  Future<void> _quitar(WidgetRef ref, FilaSorteo f) async {
    await ref.read(repoVerificacionesProvider).quitarMotor(
          mangaId: f.mangaId,
          equipoId: f.equipoId,
        );
  }
}

class _Cabecera extends StatelessWidget {
  const _Cabecera({required this.datos});
  final DatosSorteo datos;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final min = datos.campeonato.motorSorteoMin;
    final max = datos.campeonato.motorSorteoMax;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: Card(
        color: cs.surfaceContainer,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _Pildora(
                  icono: Icons.numbers,
                  label: 'Motores $min–$max',
                  color: cs.primary),
              const SizedBox(width: 8),
              _Pildora(
                  icono: Icons.check_circle_outline,
                  label: '${datos.asignados}/${datos.filas.length} asignados',
                  color: Colors.green.shade700),
              const SizedBox(width: 8),
              _Pildora(
                  icono: Icons.inventory_2_outlined,
                  label: '${datos.disponibles.length} disponibles',
                  color: cs.secondary),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pildora extends StatelessWidget {
  const _Pildora(
      {required this.icono, required this.label, required this.color});
  final IconData icono;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 16, color: color),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }
}

class _FilaTarjeta extends StatelessWidget {
  const _FilaTarjeta({
    required this.fila,
    required this.individual,
    required this.onSortear,
    required this.onQuitar,
  });

  final FilaSorteo fila;
  final bool individual;
  final VoidCallback onSortear;
  final VoidCallback? onQuitar;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final nombre = individual ? fila.pilotoNombre : fila.equipoNombre;
    final subtitulo = individual
        ? '${fila.equipoNombre} · Copa ${fila.copa} · ${fila.mangaNombre}'
        : '${fila.pilotoNombre.isEmpty ? '' : '${fila.pilotoNombre} · '}Copa ${fila.copa} · ${fila.mangaNombre}';

    return Card(
      child: ListTile(
        title: Text(nombre.isEmpty ? '—' : nombre),
        subtitle: Text(subtitulo),
        trailing: fila.motor == null
            ? FilledButton.tonalIcon(
                onPressed: onSortear,
                icon: const Icon(Icons.casino_outlined),
                label: const Text('Sortear'),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('Nº ${fila.motor}',
                        style: TextStyle(
                            color: cs.onPrimaryContainer,
                            fontWeight: FontWeight.w800,
                            fontSize: 15)),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (op) {
                      if (op == 'resortear') onSortear();
                      if (op == 'quitar') onQuitar?.call();
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                          value: 'resortear', child: Text('Volver a sortear')),
                      PopupMenuItem(value: 'quitar', child: Text('Quitar motor')),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

class _SinRango extends StatelessWidget {
  const _SinRango({required this.campeonato});
  final Campeonato campeonato;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.settings_outlined, size: 80, color: cs.outline),
            const SizedBox(height: 16),
            Text('Falta configurar el rango de motores',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Define el rango de números de motor de organización en el '
              'campeonato para poder sortearlos.',
              textAlign: TextAlign.center,
              style: TextStyle(color: cs.outline),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Configurar campeonato'),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) =>
                    EditorCampeonato(campeonatoId: campeonato.id),
              )),
            ),
          ],
        ),
      ),
    );
  }
}

/// Vista "Números": todos los motores del rango con su estado (disponible o
/// asignado y a quién).
class _VistaNumeros extends StatelessWidget {
  const _VistaNumeros({required this.datos});
  final DatosSorteo datos;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final min = datos.campeonato.motorSorteoMin;
    final max = datos.campeonato.motorSorteoMax;
    if (min == null || max == null || max < min) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text('Rango de motores no configurado.',
              style: TextStyle(color: cs.outline)),
        ),
      );
    }
    // Motor asignado → nombre (equipo o piloto según formato).
    final porMotor = <int, String>{};
    for (final f in datos.filas) {
      if (f.motor != null) {
        porMotor[f.motor!] =
            datos.individual ? f.pilotoNombre : f.equipoNombre;
      }
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var n = min; n <= max; n++)
              _ChipMotor(numero: n, asignadoA: porMotor[n]),
          ],
        ),
      ],
    );
  }
}

class _ChipMotor extends StatelessWidget {
  const _ChipMotor({required this.numero, required this.asignadoA});
  final int numero;
  final String? asignadoA;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final asignado = asignadoA != null;
    final fondo = asignado ? cs.errorContainer : Colors.green.shade50;
    final borde = asignado ? cs.error : Colors.green.shade400;
    final texto = asignado ? cs.onErrorContainer : Colors.green.shade900;
    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borde.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: borde.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Text('$numero',
                style: TextStyle(
                    fontWeight: FontWeight.w800, color: texto, fontSize: 14)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(asignado ? 'Asignado' : 'Disponible',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: texto)),
                if (asignado)
                  Text(asignadoA!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 11, color: texto)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
