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

// Aviso de versión nueva: lógica pura, sin Flutter ni red. La web publica
// `version.json` junto al APK y a los instaladores de escritorio; la app lo
// compara con su propia versión (`servicio_actualizacion.dart` hace la parte
// de red). Mismo criterio que PitWall Lap.

/// Lo que publica la web en `software/pitwall-control/version.json`.
class ManifiestoVersion {
  const ManifiestoVersion({
    required this.version,
    required this.apk,
    this.bytes,
    this.notas,
    this.descargas = const {},
  });

  /// Versión publicada (x.y.z).
  final String version;

  /// Fichero del APK; si es relativo, cuelga de la carpeta del manifiesto.
  final String apk;

  /// Tamaño esperado del APK, para detectar una descarga cortada.
  final int? bytes;

  /// Qué trae la versión, en una línea (opcional).
  final String? notas;

  /// Instaladores de escritorio de ESTA versión: `macos` | `windows` | `linux`
  /// (y `linux-deb`, informativa) → fichero. Si una plataforma no está, la app
  /// de escritorio no avisa: no se ofrece lo que aún no se puede descargar.
  final Map<String, String> descargas;
}

/// Nombre del APK cuando el manifiesto no lo dice.
const String apkPorDefecto = 'PitWallControl.apk';

/// Plataformas de escritorio que la app reconoce en `descargas`.
const List<String> plataformasEscritorio = ['macos', 'windows', 'linux'];

/// Compara dos versiones x.y.z: <0 si `a` es anterior, 0 si iguales, >0 si es
/// posterior. Tolera versiones incompletas o con sufijo (`1.8`, `1.8.1-beta`).
int compararVersiones(String a, String b) {
  List<int> partes(String v) {
    final trozos = v.split(RegExp(r'[.+-]')).take(3).map((p) => int.tryParse(p) ?? 0).toList();
    while (trozos.length < 3) {
      trozos.add(0);
    }
    return trozos;
  }

  final pa = partes(a);
  final pb = partes(b);
  for (var i = 0; i < 3; i++) {
    final d = pa[i] - pb[i];
    if (d != 0) return d;
  }
  return 0;
}

/// Valida lo que llega de la web; null si no tiene la forma esperada.
ManifiestoVersion? leerManifiesto(Object? crudo) {
  if (crudo is! Map) return null;
  final version = crudo['version'];
  if (version is! String || !RegExp(r'^\d+\.\d+\.\d+').hasMatch(version)) return null;

  final apkCrudo = crudo['apk'];
  final apk = apkCrudo is String && apkCrudo.trim().isNotEmpty ? apkCrudo.trim() : apkPorDefecto;

  final bytesCrudo = crudo['bytes'];
  final bytes = bytesCrudo is num && bytesCrudo > 0 ? bytesCrudo.toInt() : null;

  final notasCrudo = crudo['notas'];
  final notas = notasCrudo is String && notasCrudo.trim().isNotEmpty ? notasCrudo.trim() : null;

  final descargas = <String, String>{};
  final descargasCrudo = crudo['descargas'];
  if (descargasCrudo is Map) {
    for (final entrada in descargasCrudo.entries) {
      final clave = entrada.key;
      final valor = entrada.value;
      if (clave is String && valor is String && valor.trim().isNotEmpty) {
        descargas[clave] = valor.trim();
      }
    }
  }

  return ManifiestoVersion(
    version: version,
    apk: apk,
    bytes: bytes,
    notas: notas,
    descargas: descargas,
  );
}

/// ¿Hay una versión posterior a la instalada?
bool hayVersionNueva(String actual, ManifiestoVersion? manifiesto) {
  return manifiesto != null && compararVersiones(manifiesto.version, actual) > 0;
}

/// URL absoluta de un fichero que cuelga de la carpeta del manifiesto. Con
/// `conVersion` añade `?v=` (para saltar la caché de Cloudflare en el APK).
String urlDeFichero(String carpeta, String ruta, {String? conVersion}) {
  if (RegExp('^https?://', caseSensitive: false).hasMatch(ruta)) return ruta;
  final base = carpeta.replaceAll(RegExp(r'/+$'), '');
  final url = '$base/${ruta.replaceAll(RegExp(r'^/+'), '')}';
  return conVersion == null ? url : '$url?v=${Uri.encodeComponent(conVersion)}';
}

/// URL absoluta del APK a partir de la carpeta donde está el manifiesto.
String urlDelApk(String carpeta, ManifiestoVersion manifiesto) {
  return urlDeFichero(carpeta, manifiesto.apk, conVersion: manifiesto.version);
}

/// URL del instalador de escritorio de `plataforma`, o null si el manifiesto
/// no lo publica (sin `?v=`: rompería el nombre del fichero descargado).
String? urlDeDescarga(String carpeta, ManifiestoVersion manifiesto, String plataforma) {
  final ruta = manifiesto.descargas[plataforma];
  if (ruta == null) return null;
  return urlDeFichero(carpeta, ruta);
}

/// Mínimo entre dos comprobaciones automáticas al volver a la app (6 horas).
const Duration intervaloComprobacion = Duration(hours: 6);

/// ¿Toca volver a preguntar a la web? `ultima` = última comprobación (null =
/// nunca). Si el reloj del equipo va hacia atrás, también se comprueba.
bool debeComprobar(DateTime? ultima, DateTime ahora, {Duration intervalo = intervaloComprobacion}) {
  if (ultima == null) return true;
  return ahora.difference(ultima) >= intervalo || ahora.isBefore(ultima);
}

/// Una descarga sin ningún avance durante tanto tiempo se da por atascada (30 s).
const Duration limiteSinAvance = Duration(seconds: 30);

/// Tiempo máximo de toda la descarga (10 minutos).
const Duration limiteDescarga = Duration(minutes: 10);

/// ¿La descarga lleva demasiado tiempo sin recibir nada?
bool estaAtascada(DateTime ultimoAvance, DateTime ahora, {Duration limite = limiteSinAvance}) {
  return ahora.difference(ultimoAvance) >= limite;
}

/// Porcentaje entero 0–100; null si el servidor no dijo el tamaño total.
int? porcentaje(int escritos, int? total) {
  if (total == null || total <= 0 || escritos < 0) return null;
  final pct = escritos * 100 ~/ total;
  return pct > 100 ? 100 : pct;
}
