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
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/proveedores.dart';

/// Campos de la verificación cuyos desplegables se ordenan por uso, con su
/// columna en la tabla `verificaciones`.
const _columnasPorCampo = {
  'coche': 'coche_catalogo_id',
  'motor': 'motor',
  'pinonMarca': 'pinon_marca',
  'pinonDientes': 'pinon_dientes',
  'pinonMaterial': 'pinon_material',
  'coronaMarca': 'corona_marca',
  'coronaDientes': 'corona_dientes',
  'coronaMaterial': 'corona_material',
  'llantaDelMarca': 'llanta_del_marca',
  'llantaDelDimension': 'llanta_del_dimension',
  'llantaTraMarca': 'llanta_tra_marca',
  'llantaTraDimension': 'llanta_tra_dimension',
  'trencilla': 'trencilla',
  'bancada': 'bancada',
  'chasis': 'chasis',
  'neumatico': 'neumatico',
};

/// Veces que se ha elegido cada valor, por campo, en TODAS las verificaciones
/// guardadas (de cualquier campeonato). `campo → valor → veces`; los valores
/// numéricos (id de coche, dientes) van como texto.
class FrecuenciasVerificacion {
  const FrecuenciasVerificacion(this._porCampo);
  static const vacia = FrecuenciasVerificacion({});

  final Map<String, Map<String, int>> _porCampo;

  int veces(String campo, Object valor) =>
      _porCampo[campo]?['$valor'] ?? 0;

  /// [opciones] ordenadas de más a menos usadas. A igualdad de uso (incluidas
  /// las nunca usadas) se respeta el orden original de la lista.
  List<T> ordenar<T>(String campo, Iterable<T> opciones,
      [Object Function(T)? clave]) {
    final lista = opciones.toList();
    final usos = _porCampo[campo];
    if (usos == null || usos.isEmpty) return lista;
    final k = clave ?? (T o) => o as Object;
    final indexadas = [
      for (var i = 0; i < lista.length; i++)
        (i: i, o: lista[i], n: usos['${k(lista[i])}'] ?? 0),
    ];
    indexadas.sort((a, b) => a.n != b.n ? b.n - a.n : a.i - b.i);
    return [for (final e in indexadas) e.o];
  }
}

/// Recuentos de uso, en vivo: se recalculan al guardar cualquier verificación.
final frecuenciasVerificacionProvider =
    StreamProvider.autoDispose<FrecuenciasVerificacion>((ref) {
  final db = ref.watch(dbProvider);
  final sql = _columnasPorCampo.entries.map((e) {
    // El campo `motor` solo es un nombre de catálogo con motor propio; con
    // motor de organización guarda el número sorteado.
    final extra = e.key == 'motor' ? " AND motor_tipo = 'PROPIO'" : '';
    return "SELECT '${e.key}' AS campo, CAST(${e.value} AS TEXT) AS valor, "
        'COUNT(*) AS veces FROM verificaciones '
        "WHERE ${e.value} IS NOT NULL AND ${e.value} != ''$extra "
        'GROUP BY ${e.value}';
  }).join(' UNION ALL ');
  return db
      .customSelect(sql, readsFrom: {db.verificaciones})
      .watch()
      .map((filas) {
    final porCampo = <String, Map<String, int>>{};
    for (final f in filas) {
      (porCampo[f.read<String>('campo')] ??= {})[f.read<String>('valor')] =
          f.read<int>('veces');
    }
    return FrecuenciasVerificacion(porCampo);
  });
});
