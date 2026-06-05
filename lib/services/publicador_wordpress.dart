import 'package:drift/drift.dart' hide Column;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../core/proveedores.dart';
import '../features/clasificacion/repositorio_clasificacion.dart';
import 'wordpress_service.dart';

/// Resultado de una publicación: mensajes por paso ejecutado.
class ResultadoPublicacion {
  final List<String> pasos = [];
  bool ok = true;
  String? error;
}

/// Servicio que coge los datos actuales del campeonato y los publica
/// en WordPress en orden: clasificación, pruebas, pilotos, equipos.
class PublicadorWordpress {
  PublicadorWordpress(this.ref);
  final Ref ref;

  Future<ResultadoPublicacion> publicarTodo() async {
    final res = ResultadoPublicacion();
    final activo = ref.read(campeonatoActivoProvider);
    if (activo == null) {
      res.ok = false;
      res.error = 'No hay campeonato activo.';
      return res;
    }
    final wp = ref.read(wordpressServiceProvider);
    final slug = _slug(activo.nombre);

    try {
      // 1) Clasificación
      final datos = await _esperarDatos(ref.read(clasificacionProvider.future));
      final pruebas = datos.pruebas
          .map((p) => {
                'id': p.id.toString(),
                'nombre': p.nombre,
                'orden': p.orden,
              })
          .toList();
      final filas = datos.filas
          .map((f) => {
                'piloto_id': f.pilotoId.toString(),
                'piloto_nombre': f.pilotoNombre,
                'equipo_nombre': f.equipoNombre,
                'copa': f.copa,
                'categoria': f.categoria,
                'posicion': f.posicion ?? 0,
                'total_bruto': f.totalBruto,
                'total_descarte': f.totalDescarte,
                'total_neto': f.totalNeto,
                'creditos_actuales': f.creditosActuales,
                'puntos_por_prueba':
                    f.puntosPorPrueba.map((k, v) => MapEntry(k.toString(), v)),
                'descartes': f.pruebasDescartadas.map((e) => e.toString()).toList(),
              })
          .toList();
      final r1 = await wp.publicar('clasificacion', {
        'campeonato': {'slug': slug, 'nombre': activo.nombre},
        'pruebas': pruebas,
        'filas': filas,
      });
      res.pasos.add('✓ Clasificación: ${r1['filas']} pilotos publicados.');

      // 2) Pruebas como CPT (con resultados embebidos por prueba)
      final db = ref.read(dbProvider);
      final pruebasBd = await (db.select(db.pruebas)
            ..where((t) => t.campeonatoId.equals(activo.id)))
          .get();
      if (pruebasBd.isNotEmpty) {
        final items = <Map<String, dynamic>>[];
        final fmt = DateFormat('yyyy-MM-dd');
        for (final p in pruebasBd) {
          final mangas = await (db.select(db.mangas)
                ..where((t) => t.pruebaId.equals(p.id)))
              .get();
          final mangaIds = mangas.map((m) => m.id).toSet();
          final resultados = <Map<String, dynamic>>[];
          for (final m in mangas) {
            final inscritos = await (db.select(db.inscripciones)
                  ..where((t) => t.mangaId.equals(m.id)))
                .get();
            for (final ins in inscritos) {
              final eq = await (db.select(db.equipos)
                    ..where((t) => t.id.equals(ins.equipoId)))
                  .getSingle();
              final r = await (db.select(db.resultados)
                    ..where((t) =>
                        t.mangaId.equals(m.id) &
                        t.pilotoId.equals(eq.piloto1Id)))
                  .getSingleOrNull();
              final p1 = await (db.select(db.pilotos)
                    ..where((t) => t.id.equals(eq.piloto1Id)))
                  .getSingle();
              String pilotos = p1.nombre;
              if (eq.piloto2Id != null) {
                final pid2 = eq.piloto2Id!;
                final p2 = await (db.select(db.pilotos)
                      ..where((t) => t.id.equals(pid2)))
                    .getSingle();
                pilotos = '${p1.nombre} + ${p2.nombre}';
              }
              if (r != null) {
                resultados.add({
                  'posicion': r.posicion ?? 0,
                  'equipo': eq.nombre,
                  'pilotos': pilotos,
                  'copa': eq.copa,
                  'puntos': r.puntos,
                  'manga': m.nombre,
                });
              }
            }
          }
          resultados.sort((a, b) =>
              (a['posicion'] as int).compareTo(b['posicion'] as int));
          items.add({
            'uid': 'prueba-${activo.id}-${p.id}',
            'nombre': p.nombre,
            'sede': p.sede ?? '',
            'fecha': p.fecha == null ? '' : fmt.format(p.fecha!),
            'orden': p.orden,
            'estado': p.estado,
            'campeonato_slug': slug,
            'resultados': resultados,
          });
          // Marcador de uso para mangaIds (evitar warning si no se usa)
          if (mangaIds.isEmpty) {}
        }
        final r2 = await wp.publicar('pruebas', {'items': items});
        res.pasos.add('✓ Pruebas: ${r2['pruebas']} publicadas.');
      }

      // 3) Pilotos
      final perfiles = await (db.select(db.pilotoCampeonato)
            ..where((t) => t.campeonatoId.equals(activo.id)))
          .get();
      final pilotosItems = <Map<String, dynamic>>[];
      for (final pf in perfiles) {
        final p = await (db.select(db.pilotos)
              ..where((t) => t.id.equals(pf.pilotoId)))
            .getSingle();
        pilotosItems.add({
          'uid': 'piloto-${activo.id}-${p.id}',
          'nombre': p.nombre,
          'categoria': pf.categoria,
          'creditos': pf.creditosActuales,
          'email': p.email ?? '',
          'telefono': p.telefono ?? '',
          'palmares': pf.palmaresLocal ?? p.palmaresGlobal ?? '',
          'campeonato_slug': slug,
        });
      }
      if (pilotosItems.isNotEmpty) {
        final r3 = await wp.publicar('pilotos', {'items': pilotosItems});
        res.pasos.add('✓ Pilotos: ${r3['pilotos']} publicados.');
      }

      // 4) Equipos
      final equipos = await (db.select(db.equipos)
            ..where((t) => t.campeonatoId.equals(activo.id)))
          .get();
      if (equipos.isNotEmpty) {
        final items = <Map<String, dynamic>>[];
        for (final e in equipos) {
          final p1 = await (db.select(db.pilotos)
                ..where((t) => t.id.equals(e.piloto1Id)))
              .getSingle();
          String? p2;
          if (e.piloto2Id != null) {
            final pid2 = e.piloto2Id!;
            final p2obj = await (db.select(db.pilotos)
                  ..where((t) => t.id.equals(pid2)))
                .getSingle();
            p2 = p2obj.nombre;
          }
          items.add({
            'uid': 'equipo-${activo.id}-${e.id}',
            'nombre': e.nombre,
            'copa': e.copa,
            'piloto1': p1.nombre,
            'piloto2': p2 ?? '',
            'campeonato_slug': slug,
          });
        }
        final r4 = await wp.publicar('equipos', {'items': items});
        res.pasos.add('✓ Equipos: ${r4['equipos']} publicados.');
      }
    } catch (e) {
      res.ok = false;
      res.error = e.toString();
    }
    return res;
  }

  static String _slug(String s) {
    final base = s
        .toLowerCase()
        .replaceAll(RegExp(r'[áàä]'), 'a')
        .replaceAll(RegExp(r'[éèë]'), 'e')
        .replaceAll(RegExp(r'[íìï]'), 'i')
        .replaceAll(RegExp(r'[óòö]'), 'o')
        .replaceAll(RegExp(r'[úùü]'), 'u')
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    return base.isEmpty ? 'campeonato' : base;
  }

  /// Lee una vez del provider stream (toma el primer valor disponible).
  Future<DatosClasificacion> _esperarDatos(Future<DatosClasificacion> f) => f;
}

final publicadorProvider = Provider<PublicadorWordpress>((ref) {
  return PublicadorWordpress(ref);
});
