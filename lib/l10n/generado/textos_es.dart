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
}
