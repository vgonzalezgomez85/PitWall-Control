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
}
