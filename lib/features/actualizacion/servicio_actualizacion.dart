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

// Red y acciones del aviso de versión nueva: pregunta a la web si hay una
// versión posterior a la instalada y, en Android, descarga el APK y abre el
// instalador del sistema (en escritorio se abre el navegador en el instalador
// de esa plataforma). Mismo comportamiento que PitWall Lap.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'actualizacion.dart';

/// Carpeta de la web donde están el APK, su `version.json` y los instaladores
/// de escritorio. `PITWALL_WEB` permite apuntar a un servidor de pruebas.
const String carpetaWeb = String.fromEnvironment(
  'PITWALL_WEB',
  defaultValue: 'https://www.pitwall.es/software/pitwall-control/',
);

/// Límite para toda la petición del manifiesto (y para las cabeceras del APK).
const Duration esperaComprobacion = Duration(seconds: 6);

/// Un APK de Control pesa decenas de MB: menos de esto es una descarga rota o
/// una página de error.
const int bytesMinimosApk = 5 * 1000 * 1000;

/// Canal con `MainActivity.kt` para abrir el instalador de Android.
const String canalActualizacion = 'pitwall/actualizacion';

/// Una versión publicada que la app puede ofrecer.
class Actualizacion {
  const Actualizacion({
    required this.version,
    required this.url,
    this.notas,
    this.bytes,
    this.esApk = true,
  });

  final String version;

  /// Qué trae la versión, en una línea (opcional).
  final String? notas;

  /// URL del APK (Android) o del instalador de escritorio.
  final String url;

  /// Tamaño esperado del APK; solo en Android.
  final int? bytes;

  /// true = APK (se descarga e instala); false = instalador de escritorio (se
  /// abre el navegador).
  final bool esApk;
}

/// Resultado de preguntar a la web.
enum EstadoBusqueda {
  /// Hay una versión posterior.
  nueva,

  /// La instalada es la última.
  alDia,

  /// Sin red, la web no respondió a tiempo o lo recibido no era el manifiesto.
  error,
}

class ResultadoBusqueda {
  const ResultadoBusqueda(this.estado, [this.actualizacion]);

  final EstadoBusqueda estado;
  final Actualizacion? actualizacion;
}

/// Por qué falló una descarga (cada motivo tiene su mensaje en la tarjeta).
enum MotivoFallo { cancelada, atascada, apkIncompleto, otro }

class FalloDescarga implements Exception {
  const FalloDescarga(this.motivo);

  final MotivoFallo motivo;

  @override
  String toString() => 'FalloDescarga($motivo)';
}

/// Descarga en marcha: `promesa` termina cuando el instalador está abierto (o
/// el navegador, en escritorio) y rechaza con [FalloDescarga]; `cancelar` la
/// corta (rechaza con `cancelada`).
class Descarga {
  const Descarga(this.promesa, this.cancelar);

  final Future<void> promesa;
  final void Function() cancelar;
}

/// `macos` | `windows` | `linux` en escritorio; null en Android (y en iOS,
/// que no es objetivo de la app).
String? plataformaEscritorio() {
  if (Platform.isMacOS) return 'macos';
  if (Platform.isWindows) return 'windows';
  if (Platform.isLinux) return 'linux';
  return null;
}

/// Versión instalada: `versionName` del APK, `CFBundleShortVersionString` en
/// macOS, o la del `pubspec.yaml` embebida en el bundle en Linux.
Future<String> versionInstalada() async {
  final info = await PackageInfo.fromPlatform();
  return info.version;
}

/// Pregunta a la web (con un límite de 6 s para la petición). Nunca lanza.
Future<ResultadoBusqueda> comprobarActualizacion(
  String versionActual, {
  http.Client? cliente,
}) async {
  final c = cliente ?? http.Client();
  try {
    final uri = Uri.parse(
      '${carpetaWeb}version.json?t=${DateTime.now().millisecondsSinceEpoch}',
    );
    final res = await c
        .get(uri, headers: {'Cache-Control': 'no-cache'})
        .timeout(esperaComprobacion);
    if (res.statusCode != 200) return const ResultadoBusqueda(EstadoBusqueda.error);
    final manifiesto = leerManifiesto(jsonDecode(res.body));
    if (manifiesto == null) return const ResultadoBusqueda(EstadoBusqueda.error);
    if (!hayVersionNueva(versionActual, manifiesto)) {
      return const ResultadoBusqueda(EstadoBusqueda.alDia);
    }

    final plataforma = plataformaEscritorio();
    if (plataforma != null) {
      final url = urlDeDescarga(carpetaWeb, manifiesto, plataforma);
      // Hay versión nueva, pero esta plataforma aún no tiene instalador
      // publicado: no se avisa de algo que no se puede descargar.
      if (url == null) return const ResultadoBusqueda(EstadoBusqueda.alDia);
      return ResultadoBusqueda(
        EstadoBusqueda.nueva,
        Actualizacion(version: manifiesto.version, notas: manifiesto.notas, url: url, esApk: false),
      );
    }

    return ResultadoBusqueda(
      EstadoBusqueda.nueva,
      Actualizacion(
        version: manifiesto.version,
        notas: manifiesto.notas,
        url: urlDelApk(carpetaWeb, manifiesto),
        bytes: manifiesto.bytes,
      ),
    );
  } catch (_) {
    return const ResultadoBusqueda(EstadoBusqueda.error);
  } finally {
    if (cliente == null) c.close();
  }
}

