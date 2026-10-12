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

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'textos_ca.dart';
import 'textos_en.dart';
import 'textos_es.dart';
import 'textos_fr.dart';
import 'textos_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of Textos
/// returned by `Textos.of(context)`.
///
/// Applications need to include `Textos.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generado/textos.dart';
///
/// return MaterialApp(
///   localizationsDelegates: Textos.localizationsDelegates,
///   supportedLocales: Textos.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the Textos.supportedLocales
/// property.
abstract class Textos {
  Textos(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static Textos? of(BuildContext context) {
    return Localizations.of<Textos>(context, Textos);
  }

  static const LocalizationsDelegate<Textos> delegate = _TextosDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ca'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
  ];

  /// No description provided for @menuInicio.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get menuInicio;

  /// No description provided for @menuPruebas.
  ///
  /// In es, this message translates to:
  /// **'Pruebas'**
  String get menuPruebas;

  /// No description provided for @menuParticipantes.
  ///
  /// In es, this message translates to:
  /// **'Participantes'**
  String get menuParticipantes;

  /// No description provided for @menuClasificacion.
  ///
  /// In es, this message translates to:
  /// **'Clasificación'**
  String get menuClasificacion;

  /// No description provided for @menuTesoreria.
  ///
  /// In es, this message translates to:
  /// **'Tesorería'**
  String get menuTesoreria;

  /// No description provided for @menuCreditos.
  ///
  /// In es, this message translates to:
  /// **'Créditos'**
  String get menuCreditos;

  /// No description provided for @menuVerificacionLibre.
  ///
  /// In es, this message translates to:
  /// **'Verificación libre'**
  String get menuVerificacionLibre;

  /// No description provided for @menuCatalogos.
  ///
  /// In es, this message translates to:
  /// **'Catálogos'**
  String get menuCatalogos;

  /// No description provided for @menuGestionarCampeonatos.
  ///
  /// In es, this message translates to:
  /// **'Gestionar campeonatos'**
  String get menuGestionarCampeonatos;

  /// No description provided for @menuAjustes.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get menuAjustes;

  /// No description provided for @menuMas.
  ///
  /// In es, this message translates to:
  /// **'Más'**
  String get menuMas;

  /// No description provided for @grupoCampeonato.
  ///
  /// In es, this message translates to:
  /// **'CAMPEONATO'**
  String get grupoCampeonato;

  /// No description provided for @grupoHerramientas.
  ///
  /// In es, this message translates to:
  /// **'HERRAMIENTAS'**
  String get grupoHerramientas;

  /// No description provided for @grupoCampeonatoActivo.
  ///
  /// In es, this message translates to:
  /// **'CAMPEONATO ACTIVO'**
  String get grupoCampeonatoActivo;

  /// No description provided for @campeonatoActivo.
  ///
  /// In es, this message translates to:
  /// **'Campeonato activo'**
  String get campeonatoActivo;

  /// No description provided for @gestionarCampeonatosPuntos.
  ///
  /// In es, this message translates to:
  /// **'Gestionar campeonatos…'**
  String get gestionarCampeonatosPuntos;

  /// No description provided for @tooltipCampeonato.
  ///
  /// In es, this message translates to:
  /// **'Campeonato: {nombre}'**
  String tooltipCampeonato(String nombre);

  /// No description provided for @errorDetalle.
  ///
  /// In es, this message translates to:
  /// **'Error: {detalle}'**
  String errorDetalle(String detalle);

  /// No description provided for @vacioTitulo.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay campeonatos'**
  String get vacioTitulo;

  /// No description provided for @vacioTexto.
  ///
  /// In es, this message translates to:
  /// **'Crea el primer campeonato para empezar a gestionar pruebas y resultados.'**
  String get vacioTexto;

  /// No description provided for @crearCampeonato.
  ///
  /// In es, this message translates to:
  /// **'Crear campeonato'**
  String get crearCampeonato;

  /// No description provided for @soloVerificarCoches.
  ///
  /// In es, this message translates to:
  /// **'Solo verificar coches'**
  String get soloVerificarCoches;

  /// No description provided for @ajustesYCopias.
  ///
  /// In es, this message translates to:
  /// **'Ajustes y copias'**
  String get ajustesYCopias;

  /// No description provided for @masOpciones.
  ///
  /// In es, this message translates to:
  /// **'Más opciones'**
  String get masOpciones;

  /// No description provided for @statPilotos.
  ///
  /// In es, this message translates to:
  /// **'pilotos'**
  String get statPilotos;

  /// No description provided for @statEquipos.
  ///
  /// In es, this message translates to:
  /// **'equipos'**
  String get statEquipos;

  /// No description provided for @statPruebas.
  ///
  /// In es, this message translates to:
  /// **'pruebas'**
  String get statPruebas;

  /// No description provided for @pendientes.
  ///
  /// In es, this message translates to:
  /// **'Pendientes'**
  String get pendientes;

  /// No description provided for @proximaPrueba.
  ///
  /// In es, this message translates to:
  /// **'Próxima prueba'**
  String get proximaPrueba;

  /// No description provided for @noHayPruebasPendientes.
  ///
  /// In es, this message translates to:
  /// **'No hay pruebas pendientes'**
  String get noHayPruebasPendientes;

  /// No description provided for @botonInscritos.
  ///
  /// In es, this message translates to:
  /// **'Inscritos'**
  String get botonInscritos;

  /// No description provided for @botonVerificar.
  ///
  /// In es, this message translates to:
  /// **'Verificar'**
  String get botonVerificar;

  /// No description provided for @botonResultados.
  ///
  /// In es, this message translates to:
  /// **'Resultados'**
  String get botonResultados;

  /// No description provided for @pendVerificaciones.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{verificación sin validar} other{verificaciones sin validar}}'**
  String pendVerificaciones(int n);

  /// No description provided for @pendPagos.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{pago sin cobrar} other{pagos sin cobrar}}'**
  String pendPagos(int n);

  /// No description provided for @pendSinResultados.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{prueba ya disputada sin resultados} other{pruebas ya disputadas sin resultados}}'**
  String pendSinResultados(int n);

  /// No description provided for @todoAlDia.
  ///
  /// In es, this message translates to:
  /// **'Todo al día'**
  String get todoAlDia;

  /// No description provided for @todoAlDiaSinPruebas.
  ///
  /// In es, this message translates to:
  /// **'No hay pruebas pendientes ni resultados por registrar.'**
  String get todoAlDiaSinPruebas;

  /// No description provided for @todoAlDiaEnPrueba.
  ///
  /// In es, this message translates to:
  /// **'Sin verificaciones ni pagos pendientes en {prueba}.'**
  String todoAlDiaEnPrueba(String prueba);

  /// No description provided for @liderCampeonato.
  ///
  /// In es, this message translates to:
  /// **'Líder del campeonato'**
  String get liderCampeonato;

  /// No description provided for @sinResultadosTodavia.
  ///
  /// In es, this message translates to:
  /// **'Sin resultados todavía'**
  String get sinResultadosTodavia;

  /// No description provided for @puntosAbrev.
  ///
  /// In es, this message translates to:
  /// **'{puntos} pts'**
  String puntosAbrev(int puntos);

  /// No description provided for @seccionDatos.
  ///
  /// In es, this message translates to:
  /// **'Datos'**
  String get seccionDatos;

  /// No description provided for @copiasSeguridad.
  ///
  /// In es, this message translates to:
  /// **'Copias de seguridad'**
  String get copiasSeguridad;

  /// No description provided for @copiasSeguridadSub.
  ///
  /// In es, this message translates to:
  /// **'Subir o restaurar la copia en Drive, o restaurar desde archivo'**
  String get copiasSeguridadSub;

  /// No description provided for @googleSheetsDrive.
  ///
  /// In es, this message translates to:
  /// **'Google (Sheets y Drive)'**
  String get googleSheetsDrive;

  /// No description provided for @googleSub.
  ///
  /// In es, this message translates to:
  /// **'Conectar la cuenta y las credenciales de Google Cloud'**
  String get googleSub;

  /// No description provided for @plantillasCsv.
  ///
  /// In es, this message translates to:
  /// **'Plantillas CSV'**
  String get plantillasCsv;

  /// No description provided for @plantillasCsvSub.
  ///
  /// In es, this message translates to:
  /// **'Descargar plantillas para importar pilotos, equipos…'**
  String get plantillasCsvSub;

  /// No description provided for @seccionApariencia.
  ///
  /// In es, this message translates to:
  /// **'Apariencia'**
  String get seccionApariencia;

  /// No description provided for @modoOscuro.
  ///
  /// In es, this message translates to:
  /// **'Modo oscuro'**
  String get modoOscuro;

  /// No description provided for @idioma.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get idioma;

  /// No description provided for @idiomaAutomatico.
  ///
  /// In es, this message translates to:
  /// **'Automático (idioma del sistema)'**
  String get idiomaAutomatico;

  /// No description provided for @seccionAcercaDe.
  ///
  /// In es, this message translates to:
  /// **'Acerca de'**
  String get seccionAcercaDe;

  /// No description provided for @novedades.
  ///
  /// In es, this message translates to:
  /// **'Novedades'**
  String get novedades;

  /// No description provided for @historialVersiones.
  ///
  /// In es, this message translates to:
  /// **'Historial de versiones'**
  String get historialVersiones;

  /// No description provided for @versionHistorial.
  ///
  /// In es, this message translates to:
  /// **'Versión {version} · historial de versiones'**
  String versionHistorial(String version);

  /// No description provided for @actualizaciones.
  ///
  /// In es, this message translates to:
  /// **'Actualizaciones'**
  String get actualizaciones;

  /// No description provided for @actualizacionesSub.
  ///
  /// In es, this message translates to:
  /// **'Buscar una versión nueva y descargarla'**
  String get actualizacionesSub;

  /// No description provided for @actDescargaIncompleta.
  ///
  /// In es, this message translates to:
  /// **'La descarga no llegó completa. Inténtalo otra vez.'**
  String get actDescargaIncompleta;

  /// No description provided for @actDescargaAtascada.
  ///
  /// In es, this message translates to:
  /// **'La descarga se ha atascado. Inténtalo otra vez.'**
  String get actDescargaAtascada;

  /// No description provided for @actNoSePudoDescargar.
  ///
  /// In es, this message translates to:
  /// **'No se pudo descargar la actualización. Inténtalo de nuevo o descárgala desde pitwall.es.'**
  String get actNoSePudoDescargar;

  /// No description provided for @actHayVersionNueva.
  ///
  /// In es, this message translates to:
  /// **'Hay una versión nueva: v{version}'**
  String actHayVersionNueva(String version);

  /// No description provided for @actDescargaNueva.
  ///
  /// In es, this message translates to:
  /// **'Descarga la nueva versión para tener las últimas mejoras.'**
  String get actDescargaNueva;

  /// No description provided for @cancelar.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancelar;

  /// No description provided for @masTarde.
  ///
  /// In es, this message translates to:
  /// **'Más tarde'**
  String get masTarde;

  /// No description provided for @actPermisoAndroid.
  ///
  /// In es, this message translates to:
  /// **'Android pedirá permiso para instalar apps de esta fuente la primera vez. Después, vuelve a pulsar «Actualizar».'**
  String get actPermisoAndroid;

  /// No description provided for @actSeAbriraNavegador.
  ///
  /// In es, this message translates to:
  /// **'Se abrirá el navegador para descargar el instalador de esta versión.'**
  String get actSeAbriraNavegador;

  /// No description provided for @actActualizar.
  ///
  /// In es, this message translates to:
  /// **'Actualizar'**
  String get actActualizar;

  /// No description provided for @actDescargar.
  ///
  /// In es, this message translates to:
  /// **'Descargar'**
  String get actDescargar;

  /// No description provided for @actDescargando.
  ///
  /// In es, this message translates to:
  /// **'Descargando…'**
  String get actDescargando;

  /// No description provided for @actDescargandoPct.
  ///
  /// In es, this message translates to:
  /// **'Descargando… {pct} %'**
  String actDescargandoPct(int pct);

  /// No description provided for @nuevaPrueba.
  ///
  /// In es, this message translates to:
  /// **'Nueva prueba'**
  String get nuevaPrueba;

  /// No description provided for @seleccionaCampeonato.
  ///
  /// In es, this message translates to:
  /// **'Selecciona primero un campeonato'**
  String get seleccionaCampeonato;

  /// No description provided for @aunNoHayPruebas.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay pruebas'**
  String get aunNoHayPruebas;

  /// No description provided for @aunNoHayPruebasTexto.
  ///
  /// In es, this message translates to:
  /// **'Crea la primera prueba del campeonato (por ejemplo \"EL SOT\", \"SLOTMANIA\"…).'**
  String get aunNoHayPruebasTexto;

  /// No description provided for @estadoProgramada.
  ///
  /// In es, this message translates to:
  /// **'Programada'**
  String get estadoProgramada;

  /// No description provided for @estadoEnCurso.
  ///
  /// In es, this message translates to:
  /// **'En curso'**
  String get estadoEnCurso;

  /// No description provided for @estadoTerminada.
  ///
  /// In es, this message translates to:
  /// **'Terminada'**
  String get estadoTerminada;

  /// No description provided for @estadoCancelada.
  ///
  /// In es, this message translates to:
  /// **'Cancelada'**
  String get estadoCancelada;

  /// No description provided for @resumenVerificaciones.
  ///
  /// In es, this message translates to:
  /// **'Resumen de verificaciones'**
  String get resumenVerificaciones;

  /// No description provided for @aunNoHayTandas.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay tandas'**
  String get aunNoHayTandas;

  /// No description provided for @verificarSinTandasTexto.
  ///
  /// In es, this message translates to:
  /// **'Inscribe equipos y crea las tandas en la pestaña Preparar.'**
  String get verificarSinTandasTexto;

  /// No description provided for @validadasDe.
  ///
  /// In es, this message translates to:
  /// **'{validadas} / {total} validadas'**
  String validadasDe(int validadas, int total);

  /// No description provided for @sinEquiposEnTanda.
  ///
  /// In es, this message translates to:
  /// **'Sin equipos en esta tanda.'**
  String get sinEquiposEnTanda;

  /// No description provided for @carreraTienePole.
  ///
  /// In es, this message translates to:
  /// **'¿La carrera tiene pole?'**
  String get carreraTienePole;

  /// No description provided for @carreraTienePoleTexto.
  ///
  /// In es, this message translates to:
  /// **'Con pole no se exporta el orden de carril: PitWall crea la sesión de pole y la parrilla se asigna tras correrla.'**
  String get carreraTienePoleTexto;

  /// No description provided for @sinPole.
  ///
  /// In es, this message translates to:
  /// **'Sin pole'**
  String get sinPole;

  /// No description provided for @conPole.
  ///
  /// In es, this message translates to:
  /// **'Con pole'**
  String get conPole;

  /// No description provided for @noHayInscritosExportar.
  ///
  /// In es, this message translates to:
  /// **'No hay inscritos que exportar.'**
  String get noHayInscritosExportar;

  /// No description provided for @noHayTandasConCarriles.
  ///
  /// In es, this message translates to:
  /// **'No hay tandas con carriles asignados que exportar.'**
  String get noHayTandasConCarriles;

  /// No description provided for @importarDelCronometraje.
  ///
  /// In es, this message translates to:
  /// **'Importar del cronometraje'**
  String get importarDelCronometraje;

  /// No description provided for @traerResultadosPitwall.
  ///
  /// In es, this message translates to:
  /// **'Traer resultados de PitWall'**
  String get traerResultadosPitwall;

  /// No description provided for @prueba.
  ///
  /// In es, this message translates to:
  /// **'Prueba'**
  String get prueba;

  /// No description provided for @editar.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get editar;

  /// No description provided for @pestanaPreparar.
  ///
  /// In es, this message translates to:
  /// **'Preparar'**
  String get pestanaPreparar;

  /// No description provided for @pestanaVerificar.
  ///
  /// In es, this message translates to:
  /// **'Verificar'**
  String get pestanaVerificar;

  /// No description provided for @pestanaResultados.
  ///
  /// In es, this message translates to:
  /// **'Resultados'**
  String get pestanaResultados;

  /// No description provided for @pestanaCaja.
  ///
  /// In es, this message translates to:
  /// **'Caja'**
  String get pestanaCaja;

  /// No description provided for @nuevaTanda.
  ///
  /// In es, this message translates to:
  /// **'Nueva tanda'**
  String get nuevaTanda;

  /// No description provided for @compartir.
  ///
  /// In es, this message translates to:
  /// **'Compartir'**
  String get compartir;

  /// No description provided for @pdfTandas.
  ///
  /// In es, this message translates to:
  /// **'PDF de tandas'**
  String get pdfTandas;

  /// No description provided for @pdfVerificaciones.
  ///
  /// In es, this message translates to:
  /// **'PDF de verificaciones'**
  String get pdfVerificaciones;

  /// No description provided for @enviarTandasPitwall.
  ///
  /// In es, this message translates to:
  /// **'Enviar tandas a PitWall'**
  String get enviarTandasPitwall;

  /// No description provided for @porWifiSinArchivo.
  ///
  /// In es, this message translates to:
  /// **'Por wifi, sin archivo'**
  String get porWifiSinArchivo;

  /// No description provided for @enviarVerificacionesPitwall.
  ///
  /// In es, this message translates to:
  /// **'Enviar verificaciones a PitWall'**
  String get enviarVerificacionesPitwall;

  /// No description provided for @soloConsultaManager.
  ///
  /// In es, this message translates to:
  /// **'Solo consulta en Manager'**
  String get soloConsultaManager;

  /// No description provided for @archivoParaPitwall.
  ///
  /// In es, this message translates to:
  /// **'Archivo para PitWall (JSON)'**
  String get archivoParaPitwall;

  /// No description provided for @paraImportarAManoManager.
  ///
  /// In es, this message translates to:
  /// **'Para importarlo a mano en Manager'**
  String get paraImportarAManoManager;

  /// No description provided for @noEncontrada.
  ///
  /// In es, this message translates to:
  /// **'No encontrada'**
  String get noEncontrada;

  /// No description provided for @editarTandas.
  ///
  /// In es, this message translates to:
  /// **'Editar tandas'**
  String get editarTandas;

  /// No description provided for @sorteoMotores.
  ///
  /// In es, this message translates to:
  /// **'Sorteo de motores'**
  String get sorteoMotores;

  /// No description provided for @tandas.
  ///
  /// In es, this message translates to:
  /// **'Tandas'**
  String get tandas;

  /// No description provided for @crearTandasTexto.
  ///
  /// In es, this message translates to:
  /// **'Crea las tandas que tendrá esta prueba (Jueves 21:00, Viernes 21:00…).'**
  String get crearTandasTexto;

  /// No description provided for @pruebaNumero.
  ///
  /// In es, this message translates to:
  /// **'Prueba #{orden}'**
  String pruebaNumero(int orden);

  /// No description provided for @nCarriles.
  ///
  /// In es, this message translates to:
  /// **'{n} carriles'**
  String nCarriles(int n);

  /// No description provided for @noSePudoGuardar.
  ///
  /// In es, this message translates to:
  /// **'No se pudo guardar: {detalle}'**
  String noSePudoGuardar(String detalle);

  /// No description provided for @eliminarPrueba.
  ///
  /// In es, this message translates to:
  /// **'Eliminar prueba'**
  String get eliminarPrueba;

  /// No description provided for @eliminarPruebaTexto.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar \"{nombre}\"?\n\nSe borrarán también sus tandas, inscripciones, resultados y verificaciones. Esta acción no se puede deshacer.'**
  String eliminarPruebaTexto(String nombre);

  /// No description provided for @eliminar.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get eliminar;

  /// No description provided for @editarPrueba.
  ///
  /// In es, this message translates to:
  /// **'Editar prueba'**
  String get editarPrueba;

  /// No description provided for @nombrePruebaObligatorio.
  ///
  /// In es, this message translates to:
  /// **'Nombre de la prueba *'**
  String get nombrePruebaObligatorio;

  /// No description provided for @nombrePruebaAyuda.
  ///
  /// In es, this message translates to:
  /// **'Ej: EL SOT, SLOTMANIA, GASCLAVAT…'**
  String get nombrePruebaAyuda;

  /// No description provided for @indicaElNombre.
  ///
  /// In es, this message translates to:
  /// **'Indica el nombre'**
  String get indicaElNombre;

  /// No description provided for @sedeClub.
  ///
  /// In es, this message translates to:
  /// **'Sede / club'**
  String get sedeClub;

  /// No description provided for @sinFechaAsignada.
  ///
  /// In es, this message translates to:
  /// **'Sin fecha asignada'**
  String get sinFechaAsignada;

