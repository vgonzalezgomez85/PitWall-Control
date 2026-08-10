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
// Envía las verificaciones (JSON `pitwall.verificaciones/v1`) por HTTP a
// PitWall Manager en la LAN. Manager las guarda a modo de solo consulta (no
// editables desde allí) y las liga a `race_id` si se envió, o casa/crea la
// carrera por los datos de `prueba` en su defecto. Devuelve { ok, raceId,
// url, count }.

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'enviar_tanda_service.dart' show baseUrl;

class EnvioVerificacionesResultado {
  final bool ok;
  final String mensaje;
  final String? url;
  final int? raceId;
  EnvioVerificacionesResultado(this.ok, this.mensaje, {this.url, this.raceId});
}

Future<EnvioVerificacionesResultado> enviarVerificaciones({
  required String host,
  required String pin,
  required Map<String, dynamic> payload,
  int puertoDefecto = 3000,
}) async {
  final base = baseUrl(host, puertoDefecto: puertoDefecto);
  if (base.isEmpty) {
    return EnvioVerificacionesResultado(false, 'Indica la dirección de PitWall.');
  }
  try {
    final r = await http
        .post(
          Uri.parse('$base/import/verificaciones'),
          headers: {
            'Content-Type': 'application/json',
            if (pin.trim().isNotEmpty) 'x-import-pin': pin.trim(),
          },
          body: jsonEncode(payload),
        )
        .timeout(const Duration(seconds: 30));

    Map<String, dynamic> j = {};
    try {
      final decoded = jsonDecode(r.body);
      if (decoded is Map<String, dynamic>) j = decoded;
    } catch (_) {/* respuesta no-JSON (p. ej. página de error) */}

    if (r.statusCode == 200 && j['ok'] == true) {
      return EnvioVerificacionesResultado(
        true,
        '${j['count'] ?? '?'} verificación(es) enviada(s) a ${j['name'] ?? 'PitWall'}.',
        url: j['url']?.toString(),
        raceId: (j['raceId'] as num?)?.toInt(),
      );
    }
    if (r.statusCode == 403) {
      // Manager manda el mismo 403 para PIN incorrecto y para "Conexión
      // ecosistema" desactivada (indistinguibles); usamos su texto si lo trae.
      return EnvioVerificacionesResultado(false,
          (j['error'] ?? 'PIN incorrecto o dispositivo no autorizado.').toString());
    }
    return EnvioVerificacionesResultado(
        false, (j['error'] ?? 'Error ${r.statusCode}.').toString());
  } catch (e) {
    return EnvioVerificacionesResultado(false, 'No se pudo conectar con PitWall: $e');
  }
}
