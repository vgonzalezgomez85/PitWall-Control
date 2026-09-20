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
import 'package:flutter/services.dart' show rootBundle;

/// Historial de versiones: parsea `CHANGELOG.md` (empaquetado como asset) y
/// lo muestra en la pantalla "Novedades". Mismo formato/convención que en
/// PitWall Manager: `## [X.Y.Z] — fecha`, `### Sección`, líneas `- item`.

class SeccionCambios {
  final String titulo;
  final List<String> items;
  const SeccionCambios(this.titulo, this.items);
}

class VersionCambios {
  final String version;
  final String fecha;
  final List<String> notas;
  final List<SeccionCambios> secciones;
  const VersionCambios({
    required this.version,
    required this.fecha,
    required this.notas,
    required this.secciones,
  });
}

/// Convierte **negrita** en segmentos con `esNegrita`, para pintarlos en
/// negrita sin depender de un motor de markdown completo.
class SegmentoTexto {
  final String texto;
  final bool esNegrita;
  const SegmentoTexto(this.texto, this.esNegrita);
}

List<SegmentoTexto> segmentar(String texto) {
  final out = <SegmentoTexto>[];
  final re = RegExp(r'\*\*([^*]+)\*\*');
  var pos = 0;
  for (final m in re.allMatches(texto)) {
    if (m.start > pos) out.add(SegmentoTexto(texto.substring(pos, m.start), false));
    out.add(SegmentoTexto(m.group(1)!, true));
    pos = m.end;
  }
  if (pos < texto.length) out.add(SegmentoTexto(texto.substring(pos), false));
  return out;
}

List<VersionCambios> parseChangelog(String md) {
  final versiones = <VersionCambios>[];
  String? version, fecha;
  List<String> notas = [];
  List<SeccionCambios> secciones = [];
  List<String>? itemsActuales;

  void cerrarVersion() {
    if (version != null) {
      versiones.add(VersionCambios(
        version: version,
        fecha: fecha ?? '',
        notas: notas,
        secciones: secciones,
      ));
    }
  }

  final reVersion = RegExp(r'^##\s+\[([^\]]+)\]\s*(?:—|-)?\s*(.*)$');
  final reSeccion = RegExp(r'^###\s+(.+)$');
  final reItem = RegExp(r'^-\s+(.+)$');

  for (final raw in md.split(RegExp(r'\r?\n'))) {
    final line = raw.trimRight();
    final mv = reVersion.firstMatch(line);
    if (mv != null) {
      cerrarVersion();
      version = mv.group(1);
      fecha = mv.group(2)?.trim();
      notas = [];
      secciones = [];
      itemsActuales = null;
      continue;
    }
    if (version == null) continue; // antes de la primera versión: cabecera del fichero
    final ms = reSeccion.firstMatch(line);
    if (ms != null) {
      itemsActuales = <String>[];
      secciones.add(SeccionCambios(ms.group(1)!.trim(), itemsActuales));
      continue;
    }
    final mi = reItem.firstMatch(line);
    if (mi != null) {
      (itemsActuales ?? notas).add(mi.group(1)!);
      continue;
    }
    if (itemsActuales == null &&
        line.isNotEmpty &&
        !line.startsWith('#') &&
        line != '---') {
      notas.add(line);
    }
  }
  cerrarVersion();
  return versiones;
}

/// Carga y parsea `CHANGELOG.md` desde los assets de la app.
Future<List<VersionCambios>> cargarChangelog() async {
  final md = await rootBundle.loadString('CHANGELOG.md');
  return parseChangelog(md);
}
