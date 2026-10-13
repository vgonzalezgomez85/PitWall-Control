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
//
// Punto de entrada SOLO para las capturas del manual de la web
// (ver scripts/capturar_manual.sh): abre una copia anonimizada de la base de
// datos, en tema oscuro y en el idioma pedido, y va navegando pantalla a
// pantalla esperando a que el script haga la captura.
//
// Ejemplo:
//   flutter build macos --release --config-only -t lib/main_capturas.dart \
//     --dart-define=CAPTURAS_DIR=/tmp/capturas \
//     --dart-define=CAPTURAS_DB=/tmp/pitwall_capturas.sqlite \
//     --dart-define=CAPTURAS_IDIOMA=es
import 'dart:io';

import 'package:drift/drift.dart' hide Column;
import 'package:drift/native.dart';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/idioma.dart';
import 'core/proveedores.dart';
import 'core/tema.dart';
import 'data/database/app_database.dart';
import 'features/campeonatos/editor_campeonato.dart';
import 'features/campeonatos/pantalla_campeonatos.dart';
import 'features/clasificacion/pantalla_editor_tabla_puntos.dart';
import 'features/equipos/lista_equipos.dart';
import 'features/google/pantalla_configuracion_google.dart';
import 'features/home/app_shell.dart';
import 'features/plantillas/pantalla_plantillas_csv.dart';
import 'features/pruebas/detalle_manga.dart';
import 'features/pruebas/detalle_prueba.dart';
import 'features/pruebas/pantalla_inscritos.dart';
import 'features/sincronizacion/dispositivo_sync.dart';
import 'features/sincronizacion/fusionador_sync.dart';
import 'features/sincronizacion/pantalla_sincronizacion.dart';
import 'features/sincronizacion/proveedor_sync.dart';
import 'features/tesoreria/pantalla_tesoreria_prueba.dart';
import 'features/verificacion_libre/editor_sesion_libre.dart';
import 'features/verificaciones/editor_verificacion.dart';
import 'features/verificaciones/lista_verificaciones.dart';
import 'features/verificaciones/pantalla_rejilla_verificaciones.dart';
import 'features/verificaciones/pantalla_sorteo_motores.dart';
import 'services/almacen_local.dart';

// Variables de entorno (no dart-define: así un mismo binario sirve para los
// cinco idiomas).
String _env(String clave, String porDefecto) =>
    Platform.environment[clave] ?? porDefecto;

final _dir = _env('CAPTURAS_DIR', '/tmp/capturas');
final _dbPath = _env('CAPTURAS_DB', '/tmp/pitwall_capturas.sqlite');
final _idioma = _env('CAPTURAS_IDIOMA', 'es');

/// Captura suelta (para repetir una sola).
final _solo = _env('CAPTURAS_SOLO', '');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  // Ajustes en memoria: tema oscuro y el idioma pedido, sin credenciales de
  // Google ni nada del usuario.
  SharedPreferences.setMockInitialValues({
    'tema_oscuro': true,
    'idioma_app': _idioma,
    'sync_nombre_dispositivo': 'Mesa 1',
    'sync_clave': 'resistencia26',
  });
  final prefs = await SharedPreferences.getInstance();
  final almacen = AlmacenLocal(prefs);
  DispositivoSync.cargar(almacen);
  AppDatabase.nombreDispositivo = () => DispositivoSync.nombre;
  final db = AppDatabase.forTesting(NativeDatabase(File(_dbPath)));
  runApp(ProviderScope(
    overrides: [
      almacenSyncProvider.overrideWithValue(almacen),
      dbProvider.overrideWithValue(db),
      sincronizacionProvider.overrideWith(_SyncDemo.new),
    ],
    child: const _AppCapturas(),
  ));
}

enum _T {
  destino,
  equipos,
  editorCampeonato,
  detallePrueba,
  inscritos,
  manga,
  verificaciones,
  fichaVerificacion,
  fichaInfraccion,
  rejilla,
  sincronizacion,
  tablaPuntos,
  tesoreriaPrueba,
  sorteo,
  google,
  plantillas,
  editorSesion,
}

