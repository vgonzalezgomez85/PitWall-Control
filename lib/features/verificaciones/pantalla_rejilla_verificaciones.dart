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

import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import '../campeonatos/selector_marcas_permitidas.dart';
import '../../services/exportar_pdf.dart';
import '../pruebas/repositorio_pruebas.dart';
import 'exportar_rejilla_verificaciones.dart';

/// Una fila de la rejilla: un equipo inscrito a la prueba, con su
/// verificación si la tiene.
class FilaRejilla {
  final Equipo equipo;

  /// Copa que corre el equipo EN esta prueba (la fijada en la verificación /
  /// inscripción); cae a la copa actual del equipo.
  final String copa;
  final String pilotos;
  final String? coche;
  final Verificacione? v;
  final double? ejeDelMax;
  final double? ejeTraMax;

  FilaRejilla({
    required this.equipo,
    required this.copa,
    required this.pilotos,
    required this.coche,
    required this.v,
    required this.ejeDelMax,
    required this.ejeTraMax,
  });
}

/// Contenido de una celda: texto y, si está fuera de reglamento, el motivo.
class CeldaRejilla {
  const CeldaRejilla(this.texto, [this.infraccion]);
  final String texto;
  final String? infraccion;
}

/// Una columna de la rejilla: cabecera, ancho y cómo se rellena.
class ColumnaRejilla {
  const ColumnaRejilla(this.titulo, this.ancho, this.celda);
  final String titulo;
  final double ancho;
  final CeldaRejilla Function(FilaRejilla f, Campeonato c) celda;
}

/// Carga las filas de la rejilla de una prueba: equipos inscritos (o con
/// verificación en alguna de sus mangas) y su verificación más reciente.
Future<List<FilaRejilla>> cargarRejilla(
  AppDatabase db,
  Campeonato? activo,
  int pruebaId,
) async {
  final mangaIds =
      (await (db.select(
            db.mangas,
          )..where((t) => t.pruebaId.equals(pruebaId))).get())
          .map((m) => m.id)
          .toList();
  final verifs = mangaIds.isEmpty
      ? <Verificacione>[]
      : await (db.select(db.verificaciones)
              ..where((t) => t.mangaId.isIn(mangaIds))
              ..orderBy([(t) => d.OrderingTerm.desc(t.fecha)]))
            .get();
  // Una verificación por equipo (la más reciente).
  final verifPorEquipo = <int, Verificacione>{};
  for (final v in verifs) {
    verifPorEquipo.putIfAbsent(v.equipoId, () => v);
  }
  final inscritos = await (db.select(
    db.inscripcionesPrueba,
  )..where((t) => t.pruebaId.equals(pruebaId))).get();
  final equipoIds = {
    ...inscritos.map((i) => i.equipoId),
    ...verifPorEquipo.keys,
  }.toList();
  if (equipoIds.isEmpty) return [];
  final copaPrueba = {
    for (final i in inscritos)
      if (i.copa != null) i.equipoId: i.copa!,
  };

  final equipos = await (db.select(
    db.equipos,
  )..where((t) => t.id.isIn(equipoIds))).get();
  final miembros =
      await (db.select(db.equipoPilotos)
            ..where((t) => t.equipoId.isIn(equipoIds))
            ..orderBy([(t) => d.OrderingTerm.asc(t.orden)]))
          .get();
  final nombrePiloto = {
    for (final p in await db.select(db.pilotos).get()) p.id: p.nombre,
  };
  final nombreCoche = {
    for (final c in await db.select(db.catalogoCoches).get()) c.id: c.nombre,
  };
  Map<String, dynamic> ejes = {};
  try {
    final raw = jsonDecode(activo?.anchuraEjeJson ?? '{}');
    if (raw is Map<String, dynamic>) ejes = raw;
  } catch (_) {}
  double? max(String copa, String lado) {
    final l = ejes[copa];
    return l is Map && l[lado] is num ? (l[lado] as num).toDouble() : null;
  }

  final out = <FilaRejilla>[];
  for (final eq in equipos) {
    var ids = miembros
        .where((m) => m.equipoId == eq.id)
        .map((m) => m.pilotoId)
        .toList();
    if (ids.isEmpty) {
      ids = [eq.piloto1Id, if (eq.piloto2Id != null) eq.piloto2Id!];
    }
    final v = verifPorEquipo[eq.id];
    final copa = copaPrueba[eq.id] ?? eq.copa;
    out.add(
      FilaRejilla(
        equipo: eq,
        copa: copa,
        pilotos: ids.map((id) => nombrePiloto[id] ?? '?').join(' + '),
        coche: v?.cocheCatalogoId == null
            ? null
            : nombreCoche[v!.cocheCatalogoId],
        v: v,
        ejeDelMax: max(copa, 'del'),
        ejeTraMax: max(copa, 'tra'),
      ),
    );
  }
  out.sort(
    (a, b) =>
        a.equipo.nombre.toLowerCase().compareTo(b.equipo.nombre.toLowerCase()),
  );
  return out;
}

