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

// Red de la sincronización entre Controls: servidor HTTP que sirve el
// paquete de una prueba y las fotos, y cliente para pedírselos a otro
// Control. Funciona en una wifi sin internet (router o hotspot de un móvil).
//
//   GET /sync/info                         → quién soy (sin clave)
//   GET /sync/prueba?campeonato=&prueba=…  → paquete (pitwall.sync/v1)
//   GET /sync/foto/<nombre>                → foto de verificación
//
// Todo menos /sync/info exige la cabecera `x-pitwall-clave` con la clave del
// evento, que se pone igual en todos los Controls.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:nsd/nsd.dart';

import '../../data/database/app_database.dart';
import '../../services/fotos_verificacion.dart';
import 'dispositivo_sync.dart';
import 'fusionador_sync.dart';
import 'paquete_sync.dart';

const puertoSync = 47821;
const tipoServicioSync = '_pitwall-control._tcp';
const cabeceraClaveSync = 'x-pitwall-clave';
const _appSync = 'pitwall-control';

class ServidorSync {
  ServidorSync(this.db, this.clave);
  final AppDatabase db;
  final String clave;

  HttpServer? _srv;
  Registration? _registro;

  int? get puerto => _srv?.port;

  Future<void> arrancar() async {
    try {
      _srv = await HttpServer.bind(InternetAddress.anyIPv4, puertoSync);
    } on SocketException {
      // Puerto ocupado (otro Control en el mismo equipo): uno cualquiera. Se
      // encontrará por mDNS o escribiendo la dirección a mano.
      _srv = await HttpServer.bind(InternetAddress.anyIPv4, 0);
    }
    _srv!.listen(_atender, onError: (_) {});
    try {
      _registro = await register(Service(
        name: DispositivoSync.nombre,
        type: tipoServicioSync,
        port: _srv!.port,
      ));
    } catch (_) {
      // Sin mDNS (permiso de red local…): queda el barrido y la IP manual.
    }
  }

  Future<void> parar() async {
    final r = _registro;
    _registro = null;
    if (r != null) await unregister(r).catchError((_) {});
    await _srv?.close(force: true);
    _srv = null;
  }

  Future<void> _atender(HttpRequest req) async {
    final res = req.response;
    try {
      final ruta = req.uri.path;
      final claveOk = req.headers.value(cabeceraClaveSync) == clave;
      if (ruta == '/sync/info') {
        return _json(res, {
          'app': _appSync,
          'dispositivo': DispositivoSync.nombre,
          'schemaVersion': db.schemaVersion,
          'claveOk': claveOk,
        });
      }
      if (!claveOk) {
        return _json(res, {'error': 'La clave del evento no coincide.'}, 401);
      }
      if (ruta == '/sync/prueba') {
        final q = req.uri.queryParameters;
        final pruebaId = await _pruebaLocal(
          RefSync(int.tryParse(q['campeonatoId'] ?? '') ?? 0,
              q['campeonato'] ?? ''),
          RefSync(int.tryParse(q['pruebaId'] ?? '') ?? 0, q['prueba'] ?? ''),
        );
        if (pruebaId == null) {
          return _json(
              res, {'error': 'Este Control no tiene esa prueba.'}, 404);
        }
        return _json(res, await generarPaqueteSync(db, pruebaId));
      }
      if (ruta.startsWith('/sync/foto/')) {
        final nombre = Uri.decodeComponent(ruta.substring('/sync/foto/'.length));
        // Solo nombres de archivo planos: nada de rutas.
        if (nombre.isEmpty ||
            nombre.contains('/') ||
            nombre.contains('\\') ||
            nombre.startsWith('.')) {
          return _json(res, {'error': 'Nombre no válido.'}, 400);
        }
        final f = await FotosVerificacion.resolver(nombre);
        if (!await f.exists()) {
          return _json(res, {'error': 'No tengo esa foto.'}, 404);
        }
        res.headers.contentType = ContentType('application', 'octet-stream');
        await res.addStream(f.openRead());
        await res.close();
        return;
      }
      return _json(res, {'error': 'No encontrado.'}, 404);
    } catch (e) {
      try {
        await _json(res, {'error': '$e'}, 500);
      } catch (_) {}
    }
  }

