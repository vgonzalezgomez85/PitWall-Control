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

/// The translations for English (`en`).
class TextosEn extends Textos {
  TextosEn([String locale = 'en']) : super(locale);

  @override
  String get menuInicio => 'Home';

  @override
  String get menuPruebas => 'Races';

  @override
  String get menuParticipantes => 'Participants';

  @override
  String get menuClasificacion => 'Standings';

  @override
  String get menuTesoreria => 'Treasury';

  @override
  String get menuCreditos => 'Credits';

  @override
  String get menuVerificacionLibre => 'Free scrutineering';

  @override
  String get menuCatalogos => 'Catalogues';

  @override
  String get menuGestionarCampeonatos => 'Manage championships';

  @override
  String get menuAjustes => 'Settings';

  @override
  String get menuMas => 'More';

  @override
  String get grupoCampeonato => 'CHAMPIONSHIP';

  @override
  String get grupoHerramientas => 'TOOLS';

  @override
  String get grupoCampeonatoActivo => 'ACTIVE CHAMPIONSHIP';

  @override
  String get campeonatoActivo => 'Active championship';

  @override
  String get gestionarCampeonatosPuntos => 'Manage championships…';

  @override
  String tooltipCampeonato(String nombre) {
    return 'Championship: $nombre';
  }

  @override
  String errorDetalle(String detalle) {
    return 'Error: $detalle';
  }

  @override
  String get vacioTitulo => 'No championships yet';

  @override
  String get vacioTexto =>
      'Create your first championship to start managing races and results.';

  @override
  String get crearCampeonato => 'Create championship';

  @override
  String get soloVerificarCoches => 'Just scrutineer cars';

  @override
  String get ajustesYCopias => 'Settings and backups';

  @override
  String get masOpciones => 'More options';

  @override
  String get statPilotos => 'drivers';

  @override
  String get statEquipos => 'teams';

  @override
  String get statPruebas => 'races';

  @override
  String get pendientes => 'To do';

  @override
  String get proximaPrueba => 'Next race';

  @override
  String get noHayPruebasPendientes => 'No upcoming races';

  @override
  String get botonInscritos => 'Entries';

  @override
  String get botonVerificar => 'Scrutineer';

  @override
  String get botonResultados => 'Results';

  @override
  String pendVerificaciones(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'checks not validated',
      one: 'check not validated',
    );
    return '$_temp0';
  }

  @override
  String pendPagos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'fees not collected',
      one: 'fee not collected',
    );
    return '$_temp0';
  }

  @override
  String pendSinResultados(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'past races without results',
      one: 'past race without results',
    );
    return '$_temp0';
  }

  @override
  String get todoAlDia => 'All up to date';

  @override
  String get todoAlDiaSinPruebas =>
      'No upcoming races and no results to enter.';

  @override
  String todoAlDiaEnPrueba(String prueba) {
    return 'No checks or payments pending for $prueba.';
  }

  @override
  String get liderCampeonato => 'Championship leader';

  @override
  String get sinResultadosTodavia => 'No results yet';

  @override
  String puntosAbrev(int puntos) {
    return '$puntos pts';
  }

  @override
  String get seccionDatos => 'Data';

  @override
  String get copiasSeguridad => 'Backups';

  @override
  String get copiasSeguridadSub =>
      'Upload or restore the Drive backup, or restore from a file';

  @override
  String get googleSheetsDrive => 'Google (Sheets and Drive)';

  @override
  String get googleSub =>
      'Connect the account and the Google Cloud credentials';

  @override
  String get plantillasCsv => 'CSV templates';

  @override
  String get plantillasCsvSub => 'Download templates to import drivers, teams…';

  @override
  String get seccionApariencia => 'Appearance';

  @override
  String get modoOscuro => 'Dark mode';

  @override
  String get idioma => 'Language';

  @override
  String get idiomaAutomatico => 'Automatic (system language)';

  @override
  String get seccionAcercaDe => 'About';

  @override
  String get novedades => 'What\'s new';

  @override
  String get historialVersiones => 'Version history';

  @override
  String versionHistorial(String version) {
    return 'Version $version · version history';
  }

  @override
  String get actualizaciones => 'Updates';

  @override
  String get actualizacionesSub => 'Check for a new version and download it';

  @override
  String get actDescargaIncompleta =>
      'The download did not complete. Please try again.';

  @override
  String get actDescargaAtascada => 'The download got stuck. Please try again.';

  @override
  String get actNoSePudoDescargar =>
      'The update could not be downloaded. Try again or download it from pitwall.es.';

  @override
  String actHayVersionNueva(String version) {
    return 'A new version is available: v$version';
  }

  @override
  String get actDescargaNueva =>
      'Download the new version to get the latest improvements.';

  @override
  String get cancelar => 'Cancel';

  @override
  String get masTarde => 'Later';

  @override
  String get actPermisoAndroid =>
      'The first time, Android will ask for permission to install apps from this source. Then tap \"Update\" again.';

  @override
  String get actSeAbriraNavegador =>
      'Your browser will open to download the installer for this version.';

  @override
  String get actActualizar => 'Update';

  @override
  String get actDescargar => 'Download';

  @override
  String get actDescargando => 'Downloading…';

  @override
  String actDescargandoPct(int pct) {
    return 'Downloading… $pct%';
  }
}
