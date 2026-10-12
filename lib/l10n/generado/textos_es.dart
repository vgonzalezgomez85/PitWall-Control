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

/// The translations for Spanish Castilian (`es`).
class TextosEs extends Textos {
  TextosEs([String locale = 'es']) : super(locale);

  @override
  String get menuInicio => 'Inicio';

  @override
  String get menuPruebas => 'Pruebas';

  @override
  String get menuParticipantes => 'Participantes';

  @override
  String get menuClasificacion => 'Clasificación';

  @override
  String get menuTesoreria => 'Tesorería';

  @override
  String get menuCreditos => 'Créditos';

  @override
  String get menuVerificacionLibre => 'Verificación libre';

  @override
  String get menuCatalogos => 'Catálogos';

  @override
  String get menuGestionarCampeonatos => 'Gestionar campeonatos';

  @override
  String get menuAjustes => 'Ajustes';

  @override
  String get menuMas => 'Más';

  @override
  String get grupoCampeonato => 'CAMPEONATO';

  @override
  String get grupoHerramientas => 'HERRAMIENTAS';

  @override
  String get grupoCampeonatoActivo => 'CAMPEONATO ACTIVO';

  @override
  String get campeonatoActivo => 'Campeonato activo';

  @override
  String get gestionarCampeonatosPuntos => 'Gestionar campeonatos…';

  @override
  String tooltipCampeonato(String nombre) {
    return 'Campeonato: $nombre';
  }

  @override
  String errorDetalle(String detalle) {
    return 'Error: $detalle';
  }

  @override
  String get vacioTitulo => 'Aún no hay campeonatos';

  @override
  String get vacioTexto =>
      'Crea el primer campeonato para empezar a gestionar pruebas y resultados.';

  @override
  String get crearCampeonato => 'Crear campeonato';

  @override
  String get soloVerificarCoches => 'Solo verificar coches';

  @override
  String get ajustesYCopias => 'Ajustes y copias';

  @override
  String get masOpciones => 'Más opciones';

  @override
  String get statPilotos => 'pilotos';

  @override
  String get statEquipos => 'equipos';

  @override
  String get statPruebas => 'pruebas';

  @override
  String get pendientes => 'Pendientes';

  @override
  String get proximaPrueba => 'Próxima prueba';

  @override
  String get noHayPruebasPendientes => 'No hay pruebas pendientes';

  @override
  String get botonInscritos => 'Inscritos';

  @override
  String get botonVerificar => 'Verificar';

  @override
  String get botonResultados => 'Resultados';