  /// No description provided for @quitarFecha.
  ///
  /// In es, this message translates to:
  /// **'Quitar fecha'**
  String get quitarFecha;

  /// No description provided for @elegir.
  ///
  /// In es, this message translates to:
  /// **'Elegir'**
  String get elegir;

  /// No description provided for @cambiar.
  ///
  /// In es, this message translates to:
  /// **'Cambiar'**
  String get cambiar;

  /// No description provided for @ordenCampeonato.
  ///
  /// In es, this message translates to:
  /// **'Orden en el campeonato'**
  String get ordenCampeonato;

  /// No description provided for @ordenCampeonatoAyuda.
  ///
  /// In es, this message translates to:
  /// **'Posición en el calendario (1, 2, 3…)'**
  String get ordenCampeonatoAyuda;

  /// No description provided for @numeroEntero.
  ///
  /// In es, this message translates to:
  /// **'Número entero'**
  String get numeroEntero;

  /// No description provided for @estado.
  ///
  /// In es, this message translates to:
  /// **'Estado'**
  String get estado;

  /// No description provided for @crearPrueba.
  ///
  /// In es, this message translates to:
  /// **'Crear prueba'**
  String get crearPrueba;

  /// No description provided for @guardarCambios.
  ///
  /// In es, this message translates to:
  /// **'Guardar cambios'**
  String get guardarCambios;

  /// No description provided for @eliminarTanda.
  ///
  /// In es, this message translates to:
  /// **'Eliminar tanda'**
  String get eliminarTanda;

  /// No description provided for @eliminarTandaTexto.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar la tanda \"{nombre}\"? Se borrarán también las inscripciones, resultados y verificaciones de la tanda.'**
  String eliminarTandaTexto(String nombre);

  /// No description provided for @editarTanda.
  ///
  /// In es, this message translates to:
  /// **'Editar tanda'**
  String get editarTanda;

  /// No description provided for @nombreTandaObligatorio.
  ///
  /// In es, this message translates to:
  /// **'Nombre de la tanda *'**
  String get nombreTandaObligatorio;

  /// No description provided for @nombreTandaAyuda.
  ///
  /// In es, this message translates to:
  /// **'Ej: Jueves 21:00, Viernes 23:00…'**
  String get nombreTandaAyuda;

  /// No description provided for @sinFechaHora.
  ///
  /// In es, this message translates to:
  /// **'Sin fecha y hora asignadas'**
  String get sinFechaHora;

  /// No description provided for @quitar.
  ///
  /// In es, this message translates to:
  /// **'Quitar'**
  String get quitar;

  /// No description provided for @numeroCarriles.
  ///
  /// In es, this message translates to:
  /// **'Número de carriles'**
  String get numeroCarriles;

  /// No description provided for @numeroCarrilesAyuda.
  ///
  /// In es, this message translates to:
  /// **'Habitualmente 6, 7 u 8 (hasta 32)'**
  String get numeroCarrilesAyuda;

  /// No description provided for @numeroCarrilesError.
  ///
  /// In es, this message translates to:
  /// **'Indica un número entre 1 y 32'**
  String get numeroCarrilesError;

  /// No description provided for @pisters.
  ///
  /// In es, this message translates to:
  /// **'Pisters'**
  String get pisters;

  /// No description provided for @pistersAyuda.
  ///
  /// In es, this message translates to:
  /// **'Tanda cuyos pilotos hacen de pisters en esta'**
  String get pistersAyuda;

  /// No description provided for @sinPisters.
  ///
  /// In es, this message translates to:
  /// **'— sin pisters —'**
  String get sinPisters;

  /// No description provided for @pilotosDe.
  ///
  /// In es, this message translates to:
  /// **'Pilotos de {nombre}'**
  String pilotosDe(String nombre);

  /// No description provided for @crearTanda.
  ///
  /// In es, this message translates to:
  /// **'Crear tanda'**
  String get crearTanda;

  /// No description provided for @pruebaSinTandas.
  ///
  /// In es, this message translates to:
  /// **'Esta prueba no tiene tandas todavía'**
  String get pruebaSinTandas;

  /// No description provided for @generaTandasDesdeInscritos.
  ///
  /// In es, this message translates to:
  /// **'Genéralas desde Inscritos → Generar tandas.'**
  String get generaTandasDesdeInscritos;

  /// No description provided for @tocaEquipoParaMover.
  ///
  /// In es, this message translates to:
  /// **'Toca un equipo para moverlo a otra tanda.'**
  String get tocaEquipoParaMover;

  /// No description provided for @nEquiposAbrev.
  ///
  /// In es, this message translates to:
  /// **'{n} eq.'**
  String nEquiposAbrev(int n);

  /// No description provided for @sinEquipos.
  ///
  /// In es, this message translates to:
  /// **'Sin equipos'**
  String get sinEquipos;

  /// No description provided for @moverEquipoA.
  ///
  /// In es, this message translates to:
  /// **'Mover \"{nombre}\" a…'**
  String moverEquipoA(String nombre);

  /// No description provided for @tandaConEquipos.
  ///
  /// In es, this message translates to:
  /// **'{nombre}  ({n} eq.)'**
  String tandaConEquipos(String nombre, int n);

  /// No description provided for @darDeBajaPrueba.
  ///
  /// In es, this message translates to:
  /// **'Dar de baja de la prueba'**
  String get darDeBajaPrueba;

  /// No description provided for @eligePitwall.
  ///
  /// In es, this message translates to:
  /// **'Elige un PitWall o escribe su dirección.'**
  String get eligePitwall;

  /// No description provided for @noHayInscritosEnviar.
  ///
  /// In es, this message translates to:
  /// **'No hay inscritos que enviar.'**
  String get noHayInscritosEnviar;

  /// No description provided for @noHayTandasEnviar.
  ///
  /// In es, this message translates to:
  /// **'No hay tandas con carriles asignados que enviar.'**
  String get noHayTandasEnviar;

  /// No description provided for @enviarAPitwall.
  ///
  /// In es, this message translates to:
  /// **'Enviar a PitWall'**
  String get enviarAPitwall;

  /// No description provided for @pinImportacion.
  ///
  /// In es, this message translates to:
  /// **'PIN de importación'**
  String get pinImportacion;

  /// No description provided for @pinImportacionAyuda.
  ///
  /// In es, this message translates to:
  /// **'El PIN que muestra PitWall en «Importar tanda».'**
  String get pinImportacionAyuda;

  /// No description provided for @carreraTienePoleSi.
  ///
  /// In es, this message translates to:
  /// **'La carrera tiene pole'**
  String get carreraTienePoleSi;

  /// No description provided for @carreraTienePoleAyuda.
  ///
  /// In es, this message translates to:
  /// **'No se envía el orden de carril: la parrilla se asigna en PitWall tras la pole'**
  String get carreraTienePoleAyuda;

  /// No description provided for @enviar.
  ///
  /// In es, this message translates to:
  /// **'Enviar'**
  String get enviar;

  /// No description provided for @pitwallEnLaRed.
  ///
  /// In es, this message translates to:
  /// **'PitWall en la red'**
  String get pitwallEnLaRed;

  /// No description provided for @buscarDeNuevo.
  ///
  /// In es, this message translates to:
  /// **'Buscar de nuevo'**
  String get buscarDeNuevo;

  /// No description provided for @buscandoPitwall.
  ///
  /// In es, this message translates to:
  /// **'Buscando PitWall en la red local…'**
  String get buscandoPitwall;

  /// No description provided for @noSeEncuentraPitwall.
  ///
  /// In es, this message translates to:
  /// **'No se ha encontrado ningún PitWall. Comprueba que está abierto y en la misma red Wi‑Fi, o escribe su dirección abajo.'**
  String get noSeEncuentraPitwall;

  /// No description provided for @direccionIpPuerto.
  ///
  /// In es, this message translates to:
  /// **'Dirección (IP:puerto)'**
  String get direccionIpPuerto;

  /// No description provided for @resultadosDeLaTanda.
  ///
  /// In es, this message translates to:
  /// **'Resultados de la tanda'**
  String get resultadosDeLaTanda;

  /// No description provided for @noHayEquiposEnTanda.
  ///
  /// In es, this message translates to:
  /// **'No hay equipos en esta tanda'**
  String get noHayEquiposEnTanda;

  /// No description provided for @inscribeEquiposParaResultados.
  ///
  /// In es, this message translates to:
  /// **'Inscribe equipos para poder registrar sus resultados.'**
  String get inscribeEquiposParaResultados;

  /// No description provided for @indicaPosicionFinalTexto.
  ///
  /// In es, this message translates to:
  /// **'Indica la posición final de cada equipo. Los puntos se calculan solos según la tabla del campeonato.'**
  String get indicaPosicionFinalTexto;

  /// No description provided for @puntos.
  ///
  /// In es, this message translates to:
  /// **'puntos'**
  String get puntos;

  /// No description provided for @posicion.
  ///
  /// In es, this message translates to:
  /// **'Posición'**
  String get posicion;

  /// No description provided for @sinAsignar.
  ///
  /// In es, this message translates to:
  /// **'Sin asignar'**
  String get sinAsignar;

  /// No description provided for @aRestar.
  ///
  /// In es, this message translates to:
  /// **'A restar'**
  String get aRestar;

  /// No description provided for @creditosMin.
  ///
  /// In es, this message translates to:
  /// **'créditos'**
  String get creditosMin;

  /// No description provided for @noHayInscritosEnPrueba.
  ///
  /// In es, this message translates to:
  /// **'No hay inscritos en esta prueba'**
  String get noHayInscritosEnPrueba;

  /// No description provided for @inscribeEquiposGeneraTandas.
  ///
  /// In es, this message translates to:
  /// **'Inscribe equipos y genera las tandas. Luego podrás importar los resultados del cronometraje aquí.'**
  String get inscribeEquiposGeneraTandas;

  /// No description provided for @equiposConResultado.
  ///
  /// In es, this message translates to:
  /// **'{con} de {total, plural, =1{1 equipo} other{{total} equipos}} con resultado registrado.'**
  String equiposConResultado(int con, int total);

  /// No description provided for @resultadosDeLaPrueba.
  ///
  /// In es, this message translates to:
  /// **'Resultados de la prueba'**
  String get resultadosDeLaPrueba;

  /// No description provided for @importarDesdeArchivoCronometraje.
  ///
  /// In es, this message translates to:
  /// **'Importar desde archivo de cronometraje'**
  String get importarDesdeArchivoCronometraje;

  /// No description provided for @copaYManga.
  ///
  /// In es, this message translates to:
  /// **'Copa {copa}  ·  {manga}'**
  String copaYManga(String copa, String manga);

  /// No description provided for @posAbrev.
  ///
  /// In es, this message translates to:
  /// **'Pos.'**
  String get posAbrev;

  /// No description provided for @archivos.
  ///
  /// In es, this message translates to:
  /// **'Archivos'**
  String get archivos;

  /// No description provided for @noSeEncontraronResultados.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron resultados. El archivo debe tener columnas como \"Posición\" y \"Nombre\" (formato TicTacSlot o similar).'**
  String get noSeEncontraronResultados;

  /// No description provided for @noSePudoLeerArchivo.
  ///
  /// In es, this message translates to:
  /// **'No se pudo leer el archivo: {detalle}'**
  String noSePudoLeerArchivo(String detalle);

  /// No description provided for @importacionCompletada.
  ///
  /// In es, this message translates to:
  /// **'Importación completada'**
  String get importacionCompletada;

  /// No description provided for @resumenImportacionResultados.
  ///
  /// In es, this message translates to:
  /// **'✓ Resultados aplicados: {ok}\n+ Inscritos automáticamente: {inscritos}\n✗ Saltados: {saltados}'**
  String resumenImportacionResultados(int ok, int inscritos, int saltados);

  /// No description provided for @ok.
  ///
  /// In es, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @importarResultadosPrueba.
  ///
  /// In es, this message translates to:
  /// **'Importar resultados de la prueba'**
  String get importarResultadosPrueba;

  /// No description provided for @paso1EligeArchivo.
  ///
  /// In es, this message translates to:
  /// **'1. Elige el archivo'**
  String get paso1EligeArchivo;

  /// No description provided for @importaArchivoTexto.
  ///
  /// In es, this message translates to:
  /// **'Importa el archivo del sistema de cronometraje (TicTacSlot, SloTime…). Cada equipo del archivo se asigna a la tanda de esta prueba donde esté inscrito.'**
  String get importaArchivoTexto;

  /// No description provided for @elegirArchivo.
  ///
  /// In es, this message translates to:
  /// **'Elegir archivo'**
  String get elegirArchivo;

  /// No description provided for @resultadosGenerales.
  ///
  /// In es, this message translates to:
  /// **'Resultados generales'**
  String get resultadosGenerales;

  /// No description provided for @crearTandaResultadosGenerales.
  ///
  /// In es, this message translates to:
  /// **'Crear tanda \"Resultados generales\"'**
  String get crearTandaResultadosGenerales;

  /// No description provided for @pruebaSinTandasAviso.
  ///
  /// In es, this message translates to:
  /// **'La prueba no tiene tandas aún. Marcamos los resultados en una tanda creada al vuelo.'**
  String get pruebaSinTandasAviso;

  /// No description provided for @paso2VistaPrevia.
  ///
  /// In es, this message translates to:
  /// **'2. Vista previa'**
  String get paso2VistaPrevia;

  /// No description provided for @nDeTotalSeAplicaran.
  ///
  /// In es, this message translates to:
  /// **'{n} de {total} se aplicarán'**
  String nDeTotalSeAplicaran(int n, int total);

  /// No description provided for @equiposNoExistenAviso.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{⚠️ 1 equipo del archivo no existe en el campeonato.} other{⚠️ {n} equipos del archivo no existen en el campeonato.}}'**
  String equiposNoExistenAviso(int n);

  /// No description provided for @aplicarResultadosA.
  ///
  /// In es, this message translates to:
  /// **'Aplicar resultados a {n, plural, =1{1 equipo} other{{n} equipos}}'**
  String aplicarResultadosA(int n);

  /// No description provided for @noExiste.
  ///
  /// In es, this message translates to:
  /// **'No existe'**
  String get noExiste;

  /// No description provided for @seInscribira.
  ///
  /// In es, this message translates to:
  /// **'Se inscribirá'**
  String get seInscribira;

  /// No description provided for @aplicar.
  ///
  /// In es, this message translates to:
  /// **'Aplicar'**
  String get aplicar;

  /// No description provided for @copaTexto.
  ///
  /// In es, this message translates to:
  /// **'Copa {copa}'**
  String copaTexto(String copa);

  /// No description provided for @nVueltas.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 vuelta} other{{n} vueltas}}'**
  String nVueltas(int n);

  /// No description provided for @formatoNoSoportado.
  ///
  /// In es, this message translates to:
  /// **'Formato no soportado: {ext}'**
  String formatoNoSoportado(String ext);

  /// No description provided for @sortearRestantes.
  ///
  /// In es, this message translates to:
  /// **'Sortear restantes'**
  String get sortearRestantes;

  /// No description provided for @pruebaNoEncontrada.
  ///
  /// In es, this message translates to:
  /// **'Prueba no encontrada'**
  String get pruebaNoEncontrada;

  /// No description provided for @noHayEquiposInscritosTandas.
  ///
  /// In es, this message translates to:
  /// **'No hay equipos inscritos en las tandas de esta prueba.'**
  String get noHayEquiposInscritosTandas;

  /// No description provided for @sorteoBloqueadoTexto.
  ///
  /// In es, this message translates to:
  /// **'{motivo} El sorteo queda en solo lectura.'**
  String sorteoBloqueadoTexto(String motivo);

  /// No description provided for @equipos.
  ///
  /// In es, this message translates to:
  /// **'Equipos'**
  String get equipos;

  /// No description provided for @numeros.
  ///
  /// In es, this message translates to:
  /// **'Números'**
  String get numeros;

  /// No description provided for @noQuedanMotores.
  ///
  /// In es, this message translates to:
  /// **'No quedan motores disponibles.'**
  String get noQuedanMotores;

  /// No description provided for @motorSorteado.
  ///
  /// In es, this message translates to:
  /// **'Motor sorteado'**
  String get motorSorteado;

  /// No description provided for @repetir.
  ///
  /// In es, this message translates to:
  /// **'Repetir'**
  String get repetir;

  /// No description provided for @asignar.
  ///
  /// In es, this message translates to:
  /// **'Asignar'**
  String get asignar;

  /// No description provided for @faltanMotores.
  ///
  /// In es, this message translates to:
  /// **'Faltan motores: {equipos} equipos y solo {motores} motores disponibles.'**
  String faltanMotores(int equipos, int motores);

  /// No description provided for @motoresRango.
  ///
  /// In es, this message translates to:
  /// **'Motores {min}–{max}'**
  String motoresRango(int min, int max);

  /// No description provided for @asignadosDe.
  ///
  /// In es, this message translates to:
  /// **'{asignados}/{total} asignados'**
  String asignadosDe(int asignados, int total);

  /// No description provided for @disponiblesN.
  ///
  /// In es, this message translates to:
  /// **'{n} disponibles'**
  String disponiblesN(int n);

  /// No description provided for @sortear.
  ///
  /// In es, this message translates to:
  /// **'Sortear'**
  String get sortear;

  /// No description provided for @numeroMotor.
  ///
  /// In es, this message translates to:
  /// **'Nº {n}'**
  String numeroMotor(int n);

  /// No description provided for @volverASortear.
  ///
  /// In es, this message translates to:
  /// **'Volver a sortear'**
  String get volverASortear;

  /// No description provided for @quitarMotor.
  ///
  /// In es, this message translates to:
  /// **'Quitar motor'**
  String get quitarMotor;

  /// No description provided for @faltaRangoMotores.
  ///
  /// In es, this message translates to:
  /// **'Falta configurar el rango de motores'**
  String get faltaRangoMotores;

  /// No description provided for @faltaRangoMotoresTexto.
  ///
  /// In es, this message translates to:
  /// **'Define el rango de números de motor de organización en el campeonato para poder sortearlos.'**
  String get faltaRangoMotoresTexto;

  /// No description provided for @configurarCampeonato.
  ///
  /// In es, this message translates to:
  /// **'Configurar campeonato'**
  String get configurarCampeonato;

  /// No description provided for @rangoMotoresNoConfigurado.
  ///
  /// In es, this message translates to:
  /// **'Rango de motores no configurado.'**
  String get rangoMotoresNoConfigurado;

  /// No description provided for @asignado.
  ///
  /// In es, this message translates to:
  /// **'Asignado'**
  String get asignado;

  /// No description provided for @disponible.
  ///
  /// In es, this message translates to:
  /// **'Disponible'**
  String get disponible;

  /// No description provided for @tanda.
  ///
  /// In es, this message translates to:
  /// **'Tanda'**
  String get tanda;

  /// No description provided for @verificaciones.
  ///
  /// In es, this message translates to:
  /// **'Verificaciones'**
  String get verificaciones;

  /// No description provided for @renumerarCarriles.
  ///
  /// In es, this message translates to:
  /// **'Renumerar carriles'**
  String get renumerarCarriles;

  /// No description provided for @renumerar.
  ///
  /// In es, this message translates to:
  /// **'Renumerar'**
  String get renumerar;

  /// No description provided for @renumerarCarrilesTexto.
  ///
  /// In es, this message translates to:
  /// **'Se vuelven a asignar todos los carriles de \"{nombre}\" por puntos, de más a menos: 1 a {carriles} y, si hay más pilotos, D1, D2… Se pierden los cambios hechos a mano.'**
  String renumerarCarrilesTexto(String nombre, int carriles);

  /// No description provided for @inscribirEquipo.
  ///
  /// In es, this message translates to:
  /// **'Inscribir equipo'**
  String get inscribirEquipo;

  /// No description provided for @aunNoHayEquiposInscritos.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay equipos inscritos'**
  String get aunNoHayEquiposInscritos;

  /// No description provided for @pulsaInscribirEquipo.
  ///
  /// In es, this message translates to:
  /// **'Pulsa \"Inscribir equipo\" para añadirlos uno a uno asignando carril de salida.'**
  String get pulsaInscribirEquipo;

  /// No description provided for @sinCarrilN.
  ///
  /// In es, this message translates to:
  /// **'Sin carril ({n})'**
  String sinCarrilN(int n);

  /// No description provided for @actual.
  ///
  /// In es, this message translates to:
  /// **'actual'**
  String get actual;

  /// No description provided for @libre.
  ///
  /// In es, this message translates to:
  /// **'libre'**
  String get libre;

  /// No description provided for @libreTitulo.
  ///
  /// In es, this message translates to:
  /// **'Libre'**
  String get libreTitulo;

  /// No description provided for @carrilDe.
  ///
  /// In es, this message translates to:
  /// **'Carril de {nombre}'**
  String carrilDe(String nombre);

