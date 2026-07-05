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

import 'almacen_local.dart';

/// Idiomas disponibles para exportar PDFs.
enum IdiomaExport { es, en, it, fr }

extension IdiomaExportX on IdiomaExport {
  String get etiqueta => const {
        IdiomaExport.es: 'Español',
        IdiomaExport.en: 'English',
        IdiomaExport.it: 'Italiano',
        IdiomaExport.fr: 'Français',
      }[this]!;

  /// Locale para intl (formato de fechas).
  String get intlLocale => const {
        IdiomaExport.es: 'es_ES',
        IdiomaExport.en: 'en_US',
        IdiomaExport.it: 'it_IT',
        IdiomaExport.fr: 'fr_FR',
      }[this]!;
}

/// Traducción de una etiqueta de PDF. La clave es el texto en español.
/// Listas en orden [es, en, it, fr].
String tr(IdiomaExport idioma, String clave) {
  final l = _textos[clave];
  if (l == null) return clave;
  return l[idioma.index];
}

const Map<String, List<String>> _textos = {
  // Comunes
  'Con el apoyo de': ['Con el apoyo de', 'With the support of', 'Con il supporto di', 'Avec le soutien de'],
  'pilotos': ['pilotos', 'drivers', 'piloti', 'pilotes'],
  'equipos': ['equipos', 'teams', 'squadre', 'équipes'],
  // Verificaciones
  'Verificación': ['Verificación', 'Scrutineering', 'Verifica', 'Vérification'],
  'Ficha': ['Ficha', 'Sheet', 'Scheda', 'Fiche'],
  'VALIDADA': ['VALIDADA', 'VALIDATED', 'VALIDATA', 'VALIDÉE'],
  'BORRADOR': ['BORRADOR', 'DRAFT', 'BOZZA', 'BROUILLON'],
  'COPA': ['COPA', 'CUP', 'COPPA', 'COUPE'],
  'OBSERVACIONES': ['OBSERVACIONES', 'NOTES', 'NOTE', 'REMARQUES'],
  'Peso carrocería': ['Peso carrocería', 'Body weight', 'Peso carrozzeria', 'Poids carrosserie'],
  'Peso coche entero': ['Peso coche entero', 'Full car weight', 'Peso auto completo', 'Poids voiture entière'],
  'Motor': ['Motor', 'Motor', 'Motore', 'Moteur'],
  'Piñón': ['Piñón', 'Pinion', 'Pignone', 'Pignon'],
  'Corona': ['Corona', 'Crown', 'Corona', 'Couronne'],
  'Llanta delantera': ['Llanta delantera', 'Front rim', 'Cerchio anteriore', 'Jante avant'],
  'Llanta trasera': ['Llanta trasera', 'Rear rim', 'Cerchio posteriore', 'Jante arrière'],
  'Trencilla': ['Trencilla', 'Braid', 'Trecciola', 'Tresse'],
  'Suspensión': ['Suspensión', 'Suspension', 'Sospensione', 'Suspension'],
  'Bancada': ['Bancada', 'Motor mount', 'Supporto motore', 'Support moteur'],
  'Chasis': ['Chasis', 'Chassis', 'Telaio', 'Châssis'],
  'Neumático': ['Neumático', 'Tyre', 'Pneumatico', 'Pneu'],
  'dientes': ['dientes', 'teeth', 'denti', 'dents'],
  'Propio': ['Propio', 'Own', 'Proprio', 'Personnel'],
  'Organización': ['Organización', 'Organization', 'Organizzazione', 'Organisation'],
  'inicio': ['inicio', 'start', 'inizio', 'début'],
  'fin': ['fin', 'end', 'fine', 'fin'],
  // Clasificación
  'CLASIFICACIÓN GENERAL': ['CLASIFICACIÓN GENERAL', 'OVERALL STANDINGS', 'CLASSIFICA GENERALE', 'CLASSEMENT GÉNÉRAL'],
  'CLASIFICACIÓN · COPA': ['CLASIFICACIÓN · COPA', 'STANDINGS · CUP', 'CLASSIFICA · COPPA', 'CLASSEMENT · COUPE'],
  'PILOTO': ['PILOTO', 'DRIVER', 'PILOTA', 'PILOTE'],
  'EQUIPO': ['EQUIPO', 'TEAM', 'SQUADRA', 'ÉQUIPE'],
  'CAT.': ['CAT.', 'CAT.', 'CAT.', 'CAT.'],
  'BRUTO': ['BRUTO', 'GROSS', 'LORDO', 'BRUT'],
  'DESC.': ['DESC.', 'DROP', 'SCARTO', 'RETR.'],
  'TOTAL': ['TOTAL', 'TOTAL', 'TOTALE', 'TOTAL'],
  'Tachado en rojo = resultado descartado': [
    'Tachado en rojo = resultado descartado',
    'Struck through in red = dropped result',
    'Barrato in rosso = risultato scartato',
    'Barré en rouge = résultat écarté',
  ],
  // Mangas
  'Mangas': ['Mangas', 'Heats', 'Manche', 'Manches'],
  'PILOTOS': ['PILOTOS', 'DRIVERS', 'PILOTI', 'PILOTES'],
  'PUNTOS': ['PUNTOS', 'POINTS', 'PUNTI', 'POINTS'],
  'CARRIL': ['CARRIL', 'LANE', 'CORSIA', 'COULOIR'],
  // Créditos
  'Control de créditos': ['Control de créditos', 'Credit control', 'Controllo crediti', 'Contrôle des crédits'],
  'INICIAL': ['INICIAL', 'INITIAL', 'INIZIALE', 'INITIAL'],
  'SUMADOS': ['SUMADOS', 'ADDED', 'AGGIUNTI', 'AJOUTÉS'],
  'RESTADOS': ['RESTADOS', 'SUBTRACTED', 'SOTTRATTI', 'SOUSTRAITS'],
  'SALDO': ['SALDO', 'BALANCE', 'SALDO', 'SOLDE'],
};

