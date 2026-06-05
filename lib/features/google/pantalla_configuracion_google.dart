import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/google_auth_service.dart';
import 'pantalla_backup.dart';

class PantallaConfiguracionGoogle extends ConsumerStatefulWidget {
  const PantallaConfiguracionGoogle({super.key});

  @override
  ConsumerState<PantallaConfiguracionGoogle> createState() =>
      _PantallaConfiguracionGoogleState();
}

class _PantallaConfiguracionGoogleState
    extends ConsumerState<PantallaConfiguracionGoogle> {
  final _clientId = TextEditingController();
  final _clientSecret = TextEditingController();
  bool _cargando = true;
  bool _guardando = false;
  bool _conectando = false;
  bool _mostrarSecret = false;
  String? _ultimoError;
  String? _ultimoExito;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final s = ref.read(googleAuthServiceProvider);
    _clientId.text = (await s.obtenerClientId()) ?? '';
    _clientSecret.text = (await s.obtenerClientSecret()) ?? '';
    if (mounted) setState(() => _cargando = false);
  }

  @override
  void dispose() {
    _clientId.dispose();
    _clientSecret.dispose();
    super.dispose();
  }

  Future<void> _guardarCredenciales() async {
    final id = _clientId.text.trim();
    final sec = _clientSecret.text.trim();
    if (id.isEmpty || sec.isEmpty) {
      setState(() {
        _ultimoError = 'Pega el Client ID y el Client Secret antes de guardar.';
        _ultimoExito = null;
      });
      return;
    }
    if (!id.endsWith('.apps.googleusercontent.com')) {
      setState(() {
        _ultimoError =
            'El Client ID no parece válido (debe acabar en ".apps.googleusercontent.com"). '
            'Revisa que lo hayas copiado entero de Google Cloud Console.';
        _ultimoExito = null;
      });
      return;
    }
    setState(() {
      _guardando = true;
      _ultimoError = null;
      _ultimoExito = null;
    });
    await ref.read(googleAuthServiceProvider).guardarCredencialesProyecto(
          clientId: id,
          clientSecret: sec,
        );
    await ref.read(estadoGoogleProvider.notifier).refrescar();
    if (mounted) {
      setState(() {
        _guardando = false;
        _ultimoExito = 'Credenciales guardadas. Ahora pulsa "Conectar con Google".';
      });
    }
  }

  Future<void> _conectar() async {
    setState(() {
      _conectando = true;
      _ultimoError = null;
      _ultimoExito = null;
    });
    try {
      await ref.read(googleAuthServiceProvider).autorizar(
            alAbrirUrl: (url) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Abriendo el navegador… autoriza y vuelve aquí.'),
                  duration: Duration(seconds: 4),
                ),
              );
            },
          );
      await ref.read(estadoGoogleProvider.notifier).refrescar();
      if (mounted) {
        setState(() {
          _ultimoExito = 'Conectado correctamente con Google.';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _ultimoError = e.toString();
        });
      }
    } finally {
      if (mounted) setState(() => _conectando = false);
    }
  }

  Future<void> _desconectar() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Desconectar Google'),
        content: const Text(
            'La app dejará de leer tus hojas hasta que vuelvas a conectarte. '
            '¿Continuar?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Desconectar')),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(googleAuthServiceProvider).desconectar();
    await ref.read(estadoGoogleProvider.notifier).refrescar();
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final cs = Theme.of(context).colorScheme;
    final estadoAsync = ref.watch(estadoGoogleProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Google Sheets')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          estadoAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (e, _) => Text('Error: $e'),
            data: (e) => _TarjetaEstado(
              estado: e,
              onConectar: _conectar,
              onDesconectar: _desconectar,
              conectando: _conectando,
            ),
          ),
          const SizedBox(height: 24),
          Text('Credenciales del proyecto Google Cloud',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Estas credenciales se crean una sola vez en tu cuenta de Google Cloud. '
            'Pulsa "Cómo conseguirlas" para una guía paso a paso.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const _GuiaGoogleCloud())),
            icon: const Icon(Icons.help_outline),
            label: const Text('Cómo conseguirlas'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _clientId,
            decoration: const InputDecoration(
              labelText: 'Client ID',
              hintText: '123456789-abc...apps.googleusercontent.com',
              prefixIcon: Icon(Icons.fingerprint),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _clientSecret,
            obscureText: !_mostrarSecret,
            decoration: InputDecoration(
              labelText: 'Client Secret',
              prefixIcon: const Icon(Icons.key_outlined),
              suffixIcon: IconButton(
                icon: Icon(_mostrarSecret
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined),
                onPressed: () => setState(() => _mostrarSecret = !_mostrarSecret),
              ),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _guardando ? null : _guardarCredenciales,
            icon: _guardando
                ? const SizedBox(
                    width: 18, height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.save_outlined),
            label: const Text('Guardar credenciales'),
          ),
          if (_ultimoExito != null) ...[
            const SizedBox(height: 12),
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline,
                        color: Colors.green.shade700),
                    const SizedBox(width: 8),
                    Expanded(child: Text(_ultimoExito!)),
                  ],
                ),
              ),
            ),
          ],
          if (_ultimoError != null) ...[
            const SizedBox(height: 12),
            _CardError(mensaje: _ultimoError!),
          ],
          const SizedBox(height: 16),
          Card(
            color: cs.surfaceContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: cs.primary),
                      const SizedBox(width: 8),
                      Text('Permisos solicitados',
                          style: Theme.of(context).textTheme.titleSmall),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• Leer tus hojas de cálculo (Google Sheets — solo lectura)\n'
                    '• Listar archivos de Drive (Google Drive — solo lectura)\n'
                    '• Crear y modificar el archivo de copia de la app (Drive — solo el archivo de la app)\n\n'
                    'Resisbarna no toca ningún archivo tuyo, solo el que crea ella.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: Icon(Icons.cloud_sync_outlined, color: cs.primary),
              title: const Text('Copia compartida en Drive'),
              subtitle: const Text(
                  'Subir o descargar la base de datos para trabajar entre varios dispositivos.'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PantallaBackup()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaEstado extends StatelessWidget {
  const _TarjetaEstado({
    required this.estado,
    required this.onConectar,
    required this.onDesconectar,
    required this.conectando,
  });

  final EstadoGoogle estado;
  final VoidCallback onConectar;
  final VoidCallback onDesconectar;
  final bool conectando;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final conectado = estado.conectado;
    return Card(
      color: conectado ? cs.primaryContainer : cs.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  conectado ? Icons.cloud_done_outlined : Icons.cloud_off_outlined,
                  size: 32,
                  color: conectado ? cs.onPrimaryContainer : cs.outline,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        conectado ? 'Conectado con Google' : 'Sin conectar',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: conectado
                                  ? cs.onPrimaryContainer
                                  : cs.onSurface,
                            ),
                      ),
                      if (estado.email != null)
                        Text(estado.email!,
                            style: TextStyle(color: cs.onPrimaryContainer)),
                      if (!estado.credencialesListas)
                        Text(
                          'Faltan credenciales del proyecto Google Cloud',
                          style: TextStyle(color: cs.error, fontSize: 13),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (!conectado)
                  FilledButton.icon(
                    onPressed: (conectando || !estado.credencialesListas)
                        ? null
                        : onConectar,
                    icon: conectando
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.login),
                    label: const Text('Conectar con Google'),
                  )
                else
                  OutlinedButton.icon(
                    onPressed: onDesconectar,
                    icon: const Icon(Icons.logout),
                    label: const Text('Desconectar'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GuiaGoogleCloud extends StatelessWidget {
  const _GuiaGoogleCloud();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conseguir credenciales')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Una sola vez tienes que crear unas credenciales gratuitas en Google Cloud. '
            'Sigue estos pasos:',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          _Paso(
            n: 1,
            titulo: 'Crear un proyecto',
            cuerpo:
                'Entra en console.cloud.google.com con tu cuenta de Google '
                '(la misma que tendrá las hojas). Crea un proyecto nuevo, '
                'por ejemplo "Resisbarna".',
            urlAccion: 'https://console.cloud.google.com/projectcreate',
            textoAccion: 'Abrir Cloud Console',
          ),
          _Paso(
            n: 2,
            titulo: 'Activar las API de Sheets y Drive',
            cuerpo:
                'En el buscador de Google Cloud Console busca "Google Sheets API" '
                'y pulsa "Habilitar". Repite con "Google Drive API".',
            urlAccion:
                'https://console.cloud.google.com/apis/library/sheets.googleapis.com',
            textoAccion: 'API Sheets',
          ),
          _Paso(
            n: 3,
            titulo: 'Pantalla de consentimiento',
            cuerpo:
                'Ve a "APIs y servicios → Pantalla de consentimiento OAuth". '
                'Elige tipo "Externo", pon nombre "Resisbarna", tu email de soporte '
                'y guarda. En "Audiencia" añade tu propio email como usuario de prueba.',
            urlAccion:
                'https://console.cloud.google.com/apis/credentials/consent',
            textoAccion: 'Pantalla consentimiento',
          ),
          _Paso(
            n: 4,
            titulo: 'Crear credenciales OAuth de escritorio',
            cuerpo:
                'Ve a "APIs y servicios → Credenciales → Crear credenciales → '
                'ID de cliente de OAuth". Tipo: "Aplicación de escritorio". '
                'Nombre: "Resisbarna Desktop". Acepta.',
            urlAccion: 'https://console.cloud.google.com/apis/credentials',
            textoAccion: 'Credenciales',
          ),
          _Paso(
            n: 5,
            titulo: 'Copiar Client ID y Client Secret',
            cuerpo:
                'Aparece un cuadro con el Client ID (termina en .apps.googleusercontent.com) '
                'y el Client Secret. Cópialos y pégalos en la pantalla anterior. '
                '¡Listo! Pulsa "Conectar con Google".',
          ),
        ],
      ),
    );
  }
}

