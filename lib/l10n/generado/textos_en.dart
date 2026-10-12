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
}