// ============================================================
// Branding global de los PDF (título de cabecera y lema del pie).
// ============================================================

class MarcaConfig {
  final String titulo;
  final String lema;
  const MarcaConfig(this.titulo, this.lema);
}

const _defTitulo = 'RESISBARNA';
const _defLema = 'RESISBARNA · resistencias de slot en Barcelona';
const _kTitulo = 'marca_titulo';
const _kLema = 'marca_lema';
const _kIdioma = 'export_idioma';

class MarcaConfigNotifier extends Notifier<MarcaConfig> {
  @override
  MarcaConfig build() {
    final a = ref.read(almacenSyncProvider);
    return MarcaConfig(
      a.readSync(key: _kTitulo) ?? _defTitulo,
      a.readSync(key: _kLema) ?? _defLema,
    );
  }

  Future<void> guardar(String titulo, String lema) async {
    final a = ref.read(almacenSyncProvider);
    await a.write(key: _kTitulo, value: titulo);
    await a.write(key: _kLema, value: lema);
    state = MarcaConfig(titulo, lema);
  }
}

final marcaConfigProvider =
    NotifierProvider<MarcaConfigNotifier, MarcaConfig>(MarcaConfigNotifier.new);

/// Último idioma usado al exportar (se recuerda entre exportaciones).
class IdiomaExportNotifier extends Notifier<IdiomaExport> {
  @override
  IdiomaExport build() {
    final c = ref.read(almacenSyncProvider).readSync(key: _kIdioma);
    return IdiomaExport.values
        .firstWhere((e) => e.name == c, orElse: () => IdiomaExport.es);
  }

  Future<void> set(IdiomaExport i) async {
    await ref.read(almacenSyncProvider).write(key: _kIdioma, value: i.name);
    state = i;
  }
}

final idiomaExportProvider =
    NotifierProvider<IdiomaExportNotifier, IdiomaExport>(
        IdiomaExportNotifier.new);
