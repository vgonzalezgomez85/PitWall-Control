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

import 'dart:convert';

import 'package:http/http.dart' as http;

class EnvioTandaResultado {
  final bool ok;
  final String mensaje;
  final String? url; // ruta relativa de la carrera en Manager (p. ej. /races/57)
  EnvioTandaResultado(this.ok, this.mensaje, {this.url});
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
  required String host, // ip/hostname (+ puerto opcional)
  required String pin,
  required Map<String, dynamic> payload,
  int puertoDefecto = 3000,
}) async {
  final base = baseUrl(host, puertoDefecto: puertoDefecto);
  if (base.isEmpty) return EnvioTandaResultado(false, 'Indica la dirección de PitWall.');
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
        'Carrera creada: ${j['name'] ?? ''} — ${j['tandas'] ?? '?'} tanda(s), ${j['teams'] ?? '?'} equipo(s).',
        url: j['url']?.toString(),
      );
    }
    if (r.statusCode == 403) {
      return EnvioTandaResultado(false, 'PIN incorrecto o dispositivo no autorizado.');
    }
    return EnvioTandaResultado(false, (j['error'] ?? 'Error ${r.statusCode}.').toString());
  } catch (e) {
    return EnvioTandaResultado(false, 'No se pudo conectar con PitWall: $e');
  }
}