  @override
  String pendVerificaciones(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'verificaciones sin validar',
      one: 'verificación sin validar',
    );
    return '$_temp0';
  }

  @override
  String pendPagos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'pagos sin cobrar',
      one: 'pago sin cobrar',
    );
    return '$_temp0';
  }

  @override
  String pendSinResultados(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'pruebas ya disputadas sin resultados',
      one: 'prueba ya disputada sin resultados',
    );
    return '$_temp0';
  }

  @override
  String get todoAlDia => 'Todo al día';

  @override
  String get todoAlDiaSinPruebas =>
      'No hay pruebas pendientes ni resultados por registrar.';

  @override
  String todoAlDiaEnPrueba(String prueba) {
    return 'Sin verificaciones ni pagos pendientes en $prueba.';
  }

  @override
  String get liderCampeonato => 'Líder del campeonato';

  @override
  String get sinResultadosTodavia => 'Sin resultados todavía';

  @override
  String puntosAbrev(int puntos) {
    return '$puntos pts';
  }

  @override
  String get seccionDatos => 'Datos';

  @override
  String get copiasSeguridad => 'Copias de seguridad';

  @override
  String get copiasSeguridadSub =>
      'Subir o restaurar la copia en Drive, o restaurar desde archivo';

  @override
  String get googleSheetsDrive => 'Google (Sheets y Drive)';

  @override
  String get googleSub =>
      'Conectar la cuenta y las credenciales de Google Cloud';

  @override
  String get plantillasCsv => 'Plantillas CSV';

  @override
  String get plantillasCsvSub =>
      'Descargar plantillas para importar pilotos, equipos…';

  @override
  String get seccionApariencia => 'Apariencia';

  @override
  String get modoOscuro => 'Modo oscuro';

  @override
  String get idioma => 'Idioma';

  @override
  String get idiomaAutomatico => 'Automático (idioma del sistema)';

  @override
  String get seccionAcercaDe => 'Acerca de';

  @override
  String get novedades => 'Novedades';

  @override
  String get historialVersiones => 'Historial de versiones';

  @override
  String versionHistorial(String version) {
    return 'Versión $version · historial de versiones';
  }

  @override
  String get actualizaciones => 'Actualizaciones';

  @override
  String get actualizacionesSub => 'Buscar una versión nueva y descargarla';

  @override
  String get actDescargaIncompleta =>
      'La descarga no llegó completa. Inténtalo otra vez.';

  @override
  String get actDescargaAtascada =>
      'La descarga se ha atascado. Inténtalo otra vez.';

  @override
  String get actNoSePudoDescargar =>
      'No se pudo descargar la actualización. Inténtalo de nuevo o descárgala desde pitwall.es.';

  @override
  String actHayVersionNueva(String version) {
    return 'Hay una versión nueva: v$version';
  }

  @override
  String get actDescargaNueva =>
      'Descarga la nueva versión para tener las últimas mejoras.';

  @override
  String get cancelar => 'Cancelar';

  @override
  String get masTarde => 'Más tarde';

  @override
  String get actPermisoAndroid =>
      'Android pedirá permiso para instalar apps de esta fuente la primera vez. Después, vuelve a pulsar «Actualizar».';

  @override
  String get actSeAbriraNavegador =>
      'Se abrirá el navegador para descargar el instalador de esta versión.';

  @override
  String get actActualizar => 'Actualizar';

  @override
  String get actDescargar => 'Descargar';

  @override
  String get actDescargando => 'Descargando…';

  @override
  String actDescargandoPct(int pct) {
    return 'Descargando… $pct %';
  }

  @override
  String get nuevaPrueba => 'Nueva prueba';

  @override
  String get seleccionaCampeonato => 'Selecciona primero un campeonato';

  @override
  String get aunNoHayPruebas => 'Aún no hay pruebas';

  @override
  String get aunNoHayPruebasTexto =>
      'Crea la primera prueba del campeonato (por ejemplo \"EL SOT\", \"SLOTMANIA\"…).';

  @override
  String get estadoProgramada => 'Programada';

  @override
  String get estadoEnCurso => 'En curso';

  @override
  String get estadoTerminada => 'Terminada';

  @override
  String get estadoCancelada => 'Cancelada';

  @override
  String get resumenVerificaciones => 'Resumen de verificaciones';

  @override
  String get aunNoHayTandas => 'Aún no hay tandas';

  @override
  String get verificarSinTandasTexto =>
      'Inscribe equipos y crea las tandas en la pestaña Preparar.';

  @override
  String validadasDe(int validadas, int total) {
    return '$validadas / $total validadas';
  }

  @override
  String get sinEquiposEnTanda => 'Sin equipos en esta tanda.';

  @override
  String get carreraTienePole => '¿La carrera tiene pole?';

  @override
  String get carreraTienePoleTexto =>
      'Con pole no se exporta el orden de carril: PitWall crea la sesión de pole y la parrilla se asigna tras correrla.';

  @override
  String get sinPole => 'Sin pole';

  @override
  String get conPole => 'Con pole';

  @override
  String get noHayInscritosExportar => 'No hay inscritos que exportar.';

  @override
  String get noHayTandasConCarriles =>
      'No hay tandas con carriles asignados que exportar.';

  @override
  String get importarDelCronometraje => 'Importar del cronometraje';

  @override
  String get traerResultadosPitwall => 'Traer resultados de PitWall';

  @override
  String get prueba => 'Prueba';

  @override
  String get editar => 'Editar';

  @override
  String get pestanaPreparar => 'Preparar';

  @override
  String get pestanaVerificar => 'Verificar';

  @override
  String get pestanaResultados => 'Resultados';

  @override
  String get pestanaCaja => 'Caja';

  @override
  String get nuevaTanda => 'Nueva tanda';

  @override
  String get compartir => 'Compartir';

  @override
  String get pdfTandas => 'PDF de tandas';

  @override
  String get pdfVerificaciones => 'PDF de verificaciones';

  @override
  String get enviarTandasPitwall => 'Enviar tandas a PitWall';

  @override
  String get porWifiSinArchivo => 'Por wifi, sin archivo';

  @override
  String get enviarVerificacionesPitwall => 'Enviar verificaciones a PitWall';

  @override
  String get soloConsultaManager => 'Solo consulta en Manager';

  @override
  String get archivoParaPitwall => 'Archivo para PitWall (JSON)';

  @override
  String get paraImportarAManoManager => 'Para importarlo a mano en Manager';

  @override
  String get noEncontrada => 'No encontrada';

  @override
  String get editarTandas => 'Editar tandas';

  @override
  String get sorteoMotores => 'Sorteo de motores';

  @override
  String get tandas => 'Tandas';

  @override
  String get crearTandasTexto =>
      'Crea las tandas que tendrá esta prueba (Jueves 21:00, Viernes 21:00…).';

  @override
  String pruebaNumero(int orden) {
    return 'Prueba #$orden';
  }

  @override
  String nCarriles(int n) {
    return '$n carriles';
  }

  @override
  String noSePudoGuardar(String detalle) {
    return 'No se pudo guardar: $detalle';
  }

  @override
  String get eliminarPrueba => 'Eliminar prueba';

  @override
  String eliminarPruebaTexto(String nombre) {
    return '¿Eliminar \"$nombre\"?\n\nSe borrarán también sus tandas, inscripciones, resultados y verificaciones. Esta acción no se puede deshacer.';
  }

  @override
  String get eliminar => 'Eliminar';

  @override
  String get editarPrueba => 'Editar prueba';

  @override
  String get nombrePruebaObligatorio => 'Nombre de la prueba *';

  @override
  String get nombrePruebaAyuda => 'Ej: EL SOT, SLOTMANIA, GASCLAVAT…';

  @override
  String get indicaElNombre => 'Indica el nombre';

  @override
  String get sedeClub => 'Sede / club';

  @override
  String get sinFechaAsignada => 'Sin fecha asignada';

  @override
  String get quitarFecha => 'Quitar fecha';

  @override
  String get elegir => 'Elegir';

  @override
  String get cambiar => 'Cambiar';

  @override
  String get ordenCampeonato => 'Orden en el campeonato';

  @override
  String get ordenCampeonatoAyuda => 'Posición en el calendario (1, 2, 3…)';

  @override
  String get numeroEntero => 'Número entero';

  @override
  String get estado => 'Estado';

  @override
  String get crearPrueba => 'Crear prueba';

  @override
  String get guardarCambios => 'Guardar cambios';

  @override
  String get eliminarTanda => 'Eliminar tanda';

  @override
  String eliminarTandaTexto(String nombre) {
    return '¿Eliminar la tanda \"$nombre\"? Se borrarán también las inscripciones, resultados y verificaciones de la tanda.';
  }

  @override
  String get editarTanda => 'Editar tanda';

  @override
  String get nombreTandaObligatorio => 'Nombre de la tanda *';

  @override
  String get nombreTandaAyuda => 'Ej: Jueves 21:00, Viernes 23:00…';

  @override
  String get sinFechaHora => 'Sin fecha y hora asignadas';

  @override
  String get quitar => 'Quitar';

  @override
  String get numeroCarriles => 'Número de carriles';

  @override
  String get numeroCarrilesAyuda => 'Habitualmente 6, 7 u 8 (hasta 32)';

  @override
  String get numeroCarrilesError => 'Indica un número entre 1 y 32';

  @override
  String get pisters => 'Pisters';

  @override
  String get pistersAyuda => 'Tanda cuyos pilotos hacen de pisters en esta';

  @override
  String get sinPisters => '— sin pisters —';

  @override
  String pilotosDe(String nombre) {
    return 'Pilotos de $nombre';
  }

  @override
  String get crearTanda => 'Crear tanda';

  @override
  String get pruebaSinTandas => 'Esta prueba no tiene tandas todavía';

  @override
  String get generaTandasDesdeInscritos =>
      'Genéralas desde Inscritos → Generar tandas.';

  @override
  String get tocaEquipoParaMover => 'Toca un equipo para moverlo a otra tanda.';

  @override
  String nEquiposAbrev(int n) {
    return '$n eq.';
  }

  @override
  String get sinEquipos => 'Sin equipos';

  @override
  String moverEquipoA(String nombre) {
    return 'Mover \"$nombre\" a…';
  }

  @override
  String tandaConEquipos(String nombre, int n) {
    return '$nombre  ($n eq.)';
  }

  @override
  String get darDeBajaPrueba => 'Dar de baja de la prueba';

  @override
  String get eligePitwall => 'Elige un PitWall o escribe su dirección.';

  @override
  String get noHayInscritosEnviar => 'No hay inscritos que enviar.';

  @override
  String get noHayTandasEnviar =>
      'No hay tandas con carriles asignados que enviar.';

  @override
  String get enviarAPitwall => 'Enviar a PitWall';

  @override
  String get pinImportacion => 'PIN de importación';

  @override
  String get pinImportacionAyuda =>
      'El PIN que muestra PitWall en «Importar tanda».';

  @override
  String get carreraTienePoleSi => 'La carrera tiene pole';

  @override
  String get carreraTienePoleAyuda =>
      'No se envía el orden de carril: la parrilla se asigna en PitWall tras la pole';

  @override
  String get enviar => 'Enviar';

  @override
  String get pitwallEnLaRed => 'PitWall en la red';

  @override
  String get buscarDeNuevo => 'Buscar de nuevo';

  @override
  String get buscandoPitwall => 'Buscando PitWall en la red local…';

  @override
  String get noSeEncuentraPitwall =>
      'No se ha encontrado ningún PitWall. Comprueba que está abierto y en la misma red Wi‑Fi, o escribe su dirección abajo.';

  @override
  String get direccionIpPuerto => 'Dirección (IP:puerto)';

  @override
  String get resultadosDeLaTanda => 'Resultados de la tanda';

  @override
  String get noHayEquiposEnTanda => 'No hay equipos en esta tanda';

  @override
  String get inscribeEquiposParaResultados =>
      'Inscribe equipos para poder registrar sus resultados.';

  @override
  String get indicaPosicionFinalTexto =>
      'Indica la posición final de cada equipo. Los puntos se calculan solos según la tabla del campeonato.';

  @override
  String get puntos => 'puntos';

  @override
  String get posicion => 'Posición';

  @override
  String get sinAsignar => 'Sin asignar';

  @override
  String get aRestar => 'A restar';

  @override
  String get creditosMin => 'créditos';

  @override
  String get noHayInscritosEnPrueba => 'No hay inscritos en esta prueba';

  @override
  String get inscribeEquiposGeneraTandas =>
      'Inscribe equipos y genera las tandas. Luego podrás importar los resultados del cronometraje aquí.';

  @override
  String equiposConResultado(int con, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total equipos',
      one: '1 equipo',
    );
    return '$con de $_temp0 con resultado registrado.';
  }

  @override
  String get resultadosDeLaPrueba => 'Resultados de la prueba';

  @override
  String get importarDesdeArchivoCronometraje =>
      'Importar desde archivo de cronometraje';

  @override
  String copaYManga(String copa, String manga) {
    return 'Copa $copa  ·  $manga';
  }

  @override
  String get posAbrev => 'Pos.';

  @override
  String get archivos => 'Archivos';

  @override
  String get noSeEncontraronResultados =>
      'No se encontraron resultados. El archivo debe tener columnas como \"Posición\" y \"Nombre\" (formato TicTacSlot o similar).';

  @override
  String noSePudoLeerArchivo(String detalle) {
    return 'No se pudo leer el archivo: $detalle';
  }

  @override
  String get importacionCompletada => 'Importación completada';

  @override
  String resumenImportacionResultados(int ok, int inscritos, int saltados) {
    return '✓ Resultados aplicados: $ok\n+ Inscritos automáticamente: $inscritos\n✗ Saltados: $saltados';
  }

  @override
  String get ok => 'OK';

  @override
  String get importarResultadosPrueba => 'Importar resultados de la prueba';

  @override
  String get paso1EligeArchivo => '1. Elige el archivo';

  @override
  String get importaArchivoTexto =>
      'Importa el archivo del sistema de cronometraje (TicTacSlot, SloTime…). Cada equipo del archivo se asigna a la tanda de esta prueba donde esté inscrito.';

  @override
  String get elegirArchivo => 'Elegir archivo';

  @override
  String get resultadosGenerales => 'Resultados generales';

  @override
  String get crearTandaResultadosGenerales =>
      'Crear tanda \"Resultados generales\"';

  @override
  String get pruebaSinTandasAviso =>
      'La prueba no tiene tandas aún. Marcamos los resultados en una tanda creada al vuelo.';

  @override
  String get paso2VistaPrevia => '2. Vista previa';

  @override
  String nDeTotalSeAplicaran(int n, int total) {
    return '$n de $total se aplicarán';
  }

  @override
  String equiposNoExistenAviso(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '⚠️ $n equipos del archivo no existen en el campeonato.',
      one: '⚠️ 1 equipo del archivo no existe en el campeonato.',
    );
    return '$_temp0';
  }

  @override
  String aplicarResultadosA(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n equipos',
      one: '1 equipo',
    );
    return 'Aplicar resultados a $_temp0';
  }

  @override
  String get noExiste => 'No existe';

  @override
  String get seInscribira => 'Se inscribirá';

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
      other: '$n vueltas',
      one: '1 vuelta',
    );
    return '$_temp0';
  }

  @override
  String formatoNoSoportado(String ext) {
    return 'Formato no soportado: $ext';
  }

  @override
  String get sortearRestantes => 'Sortear restantes';

  @override
  String get pruebaNoEncontrada => 'Prueba no encontrada';

  @override
  String get noHayEquiposInscritosTandas =>
      'No hay equipos inscritos en las tandas de esta prueba.';

  @override
  String sorteoBloqueadoTexto(String motivo) {
    return '$motivo El sorteo queda en solo lectura.';
  }

  @override
  String get equipos => 'Equipos';

  @override
  String get numeros => 'Números';

  @override
  String get noQuedanMotores => 'No quedan motores disponibles.';

  @override
  String get motorSorteado => 'Motor sorteado';

  @override
  String get repetir => 'Repetir';

  @override
  String get asignar => 'Asignar';

  @override
  String faltanMotores(int equipos, int motores) {
    return 'Faltan motores: $equipos equipos y solo $motores motores disponibles.';
  }

  @override
  String motoresRango(int min, int max) {
    return 'Motores $min–$max';
  }

  @override
  String asignadosDe(int asignados, int total) {
    return '$asignados/$total asignados';
  }

  @override
  String disponiblesN(int n) {
    return '$n disponibles';
  }

  @override
  String get sortear => 'Sortear';

  @override
  String numeroMotor(int n) {
    return 'Nº $n';
  }

  @override
  String get volverASortear => 'Volver a sortear';

  @override
  String get quitarMotor => 'Quitar motor';

  @override
  String get faltaRangoMotores => 'Falta configurar el rango de motores';

  @override
  String get faltaRangoMotoresTexto =>
      'Define el rango de números de motor de organización en el campeonato para poder sortearlos.';

  @override
  String get configurarCampeonato => 'Configurar campeonato';

  @override
  String get rangoMotoresNoConfigurado => 'Rango de motores no configurado.';

  @override
  String get asignado => 'Asignado';

  @override
  String get disponible => 'Disponible';

  @override
  String get tanda => 'Tanda';

  @override
  String get verificaciones => 'Verificaciones';

  @override
  String get renumerarCarriles => 'Renumerar carriles';

  @override
  String get renumerar => 'Renumerar';

  @override
  String renumerarCarrilesTexto(String nombre, int carriles) {
    return 'Se vuelven a asignar todos los carriles de \"$nombre\" por puntos, de más a menos: 1 a $carriles y, si hay más pilotos, D1, D2… Se pierden los cambios hechos a mano.';
  }

  @override
  String get inscribirEquipo => 'Inscribir equipo';

  @override
  String get aunNoHayEquiposInscritos => 'Aún no hay equipos inscritos';

  @override
  String get pulsaInscribirEquipo =>
      'Pulsa \"Inscribir equipo\" para añadirlos uno a uno asignando carril de salida.';

  @override
  String sinCarrilN(int n) {
    return 'Sin carril ($n)';
  }

  @override
  String get actual => 'actual';

  @override
  String get libre => 'libre';

  @override
  String get libreTitulo => 'Libre';

  @override
  String carrilDe(String nombre) {
    return 'Carril de $nombre';
  }

  @override
  String get tocaCarrilLibreTexto =>
      'Toca un carril libre para moverlo, o uno ocupado para intercambiarlos.';

  @override
  String get pista => 'Pista';

  @override
  String get descanso => 'Descanso';

  @override
  String get seedDirecto => 'Seed directo';

  @override
  String get sinCarril => 'Sin carril';

  @override
  String get escribirAMano => 'Escribir a mano…';

  @override
  String get carrilDeSalida => 'Carril de salida';

  @override
  String get carrilEjemplo => 'Ej: D1, D2, 1, 2, 3…';

  @override
  String get carrilAyuda => 'D1-D4 para seeds directos, 1-N para sorteo';

  @override
  String get guardar => 'Guardar';

  @override
  String quienSaleEnCarril(String carril) {
    return '¿Quién sale en el carril $carril?';
  }

  @override
  String dejaLibreEl(String carril) {
    return 'Deja libre el $carril';
  }

  @override
  String get carrilesRepetidos => 'Carriles repetidos';

  @override
  String pistersPilotosDe(String tanda) {
    return 'Pisters: pilotos de $tanda';
  }

  @override
  String get cambiarCarril => 'Cambiar carril';

  @override
  String get quitarSeedDirecto => 'Quitar seed directo';

  @override
  String get marcarSeedDirecto => 'Marcar como seed directo';

  @override
  String get quitarDeLaTanda => 'Quitar de la tanda';

  @override
  String get quitarInscripcion => 'Quitar inscripción';

  @override
  String quitarInscripcionTexto(String nombre) {
    return '¿Quitar a \"$nombre\" de esta tanda?';
  }

  @override
  String inscribirEquipoEn(String nombre) {
    return 'Inscribir equipo en \"$nombre\"';
  }

  @override
  String get buscarEquipoOPiloto => 'Buscar equipo o piloto…';

  @override
  String get noHayEquiposEnCampeonatoCrealos =>
      'No hay equipos en este campeonato. Créalos primero.';

  @override
  String get todosLosEquiposYaInscritos =>
      'Todos los equipos ya están inscritos.';

  @override
  String get inscribir => 'Inscribir';

  @override
  String get carrilEjemploCorto => 'Ej: D1, 3…';

  @override
  String get carrilAyudaVacio => 'Deja vacío si aún no asignas carril';

  @override
  String get inscritosALaPrueba => 'Inscritos a la prueba';

  @override
  String get actualizarDesdeDrive => 'Actualizar desde Drive';

  @override
  String get actualizandoDesdeDrive => 'Actualizando desde Drive…';

  @override
  String get anadirPiloto => 'Añadir piloto';

  @override
  String get anadirEquipo => 'Añadir equipo';

  @override
  String get importar => 'Importar';

  @override
  String get vincularGoogleSheet => 'Vincular Google Sheet';

  @override
  String get desdeArchivoCsvExcel => 'Desde archivo CSV / Excel';

  @override
  String get generarTandas => 'Generar tandas';

  @override
  String get aunNoHayPilotosInscritosPrueba =>
      'Aún no hay pilotos inscritos a esta prueba';

  @override
  String get aunNoHayEquiposInscritosPrueba =>
      'Aún no hay equipos inscritos a esta prueba';

  @override
  String get importaCsvGoogleFormPilotos =>
      'Importa el CSV/Excel del Google Form o añade pilotos a mano.';

  @override
  String get importaCsvGoogleFormEquipos =>
      'Importa el CSV/Excel del Google Form o añade equipos a mano.';

  @override
  String get importarCsvExcel => 'Importar CSV/Excel';

  @override
  String get anadirAMano => 'Añadir a mano';

  @override
  String pilotosInscritosGenerarTandas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '$n pilotos inscritos. Cuando los tengas todos, pulsa \"Generar tandas\".',
      one:
          '1 piloto inscrito. Cuando los tengas todos, pulsa \"Generar tandas\".',
    );
    return '$_temp0';
  }

  @override
  String equiposInscritosGenerarTandas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '$n equipos inscritos. Cuando los tengas todos, pulsa \"Generar tandas\".',
      one:
          '1 equipo inscrito. Cuando los tengas todos, pulsa \"Generar tandas\".',
    );
    return '$_temp0';
  }

  @override
  String get darDeBaja => 'Dar de baja';

  @override
  String darDeBajaTexto(String nombre) {
    return '¿Dar de baja a \"$nombre\"?\n\nSe quita de Inscritos y de su tanda. Los carriles del resto no cambian: si hace falta, renumera la tanda después.';
  }

  @override
  String get inscribirPilotos => 'Inscribir pilotos';

  @override
  String get inscribirEquipos => 'Inscribir equipos';

  @override
  String nSeleccionados(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n seleccionados',
      one: '1 seleccionado',
    );
    return '$_temp0';
  }

  @override
  String get limpiar => 'Limpiar';

  @override
  String get buscarPiloto => 'Buscar piloto…';

  @override
  String get noHayPilotosEnCampeonato => 'No hay pilotos en este campeonato.';

  @override
  String get noHayEquiposEnCampeonato => 'No hay equipos en este campeonato.';

  @override
  String get todosYaInscritos => 'Todos están ya inscritos.';

  @override
  String get nuevaInscripcion => 'Nueva inscripción';

  @override
  String get nuevoEquipo => 'Nuevo equipo';

  @override
  String get copaParaPilotosNuevos => 'Copa para pilotos nuevos:';

  @override
  String get desmarcarTodos => 'Desmarcar todos';

  @override
  String marcarTodosN(int n) {
    return 'Marcar todos ($n)';
  }

  @override
  String nuevaInscripcionCopa(String copa) {
    return 'Nueva inscripción · Copa $copa';
  }

  @override
  String get marcaPilotosInscribir => 'Marca los pilotos que quieras inscribir';

  @override
  String get marcaEquiposInscribir => 'Marca los equipos que quieras inscribir';

  @override
  String inscribirNPilotos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pilotos',
      one: '1 piloto',
    );
    return 'Inscribir $_temp0';
  }

  @override
  String inscribirNEquipos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n equipos',
      one: '1 equipo',
    );
    return 'Inscribir $_temp0';
  }

  @override
  String get importarInscripciones => 'Importar inscripciones';

  @override
  String get csvGoogleFormInscripcionPilotos =>
      'CSV/Excel del Google Form de inscripción a la prueba. Las inscripciones se vinculan a pilotos existentes por nombre.';

  @override
  String get csvGoogleFormInscripcionEquipos =>
      'CSV/Excel del Google Form de inscripción a la prueba. Las inscripciones se vinculan a equipos existentes por nombre.';

  @override
  String get paso2AsignaColumnas => '2. Asigna columnas';

  @override
  String get nombreDelPilotoObligatorio => 'Nombre del piloto *';

  @override
  String get nombreDelEquipoObligatorio => 'Nombre del equipo *';

  @override
  String get diaPreferidoOpcional => 'Día preferido (opcional)';

  @override
  String get notasOpcional => 'Notas (opcional)';

  @override
  String get paso3VistaPrevia => '3. Vista previa';

  @override
  String nDeTotalSeImportaran(int n, int total) {
    return '$n de $total se importarán';
  }

  @override
  String pilotosNoExistenAviso(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '⚠️ $n pilotos no existen en el campeonato. Créalos primero o revisa el nombre.',
      one:
          '⚠️ 1 piloto no existe en el campeonato. Créalo primero o revisa el nombre.',
    );
    return '$_temp0';
  }

  @override
  String equiposNoExistenAvisoImport(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '⚠️ $n equipos no existen en el campeonato. Créalos primero o revisa el nombre.',
      one:
          '⚠️ 1 equipo no existe en el campeonato. Créalo primero o revisa el nombre.',
    );
    return '$_temp0';
  }

  @override
  String get asignaColumnaPiloto => 'Asigna la columna del nombre del piloto.';

  @override
  String get asignaColumnaEquipo => 'Asigna la columna del nombre del equipo.';

  @override
  String get ninguna => '— ninguna —';

  @override
  String get yaInscrito => 'Ya inscrito';

  @override
  String diaTexto(String dia) {
    return 'Día: $dia';
  }

  @override
  String noSePudoLeer(String detalle) {
    return 'No se pudo leer: $detalle';
  }

  @override
  String resumenImportacionInscripciones(int ok, int saltados) {
    return '✓ Inscritos: $ok\n✗ Saltados: $saltados';
  }

  @override
  String tandaNumero(int n) {
    return 'Tanda $n';
  }

  @override
  String get tandasCreadas => 'Tandas creadas';

  @override
  String tandasCreadasTexto(int n, int equipos) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Se han creado $n tandas con $equipos equipos.',
      one: 'Se ha creado 1 tanda con $equipos equipos.',
    );
    return '$_temp0';
  }

  @override
  String get conCarrilAsignado => 'Con carril de salida asignado.';

  @override
  String get carrilesSeAsignaranAntes =>
      'Los carriles se asignarán antes de la carrera.';

  @override
  String get pistersAsignadosEntreTandas =>
      'Pisters asignados entre las tandas de cada día.';

  @override
  String equiposInscritosARepartir(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n equipos inscritos a repartir',
      one: '1 equipo inscrito a repartir',
    );
    return '$_temp0';
  }

  @override
  String get ordenadosPorPuntos => 'Ordenados por puntos brutos acumulados.';

  @override
  String get sinPuntosEsteAnio =>
      'Sin puntos este año → ordenados por saldo año anterior (0 si no hay).';

  @override
  String get paso1CarrilesPista => '1. Carriles de la pista';

  @override
  String get paso1CarrilesTexto =>
      'Cuántos coches corren a la vez. Marca el máximo de equipos por tanda para repartirlos bien.';

  @override
  String get carrilesMin => 'carriles';

  @override
  String get minutosPorCarrilTexto =>
      'Minutos por carril (cuánto dura el turno de un equipo en cada carril, para calcular la duración de la tanda).';

  @override
  String get minPorCarril => 'min/carril';

  @override
  String cadaTandaDurara(int minutos, int carriles, int minPorCarril) {
    return 'Cada tanda durará ~$minutos min ($carriles carriles × $minPorCarril min).';
  }

  @override
  String get paso2NumeroTandas => '2. Número de tandas';

  @override
  String sugeridoTexto(int n, int carriles) {
    return 'Sugerido: $n (sin carriles vacíos con $carriles carriles: si sobran equipos, las tandas pasan de $carriles). Puedes cambiarlo.';
  }

  @override
  String get paso3NombresHorarios => '3. Nombres y horarios';

  @override
  String get asignarCarrilAutomatico => 'Asignar carril automáticamente';

  @override
  String asignarCarrilTexto(int carriles) {
    return 'Por puntos, de más a menos: carriles 1 a $carriles y, si hay más pilotos, D1, D2…';
  }

  @override
  String get asignarPisters => 'Asignar pisters';

  @override
  String get asignarPistersTexto =>
      'Entre las tandas del mismo día. 2 tandas: 1ª↔2ª. 3: la 3ª hace de pisters en la 1ª, la 1ª en la 2ª y la 2ª en la 3ª. 4: 1ª↔2ª y 3ª↔4ª.';

  @override
  String get paso4VistaPrevia => '4. Vista previa';

  @override
  String get numeroIzquierdaCarril =>
      'El número de la izquierda es el carril de salida.';

  @override
  String get carrilesLosAsignarasDespues =>
      'Los carriles los asignarás después, antes de la carrera.';

  @override
  String sinTandaN(int n) {
    return 'Sin tanda ($n)';
  }

  @override
  String get sinTandaTexto =>
      'Estos equipos prefieren un día que no tiene ninguna tanda en este reparto. Añade una tanda de ese día arriba o cambia su preferencia.';

  @override
  String prefiereDia(String dia) {
    return 'Prefiere: $dia';
  }

  @override
  String get sustituirTandasExistentes => 'Sustituir tandas existentes';

  @override
  String get sustituirTandasTexto =>
      'Si esta prueba ya tenía tandas, se eliminan y se reemplazan.';

  @override
  String get crearEstasTandas => 'Crear estas tandas';

  @override
  String get eligeLaCarrera => 'Elige la carrera';

  @override
  String get verCarreras => 'Ver carreras';

  @override
  String resultadosDeCarrera(String nombre) {
    return 'Resultados: $nombre';
  }

  @override
  String noSePudoConectar(String detalle) {
    return 'No se pudo conectar: $detalle';
  }

  @override
  String noSePudieronTraerResultados(String detalle) {
    return 'No se pudieron traer los resultados: $detalle';
  }

  @override
  String get noHayCampeonatoActivo => 'No hay campeonato activo.';

  @override
  String resultadosAplicadosSaltados(int ok, int saltados) {
    return 'Resultados aplicados: $ok · saltados: $saltados';
  }

  @override
  String errorAlAplicar(String detalle) {
    return 'Error al aplicar: $detalle';
  }

  @override
  String get pitwallNoTieneCarreras => 'PitWall no tiene carreras.';

  @override
  String get pitwallNoTieneCarrerasEnvia =>
      'PitWall no tiene carreras. Envía antes una tanda («Enviar a PitWall») o crea la carrera en Manager.';

  @override
  String tandasDeCarrera(int n) {
    return '$n tanda(s)';
  }

  @override
  String get laCarreraNoTieneResultados =>
      'La carrera no tiene resultados todavía.';

  @override
  String get equipoNoEncontradoCampeonato =>
      'Equipo no encontrado en el campeonato';

  @override
  String get noInscritoEnEstaPrueba => 'No inscrito en esta prueba';

  @override
  String seAplicaraPosicion(int posicion) {
    return 'se aplicará posición $posicion';
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
      'Se envían a modo de consulta: en PitWall se podrán ver pero no editar.';

  @override
  String get atras => 'Atrás';

  @override
  String get noHayVerificacionesEnviar =>
      'No hay verificaciones que enviar en esta prueba.';

  @override
  String copaDosPuntos(String copa) {
    return 'Copa: $copa';
  }

  @override
  String get aunNoHayEquiposEnEstaTanda => 'Aún no hay equipos en esta tanda';

  @override
  String get inscribeEquiposVerificacion =>
      'Inscribe equipos en la tanda para poder hacerles la verificación.';

  @override
  String nConVerificacion(int n) {
    return '$n con verificación';
  }

  @override
  String nValidadas(int n) {
    return '$n validadas';
  }

  @override
  String get quitarParticipante => 'Quitar participante';

  @override
  String quitarConVerificacionTexto(String nombre) {
    return 'Se quitará \"$nombre\" y se borrará su verificación. ¿Continuar?';
  }

  @override
  String quitarSinVerificacionTexto(String nombre) {
    return 'Se quitará \"$nombre\". ¿Continuar?';
  }

  @override
  String get validada => 'Validada';

  @override
  String get borrador => 'Borrador';

  @override
  String get enRevision => 'En revisión';

  @override
  String get pendiente => 'Pendiente';

  @override
  String get sinCocheAsignado => 'Sin coche asignado';

  @override
  String get sesionCerrada => 'La sesión está cerrada.';

  @override
  String get campeonatoFinalizado => 'El campeonato está finalizado.';

  @override
  String get pruebaTerminada => 'La prueba está terminada.';

  @override
  String get exportar => 'Exportar';

  @override
  String get exportarPdf => 'Exportar a PDF';

  @override
  String get exportarExcel => 'Exportar a Excel';

  @override
  String get noHayPruebasEnCampeonato => 'No hay pruebas en este campeonato.';

  @override
  String get noHayInscritosNiVerificaciones =>
      'No hay inscritos ni verificaciones en esta prueba.';

  @override
  String get buscarPilotoEquipoCopa => 'Buscar piloto, equipo, copa…';

  @override
  String filtroTodos(int n) {
    return 'Todos ($n)';
  }

  @override
  String filtroConInfraccion(int n) {
    return 'Con infracción ($n)';
  }

  @override
  String filtroSinVerificar(int n) {
    return 'Sin verificar ($n)';
  }

  @override
  String filtroBorrador(int n) {
    return 'Borrador ($n)';
  }

  @override
  String validadasDeTotal(int validadas, int total) {
    return '$validadas validadas de $total';
  }

  @override
  String get nadaConEsteFiltro => 'Nada que mostrar con este filtro.';

  @override
  String get colPilotoEquipo => 'Piloto / equipo';

  @override
  String get fueraDeReglamento => 'Fuera de reglamento';

  @override
  String get copa => 'Copa';

  @override
  String get coche => 'Coche';

  @override
  String get colPesoCarroc => 'Peso carroc.';

  @override
  String get colPesoMin => 'Peso mín.';

  @override
  String get colPesoCoche => 'Peso coche';

  @override
  String get motor => 'Motor';

  @override
  String get alturaMotor => 'Altura motor';

  @override
  String get colEjeDel => 'Eje del.';

  @override
  String get colEjeTras => 'Eje tras.';

  @override
  String get pinon => 'Piñón';

  @override
  String get corona => 'Corona';

  @override
  String get llantaDelantera => 'Llanta delantera';

  @override
  String get llantaTrasera => 'Llanta trasera';

  @override
  String get trencilla => 'Trencilla';

  @override
  String get suspension => 'Suspensión';

  @override
  String get bancada => 'Bancada';

  @override
  String get chasis => 'Chasis';

  @override
  String get neumatico => 'Neumático';

  @override
  String get carroceria => 'Carrocería';

  @override
  String get observaciones => 'Observaciones';

  @override
  String get sinVerificar => 'Sin verificar';

  @override
  String get propio => 'Propio';

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
  String get bien => 'Bien';

  @override
  String get faltanPiezas => 'Faltan piezas';

  @override
  String faltanPiezasDetalle(String piezas) {
    return 'Faltan: $piezas';
  }

  @override
  String marcaNoPermitida(String marca) {
    return 'Marca \"$marca\" no permitida';
  }

  @override
  String superaMaximoMm(String maximo) {
    return 'Supera el máximo de $maximo mm';
  }

  @override
  String porDebajoMinimoG(String minimo) {
    return 'Por debajo del mínimo de $minimo g';
  }

  @override
  String get alturaMotorNoConforme => 'Altura de motor no conforme';

  @override
  String get leFaltanPiezas => 'Le faltan piezas';

  @override
  String vPesoInicialBajo(String valor, String minimo) {
    return 'Peso inicial ${valor}g por debajo del mínimo ${minimo}g.';
  }

  @override
  String vPesoFinalBajo(String valor, String minimo) {
    return 'Peso final ${valor}g por debajo del mínimo ${minimo}g.';
  }

  @override
  String get vMotorSinCatalogo =>
      'Selecciona el motor del catálogo para comprobar las medidas.';

  @override
  String vMotorRpmAlto(String motor, String max, String medido) {
    return 'RPM por encima de la referencia del $motor (máx $max, medidas $medido).';
  }

  @override
  String vMotorUmsAlto(String motor, String max, String medido) {
    return 'Imán por encima de la referencia del $motor (máx $max, medido $medido).';
  }

  @override
  String get vAlturaNoConforme => 'Altura de motor no conforme: toca la pista.';

  @override
  String vEjeDelAncho(String medido, String max) {
    return 'Anchura de eje delantero $medido mm por encima del máximo $max mm.';
  }

  @override
  String vEjeTraAncho(String medido, String max) {
    return 'Anchura de eje trasero $medido mm por encima del máximo $max mm.';
  }

  @override
  String vMarcaNoPermitidaLista(String marca, String lista) {
    return 'Marca \"$marca\" no permitida (solo $lista).';
  }

  @override
  String vMarcaFueraCatalogo(String marca) {
    return 'Marca \"$marca\" no está en el catálogo.';
  }

  @override
  String vLlantaDelNoCatalogada(String valor) {
    return 'Llanta delantera no catalogada: \"$valor\".';
  }

  @override
  String vLlantaTraNoCatalogada(String valor) {
    return 'Llanta trasera no catalogada: \"$valor\".';
  }

  @override
  String vBancadaNoCatalogada(String valor) {
    return 'Bancada no catalogada: \"$valor\".';
  }

  @override
  String vNeumaticoNoCatalogado(String valor) {
    return 'Neumático no catalogado: \"$valor\".';
  }

  @override
  String vBalanceNegativo(String equipo, String coche, String balance) {
    return 'Balance de créditos negativo: equipo $equipo + coche $coche = $balance.';
  }

  @override
  String get noSePudoGenerarExcel => 'No se pudo generar el Excel.';

  @override
  String get buscarPuntos => 'Buscar…';

  @override
  String sinResultadosPara(String filtro) {
    return 'Sin resultados para \"$filtro\"';
  }

  @override
  String get sinAsignarGuiones => '— sin asignar —';

  @override
  String get sorteoEtiqueta => 'Sorteo';

  @override
  String get mixto => 'Mixto';

  @override
  String get limitarFabricante => 'Limitar fabricante';

  @override
  String noCatalogada(String nombre) {
    return '$nombre (no catalogada)';
  }

  @override
  String get imagenNoSePuedeLeer =>
      'No se puede leer esa imagen. Usa un PNG o JPG.';

  @override
  String noSePudoAnadirLogo(String detalle) {
    return 'No se pudo añadir el logo: $detalle';
  }

  @override
  String get elegirLogo => 'Elegir logo';

  @override
  String get cambiarLogo => 'Cambiar logo';

  @override
  String get repartir => 'Repartir';

  @override
  String get configuraRangoSesion =>
      'Configura el rango de motores en el reglamento de la sesión para sortear.';

  @override
  String get configuraRangoCampeonato =>
      'Configura el rango de motores en el campeonato para sortear.';

  @override
  String get sorteoDeMotor => 'Sorteo de motor';

  @override
  String get otroControl => 'Otro Control';

  @override
  String cambiadaFueraTexto(String quien) {
    return '$quien ha cambiado esta verificación. Si sigues editando, tus cambios sustituirán a los suyos.';
  }

  @override
  String get seguirConLoMio => 'Seguir con lo mío';

  @override
  String verLoDe(String quien) {
    return 'Ver lo de $quien';
  }

  @override
  String actualizadaConCambios(String quien) {
    return 'Actualizada con los cambios de $quien.';
  }

  @override
  String noSePudoAnadirFoto(String detalle) {
    return 'No se pudo añadir la foto: $detalle';
  }

  @override
  String get copaEnEstaPrueba => 'Copa en esta prueba';

  @override
  String get copaEnEstaPruebaTexto =>
      'Cambia la copa solo para esta prueba, sin afectar al equipo ni a otras pruebas.';

  @override
  String get copaCategoria => 'Copa / categoría';

  @override
  String copaDelEquipo(String copa) {
    return 'Copa del equipo: $copa';
  }

  @override
  String get usarLaDelEquipo => 'Usar la del equipo';

  @override
  String get usarReglamentoActual => 'Usar el reglamento actual';

  @override
  String get usarReglamentoActualTexto =>
      'Esta verificación se comprobará con los valores de hoy del catálogo y del campeonato en lugar de con los que tenía al verificarla:';

  @override
  String get recalcularanCreditos =>
      'Como está validada, se recalcularán sus créditos.';

  @override
  String get usarElActual => 'Usar el actual';

  @override
  String get desbloquearVerificacion => 'Desbloquear la verificación';

  @override
  String desbloquearTexto(String motivo) {
    return '$motivo Sus verificaciones están bloqueadas para no cambiarlas sin querer.\n\nSi la desbloqueas, los cambios se guardarán como siempre. Seguirá comprobándose con el reglamento con el que se verificó.';
  }

  @override
  String get desbloquear => 'Desbloquear';

  @override
  String get verificacion => 'Verificación';

  @override
  String get eliminarVerificacion => 'Eliminar verificación';

  @override
  String get eliminarVerificacionTexto =>
      'Se perderán los datos introducidos. ¿Continuar?';

  @override
  String get modeloCoche => 'Modelo de coche';

  @override
  String get elegirCoche => 'Elegir coche';

  @override
  String noHayCochesConCopa(String copa) {
    return 'No hay coches con la copa $copa en el catálogo';
  }

  @override
  String get ayudaSelectorCoche =>
      'Se muestran peso mínimo y créditos del coche al elegirlo';

  @override
  String get creditosAbrev => 'créd';

  @override
  String get pesoGramos => 'Peso (gramos)';

  @override
  String get pesoCarroceria => 'Peso carrocería';

  @override
  String minimoG(String n) {
    return 'Mínimo: ${n}g';
  }

  @override
  String get estetica => 'Estética';

  @override
  String get sinComprobar => 'Sin comprobar';

  @override
  String get quePiezasFaltan => 'Qué piezas le faltan';

  @override
  String get organizacion => 'Organización';

  @override
  String get numeroDeMotor => 'Número de motor';

  @override
  String get motorDelCatalogo => 'Motor del catálogo';

  @override
  String get elegirMotor => 'Elegir motor';

  @override
  String yaNoEnCatalogo(String nombre) {
    return '$nombre (ya no está en el catálogo)';
  }

  @override
  String refMotor(String rpm, String gauss) {
    return 'Ref: $rpm RPM · $gauss gauss';
  }

  @override
  String motoresHomologadosCopa(String copa) {
    return 'Motores homologados para la copa $copa';
  }

  @override
  String rpmYGauss(String rpm, String gauss) {
    return '$rpm RPM · $gauss gauss';
  }

  @override
  String maxN(String n) {
    return 'Máx $n';
  }

  @override
  String get alturaMotorAPista => 'Altura de motor a pista';

  @override
  String get alturaMotorTexto =>
      'Comprobación con la plancha: si toca la pista, no conforme.';

  @override
  String get delantero => 'Delantero';

  @override
  String get trasero => 'Trasero';

  @override
  String get marca => 'Marca';

  @override
  String get dimension => 'Dimensión';

  @override
  String get dientes => 'Dientes';

  @override
  String get diametro => 'Diámetro';

  @override
  String get material => 'Material';

  @override
  String get pesoCocheEntero => 'Peso coche entero (gramos)';

  @override
  String get inicial => 'Inicial';

  @override
  String get cocheEntero => 'Coche entero';

  @override
  String get otros => 'Otros';

  @override
  String get notasOAvisos => 'Notas o avisos';

  @override
  String get fotosHasta4 => 'Fotos (hasta 4)';

  @override
  String get marcarComoValidada => 'Marcar como validada';

  @override
  String get marcarComoValidadaTexto =>
      'Indica que la verificación está revisada y aprobada.';

  @override
  String get autoguardadoTexto =>
      'Se guarda solo como borrador con cada cambio.';

  @override
  String get validar => 'Validar';

  @override
  String get noPuedesValidar =>
      'No puedes validar mientras haya infracciones marcadas en rojo arriba.';

  @override
  String get fotoReferenciaTexto =>
      'Foto de referencia del catálogo: comprueba que coincide.';

  @override
  String get sinFotoCocheTexto =>
      'Este coche no tiene foto en el catálogo. Añádela en Catálogos → Coches para poder comparar el modelo entregado.';

  @override
  String get sinGuardar => 'Sin guardar…';

  @override
  String get guardando => 'Guardando…';

  @override
  String get guardado => 'Guardado';

  @override
  String get errorCorto => 'Error';

  @override
  String soloLecturaTexto(String motivo) {
    return '$motivo Verificación en solo lectura.';
  }

  @override
  String desbloqueadaTexto(String motivo) {
    return '$motivo Desbloqueada: los cambios se guardan.';
  }

  @override
  String reglamentoCongelado(String fecha) {
    return 'Reglamento congelado el $fecha: se comprueba con los valores de cuando se verificó.';
  }

  @override
  String get reglamentoCongeladoSinFecha =>
      'Reglamento congelado: se comprueba con los valores de cuando se verificó.';

  @override
  String get haCambiadoDesdeEntonces =>
      'Ha cambiado desde entonces (no se aplica):';

  @override
  String get todoCumple => 'Todo cumple las normas. Puedes validar.';

  @override
  String infraccionesN(int n) {
    return 'Infracciones: $n';
  }

  @override
  String avisosN(int n) {
    return 'Avisos: $n';
  }

  @override
  String pendienteHechosDeTotal(int hechos, int total) {
    return 'Pendiente $hechos/$total';
  }

  @override
  String get hecho => 'Hecho';

  @override
  String get revisar => 'Revisar';

  @override
  String bloquesCompletos(int hechos, int total) {
    return 'Bloques completos: $hechos de $total';
  }

  @override
  String faltaLista(String lista) {
    return 'Falta: $lista';
  }

  @override
  String fueraDeLaLista(String valor) {
    return '$valor (fuera de la lista)';
  }

  @override
  String noCatalogado(String valor) {
    return '$valor (no catalogado)';
  }

  @override
  String conEsteCoche(String creditos) {
    return 'Con este coche ($creditos créd):';
  }

  @override
  String get total => 'Total';

  @override
  String nCreditos(int n) {
    return '$n créditos';
  }

  @override
  String get sinCreditosSuficientes =>
      '⚠ No tienen créditos suficientes para cubrir el coche.';

  @override
  String get hacerFoto => 'Hacer foto';

  @override
  String get elegirDeGaleria => 'Elegir de galería';

  @override
  String get anadir => 'Añadir';

  @override
  String get equipoNoInscritoPrueba =>
      'El equipo no está inscrito en la prueba: inscríbelo para poder cobrarle.';

  @override
  String get etiquetaFinal => 'Final';

  @override
  String get anchuraEjeMm => 'Anchura de eje (mm)';

  @override
  String get nombreDelClub => 'Nombre del club';

  @override
  String get clubEjemplo => 'Ej: Club Slot Barcelona';

  @override
  String get limitarFabricanteTexto =>
      'En la verificación, los desplegables de marca (piñón, corona, llantas y trencilla) solo muestran las marcas elegidas; cualquier otra es infracción.';

  @override
  String get eligeAlMenosUnaMarca => 'Elige al menos una marca.';

  @override
  String get tipoMotorSorteoTexto =>
      'La organización sortea los motores: en la verificación solo se apunta el número de motor.';

  @override
  String get tipoMotorPropioTexto =>
      'Cada equipo trae su motor: en la verificación se elige del catálogo y se comprueban RPM.';

  @override
  String get tipoMotorMixtoTexto =>
      'En cada verificación se marca si el motor es de organización o propio.';

  @override
  String get tipoMotorEligeTexto => 'Elige de dónde salen los motores.';

  @override
  String get noPagaEstaPrueba => 'no paga esta prueba';

  @override
  String get quitarWildcard => 'Quitar wildcard';

  @override
  String get quitarCoordTotal => 'Quitar \"Coord. total\" (vuelve a pagar)';

  @override
  String get coordinadoraEnFicha =>
      'Los pilotos están marcados como coordinadora en su ficha; cámbialo allí';

  @override
  String get marcarWildcard => 'Marcar como wildcard (no paga)';

  @override
  String desglosePagados(String total) {
    return 'Desglose de los €$total pagados';
  }

  @override
  String get pagat => 'Pagat';

  @override
  String get coordinadora => 'Coordinadora';

  @override
  String get club => 'Club';

  @override
  String get observacionesOpcional => 'Observaciones (opcional)';

  @override
  String descuadreTexto(String suma, String total) {
    return 'Coordinadora + Club ($suma) no suma el Pagat ($total).';
  }

  @override
  String get pagoRapido => 'Pago rápido:';

  @override
  String get coordYPiloto => 'Coord. + piloto';

  @override
  String coordYPilotoTooltip(String monto) {
    return 'Un piloto es de coordinadora: paga la mitad de todo (€$monto)';
  }

  @override
  String get coordTotal => 'Coord. total';

  @override
  String get coordTotalTooltip =>
      'Todos los pilotos son de coordinadora: no paga';

  @override
  String get observacionMitad => 'Mitad — un piloto de coordinadora';

  @override
  String get nuevaSesion => 'Nueva sesión';

  @override
  String get aunNoHaySesiones => 'Aún no hay sesiones';

  @override
  String get sesionesVaciasTexto =>
      'Verifica coches sin montar un campeonato: una carrera esporádica, un control en el club… Crea una sesión, añade participantes y exporta el PDF.';

  @override
  String nParticipantes(int n) {
    return '$n participantes';
  }

  @override
  String get sesionYaNoExiste => 'La sesión ya no existe.';

  @override
  String get aunNoHayParticipantes => 'Aún no hay participantes';

  @override
  String get pulsaAnadirParticipante =>
      'Pulsa \"Añadir participante\" para verificar su coche, o impórtalos desde un archivo o Google Sheets con «Importar» de arriba.';

  @override
  String get anadirParticipante => 'Añadir participante';

  @override
  String get desdeArchivoCsvExcelParentesis => 'Desde archivo (CSV / Excel)';

  @override
  String get desdeGoogleSheets => 'Desde Google Sheets';

  @override
  String get excelConFotos => 'Excel con fotos';

  @override
  String get reglamento => 'Reglamento';

  @override
  String get eliminarSesion => 'Eliminar sesión';

  @override
  String get configuraCopasAntes =>
      'Configura antes las copas en el reglamento de la sesión.';

  @override
  String anadidosParticipantes(int n) {
    return 'Añadidos $n participantes.';
  }

  @override
  String eliminarSesionTexto(String nombre) {
    return 'Se borrarán \"$nombre\", sus participantes y todas sus verificaciones. No se puede deshacer.';
  }

  @override
  String get pilotoObligatorio => 'Piloto *';

  @override
  String get obligatorio => 'Obligatorio';

  @override
  String get segundoPiloto => 'Segundo piloto (opcional)';

  @override
  String get equipoOpcional => 'Equipo (opcional)';

  @override
  String get equipoOpcionalAyuda =>
      'Si se deja vacío, se usa el nombre del piloto';

  @override
  String get anadirYVerificar => 'Añadir y verificar';

  @override
  String get seleccionaUnaCopa => 'Selecciona al menos una copa / categoría.';

  @override
  String get eligeTipoMotor => 'Motor: elige si es de sorteo, propio o mixto.';

  @override
  String get limitarFabricanteError =>
      'Limitar fabricante: elige al menos una marca o desactívalo.';

  @override
  String get nuevaSesionVerificacion => 'Nueva sesión de verificación';

  @override
  String get editarSesion => 'Editar sesión';

  @override
  String get nombreSesionObligatorio => 'Nombre de la sesión *';

  @override
  String get nombreSesionAyuda =>
      'Ej: Control club jueves, Carrera GT Sant Joan';

  @override
  String get lugarOpcional => 'Lugar (opcional)';

  @override
  String get sinFecha => 'Sin fecha';

  @override
  String get fechaSesion => 'Fecha de la sesión';

  @override
  String get clubOrganizador => 'Club organizador';

  @override
  String get clubOrganizadorAyuda =>
      'Aparece en la cabecera de los PDF de la sesión.';

  @override
  String get copasCategorias => 'Copas / categorías';

  @override
  String get copasCategoriasAyuda =>
      'Las que se pueden verificar en esta sesión. La copa de cada participante filtra el catálogo y las comprobaciones, igual que en un campeonato.';

  @override
  String get anchuraEje => 'Anchura de eje';

  @override
  String get anchuraEjeAyuda =>
      'Anchura máxima de eje (mm) por copa. Deja vacío si en esa copa no se comprueba.';

  @override
  String get maxDelanteroMm => 'Máx delantero (mm)';

  @override
  String get maxTraseroMm => 'Máx trasero (mm)';

  @override
  String get fabricante => 'Fabricante';

  @override
  String get fabricanteAyuda =>
      'Para sesiones monomarca: limita las marcas que se pueden elegir en la verificación.';

  @override
  String get rangoMotorTexto =>
      'Rango de números de motor para sortear desde la verificación. Déjalo vacío si no hay sorteo.';

  @override
  String get motorDesde => 'Motor desde';

  @override
  String get motorHasta => 'Motor hasta';

  @override
  String get indicaAmbos => 'Indica ambos';

  @override
  String get hastaMayorQueDesde => 'Hasta ≥ desde';

  @override
  String get crearSesion => 'Crear sesión';

  @override
  String get importarParticipantesArchivo => 'Importar participantes (archivo)';

  @override
  String get importarParticipantesSheets =>
      'Importar participantes (Google Sheets)';

  @override
  String errorAlImportar(String detalle) {
    return 'Error al importar: $detalle';
  }

  @override
  String pasoEligeArchivoN(int n) {
    return '$n. Elige el archivo';
  }

  @override
  String pasoEligeLaHoja(int n) {
    return '$n. Elige la hoja';
  }

  @override
  String pasoEligeLaPestana(int n) {
    return '$n. Elige la pestaña';
  }

  @override
  String pasoAsignaColumnasN(int n) {
    return '$n. Asigna columnas';
  }

  @override
  String pasoVistaPreviaN(int n) {
    return '$n. Vista previa';
  }

  @override
  String get csvPlantillaTexto =>
      'CSV o Excel con una fila de cabecera. Columnas reconocidas: Piloto 1 (o Piloto / Nombre), Piloto 2, Equipo y Copa. Hay una plantilla en \"Plantillas CSV\".';

  @override
  String get buscarEnTusHojas => 'Buscar en tus hojas…';

  @override
  String get buscar => 'Buscar';

  @override
  String get pestana => 'Pestaña';

  @override
  String get piloto1Obligatorio => 'Piloto 1 *';

  @override
  String get piloto2 => 'Piloto 2';

  @override
  String get copaPorDefecto => 'Copa por defecto';

  @override
  String get copaPorDefectoAyuda =>
      'Para filas sin copa o con una copa que no está en la sesión';

  @override
  String get asignaColumnaPiloto1 => 'Asigna al menos la columna del piloto 1.';

  @override
  String get noHayFilasConPiloto => 'No hay filas con piloto.';

  @override
  String anadirNParticipantes(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n participantes',
      one: '1 participante',
    );
    return 'Añadir $_temp0';
  }

  @override
  String get noConectadoGoogle => 'Aún no estás conectado con Google';

  @override
  String get conectaCuentaTexto =>
      'Conecta tu cuenta una vez para poder leer tus hojas de cálculo.';

  @override
  String get configurarGoogle => 'Configurar Google';

  @override
  String noSePudieronListarHojas(String detalle) {
    return 'No se pudieron listar tus hojas: $detalle';
  }

  @override
  String noSePudieronListarPestanas(String detalle) {
    return 'No se pudieron listar las pestañas: $detalle';
  }

  @override
  String noSePudoLeerPestana(String detalle) {
    return 'No se pudo leer la pestaña: $detalle';
  }

  @override
  String get yaEstaEnLaSesion => 'Ya está en la sesión';

  @override
  String copaNoEnSesion(String copa, String defecto) {
    return 'Copa \"$copa\" no está en la sesión: se usa $defecto';
  }

  @override
  String get fotoCatalogo => 'Foto catálogo';
}
