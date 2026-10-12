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
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/idioma.dart';
import 'almacen_local.dart';

/// Idiomas disponibles para exportar PDFs.
enum IdiomaExport { es, ca, en, it, fr }

extension IdiomaExportX on IdiomaExport {
  String get etiqueta => const {
        IdiomaExport.es: 'Español',
        IdiomaExport.ca: 'Català',
        IdiomaExport.en: 'English',
        IdiomaExport.it: 'Italiano',
        IdiomaExport.fr: 'Français',
      }[this]!;

  /// Locale para intl (formato de fechas).
  String get intlLocale => const {
        IdiomaExport.es: 'es_ES',
        IdiomaExport.ca: 'ca_ES',
        IdiomaExport.en: 'en_US',
        IdiomaExport.it: 'it_IT',
        IdiomaExport.fr: 'fr_FR',
      }[this]!;
}

/// Traducción de una etiqueta de PDF. La clave es el texto en español.
/// Listas en orden [es, ca, en, it, fr].
String tr(IdiomaExport idioma, String clave) {
  final l = _textos[clave];
  if (l == null) return clave;
  return l[idioma.index];
}

const Map<String, List<String>> _textos = {
  // Comunes
  'Con el apoyo de': ['Con el apoyo de', 'Amb el suport de', 'With the support of', 'Con il supporto di', 'Avec le soutien de'],
  'pilotos': ['pilotos', 'pilots', 'drivers', 'piloti', 'pilotes'],
  'equipos': ['equipos', 'equips', 'teams', 'squadre', 'équipes'],
  'Organiza': ['Organiza', 'Organitza', 'Organised by', 'Organizza', 'Organisé par'],
  // Verificaciones
  'Verificación': ['Verificación', 'Verificació', 'Scrutineering', 'Verifica', 'Vérification'],
  'Ficha': ['Ficha', 'Fitxa', 'Sheet', 'Scheda', 'Fiche'],
  'VALIDADA': ['VALIDADA', 'VALIDADA', 'VALIDATED', 'VALIDATA', 'VALIDÉE'],
  'BORRADOR': ['BORRADOR', 'ESBORRANY', 'DRAFT', 'BOZZA', 'BROUILLON'],
  'COPA': ['COPA', 'COPA', 'CUP', 'COPPA', 'COUPE'],
  'OBSERVACIONES': ['OBSERVACIONES', 'OBSERVACIONS', 'NOTES', 'NOTE', 'REMARQUES'],
  'Peso carrocería': ['Peso carrocería', 'Pes carrosseria', 'Body weight', 'Peso carrozzeria', 'Poids carrosserie'],
  'Peso coche entero': ['Peso coche entero', 'Pes cotxe sencer', 'Full car weight', 'Peso auto completo', 'Poids voiture entière'],
  'Motor': ['Motor', 'Motor', 'Motor', 'Motore', 'Moteur'],
  'Altura motor': ['Altura motor', 'Alçada motor', 'Motor height', 'Altezza motore', 'Hauteur moteur'],
  'Anchura eje delantero': ['Anchura eje delantero', 'Amplada eix davanter', 'Front axle width', 'Larghezza asse anteriore', 'Largeur essieu avant'],
  'Anchura eje trasero': ['Anchura eje trasero', 'Amplada eix posterior', 'Rear axle width', 'Larghezza asse posteriore', 'Largeur essieu arrière'],
  'Conforme': ['Conforme', 'Conforme', 'Compliant', 'Conforme', 'Conforme'],
  'No conforme': ['No conforme', 'No conforme', 'Non-compliant', 'Non conforme', 'Non conforme'],
  'Carrocería': ['Carrocería', 'Carrosseria', 'Bodywork', 'Carrozzeria', 'Carrosserie'],
  'Bien': ['Bien', 'Bé', 'Good', 'Buono', 'Bon'],
  'Faltan piezas': ['Faltan piezas', 'Falten peces', 'Missing parts', 'Pezzi mancanti', 'Pièces manquantes'],
  'Piñón': ['Piñón', 'Pinyó', 'Pinion', 'Pignone', 'Pignon'],
  'Corona': ['Corona', 'Corona', 'Crown', 'Corona', 'Couronne'],
  'Llanta delantera': ['Llanta delantera', 'Llanda davantera', 'Front rim', 'Cerchio anteriore', 'Jante avant'],
  'Llanta trasera': ['Llanta trasera', 'Llanda posterior', 'Rear rim', 'Cerchio posteriore', 'Jante arrière'],
  'Trencilla': ['Trencilla', 'Trena', 'Braid', 'Trecciola', 'Tresse'],
  'Suspensión': ['Suspensión', 'Suspensió', 'Suspension', 'Sospensione', 'Suspension'],
  'Bancada': ['Bancada', 'Bancada', 'Motor mount', 'Supporto motore', 'Support moteur'],
  'Chasis': ['Chasis', 'Xassís', 'Chassis', 'Telaio', 'Châssis'],
  'Neumático': ['Neumático', 'Pneumàtic', 'Tyre', 'Pneumatico', 'Pneu'],
  'dientes': ['dientes', 'dents', 'teeth', 'denti', 'dents'],
  'Propio': ['Propio', 'Propi', 'Own', 'Proprio', 'Personnel'],
  'Organización': ['Organización', 'Organització', 'Organization', 'Organizzazione', 'Organisation'],
  'inicio': ['inicio', 'inici', 'start', 'inizio', 'début'],
  'fin': ['fin', 'fi', 'end', 'fine', 'fin'],
  // Clasificación
  'CLASIFICACIÓN GENERAL': ['CLASIFICACIÓN GENERAL', 'CLASSIFICACIÓ GENERAL', 'OVERALL STANDINGS', 'CLASSIFICA GENERALE', 'CLASSEMENT GÉNÉRAL'],
  'CLASIFICACIÓN · COPA': ['CLASIFICACIÓN · COPA', 'CLASSIFICACIÓ · COPA', 'STANDINGS · CUP', 'CLASSIFICA · COPPA', 'CLASSEMENT · COUPE'],
  'PILOTO': ['PILOTO', 'PILOT', 'DRIVER', 'PILOTA', 'PILOTE'],
  'EQUIPO': ['EQUIPO', 'EQUIP', 'TEAM', 'SQUADRA', 'ÉQUIPE'],
  'CAT.': ['CAT.', 'CAT.', 'CAT.', 'CAT.', 'CAT.'],
  'BRUTO': ['BRUTO', 'BRUT', 'GROSS', 'LORDO', 'BRUT'],
  'DESC.': ['DESC.', 'DESC.', 'DROP', 'SCARTO', 'RETR.'],
  'TOTAL': ['TOTAL', 'TOTAL', 'TOTAL', 'TOTALE', 'TOTAL'],
  'Tachado en rojo = resultado descartado': ['Tachado en rojo = resultado descartado', 'Ratllat en vermell = resultat descartat', 'Struck through in red = dropped result', 'Barrato in rosso = risultato scartato', 'Barré en rouge = résultat écarté'],
  // Tandas (grupo de pilotos que corre junto; cada tanda tiene sus mangas)
  'Tandas': ['Tandas', 'Tandes', 'Rounds', 'Batterie', 'Séries'],
  'PILOTOS': ['PILOTOS', 'PILOTS', 'DRIVERS', 'PILOTI', 'PILOTES'],
  'PUNTOS': ['PUNTOS', 'PUNTS', 'POINTS', 'PUNTI', 'POINTS'],
  'CARRIL': ['CARRIL', 'CARRIL', 'LANE', 'CORSIA', 'COULOIR'],
  'Pisters: pilotos de': ['Pisters: pilotos de', 'Pisters: pilots de', 'Marshals: drivers from', 'Commissari: piloti di', 'Commissaires : pilotes de'],
  // Créditos
  'Control de créditos': ['Control de créditos', 'Control de crèdits', 'Credit control', 'Controllo crediti', 'Contrôle des crédits'],
  'INICIAL': ['INICIAL', 'INICIAL', 'INITIAL', 'INIZIALE', 'INITIAL'],
  'SUMADOS': ['SUMADOS', 'SUMATS', 'ADDED', 'AGGIUNTI', 'AJOUTÉS'],
  'RESTADOS': ['RESTADOS', 'RESTATS', 'SUBTRACTED', 'SOTTRATTI', 'SOUSTRAITS'],
  'SALDO': ['SALDO', 'SALDO', 'BALANCE', 'SALDO', 'SOLDE'],
};

