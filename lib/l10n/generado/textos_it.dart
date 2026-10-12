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

/// The translations for Italian (`it`).
class TextosIt extends Textos {
  TextosIt([String locale = 'it']) : super(locale);

  @override
  String get menuInicio => 'Home';

  @override
  String get menuPruebas => 'Gare';

  @override
  String get menuParticipantes => 'Partecipanti';

  @override
  String get menuClasificacion => 'Classifica';

  @override
  String get menuTesoreria => 'Tesoreria';

  @override
  String get menuCreditos => 'Crediti';

  @override
  String get menuVerificacionLibre => 'Verifica libera';

  @override
  String get menuCatalogos => 'Cataloghi';

  @override
  String get menuGestionarCampeonatos => 'Gestisci campionati';

  @override
  String get menuAjustes => 'Impostazioni';

  @override
  String get menuMas => 'Altro';

  @override
  String get grupoCampeonato => 'CAMPIONATO';

  @override
  String get grupoHerramientas => 'STRUMENTI';

  @override
  String get grupoCampeonatoActivo => 'CAMPIONATO ATTIVO';

  @override
  String get campeonatoActivo => 'Campionato attivo';

  @override
  String get gestionarCampeonatosPuntos => 'Gestisci campionati…';

  @override
  String tooltipCampeonato(String nombre) {
    return 'Campionato: $nombre';
  }

  @override
  String errorDetalle(String detalle) {
    return 'Errore: $detalle';
  }

  @override
  String get vacioTitulo => 'Ancora nessun campionato';

  @override
  String get vacioTexto =>
      'Crea il primo campionato per iniziare a gestire gare e risultati.';

  @override
  String get crearCampeonato => 'Crea campionato';

  @override
  String get soloVerificarCoches => 'Verifica solo le vetture';

  @override
  String get ajustesYCopias => 'Impostazioni e backup';

  @override
  String get masOpciones => 'Altre opzioni';

  @override
  String get statPilotos => 'piloti';

  @override
  String get statEquipos => 'squadre';

  @override
  String get statPruebas => 'gare';

  @override
  String get pendientes => 'Da fare';

  @override
  String get proximaPrueba => 'Prossima gara';

  @override
  String get noHayPruebasPendientes => 'Nessuna gara in programma';

  @override
  String get botonInscritos => 'Iscritti';

  @override
  String get botonVerificar => 'Verifica';

  @override
  String get botonResultados => 'Risultati';

  @override
  String pendVerificaciones(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'verifiche non convalidate',
      one: 'verifica non convalidata',
    );
    return '$_temp0';
  }

  @override
  String pendPagos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'pagamenti non incassati',
      one: 'pagamento non incassato',
    );
    return '$_temp0';
  }

  @override
  String pendSinResultados(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'gare disputate senza risultati',
      one: 'gara disputata senza risultati',
    );
    return '$_temp0';
  }

  @override
  String get todoAlDia => 'Tutto in ordine';

  @override
  String get todoAlDiaSinPruebas =>
      'Nessuna gara in programma né risultati da registrare.';

  @override
  String todoAlDiaEnPrueba(String prueba) {
    return 'Nessuna verifica né pagamento in sospeso per $prueba.';
  }

  @override
  String get liderCampeonato => 'Leader del campionato';

  @override
  String get sinResultadosTodavia => 'Ancora nessun risultato';

  @override
  String puntosAbrev(int puntos) {
    return '$puntos pt';
  }

  @override
  String get seccionDatos => 'Dati';

  @override
  String get copiasSeguridad => 'Backup';

  @override
  String get copiasSeguridadSub =>
      'Carica o ripristina il backup su Drive, oppure ripristina da file';

  @override
  String get googleSheetsDrive => 'Google (Sheets e Drive)';

  @override
  String get googleSub => 'Collega l\'account e le credenziali di Google Cloud';

  @override
  String get plantillasCsv => 'Modelli CSV';

  @override
  String get plantillasCsvSub =>
      'Scarica i modelli per importare piloti, squadre…';

  @override
  String get seccionApariencia => 'Aspetto';

  @override
  String get modoOscuro => 'Modalità scura';

  @override
  String get idioma => 'Lingua';

  @override
  String get idiomaAutomatico => 'Automatica (lingua di sistema)';

  @override
  String get seccionAcercaDe => 'Informazioni';

  @override
  String get novedades => 'Novità';

  @override
  String get historialVersiones => 'Cronologia versioni';

  @override
  String versionHistorial(String version) {
    return 'Versione $version · cronologia versioni';
  }

  @override
  String get actualizaciones => 'Aggiornamenti';

  @override
  String get actualizacionesSub => 'Cerca una nuova versione e scaricala';

  @override
  String get actDescargaIncompleta => 'Il download non è completo. Riprova.';

  @override
  String get actDescargaAtascada => 'Il download si è bloccato. Riprova.';

  @override
  String get actNoSePudoDescargar =>
      'Impossibile scaricare l\'aggiornamento. Riprova o scaricalo da pitwall.es.';

  @override
  String actHayVersionNueva(String version) {
    return 'È disponibile una nuova versione: v$version';
  }

  @override
  String get actDescargaNueva =>
      'Scarica la nuova versione per avere gli ultimi miglioramenti.';

  @override
  String get cancelar => 'Annulla';

  @override
  String get masTarde => 'Più tardi';

  @override
  String get actPermisoAndroid =>
      'La prima volta Android chiederà il permesso di installare app da questa fonte. Poi premi di nuovo «Aggiorna».';

  @override
  String get actSeAbriraNavegador =>
      'Si aprirà il browser per scaricare il programma di installazione di questa versione.';

  @override
  String get actActualizar => 'Aggiorna';

  @override
  String get actDescargar => 'Scarica';

  @override
  String get actDescargando => 'Download in corso…';

  @override
  String actDescargandoPct(int pct) {
    return 'Download in corso… $pct%';
  }
}
