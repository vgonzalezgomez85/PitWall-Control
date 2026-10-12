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

  @override
  String get nuevaPrueba => 'Nova prova';

  @override
  String get seleccionaCampeonato => 'Selecciona primer un campionat';

  @override
  String get aunNoHayPruebas => 'Encara no hi ha proves';

  @override
  String get aunNoHayPruebasTexto =>
      'Crea la primera prova del campionat (per exemple \"EL SOT\", \"SLOTMANIA\"…).';

  @override
  String get estadoProgramada => 'Programada';

  @override
  String get estadoEnCurso => 'En curs';

  @override
  String get estadoTerminada => 'Acabada';

  @override
  String get estadoCancelada => 'Cancel·lada';

  @override
  String get resumenVerificaciones => 'Resum de verificacions';

  @override
  String get aunNoHayTandas => 'Encara no hi ha tandes';

  @override
  String get verificarSinTandasTexto =>
      'Inscriu equips i crea les tandes a la pestanya Preparar.';

  @override
  String validadasDe(int validadas, int total) {
    return '$validadas / $total validades';
  }

  @override
  String get sinEquiposEnTanda => 'Sense equips en aquesta tanda.';

  @override
  String get carreraTienePole => 'La cursa té pole?';

  @override
  String get carreraTienePoleTexto =>
      'Amb pole no s\'exporta l\'ordre de carril: PitWall crea la sessió de pole i la graella s\'assigna després de córrer-la.';

  @override
  String get sinPole => 'Sense pole';

  @override
  String get conPole => 'Amb pole';

  @override
  String get noHayInscritosExportar => 'No hi ha inscrits per exportar.';

  @override
  String get noHayTandasConCarriles =>
      'No hi ha tandes amb carrils assignats per exportar.';

  @override
  String get importarDelCronometraje => 'Importar del cronometratge';

  @override
  String get traerResultadosPitwall => 'Portar resultats de PitWall';

  @override
  String get prueba => 'Prova';

  @override
  String get editar => 'Editar';

  @override
  String get pestanaPreparar => 'Preparar';

  @override
  String get pestanaVerificar => 'Verificar';

  @override
  String get pestanaResultados => 'Resultats';

  @override
  String get pestanaCaja => 'Caixa';

  @override
  String get nuevaTanda => 'Nova tanda';

  @override
  String get compartir => 'Compartir';

  @override
  String get pdfTandas => 'PDF de tandes';

  @override
  String get pdfVerificaciones => 'PDF de verificacions';

  @override
  String get enviarTandasPitwall => 'Enviar tandes a PitWall';

  @override
  String get porWifiSinArchivo => 'Per wifi, sense fitxer';

  @override
  String get enviarVerificacionesPitwall => 'Enviar verificacions a PitWall';

  @override
  String get soloConsultaManager => 'Només consulta a Manager';

  @override
  String get archivoParaPitwall => 'Fitxer per a PitWall (JSON)';

  @override
  String get paraImportarAManoManager => 'Per importar-lo a mà a Manager';

  @override
  String get noEncontrada => 'No trobada';

  @override
  String get editarTandas => 'Editar tandes';

  @override
  String get sorteoMotores => 'Sorteig de motors';

  @override
  String get tandas => 'Tandes';

  @override
  String get crearTandasTexto =>
      'Crea les tandes que tindrà aquesta prova (Dijous 21:00, Divendres 21:00…).';

  @override
  String pruebaNumero(int orden) {
    return 'Prova #$orden';
  }

  @override
  String nCarriles(int n) {
    return '$n carrils';
  }

  @override
  String noSePudoGuardar(String detalle) {
    return 'No s\'ha pogut desar: $detalle';
  }

  @override
  String get eliminarPrueba => 'Eliminar prova';

  @override
  String eliminarPruebaTexto(String nombre) {
    return 'Vols eliminar \"$nombre\"?\n\nTambé s\'esborraran les seves tandes, inscripcions, resultats i verificacions. Aquesta acció no es pot desfer.';
  }

  @override
  String get eliminar => 'Eliminar';

  @override
  String get editarPrueba => 'Editar prova';

  @override
  String get nombrePruebaObligatorio => 'Nom de la prova *';

  @override
  String get nombrePruebaAyuda => 'Ex.: EL SOT, SLOTMANIA, GASCLAVAT…';

  @override
  String get indicaElNombre => 'Indica el nom';

  @override
  String get sedeClub => 'Seu / club';

  @override
  String get sinFechaAsignada => 'Sense data assignada';

  @override
  String get quitarFecha => 'Treure la data';

  @override
  String get elegir => 'Triar';

  @override
  String get cambiar => 'Canviar';

  @override
  String get ordenCampeonato => 'Ordre al campionat';

  @override
  String get ordenCampeonatoAyuda => 'Posició al calendari (1, 2, 3…)';

  @override
  String get numeroEntero => 'Nombre enter';

  @override
  String get estado => 'Estat';

  @override
  String get crearPrueba => 'Crear prova';

  @override
  String get guardarCambios => 'Desar els canvis';

  @override
  String get eliminarTanda => 'Eliminar tanda';

  @override
  String eliminarTandaTexto(String nombre) {
    return 'Vols eliminar la tanda \"$nombre\"? També s\'esborraran les inscripcions, els resultats i les verificacions de la tanda.';
  }

  @override
  String get editarTanda => 'Editar tanda';

  @override
  String get nombreTandaObligatorio => 'Nom de la tanda *';

  @override
  String get nombreTandaAyuda => 'Ex.: Dijous 21:00, Divendres 23:00…';

  @override
  String get sinFechaHora => 'Sense data ni hora assignades';

  @override
  String get quitar => 'Treure';

  @override
  String get numeroCarriles => 'Nombre de carrils';

  @override
  String get numeroCarrilesAyuda => 'Habitualment 6, 7 o 8 (fins a 32)';

  @override
  String get numeroCarrilesError => 'Indica un nombre entre 1 i 32';

  @override
  String get pisters => 'Pisters';

  @override
  String get pistersAyuda =>
      'Tanda els pilots de la qual fan de pisters en aquesta';

  @override
  String get sinPisters => '— sense pisters —';

  @override
  String pilotosDe(String nombre) {
    return 'Pilots de $nombre';
  }

  @override
  String get crearTanda => 'Crear tanda';

  @override
  String get pruebaSinTandas => 'Aquesta prova encara no té tandes';

  @override
  String get generaTandasDesdeInscritos =>
      'Genera-les des d\'Inscrits → Generar tandes.';

  @override
  String get tocaEquipoParaMover =>
      'Toca un equip per moure\'l a una altra tanda.';

  @override
  String nEquiposAbrev(int n) {
    return '$n eq.';
  }

  @override
  String get sinEquipos => 'Sense equips';

  @override
  String moverEquipoA(String nombre) {
    return 'Moure \"$nombre\" a…';
  }

  @override
  String tandaConEquipos(String nombre, int n) {
    return '$nombre  ($n eq.)';
  }

  @override
  String get darDeBajaPrueba => 'Donar de baixa de la prova';

  @override
  String get eligePitwall => 'Tria un PitWall o escriu-ne l\'adreça.';

  @override
  String get noHayInscritosEnviar => 'No hi ha inscrits per enviar.';

  @override
  String get noHayTandasEnviar =>
      'No hi ha tandes amb carrils assignats per enviar.';

  @override
  String get enviarAPitwall => 'Enviar a PitWall';

  @override
  String get pinImportacion => 'PIN d\'importació';

  @override
  String get pinImportacionAyuda =>
      'El PIN que mostra PitWall a «Importar tanda».';

  @override
  String get carreraTienePoleSi => 'La cursa té pole';

  @override
  String get carreraTienePoleAyuda =>
      'No s\'envia l\'ordre de carril: la graella s\'assigna a PitWall després de la pole';

  @override
  String get enviar => 'Enviar';

  @override
  String get pitwallEnLaRed => 'PitWall a la xarxa';

  @override
  String get buscarDeNuevo => 'Tornar a cercar';

  @override
  String get buscandoPitwall => 'Cercant PitWall a la xarxa local…';

  @override
  String get noSeEncuentraPitwall =>
      'No s\'ha trobat cap PitWall. Comprova que està obert i a la mateixa xarxa Wi‑Fi, o escriu-ne l\'adreça a sota.';

  @override
  String get direccionIpPuerto => 'Adreça (IP:port)';

  @override
  String get resultadosDeLaTanda => 'Resultats de la tanda';

  @override
  String get noHayEquiposEnTanda => 'No hi ha equips en aquesta tanda';

  @override
  String get inscribeEquiposParaResultados =>
      'Inscriu equips per poder registrar-ne els resultats.';

  @override
  String get indicaPosicionFinalTexto =>
      'Indica la posició final de cada equip. Els punts es calculen sols segons la taula del campionat.';

  @override
  String get puntos => 'punts';

  @override
  String get posicion => 'Posició';

  @override
  String get sinAsignar => 'Sense assignar';

  @override
  String get aRestar => 'A restar';

  @override
  String get creditosMin => 'crèdits';

  @override
  String get noHayInscritosEnPrueba => 'No hi ha inscrits en aquesta prova';

  @override
  String get inscribeEquiposGeneraTandas =>
      'Inscriu equips i genera les tandes. Després podràs importar aquí els resultats del cronometratge.';

  @override
  String equiposConResultado(int con, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total equips',
      one: '1 equip',
    );
    return '$con de $_temp0 amb resultat registrat.';
  }

  @override
  String get resultadosDeLaPrueba => 'Resultats de la prova';

  @override
  String get importarDesdeArchivoCronometraje =>
      'Importar des d\'un fitxer de cronometratge';

  @override
  String copaYManga(String copa, String manga) {
    return 'Copa $copa  ·  $manga';
  }

  @override
  String get posAbrev => 'Pos.';

  @override
  String get archivos => 'Fitxers';

  @override
  String get noSeEncontraronResultados =>
      'No s\'han trobat resultats. El fitxer ha de tenir columnes com «Posició» i «Nom» (format TicTacSlot o similar).';

  @override
  String noSePudoLeerArchivo(String detalle) {
    return 'No s\'ha pogut llegir el fitxer: $detalle';
  }

  @override
  String get importacionCompletada => 'Importació completada';

  @override
  String resumenImportacionResultados(int ok, int inscritos, int saltados) {
    return '✓ Resultats aplicats: $ok\n+ Inscrits automàticament: $inscritos\n✗ Saltats: $saltados';
  }

  @override
  String get ok => 'OK';

  @override
  String get importarResultadosPrueba => 'Importar resultats de la prova';

  @override
  String get paso1EligeArchivo => '1. Tria el fitxer';

  @override
  String get importaArchivoTexto =>
      'Importa el fitxer del sistema de cronometratge (TicTacSlot, SloTime…). Cada equip del fitxer s\'assigna a la tanda d\'aquesta prova on estigui inscrit.';

  @override
  String get elegirArchivo => 'Triar fitxer';

  @override
  String get resultadosGenerales => 'Resultats generals';

  @override
  String get crearTandaResultadosGenerales =>
      'Crear tanda «Resultats generals»';

  @override
  String get pruebaSinTandasAviso =>
      'La prova encara no té tandes. Marquem els resultats en una tanda creada al vol.';

  @override
  String get paso2VistaPrevia => '2. Vista prèvia';

  @override
  String nDeTotalSeAplicaran(int n, int total) {
    return '$n de $total s\'aplicaran';
  }

  @override
  String equiposNoExistenAviso(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '⚠️ $n equips del fitxer no existeixen al campionat.',
      one: '⚠️ 1 equip del fitxer no existeix al campionat.',
    );
    return '$_temp0';
  }

  @override
  String aplicarResultadosA(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n equips',
      one: '1 equip',
    );
    return 'Aplicar resultats a $_temp0';
  }

  @override
  String get noExiste => 'No existeix';

  @override
  String get seInscribira => 'S\'inscriurà';

  @override
  String get aplicar => 'Aplicar';

  @override
  String copaTexto(String copa) {
    return 'Copa $copa';
  }

  @override
  String nVueltas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n voltes',
      one: '1 volta',
    );
    return '$_temp0';
  }

  @override
  String formatoNoSoportado(String ext) {
    return 'Format no suportat: $ext';
  }

  @override
  String get sortearRestantes => 'Sortejar restants';

  @override
  String get pruebaNoEncontrada => 'Prova no trobada';

  @override
  String get noHayEquiposInscritosTandas =>
      'No hi ha equips inscrits a les tandes d\'aquesta prova.';

  @override
  String sorteoBloqueadoTexto(String motivo) {
    return '$motivo El sorteig queda en només lectura.';
  }

  @override
  String get equipos => 'Equips';

  @override
  String get numeros => 'Números';

  @override
  String get noQuedanMotores => 'No queden motors disponibles.';

  @override
  String get motorSorteado => 'Motor sortejat';

  @override
  String get repetir => 'Repetir';

  @override
  String get asignar => 'Assignar';

  @override
  String faltanMotores(int equipos, int motores) {
    return 'Falten motors: $equipos equips i només $motores motors disponibles.';
  }

  @override
  String motoresRango(int min, int max) {
    return 'Motors $min–$max';
  }

  @override
  String asignadosDe(int asignados, int total) {
    return '$asignados/$total assignats';
  }

  @override
  String disponiblesN(int n) {
    return '$n disponibles';
  }

  @override
  String get sortear => 'Sortejar';

  @override
  String numeroMotor(int n) {
    return 'Nº $n';
  }

  @override
  String get volverASortear => 'Tornar a sortejar';

  @override
  String get quitarMotor => 'Treure motor';

  @override
  String get faltaRangoMotores => 'Falta configurar el rang de motors';

  @override
  String get faltaRangoMotoresTexto =>
      'Defineix el rang de números de motor d\'organització al campionat per poder-los sortejar.';

  @override
  String get configurarCampeonato => 'Configurar campionat';

  @override
  String get rangoMotoresNoConfigurado => 'Rang de motors no configurat.';

  @override
  String get asignado => 'Assignat';

  @override
  String get disponible => 'Disponible';

  @override
  String get tanda => 'Tanda';

  @override
  String get verificaciones => 'Verificacions';

  @override
  String get renumerarCarriles => 'Renumerar carrils';

  @override
  String get renumerar => 'Renumerar';

  @override
  String renumerarCarrilesTexto(String nombre, int carriles) {
    return 'Es tornen a assignar tots els carrils de \"$nombre\" per punts, de més a menys: 1 a $carriles i, si hi ha més pilots, D1, D2… Es perden els canvis fets a mà.';
  }

  @override
  String get inscribirEquipo => 'Inscriure equip';

  @override
  String get aunNoHayEquiposInscritos => 'Encara no hi ha equips inscrits';

  @override
  String get pulsaInscribirEquipo =>
      'Prem \"Inscriure equip\" per afegir-los d\'un en un assignant carril de sortida.';

  @override
  String sinCarrilN(int n) {
    return 'Sense carril ($n)';
  }

  @override
  String get actual => 'actual';

  @override
  String get libre => 'lliure';

  @override
  String get libreTitulo => 'Lliure';

  @override
  String carrilDe(String nombre) {
    return 'Carril de $nombre';
  }

  @override
  String get tocaCarrilLibreTexto =>
      'Toca un carril lliure per moure-l\'hi, o un d\'ocupat per intercanviar-los.';

  @override
  String get pista => 'Pista';

  @override
  String get descanso => 'Descans';

  @override
  String get seedDirecto => 'Seed directe';

  @override
  String get sinCarril => 'Sense carril';

  @override
  String get escribirAMano => 'Escriure a mà…';

  @override
  String get carrilDeSalida => 'Carril de sortida';

  @override
  String get carrilEjemplo => 'Ex.: D1, D2, 1, 2, 3…';

  @override
  String get carrilAyuda => 'D1-D4 per a seeds directes, 1-N per a sorteig';

  @override
  String get guardar => 'Desa';

  @override
  String quienSaleEnCarril(String carril) {
    return 'Qui surt al carril $carril?';
  }

  @override
  String dejaLibreEl(String carril) {
    return 'Deixa lliure el $carril';
  }

  @override
  String get carrilesRepetidos => 'Carrils repetits';

  @override
  String pistersPilotosDe(String tanda) {
    return 'Pisters: pilots de $tanda';
  }

  @override
  String get cambiarCarril => 'Canviar carril';

  @override
  String get quitarSeedDirecto => 'Treure seed directe';

  @override
  String get marcarSeedDirecto => 'Marcar com a seed directe';

  @override
  String get quitarDeLaTanda => 'Treure de la tanda';

  @override
  String get quitarInscripcion => 'Treure inscripció';

  @override
  String quitarInscripcionTexto(String nombre) {
    return 'Treure \"$nombre\" d\'aquesta tanda?';
  }

  @override
  String inscribirEquipoEn(String nombre) {
    return 'Inscriure equip a \"$nombre\"';
  }

  @override
  String get buscarEquipoOPiloto => 'Cercar equip o pilot…';

  @override
  String get noHayEquiposEnCampeonatoCrealos =>
      'No hi ha equips en aquest campionat. Crea\'ls primer.';

  @override
  String get todosLosEquiposYaInscritos => 'Tots els equips ja estan inscrits.';

  @override
  String get inscribir => 'Inscriure';

  @override
  String get carrilEjemploCorto => 'Ex.: D1, 3…';

  @override
  String get carrilAyudaVacio => 'Deixa-ho buit si encara no assignes carril';

  @override
  String get inscritosALaPrueba => 'Inscrits a la prova';

  @override
  String get actualizarDesdeDrive => 'Actualitzar des de Drive';

  @override
  String get actualizandoDesdeDrive => 'Actualitzant des de Drive…';

  @override
  String get anadirPiloto => 'Afegir pilot';

  @override
  String get anadirEquipo => 'Afegir equip';

  @override
  String get importar => 'Importar';

  @override
  String get vincularGoogleSheet => 'Vincular Google Sheet';

  @override
  String get desdeArchivoCsvExcel => 'Des d\'un fitxer CSV / Excel';

  @override
  String get generarTandas => 'Generar tandes';

  @override
  String get aunNoHayPilotosInscritosPrueba =>
      'Encara no hi ha pilots inscrits a aquesta prova';

  @override
  String get aunNoHayEquiposInscritosPrueba =>
      'Encara no hi ha equips inscrits a aquesta prova';

  @override
  String get importaCsvGoogleFormPilotos =>
      'Importa el CSV/Excel del Google Form o afegeix pilots a mà.';

  @override
  String get importaCsvGoogleFormEquipos =>
      'Importa el CSV/Excel del Google Form o afegeix equips a mà.';

  @override
  String get importarCsvExcel => 'Importar CSV/Excel';

  @override
  String get anadirAMano => 'Afegir a mà';

  @override
  String pilotosInscritosGenerarTandas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '$n pilots inscrits. Quan els tinguis tots, prem \"Generar tandes\".',
      one: '1 pilot inscrit. Quan els tinguis tots, prem \"Generar tandes\".',
    );
    return '$_temp0';
  }

  @override
  String equiposInscritosGenerarTandas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '$n equips inscrits. Quan els tinguis tots, prem \"Generar tandes\".',
      one: '1 equip inscrit. Quan els tinguis tots, prem \"Generar tandes\".',
    );
    return '$_temp0';
  }

  @override
  String get darDeBaja => 'Donar de baixa';

  @override
  String darDeBajaTexto(String nombre) {
    return 'Donar de baixa \"$nombre\"?\n\nEs treu d\'Inscrits i de la seva tanda. Els carrils de la resta no canvien: si cal, renumera la tanda després.';
  }

  @override
  String get inscribirPilotos => 'Inscriure pilots';

  @override
  String get inscribirEquipos => 'Inscriure equips';

  @override
  String nSeleccionados(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n seleccionats',
      one: '1 seleccionat',
    );
    return '$_temp0';
  }

  @override
  String get limpiar => 'Netejar';

  @override
  String get buscarPiloto => 'Cercar pilot…';

  @override
  String get noHayPilotosEnCampeonato => 'No hi ha pilots en aquest campionat.';

  @override
  String get noHayEquiposEnCampeonato => 'No hi ha equips en aquest campionat.';

  @override
  String get todosYaInscritos => 'Tots ja estan inscrits.';

  @override
  String get nuevaInscripcion => 'Nova inscripció';

  @override
  String get nuevoEquipo => 'Nou equip';

  @override
  String get copaParaPilotosNuevos => 'Copa per a pilots nous:';

  @override
  String get desmarcarTodos => 'Desmarcar tots';

  @override
  String marcarTodosN(int n) {
    return 'Marcar tots ($n)';
  }

  @override
  String nuevaInscripcionCopa(String copa) {
    return 'Nova inscripció · Copa $copa';
  }

  @override
  String get marcaPilotosInscribir => 'Marca els pilots que vulguis inscriure';

  @override
  String get marcaEquiposInscribir => 'Marca els equips que vulguis inscriure';

  @override
  String inscribirNPilotos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pilots',
      one: '1 pilot',
    );
    return 'Inscriure $_temp0';
  }

  @override
  String inscribirNEquipos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n equips',
      one: '1 equip',
    );
    return 'Inscriure $_temp0';
  }

  @override
  String get importarInscripciones => 'Importar inscripcions';

  @override
  String get csvGoogleFormInscripcionPilotos =>
      'CSV/Excel del Google Form d\'inscripció a la prova. Les inscripcions es vinculen a pilots existents pel nom.';

  @override
  String get csvGoogleFormInscripcionEquipos =>
      'CSV/Excel del Google Form d\'inscripció a la prova. Les inscripcions es vinculen a equips existents pel nom.';

  @override
  String get paso2AsignaColumnas => '2. Assigna columnes';

  @override
  String get nombreDelPilotoObligatorio => 'Nom del pilot *';

  @override
  String get nombreDelEquipoObligatorio => 'Nom de l\'equip *';

  @override
  String get diaPreferidoOpcional => 'Dia preferit (opcional)';

  @override
  String get notasOpcional => 'Notes (opcional)';

  @override
  String get paso3VistaPrevia => '3. Vista prèvia';

  @override
  String nDeTotalSeImportaran(int n, int total) {
    return '$n de $total s\'importaran';
  }

  @override
  String pilotosNoExistenAviso(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '⚠️ $n pilots no existeixen al campionat. Crea\'ls primer o revisa el nom.',
      one:
          '⚠️ 1 pilot no existeix al campionat. Crea\'l primer o revisa el nom.',
    );
    return '$_temp0';
  }

  @override
  String equiposNoExistenAvisoImport(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '⚠️ $n equips no existeixen al campionat. Crea\'ls primer o revisa el nom.',
      one:
          '⚠️ 1 equip no existeix al campionat. Crea\'l primer o revisa el nom.',
    );
    return '$_temp0';
  }

  @override
  String get asignaColumnaPiloto => 'Assigna la columna del nom del pilot.';

  @override
  String get asignaColumnaEquipo => 'Assigna la columna del nom de l\'equip.';

  @override
  String get ninguna => '— cap —';

  @override
  String get yaInscrito => 'Ja inscrit';

  @override
  String diaTexto(String dia) {
    return 'Dia: $dia';
  }

  @override
  String noSePudoLeer(String detalle) {
    return 'No s\'ha pogut llegir: $detalle';
  }

  @override
  String resumenImportacionInscripciones(int ok, int saltados) {
    return '✓ Inscrits: $ok\n✗ Saltats: $saltados';
  }

  @override
  String tandaNumero(int n) {
    return 'Tanda $n';
  }

  @override
  String get tandasCreadas => 'Tandes creades';

  @override
  String tandasCreadasTexto(int n, int equipos) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'S\'han creat $n tandes amb $equipos equips.',
      one: 'S\'ha creat 1 tanda amb $equipos equips.',
    );
    return '$_temp0';
  }

  @override
  String get conCarrilAsignado => 'Amb carril de sortida assignat.';

  @override
  String get carrilesSeAsignaranAntes =>
      'Els carrils s\'assignaran abans de la cursa.';

  @override
  String get pistersAsignadosEntreTandas =>
      'Pisters assignats entre les tandes de cada dia.';

  @override
  String equiposInscritosARepartir(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n equips inscrits a repartir',
      one: '1 equip inscrit a repartir',
    );
    return '$_temp0';
  }

  @override
  String get ordenadosPorPuntos => 'Ordenats per punts bruts acumulats.';

  @override
  String get sinPuntosEsteAnio =>
      'Sense punts aquest any → ordenats pel saldo de l\'any anterior (0 si no n\'hi ha).';

  @override
  String get paso1CarrilesPista => '1. Carrils de la pista';

  @override
  String get paso1CarrilesTexto =>
      'Quants cotxes corren alhora. Marca el màxim d\'equips per tanda per repartir-los bé.';

  @override
  String get carrilesMin => 'carrils';

  @override
  String get minutosPorCarrilTexto =>
      'Minuts per carril (quant dura el torn d\'un equip a cada carril, per calcular la durada de la tanda).';

  @override
  String get minPorCarril => 'min/carril';

  @override
  String cadaTandaDurara(int minutos, int carriles, int minPorCarril) {
    return 'Cada tanda durarà ~$minutos min ($carriles carrils × $minPorCarril min).';
  }

  @override
  String get paso2NumeroTandas => '2. Nombre de tandes';

  @override
  String sugeridoTexto(int n, int carriles) {
    return 'Suggerit: $n (sense carrils buits amb $carriles carrils: si sobren equips, les tandes passen de $carriles). Pots canviar-ho.';
  }

  @override
  String get paso3NombresHorarios => '3. Noms i horaris';

  @override
  String get asignarCarrilAutomatico => 'Assignar carril automàticament';

  @override
  String asignarCarrilTexto(int carriles) {
    return 'Per punts, de més a menys: carrils 1 a $carriles i, si hi ha més pilots, D1, D2…';
  }

  @override
  String get asignarPisters => 'Assignar pisters';

  @override
  String get asignarPistersTexto =>
      'Entre les tandes del mateix dia. 2 tandes: 1a↔2a. 3: la 3a fa de pisters a la 1a, la 1a a la 2a i la 2a a la 3a. 4: 1a↔2a i 3a↔4a.';

  @override
  String get paso4VistaPrevia => '4. Vista prèvia';

  @override
  String get numeroIzquierdaCarril =>
      'El número de l\'esquerra és el carril de sortida.';

  @override
  String get carrilesLosAsignarasDespues =>
      'Els carrils els assignaràs després, abans de la cursa.';

  @override
  String sinTandaN(int n) {
    return 'Sense tanda ($n)';
  }

  @override
  String get sinTandaTexto =>
      'Aquests equips prefereixen un dia que no té cap tanda en aquest repartiment. Afegeix una tanda d\'aquest dia a dalt o canvia\'n la preferència.';

  @override
  String prefiereDia(String dia) {
    return 'Prefereix: $dia';
  }

  @override
  String get sustituirTandasExistentes => 'Substituir les tandes existents';

  @override
  String get sustituirTandasTexto =>
      'Si aquesta prova ja tenia tandes, s\'eliminen i es reemplacen.';

  @override
  String get crearEstasTandas => 'Crear aquestes tandes';

  @override
  String get eligeLaCarrera => 'Tria la cursa';

  @override
  String get verCarreras => 'Veure curses';

  @override
  String resultadosDeCarrera(String nombre) {
    return 'Resultats: $nombre';
  }

  @override
  String noSePudoConectar(String detalle) {
    return 'No s\'ha pogut connectar: $detalle';
  }

  @override
  String noSePudieronTraerResultados(String detalle) {
    return 'No s\'han pogut portar els resultats: $detalle';
  }

  @override
  String get noHayCampeonatoActivo => 'No hi ha cap campionat actiu.';

  @override
  String resultadosAplicadosSaltados(int ok, int saltados) {
    return 'Resultats aplicats: $ok · saltats: $saltados';
  }

  @override
  String errorAlAplicar(String detalle) {
    return 'Error en aplicar: $detalle';
  }

  @override
  String get pitwallNoTieneCarreras => 'PitWall no té curses.';

  @override
  String get pitwallNoTieneCarrerasEnvia =>
      'PitWall no té curses. Envia abans una tanda («Enviar a PitWall») o crea la cursa al Manager.';

  @override
  String tandasDeCarrera(int n) {
    return '$n tanda(es)';
  }

  @override
  String get laCarreraNoTieneResultados => 'La cursa encara no té resultats.';

  @override
  String get equipoNoEncontradoCampeonato => 'Equip no trobat al campionat';

  @override
  String get noInscritoEnEstaPrueba => 'No inscrit en aquesta prova';

  @override
  String seAplicaraPosicion(int posicion) {
    return 's\'aplicarà la posició $posicion';
  }

  @override
  String aplicarN(int n) {
    return 'Aplicar ($n)';
  }

  @override
  String tandaAbrev(int n) {
    return 'T$n';
  }

  @override
  String get seEnvianComoConsulta =>
      'S\'envien a mode de consulta: a PitWall es podran veure però no editar.';

  @override
  String get atras => 'Enrere';

  @override
  String get noHayVerificacionesEnviar =>
      'No hi ha verificacions per enviar en aquesta prova.';

  @override
  String copaDosPuntos(String copa) {
    return 'Copa: $copa';
  }

  @override
  String get aunNoHayEquiposEnEstaTanda =>
      'Encara no hi ha equips en aquesta tanda';

  @override
  String get inscribeEquiposVerificacion =>
      'Inscriu equips a la tanda per poder-los fer la verificació.';

  @override
  String nConVerificacion(int n) {
    return '$n amb verificació';
  }

  @override
  String nValidadas(int n) {
    return '$n validades';
  }

  @override
  String get quitarParticipante => 'Treure participant';

  @override
  String quitarConVerificacionTexto(String nombre) {
    return 'Es traurà \"$nombre\" i s\'esborrarà la seva verificació. Continuar?';
  }

  @override
  String quitarSinVerificacionTexto(String nombre) {
    return 'Es traurà \"$nombre\". Continuar?';
  }

  @override
  String get validada => 'Validada';

  @override
  String get borrador => 'Esborrany';

  @override
  String get enRevision => 'En revisió';

  @override
  String get pendiente => 'Pendent';

  @override
  String get sinCocheAsignado => 'Sense cotxe assignat';

  @override
  String get sesionCerrada => 'La sessió està tancada.';

  @override
  String get campeonatoFinalizado => 'El campionat està finalitzat.';

  @override
  String get pruebaTerminada => 'La prova està acabada.';

  @override
  String get exportar => 'Exportar';

  @override
  String get exportarPdf => 'Exportar a PDF';

  @override
  String get exportarExcel => 'Exportar a Excel';

  @override
  String get noHayPruebasEnCampeonato => 'No hi ha proves en aquest campionat.';

  @override
  String get noHayInscritosNiVerificaciones =>
      'No hi ha inscrits ni verificacions en aquesta prova.';

  @override
  String get buscarPilotoEquipoCopa => 'Cercar pilot, equip, copa…';

  @override
  String filtroTodos(int n) {
    return 'Tots ($n)';
  }

  @override
  String filtroConInfraccion(int n) {
    return 'Amb infracció ($n)';
  }

  @override
  String filtroSinVerificar(int n) {
    return 'Sense verificar ($n)';
  }

  @override
  String filtroBorrador(int n) {
    return 'Esborrany ($n)';
  }

  @override
  String validadasDeTotal(int validadas, int total) {
    return '$validadas validades de $total';
  }

  @override
  String get nadaConEsteFiltro => 'Res a mostrar amb aquest filtre.';

  @override
  String get colPilotoEquipo => 'Pilot / equip';

  @override
  String get fueraDeReglamento => 'Fora de reglament';

  @override
  String get copa => 'Copa';

  @override
  String get coche => 'Cotxe';

  @override
  String get colPesoCarroc => 'Pes carross.';

  @override
  String get colPesoMin => 'Pes mín.';

  @override
  String get colPesoCoche => 'Pes cotxe';

  @override
  String get motor => 'Motor';

  @override
  String get alturaMotor => 'Alçada motor';

  @override
  String get colEjeDel => 'Eix davanter';

  @override
  String get colEjeTras => 'Eix posterior';

  @override
  String get pinon => 'Pinyó';

  @override
  String get corona => 'Corona';

  @override
  String get llantaDelantera => 'Llanda davantera';

  @override
  String get llantaTrasera => 'Llanda posterior';

  @override
  String get trencilla => 'Trena';

  @override
  String get suspension => 'Suspensió';

  @override
  String get bancada => 'Bancada';

  @override
  String get chasis => 'Xassís';

  @override
  String get neumatico => 'Pneumàtic';

  @override
  String get carroceria => 'Carrosseria';

  @override
  String get observaciones => 'Observacions';

  @override
  String get sinVerificar => 'Sense verificar';

  @override
  String get propio => 'Propi';

  @override
  String orgNumero(String n) {
    return 'Org. nº $n';
  }

  @override
  String get conforme => 'Conforme';

  @override
  String get noConforme => 'No conforme';

  @override
  String get toca => 'Toca';

  @override
  String get bien => 'Bé';

  @override
  String get faltanPiezas => 'Falten peces';

  @override
  String faltanPiezasDetalle(String piezas) {
    return 'Falten: $piezas';
  }

  @override
  String marcaNoPermitida(String marca) {
    return 'Marca \"$marca\" no permesa';
  }

  @override
  String superaMaximoMm(String maximo) {
    return 'Supera el màxim de $maximo mm';
  }

  @override
  String porDebajoMinimoG(String minimo) {
    return 'Per sota del mínim de $minimo g';
  }

  @override
  String get alturaMotorNoConforme => 'Alçada de motor no conforme';

  @override
  String get leFaltanPiezas => 'Li falten peces';

  @override
  String vPesoInicialBajo(String valor, String minimo) {
    return 'Pes inicial ${valor}g per sota del mínim ${minimo}g.';
  }

  @override
  String vPesoFinalBajo(String valor, String minimo) {
    return 'Pes final ${valor}g per sota del mínim ${minimo}g.';
  }

  @override
  String get vMotorSinCatalogo =>
      'Selecciona el motor del catàleg per comprovar les mesures.';

  @override
  String vMotorRpmAlto(String motor, String max, String medido) {
    return 'RPM per sobre de la referència del $motor (màx $max, mesurades $medido).';
  }

  @override
  String vMotorUmsAlto(String motor, String max, String medido) {
    return 'Imant per sobre de la referència del $motor (màx $max, mesurat $medido).';
  }

  @override
  String get vAlturaNoConforme => 'Alçada de motor no conforme: toca la pista.';

  @override
  String vEjeDelAncho(String medido, String max) {
    return 'Amplada d\'eix davanter $medido mm per sobre del màxim $max mm.';
  }

  @override
  String vEjeTraAncho(String medido, String max) {
    return 'Amplada d\'eix posterior $medido mm per sobre del màxim $max mm.';
  }

  @override
  String vMarcaNoPermitidaLista(String marca, String lista) {
    return 'Marca \"$marca\" no permesa (només $lista).';
  }

  @override
  String vMarcaFueraCatalogo(String marca) {
    return 'Marca \"$marca\" no és al catàleg.';
  }

  @override
  String vLlantaDelNoCatalogada(String valor) {
    return 'Llanda davantera no catalogada: \"$valor\".';
  }

  @override
  String vLlantaTraNoCatalogada(String valor) {
    return 'Llanda posterior no catalogada: \"$valor\".';
  }

  @override
  String vBancadaNoCatalogada(String valor) {
    return 'Bancada no catalogada: \"$valor\".';
  }

  @override
  String vNeumaticoNoCatalogado(String valor) {
    return 'Pneumàtic no catalogat: \"$valor\".';
  }

  @override
  String vBalanceNegativo(String equipo, String coche, String balance) {
    return 'Balanç de crèdits negatiu: equip $equipo + cotxe $coche = $balance.';
  }

  @override
  String get noSePudoGenerarExcel => 'No s\'ha pogut generar l\'Excel.';

  @override
  String get buscarPuntos => 'Cercar…';

  @override
  String sinResultadosPara(String filtro) {
    return 'Sense resultats per a \"$filtro\"';
  }

  @override
  String get sinAsignarGuiones => '— sense assignar —';

  @override
  String get sorteoEtiqueta => 'Sorteig';

  @override
  String get mixto => 'Mixt';

  @override
  String get limitarFabricante => 'Limitar fabricant';

  @override
  String noCatalogada(String nombre) {
    return '$nombre (no catalogada)';
  }

  @override
  String get imagenNoSePuedeLeer =>
      'No es pot llegir aquesta imatge. Fes servir un PNG o JPG.';

  @override
  String noSePudoAnadirLogo(String detalle) {
    return 'No s\'ha pogut afegir el logo: $detalle';
  }

  @override
  String get elegirLogo => 'Triar logo';

  @override
  String get cambiarLogo => 'Canviar logo';

  @override
  String get repartir => 'Repartir';

  @override
  String get configuraRangoSesion =>
      'Configura el rang de motors al reglament de la sessió per sortejar.';

  @override
  String get configuraRangoCampeonato =>
      'Configura el rang de motors al campionat per sortejar.';

  @override
  String get sorteoDeMotor => 'Sorteig de motor';

  @override
  String get otroControl => 'Un altre Control';

  @override
  String cambiadaFueraTexto(String quien) {
    return '$quien ha canviat aquesta verificació. Si continues editant, els teus canvis substituiran els seus.';
  }

  @override
  String get seguirConLoMio => 'Continuar amb el meu';

  @override
  String verLoDe(String quien) {
    return 'Veure el de $quien';
  }

  @override
  String actualizadaConCambios(String quien) {
    return 'Actualitzada amb els canvis de $quien.';
  }

  @override
  String noSePudoAnadirFoto(String detalle) {
    return 'No s\'ha pogut afegir la foto: $detalle';
  }

  @override
  String get copaEnEstaPrueba => 'Copa en aquesta prova';

  @override
  String get copaEnEstaPruebaTexto =>
      'Canvia la copa només per a aquesta prova, sense afectar l\'equip ni altres proves.';

  @override
  String get copaCategoria => 'Copa / categoria';

  @override
  String copaDelEquipo(String copa) {
    return 'Copa de l\'equip: $copa';
  }

  @override
  String get usarLaDelEquipo => 'Fer servir la de l\'equip';

  @override
  String get usarReglamentoActual => 'Fer servir el reglament actual';

  @override
  String get usarReglamentoActualTexto =>
      'Aquesta verificació es comprovarà amb els valors d\'avui del catàleg i del campionat en lloc dels que tenia en verificar-la:';

  @override
  String get recalcularanCreditos =>
      'Com que està validada, es recalcularan els seus crèdits.';

  @override
  String get usarElActual => 'Fer servir l\'actual';

  @override
  String get desbloquearVerificacion => 'Desbloquejar la verificació';

  @override
  String desbloquearTexto(String motivo) {
    return '$motivo Les seves verificacions estan bloquejades per no canviar-les sense voler.\n\nSi la desbloqueges, els canvis es desaran com sempre. Es continuarà comprovant amb el reglament amb què es va verificar.';
  }

  @override
  String get desbloquear => 'Desbloquejar';

  @override
  String get verificacion => 'Verificació';

  @override
  String get eliminarVerificacion => 'Eliminar verificació';

  @override
  String get eliminarVerificacionTexto =>
      'Es perdran les dades introduïdes. Continuar?';

  @override
  String get modeloCoche => 'Model de cotxe';

  @override
  String get elegirCoche => 'Triar cotxe';

  @override
  String noHayCochesConCopa(String copa) {
    return 'No hi ha cotxes amb la copa $copa al catàleg';
  }

  @override
  String get ayudaSelectorCoche =>
      'Es mostren el pes mínim i els crèdits del cotxe en triar-lo';

  @override
  String get creditosAbrev => 'crèd';

  @override
  String get pesoGramos => 'Pes (grams)';

  @override
  String get pesoCarroceria => 'Pes carrosseria';

  @override
  String minimoG(String n) {
    return 'Mínim: ${n}g';
  }

  @override
  String get estetica => 'Estètica';

  @override
  String get sinComprobar => 'Sense comprovar';

  @override
  String get quePiezasFaltan => 'Quines peces li falten';

  @override
  String get organizacion => 'Organització';

  @override
  String get numeroDeMotor => 'Número de motor';

  @override
  String get motorDelCatalogo => 'Motor del catàleg';

  @override
  String get elegirMotor => 'Triar motor';

  @override
  String yaNoEnCatalogo(String nombre) {
    return '$nombre (ja no és al catàleg)';
  }

  @override
  String refMotor(String rpm, String gauss) {
    return 'Ref: $rpm RPM · $gauss gauss';
  }

  @override
  String motoresHomologadosCopa(String copa) {
    return 'Motors homologats per a la copa $copa';
  }

  @override
  String rpmYGauss(String rpm, String gauss) {
    return '$rpm RPM · $gauss gauss';
  }

  @override
  String maxN(String n) {
    return 'Màx $n';
  }

  @override
  String get alturaMotorAPista => 'Alçada de motor a pista';

  @override
  String get alturaMotorTexto =>
      'Comprovació amb la planxa: si toca la pista, no conforme.';

  @override
  String get delantero => 'Davanter';

  @override
  String get trasero => 'Posterior';

  @override
  String get marca => 'Marca';

  @override
  String get dimension => 'Dimensió';

  @override
  String get dientes => 'Dents';

  @override
  String get diametro => 'Diàmetre';

  @override
  String get material => 'Material';

  @override
  String get pesoCocheEntero => 'Pes cotxe sencer (grams)';

  @override
  String get inicial => 'Inicial';

  @override
  String get cocheEntero => 'Cotxe sencer';

  @override
  String get otros => 'Altres';

  @override
  String get notasOAvisos => 'Notes o avisos';

  @override
  String get fotosHasta4 => 'Fotos (fins a 4)';

  @override
  String get marcarComoValidada => 'Marcar com a validada';

  @override
  String get marcarComoValidadaTexto =>
      'Indica que la verificació està revisada i aprovada.';

  @override
  String get autoguardadoTexto =>
      'Es desa sols com a esborrany amb cada canvi.';

  @override
  String get validar => 'Validar';

  @override
  String get noPuedesValidar =>
      'No pots validar mentre hi hagi infraccions marcades en vermell a dalt.';

  @override
  String get fotoReferenciaTexto =>
      'Foto de referència del catàleg: comprova que coincideix.';

  @override
  String get sinFotoCocheTexto =>
      'Aquest cotxe no té foto al catàleg. Afegeix-la a Catàlegs → Cotxes per poder comparar el model lliurat.';

  @override
  String get sinGuardar => 'Sense desar…';

  @override
  String get guardando => 'Desant…';

  @override
  String get guardado => 'Desat';

  @override
  String get errorCorto => 'Error';

  @override
  String soloLecturaTexto(String motivo) {
    return '$motivo Verificació en només lectura.';
  }

  @override
  String desbloqueadaTexto(String motivo) {
    return '$motivo Desbloquejada: els canvis es desen.';
  }

  @override
  String reglamentoCongelado(String fecha) {
    return 'Reglament congelat el $fecha: es comprova amb els valors de quan es va verificar.';
  }

  @override
  String get reglamentoCongeladoSinFecha =>
      'Reglament congelat: es comprova amb els valors de quan es va verificar.';

  @override
  String get haCambiadoDesdeEntonces =>
      'Ha canviat des d\'aleshores (no s\'aplica):';

  @override
  String get todoCumple => 'Tot compleix les normes. Pots validar.';

  @override
  String infraccionesN(int n) {
    return 'Infraccions: $n';
  }

  @override
  String avisosN(int n) {
    return 'Avisos: $n';
  }

  @override
  String pendienteHechosDeTotal(int hechos, int total) {
    return 'Pendent $hechos/$total';
  }

  @override
  String get hecho => 'Fet';

  @override
  String get revisar => 'Revisar';

  @override
  String bloquesCompletos(int hechos, int total) {
    return 'Blocs complets: $hechos de $total';
  }

  @override
  String faltaLista(String lista) {
    return 'Falta: $lista';
  }

  @override
  String fueraDeLaLista(String valor) {
    return '$valor (fora de la llista)';
  }

  @override
  String noCatalogado(String valor) {
    return '$valor (no catalogat)';
  }

  @override
  String conEsteCoche(String creditos) {
    return 'Amb aquest cotxe ($creditos crèd):';
  }

  @override
  String get total => 'Total';

  @override
  String nCreditos(int n) {
    return '$n crèdits';
  }

  @override
  String get sinCreditosSuficientes =>
      '⚠ No tenen crèdits suficients per cobrir el cotxe.';

  @override
  String get hacerFoto => 'Fer foto';

  @override
  String get elegirDeGaleria => 'Triar de la galeria';

  @override
  String get anadir => 'Afegir';

  @override
  String get equipoNoInscritoPrueba =>
      'L\'equip no està inscrit a la prova: inscriu-lo per poder-li cobrar.';

  @override
  String get etiquetaFinal => 'Final';

  @override
  String get anchuraEjeMm => 'Amplada d\'eix (mm)';

  @override
  String get nombreDelClub => 'Nom del club';

  @override
  String get clubEjemplo => 'Ex.: Club Slot Barcelona';

  @override
  String get limitarFabricanteTexto =>
      'A la verificació, els desplegables de marca (pinyó, corona, llandes i trencilla) només mostren les marques triades; qualsevol altra és infracció.';

  @override
  String get eligeAlMenosUnaMarca => 'Tria almenys una marca.';

  @override
  String get tipoMotorSorteoTexto =>
      'L\'organització sorteja els motors: a la verificació només s\'apunta el número de motor.';

  @override
  String get tipoMotorPropioTexto =>
      'Cada equip porta el seu motor: a la verificació es tria del catàleg i es comproven les RPM.';

  @override
  String get tipoMotorMixtoTexto =>
      'A cada verificació es marca si el motor és d\'organització o propi.';

  @override
  String get tipoMotorEligeTexto => 'Tria d\'on surten els motors.';

  @override
  String get noPagaEstaPrueba => 'no paga aquesta prova';

  @override
  String get quitarWildcard => 'Treure wildcard';

  @override
  String get quitarCoordTotal => 'Treure \"Coord. total\" (torna a pagar)';

  @override
  String get coordinadoraEnFicha =>
      'Els pilots estan marcats com a coordinadora a la seva fitxa; canvia-ho allà';

  @override
  String get marcarWildcard => 'Marcar com a wildcard (no paga)';

  @override
  String desglosePagados(String total) {
    return 'Desglossament dels €$total pagats';
  }

  @override
  String get pagat => 'Pagat';

  @override
  String get coordinadora => 'Coordinadora';

  @override
  String get club => 'Club';

  @override
  String get observacionesOpcional => 'Observacions (opcional)';

  @override
  String descuadreTexto(String suma, String total) {
    return 'Coordinadora + Club ($suma) no suma el Pagat ($total).';
  }

  @override
  String get pagoRapido => 'Pagament ràpid:';

  @override
  String get coordYPiloto => 'Coord. + pilot';

  @override
  String coordYPilotoTooltip(String monto) {
    return 'Un pilot és de coordinadora: paga la meitat de tot (€$monto)';
  }

  @override
  String get coordTotal => 'Coord. total';

  @override
  String get coordTotalTooltip =>
      'Tots els pilots són de coordinadora: no paga';

  @override
  String get observacionMitad => 'Meitat — un pilot de coordinadora';

  @override
  String get nuevaSesion => 'Nova sessió';

  @override
  String get aunNoHaySesiones => 'Encara no hi ha sessions';

  @override
  String get sesionesVaciasTexto =>
      'Verifica cotxes sense muntar un campionat: una cursa esporàdica, un control al club… Crea una sessió, afegeix participants i exporta el PDF.';

  @override
  String nParticipantes(int n) {
    return '$n participants';
  }

  @override
  String get sesionYaNoExiste => 'La sessió ja no existeix.';

  @override
  String get aunNoHayParticipantes => 'Encara no hi ha participants';

  @override
  String get pulsaAnadirParticipante =>
      'Prem \"Afegir participant\" per verificar el seu cotxe, o importa\'ls des d\'un fitxer o Google Sheets amb «Importar» de dalt.';

  @override
  String get anadirParticipante => 'Afegir participant';

  @override
  String get desdeArchivoCsvExcelParentesis => 'Des d\'un fitxer (CSV / Excel)';

  @override
  String get desdeGoogleSheets => 'Des de Google Sheets';

  @override
  String get excelConFotos => 'Excel amb fotos';

  @override
  String get reglamento => 'Reglament';

  @override
  String get eliminarSesion => 'Eliminar sessió';

  @override
  String get configuraCopasAntes =>
      'Configura abans les copes al reglament de la sessió.';

  @override
  String anadidosParticipantes(int n) {
    return 'Afegits $n participants.';
  }

  @override
  String eliminarSesionTexto(String nombre) {
    return 'S\'esborraran \"$nombre\", els seus participants i totes les seves verificacions. No es pot desfer.';
  }

  @override
  String get pilotoObligatorio => 'Pilot *';

  @override
  String get obligatorio => 'Obligatori';

  @override
  String get segundoPiloto => 'Segon pilot (opcional)';

  @override
  String get equipoOpcional => 'Equip (opcional)';

  @override
  String get equipoOpcionalAyuda =>
      'Si es deixa buit, es fa servir el nom del pilot';

  @override
  String get anadirYVerificar => 'Afegir i verificar';

  @override
  String get seleccionaUnaCopa => 'Selecciona almenys una copa / categoria.';

  @override
  String get eligeTipoMotor => 'Motor: tria si és de sorteig, propi o mixt.';

  @override
  String get limitarFabricanteError =>
      'Limitar fabricant: tria almenys una marca o desactiva-ho.';

  @override
  String get nuevaSesionVerificacion => 'Nova sessió de verificació';

  @override
  String get editarSesion => 'Editar sessió';

  @override
  String get nombreSesionObligatorio => 'Nom de la sessió *';

  @override
  String get nombreSesionAyuda =>
      'Ex.: Control club dijous, Cursa GT Sant Joan';

  @override
  String get lugarOpcional => 'Lloc (opcional)';

  @override
  String get sinFecha => 'Sense data';

  @override
  String get fechaSesion => 'Data de la sessió';

  @override
  String get clubOrganizador => 'Club organitzador';

  @override
  String get clubOrganizadorAyuda =>
      'Apareix a la capçalera dels PDF de la sessió.';

  @override
  String get copasCategorias => 'Copes / categories';

  @override
  String get copasCategoriasAyuda =>
      'Les que es poden verificar en aquesta sessió. La copa de cada participant filtra el catàleg i les comprovacions, igual que en un campionat.';

  @override
  String get anchuraEje => 'Amplada d\'eix';

  @override
  String get anchuraEjeAyuda =>
      'Amplada màxima d\'eix (mm) per copa. Deixa-ho buit si en aquesta copa no es comprova.';

  @override
  String get maxDelanteroMm => 'Màx davanter (mm)';

  @override
  String get maxTraseroMm => 'Màx posterior (mm)';

  @override
  String get fabricante => 'Fabricant';

  @override
  String get fabricanteAyuda =>
      'Per a sessions monomarca: limita les marques que es poden triar a la verificació.';

  @override
  String get rangoMotorTexto =>
      'Rang de números de motor per sortejar des de la verificació. Deixa\'l buit si no hi ha sorteig.';

  @override
  String get motorDesde => 'Motor des de';

  @override
  String get motorHasta => 'Motor fins a';

  @override
  String get indicaAmbos => 'Indica tots dos';

  @override
  String get hastaMayorQueDesde => 'Fins a ≥ des de';

  @override
  String get crearSesion => 'Crear sessió';

  @override
  String get importarParticipantesArchivo => 'Importar participants (fitxer)';

  @override
  String get importarParticipantesSheets =>
      'Importar participants (Google Sheets)';

  @override
  String errorAlImportar(String detalle) {
    return 'Error en importar: $detalle';
  }

  @override
  String pasoEligeArchivoN(int n) {
    return '$n. Tria el fitxer';
  }

  @override
  String pasoEligeLaHoja(int n) {
    return '$n. Tria el full';
  }

  @override
  String pasoEligeLaPestana(int n) {
    return '$n. Tria la pestanya';
  }

  @override
  String pasoAsignaColumnasN(int n) {
    return '$n. Assigna columnes';
  }

  @override
  String pasoVistaPreviaN(int n) {
    return '$n. Vista prèvia';
  }

  @override
  String get csvPlantillaTexto =>
      'CSV o Excel amb una fila de capçalera. Columnes reconegudes: Pilot 1 (o Pilot / Nom), Pilot 2, Equip i Copa. Hi ha una plantilla a \"Plantilles CSV\".';

  @override
  String get buscarEnTusHojas => 'Cercar als teus fulls…';

  @override
  String get buscar => 'Cercar';

  @override
  String get pestana => 'Pestanya';

  @override
  String get piloto1Obligatorio => 'Pilot 1 *';

  @override
  String get piloto2 => 'Pilot 2';

  @override
  String get copaPorDefecto => 'Copa per defecte';

  @override
  String get copaPorDefectoAyuda =>
      'Per a files sense copa o amb una copa que no és a la sessió';

  @override
  String get asignaColumnaPiloto1 => 'Assigna almenys la columna del pilot 1.';

  @override
  String get noHayFilasConPiloto => 'No hi ha files amb pilot.';

  @override
  String anadirNParticipantes(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n participants',
      one: '1 participant',
    );
    return 'Afegir $_temp0';
  }

  @override
  String get noConectadoGoogle => 'Encara no estàs connectat amb Google';

  @override
  String get conectaCuentaTexto =>
      'Connecta el teu compte una vegada per poder llegir els teus fulls de càlcul.';

  @override
  String get configurarGoogle => 'Configurar Google';

  @override
  String noSePudieronListarHojas(String detalle) {
    return 'No s\'han pogut llistar els teus fulls: $detalle';
  }

  @override
  String noSePudieronListarPestanas(String detalle) {
    return 'No s\'han pogut llistar les pestanyes: $detalle';
  }

  @override
  String noSePudoLeerPestana(String detalle) {
    return 'No s\'ha pogut llegir la pestanya: $detalle';
  }

  @override
  String get yaEstaEnLaSesion => 'Ja és a la sessió';

  @override
  String copaNoEnSesion(String copa, String defecto) {
    return 'Copa \"$copa\" no és a la sessió: es fa servir $defecto';
  }

  @override
  String get fotoCatalogo => 'Foto catàleg';
}
