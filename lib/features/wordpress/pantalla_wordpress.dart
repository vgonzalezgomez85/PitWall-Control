import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/publicador_wordpress.dart';
import '../../services/wordpress_service.dart';

class PantallaWordpress extends ConsumerStatefulWidget {
  const PantallaWordpress({super.key});

  @override
  ConsumerState<PantallaWordpress> createState() => _PantallaWordpressState();
}

class _PantallaWordpressState extends ConsumerState<PantallaWordpress> {
  final _url = TextEditingController();
  final _usuario = TextEditingController();
  final _pass = TextEditingController();

  bool _cargando = true;
  bool _guardando = false;
  bool _probando = false;
  bool _publicando = false;
  bool _verPass = false;
  String? _mensaje;
  String? _sitio;
  List<String> _pasosPub = [];

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final cfg = await ref.read(wordpressServiceProvider).cargar();
    _url.text = cfg.url;
    _usuario.text = cfg.usuario;
    _pass.text = cfg.appPassword;
    if (mounted) setState(() => _cargando = false);
  }

  @override
  void dispose() {
    _url.dispose();
    _usuario.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    setState(() => _guardando = true);
    await ref.read(wordpressServiceProvider).guardar(WordpressConfig(
          url: _url.text,
          usuario: _usuario.text,
          appPassword: _pass.text,
        ));
    await ref.read(estadoWordpressProvider.notifier).refrescar();
    if (mounted) {
      setState(() {
        _guardando = false;
        _mensaje = 'Configuración guardada.';
      });
    }
  }

  Future<void> _probar() async {
    setState(() {
      _probando = true;
      _mensaje = null;
    });
    try {
      final res = await ref.read(wordpressServiceProvider).ping();
      _sitio = res['site']?.toString();
      _mensaje = '✓ Conectado a "${res['site'] ?? ''}" (versión plugin ${res['version'] ?? '?'})';
    } catch (e) {
      _mensaje = '✗ $e';
    } finally {
      if (mounted) setState(() => _probando = false);
    }
  }

  Future<void> _publicar() async {
    setState(() {
      _publicando = true;
      _pasosPub = [];
      _mensaje = null;
    });
    final r = await ref.read(publicadorProvider).publicarTodo();
    if (mounted) {
      setState(() {
        _publicando = false;
        _pasosPub = r.pasos;
        _mensaje = r.ok ? '✓ Publicación completada.' : '✗ ${r.error}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('WordPress')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            color: cs.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.cloud_outlined,
                      size: 32, color: cs.onPrimaryContainer),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_sitio ?? 'Configura tu sitio WordPress',
                            style: TextStyle(
                                color: cs.onPrimaryContainer,
                                fontWeight: FontWeight.w700,
                                fontSize: 16)),
                        if (_url.text.isNotEmpty)
                          Text(_url.text,
                              style: TextStyle(color: cs.onPrimaryContainer)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const _GuiaWordpress())),
            icon: const Icon(Icons.help_outline),
            label: const Text('Cómo configurarlo paso a paso'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _url,
            decoration: const InputDecoration(
              labelText: 'URL del sitio',
              hintText: 'https://www.resisbarna.es',
              prefixIcon: Icon(Icons.link),
            ),
            keyboardType: TextInputType.url,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _usuario,
            decoration: const InputDecoration(
              labelText: 'Usuario',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _pass,
            obscureText: !_verPass,
            decoration: InputDecoration(
              labelText: 'Contraseña de aplicación',
              helperText: 'No es la contraseña normal. Se crea en tu perfil de WordPress.',
              prefixIcon: const Icon(Icons.key_outlined),
              suffixIcon: IconButton(
                icon: Icon(_verPass
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined),
                onPressed: () => setState(() => _verPass = !_verPass),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _guardando ? null : _guardar,
                  icon: _guardando
                      ? const SizedBox(
                          width: 18, height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.save_outlined),
                  label: const Text('Guardar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _probando ? null : _probar,
                  icon: _probando
                      ? const SizedBox(
                          width: 18, height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.cable_outlined),
                  label: const Text('Probar conexión'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _publicando ? null : _publicar,
            icon: _publicando
                ? const SizedBox(
                    width: 18, height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.cloud_upload_outlined),
            label: const Text('Publicar todo el campeonato'),
          ),
          if (_mensaje != null) ...[
            const SizedBox(height: 16),
            Card(
              color: _mensaje!.startsWith('✓')
                  ? Colors.green.shade50
                  : cs.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(_mensaje!),
              ),
            ),
          ],
          if (_pasosPub.isNotEmpty) ...[
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _pasosPub.map((p) => Text(p)).toList(),
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),
          Card(
            color: cs.surfaceContainer,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Shortcodes disponibles',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  const SelectableText(
                    '[resisbarna_clasificacion campeonato="resisbarna-2026"]\n'
                    '[resisbarna_calendario campeonato="resisbarna-2026"]\n'
                    '[resisbarna_pilotos campeonato="resisbarna-2026"]\n'
                    '[resisbarna_equipos campeonato="resisbarna-2026"]\n'
                    '[resisbarna_verificaciones prueba="prueba-1"]\n'
                    '[resisbarna_prueba uid="prueba-1-1"]',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pega cualquiera de estos códigos en una página de WordPress '
                    'para mostrar el contenido publicado.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuiaWordpress extends StatelessWidget {
  const _GuiaWordpress();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurar WordPress')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Para que la app pueda publicar en resisbarna.es necesitas instalar '
            'el plugin gratuito "Resisbarna Sync" y crear una contraseña de aplicación.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          const _Paso(
            n: 1,
            titulo: 'Instalar el plugin',
            cuerpo:
                'Comprime la carpeta "wordpress-plugin/resisbarna-sync" del proyecto como ZIP. '
                'En tu WordPress: Plugins → Añadir nuevo → Subir → elige el ZIP → Activar.',
          ),
          const _Paso(
            n: 2,
            titulo: 'Crear contraseña de aplicación',
            cuerpo:
                'En WordPress: Usuarios → Tu perfil → baja hasta "Contraseñas de aplicación". '
                'Pon el nombre "Resisbarna App" y pulsa "Añadir nueva". '
                'WordPress te muestra una contraseña tipo "xxxx xxxx xxxx xxxx" — cópiala (solo se ve una vez).',
          ),
          _Paso(
            n: 3,
            titulo: 'Pegarlos en la app',
            cuerpo:
                'Vuelve a esta pantalla y rellena URL del sitio, tu usuario WordPress '
                'y la contraseña de aplicación. Pulsa "Probar conexión" para verificar.',
            urlAccion: null,
          ),
          const _Paso(
            n: 4,
            titulo: 'Insertar shortcodes en tus páginas',
            cuerpo:
                'En la página donde quieras mostrar la clasificación: edita la página '
                '→ añade un bloque "Shortcode" → pega [resisbarna_clasificacion campeonato="..."]. '
                'Guarda. ¡Listo!',
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
  });

  final int n;
  final String titulo;
  final String cuerpo;
  final String? urlAccion;

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
            if (urlAccion != null) ...[
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => launchUrl(Uri.parse(urlAccion!),
                    mode: LaunchMode.externalApplication),
                icon: const Icon(Icons.open_in_new, size: 16),
                label: const Text('Abrir'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
