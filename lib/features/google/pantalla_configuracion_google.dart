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
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/idioma.dart';
import '../../core/tema.dart';
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
    final l = context.l;
    final id = _clientId.text.trim();
    final sec = _clientSecret.text.trim();
    if (id.isEmpty || sec.isEmpty) {
      setState(() {
        _ultimoError = l.pegaClientIdSecret;
        _ultimoExito = null;
      });
      return;
    }
    if (!id.endsWith('.apps.googleusercontent.com')) {
      setState(() {
        _ultimoError = l.clientIdNoValido;
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
        _ultimoExito = l.credencialesGuardadasAviso;
      });
    }
  }

  Future<void> _conectar() async {
    final l = context.l;
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
                SnackBar(
                  content: Text(l.abriendoNavegadorAutoriza),
                  duration: const Duration(seconds: 4),
                ),
              );
            },
          );
      await ref.read(estadoGoogleProvider.notifier).refrescar();
      if (mounted) {
        setState(() {
          _ultimoExito = l.conectadoGoogleOk;
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
    final l = context.l;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.desconectarGoogle),
        content: Text(l.desconectarGoogleTexto),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l.cancelar)),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l.desconectar)),
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
    final l = context.l;
    final estadoAsync = ref.watch(estadoGoogleProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Google Sheets')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          estadoAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (e, _) => Text(l.errorDetalle('$e')),
            data: (e) => _TarjetaEstado(
              estado: e,
              onConectar: _conectar,
              onDesconectar: _desconectar,
              conectando: _conectando,
            ),
          ),
          const SizedBox(height: 24),
          Text(l.credencialesProyectoGoogleCloud,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            l.credencialesProyectoTexto,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const _GuiaGoogleCloud())),
            icon: const Icon(Icons.help_outline),
            label: Text(l.comoConseguirlas),
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
            label: Text(l.guardarCredenciales),
          ),
          if (_ultimoExito != null) ...[
            const SizedBox(height: 12),
            Card(
              color: context.estado.exitoSuave,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline,
                        color: context.estado.exito),
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
                      Text(l.permisosSolicitados,
                          style: Theme.of(context).textTheme.titleSmall),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(l.permisosTexto),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: Icon(Icons.cloud_sync_outlined, color: cs.primary),
              title: Text(l.copiaCompartidaDrive),
              subtitle: Text(l.copiaCompartidaDriveTexto),
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
    final l = context.l;
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
                        conectado ? l.conectadoConGoogle : l.sinConectar,
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
                          l.faltanCredencialesGoogle,
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
                    label: Text(l.conectarConGoogle),
                  )
                else
                  OutlinedButton.icon(
                    onPressed: onDesconectar,
                    icon: const Icon(Icons.logout),
                    label: Text(l.desconectar),
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
    final l = context.l;
    return Scaffold(
      appBar: AppBar(title: Text(l.conseguirCredenciales)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            l.conseguirCredencialesTexto,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => launchUrl(
                Uri.parse('https://www.pitwall.es/manual-control.html#google'),
                mode: LaunchMode.externalApplication),
            icon: const Icon(Icons.menu_book_outlined, size: 16),
            label: Text(l.verManualCapturas),
          ),
          const SizedBox(height: 16),
          _Paso(
            n: 1,
            titulo: l.guiaPaso1Titulo,
            cuerpo: l.guiaPaso1Texto,
            urlAccion: 'https://console.cloud.google.com/projectcreate',
            textoAccion: l.abrirCloudConsole,
          ),
          _Paso(
            n: 2,
            titulo: l.guiaPaso2Titulo,
            cuerpo: l.guiaPaso2Texto,
            urlAccion:
                'https://console.cloud.google.com/apis/library/sheets.googleapis.com',
            textoAccion: l.apiSheets,
            urlAccion2:
                'https://console.cloud.google.com/apis/library/drive.googleapis.com',
            textoAccion2: l.apiDrive,
          ),
          _Paso(
            n: 3,
            titulo: l.pantallaDeConsentimiento,
            cuerpo: l.guiaPaso3Texto,
            urlAccion:
                'https://console.cloud.google.com/auth/overview/create',
            textoAccion: l.pantallaDeConsentimiento,
          ),
          _Paso(
            n: 4,
            titulo: l.guiaPaso4Titulo,
            cuerpo: l.guiaPaso4Texto,
            urlAccion: 'https://console.cloud.google.com/auth/audience',
            textoAccion: l.publico,
          ),
          _Paso(
            n: 5,
            titulo: l.guiaPaso5Titulo,
            cuerpo: l.guiaPaso5Texto,
            urlAccion: 'https://console.cloud.google.com/auth/clients',
            textoAccion: l.clientes,
          ),
          _Paso(
            n: 6,
            titulo: l.guiaPaso6Titulo,
            cuerpo: l.guiaPaso6Texto,
          ),
          _Paso(
            n: 7,
            titulo: l.guiaPaso7Titulo,
            cuerpo: l.guiaPaso7Texto,
          ),
          Card(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l.avisoPrueba7Dias,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onTertiaryContainer),
              ),
            ),
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
    this.urlAccion2,
    this.textoAccion2,
  });

  final int n;
  final String titulo;
  final String cuerpo;
  final String? urlAccion;
  final String? textoAccion;
  final String? urlAccion2;
  final String? textoAccion2;

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
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => launchUrl(Uri.parse(urlAccion!),
                        mode: LaunchMode.externalApplication),
                    icon: const Icon(Icons.open_in_new, size: 16),
                    label: Text(textoAccion!),
                  ),
                  if (urlAccion2 != null && textoAccion2 != null)
                    OutlinedButton.icon(
                      onPressed: () => launchUrl(Uri.parse(urlAccion2!),
                          mode: LaunchMode.externalApplication),
                      icon: const Icon(Icons.open_in_new, size: 16),
                      label: Text(textoAccion2!),
                    ),
                ],
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
    final l = context.l;
    final pistas = _diagnosticar(mensaje, l);
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
                Text(l.conexionFallida,
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
              Text(l.cosasQueSuelenFallar,
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

  static List<String> _diagnosticar(String m, Textos l) {
    final out = <String>[];
    final low = m.toLowerCase();

    if (low.contains('access_denied') ||
        low.contains('has not completed') ||
        low.contains('verification process') ||
        low.contains('app blocked')) {
      out.add(l.pistaUsuariosPrueba);
    }
    if (low.contains('redirect_uri_mismatch') ||
        low.contains('redirect uri mismatch')) {
      out.add(l.pistaCredencialEscritorio);
    }
    if (low.contains('invalid_client') || low.contains('unauthorized')) {
      out.add(l.pistaClientIdSecreto);
    }
    if (low.contains('not enabled') ||
        low.contains('api has not been used')) {
      out.add(l.pistaApisNoActivadas);
    }
    if (low.contains('no se pudo abrir el navegador') ||
        low.contains(l.authNoSePudoAbrirNavegador.toLowerCase())) {
      out.add(l.pistaNavegador);
    }
    if (low.contains('socket') ||
        low.contains('connection') ||
        low.contains('timeout')) {
      out.add(l.pistaRed);
    }
    if (low.contains('falta el client id') ||
        low.contains('faltan las credenciales') ||
        low.contains(l.authFaltanCredenciales.toLowerCase()) ||
        low.contains(l.authConfiguraCredenciales.toLowerCase())) {
      out.add(l.pistaGuardarCredenciales);
    }
    if (out.isEmpty) {
      out.add(l.pistaCredencialPorDefecto);
    }
    return out;
  }
}