  /// No description provided for @tocaCarrilLibreTexto.
  ///
  /// In es, this message translates to:
  /// **'Toca un carril libre para moverlo, o uno ocupado para intercambiarlos.'**
  String get tocaCarrilLibreTexto;

  /// No description provided for @pista.
  ///
  /// In es, this message translates to:
  /// **'Pista'**
  String get pista;

  /// No description provided for @descanso.
  ///
  /// In es, this message translates to:
  /// **'Descanso'**
  String get descanso;

  /// No description provided for @seedDirecto.
  ///
  /// In es, this message translates to:
  /// **'Seed directo'**
  String get seedDirecto;

  /// No description provided for @sinCarril.
  ///
  /// In es, this message translates to:
  /// **'Sin carril'**
  String get sinCarril;

  /// No description provided for @escribirAMano.
  ///
  /// In es, this message translates to:
  /// **'Escribir a mano…'**
  String get escribirAMano;

  /// No description provided for @carrilDeSalida.
  ///
  /// In es, this message translates to:
  /// **'Carril de salida'**
  String get carrilDeSalida;

  /// No description provided for @carrilEjemplo.
  ///
  /// In es, this message translates to:
  /// **'Ej: D1, D2, 1, 2, 3…'**
  String get carrilEjemplo;

  /// No description provided for @carrilAyuda.
  ///
  /// In es, this message translates to:
  /// **'D1-D4 para seeds directos, 1-N para sorteo'**
  String get carrilAyuda;

  /// No description provided for @guardar.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get guardar;

  /// No description provided for @quienSaleEnCarril.
  ///
  /// In es, this message translates to:
  /// **'¿Quién sale en el carril {carril}?'**
  String quienSaleEnCarril(String carril);

  /// No description provided for @dejaLibreEl.
  ///
  /// In es, this message translates to:
  /// **'Deja libre el {carril}'**
  String dejaLibreEl(String carril);

  /// No description provided for @carrilesRepetidos.
  ///
  /// In es, this message translates to:
  /// **'Carriles repetidos'**
  String get carrilesRepetidos;

  /// No description provided for @pistersPilotosDe.
  ///
  /// In es, this message translates to:
  /// **'Pisters: pilotos de {tanda}'**
  String pistersPilotosDe(String tanda);

  /// No description provided for @cambiarCarril.
  ///
  /// In es, this message translates to:
  /// **'Cambiar carril'**
  String get cambiarCarril;

  /// No description provided for @quitarSeedDirecto.
  ///
  /// In es, this message translates to:
  /// **'Quitar seed directo'**
  String get quitarSeedDirecto;

  /// No description provided for @marcarSeedDirecto.
  ///
  /// In es, this message translates to:
  /// **'Marcar como seed directo'**
  String get marcarSeedDirecto;

  /// No description provided for @quitarDeLaTanda.
  ///
  /// In es, this message translates to:
  /// **'Quitar de la tanda'**
  String get quitarDeLaTanda;

  /// No description provided for @quitarInscripcion.
  ///
  /// In es, this message translates to:
  /// **'Quitar inscripción'**
  String get quitarInscripcion;

  /// No description provided for @quitarInscripcionTexto.
  ///
  /// In es, this message translates to:
  /// **'¿Quitar a \"{nombre}\" de esta tanda?'**
  String quitarInscripcionTexto(String nombre);

  /// No description provided for @inscribirEquipoEn.
  ///
  /// In es, this message translates to:
  /// **'Inscribir equipo en \"{nombre}\"'**
  String inscribirEquipoEn(String nombre);

  /// No description provided for @buscarEquipoOPiloto.
  ///
  /// In es, this message translates to:
  /// **'Buscar equipo o piloto…'**
  String get buscarEquipoOPiloto;

  /// No description provided for @noHayEquiposEnCampeonatoCrealos.
  ///
  /// In es, this message translates to:
  /// **'No hay equipos en este campeonato. Créalos primero.'**
  String get noHayEquiposEnCampeonatoCrealos;

  /// No description provided for @todosLosEquiposYaInscritos.
  ///
  /// In es, this message translates to:
  /// **'Todos los equipos ya están inscritos.'**
  String get todosLosEquiposYaInscritos;

  /// No description provided for @inscribir.
  ///
  /// In es, this message translates to:
  /// **'Inscribir'**
  String get inscribir;

  /// No description provided for @carrilEjemploCorto.
  ///
  /// In es, this message translates to:
  /// **'Ej: D1, 3…'**
  String get carrilEjemploCorto;

  /// No description provided for @carrilAyudaVacio.
  ///
  /// In es, this message translates to:
  /// **'Deja vacío si aún no asignas carril'**
  String get carrilAyudaVacio;

  /// No description provided for @inscritosALaPrueba.
  ///
  /// In es, this message translates to:
  /// **'Inscritos a la prueba'**
  String get inscritosALaPrueba;

  /// No description provided for @actualizarDesdeDrive.
  ///
  /// In es, this message translates to:
  /// **'Actualizar desde Drive'**
  String get actualizarDesdeDrive;

  /// No description provided for @actualizandoDesdeDrive.
  ///
  /// In es, this message translates to:
  /// **'Actualizando desde Drive…'**
  String get actualizandoDesdeDrive;

  /// No description provided for @anadirPiloto.
  ///
  /// In es, this message translates to:
  /// **'Añadir piloto'**
  String get anadirPiloto;

  /// No description provided for @anadirEquipo.
  ///
  /// In es, this message translates to:
  /// **'Añadir equipo'**
  String get anadirEquipo;

  /// No description provided for @importar.
  ///
  /// In es, this message translates to:
  /// **'Importar'**
  String get importar;

  /// No description provided for @vincularGoogleSheet.
  ///
  /// In es, this message translates to:
  /// **'Vincular Google Sheet'**
  String get vincularGoogleSheet;

  /// No description provided for @desdeArchivoCsvExcel.
  ///
  /// In es, this message translates to:
  /// **'Desde archivo CSV / Excel'**
  String get desdeArchivoCsvExcel;

  /// No description provided for @generarTandas.
  ///
  /// In es, this message translates to:
  /// **'Generar tandas'**
  String get generarTandas;

  /// No description provided for @aunNoHayPilotosInscritosPrueba.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay pilotos inscritos a esta prueba'**
  String get aunNoHayPilotosInscritosPrueba;

  /// No description provided for @aunNoHayEquiposInscritosPrueba.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay equipos inscritos a esta prueba'**
  String get aunNoHayEquiposInscritosPrueba;

  /// No description provided for @importaCsvGoogleFormPilotos.
  ///
  /// In es, this message translates to:
  /// **'Importa el CSV/Excel del Google Form o añade pilotos a mano.'**
  String get importaCsvGoogleFormPilotos;

  /// No description provided for @importaCsvGoogleFormEquipos.
  ///
  /// In es, this message translates to:
  /// **'Importa el CSV/Excel del Google Form o añade equipos a mano.'**
  String get importaCsvGoogleFormEquipos;

  /// No description provided for @importarCsvExcel.
  ///
  /// In es, this message translates to:
  /// **'Importar CSV/Excel'**
  String get importarCsvExcel;

  /// No description provided for @anadirAMano.
  ///
  /// In es, this message translates to:
  /// **'Añadir a mano'**
  String get anadirAMano;

  /// No description provided for @pilotosInscritosGenerarTandas.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 piloto inscrito. Cuando los tengas todos, pulsa \"Generar tandas\".} other{{n} pilotos inscritos. Cuando los tengas todos, pulsa \"Generar tandas\".}}'**
  String pilotosInscritosGenerarTandas(int n);

  /// No description provided for @equiposInscritosGenerarTandas.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 equipo inscrito. Cuando los tengas todos, pulsa \"Generar tandas\".} other{{n} equipos inscritos. Cuando los tengas todos, pulsa \"Generar tandas\".}}'**
  String equiposInscritosGenerarTandas(int n);

  /// No description provided for @darDeBaja.
  ///
  /// In es, this message translates to:
  /// **'Dar de baja'**
  String get darDeBaja;

  /// No description provided for @darDeBajaTexto.
  ///
  /// In es, this message translates to:
  /// **'¿Dar de baja a \"{nombre}\"?\n\nSe quita de Inscritos y de su tanda. Los carriles del resto no cambian: si hace falta, renumera la tanda después.'**
  String darDeBajaTexto(String nombre);

  /// No description provided for @inscribirPilotos.
  ///
  /// In es, this message translates to:
  /// **'Inscribir pilotos'**
  String get inscribirPilotos;

  /// No description provided for @inscribirEquipos.
  ///
  /// In es, this message translates to:
  /// **'Inscribir equipos'**
  String get inscribirEquipos;

  /// No description provided for @nSeleccionados.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 seleccionado} other{{n} seleccionados}}'**
  String nSeleccionados(int n);

  /// No description provided for @limpiar.
  ///
  /// In es, this message translates to:
  /// **'Limpiar'**
  String get limpiar;

  /// No description provided for @buscarPiloto.
  ///
  /// In es, this message translates to:
  /// **'Buscar piloto…'**
  String get buscarPiloto;

  /// No description provided for @noHayPilotosEnCampeonato.
  ///
  /// In es, this message translates to:
  /// **'No hay pilotos en este campeonato.'**
  String get noHayPilotosEnCampeonato;

  /// No description provided for @noHayEquiposEnCampeonato.
  ///
  /// In es, this message translates to:
  /// **'No hay equipos en este campeonato.'**
  String get noHayEquiposEnCampeonato;

  /// No description provided for @todosYaInscritos.
  ///
  /// In es, this message translates to:
  /// **'Todos están ya inscritos.'**
  String get todosYaInscritos;

  /// No description provided for @nuevaInscripcion.
  ///
  /// In es, this message translates to:
  /// **'Nueva inscripción'**
  String get nuevaInscripcion;

  /// No description provided for @nuevoEquipo.
  ///
  /// In es, this message translates to:
  /// **'Nuevo equipo'**
  String get nuevoEquipo;

  /// No description provided for @copaParaPilotosNuevos.
  ///
  /// In es, this message translates to:
  /// **'Copa para pilotos nuevos:'**
  String get copaParaPilotosNuevos;

  /// No description provided for @desmarcarTodos.
  ///
  /// In es, this message translates to:
  /// **'Desmarcar todos'**
  String get desmarcarTodos;

  /// No description provided for @marcarTodosN.
  ///
  /// In es, this message translates to:
  /// **'Marcar todos ({n})'**
  String marcarTodosN(int n);

  /// No description provided for @nuevaInscripcionCopa.
  ///
  /// In es, this message translates to:
  /// **'Nueva inscripción · Copa {copa}'**
  String nuevaInscripcionCopa(String copa);

  /// No description provided for @marcaPilotosInscribir.
  ///
  /// In es, this message translates to:
  /// **'Marca los pilotos que quieras inscribir'**
  String get marcaPilotosInscribir;

  /// No description provided for @marcaEquiposInscribir.
  ///
  /// In es, this message translates to:
  /// **'Marca los equipos que quieras inscribir'**
  String get marcaEquiposInscribir;

  /// No description provided for @inscribirNPilotos.
  ///
  /// In es, this message translates to:
  /// **'Inscribir {n, plural, =1{1 piloto} other{{n} pilotos}}'**
  String inscribirNPilotos(int n);

  /// No description provided for @inscribirNEquipos.
  ///
  /// In es, this message translates to:
  /// **'Inscribir {n, plural, =1{1 equipo} other{{n} equipos}}'**
  String inscribirNEquipos(int n);

  /// No description provided for @importarInscripciones.
  ///
  /// In es, this message translates to:
  /// **'Importar inscripciones'**
  String get importarInscripciones;

  /// No description provided for @csvGoogleFormInscripcionPilotos.
  ///
  /// In es, this message translates to:
  /// **'CSV/Excel del Google Form de inscripción a la prueba. Las inscripciones se vinculan a pilotos existentes por nombre.'**
  String get csvGoogleFormInscripcionPilotos;

  /// No description provided for @csvGoogleFormInscripcionEquipos.
  ///
  /// In es, this message translates to:
  /// **'CSV/Excel del Google Form de inscripción a la prueba. Las inscripciones se vinculan a equipos existentes por nombre.'**
  String get csvGoogleFormInscripcionEquipos;

  /// No description provided for @paso2AsignaColumnas.
  ///
  /// In es, this message translates to:
  /// **'2. Asigna columnas'**
  String get paso2AsignaColumnas;

  /// No description provided for @nombreDelPilotoObligatorio.
  ///
  /// In es, this message translates to:
  /// **'Nombre del piloto *'**
  String get nombreDelPilotoObligatorio;

  /// No description provided for @nombreDelEquipoObligatorio.
  ///
  /// In es, this message translates to:
  /// **'Nombre del equipo *'**
  String get nombreDelEquipoObligatorio;

  /// No description provided for @diaPreferidoOpcional.
  ///
  /// In es, this message translates to:
  /// **'Día preferido (opcional)'**
  String get diaPreferidoOpcional;

  /// No description provided for @notasOpcional.
  ///
  /// In es, this message translates to:
  /// **'Notas (opcional)'**
  String get notasOpcional;

  /// No description provided for @paso3VistaPrevia.
  ///
  /// In es, this message translates to:
  /// **'3. Vista previa'**
  String get paso3VistaPrevia;

  /// No description provided for @nDeTotalSeImportaran.
  ///
  /// In es, this message translates to:
  /// **'{n} de {total} se importarán'**
  String nDeTotalSeImportaran(int n, int total);

  /// No description provided for @pilotosNoExistenAviso.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{⚠️ 1 piloto no existe en el campeonato. Créalo primero o revisa el nombre.} other{⚠️ {n} pilotos no existen en el campeonato. Créalos primero o revisa el nombre.}}'**
  String pilotosNoExistenAviso(int n);

  /// No description provided for @equiposNoExistenAvisoImport.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{⚠️ 1 equipo no existe en el campeonato. Créalo primero o revisa el nombre.} other{⚠️ {n} equipos no existen en el campeonato. Créalos primero o revisa el nombre.}}'**
  String equiposNoExistenAvisoImport(int n);

  /// No description provided for @asignaColumnaPiloto.
  ///
  /// In es, this message translates to:
  /// **'Asigna la columna del nombre del piloto.'**
  String get asignaColumnaPiloto;

  /// No description provided for @asignaColumnaEquipo.
  ///
  /// In es, this message translates to:
  /// **'Asigna la columna del nombre del equipo.'**
  String get asignaColumnaEquipo;

  /// No description provided for @ninguna.
  ///
  /// In es, this message translates to:
  /// **'— ninguna —'**
  String get ninguna;

  /// No description provided for @yaInscrito.
  ///
  /// In es, this message translates to:
  /// **'Ya inscrito'**
  String get yaInscrito;

  /// No description provided for @diaTexto.
  ///
  /// In es, this message translates to:
  /// **'Día: {dia}'**
  String diaTexto(String dia);

  /// No description provided for @noSePudoLeer.
  ///
  /// In es, this message translates to:
  /// **'No se pudo leer: {detalle}'**
  String noSePudoLeer(String detalle);

  /// No description provided for @resumenImportacionInscripciones.
  ///
  /// In es, this message translates to:
  /// **'✓ Inscritos: {ok}\n✗ Saltados: {saltados}'**
  String resumenImportacionInscripciones(int ok, int saltados);

  /// No description provided for @tandaNumero.
  ///
  /// In es, this message translates to:
  /// **'Tanda {n}'**
  String tandaNumero(int n);

  /// No description provided for @tandasCreadas.
  ///
  /// In es, this message translates to:
  /// **'Tandas creadas'**
  String get tandasCreadas;

  /// No description provided for @tandasCreadasTexto.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{Se ha creado 1 tanda con {equipos} equipos.} other{Se han creado {n} tandas con {equipos} equipos.}}'**
  String tandasCreadasTexto(int n, int equipos);

  /// No description provided for @conCarrilAsignado.
  ///
  /// In es, this message translates to:
  /// **'Con carril de salida asignado.'**
  String get conCarrilAsignado;

  /// No description provided for @carrilesSeAsignaranAntes.
  ///
  /// In es, this message translates to:
  /// **'Los carriles se asignarán antes de la carrera.'**
  String get carrilesSeAsignaranAntes;

  /// No description provided for @pistersAsignadosEntreTandas.
  ///
  /// In es, this message translates to:
  /// **'Pisters asignados entre las tandas de cada día.'**
  String get pistersAsignadosEntreTandas;

  /// No description provided for @equiposInscritosARepartir.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 equipo inscrito a repartir} other{{n} equipos inscritos a repartir}}'**
  String equiposInscritosARepartir(int n);

  /// No description provided for @ordenadosPorPuntos.
  ///
  /// In es, this message translates to:
  /// **'Ordenados por puntos brutos acumulados.'**
  String get ordenadosPorPuntos;

  /// No description provided for @sinPuntosEsteAnio.
  ///
  /// In es, this message translates to:
  /// **'Sin puntos este año → ordenados por saldo año anterior (0 si no hay).'**
  String get sinPuntosEsteAnio;

  /// No description provided for @paso1CarrilesPista.
  ///
  /// In es, this message translates to:
  /// **'1. Carriles de la pista'**
  String get paso1CarrilesPista;

  /// No description provided for @paso1CarrilesTexto.
  ///
  /// In es, this message translates to:
  /// **'Cuántos coches corren a la vez. Marca el máximo de equipos por tanda para repartirlos bien.'**
  String get paso1CarrilesTexto;

  /// No description provided for @carrilesMin.
  ///
  /// In es, this message translates to:
  /// **'carriles'**
  String get carrilesMin;

  /// No description provided for @minutosPorCarrilTexto.
  ///
  /// In es, this message translates to:
  /// **'Minutos por carril (cuánto dura el turno de un equipo en cada carril, para calcular la duración de la tanda).'**
  String get minutosPorCarrilTexto;

  /// No description provided for @minPorCarril.
  ///
  /// In es, this message translates to:
  /// **'min/carril'**
  String get minPorCarril;

  /// No description provided for @cadaTandaDurara.
  ///
  /// In es, this message translates to:
  /// **'Cada tanda durará ~{minutos} min ({carriles} carriles × {minPorCarril} min).'**
  String cadaTandaDurara(int minutos, int carriles, int minPorCarril);

  /// No description provided for @paso2NumeroTandas.
  ///
  /// In es, this message translates to:
  /// **'2. Número de tandas'**
  String get paso2NumeroTandas;

  /// No description provided for @sugeridoTexto.
  ///
  /// In es, this message translates to:
  /// **'Sugerido: {n} (sin carriles vacíos con {carriles} carriles: si sobran equipos, las tandas pasan de {carriles}). Puedes cambiarlo.'**
  String sugeridoTexto(int n, int carriles);

  /// No description provided for @paso3NombresHorarios.
  ///
  /// In es, this message translates to:
  /// **'3. Nombres y horarios'**
  String get paso3NombresHorarios;

  /// No description provided for @asignarCarrilAutomatico.
  ///
  /// In es, this message translates to:
  /// **'Asignar carril automáticamente'**
  String get asignarCarrilAutomatico;

  /// No description provided for @asignarCarrilTexto.
  ///
  /// In es, this message translates to:
  /// **'Por puntos, de más a menos: carriles 1 a {carriles} y, si hay más pilotos, D1, D2…'**
  String asignarCarrilTexto(int carriles);

  /// No description provided for @asignarPisters.
  ///
  /// In es, this message translates to:
  /// **'Asignar pisters'**
  String get asignarPisters;

  /// No description provided for @asignarPistersTexto.
  ///
  /// In es, this message translates to:
  /// **'Entre las tandas del mismo día. 2 tandas: 1ª↔2ª. 3: la 3ª hace de pisters en la 1ª, la 1ª en la 2ª y la 2ª en la 3ª. 4: 1ª↔2ª y 3ª↔4ª.'**
  String get asignarPistersTexto;

  /// No description provided for @paso4VistaPrevia.
  ///
  /// In es, this message translates to:
  /// **'4. Vista previa'**
  String get paso4VistaPrevia;

  /// No description provided for @numeroIzquierdaCarril.
  ///
  /// In es, this message translates to:
  /// **'El número de la izquierda es el carril de salida.'**
  String get numeroIzquierdaCarril;

  /// No description provided for @carrilesLosAsignarasDespues.
  ///
  /// In es, this message translates to:
  /// **'Los carriles los asignarás después, antes de la carrera.'**
  String get carrilesLosAsignarasDespues;

  /// No description provided for @sinTandaN.
  ///
  /// In es, this message translates to:
  /// **'Sin tanda ({n})'**
  String sinTandaN(int n);