// ============================================================
// Marca por defecto de los PDF cuando el campeonato no define la suya.
// La marca es propia de cada campeonato (título de cabecera y lema del pie);
// se configura en el editor de campeonato.
// ============================================================

const marcaTituloPorDefecto = 'PITWALL';
const marcaLemaPorDefecto = 'PitWall Control · gestión de campeonatos de slot';
const _kIdioma = 'export_idioma';

/// Último idioma usado al exportar (se recuerda entre exportaciones).
/// Sin elegir todavía, se propone el idioma de la app.
class IdiomaExportNotifier extends Notifier<IdiomaExport> {
  @override
  IdiomaExport build() {
    final c = ref.read(almacenSyncProvider).readSync(key: _kIdioma);
    final guardado =
        IdiomaExport.values.where((e) => e.name == c).firstOrNull;
    if (guardado != null) return guardado;
    final locale = ref.read(idiomaProvider) ??
        resolverIdioma(
            PlatformDispatcher.instance.locale, Textos.supportedLocales);
    return IdiomaExport.values
            .where((e) => e.name == locale.languageCode)
            .firstOrNull ??
        IdiomaExport.es;
  }

  Future<void> set(IdiomaExport i) async {
    await ref.read(almacenSyncProvider).write(key: _kIdioma, value: i.name);
    state = i;
  }
}

final idiomaExportProvider =
    NotifierProvider<IdiomaExportNotifier, IdiomaExport>(
        IdiomaExportNotifier.new);
