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

/// The translations for French (`fr`).
class TextosFr extends Textos {
  TextosFr([String locale = 'fr']) : super(locale);

  @override
  String get menuInicio => 'Accueil';

  @override
  String get menuPruebas => 'Épreuves';

  @override
  String get menuParticipantes => 'Participants';

  @override
  String get menuClasificacion => 'Classement';

  @override
  String get menuTesoreria => 'Trésorerie';

  @override
  String get menuCreditos => 'Crédits';

  @override
  String get menuVerificacionLibre => 'Vérification libre';

  @override
  String get menuCatalogos => 'Catalogues';

  @override
  String get menuGestionarCampeonatos => 'Gérer les championnats';

  @override
  String get menuAjustes => 'Réglages';

  @override
  String get menuMas => 'Plus';

  @override
  String get grupoCampeonato => 'CHAMPIONNAT';

  @override
  String get grupoHerramientas => 'OUTILS';

  @override
  String get grupoCampeonatoActivo => 'CHAMPIONNAT ACTIF';

  @override
  String get campeonatoActivo => 'Championnat actif';

  @override
  String get gestionarCampeonatosPuntos => 'Gérer les championnats…';

  @override
  String tooltipCampeonato(String nombre) {
    return 'Championnat : $nombre';
  }

  @override
  String errorDetalle(String detalle) {
    return 'Erreur : $detalle';
  }

  @override
  String get vacioTitulo => 'Aucun championnat pour l\'instant';

  @override
  String get vacioTexto =>
      'Créez votre premier championnat pour commencer à gérer les épreuves et les résultats.';

  @override
  String get crearCampeonato => 'Créer un championnat';

  @override
  String get soloVerificarCoches => 'Vérifier des voitures uniquement';

  @override
  String get ajustesYCopias => 'Réglages et sauvegardes';

  @override
  String get masOpciones => 'Plus d\'options';

  @override
  String get statPilotos => 'pilotes';

  @override
  String get statEquipos => 'équipes';

  @override
  String get statPruebas => 'épreuves';

  @override
  String get pendientes => 'À faire';

  @override
  String get proximaPrueba => 'Prochaine épreuve';

  @override
  String get noHayPruebasPendientes => 'Aucune épreuve à venir';

  @override
  String get botonInscritos => 'Inscrits';

  @override
  String get botonVerificar => 'Vérifier';

  @override
  String get botonResultados => 'Résultats';

