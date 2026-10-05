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

// Importación de participantes a una sesión de verificación libre desde una
// tabla (CSV, Excel o pestaña de Google Sheets ya leída como filas).

import '../equipos/importador_equipos.dart';

/// Columnas de la tabla que se usan. Solo el piloto 1 es obligatorio.
class MapeoParticipantes {
  String? colPiloto1;
  String? colPiloto2;
  String? colEquipo;
  String? colCopa;

  bool get esValido => colPiloto1 != null;
}

/// Una fila de la tabla ya interpretada.
class ParticipanteImportado {
  ParticipanteImportado({
    required this.piloto1,
    this.piloto2,
    this.equipo,
    this.copaOriginal,
    required this.copa,
    required this.estado,
    this.aviso,
  }) : importar = estado == 'nuevo';

  final String piloto1;
  final String? piloto2;
  final String? equipo;

  /// Copa tal cual venía en la tabla (null si no había columna o celda).
  final String? copaOriginal;

  /// Copa de la sesión que se le asignará.
  final String copa;

  /// 'nuevo' | 'duplicado' (ya en la sesión o repetido en la tabla).
  final String estado;
  final String? aviso;
  bool importar;

  /// Nombre con el que quedará el equipo (mismo criterio que el alta manual).
  String get nombreEquipo => nombreEquipoParticipante(piloto1, piloto2, equipo);
}

/// Equipo indicado o, si no hay, "Piloto 1 / Piloto 2".
String nombreEquipoParticipante(String piloto1, String? piloto2, String? equipo) {
  final eq = equipo?.trim() ?? '';
  if (eq.isNotEmpty) return eq;
  final p2 = piloto2?.trim() ?? '';
  return [piloto1.trim(), if (p2.isNotEmpty) p2].join(' / ');
}

class ImportadorParticipantes {
  /// Adivina las columnas por su cabecera. El piloto 2 se busca antes que el
  /// 1 para que "Piloto 2" no se tome como el piloto genérico.
  static MapeoParticipantes detectarMapeo(List<String> columnas) {
    final m = MapeoParticipantes();
    bool es(String n, List<String> alts) =>
        ImportadorEquipos.coincideCabecera(n, alts);
    final libres = <String>[];
    for (final col in columnas) {
      final n = ImportadorEquipos.normalizarCabecera(col);
      if (m.colPiloto2 == null &&
          es(n, ['piloto 2', 'piloto2', 'p2', 'piloto b', 'pilot 2',
                 'driver 2', 'segundo piloto', 'copiloto'])) {
        m.colPiloto2 = col;
      } else if (m.colPiloto1 == null &&
          es(n, ['piloto 1', 'piloto1', 'p1', 'piloto a', 'pilot 1',
                 'driver 1'])) {
        m.colPiloto1 = col;
      } else if (m.colEquipo == null &&
          es(n, ['equipo', 'team', 'escuderia', 'nombre equipo'])) {
        m.colEquipo = col;
      } else if (m.colCopa == null &&
          es(n, ['copa', 'categoria', 'clase', 'class'])) {
        m.colCopa = col;
      } else {
        libres.add(col);
      }
    }
    // Sin "Piloto 1" explícito: la columna genérica de nombre de piloto.
    if (m.colPiloto1 == null) {
      for (final col in libres) {
        final n = ImportadorEquipos.normalizarCabecera(col);
        if (es(n, ['piloto', 'pilot', 'driver', 'nombre', 'participante',
                   'nombre y apellidos'])) {
          m.colPiloto1 = col;
          break;
        }
      }
    }
    // Tabla de una sola columna: es la lista de pilotos.
    if (m.colPiloto1 == null && columnas.length == 1) {
      m.colPiloto1 = columnas.first;
    }
    return m;
  }

  /// Interpreta las filas. [copasSesion] son las copas válidas; una copa
  /// vacía o que no está en la sesión pasa a [copaPorDefecto] (con aviso si
  /// venía rellena). [equiposEnSesion] son los nombres de equipo ya
  /// inscritos, para marcar duplicados.
  static List<ParticipanteImportado> transformar(
    List<Map<String, String>> filas,
    MapeoParticipantes m, {
    required List<String> copasSesion,
    required String copaPorDefecto,
    required Iterable<String> equiposEnSesion,
  }) {
    String? celda(Map<String, String> f, String? col) {
      if (col == null) return null;
      final v = f[col]?.trim() ?? '';
      return v.isEmpty ? null : v;
    }

    final vistos = equiposEnSesion.map(_clave).toSet();
    final out = <ParticipanteImportado>[];
    for (final f in filas) {
      final p1 = celda(f, m.colPiloto1);
      if (p1 == null) continue; // fila sin piloto: nada que importar
      final p2 = celda(f, m.colPiloto2);
      final eq = celda(f, m.colEquipo);
      final copaTabla = celda(f, m.colCopa);
      final copaSesion = copaTabla == null
          ? null
          : copasSesion
              .where((c) => _normCopa(c) == _normCopa(copaTabla))
              .firstOrNull;
      final nombre = nombreEquipoParticipante(p1, p2, eq);
      final duplicado = !vistos.add(_clave(nombre));
      out.add(ParticipanteImportado(
        piloto1: p1,
        piloto2: p2,
        equipo: eq,
        copaOriginal: copaTabla,
        copa: copaSesion ?? copaPorDefecto,
        estado: duplicado ? 'duplicado' : 'nuevo',
        aviso: duplicado
            ? 'Ya está en la sesión'
            : (copaTabla != null && copaSesion == null)
                ? 'Copa "$copaTabla" no está en la sesión: se usa $copaPorDefecto'
                : null,
      ));
    }
    return out;
  }

  static String _clave(String nombre) => nombre.trim().toLowerCase();

  /// Igual que en el catálogo: "LMP-2", "LMP 2" y "lmp2" son la misma copa.
  static String _normCopa(String s) =>
      s.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9ÁÉÍÓÚÜÑ]'), '');
}
