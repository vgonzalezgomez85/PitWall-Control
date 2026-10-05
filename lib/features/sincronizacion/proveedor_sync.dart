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

// Estado de la sincronización por wifi entre Controls ("verificar entre
// varios"). Vive mientras la app esté abierta: el servidor sigue sirviendo
// aunque se cambie de pantalla, y si estaba encendido se vuelve a encender
// al abrir la app.

import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nsd/nsd.dart';

import '../../core/proveedores.dart';
import '../../services/almacen_local.dart';
import 'dispositivo_sync.dart';
import 'fusionador_sync.dart';
import 'paquete_sync.dart';
import 'servicio_sync.dart';

const _claveClave = 'sync_clave';
const _claveActivo = 'sync_activo';
const _claveAuto = 'sync_auto';
const _claveManuales = 'sync_hosts_manuales';

/// Cada cuánto se sincroniza solo, con el modo automático.
const intervaloAutoSync = Duration(seconds: 20);

/// Diferencia de hora a partir de la cual se avisa: gana el cambio más
/// reciente, así que un reloj mal puesto haría ganar cambios viejos.
const _desfaseMaximo = Duration(minutes: 2);

class CompaneroSync {
  const CompaneroSync({
    required this.host,
    required this.nombre,
    this.claveOk = true,
    this.ultimaSync,
    this.resumen,
    this.error,
  });
  final String host;
  final String nombre;
  final bool claveOk;
  final DateTime? ultimaSync;
  final String? resumen;
  final String? error;

  CompaneroSync copyWith({
    String? nombre,
    bool? claveOk,
    DateTime? ultimaSync,
    String? resumen,
    String? error,
    bool limpiarError = false,
  }) =>
      CompaneroSync(
        host: host,
        nombre: nombre ?? this.nombre,
        claveOk: claveOk ?? this.claveOk,
        ultimaSync: ultimaSync ?? this.ultimaSync,
        resumen: resumen ?? this.resumen,
        error: limpiarError ? null : (error ?? this.error),
      );
}

class EstadoSync {
  const EstadoSync({
    this.activo = false,
    this.arrancando = false,
    this.puerto,
    this.error,
    this.companeros = const {},
    this.buscando = false,
    this.sincronizando = false,
    this.auto = true,
    this.pruebaId,
    this.avisos = const [],
    this.ultimaSync,
  });
  final bool activo;
  final bool arrancando;
  final int? puerto;
  final String? error;
  /// host "ip:puerto" → otro Control encontrado.
  final Map<String, CompaneroSync> companeros;
  final bool buscando;
  final bool sincronizando;
  final bool auto;
  /// Prueba que se está verificando entre varios.
  final int? pruebaId;
  final List<String> avisos;
  final DateTime? ultimaSync;

  EstadoSync copyWith({
    bool? activo,
    bool? arrancando,
    int? puerto,
    String? error,
    bool limpiarError = false,
    Map<String, CompaneroSync>? companeros,
    bool? buscando,
    bool? sincronizando,
    bool? auto,
    int? pruebaId,
    List<String>? avisos,
    DateTime? ultimaSync,
  }) =>
      EstadoSync(
        activo: activo ?? this.activo,
        arrancando: arrancando ?? this.arrancando,
        puerto: puerto ?? this.puerto,
        error: limpiarError ? null : (error ?? this.error),
        companeros: companeros ?? this.companeros,
        buscando: buscando ?? this.buscando,
        sincronizando: sincronizando ?? this.sincronizando,
        auto: auto ?? this.auto,
        pruebaId: pruebaId ?? this.pruebaId,
        avisos: avisos ?? this.avisos,
        ultimaSync: ultimaSync ?? this.ultimaSync,
      );
}

class SincronizacionNotifier extends Notifier<EstadoSync> {
  ServidorSync? _servidor;
  Discovery? _discovery;
  Timer? _timer;
  final Set<String> _resolviendo = {};
  final Set<String> _misIps = {};

  AlmacenLocal get _almacen => ref.read(almacenSyncProvider);

  String get clave => _almacen.readSync(key: _claveClave) ?? '';

  @override
  EstadoSync build() {
    ref.onDispose(() => unawaited(_pararTodo()));
    return EstadoSync(auto: _almacen.readSync(key: _claveAuto) != '0');
  }

  /// Al abrir la app: si estaba encendida, se vuelve a encender.
  Future<void> reanudarSiEstabaActiva() async {
    if (_almacen.readSync(key: _claveActivo) == '1' && clave.isNotEmpty) {
      await activar();
    }
  }

  Future<void> guardarClave(String nueva) async {
    await _almacen.write(key: _claveClave, value: nueva.trim());
    if (state.activo) {
      // El servidor usa la clave con la que arrancó: se reinicia.
      await desactivar(recordar: false);
      await activar();
    }
  }