/// Descarga el APK y abre el instalador de Android. En escritorio (o si lo que
/// hay que abrir no es un APK) abre el navegador y ya está. La primera vez
/// Android pide permitir a la app «instalar apps desconocidas»; tras
/// concederlo, hay que volver a pulsar Actualizar. Se puede cancelar, y se
/// corta sola si pasan 30 s sin recibir nada o 10 min en total. `alProgreso`
/// recibe 0–100 (null si no se conoce el tamaño).
Descarga iniciarDescarga(Actualizacion actualizacion, void Function(int? pct) alProgreso) {
  if (!actualizacion.esApk || !Platform.isAndroid) {
    return Descarga(_abrir(actualizacion, ''), () {});
  }

  final cliente = http.Client();
  final inicio = DateTime.now();
  var ultimoAvance = inicio;
  var escritos = 0;
  MotivoFallo? motivo;
  Timer? vigilante;
  IOSink? salida;

  void cortar(MotivoFallo porQue) {
    if (motivo == null) {
      motivo = porQue;
      cliente.close();
    }
  }

  final promesa = () async {
    try {
      final carpeta = await getTemporaryDirectory();
      final fichero = File('${carpeta.path}/PitWallControl-actualizacion.apk');
      if (await fichero.exists()) await fichero.delete();

      vigilante = Timer.periodic(const Duration(seconds: 5), (_) {
        final ahora = DateTime.now();
        if (estaAtascada(ultimoAvance, ahora) || ahora.difference(inicio) > limiteDescarga) {
          cortar(MotivoFallo.atascada);
        }
      });

      final peticion = http.Request('GET', Uri.parse(actualizacion.url));
      final respuesta = await cliente.send(peticion).timeout(esperaComprobacion);
      if (respuesta.statusCode != 200) throw const FalloDescarga(MotivoFallo.otro);

      final total = respuesta.contentLength ?? actualizacion.bytes;
      final salidaLocal = fichero.openWrite();
      salida = salidaLocal;
      await for (final trozo in respuesta.stream) {
        ultimoAvance = DateTime.now();
        escritos += trozo.length;
        salidaLocal.add(trozo);
        alProgreso(porcentaje(escritos, total));
      }
      await salidaLocal.flush();
      await salidaLocal.close();
      salida = null;

      // Primero el motivo (cancelar o atasco); si no, la descarga cortada se
      // reportaría como incompleta.
      if (motivo != null) throw FalloDescarga(motivo!);

      final tamano = await fichero.length();
      if (tamano < bytesMinimosApk ||
          (actualizacion.bytes != null && tamano != actualizacion.bytes)) {
        throw const FalloDescarga(MotivoFallo.apkIncompleto);
      }

      await _abrir(actualizacion, fichero.path);
    } catch (e) {
      // Si la descarga se cortó por red, el error llega sin motivo: se trata
      // como fallo genérico.
      if (motivo != null) throw FalloDescarga(motivo!);
      if (e is FalloDescarga) rethrow;
      throw const FalloDescarga(MotivoFallo.otro);
    } finally {
      vigilante?.cancel();
      await salida?.close();
      cliente.close();
    }
  }();

  return Descarga(promesa, () => cortar(MotivoFallo.cancelada));
}

/// Abre el instalador de Android para el APK descargado y, si no puede (o en
/// escritorio), el navegador en la URL de descarga.
Future<void> _abrir(Actualizacion actualizacion, String ruta) async {
  if (actualizacion.esApk && Platform.isAndroid) {
    try {
      final abierto = await const MethodChannel(canalActualizacion)
          .invokeMethod<bool>('instalarApk', {'ruta': ruta});
      if (abierto ?? false) return;
    } on PlatformException {
      // Sin canal (u otro fallo): lo abre el navegador, que sí sabe instalar.
    } on MissingPluginException {
      // Igual que arriba.
    }
  }

  var lanzado = false;
  try {
    lanzado = await launchUrl(Uri.parse(actualizacion.url), mode: LaunchMode.externalApplication);
  } catch (_) {
    lanzado = false;
  }
  if (!lanzado) throw const FalloDescarga(MotivoFallo.otro);
}