class _Paso extends StatelessWidget {
  const _Paso({
    required this.n,
    required this.titulo,
    required this.cuerpo,
    this.urlAccion,
    this.textoAccion,
  });

  final int n;
  final String titulo;
  final String cuerpo;
  final String? urlAccion;
  final String? textoAccion;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: cs.primary,
                  child: Text('$n',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(titulo,
                      style: Theme.of(context).textTheme.titleMedium),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(cuerpo),
            if (urlAccion != null && textoAccion != null) ...[
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => launchUrl(Uri.parse(urlAccion!),
                    mode: LaunchMode.externalApplication),
                icon: const Icon(Icons.open_in_new, size: 16),
                label: Text(textoAccion!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Tarjeta que muestra el error tal cual + pistas inteligentes según patrones
/// que se ven habitualmente en el flujo OAuth.
class _CardError extends StatelessWidget {
  const _CardError({required this.mensaje});
  final String mensaje;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final pistas = _diagnosticar(mensaje);
    return Card(
      color: cs.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.error_outline, color: cs.onErrorContainer),
                const SizedBox(width: 8),
                Text('No se pudo conectar',
                    style: TextStyle(
                        color: cs.onErrorContainer,
                        fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 8),
            SelectableText(mensaje,
                style: TextStyle(color: cs.onErrorContainer)),
            if (pistas.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text('Cosas que suelen fallar:',
                  style: TextStyle(
                      color: cs.onErrorContainer,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              ...pistas.map((p) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.lightbulb_outline,
                            size: 16, color: cs.onErrorContainer),
                        const SizedBox(width: 6),
                        Expanded(
                            child: Text(p,
                                style: TextStyle(
                                    color: cs.onErrorContainer))),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  static List<String> _diagnosticar(String m) {
    final out = <String>[];
    final low = m.toLowerCase();

    if (low.contains('access_denied') ||
        low.contains('has not completed') ||
        low.contains('verification process') ||
        low.contains('app blocked')) {
      out.add(
          'Estás en modo "Testing" de la pantalla de consentimiento OAuth y tu email NO está añadido como "Usuario de prueba". En Google Cloud Console → APIs y servicios → Pantalla de consentimiento → Audiencia → "Añadir usuarios" → pon tu email.');
    }
    if (low.contains('redirect_uri_mismatch') ||
        low.contains('redirect uri mismatch')) {
      out.add(
          'El tipo de credencial no es "Aplicación de escritorio". Crea de nuevo las credenciales OAuth en Google Cloud Console eligiendo "Aplicación de escritorio".');
    }
    if (low.contains('invalid_client') || low.contains('unauthorized')) {
      out.add(
          'Client ID o Client Secret incorrectos. Vuelve a copiarlos de Google Cloud Console (Credenciales → tu cliente OAuth) y pégalos sin espacios.');
    }
    if (low.contains('not enabled') ||
        low.contains('api has not been used')) {
      out.add(
          'Las APIs de Google Sheets y/o Drive no están activadas en tu proyecto. Ve a "APIs y servicios → Biblioteca", busca "Google Sheets API" y "Google Drive API" y pulsa Habilitar.');
    }
    if (low.contains('no se pudo abrir el navegador')) {
      out.add(
          'La app no consiguió abrir el navegador. Cierra esta ventana, espera 2 segundos y vuelve a intentarlo.');
    }
    if (low.contains('socket') ||
        low.contains('connection') ||
        low.contains('timeout')) {
      out.add(
          'Problema de red. Verifica que tienes conexión a internet y vuelve a probar.');
    }
    if (low.contains('falta el client id') ||
        low.contains('faltan las credenciales')) {
      out.add(
          'No has guardado el Client ID y Client Secret. Rellena los campos y pulsa "Guardar credenciales" primero.');
    }
    if (out.isEmpty) {
      out.add(
          'Comprueba que el tipo de credenciales en Google Cloud Console es "Aplicación de escritorio" y que tu email está añadido como usuario de prueba en la pantalla de consentimiento.');
    }
    return out;
  }
}
