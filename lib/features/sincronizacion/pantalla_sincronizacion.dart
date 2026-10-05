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

// Pantalla "Verificar entre varios": varios Controls verifican la misma
// prueba a la vez, cada uno con su BD, y se sincronizan por la wifi (no hace
// falta internet). Ver proveedor_sync.dart.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
        title: const Text('Añadir Control por dirección'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'IP (o IP:puerto)',
            hintText: '192.168.1.34',
            helperText: 'La ves en esta misma pantalla del otro Control.',
          ),
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, ctrl.text),
              child: const Text('Añadir')),
        ],
      ),
    );
    if (dir == null || dir.trim().isEmpty) return;
    final ok =
        await ref.read(sincronizacionProvider.notifier).anadirManual(dir);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ok
            ? 'Control añadido.'
            : 'No hay ningún Control conectado en $dir.')));
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
      appBar: AppBar(title: const Text('Verificar entre varios')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Varios Controls pueden verificar esta prueba a la vez. '
                'Cada uno guarda en su dispositivo y se pasan los cambios por '
                'la wifi: verificaciones, fotos, copa y cobros.\n\n'
                '• Todos en la misma wifi. No hace falta internet: vale un '
                'router sin conexión o el punto de acceso de un móvil.\n'
                '• Antes del evento, partid todos de la misma copia de datos '
                '(campeonato, prueba, mangas y equipos).\n'
                '• La misma clave del evento en todos, y la hora automática '
                'activada: si dos tocan la misma verificación, gana el último '
                'cambio.',
                style: gris,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nombre,
            decoration: const InputDecoration(
              labelText: 'Nombre de este Control',
              helperText: 'Distinto en cada dispositivo (p. ej. «Mesa 1»).',
            ),
            onSubmitted: (_) => _guardarNombre(),
            onTapOutside: (_) => _guardarNombre(),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _clave,
            decoration: const InputDecoration(
              labelText: 'Clave del evento',
              helperText: 'La misma en todos los Controls.',
            ),
            onSubmitted: (v) => n.guardarClave(v),
            onTapOutside: (_) {
              if (_clave.text.trim() != n.clave) n.guardarClave(_clave.text);
            },
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Conectar con otros Controls'),
            subtitle: Text(st.activo
                ? 'Visible como «${DispositivoSync.nombre}»'
                    '${_misIps.isEmpty ? '' : ' · ${_misIps.map((ip) => '$ip:${st.puerto}').join(', ')}'}'
                : st.arrancando
                    ? 'Conectando…'
                    : 'Apagado'),
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
          if (st.error != null)
            Text(st.error!, style: TextStyle(color: cs.error)),
          if (st.activo) ...[
            const Divider(height: 24),
            Row(
              children: [
                Text('Controls en la red',
                    style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                if (st.buscando)
                  const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                else
                  IconButton(
                    tooltip: 'Buscar de nuevo',
                    icon: const Icon(Icons.refresh),
                    onPressed: n.buscar,
                  ),
                IconButton(
                  tooltip: 'Añadir por dirección',
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
                      ? 'Buscando otros Controls en la wifi…'
                      : 'No se ha encontrado ningún Control. Comprueba que '
                          'los demás tienen esta pantalla con «Conectar» '
                          'encendido y están en la misma wifi, o añádelos '
                          'por su dirección.',
                  style: gris,
                ),
              ),
            if (mismoNombre)
              Text(
                  'Hay otro Control que también se llama '
                  '«${DispositivoSync.nombre}». Cambia el nombre de uno de '
                  'los dos.',
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
                          ? Colors.green
                          : null,
                ),
                title: Text(c.nombre),
                subtitle: Text(
                  !c.claveOk && c.error == null
                      ? '${c.host} · la clave del evento no coincide'
                      : c.error != null
                          ? '${c.host} · ${c.error}'
                          : c.ultimaSync == null
                              ? c.host
                              : '${c.host} · ${hora.format(c.ultimaSync!)} · '
                                  '${c.resumen}',
                ),
                trailing: IconButton(
                  tooltip: 'Quitar de la lista',
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => n.olvidar(c.host),
                ),
              ),
            const Divider(height: 24),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Sincronizar automáticamente'),
              subtitle: Text(
                  'Cada ${intervaloAutoSync.inSeconds} s mientras la app '
                  'esté abierta'),
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
                  ? 'Sincronizando…'
                  : 'Sincronizar ahora'),
            ),
            if (st.ultimaSync != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                    'Última sincronización: ${hora.format(st.ultimaSync!)}',
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

/// Icono para las barras de las pantallas de verificación: indica si la
/// sincronización está encendida y abre su pantalla.
class BotonSincronizacion extends ConsumerWidget {
  const BotonSincronizacion({super.key, required this.pruebaId});
  final int pruebaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final st = ref.watch(sincronizacionProvider);
    final conectados = st.companeros.values
        .where((c) => c.error == null && c.claveOk)
        .length;
    final activaAqui = st.activo && st.pruebaId == pruebaId;
    return IconButton(
      tooltip: activaAqui
          ? 'Verificar entre varios · $conectados conectados'
          : 'Verificar entre varios',
      icon: Badge(
        isLabelVisible: activaAqui,
        label: Text('$conectados'),
        child: Icon(activaAqui ? Icons.sync : Icons.sync_disabled_outlined),
      ),
      onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => PantallaSincronizacion(pruebaId: pruebaId))),
    );
  }
}