  /// No description provided for @sinTandaTexto.
  ///
  /// In es, this message translates to:
  /// **'Estos equipos prefieren un día que no tiene ninguna tanda en este reparto. Añade una tanda de ese día arriba o cambia su preferencia.'**
  String get sinTandaTexto;

  /// No description provided for @prefiereDia.
  ///
  /// In es, this message translates to:
  /// **'Prefiere: {dia}'**
  String prefiereDia(String dia);

  /// No description provided for @sustituirTandasExistentes.
  ///
  /// In es, this message translates to:
  /// **'Sustituir tandas existentes'**
  String get sustituirTandasExistentes;

  /// No description provided for @sustituirTandasTexto.
  ///
  /// In es, this message translates to:
  /// **'Si esta prueba ya tenía tandas, se eliminan y se reemplazan.'**
  String get sustituirTandasTexto;

  /// No description provided for @crearEstasTandas.
  ///
  /// In es, this message translates to:
  /// **'Crear estas tandas'**
  String get crearEstasTandas;

  /// No description provided for @eligeLaCarrera.
  ///
  /// In es, this message translates to:
  /// **'Elige la carrera'**
  String get eligeLaCarrera;

  /// No description provided for @verCarreras.
  ///
  /// In es, this message translates to:
  /// **'Ver carreras'**
  String get verCarreras;

  /// No description provided for @resultadosDeCarrera.
  ///
  /// In es, this message translates to:
  /// **'Resultados: {nombre}'**
  String resultadosDeCarrera(String nombre);

  /// No description provided for @noSePudoConectar.
  ///
  /// In es, this message translates to:
  /// **'No se pudo conectar: {detalle}'**
  String noSePudoConectar(String detalle);

  /// No description provided for @noSePudieronTraerResultados.
  ///
  /// In es, this message translates to:
  /// **'No se pudieron traer los resultados: {detalle}'**
  String noSePudieronTraerResultados(String detalle);

  /// No description provided for @noHayCampeonatoActivo.
  ///
  /// In es, this message translates to:
  /// **'No hay campeonato activo.'**
  String get noHayCampeonatoActivo;

  /// No description provided for @resultadosAplicadosSaltados.
  ///
  /// In es, this message translates to:
  /// **'Resultados aplicados: {ok} · saltados: {saltados}'**
  String resultadosAplicadosSaltados(int ok, int saltados);

  /// No description provided for @errorAlAplicar.
  ///
  /// In es, this message translates to:
  /// **'Error al aplicar: {detalle}'**
  String errorAlAplicar(String detalle);

  /// No description provided for @pitwallNoTieneCarreras.
  ///
  /// In es, this message translates to:
  /// **'PitWall no tiene carreras.'**
  String get pitwallNoTieneCarreras;

  /// No description provided for @pitwallNoTieneCarrerasEnvia.
  ///
  /// In es, this message translates to:
  /// **'PitWall no tiene carreras. Envía antes una tanda («Enviar a PitWall») o crea la carrera en Manager.'**
  String get pitwallNoTieneCarrerasEnvia;

  /// No description provided for @tandasDeCarrera.
  ///
  /// In es, this message translates to:
  /// **'{n} tanda(s)'**
  String tandasDeCarrera(int n);

  /// No description provided for @laCarreraNoTieneResultados.
  ///
  /// In es, this message translates to:
  /// **'La carrera no tiene resultados todavía.'**
  String get laCarreraNoTieneResultados;

  /// No description provided for @equipoNoEncontradoCampeonato.
  ///
  /// In es, this message translates to:
  /// **'Equipo no encontrado en el campeonato'**
  String get equipoNoEncontradoCampeonato;

  /// No description provided for @noInscritoEnEstaPrueba.
  ///
  /// In es, this message translates to:
  /// **'No inscrito en esta prueba'**
  String get noInscritoEnEstaPrueba;

  /// No description provided for @seAplicaraPosicion.
  ///
  /// In es, this message translates to:
  /// **'se aplicará posición {posicion}'**
  String seAplicaraPosicion(int posicion);

  /// No description provided for @aplicarN.
  ///
  /// In es, this message translates to:
  /// **'Aplicar ({n})'**
  String aplicarN(int n);

  /// No description provided for @tandaAbrev.
  ///
  /// In es, this message translates to:
  /// **'T{n}'**
  String tandaAbrev(int n);

  /// No description provided for @seEnvianComoConsulta.
  ///
  /// In es, this message translates to:
  /// **'Se envían a modo de consulta: en PitWall se podrán ver pero no editar.'**
  String get seEnvianComoConsulta;

  /// No description provided for @atras.
  ///
  /// In es, this message translates to:
  /// **'Atrás'**
  String get atras;

  /// No description provided for @noHayVerificacionesEnviar.
  ///
  /// In es, this message translates to:
  /// **'No hay verificaciones que enviar en esta prueba.'**
  String get noHayVerificacionesEnviar;

  /// No description provided for @copaDosPuntos.
  ///
  /// In es, this message translates to:
  /// **'Copa: {copa}'**
  String copaDosPuntos(String copa);

  /// No description provided for @aunNoHayEquiposEnEstaTanda.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay equipos en esta tanda'**
  String get aunNoHayEquiposEnEstaTanda;

  /// No description provided for @inscribeEquiposVerificacion.
  ///
  /// In es, this message translates to:
  /// **'Inscribe equipos en la tanda para poder hacerles la verificación.'**
  String get inscribeEquiposVerificacion;

  /// No description provided for @nConVerificacion.
  ///
  /// In es, this message translates to:
  /// **'{n} con verificación'**
  String nConVerificacion(int n);

  /// No description provided for @nValidadas.
  ///
  /// In es, this message translates to:
  /// **'{n} validadas'**
  String nValidadas(int n);

  /// No description provided for @quitarParticipante.
  ///
  /// In es, this message translates to:
  /// **'Quitar participante'**
  String get quitarParticipante;

  /// No description provided for @quitarConVerificacionTexto.
  ///
  /// In es, this message translates to:
  /// **'Se quitará \"{nombre}\" y se borrará su verificación. ¿Continuar?'**
  String quitarConVerificacionTexto(String nombre);

  /// No description provided for @quitarSinVerificacionTexto.
  ///
  /// In es, this message translates to:
  /// **'Se quitará \"{nombre}\". ¿Continuar?'**
  String quitarSinVerificacionTexto(String nombre);

  /// No description provided for @validada.
  ///
  /// In es, this message translates to:
  /// **'Validada'**
  String get validada;

  /// No description provided for @borrador.
  ///
  /// In es, this message translates to:
  /// **'Borrador'**
  String get borrador;

  /// No description provided for @enRevision.
  ///
  /// In es, this message translates to:
  /// **'En revisión'**
  String get enRevision;

  /// No description provided for @pendiente.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get pendiente;

  /// No description provided for @sinCocheAsignado.
  ///
  /// In es, this message translates to:
  /// **'Sin coche asignado'**
  String get sinCocheAsignado;

  /// No description provided for @sesionCerrada.
  ///
  /// In es, this message translates to:
  /// **'La sesión está cerrada.'**
  String get sesionCerrada;

  /// No description provided for @campeonatoFinalizado.
  ///
  /// In es, this message translates to:
  /// **'El campeonato está finalizado.'**
  String get campeonatoFinalizado;

  /// No description provided for @pruebaTerminada.
  ///
  /// In es, this message translates to:
  /// **'La prueba está terminada.'**
  String get pruebaTerminada;

  /// No description provided for @exportar.
  ///
  /// In es, this message translates to:
  /// **'Exportar'**
  String get exportar;

  /// No description provided for @exportarPdf.
  ///
  /// In es, this message translates to:
  /// **'Exportar a PDF'**
  String get exportarPdf;

  /// No description provided for @exportarExcel.
  ///
  /// In es, this message translates to:
  /// **'Exportar a Excel'**
  String get exportarExcel;

  /// No description provided for @noHayPruebasEnCampeonato.
  ///
  /// In es, this message translates to:
  /// **'No hay pruebas en este campeonato.'**
  String get noHayPruebasEnCampeonato;

  /// No description provided for @noHayInscritosNiVerificaciones.
  ///
  /// In es, this message translates to:
  /// **'No hay inscritos ni verificaciones en esta prueba.'**
  String get noHayInscritosNiVerificaciones;

  /// No description provided for @buscarPilotoEquipoCopa.
  ///
  /// In es, this message translates to:
  /// **'Buscar piloto, equipo, copa…'**
  String get buscarPilotoEquipoCopa;

  /// No description provided for @filtroTodos.
  ///
  /// In es, this message translates to:
  /// **'Todos ({n})'**
  String filtroTodos(int n);

  /// No description provided for @filtroConInfraccion.
  ///
  /// In es, this message translates to:
  /// **'Con infracción ({n})'**
  String filtroConInfraccion(int n);

  /// No description provided for @filtroSinVerificar.
  ///
  /// In es, this message translates to:
  /// **'Sin verificar ({n})'**
  String filtroSinVerificar(int n);

  /// No description provided for @filtroBorrador.
  ///
  /// In es, this message translates to:
  /// **'Borrador ({n})'**
  String filtroBorrador(int n);

  /// No description provided for @validadasDeTotal.
  ///
  /// In es, this message translates to:
  /// **'{validadas} validadas de {total}'**
  String validadasDeTotal(int validadas, int total);

  /// No description provided for @nadaConEsteFiltro.
  ///
  /// In es, this message translates to:
  /// **'Nada que mostrar con este filtro.'**
  String get nadaConEsteFiltro;

  /// No description provided for @colPilotoEquipo.
  ///
  /// In es, this message translates to:
  /// **'Piloto / equipo'**
  String get colPilotoEquipo;

  /// No description provided for @fueraDeReglamento.
  ///
  /// In es, this message translates to:
  /// **'Fuera de reglamento'**
  String get fueraDeReglamento;

  /// No description provided for @copa.
  ///
  /// In es, this message translates to:
  /// **'Copa'**
  String get copa;

  /// No description provided for @coche.
  ///
  /// In es, this message translates to:
  /// **'Coche'**
  String get coche;

  /// No description provided for @colPesoCarroc.
  ///
  /// In es, this message translates to:
  /// **'Peso carroc.'**
  String get colPesoCarroc;

  /// No description provided for @colPesoMin.
  ///
  /// In es, this message translates to:
  /// **'Peso mín.'**
  String get colPesoMin;

  /// No description provided for @colPesoCoche.
  ///
  /// In es, this message translates to:
  /// **'Peso coche'**
  String get colPesoCoche;

  /// No description provided for @motor.
  ///
  /// In es, this message translates to:
  /// **'Motor'**
  String get motor;

  /// No description provided for @alturaMotor.
  ///
  /// In es, this message translates to:
  /// **'Altura motor'**
  String get alturaMotor;

  /// No description provided for @colEjeDel.
  ///
  /// In es, this message translates to:
  /// **'Eje del.'**
  String get colEjeDel;

  /// No description provided for @colEjeTras.
  ///
  /// In es, this message translates to:
  /// **'Eje tras.'**
  String get colEjeTras;

  /// No description provided for @pinon.
  ///
  /// In es, this message translates to:
  /// **'Piñón'**
  String get pinon;

  /// No description provided for @corona.
  ///
  /// In es, this message translates to:
  /// **'Corona'**
  String get corona;

  /// No description provided for @llantaDelantera.
  ///
  /// In es, this message translates to:
  /// **'Llanta delantera'**
  String get llantaDelantera;

  /// No description provided for @llantaTrasera.
  ///
  /// In es, this message translates to:
  /// **'Llanta trasera'**
  String get llantaTrasera;

  /// No description provided for @trencilla.
  ///
  /// In es, this message translates to:
  /// **'Trencilla'**
  String get trencilla;

  /// No description provided for @suspension.
  ///
  /// In es, this message translates to:
  /// **'Suspensión'**
  String get suspension;

  /// No description provided for @bancada.
  ///
  /// In es, this message translates to:
  /// **'Bancada'**
  String get bancada;

  /// No description provided for @chasis.
  ///
  /// In es, this message translates to:
  /// **'Chasis'**
  String get chasis;

  /// No description provided for @neumatico.
  ///
  /// In es, this message translates to:
  /// **'Neumático'**
  String get neumatico;

  /// No description provided for @carroceria.
  ///
  /// In es, this message translates to:
  /// **'Carrocería'**
  String get carroceria;

  /// No description provided for @observaciones.
  ///
  /// In es, this message translates to:
  /// **'Observaciones'**
  String get observaciones;

  /// No description provided for @sinVerificar.
  ///
  /// In es, this message translates to:
  /// **'Sin verificar'**
  String get sinVerificar;

  /// No description provided for @propio.
  ///
  /// In es, this message translates to:
  /// **'Propio'**
  String get propio;

  /// No description provided for @orgNumero.
  ///
  /// In es, this message translates to:
  /// **'Org. nº {n}'**
  String orgNumero(String n);

  /// No description provided for @conforme.
  ///
  /// In es, this message translates to:
  /// **'Conforme'**
  String get conforme;

  /// No description provided for @noConforme.
  ///
  /// In es, this message translates to:
  /// **'No conforme'**
  String get noConforme;

  /// No description provided for @toca.
  ///
  /// In es, this message translates to:
  /// **'Toca'**
  String get toca;

  /// No description provided for @bien.
  ///
  /// In es, this message translates to:
  /// **'Bien'**
  String get bien;

  /// No description provided for @faltanPiezas.
  ///
  /// In es, this message translates to:
  /// **'Faltan piezas'**
  String get faltanPiezas;

  /// No description provided for @faltanPiezasDetalle.
  ///
  /// In es, this message translates to:
  /// **'Faltan: {piezas}'**
  String faltanPiezasDetalle(String piezas);

  /// No description provided for @marcaNoPermitida.
  ///
  /// In es, this message translates to:
  /// **'Marca \"{marca}\" no permitida'**
  String marcaNoPermitida(String marca);

  /// No description provided for @superaMaximoMm.
  ///
  /// In es, this message translates to:
  /// **'Supera el máximo de {maximo} mm'**
  String superaMaximoMm(String maximo);

  /// No description provided for @porDebajoMinimoG.
  ///
  /// In es, this message translates to:
  /// **'Por debajo del mínimo de {minimo} g'**
  String porDebajoMinimoG(String minimo);

  /// No description provided for @alturaMotorNoConforme.
  ///
  /// In es, this message translates to:
  /// **'Altura de motor no conforme'**
  String get alturaMotorNoConforme;

  /// No description provided for @leFaltanPiezas.
  ///
  /// In es, this message translates to:
  /// **'Le faltan piezas'**
  String get leFaltanPiezas;

  /// No description provided for @vPesoInicialBajo.
  ///
  /// In es, this message translates to:
  /// **'Peso inicial {valor}g por debajo del mínimo {minimo}g.'**
  String vPesoInicialBajo(String valor, String minimo);

  /// No description provided for @vPesoFinalBajo.
  ///
  /// In es, this message translates to:
  /// **'Peso final {valor}g por debajo del mínimo {minimo}g.'**
  String vPesoFinalBajo(String valor, String minimo);

  /// No description provided for @vMotorSinCatalogo.
  ///
  /// In es, this message translates to:
  /// **'Selecciona el motor del catálogo para comprobar las medidas.'**
  String get vMotorSinCatalogo;

  /// No description provided for @vMotorRpmAlto.
  ///
  /// In es, this message translates to:
  /// **'RPM por encima de la referencia del {motor} (máx {max}, medidas {medido}).'**
  String vMotorRpmAlto(String motor, String max, String medido);

  /// No description provided for @vMotorUmsAlto.
  ///
  /// In es, this message translates to:
  /// **'Imán por encima de la referencia del {motor} (máx {max}, medido {medido}).'**
  String vMotorUmsAlto(String motor, String max, String medido);

  /// No description provided for @vAlturaNoConforme.
  ///
  /// In es, this message translates to:
  /// **'Altura de motor no conforme: toca la pista.'**
  String get vAlturaNoConforme;

  /// No description provided for @vEjeDelAncho.
  ///
  /// In es, this message translates to:
  /// **'Anchura de eje delantero {medido} mm por encima del máximo {max} mm.'**
  String vEjeDelAncho(String medido, String max);

  /// No description provided for @vEjeTraAncho.
  ///
  /// In es, this message translates to:
  /// **'Anchura de eje trasero {medido} mm por encima del máximo {max} mm.'**
  String vEjeTraAncho(String medido, String max);

  /// No description provided for @vMarcaNoPermitidaLista.
  ///
  /// In es, this message translates to:
  /// **'Marca \"{marca}\" no permitida (solo {lista}).'**
  String vMarcaNoPermitidaLista(String marca, String lista);

  /// No description provided for @vMarcaFueraCatalogo.
  ///
  /// In es, this message translates to:
  /// **'Marca \"{marca}\" no está en el catálogo.'**
  String vMarcaFueraCatalogo(String marca);

  /// No description provided for @vLlantaDelNoCatalogada.
  ///
  /// In es, this message translates to:
  /// **'Llanta delantera no catalogada: \"{valor}\".'**
  String vLlantaDelNoCatalogada(String valor);

  /// No description provided for @vLlantaTraNoCatalogada.
  ///
  /// In es, this message translates to:
  /// **'Llanta trasera no catalogada: \"{valor}\".'**
  String vLlantaTraNoCatalogada(String valor);

  /// No description provided for @vBancadaNoCatalogada.
  ///
  /// In es, this message translates to:
  /// **'Bancada no catalogada: \"{valor}\".'**
  String vBancadaNoCatalogada(String valor);

  /// No description provided for @vNeumaticoNoCatalogado.
  ///
  /// In es, this message translates to:
  /// **'Neumático no catalogado: \"{valor}\".'**
  String vNeumaticoNoCatalogado(String valor);

  /// No description provided for @vBalanceNegativo.
  ///
  /// In es, this message translates to:
  /// **'Balance de créditos negativo: equipo {equipo} + coche {coche} = {balance}.'**
  String vBalanceNegativo(String equipo, String coche, String balance);

  /// No description provided for @noSePudoGenerarExcel.
  ///
  /// In es, this message translates to:
  /// **'No se pudo generar el Excel.'**
  String get noSePudoGenerarExcel;

  /// No description provided for @buscarPuntos.
  ///
  /// In es, this message translates to:
  /// **'Buscar…'**
  String get buscarPuntos;

  /// No description provided for @sinResultadosPara.
  ///
  /// In es, this message translates to:
  /// **'Sin resultados para \"{filtro}\"'**
  String sinResultadosPara(String filtro);

  /// No description provided for @sinAsignarGuiones.
  ///
  /// In es, this message translates to:
  /// **'— sin asignar —'**
  String get sinAsignarGuiones;

  /// No description provided for @sorteoEtiqueta.
  ///
  /// In es, this message translates to:
  /// **'Sorteo'**
  String get sorteoEtiqueta;

  /// No description provided for @mixto.
  ///
  /// In es, this message translates to:
  /// **'Mixto'**
  String get mixto;

  /// No description provided for @limitarFabricante.
  ///
  /// In es, this message translates to:
  /// **'Limitar fabricante'**
  String get limitarFabricante;

  /// No description provided for @noCatalogada.
  ///
  /// In es, this message translates to:
  /// **'{nombre} (no catalogada)'**
  String noCatalogada(String nombre);

  /// No description provided for @imagenNoSePuedeLeer.
  ///
  /// In es, this message translates to:
  /// **'No se puede leer esa imagen. Usa un PNG o JPG.'**
  String get imagenNoSePuedeLeer;

  /// No description provided for @noSePudoAnadirLogo.
  ///
  /// In es, this message translates to:
  /// **'No se pudo añadir el logo: {detalle}'**
  String noSePudoAnadirLogo(String detalle);

  /// No description provided for @elegirLogo.
  ///
  /// In es, this message translates to:
  /// **'Elegir logo'**
  String get elegirLogo;

  /// No description provided for @cambiarLogo.
  ///
  /// In es, this message translates to:
  /// **'Cambiar logo'**
  String get cambiarLogo;

  /// No description provided for @repartir.
  ///
  /// In es, this message translates to:
  /// **'Repartir'**
  String get repartir;

  /// No description provided for @configuraRangoSesion.
  ///
  /// In es, this message translates to:
  /// **'Configura el rango de motores en el reglamento de la sesión para sortear.'**
  String get configuraRangoSesion;

  /// No description provided for @configuraRangoCampeonato.
  ///
  /// In es, this message translates to:
  /// **'Configura el rango de motores en el campeonato para sortear.'**
  String get configuraRangoCampeonato;

  /// No description provided for @sorteoDeMotor.
  ///
  /// In es, this message translates to:
  /// **'Sorteo de motor'**
  String get sorteoDeMotor;

