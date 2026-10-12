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
// Diálogo "Enviar verificaciones a PitWall": descubre Manager en la LAN (o IP
// manual + PIN), pide la lista de sus carreras (mismo `/link/races` que usa
// "Traer resultados") y, al elegir una, envía las verificaciones LIGADAS a
// esa carrera (a modo de solo consulta en Manager). Guarda el raceId elegido
// como el de esta prueba para la próxima vez.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/idioma.dart';
import '../../services/almacen_local.dart';
import '../../services/enviar_verificaciones_service.dart';
import '../../services/generador_verificaciones_json.dart';
import '../../services/traer_resultados_service.dart'
    show listarCarreras, CarreraManager;
import 'repositorio_pruebas.dart';
import 'selector_pitwall.dart';

const _kHostKey = 'pitwall_host';
const _kPinKey = 'pitwall_pin';

Future<void> mostrarEnviarVerificaciones(
    BuildContext context, WidgetRef ref, int pruebaId) async {
  await showDialog<void>(
    context: context,
    builder: (_) => _EnviarVerificacionesDialog(ref: ref, pruebaId: pruebaId),
  );
}

class _EnviarVerificacionesDialog extends StatefulWidget {
  const _EnviarVerificacionesDialog(
      {required this.ref, required this.pruebaId});
  final WidgetRef ref;
  final int pruebaId;

  @override
  State<_EnviarVerificacionesDialog> createState() =>
      _EnviarVerificacionesDialogState();
}

class _EnviarVerificacionesDialogState
    extends State<_EnviarVerificacionesDialog> {
  final _hostCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  bool _trabajando = false; // listando carreras o enviando

  int _paso = 0; // 0 = elegir PitWall, 1 = elegir carrera
  List<CarreraManager> _carreras = [];

  @override
  void initState() {
    super.initState();
    final almacen = widget.ref.read(almacenSyncProvider);
    _hostCtrl.text = almacen.readSync(key: _kHostKey) ?? '';
    _pinCtrl.text = almacen.readSync(key: _kPinKey) ?? '';
  }

  @override
  void dispose() {
    _hostCtrl.dispose();
    _pinCtrl.dispose();
    super.dispose();
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  // Paso 0 → 1: guardar host/PIN y pedir la lista de carreras a Manager.
  Future<void> _verCarreras() async {
    final l = context.l;
    final host = _hostCtrl.text.trim();
    if (host.isEmpty) {
      _snack(l.eligePitwall);
      return;
    }
    setState(() => _trabajando = true);
    try {
      final almacen = widget.ref.read(almacenSyncProvider);
      await almacen.write(key: _kHostKey, value: host);
      await almacen.write(key: _kPinKey, value: _pinCtrl.text.trim());
      final carreras = await listarCarreras(host);
      if (!mounted) return;
      setState(() {
        _carreras = carreras;
        _paso = 1;
      });
    } catch (e) {
      _snack(l.noSePudoConectar('$e'));
    } finally {
      if (mounted) setState(() => _trabajando = false);
    }
  }

  // Paso 1: al elegir una carrera, se envían las verificaciones ligadas a ella.
  Future<void> _enviarACarrera(CarreraManager carrera) async {
    final l = context.l;
    setState(() => _trabajando = true);
    try {
      final payload = await widget.ref
          .read(generadorVerificacionesJsonProvider)
          .generar(pruebaId: widget.pruebaId, raceId: carrera.id);
      final verificaciones = (payload['verificaciones'] as List?) ?? const [];
      if (verificaciones.isEmpty) {
        _snack(l.noHayVerificacionesEnviar);
        setState(() => _trabajando = false);
        return;
      }

      final res = await enviarVerificaciones(
          host: _hostCtrl.text.trim(), pin: _pinCtrl.text, payload: payload);
      if (res.ok) {
        await widget.ref
            .read(repoPruebasProvider)
            .guardarManagerRaceId(widget.pruebaId, carrera.id);
      }
      if (!mounted) return;
      if (res.ok) {
        Navigator.of(context).pop();
        _snack(res.mensaje);
      } else {
        setState(() => _trabajando = false);
        _snack(res.mensaje);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _trabajando = false);
      _snack(l.errorDetalle('$e'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_paso == 0
          ? context.l.enviarVerificacionesPitwall
          : context.l.eligeLaCarrera),
      content: SizedBox(width: 420, child: _cuerpo()),
      actions: [
        TextButton(
          onPressed: _trabajando ? null : () => Navigator.of(context).pop(),
          child: Text(context.l.cancelar),
        ),
        if (_paso == 1)
          TextButton(
            onPressed: _trabajando ? null : () => setState(() => _paso = 0),
            child: Text(context.l.atras),
          ),
        if (_paso == 0)
          FilledButton.icon(
            onPressed: _trabajando ? null : _verCarreras,
            icon: _trabajando
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.list),
            label: Text(context.l.verCarreras),
          ),
      ],
    );
  }

  Widget _cuerpo() => _paso == 0 ? _pasoHost() : _pasoCarreras();

  Widget _pasoHost() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l.seEnvianComoConsulta,
          style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.outline),
        ),
        const SizedBox(height: 8),
        SelectorPitwall(hostCtrl: _hostCtrl),
        const SizedBox(height: 8),
        TextField(
          controller: _pinCtrl,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: context.l.pinImportacion,
            helperText: context.l.pinImportacionAyuda,
          ),
        ),
      ],
    );
  }

  Widget _pasoCarreras() {
    if (_carreras.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(context.l.pitwallNoTieneCarrerasEnvia),
      );
    }
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 340),
      child: ListView(
        shrinkWrap: true,
        children: [
          for (final c in _carreras)
            ListTile(
              leading: const Icon(Icons.flag_outlined),
              title: Text(c.nombre),
              subtitle: Text(
                  '${context.l.tandasDeCarrera(c.tandas)}'
                  '${c.creada != null ? ' · ${c.creada}' : ''}'),
              enabled: !_trabajando,
              onTap: () => _enviarACarrera(c),
            ),
          if (_trabajando)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                  child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2))),
            ),
        ],
      ),
    );
  }
}