  /// La prueba de este Control que corresponde a la que pide el otro.
  Future<int?> _pruebaLocal(RefSync camp, RefSync prueba) async {
    final camps = await (db.select(db.campeonatos)
          ..where((t) => t.esVerificacionLibre.equals(false)))
        .get();
    final c = casar(camp, camps, (c) => c.id, (c) => c.nombre);
    if (c == null) return null;
    final pruebas = await (db.select(db.pruebas)
          ..where((t) => t.campeonatoId.equals(c.id)))
        .get();
    return casar(prueba, pruebas, (p) => p.id, (p) => p.nombre)?.id;
  }

  static Future<void> _json(HttpResponse res, Object cuerpo,
      [int estado = 200]) async {
    res.statusCode = estado;
    res.headers.contentType = ContentType.json;
    res.write(jsonEncode(cuerpo));
    await res.close();
  }
}

/// Lo que responde otro Control en /sync/info.
class InfoControl {
  const InfoControl(this.dispositivo, this.schemaVersion, this.claveOk);
  final String dispositivo;
  final int schemaVersion;
  final bool claveOk;
}

class ErrorSync implements Exception {
  const ErrorSync(this.mensaje);
  final String mensaje;
  @override
  String toString() => mensaje;
}

class ClienteSync {
  ClienteSync._();

  static Uri _uri(String host, String ruta, [Map<String, String>? q]) =>
      Uri.parse('http://$host$ruta').replace(queryParameters: q);

  /// null si en [host] no hay un Control.
  static Future<InfoControl?> info(String host, String clave,
      {Duration timeout = const Duration(seconds: 3)}) async {
    try {
      final r = await http.get(_uri(host, '/sync/info'),
          headers: {cabeceraClaveSync: clave}).timeout(timeout);
      if (r.statusCode != 200) return null;
      final j = jsonDecode(utf8.decode(r.bodyBytes));
      if (j is! Map || j['app'] != _appSync) return null;
      return InfoControl(j['dispositivo'] as String? ?? host,
          (j['schemaVersion'] as num?)?.toInt() ?? 0, j['claveOk'] == true);
    } catch (_) {
      return null;
    }
  }

  static Future<Map<String, dynamic>> paquete(
      String host, String clave, RefSync campeonato, RefSync prueba) async {
    final http.Response r;
    try {
      r = await http.get(
        _uri(host, '/sync/prueba', {
          'campeonatoId': '${campeonato.id}',
          'campeonato': campeonato.nombre,
          'pruebaId': '${prueba.id}',
          'prueba': prueba.nombre,
        }),
        headers: {cabeceraClaveSync: clave},
      ).timeout(const Duration(seconds: 20));
    } on TimeoutException {
      throw const ErrorSync('No responde (¿sigue en la misma wifi?).');
    } catch (_) {
      throw const ErrorSync('No se puede conectar (¿sigue en la misma wifi?).');
    }
    final cuerpo = utf8.decode(r.bodyBytes);
    if (r.statusCode != 200) {
      String msg = 'Error ${r.statusCode}';
      try {
        msg = (jsonDecode(cuerpo) as Map)['error'] as String? ?? msg;
      } catch (_) {}
      throw ErrorSync(msg);
    }
    return jsonDecode(cuerpo) as Map<String, dynamic>;
  }

  /// Trae a este dispositivo las fotos de [nombres] que aún no tenga.
  static Future<void> traerFotosQueFalten(
      String host, String clave, Iterable<String> nombres) async {
    for (final n in nombres) {
      final f = await FotosVerificacion.resolver(n);
      if (await f.exists()) continue;
      try {
        final r = await http.get(
            _uri(host, '/sync/foto/${Uri.encodeComponent(n)}'),
            headers: {cabeceraClaveSync: clave}).timeout(
            const Duration(seconds: 30));
        if (r.statusCode != 200) continue; // la traerá otro Control
        final tmp = File('${f.path}.parcial');
        await tmp.writeAsBytes(r.bodyBytes, flush: true);
        await tmp.rename(f.path);
      } catch (_) {
        // Se reintenta en la próxima sincronización.
      }
    }
  }
}
