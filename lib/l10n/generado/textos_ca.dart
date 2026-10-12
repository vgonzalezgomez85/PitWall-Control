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
}
