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