/// Equipos inscritos a la prueba (o con verificación en alguna de sus
/// mangas) y su verificación. Solo lectura.
final _rejillaProvider = StreamProvider.autoDispose
    .family<List<FilaRejilla>, int>((ref, pruebaId) {
      final db = ref.watch(dbProvider);
      final activo = ref.watch(campeonatoActivoProvider);

      Future<List<FilaRejilla>> calcular() =>
          cargarRejilla(db, activo, pruebaId);

      final ctrl = StreamController<List<FilaRejilla>>();
      final subs = <StreamSubscription>[];
      void recalcular([_]) => calcular().then(
        (v) {
          if (!ctrl.isClosed) ctrl.add(v);
        },
        onError: (Object e, StackTrace s) {
          if (!ctrl.isClosed) ctrl.addError(e, s);
        },
      );
      for (final s in <Stream>[
        db.select(db.verificaciones).watch(),
        (db.select(
          db.inscripcionesPrueba,
        )..where((t) => t.pruebaId.equals(pruebaId))).watch(),
        db.select(db.equipos).watch(),
      ]) {
        subs.add(s.skip(1).listen(recalcular));
      }
      recalcular();
      ref.onDispose(() {
        for (final s in subs) {
          s.cancel();
        }
        ctrl.close();
      });
      return ctrl.stream;
    });

String _num(num? n, [String unidad = '']) {
  if (n == null) return '';
  final t = n == n.roundToDouble() ? n.toStringAsFixed(0) : '$n';
  return unidad.isEmpty ? t : '$t $unidad';
}

String _juntar(List<Object?> partes) => partes
    .where((p) => p != null && p.toString().trim().isNotEmpty)
    .join(' · ');

CeldaRejilla _marca(
  String? marca,
  Set<String> permitidas,
  List<Object?> resto,
) {
  final texto = _juntar([marca, ...resto]);
  final mala =
      marca != null &&
      marca.isNotEmpty &&
      permitidas.isNotEmpty &&
      !permitidas.contains(marca);
  return CeldaRejilla(texto, mala ? 'Marca "$marca" no permitida' : null);
}

CeldaRejilla _dientes(
  String? marca,
  int? dientes,
  String? material,
  Set<String> permitidas,
) {
  return _marca(marca, permitidas, [
    dientes == null ? null : '${dientes}d',
    material,
  ]);
}

CeldaRejilla _eje(double? medida, double? maximo) {
  if (medida == null) return const CeldaRejilla('');
  if (maximo != null && medida > maximo) {
    return CeldaRejilla(_num(medida), 'Supera el máximo de ${_num(maximo)} mm');
  }
  return CeldaRejilla(_num(medida));
}

