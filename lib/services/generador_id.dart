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
/// Calcula el máximo id numérico visto entre las cadenas dadas (ids ya
/// usados, tanto locales como los que ya haya en la hoja). Los valores no
/// numéricos o vacíos se ignoran.
int maxIdExterno(Iterable<String?> idsConocidos) {
  var max = 0;
  for (final id in idsConocidos) {
    final n = int.tryParse((id ?? '').trim());
    if (n != null && n > max) max = n;
  }
  return max;
}