  Future<void> activar() async {
    if (state.activo || state.arrancando) return;
    if (clave.isEmpty) {
      state = state.copyWith(error: 'Pon una clave del evento.');
      return;
    }
    state = state.copyWith(arrancando: true, limpiarError: true);
    try {
      final srv = ServidorSync(ref.read(dbProvider), clave);
      await srv.arrancar();
      _servidor = srv;
      await _cargarMisIps();
      await _almacen.write(key: _claveActivo, value: '1');
      state = state.copyWith(
          activo: true, arrancando: false, puerto: srv.puerto);
      _timer = Timer.periodic(intervaloAutoSync, (_) => _tic());
      await buscar();
      for (final h in _hostsManuales()) {
        unawaited(_probar(h));
      }
    } catch (e) {
      state = state.copyWith(
          arrancando: false, error: 'No se pudo abrir la conexión: $e');
    }
  }

  Future<void> desactivar({bool recordar = true}) async {
    await _pararTodo();
    if (recordar) await _almacen.write(key: _claveActivo, value: '0');
    state = EstadoSync(auto: state.auto, pruebaId: state.pruebaId);
  }

  Future<void> _pararTodo() async {
    _timer?.cancel();
    _timer = null;
    final d = _discovery;
    _discovery = null;
    if (d != null) await stopDiscovery(d).catchError((_) {});
    await _servidor?.parar();
    _servidor = null;
    _resolviendo.clear();
  }

  void fijarPrueba(int pruebaId) {
    if (state.pruebaId != pruebaId) {
      state = state.copyWith(pruebaId: pruebaId, avisos: const []);
    }
  }

  Future<void> fijarAuto(bool auto) async {
    await _almacen.write(key: _claveAuto, value: auto ? '1' : '0');
    state = state.copyWith(auto: auto);
  }

  // ---------------------------------------------------------------------
  // Descubrimiento de otros Controls
  // ---------------------------------------------------------------------

  Future<void> _cargarMisIps() async {
    _misIps.clear();
    try {
      for (final i
          in await NetworkInterface.list(type: InternetAddressType.IPv4)) {
        for (final a in i.addresses) {
          _misIps.add(a.address);
        }
      }
    } catch (_) {}
    _misIps.add('127.0.0.1');
  }

  bool _soyYo(String host) {
    final i = host.lastIndexOf(':');
    final ip = host.substring(0, i);
    final puerto = int.tryParse(host.substring(i + 1));
    return _misIps.contains(ip) && puerto == state.puerto;
  }

  Future<void> buscar() async {
    if (!state.activo || state.buscando) return;
    state = state.copyWith(buscando: true);
    await _cargarMisIps();
    if (_discovery == null) {
      try {
        final d = await startDiscovery(tipoServicioSync, autoResolve: false);
        _discovery = d;
        d.addListener(_alCambiarServicios);
        _alCambiarServicios();
      } catch (_) {
        // Sin mDNS: queda el barrido de la subred.
      }
    }
    await _barrerSubred();
    if (state.activo) state = state.copyWith(buscando: false);
  }

  void _alCambiarServicios() {
    for (final s in _discovery?.services ?? const <Service>[]) {
      final clave = s.name ?? '';
      if (_resolviendo.add(clave)) unawaited(_resolver(s));
    }
  }

  Future<void> _resolver(Service s) async {
    for (var intento = 0; intento < 4; intento++) {
      if (!state.activo) return;
      try {
        final r = await resolve(s).timeout(const Duration(seconds: 5));
        final ip = await _ipDe(r);
        if (ip != null && r.port != null) {
          await _probar('$ip:${r.port}');
          return;
        }
      } catch (_) {}
      await Future<void>.delayed(Duration(milliseconds: 600 * (intento + 1)));
    }
    _resolviendo.remove(s.name ?? '');
  }

  static Future<String?> _ipDe(Service s) async {
    for (final a in s.addresses ?? const <InternetAddress>[]) {
      if (a.type == InternetAddressType.IPv4) return a.address;
    }
    final host = s.host;
    if (host == null || host.isEmpty) return null;
    if (InternetAddress.tryParse(host) != null) return host;
    try {
      final r = await InternetAddress.lookup(host,
              type: InternetAddressType.IPv4)
          .timeout(const Duration(seconds: 3));
      return r.isEmpty ? null : r.first.address;
    } catch (_) {
      return null;
    }
  }

  /// Barre la /24 de cada interfaz privada al puerto de la sync: cubre
  /// routers y móviles que filtran el multicast de mDNS.
  Future<void> _barrerSubred() async {
    final candidatos = <String>[];
    try {
      for (final i
          in await NetworkInterface.list(type: InternetAddressType.IPv4)) {
        for (final a in i.addresses) {
          final o = a.rawAddress;
          final privada = o[0] == 10 ||
              (o[0] == 192 && o[1] == 168) ||
              (o[0] == 172 && o[1] >= 16 && o[1] <= 31);
          if (!privada || a.isLoopback) continue;
          for (var h = 1; h <= 254; h++) {
            candidatos.add('${o[0]}.${o[1]}.${o[2]}.$h:$puertoSync');
          }
        }
      }
    } catch (_) {
      return;
    }
    for (var i = 0; i < candidatos.length; i += 64) {
      if (!state.activo) return;
      await Future.wait(candidatos
          .skip(i)
          .take(64)
          .where((c) => !_soyYo(c))
          .map((c) => _probar(c, timeout: const Duration(milliseconds: 900))));
    }
  }

