import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'almacen_local.dart';

class WordpressConfig {
  final String url;        // p.ej. https://www.resisbarna.es
  final String usuario;
  final String appPassword;

  WordpressConfig({
    required this.url,
    required this.usuario,
    required this.appPassword,
  });

  bool get listo => url.isNotEmpty && usuario.isNotEmpty && appPassword.isNotEmpty;

  Uri endpoint(String camino) {
    final base = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
    return Uri.parse('$base/wp-json/resisbarna/v1/$camino');
  }

  Map<String, String> get headers {
    final auth = base64Encode(utf8.encode('$usuario:$appPassword'));
    return {
      'Authorization': 'Basic $auth',
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json',
    };
  }
}

class WordpressService {
  WordpressService(this._storage);
  final AlmacenLocal _storage;

  static const _kUrl = 'wp_url';
  static const _kUser = 'wp_user';
  static const _kPass = 'wp_app_password';

  Future<WordpressConfig> cargar() async {
    return WordpressConfig(
      url: (await _storage.read(key: _kUrl)) ?? '',
      usuario: (await _storage.read(key: _kUser)) ?? '',
      appPassword: (await _storage.read(key: _kPass)) ?? '',
    );
  }

  Future<void> guardar(WordpressConfig cfg) async {
    await _storage.write(key: _kUrl, value: cfg.url.trim());
    await _storage.write(key: _kUser, value: cfg.usuario.trim());
    await _storage.write(key: _kPass, value: cfg.appPassword.trim());
  }

  Future<void> borrar() async {
    await _storage.delete(key: _kUrl);
    await _storage.delete(key: _kUser);
    await _storage.delete(key: _kPass);
  }

  /// GET /ping — devuelve info del sitio si la conexión + permisos son correctos.
  Future<Map<String, dynamic>> ping() async {
    final cfg = await cargar();
    if (!cfg.listo) {
      throw WordpressException('Faltan datos de configuración.');
    }
    final res = await http.get(cfg.endpoint('ping'), headers: cfg.headers);
    if (res.statusCode != 200) {
      throw WordpressException(
        'HTTP ${res.statusCode}: ${_leerError(res.body)}',
      );
    }
    return json.decode(res.body) as Map<String, dynamic>;
  }

  /// POST genérico a un endpoint del plugin.
  Future<Map<String, dynamic>> publicar(String camino, Map<String, dynamic> body) async {
    final cfg = await cargar();
    if (!cfg.listo) {
      throw WordpressException('Faltan datos de configuración.');
    }
    final res = await http.post(
      cfg.endpoint(camino),
      headers: cfg.headers,
      body: json.encode(body),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw WordpressException(
        'HTTP ${res.statusCode} en /$camino: ${_leerError(res.body)}',
      );
    }
    return json.decode(res.body) as Map<String, dynamic>;
  }

  String _leerError(String body) {
    try {
      final j = json.decode(body);
      if (j is Map && j['message'] is String) return j['message'];
    } catch (_) {}
    return body.length > 200 ? '${body.substring(0, 200)}…' : body;
  }
}

class WordpressException implements Exception {
  WordpressException(this.mensaje);
  final String mensaje;
  @override
  String toString() => mensaje;
}

final wordpressServiceProvider = Provider<WordpressService>((ref) {
  return WordpressService(ref.watch(almacenSyncProvider));
});

class EstadoWordpress {
  final bool configurado;
  final String url;
  final String usuario;
  final String? sitio; // título del sitio si está conectado
  final String? error;

  const EstadoWordpress({
    required this.configurado,
    this.url = '',
    this.usuario = '',
    this.sitio,
    this.error,
  });
}

class EstadoWordpressNotifier extends AsyncNotifier<EstadoWordpress> {
  @override
  Future<EstadoWordpress> build() async {
    final svc = ref.watch(wordpressServiceProvider);
    final cfg = await svc.cargar();
    return EstadoWordpress(
      configurado: cfg.listo,
      url: cfg.url,
      usuario: cfg.usuario,
    );
  }

  Future<void> refrescar() async {
    state = const AsyncLoading();
    state = AsyncData(await build());
  }
}

final estadoWordpressProvider =
    AsyncNotifierProvider<EstadoWordpressNotifier, EstadoWordpress>(
        EstadoWordpressNotifier.new);