  /// No description provided for @otroControl.
  ///
  /// In es, this message translates to:
  /// **'Otro Control'**
  String get otroControl;

  /// No description provided for @cambiadaFueraTexto.
  ///
  /// In es, this message translates to:
  /// **'{quien} ha cambiado esta verificación. Si sigues editando, tus cambios sustituirán a los suyos.'**
  String cambiadaFueraTexto(String quien);

  /// No description provided for @seguirConLoMio.
  ///
  /// In es, this message translates to:
  /// **'Seguir con lo mío'**
  String get seguirConLoMio;

  /// No description provided for @verLoDe.
  ///
  /// In es, this message translates to:
  /// **'Ver lo de {quien}'**
  String verLoDe(String quien);

  /// No description provided for @actualizadaConCambios.
  ///
  /// In es, this message translates to:
  /// **'Actualizada con los cambios de {quien}.'**
  String actualizadaConCambios(String quien);

  /// No description provided for @noSePudoAnadirFoto.
  ///
  /// In es, this message translates to:
  /// **'No se pudo añadir la foto: {detalle}'**
  String noSePudoAnadirFoto(String detalle);

  /// No description provided for @copaEnEstaPrueba.
  ///
  /// In es, this message translates to:
  /// **'Copa en esta prueba'**
  String get copaEnEstaPrueba;

  /// No description provided for @copaEnEstaPruebaTexto.
  ///
  /// In es, this message translates to:
  /// **'Cambia la copa solo para esta prueba, sin afectar al equipo ni a otras pruebas.'**
  String get copaEnEstaPruebaTexto;

  /// No description provided for @copaCategoria.
  ///
  /// In es, this message translates to:
  /// **'Copa / categoría'**
  String get copaCategoria;

  /// No description provided for @copaDelEquipo.
  ///
  /// In es, this message translates to:
  /// **'Copa del equipo: {copa}'**
  String copaDelEquipo(String copa);

  /// No description provided for @usarLaDelEquipo.
  ///
  /// In es, this message translates to:
  /// **'Usar la del equipo'**
  String get usarLaDelEquipo;

  /// No description provided for @usarReglamentoActual.
  ///
  /// In es, this message translates to:
  /// **'Usar el reglamento actual'**
  String get usarReglamentoActual;

  /// No description provided for @usarReglamentoActualTexto.
  ///
  /// In es, this message translates to:
  /// **'Esta verificación se comprobará con los valores de hoy del catálogo y del campeonato en lugar de con los que tenía al verificarla:'**
  String get usarReglamentoActualTexto;

  /// No description provided for @recalcularanCreditos.
  ///
  /// In es, this message translates to:
  /// **'Como está validada, se recalcularán sus créditos.'**
  String get recalcularanCreditos;

  /// No description provided for @usarElActual.
  ///
  /// In es, this message translates to:
  /// **'Usar el actual'**
  String get usarElActual;

  /// No description provided for @desbloquearVerificacion.
  ///
  /// In es, this message translates to:
  /// **'Desbloquear la verificación'**
  String get desbloquearVerificacion;

  /// No description provided for @desbloquearTexto.
  ///
  /// In es, this message translates to:
  /// **'{motivo} Sus verificaciones están bloqueadas para no cambiarlas sin querer.\n\nSi la desbloqueas, los cambios se guardarán como siempre. Seguirá comprobándose con el reglamento con el que se verificó.'**
  String desbloquearTexto(String motivo);

  /// No description provided for @desbloquear.
  ///
  /// In es, this message translates to:
  /// **'Desbloquear'**
  String get desbloquear;

  /// No description provided for @verificacion.
  ///
  /// In es, this message translates to:
  /// **'Verificación'**
  String get verificacion;

  /// No description provided for @eliminarVerificacion.
  ///
  /// In es, this message translates to:
  /// **'Eliminar verificación'**
  String get eliminarVerificacion;

  /// No description provided for @eliminarVerificacionTexto.
  ///
  /// In es, this message translates to:
  /// **'Se perderán los datos introducidos. ¿Continuar?'**
  String get eliminarVerificacionTexto;

  /// No description provided for @modeloCoche.
  ///
  /// In es, this message translates to:
  /// **'Modelo de coche'**
  String get modeloCoche;

  /// No description provided for @elegirCoche.
  ///
  /// In es, this message translates to:
  /// **'Elegir coche'**
  String get elegirCoche;

  /// No description provided for @noHayCochesConCopa.
  ///
  /// In es, this message translates to:
  /// **'No hay coches con la copa {copa} en el catálogo'**
  String noHayCochesConCopa(String copa);

  /// No description provided for @ayudaSelectorCoche.
  ///
  /// In es, this message translates to:
  /// **'Se muestran peso mínimo y créditos del coche al elegirlo'**
  String get ayudaSelectorCoche;

  /// No description provided for @creditosAbrev.
  ///
  /// In es, this message translates to:
  /// **'créd'**
  String get creditosAbrev;

  /// No description provided for @pesoGramos.
  ///
  /// In es, this message translates to:
  /// **'Peso (gramos)'**
  String get pesoGramos;

  /// No description provided for @pesoCarroceria.
  ///
  /// In es, this message translates to:
  /// **'Peso carrocería'**
  String get pesoCarroceria;

  /// No description provided for @minimoG.
  ///
  /// In es, this message translates to:
  /// **'Mínimo: {n}g'**
  String minimoG(String n);

  /// No description provided for @estetica.
  ///
  /// In es, this message translates to:
  /// **'Estética'**
  String get estetica;

  /// No description provided for @sinComprobar.
  ///
  /// In es, this message translates to:
  /// **'Sin comprobar'**
  String get sinComprobar;

  /// No description provided for @quePiezasFaltan.
  ///
  /// In es, this message translates to:
  /// **'Qué piezas le faltan'**
  String get quePiezasFaltan;

  /// No description provided for @organizacion.
  ///
  /// In es, this message translates to:
  /// **'Organización'**
  String get organizacion;

  /// No description provided for @numeroDeMotor.
  ///
  /// In es, this message translates to:
  /// **'Número de motor'**
  String get numeroDeMotor;

  /// No description provided for @motorDelCatalogo.
  ///
  /// In es, this message translates to:
  /// **'Motor del catálogo'**
  String get motorDelCatalogo;

  /// No description provided for @elegirMotor.
  ///
  /// In es, this message translates to:
  /// **'Elegir motor'**
  String get elegirMotor;

  /// No description provided for @yaNoEnCatalogo.
  ///
  /// In es, this message translates to:
  /// **'{nombre} (ya no está en el catálogo)'**
  String yaNoEnCatalogo(String nombre);

  /// No description provided for @refMotor.
  ///
  /// In es, this message translates to:
  /// **'Ref: {rpm} RPM · {gauss} gauss'**
  String refMotor(String rpm, String gauss);

  /// No description provided for @motoresHomologadosCopa.
  ///
  /// In es, this message translates to:
  /// **'Motores homologados para la copa {copa}'**
  String motoresHomologadosCopa(String copa);

  /// No description provided for @rpmYGauss.
  ///
  /// In es, this message translates to:
  /// **'{rpm} RPM · {gauss} gauss'**
  String rpmYGauss(String rpm, String gauss);

  /// No description provided for @maxN.
  ///
  /// In es, this message translates to:
  /// **'Máx {n}'**
  String maxN(String n);

  /// No description provided for @alturaMotorAPista.
  ///
  /// In es, this message translates to:
  /// **'Altura de motor a pista'**
  String get alturaMotorAPista;

  /// No description provided for @alturaMotorTexto.
  ///
  /// In es, this message translates to:
  /// **'Comprobación con la plancha: si toca la pista, no conforme.'**
  String get alturaMotorTexto;

  /// No description provided for @delantero.
  ///
  /// In es, this message translates to:
  /// **'Delantero'**
  String get delantero;

  /// No description provided for @trasero.
  ///
  /// In es, this message translates to:
  /// **'Trasero'**
  String get trasero;

  /// No description provided for @marca.
  ///
  /// In es, this message translates to:
  /// **'Marca'**
  String get marca;

  /// No description provided for @dimension.
  ///
  /// In es, this message translates to:
  /// **'Dimensión'**
  String get dimension;

  /// No description provided for @dientes.
  ///
  /// In es, this message translates to:
  /// **'Dientes'**
  String get dientes;

  /// No description provided for @diametro.
  ///
  /// In es, this message translates to:
  /// **'Diámetro'**
  String get diametro;

  /// No description provided for @material.
  ///
  /// In es, this message translates to:
  /// **'Material'**
  String get material;

  /// No description provided for @pesoCocheEntero.
  ///
  /// In es, this message translates to:
  /// **'Peso coche entero (gramos)'**
  String get pesoCocheEntero;

  /// No description provided for @inicial.
  ///
  /// In es, this message translates to:
  /// **'Inicial'**
  String get inicial;

  /// No description provided for @cocheEntero.
  ///
  /// In es, this message translates to:
  /// **'Coche entero'**
  String get cocheEntero;

  /// No description provided for @otros.
  ///
  /// In es, this message translates to:
  /// **'Otros'**
  String get otros;

  /// No description provided for @notasOAvisos.
  ///
  /// In es, this message translates to:
  /// **'Notas o avisos'**
  String get notasOAvisos;

  /// No description provided for @fotosHasta4.
  ///
  /// In es, this message translates to:
  /// **'Fotos (hasta 4)'**
  String get fotosHasta4;

  /// No description provided for @marcarComoValidada.
  ///
  /// In es, this message translates to:
  /// **'Marcar como validada'**
  String get marcarComoValidada;

  /// No description provided for @marcarComoValidadaTexto.
  ///
  /// In es, this message translates to:
  /// **'Indica que la verificación está revisada y aprobada.'**
  String get marcarComoValidadaTexto;

  /// No description provided for @autoguardadoTexto.
  ///
  /// In es, this message translates to:
  /// **'Se guarda solo como borrador con cada cambio.'**
  String get autoguardadoTexto;

  /// No description provided for @validar.
  ///
  /// In es, this message translates to:
  /// **'Validar'**
  String get validar;

  /// No description provided for @noPuedesValidar.
  ///
  /// In es, this message translates to:
  /// **'No puedes validar mientras haya infracciones marcadas en rojo arriba.'**
  String get noPuedesValidar;

  /// No description provided for @fotoReferenciaTexto.
  ///
  /// In es, this message translates to:
  /// **'Foto de referencia del catálogo: comprueba que coincide.'**
  String get fotoReferenciaTexto;

  /// No description provided for @sinFotoCocheTexto.
  ///
  /// In es, this message translates to:
  /// **'Este coche no tiene foto en el catálogo. Añádela en Catálogos → Coches para poder comparar el modelo entregado.'**
  String get sinFotoCocheTexto;

  /// No description provided for @sinGuardar.
  ///
  /// In es, this message translates to:
  /// **'Sin guardar…'**
  String get sinGuardar;

  /// No description provided for @guardando.
  ///
  /// In es, this message translates to:
  /// **'Guardando…'**
  String get guardando;

  /// No description provided for @guardado.
  ///
  /// In es, this message translates to:
  /// **'Guardado'**
  String get guardado;

  /// No description provided for @errorCorto.
  ///
  /// In es, this message translates to:
  /// **'Error'**
  String get errorCorto;

  /// No description provided for @soloLecturaTexto.
  ///
  /// In es, this message translates to:
  /// **'{motivo} Verificación en solo lectura.'**
  String soloLecturaTexto(String motivo);

  /// No description provided for @desbloqueadaTexto.
  ///
  /// In es, this message translates to:
  /// **'{motivo} Desbloqueada: los cambios se guardan.'**
  String desbloqueadaTexto(String motivo);

  /// No description provided for @reglamentoCongelado.
  ///
  /// In es, this message translates to:
  /// **'Reglamento congelado el {fecha}: se comprueba con los valores de cuando se verificó.'**
  String reglamentoCongelado(String fecha);

  /// No description provided for @reglamentoCongeladoSinFecha.
  ///
  /// In es, this message translates to:
  /// **'Reglamento congelado: se comprueba con los valores de cuando se verificó.'**
  String get reglamentoCongeladoSinFecha;

  /// No description provided for @haCambiadoDesdeEntonces.
  ///
  /// In es, this message translates to:
  /// **'Ha cambiado desde entonces (no se aplica):'**
  String get haCambiadoDesdeEntonces;

  /// No description provided for @todoCumple.
  ///
  /// In es, this message translates to:
  /// **'Todo cumple las normas. Puedes validar.'**
  String get todoCumple;

  /// No description provided for @infraccionesN.
  ///
  /// In es, this message translates to:
  /// **'Infracciones: {n}'**
  String infraccionesN(int n);

  /// No description provided for @avisosN.
  ///
  /// In es, this message translates to:
  /// **'Avisos: {n}'**
  String avisosN(int n);

  /// No description provided for @pendienteHechosDeTotal.
  ///
  /// In es, this message translates to:
  /// **'Pendiente {hechos}/{total}'**
  String pendienteHechosDeTotal(int hechos, int total);

  /// No description provided for @hecho.
  ///
  /// In es, this message translates to:
  /// **'Hecho'**
  String get hecho;

  /// No description provided for @revisar.
  ///
  /// In es, this message translates to:
  /// **'Revisar'**
  String get revisar;

  /// No description provided for @bloquesCompletos.
  ///
  /// In es, this message translates to:
  /// **'Bloques completos: {hechos} de {total}'**
  String bloquesCompletos(int hechos, int total);

  /// No description provided for @faltaLista.
  ///
  /// In es, this message translates to:
  /// **'Falta: {lista}'**
  String faltaLista(String lista);

  /// No description provided for @fueraDeLaLista.
  ///
  /// In es, this message translates to:
  /// **'{valor} (fuera de la lista)'**
  String fueraDeLaLista(String valor);

  /// No description provided for @noCatalogado.
  ///
  /// In es, this message translates to:
  /// **'{valor} (no catalogado)'**
  String noCatalogado(String valor);

  /// No description provided for @conEsteCoche.
  ///
  /// In es, this message translates to:
  /// **'Con este coche ({creditos} créd):'**
  String conEsteCoche(String creditos);

  /// No description provided for @total.
  ///
  /// In es, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @nCreditos.
  ///
  /// In es, this message translates to:
  /// **'{n} créditos'**
  String nCreditos(int n);

  /// No description provided for @sinCreditosSuficientes.
  ///
  /// In es, this message translates to:
  /// **'⚠ No tienen créditos suficientes para cubrir el coche.'**
  String get sinCreditosSuficientes;

  /// No description provided for @hacerFoto.
  ///
  /// In es, this message translates to:
  /// **'Hacer foto'**
  String get hacerFoto;

  /// No description provided for @elegirDeGaleria.
  ///
  /// In es, this message translates to:
  /// **'Elegir de galería'**
  String get elegirDeGaleria;

  /// No description provided for @anadir.
  ///
  /// In es, this message translates to:
  /// **'Añadir'**
  String get anadir;

  /// No description provided for @equipoNoInscritoPrueba.
  ///
  /// In es, this message translates to:
  /// **'El equipo no está inscrito en la prueba: inscríbelo para poder cobrarle.'**
  String get equipoNoInscritoPrueba;

  /// No description provided for @etiquetaFinal.
  ///
  /// In es, this message translates to:
  /// **'Final'**
  String get etiquetaFinal;

  /// No description provided for @anchuraEjeMm.
  ///
  /// In es, this message translates to:
  /// **'Anchura de eje (mm)'**
  String get anchuraEjeMm;

  /// No description provided for @nombreDelClub.
  ///
  /// In es, this message translates to:
  /// **'Nombre del club'**
  String get nombreDelClub;

  /// No description provided for @clubEjemplo.
  ///
  /// In es, this message translates to:
  /// **'Ej: Club Slot Barcelona'**
  String get clubEjemplo;

  /// No description provided for @limitarFabricanteTexto.
  ///
  /// In es, this message translates to:
  /// **'En la verificación, los desplegables de marca (piñón, corona, llantas y trencilla) solo muestran las marcas elegidas; cualquier otra es infracción.'**
  String get limitarFabricanteTexto;

  /// No description provided for @eligeAlMenosUnaMarca.
  ///
  /// In es, this message translates to:
  /// **'Elige al menos una marca.'**
  String get eligeAlMenosUnaMarca;

  /// No description provided for @tipoMotorSorteoTexto.
  ///
  /// In es, this message translates to:
  /// **'La organización sortea los motores: en la verificación solo se apunta el número de motor.'**
  String get tipoMotorSorteoTexto;

  /// No description provided for @tipoMotorPropioTexto.
  ///
  /// In es, this message translates to:
  /// **'Cada equipo trae su motor: en la verificación se elige del catálogo y se comprueban RPM.'**
  String get tipoMotorPropioTexto;

  /// No description provided for @tipoMotorMixtoTexto.
  ///
  /// In es, this message translates to:
  /// **'En cada verificación se marca si el motor es de organización o propio.'**
  String get tipoMotorMixtoTexto;

  /// No description provided for @tipoMotorEligeTexto.
  ///
  /// In es, this message translates to:
  /// **'Elige de dónde salen los motores.'**
  String get tipoMotorEligeTexto;

  /// No description provided for @noPagaEstaPrueba.
  ///
  /// In es, this message translates to:
  /// **'no paga esta prueba'**
  String get noPagaEstaPrueba;

  /// No description provided for @quitarWildcard.
  ///
  /// In es, this message translates to:
  /// **'Quitar wildcard'**
  String get quitarWildcard;

  /// No description provided for @quitarCoordTotal.
  ///
  /// In es, this message translates to:
  /// **'Quitar \"Coord. total\" (vuelve a pagar)'**
  String get quitarCoordTotal;

  /// No description provided for @coordinadoraEnFicha.
  ///
  /// In es, this message translates to:
  /// **'Los pilotos están marcados como coordinadora en su ficha; cámbialo allí'**
  String get coordinadoraEnFicha;

  /// No description provided for @marcarWildcard.
  ///
  /// In es, this message translates to:
  /// **'Marcar como wildcard (no paga)'**
  String get marcarWildcard;

  /// No description provided for @desglosePagados.
  ///
  /// In es, this message translates to:
  /// **'Desglose de los €{total} pagados'**
  String desglosePagados(String total);

  /// No description provided for @pagat.
  ///
  /// In es, this message translates to:
  /// **'Pagat'**
  String get pagat;

  /// No description provided for @coordinadora.
  ///
  /// In es, this message translates to:
  /// **'Coordinadora'**
  String get coordinadora;

  /// No description provided for @club.
  ///
  /// In es, this message translates to:
  /// **'Club'**
  String get club;

  /// No description provided for @observacionesOpcional.
  ///
  /// In es, this message translates to:
  /// **'Observaciones (opcional)'**
  String get observacionesOpcional;

  /// No description provided for @descuadreTexto.
  ///
  /// In es, this message translates to:
  /// **'Coordinadora + Club ({suma}) no suma el Pagat ({total}).'**
  String descuadreTexto(String suma, String total);

  /// No description provided for @pagoRapido.
  ///
  /// In es, this message translates to:
  /// **'Pago rápido:'**
  String get pagoRapido;

  /// No description provided for @coordYPiloto.
  ///
  /// In es, this message translates to:
  /// **'Coord. + piloto'**
  String get coordYPiloto;

  /// No description provided for @coordYPilotoTooltip.
  ///
  /// In es, this message translates to:
  /// **'Un piloto es de coordinadora: paga la mitad de todo (€{monto})'**
  String coordYPilotoTooltip(String monto);

  /// No description provided for @coordTotal.
  ///
  /// In es, this message translates to:
  /// **'Coord. total'**
  String get coordTotal;

  /// No description provided for @coordTotalTooltip.
  ///
  /// In es, this message translates to:
  /// **'Todos los pilotos son de coordinadora: no paga'**
  String get coordTotalTooltip;

  /// No description provided for @observacionMitad.
  ///
  /// In es, this message translates to:
  /// **'Mitad — un piloto de coordinadora'**
  String get observacionMitad;

  /// No description provided for @nuevaSesion.
  ///
  /// In es, this message translates to:
  /// **'Nueva sesión'**
  String get nuevaSesion;

  /// No description provided for @aunNoHaySesiones.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay sesiones'**
  String get aunNoHaySesiones;

  /// No description provided for @sesionesVaciasTexto.
  ///
  /// In es, this message translates to:
  /// **'Verifica coches sin montar un campeonato: una carrera esporádica, un control en el club… Crea una sesión, añade participantes y exporta el PDF.'**
  String get sesionesVaciasTexto;

  /// No description provided for @nParticipantes.
  ///
  /// In es, this message translates to:
  /// **'{n} participantes'**
  String nParticipantes(int n);

