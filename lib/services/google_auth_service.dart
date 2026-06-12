import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'almacen_local.dart';

/// Scopes:
/// - sheets.readonly: leer hojas vinculadas
/// - drive.readonly: listar las hojas del usuario
/// - drive.file: leer/escribir archivos creados por la app (backup BD)
const List<String> _scopesGoogle = [
  'https://www.googleapis.com/auth/spreadsheets.readonly',
  'https://www.googleapis.com/auth/drive.readonly',
  'https://www.googleapis.com/auth/drive.file',
];

/// Maneja la autenticación OAuth con Google + persistencia de tokens.
class GoogleAuthService {
  GoogleAuthService(this._storage);
  final AlmacenLocal _storage;

  static const _kClientId = 'google_client_id';
  static const _kClientSecret = 'google_client_secret';
  static const _kAccessToken = 'google_access_token';
  static const _kRefreshToken = 'google_refresh_token';
  static const _kExpiry = 'google_token_expiry';
  static const _kAccountEmail = 'google_account_email';

  // ----- Credenciales del proyecto Google Cloud -----

  Future<String?> obtenerClientId() => _storage.read(key: _kClientId);
  Future<String?> obtenerClientSecret() => _storage.read(key: _kClientSecret);

  Future<void> guardarCredencialesProyecto({
    required String clientId,
    required String clientSecret,
  }) async {
    await _storage.write(key: _kClientId, value: clientId);
    await _storage.write(key: _kClientSecret, value: clientSecret);
  }

  // ----- Estado de la sesión -----

  Future<bool> estaConectado() async {
    final at = await _storage.read(key: _kAccessToken);
    final rt = await _storage.read(key: _kRefreshToken);
    return at != null || rt != null;
  }

  Future<String?> obtenerEmailConectado() =>
      _storage.read(key: _kAccountEmail);

  Future<void> desconectar() async {
    await _storage.delete(key: _kAccessToken);
    await _storage.delete(key: _kRefreshToken);
    await _storage.delete(key: _kExpiry);
    await _storage.delete(key: _kAccountEmail);
  }

  // ----- Autorización -----

  /// Lanza el flujo OAuth: abre el navegador y espera la redirección al
  /// servidor loopback local. Al terminar guarda los tokens.
  Future<AccessCredentials> autorizar({
    void Function(String url)? alAbrirUrl,
  }) async {
    final clientId = await obtenerClientId();
    final clientSecret = await obtenerClientSecret();
    if (clientId == null || clientSecret == null) {
      throw GoogleAuthException(
        'Faltan las credenciales del proyecto Google Cloud. '
        'Ve a Configuración → Google y pega el Client ID y el Client Secret.',
      );
    }

    final id = ClientId(clientId, clientSecret);
    final creds = await obtainAccessCredentialsViaUserConsent(
      id,
      _scopesGoogle,
      _httpClient(),
      (String url) async {
        alAbrirUrl?.call(url);
        final uri = Uri.parse(url);
        if (!await launchUrl(uri,
            mode: LaunchMode.externalApplication)) {
          throw GoogleAuthException(
              'No se pudo abrir el navegador para autorizar.');
        }
      },
    );

    await _persistirCredenciales(creds);
    await _intentarGuardarEmail(creds);
    return creds;
  }

  /// Devuelve un cliente HTTP autenticado, refrescando el token si hace falta.
  ///
  /// Si el refresh token ha caducado o fue revocado (`invalid_grant`), limpia
  /// la sesión guardada y lanza un error claro pidiendo reconectar.
  Future<AuthClient> clienteAutenticado() async {
    final clientId = await obtenerClientId();
    final clientSecret = await obtenerClientSecret();
    if (clientId == null || clientSecret == null) {
      throw GoogleAuthException('Configura primero las credenciales de Google Cloud.');
    }

    var creds = await _cargarCredenciales();
    if (creds == null) {
      throw GoogleAuthException('No estás conectado con Google.');
    }
    final id = ClientId(clientId, clientSecret);

    // Refrescar aquí (y no perezosamente) para poder capturar un token
    // caducado/revocado y convertirlo en un mensaje accionable.
    final caducado = creds.accessToken.expiry
        .isBefore(DateTime.now().toUtc().add(const Duration(minutes: 1)));
    if (caducado) {
      if (creds.refreshToken == null) {
        await desconectar();
        throw GoogleAuthException(
            'La sesión de Google ha caducado. Vuelve a conectar tu cuenta '
            'en Google Sheets (menú lateral).');
      }
      try {
        creds = await refreshCredentials(id, creds, _httpClient());
        await _persistirCredenciales(creds);
      } catch (e) {
        if (e.toString().contains('invalid_grant')) {
          await desconectar();
          throw GoogleAuthException(
              'La conexión con Google ha caducado o fue revocada. '
              'Ve a Google Sheets (menú lateral) y pulsa "Conectar con '
              'Google" para autorizar de nuevo.');
        }
        rethrow;
      }
    }
    return autoRefreshingClient(id, creds, _httpClient());
  }

