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
// Trae de PitWall Manager (LAN) la lista de carreras y los resultados de una
// carrera (contrato `pitwall.resultados/v1`, posición POR TANDA). Solo lectura,
// sin PIN (mismo canal que /link/races de Manager).

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'enviar_tanda_service.dart' show baseUrl;

/// Carrera del listado de Manager.
class CarreraManager {
  final int id;
  final String nombre;
  final int tandas;
  final String? creada;
  CarreraManager({
    required this.id,
    required this.nombre,
    required this.tandas,
    this.creada,
  });
}

/// Un equipo dentro de una tanda de resultados.
class ResultadoRemoto {
  final int tanda;
  final String nombre;
  final int posicion;
  final int? vueltas;
  final int? mejorVueltaMs;
  ResultadoRemoto({
    required this.tanda,
    required this.nombre,
    required this.posicion,
    this.vueltas,
    this.mejorVueltaMs,
  });
}

class ResultadosRemotos {
  final String raceName;
  final List<ResultadoRemoto> filas;
  ResultadosRemotos({required this.raceName, required this.filas});
}

// Manager explica algunos rechazos en el cuerpo (p. ej. la Conexión ecosistema
// desactivada en la LAN): `{error: '...'}` o `{ok:false, error:'...'}`. Si no
// hay body JSON reconocible (proxy, página de error…), cae al genérico.
String _errorDe(http.Response r, String generico) {
  try {
    final j = jsonDecode(r.body);
    if (j is Map && j['error'] is String && (j['error'] as String).isNotEmpty) {
      return j['error'] as String;
    }
  } catch (_) {/* respuesta no-JSON */}
  return generico;
}

Future<List<CarreraManager>> listarCarreras(String host) async {
  final base = baseUrl(host);
  if (base.isEmpty) throw 'Indica la dirección de PitWall.';
  final r = await http
      .get(Uri.parse('$base/link/races'))
      .timeout(const Duration(seconds: 10));
  if (r.statusCode != 200) {
    throw _errorDe(r, 'Error ${r.statusCode} al pedir las carreras.');
  }
  final j = jsonDecode(r.body) as Map<String, dynamic>;
  final races = (j['races'] as List?) ?? const [];
  return races
      .whereType<Map<String, dynamic>>()
      .map((c) => CarreraManager(
            id: (c['id'] as num).toInt(),
            nombre: (c['name'] ?? '').toString(),
            tandas: (c['tandaCount'] as num?)?.toInt() ?? 0,
            creada: c['createdAt']?.toString(),
          ))
      .toList();
}

Future<ResultadosRemotos> traerResultados(String host, int raceId) async {
  final base = baseUrl(host);
  final r = await http
      .get(Uri.parse('$base/link/races/$raceId/results.json'))
      .timeout(const Duration(seconds: 15));
  if (r.statusCode != 200) {
    throw _errorDe(r, 'Error ${r.statusCode} al pedir los resultados.');
  }
  final j = jsonDecode(r.body) as Map<String, dynamic>;
  if (j['schema'] != 'pitwall.resultados/v1') {
    throw 'Respuesta no reconocida (${j['schema']}).';
  }
  final filas = <ResultadoRemoto>[];
  for (final t in (j['tandas'] as List? ?? const [])) {
    if (t is! Map<String, dynamic>) continue;
    final numero = (t['numero'] as num?)?.toInt() ?? 0;
    for (final e in (t['equipos'] as List? ?? const [])) {
      if (e is! Map<String, dynamic>) continue;
      filas.add(ResultadoRemoto(
        tanda: numero,
        nombre: (e['nombre'] ?? '').toString(),
        posicion: (e['posicion'] as num?)?.toInt() ?? 0,
        vueltas: (e['vueltas'] as num?)?.toInt(),
        mejorVueltaMs: (e['mejor_vuelta_ms'] as num?)?.toInt(),
      ));
    }
  }
  return ResultadosRemotos(
    raceName: ((j['race'] as Map?)?['name'] ?? '').toString(),
    filas: filas,
  );
}