  /// No description provided for @sesionYaNoExiste.
  ///
  /// In es, this message translates to:
  /// **'La sesión ya no existe.'**
  String get sesionYaNoExiste;

  /// No description provided for @aunNoHayParticipantes.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay participantes'**
  String get aunNoHayParticipantes;

  /// No description provided for @pulsaAnadirParticipante.
  ///
  /// In es, this message translates to:
  /// **'Pulsa \"Añadir participante\" para verificar su coche, o impórtalos desde un archivo o Google Sheets con «Importar» de arriba.'**
  String get pulsaAnadirParticipante;

  /// No description provided for @anadirParticipante.
  ///
  /// In es, this message translates to:
  /// **'Añadir participante'**
  String get anadirParticipante;

  /// No description provided for @desdeArchivoCsvExcelParentesis.
  ///
  /// In es, this message translates to:
  /// **'Desde archivo (CSV / Excel)'**
  String get desdeArchivoCsvExcelParentesis;

  /// No description provided for @desdeGoogleSheets.
  ///
  /// In es, this message translates to:
  /// **'Desde Google Sheets'**
  String get desdeGoogleSheets;

  /// No description provided for @excelConFotos.
  ///
  /// In es, this message translates to:
  /// **'Excel con fotos'**
  String get excelConFotos;

  /// No description provided for @reglamento.
  ///
  /// In es, this message translates to:
  /// **'Reglamento'**
  String get reglamento;

  /// No description provided for @eliminarSesion.
  ///
  /// In es, this message translates to:
  /// **'Eliminar sesión'**
  String get eliminarSesion;

  /// No description provided for @configuraCopasAntes.
  ///
  /// In es, this message translates to:
  /// **'Configura antes las copas en el reglamento de la sesión.'**
  String get configuraCopasAntes;

  /// No description provided for @anadidosParticipantes.
  ///
  /// In es, this message translates to:
  /// **'Añadidos {n} participantes.'**
  String anadidosParticipantes(int n);

  /// No description provided for @eliminarSesionTexto.
  ///
  /// In es, this message translates to:
  /// **'Se borrarán \"{nombre}\", sus participantes y todas sus verificaciones. No se puede deshacer.'**
  String eliminarSesionTexto(String nombre);

  /// No description provided for @pilotoObligatorio.
  ///
  /// In es, this message translates to:
  /// **'Piloto *'**
  String get pilotoObligatorio;

  /// No description provided for @obligatorio.
  ///
  /// In es, this message translates to:
  /// **'Obligatorio'**
  String get obligatorio;

  /// No description provided for @segundoPiloto.
  ///
  /// In es, this message translates to:
  /// **'Segundo piloto (opcional)'**
  String get segundoPiloto;

  /// No description provided for @equipoOpcional.
  ///
  /// In es, this message translates to:
  /// **'Equipo (opcional)'**
  String get equipoOpcional;

  /// No description provided for @equipoOpcionalAyuda.
  ///
  /// In es, this message translates to:
  /// **'Si se deja vacío, se usa el nombre del piloto'**
  String get equipoOpcionalAyuda;

  /// No description provided for @anadirYVerificar.
  ///
  /// In es, this message translates to:
  /// **'Añadir y verificar'**
  String get anadirYVerificar;

  /// No description provided for @seleccionaUnaCopa.
  ///
  /// In es, this message translates to:
  /// **'Selecciona al menos una copa / categoría.'**
  String get seleccionaUnaCopa;

  /// No description provided for @eligeTipoMotor.
  ///
  /// In es, this message translates to:
  /// **'Motor: elige si es de sorteo, propio o mixto.'**
  String get eligeTipoMotor;

  /// No description provided for @limitarFabricanteError.
  ///
  /// In es, this message translates to:
  /// **'Limitar fabricante: elige al menos una marca o desactívalo.'**
  String get limitarFabricanteError;

  /// No description provided for @nuevaSesionVerificacion.
  ///
  /// In es, this message translates to:
  /// **'Nueva sesión de verificación'**
  String get nuevaSesionVerificacion;

  /// No description provided for @editarSesion.
  ///
  /// In es, this message translates to:
  /// **'Editar sesión'**
  String get editarSesion;

  /// No description provided for @nombreSesionObligatorio.
  ///
  /// In es, this message translates to:
  /// **'Nombre de la sesión *'**
  String get nombreSesionObligatorio;

  /// No description provided for @nombreSesionAyuda.
  ///
  /// In es, this message translates to:
  /// **'Ej: Control club jueves, Carrera GT Sant Joan'**
  String get nombreSesionAyuda;

  /// No description provided for @lugarOpcional.
  ///
  /// In es, this message translates to:
  /// **'Lugar (opcional)'**
  String get lugarOpcional;

  /// No description provided for @sinFecha.
  ///
  /// In es, this message translates to:
  /// **'Sin fecha'**
  String get sinFecha;

  /// No description provided for @fechaSesion.
  ///
  /// In es, this message translates to:
  /// **'Fecha de la sesión'**
  String get fechaSesion;

  /// No description provided for @clubOrganizador.
  ///
  /// In es, this message translates to:
  /// **'Club organizador'**
  String get clubOrganizador;

  /// No description provided for @clubOrganizadorAyuda.
  ///
  /// In es, this message translates to:
  /// **'Aparece en la cabecera de los PDF de la sesión.'**
  String get clubOrganizadorAyuda;

  /// No description provided for @copasCategorias.
  ///
  /// In es, this message translates to:
  /// **'Copas / categorías'**
  String get copasCategorias;

  /// No description provided for @copasCategoriasAyuda.
  ///
  /// In es, this message translates to:
  /// **'Las que se pueden verificar en esta sesión. La copa de cada participante filtra el catálogo y las comprobaciones, igual que en un campeonato.'**
  String get copasCategoriasAyuda;

  /// No description provided for @anchuraEje.
  ///
  /// In es, this message translates to:
  /// **'Anchura de eje'**
  String get anchuraEje;

  /// No description provided for @anchuraEjeAyuda.
  ///
  /// In es, this message translates to:
  /// **'Anchura máxima de eje (mm) por copa. Deja vacío si en esa copa no se comprueba.'**
  String get anchuraEjeAyuda;

  /// No description provided for @maxDelanteroMm.
  ///
  /// In es, this message translates to:
  /// **'Máx delantero (mm)'**
  String get maxDelanteroMm;

  /// No description provided for @maxTraseroMm.
  ///
  /// In es, this message translates to:
  /// **'Máx trasero (mm)'**
  String get maxTraseroMm;

  /// No description provided for @fabricante.
  ///
  /// In es, this message translates to:
  /// **'Fabricante'**
  String get fabricante;

  /// No description provided for @fabricanteAyuda.
  ///
  /// In es, this message translates to:
  /// **'Para sesiones monomarca: limita las marcas que se pueden elegir en la verificación.'**
  String get fabricanteAyuda;

  /// No description provided for @rangoMotorTexto.
  ///
  /// In es, this message translates to:
  /// **'Rango de números de motor para sortear desde la verificación. Déjalo vacío si no hay sorteo.'**
  String get rangoMotorTexto;

  /// No description provided for @motorDesde.
  ///
  /// In es, this message translates to:
  /// **'Motor desde'**
  String get motorDesde;

  /// No description provided for @motorHasta.
  ///
  /// In es, this message translates to:
  /// **'Motor hasta'**
  String get motorHasta;

  /// No description provided for @indicaAmbos.
  ///
  /// In es, this message translates to:
  /// **'Indica ambos'**
  String get indicaAmbos;

  /// No description provided for @hastaMayorQueDesde.
  ///
  /// In es, this message translates to:
  /// **'Hasta ≥ desde'**
  String get hastaMayorQueDesde;

  /// No description provided for @crearSesion.
  ///
  /// In es, this message translates to:
  /// **'Crear sesión'**
  String get crearSesion;

  /// No description provided for @importarParticipantesArchivo.
  ///
  /// In es, this message translates to:
  /// **'Importar participantes (archivo)'**
  String get importarParticipantesArchivo;

  /// No description provided for @importarParticipantesSheets.
  ///
  /// In es, this message translates to:
  /// **'Importar participantes (Google Sheets)'**
  String get importarParticipantesSheets;

  /// No description provided for @errorAlImportar.
  ///
  /// In es, this message translates to:
  /// **'Error al importar: {detalle}'**
  String errorAlImportar(String detalle);

  /// No description provided for @pasoEligeArchivoN.
  ///
  /// In es, this message translates to:
  /// **'{n}. Elige el archivo'**
  String pasoEligeArchivoN(int n);

  /// No description provided for @pasoEligeLaHoja.
  ///
  /// In es, this message translates to:
  /// **'{n}. Elige la hoja'**
  String pasoEligeLaHoja(int n);

  /// No description provided for @pasoEligeLaPestana.
  ///
  /// In es, this message translates to:
  /// **'{n}. Elige la pestaña'**
  String pasoEligeLaPestana(int n);

  /// No description provided for @pasoAsignaColumnasN.
  ///
  /// In es, this message translates to:
  /// **'{n}. Asigna columnas'**
  String pasoAsignaColumnasN(int n);

  /// No description provided for @pasoVistaPreviaN.
  ///
  /// In es, this message translates to:
  /// **'{n}. Vista previa'**
  String pasoVistaPreviaN(int n);

  /// No description provided for @csvPlantillaTexto.
  ///
  /// In es, this message translates to:
  /// **'CSV o Excel con una fila de cabecera. Columnas reconocidas: Piloto 1 (o Piloto / Nombre), Piloto 2, Equipo y Copa. Hay una plantilla en \"Plantillas CSV\".'**
  String get csvPlantillaTexto;

  /// No description provided for @buscarEnTusHojas.
  ///
  /// In es, this message translates to:
  /// **'Buscar en tus hojas…'**
  String get buscarEnTusHojas;

  /// No description provided for @buscar.
  ///
  /// In es, this message translates to:
  /// **'Buscar'**
  String get buscar;

  /// No description provided for @pestana.
  ///
  /// In es, this message translates to:
  /// **'Pestaña'**
  String get pestana;

  /// No description provided for @piloto1Obligatorio.
  ///
  /// In es, this message translates to:
  /// **'Piloto 1 *'**
  String get piloto1Obligatorio;

  /// No description provided for @piloto2.
  ///
  /// In es, this message translates to:
  /// **'Piloto 2'**
  String get piloto2;

  /// No description provided for @copaPorDefecto.
  ///
  /// In es, this message translates to:
  /// **'Copa por defecto'**
  String get copaPorDefecto;

  /// No description provided for @copaPorDefectoAyuda.
  ///
  /// In es, this message translates to:
  /// **'Para filas sin copa o con una copa que no está en la sesión'**
  String get copaPorDefectoAyuda;

  /// No description provided for @asignaColumnaPiloto1.
  ///
  /// In es, this message translates to:
  /// **'Asigna al menos la columna del piloto 1.'**
  String get asignaColumnaPiloto1;

  /// No description provided for @noHayFilasConPiloto.
  ///
  /// In es, this message translates to:
  /// **'No hay filas con piloto.'**
  String get noHayFilasConPiloto;

  /// No description provided for @anadirNParticipantes.
  ///
  /// In es, this message translates to:
  /// **'Añadir {n, plural, =1{1 participante} other{{n} participantes}}'**
  String anadirNParticipantes(int n);

  /// No description provided for @noConectadoGoogle.
  ///
  /// In es, this message translates to:
  /// **'Aún no estás conectado con Google'**
  String get noConectadoGoogle;

  /// No description provided for @conectaCuentaTexto.
  ///
  /// In es, this message translates to:
  /// **'Conecta tu cuenta una vez para poder leer tus hojas de cálculo.'**
  String get conectaCuentaTexto;

  /// No description provided for @configurarGoogle.
  ///
  /// In es, this message translates to:
  /// **'Configurar Google'**
  String get configurarGoogle;

  /// No description provided for @noSePudieronListarHojas.
  ///
  /// In es, this message translates to:
  /// **'No se pudieron listar tus hojas: {detalle}'**
  String noSePudieronListarHojas(String detalle);

  /// No description provided for @noSePudieronListarPestanas.
  ///
  /// In es, this message translates to:
  /// **'No se pudieron listar las pestañas: {detalle}'**
  String noSePudieronListarPestanas(String detalle);

  /// No description provided for @noSePudoLeerPestana.
  ///
  /// In es, this message translates to:
  /// **'No se pudo leer la pestaña: {detalle}'**
  String noSePudoLeerPestana(String detalle);

  /// No description provided for @yaEstaEnLaSesion.
  ///
  /// In es, this message translates to:
  /// **'Ya está en la sesión'**
  String get yaEstaEnLaSesion;

  /// No description provided for @copaNoEnSesion.
  ///
  /// In es, this message translates to:
  /// **'Copa \"{copa}\" no está en la sesión: se usa {defecto}'**
  String copaNoEnSesion(String copa, String defecto);

  /// No description provided for @fotoCatalogo.
  ///
  /// In es, this message translates to:
  /// **'Foto catálogo'**
  String get fotoCatalogo;

  /// No description provided for @pilotos.
  ///
  /// In es, this message translates to:
  /// **'Pilotos'**
  String get pilotos;

  /// No description provided for @inscripciones.
  ///
  /// In es, this message translates to:
  /// **'Inscripciones'**
  String get inscripciones;

  /// No description provided for @nuevoPiloto.
  ///
  /// In es, this message translates to:
  /// **'Nuevo piloto'**
  String get nuevoPiloto;

  /// No description provided for @editarPiloto.
  ///
  /// In es, this message translates to:
  /// **'Editar piloto'**
  String get editarPiloto;

  /// No description provided for @crearPiloto.
  ///
  /// In es, this message translates to:
  /// **'Crear piloto'**
  String get crearPiloto;

  /// No description provided for @puntuacionPreviaImport.
  ///
  /// In es, this message translates to:
  /// **'Puntuación previa (1ª prueba)'**
  String get puntuacionPreviaImport;

  /// No description provided for @buscarPorNombre.
  ///
  /// In es, this message translates to:
  /// **'Buscar por nombre…'**
  String get buscarPorNombre;

  /// No description provided for @aunNoHayPilotosCampeonato.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay pilotos en este campeonato'**
  String get aunNoHayPilotosCampeonato;

  /// No description provided for @noHayCoincidencias.
  ///
  /// In es, this message translates to:
  /// **'No hay coincidencias'**
  String get noHayCoincidencias;

  /// No description provided for @pulsaNuevoPiloto.
  ///
  /// In es, this message translates to:
  /// **'Pulsa el botón \"Nuevo piloto\" para añadir el primero.'**
  String get pulsaNuevoPiloto;

  /// No description provided for @quitarDelCampeonato.
  ///
  /// In es, this message translates to:
  /// **'Quitar del campeonato'**
  String get quitarDelCampeonato;

  /// No description provided for @quitarDelCampeonatoTexto.
  ///
  /// In es, this message translates to:
  /// **'¿Quitar a {piloto} de \"{campeonato}\"?\n\nEl piloto no se borra, solo se desinscribe de este campeonato.'**
  String quitarDelCampeonatoTexto(String piloto, String campeonato);

  /// No description provided for @motivoAjusteManual.
  ///
  /// In es, this message translates to:
  /// **'Ajuste manual (ficha de piloto)'**
  String get motivoAjusteManual;

  /// No description provided for @datosPersonales.
  ///
  /// In es, this message translates to:
  /// **'Datos personales'**
  String get datosPersonales;

  /// No description provided for @nombreYApellidos.
  ///
  /// In es, this message translates to:
  /// **'Nombre y apellidos *'**
  String get nombreYApellidos;

  /// No description provided for @telefono.
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get telefono;

  /// No description provided for @email.
  ///
  /// In es, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @palmaresHistorico.
  ///
  /// In es, this message translates to:
  /// **'Palmarés histórico'**
  String get palmaresHistorico;

  /// No description provided for @palmaresEjemplo.
  ///
  /// In es, this message translates to:
  /// **'Ej: \"Top 3 liga 2025\", \"WES 2023-2024\"'**
  String get palmaresEjemplo;

  /// No description provided for @pilotoCoordinadora.
  ///
  /// In es, this message translates to:
  /// **'Piloto de coordinadora'**
  String get pilotoCoordinadora;

  /// No description provided for @pilotoCoordinadoraTexto.
  ///
  /// In es, this message translates to:
  /// **'Si está activado, los equipos en los que participe no pagarán cuota.'**
  String get pilotoCoordinadoraTexto;

  /// No description provided for @enEsteCampeonato.
  ///
  /// In es, this message translates to:
  /// **'En este campeonato'**
  String get enEsteCampeonato;

  /// No description provided for @categoria.
  ///
  /// In es, this message translates to:
  /// **'Categoría'**
  String get categoria;

  /// No description provided for @creditosIniciales.
  ///
  /// In es, this message translates to:
  /// **'Créditos iniciales'**
  String get creditosIniciales;

  /// No description provided for @sugeridoSegunCategoria.
  ///
  /// In es, this message translates to:
  /// **'Sugerido según categoría'**
  String get sugeridoSegunCategoria;

  /// No description provided for @creditosActuales.
  ///
  /// In es, this message translates to:
  /// **'Créditos actuales'**
  String get creditosActuales;

  /// No description provided for @palmaresLocal.
  ///
  /// In es, this message translates to:
  /// **'Palmarés en este campeonato'**
  String get palmaresLocal;

  /// No description provided for @indicaUnNumero.
  ///
  /// In es, this message translates to:
  /// **'Indica un número'**
  String get indicaUnNumero;

  /// No description provided for @tieneQueSerEntero.
  ///
  /// In es, this message translates to:
  /// **'Tiene que ser un número entero'**
  String get tieneQueSerEntero;

  /// No description provided for @noPuedeSerNegativo.
  ///
  /// In es, this message translates to:
  /// **'No puede ser negativo'**
  String get noPuedeSerNegativo;

  /// No description provided for @importarPilotos.
  ///
  /// In es, this message translates to:
  /// **'Importar pilotos'**
  String get importarPilotos;

  /// No description provided for @soportaExcelPilotos.
  ///
  /// In es, this message translates to:
  /// **'Soporta archivos Excel (.xlsx) y CSV. Debe tener al menos una columna con el nombre de los pilotos.'**
  String get soportaExcelPilotos;

  /// No description provided for @resumenImportacionPilotos.
  ///
  /// In es, this message translates to:
  /// **'✓ Pilotos nuevos: {nuevos}\n✓ Inscritos en este campeonato: {inscritos}\n✗ Saltados: {saltados}'**
  String resumenImportacionPilotos(int nuevos, int inscritos, int saltados);

  /// No description provided for @errorImportando.
  ///
  /// In es, this message translates to:
  /// **'Error importando: {detalle}'**
  String errorImportando(String detalle);

  /// No description provided for @indicaColumnaNombrePiloto.
  ///
  /// In es, this message translates to:
  /// **'Indica qué columna contiene el nombre del piloto.'**
  String get indicaColumnaNombrePiloto;

  /// No description provided for @noFilasValidas.
  ///
  /// In es, this message translates to:
  /// **'No se han encontrado filas válidas.'**
  String get noFilasValidas;

  /// No description provided for @importarNPilotos.
  ///
  /// In es, this message translates to:
  /// **'Importar {n, plural, =1{1 piloto} other{{n} pilotos}}'**
  String importarNPilotos(int n);

  /// No description provided for @paso2AsignaLasColumnas.
  ///
  /// In es, this message translates to:
  /// **'2. Asigna las columnas'**
  String get paso2AsignaLasColumnas;

  /// No description provided for @columnasAutodetectadas.
  ///
  /// In es, this message translates to:
  /// **'Hemos intentado detectarlas automáticamente. Cámbialas si hace falta.'**
  String get columnasAutodetectadas;

  /// No description provided for @categoriaMetal.
  ///
  /// In es, this message translates to:
  /// **'Categoría (metal)'**
  String get categoriaMetal;

  /// No description provided for @palmares.
  ///
  /// In es, this message translates to:
  /// **'Palmarés'**
  String get palmares;

  /// No description provided for @nuevo.
  ///
  /// In es, this message translates to:
  /// **'Nuevo'**
  String get nuevo;

  /// No description provided for @importarPuntuacionPrevia.
  ///
  /// In es, this message translates to:
  /// **'Importar puntuación previa'**
  String get importarPuntuacionPrevia;

  /// No description provided for @puntuacionPreviaTexto.
  ///
  /// In es, this message translates to:
  /// **'Excel (.xlsx) o CSV con el nombre del piloto y su puntuación. Solo actualiza a pilotos que YA están inscritos en el campeonato activo (se cruza por nombre) — no da de alta a nadie nuevo.'**
  String get puntuacionPreviaTexto;