  // ----- Helpers de persistencia -----

  Future<void> _persistirCredenciales(AccessCredentials c) async {
    await _storage.write(key: _kAccessToken, value: c.accessToken.data);
    await _storage.write(
        key: _kExpiry, value: c.accessToken.expiry.toUtc().toIso8601String());
    if (c.refreshToken != null) {
      await _storage.write(key: _kRefreshToken, value: c.refreshToken);
    }
  }

  Future<AccessCredentials?> _cargarCredenciales() async {
    final at = await _storage.read(key: _kAccessToken);
    final exp = await _storage.read(key: _kExpiry);
    final rt = await _storage.read(key: _kRefreshToken);
    if (at == null || exp == null) return null;
    return AccessCredentials(
      AccessToken('Bearer', at, DateTime.parse(exp)),
      rt,
      _scopesGoogle,
    );
  }

  Future<void> _intentarGuardarEmail(AccessCredentials c) async {
    try {
      final cli = autoRefreshingClient(
        ClientId(
          (await obtenerClientId())!,
          (await obtenerClientSecret())!,
        ),
        c,
        _httpClient(),
      );
      final res = await cli.get(
          Uri.parse('https://www.googleapis.com/oauth2/v2/userinfo'));
      if (res.statusCode == 200) {
        final data = json.decode(res.body) as Map<String, dynamic>;
        final email = data['email'] as String?;
        if (email != null) {
          await _storage.write(key: _kAccountEmail, value: email);
        }
      }
      cli.close();
    } catch (_) {
      // Ignorar — email es informativo.
    }
  }

  // Cliente HTTP simple (separado para poder mockear si quisiéramos)
  _HttpClientWrapper _httpClient() => _HttpClientWrapper();
}

/// Cliente HTTP plano que añade un único User-Agent sano.
class _HttpClientWrapper extends http.BaseClient {
  final _inner = http.Client();
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['User-Agent'] = 'Resisbarna/1.0';
    return _inner.send(request);
  }

  @override
  void close() => _inner.close();
}

class GoogleAuthException implements Exception {
  GoogleAuthException(this.mensaje);
  final String mensaje;
  @override
  String toString() => mensaje;
}

// ---- Providers Riverpod ----

final googleAuthServiceProvider = Provider<GoogleAuthService>((ref) {
  return GoogleAuthService(ref.watch(almacenSyncProvider));
});

/// Notifica cambios en el estado de conexión (conectado/email).
class EstadoGoogle {
  final bool conectado;
  final String? email;
  final bool credencialesListas;

  const EstadoGoogle({
    required this.conectado,
    this.email,
    required this.credencialesListas,
  });
}

class EstadoGoogleNotifier extends AsyncNotifier<EstadoGoogle> {
  @override
  Future<EstadoGoogle> build() async {
    final s = ref.watch(googleAuthServiceProvider);
    final id = await s.obtenerClientId();
    final sec = await s.obtenerClientSecret();
    final con = await s.estaConectado();
    final mail = await s.obtenerEmailConectado();
    return EstadoGoogle(
      conectado: con,
      email: mail,
      credencialesListas: id != null && sec != null,
    );
  }

  Future<void> refrescar() async {
    state = const AsyncLoading();
    state = AsyncData(await build());
  }
}

final estadoGoogleProvider =
    AsyncNotifierProvider<EstadoGoogleNotifier, EstadoGoogle>(
        EstadoGoogleNotifier.new);
