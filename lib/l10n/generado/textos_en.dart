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
}