  /// No description provided for @puntuacionImportada.
  ///
  /// In es, this message translates to:
  /// **'Puntuación importada'**
  String get puntuacionImportada;

  /// No description provided for @puntuacionImportadaTexto.
  ///
  /// In es, this message translates to:
  /// **'✓ Actualizados: {ok}\n✗ Saltados: {saltados}\n\nEsta puntuación solo se usa para \"Generar tandas\" en la primera prueba; en cuanto el campeonato tenga resultados propios, la clasificación real la sustituye sola.'**
  String puntuacionImportadaTexto(int ok, int saltados);

  /// No description provided for @puntuacionObligatoria.
  ///
  /// In es, this message translates to:
  /// **'Puntuación *'**
  String get puntuacionObligatoria;

  /// No description provided for @nDeTotalSeActualizaran.
  ///
  /// In es, this message translates to:
  /// **'{n} de {total} se actualizarán'**
  String nDeTotalSeActualizaran(int n, int total);

  /// No description provided for @indicaColumnaNombreYPuntuacion.
  ///
  /// In es, this message translates to:
  /// **'Indica qué columna es el nombre y cuál la puntuación.'**
  String get indicaColumnaNombreYPuntuacion;

  /// No description provided for @actualizarNPilotos.
  ///
  /// In es, this message translates to:
  /// **'Actualizar {n, plural, =1{1 piloto} other{{n} pilotos}}'**
  String actualizarNPilotos(int n);

  /// No description provided for @noEstaEnCampeonato.
  ///
  /// In es, this message translates to:
  /// **'No está en el campeonato'**
  String get noEstaEnCampeonato;

  /// No description provided for @formulaSinCalcular.
  ///
  /// In es, this message translates to:
  /// **'Fórmula sin calcular — usa \"pegado especial: valores\"'**
  String get formulaSinCalcular;

  /// No description provided for @seActualizara.
  ///
  /// In es, this message translates to:
  /// **'Se actualizará'**
  String get seActualizara;

  /// No description provided for @aunNoHayEquipos.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay equipos'**
  String get aunNoHayEquipos;

  /// No description provided for @creaEquipoDosPilotos.
  ///
  /// In es, this message translates to:
  /// **'Crea un equipo con dos pilotos para empezar.'**
  String get creaEquipoDosPilotos;

  /// No description provided for @creaInscripcionIndividual.
  ///
  /// In es, this message translates to:
  /// **'Crea una inscripción individual para empezar.'**
  String get creaInscripcionIndividual;

  /// No description provided for @importarEquipos.
  ///
  /// In es, this message translates to:
  /// **'Importar equipos'**
  String get importarEquipos;

  /// No description provided for @seleccionaLaCopa.
  ///
  /// In es, this message translates to:
  /// **'Selecciona la copa.'**
  String get seleccionaLaCopa;

  /// No description provided for @seleccionaUnPiloto.
  ///
  /// In es, this message translates to:
  /// **'Selecciona al menos un piloto.'**
  String get seleccionaUnPiloto;

  /// No description provided for @parejasNecesitanDosPilotos.
  ///
  /// In es, this message translates to:
  /// **'En este campeonato (parejas) el equipo necesita dos pilotos.'**
  String get parejasNecesitanDosPilotos;

  /// No description provided for @pilotosRepetidos.
  ///
  /// In es, this message translates to:
  /// **'Hay pilotos repetidos en el equipo.'**
  String get pilotosRepetidos;

  /// No description provided for @eliminarInscripcion.
  ///
  /// In es, this message translates to:
  /// **'Eliminar inscripción'**
  String get eliminarInscripcion;

  /// No description provided for @eliminarEquipo.
  ///
  /// In es, this message translates to:
  /// **'Eliminar equipo'**
  String get eliminarEquipo;

  /// No description provided for @eliminarInscripcionTexto.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar la inscripción de \"{nombre}\"? Esta acción no se puede deshacer.'**
  String eliminarInscripcionTexto(String nombre);

  /// No description provided for @eliminarEquipoTexto.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar el equipo \"{nombre}\"? Esta acción no se puede deshacer.'**
  String eliminarEquipoTexto(String nombre);

  /// No description provided for @editarInscripcion.
  ///
  /// In es, this message translates to:
  /// **'Editar inscripción'**
  String get editarInscripcion;

  /// No description provided for @editarEquipo.
  ///
  /// In es, this message translates to:
  /// **'Editar equipo'**
  String get editarEquipo;

  /// No description provided for @primeroAnadePilotos.
  ///
  /// In es, this message translates to:
  /// **'Primero añade pilotos al campeonato para poder crear equipos.'**
  String get primeroAnadePilotos;

  /// No description provided for @indicaUnNombre.
  ///
  /// In es, this message translates to:
  /// **'Indica un nombre'**
  String get indicaUnNombre;

  /// No description provided for @copaCategoriaObligatoria.
  ///
  /// In es, this message translates to:
  /// **'Copa / categoría *'**
  String get copaCategoriaObligatoria;

  /// No description provided for @piloto.
  ///
  /// In es, this message translates to:
  /// **'Piloto'**
  String get piloto;

  /// No description provided for @pilotosDelEquipo.
  ///
  /// In es, this message translates to:
  /// **'Pilotos del equipo'**
  String get pilotosDelEquipo;

  /// No description provided for @pilotoN.
  ///
  /// In es, this message translates to:
  /// **'Piloto {n}'**
  String pilotoN(int n);

  /// No description provided for @cocheEnVerificacionTexto.
  ///
  /// In es, this message translates to:
  /// **'El coche se indica en la verificación de cada tanda. Un equipo puede usar coches diferentes en distintas pruebas.'**
  String get cocheEnVerificacionTexto;

  /// No description provided for @crearEquipo.
  ///
  /// In es, this message translates to:
  /// **'Crear equipo'**
  String get crearEquipo;

  /// No description provided for @elegirPiloto.
  ///
  /// In es, this message translates to:
  /// **'— elegir piloto —'**
  String get elegirPiloto;

  /// No description provided for @equipoImportTexto.
  ///
  /// In es, this message translates to:
  /// **'Sube el CSV o Excel del Google Form de pretemporada. Cada fila debe ser un equipo con el nombre del equipo y {pilotos}.'**
  String equipoImportTexto(String pilotos);

  /// No description provided for @susDosPilotos.
  ///
  /// In es, this message translates to:
  /// **'sus dos pilotos'**
  String get susDosPilotos;

  /// No description provided for @suPiloto.
  ///
  /// In es, this message translates to:
  /// **'su piloto'**
  String get suPiloto;

  /// No description provided for @asignaColumnaEquipoYPiloto.
  ///
  /// In es, this message translates to:
  /// **'Asigna al menos la columna del nombre del equipo y la del primer piloto.'**
  String get asignaColumnaEquipoYPiloto;

  /// No description provided for @importarNEquipos.
  ///
  /// In es, this message translates to:
  /// **'Importar {n, plural, =1{1 equipo} other{{n} equipos}}'**
  String importarNEquipos(int n);

  /// No description provided for @resumenImportacionEquipos.
  ///
  /// In es, this message translates to:
  /// **'✓ Equipos creados: {equipos}\n✓ Pilotos nuevos: {pilotosNuevos}\n✓ Pilotos inscritos al campeonato: {pilotosInscritos}\n✗ Saltados: {saltados}'**
  String resumenImportacionEquipos(
    int equipos,
    int pilotosNuevos,
    int pilotosInscritos,
    int saltados,
  );

  /// No description provided for @columnasIntentadas.
  ///
  /// In es, this message translates to:
  /// **'Hemos intentado detectarlas. Cambia las que no estén bien.'**
  String get columnasIntentadas;

  /// No description provided for @yaExiste.
  ///
  /// In es, this message translates to:
  /// **'Ya existe'**
  String get yaExiste;

  /// No description provided for @sinPiloto.
  ///
  /// In es, this message translates to:
  /// **'Sin piloto'**
  String get sinPiloto;

  /// No description provided for @faltaSegundoPiloto.
  ///
  /// In es, this message translates to:
  /// **'Falta el segundo piloto (campeonato por parejas)'**
  String get faltaSegundoPiloto;

  /// No description provided for @nombreObligatorio.
  ///
  /// In es, this message translates to:
  /// **'Nombre *'**
  String get nombreObligatorio;

  /// No description provided for @nombreCampo.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get nombreCampo;

  /// No description provided for @piloto1.
  ///
  /// In es, this message translates to:
  /// **'Piloto 1'**
  String get piloto1;

  /// No description provided for @piloto2Opcional.
  ///
  /// In es, this message translates to:
  /// **'Piloto 2 (opcional)'**
  String get piloto2Opcional;

  /// No description provided for @formatoNoSoportadoUsaCsv.
  ///
  /// In es, this message translates to:
  /// **'Formato no soportado: {ext}. Usa .csv o .xlsx'**
  String formatoNoSoportadoUsaCsv(String ext);

  /// No description provided for @tablaDePuntos.
  ///
  /// In es, this message translates to:
  /// **'Tabla de puntos'**
  String get tablaDePuntos;

  /// No description provided for @rellenarAMano.
  ///
  /// In es, this message translates to:
  /// **'Rellenar a mano'**
  String get rellenarAMano;

  /// No description provided for @aunNoHayClasificacion.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay clasificación'**
  String get aunNoHayClasificacion;

  /// No description provided for @clasificacionVaciaTexto.
  ///
  /// In es, this message translates to:
  /// **'Registra resultados de tanda, impórtala desde un archivo o rellénala a mano.'**
  String get clasificacionVaciaTexto;

  /// No description provided for @importarClasificacion.
  ///
  /// In es, this message translates to:
  /// **'Importar clasificación'**
  String get importarClasificacion;

  /// No description provided for @general.
  ///
  /// In es, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @noHayPilotosEn.
  ///
  /// In es, this message translates to:
  /// **'No hay pilotos en \"{titulo}\".'**
  String noHayPilotosEn(String titulo);

  /// No description provided for @todosLosPilotosCampeonato.
  ///
  /// In es, this message translates to:
  /// **'Todos los pilotos del campeonato'**
  String get todosLosPilotosCampeonato;

  /// No description provided for @pilotosDeCopa.
  ///
  /// In es, this message translates to:
  /// **'Pilotos de copa {copa}'**
  String pilotosDeCopa(String copa);

  /// No description provided for @nPilotos.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 piloto} other{{n} pilotos}}'**
  String nPilotos(int n);

  /// No description provided for @equipo.
  ///
  /// In es, this message translates to:
  /// **'Equipo'**
  String get equipo;

  /// No description provided for @catAbrev.
  ///
  /// In es, this message translates to:
  /// **'Cat.'**
  String get catAbrev;

  /// No description provided for @bruto.
  ///
  /// In es, this message translates to:
  /// **'Bruto'**
  String get bruto;

  /// No description provided for @descAbrev.
  ///
  /// In es, this message translates to:
  /// **'Desc.'**
  String get descAbrev;

  /// No description provided for @totalMayusculas.
  ///
  /// In es, this message translates to:
  /// **'TOTAL'**
  String get totalMayusculas;

  /// No description provided for @clasificacionAMano.
  ///
  /// In es, this message translates to:
  /// **'Clasificación a mano'**
  String get clasificacionAMano;

  /// No description provided for @clasificacionAManoCopa.
  ///
  /// In es, this message translates to:
  /// **'Clasificación a mano · {copa}'**
  String clasificacionAManoCopa(String copa);

  /// No description provided for @sinPruebasParaPuntos.
  ///
  /// In es, this message translates to:
  /// **'Este campeonato no tiene pruebas. Crea pruebas primero para poder asignar puntos.'**
  String get sinPruebasParaPuntos;

  /// No description provided for @sinPilotosConEquipo.
  ///
  /// In es, this message translates to:
  /// **'No hay pilotos con equipo en este campeonato. Asigna equipos a los pilotos primero.'**
  String get sinPilotosConEquipo;

  /// No description provided for @editorManualTexto.
  ///
  /// In es, this message translates to:
  /// **'Escribe los puntos de cada piloto por prueba. Se guardan solos al salir de cada casilla. Casilla vacía = no puntuó; 0 = participó con 0.'**
  String get editorManualTexto;

  /// No description provided for @restaurarValores.
  ///
  /// In es, this message translates to:
  /// **'Restaurar valores por defecto'**
  String get restaurarValores;

  /// No description provided for @restaurar.
  ///
  /// In es, this message translates to:
  /// **'Restaurar'**
  String get restaurar;

  /// No description provided for @restaurarTexto.
  ///
  /// In es, this message translates to:
  /// **'Se sustituirá la tabla de puntos actual por la de PitWall Control (70, 64, 59… hasta 1 punto). Los cambios no se guardan hasta que pulses \"Guardar\".'**
  String get restaurarTexto;

  /// No description provided for @posN.
  ///
  /// In es, this message translates to:
  /// **'Pos. {n}'**
  String posN(int n);

  /// No description provided for @puntosMayus.
  ///
  /// In es, this message translates to:
  /// **'Puntos'**
  String get puntosMayus;

  /// No description provided for @quitarUltimaPosicion.
  ///
  /// In es, this message translates to:
  /// **'Quitar última posición'**
  String get quitarUltimaPosicion;

  /// No description provided for @anadirPosicion.
  ///
  /// In es, this message translates to:
  /// **'Añadir posición'**
  String get anadirPosicion;

  /// No description provided for @csvExcel.
  ///
  /// In es, this message translates to:
  /// **'CSV / Excel'**
  String get csvExcel;

  /// No description provided for @googleSheets.
  ///
  /// In es, this message translates to:
  /// **'Google Sheets'**
  String get googleSheets;

  /// No description provided for @listarHojas.
  ///
  /// In es, this message translates to:
  /// **'Listar hojas'**
  String get listarHojas;

  /// No description provided for @seleccionaArchivoClasificacion.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un archivo CSV o Excel con la clasificación. La primera fila debe ser la cabecera, con una columna \"Piloto\" y una columna por cada prueba.'**
  String get seleccionaArchivoClasificacion;

  /// No description provided for @archivoNombre.
  ///
  /// In es, this message translates to:
  /// **'Archivo: {nombre}'**
  String archivoNombre(String nombre);

  /// No description provided for @seleccionaHojaClasificacion.
  ///
  /// In es, this message translates to:
  /// **'Selecciona la hoja de Drive con la clasificación.'**
  String get seleccionaHojaClasificacion;

  /// No description provided for @hojaNombre.
  ///
  /// In es, this message translates to:
  /// **'Hoja: {nombre}'**
  String hojaNombre(String nombre);

  /// No description provided for @pulsaListarHojas.
  ///
  /// In es, this message translates to:
  /// **'Pulsa \"Listar hojas\" para empezar.'**
  String get pulsaListarHojas;

  /// No description provided for @pruebasReconocidas.
  ///
  /// In es, this message translates to:
  /// **'Pruebas reconocidas: {n}'**
  String pruebasReconocidas(int n);

  /// No description provided for @noReconocidasCampo.
  ///
  /// In es, this message translates to:
  /// **'No reconocidas: {lista}'**
  String noReconocidasCampo(String lista);

  /// No description provided for @pilotosOk.
  ///
  /// In es, this message translates to:
  /// **'Pilotos OK: {n}'**
  String pilotosOk(int n);

  /// No description provided for @pilotosConProblemas.
  ///
  /// In es, this message translates to:
  /// **'Pilotos con problemas: {n}'**
  String pilotosConProblemas(int n);

  /// No description provided for @conectaGooglePrimero.
  ///
  /// In es, this message translates to:
  /// **'Conecta tu cuenta de Google primero en Configuración → Google.'**
  String get conectaGooglePrimero;

  /// No description provided for @importadosResultados.
  ///
  /// In es, this message translates to:
  /// **'Importados {registros} resultados de {pilotos} pilotos. Vuelve a la clasificación para verla actualizada.'**
  String importadosResultados(int registros, int pilotos);

  /// No description provided for @estadoOk.
  ///
  /// In es, this message translates to:
  /// **'OK'**
  String get estadoOk;

  /// No description provided for @pilotoNoEncontrado.
  ///
  /// In es, this message translates to:
  /// **'Piloto no encontrado'**
  String get pilotoNoEncontrado;

  /// No description provided for @pilotoSinEquipo.
  ///
  /// In es, this message translates to:
  /// **'Piloto sin equipo en este campeonato'**
  String get pilotoSinEquipo;

  /// No description provided for @sinPuntosImportables.
  ///
  /// In es, this message translates to:
  /// **'Sin puntos importables'**
  String get sinPuntosImportables;

  /// No description provided for @noEncuentroColumnaPiloto.
  ///
  /// In es, this message translates to:
  /// **'No encuentro la columna del piloto. La primera fila debe contener una columna llamada \"Piloto\", \"Nombre\" o \"Equipo\".'**
  String get noEncuentroColumnaPiloto;

  /// No description provided for @importando.
  ///
  /// In es, this message translates to:
  /// **'Importando…'**
  String get importando;

  /// No description provided for @puntosNoValidos.
  ///
  /// In es, this message translates to:
  /// **'Hay una posición con un valor de puntos no válido.'**
  String get puntosNoValidos;

  /// No description provided for @tablaGuardada.
  ///
  /// In es, this message translates to:
  /// **'Tabla de puntos guardada.'**
  String get tablaGuardada;

  /// No description provided for @reparto.
  ///
  /// In es, this message translates to:
  /// **'Reparto'**
  String get reparto;

  /// No description provided for @movimiento.
  ///
  /// In es, this message translates to:
  /// **'Movimiento'**
  String get movimiento;

  /// No description provided for @sinCampeonatoActivo.
  ///
  /// In es, this message translates to:
  /// **'No hay campeonato activo'**
  String get sinCampeonatoActivo;

  /// No description provided for @cuotaPorPruebaTexto.
  ///
  /// In es, this message translates to:
  /// **'Cuota por prueba: {pagat} (coordinadora {coord} · club {club})'**
  String cuotaPorPruebaTexto(String pagat, String coord, String club);

  /// No description provided for @porPrueba.
  ///
  /// In es, this message translates to:
  /// **'Por prueba'**
  String get porPrueba;

  /// No description provided for @repartoDeLaCuota.
  ///
  /// In es, this message translates to:
  /// **'Reparto de la cuota'**
  String get repartoDeLaCuota;

  /// No description provided for @repartoTexto.
  ///
  /// In es, this message translates to:
  /// **'Lo que paga cada equipo por prueba y a dónde va. Al cambiar coordinadora o club, el otro se ajusta para que sumen el Pagat.'**
  String get repartoTexto;

  /// No description provided for @pagatCuotaTotal.
  ///
  /// In es, this message translates to:
  /// **'Pagat (cuota total) €'**
  String get pagatCuotaTotal;

  /// No description provided for @coordinadoraEur.
  ///
  /// In es, this message translates to:
  /// **'Coordinadora €'**
  String get coordinadoraEur;

  /// No description provided for @clubEur.
  ///
  /// In es, this message translates to:
  /// **'Club €'**
  String get clubEur;

  /// No description provided for @pagatMayorQueCero.
  ///
  /// In es, this message translates to:
  /// **'El Pagat tiene que ser mayor que 0.'**
  String get pagatMayorQueCero;

  /// No description provided for @coordClubSumanPagat.
  ///
  /// In es, this message translates to:
  /// **'Coordinadora + club tienen que sumar el Pagat.'**
  String get coordClubSumanPagat;

  /// No description provided for @aplicarAPagosCobrados.
  ///
  /// In es, this message translates to:
  /// **'Aplicar también a los pagos ya cobrados'**
  String get aplicarAPagosCobrados;

  /// No description provided for @aplicarAPagosCobradosTexto.
  ///
  /// In es, this message translates to:
  /// **'Vuelve a repartir lo que pagó cada equipo con la nueva proporción. Lo cobrado no cambia.'**
  String get aplicarAPagosCobradosTexto;

  /// No description provided for @repartoGuardadoRecalculado.
  ///
  /// In es, this message translates to:
  /// **'Reparto guardado. {n, plural, =1{1 pago recalculado.} other{{n} pagos recalculados.}}'**
  String repartoGuardadoRecalculado(int n);

  /// No description provided for @repartoGuardado.
  ///
  /// In es, this message translates to:
  /// **'Reparto guardado. Se aplicará a los próximos pagos.'**
  String get repartoGuardado;

  /// No description provided for @nuevoMovimiento.
  ///
  /// In es, this message translates to:
  /// **'Nuevo movimiento'**
  String get nuevoMovimiento;

  /// No description provided for @editarMovimiento.
  ///
  /// In es, this message translates to:
  /// **'Editar movimiento'**
  String get editarMovimiento;

  /// No description provided for @ingreso.
  ///
  /// In es, this message translates to:
  /// **'Ingreso'**
  String get ingreso;

