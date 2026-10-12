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

// Pantalla "Verificar en equipo (wifi)": varios Controls verifican la misma
// prueba a la vez, cada uno con su BD, y se sincronizan por la wifi (no hace
// falta internet). Ver proveedor_sync.dart.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/idioma.dart';
import '../../core/proveedores.dart';
import '../../core/tema.dart';
import '../../services/almacen_local.dart';
import 'dispositivo_sync.dart';
import 'proveedor_sync.dart';

class PantallaSincronizacion extends ConsumerStatefulWidget {
  const PantallaSincronizacion({super.key, required this.pruebaId});
  final int pruebaId;

  @override
  ConsumerState<PantallaSincronizacion> createState() =>
      _PantallaSincronizacionState();
}

class _PantallaSincronizacionState
    extends ConsumerState<PantallaSincronizacion> {
  late final _nombre = TextEditingController(text: DispositivoSync.nombre);
  late final _clave =
      TextEditingController(text: ref.read(sincronizacionProvider.notifier).clave);
  List<String> _misIps = const [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        ref.read(sincronizacionProvider.notifier).fijarPrueba(widget.pruebaId));
    _cargarIps();
  }

  @override
  void dispose() {
    _nombre.dispose();
    _clave.dispose();
    super.dispose();
  }

  Future<void> _cargarIps() async {
    try {
      final l = <String>[];
      for (final i
          in await NetworkInterface.list(type: InternetAddressType.IPv4)) {
        for (final a in i.addresses) {
          if (!a.isLoopback) l.add(a.address);
        }
      }
      if (mounted) setState(() => _misIps = l);
    } catch (_) {}
  }

  Future<void> _guardarNombre() async {
    if (_nombre.text.trim() == DispositivoSync.nombre) return;
    await DispositivoSync.cambiar(
        ref.read(almacenSyncProvider), _nombre.text);
    _nombre.text = DispositivoSync.nombre;
    // Los triggers de la BD firman los cambios con este nombre.
    await ref.read(dbProvider).fijarDispositivoSync(DispositivoSync.nombre);
    final n = ref.read(sincronizacionProvider.notifier);
    // Se vuelve a anunciar en la red con el nombre nuevo.
    if (ref.read(sincronizacionProvider).activo) {
      await n.desactivar(recordar: false);
      await n.activar();
    }
    if (mounted) setState(() {});
  }

  Future<void> _anadirManual() async {
    final ctrl = TextEditingController();
    final dir = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l.anadirControlPorDireccion),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: InputDecoration(
            labelText: context.l.ipOPuerto,
            hintText: '192.168.1.34',
            helperText: context.l.ipAyuda,
          ),
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(context.l.cancelar)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, ctrl.text),
              child: Text(context.l.anadir)),
        ],
      ),
    );
    if (dir == null || dir.trim().isEmpty) return;
    final ok =
        await ref.read(sincronizacionProvider.notifier).anadirManual(dir);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ok
            ? context.l.syncControlAnadido
            : context.l.syncNoHayControlEn(dir))));
  }

  @override
  Widget build(BuildContext context) {
    final st = ref.watch(sincronizacionProvider);
    final n = ref.read(sincronizacionProvider.notifier);
    final cs = Theme.of(context).colorScheme;
    final gris = TextStyle(color: cs.onSurfaceVariant, fontSize: 13);
    final hora = DateFormat('HH:mm:ss');
    final mismoNombre = st.companeros.values
        .any((c) => c.nombre == DispositivoSync.nombre);

    return Scaffold(
      appBar: AppBar(title: Text(context.l.verificarEnEquipoWifi)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                context.l.syncIntroTexto,
                style: gris,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nombre,
            decoration: InputDecoration(
              labelText: context.l.nombreDeEsteControl,
              helperText: context.l.nombreControlAyuda,
            ),
            onSubmitted: (_) => _guardarNombre(),
            onTapOutside: (_) => _guardarNombre(),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _clave,
            decoration: InputDecoration(
              labelText: context.l.claveDelEvento,
              helperText: context.l.claveEventoAyuda,
            ),
            onSubmitted: (v) => n.guardarClave(v),
            onTapOutside: (_) {
              if (_clave.text.trim() != n.clave) n.guardarClave(_clave.text);
            },
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(context.l.conectarConOtros),
            subtitle: Text(st.activo
                ? '${context.l.visibleComo(DispositivoSync.nombre)}'
                    '${_misIps.isEmpty ? '' : ' · ${_misIps.map((ip) => '$ip:${st.puerto}').join(', ')}'}'
                : st.arrancando
                    ? context.l.conectando
                    : context.l.apagado),
            value: st.activo,
            onChanged: st.arrancando
                ? null
                : (v) async {
                    if (v) {
                      await n.guardarClave(_clave.text);
                      await _guardarNombre();
                      await n.activar();
                    } else {
                      await n.desactivar();
                    }
                  },
          ),
          if (st.error != null || st.errorCodigo != null)
            Text(_textoError(context.l, st), style: TextStyle(color: cs.error)),
          if (st.activo) ...[
            const Divider(height: 24),
            Row(
              children: [
                Text(context.l.controlsEnLaRed,
                    style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                if (st.buscando)
                  const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                else
                  IconButton(
                    tooltip: context.l.buscarDeNuevo,
                    icon: const Icon(Icons.refresh),
                    onPressed: n.buscar,
                  ),
                IconButton(
                  tooltip: context.l.anadirPorDireccion,
                  icon: const Icon(Icons.add_link),
                  onPressed: _anadirManual,
                ),
              ],
            ),
            if (st.companeros.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  st.buscando
                      ? context.l.buscandoOtrosControls
                      : context.l.noSeEncuentraControl,
                  style: gris,
                ),
              ),
            if (mismoNombre)
              Text(
                  context.l.dosControlsMismoNombre(DispositivoSync.nombre),
                  style: TextStyle(color: cs.error)),
            for (final c in st.companeros.values)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  c.error != null || !c.claveOk
                      ? Icons.error_outline
                      : c.ultimaSync != null
                          ? Icons.check_circle_outline
                          : Icons.devices_outlined,
                  color: c.error != null || !c.claveOk
                      ? cs.error
                      : c.ultimaSync != null
                          ? context.estado.exito
                          : null,
                ),
                title: Text(c.nombre),
                subtitle: Text(
                  !c.claveOk && c.error == null
                      ? context.l.claveNoCoincide(c.host)
                      : c.error != null
                          ? '${c.host} · ${c.error}'
                          : c.ultimaSync == null
                              ? c.host
                              : '${c.host} · ${hora.format(c.ultimaSync!)} · '
                                  '${c.resumen?.resumen(context.l) ?? ''}',
                ),
                trailing: IconButton(
                  tooltip: context.l.quitarDeLaLista,
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => n.olvidar(c.host),
                ),
              ),
            const Divider(height: 24),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(context.l.sincronizarAutomaticamente),
              subtitle: Text(
                  context.l.cadaNsAppAbierta(intervaloAutoSync.inSeconds)),
              value: st.auto,
              onChanged: n.fijarAuto,
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: st.sincronizando || st.companeros.isEmpty
                  ? null
                  : n.sincronizarAhora,
              icon: st.sincronizando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.sync),
              label: Text(st.sincronizando
                  ? context.l.sincronizando
                  : context.l.sincronizarAhora),
            ),
            if (st.ultimaSync != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                    context.l.ultimaSincronizacion(
                        hora.format(st.ultimaSync!)),
                    style: gris,
                    textAlign: TextAlign.center),
              ),
            for (final a in st.avisos)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber_outlined,
                        size: 18, color: cs.tertiary),
                    const SizedBox(width: 6),
                    Expanded(child: Text(a, style: gris)),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

