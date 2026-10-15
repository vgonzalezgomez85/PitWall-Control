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

  @override
  String get nuevaPrueba => 'New race';

  @override
  String get seleccionaCampeonato => 'Select a championship first';

  @override
  String get aunNoHayPruebas => 'No races yet';

  @override
  String get aunNoHayPruebasTexto =>
      'Create the championship\'s first race (for example \"EL SOT\", \"SLOTMANIA\"…).';

  @override
  String get estadoProgramada => 'Scheduled';

  @override
  String get estadoEnCurso => 'In progress';

  @override
  String get estadoTerminada => 'Finished';

  @override
  String get estadoCancelada => 'Cancelled';

  @override
  String get resumenVerificaciones => 'Scrutineering summary';

  @override
  String get aunNoHayTandas => 'No rounds yet';

  @override
  String get verificarSinTandasTexto =>
      'Enter teams and create the rounds in the Prepare tab.';

  @override
  String validadasDe(int validadas, int total) {
    return '$validadas / $total validated';
  }

  @override
  String get sinEquiposEnTanda => 'No teams in this round.';

  @override
  String get carreraTienePole => 'Does the race have a pole?';

  @override
  String get carreraTienePoleTexto =>
      'With a pole the lane order is not exported: PitWall creates the pole session and the grid is set after it is run.';

  @override
  String get sinPole => 'No pole';

  @override
  String get conPole => 'With pole';

  @override
  String get noHayInscritosExportar => 'There are no entries to export.';

  @override
  String get noHayTandasConCarriles =>
      'There are no rounds with assigned lanes to export.';

  @override
  String get importarDelCronometraje => 'Import from timing';

  @override
  String get traerResultadosPitwall => 'Get results from PitWall';

  @override
  String get prueba => 'Race';

  @override
  String get editar => 'Edit';

  @override
  String get pestanaPreparar => 'Prepare';

  @override
  String get pestanaVerificar => 'Scrutineer';

  @override
  String get pestanaResultados => 'Results';

  @override
  String get pestanaCaja => 'Payments';

  @override
  String get nuevaTanda => 'New round';

  @override
  String get compartir => 'Share';

  @override
  String get pdfTandas => 'Rounds PDF';

  @override
  String get pdfVerificaciones => 'Scrutineering PDF';

  @override
  String get enviarTandasPitwall => 'Send rounds to PitWall';

  @override
  String get porWifiSinArchivo => 'Over wifi, no file';

  @override
  String get enviarVerificacionesPitwall => 'Send scrutineering to PitWall';

  @override
  String get soloConsultaManager => 'Read-only in Manager';

  @override
  String get archivoParaPitwall => 'File for PitWall (JSON)';

  @override
  String get paraImportarAManoManager => 'To import it manually in Manager';

  @override
  String get noEncontrada => 'Not found';

  @override
  String get editarTandas => 'Edit rounds';

  @override
  String get sorteoMotores => 'Engine draw';

  @override
  String get tandas => 'Rounds';

  @override
  String get crearTandasTexto =>
      'Create the rounds this race will have (Thursday 21:00, Friday 21:00…).';

  @override
  String pruebaNumero(int orden) {
    return 'Race #$orden';
  }

  @override
  String nCarriles(int n) {
    return '$n lanes';
  }

  @override
  String noSePudoGuardar(String detalle) {
    return 'Could not save: $detalle';
  }

  @override
  String get eliminarPrueba => 'Delete race';

  @override
  String eliminarPruebaTexto(String nombre) {
    return 'Delete \"$nombre\"?\n\nIts rounds, entries, results and scrutineering will also be deleted. This cannot be undone.';
  }

  @override
  String get eliminar => 'Delete';

  @override
  String get editarPrueba => 'Edit race';

  @override
  String get nombrePruebaObligatorio => 'Race name *';

  @override
  String get nombrePruebaAyuda => 'E.g. EL SOT, SLOTMANIA, GASCLAVAT…';

  @override
  String get indicaElNombre => 'Enter a name';

  @override
  String get sedeClub => 'Venue / club';

  @override
  String get sinFechaAsignada => 'No date set';

  @override
  String get quitarFecha => 'Remove date';

  @override
  String get elegir => 'Choose';

  @override
  String get cambiar => 'Change';

  @override
  String get ordenCampeonato => 'Order in the championship';

  @override
  String get ordenCampeonatoAyuda => 'Position in the calendar (1, 2, 3…)';

  @override
  String get numeroEntero => 'Whole number';

  @override
  String get estado => 'Status';

  @override
  String get crearPrueba => 'Create race';

  @override
  String get guardarCambios => 'Save changes';

  @override
  String get eliminarTanda => 'Delete round';

  @override
  String eliminarTandaTexto(String nombre) {
    return 'Delete the round \"$nombre\"? Its entries, results and scrutineering will also be deleted.';
  }

  @override
  String get editarTanda => 'Edit round';

  @override
  String get nombreTandaObligatorio => 'Round name *';

  @override
  String get nombreTandaAyuda => 'E.g. Thursday 21:00, Friday 23:00…';

  @override
  String get sinFechaHora => 'No date and time set';

  @override
  String get quitar => 'Remove';

  @override
  String get numeroCarriles => 'Number of lanes';

  @override
  String get numeroCarrilesAyuda => 'Usually 6, 7 or 8 (up to 32)';

  @override
  String get numeroCarrilesError => 'Enter a number between 1 and 32';

  @override
  String get pisters => 'Marshals';

  @override
  String get pistersAyuda => 'Round whose drivers act as marshals in this one';

  @override
  String get sinPisters => '— no marshals —';

  @override
  String pilotosDe(String nombre) {
    return 'Drivers of $nombre';
  }

  @override
  String get crearTanda => 'Create round';

  @override
  String get pruebaSinTandas => 'This race has no rounds yet';

  @override
  String get generaTandasDesdeInscritos =>
      'Generate them from Entries → Generate rounds.';

  @override
  String get tocaEquipoParaMover => 'Tap a team to move it to another round.';

  @override
  String nEquiposAbrev(int n) {
    return '$n teams';
  }

  @override
  String get sinEquipos => 'No teams';

  @override
  String moverEquipoA(String nombre) {
    return 'Move \"$nombre\" to…';
  }

  @override
  String tandaConEquipos(String nombre, int n) {
    return '$nombre  ($n teams)';
  }

  @override
  String get darDeBajaPrueba => 'Withdraw from the race';

  @override
  String get eligePitwall => 'Choose a PitWall or type its address.';

  @override
  String get noHayInscritosEnviar => 'There are no entries to send.';

  @override
  String get noHayTandasEnviar =>
      'There are no rounds with assigned lanes to send.';

  @override
  String get enviarAPitwall => 'Send to PitWall';

  @override
  String get pinImportacion => 'Import PIN';

  @override
  String get pinImportacionAyuda =>
      'The PIN shown by PitWall in \"Import round\".';

  @override
  String get carreraTienePoleSi => 'The race has a pole';

  @override
  String get carreraTienePoleAyuda =>
      'The lane order is not sent: the grid is set in PitWall after the pole';

  @override
  String get activarCategoria => 'Activate category';

  @override
  String get activarCategoriaAyuda =>
      'Sends each team\'s category/cup and PitWall activates it in the race';

  @override
  String get activarCoche => 'Activate car';

  @override
  String get activarCocheAyuda =>
      'Sends each team\'s car from the verifications and PitWall activates it in the race';

  @override
  String get actualizarCarreraEnviada => 'Update the race already sent';

  @override
  String actualizarCarreraEnviadaAyuda(String id) {
    return 'PitWall race #$id: rounds already run are left untouched; pending ones are rebuilt with the current data';
  }

  @override
  String carreraCreadaPitwall(String nombre, String tandas, String equipos) {
    return 'Race created: $nombre — $tandas round(s), $equipos team(s).';
  }

  @override
  String carreraActualizadaPitwall(
    String nombre,
    String actualizadas,
    String nuevas,
    String borradas,
  ) {
    return 'Race updated: $nombre — $actualizadas round(s) rebuilt, $nuevas new, $borradas removed.';
  }

  @override
  String tandasCorridasSinTocar(String lista) {
    return 'Rounds already run, left untouched: $lista.';
  }

  @override
  String poleActualizadaPitwall(String nombre, String equipos) {
    return 'Pole updated: $nombre — $equipos participant(s).';
  }

  @override
  String get enviar => 'Send';

  @override
  String get pitwallEnLaRed => 'PitWall on the network';

  @override
  String get buscarDeNuevo => 'Search again';

  @override
  String get buscandoPitwall => 'Looking for PitWall on the local network…';

  @override
  String get noSeEncuentraPitwall =>
      'No PitWall found. Check that it is open and on the same Wi‑Fi network, or type its address below.';

  @override
  String get direccionIpPuerto => 'Address (IP:port)';

  @override
  String get resultadosDeLaTanda => 'Round results';

  @override
  String get noHayEquiposEnTanda => 'No teams in this round';

  @override
  String get inscribeEquiposParaResultados =>
      'Enter teams to record their results.';

  @override
  String get indicaPosicionFinalTexto =>
      'Set each team\'s final position. Points are calculated automatically from the championship table.';

  @override
  String get puntos => 'points';

  @override
  String get posicion => 'Position';

  @override
  String get sinAsignar => 'Unassigned';

  @override
  String get aRestar => 'To deduct';

  @override
  String get creditosMin => 'credits';

  @override
  String get noHayInscritosEnPrueba => 'No entries in this race';

  @override
  String get inscribeEquiposGeneraTandas =>
      'Enter teams and generate the rounds. You can then import the timing results here.';

  @override
  String equiposConResultado(int con, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total teams',
      one: '1 team',
    );
    return '$con of $_temp0 with a recorded result.';
  }

  @override
  String get resultadosDeLaPrueba => 'Race results';

  @override
  String get importarDesdeArchivoCronometraje => 'Import from timing file';

  @override
  String copaYManga(String copa, String manga) {
    return 'Cup $copa  ·  $manga';
  }

  @override
  String get posAbrev => 'Pos.';

  @override
  String get archivos => 'Files';

  @override
  String get noSeEncontraronResultados =>
      'No results found. The file must have columns such as \"Position\" and \"Name\" (TicTacSlot format or similar).';

  @override
  String noSePudoLeerArchivo(String detalle) {
    return 'Could not read the file: $detalle';
  }

  @override
  String get importacionCompletada => 'Import complete';

  @override
  String resumenImportacionResultados(int ok, int inscritos, int saltados) {
    return '✓ Results applied: $ok\n+ Automatically entered: $inscritos\n✗ Skipped: $saltados';
  }

  @override
  String get ok => 'OK';

  @override
  String get importarResultadosPrueba => 'Import race results';

  @override
  String get paso1EligeArchivo => '1. Choose the file';

  @override
  String get importaArchivoTexto =>
      'Import the file from the timing system (TicTacSlot, SloTime…). Each team in the file is assigned to the round of this race where it is entered.';

  @override
  String get elegirArchivo => 'Choose file';

  @override
  String get resultadosGenerales => 'Overall results';

  @override
  String get crearTandaResultadosGenerales =>
      'Create \"Overall results\" round';

  @override
  String get pruebaSinTandasAviso =>
      'The race has no rounds yet. Results are recorded in a round created on the fly.';

  @override
  String get paso2VistaPrevia => '2. Preview';

  @override
  String nDeTotalSeAplicaran(int n, int total) {
    return '$n of $total will be applied';
  }

  @override
  String equiposNoExistenAviso(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '⚠️ $n teams from the file do not exist in the championship.',
      one: '⚠️ 1 team from the file does not exist in the championship.',
    );
    return '$_temp0';
  }

  @override
  String aplicarResultadosA(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n teams',
      one: '1 team',
    );
    return 'Apply results to $_temp0';
  }

  @override
  String get noExiste => 'Not found';

  @override
  String get seInscribira => 'Will be entered';

  @override
  String get aplicar => 'Apply';

  @override
  String copaTexto(String copa) {
    return 'Cup $copa';
  }

  @override
  String nVueltas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n laps',
      one: '1 lap',
    );
    return '$_temp0';
  }

  @override
  String formatoNoSoportado(String ext) {
    return 'Unsupported format: $ext';
  }

  @override
  String get sortearRestantes => 'Draw remaining';

  @override
  String get pruebaNoEncontrada => 'Race not found';

  @override
  String get noHayEquiposInscritosTandas =>
      'No teams entered in the rounds of this race.';

  @override
  String sorteoBloqueadoTexto(String motivo) {
    return '$motivo The draw is now read-only.';
  }

  @override
  String get equipos => 'Teams';

  @override
  String get numeros => 'Numbers';

  @override
  String get noQuedanMotores => 'No engines left available.';

  @override
  String get motorSorteado => 'Drawn engine';

  @override
  String get repetir => 'Repeat';

  @override
  String get asignar => 'Assign';

  @override
  String faltanMotores(int equipos, int motores) {
    return 'Not enough engines: $equipos teams and only $motores engines available.';
  }

  @override
  String motoresRango(int min, int max) {
    return 'Engines $min–$max';
  }

  @override
  String asignadosDe(int asignados, int total) {
    return '$asignados/$total assigned';
  }

  @override
  String disponiblesN(int n) {
    return '$n available';
  }

  @override
  String get sortear => 'Draw';

  @override
  String numeroMotor(int n) {
    return 'No. $n';
  }

  @override
  String get volverASortear => 'Draw again';

  @override
  String get quitarMotor => 'Remove engine';

  @override
  String get faltaRangoMotores => 'Engine range not configured';

  @override
  String get faltaRangoMotoresTexto =>
      'Set the organisation engine number range in the championship to be able to draw them.';

  @override
  String get configurarCampeonato => 'Configure championship';

  @override
  String get rangoMotoresNoConfigurado => 'Engine range not configured.';

  @override
  String get asignado => 'Assigned';

  @override
  String get disponible => 'Available';

  @override
  String get tanda => 'Round';

  @override
  String get verificaciones => 'Scrutineering';

  @override
  String get renumerarCarriles => 'Renumber lanes';

  @override
  String get renumerar => 'Renumber';

  @override
  String renumerarCarrilesTexto(String nombre, int carriles) {
    return 'All lanes of \"$nombre\" are reassigned by points, highest to lowest: 1 to $carriles and, if there are more drivers, D1, D2… Manual changes are lost.';
  }

  @override
  String get inscribirEquipo => 'Enter team';

  @override
  String get aunNoHayEquiposInscritos => 'No teams entered yet';

  @override
  String get pulsaInscribirEquipo =>
      'Tap \"Enter team\" to add them one by one, assigning a starting lane.';

  @override
  String sinCarrilN(int n) {
    return 'No lane ($n)';
  }

  @override
  String get actual => 'current';

  @override
  String get libre => 'free';

  @override
  String get libreTitulo => 'Free';

  @override
  String carrilDe(String nombre) {
    return 'Lane of $nombre';
  }

  @override
  String get tocaCarrilLibreTexto =>
      'Tap a free lane to move it there, or an occupied one to swap them.';

  @override
  String get pista => 'Track';

  @override
  String get descanso => 'Rest';

  @override
  String get seedDirecto => 'Direct seed';

  @override
  String get sinCarril => 'No lane';

  @override
  String get escribirAMano => 'Type manually…';

  @override
  String get carrilDeSalida => 'Starting lane';

  @override
  String get carrilEjemplo => 'E.g. D1, D2, 1, 2, 3…';

  @override
  String get carrilAyuda => 'D1-D4 for direct seeds, 1-N for the draw';

  @override
  String get guardar => 'Save';

  @override
  String quienSaleEnCarril(String carril) {
    return 'Who starts from lane $carril?';
  }

  @override
  String dejaLibreEl(String carril) {
    return 'Frees up lane $carril';
  }

  @override
  String get carrilesRepetidos => 'Repeated lanes';

  @override
  String pistersPilotosDe(String tanda) {
    return 'Marshals: drivers of $tanda';
  }

  @override
  String get cambiarCarril => 'Change lane';

  @override
  String get quitarSeedDirecto => 'Remove direct seed';

  @override
  String get marcarSeedDirecto => 'Mark as direct seed';

  @override
  String get quitarDeLaTanda => 'Remove from the round';

  @override
  String get quitarInscripcion => 'Remove entry';

  @override
  String quitarInscripcionTexto(String nombre) {
    return 'Remove \"$nombre\" from this round?';
  }

  @override
  String inscribirEquipoEn(String nombre) {
    return 'Enter team in \"$nombre\"';
  }

  @override
  String get buscarEquipoOPiloto => 'Search team or driver…';

  @override
  String get noHayEquiposEnCampeonatoCrealos =>
      'There are no teams in this championship. Create them first.';

  @override
  String get todosLosEquiposYaInscritos => 'All teams are already entered.';

  @override
  String get inscribir => 'Enter';

  @override
  String get carrilEjemploCorto => 'E.g. D1, 3…';

  @override
  String get carrilAyudaVacio => 'Leave empty if you don\'t assign a lane yet';

  @override
  String get inscritosALaPrueba => 'Race entries';

  @override
  String get actualizarDesdeDrive => 'Update from Drive';

  @override
  String get actualizandoDesdeDrive => 'Updating from Drive…';

  @override
  String get anadirPiloto => 'Add driver';

  @override
  String get anadirEquipo => 'Add team';

  @override
  String get importar => 'Import';

  @override
  String get vincularGoogleSheet => 'Link Google Sheet';

  @override
  String get desdeArchivoCsvExcel => 'From CSV / Excel file';

  @override
  String get generarTandas => 'Generate rounds';

  @override
  String get aunNoHayPilotosInscritosPrueba =>
      'No drivers entered in this race yet';

  @override
  String get aunNoHayEquiposInscritosPrueba =>
      'No teams entered in this race yet';

  @override
  String get importaCsvGoogleFormPilotos =>
      'Import the CSV/Excel from the Google Form or add drivers manually.';

  @override
  String get importaCsvGoogleFormEquipos =>
      'Import the CSV/Excel from the Google Form or add teams manually.';

  @override
  String get importarCsvExcel => 'Import CSV/Excel';

  @override
  String get anadirAMano => 'Add manually';

  @override
  String pilotosInscritosGenerarTandas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '$n drivers entered. When you have them all, tap \"Generate rounds\".',
      one: '1 driver entered. When you have them all, tap \"Generate rounds\".',
    );
    return '$_temp0';
  }

  @override
  String equiposInscritosGenerarTandas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '$n teams entered. When you have them all, tap \"Generate rounds\".',
      one: '1 team entered. When you have them all, tap \"Generate rounds\".',
    );
    return '$_temp0';
  }

  @override
  String get darDeBaja => 'Withdraw';

  @override
  String darDeBajaTexto(String nombre) {
    return 'Withdraw \"$nombre\"?\n\nThey are removed from Entries and from their round. The other lanes do not change: renumber the round afterwards if needed.';
  }

  @override
  String get inscribirPilotos => 'Enter drivers';

  @override
  String get inscribirEquipos => 'Enter teams';

  @override
  String nSeleccionados(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n selected',
      one: '1 selected',
    );
    return '$_temp0';
  }

  @override
  String get limpiar => 'Clear';

  @override
  String get buscarPiloto => 'Search driver…';

  @override
  String get noHayPilotosEnCampeonato =>
      'There are no drivers in this championship.';

  @override
  String get noHayEquiposEnCampeonato =>
      'There are no teams in this championship.';

  @override
  String get todosYaInscritos => 'Everyone is already entered.';

  @override
  String get nuevaInscripcion => 'New entry';

  @override
  String get nuevoEquipo => 'New team';

  @override
  String get copaParaPilotosNuevos => 'Cup for new drivers:';

  @override
  String get desmarcarTodos => 'Unselect all';

  @override
  String marcarTodosN(int n) {
    return 'Select all ($n)';
  }

  @override
  String nuevaInscripcionCopa(String copa) {
    return 'New entry · Cup $copa';
  }

  @override
  String get marcaPilotosInscribir => 'Tick the drivers you want to enter';

  @override
  String get marcaEquiposInscribir => 'Tick the teams you want to enter';

  @override
  String inscribirNPilotos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n drivers',
      one: '1 driver',
    );
    return 'Enter $_temp0';
  }

  @override
  String inscribirNEquipos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n teams',
      one: '1 team',
    );
    return 'Enter $_temp0';
  }

  @override
  String get importarInscripciones => 'Import entries';

  @override
  String get csvGoogleFormInscripcionPilotos =>
      'CSV/Excel from the Google Form for entering the race. Entries are matched to existing drivers by name.';

  @override
  String get csvGoogleFormInscripcionEquipos =>
      'CSV/Excel from the Google Form for entering the race. Entries are matched to existing teams by name.';

  @override
  String get paso2AsignaColumnas => '2. Map columns';

  @override
  String get nombreDelPilotoObligatorio => 'Driver name *';

  @override
  String get nombreDelEquipoObligatorio => 'Team name *';

  @override
  String get diaPreferidoOpcional => 'Preferred day (optional)';

  @override
  String get notasOpcional => 'Notes (optional)';

  @override
  String get paso3VistaPrevia => '3. Preview';

  @override
  String nDeTotalSeImportaran(int n, int total) {
    return '$n of $total will be imported';
  }

  @override
  String pilotosNoExistenAviso(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '⚠️ $n drivers do not exist in the championship. Create them first or check the names.',
      one:
          '⚠️ 1 driver does not exist in the championship. Create them first or check the name.',
    );
    return '$_temp0';
  }

  @override
  String equiposNoExistenAvisoImport(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '⚠️ $n teams do not exist in the championship. Create them first or check the names.',
      one:
          '⚠️ 1 team does not exist in the championship. Create it first or check the name.',
    );
    return '$_temp0';
  }

  @override
  String get asignaColumnaPiloto => 'Map the driver-name column.';

  @override
  String get asignaColumnaEquipo => 'Map the team-name column.';

  @override
  String get ninguna => '— none —';

  @override
  String get yaInscrito => 'Already entered';

  @override
  String diaTexto(String dia) {
    return 'Day: $dia';
  }

  @override
  String noSePudoLeer(String detalle) {
    return 'Could not read: $detalle';
  }

  @override
  String resumenImportacionInscripciones(int ok, int saltados) {
    return '✓ Entered: $ok\n✗ Skipped: $saltados';
  }

  @override
  String tandaNumero(int n) {
    return 'Round $n';
  }

  @override
  String get tandasCreadas => 'Rounds created';

  @override
  String tandasCreadasTexto(int n, int equipos) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n rounds created with $equipos teams.',
      one: '1 round created with $equipos teams.',
    );
    return '$_temp0';
  }

  @override
  String get conCarrilAsignado => 'With starting lanes assigned.';

  @override
  String get carrilesSeAsignaranAntes =>
      'Lanes will be assigned before the race.';

  @override
  String get pistersAsignadosEntreTandas =>
      'Marshals assigned between the rounds of each day.';

  @override
  String equiposInscritosARepartir(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n teams entered to distribute',
      one: '1 team entered to distribute',
    );
    return '$_temp0';
  }

  @override
  String get ordenadosPorPuntos => 'Sorted by accumulated gross points.';

  @override
  String get sinPuntosEsteAnio =>
      'No points this year → sorted by last year\'s balance (0 if none).';

  @override
  String get paso1CarrilesPista => '1. Track lanes';

  @override
  String get paso1CarrilesTexto =>
      'How many cars run at once. It sets the maximum teams per round so they are distributed well.';

  @override
  String get carrilesMin => 'lanes';

  @override
  String get minutosPorCarrilTexto =>
      'Minutes per lane (how long a team\'s stint lasts in each lane, to calculate the round\'s duration).';

  @override
  String get minPorCarril => 'min/lane';

  @override
  String cadaTandaDurara(int minutos, int carriles, int minPorCarril) {
    return 'Each round will last ~$minutos min ($carriles lanes × $minPorCarril min).';
  }

  @override
  String get paso2NumeroTandas => '2. Number of rounds';

  @override
  String sugeridoTexto(int n, int carriles) {
    return 'Suggested: $n (no empty lanes with $carriles lanes: if teams are left over, rounds go above $carriles). You can change it.';
  }

  @override
  String get paso3NombresHorarios => '3. Names and times';

  @override
  String get asignarCarrilAutomatico => 'Assign lanes automatically';

  @override
  String asignarCarrilTexto(int carriles) {
    return 'By points, highest to lowest: lanes 1 to $carriles and, if there are more drivers, D1, D2…';
  }

  @override
  String get asignarPisters => 'Assign marshals';

  @override
  String get asignarPistersTexto =>
      'Between rounds on the same day. 2 rounds: 1st↔2nd. 3: the 3rd marshals in the 1st, the 1st in the 2nd and the 2nd in the 3rd. 4: 1st↔2nd and 3rd↔4th.';

  @override
  String get paso4VistaPrevia => '4. Preview';

  @override
  String get numeroIzquierdaCarril =>
      'The number on the left is the starting lane.';

  @override
  String get carrilesLosAsignarasDespues =>
      'You will assign the lanes later, before the race.';

  @override
  String sinTandaN(int n) {
    return 'No round ($n)';
  }

  @override
  String get sinTandaTexto =>
      'These teams prefer a day that has no round in this distribution. Add a round for that day above or change their preference.';

  @override
  String prefiereDia(String dia) {
    return 'Prefers: $dia';
  }

  @override
  String get sustituirTandasExistentes => 'Replace existing rounds';

  @override
  String get sustituirTandasTexto =>
      'If this race already had rounds, they are deleted and replaced.';

  @override
  String get crearEstasTandas => 'Create these rounds';

  @override
  String get eligeLaCarrera => 'Choose the race';

  @override
  String get verCarreras => 'View races';

  @override
  String resultadosDeCarrera(String nombre) {
    return 'Results: $nombre';
  }

  @override
  String noSePudoConectar(String detalle) {
    return 'Could not connect: $detalle';
  }

  @override
  String noSePudieronTraerResultados(String detalle) {
    return 'Could not fetch the results: $detalle';
  }

  @override
  String get noHayCampeonatoActivo => 'No active championship.';

  @override
  String resultadosAplicadosSaltados(int ok, int saltados) {
    return 'Results applied: $ok · skipped: $saltados';
  }

  @override
  String errorAlAplicar(String detalle) {
    return 'Error applying: $detalle';
  }

  @override
  String get pitwallNoTieneCarreras => 'PitWall has no races.';

  @override
  String get pitwallNoTieneCarrerasEnvia =>
      'PitWall has no races. Send a round first («Send to PitWall») or create the race in Manager.';

  @override
  String tandasDeCarrera(int n) {
    return '$n round(s)';
  }

  @override
  String get laCarreraNoTieneResultados => 'The race has no results yet.';

  @override
  String get equipoNoEncontradoCampeonato =>
      'Team not found in the championship';

  @override
  String get noInscritoEnEstaPrueba => 'Not entered in this race';

  @override
  String seAplicaraPosicion(int posicion) {
    return 'position $posicion will be applied';
  }

  @override
  String aplicarN(int n) {
    return 'Apply ($n)';
  }

  @override
  String tandaAbrev(int n) {
    return 'R$n';
  }

  @override
  String get seEnvianComoConsulta =>
      'They are sent for consultation: they can be viewed in PitWall but not edited.';

  @override
  String get atras => 'Back';

  @override
  String get noHayVerificacionesEnviar =>
      'There are no scrutineering records to send in this race.';

  @override
  String copaDosPuntos(String copa) {
    return 'Cup: $copa';
  }

  @override
  String get aunNoHayEquiposEnEstaTanda => 'No teams in this round yet';

  @override
  String get inscribeEquiposVerificacion =>
      'Enter teams in the round so they can be scrutineered.';

  @override
  String nConVerificacion(int n) {
    return '$n with scrutineering';
  }

  @override
  String nValidadas(int n) {
    return '$n validated';
  }

  @override
  String get quitarParticipante => 'Remove participant';

  @override
  String quitarConVerificacionTexto(String nombre) {
    return '\"$nombre\" will be removed and their scrutineering deleted. Continue?';
  }

  @override
  String quitarSinVerificacionTexto(String nombre) {
    return '\"$nombre\" will be removed. Continue?';
  }

  @override
  String get validada => 'Validated';

  @override
  String get borrador => 'Draft';

  @override
  String get enRevision => 'In progress';

  @override
  String get pendiente => 'Pending';

  @override
  String get sinCocheAsignado => 'No car assigned';

  @override
  String get sesionCerrada => 'The session is closed.';

  @override
  String get campeonatoFinalizado => 'The championship is finished.';

  @override
  String get pruebaTerminada => 'The race is over.';

  @override
  String get exportar => 'Export';

  @override
  String get exportarPdf => 'Export to PDF';

  @override
  String get exportarExcel => 'Export to Excel';

  @override
  String get noHayPruebasEnCampeonato =>
      'There are no races in this championship.';

  @override
  String get noHayInscritosNiVerificaciones =>
      'No entries or scrutineering in this race.';

  @override
  String get buscarPilotoEquipoCopa => 'Search driver, team, cup…';

  @override
  String filtroTodos(int n) {
    return 'All ($n)';
  }

  @override
  String filtroConInfraccion(int n) {
    return 'With infraction ($n)';
  }

  @override
  String filtroSinVerificar(int n) {
    return 'Not scrutineered ($n)';
  }

  @override
  String filtroBorrador(int n) {
    return 'Draft ($n)';
  }

  @override
  String validadasDeTotal(int validadas, int total) {
    return '$validadas of $total validated';
  }

  @override
  String get nadaConEsteFiltro => 'Nothing to show with this filter.';

  @override
  String get colPilotoEquipo => 'Driver / team';

  @override
  String get fueraDeReglamento => 'Out of regulations';

  @override
  String get copa => 'Cup';

  @override
  String get coche => 'Car';

  @override
  String get colPesoCarroc => 'Body wt.';

  @override
  String get colPesoMin => 'Min. wt.';

  @override
  String get colPesoCoche => 'Car weight';

  @override
  String get motor => 'Motor';

  @override
  String get alturaMotor => 'Motor height';

  @override
  String get colEjeDel => 'Front axle';

  @override
  String get colEjeTras => 'Rear axle';

  @override
  String get pinon => 'Pinion';

  @override
  String get corona => 'Crown';

  @override
  String get llantaDelantera => 'Front rim';

  @override
  String get llantaTrasera => 'Rear rim';

  @override
  String get trencilla => 'Braid';

  @override
  String get suspension => 'Suspension';

  @override
  String get bancada => 'Motor mount';

  @override
  String get chasis => 'Chassis';

  @override
  String get neumatico => 'Tyre';

  @override
  String get carroceria => 'Bodywork';

  @override
  String get observaciones => 'Notes';

  @override
  String get sinVerificar => 'Not scrutineered';

  @override
  String get propio => 'Own';

  @override
  String orgNumero(String n) {
    return 'Org. no. $n';
  }

  @override
  String get conforme => 'Compliant';

  @override
  String get noConforme => 'Non-compliant';

  @override
  String get toca => 'Must touch';

  @override
  String get bien => 'Good';

  @override
  String get faltanPiezas => 'Missing parts';

  @override
  String faltanPiezasDetalle(String piezas) {
    return 'Missing: $piezas';
  }

  @override
  String marcaNoPermitida(String marca) {
    return 'Brand \"$marca\" not allowed';
  }

  @override
  String superaMaximoMm(String maximo) {
    return 'Over the maximum of $maximo mm';
  }

  @override
  String porDebajoMinimoG(String minimo) {
    return 'Below the minimum of $minimo g';
  }

  @override
  String get alturaMotorNoConforme => 'Motor height non-compliant';

  @override
  String get leFaltanPiezas => 'Missing parts';

  @override
  String vPesoInicialBajo(String valor, String minimo) {
    return 'Initial weight ${valor}g below the minimum ${minimo}g.';
  }

  @override
  String vPesoFinalBajo(String valor, String minimo) {
    return 'Final weight ${valor}g below the minimum ${minimo}g.';
  }

  @override
  String get vMotorSinCatalogo =>
      'Select the catalogue motor to check the measurements.';

  @override
  String vMotorRpmAlto(String motor, String max, String medido) {
    return 'RPM above the $motor reference (max $max, measured $medido).';
  }

  @override
  String vMotorUmsAlto(String motor, String max, String medido) {
    return 'Magnet above the $motor reference (max $max, measured $medido).';
  }

  @override
  String get vAlturaNoConforme =>
      'Motor height non-compliant: it touches the track.';

  @override
  String vEjeDelAncho(String medido, String max) {
    return 'Front axle width $medido mm over the maximum $max mm.';
  }

  @override
  String vEjeTraAncho(String medido, String max) {
    return 'Rear axle width $medido mm over the maximum $max mm.';
  }

  @override
  String vMarcaNoPermitidaLista(String marca, String lista) {
    return 'Brand \"$marca\" not allowed (only $lista).';
  }

  @override
  String vMarcaFueraCatalogo(String marca) {
    return 'Brand \"$marca\" is not in the catalogue.';
  }

  @override
  String vLlantaDelNoCatalogada(String valor) {
    return 'Front rim not in the catalogue: \"$valor\".';
  }

  @override
  String vLlantaTraNoCatalogada(String valor) {
    return 'Rear rim not in the catalogue: \"$valor\".';
  }

  @override
  String vBancadaNoCatalogada(String valor) {
    return 'Motor mount not in the catalogue: \"$valor\".';
  }

  @override
  String vNeumaticoNoCatalogado(String valor) {
    return 'Tyre not in the catalogue: \"$valor\".';
  }

  @override
  String vBalanceNegativo(String equipo, String coche, String balance) {
    return 'Negative credit balance: team $equipo + car $coche = $balance.';
  }

  @override
  String get noSePudoGenerarExcel => 'Could not generate the Excel file.';

  @override
  String get buscarPuntos => 'Search…';

  @override
  String sinResultadosPara(String filtro) {
    return 'No results for \"$filtro\"';
  }

  @override
  String get sinAsignarGuiones => '— unassigned —';

  @override
  String get sorteoEtiqueta => 'Draw';

  @override
  String get mixto => 'Mixed';

  @override
  String get limitarFabricante => 'Limit manufacturer';

  @override
  String noCatalogada(String nombre) {
    return '$nombre (not in the catalogue)';
  }

  @override
  String get imagenNoSePuedeLeer =>
      'That image cannot be read. Use a PNG or JPG.';

  @override
  String noSePudoAnadirLogo(String detalle) {
    return 'Could not add the logo: $detalle';
  }

  @override
  String get elegirLogo => 'Choose logo';

  @override
  String get cambiarLogo => 'Change logo';

  @override
  String get repartir => 'Split';

  @override
  String get configuraRangoSesion =>
      'Set the engine range in the session rules to be able to draw.';

  @override
  String get configuraRangoCampeonato =>
      'Set the engine range in the championship to be able to draw.';

  @override
  String get sorteoDeMotor => 'Engine draw';

  @override
  String get otroControl => 'Another Control';

  @override
  String cambiadaFueraTexto(String quien) {
    return '$quien has changed this scrutineering sheet. If you keep editing, your changes will replace theirs.';
  }

  @override
  String get seguirConLoMio => 'Keep mine';

  @override
  String verLoDe(String quien) {
    return 'See $quien\'s';
  }

  @override
  String actualizadaConCambios(String quien) {
    return 'Updated with the changes from $quien.';
  }

  @override
  String noSePudoAnadirFoto(String detalle) {
    return 'Could not add the photo: $detalle';
  }

  @override
  String get copaEnEstaPrueba => 'Cup in this race';

  @override
  String get copaEnEstaPruebaTexto =>
      'Changes the cup only for this race, without affecting the team or other races.';

  @override
  String get copaCategoria => 'Cup / category';

  @override
  String copaDelEquipo(String copa) {
    return 'Team cup: $copa';
  }

  @override
  String get usarLaDelEquipo => 'Use the team\'s';

  @override
  String get usarReglamentoActual => 'Use the current rules';

  @override
  String get usarReglamentoActualTexto =>
      'This scrutineering sheet will be checked against today\'s catalogue and championship values instead of the ones it had when it was scrutinised:';

  @override
  String get recalcularanCreditos =>
      'As it is validated, its credits will be recalculated.';

  @override
  String get usarElActual => 'Use the current one';

  @override
  String get desbloquearVerificacion => 'Unlock scrutineering';

  @override
  String desbloquearTexto(String motivo) {
    return '$motivo Their scrutineering sheets are locked so they are not changed by accident.\n\nIf you unlock it, changes are saved as usual. It will still be checked against the rules it was scrutinised with.';
  }

  @override
  String get desbloquear => 'Unlock';

  @override
  String get verificacion => 'Scrutineering';

  @override
  String get eliminarVerificacion => 'Delete scrutineering';

  @override
  String get eliminarVerificacionTexto =>
      'The data entered will be lost. Continue?';

  @override
  String get modeloCoche => 'Car model';

  @override
  String get elegirCoche => 'Choose car';

  @override
  String noHayCochesConCopa(String copa) {
    return 'There are no cars with the $copa cup in the catalogue';
  }

  @override
  String get ayudaSelectorCoche =>
      'The car\'s minimum weight and credits are shown when you choose it';

  @override
  String get creditosAbrev => 'cred';

  @override
  String get pesoGramos => 'Weight (grams)';

  @override
  String get pesoCarroceria => 'Bodywork weight';

  @override
  String minimoG(String n) {
    return 'Minimum: ${n}g';
  }

  @override
  String get estetica => 'Appearance';

  @override
  String get sinComprobar => 'Not checked';

  @override
  String get quePiezasFaltan => 'Which parts are missing';

  @override
  String get organizacion => 'Organization';

  @override
  String get numeroDeMotor => 'Engine number';

  @override
  String get motorDelCatalogo => 'Catalogue motor';

  @override
  String get elegirMotor => 'Choose motor';

  @override
  String yaNoEnCatalogo(String nombre) {
    return '$nombre (no longer in the catalogue)';
  }

  @override
  String refMotor(String rpm, String gauss) {
    return 'Ref: $rpm RPM · $gauss gauss';
  }

  @override
  String motoresHomologadosCopa(String copa) {
    return 'Motors approved for the $copa cup';
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
  String get alturaMotorAPista => 'Motor height on track';

  @override
  String get alturaMotorTexto =>
      'Checked with the plate: if it touches the track, non-compliant.';

  @override
  String get delantero => 'Front';

  @override
  String get trasero => 'Rear';

  @override
  String get marca => 'Brand';

  @override
  String get dimension => 'Size';

  @override
  String get dientes => 'Teeth';

  @override
  String get diametro => 'Diameter';

  @override
  String get material => 'Material';

  @override
  String get pesoCocheEntero => 'Full car weight (grams)';

  @override
  String get inicial => 'Initial';

  @override
  String get cocheEntero => 'Full car';

  @override
  String get otros => 'Others';

  @override
  String get notasOAvisos => 'Notes or warnings';

  @override
  String get fotosHasta4 => 'Photos (up to 4)';

  @override
  String get marcarComoValidada => 'Mark as validated';

  @override
  String get marcarComoValidadaTexto =>
      'Marks the scrutineering sheet as reviewed and approved.';

  @override
  String get autoguardadoTexto => 'Saved as a draft on every change.';

  @override
  String get validar => 'Validate';

  @override
  String get noPuedesValidar =>
      'You cannot validate while there are infractions marked in red above.';

  @override
  String get fotoReferenciaTexto =>
      'Catalogue reference photo: check that it matches.';

  @override
  String get sinFotoCocheTexto =>
      'This car has no photo in the catalogue. Add one in Catalogues → Cars to be able to compare the delivered model.';

  @override
  String get sinGuardar => 'Unsaved…';

  @override
  String get guardando => 'Saving…';

  @override
  String get guardado => 'Saved';

  @override
  String get errorCorto => 'Error';

  @override
  String soloLecturaTexto(String motivo) {
    return '$motivo Scrutineering is read-only.';
  }

  @override
  String desbloqueadaTexto(String motivo) {
    return '$motivo Unlocked: changes are saved.';
  }

  @override
  String reglamentoCongelado(String fecha) {
    return 'Rules frozen on $fecha: it is checked against the values from when it was scrutinised.';
  }

  @override
  String get reglamentoCongeladoSinFecha =>
      'Rules frozen: it is checked against the values from when it was scrutinised.';

  @override
  String get haCambiadoDesdeEntonces => 'Changed since then (not applied):';

  @override
  String get todoCumple => 'Everything meets the rules. You can validate.';

  @override
  String infraccionesN(int n) {
    return 'Infractions: $n';
  }

  @override
  String avisosN(int n) {
    return 'Warnings: $n';
  }

  @override
  String pendienteHechosDeTotal(int hechos, int total) {
    return '$hechos/$total pending';
  }

  @override
  String get hecho => 'Done';

  @override
  String get revisar => 'Review';

  @override
  String bloquesCompletos(int hechos, int total) {
    return 'Blocks complete: $hechos of $total';
  }

  @override
  String faltaLista(String lista) {
    return 'Missing: $lista';
  }

  @override
  String fueraDeLaLista(String valor) {
    return '$valor (not in the list)';
  }

  @override
  String noCatalogado(String valor) {
    return '$valor (not in the catalogue)';
  }

  @override
  String conEsteCoche(String creditos) {
    return 'With this car ($creditos cred):';
  }

  @override
  String get total => 'Total';

  @override
  String nCreditos(int n) {
    return '$n credits';
  }

  @override
  String get sinCreditosSuficientes =>
      '⚠ They do not have enough credits to cover the car.';

  @override
  String get hacerFoto => 'Take photo';

  @override
  String get elegirDeGaleria => 'Choose from gallery';

  @override
  String get anadir => 'Add';

  @override
  String get equipoNoInscritoPrueba =>
      'The team is not entered in the race: enter it to be able to charge it.';

  @override
  String get etiquetaFinal => 'Final';

  @override
  String get anchuraEjeMm => 'Axle width (mm)';

  @override
  String get nombreDelClub => 'Club name';

  @override
  String get clubEjemplo => 'E.g. Club Slot Barcelona';

  @override
  String get limitarFabricanteTexto =>
      'In scrutineering, the brand dropdowns (pinion, crown, rims and braid) only show the chosen brands; any other one is an infraction.';

  @override
  String get eligeAlMenosUnaMarca => 'Choose at least one brand.';

  @override
  String get tipoMotorSorteoTexto =>
      'The organisation draws the engines: scrutineering only records the engine number.';

  @override
  String get tipoMotorPropioTexto =>
      'Each team brings its own motor: scrutineering picks it from the catalogue and checks the RPM.';

  @override
  String get tipoMotorMixtoTexto =>
      'Each scrutineering sheet marks whether the engine is the organisation\'s or the team\'s own.';

  @override
  String get tipoMotorEligeTexto => 'Choose where the engines come from.';

  @override
  String get noPagaEstaPrueba => 'does not pay this race';

  @override
  String get quitarWildcard => 'Remove wildcard';

  @override
  String get quitarCoordTotal => 'Remove \"Coord. total\" (pays again)';

  @override
  String get coordinadoraEnFicha =>
      'The drivers are marked as coordinators in their profile; change it there';

  @override
  String get marcarWildcard => 'Mark as wildcard (does not pay)';

  @override
  String desglosePagados(String total) {
    return 'Breakdown of the €$total paid';
  }

  @override
  String get pagat => 'Paid';

  @override
  String get coordinadora => 'Coordination';

  @override
  String get club => 'Club';

  @override
  String get observacionesOpcional => 'Notes (optional)';

  @override
  String descuadreTexto(String suma, String total) {
    return 'Coordination + Club ($suma) does not add up to Paid ($total).';
  }

  @override
  String get pagoRapido => 'Quick payment:';

  @override
  String get coordYPiloto => 'Coord. + driver';

  @override
  String coordYPilotoTooltip(String monto) {
    return 'One driver is a coordinator: pays half of everything (€$monto)';
  }

  @override
  String get coordTotal => 'Coord. total';

  @override
  String get coordTotalTooltip => 'All drivers are coordinators: does not pay';

  @override
  String get observacionMitad => 'Half — one coordinator driver';

  @override
  String get nuevaSesion => 'New session';

  @override
  String get aunNoHaySesiones => 'No sessions yet';

  @override
  String get sesionesVaciasTexto =>
      'Scrutineer cars without setting up a championship: a one-off race, a club check… Create a session, add participants and export the PDF.';

  @override
  String nParticipantes(int n) {
    return '$n participants';
  }

  @override
  String get sesionYaNoExiste => 'The session no longer exists.';

  @override
  String get aunNoHayParticipantes => 'No participants yet';

  @override
  String get pulsaAnadirParticipante =>
      'Tap \"Add participant\" to scrutineer their car, or import them from a file or Google Sheets with \"Import\" above.';

  @override
  String get anadirParticipante => 'Add participant';

  @override
  String get desdeArchivoCsvExcelParentesis => 'From file (CSV / Excel)';

  @override
  String get desdeGoogleSheets => 'From Google Sheets';

  @override
  String get excelConFotos => 'Excel with photos';

  @override
  String get reglamento => 'Rules';

  @override
  String get eliminarSesion => 'Delete session';

  @override
  String get configuraCopasAntes => 'Set the cups in the session rules first.';

  @override
  String anadidosParticipantes(int n) {
    return '$n participants added.';
  }

  @override
  String eliminarSesionTexto(String nombre) {
    return '\"$nombre\", its participants and all its scrutineering sheets will be deleted. This cannot be undone.';
  }

  @override
  String get pilotoObligatorio => 'Driver *';

  @override
  String get obligatorio => 'Required';

  @override
  String get segundoPiloto => 'Second driver (optional)';

  @override
  String get equipoOpcional => 'Team (optional)';

  @override
  String get equipoOpcionalAyuda => 'If left empty, the driver\'s name is used';

  @override
  String get anadirYVerificar => 'Add and scrutineer';

  @override
  String get seleccionaUnaCopa => 'Select at least one cup / category.';

  @override
  String get eligeTipoMotor =>
      'Motor: choose whether it is drawn, the team\'s own or mixed.';

  @override
  String get limitarFabricanteError =>
      'Limit manufacturer: choose at least one brand or turn it off.';

  @override
  String get nuevaSesionVerificacion => 'New scrutineering session';

  @override
  String get editarSesion => 'Edit session';

  @override
  String get nombreSesionObligatorio => 'Session name *';

  @override
  String get nombreSesionAyuda => 'E.g. Thursday club check, GT Sant Joan race';

  @override
  String get lugarOpcional => 'Venue (optional)';

  @override
  String get sinFecha => 'No date';

  @override
  String get fechaSesion => 'Session date';

  @override
  String get clubOrganizador => 'Organising club';

  @override
  String get clubOrganizadorAyuda =>
      'Appears in the header of the session\'s PDFs.';

  @override
  String get copasCategorias => 'Cups / categories';

  @override
  String get copasCategoriasAyuda =>
      'The ones that can be scrutineered in this session. Each participant\'s cup filters the catalogue and the checks, as in a championship.';

  @override
  String get anchuraEje => 'Axle width';

  @override
  String get anchuraEjeAyuda =>
      'Maximum axle width (mm) per cup. Leave empty if it is not checked in that cup.';

  @override
  String get maxDelanteroMm => 'Front max. (mm)';

  @override
  String get maxTraseroMm => 'Rear max. (mm)';

  @override
  String get fabricante => 'Manufacturer';

  @override
  String get fabricanteAyuda =>
      'For single-brand sessions: limits the brands that can be chosen in scrutineering.';

  @override
  String get rangoMotorTexto =>
      'Engine number range for drawing from scrutineering. Leave it empty if there is no draw.';

  @override
  String get motorDesde => 'Motor from';

  @override
  String get motorHasta => 'Motor to';

  @override
  String get indicaAmbos => 'Enter both';

  @override
  String get hastaMayorQueDesde => 'To ≥ from';

  @override
  String get crearSesion => 'Create session';

  @override
  String get importarParticipantesArchivo => 'Import participants (file)';

  @override
  String get importarParticipantesSheets =>
      'Import participants (Google Sheets)';

  @override
  String errorAlImportar(String detalle) {
    return 'Error importing: $detalle';
  }

  @override
  String pasoEligeArchivoN(int n) {
    return '$n. Choose the file';
  }

  @override
  String pasoEligeLaHoja(int n) {
    return '$n. Choose the sheet';
  }

  @override
  String pasoEligeLaPestana(int n) {
    return '$n. Choose the tab';
  }

  @override
  String pasoAsignaColumnasN(int n) {
    return '$n. Map columns';
  }

  @override
  String pasoVistaPreviaN(int n) {
    return '$n. Preview';
  }

  @override
  String get csvPlantillaTexto =>
      'CSV or Excel with a header row. Recognised columns: Driver 1 (or Driver / Name), Driver 2, Team and Cup. There is a template in \"CSV templates\".';

  @override
  String get buscarEnTusHojas => 'Search your sheets…';

  @override
  String get buscar => 'Search';

  @override
  String get pestana => 'Tab';

  @override
  String get piloto1Obligatorio => 'Driver 1 *';

  @override
  String get piloto2 => 'Driver 2';

  @override
  String get copaPorDefecto => 'Default cup';

  @override
  String get copaPorDefectoAyuda =>
      'For rows without a cup or with a cup that is not in the session';

  @override
  String get asignaColumnaPiloto1 => 'Map at least the driver 1 column.';

  @override
  String get noHayFilasConPiloto => 'There are no rows with a driver.';

  @override
  String anadirNParticipantes(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n participants',
      one: '1 participant',
    );
    return 'Add $_temp0';
  }

  @override
  String get noConectadoGoogle => 'You are not connected to Google yet';

  @override
  String get conectaCuentaTexto =>
      'Connect your account once to be able to read your spreadsheets.';

  @override
  String get configurarGoogle => 'Set up Google';

  @override
  String noSePudieronListarHojas(String detalle) {
    return 'Could not list your sheets: $detalle';
  }

  @override
  String noSePudieronListarPestanas(String detalle) {
    return 'Could not list the tabs: $detalle';
  }

  @override
  String noSePudoLeerPestana(String detalle) {
    return 'Could not read the tab: $detalle';
  }

  @override
  String get yaEstaEnLaSesion => 'Already in the session';

  @override
  String copaNoEnSesion(String copa, String defecto) {
    return 'Cup \"$copa\" is not in the session: $defecto is used';
  }

  @override
  String get fotoCatalogo => 'Catalogue photo';

  @override
  String get pilotos => 'Drivers';

  @override
  String get inscripciones => 'Entries';

  @override
  String get nuevoPiloto => 'New driver';

  @override
  String get editarPiloto => 'Edit driver';

  @override
  String get crearPiloto => 'Create driver';

  @override
  String get puntuacionPreviaImport => 'Previous score (1st race)';

  @override
  String get buscarPorNombre => 'Search by name…';

  @override
  String get aunNoHayPilotosCampeonato => 'No drivers in this championship yet';

  @override
  String get noHayCoincidencias => 'No matches';

  @override
  String get pulsaNuevoPiloto =>
      'Tap the \"New driver\" button to add the first one.';

  @override
  String get quitarDelCampeonato => 'Remove from championship';

  @override
  String quitarDelCampeonatoTexto(String piloto, String campeonato) {
    return 'Remove $piloto from \"$campeonato\"?\n\nThe driver is not deleted, only unsubscribed from this championship.';
  }

  @override
  String get motivoAjusteManual => 'Manual adjustment (driver profile)';

  @override
  String get datosPersonales => 'Personal details';

  @override
  String get nombreYApellidos => 'Full name *';

  @override
  String get telefono => 'Phone';

  @override
  String get email => 'Email';

  @override
  String get palmaresHistorico => 'Career record';

  @override
  String get palmaresEjemplo => 'E.g. \"Top 3 league 2025\", \"WES 2023-2024\"';

  @override
  String get pilotoCoordinadora => 'Coordination driver';

  @override
  String get pilotoCoordinadoraTexto =>
      'If enabled, the teams they take part in will not pay a fee.';

  @override
  String get enEsteCampeonato => 'In this championship';

  @override
  String get categoria => 'Category';

  @override
  String get creditosIniciales => 'Initial credits';

  @override
  String get sugeridoSegunCategoria => 'Suggested by category';

  @override
  String get creditosActuales => 'Current credits';

  @override
  String get palmaresLocal => 'Record in this championship';

  @override
  String get indicaUnNumero => 'Enter a number';

  @override
  String get tieneQueSerEntero => 'It must be a whole number';

  @override
  String get noPuedeSerNegativo => 'It cannot be negative';

  @override
  String get importarPilotos => 'Import drivers';

  @override
  String get soportaExcelPilotos =>
      'Supports Excel (.xlsx) and CSV files. It must have at least one column with the drivers\' names.';

  @override
  String resumenImportacionPilotos(int nuevos, int inscritos, int saltados) {
    return '✓ New drivers: $nuevos\n✓ Entered in this championship: $inscritos\n✗ Skipped: $saltados';
  }

  @override
  String errorImportando(String detalle) {
    return 'Error importing: $detalle';
  }

  @override
  String get indicaColumnaNombrePiloto =>
      'Indicate which column contains the driver\'s name.';

  @override
  String get noFilasValidas => 'No valid rows were found.';

  @override
  String importarNPilotos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n drivers',
      one: '1 driver',
    );
    return 'Import $_temp0';
  }

  @override
  String get paso2AsignaLasColumnas => '2. Map the columns';

  @override
  String get columnasAutodetectadas =>
      'We tried to detect them automatically. Change them if needed.';

  @override
  String get categoriaMetal => 'Category (metal)';

  @override
  String get palmares => 'Record';

  @override
  String get nuevo => 'New';

  @override
  String get importarPuntuacionPrevia => 'Import previous score';

  @override
  String get puntuacionPreviaTexto =>
      'Excel (.xlsx) or CSV with the driver\'s name and score. It only updates drivers ALREADY entered in the active championship (matched by name) — it does not add anyone new.';

  @override
  String get puntuacionImportada => 'Score imported';

  @override
  String puntuacionImportadaTexto(int ok, int saltados) {
    return '✓ Updated: $ok\n✗ Skipped: $saltados\n\nThis score is only used for \"Generate rounds\" in the first race; as soon as the championship has its own results, the real standings replace it automatically.';
  }

  @override
  String get puntuacionObligatoria => 'Score *';

  @override
  String nDeTotalSeActualizaran(int n, int total) {
    return '$n of $total will be updated';
  }

  @override
  String get indicaColumnaNombreYPuntuacion =>
      'Indicate which column is the name and which the score.';

  @override
  String actualizarNPilotos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n drivers',
      one: '1 driver',
    );
    return 'Update $_temp0';
  }

  @override
  String get noEstaEnCampeonato => 'Not in the championship';

  @override
  String get formulaSinCalcular =>
      'Uncalculated formula — use \"paste special: values\"';

  @override
  String get seActualizara => 'Will be updated';

  @override
  String get aunNoHayEquipos => 'No teams yet';

  @override
  String get creaEquipoDosPilotos => 'Create a team with two drivers to start.';

  @override
  String get creaInscripcionIndividual =>
      'Create an individual entry to start.';

  @override
  String get importarEquipos => 'Import teams';

  @override
  String get seleccionaLaCopa => 'Select the cup.';

  @override
  String get seleccionaUnPiloto => 'Select at least one driver.';

  @override
  String get parejasNecesitanDosPilotos =>
      'In this championship (pairs) the team needs two drivers.';

  @override
  String get pilotosRepetidos => 'There are repeated drivers in the team.';

  @override
  String get eliminarInscripcion => 'Delete entry';

  @override
  String get eliminarEquipo => 'Delete team';

  @override
  String eliminarInscripcionTexto(String nombre) {
    return 'Delete the entry for \"$nombre\"? This action cannot be undone.';
  }

  @override
  String eliminarEquipoTexto(String nombre) {
    return 'Delete the team \"$nombre\"? This action cannot be undone.';
  }

  @override
  String get editarInscripcion => 'Edit entry';

  @override
  String get editarEquipo => 'Edit team';

  @override
  String get primeroAnadePilotos =>
      'First add drivers to the championship to be able to create teams.';

  @override
  String get indicaUnNombre => 'Enter a name';

  @override
  String get copaCategoriaObligatoria => 'Cup / category *';

  @override
  String get piloto => 'Driver';

  @override
  String get pilotosDelEquipo => 'Team drivers';

  @override
  String pilotoN(int n) {
    return 'Driver $n';
  }

  @override
  String get cocheEnVerificacionTexto =>
      'The car is set in the scrutineering of each round. A team can use different cars in different races.';

  @override
  String get crearEquipo => 'Create team';

  @override
  String get elegirPiloto => '— choose driver —';

  @override
  String equipoImportTexto(String pilotos) {
    return 'Upload the CSV or Excel from the pre-season Google Form. Each row must be a team with the team name and $pilotos.';
  }

  @override
  String get susDosPilotos => 'its two drivers';

  @override
  String get suPiloto => 'its driver';

  @override
  String get asignaColumnaEquipoYPiloto =>
      'Map at least the team-name column and the first driver\'s column.';

  @override
  String importarNEquipos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n teams',
      one: '1 team',
    );
    return 'Import $_temp0';
  }

  @override
  String resumenImportacionEquipos(
    int equipos,
    int pilotosNuevos,
    int pilotosInscritos,
    int saltados,
  ) {
    return '✓ Teams created: $equipos\n✓ New drivers: $pilotosNuevos\n✓ Drivers entered in the championship: $pilotosInscritos\n✗ Skipped: $saltados';
  }

  @override
  String get columnasIntentadas =>
      'We tried to detect them. Change any that are wrong.';

  @override
  String get yaExiste => 'Already exists';

  @override
  String get sinPiloto => 'No driver';

  @override
  String get faltaSegundoPiloto =>
      'The second driver is missing (pairs championship)';

  @override
  String get nombreObligatorio => 'Name *';

  @override
  String get nombreCampo => 'Name';

  @override
  String get piloto1 => 'Driver 1';

  @override
  String get piloto2Opcional => 'Driver 2 (optional)';

  @override
  String formatoNoSoportadoUsaCsv(String ext) {
    return 'Unsupported format: $ext. Use .csv or .xlsx';
  }

  @override
  String get tablaDePuntos => 'Points table';

  @override
  String get rellenarAMano => 'Fill in manually';

  @override
  String get aunNoHayClasificacion => 'No standings yet';

  @override
  String get clasificacionVaciaTexto =>
      'Record round results, import it from a file or fill it in manually.';

  @override
  String get importarClasificacion => 'Import standings';

  @override
  String get general => 'Overall';

  @override
  String noHayPilotosEn(String titulo) {
    return 'No drivers in \"$titulo\".';
  }

  @override
  String get todosLosPilotosCampeonato => 'All the championship drivers';

  @override
  String pilotosDeCopa(String copa) {
    return 'Drivers in the $copa cup';
  }

  @override
  String nPilotos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n drivers',
      one: '1 driver',
    );
    return '$_temp0';
  }

  @override
  String get equipo => 'Team';

  @override
  String get catAbrev => 'Cat.';

  @override
  String get bruto => 'Gross';

  @override
  String get descAbrev => 'Drop';

  @override
  String get totalMayusculas => 'TOTAL';

  @override
  String get clasificacionAMano => 'Manual standings';

  @override
  String clasificacionAManoCopa(String copa) {
    return 'Manual standings · $copa';
  }

  @override
  String get sinPruebasParaPuntos =>
      'This championship has no races. Create races first to be able to assign points.';

  @override
  String get sinPilotosConEquipo =>
      'There are no drivers with a team in this championship. Assign teams to the drivers first.';

  @override
  String get editorManualTexto =>
      'Type each driver\'s points per race. They are saved automatically when you leave each field. Empty field = did not score; 0 = took part with 0.';

  @override
  String get restaurarValores => 'Restore default values';

  @override
  String get restaurar => 'Restore';

  @override
  String get restaurarTexto =>
      'The current points table will be replaced with PitWall Control\'s (70, 64, 59… down to 1 point). Changes are not saved until you tap \"Save\".';

  @override
  String posN(int n) {
    return 'Pos. $n';
  }

  @override
  String get puntosMayus => 'Points';

  @override
  String get quitarUltimaPosicion => 'Remove last position';

  @override
  String get anadirPosicion => 'Add position';

  @override
  String get csvExcel => 'CSV / Excel';

  @override
  String get googleSheets => 'Google Sheets';

  @override
  String get listarHojas => 'List sheets';

  @override
  String get seleccionaArchivoClasificacion =>
      'Choose a CSV or Excel file with the standings. The first row must be the header, with a \"Driver\" column and one column per race.';

  @override
  String archivoNombre(String nombre) {
    return 'File: $nombre';
  }

  @override
  String get seleccionaHojaClasificacion =>
      'Choose the Drive sheet with the standings.';

  @override
  String hojaNombre(String nombre) {
    return 'Sheet: $nombre';
  }

  @override
  String get pulsaListarHojas => 'Tap \"List sheets\" to start.';

  @override
  String pruebasReconocidas(int n) {
    return 'Races recognised: $n';
  }

  @override
  String noReconocidasCampo(String lista) {
    return 'Not recognised: $lista';
  }

  @override
  String pilotosOk(int n) {
    return 'Drivers OK: $n';
  }

  @override
  String pilotosConProblemas(int n) {
    return 'Drivers with problems: $n';
  }

  @override
  String get conectaGooglePrimero =>
      'Connect your Google account first in Settings → Google.';

  @override
  String importadosResultados(int registros, int pilotos) {
    return '$registros results from $pilotos drivers imported. Go back to the standings to see it updated.';
  }

  @override
  String get estadoOk => 'OK';

  @override
  String get pilotoNoEncontrado => 'Driver not found';

  @override
  String get pilotoSinEquipo => 'Driver without a team in this championship';

  @override
  String get sinPuntosImportables => 'No importable points';

  @override
  String get noEncuentroColumnaPiloto =>
      'I can\'t find the driver column. The first row must contain a column called \"Driver\", \"Name\" or \"Team\".';

  @override
  String get importando => 'Importing…';

  @override
  String get puntosNoValidos =>
      'There is a position with an invalid points value.';

  @override
  String get tablaGuardada => 'Points table saved.';

  @override
  String get reparto => 'Split';

  @override
  String get movimiento => 'Movement';

  @override
  String get sinCampeonatoActivo => 'No active championship';

  @override
  String cuotaPorPruebaTexto(String pagat, String coord, String club) {
    return 'Fee per race: $pagat (coordination $coord · club $club)';
  }

  @override
  String get porPrueba => 'Per race';

  @override
  String get repartoDeLaCuota => 'Fee split';

  @override
  String get repartoTexto =>
      'What each team pays per race and where it goes. When you change coordination or club, the other adjusts so they add up to Paid.';

  @override
  String get pagatCuotaTotal => 'Paid (total fee) €';

  @override
  String get coordinadoraEur => 'Coordination €';

  @override
  String get clubEur => 'Club €';

  @override
  String get pagatMayorQueCero => 'Paid must be greater than 0.';

  @override
  String get coordClubSumanPagat => 'Coordination + club must add up to Paid.';

  @override
  String get aplicarAPagosCobrados =>
      'Also apply to payments already collected';

  @override
  String get aplicarAPagosCobradosTexto =>
      'Splits again what each team paid with the new proportion. What was collected does not change.';

  @override
  String repartoGuardadoRecalculado(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n payments recalculated.',
      one: '1 payment recalculated.',
    );
    return 'Split saved. $_temp0';
  }

  @override
  String get repartoGuardado =>
      'Split saved. It will apply to future payments.';

  @override
  String get nuevoMovimiento => 'New movement';

  @override
  String get editarMovimiento => 'Edit movement';

  @override
  String get ingreso => 'Income';

  @override
  String get gasto => 'Expense';

  @override
  String get conceptoObligatorio => 'Description *';

  @override
  String get conceptoEjemplo => 'E.g. Sponsorship, Equipment, Prize…';

  @override
  String get importeObligatorio => 'Amount (€) *';

  @override
  String get importeAyuda => 'Just the number, no sign';

  @override
  String get notas => 'Notes';

  @override
  String get movimientosExtras => 'Extra movements';

  @override
  String get ingresosYGastosSueltos => '(one-off income and expenses)';

  @override
  String get sinMovimientosTexto =>
      'No movements. Use the \"+ Movement\" button to add sponsorships, equipment expenses, etc.';

  @override
  String get balanceCampeonato => 'Championship balance';

  @override
  String get masIngresos => '+ Income';

  @override
  String get menosGastos => '− Expenses';

  @override
  String get coordAbrev => 'Coord.';

  @override
  String get tesoreriaDeLaPrueba => 'Race finances';

  @override
  String get buscarPilotoOEquipo => 'Search driver or team…';

  @override
  String get borrar => 'Clear';

  @override
  String get sinEquiposInscritos => 'No teams entered';

  @override
  String get recaudadoEnPrueba => 'Collected in the race';

  @override
  String pagadosDe(int pagados, int total) {
    return '$pagados / $total paid';
  }

  @override
  String exentosNoPagan(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n exempt',
      one: '1 exempt',
    );
    return '$_temp0 do not pay';
  }

  @override
  String nadieCoincide(String filtro) {
    return 'Nobody matches \"$filtro\".';
  }

  @override
  String get exencionWildcard => 'Wildcard';

  @override
  String get exencionCoordinadora => 'Coordination drivers';

  @override
  String pagaMitad(String piloto) {
    return 'Pays half — $piloto is a coordinator';
  }

  @override
  String get revisionCategorias => 'Category review (closing)';

  @override
  String get aplicarBonificacion => 'Apply closing bonus';

  @override
  String get aunNoHayPilotosInscritos =>
      'No drivers entered in this championship yet.';

  @override
  String get bonificacionCierre => 'Closing bonus';

  @override
  String bonificacionCierreTexto(String tope) {
    return 'The balance of every driver who has competed will be topped up:\n\nbalance = min(current balance + bonus by category and number of races, $tope).\n\nIt only applies to those who do not have it yet. Continue?';
  }

  @override
  String bonificacionAplicada(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n drivers',
      one: '1 driver',
    );
    return 'Bonus applied to $_temp0.';
  }

  @override
  String inicialUsados(int inicial, int usados) {
    return 'Initial $inicial  ·  Used $usados';
  }

  @override
  String ajustarCreditos(String piloto) {
    return 'Adjust credits · $piloto';
  }

  @override
  String get creditosActualesSaldo => 'Current credits (balance)';

  @override
  String get creditosAjustados => 'Credits adjusted';

  @override
  String get ajustarCreditosMano => 'Adjust credits manually';

  @override
  String get usados => 'Used';

  @override
  String get saldoMayus => 'BALANCE';

  @override
  String get movimientos => 'Movements';

  @override
  String get inscripcionAlCampeonato => 'Championship entry';

  @override
  String get sinMovimientosTodavia => 'No movements yet.';

  @override
  String huecoSinJustificar(int n) {
    return '$n cred. unexplained';
  }

  @override
  String descuadreSaldo(String actual, String inicial, String suma) {
    return 'The current balance ($actual) does not match initial $inicial $suma movements. It probably came like this from the import or was edited by hand before the log was enabled.';
  }

  @override
  String get estadoPromociona => 'Promoted';

  @override
  String get estadoDesciende => 'Relegated';

  @override
  String get estadoSeMantiene => 'Stays';

  @override
  String get bajar => 'Lower';

  @override
  String get mantener => 'Keep';

  @override
  String get subir => 'Raise';

  @override
  String get noHayPilotosCompetido =>
      'No drivers have competed in this championship.';

  @override
  String get revisionTexto =>
      'Adjust each driver\'s category before finishing. It will be used for the closing bonus and as the starting category for the next championship.';

  @override
  String get motivoAjusteCreditos => 'Manual adjustment (credits)';

  @override
  String get verificarEnEquipoWifi => 'Scrutineer as a team (wifi)';

  @override
  String verificarEnEquipoN(int n) {
    return 'Scrutineer as a team · $n';
  }

  @override
  String verificarEnEquipoNConectados(int n) {
    return 'Scrutineer as a team · $n connected';
  }

  @override
  String get syncIntroTexto =>
      'Several Controls can work on this race at the same time. Each one saves on its own device and the changes travel over wifi: scrutineering with its photos, cup and charges, and also new records (drivers, teams, their category in the championship and race entries, and withdrawals), rounds with their lanes and the results.\n\n• All on the same wifi. No internet needed: an offline router or a phone hotspot works.\n• First time, everyone starts from the same data copy. Catalogues and championship settings do not travel yet.\n• The same event key on all of them, and automatic time on: if two people touch the same thing, the last change wins.';

  @override
  String get nombreDeEsteControl => 'Name of this Control';

  @override
  String get nombreControlAyuda =>
      'Different on each device (e.g. \"Table 1\").';

  @override
  String get claveDelEvento => 'Event key';

  @override
  String get claveEventoAyuda => 'The same on all the Controls.';

  @override
  String get conectarConOtros => 'Connect to other Controls';

  @override
  String visibleComo(String nombre) {
    return 'Visible as \"$nombre\"';
  }

  @override
  String get conectando => 'Connecting…';

  @override
  String get apagado => 'Off';

  @override
  String get controlsEnLaRed => 'Controls on the network';

  @override
  String get anadirPorDireccion => 'Add by address';

  @override
  String get anadirControlPorDireccion => 'Add Control by address';

  @override
  String get ipOPuerto => 'IP (or IP:port)';

  @override
  String get ipAyuda =>
      'You can see it on this same screen on the other Control.';

  @override
  String get buscandoOtrosControls => 'Looking for other Controls on the wifi…';

  @override
  String get noSeEncuentraControl =>
      'No Control has been found. Check that the others have this screen with \"Connect\" on and are on the same wifi, or add them by their address.';

  @override
  String dosControlsMismoNombre(String nombre) {
    return 'Another Control is also called \"$nombre\". Change the name of one of them.';
  }

  @override
  String claveNoCoincide(String host) {
    return '$host · the event key does not match';
  }

  @override
  String get quitarDeLaLista => 'Remove from the list';

  @override
  String get sincronizarAutomaticamente => 'Sync automatically';

  @override
  String cadaNsAppAbierta(int n) {
    return 'Every $n s while the app is open';
  }

  @override
  String get sincronizando => 'Syncing…';

  @override
  String get sincronizarAhora => 'Sync now';

  @override
  String ultimaSincronizacion(String hora) {
    return 'Last sync: $hora';
  }

  @override
  String get syncSinCambios => 'No changes';

  @override
  String nEquipos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n teams',
      one: '1 team',
    );
    return '$_temp0';
  }

  @override
  String nPerfiles(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n profiles',
      one: '1 profile',
    );
    return '$_temp0';
  }

  @override
  String nInscritos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n entries',
      one: '1 entry',
    );
    return '$_temp0';
  }

  @override
  String nTandas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n rounds',
      one: '1 round',
    );
    return '$_temp0';
  }

  @override
  String resultadosDeNTandas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n rounds',
      one: '1 round',
    );
    return 'results from $_temp0';
  }

  @override
  String nBajas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n withdrawals',
      one: '1 withdrawal',
    );
    return '$_temp0';
  }

  @override
  String nVerifNuevas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n new scrutineering sheets',
      one: '1 new scrutineering sheet',
    );
    return '$_temp0';
  }

  @override
  String nVerifActualizadas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n updated',
      one: '1 updated',
    );
    return '$_temp0';
  }

  @override
  String nVerifBorradas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n deleted',
      one: '1 deleted',
    );
    return '$_temp0';
  }

  @override
  String nCopas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n cups',
      one: '1 cup',
    );
    return '$_temp0';
  }

  @override
  String nCobros(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n charges',
      one: '1 charge',
    );
    return '$_temp0';
  }

  @override
  String get syncSinClave => 'Enter an event key.';

  @override
  String syncNoSePudoAbrir(String detalle) {
    return 'Could not open the connection: $detalle';
  }

  @override
  String get syncFormatoDesconocido => 'Unknown sync format.';

  @override
  String get syncOtraVersion =>
      'The other Control has a different version of PitWall Control. Update everyone to the same version.';

  @override
  String syncVerifNoExiste(String equipo, String manga) {
    return 'Scrutineering of \"$equipo\" in \"$manga\": that round or team does not exist here.';
  }

  @override
  String syncCocheNoCatalogo(String equipo, String coche) {
    return '$equipo: the car \"$coche\" is not in this Control\'s catalogue.';
  }

  @override
  String syncTandaFaltaEquipo(String tanda) {
    return 'Round \"$tanda\": a team is missing here; its lane is left empty.';
  }

  @override
  String syncResultFaltaPiloto(String tanda) {
    return 'Results of \"$tanda\": a driver or team is missing here; that row is not copied.';
  }

  @override
  String syncEquipoFaltanPilotos(String equipo) {
    return 'Team \"$equipo\": some of its drivers are missing here; it is not copied.';
  }

  @override
  String get syncSinRespuesta => 'Not responding (still on the same wifi?).';

  @override
  String get syncSinConexion => 'Cannot connect (still on the same wifi?).';

  @override
  String get syncControlAnadido => 'Control added.';

  @override
  String syncNoHayControlEn(String dir) {
    return 'No Control is connected at $dir.';
  }

  @override
  String get primeroInscribeEquipos => 'First enter teams in the race.';

  @override
  String get sinCoincidenciasPunto => 'No matches.';

  @override
  String get ajusteManualHistorial =>
      'The balance change is recorded as \"Manual adjustment\" in the history.';

  @override
  String bonifTope(int bonif, int tope) {
    return '+$bonif, capped at $tope';
  }

  @override
  String desfaseHora(int min) {
    return 'The other Control\'s clock is off by $min min from this device. Turn on automatic time everywhere.';
  }

  @override
  String nCarreras(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n races',
      one: '1 race',
    );
    return '$_temp0';
  }

  @override
  String bonifMotivo(String carreras, String categoria, int bonif) {
    return 'Closing bonus for $carreras ($categoria): +$bonif';
  }

  @override
  String bonifLimiteTope(int tope) {
    return ', capped at $tope';
  }

  @override
  String get importarPilotosFinalizado =>
      'Import drivers from a finished championship';

  @override
  String get importarPilotosFinalizadoAyuda =>
      'Brings its drivers with the closing balance as initial credits.';

  @override
  String get noImportar => 'Do not import';

  @override
  String tesoreriaNoCuadra(String suma, String pagat) {
    return 'Finances: Coordination + Club must add up to Paid ($suma ≠ $pagat).';
  }

  @override
  String bonifCierrePregunta(String tope) {
    return 'You have marked the championship as finished.\n\nThe balance of every driver who has competed will be topped up: balance = min(current balance + bonus by category and number of races, $tope). Each adjustment is recorded as a movement showing the bonus applied.\n\nImportant: the bonus uses the closing category (check it first in Credits → Category review if there are promotions or relegations).\n\nApply it now?';
  }

  @override
  String get ahoraNo => 'Not now';

  @override
  String get eliminarCampeonato => 'Delete championship';

  @override
  String eliminarCampeonatoTexto(String nombre) {
    return 'Delete \"$nombre\"?\n\nIts races, rounds, entries, results, scrutineering and payments will also be deleted. This cannot be undone.';
  }

  @override
  String get nuevoCampeonato => 'New championship';

  @override
  String get editarCampeonato => 'Edit championship';

  @override
  String get obligatoriosAviso =>
      'Required (*): name, at least one cup and the motor type. The rest can be filled in later.';

  @override
  String get datosBasicos => 'Basic details';

  @override
  String get nombreCampeonatoObligatorio => 'Championship name *';

  @override
  String get nombreCampeonatoEjemplo =>
      'E.g. 2026 League, Individual LMP-HYP-GT3 Autumn';

  @override
  String get formato => 'Format';

  @override
  String get formatoAyuda =>
      'Pairs = 2 drivers per team. Individual = 1 driver';

  @override
  String get formatoParejas => 'Pairs';

  @override
  String get formatoIndividual => 'Individual';

  @override
  String get anio => 'Year';

  @override
  String get anioInvalido => 'Invalid year';

  @override
  String get activarCampeonatoAlCrear =>
      'Activate this championship when creating it';

  @override
  String get campeonatoVisible => 'Visible championship';

  @override
  String get campeonatoVisibleAyuda =>
      'Only visible championships appear in the selector';

  @override
  String get clubOrgAyudaExportaciones =>
      'Appears in the header of the exports (PDFs of rounds, scrutineering, standings and credits).';

  @override
  String get categoriasCopasObligatorio => 'Categories / cups *';

  @override
  String get seleccionaCopasTexto =>
      'Select the ones used in this championship. There can be just one (e.g. \"Group C\") or several (e.g. \"LMP + HYP + GT3\").';

  @override
  String get anadirNuevaCategoria => 'Add new category';

  @override
  String get anadirNuevaCategoriaAyuda => 'If you cannot find it above';

  @override
  String get motorObligatorio => 'Motor *';

  @override
  String get rangoMotorCampeonatoTexto =>
      'Range of engine numbers that the organisation draws among the teams in each race. Leave it empty if you do not use a draw.';

  @override
  String get creditosYTesoreria => 'Credits and finances';

  @override
  String get creditosTesoreriaAyuda =>
      'Turn them on only if the championship uses them; otherwise their screens are hidden from the menu.';

  @override
  String get usaCreditos => 'Uses a credit system (handicap)';

  @override
  String get usaCreditosAyuda =>
      'Credit handicap system. Turn it off if the championship does not use it.';

  @override
  String get topeRegularizacion => 'Credit top-up cap';

  @override
  String get topeRegularizacionAyuda =>
      'Maximum credits when topping up at the end of the season';

  @override
  String get numeroPositivo => 'Positive number';

  @override
  String get gestionaTesoreria => 'Manages finances (fees/payments)';

  @override
  String get gestionaTesoreriaAyuda =>
      'Turn it off if this championship does not track money.';

  @override
  String get pagatTexto =>
      'PAID is the total fee. COORDINATION SHARE + CLUB SHARE must add up to PAID (it is the breakdown of where the money goes).';

  @override
  String get pagatObligatorio => 'Paid (€) *';

  @override
  String get coordinadoraEurParentesis => 'Coordination (€)';

  @override
  String get clubEurParentesis => 'Club (€)';

  @override
  String get indicaLaCuota => 'Enter the fee';

  @override
  String get numeroNoValido => 'Invalid number';

  @override
  String get masOpcionesPuntuacion =>
      'More options: scoring, scrutineering and PDF';

  @override
  String get puntuacion => 'Scoring';

  @override
  String get numeroDescartes => 'Number of drop scores';

  @override
  String get numeroDescartesAyuda =>
      'How many of the driver\'s worst races are dropped';

  @override
  String get entreCeroYCinco => 'Between 0 and 5';

  @override
  String get tablaDePuntosAyuda => 'Points by position in each race';

  @override
  String get verificacionAyuda =>
      'Axle width, cars and manufacturers checked during scrutineering.';

  @override
  String get anchuraEjeCategoriasAyuda =>
      'Maximum axle width (mm) per category. Leave empty if it is not checked in that cup.';

  @override
  String get pesoMinCreditos =>
      'Minimum weight and credits in this championship';

  @override
  String get pesoMinCampeonato => 'Minimum weight in this championship';

  @override
  String get pesoMinCampeonatoAyuda =>
      'Fixes the car values so that catalogue changes do not affect this championship.';

  @override
  String get marcaPdf => 'Branding in the PDFs (optional)';

  @override
  String get marcaPdfTexto =>
      'Header title and footer motto in the exports (PDF) of THIS championship. If you leave it empty, a default value is used.';

  @override
  String get tituloCabecera => 'Header title';

  @override
  String get tituloCabeceraEjemplo => 'E.g. PITWALL or your club\'s name';

  @override
  String get lemaPie => 'Footer motto';

  @override
  String get lemaPieEjemplo => 'E.g. your club · town';

  @override
  String get campeonatoFinalizadoTitulo => 'Championship finished';

  @override
  String get campeonatoFinalizadoAyuda =>
      'Season closed: the standings sort by net, the closing bonus is enabled and its scrutineering sheets are locked (read-only).';

  @override
  String get campeonatos => 'Championships';

  @override
  String get activar => 'Activate';

  @override
  String anioTexto(int anio) {
    return 'Year $anio';
  }

  @override
  String descartesTexto(int n) {
    return 'Drops: $n';
  }

  @override
  String get cochesDelCampeonato => 'Championship cars';

  @override
  String get fijarValoresCatalogo => 'Fix the catalogue\'s current values';

  @override
  String get volverTodosAlCatalogo => 'Return all to the catalogue';

  @override
  String get volverAlCatalogo => 'Return to the catalogue';

  @override
  String get volverAlCatalogoTexto =>
      'The values fixed in this championship are deleted and all cars go back to using the catalogue\'s minimum weight and credits.\n\nAlready validated scrutineering sheets do not change: they keep the rules they were scrutinised with.';

  @override
  String valorNoValidoEn(String coche) {
    return 'Invalid value in $coche.';
  }

  @override
  String get buscarCoche => 'Search car';

  @override
  String get pesoMinG => 'Min. wt. (g)';

  @override
  String fijadosCoches(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n cars',
      one: '1 car',
    );
    return 'Catalogue values fixed for $_temp0.';
  }

  @override
  String get aunNoHayHistorial => 'No history yet.';

  @override
  String get cochesYaFijados => 'All cars already had their values fixed.';

  @override
  String get yCreditos => ' and credits';

  @override
  String pesoMinCochesTexto(String creditos, String campeonato) {
    return 'Minimum weight$creditos for each car in $campeonato. Empty = the catalogue value is used. What you set here does not change even if the catalogue is later modified (e.g. for the next season).';
  }

  @override
  String get verifsValidadasNoCambian =>
      'Validated scrutineering sheets do not change: they keep the rules they were scrutinised with.';

  @override
  String get noHayCochesConCopas =>
      'There are no catalogue cars with this championship\'s cups.';

  @override
  String get indicaDireccionPitwall => 'Enter PitWall\'s address.';

  @override
  String errorAlPedirCarreras(String codigo) {
    return 'Error $codigo while fetching the races.';
  }

  @override
  String errorAlPedirResultados(String codigo) {
    return 'Error $codigo while fetching the results.';
  }

  @override
  String respuestaNoReconocida(String schema) {
    return 'Unrecognised response ($schema).';
  }

  @override
  String get pinIncorrecto => 'Wrong PIN or unauthorised device.';

  @override
  String errorCodigoHttp(String codigo) {
    return 'Error $codigo.';
  }

  @override
  String noSePudoConectarPitwall(String detalle) {
    return 'Could not connect to PitWall: $detalle';
  }

  @override
  String verificacionesEnviadas(String n, String nombre) {
    return '$n scrutineering sheet(s) sent to $nombre.';
  }

  @override
  String get idiomaDelPdf => 'PDF language';

  @override
  String get imagenes => 'Images';

  @override
  String difValor(String titulo, String antes, String unidad, String ahora) {
    return '$titulo: $antes$unidad (now $ahora$unidad)';
  }

  @override
  String difAnadidas(String lista) {
    return 'added: $lista';
  }

  @override
  String difQuitadas(String lista) {
    return 'removed: $lista';
  }

  @override
  String difNombreCoche(String antes, String ahora) {
    return 'Car name: $antes (now $ahora)';
  }

  @override
  String get tituloPesoMinimo => 'Minimum weight';

  @override
  String get tituloCreditosCoche => 'Car credits';

  @override
  String get tituloRpmMax => 'Motor max. RPM';

  @override
  String get tituloImanMax => 'Motor max. magnet';

  @override
  String get tituloEjeDelMax => 'Front axle max.';

  @override
  String get tituloEjeTraMax => 'Rear axle max.';

  @override
  String get tituloFabricantesPermitidos => 'Allowed manufacturers';

  @override
  String get tituloMarcasCatalogo => 'Catalogue brands';

  @override
  String get tituloLlantasDel => 'Front rims';

  @override
  String get tituloLlantasTra => 'Rear rims';

  @override
  String get tituloBancadas => 'Motor mounts';

  @override
  String get tituloNeumaticos => 'Tyres';

  @override
  String get coches => 'Cars';

  @override
  String get marcas => 'Brands';

  @override
  String get llantas => 'Rims';

  @override
  String get engranajes => 'Gears';

  @override
  String get motores => 'Motors';

  @override
  String get bancadas => 'Motor mounts';

  @override
  String get neumaticos => 'Tyres';

  @override
  String get copas => 'Cups';

  @override
  String get clubs => 'Clubs';

  @override
  String get llanta => 'Rim';

  @override
  String get engranaje => 'Gear';

  @override
  String get sinCopaCategoria => 'No cup/category (cannot be used)';

  @override
  String copasEtiqueta(String copas) {
    return 'Cups: $copas';
  }

  @override
  String pesoYCreditos(String peso, String creditos) {
    return 'Min. weight ${peso}g  ·  Cred. $creditos';
  }

  @override
  String get todasLasCopas => 'All cups';

  @override
  String get todas => 'All';

  @override
  String get sinCoincidencias => 'No matches';

  @override
  String get sinCoches => 'No cars';

  @override
  String get sinMarcas => 'No brands';

  @override
  String get sinLlantas => 'No rims';

  @override
  String get sinEngranajes => 'No gears';

  @override
  String get sinMotores => 'No motors';

  @override
  String get sinBancadas => 'No motor mounts';

  @override
  String get sinChasis => 'No chassis';

  @override
  String get sinNeumaticos => 'No tyres';

  @override
  String get sinCopas => 'No cups';

  @override
  String get sinClubs => 'No clubs';

  @override
  String get buscarCochePuntos => 'Search car…';

  @override
  String get sinMedidas => 'No measurements';

  @override
  String get sinReferencia => 'No reference';

  @override
  String get calculandoCambiosSubir => 'Working out the changes to upload…';

  @override
  String get todoCatalogoExcel => 'The whole catalogue in Excel';

  @override
  String get exportarTodoExcel => 'Export everything to Excel';

  @override
  String get unaPestanaPorCatalogo => 'One tab per catalogue';

  @override
  String get importarExcelEditado => 'Import the edited Excel file';

  @override
  String get actualizaPorIdCreaNuevos => 'Updates by ID and creates new ones';

  @override
  String bajarDesdeDriveCon(String hoja, String pestana) {
    return 'Download from Drive ($hoja · $pestana)';
  }

  @override
  String get subirMisCambiosSheet => 'Upload my changes to the Sheet';

  @override
  String get importarPestanaActual => 'Import the current tab';

  @override
  String get importarCatalogosExcelTitulo => 'Import catalogues from Excel';

  @override
  String get importarCatalogosExcelTexto =>
      'Rows with an ID will be updated and those without one will be created.\n\nNothing is deleted: entries you remove from the sheet will stay in the app.';

  @override
  String resumenCreadosActualizados(int creados, int actualizados) {
    return '✓ Created: $creados · Updated: $actualizados';
  }

  @override
  String catalogoImportadoLinea(String nombre, int creados, int actualizados) {
    String _temp0 = intl.Intl.pluralLogic(
      creados,
      locale: localeName,
      other: '$creados new',
      one: '1 new',
    );
    String _temp1 = intl.Intl.pluralLogic(
      actualizados,
      locale: localeName,
      other: '$actualizados updated',
      one: '1 updated',
    );
    return '• $nombre: $_temp0, $_temp1';
  }

  @override
  String pestanasIgnoradasAviso(String lista) {
    return '⚠ These tabs were not imported because their name does not match any catalogue:\n$lista\nDo not rename the tabs in the exported file.';
  }

  @override
  String erroresEtiqueta(String lista) {
    return 'Errors:\n$lista';
  }

  @override
  String eliminarFichaTexto(String nombre) {
    return 'Delete \"$nombre\"?';
  }

  @override
  String vacioPulsaAnadir(String texto) {
    return '$texto.\nTap + to add one.';
  }

  @override
  String get copasDondeAplica => 'Cups it applies to';

  @override
  String get copasSinMarcarAviso =>
      'Left unticked = it cannot be used in any cup.';

  @override
  String get copasMarcarAviso => 'Tick only the cups where it is valid.';

  @override
  String get nuevoCoche => 'New car';

  @override
  String get editarCoche => 'Edit car';

  @override
  String get nombreCompletoObligatorio => 'Full name *';

  @override
  String get nombreCompletoEjemplo => 'E.g. SCALEAUTO-BMW M8 GTE';

  @override
  String get marcaObligatoria => 'Brand *';

  @override
  String get modeloObligatorio => 'Model *';

  @override
  String get pesoMinimoObligatorio => 'Minimum weight (g) *';

  @override
  String get pesoMinimoAyuda =>
      'Does not change validated scrutineering records or championships with fixed values';

  @override
  String get creditosCoche => 'Car credits';

  @override
  String get creditosCocheAyuda => 'Negative or positive';

  @override
  String get galeria => 'Gallery';

  @override
  String get camara => 'Camera';

  @override
  String get quitarFoto => 'Remove photo';

  @override
  String get nuevaMarca => 'New brand';

  @override
  String get editarMarca => 'Edit brand';

  @override
  String get codigoObligatorio => 'Code *';

  @override
  String get marcaCodigoEjemplo => 'E.g. SIT, SCA, SLP';

  @override
  String get nuevaLlanta => 'New rim';

  @override
  String get editarLlanta => 'Edit rim';

  @override
  String get llantaDimensionEjemplo => 'E.g. 15.8 x 8 PL';

  @override
  String get delantera => 'Front';

  @override
  String get trasera => 'Rear';

  @override
  String get ambas => 'Both';

  @override
  String get nuevoEngranaje => 'New gear';

  @override
  String get editarEngranaje => 'Edit gear';

  @override
  String get diametroEjemplo => 'E.g. 6.5';

  @override
  String get dientesEjemplo => 'E.g. 12 pinion, 28 crown';

  @override
  String nDientes(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n teeth',
      one: '1 tooth',
    );
    return '$_temp0';
  }

  @override
  String get nuevoMotor => 'New motor';

  @override
  String get editarMotor => 'Edit motor';

  @override
  String get motorIdentificadorAyuda => 'Identifier or model';

  @override
  String get nuevaBancada => 'New motor mount';

  @override
  String get editarBancada => 'Edit motor mount';

  @override
  String get bancadaEjemplo => 'E.g. Slot.it 1.0 carbon';

  @override
  String get nuevoNeumatico => 'New tyre';

  @override
  String get editarNeumatico => 'Edit tyre';

  @override
  String get neumaticoEjemplo => 'E.g. AS25 19.0 BLACK';

  @override
  String get referenciaOpcional => 'Reference (optional)';

  @override
  String get copaEjemplo => 'E.g. GT, GT2, LMP, HYP';

  @override
  String get clubNombreEjemplo => 'E.g. EL SOT, GASCLAVAT, SLOTMANIA';

  @override
  String get chasisEjemplo => 'E.g. BLACK PLASTIC INJECTION, 3D';

  @override
  String get nuevoChasis => 'New chassis';

  @override
  String get nuevaCopa => 'New cup';

  @override
  String get nuevoClub => 'New club';

  @override
  String importarTitulo(String titulo) {
    return 'Import $titulo';
  }

  @override
  String pasoEligeLaFuente(int n) {
    return '$n. Choose the source';
  }

  @override
  String get archivoCsvExcel => 'CSV / Excel file';

  @override
  String get sustituirCatalogoExistente => 'Replace the existing catalogue';

  @override
  String get sustituirCatalogoExistenteTexto =>
      'If ticked, the table is emptied first and then the import runs.';

  @override
  String importarNFilas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Import $n rows',
      one: 'Import 1 row',
    );
    return '$_temp0';
  }

  @override
  String get vincularSinImportar => 'Link without importing';

  @override
  String get sustituirCatalogoTitulo => 'Replace the catalogue';

  @override
  String get anadirCatalogoTitulo => 'Add to the catalogue';

  @override
  String sustituirCatalogoTexto(int n, int m) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'The $n current entries will be emptied',
      one: 'The current entry will be emptied',
    );
    String _temp1 = intl.Intl.pluralLogic(
      m,
      locale: localeName,
      other: 'the $m rows from the sheet',
      one: 'the row from the sheet',
    );
    return '$_temp0 before importing $_temp1.\n\nSync IDs, local car photos and values fixed in championships are lost. Anything that exists only in the app and not in the sheet disappears.';
  }

  @override
  String anadirCatalogoTexto(int n, int m) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'The $n rows from the sheet will be added',
      one: 'The row from the sheet will be added',
    );
    String _temp1 = intl.Intl.pluralLogic(
      m,
      locale: localeName,
      other: 'the $m entries you already have',
      one: 'the entry you already have',
    );
    return '$_temp0 to $_temp1.\n\nRows that already exist (same name or key) will be duplicated. If you only want to link the sheet to bring in changes, cancel and use “Link without importing”.';
  }

  @override
  String get siSustituir => 'Yes, replace';

  @override
  String get siAnadir => 'Yes, add';

  @override
  String get hojaVinculadaTitulo => 'Sheet linked';

  @override
  String hojaVinculadaTexto(String pestana) {
    return 'Nothing was imported and no catalogue entry was touched.\n\nIn the “$pestana” tab the sync button is already there: “Update from Drive” will bring in the sheet changes, matching by the ID column (if there is one) or by name, without duplicating the entries you already have.';
  }

  @override
  String errorAlVincular(String detalle) {
    return 'Error linking: $detalle';
  }

  @override
  String resumenImportacionCatalogo(int ok, int saltados) {
    return '✓ Added: $ok\n✗ Skipped: $saltados';
  }

  @override
  String get hojaVinculadaAviso =>
      '\n\nSheet linked: from now on, press \"Update from Drive\" in the catalogue tab to bring in changes.';

  @override
  String get eligeHojaGoogle => 'Choose the Google sheet';

  @override
  String modificadaFecha(DateTime fecha) {
    final intl.DateFormat fechaDateFormat = intl.DateFormat.yMd(localeName);
    final String fechaString = fechaDateFormat.format(fecha);

    return 'Modified: $fechaString';
  }

  @override
  String avisoCatalogoLlenoIntro(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n entries',
      one: '1 entry',
    );
    return 'This catalogue already has $_temp0 in the app.';
  }

  @override
  String get avisoCatalogoLlenoImportar =>
      '• “Import” will add the sheet rows as new ones: any that already exist will be duplicated.';

  @override
  String get avisoCatalogoLlenoVincular =>
      '• If you only want to link the sheet, use “Link without importing”; afterwards, “Update from Drive” brings in the changes without duplicating.';

  @override
  String get avisoCatalogoLlenoSustituir =>
      '• “Replace the existing catalogue” empties the current catalogue: sync IDs, local photos and values fixed in championships are lost.';

  @override
  String get ayudaCatalogoCoches =>
      'CSV/Excel or Google Sheets with columns: Name, Brand, Model, Minimum weight, Credits, Cup(s) (comma-separated; empty = all).';

  @override
  String get ayudaCatalogoMarcas => 'CSV/Excel with columns: Code, Name.';

  @override
  String get ayudaCatalogoLlantas =>
      'CSV/Excel with columns: Size, Type (DELANTERA / TRASERA / AMBAS).';

  @override
  String get ayudaCatalogoEngranajes =>
      'CSV/Excel or Google Sheets with columns: Brand, Teeth, Type (PIÑÓN / CORONA).';

  @override
  String get ayudaCatalogoMotores =>
      'CSV/Excel or Google Sheets with columns: Motor, RPM, Gauss, Cup(s) (comma-separated; empty = all).';

  @override
  String get ayudaCatalogoSimple => 'CSV/Excel with one column: Name.';

  @override
  String get ayudaCatalogoNeumaticos =>
      'CSV/Excel with columns: Name, Reference (optional).';

  @override
  String get modeloCampo => 'Model';

  @override
  String get pesoMinimoCampo => 'Minimum weight *';

  @override
  String get creditosCampo => 'Credits';

  @override
  String get copasCampo => 'Cup(s)';

  @override
  String get fotoEnlaceDrive => 'Photo (Drive link)';

  @override
  String get tipoPinonCorona => 'Type (pinion/crown)';

  @override
  String get referenciaCampo => 'Reference';

  @override
  String get dimensionObligatoria => 'Size *';

  @override
  String get tipoCampo => 'Type';

  @override
  String get dientesObligatorio => 'Teeth *';

  @override
  String get subirAlSheet => 'Upload to the Sheet';

  @override
  String subidoSheetResumen(int anadidas, int actualizadas, int borradas) {
    String _temp0 = intl.Intl.pluralLogic(
      anadidas,
      locale: localeName,
      other: '$anadidas added',
      one: '1 added',
    );
    String _temp1 = intl.Intl.pluralLogic(
      actualizadas,
      locale: localeName,
      other: '$actualizadas updated',
      one: '1 updated',
    );
    String _temp2 = intl.Intl.pluralLogic(
      borradas,
      locale: localeName,
      other: '$borradas deleted',
      one: '1 deleted',
    );
    return '✓ Uploaded to the Sheet: $_temp0, $_temp1, $_temp2.';
  }

  @override
  String fotosSinSubir(String lista) {
    return '\n✗ Photos not uploaded: $lista';
  }

  @override
  String errorAlSubir(String detalle) {
    return 'Error uploading: $detalle';
  }

  @override
  String nadaQueSubir(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n identical rows',
      one: '1 identical row',
    );
    return 'There is nothing to upload: the sheet already matches the app.\n\n($_temp0)';
  }

  @override
  String get subidaIntro =>
      'Your changes will be uploaded to the Google Sheet.';

  @override
  String filasNuevasResumen(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '· $n new rows (they are added)',
      one: '· 1 new row (it is added)',
    );
    return '$_temp0';
  }

  @override
  String conDiferenciasResumen(int n) {
    return '· $n with differences (choose which ones overwrite the sheet)';
  }

  @override
  String borradasResumen(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '· $n deleted in the app, pending deletion in the sheet (choose which ones)',
      one:
          '· 1 deleted in the app, pending deletion in the sheet (choose whether)',
    );
    return '$_temp0';
  }

  @override
  String identicasResumen(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '· $n identical (ignored)',
      one: '· 1 identical (ignored)',
    );
    return '$_temp0';
  }

  @override
  String get borradasEnAppPregunta =>
      'Deleted in the app — delete them in the sheet too?';

  @override
  String get seBorraraEsaFila => 'That row will be deleted from the Sheet';

  @override
  String get seDejaEnSheet => 'It is left in the Sheet (not deleted)';

  @override
  String get filasNuevasTitulo => 'New rows';

  @override
  String get seAnadiraAlSheet => 'It will be added to the Sheet';

  @override
  String get diferenciasConflictos => 'Differences (conflicts)';

  @override
  String subirNAlSheet(int n) {
    return 'Upload $n to the Sheet';
  }

  @override
  String get seSubiraTuVersion =>
      'Your version will be uploaded (it overwrites the sheet)';

  @override
  String get seMantieneSheet => 'The Sheet version is kept';

  @override
  String appValor(String valor) {
    return 'app: $valor';
  }

  @override
  String sheetValor(String valor) {
    return 'sheet: $valor';
  }

  @override
  String get vacioParentesis => '(empty)';

  @override
  String get plantillasIntro =>
      'Download the template, fill it in with your data (delete the example row) and then import it from the matching section. The first row holds the columns: do not change it.';

  @override
  String get descargar => 'Download';

  @override
  String get plantillaPilotos => 'Drivers';

  @override
  String get plantillaPilotosTexto => 'To import drivers into a championship.';

  @override
  String get plantillaEquipos => 'Teams (pairs)';

  @override
  String get plantillaEquiposTexto =>
      'Teams with one or two drivers. Leave driver 2 blank for a solo entry.';

  @override
  String get plantillaEquiposResistencia => 'Endurance teams (24H/12H)';

  @override
  String get plantillaEquiposResistenciaTexto =>
      'Teams of 3 to 6 drivers. Leave blank the ones you do not use. Each driver\'s category is taken from their already imported entry.';

  @override
  String get plantillaInscripciones => 'Race entries';

  @override
  String get plantillaInscripcionesTexto =>
      'Teams entering a race, with their preferred day.';

  @override
  String get plantillaParticipantesVerificacion =>
      'Free scrutineering participants';

  @override
  String get plantillaParticipantesVerificacionTexto =>
      'Participants in a free scrutineering session. Driver 2 and Team are optional; if the cup is empty it is chosen when importing.';

  @override
  String get plantillaCoches => 'Catalogue · Cars';

  @override
  String get plantillaCochesTexto => 'Car models in the catalogue.';

  @override
  String get plantillaMotores => 'Catalogue · Motors';

  @override
  String get plantillaMotoresTexto =>
      'Approved motors (reference RPM and gauss).';

  @override
  String get plantillaMarcas => 'Catalogue · Brands';

  @override
  String get plantillaMarcasTexto => 'Brands (short code + name).';

  @override
  String get plantillaLlantas => 'Catalogue · Rims';

  @override
  String get plantillaLlantasTexto =>
      'Size and type (DELANTERA / TRASERA / AMBAS).';

  @override
  String get plantillaEngranajes => 'Catalogue · Gears';

  @override
  String get plantillaEngranajesTexto =>
      'Pinions and crowns (type, diameter, teeth).';

  @override
  String get pegaClientIdSecret =>
      'Paste the Client ID and Client Secret before saving.';

  @override
  String get clientIdNoValido =>
      'The Client ID does not look valid (it should end in \".apps.googleusercontent.com\"). Check that you copied it in full from Google Cloud Console.';

  @override
  String get credencialesGuardadasAviso =>
      'Credentials saved. Now press \"Connect with Google\".';

  @override
  String get abriendoNavegadorAutoriza =>
      'Opening the browser… authorise and come back here.';

  @override
  String get conectadoGoogleOk => 'Successfully connected to Google.';

  @override
  String get desconectarGoogle => 'Disconnect Google';

  @override
  String get desconectarGoogleTexto =>
      'The app will stop reading your sheets until you connect again. Continue?';

  @override
  String get desconectar => 'Disconnect';

  @override
  String get credencialesProyectoGoogleCloud =>
      'Google Cloud project credentials';

  @override
  String get credencialesProyectoTexto =>
      'These credentials are created only once in your Google Cloud account. Press \"How to get them\" for a step-by-step guide.';

  @override
  String get comoConseguirlas => 'How to get them';

  @override
  String get guardarCredenciales => 'Save credentials';

  @override
  String get permisosSolicitados => 'Permissions requested';

  @override
  String get permisosTexto =>
      '• Read your spreadsheets (Google Sheets — read-only)\n• List Drive files (Google Drive — read-only)\n• Create and modify the app\'s backup file (Drive — only the app\'s file)\n\nPitWall Control does not touch any of your files, only the one it creates.';

  @override
  String get copiaCompartidaDrive => 'Shared backup on Drive';

  @override
  String get copiaCompartidaDriveTexto =>
      'Upload or download the database to work across several devices.';

  @override
  String get conectadoConGoogle => 'Connected to Google';

  @override
  String get sinConectar => 'Not connected';

  @override
  String get faltanCredencialesGoogle =>
      'Missing Google Cloud project credentials';

  @override
  String get conectarConGoogle => 'Connect with Google';

  @override
  String get conseguirCredenciales => 'Get credentials';

  @override
  String get conseguirCredencialesTexto =>
      'It only takes once, it\'s free and no card is needed. You need the Google account that holds your sheets and your Drive, and about 10 minutes.';

  @override
  String get verManualCapturas => 'View the manual with screenshots';

  @override
  String get guiaPaso1Titulo => 'Create a project';

  @override
  String get guiaPaso1Texto =>
      'Sign in to Google Cloud Console with your Google account. At the top, press the project selector → \"New project\". Name: \"PitWall Control\". Press \"Create\" and check that it stays selected.';

  @override
  String get abrirCloudConsole => 'Open Cloud Console';

  @override
  String get guiaPaso2Titulo => 'Enable both APIs';

  @override
  String get guiaPaso2Texto =>
      'Enable \"Google Sheets API\" and also \"Google Drive API\" (press \"Enable\" on each). Otherwise the connection will fail.';

  @override
  String get apiSheets => 'Sheets API';

  @override
  String get apiDrive => 'Drive API';

  @override
  String get pantallaDeConsentimiento => 'Consent screen';

  @override
  String get guiaPaso3Texto =>
      'In \"Google Auth Platform\" press \"Get started\" and follow the wizard: 1) name \"PitWall Control\" and your support email; 2) Audience: choose \"External users\" (\"Internal\" only works for company accounts); 3) your contact email; 4) accept the data policy, \"Continue\" and \"Create\".';

  @override
  String get guiaPaso4Titulo => 'Add your account as a test user';

  @override
  String get guiaPaso4Texto =>
      'In the side menu go to \"Audience\" → \"Test users\" → \"Add users\". Type the Google email you will use to connect Control (and anyone else who will connect) and save. Without this step Google returns \"Error 403: access_denied\".';

  @override
  String get publico => 'Audience';

  @override
  String get guiaPaso5Titulo => 'Create the OAuth client';

  @override
  String get guiaPaso5Texto =>
      'In \"Clients\" press \"Create client\". Type: \"Desktop app\". Name: \"PitWall Control Desktop\". Press \"Create\".';

  @override
  String get clientes => 'Clients';

  @override
  String get guiaPaso6Titulo => 'Copy the ID and the secret';

  @override
  String get guiaPaso6Texto =>
      'The client ID (ends in .apps.googleusercontent.com) and the secret appear. Copy them and press \"Download JSON\": Google only shows the secret at this moment. Paste them on the previous screen, press \"Save credentials\" and then \"Connect with Google\".';

  @override
  String get guiaPaso7Titulo => 'Authorise in the browser';

  @override
  String get guiaPaso7Texto =>
      'Choose the account from step 4. If \"Google hasn\'t verified this app\" appears, press \"Advanced\" → \"Go to PitWall Control (unsafe)\", tick all the permissions and \"Continue\".';

  @override
  String get avisoPrueba7Dias =>
      'So it doesn\'t expire after 7 days: while the app is in \"Testing\" status, Google signs you out every 7 days. In \"Audience\" press \"Publish app\" (it moves to \"In production\"); for personal use it needs no verification.';

  @override
  String get cosasQueSuelenFallar => 'Things that often fail:';

  @override
  String get pistaUsuariosPrueba =>
      'Google is blocking the account you signed in with because the app is in \"Testing\" mode and that account is NOT in the test users list. In Google Cloud Console → Google Auth Platform → Audience → \"Test users\" → \"Add users\", add that exact email. Or press \"Publish app\" on that same screen.';

  @override
  String get pistaCredencialEscritorio =>
      'The credential type is not \"Desktop app\". Create the OAuth credentials again in Google Cloud Console choosing \"Desktop app\".';

  @override
  String get pistaClientIdSecreto =>
      'Wrong Client ID or Client Secret. Copy them again from Google Cloud Console (Credentials → your OAuth client) and paste them without spaces.';

  @override
  String get pistaApisNoActivadas =>
      'The Google Sheets and/or Drive APIs are not enabled in your project. Go to \"APIs & Services → Library\", search for \"Google Sheets API\" and \"Google Drive API\" and press Enable.';

  @override
  String get pistaNavegador =>
      'The app could not open the browser. Close this window, wait 2 seconds and try again.';

  @override
  String get pistaRed =>
      'Network problem. Check that you have an internet connection and try again.';

  @override
  String get pistaGuardarCredenciales =>
      'You have not saved the Client ID and Client Secret. Fill in the fields and press \"Save credentials\" first.';

  @override
  String get pistaCredencialPorDefecto =>
      'Check that the credential type in Google Cloud Console is \"Desktop app\" and that your email is added as a test user on the consent screen.';

  @override
  String get subirCopiaADrive => 'Upload backup to Drive';

  @override
  String get subirCopiaTexto =>
      'A current backup will be uploaded to your Drive as \"pitwall-backup.zip\". It includes the database, the inspection photos and the app configuration (Google credentials, theme and preferences); never the connected session.\n\nIf there was an earlier version, it is replaced by the new one.\n\nContinue?';

  @override
  String get restaurarTambienConfig =>
      'Also restore the configuration from the backup';

  @override
  String get restaurarTambienConfigSub =>
      'Google credentials, theme and preferences. Never the connected session.';

  @override
  String get siRestaurar => 'Yes, restore';

  @override
  String get descargarYRestaurar => 'Download and restore';

  @override
  String get descargarRestaurarTexto =>
      'Your local database will be replaced with the backup on Drive. ⚠️ Any local change you have not uploaded will be lost.\n\nAfterwards you will have to close and reopen the app.';

  @override
  String get copiaDePitwall => 'PitWall backup';

  @override
  String get restaurarDesdeArchivo => 'Restore from file';

  @override
  String restaurarDesdeArchivoTexto(Object nombre) {
    return 'Your local database will be replaced with the backup «$nombre». ⚠️ Any local change you have not uploaded will be lost.\n\nNo Google connection is needed for this.\n\nAfterwards you will have to close and reopen the app.';
  }

  @override
  String get copiaActualEnDrive => 'Current backup on Drive';

  @override
  String get noHayCopiaDriveTexto =>
      'There is no backup on Drive yet. Press \"Upload backup\" to create the first one.';

  @override
  String ultimaSubida(Object fecha) {
    return 'Last upload: $fecha';
  }

  @override
  String tamanoKB(Object kb) {
    return 'Size: $kb KB';
  }

  @override
  String get restaurarDesdeArchivoPuntos => 'Restore from file…';

  @override
  String get comoTrabajarEnEquipo => 'How to work as a team';

  @override
  String get trabajoEnEquipoTexto =>
      '• When you start working, press \"Download\" to get the latest version.\n• When you finish your changes, press \"Upload\" so the others can receive them.\n• If two people edit at the same time, whoever uploads last wins (there is no automatic merge). Most practical: coordinate who edits at each moment.';

  @override
  String get sinConexionGoogle => 'Not connected to Google';

  @override
  String get sinConexionGoogleTexto =>
      'Connect to Google to be able to upload or download the backup.\n\nYou can also restore a backup saved as a file (.zip), without a connection.';

  @override
  String get importarEquiposDesdeSheets => 'Import teams from Sheets';

  @override
  String get importacionEquiposAviso =>
      'From now on, press \"Update from Drive\" in Teams.';

  @override
  String get conectaCuentaHojas =>
      'Connect your account once so the app can read the sheets.';

  @override
  String nDeTotal(Object n, Object total) {
    return '$n of $total';
  }

  @override
  String hojaModificada(Object fecha) {
    return 'Modified: $fecha';
  }

  @override
  String get importarDesdeGoogleSheets => 'Import from Google Sheets';

  @override
  String get importacionInscripcionesAviso =>
      'From now on, press \"Update from Drive\" in Entries to bring in new form responses.';

  @override
  String get conectaCuentaGoogleForm =>
      'Connect your account once so the app can read the sheets where the Google Form responses arrive.';

  @override
  String get diaPreferido => 'Preferred day';

  @override
  String get asignaAlMenosColumnaPiloto =>
      'Assign at least the driver name column.';

  @override
  String get asignaAlMenosColumnaEquipo =>
      'Assign at least the team name column.';

  @override
  String get importarPilotosDesdeSheets => 'Import drivers from Sheets';

  @override
  String get importacionPilotosAviso =>
      'From now on, press \"Update from Drive\" in Drivers to bring in changes without setting anything up again.';

  @override
  String get detectadasAutomaticamente =>
      'Detected automatically. Change them if needed.';

  @override
  String diagLeidas(
    Object columnas,
    Object filas,
    Object piloto,
    Object primera,
  ) {
    return 'Read $filas rows · $columnas columns detected · driver=$piloto\n1st row: $primera';
  }

  @override
  String get diagNinguna => '(none)';

  @override
  String get sinCampeonatoActivoAviso => 'No active championship';

  @override
  String get sinPruebaAsignadaVinculo => 'No event assigned to the link';

  @override
  String resumenPilotosActualizados(Object nuevos, Object saltados, Object ya) {
    return 'New: $nuevos · Entered in the championship: $ya · Skipped: $saltados';
  }

  @override
  String resumenEquiposActualizados(Object nuevos, Object saltados) {
    return 'New teams: $nuevos · Skipped: $saltados';
  }

  @override
  String resumenCatalogoActualizado(
    Object actualizados,
    Object nuevos,
    Object saltados,
  ) {
    return 'New: $nuevos · Updated: $actualizados · Unchanged: $saltados';
  }

  @override
  String resumenFotos(Object n) {
    return ' · Photos: $n';
  }

  @override
  String resumenFotosFallan(Object detalle, Object n) {
    return ' ($n failed: $detalle)';
  }

  @override
  String resumenInscripcionesActualizadas(
    Object nuevos,
    Object sin,
    Object ya,
  ) {
    return 'New entries: $nuevos · Already entered: $ya · Unrecognised: $sin';
  }

  @override
  String resumenNoReconocidos(Object detalle) {
    return ' ($detalle)';
  }

  @override
  String get noEncuentroCabecera => 'I cannot find the header in the sheet.';

  @override
  String get faltanColumnasClaveMapeo =>
      'Key columns are missing from the sheet mapping. Check the link (Import) so the columns match up.';

  @override
  String get fotoNuevaSeSube =>
      '(new photo: uploaded to Drive and replaces the link)';

  @override
  String get seSubeFotoADrive => '(the photo is uploaded to Drive)';

  @override
  String copiaSubida(Object fotos, Object kb) {
    return 'Backup uploaded ($kb KB · $fotos photos).';
  }

  @override
  String get noHayCopiaEnDrive => 'There is no backup on Drive.';

  @override
  String get zipSinBaseDeDatos =>
      'The backup ZIP does not contain the database.';

  @override
  String get configuracionRestaurada => ' · Configuration restored';

  @override
  String get reconectaConGoogle => ' — reconnect to Google when you reopen';

  @override
  String copiaConFotos(Object n) {
    return ' · $n photos';
  }

  @override
  String copiaRestaurada(Object detalle) {
    return 'Backup restored ($detalle). Close and reopen the app for the changes to take effect.';
  }

  @override
  String get descripcionCopiaDrive =>
      'PitWall backup (database + inspection photos).';

  @override
  String get authFaltanCredenciales =>
      'The Google Cloud project credentials are missing. Go to Settings → Google and paste the Client ID and Client Secret.';

  @override
  String get authNoSePudoAbrirNavegador =>
      'The browser could not be opened to authorise.';

  @override
  String get authConfiguraCredenciales =>
      'Set up the Google Cloud credentials first.';

  @override
  String get authNoConectado => 'You are not connected to Google.';

  @override
  String get authSesionCaducada =>
      'Your Google session has expired. Connect your account again in Google Sheets (side menu).';

  @override
  String get authConexionRevocada =>
      'The Google connection has expired or was revoked. Go to Google Sheets (side menu) and press \"Connect with Google\" to authorise again.';

  @override
  String get sinTitulo => 'Untitled';

  @override
  String get sinNombre => 'Unnamed';

  @override
  String get fotoNoLegible => 'the file is not a readable JPG/PNG/WEBP image';

  @override
  String fotoLocalNoEncontrada(Object ruta) {
    return 'the local photo $ruta was not found';
  }

  @override
  String get versionInstalada => 'Installed version';

  @override
  String get buscarActualizaciones => 'Check for updates';

  @override
  String get estasAlDia => 'You are up to date';

  @override
  String get noSePudoComprobarSinConexion => 'Could not check (offline?)';

  @override
  String get conexionFallida => 'Could not connect';

  @override
  String get accionSubir => 'Upload';

  @override
  String errorFilaDetalle(String hoja, int fila, String detalle) {
    return '$hoja row $fila: $detalle';
  }

  @override
  String get diaLunes => 'Monday';

  @override
  String get diaMartes => 'Tuesday';

  @override
  String get diaMiercoles => 'Wednesday';

  @override
  String get diaJueves => 'Thursday';

  @override
  String get diaViernes => 'Friday';

  @override
  String get diaSabado => 'Saturday';

  @override
  String get diaDomingo => 'Sunday';

  @override
  String get diaQueCorre => 'Race day';

  @override
  String get sinPreferenciaDeDia => '— no preference —';

  @override
  String get cambiarDiaQueCorre => 'Change race day';
}
