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