  /// No description provided for @gasto.
  ///
  /// In es, this message translates to:
  /// **'Gasto'**
  String get gasto;

  /// No description provided for @conceptoObligatorio.
  ///
  /// In es, this message translates to:
  /// **'Concepto *'**
  String get conceptoObligatorio;

  /// No description provided for @conceptoEjemplo.
  ///
  /// In es, this message translates to:
  /// **'Ej: Patrocinio, Material, Premio…'**
  String get conceptoEjemplo;

  /// No description provided for @importeObligatorio.
  ///
  /// In es, this message translates to:
  /// **'Importe (€) *'**
  String get importeObligatorio;

  /// No description provided for @importeAyuda.
  ///
  /// In es, this message translates to:
  /// **'Solo el número, sin signo'**
  String get importeAyuda;

  /// No description provided for @notas.
  ///
  /// In es, this message translates to:
  /// **'Notas'**
  String get notas;

  /// No description provided for @movimientosExtras.
  ///
  /// In es, this message translates to:
  /// **'Movimientos extras'**
  String get movimientosExtras;

  /// No description provided for @ingresosYGastosSueltos.
  ///
  /// In es, this message translates to:
  /// **'(ingresos y gastos sueltos)'**
  String get ingresosYGastosSueltos;

  /// No description provided for @sinMovimientosTexto.
  ///
  /// In es, this message translates to:
  /// **'Sin movimientos. Usa el botón \"+ Movimiento\" para añadir patrocinios, gastos de material, etc.'**
  String get sinMovimientosTexto;

  /// No description provided for @balanceCampeonato.
  ///
  /// In es, this message translates to:
  /// **'Balance del campeonato'**
  String get balanceCampeonato;

  /// No description provided for @masIngresos.
  ///
  /// In es, this message translates to:
  /// **'+ Ingresos'**
  String get masIngresos;

  /// No description provided for @menosGastos.
  ///
  /// In es, this message translates to:
  /// **'− Gastos'**
  String get menosGastos;

  /// No description provided for @coordAbrev.
  ///
  /// In es, this message translates to:
  /// **'Coord.'**
  String get coordAbrev;

  /// No description provided for @tesoreriaDeLaPrueba.
  ///
  /// In es, this message translates to:
  /// **'Tesorería de la prueba'**
  String get tesoreriaDeLaPrueba;

  /// No description provided for @buscarPilotoOEquipo.
  ///
  /// In es, this message translates to:
  /// **'Buscar piloto o equipo…'**
  String get buscarPilotoOEquipo;

  /// No description provided for @borrar.
  ///
  /// In es, this message translates to:
  /// **'Borrar'**
  String get borrar;

  /// No description provided for @sinEquiposInscritos.
  ///
  /// In es, this message translates to:
  /// **'Sin equipos inscritos'**
  String get sinEquiposInscritos;

  /// No description provided for @recaudadoEnPrueba.
  ///
  /// In es, this message translates to:
  /// **'Recaudado en la prueba'**
  String get recaudadoEnPrueba;

  /// No description provided for @pagadosDe.
  ///
  /// In es, this message translates to:
  /// **'{pagados} / {total} pagados'**
  String pagadosDe(int pagados, int total);

  /// No description provided for @exentosNoPagan.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 exento} other{{n} exentos}} no pagan'**
  String exentosNoPagan(int n);

  /// No description provided for @nadieCoincide.
  ///
  /// In es, this message translates to:
  /// **'Nadie coincide con \"{filtro}\".'**
  String nadieCoincide(String filtro);

  /// No description provided for @exencionWildcard.
  ///
  /// In es, this message translates to:
  /// **'Wildcard'**
  String get exencionWildcard;

  /// No description provided for @exencionCoordinadora.
  ///
  /// In es, this message translates to:
  /// **'Pilotos de coordinadora'**
  String get exencionCoordinadora;

  /// No description provided for @pagaMitad.
  ///
  /// In es, this message translates to:
  /// **'Paga mitad — {piloto} es de coordinadora'**
  String pagaMitad(String piloto);

  /// No description provided for @revisionCategorias.
  ///
  /// In es, this message translates to:
  /// **'Revisión de categorías (cierre)'**
  String get revisionCategorias;

  /// No description provided for @aplicarBonificacion.
  ///
  /// In es, this message translates to:
  /// **'Aplicar bonificación de cierre'**
  String get aplicarBonificacion;

  /// No description provided for @aunNoHayPilotosInscritos.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay pilotos inscritos en este campeonato.'**
  String get aunNoHayPilotosInscritos;

  /// No description provided for @bonificacionCierre.
  ///
  /// In es, this message translates to:
  /// **'Bonificación de cierre'**
  String get bonificacionCierre;

  /// No description provided for @bonificacionCierreTexto.
  ///
  /// In es, this message translates to:
  /// **'Se regularizará el saldo de cada piloto que haya competido:\n\nsaldo = mín(saldo actual + bonificación según categoría y nº de carreras, {tope}).\n\nSolo se aplica a quien aún no la tenga. ¿Continuar?'**
  String bonificacionCierreTexto(String tope);

  /// No description provided for @bonificacionAplicada.
  ///
  /// In es, this message translates to:
  /// **'Bonificación aplicada a {n, plural, =1{1 piloto} other{{n} pilotos}}.'**
  String bonificacionAplicada(int n);

  /// No description provided for @inicialUsados.
  ///
  /// In es, this message translates to:
  /// **'Inicial {inicial}  ·  Usados {usados}'**
  String inicialUsados(int inicial, int usados);

  /// No description provided for @ajustarCreditos.
  ///
  /// In es, this message translates to:
  /// **'Ajustar créditos · {piloto}'**
  String ajustarCreditos(String piloto);

  /// No description provided for @creditosActualesSaldo.
  ///
  /// In es, this message translates to:
  /// **'Créditos actuales (saldo)'**
  String get creditosActualesSaldo;

  /// No description provided for @creditosAjustados.
  ///
  /// In es, this message translates to:
  /// **'Créditos ajustados'**
  String get creditosAjustados;

  /// No description provided for @ajustarCreditosMano.
  ///
  /// In es, this message translates to:
  /// **'Ajustar créditos a mano'**
  String get ajustarCreditosMano;

  /// No description provided for @usados.
  ///
  /// In es, this message translates to:
  /// **'Usados'**
  String get usados;

  /// No description provided for @saldoMayus.
  ///
  /// In es, this message translates to:
  /// **'SALDO'**
  String get saldoMayus;

  /// No description provided for @movimientos.
  ///
  /// In es, this message translates to:
  /// **'Movimientos'**
  String get movimientos;

  /// No description provided for @inscripcionAlCampeonato.
  ///
  /// In es, this message translates to:
  /// **'Inscripción al campeonato'**
  String get inscripcionAlCampeonato;

  /// No description provided for @sinMovimientosTodavia.
  ///
  /// In es, this message translates to:
  /// **'Sin movimientos todavía.'**
  String get sinMovimientosTodavia;

  /// No description provided for @huecoSinJustificar.
  ///
  /// In es, this message translates to:
  /// **'{n} créd. sin justificar'**
  String huecoSinJustificar(int n);

  /// No description provided for @descuadreSaldo.
  ///
  /// In es, this message translates to:
  /// **'El saldo actual ({actual}) no cuadra con inicial {inicial} {suma} movimientos. Probablemente venía así al importar o se editó a mano antes de activar el log.'**
  String descuadreSaldo(String actual, String inicial, String suma);

  /// No description provided for @estadoPromociona.
  ///
  /// In es, this message translates to:
  /// **'Promociona'**
  String get estadoPromociona;

  /// No description provided for @estadoDesciende.
  ///
  /// In es, this message translates to:
  /// **'Desciende'**
  String get estadoDesciende;

  /// No description provided for @estadoSeMantiene.
  ///
  /// In es, this message translates to:
  /// **'Se mantiene'**
  String get estadoSeMantiene;

  /// No description provided for @bajar.
  ///
  /// In es, this message translates to:
  /// **'Bajar'**
  String get bajar;

  /// No description provided for @mantener.
  ///
  /// In es, this message translates to:
  /// **'Mantener'**
  String get mantener;

  /// No description provided for @subir.
  ///
  /// In es, this message translates to:
  /// **'Subir'**
  String get subir;

  /// No description provided for @noHayPilotosCompetido.
  ///
  /// In es, this message translates to:
  /// **'No hay pilotos que hayan competido en este campeonato.'**
  String get noHayPilotosCompetido;

  /// No description provided for @revisionTexto.
  ///
  /// In es, this message translates to:
  /// **'Ajusta la categoría de cada piloto antes de finalizar. Se usará para la bonificación de cierre y como categoría inicial del próximo campeonato.'**
  String get revisionTexto;

  /// No description provided for @motivoAjusteCreditos.
  ///
  /// In es, this message translates to:
  /// **'Ajuste manual (créditos)'**
  String get motivoAjusteCreditos;

  /// No description provided for @verificarEnEquipoWifi.
  ///
  /// In es, this message translates to:
  /// **'Verificar en equipo (wifi)'**
  String get verificarEnEquipoWifi;

  /// No description provided for @verificarEnEquipoN.
  ///
  /// In es, this message translates to:
  /// **'Verificar en equipo · {n}'**
  String verificarEnEquipoN(int n);

  /// No description provided for @verificarEnEquipoNConectados.
  ///
  /// In es, this message translates to:
  /// **'Verificar en equipo · {n} conectados'**
  String verificarEnEquipoNConectados(int n);

  /// No description provided for @syncIntroTexto.
  ///
  /// In es, this message translates to:
  /// **'Varios Controls pueden trabajar en esta prueba a la vez. Cada uno guarda en su dispositivo y se pasan los cambios por la wifi: verificaciones con sus fotos, copa y cobros, y también las altas (pilotos, equipos, su categoría en el campeonato e inscritos a la prueba, y sus bajas), las tandas con sus carriles y los resultados.\n\n• Todos en la misma wifi. No hace falta internet: vale un router sin conexión o el punto de acceso de un móvil.\n• La primera vez, partid todos de la misma copia de datos. Los catálogos y la configuración del campeonato todavía no viajan.\n• La misma clave del evento en todos, y la hora automática activada: si dos tocan lo mismo, gana el último cambio.'**
  String get syncIntroTexto;

  /// No description provided for @nombreDeEsteControl.
  ///
  /// In es, this message translates to:
  /// **'Nombre de este Control'**
  String get nombreDeEsteControl;

  /// No description provided for @nombreControlAyuda.
  ///
  /// In es, this message translates to:
  /// **'Distinto en cada dispositivo (p. ej. «Mesa 1»).'**
  String get nombreControlAyuda;

  /// No description provided for @claveDelEvento.
  ///
  /// In es, this message translates to:
  /// **'Clave del evento'**
  String get claveDelEvento;

  /// No description provided for @claveEventoAyuda.
  ///
  /// In es, this message translates to:
  /// **'La misma en todos los Controls.'**
  String get claveEventoAyuda;

  /// No description provided for @conectarConOtros.
  ///
  /// In es, this message translates to:
  /// **'Conectar con otros Controls'**
  String get conectarConOtros;

  /// No description provided for @visibleComo.
  ///
  /// In es, this message translates to:
  /// **'Visible como «{nombre}»'**
  String visibleComo(String nombre);

  /// No description provided for @conectando.
  ///
  /// In es, this message translates to:
  /// **'Conectando…'**
  String get conectando;

  /// No description provided for @apagado.
  ///
  /// In es, this message translates to:
  /// **'Apagado'**
  String get apagado;

  /// No description provided for @controlsEnLaRed.
  ///
  /// In es, this message translates to:
  /// **'Controls en la red'**
  String get controlsEnLaRed;

  /// No description provided for @anadirPorDireccion.
  ///
  /// In es, this message translates to:
  /// **'Añadir por dirección'**
  String get anadirPorDireccion;

  /// No description provided for @anadirControlPorDireccion.
  ///
  /// In es, this message translates to:
  /// **'Añadir Control por dirección'**
  String get anadirControlPorDireccion;

  /// No description provided for @ipOPuerto.
  ///
  /// In es, this message translates to:
  /// **'IP (o IP:puerto)'**
  String get ipOPuerto;

  /// No description provided for @ipAyuda.
  ///
  /// In es, this message translates to:
  /// **'La ves en esta misma pantalla del otro Control.'**
  String get ipAyuda;

  /// No description provided for @buscandoOtrosControls.
  ///
  /// In es, this message translates to:
  /// **'Buscando otros Controls en la wifi…'**
  String get buscandoOtrosControls;

  /// No description provided for @noSeEncuentraControl.
  ///
  /// In es, this message translates to:
  /// **'No se ha encontrado ningún Control. Comprueba que los demás tienen esta pantalla con «Conectar» encendido y están en la misma wifi, o añádelos por su dirección.'**
  String get noSeEncuentraControl;

  /// No description provided for @dosControlsMismoNombre.
  ///
  /// In es, this message translates to:
  /// **'Hay otro Control que también se llama «{nombre}». Cambia el nombre de uno de los dos.'**
  String dosControlsMismoNombre(String nombre);

  /// No description provided for @claveNoCoincide.
  ///
  /// In es, this message translates to:
  /// **'{host} · la clave del evento no coincide'**
  String claveNoCoincide(String host);

  /// No description provided for @quitarDeLaLista.
  ///
  /// In es, this message translates to:
  /// **'Quitar de la lista'**
  String get quitarDeLaLista;

  /// No description provided for @sincronizarAutomaticamente.
  ///
  /// In es, this message translates to:
  /// **'Sincronizar automáticamente'**
  String get sincronizarAutomaticamente;

  /// No description provided for @cadaNsAppAbierta.
  ///
  /// In es, this message translates to:
  /// **'Cada {n} s mientras la app esté abierta'**
  String cadaNsAppAbierta(int n);

  /// No description provided for @sincronizando.
  ///
  /// In es, this message translates to:
  /// **'Sincronizando…'**
  String get sincronizando;

  /// No description provided for @sincronizarAhora.
  ///
  /// In es, this message translates to:
  /// **'Sincronizar ahora'**
  String get sincronizarAhora;

  /// No description provided for @ultimaSincronizacion.
  ///
  /// In es, this message translates to:
  /// **'Última sincronización: {hora}'**
  String ultimaSincronizacion(String hora);

  /// No description provided for @syncSinCambios.
  ///
  /// In es, this message translates to:
  /// **'Sin cambios'**
  String get syncSinCambios;

  /// No description provided for @nEquipos.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 equipo} other{{n} equipos}}'**
  String nEquipos(int n);

  /// No description provided for @nPerfiles.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 perfil} other{{n} perfiles}}'**
  String nPerfiles(int n);

  /// No description provided for @nInscritos.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 inscrito} other{{n} inscritos}}'**
  String nInscritos(int n);

  /// No description provided for @nTandas.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 tanda} other{{n} tandas}}'**
  String nTandas(int n);

  /// No description provided for @resultadosDeNTandas.
  ///
  /// In es, this message translates to:
  /// **'resultados de {n, plural, =1{1 tanda} other{{n} tandas}}'**
  String resultadosDeNTandas(int n);

  /// No description provided for @nBajas.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 baja} other{{n} bajas}}'**
  String nBajas(int n);

  /// No description provided for @nVerifNuevas.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 verificación nueva} other{{n} verificaciones nuevas}}'**
  String nVerifNuevas(int n);

  /// No description provided for @nVerifActualizadas.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 actualizada} other{{n} actualizadas}}'**
  String nVerifActualizadas(int n);

  /// No description provided for @nVerifBorradas.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 borrada} other{{n} borradas}}'**
  String nVerifBorradas(int n);

  /// No description provided for @nCopas.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 copa} other{{n} copas}}'**
  String nCopas(int n);

  /// No description provided for @nCobros.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 cobro} other{{n} cobros}}'**
  String nCobros(int n);

  /// No description provided for @syncSinClave.
  ///
  /// In es, this message translates to:
  /// **'Pon una clave del evento.'**
  String get syncSinClave;

  /// No description provided for @syncNoSePudoAbrir.
  ///
  /// In es, this message translates to:
  /// **'No se pudo abrir la conexión: {detalle}'**
  String syncNoSePudoAbrir(String detalle);

  /// No description provided for @syncFormatoDesconocido.
  ///
  /// In es, this message translates to:
  /// **'Formato de sincronización desconocido.'**
  String get syncFormatoDesconocido;

  /// No description provided for @syncOtraVersion.
  ///
  /// In es, this message translates to:
  /// **'El otro Control tiene otra versión de PitWall Control. Actualizad todos a la misma versión.'**
  String get syncOtraVersion;

  /// No description provided for @syncVerifNoExiste.
  ///
  /// In es, this message translates to:
  /// **'Verificación de «{equipo}» en «{manga}»: no existe aquí esa tanda o ese equipo.'**
  String syncVerifNoExiste(String equipo, String manga);

  /// No description provided for @syncCocheNoCatalogo.
  ///
  /// In es, this message translates to:
  /// **'{equipo}: el coche «{coche}» no está en el catálogo de este Control.'**
  String syncCocheNoCatalogo(String equipo, String coche);

  /// No description provided for @syncTandaFaltaEquipo.
  ///
  /// In es, this message translates to:
  /// **'Tanda «{tanda}»: falta aquí un equipo; su carril queda vacío.'**
  String syncTandaFaltaEquipo(String tanda);

  /// No description provided for @syncResultFaltaPiloto.
  ///
  /// In es, this message translates to:
  /// **'Resultados de «{tanda}»: falta aquí un piloto o un equipo; esa fila no se copia.'**
  String syncResultFaltaPiloto(String tanda);

  /// No description provided for @syncEquipoFaltanPilotos.
  ///
  /// In es, this message translates to:
  /// **'Equipo «{equipo}»: faltan aquí algunos de sus pilotos; no se copia.'**
  String syncEquipoFaltanPilotos(String equipo);

  /// No description provided for @syncSinRespuesta.
  ///
  /// In es, this message translates to:
  /// **'No responde (¿sigue en la misma wifi?).'**
  String get syncSinRespuesta;

  /// No description provided for @syncSinConexion.
  ///
  /// In es, this message translates to:
  /// **'No se puede conectar (¿sigue en la misma wifi?).'**
  String get syncSinConexion;

  /// No description provided for @syncControlAnadido.
  ///
  /// In es, this message translates to:
  /// **'Control añadido.'**
  String get syncControlAnadido;

  /// No description provided for @syncNoHayControlEn.
  ///
  /// In es, this message translates to:
  /// **'No hay ningún Control conectado en {dir}.'**
  String syncNoHayControlEn(String dir);

  /// No description provided for @primeroInscribeEquipos.
  ///
  /// In es, this message translates to:
  /// **'Primero inscribe equipos a la prueba.'**
  String get primeroInscribeEquipos;

  /// No description provided for @sinCoincidenciasPunto.
  ///
  /// In es, this message translates to:
  /// **'No hay coincidencias.'**
  String get sinCoincidenciasPunto;

  /// No description provided for @ajusteManualHistorial.
  ///
  /// In es, this message translates to:
  /// **'El cambio del saldo se anota como \"Ajuste manual\" en el historial.'**
  String get ajusteManualHistorial;

  /// No description provided for @bonifTope.
  ///
  /// In es, this message translates to:
  /// **'+{bonif}, limitado al tope {tope}'**
  String bonifTope(int bonif, int tope);

  /// No description provided for @desfaseHora.
  ///
  /// In es, this message translates to:
  /// **'La hora del otro Control se desvía {min} min de la de este dispositivo. Poned todos la hora automática.'**
  String desfaseHora(int min);

  /// No description provided for @nCarreras.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 carrera} other{{n} carreras}}'**
  String nCarreras(int n);

  /// No description provided for @bonifMotivo.
  ///
  /// In es, this message translates to:
  /// **'Bonificación de cierre por {carreras} ({categoria}): +{bonif}'**
  String bonifMotivo(String carreras, String categoria, int bonif);

  /// No description provided for @bonifLimiteTope.
  ///
  /// In es, this message translates to:
  /// **', limitado al tope {tope}'**
  String bonifLimiteTope(int tope);
}

class _TextosDelegate extends LocalizationsDelegate<Textos> {
  const _TextosDelegate();

  @override
  Future<Textos> load(Locale locale) {
    return SynchronousFuture<Textos>(lookupTextos(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ca', 'en', 'es', 'fr', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_TextosDelegate old) => false;
}

Textos lookupTextos(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ca':
      return TextosCa();
    case 'en':
      return TextosEn();
    case 'es':
      return TextosEs();
    case 'fr':
      return TextosFr();
    case 'it':
      return TextosIt();
  }

  throw FlutterError(
    'Textos.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
