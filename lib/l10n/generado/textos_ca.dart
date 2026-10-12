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

  @override
  String get pilotos => 'Pilots';

  @override
  String get inscripciones => 'Inscripcions';

  @override
  String get nuevoPiloto => 'Nou pilot';

  @override
  String get editarPiloto => 'Editar pilot';

  @override
  String get crearPiloto => 'Crear pilot';

  @override
  String get puntuacionPreviaImport => 'Puntuació prèvia (1a prova)';

  @override
  String get buscarPorNombre => 'Cercar per nom…';

  @override
  String get aunNoHayPilotosCampeonato =>
      'Encara no hi ha pilots en aquest campionat';

  @override
  String get noHayCoincidencias => 'No hi ha coincidències';

  @override
  String get pulsaNuevoPiloto =>
      'Prem el botó \"Nou pilot\" per afegir el primer.';

  @override
  String get quitarDelCampeonato => 'Treure del campionat';

  @override
  String quitarDelCampeonatoTexto(String piloto, String campeonato) {
    return 'Treure $piloto de \"$campeonato\"?\n\nEl pilot no s\'esborra, només es desinscriu d\'aquest campionat.';
  }

  @override
  String get motivoAjusteManual => 'Ajust manual (fitxa de pilot)';

  @override
  String get datosPersonales => 'Dades personals';

  @override
  String get nombreYApellidos => 'Nom i cognoms *';

  @override
  String get telefono => 'Telèfon';

  @override
  String get email => 'Correu electrònic';

  @override
  String get palmaresHistorico => 'Palmarès històric';

  @override
  String get palmaresEjemplo => 'Ex.: \"Top 3 lliga 2025\", \"WES 2023-2024\"';

  @override
  String get pilotoCoordinadora => 'Pilot de coordinadora';

  @override
  String get pilotoCoordinadoraTexto =>
      'Si està activat, els equips en què participi no pagaran quota.';

  @override
  String get enEsteCampeonato => 'En aquest campionat';

  @override
  String get categoria => 'Categoria';

  @override
  String get creditosIniciales => 'Crèdits inicials';

  @override
  String get sugeridoSegunCategoria => 'Suggerit segons categoria';

  @override
  String get creditosActuales => 'Crèdits actuals';

  @override
  String get palmaresLocal => 'Palmarès en aquest campionat';

  @override
  String get indicaUnNumero => 'Indica un número';

  @override
  String get tieneQueSerEntero => 'Ha de ser un número enter';

  @override
  String get noPuedeSerNegativo => 'No pot ser negatiu';

  @override
  String get importarPilotos => 'Importar pilots';

  @override
  String get soportaExcelPilotos =>
      'Admet fitxers Excel (.xlsx) i CSV. Ha de tenir almenys una columna amb el nom dels pilots.';

  @override
  String resumenImportacionPilotos(int nuevos, int inscritos, int saltados) {
    return '✓ Pilots nous: $nuevos\n✓ Inscrits en aquest campionat: $inscritos\n✗ Saltats: $saltados';
  }

  @override
  String errorImportando(String detalle) {
    return 'Error en importar: $detalle';
  }

  @override
  String get indicaColumnaNombrePiloto =>
      'Indica quina columna conté el nom del pilot.';

  @override
  String get noFilasValidas => 'No s\'han trobat files vàlides.';

  @override
  String importarNPilotos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pilots',
      one: '1 pilot',
    );
    return 'Importar $_temp0';
  }

  @override
  String get paso2AsignaLasColumnas => '2. Assigna les columnes';

  @override
  String get columnasAutodetectadas =>
      'Hem intentat detectar-les automàticament. Canvia-les si cal.';

  @override
  String get categoriaMetal => 'Categoria (metall)';

  @override
  String get palmares => 'Palmarès';

  @override
  String get nuevo => 'Nou';

  @override
  String get importarPuntuacionPrevia => 'Importar puntuació prèvia';

  @override
  String get puntuacionPreviaTexto =>
      'Excel (.xlsx) o CSV amb el nom del pilot i la seva puntuació. Només actualitza pilots que JA estan inscrits al campionat actiu (es creua per nom) — no dona d\'alta ningú nou.';

  @override
  String get puntuacionImportada => 'Puntuació importada';

  @override
  String puntuacionImportadaTexto(int ok, int saltados) {
    return '✓ Actualitzats: $ok\n✗ Saltats: $saltados\n\nAquesta puntuació només es fa servir per a \"Generar tandes\" a la primera prova; quan el campionat tingui resultats propis, la classificació real la substitueix sola.';
  }

  @override
  String get puntuacionObligatoria => 'Puntuació *';

  @override
  String nDeTotalSeActualizaran(int n, int total) {
    return '$n de $total s\'actualitzaran';
  }

  @override
  String get indicaColumnaNombreYPuntuacion =>
      'Indica quina columna és el nom i quina la puntuació.';

  @override
  String actualizarNPilotos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pilots',
      one: '1 pilot',
    );
    return 'Actualitzar $_temp0';
  }

  @override
  String get noEstaEnCampeonato => 'No és al campionat';

  @override
  String get formulaSinCalcular =>
      'Fórmula sense calcular — fes servir \"enganxat especial: valors\"';

  @override
  String get seActualizara => 'S\'actualitzarà';

  @override
  String get aunNoHayEquipos => 'Encara no hi ha equips';

  @override
  String get creaEquipoDosPilotos =>
      'Crea un equip amb dos pilots per començar.';

  @override
  String get creaInscripcionIndividual =>
      'Crea una inscripció individual per començar.';

  @override
  String get importarEquipos => 'Importar equips';

  @override
  String get seleccionaLaCopa => 'Selecciona la copa.';

  @override
  String get seleccionaUnPiloto => 'Selecciona almenys un pilot.';

  @override
  String get parejasNecesitanDosPilotos =>
      'En aquest campionat (parelles) l\'equip necessita dos pilots.';

  @override
  String get pilotosRepetidos => 'Hi ha pilots repetits a l\'equip.';

  @override
  String get eliminarInscripcion => 'Eliminar inscripció';

  @override
  String get eliminarEquipo => 'Eliminar equip';

  @override
  String eliminarInscripcionTexto(String nombre) {
    return 'Eliminar la inscripció de \"$nombre\"? Aquesta acció no es pot desfer.';
  }

  @override
  String eliminarEquipoTexto(String nombre) {
    return 'Eliminar l\'equip \"$nombre\"? Aquesta acció no es pot desfer.';
  }

  @override
  String get editarInscripcion => 'Editar inscripció';

  @override
  String get editarEquipo => 'Editar equip';

  @override
  String get primeroAnadePilotos =>
      'Primer afegeix pilots al campionat per poder crear equips.';

  @override
  String get indicaUnNombre => 'Indica un nom';

  @override
  String get copaCategoriaObligatoria => 'Copa / categoria *';

  @override
  String get piloto => 'Pilot';

  @override
  String get pilotosDelEquipo => 'Pilots de l\'equip';

  @override
  String pilotoN(int n) {
    return 'Pilot $n';
  }

  @override
  String get cocheEnVerificacionTexto =>
      'El cotxe s\'indica a la verificació de cada tanda. Un equip pot fer servir cotxes diferents en proves diferents.';

  @override
  String get crearEquipo => 'Crear equip';

  @override
  String get elegirPiloto => '— triar pilot —';

  @override
  String equipoImportTexto(String pilotos) {
    return 'Puja el CSV o Excel del Google Form de pretemporada. Cada fila ha de ser un equip amb el nom de l\'equip i $pilotos.';
  }

  @override
  String get susDosPilotos => 'els seus dos pilots';

  @override
  String get suPiloto => 'el seu pilot';

  @override
  String get asignaColumnaEquipoYPiloto =>
      'Assigna almenys la columna del nom de l\'equip i la del primer pilot.';

  @override
  String importarNEquipos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n equips',
      one: '1 equip',
    );
    return 'Importar $_temp0';
  }

  @override
  String resumenImportacionEquipos(
    int equipos,
    int pilotosNuevos,
    int pilotosInscritos,
    int saltados,
  ) {
    return '✓ Equips creats: $equipos\n✓ Pilots nous: $pilotosNuevos\n✓ Pilots inscrits al campionat: $pilotosInscritos\n✗ Saltats: $saltados';
  }

  @override
  String get columnasIntentadas =>
      'Hem intentat detectar-les. Canvia les que no estiguin bé.';

  @override
  String get yaExiste => 'Ja existeix';

  @override
  String get sinPiloto => 'Sense pilot';

  @override
  String get faltaSegundoPiloto =>
      'Falta el segon pilot (campionat per parelles)';

  @override
  String get nombreObligatorio => 'Nom *';

  @override
  String get nombreCampo => 'Nom';

  @override
  String get piloto1 => 'Pilot 1';

  @override
  String get piloto2Opcional => 'Pilot 2 (opcional)';

  @override
  String formatoNoSoportadoUsaCsv(String ext) {
    return 'Format no suportat: $ext. Fes servir .csv o .xlsx';
  }

  @override
  String get tablaDePuntos => 'Taula de punts';

  @override
  String get rellenarAMano => 'Omplir a mà';

  @override
  String get aunNoHayClasificacion => 'Encara no hi ha classificació';

  @override
  String get clasificacionVaciaTexto =>
      'Registra resultats de tanda, importa-la des d\'un fitxer o omple-la a mà.';

  @override
  String get importarClasificacion => 'Importar classificació';

  @override
  String get general => 'General';

  @override
  String noHayPilotosEn(String titulo) {
    return 'No hi ha pilots a \"$titulo\".';
  }

  @override
  String get todosLosPilotosCampeonato => 'Tots els pilots del campionat';

  @override
  String pilotosDeCopa(String copa) {
    return 'Pilots de copa $copa';
  }

  @override
  String nPilotos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pilots',
      one: '1 pilot',
    );
    return '$_temp0';
  }

  @override
  String get equipo => 'Equip';

  @override
  String get catAbrev => 'Cat.';

  @override
  String get bruto => 'Brut';

  @override
  String get descAbrev => 'Desc.';

  @override
  String get totalMayusculas => 'TOTAL';

  @override
  String get clasificacionAMano => 'Classificació a mà';

  @override
  String clasificacionAManoCopa(String copa) {
    return 'Classificació a mà · $copa';
  }

  @override
  String get sinPruebasParaPuntos =>
      'Aquest campionat no té proves. Crea proves primer per poder assignar punts.';

  @override
  String get sinPilotosConEquipo =>
      'No hi ha pilots amb equip en aquest campionat. Assigna equips als pilots primer.';

  @override
  String get editorManualTexto =>
      'Escriu els punts de cada pilot per prova. Es desen sols en sortir de cada casella. Casella buida = no va puntuar; 0 = va participar amb 0.';

  @override
  String get restaurarValores => 'Restaurar valors per defecte';

  @override
  String get restaurar => 'Restaurar';

  @override
  String get restaurarTexto =>
      'Se substituirà la taula de punts actual per la de PitWall Control (70, 64, 59… fins a 1 punt). Els canvis no es desen fins que premis \"Desa\".';

  @override
  String posN(int n) {
    return 'Pos. $n';
  }

  @override
  String get puntosMayus => 'Punts';

  @override
  String get quitarUltimaPosicion => 'Treure última posició';

  @override
  String get anadirPosicion => 'Afegir posició';

  @override
  String get csvExcel => 'CSV / Excel';

  @override
  String get googleSheets => 'Google Sheets';

  @override
  String get listarHojas => 'Llistar fulls';

  @override
  String get seleccionaArchivoClasificacion =>
      'Selecciona un fitxer CSV o Excel amb la classificació. La primera fila ha de ser la capçalera, amb una columna \"Pilot\" i una columna per cada prova.';

  @override
  String archivoNombre(String nombre) {
    return 'Fitxer: $nombre';
  }

  @override
  String get seleccionaHojaClasificacion =>
      'Selecciona el full de Drive amb la classificació.';

  @override
  String hojaNombre(String nombre) {
    return 'Full: $nombre';
  }

  @override
  String get pulsaListarHojas => 'Prem \"Llistar fulls\" per començar.';

  @override
  String pruebasReconocidas(int n) {
    return 'Proves reconegudes: $n';
  }

  @override
  String noReconocidasCampo(String lista) {
    return 'No reconegudes: $lista';
  }

  @override
  String pilotosOk(int n) {
    return 'Pilots OK: $n';
  }

  @override
  String pilotosConProblemas(int n) {
    return 'Pilots amb problemes: $n';
  }

  @override
  String get conectaGooglePrimero =>
      'Connecta el teu compte de Google primer a Configuració → Google.';

  @override
  String importadosResultados(int registros, int pilotos) {
    return 'Importats $registros resultats de $pilotos pilots. Torna a la classificació per veure-la actualitzada.';
  }

  @override
  String get estadoOk => 'OK';

  @override
  String get pilotoNoEncontrado => 'Pilot no trobat';

  @override
  String get pilotoSinEquipo => 'Pilot sense equip en aquest campionat';

  @override
  String get sinPuntosImportables => 'Sense punts importables';

  @override
  String get noEncuentroColumnaPiloto =>
      'No trobo la columna del pilot. La primera fila ha de contenir una columna anomenada \"Pilot\", \"Nom\" o \"Equip\".';

  @override
  String get importando => 'Important…';

  @override
  String get puntosNoValidos =>
      'Hi ha una posició amb un valor de punts no vàlid.';

  @override
  String get tablaGuardada => 'Taula de punts desada.';

  @override
  String get reparto => 'Repartiment';

  @override
  String get movimiento => 'Moviment';

  @override
  String get sinCampeonatoActivo => 'No hi ha cap campionat actiu';

  @override
  String cuotaPorPruebaTexto(String pagat, String coord, String club) {
    return 'Quota per prova: $pagat (coordinadora $coord · club $club)';
  }

  @override
  String get porPrueba => 'Per prova';

  @override
  String get repartoDeLaCuota => 'Repartiment de la quota';

  @override
  String get repartoTexto =>
      'El que paga cada equip per prova i on va. En canviar coordinadora o club, l\'altre s\'ajusta perquè sumin el Pagat.';

  @override
  String get pagatCuotaTotal => 'Pagat (quota total) €';

  @override
  String get coordinadoraEur => 'Coordinadora €';

  @override
  String get clubEur => 'Club €';

  @override
  String get pagatMayorQueCero => 'El Pagat ha de ser més gran que 0.';

  @override
  String get coordClubSumanPagat =>
      'Coordinadora + club han de sumar el Pagat.';

  @override
  String get aplicarAPagosCobrados => 'Aplicar també als pagaments ja cobrats';

  @override
  String get aplicarAPagosCobradosTexto =>
      'Torna a repartir el que va pagar cada equip amb la nova proporció. El que s\'ha cobrat no canvia.';

  @override
  String repartoGuardadoRecalculado(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pagaments recalculats.',
      one: '1 pagament recalculat.',
    );
    return 'Repartiment desat. $_temp0';
  }

  @override
  String get repartoGuardado =>
      'Repartiment desat. S\'aplicarà als pròxims pagaments.';

  @override
  String get nuevoMovimiento => 'Nou moviment';

  @override
  String get editarMovimiento => 'Editar moviment';

  @override
  String get ingreso => 'Ingrés';

  @override
  String get gasto => 'Despesa';

  @override
  String get conceptoObligatorio => 'Concepte *';

  @override
  String get conceptoEjemplo => 'Ex.: Patrocini, Material, Premi…';

  @override
  String get importeObligatorio => 'Import (€) *';

  @override
  String get importeAyuda => 'Només el número, sense signe';

  @override
  String get notas => 'Notes';

  @override
  String get movimientosExtras => 'Moviments extres';

  @override
  String get ingresosYGastosSueltos => '(ingressos i despeses solts)';

  @override
  String get sinMovimientosTexto =>
      'Sense moviments. Fes servir el botó \"+ Moviment\" per afegir patrocinis, despeses de material, etc.';

  @override
  String get balanceCampeonato => 'Balanç del campionat';

  @override
  String get masIngresos => '+ Ingressos';

  @override
  String get menosGastos => '− Despeses';

  @override
  String get coordAbrev => 'Coord.';

  @override
  String get tesoreriaDeLaPrueba => 'Tresoreria de la prova';

  @override
  String get buscarPilotoOEquipo => 'Cercar pilot o equip…';

  @override
  String get borrar => 'Esborrar';

  @override
  String get sinEquiposInscritos => 'Sense equips inscrits';

  @override
  String get recaudadoEnPrueba => 'Recaptat a la prova';

  @override
  String pagadosDe(int pagados, int total) {
    return '$pagados / $total pagats';
  }

  @override
  String exentosNoPagan(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n exempts',
      one: '1 exempt',
    );
    return '$_temp0 no paguen';
  }

  @override
  String nadieCoincide(String filtro) {
    return 'Ningú no coincideix amb \"$filtro\".';
  }

  @override
  String get exencionWildcard => 'Wildcard';

  @override
  String get exencionCoordinadora => 'Pilots de coordinadora';

  @override
  String pagaMitad(String piloto) {
    return 'Paga meitat — $piloto és de coordinadora';
  }

  @override
  String get revisionCategorias => 'Revisió de categories (tancament)';

  @override
  String get aplicarBonificacion => 'Aplicar bonificació de tancament';

  @override
  String get aunNoHayPilotosInscritos =>
      'Encara no hi ha pilots inscrits en aquest campionat.';

  @override
  String get bonificacionCierre => 'Bonificació de tancament';

  @override
  String bonificacionCierreTexto(String tope) {
    return 'Es regularitzarà el saldo de cada pilot que hagi competit:\n\nsaldo = mín(saldo actual + bonificació segons categoria i nombre de curses, $tope).\n\nNomés s\'aplica a qui encara no la tingui. Continuar?';
  }

  @override
  String bonificacionAplicada(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pilots',
      one: '1 pilot',
    );
    return 'Bonificació aplicada a $_temp0.';
  }

  @override
  String inicialUsados(int inicial, int usados) {
    return 'Inicial $inicial  ·  Usats $usados';
  }

  @override
  String ajustarCreditos(String piloto) {
    return 'Ajustar crèdits · $piloto';
  }

  @override
  String get creditosActualesSaldo => 'Crèdits actuals (saldo)';

  @override
  String get creditosAjustados => 'Crèdits ajustats';

  @override
  String get ajustarCreditosMano => 'Ajustar crèdits a mà';

  @override
  String get usados => 'Usats';

  @override
  String get saldoMayus => 'SALDO';

  @override
  String get movimientos => 'Moviments';

  @override
  String get inscripcionAlCampeonato => 'Inscripció al campionat';

  @override
  String get sinMovimientosTodavia => 'Sense moviments encara.';

  @override
  String huecoSinJustificar(int n) {
    return '$n crèd. sense justificar';
  }

  @override
  String descuadreSaldo(String actual, String inicial, String suma) {
    return 'El saldo actual ($actual) no quadra amb inicial $inicial $suma moviments. Probablement venia així en importar o es va editar a mà abans d\'activar el registre.';
  }

  @override
  String get estadoPromociona => 'Promociona';

  @override
  String get estadoDesciende => 'Descendeix';

  @override
  String get estadoSeMantiene => 'Es manté';

  @override
  String get bajar => 'Baixar';

  @override
  String get mantener => 'Mantenir';

  @override
  String get subir => 'Pujar';

  @override
  String get noHayPilotosCompetido =>
      'No hi ha pilots que hagin competit en aquest campionat.';

  @override
  String get revisionTexto =>
      'Ajusta la categoria de cada pilot abans de finalitzar. Es farà servir per a la bonificació de tancament i com a categoria inicial del pròxim campionat.';

  @override
  String get motivoAjusteCreditos => 'Ajust manual (crèdits)';

  @override
  String get verificarEnEquipoWifi => 'Verificar en equip (wifi)';

  @override
  String verificarEnEquipoN(int n) {
    return 'Verificar en equip · $n';
  }

  @override
  String verificarEnEquipoNConectados(int n) {
    return 'Verificar en equip · $n connectats';
  }

  @override
  String get syncIntroTexto =>
      'Diversos Controls poden treballar en aquesta prova alhora. Cadascun desa al seu dispositiu i es passen els canvis per la wifi: verificacions amb les seves fotos, copa i cobraments, i també les altes (pilots, equips, la seva categoria al campionat i inscrits a la prova, i les seves baixes), les tandes amb els seus carrils i els resultats.\n\n• Tots a la mateixa wifi. No cal internet: serveix un router sense connexió o el punt d\'accés d\'un mòbil.\n• La primera vegada, partiu tots de la mateixa còpia de dades. Els catàlegs i la configuració del campionat encara no viatgen.\n• La mateixa clau de l\'esdeveniment a tots, i l\'hora automàtica activada: si dos toquen el mateix, guanya l\'últim canvi.';

  @override
  String get nombreDeEsteControl => 'Nom d\'aquest Control';

  @override
  String get nombreControlAyuda =>
      'Diferent a cada dispositiu (p. ex. «Taula 1»).';

  @override
  String get claveDelEvento => 'Clau de l\'esdeveniment';

  @override
  String get claveEventoAyuda => 'La mateixa a tots els Controls.';

  @override
  String get conectarConOtros => 'Connectar amb altres Controls';

  @override
  String visibleComo(String nombre) {
    return 'Visible com a «$nombre»';
  }

  @override
  String get conectando => 'Connectant…';

  @override
  String get apagado => 'Apagat';

  @override
  String get controlsEnLaRed => 'Controls a la xarxa';

  @override
  String get anadirPorDireccion => 'Afegir per adreça';

  @override
  String get anadirControlPorDireccion => 'Afegir Control per adreça';

  @override
  String get ipOPuerto => 'IP (o IP:port)';

  @override
  String get ipAyuda =>
      'La veus en aquesta mateixa pantalla de l\'altre Control.';

  @override
  String get buscandoOtrosControls => 'Cercant altres Controls a la wifi…';

  @override
  String get noSeEncuentraControl =>
      'No s\'ha trobat cap Control. Comprova que els altres tenen aquesta pantalla amb «Connectar» encès i són a la mateixa wifi, o afegeix-los per la seva adreça.';

  @override
  String dosControlsMismoNombre(String nombre) {
    return 'Hi ha un altre Control que també es diu «$nombre». Canvia el nom d\'un dels dos.';
  }

  @override
  String claveNoCoincide(String host) {
    return '$host · la clau de l\'esdeveniment no coincideix';
  }

  @override
  String get quitarDeLaLista => 'Treure de la llista';

  @override
  String get sincronizarAutomaticamente => 'Sincronitzar automàticament';

  @override
  String cadaNsAppAbierta(int n) {
    return 'Cada $n s mentre l\'app estigui oberta';
  }

  @override
  String get sincronizando => 'Sincronitzant…';

  @override
  String get sincronizarAhora => 'Sincronitzar ara';

  @override
  String ultimaSincronizacion(String hora) {
    return 'Última sincronització: $hora';
  }

  @override
  String get syncSinCambios => 'Sense canvis';

  @override
  String nEquipos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n equips',
      one: '1 equip',
    );
    return '$_temp0';
  }

  @override
  String nPerfiles(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n perfils',
      one: '1 perfil',
    );
    return '$_temp0';
  }

  @override
  String nInscritos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n inscrits',
      one: '1 inscrit',
    );
    return '$_temp0';
  }

  @override
  String nTandas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n tandes',
      one: '1 tanda',
    );
    return '$_temp0';
  }

  @override
  String resultadosDeNTandas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n tandes',
      one: '1 tanda',
    );
    return 'resultats de $_temp0';
  }

  @override
  String nBajas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n baixes',
      one: '1 baixa',
    );
    return '$_temp0';
  }

  @override
  String nVerifNuevas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n verificacions noves',
      one: '1 verificació nova',
    );
    return '$_temp0';
  }

  @override
  String nVerifActualizadas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n actualitzades',
      one: '1 actualitzada',
    );
    return '$_temp0';
  }

  @override
  String nVerifBorradas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n esborrades',
      one: '1 esborrada',
    );
    return '$_temp0';
  }

  @override
  String nCopas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n copes',
      one: '1 copa',
    );
    return '$_temp0';
  }

  @override
  String nCobros(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n cobraments',
      one: '1 cobrament',
    );
    return '$_temp0';
  }

  @override
  String get syncSinClave => 'Posa una clau de l\'esdeveniment.';

  @override
  String syncNoSePudoAbrir(String detalle) {
    return 'No s\'ha pogut obrir la connexió: $detalle';
  }

  @override
  String get syncFormatoDesconocido => 'Format de sincronització desconegut.';

  @override
  String get syncOtraVersion =>
      'L\'altre Control té una altra versió de PitWall Control. Actualitzeu tots a la mateixa versió.';

  @override
  String syncVerifNoExiste(String equipo, String manga) {
    return 'Verificació de «$equipo» a «$manga»: aquí no existeix aquesta tanda o aquest equip.';
  }

  @override
  String syncCocheNoCatalogo(String equipo, String coche) {
    return '$equipo: el cotxe «$coche» no és al catàleg d\'aquest Control.';
  }

  @override
  String syncTandaFaltaEquipo(String tanda) {
    return 'Tanda «$tanda»: aquí falta un equip; el seu carril queda buit.';
  }

  @override
  String syncResultFaltaPiloto(String tanda) {
    return 'Resultats de «$tanda»: aquí falta un pilot o un equip; aquesta fila no es copia.';
  }

  @override
  String syncEquipoFaltanPilotos(String equipo) {
    return 'Equip «$equipo»: aquí falten alguns dels seus pilots; no es copia.';
  }

  @override
  String get syncSinRespuesta => 'No respon (segueix a la mateixa wifi?).';

  @override
  String get syncSinConexion =>
      'No es pot connectar (segueix a la mateixa wifi?).';

  @override
  String get syncControlAnadido => 'Control afegit.';

  @override
  String syncNoHayControlEn(String dir) {
    return 'No hi ha cap Control connectat a $dir.';
  }

  @override
  String get primeroInscribeEquipos => 'Primer inscriu equips a la prova.';

  @override
  String get sinCoincidenciasPunto => 'No hi ha coincidències.';

  @override
  String get ajusteManualHistorial =>
      'El canvi del saldo s\'anota com a \"Ajust manual\" a l\'historial.';

  @override
  String bonifTope(int bonif, int tope) {
    return '+$bonif, limitat al topall $tope';
  }

  @override
  String desfaseHora(int min) {
    return 'L\'hora de l\'altre Control es desvia $min min de la d\'aquest dispositiu. Posa a tots l\'hora automàtica.';
  }

  @override
  String nCarreras(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n curses',
      one: '1 cursa',
    );
    return '$_temp0';
  }

  @override
  String bonifMotivo(String carreras, String categoria, int bonif) {
    return 'Bonificació de tancament per $carreras ($categoria): +$bonif';
  }

  @override
  String bonifLimiteTope(int tope) {
    return ', limitat al topall $tope';
  }

  @override
  String get importarPilotosFinalizado =>
      'Importar pilots d\'un campionat finalitzat';

  @override
  String get importarPilotosFinalizadoAyuda =>
      'Porta els seus pilots amb el saldo de tancament com a crèdits inicials.';

  @override
  String get noImportar => 'No importar';

  @override
  String tesoreriaNoCuadra(String suma, String pagat) {
    return 'Tresoreria: Coordinadora + Club han de sumar el Pagat ($suma ≠ $pagat).';
  }

  @override
  String bonifCierrePregunta(String tope) {
    return 'Has marcat el campionat com a finalitzat.\n\nEs regularitzarà el saldo de cada pilot que hagi competit: saldo = mín(saldo actual + bonificació segons categoria i nombre de curses, $tope). Cada ajust queda registrat com un moviment que indica la bonificació aplicada.\n\nImportant: la bonificació fa servir la categoria de tancament (revisa-la abans a Crèdits → Revisió de categories si hi ha promocions o descensos).\n\nAplicar-la ara?';
  }

  @override
  String get ahoraNo => 'Ara no';

  @override
  String get eliminarCampeonato => 'Eliminar campionat';

  @override
  String eliminarCampeonatoTexto(String nombre) {
    return 'Eliminar \"$nombre\"?\n\nS\'esborraran també les seves proves, tandes, inscripcions, resultats, verificacions i pagaments. No es pot desfer.';
  }

  @override
  String get nuevoCampeonato => 'Nou campionat';

  @override
  String get editarCampeonato => 'Editar campionat';

  @override
  String get obligatoriosAviso =>
      'Obligatori (*): nom, almenys una copa i el tipus de motor. La resta es pot completar després.';

  @override
  String get datosBasicos => 'Dades bàsiques';

  @override
  String get nombreCampeonatoObligatorio => 'Nom del campionat *';

  @override
  String get nombreCampeonatoEjemplo =>
      'Ex.: Lliga 2026, Individual LMP-HYP-GT3 Tardor';

  @override
  String get formato => 'Format';

  @override
  String get formatoAyuda =>
      'Parelles = 2 pilots per equip. Individual = 1 pilot';

  @override
  String get formatoParejas => 'Parelles';

  @override
  String get formatoIndividual => 'Individual';

  @override
  String get anio => 'Any';

  @override
  String get anioInvalido => 'Any invàlid';

  @override
  String get activarCampeonatoAlCrear => 'Activar aquest campionat en crear-lo';

  @override
  String get campeonatoVisible => 'Campionat visible';

  @override
  String get campeonatoVisibleAyuda =>
      'Només els campionats visibles surten al selector';

  @override
  String get clubOrgAyudaExportaciones =>
      'Apareix a la capçalera de les exportacions (PDF de tandes, verificacions, classificació i crèdits).';

  @override
  String get categoriasCopasObligatorio => 'Categories / copes *';

  @override
  String get seleccionaCopasTexto =>
      'Selecciona les que es fan servir en aquest campionat. Poden ser una de sola (p. ex. \"Grup C\") o diverses (p. ex. \"LMP + HYP + GT3\").';

  @override
  String get anadirNuevaCategoria => 'Afegir nova categoria';

  @override
  String get anadirNuevaCategoriaAyuda => 'Si no la trobes a dalt';

  @override
  String get motorObligatorio => 'Motor *';

  @override
  String get rangoMotorCampeonatoTexto =>
      'Rang de números de motor que l\'organització sorteja entre els equips a cada prova. Deixa\'l buit si no feu servir sorteig.';

  @override
  String get creditosYTesoreria => 'Crèdits i tresoreria';

  @override
  String get creditosTesoreriaAyuda =>
      'Activa\'ls només si el campionat els fa servir; si no, les seves pantalles s\'amaguen del menú.';

  @override
  String get usaCreditos => 'Fa servir sistema de crèdits (handicap)';

  @override
  String get usaCreditosAyuda =>
      'Sistema d\'handicap per crèdits. Apaga\'l si el campionat no el fa servir.';

  @override
  String get topeRegularizacion => 'Topall regularització crèdits';

  @override
  String get topeRegularizacionAyuda =>
      'Màxim de crèdits en regularitzar al tancament de temporada';

  @override
  String get numeroPositivo => 'Número positiu';

  @override
  String get gestionaTesoreria => 'Gestiona tresoreria (quotes/pagaments)';

  @override
  String get gestionaTesoreriaAyuda =>
      'Apaga\'l si aquest campionat no controla els diners.';

  @override
  String get pagatTexto =>
      'PAGAT és la quota total. APORTACIÓ COORDINADORA + APORTACIÓ CLUB han de sumar el PAGAT (és el desglossament d\'on va el diner).';

  @override
  String get pagatObligatorio => 'Pagat (€) *';

  @override
  String get coordinadoraEurParentesis => 'Coordinadora (€)';

  @override
  String get clubEurParentesis => 'Club (€)';

  @override
  String get indicaLaCuota => 'Indica la quota';

  @override
  String get numeroNoValido => 'Número no vàlid';

  @override
  String get masOpcionesPuntuacion =>
      'Més opcions: puntuació, verificació i PDF';

  @override
  String get puntuacion => 'Puntuació';

  @override
  String get numeroDescartes => 'Nombre de descarts';

  @override
  String get numeroDescartesAyuda =>
      'Quantes proves pitjors es descarten al pilot';

  @override
  String get entreCeroYCinco => 'Entre 0 i 5';

  @override
  String get tablaDePuntosAyuda => 'Punts per posició a cada prova';

  @override
  String get verificacionAyuda =>
      'Amplada d\'eix, cotxes i fabricants que es comproven en verificar.';

  @override
  String get anchuraEjeCategoriasAyuda =>
      'Amplada màxima d\'eix (mm) per categoria. Deixa-ho buit si en aquesta copa no es comprova.';

  @override
  String get pesoMinCreditos => 'Pes mínim i crèdits en aquest campionat';

  @override
  String get pesoMinCampeonato => 'Pes mínim en aquest campionat';

  @override
  String get pesoMinCampeonatoAyuda =>
      'Fixa els valors dels cotxes perquè els canvis del catàleg no afectin aquest campionat.';

  @override
  String get marcaPdf => 'Marca als PDF (opcional)';

  @override
  String get marcaPdfTexto =>
      'Títol de capçalera i lema del peu a les exportacions (PDF) d\'AQUEST campionat. Si ho deixes buit, es fa servir un valor per defecte.';

  @override
  String get tituloCabecera => 'Títol de capçalera';

  @override
  String get tituloCabeceraEjemplo => 'Ex.: PITWALL o el nom del teu club';

  @override
  String get lemaPie => 'Lema del peu';

  @override
  String get lemaPieEjemplo => 'Ex.: el teu club · localitat';

  @override
  String get campeonatoFinalizadoTitulo => 'Campionat finalitzat';

  @override
  String get campeonatoFinalizadoAyuda =>
      'Temporada tancada: la classificació ordena per nets, s\'habilita la bonificació de tancament i les seves verificacions queden bloquejades (només lectura).';

  @override
  String get campeonatos => 'Campionats';

  @override
  String get activar => 'Activar';

  @override
  String anioTexto(int anio) {
    return 'Any $anio';
  }

  @override
  String descartesTexto(int n) {
    return 'Descarts: $n';
  }

  @override
  String get cochesDelCampeonato => 'Cotxes del campionat';

  @override
  String get fijarValoresCatalogo => 'Fixar els valors actuals del catàleg';

  @override
  String get volverTodosAlCatalogo => 'Tornar tots al catàleg';

  @override
  String get volverAlCatalogo => 'Tornar al catàleg';

  @override
  String get volverAlCatalogoTexto =>
      'S\'esborren els valors fixats en aquest campionat i tots els cotxes tornen a fer servir el pes mínim i els crèdits del catàleg.\n\nLes verificacions ja validades no canvien: guarden el reglament amb què es van verificar.';

  @override
  String valorNoValidoEn(String coche) {
    return 'Valor no vàlid a $coche.';
  }

  @override
  String get buscarCoche => 'Cercar cotxe';

  @override
  String get pesoMinG => 'Pes mín. (g)';

  @override
  String fijadosCoches(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n cotxes',
      one: '1 cotxe',
    );
    return 'Fixats els valors del catàleg en $_temp0.';
  }

  @override
  String get aunNoHayHistorial => 'Encara no hi ha historial.';

  @override
  String get cochesYaFijados =>
      'Tots els cotxes ja tenien els seus valors fixats.';

  @override
  String get yCreditos => ' i crèdits';

  @override
  String pesoMinCochesTexto(String creditos, String campeonato) {
    return 'Pes mínim$creditos de cada cotxe a $campeonato. Buit = es fa servir el valor del catàleg. El que fixis aquí no canvia encara que després es modifiqui el catàleg (p. ex. per a la temporada següent).';
  }

  @override
  String get verifsValidadasNoCambian =>
      'Les verificacions validades no canvien: guarden el reglament amb què es van verificar.';

  @override
  String get noHayCochesConCopas =>
      'No hi ha cotxes del catàleg amb les copes d\'aquest campionat.';

  @override
  String get indicaDireccionPitwall => 'Indica l\'adreça de PitWall.';

  @override
  String errorAlPedirCarreras(String codigo) {
    return 'Error $codigo en demanar les curses.';
  }

  @override
  String errorAlPedirResultados(String codigo) {
    return 'Error $codigo en demanar els resultats.';
  }

  @override
  String respuestaNoReconocida(String schema) {
    return 'Resposta no reconeguda ($schema).';
  }

  @override
  String get pinIncorrecto => 'PIN incorrecte o dispositiu no autoritzat.';

  @override
  String errorCodigoHttp(String codigo) {
    return 'Error $codigo.';
  }

  @override
  String noSePudoConectarPitwall(String detalle) {
    return 'No s\'ha pogut connectar amb PitWall: $detalle';
  }

  @override
  String verificacionesEnviadas(String n, String nombre) {
    return '$n verificació(ns) enviada(es) a $nombre.';
  }

  @override
  String get idiomaDelPdf => 'Idioma del PDF';

  @override
  String get imagenes => 'Imatges';

  @override
  String difValor(String titulo, String antes, String unidad, String ahora) {
    return '$titulo: $antes$unidad (ara $ahora$unidad)';
  }

  @override
  String difAnadidas(String lista) {
    return 'afegides: $lista';
  }

  @override
  String difQuitadas(String lista) {
    return 'tretes: $lista';
  }

  @override
  String difNombreCoche(String antes, String ahora) {
    return 'Nom del cotxe: $antes (ara $ahora)';
  }

  @override
  String get tituloPesoMinimo => 'Pes mínim';

  @override
  String get tituloCreditosCoche => 'Crèdits del cotxe';

  @override
  String get tituloRpmMax => 'RPM màx. del motor';

  @override
  String get tituloImanMax => 'Imant màx. del motor';

  @override
  String get tituloEjeDelMax => 'Eix davanter màx.';

  @override
  String get tituloEjeTraMax => 'Eix posterior màx.';

  @override
  String get tituloFabricantesPermitidos => 'Fabricants permesos';

  @override
  String get tituloMarcasCatalogo => 'Marques del catàleg';

  @override
  String get tituloLlantasDel => 'Llandes davanteres';

  @override
  String get tituloLlantasTra => 'Llandes posteriors';

  @override
  String get tituloBancadas => 'Bancades';

  @override
  String get tituloNeumaticos => 'Pneumàtics';

  @override
  String get coches => 'Cotxes';

  @override
  String get marcas => 'Marques';

  @override
  String get llantas => 'Llandes';

  @override
  String get engranajes => 'Engranatges';

  @override
  String get motores => 'Motors';

  @override
  String get bancadas => 'Bancades';

  @override
  String get neumaticos => 'Pneumàtics';

  @override
  String get copas => 'Copes';

  @override
  String get clubs => 'Clubs';

  @override
  String get llanta => 'Llanda';

  @override
  String get engranaje => 'Engranatge';

  @override
  String get sinCopaCategoria => 'Sense copa/categoria (no es pot fer servir)';

  @override
  String copasEtiqueta(String copas) {
    return 'Copes: $copas';
  }

  @override
  String pesoYCreditos(String peso, String creditos) {
    return 'Pes mín ${peso}g  ·  Crèd $creditos';
  }

  @override
  String get todasLasCopas => 'Totes les copes';

  @override
  String get todas => 'Totes';

  @override
  String get sinCoincidencias => 'Sense coincidències';

  @override
  String get sinCoches => 'Sense cotxes';

  @override
  String get sinMarcas => 'Sense marques';

  @override
  String get sinLlantas => 'Sense llandes';

  @override
  String get sinEngranajes => 'Sense engranatges';

  @override
  String get sinMotores => 'Sense motors';

  @override
  String get sinBancadas => 'Sense bancades';

  @override
  String get sinChasis => 'Sense xassís';

  @override
  String get sinNeumaticos => 'Sense pneumàtics';

  @override
  String get sinCopas => 'Sense copes';

  @override
  String get sinClubs => 'Sense clubs';

  @override
  String get buscarCochePuntos => 'Cercar cotxe…';

  @override
  String get sinMedidas => 'Sense mesures';

  @override
  String get sinReferencia => 'Sense referència';

  @override
  String get calculandoCambiosSubir => 'Calculant els canvis per pujar…';

  @override
  String get todoCatalogoExcel => 'Tot el catàleg en Excel';

  @override
  String get exportarTodoExcel => 'Exportar-ho tot a Excel';

  @override
  String get unaPestanaPorCatalogo => 'Una pestanya per catàleg';

  @override
  String get importarExcelEditado => 'Importar l\'Excel editat';

  @override
  String get actualizaPorIdCreaNuevos => 'Actualitza per ID i crea els nous';

  @override
  String bajarDesdeDriveCon(String hoja, String pestana) {
    return 'Baixar des de Drive ($hoja · $pestana)';
  }

  @override
  String get subirMisCambiosSheet => 'Pujar els meus canvis al Sheet';

  @override
  String get importarPestanaActual => 'Importar la pestanya actual';

  @override
  String get importarCatalogosExcelTitulo => 'Importar catàlegs des d\'Excel';

  @override
  String get importarCatalogosExcelTexto =>
      'S\'actualitzaran les files que tinguin ID i es crearan les que no en tinguin.\n\nNo s\'esborra res: les fitxes que treguis del full continuaran a l\'app.';

  @override
  String resumenCreadosActualizados(int creados, int actualizados) {
    return '✓ Creats: $creados · Actualitzats: $actualizados';
  }

  @override
  String catalogoImportadoLinea(String nombre, int creados, int actualizados) {
    String _temp0 = intl.Intl.pluralLogic(
      creados,
      locale: localeName,
      other: '$creados nous',
      one: '1 nou',
    );
    String _temp1 = intl.Intl.pluralLogic(
      actualizados,
      locale: localeName,
      other: '$actualizados actualitzats',
      one: '1 actualitzat',
    );
    return '• $nombre: $_temp0, $_temp1';
  }

  @override
  String pestanasIgnoradasAviso(String lista) {
    return '⚠ Aquestes pestanyes no s\'han importat perquè el seu nom no coincideix amb cap catàleg:\n$lista\nNo reanomenis les pestanyes del fitxer exportat.';
  }

  @override
  String erroresEtiqueta(String lista) {
    return 'Errors:\n$lista';
  }

  @override
  String eliminarFichaTexto(String nombre) {
    return 'Eliminar \"$nombre\"?';
  }

  @override
  String vacioPulsaAnadir(String texto) {
    return '$texto.\nPrem el + per afegir.';
  }

  @override
  String get copasDondeAplica => 'Copes on s\'aplica';

  @override
  String get copasSinMarcarAviso =>
      'Sense marcar = no es podrà fer servir en cap copa.';

  @override
  String get copasMarcarAviso => 'Marca només les copes on és vàlid.';

  @override
  String get nuevoCoche => 'Cotxe nou';

  @override
  String get editarCoche => 'Editar cotxe';

  @override
  String get nombreCompletoObligatorio => 'Nom complet *';

  @override
  String get nombreCompletoEjemplo => 'Ex: SCALEAUTO-BMW M8 GTE';

  @override
  String get marcaObligatoria => 'Marca *';

  @override
  String get modeloObligatorio => 'Model *';

  @override
  String get pesoMinimoObligatorio => 'Pes mínim (g) *';

  @override
  String get pesoMinimoAyuda =>
      'No canvia les verificacions validades ni els campionats amb valors fixats';

  @override
  String get creditosCoche => 'Crèdits cotxe';

  @override
  String get creditosCocheAyuda => 'Negatiu o positiu';

  @override
  String get galeria => 'Galeria';

  @override
  String get camara => 'Càmera';

  @override
  String get quitarFoto => 'Treure la foto';

  @override
  String get nuevaMarca => 'Marca nova';

  @override
  String get editarMarca => 'Editar marca';

  @override
  String get codigoObligatorio => 'Codi *';

  @override
  String get marcaCodigoEjemplo => 'Ex: SIT, SCA, SLP';

  @override
  String get nuevaLlanta => 'Llanda nova';

  @override
  String get editarLlanta => 'Editar llanda';

  @override
  String get llantaDimensionEjemplo => 'Ex: 15,8 x 8 PL';

  @override
  String get delantera => 'Davantera';

  @override
  String get trasera => 'Posterior';

  @override
  String get ambas => 'Totes dues';

  @override
  String get nuevoEngranaje => 'Engranatge nou';

  @override
  String get editarEngranaje => 'Editar engranatge';

  @override
  String get diametroEjemplo => 'Ex: 6,5';

  @override
  String get dientesEjemplo => 'Ex: 12 pinyó, 28 corona';

  @override
  String nDientes(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n dents',
      one: '1 dent',
    );
    return '$_temp0';
  }

  @override
  String get nuevoMotor => 'Motor nou';

  @override
  String get editarMotor => 'Editar motor';

  @override
  String get motorIdentificadorAyuda => 'Identificador o model';

  @override
  String get nuevaBancada => 'Bancada nova';

  @override
  String get editarBancada => 'Editar bancada';

  @override
  String get bancadaEjemplo => 'Ex: Slot.it 1,0 carboni';

  @override
  String get nuevoNeumatico => 'Pneumàtic nou';

  @override
  String get editarNeumatico => 'Editar pneumàtic';

  @override
  String get neumaticoEjemplo => 'Ex: AS25 19,0 NEGRE';

  @override
  String get referenciaOpcional => 'Referència (opcional)';

  @override
  String get copaEjemplo => 'Ex: GT, GT2, LMP, HYP';

  @override
  String get clubNombreEjemplo => 'Ex: EL SOT, GASCLAVAT, SLOTMANIA';

  @override
  String get chasisEjemplo => 'Ex: INJECCIÓ PLÀSTIC NEGRE, 3D';

  @override
  String get nuevoChasis => 'Xassís nou';

  @override
  String get nuevaCopa => 'Copa nova';

  @override
  String get nuevoClub => 'Club nou';

  @override
  String importarTitulo(String titulo) {
    return 'Importar $titulo';
  }

  @override
  String pasoEligeLaFuente(int n) {
    return '$n. Tria la font';
  }

  @override
  String get archivoCsvExcel => 'Fitxer CSV / Excel';

  @override
  String get sustituirCatalogoExistente => 'Substituir el catàleg existent';

  @override
  String get sustituirCatalogoExistenteTexto =>
      'Si ho marques, primer es buida la taula i després s\'importa.';

  @override
  String importarNFilas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Importar $n files',
      one: 'Importar 1 fila',
    );
    return '$_temp0';
  }

  @override
  String get vincularSinImportar => 'Vincular sense importar';

  @override
  String get sustituirCatalogoTitulo => 'Substituir el catàleg';

  @override
  String get anadirCatalogoTitulo => 'Afegir al catàleg';

  @override
  String sustituirCatalogoTexto(int n, int m) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Es buidaran les $n fitxes actuals',
      one: 'Es buidarà la fitxa actual',
    );
    String _temp1 = intl.Intl.pluralLogic(
      m,
      locale: localeName,
      other: 'les $m files del full',
      one: 'la fila del full',
    );
    return '$_temp0 abans d\'importar $_temp1.\n\nEs perden els ID de sincronització, les fotos locals dels cotxes i els valors fixats als campionats. El que només existeixi a l\'app i no sigui al full desapareix.';
  }

  @override
  String anadirCatalogoTexto(int n, int m) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'S\'afegiran les $n files del full',
      one: 'S\'afegirà la fila del full',
    );
    String _temp1 = intl.Intl.pluralLogic(
      m,
      locale: localeName,
      other: 'les $m fitxes que ja tens',
      one: 'la fitxa que ja tens',
    );
    return '$_temp0 a $_temp1.\n\nLes files que ja existeixin (mateix nom o clau) quedaran duplicades. Si només vols connectar el full per portar canvis, cancel·la i fes servir «Vincular sense importar».';
  }

  @override
  String get siSustituir => 'Sí, substituir';

  @override
  String get siAnadir => 'Sí, afegir';

  @override
  String get hojaVinculadaTitulo => 'Full vinculat';

  @override
  String hojaVinculadaTexto(String pestana) {
    return 'No s\'ha importat res ni s\'ha tocat cap fitxa del catàleg.\n\nA la pestanya «$pestana» ja apareix el botó de sincronització: «Actualitzar des de Drive» portarà els canvis del full aparellant per la columna ID (si n\'hi ha) o per nom, sense duplicar les fitxes que ja tens.';
  }

  @override
  String errorAlVincular(String detalle) {
    return 'Error en vincular: $detalle';
  }

  @override
  String resumenImportacionCatalogo(int ok, int saltados) {
    return '✓ Afegits: $ok\n✗ Saltats: $saltados';
  }

  @override
  String get hojaVinculadaAviso =>
      '\n\nFull vinculat: a partir d\'ara prem \"Actualitzar des de Drive\" a la pestanya del catàleg per portar canvis.';

  @override
  String get eligeHojaGoogle => 'Tria el full de Google';

  @override
  String modificadaFecha(DateTime fecha) {
    final intl.DateFormat fechaDateFormat = intl.DateFormat.yMd(localeName);
    final String fechaString = fechaDateFormat.format(fecha);

    return 'Modificada: $fechaString';
  }

  @override
  String avisoCatalogoLlenoIntro(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n fitxes',
      one: '1 fitxa',
    );
    return 'Aquest catàleg ja té $_temp0 a l\'app.';
  }

  @override
  String get avisoCatalogoLlenoImportar =>
      '• «Importar» afegirà les files del full com a noves: les que ja existeixin quedaran duplicades.';

  @override
  String get avisoCatalogoLlenoVincular =>
      '• Si només vols connectar el full, fes servir «Vincular sense importar»; després, «Actualitzar des de Drive» porta els canvis sense duplicar.';

  @override
  String get avisoCatalogoLlenoSustituir =>
      '• «Substituir el catàleg existent» buida el catàleg actual: es perden els ID de sincronització, les fotos locals i els valors fixats als campionats.';

  @override
  String get ayudaCatalogoCoches =>
      'CSV/Excel o Google Sheets amb columnes: Nom, Marca, Model, Pes mínim, Crèdits, Copa(es) (separades per coma; buit = totes).';

  @override
  String get ayudaCatalogoMarcas => 'CSV/Excel amb columnes: Codi, Nom.';

  @override
  String get ayudaCatalogoLlantas =>
      'CSV/Excel amb columnes: Dimensió, Tipus (DELANTERA / TRASERA / AMBAS).';

  @override
  String get ayudaCatalogoEngranajes =>
      'CSV/Excel o Google Sheets amb columnes: Marca, Dents, Tipus (PIÑÓN / CORONA).';

  @override
  String get ayudaCatalogoMotores =>
      'CSV/Excel o Google Sheets amb columnes: Motor, RPM, Gauss, Copa(es) (separades per coma; buit = totes).';

  @override
  String get ayudaCatalogoSimple => 'CSV/Excel amb una columna: Nom.';

  @override
  String get ayudaCatalogoNeumaticos =>
      'CSV/Excel amb columnes: Nom, Referència (opcional).';

  @override
  String get modeloCampo => 'Model';

  @override
  String get pesoMinimoCampo => 'Pes mínim *';

  @override
  String get creditosCampo => 'Crèdits';

  @override
  String get copasCampo => 'Copa(es)';

  @override
  String get fotoEnlaceDrive => 'Foto (enllaç de Drive)';

  @override
  String get tipoPinonCorona => 'Tipus (pinyó/corona)';

  @override
  String get referenciaCampo => 'Referència';

  @override
  String get dimensionObligatoria => 'Dimensió *';

  @override
  String get tipoCampo => 'Tipus';

  @override
  String get dientesObligatorio => 'Dents *';

  @override
  String get subirAlSheet => 'Pujar al Sheet';

  @override
  String subidoSheetResumen(int anadidas, int actualizadas, int borradas) {
    String _temp0 = intl.Intl.pluralLogic(
      anadidas,
      locale: localeName,
      other: '$anadidas afegides',
      one: '1 afegida',
    );
    String _temp1 = intl.Intl.pluralLogic(
      actualizadas,
      locale: localeName,
      other: '$actualizadas actualitzades',
      one: '1 actualitzada',
    );
    String _temp2 = intl.Intl.pluralLogic(
      borradas,
      locale: localeName,
      other: '$borradas esborrades',
      one: '1 esborrada',
    );
    return '✓ Pujat al Sheet: $_temp0, $_temp1, $_temp2.';
  }

  @override
  String fotosSinSubir(String lista) {
    return '\n✗ Fotos sense pujar: $lista';
  }

  @override
  String errorAlSubir(String detalle) {
    return 'Error en pujar: $detalle';
  }

  @override
  String nadaQueSubir(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n files idèntiques',
      one: '1 fila idèntica',
    );
    return 'No hi ha res per pujar: el full ja coincideix amb l\'app.\n\n($_temp0)';
  }

  @override
  String get subidaIntro => 'Es pujaran els teus canvis al Google Sheet.';

  @override
  String filasNuevasResumen(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '· $n files noves (s\'afegeixen)',
      one: '· 1 fila nova (s\'afegeix)',
    );
    return '$_temp0';
  }

  @override
  String conDiferenciasResumen(int n) {
    return '· $n amb diferències (tria quines trepitgen el full)';
  }

  @override
  String borradasResumen(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '· $n esborrades a l\'app, pendents d\'esborrar al full (tria quines)',
      one: '· 1 esborrada a l\'app, pendent d\'esborrar al full (tria quina)',
    );
    return '$_temp0';
  }

  @override
  String identicasResumen(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '· $n idèntiques (s\'ignoren)',
      one: '· 1 idèntica (s\'ignora)',
    );
    return '$_temp0';
  }

  @override
  String get borradasEnAppPregunta =>
      'Esborrades a l\'app — també les esborrem del full?';

  @override
  String get seBorraraEsaFila => 'S\'esborrarà aquesta fila del Sheet';

  @override
  String get seDejaEnSheet => 'Es deixa al Sheet (no s\'esborra)';

  @override
  String get filasNuevasTitulo => 'Files noves';

  @override
  String get seAnadiraAlSheet => 'S\'afegirà al Sheet';

  @override
  String get diferenciasConflictos => 'Diferències (conflictes)';

  @override
  String subirNAlSheet(int n) {
    return 'Pujar $n al Sheet';
  }

  @override
  String get seSubiraTuVersion => 'Es pujarà la teva versió (trepitja el full)';

  @override
  String get seMantieneSheet => 'Es manté el que hi ha al Sheet';

  @override
  String appValor(String valor) {
    return 'app: $valor';
  }

  @override
  String sheetValor(String valor) {
    return 'full: $valor';
  }

  @override
  String get vacioParentesis => '(buit)';

  @override
  String get plantillasIntro =>
      'Descarrega la plantilla, omple-la amb les teves dades (esborra la fila d\'exemple) i després importa-la des de la secció corresponent. La primera fila són les columnes: no la canviïs.';

  @override
  String get descargar => 'Descarregar';

  @override
  String get plantillaPilotos => 'Pilots';

  @override
  String get plantillaPilotosTexto => 'Per importar pilots a un campionat.';

  @override
  String get plantillaEquipos => 'Equips (parelles)';

  @override
  String get plantillaEquiposTexto =>
      'Equips amb un o dos pilots. Deixa en blanc el pilot 2 si és individual.';

  @override
  String get plantillaEquiposResistencia => 'Equips de resistència (24H/12H)';

  @override
  String get plantillaEquiposResistenciaTexto =>
      'Equips de 3 a 6 pilots. Deixa en blanc els que no facis servir. La categoria de cada pilot es pren de la seva fitxa ja importada.';

  @override
  String get plantillaInscripciones => 'Inscripcions a una prova';

  @override
  String get plantillaInscripcionesTexto =>
      'Equips que s\'inscriuen a una prova, amb la seva preferència de dia.';

  @override
  String get plantillaParticipantesVerificacion =>
      'Participants de verificació lliure';

  @override
  String get plantillaParticipantesVerificacionTexto =>
      'Participants d\'una sessió de verificació lliure. Pilot 2 i Equip són opcionals; si la copa va buida es tria en importar.';

  @override
  String get plantillaCoches => 'Catàleg · Cotxes';

  @override
  String get plantillaCochesTexto => 'Models de cotxe del catàleg.';

  @override
  String get plantillaMotores => 'Catàleg · Motors';

  @override
  String get plantillaMotoresTexto =>
      'Motors homologats (RPM i gauss de referència).';

  @override
  String get plantillaMarcas => 'Catàleg · Marques';

  @override
  String get plantillaMarcasTexto => 'Marques (codi curt + nom).';

  @override
  String get plantillaLlantas => 'Catàleg · Llandes';

  @override
  String get plantillaLlantasTexto =>
      'Dimensió i tipus (DELANTERA / TRASERA / AMBAS).';

  @override
  String get plantillaEngranajes => 'Catàleg · Engranatges';

  @override
  String get plantillaEngranajesTexto =>
      'Pinyons i corones (tipus, diàmetre, dents).';

  @override
  String get pegaClientIdSecret =>
      'Enganxa el Client ID i el Client Secret abans de desar.';

  @override
  String get clientIdNoValido =>
      'El Client ID no sembla vàlid (ha d\'acabar en \".apps.googleusercontent.com\"). Comprova que l\'hagis copiat sencer de Google Cloud Console.';

  @override
  String get credencialesGuardadasAviso =>
      'Credencials desades. Ara prem \"Connecta amb Google\".';

  @override
  String get abriendoNavegadorAutoriza =>
      'Obrint el navegador… autoritza i torna aquí.';

  @override
  String get conectadoGoogleOk => 'Connectat correctament amb Google.';

  @override
  String get desconectarGoogle => 'Desconnecta Google';

  @override
  String get desconectarGoogleTexto =>
      'L\'app deixarà de llegir els teus fulls fins que et tornis a connectar. Continuar?';

  @override
  String get desconectar => 'Desconnecta';

  @override
  String get credencialesProyectoGoogleCloud =>
      'Credencials del projecte Google Cloud';

  @override
  String get credencialesProyectoTexto =>
      'Aquestes credencials es creen una sola vegada al teu compte de Google Cloud. Prem \"Com aconseguir-les\" per a una guia pas a pas.';

  @override
  String get comoConseguirlas => 'Com aconseguir-les';

  @override
  String get guardarCredenciales => 'Desa les credencials';

  @override
  String get permisosSolicitados => 'Permisos sol·licitats';

  @override
  String get permisosTexto =>
      '• Llegir els teus fulls de càlcul (Google Sheets — només lectura)\n• Llistar fitxers de Drive (Google Drive — només lectura)\n• Crear i modificar el fitxer de còpia de l\'app (Drive — només el fitxer de l\'app)\n\nPitWall Control no toca cap fitxer teu, només el que crea ell.';

  @override
  String get copiaCompartidaDrive => 'Còpia compartida a Drive';

  @override
  String get copiaCompartidaDriveTexto =>
      'Puja o baixa la base de dades per treballar entre diversos dispositius.';

  @override
  String get conectadoConGoogle => 'Connectat amb Google';

  @override
  String get sinConectar => 'Sense connectar';

  @override
  String get faltanCredencialesGoogle =>
      'Falten credencials del projecte Google Cloud';

  @override
  String get conectarConGoogle => 'Connecta amb Google';

  @override
  String get conseguirCredenciales => 'Com aconseguir les credencials';

  @override
  String get conseguirCredencialesTexto =>
      'Només es fa una vegada, és gratis i no demana targeta. Necessites el compte de Google que té els teus fulls i el teu Drive i uns 10 minuts.';

  @override
  String get verManualCapturas => 'Veure el manual amb captures';

  @override
  String get guiaPaso1Titulo => 'Crear un projecte';

  @override
  String get guiaPaso1Texto =>
      'Entra a Google Cloud Console amb el teu compte de Google. A dalt, prem el selector de projectes → \"Projecte nou\". Nom: \"PitWall Control\". Prem \"Crea\" i comprova que quedi seleccionat.';

  @override
  String get abrirCloudConsole => 'Obre Cloud Console';

  @override
  String get guiaPaso2Titulo => 'Activar les dues API';

  @override
  String get guiaPaso2Texto =>
      'Habilita \"Google Sheets API\" i també \"Google Drive API\" (prem \"Habilita\" a cadascuna). Si no, la connexió fallarà.';

  @override
  String get apiSheets => 'API Sheets';

  @override
  String get apiDrive => 'API Drive';

  @override
  String get pantallaDeConsentimiento => 'Pantalla de consentiment';

  @override
  String get guiaPaso3Texto =>
      'A \"Google Auth Platform\" prem \"Comença\" i segueix l\'assistent: 1) nom \"PitWall Control\" i el teu correu d\'assistència; 2) Públic: tria \"Usuaris externs\" (\"Intern\" només val per a comptes d\'empresa); 3) el teu correu de contacte; 4) accepta la política de dades, \"Continua\" i \"Crea\".';

  @override
  String get guiaPaso4Titulo => 'Afegir el teu compte com a usuari de prova';

  @override
  String get guiaPaso4Texto =>
      'Al menú lateral entra a \"Públic\" → \"Usuaris de prova\" → \"Add users\". Escriu el correu de Google amb el qual connectaràs Control (i el de qui més s\'hi connecti) i desa. Sense aquest pas Google dona l\'\"Error 403: access_denied\".';

  @override
  String get publico => 'Públic';

  @override
  String get guiaPaso5Titulo => 'Crear el client OAuth';

  @override
  String get guiaPaso5Texto =>
      'A \"Clients\" prem \"Crea un client\". Tipus: \"Aplicació d\'escriptori\". Nom: \"PitWall Control Desktop\". Prem \"Crea\".';

  @override
  String get clientes => 'Clients';

  @override
  String get guiaPaso6Titulo => 'Copiar l\'ID i el secret';

  @override
  String get guiaPaso6Texto =>
      'Apareix l\'ID de client (acaba en .apps.googleusercontent.com) i el secret. Copia\'ls i prem \"Baixa JSON\": Google només mostra el secret en aquest moment. Enganxa\'ls a la pantalla anterior, prem \"Desa les credencials\" i després \"Connecta amb Google\".';

  @override
  String get guiaPaso7Titulo => 'Autoritzar al navegador';

  @override
  String get guiaPaso7Texto =>
      'Tria el compte del pas 4. Si surt \"Google no ha verificat aquesta aplicació\", prem \"Configuració avançada\" → \"Ves a PitWall Control (no segur)\", marca tots els permisos i \"Continua\".';

  @override
  String get avisoPrueba7Dias =>
      'Perquè no caduqui als 7 dies: mentre l\'aplicació està en estat \"Prova\", Google tanca la sessió cada 7 dies. A \"Públic\" prem \"Publica l\'aplicació\" (passa a \"En producció\"); per a ús propi no necessita verificació.';

  @override
  String get cosasQueSuelenFallar => 'Coses que solen fallar:';

  @override
  String get pistaUsuariosPrueba =>
      'Google bloqueja el compte amb el qual has entrat perquè l\'app està en mode \"Prova\" i aquest compte NO és a la llista d\'usuaris de prova. A Google Cloud Console → Google Auth Platform → Públic → \"Usuaris de prova\" → \"Add users\", afegeix aquest correu exacte. O prem \"Publica l\'aplicació\" en aquesta mateixa pantalla.';

  @override
  String get pistaCredencialEscritorio =>
      'El tipus de credencial no és \"Aplicació d\'escriptori\". Torna a crear les credencials OAuth a Google Cloud Console triant \"Aplicació d\'escriptori\".';

  @override
  String get pistaClientIdSecreto =>
      'Client ID o Client Secret incorrectes. Torna a copiar-los de Google Cloud Console (Credencials → el teu client OAuth) i enganxa\'ls sense espais.';

  @override
  String get pistaApisNoActivadas =>
      'Les API de Google Sheets i/o Drive no estan activades al teu projecte. Ves a \"APIs i serveis → Biblioteca\", cerca \"Google Sheets API\" i \"Google Drive API\" i prem Habilita.';

  @override
  String get pistaNavegador =>
      'L\'app no ha pogut obrir el navegador. Tanca aquesta finestra, espera 2 segons i torna-ho a provar.';

  @override
  String get pistaRed =>
      'Problema de xarxa. Comprova que tens connexió a internet i torna-ho a provar.';

  @override
  String get pistaGuardarCredenciales =>
      'No has desat el Client ID i el Client Secret. Omple els camps i prem \"Desa les credencials\" primer.';

  @override
  String get pistaCredencialPorDefecto =>
      'Comprova que el tipus de credencials a Google Cloud Console és \"Aplicació d\'escriptori\" i que el teu correu està afegit com a usuari de prova a la pantalla de consentiment.';

  @override
  String get subirCopiaADrive => 'Puja la còpia a Drive';

  @override
  String get subirCopiaTexto =>
      'Es pujarà una còpia actual al teu Drive com a \"pitwall-backup.zip\". Inclou la base de dades, les fotos de verificacions i la configuració del programa (credencials de Google, tema i preferències); mai la sessió connectada.\n\nSi ja hi havia una versió anterior, es reemplaça per la nova.\n\nContinuar?';

  @override
  String get restaurarTambienConfig =>
      'Restaura també la configuració de la còpia';

  @override
  String get restaurarTambienConfigSub =>
      'Credencials de Google, tema i preferències. Mai la sessió connectada.';

  @override
  String get siRestaurar => 'Sí, restaura';

  @override
  String get descargarYRestaurar => 'Baixa i restaura';

  @override
  String get descargarRestaurarTexto =>
      'Es reemplaçarà la teva base de dades local amb la còpia que hi ha a Drive. ⚠️ Qualsevol canvi local que no hagis pujat es perdrà.\n\nDesprés hauràs de tancar i tornar a obrir l\'app.';

  @override
  String get copiaDePitwall => 'Còpia de PitWall';

  @override
  String get restaurarDesdeArchivo => 'Restaura des d\'un fitxer';

  @override
  String restaurarDesdeArchivoTexto(Object nombre) {
    return 'Es reemplaçarà la teva base de dades local amb la còpia de «$nombre». ⚠️ Qualsevol canvi local que no hagis pujat es perdrà.\n\nPer a això no cal connexió amb Google.\n\nDesprés hauràs de tancar i tornar a obrir l\'app.';
  }

  @override
  String get copiaActualEnDrive => 'Còpia actual a Drive';

  @override
  String get noHayCopiaDriveTexto =>
      'Encara no hi ha cap còpia a Drive. Prem \"Puja la còpia\" per crear la primera.';

  @override
  String ultimaSubida(Object fecha) {
    return 'Darrera pujada: $fecha';
  }

  @override
  String tamanoKB(Object kb) {
    return 'Mida: $kb KB';
  }

  @override
  String get restaurarDesdeArchivoPuntos => 'Restaura des d\'un fitxer…';

  @override
  String get comoTrabajarEnEquipo => 'Com treballar en equip';

  @override
  String get trabajoEnEquipoTexto =>
      '• En començar a treballar, prem \"Baixa\" per tenir la darrera versió.\n• En acabar els teus canvis, prem \"Puja\" perquè els altres els puguin rebre.\n• Si dues persones editen alhora, guanya qui puja l\'últim (no hi ha fusió automàtica). El més pràctic: coordinar qui edita en cada moment.';

  @override
  String get sinConexionGoogle => 'Sense connexió amb Google';

  @override
  String get sinConexionGoogleTexto =>
      'Connecta\'t amb Google per poder pujar o baixar la còpia.\n\nTambé pots restaurar una còpia desada com a fitxer (.zip), sense connexió.';

  @override
  String get importarEquiposDesdeSheets => 'Importa equips des de Sheets';

  @override
  String get importacionEquiposAviso =>
      'A partir d\'ara, prem \"Actualitza des de Drive\" a Equips.';

  @override
  String get conectaCuentaHojas =>
      'Connecta el teu compte una sola vegada per poder llegir els fulls.';

  @override
  String nDeTotal(Object n, Object total) {
    return '$n de $total';
  }

  @override
  String hojaModificada(Object fecha) {
    return 'Modificada: $fecha';
  }

  @override
  String get importarDesdeGoogleSheets => 'Importa des de Google Sheets';

  @override
  String get importacionInscripcionesAviso =>
      'A partir d\'ara, prem \"Actualitza des de Drive\" a Inscrits per portar noves respostes del formulari.';

  @override
  String get conectaCuentaGoogleForm =>
      'Connecta el teu compte una sola vegada per poder llegir els fulls on arriben les respostes del Google Form.';

  @override
  String get diaPreferido => 'Dia preferit';

  @override
  String get asignaAlMenosColumnaPiloto =>
      'Assigna com a mínim la columna del nom del pilot.';

  @override
  String get asignaAlMenosColumnaEquipo =>
      'Assigna com a mínim la columna del nom de l\'equip.';

  @override
  String get importarPilotosDesdeSheets => 'Importa pilots des de Sheets';

  @override
  String get importacionPilotosAviso =>
      'A partir d\'ara, prem \"Actualitza des de Drive\" a Pilots per portar canvis sense haver de tornar a configurar res.';

  @override
  String get detectadasAutomaticamente =>
      'Detectades automàticament. Canvia-les si cal.';

  @override
  String diagLeidas(
    Object columnas,
    Object filas,
    Object piloto,
    Object primera,
  ) {
    return 'Llegides $filas files · $columnas columnes detectades · pilot=$piloto\n1a fila: $primera';
  }

  @override
  String get diagNinguna => '(cap)';

  @override
  String get sinCampeonatoActivoAviso => 'Sense campionat actiu';

  @override
  String get sinPruebaAsignadaVinculo => 'Sense prova assignada al vincle';

  @override
  String resumenPilotosActualizados(Object nuevos, Object saltados, Object ya) {
    return 'Nous: $nuevos · Inscrits al campionat: $ya · Saltats: $saltados';
  }

  @override
  String resumenEquiposActualizados(Object nuevos, Object saltados) {
    return 'Equips nous: $nuevos · Saltats: $saltados';
  }

  @override
  String resumenCatalogoActualizado(
    Object actualizados,
    Object nuevos,
    Object saltados,
  ) {
    return 'Nous: $nuevos · Actualitzats: $actualizados · Sense canvis: $saltados';
  }

  @override
  String resumenFotos(Object n) {
    return ' · Fotos: $n';
  }

  @override
  String resumenFotosFallan(Object detalle, Object n) {
    return ' (fallen $n: $detalle)';
  }

  @override
  String resumenInscripcionesActualizadas(
    Object nuevos,
    Object sin,
    Object ya,
  ) {
    return 'Inscripcions noves: $nuevos · Ja inscrits: $ya · No reconeguts: $sin';
  }

  @override
  String resumenNoReconocidos(Object detalle) {
    return ' ($detalle)';
  }

  @override
  String get noEncuentroCabecera => 'No trobo la capçalera al full.';

  @override
  String get faltanColumnasClaveMapeo =>
      'Falten columnes clau en el mapatge del full. Revisa el vincle (Importa) perquè les columnes quadrin.';

  @override
  String get fotoNuevaSeSube =>
      '(foto nova: es puja a Drive i substitueix l\'enllaç)';

  @override
  String get seSubeFotoADrive => '(es puja la foto a Drive)';

  @override
  String copiaSubida(Object fotos, Object kb) {
    return 'Còpia pujada ($kb KB · $fotos fotos).';
  }

  @override
  String get noHayCopiaEnDrive => 'No hi ha cap còpia a Drive.';

  @override
  String get zipSinBaseDeDatos => 'El ZIP de backup no conté la base de dades.';

  @override
  String get configuracionRestaurada => ' · Configuració restaurada';

  @override
  String get reconectaConGoogle => ' — reconnecta amb Google en reobrir';

  @override
  String copiaConFotos(Object n) {
    return ' · $n fotos';
  }

  @override
  String copiaRestaurada(Object detalle) {
    return 'Còpia restaurada ($detalle). Tanca i torna a obrir l\'app perquè els canvis tinguin efecte.';
  }

  @override
  String get descripcionCopiaDrive =>
      'Còpia de PitWall (BD + fotos de verificacions).';

  @override
  String get authFaltanCredenciales =>
      'Falten les credencials del projecte Google Cloud. Ves a Configuració → Google i enganxa el Client ID i el Client Secret.';

  @override
  String get authNoSePudoAbrirNavegador =>
      'No s\'ha pogut obrir el navegador per autoritzar.';

  @override
  String get authConfiguraCredenciales =>
      'Configura primer les credencials de Google Cloud.';

  @override
  String get authNoConectado => 'No estàs connectat amb Google.';

  @override
  String get authSesionCaducada =>
      'La sessió de Google ha caducat. Torna a connectar el teu compte a Google Sheets (menú lateral).';

  @override
  String get authConexionRevocada =>
      'La connexió amb Google ha caducat o va ser revocada. Ves a Google Sheets (menú lateral) i prem \"Connecta amb Google\" per autoritzar de nou.';

  @override
  String get sinTitulo => 'Sense títol';

  @override
  String get sinNombre => 'Sense nom';

  @override
  String get fotoNoLegible =>
      'el fitxer no és una imatge JPG/PNG/WEBP llegible';

  @override
  String fotoLocalNoEncontrada(Object ruta) {
    return 'no es troba la foto local $ruta';
  }

  @override
  String get versionInstalada => 'Versió instal·lada';

  @override
  String get buscarActualizaciones => 'Cercar actualitzacions';

  @override
  String get estasAlDia => 'Estàs al dia';

  @override
  String get noSePudoComprobarSinConexion =>
      'No s\'ha pogut comprovar (sense connexió?)';

  @override
  String get conexionFallida => 'No s\'ha pogut connectar';

  @override
  String get accionSubir => 'Puja';

  @override
  String errorFilaDetalle(String hoja, int fila, String detalle) {
    return '$hoja fila $fila: $detalle';
  }
}