  @override
  String pendVerificaciones(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'vérifications non validées',
      one: 'vérification non validée',
    );
    return '$_temp0';
  }

  @override
  String pendPagos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'paiements non encaissés',
      one: 'paiement non encaissé',
    );
    return '$_temp0';
  }

  @override
  String pendSinResultados(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'épreuves disputées sans résultats',
      one: 'épreuve disputée sans résultats',
    );
    return '$_temp0';
  }

  @override
  String get todoAlDia => 'Tout est à jour';

  @override
  String get todoAlDiaSinPruebas =>
      'Aucune épreuve à venir ni résultat à saisir.';

  @override
  String todoAlDiaEnPrueba(String prueba) {
    return 'Aucune vérification ni aucun paiement en attente pour $prueba.';
  }

  @override
  String get liderCampeonato => 'Leader du championnat';

  @override
  String get sinResultadosTodavia => 'Pas encore de résultats';

  @override
  String puntosAbrev(int puntos) {
    return '$puntos pts';
  }

  @override
  String get seccionDatos => 'Données';

  @override
  String get copiasSeguridad => 'Sauvegardes';

  @override
  String get copiasSeguridadSub =>
      'Envoyer ou restaurer la sauvegarde Drive, ou restaurer depuis un fichier';

  @override
  String get googleSheetsDrive => 'Google (Sheets et Drive)';

  @override
  String get googleSub =>
      'Connecter le compte et les identifiants Google Cloud';

  @override
  String get plantillasCsv => 'Modèles CSV';

  @override
  String get plantillasCsvSub =>
      'Télécharger des modèles pour importer pilotes, équipes…';

  @override
  String get seccionApariencia => 'Apparence';

  @override
  String get modoOscuro => 'Mode sombre';

  @override
  String get idioma => 'Langue';

  @override
  String get idiomaAutomatico => 'Automatique (langue du système)';

  @override
  String get seccionAcercaDe => 'À propos';

  @override
  String get novedades => 'Nouveautés';

  @override
  String get historialVersiones => 'Historique des versions';

  @override
  String versionHistorial(String version) {
    return 'Version $version · historique des versions';
  }

  @override
  String get actualizaciones => 'Mises à jour';

  @override
  String get actualizacionesSub =>
      'Rechercher une nouvelle version et la télécharger';

  @override
  String get actDescargaIncompleta =>
      'Le téléchargement est incomplet. Réessayez.';

  @override
  String get actDescargaAtascada => 'Le téléchargement est bloqué. Réessayez.';

  @override
  String get actNoSePudoDescargar =>
      'Impossible de télécharger la mise à jour. Réessayez ou téléchargez-la sur pitwall.es.';

  @override
  String actHayVersionNueva(String version) {
    return 'Une nouvelle version est disponible : v$version';
  }

  @override
  String get actDescargaNueva =>
      'Téléchargez la nouvelle version pour profiter des dernières améliorations.';

  @override
  String get cancelar => 'Annuler';

  @override
  String get masTarde => 'Plus tard';

  @override
  String get actPermisoAndroid =>
      'La première fois, Android demandera l\'autorisation d\'installer des applications de cette source. Appuyez ensuite à nouveau sur « Mettre à jour ».';

  @override
  String get actSeAbriraNavegador =>
      'Le navigateur s\'ouvrira pour télécharger le programme d\'installation de cette version.';

  @override
  String get actActualizar => 'Mettre à jour';

  @override
  String get actDescargar => 'Télécharger';

  @override
  String get actDescargando => 'Téléchargement…';

  @override
  String actDescargandoPct(int pct) {
    return 'Téléchargement… $pct %';
  }

  @override
  String get nuevaPrueba => 'Nouvelle épreuve';

  @override
  String get seleccionaCampeonato => 'Sélectionnez d\'abord un championnat';

  @override
  String get aunNoHayPruebas => 'Aucune épreuve pour l\'instant';

  @override
  String get aunNoHayPruebasTexto =>
      'Créez la première épreuve du championnat (par exemple « EL SOT », « SLOTMANIA »…).';

  @override
  String get estadoProgramada => 'Programmée';

  @override
  String get estadoEnCurso => 'En cours';

  @override
  String get estadoTerminada => 'Terminée';

  @override
  String get estadoCancelada => 'Annulée';

  @override
  String get resumenVerificaciones => 'Résumé des vérifications';

  @override
  String get aunNoHayTandas => 'Aucune série pour l\'instant';

  @override
  String get verificarSinTandasTexto =>
      'Inscrivez des équipes et créez les séries dans l\'onglet Préparer.';

  @override
  String validadasDe(int validadas, int total) {
    return '$validadas / $total validées';
  }

  @override
  String get sinEquiposEnTanda => 'Aucune équipe dans cette série.';

  @override
  String get carreraTienePole => 'La course a-t-elle une pole ?';

  @override
  String get carreraTienePoleTexto =>
      'Avec une pole, l\'ordre des voies n\'est pas exporté : PitWall crée la séance de pole et la grille est attribuée après.';

  @override
  String get sinPole => 'Sans pole';

  @override
  String get conPole => 'Avec pole';

  @override
  String get noHayInscritosExportar => 'Aucun inscrit à exporter.';

  @override
  String get noHayTandasConCarriles =>
      'Aucune série avec des voies attribuées à exporter.';

  @override
  String get importarDelCronometraje => 'Importer du chronométrage';

  @override
  String get traerResultadosPitwall => 'Récupérer les résultats de PitWall';

  @override
  String get prueba => 'Épreuve';

  @override
  String get editar => 'Modifier';

  @override
  String get pestanaPreparar => 'Préparer';

  @override
  String get pestanaVerificar => 'Vérifier';

  @override
  String get pestanaResultados => 'Résultats';

  @override
  String get pestanaCaja => 'Caisse';

  @override
  String get nuevaTanda => 'Nouvelle série';

  @override
  String get compartir => 'Partager';

  @override
  String get pdfTandas => 'PDF des séries';

  @override
  String get pdfVerificaciones => 'PDF des vérifications';

  @override
  String get enviarTandasPitwall => 'Envoyer les séries à PitWall';

  @override
  String get porWifiSinArchivo => 'Par wifi, sans fichier';

  @override
  String get enviarVerificacionesPitwall =>
      'Envoyer les vérifications à PitWall';

  @override
  String get soloConsultaManager => 'Consultation seule dans Manager';

  @override
  String get archivoParaPitwall => 'Fichier pour PitWall (JSON)';

  @override
  String get paraImportarAManoManager =>
      'Pour l\'importer manuellement dans Manager';

  @override
  String get noEncontrada => 'Introuvable';

  @override
  String get editarTandas => 'Modifier les séries';

  @override
  String get sorteoMotores => 'Tirage des moteurs';

  @override
  String get tandas => 'Séries';

  @override
  String get crearTandasTexto =>
      'Créez les séries de cette épreuve (Jeudi 21:00, Vendredi 21:00…).';

  @override
  String pruebaNumero(int orden) {
    return 'Épreuve n° $orden';
  }

  @override
  String nCarriles(int n) {
    return '$n voies';
  }

  @override
  String noSePudoGuardar(String detalle) {
    return 'Impossible d\'enregistrer : $detalle';
  }

  @override
  String get eliminarPrueba => 'Supprimer l\'épreuve';

  @override
  String eliminarPruebaTexto(String nombre) {
    return 'Supprimer « $nombre » ?\n\nSes séries, inscriptions, résultats et vérifications seront aussi supprimés. Cette action est irréversible.';
  }

  @override
  String get eliminar => 'Supprimer';

  @override
  String get editarPrueba => 'Modifier l\'épreuve';

  @override
  String get nombrePruebaObligatorio => 'Nom de l\'épreuve *';

  @override
  String get nombrePruebaAyuda => 'Ex. : EL SOT, SLOTMANIA, GASCLAVAT…';

  @override
  String get indicaElNombre => 'Indiquez le nom';

  @override
  String get sedeClub => 'Lieu / club';

  @override
  String get sinFechaAsignada => 'Aucune date';

  @override
  String get quitarFecha => 'Retirer la date';

  @override
  String get elegir => 'Choisir';

  @override
  String get cambiar => 'Modifier';

  @override
  String get ordenCampeonato => 'Ordre dans le championnat';

  @override
  String get ordenCampeonatoAyuda => 'Position dans le calendrier (1, 2, 3…)';

  @override
  String get numeroEntero => 'Nombre entier';

  @override
  String get estado => 'État';

  @override
  String get crearPrueba => 'Créer l\'épreuve';

  @override
  String get guardarCambios => 'Enregistrer';

  @override
  String get eliminarTanda => 'Supprimer la série';

  @override
  String eliminarTandaTexto(String nombre) {
    return 'Supprimer la série « $nombre » ? Ses inscriptions, résultats et vérifications seront aussi supprimés.';
  }

  @override
  String get editarTanda => 'Modifier la série';

  @override
  String get nombreTandaObligatorio => 'Nom de la série *';

  @override
  String get nombreTandaAyuda => 'Ex. : Jeudi 21:00, Vendredi 23:00…';

  @override
  String get sinFechaHora => 'Aucune date ni heure';

  @override
  String get quitar => 'Retirer';

  @override
  String get numeroCarriles => 'Nombre de voies';

  @override
  String get numeroCarrilesAyuda => 'Habituellement 6, 7 ou 8 (jusqu\'à 32)';

  @override
  String get numeroCarrilesError => 'Indiquez un nombre entre 1 et 32';

  @override
  String get pisters => 'Commissaires';

  @override
  String get pistersAyuda =>
      'Série dont les pilotes sont commissaires dans celle-ci';

  @override
  String get sinPisters => '— sans commissaires —';

  @override
  String pilotosDe(String nombre) {
    return 'Pilotes de $nombre';
  }

  @override
  String get crearTanda => 'Créer la série';

  @override
  String get pruebaSinTandas => 'Cette épreuve n\'a pas encore de séries';

  @override
  String get generaTandasDesdeInscritos =>
      'Générez-les depuis Inscrits → Générer les séries.';

  @override
  String get tocaEquipoParaMover =>
      'Touchez une équipe pour la déplacer vers une autre série.';

  @override
  String nEquiposAbrev(int n) {
    return '$n éq.';
  }

  @override
  String get sinEquipos => 'Aucune équipe';

  @override
  String moverEquipoA(String nombre) {
    return 'Déplacer « $nombre » vers…';
  }

  @override
  String tandaConEquipos(String nombre, int n) {
    return '$nombre  ($n éq.)';
  }

  @override
  String get darDeBajaPrueba => 'Retirer de l\'épreuve';

  @override
  String get eligePitwall => 'Choisissez un PitWall ou saisissez son adresse.';

  @override
  String get noHayInscritosEnviar => 'Aucun inscrit à envoyer.';

  @override
  String get noHayTandasEnviar =>
      'Aucune série avec des voies attribuées à envoyer.';

  @override
  String get enviarAPitwall => 'Envoyer à PitWall';

  @override
  String get pinImportacion => 'PIN d\'importation';

  @override
  String get pinImportacionAyuda =>
      'Le PIN affiché par PitWall dans « Importer une série ».';

  @override
  String get carreraTienePoleSi => 'La course a une pole';

  @override
  String get carreraTienePoleAyuda =>
      'L\'ordre des voies n\'est pas envoyé : la grille est attribuée dans PitWall après la pole';

  @override
  String get enviar => 'Envoyer';

  @override
  String get pitwallEnLaRed => 'PitWall sur le réseau';

  @override
  String get buscarDeNuevo => 'Rechercher à nouveau';

  @override
  String get buscandoPitwall => 'Recherche de PitWall sur le réseau local…';

  @override
  String get noSeEncuentraPitwall =>
      'Aucun PitWall trouvé. Vérifiez qu\'il est ouvert et sur le même réseau Wi‑Fi, ou saisissez son adresse ci-dessous.';

  @override
  String get direccionIpPuerto => 'Adresse (IP:port)';

  @override
  String get resultadosDeLaTanda => 'Résultats de la série';

  @override
  String get noHayEquiposEnTanda => 'Aucune équipe dans cette série';

  @override
  String get inscribeEquiposParaResultados =>
      'Inscrivez des équipes pour pouvoir enregistrer leurs résultats.';

  @override
  String get indicaPosicionFinalTexto =>
      'Indiquez la position finale de chaque équipe. Les points sont calculés automatiquement selon la table du championnat.';

  @override
  String get puntos => 'points';

  @override
  String get posicion => 'Position';

  @override
  String get sinAsignar => 'Non attribuée';

  @override
  String get aRestar => 'À déduire';

  @override
  String get creditosMin => 'crédits';

  @override
  String get noHayInscritosEnPrueba => 'Aucun inscrit dans cette épreuve';

  @override
  String get inscribeEquiposGeneraTandas =>
      'Inscrivez des équipes et générez les séries. Vous pourrez ensuite importer ici les résultats du chronométrage.';

  @override
  String equiposConResultado(int con, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total équipes',
      one: '1 équipe',
    );
    return '$con sur $_temp0 avec un résultat enregistré.';
  }

  @override
  String get resultadosDeLaPrueba => 'Résultats de l\'épreuve';

  @override
  String get importarDesdeArchivoCronometraje =>
      'Importer depuis un fichier de chronométrage';

  @override
  String copaYManga(String copa, String manga) {
    return 'Coupe $copa  ·  $manga';
  }

  @override
  String get posAbrev => 'Pos.';

  @override
  String get archivos => 'Fichiers';

  @override
  String get noSeEncontraronResultados =>
      'Aucun résultat trouvé. Le fichier doit comporter des colonnes telles que « Position » et « Nom » (format TicTacSlot ou similaire).';

  @override
  String noSePudoLeerArchivo(String detalle) {
    return 'Impossible de lire le fichier : $detalle';
  }

  @override
  String get importacionCompletada => 'Importation terminée';

  @override
  String resumenImportacionResultados(int ok, int inscritos, int saltados) {
    return '✓ Résultats appliqués : $ok\n+ Inscrits automatiquement : $inscritos\n✗ Ignorés : $saltados';
  }

  @override
  String get ok => 'OK';

  @override
  String get importarResultadosPrueba => 'Importer les résultats de l\'épreuve';

  @override
  String get paso1EligeArchivo => '1. Choisissez le fichier';

  @override
  String get importaArchivoTexto =>
      'Importez le fichier du système de chronométrage (TicTacSlot, SloTime…). Chaque équipe du fichier est affectée à la série de cette épreuve où elle est inscrite.';

  @override
  String get elegirArchivo => 'Choisir un fichier';

  @override
  String get resultadosGenerales => 'Résultats généraux';

  @override
  String get crearTandaResultadosGenerales =>
      'Créer la série « Résultats généraux »';

  @override
  String get pruebaSinTandasAviso =>
      'L\'épreuve n\'a pas encore de séries. Les résultats sont marqués dans une série créée à la volée.';

  @override
  String get paso2VistaPrevia => '2. Aperçu';

  @override
  String nDeTotalSeAplicaran(int n, int total) {
    return '$n sur $total seront appliqués';
  }

  @override
  String equiposNoExistenAviso(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '⚠️ $n équipes du fichier n\'existent pas dans le championnat.',
      one: '⚠️ 1 équipe du fichier n\'existe pas dans le championnat.',
    );
    return '$_temp0';
  }

  @override
  String aplicarResultadosA(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n équipes',
      one: '1 équipe',
    );
    return 'Appliquer les résultats à $_temp0';
  }

  @override
  String get noExiste => 'Inexistante';

  @override
  String get seInscribira => 'Sera inscrite';

  @override
  String get aplicar => 'Appliquer';

  @override
  String copaTexto(String copa) {
    return 'Coupe $copa';
  }

  @override
  String nVueltas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n tours',
      one: '1 tour',
    );
    return '$_temp0';
  }

  @override
  String formatoNoSoportado(String ext) {
    return 'Format non pris en charge : $ext';
  }

  @override
  String get sortearRestantes => 'Tirer les restants';

  @override
  String get pruebaNoEncontrada => 'Épreuve introuvable';

  @override
  String get noHayEquiposInscritosTandas =>
      'Aucune équipe inscrite dans les séries de cette épreuve.';

  @override
  String sorteoBloqueadoTexto(String motivo) {
    return '$motivo Le tirage reste en lecture seule.';
  }

  @override
  String get equipos => 'Équipes';

  @override
  String get numeros => 'Numéros';

  @override
  String get noQuedanMotores => 'Plus de moteurs disponibles.';

  @override
  String get motorSorteado => 'Moteur tiré';

  @override
  String get repetir => 'Répéter';

  @override
  String get asignar => 'Attribuer';

  @override
  String faltanMotores(int equipos, int motores) {
    return 'Moteurs insuffisants : $equipos équipes et seulement $motores moteurs disponibles.';
  }

  @override
  String motoresRango(int min, int max) {
    return 'Moteurs $min–$max';
  }

  @override
  String asignadosDe(int asignados, int total) {
    return '$asignados/$total attribués';
  }

  @override
  String disponiblesN(int n) {
    return '$n disponibles';
  }

  @override
  String get sortear => 'Tirer';

  @override
  String numeroMotor(int n) {
    return 'N° $n';
  }

  @override
  String get volverASortear => 'Retirer';

  @override
  String get quitarMotor => 'Retirer le moteur';

  @override
  String get faltaRangoMotores => 'Plage de moteurs non configurée';

  @override
  String get faltaRangoMotoresTexto =>
      'Définissez la plage de numéros de moteur d\'organisation dans le championnat pour pouvoir les tirer.';

  @override
  String get configurarCampeonato => 'Configurer le championnat';

  @override
  String get rangoMotoresNoConfigurado => 'Plage de moteurs non configurée.';

  @override
  String get asignado => 'Attribué';

  @override
  String get disponible => 'Disponible';

  @override
  String get tanda => 'Série';

  @override
  String get verificaciones => 'Vérifications';

  @override
  String get renumerarCarriles => 'Renuméroter les voies';

  @override
  String get renumerar => 'Renuméroter';

  @override
  String renumerarCarrilesTexto(String nombre, int carriles) {
    return 'Toutes les voies de « $nombre » sont réattribuées par points, du plus haut au plus bas : 1 à $carriles et, s\'il y a plus de pilotes, D1, D2… Les modifications manuelles sont perdues.';
  }

  @override
  String get inscribirEquipo => 'Inscrire une équipe';

  @override
  String get aunNoHayEquiposInscritos =>
      'Aucune équipe inscrite pour l\'instant';

  @override
  String get pulsaInscribirEquipo =>
      'Appuyez sur « Inscrire une équipe » pour les ajouter une à une en attribuant une voie de départ.';

  @override
  String sinCarrilN(int n) {
    return 'Sans voie ($n)';
  }

  @override
  String get actual => 'actuelle';

  @override
  String get libre => 'libre';

  @override
  String get libreTitulo => 'Libre';

  @override
  String carrilDe(String nombre) {
    return 'Voie de $nombre';
  }

  @override
  String get tocaCarrilLibreTexto =>
      'Touchez une voie libre pour l\'y déplacer, ou une voie occupée pour les échanger.';

  @override
  String get pista => 'Piste';

  @override
  String get descanso => 'Repos';

  @override
  String get seedDirecto => 'Seed direct';

  @override
  String get sinCarril => 'Sans voie';

  @override
  String get escribirAMano => 'Saisir à la main…';

  @override
  String get carrilDeSalida => 'Voie de départ';

  @override
  String get carrilEjemplo => 'Ex. : D1, D2, 1, 2, 3…';

  @override
  String get carrilAyuda => 'D1-D4 pour les seeds directs, 1-N pour le tirage';

  @override
  String get guardar => 'Enregistrer';

  @override
  String quienSaleEnCarril(String carril) {
    return 'Qui part de la voie $carril ?';
  }

  @override
  String dejaLibreEl(String carril) {
    return 'Libère la voie $carril';
  }

  @override
  String get carrilesRepetidos => 'Voies en double';

  @override
  String pistersPilotosDe(String tanda) {
    return 'Commissaires : pilotes de $tanda';
  }

  @override
  String get cambiarCarril => 'Changer de voie';

  @override
  String get quitarSeedDirecto => 'Retirer le seed direct';

  @override
  String get marcarSeedDirecto => 'Marquer comme seed direct';

  @override
  String get quitarDeLaTanda => 'Retirer de la série';

  @override
  String get quitarInscripcion => 'Retirer l\'inscription';

  @override
  String quitarInscripcionTexto(String nombre) {
    return 'Retirer « $nombre » de cette série ?';
  }

  @override
  String inscribirEquipoEn(String nombre) {
    return 'Inscrire une équipe dans « $nombre »';
  }

  @override
  String get buscarEquipoOPiloto => 'Rechercher une équipe ou un pilote…';

  @override
  String get noHayEquiposEnCampeonatoCrealos =>
      'Aucune équipe dans ce championnat. Créez-les d\'abord.';

  @override
  String get todosLosEquiposYaInscritos =>
      'Toutes les équipes sont déjà inscrites.';

  @override
  String get inscribir => 'Inscrire';

  @override
  String get carrilEjemploCorto => 'Ex. : D1, 3…';

  @override
  String get carrilAyudaVacio =>
      'Laissez vide si vous n\'attribuez pas encore de voie';

  @override
  String get inscritosALaPrueba => 'Inscrits à l\'épreuve';

  @override
  String get actualizarDesdeDrive => 'Mettre à jour depuis Drive';

  @override
  String get actualizandoDesdeDrive => 'Mise à jour depuis Drive…';

  @override
  String get anadirPiloto => 'Ajouter un pilote';

  @override
  String get anadirEquipo => 'Ajouter une équipe';

  @override
  String get importar => 'Importer';

  @override
  String get vincularGoogleSheet => 'Lier un Google Sheet';

  @override
  String get desdeArchivoCsvExcel => 'Depuis un fichier CSV / Excel';

  @override
  String get generarTandas => 'Générer les séries';

  @override
  String get aunNoHayPilotosInscritosPrueba =>
      'Aucun pilote inscrit à cette épreuve pour l\'instant';

  @override
  String get aunNoHayEquiposInscritosPrueba =>
      'Aucune équipe inscrite à cette épreuve pour l\'instant';

  @override
  String get importaCsvGoogleFormPilotos =>
      'Importez le CSV/Excel du Google Form ou ajoutez des pilotes à la main.';

  @override
  String get importaCsvGoogleFormEquipos =>
      'Importez le CSV/Excel du Google Form ou ajoutez des équipes à la main.';

  @override
  String get importarCsvExcel => 'Importer CSV/Excel';

  @override
  String get anadirAMano => 'Ajouter à la main';

  @override
  String pilotosInscritosGenerarTandas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '$n pilotes inscrits. Quand ils sont tous là, appuyez sur « Générer les séries ».',
      one:
          '1 pilote inscrit. Quand ils sont tous là, appuyez sur « Générer les séries ».',
    );
    return '$_temp0';
  }

  @override
  String equiposInscritosGenerarTandas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '$n équipes inscrites. Quand elles sont toutes là, appuyez sur « Générer les séries ».',
      one:
          '1 équipe inscrite. Quand elles sont toutes là, appuyez sur « Générer les séries ».',
    );
    return '$_temp0';
  }

  @override
  String get darDeBaja => 'Retirer';

  @override
  String darDeBajaTexto(String nombre) {
    return 'Retirer « $nombre » ?\n\nIl est retiré des Inscrits et de sa série. Les voies des autres ne changent pas : renumérotez la série ensuite si nécessaire.';
  }

  @override
  String get inscribirPilotos => 'Inscrire des pilotes';

  @override
  String get inscribirEquipos => 'Inscrire des équipes';

  @override
  String nSeleccionados(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n sélectionnés',
      one: '1 sélectionné',
    );
    return '$_temp0';
  }

  @override
  String get limpiar => 'Effacer';

  @override
  String get buscarPiloto => 'Rechercher un pilote…';

  @override
  String get noHayPilotosEnCampeonato => 'Aucun pilote dans ce championnat.';

  @override
  String get noHayEquiposEnCampeonato => 'Aucune équipe dans ce championnat.';

  @override
  String get todosYaInscritos => 'Tous sont déjà inscrits.';

  @override
  String get nuevaInscripcion => 'Nouvelle inscription';

  @override
  String get nuevoEquipo => 'Nouvelle équipe';

  @override
  String get copaParaPilotosNuevos => 'Coupe pour les nouveaux pilotes :';

  @override
  String get desmarcarTodos => 'Tout décocher';

  @override
  String marcarTodosN(int n) {
    return 'Tout cocher ($n)';
  }

  @override
  String nuevaInscripcionCopa(String copa) {
    return 'Nouvelle inscription · Coupe $copa';
  }

  @override
  String get marcaPilotosInscribir => 'Cochez les pilotes à inscrire';

  @override
  String get marcaEquiposInscribir => 'Cochez les équipes à inscrire';

  @override
  String inscribirNPilotos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pilotes',
      one: '1 pilote',
    );
    return 'Inscrire $_temp0';
  }

  @override
  String inscribirNEquipos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n équipes',
      one: '1 équipe',
    );
    return 'Inscrire $_temp0';
  }

  @override
  String get importarInscripciones => 'Importer les inscriptions';

  @override
  String get csvGoogleFormInscripcionPilotos =>
      'CSV/Excel du Google Form d\'inscription à l\'épreuve. Les inscriptions sont reliées aux pilotes existants par leur nom.';

  @override
  String get csvGoogleFormInscripcionEquipos =>
      'CSV/Excel du Google Form d\'inscription à l\'épreuve. Les inscriptions sont reliées aux équipes existantes par leur nom.';

  @override
  String get paso2AsignaColumnas => '2. Associez les colonnes';

  @override
  String get nombreDelPilotoObligatorio => 'Nom du pilote *';

  @override
  String get nombreDelEquipoObligatorio => 'Nom de l\'équipe *';

  @override
  String get diaPreferidoOpcional => 'Jour préféré (facultatif)';

  @override
  String get notasOpcional => 'Notes (facultatif)';

  @override
  String get paso3VistaPrevia => '3. Aperçu';

  @override
  String nDeTotalSeImportaran(int n, int total) {
    return '$n sur $total seront importés';
  }

  @override
  String pilotosNoExistenAviso(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '⚠️ $n pilotes n\'existent pas dans le championnat. Créez-les d\'abord ou vérifiez les noms.',
      one:
          '⚠️ 1 pilote n\'existe pas dans le championnat. Créez-le d\'abord ou vérifiez le nom.',
    );
    return '$_temp0';
  }

  @override
  String equiposNoExistenAvisoImport(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '⚠️ $n équipes n\'existent pas dans le championnat. Créez-les d\'abord ou vérifiez les noms.',
      one:
          '⚠️ 1 équipe n\'existe pas dans le championnat. Créez-la d\'abord ou vérifiez le nom.',
    );
    return '$_temp0';
  }

  @override
  String get asignaColumnaPiloto => 'Associez la colonne du nom du pilote.';

  @override
  String get asignaColumnaEquipo => 'Associez la colonne du nom de l\'équipe.';

  @override
  String get ninguna => '— aucune —';

  @override
  String get yaInscrito => 'Déjà inscrit';

  @override
  String diaTexto(String dia) {
    return 'Jour : $dia';
  }

  @override
  String noSePudoLeer(String detalle) {
    return 'Impossible de lire : $detalle';
  }

  @override
  String resumenImportacionInscripciones(int ok, int saltados) {
    return '✓ Inscrits : $ok\n✗ Ignorés : $saltados';
  }

  @override
  String tandaNumero(int n) {
    return 'Série $n';
  }

  @override
  String get tandasCreadas => 'Séries créées';

  @override
  String tandasCreadasTexto(int n, int equipos) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n séries créées avec $equipos équipes.',
      one: '1 série créée avec $equipos équipes.',
    );
    return '$_temp0';
  }

  @override
  String get conCarrilAsignado => 'Avec voie de départ attribuée.';

  @override
  String get carrilesSeAsignaranAntes =>
      'Les voies seront attribuées avant la course.';

  @override
  String get pistersAsignadosEntreTandas =>
      'Commissaires attribués entre les séries de chaque journée.';

  @override
  String equiposInscritosARepartir(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n équipes inscrites à répartir',
      one: '1 équipe inscrite à répartir',
    );
    return '$_temp0';
  }

  @override
  String get ordenadosPorPuntos => 'Triées par points bruts cumulés.';

  @override
  String get sinPuntosEsteAnio =>
      'Aucun point cette année → triées par solde de l\'année précédente (0 sinon).';

  @override
  String get paso1CarrilesPista => '1. Voies de la piste';

  @override
  String get paso1CarrilesTexto =>
      'Combien de voitures roulent en même temps. Fixe le maximum d\'équipes par série pour bien les répartir.';

  @override
  String get carrilesMin => 'voies';

  @override
  String get minutosPorCarrilTexto =>
      'Minutes par voie (durée du relais d\'une équipe sur chaque voie, pour calculer la durée de la série).';

  @override
  String get minPorCarril => 'min/voie';

  @override
  String cadaTandaDurara(int minutos, int carriles, int minPorCarril) {
    return 'Chaque série durera ~$minutos min ($carriles voies × $minPorCarril min).';
  }

  @override
  String get paso2NumeroTandas => '2. Nombre de séries';

  @override
  String sugeridoTexto(int n, int carriles) {
    return 'Suggéré : $n (sans voies vides avec $carriles voies : s\'il reste des équipes, les séries dépassent $carriles). Vous pouvez le changer.';
  }

  @override
  String get paso3NombresHorarios => '3. Noms et horaires';

  @override
  String get asignarCarrilAutomatico => 'Attribuer les voies automatiquement';

  @override
  String asignarCarrilTexto(int carriles) {
    return 'Par points, du plus haut au plus bas : voies 1 à $carriles et, s\'il y a plus de pilotes, D1, D2…';
  }

  @override
  String get asignarPisters => 'Attribuer les commissaires';

  @override
  String get asignarPistersTexto =>
      'Entre les séries du même jour. 2 séries : 1re↔2e. 3 : la 3e commissaire dans la 1re, la 1re dans la 2e et la 2e dans la 3e. 4 : 1re↔2e et 3e↔4e.';

  @override
  String get paso4VistaPrevia => '4. Aperçu';

  @override
  String get numeroIzquierdaCarril =>
      'Le numéro de gauche est la voie de départ.';

  @override
  String get carrilesLosAsignarasDespues =>
      'Vous attribuerez les voies plus tard, avant la course.';

  @override
  String sinTandaN(int n) {
    return 'Sans série ($n)';
  }

  @override
  String get sinTandaTexto =>
      'Ces équipes préfèrent un jour qui n\'a aucune série dans cette répartition. Ajoutez une série de ce jour ci-dessus ou changez leur préférence.';

  @override
  String prefiereDia(String dia) {
    return 'Préfère : $dia';
  }

  @override
  String get sustituirTandasExistentes => 'Remplacer les séries existantes';

  @override
  String get sustituirTandasTexto =>
      'Si cette épreuve avait déjà des séries, elles sont supprimées et remplacées.';

  @override
  String get crearEstasTandas => 'Créer ces séries';

  @override
  String get eligeLaCarrera => 'Choisissez la course';

  @override
  String get verCarreras => 'Voir les courses';

  @override
  String resultadosDeCarrera(String nombre) {
    return 'Résultats : $nombre';
  }

  @override
  String noSePudoConectar(String detalle) {
    return 'Connexion impossible : $detalle';
  }

  @override
  String noSePudieronTraerResultados(String detalle) {
    return 'Impossible de récupérer les résultats : $detalle';
  }

  @override
  String get noHayCampeonatoActivo => 'Aucun championnat actif.';

  @override
  String resultadosAplicadosSaltados(int ok, int saltados) {
    return 'Résultats appliqués : $ok · ignorés : $saltados';
  }

  @override
  String errorAlAplicar(String detalle) {
    return 'Erreur lors de l\'application : $detalle';
  }

  @override
  String get pitwallNoTieneCarreras => 'PitWall n\'a aucune course.';

  @override
  String get pitwallNoTieneCarrerasEnvia =>
      'PitWall n\'a aucune course. Envoyez d\'abord une série (« Envoyer à PitWall ») ou créez la course dans Manager.';

  @override
  String tandasDeCarrera(int n) {
    return '$n série(s)';
  }

  @override
  String get laCarreraNoTieneResultados =>
      'La course n\'a pas encore de résultats.';

  @override
  String get equipoNoEncontradoCampeonato =>
      'Équipe introuvable dans le championnat';

  @override
  String get noInscritoEnEstaPrueba => 'Non inscrite à cette épreuve';

  @override
  String seAplicaraPosicion(int posicion) {
    return 'la position $posicion sera appliquée';
  }

  @override
  String aplicarN(int n) {
    return 'Appliquer ($n)';
  }

  @override
  String tandaAbrev(int n) {
    return 'S$n';
  }

  @override
  String get seEnvianComoConsulta =>
      'Ils sont envoyés en consultation : visibles dans PitWall mais non modifiables.';

  @override
  String get atras => 'Retour';

  @override
  String get noHayVerificacionesEnviar =>
      'Aucune vérification à envoyer dans cette épreuve.';

  @override
  String copaDosPuntos(String copa) {
    return 'Coupe : $copa';
  }

  @override
  String get aunNoHayEquiposEnEstaTanda =>
      'Aucune équipe dans cette série pour l\'instant';

  @override
  String get inscribeEquiposVerificacion =>
      'Inscrivez des équipes dans la série pour pouvoir les vérifier.';

  @override
  String nConVerificacion(int n) {
    return '$n avec vérification';
  }

  @override
  String nValidadas(int n) {
    return '$n validées';
  }

  @override
  String get quitarParticipante => 'Retirer le participant';

  @override
  String quitarConVerificacionTexto(String nombre) {
    return '« $nombre » sera retiré et sa vérification supprimée. Continuer ?';
  }

  @override
  String quitarSinVerificacionTexto(String nombre) {
    return '« $nombre » sera retiré. Continuer ?';
  }

  @override
  String get validada => 'Validée';

  @override
  String get borrador => 'Brouillon';

  @override
  String get enRevision => 'En cours';

  @override
  String get pendiente => 'En attente';

  @override
  String get sinCocheAsignado => 'Aucune voiture attribuée';

  @override
  String get sesionCerrada => 'La session est fermée.';

  @override
  String get campeonatoFinalizado => 'Le championnat est terminé.';

  @override
  String get pruebaTerminada => 'L\'épreuve est terminée.';

  @override
  String get exportar => 'Exporter';

  @override
  String get exportarPdf => 'Exporter en PDF';

  @override
  String get exportarExcel => 'Exporter en Excel';

  @override
  String get noHayPruebasEnCampeonato => 'Aucune épreuve dans ce championnat.';

  @override
  String get noHayInscritosNiVerificaciones =>
      'Aucun inscrit ni vérification dans cette épreuve.';

  @override
  String get buscarPilotoEquipoCopa => 'Rechercher pilote, équipe, coupe…';

  @override
  String filtroTodos(int n) {
    return 'Tous ($n)';
  }

  @override
  String filtroConInfraccion(int n) {
    return 'Avec infraction ($n)';
  }

  @override
  String filtroSinVerificar(int n) {
    return 'Non vérifiées ($n)';
  }

  @override
  String filtroBorrador(int n) {
    return 'Brouillon ($n)';
  }

  @override
  String validadasDeTotal(int validadas, int total) {
    return '$validadas validées sur $total';
  }

  @override
  String get nadaConEsteFiltro => 'Rien à afficher avec ce filtre.';

  @override
  String get colPilotoEquipo => 'Pilote / équipe';

  @override
  String get fueraDeReglamento => 'Hors règlement';

  @override
  String get copa => 'Coupe';

  @override
  String get coche => 'Voiture';

  @override
  String get colPesoCarroc => 'Poids carross.';

  @override
  String get colPesoMin => 'Poids min.';

  @override
  String get colPesoCoche => 'Poids voiture';

  @override
  String get motor => 'Moteur';

  @override
  String get alturaMotor => 'Hauteur moteur';

  @override
  String get colEjeDel => 'Essieu av.';

  @override
  String get colEjeTras => 'Essieu arr.';

  @override
  String get pinon => 'Pignon';

  @override
  String get corona => 'Couronne';

  @override
  String get llantaDelantera => 'Jante avant';

  @override
  String get llantaTrasera => 'Jante arrière';

  @override
  String get trencilla => 'Tresse';

  @override
  String get suspension => 'Suspension';

  @override
  String get bancada => 'Support moteur';

  @override
  String get chasis => 'Châssis';

  @override
  String get neumatico => 'Pneu';

  @override
  String get carroceria => 'Carrosserie';

  @override
  String get observaciones => 'Remarques';

  @override
  String get sinVerificar => 'Non vérifiée';

  @override
  String get propio => 'Personnel';

  @override
  String orgNumero(String n) {
    return 'Org. n° $n';
  }

  @override
  String get conforme => 'Conforme';

  @override
  String get noConforme => 'Non conforme';

  @override
  String get toca => 'Touche';

  @override
  String get bien => 'Bon';

  @override
  String get faltanPiezas => 'Pièces manquantes';

  @override
  String faltanPiezasDetalle(String piezas) {
    return 'Manquent : $piezas';
  }

  @override
  String marcaNoPermitida(String marca) {
    return 'Marque « $marca » non autorisée';
  }

  @override
  String superaMaximoMm(String maximo) {
    return 'Dépasse le maximum de $maximo mm';
  }

  @override
  String porDebajoMinimoG(String minimo) {
    return 'En dessous du minimum de $minimo g';
  }

  @override
  String get alturaMotorNoConforme => 'Hauteur de moteur non conforme';

  @override
  String get leFaltanPiezas => 'Pièces manquantes';

  @override
  String vPesoInicialBajo(String valor, String minimo) {
    return 'Poids initial ${valor}g en dessous du minimum ${minimo}g.';
  }

  @override
  String vPesoFinalBajo(String valor, String minimo) {
    return 'Poids final ${valor}g en dessous du minimum ${minimo}g.';
  }

  @override
  String get vMotorSinCatalogo =>
      'Sélectionnez le moteur du catalogue pour vérifier les mesures.';

  @override
  String vMotorRpmAlto(String motor, String max, String medido) {
    return 'RPM au-dessus de la référence du $motor (max $max, mesuré $medido).';
  }

  @override
  String vMotorUmsAlto(String motor, String max, String medido) {
    return 'Aimant au-dessus de la référence du $motor (max $max, mesuré $medido).';
  }

  @override
  String get vAlturaNoConforme =>
      'Hauteur de moteur non conforme : touche la piste.';

  @override
  String vEjeDelAncho(String medido, String max) {
    return 'Largeur essieu avant $medido mm au-dessus du maximum $max mm.';
  }

  @override
  String vEjeTraAncho(String medido, String max) {
    return 'Largeur essieu arrière $medido mm au-dessus du maximum $max mm.';
  }

  @override
  String vMarcaNoPermitidaLista(String marca, String lista) {
    return 'Marque « $marca » non autorisée (seulement $lista).';
  }

  @override
  String vMarcaFueraCatalogo(String marca) {
    return 'Marque « $marca » absente du catalogue.';
  }

  @override
  String vLlantaDelNoCatalogada(String valor) {
    return 'Jante avant absente du catalogue : « $valor ».';
  }

  @override
  String vLlantaTraNoCatalogada(String valor) {
    return 'Jante arrière absente du catalogue : « $valor ».';
  }

  @override
  String vBancadaNoCatalogada(String valor) {
    return 'Support moteur absent du catalogue : « $valor ».';
  }

  @override
  String vNeumaticoNoCatalogado(String valor) {
    return 'Pneu absent du catalogue : « $valor ».';
  }

  @override
  String vBalanceNegativo(String equipo, String coche, String balance) {
    return 'Solde de crédits négatif : équipe $equipo + voiture $coche = $balance.';
  }

  @override
  String get noSePudoGenerarExcel => 'Impossible de générer le fichier Excel.';

  @override
  String get buscarPuntos => 'Rechercher…';

  @override
  String sinResultadosPara(String filtro) {
    return 'Aucun résultat pour « $filtro »';
  }

  @override
  String get sinAsignarGuiones => '— non attribué —';

  @override
  String get sorteoEtiqueta => 'Tirage';

  @override
  String get mixto => 'Mixte';

  @override
  String get limitarFabricante => 'Limiter le fabricant';

  @override
  String noCatalogada(String nombre) {
    return '$nombre (absente du catalogue)';
  }

  @override
  String get imagenNoSePuedeLeer =>
      'Impossible de lire cette image. Utilisez un PNG ou JPG.';

  @override
  String noSePudoAnadirLogo(String detalle) {
    return 'Impossible d\'ajouter le logo : $detalle';
  }

  @override
  String get elegirLogo => 'Choisir un logo';

  @override
  String get cambiarLogo => 'Changer de logo';

  @override
  String get repartir => 'Répartir';

  @override
  String get configuraRangoSesion =>
      'Configurez la plage de moteurs dans le règlement de la session pour tirer.';

  @override
  String get configuraRangoCampeonato =>
      'Configurez la plage de moteurs dans le championnat pour tirer.';

  @override
  String get sorteoDeMotor => 'Tirage du moteur';

  @override
  String get otroControl => 'Un autre Control';

  @override
  String cambiadaFueraTexto(String quien) {
    return '$quien a modifié cette vérification. Si vous continuez à éditer, vos changements remplaceront les siens.';
  }

  @override
  String get seguirConLoMio => 'Garder les miens';

  @override
  String verLoDe(String quien) {
    return 'Voir ceux de $quien';
  }

  @override
  String actualizadaConCambios(String quien) {
    return 'Mise à jour avec les changements de $quien.';
  }

  @override
  String noSePudoAnadirFoto(String detalle) {
    return 'Impossible d\'ajouter la photo : $detalle';
  }

  @override
  String get copaEnEstaPrueba => 'Coupe dans cette épreuve';

  @override
  String get copaEnEstaPruebaTexto =>
      'Change la coupe seulement pour cette épreuve, sans affecter l\'équipe ni les autres épreuves.';

  @override
  String get copaCategoria => 'Coupe / catégorie';

  @override
  String copaDelEquipo(String copa) {
    return 'Coupe de l\'équipe : $copa';
  }

  @override
  String get usarLaDelEquipo => 'Utiliser celle de l\'équipe';

  @override
  String get usarReglamentoActual => 'Utiliser le règlement actuel';

  @override
  String get usarReglamentoActualTexto =>
      'Cette vérification sera contrôlée avec les valeurs actuelles du catalogue et du championnat au lieu de celles qu\'elle avait lors du contrôle :';

  @override
  String get recalcularanCreditos =>
      'Comme elle est validée, ses crédits seront recalculés.';

  @override
  String get usarElActual => 'Utiliser l\'actuel';

  @override
  String get desbloquearVerificacion => 'Déverrouiller la vérification';

  @override
  String desbloquearTexto(String motivo) {
    return '$motivo Ses vérifications sont verrouillées pour éviter de les modifier par erreur.\n\nSi vous la déverrouillez, les changements seront enregistrés comme d\'habitude. Elle continuera d\'être contrôlée avec le règlement utilisé lors de la vérification.';
  }

  @override
  String get desbloquear => 'Déverrouiller';

  @override
  String get verificacion => 'Vérification';

  @override
  String get eliminarVerificacion => 'Supprimer la vérification';

  @override
  String get eliminarVerificacionTexto =>
      'Les données saisies seront perdues. Continuer ?';

  @override
  String get modeloCoche => 'Modèle de voiture';

  @override
  String get elegirCoche => 'Choisir une voiture';

  @override
  String noHayCochesConCopa(String copa) {
    return 'Aucune voiture avec la coupe $copa dans le catalogue';
  }

  @override
  String get ayudaSelectorCoche =>
      'Le poids minimum et les crédits de la voiture s\'affichent quand vous la choisissez';

  @override
  String get creditosAbrev => 'créd';

  @override
  String get pesoGramos => 'Poids (grammes)';

  @override
  String get pesoCarroceria => 'Poids carrosserie';

  @override
  String minimoG(String n) {
    return 'Minimum : ${n}g';
  }

  @override
  String get estetica => 'Esthétique';

  @override
  String get sinComprobar => 'Non contrôlé';

  @override
  String get quePiezasFaltan => 'Quelles pièces manquent';

  @override
  String get organizacion => 'Organisation';

  @override
  String get numeroDeMotor => 'Numéro de moteur';

  @override
  String get motorDelCatalogo => 'Moteur du catalogue';

  @override
  String get elegirMotor => 'Choisir un moteur';

  @override
  String yaNoEnCatalogo(String nombre) {
    return '$nombre (plus dans le catalogue)';
  }

  @override
  String refMotor(String rpm, String gauss) {
    return 'Réf. : $rpm RPM · $gauss gauss';
  }

  @override
  String motoresHomologadosCopa(String copa) {
    return 'Moteurs homologués pour la coupe $copa';
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
  String get alturaMotorAPista => 'Hauteur de moteur sur piste';

  @override
  String get alturaMotorTexto =>
      'Contrôle avec la plaque : si ça touche la piste, non conforme.';

  @override
  String get delantero => 'Avant';

  @override
  String get trasero => 'Arrière';

  @override
  String get marca => 'Marque';

  @override
  String get dimension => 'Dimension';

  @override
  String get dientes => 'Dents';

  @override
  String get diametro => 'Diamètre';

  @override
  String get material => 'Matériau';

  @override
  String get pesoCocheEntero => 'Poids voiture entière (grammes)';

  @override
  String get inicial => 'Initial';

  @override
  String get cocheEntero => 'Voiture entière';

  @override
  String get otros => 'Autres';

  @override
  String get notasOAvisos => 'Notes ou remarques';

  @override
  String get fotosHasta4 => 'Photos (jusqu\'à 4)';

  @override
  String get marcarComoValidada => 'Marquer comme validée';

  @override
  String get marcarComoValidadaTexto =>
      'Indique que la vérification a été révisée et approuvée.';

  @override
  String get autoguardadoTexto =>
      'Enregistré comme brouillon à chaque modification.';

  @override
  String get validar => 'Valider';

  @override
  String get noPuedesValidar =>
      'Vous ne pouvez pas valider tant qu\'il y a des infractions en rouge ci-dessus.';

  @override
  String get fotoReferenciaTexto =>
      'Photo de référence du catalogue : vérifiez qu\'elle correspond.';

  @override
  String get sinFotoCocheTexto =>
      'Cette voiture n\'a pas de photo dans le catalogue. Ajoutez-la dans Catalogues → Voitures pour pouvoir comparer le modèle livré.';

  @override
  String get sinGuardar => 'Non enregistré…';

  @override
  String get guardando => 'Enregistrement…';

  @override
  String get guardado => 'Enregistré';

  @override
  String get errorCorto => 'Erreur';

  @override
  String soloLecturaTexto(String motivo) {
    return '$motivo Vérification en lecture seule.';
  }

  @override
  String desbloqueadaTexto(String motivo) {
    return '$motivo Déverrouillée : les changements sont enregistrés.';
  }

  @override
  String reglamentoCongelado(String fecha) {
    return 'Règlement figé le $fecha : le contrôle utilise les valeurs du moment de la vérification.';
  }

  @override
  String get reglamentoCongeladoSinFecha =>
      'Règlement figé : le contrôle utilise les valeurs du moment de la vérification.';

  @override
  String get haCambiadoDesdeEntonces => 'A changé depuis (non appliqué) :';

  @override
  String get todoCumple =>
      'Tout est conforme au règlement. Vous pouvez valider.';

  @override
  String infraccionesN(int n) {
    return 'Infractions : $n';
  }

  @override
  String avisosN(int n) {
    return 'Avertissements : $n';
  }

  @override
  String pendienteHechosDeTotal(int hechos, int total) {
    return '$hechos/$total en attente';
  }

  @override
  String get hecho => 'Fait';

  @override
  String get revisar => 'À revoir';

  @override
  String bloquesCompletos(int hechos, int total) {
    return 'Blocs complets : $hechos sur $total';
  }

  @override
  String faltaLista(String lista) {
    return 'Manque : $lista';
  }

  @override
  String fueraDeLaLista(String valor) {
    return '$valor (hors liste)';
  }

  @override
  String noCatalogado(String valor) {
    return '$valor (absent du catalogue)';
  }

  @override
  String conEsteCoche(String creditos) {
    return 'Avec cette voiture ($creditos créd) :';
  }

  @override
  String get total => 'Total';

  @override
  String nCreditos(int n) {
    return '$n crédits';
  }

  @override
  String get sinCreditosSuficientes =>
      '⚠ Ils n\'ont pas assez de crédits pour couvrir la voiture.';

  @override
  String get hacerFoto => 'Prendre une photo';

  @override
  String get elegirDeGaleria => 'Choisir dans la galerie';

  @override
  String get anadir => 'Ajouter';

  @override
  String get equipoNoInscritoPrueba =>
      'L\'équipe n\'est pas inscrite à l\'épreuve : inscrivez-la pour pouvoir la facturer.';

  @override
  String get etiquetaFinal => 'Final';

  @override
  String get anchuraEjeMm => 'Largeur d\'essieu (mm)';

  @override
  String get nombreDelClub => 'Nom du club';

  @override
  String get clubEjemplo => 'Ex. : Club Slot Barcelona';

  @override
  String get limitarFabricanteTexto =>
      'Lors de la vérification, les listes de marque (pignon, couronne, jantes et tresse) n\'affichent que les marques choisies ; toute autre est une infraction.';

  @override
  String get eligeAlMenosUnaMarca => 'Choisissez au moins une marque.';

  @override
  String get tipoMotorSorteoTexto =>
      'L\'organisation tire les moteurs au sort : lors de la vérification, on note seulement le numéro de moteur.';

  @override
  String get tipoMotorPropioTexto =>
      'Chaque équipe apporte son moteur : lors de la vérification, il est choisi dans le catalogue et les RPM sont contrôlées.';

  @override
  String get tipoMotorMixtoTexto =>
      'À chaque vérification, on indique si le moteur est celui de l\'organisation ou celui de l\'équipe.';

  @override
  String get tipoMotorEligeTexto => 'Choisissez d\'où viennent les moteurs.';

  @override
  String get noPagaEstaPrueba => 'ne paie pas cette épreuve';

  @override
  String get quitarWildcard => 'Retirer le wildcard';

  @override
  String get quitarCoordTotal => 'Retirer « Coord. total » (repaye)';

  @override
  String get coordinadoraEnFicha =>
      'Les pilotes sont marqués comme coordinateurs dans leur fiche ; modifiez-le là-bas';

  @override
  String get marcarWildcard => 'Marquer comme wildcard (ne paie pas)';

  @override
  String desglosePagados(String total) {
    return 'Détail des $total € payés';
  }

  @override
  String get pagat => 'Payé';

  @override
  String get coordinadora => 'Coordination';

  @override
  String get club => 'Club';

  @override
  String get observacionesOpcional => 'Remarques (facultatif)';

  @override
  String descuadreTexto(String suma, String total) {
    return 'Coordination + Club ($suma) ne totalise pas le Payé ($total).';
  }

  @override
  String get pagoRapido => 'Paiement rapide :';

  @override
  String get coordYPiloto => 'Coord. + pilote';

  @override
  String coordYPilotoTooltip(String monto) {
    return 'Un pilote est coordinateur : paie la moitié de tout ($monto €)';
  }

  @override
  String get coordTotal => 'Coord. total';

  @override
  String get coordTotalTooltip =>
      'Tous les pilotes sont coordinateurs : ne paie pas';

  @override
  String get observacionMitad => 'Moitié — un pilote coordinateur';

  @override
  String get nuevaSesion => 'Nouvelle session';

  @override
  String get aunNoHaySesiones => 'Aucune session pour l\'instant';

  @override
  String get sesionesVaciasTexto =>
      'Vérifiez des voitures sans monter un championnat : une course ponctuelle, un contrôle au club… Créez une session, ajoutez des participants et exportez le PDF.';

  @override
  String nParticipantes(int n) {
    return '$n participants';
  }

  @override
  String get sesionYaNoExiste => 'La session n\'existe plus.';

  @override
  String get aunNoHayParticipantes => 'Aucun participant pour l\'instant';

  @override
  String get pulsaAnadirParticipante =>
      'Appuyez sur « Ajouter un participant » pour vérifier sa voiture, ou importez-les depuis un fichier ou Google Sheets avec « Importer » ci-dessus.';

  @override
  String get anadirParticipante => 'Ajouter un participant';

  @override
  String get desdeArchivoCsvExcelParentesis =>
      'Depuis un fichier (CSV / Excel)';

  @override
  String get desdeGoogleSheets => 'Depuis Google Sheets';

  @override
  String get excelConFotos => 'Excel avec photos';

  @override
  String get reglamento => 'Règlement';

  @override
  String get eliminarSesion => 'Supprimer la session';

  @override
  String get configuraCopasAntes =>
      'Configurez d\'abord les coupes dans le règlement de la session.';

  @override
  String anadidosParticipantes(int n) {
    return '$n participants ajoutés.';
  }

  @override
  String eliminarSesionTexto(String nombre) {
    return '« $nombre », ses participants et toutes ses vérifications seront supprimés. Action irréversible.';
  }

  @override
  String get pilotoObligatorio => 'Pilote *';

  @override
  String get obligatorio => 'Obligatoire';

  @override
  String get segundoPiloto => 'Deuxième pilote (facultatif)';

  @override
  String get equipoOpcional => 'Équipe (facultatif)';

  @override
  String get equipoOpcionalAyuda =>
      'Si laissé vide, le nom du pilote est utilisé';

  @override
  String get anadirYVerificar => 'Ajouter et vérifier';

  @override
  String get seleccionaUnaCopa =>
      'Sélectionnez au moins une coupe / catégorie.';

  @override
  String get eligeTipoMotor =>
      'Moteur : choisissez s\'il est tiré au sort, personnel ou mixte.';

  @override
  String get limitarFabricanteError =>
      'Limiter le fabricant : choisissez au moins une marque ou désactivez-le.';

  @override
  String get nuevaSesionVerificacion => 'Nouvelle session de vérification';

  @override
  String get editarSesion => 'Modifier la session';

  @override
  String get nombreSesionObligatorio => 'Nom de la session *';

  @override
  String get nombreSesionAyuda =>
      'Ex. : Contrôle club jeudi, Course GT Sant Joan';

  @override
  String get lugarOpcional => 'Lieu (facultatif)';

  @override
  String get sinFecha => 'Sans date';

  @override
  String get fechaSesion => 'Date de la session';

  @override
  String get clubOrganizador => 'Club organisateur';

  @override
  String get clubOrganizadorAyuda => 'Apparaît en tête des PDF de la session.';

  @override
  String get copasCategorias => 'Coupes / catégories';

  @override
  String get copasCategoriasAyuda =>
      'Celles qui peuvent être vérifiées dans cette session. La coupe de chaque participant filtre le catalogue et les contrôles, comme dans un championnat.';

  @override
  String get anchuraEje => 'Largeur d\'essieu';

  @override
  String get anchuraEjeAyuda =>
      'Largeur d\'essieu maximale (mm) par coupe. Laissez vide si ce n\'est pas contrôlé dans cette coupe.';

  @override
  String get maxDelanteroMm => 'Max avant (mm)';

  @override
  String get maxTraseroMm => 'Max arrière (mm)';

  @override
  String get fabricante => 'Fabricant';

  @override
  String get fabricanteAyuda =>
      'Pour les sessions monomarque : limite les marques sélectionnables lors de la vérification.';

  @override
  String get rangoMotorTexto =>
      'Plage de numéros de moteur pour le tirage depuis la vérification. Laissez vide s\'il n\'y a pas de tirage.';

  @override
  String get motorDesde => 'Moteur de';

  @override
  String get motorHasta => 'Moteur à';

  @override
  String get indicaAmbos => 'Indiquez les deux';

  @override
  String get hastaMayorQueDesde => 'Jusqu\'à ≥ de';

  @override
  String get crearSesion => 'Créer la session';

  @override
  String get importarParticipantesArchivo =>
      'Importer des participants (fichier)';

  @override
  String get importarParticipantesSheets =>
      'Importer des participants (Google Sheets)';

  @override
  String errorAlImportar(String detalle) {
    return 'Erreur lors de l\'importation : $detalle';
  }

  @override
  String pasoEligeArchivoN(int n) {
    return '$n. Choisissez le fichier';
  }

  @override
  String pasoEligeLaHoja(int n) {
    return '$n. Choisissez la feuille';
  }

  @override
  String pasoEligeLaPestana(int n) {
    return '$n. Choisissez l\'onglet';
  }

  @override
  String pasoAsignaColumnasN(int n) {
    return '$n. Associez les colonnes';
  }

  @override
  String pasoVistaPreviaN(int n) {
    return '$n. Aperçu';
  }

  @override
  String get csvPlantillaTexto =>
      'CSV ou Excel avec une ligne d\'en-tête. Colonnes reconnues : Pilote 1 (ou Pilote / Nom), Pilote 2, Équipe et Coupe. Un modèle est disponible dans « Modèles CSV ».';

  @override
  String get buscarEnTusHojas => 'Rechercher dans vos feuilles…';

  @override
  String get buscar => 'Rechercher';

  @override
  String get pestana => 'Onglet';

  @override
  String get piloto1Obligatorio => 'Pilote 1 *';

  @override
  String get piloto2 => 'Pilote 2';

  @override
  String get copaPorDefecto => 'Coupe par défaut';

  @override
  String get copaPorDefectoAyuda =>
      'Pour les lignes sans coupe ou avec une coupe absente de la session';

  @override
  String get asignaColumnaPiloto1 =>
      'Associez au moins la colonne du pilote 1.';

  @override
  String get noHayFilasConPiloto => 'Aucune ligne avec un pilote.';

  @override
  String anadirNParticipantes(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n participants',
      one: '1 participant',
    );
    return 'Ajouter $_temp0';
  }

  @override
  String get noConectadoGoogle => 'Vous n\'êtes pas encore connecté à Google';

  @override
  String get conectaCuentaTexto =>
      'Connectez votre compte une fois pour pouvoir lire vos feuilles de calcul.';

  @override
  String get configurarGoogle => 'Configurer Google';

  @override
  String noSePudieronListarHojas(String detalle) {
    return 'Impossible de lister vos feuilles : $detalle';
  }

  @override
  String noSePudieronListarPestanas(String detalle) {
    return 'Impossible de lister les onglets : $detalle';
  }

  @override
  String noSePudoLeerPestana(String detalle) {
    return 'Impossible de lire l\'onglet : $detalle';
  }

  @override
  String get yaEstaEnLaSesion => 'Déjà dans la session';

  @override
  String copaNoEnSesion(String copa, String defecto) {
    return 'Coupe « $copa » absente de la session : $defecto est utilisée';
  }

  @override
  String get fotoCatalogo => 'Photo catalogue';

  @override
  String get pilotos => 'Pilotes';

  @override
  String get inscripciones => 'Inscriptions';

  @override
  String get nuevoPiloto => 'Nouveau pilote';

  @override
  String get editarPiloto => 'Modifier le pilote';

  @override
  String get crearPiloto => 'Créer le pilote';

  @override
  String get puntuacionPreviaImport => 'Score précédent (1re épreuve)';

  @override
  String get buscarPorNombre => 'Rechercher par nom…';

  @override
  String get aunNoHayPilotosCampeonato =>
      'Aucun pilote dans ce championnat pour l\'instant';

  @override
  String get noHayCoincidencias => 'Aucune correspondance';

  @override
  String get pulsaNuevoPiloto =>
      'Appuyez sur le bouton « Nouveau pilote » pour ajouter le premier.';

  @override
  String get quitarDelCampeonato => 'Retirer du championnat';

  @override
  String quitarDelCampeonatoTexto(String piloto, String campeonato) {
    return 'Retirer $piloto de « $campeonato » ?\n\nLe pilote n\'est pas supprimé, il est seulement désinscrit de ce championnat.';
  }

  @override
  String get motivoAjusteManual => 'Ajustement manuel (fiche pilote)';

  @override
  String get datosPersonales => 'Données personnelles';

  @override
  String get nombreYApellidos => 'Nom et prénom *';

  @override
  String get telefono => 'Téléphone';

  @override
  String get email => 'E-mail';

  @override
  String get palmaresHistorico => 'Palmarès historique';

  @override
  String get palmaresEjemplo => 'Ex. : « Top 3 ligue 2025 », « WES 2023-2024 »';

  @override
  String get pilotoCoordinadora => 'Pilote coordinateur';

  @override
  String get pilotoCoordinadoraTexto =>
      'Si activé, les équipes dans lesquelles il participe ne paieront pas de cotisation.';

  @override
  String get enEsteCampeonato => 'Dans ce championnat';

  @override
  String get categoria => 'Catégorie';

  @override
  String get creditosIniciales => 'Crédits initiaux';

  @override
  String get sugeridoSegunCategoria => 'Suggéré selon la catégorie';

  @override
  String get creditosActuales => 'Crédits actuels';

  @override
  String get palmaresLocal => 'Palmarès dans ce championnat';

  @override
  String get indicaUnNumero => 'Indiquez un nombre';

  @override
  String get tieneQueSerEntero => 'Cela doit être un nombre entier';

  @override
  String get noPuedeSerNegativo => 'Cela ne peut pas être négatif';

  @override
  String get importarPilotos => 'Importer des pilotes';

  @override
  String get soportaExcelPilotos =>
      'Prend en charge les fichiers Excel (.xlsx) et CSV. Il doit contenir au moins une colonne avec le nom des pilotes.';

  @override
  String resumenImportacionPilotos(int nuevos, int inscritos, int saltados) {
    return '✓ Nouveaux pilotes : $nuevos\n✓ Inscrits dans ce championnat : $inscritos\n✗ Ignorés : $saltados';
  }

  @override
  String errorImportando(String detalle) {
    return 'Erreur lors de l\'importation : $detalle';
  }

  @override
  String get indicaColumnaNombrePiloto =>
      'Indiquez quelle colonne contient le nom du pilote.';

  @override
  String get noFilasValidas => 'Aucune ligne valide trouvée.';

  @override
  String importarNPilotos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pilotes',
      one: '1 pilote',
    );
    return 'Importer $_temp0';
  }

  @override
  String get paso2AsignaLasColumnas => '2. Associez les colonnes';

  @override
  String get columnasAutodetectadas =>
      'Nous avons essayé de les détecter automatiquement. Modifiez-les si nécessaire.';

  @override
  String get categoriaMetal => 'Catégorie (métal)';

  @override
  String get palmares => 'Palmarès';

  @override
  String get nuevo => 'Nouveau';

  @override
  String get importarPuntuacionPrevia => 'Importer le score précédent';

  @override
  String get puntuacionPreviaTexto =>
      'Excel (.xlsx) ou CSV avec le nom du pilote et son score. Met à jour uniquement les pilotes DÉJÀ inscrits dans le championnat actif (croisement par nom) — n\'inscrit personne de nouveau.';

  @override
  String get puntuacionImportada => 'Score importé';

  @override
  String puntuacionImportadaTexto(int ok, int saltados) {
    return '✓ Mis à jour : $ok\n✗ Ignorés : $saltados\n\nCe score ne sert qu\'à « Générer les séries » lors de la première épreuve ; dès que le championnat a ses propres résultats, le classement réel le remplace automatiquement.';
  }

  @override
  String get puntuacionObligatoria => 'Score *';

  @override
  String nDeTotalSeActualizaran(int n, int total) {
    return '$n sur $total seront mis à jour';
  }

  @override
  String get indicaColumnaNombreYPuntuacion =>
      'Indiquez quelle colonne est le nom et quelle est le score.';

  @override
  String actualizarNPilotos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pilotes',
      one: '1 pilote',
    );
    return 'Mettre à jour $_temp0';
  }

  @override
  String get noEstaEnCampeonato => 'Absent du championnat';

  @override
  String get formulaSinCalcular =>
      'Formule non calculée — utilisez « collage spécial : valeurs »';

  @override
  String get seActualizara => 'Sera mis à jour';

  @override
  String get aunNoHayEquipos => 'Aucune équipe pour l\'instant';

  @override
  String get creaEquipoDosPilotos =>
      'Créez une équipe avec deux pilotes pour commencer.';

  @override
  String get creaInscripcionIndividual =>
      'Créez une inscription individuelle pour commencer.';

  @override
  String get importarEquipos => 'Importer des équipes';

  @override
  String get seleccionaLaCopa => 'Sélectionnez la coupe.';

  @override
  String get seleccionaUnPiloto => 'Sélectionnez au moins un pilote.';

  @override
  String get parejasNecesitanDosPilotos =>
      'Dans ce championnat (binômes), l\'équipe a besoin de deux pilotes.';

  @override
  String get pilotosRepetidos => 'Il y a des pilotes en double dans l\'équipe.';

  @override
  String get eliminarInscripcion => 'Supprimer l\'inscription';

  @override
  String get eliminarEquipo => 'Supprimer l\'équipe';

  @override
  String eliminarInscripcionTexto(String nombre) {
    return 'Supprimer l\'inscription de « $nombre » ? Cette action est irréversible.';
  }

  @override
  String eliminarEquipoTexto(String nombre) {
    return 'Supprimer l\'équipe « $nombre » ? Cette action est irréversible.';
  }

  @override
  String get editarInscripcion => 'Modifier l\'inscription';

  @override
  String get editarEquipo => 'Modifier l\'équipe';

  @override
  String get primeroAnadePilotos =>
      'Ajoutez d\'abord des pilotes au championnat pour pouvoir créer des équipes.';

  @override
  String get indicaUnNombre => 'Indiquez un nom';

  @override
  String get copaCategoriaObligatoria => 'Coupe / catégorie *';

  @override
  String get piloto => 'Pilote';

  @override
  String get pilotosDelEquipo => 'Pilotes de l\'équipe';

  @override
  String pilotoN(int n) {
    return 'Pilote $n';
  }

  @override
  String get cocheEnVerificacionTexto =>
      'La voiture est indiquée lors de la vérification de chaque série. Une équipe peut utiliser des voitures différentes selon les épreuves.';

  @override
  String get crearEquipo => 'Créer l\'équipe';

  @override
  String get elegirPiloto => '— choisir un pilote —';

  @override
  String equipoImportTexto(String pilotos) {
    return 'Chargez le CSV ou Excel du Google Form d\'avant-saison. Chaque ligne doit être une équipe avec le nom de l\'équipe et $pilotos.';
  }

  @override
  String get susDosPilotos => 'ses deux pilotes';

  @override
  String get suPiloto => 'son pilote';

  @override
  String get asignaColumnaEquipoYPiloto =>
      'Associez au moins la colonne du nom de l\'équipe et celle du premier pilote.';

  @override
  String importarNEquipos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n équipes',
      one: '1 équipe',
    );
    return 'Importer $_temp0';
  }

  @override
  String resumenImportacionEquipos(
    int equipos,
    int pilotosNuevos,
    int pilotosInscritos,
    int saltados,
  ) {
    return '✓ Équipes créées : $equipos\n✓ Nouveaux pilotes : $pilotosNuevos\n✓ Pilotes inscrits au championnat : $pilotosInscritos\n✗ Ignorés : $saltados';
  }

  @override
  String get columnasIntentadas =>
      'Nous avons essayé de les détecter. Modifiez celles qui sont incorrectes.';

  @override
  String get yaExiste => 'Existe déjà';

  @override
  String get sinPiloto => 'Sans pilote';

  @override
  String get faltaSegundoPiloto =>
      'Le deuxième pilote manque (championnat en binômes)';

  @override
  String get nombreObligatorio => 'Nom *';

  @override
  String get nombreCampo => 'Nom';

  @override
  String get piloto1 => 'Pilote 1';

  @override
  String get piloto2Opcional => 'Pilote 2 (facultatif)';

  @override
  String formatoNoSoportadoUsaCsv(String ext) {
    return 'Format non pris en charge : $ext. Utilisez .csv ou .xlsx';
  }

  @override
  String get tablaDePuntos => 'Table de points';

  @override
  String get rellenarAMano => 'Remplir à la main';

  @override
  String get aunNoHayClasificacion => 'Aucun classement pour l\'instant';

  @override
  String get clasificacionVaciaTexto =>
      'Enregistrez des résultats de série, importez-la depuis un fichier ou remplissez-la à la main.';

  @override
  String get importarClasificacion => 'Importer le classement';

  @override
  String get general => 'Général';

  @override
  String noHayPilotosEn(String titulo) {
    return 'Aucun pilote dans « $titulo ».';
  }

  @override
  String get todosLosPilotosCampeonato => 'Tous les pilotes du championnat';

  @override
  String pilotosDeCopa(String copa) {
    return 'Pilotes de la coupe $copa';
  }

  @override
  String nPilotos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pilotes',
      one: '1 pilote',
    );
    return '$_temp0';
  }

  @override
  String get equipo => 'Équipe';

  @override
  String get catAbrev => 'Cat.';

  @override
  String get bruto => 'Brut';

  @override
  String get descAbrev => 'Retr.';

  @override
  String get totalMayusculas => 'TOTAL';

  @override
  String get clasificacionAMano => 'Classement manuel';

  @override
  String clasificacionAManoCopa(String copa) {
    return 'Classement manuel · $copa';
  }

  @override
  String get sinPruebasParaPuntos =>
      'Ce championnat n\'a pas d\'épreuves. Créez d\'abord des épreuves pour pouvoir attribuer des points.';

  @override
  String get sinPilotosConEquipo =>
      'Aucun pilote avec une équipe dans ce championnat. Attribuez d\'abord des équipes aux pilotes.';

  @override
  String get editorManualTexto =>
      'Saisissez les points de chaque pilote par épreuve. Ils sont enregistrés automatiquement en quittant chaque case. Case vide = n\'a pas marqué ; 0 = a participé avec 0.';

  @override
  String get restaurarValores => 'Restaurer les valeurs par défaut';

  @override
  String get restaurar => 'Restaurer';

  @override
  String get restaurarTexto =>
      'La table de points actuelle sera remplacée par celle de PitWall Control (70, 64, 59… jusqu\'à 1 point). Les changements ne sont enregistrés qu\'après avoir appuyé sur « Enregistrer ».';

  @override
  String posN(int n) {
    return 'Pos. $n';
  }

  @override
  String get puntosMayus => 'Points';

  @override
  String get quitarUltimaPosicion => 'Retirer la dernière position';

  @override
  String get anadirPosicion => 'Ajouter une position';

  @override
  String get csvExcel => 'CSV / Excel';

  @override
  String get googleSheets => 'Google Sheets';

  @override
  String get listarHojas => 'Lister les feuilles';

  @override
  String get seleccionaArchivoClasificacion =>
      'Sélectionnez un fichier CSV ou Excel avec le classement. La première ligne doit être l\'en-tête, avec une colonne « Pilote » et une colonne par épreuve.';

  @override
  String archivoNombre(String nombre) {
    return 'Fichier : $nombre';
  }

  @override
  String get seleccionaHojaClasificacion =>
      'Sélectionnez la feuille Drive contenant le classement.';

  @override
  String hojaNombre(String nombre) {
    return 'Feuille : $nombre';
  }

  @override
  String get pulsaListarHojas =>
      'Appuyez sur « Lister les feuilles » pour commencer.';

  @override
  String pruebasReconocidas(int n) {
    return 'Épreuves reconnues : $n';
  }

  @override
  String noReconocidasCampo(String lista) {
    return 'Non reconnues : $lista';
  }

  @override
  String pilotosOk(int n) {
    return 'Pilotes OK : $n';
  }

  @override
  String pilotosConProblemas(int n) {
    return 'Pilotes à problème : $n';
  }

  @override
  String get conectaGooglePrimero =>
      'Connectez d\'abord votre compte Google dans Réglages → Google.';

  @override
  String importadosResultados(int registros, int pilotos) {
    return '$registros résultats de $pilotos pilotes importés. Revenez au classement pour le voir mis à jour.';
  }

  @override
  String get estadoOk => 'OK';

  @override
  String get pilotoNoEncontrado => 'Pilote introuvable';

  @override
  String get pilotoSinEquipo => 'Pilote sans équipe dans ce championnat';

  @override
  String get sinPuntosImportables => 'Aucun point importable';

  @override
  String get noEncuentroColumnaPiloto =>
      'Je ne trouve pas la colonne du pilote. La première ligne doit contenir une colonne nommée « Pilote », « Nom » ou « Équipe ».';

  @override
  String get importando => 'Importation…';

  @override
  String get puntosNoValidos =>
      'Une position a une valeur de points non valide.';

  @override
  String get tablaGuardada => 'Table de points enregistrée.';

  @override
  String get reparto => 'Répartition';

  @override
  String get movimiento => 'Mouvement';

  @override
  String get sinCampeonatoActivo => 'Aucun championnat actif';

  @override
  String cuotaPorPruebaTexto(String pagat, String coord, String club) {
    return 'Cotisation par épreuve : $pagat (coordination $coord · club $club)';
  }

  @override
  String get porPrueba => 'Par épreuve';

  @override
  String get repartoDeLaCuota => 'Répartition de la cotisation';

  @override
  String get repartoTexto =>
      'Ce que paie chaque équipe par épreuve et où cela va. Quand vous modifiez la coordination ou le club, l\'autre s\'ajuste pour totaliser le Payé.';

  @override
  String get pagatCuotaTotal => 'Payé (cotisation totale) €';

  @override
  String get coordinadoraEur => 'Coordination €';

  @override
  String get clubEur => 'Club €';

  @override
  String get pagatMayorQueCero => 'Le Payé doit être supérieur à 0.';

  @override
  String get coordClubSumanPagat =>
      'Coordination + club doivent totaliser le Payé.';

  @override
  String get aplicarAPagosCobrados =>
      'Appliquer aussi aux paiements déjà encaissés';

  @override
  String get aplicarAPagosCobradosTexto =>
      'Répartit à nouveau ce qu\'a payé chaque équipe selon la nouvelle proportion. L\'encaissé ne change pas.';

  @override
  String repartoGuardadoRecalculado(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n paiements recalculés.',
      one: '1 paiement recalculé.',
    );
    return 'Répartition enregistrée. $_temp0';
  }

  @override
  String get repartoGuardado =>
      'Répartition enregistrée. Elle s\'appliquera aux prochains paiements.';

  @override
  String get nuevoMovimiento => 'Nouveau mouvement';

  @override
  String get editarMovimiento => 'Modifier le mouvement';

  @override
  String get ingreso => 'Recette';

  @override
  String get gasto => 'Dépense';

  @override
  String get conceptoObligatorio => 'Libellé *';

  @override
  String get conceptoEjemplo => 'Ex. : Sponsoring, Matériel, Prix…';

  @override
  String get importeObligatorio => 'Montant (€) *';

  @override
  String get importeAyuda => 'Seulement le nombre, sans signe';

  @override
  String get notas => 'Notes';

  @override
  String get movimientosExtras => 'Mouvements divers';

  @override
  String get ingresosYGastosSueltos => '(recettes et dépenses ponctuelles)';

  @override
  String get sinMovimientosTexto =>
      'Aucun mouvement. Utilisez le bouton « + Mouvement » pour ajouter des sponsorings, des frais de matériel, etc.';

  @override
  String get balanceCampeonato => 'Solde du championnat';

  @override
  String get masIngresos => '+ Recettes';

  @override
  String get menosGastos => '− Dépenses';

  @override
  String get coordAbrev => 'Coord.';

  @override
  String get tesoreriaDeLaPrueba => 'Trésorerie de l\'épreuve';

  @override
  String get buscarPilotoOEquipo => 'Rechercher un pilote ou une équipe…';

  @override
  String get borrar => 'Effacer';

  @override
  String get sinEquiposInscritos => 'Aucune équipe inscrite';

  @override
  String get recaudadoEnPrueba => 'Encaissé lors de l\'épreuve';

  @override
  String pagadosDe(int pagados, int total) {
    return '$pagados / $total payés';
  }

  @override
  String exentosNoPagan(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n exempts',
      one: '1 exempt',
    );
    return '$_temp0 ne paient pas';
  }

  @override
  String nadieCoincide(String filtro) {
    return 'Personne ne correspond à « $filtro ».';
  }

  @override
  String get exencionWildcard => 'Wildcard';

  @override
  String get exencionCoordinadora => 'Pilotes coordinateurs';

  @override
  String pagaMitad(String piloto) {
    return 'Paie la moitié — $piloto est coordinateur';
  }

  @override
  String get revisionCategorias => 'Révision des catégories (clôture)';

  @override
  String get aplicarBonificacion => 'Appliquer la bonification de clôture';

  @override
  String get aunNoHayPilotosInscritos =>
      'Aucun pilote inscrit dans ce championnat pour l\'instant.';

  @override
  String get bonificacionCierre => 'Bonification de clôture';

  @override
  String bonificacionCierreTexto(String tope) {
    return 'Le solde de chaque pilote ayant couru sera régularisé :\n\nsolde = min(solde actuel + bonification selon la catégorie et le nombre de courses, $tope).\n\nElle ne s\'applique qu\'à ceux qui ne l\'ont pas encore. Continuer ?';
  }

  @override
  String bonificacionAplicada(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pilotes',
      one: '1 pilote',
    );
    return 'Bonification appliquée à $_temp0.';
  }

  @override
  String inicialUsados(int inicial, int usados) {
    return 'Initial $inicial  ·  Utilisés $usados';
  }

  @override
  String ajustarCreditos(String piloto) {
    return 'Ajuster les crédits · $piloto';
  }

  @override
  String get creditosActualesSaldo => 'Crédits actuels (solde)';

  @override
  String get creditosAjustados => 'Crédits ajustés';

  @override
  String get ajustarCreditosMano => 'Ajuster les crédits à la main';

  @override
  String get usados => 'Utilisés';

  @override
  String get saldoMayus => 'SOLDE';

  @override
  String get movimientos => 'Mouvements';

  @override
  String get inscripcionAlCampeonato => 'Inscription au championnat';

  @override
  String get sinMovimientosTodavia => 'Aucun mouvement pour l\'instant.';

  @override
  String huecoSinJustificar(int n) {
    return '$n créd. non justifiés';
  }

  @override
  String descuadreSaldo(String actual, String inicial, String suma) {
    return 'Le solde actuel ($actual) ne correspond pas à initial $inicial $suma mouvements. Il venait probablement ainsi de l\'importation ou a été modifié à la main avant l\'activation du journal.';
  }

  @override
  String get estadoPromociona => 'Monte';

  @override
  String get estadoDesciende => 'Descend';

  @override
  String get estadoSeMantiene => 'Se maintient';

  @override
  String get bajar => 'Descendre';

  @override
  String get mantener => 'Maintenir';

  @override
  String get subir => 'Monter';

  @override
  String get noHayPilotosCompetido =>
      'Aucun pilote n\'a couru dans ce championnat.';

  @override
  String get revisionTexto =>
      'Ajustez la catégorie de chaque pilote avant de terminer. Elle servira à la bonification de clôture et comme catégorie initiale du prochain championnat.';

  @override
  String get motivoAjusteCreditos => 'Ajustement manuel (crédits)';

  @override
  String get verificarEnEquipoWifi => 'Vérifier en équipe (wifi)';

  @override
  String verificarEnEquipoN(int n) {
    return 'Vérifier en équipe · $n';
  }

  @override
  String verificarEnEquipoNConectados(int n) {
    return 'Vérifier en équipe · $n connectés';
  }

  @override
  String get syncIntroTexto =>
      'Plusieurs Controls peuvent travailler sur cette épreuve en même temps. Chacun enregistre sur son appareil et les changements circulent par wifi : vérifications avec leurs photos, coupe et encaissements, ainsi que les nouvelles fiches (pilotes, équipes, leur catégorie dans le championnat et inscrits à l\'épreuve, et leurs retraits), les séries avec leurs voies et les résultats.\n\n• Tous sur le même wifi. Pas besoin d\'internet : un routeur hors ligne ou le partage de connexion d\'un téléphone suffit.\n• La première fois, partez tous de la même copie de données. Les catalogues et la configuration du championnat ne voyagent pas encore.\n• La même clé d\'événement partout, et l\'heure automatique activée : si deux personnes touchent la même chose, le dernier changement gagne.';

  @override
  String get nombreDeEsteControl => 'Nom de ce Control';

  @override
  String get nombreControlAyuda =>
      'Différent sur chaque appareil (p. ex. « Table 1 »).';

  @override
  String get claveDelEvento => 'Clé de l\'événement';

  @override
  String get claveEventoAyuda => 'La même sur tous les Controls.';

  @override
  String get conectarConOtros => 'Se connecter à d\'autres Controls';

  @override
  String visibleComo(String nombre) {
    return 'Visible comme « $nombre »';
  }

  @override
  String get conectando => 'Connexion…';

  @override
  String get apagado => 'Éteint';

  @override
  String get controlsEnLaRed => 'Controls sur le réseau';

  @override
  String get anadirPorDireccion => 'Ajouter par adresse';

  @override
  String get anadirControlPorDireccion => 'Ajouter un Control par adresse';

  @override
  String get ipOPuerto => 'IP (ou IP:port)';

  @override
  String get ipAyuda => 'Vous la voyez sur ce même écran de l\'autre Control.';

  @override
  String get buscandoOtrosControls =>
      'Recherche d\'autres Controls sur le wifi…';

  @override
  String get noSeEncuentraControl =>
      'Aucun Control trouvé. Vérifiez que les autres ont cet écran avec « Connecter » activé et sont sur le même wifi, ou ajoutez-les par leur adresse.';

  @override
  String dosControlsMismoNombre(String nombre) {
    return 'Un autre Control s\'appelle aussi « $nombre ». Changez le nom de l\'un des deux.';
  }

  @override
  String claveNoCoincide(String host) {
    return '$host · la clé de l\'événement ne correspond pas';
  }

  @override
  String get quitarDeLaLista => 'Retirer de la liste';

  @override
  String get sincronizarAutomaticamente => 'Synchroniser automatiquement';

  @override
  String cadaNsAppAbierta(int n) {
    return 'Toutes les $n s tant que l\'app est ouverte';
  }

  @override
  String get sincronizando => 'Synchronisation…';

  @override
  String get sincronizarAhora => 'Synchroniser maintenant';

  @override
  String ultimaSincronizacion(String hora) {
    return 'Dernière synchronisation : $hora';
  }

  @override
  String get syncSinCambios => 'Aucun changement';

  @override
  String nEquipos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n équipes',
      one: '1 équipe',
    );
    return '$_temp0';
  }

  @override
  String nPerfiles(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n profils',
      one: '1 profil',
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
      other: '$n séries',
      one: '1 série',
    );
    return '$_temp0';
  }

  @override
  String resultadosDeNTandas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n séries',
      one: '1 série',
    );
    return 'résultats de $_temp0';
  }

  @override
  String nBajas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n retraits',
      one: '1 retrait',
    );
    return '$_temp0';
  }

  @override
  String nVerifNuevas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n nouvelles vérifications',
      one: '1 nouvelle vérification',
    );
    return '$_temp0';
  }

  @override
  String nVerifActualizadas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n mises à jour',
      one: '1 mise à jour',
    );
    return '$_temp0';
  }

  @override
  String nVerifBorradas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n supprimées',
      one: '1 supprimée',
    );
    return '$_temp0';
  }

  @override
  String nCopas(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n coupes',
      one: '1 coupe',
    );
    return '$_temp0';
  }

  @override
  String nCobros(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n encaissements',
      one: '1 encaissement',
    );
    return '$_temp0';
  }

  @override
  String get syncSinClave => 'Saisissez une clé d\'événement.';

  @override
  String syncNoSePudoAbrir(String detalle) {
    return 'Impossible d\'ouvrir la connexion : $detalle';
  }

  @override
  String get syncFormatoDesconocido => 'Format de synchronisation inconnu.';

  @override
  String get syncOtraVersion =>
      'L\'autre Control a une autre version de PitWall Control. Mettez tout le monde à jour avec la même version.';

  @override
  String syncVerifNoExiste(String equipo, String manga) {
    return 'Vérification de « $equipo » dans « $manga » : cette série ou cette équipe n\'existe pas ici.';
  }

  @override
  String syncCocheNoCatalogo(String equipo, String coche) {
    return '$equipo : la voiture « $coche » n\'est pas dans le catalogue de ce Control.';
  }

  @override
  String syncTandaFaltaEquipo(String tanda) {
    return 'Série « $tanda » : une équipe manque ici ; sa voie reste vide.';
  }

  @override
  String syncResultFaltaPiloto(String tanda) {
    return 'Résultats de « $tanda » : un pilote ou une équipe manque ici ; cette ligne n\'est pas copiée.';
  }

  @override
  String syncEquipoFaltanPilotos(String equipo) {
    return 'Équipe « $equipo » : certains de ses pilotes manquent ici ; elle n\'est pas copiée.';
  }

  @override
  String get syncSinRespuesta => 'Ne répond pas (toujours sur le même wifi ?).';

  @override
  String get syncSinConexion =>
      'Connexion impossible (toujours sur le même wifi ?).';

  @override
  String get syncControlAnadido => 'Control ajouté.';

  @override
  String syncNoHayControlEn(String dir) {
    return 'Aucun Control connecté à $dir.';
  }

  @override
  String get primeroInscribeEquipos =>
      'Inscrivez d\'abord des équipes à l\'épreuve.';

  @override
  String get sinCoincidenciasPunto => 'Aucune correspondance.';

  @override
  String get ajusteManualHistorial =>
      'Le changement de solde est noté comme « Ajustement manuel » dans l\'historique.';

  @override
  String bonifTope(int bonif, int tope) {
    return '+$bonif, limité au plafond $tope';
  }

  @override
  String desfaseHora(int min) {
    return 'L\'heure de l\'autre Control s\'écarte de $min min de celle de cet appareil. Activez l\'heure automatique partout.';
  }

  @override
  String nCarreras(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n courses',
      one: '1 course',
    );
    return '$_temp0';
  }

  @override
  String bonifMotivo(String carreras, String categoria, int bonif) {
    return 'Bonification de clôture pour $carreras ($categoria) : +$bonif';
  }

  @override
  String bonifLimiteTope(int tope) {
    return ', limité au plafond $tope';
  }
}
