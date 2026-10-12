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

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'textos.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class TextosFr extends Textos {
  TextosFr([String locale = 'fr']) : super(locale);

  @override
  String get menuInicio => 'Accueil';

  @override
  String get menuPruebas => 'Épreuves';

  @override
  String get menuParticipantes => 'Participants';

  @override
  String get menuClasificacion => 'Classement';

  @override
  String get menuTesoreria => 'Trésorerie';

  @override
  String get menuCreditos => 'Crédits';

  @override
  String get menuVerificacionLibre => 'Vérification libre';

  @override
  String get menuCatalogos => 'Catalogues';

  @override
  String get menuGestionarCampeonatos => 'Gérer les championnats';

  @override
  String get menuAjustes => 'Réglages';

  @override
  String get menuMas => 'Plus';

  @override
  String get grupoCampeonato => 'CHAMPIONNAT';

  @override
  String get grupoHerramientas => 'OUTILS';

  @override
  String get grupoCampeonatoActivo => 'CHAMPIONNAT ACTIF';

  @override
  String get campeonatoActivo => 'Championnat actif';

  @override
  String get gestionarCampeonatosPuntos => 'Gérer les championnats…';

  @override
  String tooltipCampeonato(String nombre) {
    return 'Championnat : $nombre';
  }

  @override
  String errorDetalle(String detalle) {
    return 'Erreur : $detalle';
  }

  @override
  String get vacioTitulo => 'Aucun championnat pour l\'instant';

  @override
  String get vacioTexto =>
      'Créez votre premier championnat pour commencer à gérer les épreuves et les résultats.';

  @override
  String get crearCampeonato => 'Créer un championnat';

  @override
  String get soloVerificarCoches => 'Vérifier des voitures uniquement';

  @override
  String get ajustesYCopias => 'Réglages et sauvegardes';

  @override
  String get masOpciones => 'Plus d\'options';

  @override
  String get statPilotos => 'pilotes';

  @override
  String get statEquipos => 'équipes';

  @override
  String get statPruebas => 'épreuves';

  @override
  String get pendientes => 'À faire';

  @override
  String get proximaPrueba => 'Prochaine épreuve';

  @override
  String get noHayPruebasPendientes => 'Aucune épreuve à venir';

  @override
  String get botonInscritos => 'Inscrits';

  @override
  String get botonVerificar => 'Vérifier';

  @override
  String get botonResultados => 'Résultats';

  @override
  String pendVerificaciones(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'vérifications non validées',
      one: 'vérification non validée',
    );
    return '$_temp0';
  }

  @override
  String pendPagos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'paiements non encaissés',
      one: 'paiement non encaissé',
    );
    return '$_temp0';
  }

  @override
  String pendSinResultados(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'épreuves disputées sans résultats',
      one: 'épreuve disputée sans résultats',
    );
    return '$_temp0';
  }

  @override
  String get todoAlDia => 'Tout est à jour';

  @override
  String get todoAlDiaSinPruebas =>
      'Aucune épreuve à venir ni résultat à saisir.';

  @override
  String todoAlDiaEnPrueba(String prueba) {
    return 'Aucune vérification ni aucun paiement en attente pour $prueba.';
  }

  @override
  String get liderCampeonato => 'Leader du championnat';

  @override
  String get sinResultadosTodavia => 'Pas encore de résultats';

  @override
  String puntosAbrev(int puntos) {
    return '$puntos pts';
  }

  @override
  String get seccionDatos => 'Données';

  @override
  String get copiasSeguridad => 'Sauvegardes';

  @override
  String get copiasSeguridadSub =>
      'Envoyer ou restaurer la sauvegarde Drive, ou restaurer depuis un fichier';

  @override
  String get googleSheetsDrive => 'Google (Sheets et Drive)';

  @override
  String get googleSub =>
      'Connecter le compte et les identifiants Google Cloud';

  @override
  String get plantillasCsv => 'Modèles CSV';

  @override
  String get plantillasCsvSub =>
      'Télécharger des modèles pour importer pilotes, équipes…';

  @override
  String get seccionApariencia => 'Apparence';

  @override
  String get modoOscuro => 'Mode sombre';

  @override
  String get idioma => 'Langue';

  @override
  String get idiomaAutomatico => 'Automatique (langue du système)';

  @override
  String get seccionAcercaDe => 'À propos';

  @override
  String get novedades => 'Nouveautés';

  @override
  String get historialVersiones => 'Historique des versions';

  @override
  String versionHistorial(String version) {
    return 'Version $version · historique des versions';
  }

  @override
  String get actualizaciones => 'Mises à jour';

  @override
  String get actualizacionesSub =>
      'Rechercher une nouvelle version et la télécharger';

  @override
  String get actDescargaIncompleta =>
      'Le téléchargement est incomplet. Réessayez.';

  @override
  String get actDescargaAtascada => 'Le téléchargement est bloqué. Réessayez.';

  @override
  String get actNoSePudoDescargar =>
      'Impossible de télécharger la mise à jour. Réessayez ou téléchargez-la sur pitwall.es.';

  @override
  String actHayVersionNueva(String version) {
    return 'Une nouvelle version est disponible : v$version';
  }

  @override
  String get actDescargaNueva =>
      'Téléchargez la nouvelle version pour profiter des dernières améliorations.';

  @override
  String get cancelar => 'Annuler';

  @override
  String get masTarde => 'Plus tard';

  @override
  String get actPermisoAndroid =>
      'La première fois, Android demandera l\'autorisation d\'installer des applications de cette source. Appuyez ensuite à nouveau sur « Mettre à jour ».';

  @override
  String get actSeAbriraNavegador =>
      'Le navigateur s\'ouvrira pour télécharger le programme d\'installation de cette version.';

  @override
  String get actActualizar => 'Mettre à jour';

  @override
  String get actDescargar => 'Télécharger';

  @override
  String get actDescargando => 'Téléchargement…';

  @override
  String actDescargandoPct(int pct) {
    return 'Téléchargement… $pct %';
  }
}
