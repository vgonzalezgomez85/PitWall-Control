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

  @override
  String get nuevaPrueba => 'Nuova gara';

  @override
  String get seleccionaCampeonato => 'Seleziona prima un campionato';

  @override
  String get aunNoHayPruebas => 'Ancora nessuna gara';

  @override
  String get aunNoHayPruebasTexto =>
      'Crea la prima gara del campionato (ad esempio \"EL SOT\", \"SLOTMANIA\"…).';

  @override
  String get estadoProgramada => 'Programmata';

  @override
  String get estadoEnCurso => 'In corso';

  @override
  String get estadoTerminada => 'Conclusa';

  @override
  String get estadoCancelada => 'Annullata';

  @override
  String get resumenVerificaciones => 'Riepilogo verifiche';

  @override
  String get aunNoHayTandas => 'Ancora nessuna batteria';

  @override
  String get verificarSinTandasTexto =>
      'Iscrivi le squadre e crea le batterie nella scheda Prepara.';

  @override
  String validadasDe(int validadas, int total) {
    return '$validadas / $total convalidate';
  }

  @override
  String get sinEquiposEnTanda => 'Nessuna squadra in questa batteria.';

  @override
  String get carreraTienePole => 'La gara ha la pole?';

  @override
  String get carreraTienePoleTexto =>
      'Con la pole l\'ordine delle corsie non viene esportato: PitWall crea la sessione di pole e la griglia si assegna dopo averla corsa.';

  @override
  String get sinPole => 'Senza pole';

  @override
  String get conPole => 'Con pole';

  @override
  String get noHayInscritosExportar => 'Nessun iscritto da esportare.';

  @override
  String get noHayTandasConCarriles =>
      'Nessuna batteria con corsie assegnate da esportare.';

  @override
  String get importarDelCronometraje => 'Importa dal cronometraggio';

  @override
  String get traerResultadosPitwall => 'Recupera i risultati da PitWall';

  @override
  String get prueba => 'Gara';

  @override
  String get editar => 'Modifica';

  @override
  String get pestanaPreparar => 'Prepara';

  @override
  String get pestanaVerificar => 'Verifica';

  @override
  String get pestanaResultados => 'Risultati';

  @override
  String get pestanaCaja => 'Cassa';

  @override
  String get nuevaTanda => 'Nuova batteria';

  @override
  String get compartir => 'Condividi';

  @override
  String get pdfTandas => 'PDF delle batterie';

  @override
  String get pdfVerificaciones => 'PDF delle verifiche';

  @override
  String get enviarTandasPitwall => 'Invia le batterie a PitWall';

  @override
  String get porWifiSinArchivo => 'Via wifi, senza file';

  @override
  String get enviarVerificacionesPitwall => 'Invia le verifiche a PitWall';

  @override
  String get soloConsultaManager => 'Sola consultazione in Manager';

  @override
  String get archivoParaPitwall => 'File per PitWall (JSON)';

  @override
  String get paraImportarAManoManager => 'Per importarlo a mano in Manager';

  @override
  String get noEncontrada => 'Non trovata';

  @override
  String get editarTandas => 'Modifica batterie';

  @override
  String get sorteoMotores => 'Sorteggio motori';

  @override
  String get tandas => 'Batterie';

  @override
  String get crearTandasTexto =>
      'Crea le batterie di questa gara (Giovedì 21:00, Venerdì 21:00…).';

  @override
  String pruebaNumero(int orden) {
    return 'Gara #$orden';
  }

  @override
  String nCarriles(int n) {
    return '$n corsie';
  }

  @override
  String noSePudoGuardar(String detalle) {
    return 'Impossibile salvare: $detalle';
  }

  @override
  String get eliminarPrueba => 'Elimina gara';

  @override
  String eliminarPruebaTexto(String nombre) {
    return 'Eliminare \"$nombre\"?\n\nVerranno eliminati anche le sue batterie, iscrizioni, risultati e verifiche. L\'operazione non si può annullare.';
  }

  @override
  String get eliminar => 'Elimina';

  @override
  String get editarPrueba => 'Modifica gara';

  @override
  String get nombrePruebaObligatorio => 'Nome della gara *';

  @override
  String get nombrePruebaAyuda => 'Es.: EL SOT, SLOTMANIA, GASCLAVAT…';

  @override
  String get indicaElNombre => 'Indica il nome';

  @override
  String get sedeClub => 'Sede / club';

  @override
  String get sinFechaAsignada => 'Nessuna data';

  @override
  String get quitarFecha => 'Rimuovi data';

  @override
  String get elegir => 'Scegli';

  @override
  String get cambiar => 'Cambia';

  @override
  String get ordenCampeonato => 'Ordine nel campionato';

  @override
  String get ordenCampeonatoAyuda => 'Posizione nel calendario (1, 2, 3…)';

  @override
  String get numeroEntero => 'Numero intero';

  @override
  String get estado => 'Stato';

  @override
  String get crearPrueba => 'Crea gara';

  @override
  String get guardarCambios => 'Salva modifiche';

  @override
  String get eliminarTanda => 'Elimina batteria';

  @override
  String eliminarTandaTexto(String nombre) {
    return 'Eliminare la batteria \"$nombre\"? Verranno eliminati anche iscrizioni, risultati e verifiche della batteria.';
  }

  @override
  String get editarTanda => 'Modifica batteria';

  @override
  String get nombreTandaObligatorio => 'Nome della batteria *';

  @override
  String get nombreTandaAyuda => 'Es.: Giovedì 21:00, Venerdì 23:00…';

  @override
  String get sinFechaHora => 'Nessuna data e ora';

  @override
  String get quitar => 'Rimuovi';

  @override
  String get numeroCarriles => 'Numero di corsie';

  @override
  String get numeroCarrilesAyuda => 'Di solito 6, 7 o 8 (fino a 32)';

  @override
  String get numeroCarrilesError => 'Indica un numero tra 1 e 32';

  @override
  String get pisters => 'Commissari';

  @override
  String get pistersAyuda =>
      'Batteria i cui piloti fanno da commissari in questa';

  @override
  String get sinPisters => '— senza commissari —';

  @override
  String pilotosDe(String nombre) {
    return 'Piloti di $nombre';
  }

  @override
  String get crearTanda => 'Crea batteria';

  @override
  String get pruebaSinTandas => 'Questa gara non ha ancora batterie';

  @override
  String get generaTandasDesdeInscritos =>
      'Generale da Iscritti → Genera batterie.';

  @override
  String get tocaEquipoParaMover =>
      'Tocca una squadra per spostarla in un\'altra batteria.';

  @override
  String nEquiposAbrev(int n) {
    return '$n sq.';
  }

  @override
  String get sinEquipos => 'Nessuna squadra';

  @override
  String moverEquipoA(String nombre) {
    return 'Sposta \"$nombre\" in…';
  }

  @override
  String tandaConEquipos(String nombre, int n) {
    return '$nombre  ($n sq.)';
  }

  @override
  String get darDeBajaPrueba => 'Ritira dalla gara';

  @override
  String get eligePitwall => 'Scegli un PitWall o scrivi il suo indirizzo.';

  @override
  String get noHayInscritosEnviar => 'Nessun iscritto da inviare.';

  @override
  String get noHayTandasEnviar =>
      'Nessuna batteria con corsie assegnate da inviare.';

  @override
  String get enviarAPitwall => 'Invia a PitWall';

  @override
  String get pinImportacion => 'PIN di importazione';

  @override
  String get pinImportacionAyuda =>
      'Il PIN che mostra PitWall in «Importa batteria».';

  @override
  String get carreraTienePoleSi => 'La gara ha la pole';

  @override
  String get carreraTienePoleAyuda =>
      'L\'ordine delle corsie non viene inviato: la griglia si assegna in PitWall dopo la pole';

  @override
  String get enviar => 'Invia';

  @override
  String get pitwallEnLaRed => 'PitWall in rete';

  @override
  String get buscarDeNuevo => 'Cerca di nuovo';

  @override
  String get buscandoPitwall => 'Ricerca di PitWall nella rete locale…';

  @override
  String get noSeEncuentraPitwall =>
      'Nessun PitWall trovato. Controlla che sia aperto e sulla stessa rete Wi‑Fi, oppure scrivi il suo indirizzo qui sotto.';

  @override
  String get direccionIpPuerto => 'Indirizzo (IP:porta)';

  @override
  String get resultadosDeLaTanda => 'Risultati della batteria';

  @override
  String get noHayEquiposEnTanda => 'Nessuna squadra in questa batteria';

  @override
  String get inscribeEquiposParaResultados =>
      'Iscrivi squadre per poter registrare i loro risultati.';

  @override
  String get indicaPosicionFinalTexto =>
      'Indica la posizione finale di ogni squadra. I punti si calcolano da soli secondo la tabella del campionato.';

  @override
  String get puntos => 'punti';

  @override
  String get posicion => 'Posizione';

  @override
  String get sinAsignar => 'Non assegnata';

  @override
  String get aRestar => 'Da sottrarre';

  @override
  String get creditosMin => 'crediti';

  @override
  String get noHayInscritosEnPrueba => 'Nessun iscritto in questa gara';

  @override
  String get inscribeEquiposGeneraTandas =>
      'Iscrivi squadre e genera le batterie. Poi potrai importare qui i risultati del cronometraggio.';

  @override
  String equiposConResultado(int con, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total squadre',
      one: '1 squadra',
    );
    return '$con di $_temp0 con risultato registrato.';
  }

  @override
  String get resultadosDeLaPrueba => 'Risultati della gara';

  @override
  String get importarDesdeArchivoCronometraje =>
      'Importa da file di cronometraggio';

  @override
  String copaYManga(String copa, String manga) {
    return 'Coppa $copa  ·  $manga';
  }

  @override
  String get posAbrev => 'Pos.';

  @override
  String get archivos => 'File';

  @override
  String get noSeEncontraronResultados =>
      'Nessun risultato trovato. Il file deve avere colonne come \"Posizione\" e \"Nome\" (formato TicTacSlot o simile).';

  @override
  String noSePudoLeerArchivo(String detalle) {
    return 'Impossibile leggere il file: $detalle';
  }

  @override
  String get importacionCompletada => 'Importazione completata';

  @override
  String resumenImportacionResultados(int ok, int inscritos, int saltados) {
    return '✓ Risultati applicati: $ok\n+ Iscritti automaticamente: $inscritos\n✗ Saltati: $saltados';
  }

  @override
  String get ok => 'OK';

  @override
  String get importarResultadosPrueba => 'Importa risultati della gara';

  @override
  String get paso1EligeArchivo => '1. Scegli il file';

  @override
  String get importaArchivoTexto =>
      'Importa il file del sistema di cronometraggio (TicTacSlot, SloTime…). Ogni squadra del file viene assegnata alla batteria di questa gara in cui è iscritta.';

  @override
  String get elegirArchivo => 'Scegli file';

  @override
  String get resultadosGenerales => 'Risultati generali';

  @override
  String get crearTandaResultadosGenerales =>
      'Crea batteria \"Risultati generali\"';

  @override
  String get pruebaSinTandasAviso =>
      'La gara non ha ancora batterie. Segniamo i risultati in una batteria creata al volo.';

  @override
  String get paso2VistaPrevia => '2. Anteprima';

  @override
  String nDeTotalSeAplicaran(int n, int total) {
    return '$n di $total verranno applicati';
  }

  @override
  String equiposNoExistenAviso(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '⚠️ $n squadre del file non esistono nel campionato.',
      one: '⚠️ 1 squadra del file non esiste nel campionato.',
    );
    return '$_temp0';
  }

  @override
  String aplicarResultadosA(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n squadre',
      one: '1 squadra',
    );
    return 'Applica risultati a $_temp0';
  }

  @override
  String get noExiste => 'Non esiste';

  @override
  String get seInscribira => 'Verrà iscritta';

  @override
  String get aplicar => 'Applica';

  @override
  String copaTexto(String copa) {
    return 'Coppa $copa';
  }

  @override
  String nVueltas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n giri',
      one: '1 giro',
    );
    return '$_temp0';
  }

  @override
  String formatoNoSoportado(String ext) {
    return 'Formato non supportato: $ext';
  }

  @override
  String get sortearRestantes => 'Sorteggia rimanenti';

  @override
  String get pruebaNoEncontrada => 'Gara non trovata';

  @override
  String get noHayEquiposInscritosTandas =>
      'Nessuna squadra iscritta nelle batterie di questa gara.';

  @override
  String sorteoBloqueadoTexto(String motivo) {
    return '$motivo Il sorteggio resta in sola lettura.';
  }

  @override
  String get equipos => 'Squadre';

  @override
  String get numeros => 'Numeri';

  @override
  String get noQuedanMotores => 'Non restano motori disponibili.';

  @override
  String get motorSorteado => 'Motore sorteggiato';

  @override
  String get repetir => 'Ripeti';

  @override
  String get asignar => 'Assegna';

  @override
  String faltanMotores(int equipos, int motores) {
    return 'Mancano motori: $equipos squadre e solo $motores motori disponibili.';
  }

  @override
  String motoresRango(int min, int max) {
    return 'Motori $min–$max';
  }

  @override
  String asignadosDe(int asignados, int total) {
    return '$asignados/$total assegnati';
  }

  @override
  String disponiblesN(int n) {
    return '$n disponibili';
  }

  @override
  String get sortear => 'Sorteggia';

  @override
  String numeroMotor(int n) {
    return 'N. $n';
  }

  @override
  String get volverASortear => 'Sorteggia di nuovo';

  @override
  String get quitarMotor => 'Rimuovi motore';

  @override
  String get faltaRangoMotores => 'Manca configurare l\'intervallo di motori';

  @override
  String get faltaRangoMotoresTexto =>
      'Definisci l\'intervallo di numeri motore dell\'organizzazione nel campionato per poterli sorteggiare.';

  @override
  String get configurarCampeonato => 'Configura campionato';

  @override
  String get rangoMotoresNoConfigurado =>
      'Intervallo di motori non configurato.';

  @override
  String get asignado => 'Assegnato';

  @override
  String get disponible => 'Disponibile';

  @override
  String get tanda => 'Batteria';

  @override
  String get verificaciones => 'Verifiche';

  @override
  String get renumerarCarriles => 'Rinumera corsie';

  @override
  String get renumerar => 'Rinumera';

  @override
  String renumerarCarrilesTexto(String nombre, int carriles) {
    return 'Vengono riassegnate tutte le corsie di \"$nombre\" per punti, dal più alto al più basso: da 1 a $carriles e, se ci sono più piloti, D1, D2… Le modifiche fatte a mano vanno perse.';
  }

  @override
  String get inscribirEquipo => 'Iscrivi squadra';

  @override
  String get aunNoHayEquiposInscritos => 'Nessuna squadra ancora iscritta';

  @override
  String get pulsaInscribirEquipo =>
      'Tocca \"Iscrivi squadra\" per aggiungerle una a una assegnando la corsia di partenza.';

  @override
  String sinCarrilN(int n) {
    return 'Senza corsia ($n)';
  }

  @override
  String get actual => 'attuale';

  @override
  String get libre => 'libera';

  @override
  String get libreTitulo => 'Libera';

  @override
  String carrilDe(String nombre) {
    return 'Corsia di $nombre';
  }

  @override
  String get tocaCarrilLibreTexto =>
      'Tocca una corsia libera per spostarla lì, o una occupata per scambiarle.';

  @override
  String get pista => 'Pista';

  @override
  String get descanso => 'Riposo';

  @override
  String get seedDirecto => 'Seed diretto';

  @override
  String get sinCarril => 'Senza corsia';

  @override
  String get escribirAMano => 'Scrivi a mano…';

  @override
  String get carrilDeSalida => 'Corsia di partenza';

  @override
  String get carrilEjemplo => 'Es.: D1, D2, 1, 2, 3…';

  @override
  String get carrilAyuda => 'D1-D4 per i seed diretti, 1-N per il sorteggio';

  @override
  String get guardar => 'Salva';

  @override
  String quienSaleEnCarril(String carril) {
    return 'Chi parte dalla corsia $carril?';
  }

  @override
  String dejaLibreEl(String carril) {
    return 'Libera la corsia $carril';
  }

  @override
  String get carrilesRepetidos => 'Corsie ripetute';

  @override
  String pistersPilotosDe(String tanda) {
    return 'Commissari: piloti di $tanda';
  }

  @override
  String get cambiarCarril => 'Cambia corsia';

  @override
  String get quitarSeedDirecto => 'Rimuovi seed diretto';

  @override
  String get marcarSeedDirecto => 'Segna come seed diretto';

  @override
  String get quitarDeLaTanda => 'Rimuovi dalla batteria';

  @override
  String get quitarInscripcion => 'Rimuovi iscrizione';

  @override
  String quitarInscripcionTexto(String nombre) {
    return 'Rimuovere \"$nombre\" da questa batteria?';
  }

  @override
  String inscribirEquipoEn(String nombre) {
    return 'Iscrivi squadra in \"$nombre\"';
  }

  @override
  String get buscarEquipoOPiloto => 'Cerca squadra o pilota…';

  @override
  String get noHayEquiposEnCampeonatoCrealos =>
      'Non ci sono squadre in questo campionato. Creale prima.';

  @override
  String get todosLosEquiposYaInscritos =>
      'Tutte le squadre sono già iscritte.';

  @override
  String get inscribir => 'Iscrivi';

  @override
  String get carrilEjemploCorto => 'Es.: D1, 3…';

  @override
  String get carrilAyudaVacio => 'Lascia vuoto se non assegni ancora la corsia';

  @override
  String get inscritosALaPrueba => 'Iscritti alla gara';

  @override
  String get actualizarDesdeDrive => 'Aggiorna da Drive';

  @override
  String get actualizandoDesdeDrive => 'Aggiornamento da Drive…';

  @override
  String get anadirPiloto => 'Aggiungi pilota';

  @override
  String get anadirEquipo => 'Aggiungi squadra';

  @override
  String get importar => 'Importa';

  @override
  String get vincularGoogleSheet => 'Collega Google Sheet';

  @override
  String get desdeArchivoCsvExcel => 'Da file CSV / Excel';

  @override
  String get generarTandas => 'Genera batterie';

  @override
  String get aunNoHayPilotosInscritosPrueba =>
      'Nessun pilota ancora iscritto a questa gara';

  @override
  String get aunNoHayEquiposInscritosPrueba =>
      'Nessuna squadra ancora iscritta a questa gara';

  @override
  String get importaCsvGoogleFormPilotos =>
      'Importa il CSV/Excel del Google Form o aggiungi piloti a mano.';

  @override
  String get importaCsvGoogleFormEquipos =>
      'Importa il CSV/Excel del Google Form o aggiungi squadre a mano.';

  @override
  String get importarCsvExcel => 'Importa CSV/Excel';

  @override
  String get anadirAMano => 'Aggiungi a mano';

  @override
  String pilotosInscritosGenerarTandas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '$n piloti iscritti. Quando ci sono tutti, tocca \"Genera batterie\".',
      one:
          '1 pilota iscritto. Quando ci sono tutti, tocca \"Genera batterie\".',
    );
    return '$_temp0';
  }

  @override
  String equiposInscritosGenerarTandas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '$n squadre iscritte. Quando ci sono tutte, tocca \"Genera batterie\".',
      one:
          '1 squadra iscritta. Quando ci sono tutte, tocca \"Genera batterie\".',
    );
    return '$_temp0';
  }

  @override
  String get darDeBaja => 'Ritira';

  @override
  String darDeBajaTexto(String nombre) {
    return 'Ritira \"$nombre\"?\n\nViene tolto dagli Iscritti e dalla sua batteria. Le corsie degli altri non cambiano: se serve, rinumera la batteria dopo.';
  }

  @override
  String get inscribirPilotos => 'Iscrivi piloti';

  @override
  String get inscribirEquipos => 'Iscrivi squadre';

  @override
  String nSeleccionados(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n selezionati',
      one: '1 selezionato',
    );
    return '$_temp0';
  }

  @override
  String get limpiar => 'Pulisci';

  @override
  String get buscarPiloto => 'Cerca pilota…';

  @override
  String get noHayPilotosEnCampeonato =>
      'Non ci sono piloti in questo campionato.';

  @override
  String get noHayEquiposEnCampeonato =>
      'Non ci sono squadre in questo campionato.';

  @override
  String get todosYaInscritos => 'Sono già iscritti tutti.';

  @override
  String get nuevaInscripcion => 'Nuova iscrizione';

  @override
  String get nuevoEquipo => 'Nuova squadra';

  @override
  String get copaParaPilotosNuevos => 'Coppa per i nuovi piloti:';

  @override
  String get desmarcarTodos => 'Deseleziona tutti';

  @override
  String marcarTodosN(int n) {
    return 'Seleziona tutti ($n)';
  }

  @override
  String nuevaInscripcionCopa(String copa) {
    return 'Nuova iscrizione · Coppa $copa';
  }

  @override
  String get marcaPilotosInscribir => 'Spunta i piloti che vuoi iscrivere';

  @override
  String get marcaEquiposInscribir => 'Spunta le squadre che vuoi iscrivere';

  @override
  String inscribirNPilotos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n piloti',
      one: '1 pilota',
    );
    return 'Iscrivi $_temp0';
  }

  @override
  String inscribirNEquipos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n squadre',
      one: '1 squadra',
    );
    return 'Iscrivi $_temp0';
  }

  @override
  String get importarInscripciones => 'Importa iscrizioni';

  @override
  String get csvGoogleFormInscripcionPilotos =>
      'CSV/Excel del Google Form di iscrizione alla gara. Le iscrizioni vengono collegate ai piloti esistenti per nome.';

  @override
  String get csvGoogleFormInscripcionEquipos =>
      'CSV/Excel del Google Form di iscrizione alla gara. Le iscrizioni vengono collegate alle squadre esistenti per nome.';

  @override
  String get paso2AsignaColumnas => '2. Assegna colonne';

  @override
  String get nombreDelPilotoObligatorio => 'Nome del pilota *';

  @override
  String get nombreDelEquipoObligatorio => 'Nome della squadra *';

  @override
  String get diaPreferidoOpcional => 'Giorno preferito (opzionale)';

  @override
  String get notasOpcional => 'Note (opzionale)';

  @override
  String get paso3VistaPrevia => '3. Anteprima';

  @override
  String nDeTotalSeImportaran(int n, int total) {
    return '$n di $total verranno importati';
  }

  @override
  String pilotosNoExistenAviso(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '⚠️ $n piloti non esistono nel campionato. Creali prima o controlla i nomi.',
      one:
          '⚠️ 1 pilota non esiste nel campionato. Crealo prima o controlla il nome.',
    );
    return '$_temp0';
  }

  @override
  String equiposNoExistenAvisoImport(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '⚠️ $n squadre non esistono nel campionato. Creale prima o controlla i nomi.',
      one:
          '⚠️ 1 squadra non esiste nel campionato. Creala prima o controlla il nome.',
    );
    return '$_temp0';
  }

  @override
  String get asignaColumnaPiloto => 'Assegna la colonna del nome del pilota.';

  @override
  String get asignaColumnaEquipo =>
      'Assegna la colonna del nome della squadra.';

  @override
  String get ninguna => '— nessuna —';

  @override
  String get yaInscrito => 'Già iscritto';

  @override
  String diaTexto(String dia) {
    return 'Giorno: $dia';
  }

  @override
  String noSePudoLeer(String detalle) {
    return 'Impossibile leggere: $detalle';
  }

  @override
  String resumenImportacionInscripciones(int ok, int saltados) {
    return '✓ Iscritti: $ok\n✗ Saltati: $saltados';
  }

  @override
  String tandaNumero(int n) {
    return 'Batteria $n';
  }

  @override
  String get tandasCreadas => 'Batterie create';

  @override
  String tandasCreadasTexto(int n, int equipos) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Creata $n batterie con $equipos squadre.',
      one: 'Creata 1 batteria con $equipos squadre.',
    );
    return '$_temp0';
  }

  @override
  String get conCarrilAsignado => 'Con corsia di partenza assegnata.';

  @override
  String get carrilesSeAsignaranAntes =>
      'Le corsie verranno assegnate prima della gara.';

  @override
  String get pistersAsignadosEntreTandas =>
      'Commissari assegnati tra le batterie di ogni giornata.';

  @override
  String equiposInscritosARepartir(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n squadre iscritte da distribuire',
      one: '1 squadra iscritta da distribuire',
    );
    return '$_temp0';
  }

  @override
  String get ordenadosPorPuntos => 'Ordinate per punti lordi accumulati.';

  @override
  String get sinPuntosEsteAnio =>
      'Nessun punto quest\'anno → ordinate per saldo dell\'anno precedente (0 se non c\'è).';

  @override
  String get paso1CarrilesPista => '1. Corsie della pista';

  @override
  String get paso1CarrilesTexto =>
      'Quante auto corrono insieme. Imposta il massimo di squadre per batteria per distribuirle bene.';

  @override
  String get carrilesMin => 'corsie';

  @override
  String get minutosPorCarrilTexto =>
      'Minuti per corsia (quanto dura il turno di una squadra su ogni corsia, per calcolare la durata della batteria).';

  @override
  String get minPorCarril => 'min/corsia';

  @override
  String cadaTandaDurara(int minutos, int carriles, int minPorCarril) {
    return 'Ogni batteria durerà ~$minutos min ($carriles corsie × $minPorCarril min).';
  }

  @override
  String get paso2NumeroTandas => '2. Numero di batterie';

  @override
  String sugeridoTexto(int n, int carriles) {
    return 'Suggerito: $n (senza corsie vuote con $carriles corsie: se avanzano squadre, le batterie superano $carriles). Puoi cambiarlo.';
  }

  @override
  String get paso3NombresHorarios => '3. Nomi e orari';

  @override
  String get asignarCarrilAutomatico => 'Assegna la corsia automaticamente';

  @override
  String asignarCarrilTexto(int carriles) {
    return 'Per punti, dal più alto al più basso: corsie da 1 a $carriles e, se ci sono più piloti, D1, D2…';
  }

  @override
  String get asignarPisters => 'Assegna commissari';

  @override
  String get asignarPistersTexto =>
      'Tra le batterie dello stesso giorno. 2 batterie: 1a↔2a. 3: la 3a fa da commissario nella 1a, la 1a nella 2a e la 2a nella 3a. 4: 1a↔2a e 3a↔4a.';

  @override
  String get paso4VistaPrevia => '4. Anteprima';

  @override
  String get numeroIzquierdaCarril =>
      'Il numero a sinistra è la corsia di partenza.';

  @override
  String get carrilesLosAsignarasDespues =>
      'Le corsie le assegnerai dopo, prima della gara.';

  @override
  String sinTandaN(int n) {
    return 'Senza batteria ($n)';
  }

  @override
  String get sinTandaTexto =>
      'Queste squadre preferiscono un giorno che non ha nessuna batteria in questa distribuzione. Aggiungi una batteria di quel giorno sopra o cambia la loro preferenza.';

  @override
  String prefiereDia(String dia) {
    return 'Preferisce: $dia';
  }

  @override
  String get sustituirTandasExistentes => 'Sostituisci le batterie esistenti';

  @override
  String get sustituirTandasTexto =>
      'Se questa gara aveva già batterie, vengono eliminate e sostituite.';

  @override
  String get crearEstasTandas => 'Crea queste batterie';

  @override
  String get eligeLaCarrera => 'Scegli la gara';

  @override
  String get verCarreras => 'Vedi gare';

  @override
  String resultadosDeCarrera(String nombre) {
    return 'Risultati: $nombre';
  }

  @override
  String noSePudoConectar(String detalle) {
    return 'Impossibile connettersi: $detalle';
  }

  @override
  String noSePudieronTraerResultados(String detalle) {
    return 'Impossibile recuperare i risultati: $detalle';
  }

  @override
  String get noHayCampeonatoActivo => 'Nessun campionato attivo.';

  @override
  String resultadosAplicadosSaltados(int ok, int saltados) {
    return 'Risultati applicati: $ok · saltati: $saltados';
  }

  @override
  String errorAlAplicar(String detalle) {
    return 'Errore durante l\'applicazione: $detalle';
  }

  @override
  String get pitwallNoTieneCarreras => 'PitWall non ha gare.';

  @override
  String get pitwallNoTieneCarrerasEnvia =>
      'PitWall non ha gare. Invia prima una batteria («Invia a PitWall») o crea la gara in Manager.';

  @override
  String tandasDeCarrera(int n) {
    return '$n batteria/e';
  }

  @override
  String get laCarreraNoTieneResultados => 'La gara non ha ancora risultati.';

  @override
  String get equipoNoEncontradoCampeonato =>
      'Squadra non trovata nel campionato';

  @override
  String get noInscritoEnEstaPrueba => 'Non iscritta a questa gara';

  @override
  String seAplicaraPosicion(int posicion) {
    return 'verrà applicata la posizione $posicion';
  }

  @override
  String aplicarN(int n) {
    return 'Applica ($n)';
  }

  @override
  String tandaAbrev(int n) {
    return 'B$n';
  }

  @override
  String get seEnvianComoConsulta =>
      'Vengono inviate in sola consultazione: su PitWall si potranno vedere ma non modificare.';

  @override
  String get atras => 'Indietro';

  @override
  String get noHayVerificacionesEnviar =>
      'Nessuna verifica da inviare in questa gara.';

  @override
  String copaDosPuntos(String copa) {
    return 'Coppa: $copa';
  }

  @override
  String get aunNoHayEquiposEnEstaTanda =>
      'Nessuna squadra ancora in questa batteria';

  @override
  String get inscribeEquiposVerificacion =>
      'Iscrivi squadre nella batteria per poterle verificare.';

  @override
  String nConVerificacion(int n) {
    return '$n con verifica';
  }

  @override
  String nValidadas(int n) {
    return '$n convalidate';
  }

  @override
  String get quitarParticipante => 'Rimuovi partecipante';

  @override
  String quitarConVerificacionTexto(String nombre) {
    return '\"$nombre\" verrà rimosso e la sua verifica cancellata. Continuare?';
  }

  @override
  String quitarSinVerificacionTexto(String nombre) {
    return '\"$nombre\" verrà rimosso. Continuare?';
  }

  @override
  String get validada => 'Convalidata';

  @override
  String get borrador => 'Bozza';

  @override
  String get enRevision => 'In revisione';

  @override
  String get pendiente => 'Pendente';

  @override
  String get sinCocheAsignado => 'Nessuna auto assegnata';

  @override
  String get sesionCerrada => 'La sessione è chiusa.';

  @override
  String get campeonatoFinalizado => 'Il campionato è concluso.';

  @override
  String get pruebaTerminada => 'La gara è terminata.';

  @override
  String get exportar => 'Esporta';

  @override
  String get exportarPdf => 'Esporta in PDF';

  @override
  String get exportarExcel => 'Esporta in Excel';

  @override
  String get noHayPruebasEnCampeonato =>
      'Non ci sono gare in questo campionato.';

  @override
  String get noHayInscritosNiVerificaciones =>
      'Nessun iscritto né verifiche in questa gara.';

  @override
  String get buscarPilotoEquipoCopa => 'Cerca pilota, squadra, coppa…';

  @override
  String filtroTodos(int n) {
    return 'Tutti ($n)';
  }

  @override
  String filtroConInfraccion(int n) {
    return 'Con infrazione ($n)';
  }

  @override
  String filtroSinVerificar(int n) {
    return 'Non verificate ($n)';
  }

  @override
  String filtroBorrador(int n) {
    return 'Bozza ($n)';
  }

  @override
  String validadasDeTotal(int validadas, int total) {
    return '$validadas convalidate su $total';
  }

  @override
  String get nadaConEsteFiltro => 'Niente da mostrare con questo filtro.';

  @override
  String get colPilotoEquipo => 'Pilota / squadra';

  @override
  String get fueraDeReglamento => 'Fuori regolamento';

  @override
  String get copa => 'Coppa';

  @override
  String get coche => 'Auto';

  @override
  String get colPesoCarroc => 'Peso carrozz.';

  @override
  String get colPesoMin => 'Peso min.';

  @override
  String get colPesoCoche => 'Peso auto';

  @override
  String get motor => 'Motore';

  @override
  String get alturaMotor => 'Altezza motore';

  @override
  String get colEjeDel => 'Asse ant.';

  @override
  String get colEjeTras => 'Asse post.';

  @override
  String get pinon => 'Pignone';

  @override
  String get corona => 'Corona';

  @override
  String get llantaDelantera => 'Cerchio anteriore';

  @override
  String get llantaTrasera => 'Cerchio posteriore';

  @override
  String get trencilla => 'Trecciola';

  @override
  String get suspension => 'Sospensione';

  @override
  String get bancada => 'Supporto motore';

  @override
  String get chasis => 'Telaio';

  @override
  String get neumatico => 'Pneumatico';

  @override
  String get carroceria => 'Carrozzeria';

  @override
  String get observaciones => 'Note';

  @override
  String get sinVerificar => 'Non verificata';

  @override
  String get propio => 'Proprio';

  @override
  String orgNumero(String n) {
    return 'Org. n. $n';
  }

  @override
  String get conforme => 'Conforme';

  @override
  String get noConforme => 'Non conforme';

  @override
  String get toca => 'Tocca';

  @override
  String get bien => 'Buono';

  @override
  String get faltanPiezas => 'Pezzi mancanti';

  @override
  String faltanPiezasDetalle(String piezas) {
    return 'Mancano: $piezas';
  }

  @override
  String marcaNoPermitida(String marca) {
    return 'Marca \"$marca\" non ammessa';
  }

  @override
  String superaMaximoMm(String maximo) {
    return 'Supera il massimo di $maximo mm';
  }

  @override
  String porDebajoMinimoG(String minimo) {
    return 'Sotto il minimo di $minimo g';
  }

  @override
  String get alturaMotorNoConforme => 'Altezza motore non conforme';

  @override
  String get leFaltanPiezas => 'Pezzi mancanti';

  @override
  String vPesoInicialBajo(String valor, String minimo) {
    return 'Peso iniziale ${valor}g sotto il minimo ${minimo}g.';
  }

  @override
  String vPesoFinalBajo(String valor, String minimo) {
    return 'Peso finale ${valor}g sotto il minimo ${minimo}g.';
  }

  @override
  String get vMotorSinCatalogo =>
      'Seleziona il motore del catalogo per controllare le misure.';

  @override
  String vMotorRpmAlto(String motor, String max, String medido) {
    return 'RPM sopra il riferimento del $motor (max $max, misurati $medido).';
  }

  @override
  String vMotorUmsAlto(String motor, String max, String medido) {
    return 'Magnete sopra il riferimento del $motor (max $max, misurato $medido).';
  }

  @override
  String get vAlturaNoConforme =>
      'Altezza motore non conforme: tocca la pista.';

  @override
  String vEjeDelAncho(String medido, String max) {
    return 'Larghezza asse anteriore $medido mm sopra il massimo $max mm.';
  }

  @override
  String vEjeTraAncho(String medido, String max) {
    return 'Larghezza asse posteriore $medido mm sopra il massimo $max mm.';
  }

  @override
  String vMarcaNoPermitidaLista(String marca, String lista) {
    return 'Marca \"$marca\" non ammessa (solo $lista).';
  }

  @override
  String vMarcaFueraCatalogo(String marca) {
    return 'Marca \"$marca\" non è nel catalogo.';
  }

  @override
  String vLlantaDelNoCatalogada(String valor) {
    return 'Cerchio anteriore non catalogato: \"$valor\".';
  }

  @override
  String vLlantaTraNoCatalogada(String valor) {
    return 'Cerchio posteriore non catalogato: \"$valor\".';
  }

  @override
  String vBancadaNoCatalogada(String valor) {
    return 'Supporto motore non catalogato: \"$valor\".';
  }

  @override
  String vNeumaticoNoCatalogado(String valor) {
    return 'Pneumatico non catalogato: \"$valor\".';
  }

  @override
  String vBalanceNegativo(String equipo, String coche, String balance) {
    return 'Saldo crediti negativo: squadra $equipo + auto $coche = $balance.';
  }

  @override
  String get noSePudoGenerarExcel => 'Impossibile generare l\'Excel.';

  @override
  String get buscarPuntos => 'Cerca…';

  @override
  String sinResultadosPara(String filtro) {
    return 'Nessun risultato per \"$filtro\"';
  }

  @override
  String get sinAsignarGuiones => '— non assegnato —';

  @override
  String get sorteoEtiqueta => 'Sorteggio';

  @override
  String get mixto => 'Misto';

  @override
  String get limitarFabricante => 'Limita il costruttore';

  @override
  String noCatalogada(String nombre) {
    return '$nombre (non catalogata)';
  }

  @override
  String get imagenNoSePuedeLeer =>
      'Impossibile leggere quell\'immagine. Usa un PNG o JPG.';

  @override
  String noSePudoAnadirLogo(String detalle) {
    return 'Impossibile aggiungere il logo: $detalle';
  }

  @override
  String get elegirLogo => 'Scegli logo';

  @override
  String get cambiarLogo => 'Cambia logo';

  @override
  String get repartir => 'Ripartisci';

  @override
  String get configuraRangoSesion =>
      'Configura l\'intervallo di motori nel regolamento della sessione per sorteggiare.';

  @override
  String get configuraRangoCampeonato =>
      'Configura l\'intervallo di motori nel campionato per sorteggiare.';

  @override
  String get sorteoDeMotor => 'Sorteggio del motore';

  @override
  String get otroControl => 'Un altro Control';

  @override
  String cambiadaFueraTexto(String quien) {
    return '$quien ha modificato questa verifica. Se continui a modificare, le tue modifiche sostituiranno le sue.';
  }

  @override
  String get seguirConLoMio => 'Continua con il mio';

  @override
  String verLoDe(String quien) {
    return 'Vedi quelli di $quien';
  }

  @override
  String actualizadaConCambios(String quien) {
    return 'Aggiornata con le modifiche di $quien.';
  }

  @override
  String noSePudoAnadirFoto(String detalle) {
    return 'Impossibile aggiungere la foto: $detalle';
  }

  @override
  String get copaEnEstaPrueba => 'Coppa in questa gara';

  @override
  String get copaEnEstaPruebaTexto =>
      'Cambia la coppa solo per questa gara, senza toccare la squadra né le altre gare.';

  @override
  String get copaCategoria => 'Coppa / categoria';

  @override
  String copaDelEquipo(String copa) {
    return 'Coppa della squadra: $copa';
  }

  @override
  String get usarLaDelEquipo => 'Usa quella della squadra';

  @override
  String get usarReglamentoActual => 'Usa il regolamento attuale';

  @override
  String get usarReglamentoActualTexto =>
      'Questa verifica sarà controllata con i valori odierni del catalogo e del campionato invece di quelli che aveva al momento della verifica:';

  @override
  String get recalcularanCreditos =>
      'Essendo convalidata, i suoi crediti verranno ricalcolati.';

  @override
  String get usarElActual => 'Usa quello attuale';

  @override
  String get desbloquearVerificacion => 'Sblocca la verifica';

  @override
  String desbloquearTexto(String motivo) {
    return '$motivo Le sue verifiche sono bloccate per non modificarle per sbaglio.\n\nSe la sblocchi, le modifiche verranno salvate come sempre. Continuerà a essere controllata con il regolamento con cui è stata verificata.';
  }

  @override
  String get desbloquear => 'Sblocca';

  @override
  String get verificacion => 'Verifica';

  @override
  String get eliminarVerificacion => 'Elimina verifica';

  @override
  String get eliminarVerificacionTexto =>
      'I dati inseriti andranno persi. Continuare?';

  @override
  String get modeloCoche => 'Modello di auto';

  @override
  String get elegirCoche => 'Scegli auto';

  @override
  String noHayCochesConCopa(String copa) {
    return 'Non ci sono auto con la coppa $copa nel catalogo';
  }

  @override
  String get ayudaSelectorCoche =>
      'Il peso minimo e i crediti dell\'auto vengono mostrati quando la scegli';

  @override
  String get creditosAbrev => 'cred';

  @override
  String get pesoGramos => 'Peso (grammi)';

  @override
  String get pesoCarroceria => 'Peso carrozzeria';

  @override
  String minimoG(String n) {
    return 'Minimo: ${n}g';
  }

  @override
  String get estetica => 'Estetica';

  @override
  String get sinComprobar => 'Non controllato';

  @override
  String get quePiezasFaltan => 'Quali pezzi mancano';

  @override
  String get organizacion => 'Organizzazione';

  @override
  String get numeroDeMotor => 'Numero di motore';

  @override
  String get motorDelCatalogo => 'Motore del catalogo';

  @override
  String get elegirMotor => 'Scegli motore';

  @override
  String yaNoEnCatalogo(String nombre) {
    return '$nombre (non più nel catalogo)';
  }

  @override
  String refMotor(String rpm, String gauss) {
    return 'Rif.: $rpm RPM · $gauss gauss';
  }

  @override
  String motoresHomologadosCopa(String copa) {
    return 'Motori omologati per la coppa $copa';
  }

  @override
  String rpmYGauss(String rpm, String gauss) {
    return '$rpm RPM · $gauss gauss';
  }

  @override
  String maxN(String n) {
    return 'Max $n';
  }

  @override
  String get alturaMotorAPista => 'Altezza motore a pista';

  @override
  String get alturaMotorTexto =>
      'Controllo con la piastra: se tocca la pista, non conforme.';

  @override
  String get delantero => 'Anteriore';

  @override
  String get trasero => 'Posteriore';

  @override
  String get marca => 'Marca';

  @override
  String get dimension => 'Dimensione';

  @override
  String get dientes => 'Denti';

  @override
  String get diametro => 'Diametro';

  @override
  String get material => 'Materiale';

  @override
  String get pesoCocheEntero => 'Peso auto completa (grammi)';

  @override
  String get inicial => 'Iniziale';

  @override
  String get cocheEntero => 'Auto completa';

  @override
  String get otros => 'Altri';

  @override
  String get notasOAvisos => 'Note o avvisi';

  @override
  String get fotosHasta4 => 'Foto (fino a 4)';

  @override
  String get marcarComoValidada => 'Segna come convalidata';

  @override
  String get marcarComoValidadaTexto =>
      'Indica che la verifica è stata rivista e approvata.';

  @override
  String get autoguardadoTexto => 'Salvata come bozza a ogni modifica.';

  @override
  String get validar => 'Convalida';

  @override
  String get noPuedesValidar =>
      'Non puoi convalidare finché ci sono infrazioni segnate in rosso sopra.';

  @override
  String get fotoReferenciaTexto =>
      'Foto di riferimento del catalogo: controlla che coincida.';

  @override
  String get sinFotoCocheTexto =>
      'Questa auto non ha foto nel catalogo. Aggiungila in Cataloghi → Auto per poter confrontare il modello consegnato.';

  @override
  String get sinGuardar => 'Non salvato…';

  @override
  String get guardando => 'Salvataggio…';

  @override
  String get guardado => 'Salvato';

  @override
  String get errorCorto => 'Errore';

  @override
  String soloLecturaTexto(String motivo) {
    return '$motivo Verifica in sola lettura.';
  }

  @override
  String desbloqueadaTexto(String motivo) {
    return '$motivo Sbloccata: le modifiche vengono salvate.';
  }

  @override
  String reglamentoCongelado(String fecha) {
    return 'Regolamento congelato il $fecha: viene controllata con i valori di quando è stata verificata.';
  }

  @override
  String get reglamentoCongeladoSinFecha =>
      'Regolamento congelato: viene controllata con i valori di quando è stata verificata.';

  @override
  String get haCambiadoDesdeEntonces => 'È cambiato da allora (non applicato):';

  @override
  String get todoCumple => 'Tutto conforme alle norme. Puoi convalidare.';

  @override
  String infraccionesN(int n) {
    return 'Infrazioni: $n';
  }

  @override
  String avisosN(int n) {
    return 'Avvisi: $n';
  }

  @override
  String pendienteHechosDeTotal(int hechos, int total) {
    return 'In sospeso $hechos/$total';
  }

  @override
  String get hecho => 'Fatto';

  @override
  String get revisar => 'Da rivedere';

  @override
  String bloquesCompletos(int hechos, int total) {
    return 'Blocchi completi: $hechos di $total';
  }

  @override
  String faltaLista(String lista) {
    return 'Manca: $lista';
  }

  @override
  String fueraDeLaLista(String valor) {
    return '$valor (fuori lista)';
  }

  @override
  String noCatalogado(String valor) {
    return '$valor (non catalogato)';
  }

  @override
  String conEsteCoche(String creditos) {
    return 'Con quest\'auto ($creditos cred):';
  }

  @override
  String get total => 'Totale';

  @override
  String nCreditos(int n) {
    return '$n crediti';
  }

  @override
  String get sinCreditosSuficientes =>
      '⚠ Non hanno crediti sufficienti per coprire l\'auto.';

  @override
  String get hacerFoto => 'Scatta foto';

  @override
  String get elegirDeGaleria => 'Scegli dalla galleria';

  @override
  String get anadir => 'Aggiungi';

  @override
  String get equipoNoInscritoPrueba =>
      'La squadra non è iscritta alla gara: iscrivila per poterle addebitare.';

  @override
  String get etiquetaFinal => 'Finale';

  @override
  String get anchuraEjeMm => 'Larghezza asse (mm)';

  @override
  String get nombreDelClub => 'Nome del club';

  @override
  String get clubEjemplo => 'Es.: Club Slot Barcelona';

  @override
  String get limitarFabricanteTexto =>
      'Nella verifica, i menu di marca (pignone, corona, cerchi e trecciola) mostrano solo le marche scelte; qualsiasi altra è infrazione.';

  @override
  String get eligeAlMenosUnaMarca => 'Scegli almeno una marca.';

  @override
  String get tipoMotorSorteoTexto =>
      'L\'organizzazione sorteggia i motori: nella verifica si annota solo il numero di motore.';

  @override
  String get tipoMotorPropioTexto =>
      'Ogni squadra porta il suo motore: nella verifica si sceglie dal catalogo e si controllano gli RPM.';

  @override
  String get tipoMotorMixtoTexto =>
      'In ogni verifica si segna se il motore è dell\'organizzazione o proprio.';

  @override
  String get tipoMotorEligeTexto => 'Scegli da dove vengono i motori.';

  @override
  String get noPagaEstaPrueba => 'non paga questa gara';

  @override
  String get quitarWildcard => 'Rimuovi wildcard';

  @override
  String get quitarCoordTotal => 'Rimuovi \"Coord. total\" (torna a pagare)';

  @override
  String get coordinadoraEnFicha =>
      'I piloti sono segnati come coordinatori nella loro scheda; cambialo lì';

  @override
  String get marcarWildcard => 'Segna come wildcard (non paga)';

  @override
  String desglosePagados(String total) {
    return 'Dettaglio dei €$total pagati';
  }

  @override
  String get pagat => 'Pagato';

  @override
  String get coordinadora => 'Coordinamento';

  @override
  String get club => 'Club';

  @override
  String get observacionesOpcional => 'Note (opzionale)';

  @override
  String descuadreTexto(String suma, String total) {
    return 'Coordinamento + Club ($suma) non fa il totale del Pagato ($total).';
  }

  @override
  String get pagoRapido => 'Pagamento rapido:';

  @override
  String get coordYPiloto => 'Coord. + pilota';

  @override
  String coordYPilotoTooltip(String monto) {
    return 'Un pilota è del coordinamento: paga la metà di tutto (€$monto)';
  }

  @override
  String get coordTotal => 'Coord. total';

  @override
  String get coordTotalTooltip =>
      'Tutti i piloti sono del coordinamento: non paga';

  @override
  String get observacionMitad => 'Metà — un pilota del coordinamento';

  @override
  String get nuevaSesion => 'Nuova sessione';

  @override
  String get aunNoHaySesiones => 'Nessuna sessione ancora';

  @override
  String get sesionesVaciasTexto =>
      'Verifica auto senza montare un campionato: una gara sporadica, un controllo al club… Crea una sessione, aggiungi partecipanti ed esporta il PDF.';

  @override
  String nParticipantes(int n) {
    return '$n partecipanti';
  }

  @override
  String get sesionYaNoExiste => 'La sessione non esiste più.';

  @override
  String get aunNoHayParticipantes => 'Nessun partecipante ancora';

  @override
  String get pulsaAnadirParticipante =>
      'Tocca \"Aggiungi partecipante\" per verificare la sua auto, o importali da un file o Google Sheets con «Importa» in alto.';

  @override
  String get anadirParticipante => 'Aggiungi partecipante';

  @override
  String get desdeArchivoCsvExcelParentesis => 'Da file (CSV / Excel)';

  @override
  String get desdeGoogleSheets => 'Da Google Sheets';

  @override
  String get excelConFotos => 'Excel con foto';

  @override
  String get reglamento => 'Regolamento';

  @override
  String get eliminarSesion => 'Elimina sessione';

  @override
  String get configuraCopasAntes =>
      'Configura prima le coppe nel regolamento della sessione.';

  @override
  String anadidosParticipantes(int n) {
    return 'Aggiunti $n partecipanti.';
  }

  @override
  String eliminarSesionTexto(String nombre) {
    return 'Verranno cancellati \"$nombre\", i suoi partecipanti e tutte le sue verifiche. Non si può annullare.';
  }

  @override
  String get pilotoObligatorio => 'Pilota *';

  @override
  String get obligatorio => 'Obbligatorio';

  @override
  String get segundoPiloto => 'Secondo pilota (opzionale)';

  @override
  String get equipoOpcional => 'Squadra (opzionale)';

  @override
  String get equipoOpcionalAyuda =>
      'Se lasciato vuoto, si usa il nome del pilota';

  @override
  String get anadirYVerificar => 'Aggiungi e verifica';

  @override
  String get seleccionaUnaCopa => 'Seleziona almeno una coppa / categoria.';

  @override
  String get eligeTipoMotor =>
      'Motore: scegli se è sorteggiato, proprio o misto.';

  @override
  String get limitarFabricanteError =>
      'Limita costruttore: scegli almeno una marca o disattivalo.';

  @override
  String get nuevaSesionVerificacion => 'Nuova sessione di verifica';

  @override
  String get editarSesion => 'Modifica sessione';

  @override
  String get nombreSesionObligatorio => 'Nome della sessione *';

  @override
  String get nombreSesionAyuda =>
      'Es.: Controllo club giovedì, Gara GT Sant Joan';

  @override
  String get lugarOpcional => 'Luogo (opzionale)';

  @override
  String get sinFecha => 'Senza data';

  @override
  String get fechaSesion => 'Data della sessione';

  @override
  String get clubOrganizador => 'Club organizzatore';

  @override
  String get clubOrganizadorAyuda =>
      'Compare nell\'intestazione dei PDF della sessione.';

  @override
  String get copasCategorias => 'Coppe / categorie';

  @override
  String get copasCategoriasAyuda =>
      'Quelle che si possono verificare in questa sessione. La coppa di ogni partecipante filtra il catalogo e i controlli, come in un campionato.';

  @override
  String get anchuraEje => 'Larghezza asse';

  @override
  String get anchuraEjeAyuda =>
      'Larghezza asse massima (mm) per coppa. Lascia vuoto se in quella coppa non si controlla.';

  @override
  String get maxDelanteroMm => 'Max anteriore (mm)';

  @override
  String get maxTraseroMm => 'Max posteriore (mm)';

  @override
  String get fabricante => 'Costruttore';

  @override
  String get fabricanteAyuda =>
      'Per sessioni monomarca: limita le marche che si possono scegliere nella verifica.';

  @override
  String get rangoMotorTexto =>
      'Intervallo di numeri motore per sorteggiare dalla verifica. Lascialo vuoto se non c\'è sorteggio.';

  @override
  String get motorDesde => 'Motore da';

  @override
  String get motorHasta => 'Motore a';

  @override
  String get indicaAmbos => 'Indica entrambi';

  @override
  String get hastaMayorQueDesde => 'A ≥ da';

  @override
  String get crearSesion => 'Crea sessione';

  @override
  String get importarParticipantesArchivo => 'Importa partecipanti (file)';

  @override
  String get importarParticipantesSheets =>
      'Importa partecipanti (Google Sheets)';

  @override
  String errorAlImportar(String detalle) {
    return 'Errore durante l\'importazione: $detalle';
  }

  @override
  String pasoEligeArchivoN(int n) {
    return '$n. Scegli il file';
  }

  @override
  String pasoEligeLaHoja(int n) {
    return '$n. Scegli il foglio';
  }

  @override
  String pasoEligeLaPestana(int n) {
    return '$n. Scegli la scheda';
  }

  @override
  String pasoAsignaColumnasN(int n) {
    return '$n. Assegna colonne';
  }

  @override
  String pasoVistaPreviaN(int n) {
    return '$n. Anteprima';
  }

  @override
  String get csvPlantillaTexto =>
      'CSV o Excel con una riga di intestazione. Colonne riconosciute: Pilota 1 (o Pilota / Nome), Pilota 2, Squadra e Coppa. C\'è un modello in \"Modelli CSV\".';

  @override
  String get buscarEnTusHojas => 'Cerca nei tuoi fogli…';

  @override
  String get buscar => 'Cerca';

  @override
  String get pestana => 'Scheda';

  @override
  String get piloto1Obligatorio => 'Pilota 1 *';

  @override
  String get piloto2 => 'Pilota 2';

  @override
  String get copaPorDefecto => 'Coppa predefinita';

  @override
  String get copaPorDefectoAyuda =>
      'Per righe senza coppa o con una coppa che non è nella sessione';

  @override
  String get asignaColumnaPiloto1 => 'Assegna almeno la colonna del pilota 1.';

  @override
  String get noHayFilasConPiloto => 'Non ci sono righe con pilota.';

  @override
  String anadirNParticipantes(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n partecipanti',
      one: '1 partecipante',
    );
    return 'Aggiungi $_temp0';
  }

  @override
  String get noConectadoGoogle => 'Non sei ancora connesso a Google';

  @override
  String get conectaCuentaTexto =>
      'Connetti il tuo account una volta per poter leggere i tuoi fogli di calcolo.';

  @override
  String get configurarGoogle => 'Configura Google';

  @override
  String noSePudieronListarHojas(String detalle) {
    return 'Impossibile elencare i tuoi fogli: $detalle';
  }

  @override
  String noSePudieronListarPestanas(String detalle) {
    return 'Impossibile elencare le schede: $detalle';
  }

  @override
  String noSePudoLeerPestana(String detalle) {
    return 'Impossibile leggere la scheda: $detalle';
  }

  @override
  String get yaEstaEnLaSesion => 'Già nella sessione';

  @override
  String copaNoEnSesion(String copa, String defecto) {
    return 'Coppa \"$copa\" non è nella sessione: si usa $defecto';
  }

  @override
  String get fotoCatalogo => 'Foto catalogo';

  @override
  String get pilotos => 'Piloti';

  @override
  String get inscripciones => 'Iscrizioni';

  @override
  String get nuevoPiloto => 'Nuovo pilota';

  @override
  String get editarPiloto => 'Modifica pilota';

  @override
  String get crearPiloto => 'Crea pilota';

  @override
  String get puntuacionPreviaImport => 'Punteggio precedente (1ª gara)';

  @override
  String get buscarPorNombre => 'Cerca per nome…';

  @override
  String get aunNoHayPilotosCampeonato =>
      'Nessun pilota ancora in questo campionato';

  @override
  String get noHayCoincidencias => 'Nessuna corrispondenza';

  @override
  String get pulsaNuevoPiloto =>
      'Tocca il pulsante \"Nuovo pilota\" per aggiungere il primo.';

  @override
  String get quitarDelCampeonato => 'Rimuovi dal campionato';

  @override
  String quitarDelCampeonatoTexto(String piloto, String campeonato) {
    return 'Rimuovere $piloto da \"$campeonato\"?\n\nIl pilota non viene cancellato, solo disiscritto da questo campionato.';
  }

  @override
  String get motivoAjusteManual => 'Aggiustamento manuale (scheda pilota)';

  @override
  String get datosPersonales => 'Dati personali';

  @override
  String get nombreYApellidos => 'Nome e cognome *';

  @override
  String get telefono => 'Telefono';

  @override
  String get email => 'Email';

  @override
  String get palmaresHistorico => 'Palmarès storico';

  @override
  String get palmaresEjemplo =>
      'Es.: \"Top 3 campionato 2025\", \"WES 2023-2024\"';

  @override
  String get pilotoCoordinadora => 'Pilota del coordinamento';

  @override
  String get pilotoCoordinadoraTexto =>
      'Se attivo, le squadre in cui partecipa non pagheranno la quota.';

  @override
  String get enEsteCampeonato => 'In questo campionato';

  @override
  String get categoria => 'Categoria';

  @override
  String get creditosIniciales => 'Crediti iniziali';

  @override
  String get sugeridoSegunCategoria => 'Suggerito in base alla categoria';

  @override
  String get creditosActuales => 'Crediti attuali';

  @override
  String get palmaresLocal => 'Palmarès in questo campionato';

  @override
  String get indicaUnNumero => 'Indica un numero';

  @override
  String get tieneQueSerEntero => 'Deve essere un numero intero';

  @override
  String get noPuedeSerNegativo => 'Non può essere negativo';

  @override
  String get importarPilotos => 'Importa piloti';

  @override
  String get soportaExcelPilotos =>
      'Supporta file Excel (.xlsx) e CSV. Deve avere almeno una colonna con il nome dei piloti.';

  @override
  String resumenImportacionPilotos(int nuevos, int inscritos, int saltados) {
    return '✓ Piloti nuovi: $nuevos\n✓ Iscritti in questo campionato: $inscritos\n✗ Saltati: $saltados';
  }

  @override
  String errorImportando(String detalle) {
    return 'Errore durante l\'importazione: $detalle';
  }

  @override
  String get indicaColumnaNombrePiloto =>
      'Indica quale colonna contiene il nome del pilota.';

  @override
  String get noFilasValidas => 'Nessuna riga valida trovata.';

  @override
  String importarNPilotos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n piloti',
      one: '1 pilota',
    );
    return 'Importa $_temp0';
  }

  @override
  String get paso2AsignaLasColumnas => '2. Assegna le colonne';

  @override
  String get columnasAutodetectadas =>
      'Abbiamo provato a rilevarle automaticamente. Cambiale se serve.';

  @override
  String get categoriaMetal => 'Categoria (metallo)';

  @override
  String get palmares => 'Palmarès';

  @override
  String get nuevo => 'Nuovo';

  @override
  String get importarPuntuacionPrevia => 'Importa punteggio precedente';

  @override
  String get puntuacionPreviaTexto =>
      'Excel (.xlsx) o CSV con il nome del pilota e il suo punteggio. Aggiorna solo i piloti GIÀ iscritti nel campionato attivo (incrocio per nome) — non iscrive nessuno nuovo.';

  @override
  String get puntuacionImportada => 'Punteggio importato';

  @override
  String puntuacionImportadaTexto(int ok, int saltados) {
    return '✓ Aggiornati: $ok\n✗ Saltati: $saltados\n\nQuesto punteggio serve solo per \"Genera batterie\" nella prima gara; appena il campionato avrà risultati propri, la classifica reale lo sostituirà da sola.';
  }

  @override
  String get puntuacionObligatoria => 'Punteggio *';

  @override
  String nDeTotalSeActualizaran(int n, int total) {
    return '$n di $total verranno aggiornati';
  }

  @override
  String get indicaColumnaNombreYPuntuacion =>
      'Indica quale colonna è il nome e quale il punteggio.';

  @override
  String actualizarNPilotos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n piloti',
      one: '1 pilota',
    );
    return 'Aggiorna $_temp0';
  }

  @override
  String get noEstaEnCampeonato => 'Non è nel campionato';

  @override
  String get formulaSinCalcular =>
      'Formula non calcolata — usa \"incolla speciale: valori\"';

  @override
  String get seActualizara => 'Verrà aggiornato';

  @override
  String get aunNoHayEquipos => 'Nessuna squadra ancora';

  @override
  String get creaEquipoDosPilotos =>
      'Crea una squadra con due piloti per iniziare.';

  @override
  String get creaInscripcionIndividual =>
      'Crea un\'iscrizione individuale per iniziare.';

  @override
  String get importarEquipos => 'Importa squadre';

  @override
  String get seleccionaLaCopa => 'Seleziona la coppa.';

  @override
  String get seleccionaUnPiloto => 'Seleziona almeno un pilota.';

  @override
  String get parejasNecesitanDosPilotos =>
      'In questo campionato (coppie) la squadra ha bisogno di due piloti.';

  @override
  String get pilotosRepetidos => 'Ci sono piloti ripetuti nella squadra.';

  @override
  String get eliminarInscripcion => 'Elimina iscrizione';

  @override
  String get eliminarEquipo => 'Elimina squadra';

  @override
  String eliminarInscripcionTexto(String nombre) {
    return 'Eliminare l\'iscrizione di \"$nombre\"? Questa azione non si può annullare.';
  }

  @override
  String eliminarEquipoTexto(String nombre) {
    return 'Eliminare la squadra \"$nombre\"? Questa azione non si può annullare.';
  }

  @override
  String get editarInscripcion => 'Modifica iscrizione';

  @override
  String get editarEquipo => 'Modifica squadra';

  @override
  String get primeroAnadePilotos =>
      'Prima aggiungi piloti al campionato per poter creare squadre.';

  @override
  String get indicaUnNombre => 'Indica un nome';

  @override
  String get copaCategoriaObligatoria => 'Coppa / categoria *';

  @override
  String get piloto => 'Pilota';

  @override
  String get pilotosDelEquipo => 'Piloti della squadra';

  @override
  String pilotoN(int n) {
    return 'Pilota $n';
  }

  @override
  String get cocheEnVerificacionTexto =>
      'L\'auto si indica nella verifica di ogni batteria. Una squadra può usare auto diverse in gare diverse.';

  @override
  String get crearEquipo => 'Crea squadra';

  @override
  String get elegirPiloto => '— scegli pilota —';

  @override
  String equipoImportTexto(String pilotos) {
    return 'Carica il CSV o Excel del Google Form di preseason. Ogni riga deve essere una squadra con il nome della squadra e $pilotos.';
  }

  @override
  String get susDosPilotos => 'i suoi due piloti';

  @override
  String get suPiloto => 'il suo pilota';

  @override
  String get asignaColumnaEquipoYPiloto =>
      'Assegna almeno la colonna del nome della squadra e quella del primo pilota.';

  @override
  String importarNEquipos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n squadre',
      one: '1 squadra',
    );
    return 'Importa $_temp0';
  }

  @override
  String resumenImportacionEquipos(
    int equipos,
    int pilotosNuevos,
    int pilotosInscritos,
    int saltados,
  ) {
    return '✓ Squadre create: $equipos\n✓ Piloti nuovi: $pilotosNuevos\n✓ Piloti iscritti al campionato: $pilotosInscritos\n✗ Saltati: $saltados';
  }

  @override
  String get columnasIntentadas =>
      'Abbiamo provato a rilevarle. Cambia quelle sbagliate.';

  @override
  String get yaExiste => 'Esiste già';

  @override
  String get sinPiloto => 'Senza pilota';

  @override
  String get faltaSegundoPiloto =>
      'Manca il secondo pilota (campionato a coppie)';

  @override
  String get nombreObligatorio => 'Nome *';

  @override
  String get nombreCampo => 'Nome';

  @override
  String get piloto1 => 'Pilota 1';

  @override
  String get piloto2Opcional => 'Pilota 2 (opzionale)';

  @override
  String formatoNoSoportadoUsaCsv(String ext) {
    return 'Formato non supportato: $ext. Usa .csv o .xlsx';
  }

  @override
  String get tablaDePuntos => 'Tabella punti';

  @override
  String get rellenarAMano => 'Compila a mano';

  @override
  String get aunNoHayClasificacion => 'Nessuna classifica ancora';

  @override
  String get clasificacionVaciaTexto =>
      'Registra risultati di batteria, importala da un file o compilala a mano.';

  @override
  String get importarClasificacion => 'Importa classifica';

  @override
  String get general => 'Generale';

  @override
  String noHayPilotosEn(String titulo) {
    return 'Nessun pilota in \"$titulo\".';
  }

  @override
  String get todosLosPilotosCampeonato => 'Tutti i piloti del campionato';

  @override
  String pilotosDeCopa(String copa) {
    return 'Piloti della coppa $copa';
  }

  @override
  String nPilotos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n piloti',
      one: '1 pilota',
    );
    return '$_temp0';
  }

  @override
  String get equipo => 'Squadra';

  @override
  String get catAbrev => 'Cat.';

  @override
  String get bruto => 'Lordo';

  @override
  String get descAbrev => 'Scarto';

  @override
  String get totalMayusculas => 'TOTALE';

  @override
  String get clasificacionAMano => 'Classifica manuale';

  @override
  String clasificacionAManoCopa(String copa) {
    return 'Classifica manuale · $copa';
  }

  @override
  String get sinPruebasParaPuntos =>
      'Questo campionato non ha gare. Crea prima le gare per poter assegnare punti.';

  @override
  String get sinPilotosConEquipo =>
      'Non ci sono piloti con squadra in questo campionato. Assegna prima le squadre ai piloti.';

  @override
  String get editorManualTexto =>
      'Scrivi i punti di ogni pilota per gara. Si salvano da soli uscendo da ogni casella. Casella vuota = non ha segnato; 0 = ha partecipato con 0.';

  @override
  String get restaurarValores => 'Ripristina valori predefiniti';

  @override
  String get restaurar => 'Ripristina';

  @override
  String get restaurarTexto =>
      'La tabella punti attuale sarà sostituita con quella di PitWall Control (70, 64, 59… fino a 1 punto). Le modifiche non vengono salvate finché non tocchi \"Salva\".';

  @override
  String posN(int n) {
    return 'Pos. $n';
  }

  @override
  String get puntosMayus => 'Punti';

  @override
  String get quitarUltimaPosicion => 'Rimuovi l\'ultima posizione';

  @override
  String get anadirPosicion => 'Aggiungi posizione';

  @override
  String get csvExcel => 'CSV / Excel';

  @override
  String get googleSheets => 'Google Sheets';

  @override
  String get listarHojas => 'Elenca fogli';

  @override
  String get seleccionaArchivoClasificacion =>
      'Seleziona un file CSV o Excel con la classifica. La prima riga deve essere l\'intestazione, con una colonna \"Pilota\" e una colonna per ogni gara.';

  @override
  String archivoNombre(String nombre) {
    return 'File: $nombre';
  }

  @override
  String get seleccionaHojaClasificacion =>
      'Seleziona il foglio Drive con la classifica.';

  @override
  String hojaNombre(String nombre) {
    return 'Foglio: $nombre';
  }

  @override
  String get pulsaListarHojas => 'Tocca \"Elenca fogli\" per iniziare.';

  @override
  String pruebasReconocidas(int n) {
    return 'Gare riconosciute: $n';
  }

  @override
  String noReconocidasCampo(String lista) {
    return 'Non riconosciute: $lista';
  }

  @override
  String pilotosOk(int n) {
    return 'Piloti OK: $n';
  }

  @override
  String pilotosConProblemas(int n) {
    return 'Piloti con problemi: $n';
  }

  @override
  String get conectaGooglePrimero =>
      'Connetti prima il tuo account Google in Impostazioni → Google.';

  @override
  String importadosResultados(int registros, int pilotos) {
    return 'Importati $registros risultati di $pilotos piloti. Torna alla classifica per vederla aggiornata.';
  }

  @override
  String get estadoOk => 'OK';

  @override
  String get pilotoNoEncontrado => 'Pilota non trovato';

  @override
  String get pilotoSinEquipo => 'Pilota senza squadra in questo campionato';

  @override
  String get sinPuntosImportables => 'Nessun punto importabile';

  @override
  String get noEncuentroColumnaPiloto =>
      'Non trovo la colonna del pilota. La prima riga deve contenere una colonna chiamata \"Pilota\", \"Nome\" o \"Squadra\".';

  @override
  String get importando => 'Importazione…';

  @override
  String get puntosNoValidos =>
      'C\'è una posizione con un valore di punti non valido.';

  @override
  String get tablaGuardada => 'Tabella punti salvata.';

  @override
  String get reparto => 'Ripartizione';

  @override
  String get movimiento => 'Movimento';

  @override
  String get sinCampeonatoActivo => 'Nessun campionato attivo';

  @override
  String cuotaPorPruebaTexto(String pagat, String coord, String club) {
    return 'Quota per gara: $pagat (coordinamento $coord · club $club)';
  }

  @override
  String get porPrueba => 'Per gara';

  @override
  String get repartoDeLaCuota => 'Ripartizione della quota';

  @override
  String get repartoTexto =>
      'Quanto paga ogni squadra per gara e dove va. Cambiando coordinamento o club, l\'altro si adegua per fare il totale del Pagato.';

  @override
  String get pagatCuotaTotal => 'Pagato (quota totale) €';

  @override
  String get coordinadoraEur => 'Coordinamento €';

  @override
  String get clubEur => 'Club €';

  @override
  String get pagatMayorQueCero => 'Il Pagato deve essere maggiore di 0.';

  @override
  String get coordClubSumanPagat =>
      'Coordinamento + club devono fare il totale del Pagato.';

  @override
  String get aplicarAPagosCobrados =>
      'Applica anche ai pagamenti già incassati';

  @override
  String get aplicarAPagosCobradosTexto =>
      'Ridistribuisce quanto ha pagato ogni squadra con la nuova proporzione. L\'incassato non cambia.';

  @override
  String repartoGuardadoRecalculado(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pagamenti ricalcolati.',
      one: '1 pagamento ricalcolato.',
    );
    return 'Ripartizione salvata. $_temp0';
  }

  @override
  String get repartoGuardado =>
      'Ripartizione salvata. Si applicherà ai prossimi pagamenti.';

  @override
  String get nuevoMovimiento => 'Nuovo movimento';

  @override
  String get editarMovimiento => 'Modifica movimento';

  @override
  String get ingreso => 'Entrata';

  @override
  String get gasto => 'Spesa';

  @override
  String get conceptoObligatorio => 'Descrizione *';

  @override
  String get conceptoEjemplo => 'Es.: Sponsorizzazione, Materiale, Premio…';

  @override
  String get importeObligatorio => 'Importo (€) *';

  @override
  String get importeAyuda => 'Solo il numero, senza segno';

  @override
  String get notas => 'Note';

  @override
  String get movimientosExtras => 'Movimenti extra';

  @override
  String get ingresosYGastosSueltos => '(entrate e spese singole)';

  @override
  String get sinMovimientosTexto =>
      'Nessun movimento. Usa il pulsante \"+ Movimento\" per aggiungere sponsorizzazioni, spese di materiale, ecc.';

  @override
  String get balanceCampeonato => 'Bilancio del campionato';

  @override
  String get masIngresos => '+ Entrate';

  @override
  String get menosGastos => '− Spese';

  @override
  String get coordAbrev => 'Coord.';

  @override
  String get tesoreriaDeLaPrueba => 'Cassa della gara';

  @override
  String get buscarPilotoOEquipo => 'Cerca pilota o squadra…';

  @override
  String get borrar => 'Cancella';

  @override
  String get sinEquiposInscritos => 'Nessuna squadra iscritta';

  @override
  String get recaudadoEnPrueba => 'Incassato nella gara';

  @override
  String pagadosDe(int pagados, int total) {
    return '$pagados / $total pagati';
  }

  @override
  String exentosNoPagan(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n esenti',
      one: '1 esente',
    );
    return '$_temp0 non pagano';
  }

  @override
  String nadieCoincide(String filtro) {
    return 'Nessuno corrisponde a \"$filtro\".';
  }

  @override
  String get exencionWildcard => 'Wildcard';

  @override
  String get exencionCoordinadora => 'Piloti del coordinamento';

  @override
  String pagaMitad(String piloto) {
    return 'Paga metà — $piloto è del coordinamento';
  }

  @override
  String get revisionCategorias => 'Revisione categorie (chiusura)';

  @override
  String get aplicarBonificacion => 'Applica bonus di chiusura';

  @override
  String get aunNoHayPilotosInscritos =>
      'Nessun pilota ancora iscritto in questo campionato.';

  @override
  String get bonificacionCierre => 'Bonus di chiusura';

  @override
  String bonificacionCierreTexto(String tope) {
    return 'Il saldo di ogni pilota che ha gareggiato verrà regolarizzato:\n\nsaldo = min(saldo attuale + bonus secondo categoria e numero di gare, $tope).\n\nSi applica solo a chi non lo ha ancora. Continuare?';
  }

  @override
  String bonificacionAplicada(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n piloti',
      one: '1 pilota',
    );
    return 'Bonus applicato a $_temp0.';
  }

  @override
  String inicialUsados(int inicial, int usados) {
    return 'Iniziale $inicial  ·  Usati $usados';
  }

  @override
  String ajustarCreditos(String piloto) {
    return 'Ajusta crediti · $piloto';
  }

  @override
  String get creditosActualesSaldo => 'Crediti attuali (saldo)';

  @override
  String get creditosAjustados => 'Crediti aggiornati';

  @override
  String get ajustarCreditosMano => 'Ajusta crediti a mano';

  @override
  String get usados => 'Usati';

  @override
  String get saldoMayus => 'SALDO';

  @override
  String get movimientos => 'Movimenti';

  @override
  String get inscripcionAlCampeonato => 'Iscrizione al campionato';

  @override
  String get sinMovimientosTodavia => 'Nessun movimento ancora.';

  @override
  String huecoSinJustificar(int n) {
    return '$n cred. non giustificati';
  }

  @override
  String descuadreSaldo(String actual, String inicial, String suma) {
    return 'Il saldo attuale ($actual) non quadra con iniziale $inicial $suma movimenti. Probabilmente veniva così dall\'importazione o è stato modificato a mano prima di attivare il registro.';
  }

  @override
  String get estadoPromociona => 'Promosso';

  @override
  String get estadoDesciende => 'Retrocesso';

  @override
  String get estadoSeMantiene => 'Resta';

  @override
  String get bajar => 'Abbassa';

  @override
  String get mantener => 'Mantieni';

  @override
  String get subir => 'Alza';

  @override
  String get noHayPilotosCompetido =>
      'Nessun pilota ha gareggiato in questo campionato.';

  @override
  String get revisionTexto =>
      'Ajusta la categoria di ogni pilota prima di concludere. Servirà per il bonus di chiusura e come categoria iniziale del prossimo campionato.';

  @override
  String get motivoAjusteCreditos => 'Aggiustamento manuale (crediti)';

  @override
  String get verificarEnEquipoWifi => 'Verifica in squadra (wifi)';

  @override
  String verificarEnEquipoN(int n) {
    return 'Verifica in squadra · $n';
  }

  @override
  String verificarEnEquipoNConectados(int n) {
    return 'Verifica in squadra · $n connessi';
  }

  @override
  String get syncIntroTexto =>
      'Più Control possono lavorare su questa gara contemporaneamente. Ognuno salva sul proprio dispositivo e le modifiche viaggiano via wifi: verifiche con foto, coppa e incassi, e anche le nuove schede (piloti, squadre, la loro categoria nel campionato e iscritti alla gara, e le loro rinunce), le batterie con le loro corsie e i risultati.\n\n• Tutti sulla stessa wifi. Non serve internet: va bene un router senza connessione o l\'hotspot di un telefono.\n• La prima volta, partite tutti dalla stessa copia di dati. I cataloghi e la configurazione del campionato non viaggiano ancora.\n• La stessa chiave dell\'evento su tutti, e l\'ora automatica attiva: se due toccano la stessa cosa, vince l\'ultima modifica.';

  @override
  String get nombreDeEsteControl => 'Nome di questo Control';

  @override
  String get nombreControlAyuda =>
      'Diverso su ogni dispositivo (es. \"Tavolo 1\").';

  @override
  String get claveDelEvento => 'Chiave dell\'evento';

  @override
  String get claveEventoAyuda => 'La stessa su tutti i Control.';

  @override
  String get conectarConOtros => 'Connetti con altri Control';

  @override
  String visibleComo(String nombre) {
    return 'Visibile come \"$nombre\"';
  }

  @override
  String get conectando => 'Connessione…';

  @override
  String get apagado => 'Spento';

  @override
  String get controlsEnLaRed => 'Control sulla rete';

  @override
  String get anadirPorDireccion => 'Aggiungi per indirizzo';

  @override
  String get anadirControlPorDireccion => 'Aggiungi Control per indirizzo';

  @override
  String get ipOPuerto => 'IP (o IP:porta)';

  @override
  String get ipAyuda =>
      'La vedi su questa stessa schermata dell\'altro Control.';

  @override
  String get buscandoOtrosControls => 'Ricerca di altri Control sulla wifi…';

  @override
  String get noSeEncuentraControl =>
      'Nessun Control trovato. Controlla che gli altri abbiano questa schermata con «Connetti» attivo e siano sulla stessa wifi, o aggiungili per indirizzo.';

  @override
  String dosControlsMismoNombre(String nombre) {
    return 'C\'è un altro Control che si chiama anch\'esso \"$nombre\". Cambia il nome di uno dei due.';
  }

  @override
  String claveNoCoincide(String host) {
    return '$host · la chiave dell\'evento non coincide';
  }

  @override
  String get quitarDeLaLista => 'Rimuovi dalla lista';

  @override
  String get sincronizarAutomaticamente => 'Sincronizza automaticamente';

  @override
  String cadaNsAppAbierta(int n) {
    return 'Ogni $n s mentre l\'app è aperta';
  }

  @override
  String get sincronizando => 'Sincronizzazione…';

  @override
  String get sincronizarAhora => 'Sincronizza ora';

  @override
  String ultimaSincronizacion(String hora) {
    return 'Ultima sincronizzazione: $hora';
  }

  @override
  String get syncSinCambios => 'Nessun cambiamento';

  @override
  String nEquipos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n squadre',
      one: '1 squadra',
    );
    return '$_temp0';
  }

  @override
  String nPerfiles(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n profili',
      one: '1 profilo',
    );
    return '$_temp0';
  }

  @override
  String nInscritos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n iscritti',
      one: '1 iscritto',
    );
    return '$_temp0';
  }

  @override
  String nTandas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n batterie',
      one: '1 batteria',
    );
    return '$_temp0';
  }

  @override
  String resultadosDeNTandas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n batterie',
      one: '1 batteria',
    );
    return 'risultati di $_temp0';
  }

  @override
  String nBajas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n rinunce',
      one: '1 rinuncia',
    );
    return '$_temp0';
  }

  @override
  String nVerifNuevas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n nuove verifiche',
      one: '1 nuova verifica',
    );
    return '$_temp0';
  }

  @override
  String nVerifActualizadas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n aggiornate',
      one: '1 aggiornata',
    );
    return '$_temp0';
  }

  @override
  String nVerifBorradas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n cancellate',
      one: '1 cancellata',
    );
    return '$_temp0';
  }

  @override
  String nCopas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n coppe',
      one: '1 coppa',
    );
    return '$_temp0';
  }

  @override
  String nCobros(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n incassi',
      one: '1 incasso',
    );
    return '$_temp0';
  }

  @override
  String get syncSinClave => 'Inserisci una chiave dell\'evento.';

  @override
  String syncNoSePudoAbrir(String detalle) {
    return 'Impossibile aprire la connessione: $detalle';
  }

  @override
  String get syncFormatoDesconocido =>
      'Formato di sincronizzazione sconosciuto.';

  @override
  String get syncOtraVersion =>
      'L\'altro Control ha un\'altra versione di PitWall Control. Aggiornate tutti alla stessa versione.';

  @override
  String syncVerifNoExiste(String equipo, String manga) {
    return 'Verifica di \"$equipo\" in \"$manga\": quella batteria o squadra non esiste qui.';
  }

  @override
  String syncCocheNoCatalogo(String equipo, String coche) {
    return '$equipo: l\'auto \"$coche\" non è nel catalogo di questo Control.';
  }

  @override
  String syncTandaFaltaEquipo(String tanda) {
    return 'Batteria \"$tanda\": qui manca una squadra; la sua corsia resta vuota.';
  }

  @override
  String syncResultFaltaPiloto(String tanda) {
    return 'Risultati di \"$tanda\": qui manca un pilota o una squadra; quella riga non viene copiata.';
  }

  @override
  String syncEquipoFaltanPilotos(String equipo) {
    return 'Squadra \"$equipo\": qui mancano alcuni dei suoi piloti; non viene copiata.';
  }

  @override
  String get syncSinRespuesta => 'Non risponde (è ancora sulla stessa wifi?).';

  @override
  String get syncSinConexion =>
      'Impossibile connettersi (è ancora sulla stessa wifi?).';

  @override
  String get syncControlAnadido => 'Control aggiunto.';

  @override
  String syncNoHayControlEn(String dir) {
    return 'Nessun Control connesso su $dir.';
  }

  @override
  String get primeroInscribeEquipos => 'Prima iscrivi squadre alla gara.';

  @override
  String get sinCoincidenciasPunto => 'Nessuna corrispondenza.';

  @override
  String get ajusteManualHistorial =>
      'La modifica del saldo viene annotata come \"Aggiustamento manuale\" nello storico.';

  @override
  String bonifTope(int bonif, int tope) {
    return '+$bonif, limitato al massimo $tope';
  }

  @override
  String desfaseHora(int min) {
    return 'L\'ora dell\'altro Control si discosta di $min min da quella di questo dispositivo. Attiva l\'ora automatica su tutti.';
  }

  @override
  String nCarreras(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n gare',
      one: '1 gara',
    );
    return '$_temp0';
  }

  @override
  String bonifMotivo(String carreras, String categoria, int bonif) {
    return 'Bonus di chiusura per $carreras ($categoria): +$bonif';
  }

  @override
  String bonifLimiteTope(int tope) {
    return ', limitato al massimo $tope';
  }
}