final columnasRejilla = <ColumnaRejilla>[
  ColumnaRejilla('Estado', 96, (f, c) {
    final v = f.v;
    if (v == null) return const CeldaRejilla('Sin verificar');
    return CeldaRejilla(v.validado ? 'Validada' : 'Borrador');
  }),
  ColumnaRejilla('Copa', 110, (f, c) => CeldaRejilla(f.copa)),
  ColumnaRejilla('Coche', 170, (f, c) => CeldaRejilla(f.coche ?? '')),
  ColumnaRejilla('Peso carroc.', 96, (f, c) {
    final v = f.v;
    if (v?.pesoInicial == null) return const CeldaRejilla('');
    final min = v!.pesoMin;
    final t = _num(v.pesoInicial, 'g');
    if (min != null && v.pesoInicial! < min) {
      return CeldaRejilla(t, 'Por debajo del mínimo de ${_num(min)} g');
    }
    return CeldaRejilla(t);
  }),
  ColumnaRejilla(
    'Peso mín.',
    80,
    (f, c) => CeldaRejilla(_num(f.v?.pesoMin, 'g')),
  ),
  ColumnaRejilla('Peso coche', 120, (f, c) {
    final v = f.v;
    if (v == null) return const CeldaRejilla('');
    final ini = v.pesoInicialCoche, fin = v.pesoFinalCoche;
    if (ini == null && fin == null) return const CeldaRejilla('');
    if (fin == null || fin == ini) return CeldaRejilla(_num(ini, 'g'));
    return CeldaRejilla('${_num(ini)} / ${_num(fin)} g');
  }),
  ColumnaRejilla('Motor', 150, (f, c) {
    final v = f.v;
    if (v == null) return const CeldaRejilla('');
    if (v.motorTipo == 'PROPIO') {
      return CeldaRejilla(
        _juntar([
          'Propio',
          v.motorRpm == null ? null : '${v.motorRpm} rpm',
          v.motorUms == null ? null : '${_num(v.motorUms)} uMs',
        ]),
      );
    }
    return CeldaRejilla((v.motor ?? '').isEmpty ? '' : 'Org. nº ${v.motor}');
  }),
  ColumnaRejilla('Altura motor', 96, (f, c) {
    final ok = f.v?.alturaMotorConforme;
    if (ok == null) return const CeldaRejilla('');
    return ok
        ? const CeldaRejilla('Conforme')
        : const CeldaRejilla('Toca', 'Altura de motor no conforme');
  }),
  ColumnaRejilla(
    'Eje del.',
    72,
    (f, c) => _eje(f.v?.anchuraEjeDel, f.ejeDelMax),
  ),
  ColumnaRejilla(
    'Eje tras.',
    72,
    (f, c) => _eje(f.v?.anchuraEjeTra, f.ejeTraMax),
  ),
  ColumnaRejilla('Piñón', 150, (f, c) {
    final v = f.v;
    return _dientes(
      v?.pinonMarca,
      v?.pinonDientes,
      v?.pinonMaterial,
      marcasPermitidasDe(c.marcasPermitidasJson),
    );
  }),
  ColumnaRejilla('Corona', 150, (f, c) {
    final v = f.v;
    return _dientes(
      v?.coronaMarca,
      v?.coronaDientes,
      v?.coronaMaterial,
      marcasPermitidasDe(c.marcasPermitidasJson),
    );
  }),
  ColumnaRejilla(
    'Llanta del.',
    140,
    (f, c) => _marca(
      f.v?.llantaDelMarca,
      marcasPermitidasDe(c.marcasPermitidasJson),
      [f.v?.llantaDelDimension],
    ),
  ),
  ColumnaRejilla(
    'Llanta tras.',
    140,
    (f, c) => _marca(
      f.v?.llantaTraMarca,
      marcasPermitidasDe(c.marcasPermitidasJson),
      [f.v?.llantaTraDimension],
    ),
  ),
  ColumnaRejilla(
    'Trencilla',
    110,
    (f, c) => _marca(
      f.v?.trencilla,
      marcasPermitidasDe(c.marcasPermitidasJson),
      const [],
    ),
  ),
  ColumnaRejilla(
    'Suspensión',
    110,
    (f, c) => CeldaRejilla(f.v?.suspension ?? ''),
  ),
  ColumnaRejilla('Bancada', 120, (f, c) => CeldaRejilla(f.v?.bancada ?? '')),
  ColumnaRejilla('Chasis', 120, (f, c) => CeldaRejilla(f.v?.chasis ?? '')),
  ColumnaRejilla(
    'Neumático',
    120,
    (f, c) => CeldaRejilla(f.v?.neumatico ?? ''),
  ),
  ColumnaRejilla('Carrocería', 140, (f, c) {
    final ok = f.v?.carroceriaConforme;
    if (ok == null) return const CeldaRejilla('');
    if (ok) return const CeldaRejilla('Bien');
    final faltan = f.v?.carroceriaPiezasFaltantes?.trim() ?? '';
    return CeldaRejilla(
      faltan.isEmpty ? 'Faltan piezas' : 'Faltan: $faltan',
      'Le faltan piezas',
    );
  }),
  ColumnaRejilla(
    'Observaciones',
    260,
    (f, c) => CeldaRejilla(f.v?.observaciones ?? ''),
  ),
];

