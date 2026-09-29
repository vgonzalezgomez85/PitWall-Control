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
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;

import 'fotos_verificacion.dart';
import 'google_auth_service.dart';

/// Fotos de coche del catálogo sincronizadas con Google Drive.
///
/// En la hoja de coches, la columna FOTO lleva el enlace de Drive de la
/// imagen. La foto local se guarda como `coche-drive-<idDrive>.jpg`: así el
/// nombre del archivo ya dice de qué archivo de Drive viene (no hace falta
/// guardar el enlace aparte) y solo se descarga de nuevo si cambia.
class FotosCochesDrive {
  FotosCochesDrive(this.ref);
  final Ref ref;

  static const _prefijo = 'coche-drive-';
  static const _carpetaDrive = 'PitWall Control - Fotos coches';
  static const _ladoMax = 1600;

  /// Id de archivo de Drive de un enlace (`/file/d/<id>/…`, `?id=<id>`,
  /// `/d/<id>`). Null si no es un enlace de Drive.
  static String? idDeEnlace(String? enlace) {
    final t = (enlace ?? '').trim();
    if (t.isEmpty) return null;
    for (final re in [
      RegExp(r'/file/d/([\w-]{10,})'),
      RegExp(r'[?&]id=([\w-]{10,})'),
      RegExp(r'/d/([\w-]{10,})'),
    ]) {
      final m = re.firstMatch(t);
      if (m != null) return m.group(1);
    }
    return null;
  }

  /// Id de Drive del que viene una foto local (null si se subió a mano en
  /// la app y aún no está en Drive).
  static String? idDeFotoLocal(String? fotoPath) {
    if (fotoPath == null) return null;
    final nombre = p.basenameWithoutExtension(fotoPath);
    return nombre.startsWith(_prefijo) ? nombre.substring(_prefijo.length) : null;
  }

  static String enlace(String idDrive) =>
      'https://drive.google.com/file/d/$idDrive/view';

  /// Ejecuta [fn] con un cliente de Drive autenticado (uno para toda la
  /// tanda de fotos).
  Future<T> conDrive<T>(Future<T> Function(drive.DriveApi api) fn) async {
    final cli = await ref
        .read(googleAuthServiceProvider)
        .clienteAutenticado()
        .timeout(const Duration(seconds: 30));
    try {
      return await fn(drive.DriveApi(cli));
    } finally {
      cli.close();
    }
  }

  /// Descarga la imagen [idDrive] a la carpeta de fotos (reducida a JPEG de
  /// 1600 px como máximo) y devuelve el nombre de archivo para la BD.
  Future<String> descargar(drive.DriveApi api, String idDrive) async {
    final media = await api.files
        .get(idDrive,
            downloadOptions: drive.DownloadOptions.fullMedia,
            supportsAllDrives: true)
        .timeout(const Duration(seconds: 60)) as drive.Media;
    final builder = BytesBuilder(copy: false);
    await for (final chunk in media.stream.timeout(const Duration(seconds: 60))) {
      builder.add(chunk);
    }
    final jpg = await Isolate.run(() => _aJpeg(builder.takeBytes()));
    if (jpg == null) {
      throw Exception('el archivo no es una imagen JPG/PNG/WEBP legible');
    }
    final nombre = '$_prefijo$idDrive.jpg';
    final dir = await FotosVerificacion.carpeta();
    await File(p.join(dir.path, nombre)).writeAsBytes(jpg);
    return nombre;
  }

  /// Sube la foto local [fotoPath] a la carpeta de fotos de coches en Drive
  /// y devuelve el id del archivo creado.
  Future<String> subir(
      drive.DriveApi api, String fotoPath, String nombreCoche) async {
    final archivo = await FotosVerificacion.resolver(fotoPath);
    if (!await archivo.exists()) {
      throw Exception('no se encuentra la foto local $fotoPath');
    }
    final carpetaId = await _carpeta(api);
    final bytes = await archivo.readAsBytes();
    final ext = p.extension(fotoPath).toLowerCase();
    final creado = await api.files.create(
      drive.File()
        ..name = '$nombreCoche$ext'
        ..parents = [carpetaId],
      uploadMedia: drive.Media(Stream.value(bytes), bytes.length,
          contentType: ext == '.png' ? 'image/png' : 'image/jpeg'),
      $fields: 'id',
    );
    return creado.id!;
  }

  /// Renombra la foto local subida a `coche-drive-<id>` para que la próxima
  /// sincronización la reconozca. Devuelve el nombre nuevo.
  Future<String> renombrarLocal(String fotoPath, String idDrive) async {
    final origen = await FotosVerificacion.resolver(fotoPath);
    final nombre = '$_prefijo$idDrive${p.extension(fotoPath).toLowerCase()}';
    await origen.rename(p.join(origen.parent.path, nombre));
    return nombre;
  }

  /// Carpeta de Drive para las fotos (la crea si no existe). Con el permiso
  /// drive.file solo se ven las carpetas creadas por la propia app.
  Future<String> _carpeta(drive.DriveApi api) async {
    final res = await api.files.list(
      q: "name='$_carpetaDrive' and "
          "mimeType='application/vnd.google-apps.folder' and trashed=false",
      $fields: 'files(id)',
      spaces: 'drive',
    );
    final existente = res.files?.firstOrNull?.id;
    if (existente != null) return existente;
    final creada = await api.files.create(
      drive.File()
        ..name = _carpetaDrive
        ..mimeType = 'application/vnd.google-apps.folder',
      $fields: 'id',
    );
    return creada.id!;
  }

  static Uint8List? _aJpeg(Uint8List bytes) {
    final original = img.decodeImage(bytes);
    if (original == null) return null;
    // Las fotos de móvil guardan el giro en EXIF: se aplica antes de reducir.
    final imagen = img.bakeOrientation(original);
    final lado = imagen.width > imagen.height ? imagen.width : imagen.height;
    final reducida = lado <= _ladoMax
        ? imagen
        : img.copyResize(imagen,
            width: imagen.width >= imagen.height ? _ladoMax : null,
            height: imagen.height > imagen.width ? _ladoMax : null);
    return img.encodeJpg(reducida, quality: 80);
  }
}

final fotosCochesDriveProvider =
    Provider<FotosCochesDrive>((ref) => FotosCochesDrive(ref));