/// Texto del error de sincronización: los códigos propios se traducen; el
/// resto (fallos de red) ya viene listo.
String _textoError(Textos l, EstadoSync st) => switch (st.errorCodigo) {
      'sinClave' => l.syncSinClave,
      'abrirConexion' => l.syncNoSePudoAbrir(st.errorDetalle ?? ''),
      _ => st.error ?? '',
    };

/// Icono para las barras de las pantallas de verificación: indica si la
/// sincronización está encendida y abre su pantalla.
class BotonSincronizacion extends ConsumerWidget {
  const BotonSincronizacion(
      {super.key, required this.pruebaId, this.conTexto = false});
  final int pruebaId;

  /// Botón con texto (barra de acciones de la pestaña Verificar) en vez de
  /// solo icono.
  final bool conTexto;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final st = ref.watch(sincronizacionProvider);
    final conectados = st.companeros.values
        .where((c) => c.error == null && c.claveOk)
        .length;
    final activaAqui = st.activo && st.pruebaId == pruebaId;
    final icono = Badge(
      isLabelVisible: activaAqui,
      label: Text('$conectados'),
      child: Icon(activaAqui ? Icons.sync : Icons.sync_disabled_outlined),
    );
    void abrir() => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => PantallaSincronizacion(pruebaId: pruebaId)));
    if (conTexto) {
      return OutlinedButton.icon(
        icon: icono,
        label: Text(activaAqui
            ? context.l.verificarEnEquipoN(conectados)
            : context.l.verificarEnEquipoWifi),
        onPressed: abrir,
      );
    }
    return IconButton(
      tooltip: activaAqui
          ? context.l.verificarEnEquipoNConectados(conectados)
          : context.l.verificarEnEquipoWifi,
      icon: icono,
      onPressed: abrir,
    );
  }
}