/// Si alguna celda de la fila está fuera de reglamento.
bool tieneInfraccion(FilaRejilla f, Campeonato c) =>
    f.v != null &&
    columnasRejilla.any((col) => col.celda(f, c).infraccion != null);

/// Texto de la primera columna: pilotos y, si se llama distinto, el equipo.
String nombreFilaRejilla(FilaRejilla f) => f.equipo.nombre == f.pilotos
    ? f.pilotos
    : '${f.pilotos} (${f.equipo.nombre})';

enum _Filtro { todos, conInfraccion, sinVerificar, borrador }

/// Resumen de verificaciones en rejilla (estilo hoja de cálculo, sin fotos)
/// para echar un vistazo rápido a todos los coches de una prueba. Solo
/// lectura: para cambiar algo, se abre la verificación desde la prueba.
class PantallaRejillaVerificaciones extends ConsumerStatefulWidget {
  const PantallaRejillaVerificaciones({super.key, this.pruebaId});

  /// Prueba con la que se abre (desde la propia prueba). Null = la última
  /// en curso o terminada del campeonato.
  final int? pruebaId;

  @override
  ConsumerState<PantallaRejillaVerificaciones> createState() =>
      _PantallaRejillaVerificacionesState();
}

class _PantallaRejillaVerificacionesState
    extends ConsumerState<PantallaRejillaVerificaciones> {
  int? _pruebaId;
  _Filtro _filtro = _Filtro.todos;
  String _busqueda = '';
  final _horizontal = ScrollController();
  final _horizontalCab = ScrollController();
  final _vertical = ScrollController();

  static const _anchoEquipo = 220.0;
  static const _altoFila = 34.0;

  @override
  void initState() {
    super.initState();
    _pruebaId = widget.pruebaId;
    // La cabecera va fuera del scroll vertical y sigue al cuerpo en
    // horizontal.
    _horizontal.addListener(() {
      if (_horizontalCab.hasClients) {
        _horizontalCab.jumpTo(_horizontal.offset);
      }
    });
  }

  @override
  void dispose() {
    _horizontal.dispose();
    _horizontalCab.dispose();
    _vertical.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pruebasAsync = ref.watch(pruebasCampeonatoProvider);
    final activo = ref.watch(campeonatoActivoProvider);
    final pruebas = pruebasAsync.asData?.value ?? const <Prueba>[];
    // Por defecto, la prueba más reciente que no esté programada a futuro:
    // la última en curso o terminada; si no, la primera.
    if (_pruebaId == null || !pruebas.any((p) => p.id == _pruebaId)) {
      final jugadas = pruebas.where((p) => p.estado != 'PROGRAMADA').toList();
      _pruebaId = jugadas.isNotEmpty
          ? jugadas.last.id
          : (pruebas.isEmpty ? null : pruebas.first.id);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen de verificaciones'),
        actions: [
          if (pruebas.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _pruebaId,
                  items: [
                    for (final p in pruebas)
                      DropdownMenuItem(value: p.id, child: Text(p.nombre)),
                  ],
                  onChanged: (id) => setState(() => _pruebaId = id),
                ),
              ),
            ),
          if (pruebas.any((p) => p.id == _pruebaId))
            PopupMenuButton<String>(
              tooltip: 'Exportar',
              icon: const Icon(Icons.file_download_outlined),
              onSelected: (f) =>
                  _exportar(f, pruebas.firstWhere((p) => p.id == _pruebaId)),
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: 'pdf',
                  child: ListTile(
                    leading: Icon(Icons.picture_as_pdf_outlined),
                    title: Text('Exportar a PDF'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem(
                  value: 'excel',
                  child: ListTile(
                    leading: Icon(Icons.grid_on_outlined),
                    title: Text('Exportar a Excel'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
        ],
      ),
      body: activo == null || _pruebaId == null
          ? const Center(child: Text('No hay pruebas en este campeonato.'))
          : ref
                .watch(_rejillaProvider(_pruebaId!))
                .when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                  data: (filas) => _contenido(filas, activo),
                ),
    );
  }

  /// Filas que se ven con el filtro y la búsqueda actuales (es lo que se
  /// exporta).
  List<FilaRejilla> _filtrar(List<FilaRejilla> filas, Campeonato c) =>
      filas.where((f) {
        final ok = switch (_filtro) {
          _Filtro.todos => true,
          _Filtro.conInfraccion => tieneInfraccion(f, c),
          _Filtro.sinVerificar => f.v == null,
          _Filtro.borrador => f.v != null && !f.v!.validado,
        };
        if (!ok) return false;
        if (_busqueda.isEmpty) return true;
        return '${f.equipo.nombre} ${f.pilotos} ${f.copa} ${f.coche ?? ''}'
            .toLowerCase()
            .contains(_busqueda);
      }).toList();

  Future<void> _exportar(String formato, Prueba prueba) async {
    final activo = ref.read(campeonatoActivoProvider);
    if (activo == null) return;
    final filas = _filtrar(
        await cargarRejilla(ref.read(dbProvider), activo, prueba.id), activo);
    if (!mounted) return;
    final base = 'resumen-verificaciones-${slugArchivo(prueba.nombre)}';
    if (formato == 'pdf') {
      await guardarPdf(context,
          sugerido: '$base.pdf',
          generar: () => generarPdfRejilla(
              filas: filas, campeonato: activo, prueba: prueba));
    } else {
      await guardarExcel(context,
          sugerido: '$base.xlsx',
          generar: () async => generarExcelRejilla(
              filas: filas, campeonato: activo, prueba: prueba));
    }
  }

  Widget _contenido(List<FilaRejilla> filas, Campeonato c) {
    final cs = Theme.of(context).colorScheme;
    if (filas.isEmpty) {
      return Center(
        child: Text(
          'No hay inscritos ni verificaciones en esta prueba.',
          style: TextStyle(color: cs.outline),
        ),
      );
    }
    final verificadas = filas.where((f) => f.v != null).length;
    final validadas = filas.where((f) => f.v?.validado ?? false).length;
    final conInfraccion = filas.where((f) => tieneInfraccion(f, c)).length;

    final visibles = _filtrar(filas, c);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 260,
                child: TextField(
                  decoration: const InputDecoration(
                    isDense: true,
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Buscar piloto, equipo, copa…',
                  ),
                  onChanged: (t) =>
                      setState(() => _busqueda = t.trim().toLowerCase()),
                ),
              ),
              _chip('Todos (${filas.length})', _Filtro.todos),
              _chip('Con infracción ($conInfraccion)', _Filtro.conInfraccion),
              _chip(
                'Sin verificar (${filas.length - verificadas})',
                _Filtro.sinVerificar,
              ),
              _chip('Borrador (${verificadas - validadas})', _Filtro.borrador),
              Text(
                '$validadas validadas de ${filas.length}',
                style: TextStyle(color: cs.outline),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(child: _tabla(visibles, c)),
      ],
    );
  }

  Widget _chip(String texto, _Filtro f) => ChoiceChip(
    label: Text(texto),
    selected: _filtro == f,
    onSelected: (_) => setState(() => _filtro = f),
  );

  /// Rejilla con cabecera y primera columna (piloto/equipo) fijas.
  Widget _tabla(List<FilaRejilla> filas, Campeonato c) {
    final cs = Theme.of(context).colorScheme;
    final borde = BorderSide(color: cs.outlineVariant, width: 0.5);
    final anchoResto = columnasRejilla.fold<double>(
      0,
      (s, col) => s + col.ancho,
    );
    final estiloCab = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700);
    final estilo = Theme.of(context).textTheme.bodySmall;

    Widget celda(
      String texto, {
      required double ancho,
      String? infraccion,
      Color? fondo,
      TextStyle? estiloTexto,
    }) {
      final hijo = Container(
        width: ancho,
        height: _altoFila,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: infraccion != null ? cs.errorContainer : fondo,
          border: Border(right: borde, bottom: borde),
        ),
        child: Text(
          texto,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: (estiloTexto ?? estilo)?.copyWith(
            color: infraccion != null ? cs.onErrorContainer : null,
          ),
        ),
      );
      final tip = infraccion ?? (texto.length > 18 ? texto : null);
      return tip == null ? hijo : Tooltip(message: tip, child: hijo);
    }

    Color? fondoFila(int i) =>
        i.isOdd ? cs.surfaceContainerHighest.withValues(alpha: 0.35) : null;

    final cabeceraFija = celda(
      'Piloto / equipo',
      ancho: _anchoEquipo,
      fondo: cs.surfaceContainerHigh,
      estiloTexto: estiloCab,
    );

    Widget primeraColumna(FilaRejilla f, int i) {
      return celda(
        nombreFilaRejilla(f),
        ancho: _anchoEquipo,
        fondo: fondoFila(i),
        estiloTexto: estilo?.copyWith(
          fontWeight: FontWeight.w600,
          color: f.v == null ? cs.outline : null,
        ),
      );
    }

    Widget restoFila(FilaRejilla f, int i) => Row(
      children: [
        for (final col in columnasRejilla)
          Builder(
            builder: (_) {
              final cel = col.celda(f, c);
              final esEstado = col.titulo == 'Estado';
              return celda(
                cel.texto,
                ancho: col.ancho,
                infraccion: cel.infraccion,
                fondo: fondoFila(i),
                estiloTexto: esEstado
                    ? estilo?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: f.v == null
                            ? cs.outline
                            : f.v!.validado
                            ? Colors.green.shade600
                            : Colors.orange.shade700,
                      )
                    : null,
              );
            },
          ),
      ],
    );

    if (filas.isEmpty) {
      return Center(
        child: Text(
          'Nada que mostrar con este filtro.',
          style: TextStyle(color: cs.outline),
        ),
      );
    }

    // Cabecera fija arriba y primera columna fija a la izquierda; el resto
    // se desplaza en horizontal. Ambas columnas comparten el vertical.
    final cabecera = Row(
      children: [
        cabeceraFija,
        Expanded(
          child: SingleChildScrollView(
            controller: _horizontalCab,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              children: [
                for (final col in columnasRejilla)
                  celda(
                    col.titulo,
                    ancho: col.ancho,
                    fondo: cs.surfaceContainerHigh,
                    estiloTexto: estiloCab,
                  ),
              ],
            ),
          ),
        ),
      ],
    );

    final cuerpo = Scrollbar(
      controller: _vertical,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _vertical,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                for (var i = 0; i < filas.length; i++)
                  primeraColumna(filas[i], i),
              ],
            ),
            Expanded(
              child: Scrollbar(
                controller: _horizontal,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _horizontal,
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: anchoResto,
                    child: Column(
                      children: [
                        for (var i = 0; i < filas.length; i++)
                          restoFila(filas[i], i),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Column(
      children: [
        cabecera,
        Expanded(child: cuerpo),
      ],
    );
  }
}