  /// Comprueba si en [host] hay un Control y, si lo hay, lo añade.
  Future<bool> _probar(String host,
      {Duration timeout = const Duration(seconds: 3)}) async {
    if (_soyYo(host)) return false;
    final info = await ClienteSync.info(host, clave, timeout: timeout);
    if (info == null || !state.activo) return false;
    final previo = state.companeros[host];
    final c = (previo ??
            CompaneroSync(host: host, nombre: info.dispositivo))
        .copyWith(nombre: info.dispositivo, claveOk: info.claveOk);
    state = state.copyWith(companeros: {...state.companeros, host: c});
    return true;
  }

  /// Añade un Control escribiendo su dirección (IP o IP:puerto).
  Future<bool> anadirManual(String direccion) async {
    var host = direccion.trim();
    if (host.isEmpty) return false;
    if (!host.contains(':')) host = '$host:$puertoSync';
    final ok = await _probar(host);
    if (ok) {
      final l = {..._hostsManuales(), host};
      await _almacen.write(key: _claveManuales, value: l.join(','));
    }
    return ok;
  }

  Future<void> olvidar(String host) async {
    final l = _hostsManuales()..remove(host);
    await _almacen.write(key: _claveManuales, value: l.join(','));
    state = state.copyWith(
        companeros: {...state.companeros}..remove(host));
  }

  Set<String> _hostsManuales() => {
        for (final h in (_almacen.readSync(key: _claveManuales) ?? '').split(','))
          if (h.trim().isNotEmpty) h.trim(),
      };

  // ---------------------------------------------------------------------
  // Sincronizar
  // ---------------------------------------------------------------------

  void _tic() {
    if (state.auto && state.pruebaId != null && !state.sincronizando) {
      unawaited(sincronizarAhora());
    }
  }

  /// Trae de cada Control encontrado el estado de la prueba y lo fusiona.
  /// Los demás hacen lo mismo con este, así que todos acaban iguales.
  Future<void> sincronizarAhora() async {
    final pruebaId = state.pruebaId;
    if (!state.activo || pruebaId == null || state.sincronizando) return;
    state = state.copyWith(sincronizando: true);
    final db = ref.read(dbProvider);
    final avisos = <String>[];
    try {
      final prueba = await (db.select(db.pruebas)
            ..where((t) => t.id.equals(pruebaId)))
          .getSingleOrNull();
      if (prueba == null) return;
      final camp = await (db.select(db.campeonatos)
            ..where((t) => t.id.equals(prueba.campeonatoId)))
          .getSingle();
      final refCamp = RefSync(camp.id, camp.nombre);
      final refPrueba = RefSync(prueba.id, prueba.nombre);

      for (final host in state.companeros.keys.toList()) {
        if (!state.activo || state.pruebaId != pruebaId) return;
        final c = state.companeros[host];
        if (c == null) continue;
        CompaneroSync nuevo;
        try {
          final paquete =
              await ClienteSync.paquete(host, clave, refCamp, refPrueba);
          final ahoraOtro = (paquete['ahoraMs'] as num?)?.toInt();
          if (ahoraOtro != null) {
            final desfase = Duration(
                milliseconds: (ahoraOtro - ahoraMsSync()).abs());
            if (desfase > _desfaseMaximo) {
              avisos.add('La hora de ${c.nombre} difiere ${desfase.inMinutes} '
                  'min de la de este dispositivo. Poned todos la hora '
                  'automática: si no, un cambio viejo puede pisar a uno nuevo.');
            }
          }
          final r = await FusionadorSync(db).fusionar(pruebaId, paquete);
          avisos.addAll(r.avisos.map((a) => '${c.nombre}: $a'));
          await ClienteSync.traerFotosQueFalten(host, clave, r.fotos);
          nuevo = c.copyWith(
              claveOk: true,
              ultimaSync: DateTime.now(),
              resumen: r.resumen(),
              limpiarError: true);
        } on ErrorSync catch (e) {
          nuevo = c.copyWith(error: e.mensaje);
        } on FormatException catch (e) {
          nuevo = c.copyWith(error: e.message);
        } catch (e) {
          nuevo = c.copyWith(error: '$e');
        }
        state = state.copyWith(companeros: {...state.companeros, host: nuevo});
      }
      state = state.copyWith(
          avisos: avisos.toSet().toList(), ultimaSync: DateTime.now());
    } finally {
      state = state.copyWith(sincronizando: false);
    }
  }
}

final sincronizacionProvider =
    NotifierProvider<SincronizacionNotifier, EstadoSync>(
        SincronizacionNotifier.new);