class _P {
  const _P(this.id, this.tipo, {this.titulo, this.scroll = 0});
  final String id;
  final _T tipo;
  final String? titulo;
  final double scroll;
}

const _pasos = <_P>[
  _P('control-01-inicio', _T.destino, titulo: 'Inicio'),
  _P('control-02-campeonatos', _T.destino, titulo: 'Gestionar campeonatos'),
  _P('control-02b-campeonato-reglas', _T.editorCampeonato, scroll: 1900),
  _P('control-03-catalogos', _T.destino, titulo: 'Catálogos'),
  _P('control-04-pilotos', _T.destino, titulo: 'Participantes'),
  _P('control-05-equipos', _T.equipos),
  _P('control-06-pruebas', _T.destino, titulo: 'Pruebas'),
  _P('control-06b-detalle-prueba', _T.detallePrueba),
  _P('control-06c-inscritos', _T.inscritos),
  _P('control-06d-manga', _T.manga),
  _P('control-07-verificaciones', _T.verificaciones),
  _P('control-07b-verificacion-ficha', _T.fichaVerificacion),
  _P('control-07c-verificacion-bloques', _T.fichaVerificacion, scroll: 760),
  _P('control-07d-verificacion-transmision', _T.fichaVerificacion, scroll: 2100),
  _P('control-07e-verificacion-infraccion', _T.fichaInfraccion, scroll: 700),
  _P('control-07f-resumen-rejilla', _T.rejilla),
  _P('control-07g-verificar-entre-varios', _T.sincronizacion),
  _P('control-08-clasificacion', _T.destino, titulo: 'Clasificación'),
  _P('control-08b-tabla-puntos', _T.tablaPuntos),
  _P('control-09-tesoreria', _T.destino, titulo: 'Tesorería'),
  _P('control-09b-tesoreria-prueba', _T.tesoreriaPrueba),
  _P('control-11-sorteo', _T.sorteo),
  _P('control-12-google', _T.google),
  _P('control-13-plantillas', _T.plantillas),
  _P('control-17-verificacion-libre', _T.destino, titulo: 'Verificación libre'),
  _P('control-17b-sesion-reglamento', _T.editorSesion),
];

class _AppCapturas extends ConsumerStatefulWidget {
  const _AppCapturas();

  @override
  ConsumerState<_AppCapturas> createState() => _AppCapturasState();
}

class _AppCapturasState extends ConsumerState<_AppCapturas> {
  final _nav = GlobalKey<NavigatorState>();
  final _boundary = GlobalKey();

  int _campeonatoId = 0;
  int _pruebaId = 0;
  int _mangaId = 0;
  int _equipoId = 0;
  int _verifOk = 0; // verificación completa (validada)
  int _verifInfraccion = 0;
  int _sesionLibrePruebaId = 0;

