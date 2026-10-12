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

/// The translations for Catalan Valencian (`ca`).
class TextosCa extends Textos {
  TextosCa([String locale = 'ca']) : super(locale);

  @override
  String get menuInicio => 'Inici';

  @override
  String get menuPruebas => 'Proves';

  @override
  String get menuParticipantes => 'Participants';

  @override
  String get menuClasificacion => 'Classificació';

  @override
  String get menuTesoreria => 'Tresoreria';

  @override
  String get menuCreditos => 'Crèdits';

  @override
  String get menuVerificacionLibre => 'Verificació lliure';

  @override
  String get menuCatalogos => 'Catàlegs';

  @override
  String get menuGestionarCampeonatos => 'Gestionar campionats';

  @override
  String get menuAjustes => 'Configuració';

  @override
  String get menuMas => 'Més';

  @override
  String get grupoCampeonato => 'CAMPIONAT';

  @override
  String get grupoHerramientas => 'EINES';

  @override
  String get grupoCampeonatoActivo => 'CAMPIONAT ACTIU';

  @override
  String get campeonatoActivo => 'Campionat actiu';

  @override
  String get gestionarCampeonatosPuntos => 'Gestionar campionats…';

  @override
  String tooltipCampeonato(String nombre) {
    return 'Campionat: $nombre';
  }

  @override
  String errorDetalle(String detalle) {
    return 'Error: $detalle';
  }

  @override
  String get vacioTitulo => 'Encara no hi ha campionats';

  @override
  String get vacioTexto =>
      'Crea el primer campionat per començar a gestionar proves i resultats.';

  @override
  String get crearCampeonato => 'Crear campionat';

  @override
  String get soloVerificarCoches => 'Només verificar cotxes';

  @override
  String get ajustesYCopias => 'Configuració i còpies';

  @override
  String get masOpciones => 'Més opcions';

  @override
  String get statPilotos => 'pilots';

  @override
  String get statEquipos => 'equips';

  @override
  String get statPruebas => 'proves';

  @override
  String get pendientes => 'Pendents';

  @override
  String get proximaPrueba => 'Propera prova';

  @override
  String get noHayPruebasPendientes => 'No hi ha proves pendents';

  @override
  String get botonInscritos => 'Inscrits';

  @override
  String get botonVerificar => 'Verificar';

  @override
  String get botonResultados => 'Resultats';

  @override
  String pendVerificaciones(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'verificacions sense validar',
      one: 'verificació sense validar',
    );
    return '$_temp0';
  }

  @override
  String pendPagos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'pagaments sense cobrar',
      one: 'pagament sense cobrar',
    );
    return '$_temp0';
  }

  @override
  String pendSinResultados(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'proves ja disputades sense resultats',
      one: 'prova ja disputada sense resultats',
    );
    return '$_temp0';
  }

  @override
  String get todoAlDia => 'Tot al dia';

  @override
  String get todoAlDiaSinPruebas =>
      'No hi ha proves pendents ni resultats per registrar.';

  @override
  String todoAlDiaEnPrueba(String prueba) {
    return 'Sense verificacions ni pagaments pendents a $prueba.';
  }

  @override
  String get liderCampeonato => 'Líder del campionat';

  @override
  String get sinResultadosTodavia => 'Encara sense resultats';

  @override
  String puntosAbrev(int puntos) {
    return '$puntos pts';
  }

  @override
  String get seccionDatos => 'Dades';

  @override
  String get copiasSeguridad => 'Còpies de seguretat';

  @override
  String get copiasSeguridadSub =>
      'Pujar o restaurar la còpia a Drive, o restaurar des d\'un fitxer';

  @override
  String get googleSheetsDrive => 'Google (Sheets i Drive)';

  @override
  String get googleSub =>
      'Connectar el compte i les credencials de Google Cloud';

  @override
  String get plantillasCsv => 'Plantilles CSV';

  @override
  String get plantillasCsvSub =>
      'Descarregar plantilles per importar pilots, equips…';

  @override
  String get seccionApariencia => 'Aparença';

  @override
  String get modoOscuro => 'Mode fosc';

  @override
  String get idioma => 'Idioma';

  @override
  String get idiomaAutomatico => 'Automàtic (idioma del sistema)';

  @override
  String get seccionAcercaDe => 'Quant a';

  @override
  String get novedades => 'Novetats';

  @override
  String get historialVersiones => 'Historial de versions';

  @override
  String versionHistorial(String version) {
    return 'Versió $version · historial de versions';
  }

  @override
  String get actualizaciones => 'Actualitzacions';

  @override
  String get actualizacionesSub => 'Cercar una versió nova i descarregar-la';

  @override
  String get actDescargaIncompleta =>
      'La descàrrega no ha arribat completa. Torna-ho a provar.';

  @override
  String get actDescargaAtascada =>
      'La descàrrega s\'ha encallat. Torna-ho a provar.';

  @override
  String get actNoSePudoDescargar =>
      'No s\'ha pogut descarregar l\'actualització. Torna-ho a provar o descarrega-la des de pitwall.es.';

  @override
  String actHayVersionNueva(String version) {
    return 'Hi ha una versió nova: v$version';
  }

  @override
  String get actDescargaNueva =>
      'Descarrega la versió nova per tenir les últimes millores.';

  @override
  String get cancelar => 'Cancel·lar';

  @override
  String get masTarde => 'Més tard';

  @override
  String get actPermisoAndroid =>
      'La primera vegada, Android demanarà permís per instal·lar apps d\'aquesta font. Després, torna a prémer «Actualitzar».';

  @override
  String get actSeAbriraNavegador =>
      'S\'obrirà el navegador per descarregar l\'instal·lador d\'aquesta versió.';

  @override
  String get actActualizar => 'Actualitzar';

  @override
  String get actDescargar => 'Descarregar';

  @override
  String get actDescargando => 'Descarregant…';

  @override
  String actDescargandoPct(int pct) {
    return 'Descarregant… $pct %';
  }
}
