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
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/generado/textos.dart';
import '../services/almacen_local.dart';

export '../l10n/generado/textos.dart' show Textos, lookupTextos;

/// Idiomas de la app, con su nombre en ese mismo idioma (así se reconocen en
/// el selector aunque la app esté en otro).
const idiomasApp = <(String codigo, String nombre)>[
  ('es', 'Español'),
  ('ca', 'Català'),
  ('en', 'English'),
  ('fr', 'Français'),
  ('it', 'Italiano'),
];

/// Idioma elegido en Ajustes; null = «Automático», el del sistema (si la
/// app lo tiene; si no, español). Se guarda como el modo oscuro.
///
/// Sin elección guardada se sigue el idioma del sistema: la traducción ya
/// está completa (a falta de los PDF), así que es lo natural para quien
/// tiene el Mac o el móvil en otro idioma.
class IdiomaNotifier extends Notifier<Locale?> {
  static const _clave = 'idioma_app';
  static const _automatico = 'auto';

  @override
  Locale? build() {
    final c = ref.read(almacenSyncProvider).readSync(key: _clave);
    if (c == null || c == _automatico || c.isEmpty) return null;
    return Locale(c);
  }

  Future<void> elegir(String? codigo) async {
    state = codigo == null ? null : Locale(codigo);
    await ref
        .read(almacenSyncProvider)
        .write(key: _clave, value: codigo ?? _automatico);
  }
}

final idiomaProvider =
    NotifierProvider<IdiomaNotifier, Locale?>(IdiomaNotifier.new);

/// Si el sistema está en un idioma que la app no tiene, español.
Locale resolverIdioma(Locale? sistema, Iterable<Locale> soportados) {
  for (final l in soportados) {
    if (l.languageCode == sistema?.languageCode) return l;
  }
  return const Locale('es');
}

/// Textos en español, para código sin contexto (exportaciones de PDF y Excel,
/// que llevan su propio diccionario — ver `exportar_config.dart`).
Textos get textosEspanol => lookupTextos(const Locale('es'));

/// Textos traducidos: `context.l.menuInicio`. Sin traducciones cargadas (p.
/// ej. un widget de test sin delegados) devuelve los de español.
extension TextosEnContexto on BuildContext {
  Textos get l => Textos.of(this) ?? lookupTextos(const Locale('es'));

  /// Código de idioma activo, para formatos de fecha (`DateFormat`).
  String get idiomaFechas => Localizations.maybeLocaleOf(this)?.languageCode ?? 'es';
}