  @override
  Widget build(BuildContext context) {
    // La captura la hace la propia app (sin permisos de Grabación de
    // pantalla). El RepaintBoundary va POR FUERA del MaterialApp: si no, las
    // pantallas que se abren encima (rutas) quedarían fuera de la captura.
    return RepaintBoundary(
      key: _boundary,
      child: MaterialApp(
        navigatorKey: _nav,
        debugShowCheckedModeBanner: false,
        theme: TemaApp.oscuro(),
        locale: Locale(_idioma),
        supportedLocales: Textos.supportedLocales,
        localizationsDelegates: Textos.localizationsDelegates,
        home: const AppShell(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future<void>.delayed(const Duration(seconds: 3));
      await _secuencia();
    });
  }

  Future<void> _secuencia() async {
    try {
      Directory(_dir).createSync(recursive: true);
      for (final f in Directory(_dir).listSync()) {
        if (f is File) f.deleteSync();
      }
      await _resolverDatos();
      for (final paso in _pasos) {
        if (_solo.isNotEmpty && paso.id != _solo) continue;
        await _preparar(paso);
        await _capturar(paso.id);
      }
    } catch (e, st) {
      File('$_dir/error.txt').writeAsStringSync('$e\n$st');
    }
    exit(0);
  }

  /// Datos de la demo: campeonato activo, su primera prueba y tanda, y las
  /// verificaciones de ejemplo.
  Future<void> _resolverDatos() async {
    final db = ref.read(dbProvider);
    final camp = ref.read(campeonatoActivoProvider) ??
        (await (db.select(db.campeonatos)
                  ..where((t) => t.esVerificacionLibre.equals(false))
                  ..orderBy([(t) => OrderingTerm.desc(t.activo)]))
                .get())
            .first;
    _campeonatoId = camp.id;
    final pruebas = await (db.select(db.pruebas)
          ..where((t) => t.campeonatoId.equals(camp.id))
          ..orderBy([(t) => OrderingTerm.asc(t.orden)]))
        .get();
    _pruebaId = pruebas.first.id;
    final mangas = await (db.select(db.mangas)
          ..where((t) => t.pruebaId.equals(_pruebaId))
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .get();
    _mangaId = mangas.first.id;
    final inscritos = await (db.select(db.inscripciones)
          ..where((t) => t.mangaId.equals(_mangaId))
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .get();
    _equipoId = inscritos.first.equipoId;

    final verifs = await (db.select(db.verificaciones)
          ..where((t) => t.mangaId.equals(_mangaId))
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .get();
    final infraccion = verifs.where((v) =>
        v.pesoInicial != null &&
        v.pesoMin != null &&
        v.pesoInicial! < v.pesoMin!);
    _verifInfraccion = infraccion.isNotEmpty
        ? infraccion.first.id
        : (verifs.isNotEmpty ? verifs.first.id : 0);
    final ok = verifs.where((v) =>
        v.validado &&
        v.cocheCatalogoId != null &&
        v.pesoInicial != null &&
        v.pinonMarca != null);
    _verifOk = ok.isNotEmpty
        ? ok.first.id
        : (verifs.isNotEmpty ? verifs.last.id : 0);
    // Equipo de la verificación de ejemplo (no el primero de la lista).
    if (_verifOk != 0) {
      _equipoId = verifs.firstWhere((v) => v.id == _verifOk).equipoId;
    }

    // Sesión de verificación libre (si no hay, se crea una).
    final libres = await (db.select(db.campeonatos)
          ..where((t) => t.esVerificacionLibre.equals(true)))
        .get();
    if (libres.isNotEmpty) {
      final p = await (db.select(db.pruebas)
            ..where((t) => t.campeonatoId.equals(libres.first.id)))
          .get();
      _sesionLibrePruebaId = p.isNotEmpty ? p.first.id : 0;
    }
  }

  Future<void> _preparar(_P paso) async {
    final nav = _nav.currentState!;
    nav.popUntil((r) => r.isFirst);
    await _asentar(300);
    switch (paso.tipo) {
      case _T.destino:
        ref.read(shellIndiceProvider.notifier).ir(
            indiceDestinoVisible(paso.titulo!, ref.read(campeonatoActivoProvider)));
      case _T.equipos:
        nav.push(MaterialPageRoute(builder: (_) => const PantallaEquipos()));
      case _T.editorCampeonato:
        nav.push(MaterialPageRoute(
            builder: (_) => EditorCampeonato(campeonatoId: _campeonatoId)));
      case _T.detallePrueba:
        nav.push(MaterialPageRoute(
            builder: (_) => DetallePrueba(pruebaId: _pruebaId)));
      case _T.inscritos:
        nav.push(MaterialPageRoute(
            builder: (_) => PantallaInscritos(pruebaId: _pruebaId)));
      case _T.manga:
        nav.push(
            MaterialPageRoute(builder: (_) => DetalleManga(mangaId: _mangaId)));
      case _T.verificaciones:
        nav.push(MaterialPageRoute(
            builder: (_) => PantallaVerificaciones(mangaId: _mangaId)));
      case _T.fichaVerificacion:
      case _T.fichaInfraccion:
        final esInfra = paso.tipo == _T.fichaInfraccion;
        final equipo = esInfra
            ? (await _equipoDeVerificacion(_verifInfraccion))
            : _equipoId;
        nav.push(MaterialPageRoute(
            builder: (_) => EditorVerificacion(
                  mangaId: _mangaId,
                  equipoId: equipo,
                )));
      case _T.rejilla:
        nav.push(MaterialPageRoute(
            builder: (_) => PantallaRejillaVerificaciones(pruebaId: _pruebaId)));
      case _T.sincronizacion:
        nav.push(MaterialPageRoute(builder: (_) => PantallaSincronizacion(pruebaId: _pruebaId)));
      case _T.tablaPuntos:
        nav.push(
            MaterialPageRoute(builder: (_) => const PantallaEditorTablaPuntos()));
      case _T.tesoreriaPrueba:
        nav.push(MaterialPageRoute(
            builder: (_) => PantallaTesoreriaPrueba(pruebaId: _pruebaId)));
      case _T.sorteo:
        nav.push(MaterialPageRoute(
            builder: (_) => PantallaSorteoMotores(pruebaId: _pruebaId)));
      case _T.google:
        nav.push(MaterialPageRoute(
            builder: (_) => const PantallaConfiguracionGoogle()));
      case _T.plantillas:
        nav.push(
            MaterialPageRoute(builder: (_) => const PantallaPlantillasCsv()));
      case _T.editorSesion:
        nav.push(MaterialPageRoute(
            builder: (_) => EditorSesionLibre(pruebaId: _sesionLibrePruebaId)));
    }
    await _asentar();
    if (paso.scroll > 0) await _scroll(paso.scroll);
  }

  Future<int> _equipoDeVerificacion(int verificacionId) async {
    final db = ref.read(dbProvider);
    final v = await (db.select(db.verificaciones)
          ..where((t) => t.id.equals(verificacionId)))
        .getSingle();
    return v.equipoId;
  }

  /// Espera a que la pantalla esté pintada.
  Future<void> _asentar([int ms = 900]) async {
    await Future<void>.delayed(Duration(milliseconds: ms));
    await WidgetsBinding.instance.endOfFrame;
    await Future<void>.delayed(const Duration(milliseconds: 350));
  }

  /// Desplaza la lista de la pantalla abierta (sin tocar el ratón).
  Future<void> _scroll(double total) async {
    const centro = Offset(375, 190); // dentro de la ventana (750×382)
    var restante = total;
    while (restante > 0) {
      final paso = restante > 120 ? 120.0 : restante;
      GestureBinding.instance.handlePointerEvent(
          PointerScrollEvent(position: centro, scrollDelta: Offset(0, paso)));
      restante -= paso;
      await Future<void>.delayed(const Duration(milliseconds: 24));
    }
    await _asentar(700);
  }

  /// Guarda la pantalla actual como PNG (retina ×2, como las del manual).
  Future<void> _capturar(String id) async {
    final capa = _boundary.currentContext!.findRenderObject()!
        as RenderRepaintBoundary;
    final imagen = await capa.toImage(pixelRatio: 2);
    final bytes = await imagen.toByteData(format: ui.ImageByteFormat.png);
    File('$_dir/$id.png').writeAsBytesSync(bytes!.buffer.asUint8List());
  }
}

/// Estado de sincronización de demostración para la captura del wifi (no
/// arranca servidor ni descubrimiento).
class _SyncDemo extends SincronizacionNotifier {
  @override
  EstadoSync build() {
    final ahora = DateTime.now();
    final mesa2 = ResultadoFusionSync()
      ..verifNuevas = 3
      ..verifActualizadas = 1
      ..tesoreria = 2;
    return EstadoSync(
      activo: true,
      puerto: 47821,
      auto: true,
      ultimaSync: ahora,
      companeros: {
        '192.168.10.131:47821': CompaneroSync(
            host: '192.168.10.131:47821',
            nombre: 'Mesa 2',
            ultimaSync: ahora,
            resumen: mesa2),
        '192.168.10.140:47821': CompaneroSync(
            host: '192.168.10.140:47821',
            nombre: 'Tablet boxes',
            ultimaSync: ahora,
            resumen: ResultadoFusionSync()),
      },
    );
  }
}
