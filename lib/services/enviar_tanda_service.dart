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
// Envía una tanda (JSON `pitwall.tanda/v1`) por HTTP a PitWall Manager en la LAN.
// Manager crea la carrera y devuelve { ok, raceId, url, tandas, teams, name }.
// Si el payload trae `race_id`, la actualiza y añade `actualizada: true` con las
// tandas rehechas/nuevas/borradas y las ya corridas que no ha tocado.

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/idioma.dart';

class EnvioTandaResultado {
  final bool ok;
  final String mensaje;
  final String? url; // ruta relativa de la carrera en Manager (p. ej. /races/57)
  final int? raceId;
  EnvioTandaResultado(this.ok, this.mensaje, {this.url, this.raceId});
}

/// Normaliza "192.168.1.50:3000" / "http://host:3000" / "host" en una base URL.
String baseUrl(String host, {int puertoDefecto = 3000}) {
  var h = host.trim();
  if (h.isEmpty) return '';
  if (!h.startsWith('http://') && !h.startsWith('https://')) h = 'http://$h';
  final u = Uri.parse(h);
  final port = u.hasPort ? u.port : puertoDefecto;
  return '${u.scheme}://${u.host}:$port';
}

Future<EnvioTandaResultado> enviarTanda({
  required Textos l,
  required String host, // ip/hostname (+ puerto opcional)
  required String pin,
  required Map<String, dynamic> payload,
  int puertoDefecto = 3000,
}) async {
  final base = baseUrl(host, puertoDefecto: puertoDefecto);
  if (base.isEmpty) return EnvioTandaResultado(false, l.indicaDireccionPitwall);
  try {
    final r = await http
        .post(
          Uri.parse('$base/import/tanda'),
          headers: {
            'Content-Type': 'application/json',
            if (pin.trim().isNotEmpty) 'x-import-pin': pin.trim(),
          },
          body: jsonEncode(payload),
        )
        .timeout(const Duration(seconds: 15));

    Map<String, dynamic> j = {};
    try {
      final decoded = jsonDecode(r.body);
      if (decoded is Map<String, dynamic>) j = decoded;
    } catch (_) {/* respuesta no-JSON (p. ej. página de error) */}

    if (r.statusCode == 200 && j['ok'] == true) {
      return EnvioTandaResultado(
        true,
        _mensajeOk(l, j),
        url: j['url']?.toString(),
        raceId: (j['raceId'] as num?)?.toInt(),
      );
    }
    if (r.statusCode == 403) {
      // Manager manda el mismo 403 para PIN incorrecto y para "Conexión
      // ecosistema" desactivada (indistinguibles); usamos su texto si lo trae.
      return EnvioTandaResultado(false,
          (j['error'] ?? l.pinIncorrecto).toString());
    }
    return EnvioTandaResultado(false,
        (j['error'] ?? l.errorCodigoHttp('${r.statusCode}')).toString());
  } catch (e) {
    return EnvioTandaResultado(false, l.noSePudoConectarPitwall('$e'));
  }
}

String _mensajeOk(Textos l, Map<String, dynamic> j) {
  final nombre = '${j['name'] ?? ''}';
  if (j['actualizada'] != true) {
    return l.carreraCreadaPitwall(
        nombre, '${j['tandas'] ?? '?'}', '${j['teams'] ?? '?'}');
  }
  if (j['pole'] == true) {
    return l.poleActualizadaPitwall(nombre, '${j['teams'] ?? '?'}');
  }
  int n(String k) => (j[k] as List?)?.length ?? 0;
  final bloqueadas = (j['bloqueadas'] as List?) ?? const [];
  return [
    l.carreraActualizadaPitwall(nombre, '${n('actualizadas')}',
        '${n('nuevas')}', '${n('borradas')}'),
    if (bloqueadas.isNotEmpty) l.tandasCorridasSinTocar(bloqueadas.join(', ')),
  ].join(' ');
}
