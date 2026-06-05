import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../core/proveedores.dart';
import 'fotos_verificacion.dart';
import 'google_auth_service.dart';

/// Información del backup actualmente en Drive.
class BackupInfo {
  final String id;
  final String nombre;
  final DateTime? modificado;
  final int? tamano;
  BackupInfo({
    required this.id,
    required this.nombre,
    this.modificado,
    this.tamano,
  });
}

/// Resultado de una operación de backup.
class ResultadoBackup {
  final bool ok;
  final String mensaje;
  ResultadoBackup({required this.ok, required this.mensaje});
}

class DriveBackupService {
  DriveBackupService(this.ref);
  final Ref ref;

  /// Nombre del backup actual (ZIP con BD + fotos).
  static const _nombreArchivo = 'pitwall-backup.zip';
  /// Nombres antiguos que aún se buscan al restaurar (compatibilidad).
  static const _legacyZip = 'resisbarna-backup.zip';
  static const _legacyDb = 'resisbarna-backup.db';

  /// Path del archivo SQLite local que usa drift_flutter.
  Future<File> _archivoBdLocal() async {
    final docs = await getApplicationDocumentsDirectory();
    return File(p.join(docs.path, 'pitwall.sqlite'));
  }

  /// Busca el backup existente en Drive (si lo hay). Prefiere el .zip nuevo;
  /// si no existe, devuelve el .db antiguo para que se pueda restaurar.
  Future<BackupInfo?> obtenerBackup() async {
    final auth = ref.read(googleAuthServiceProvider);
    final cli = await auth.clienteAutenticado();
    try {
      final api = drive.DriveApi(cli);
      final res = await api.files.list(
        q: "(name='$_nombreArchivo' or name='$_legacyZip' or name='$_legacyDb') and trashed=false",
        pageSize: 10,
        orderBy: 'modifiedTime desc',
        $fields: 'files(id,name,modifiedTime,size)',
        spaces: 'drive',
      );
      final files = res.files ?? [];
      if (files.isEmpty) return null;
      // Preferimos pitwall-backup.zip → resisbarna-backup.zip → .db legacy.
      drive.File? pick(String name) {
        for (final x in files) {
          if (x.name == name) return x;
        }
        return null;
      }
      final f = pick(_nombreArchivo) ??
          pick(_legacyZip) ??
          pick(_legacyDb) ??
          files.first;
      return BackupInfo(
        id: f.id!,
        nombre: f.name ?? _nombreArchivo,
        modificado: f.modifiedTime,
        tamano: int.tryParse(f.size ?? '0'),
      );
    } finally {
      cli.close();
    }
  }

  /// Hace VACUUM INTO un archivo temporal, lo empaqueta junto con la carpeta
  /// de fotos en un ZIP y lo sube a Drive (crea o reemplaza el archivo).
  Future<ResultadoBackup> subir() async {
    try {
      final db = ref.read(dbProvider);
      final tmpDir = await getTemporaryDirectory();
      if (!await tmpDir.exists()) {
        await tmpDir.create(recursive: true);
      }
      final ts = DateTime.now().millisecondsSinceEpoch;
      final snapPath = p.join(tmpDir.path, 'resisbarna-snapshot-$ts.db');
      final snap = File(snapPath);
      if (await snap.exists()) await snap.delete();

      // Snapshot consistente con la BD abierta.
      await db.customStatement("VACUUM INTO ?", [snapPath]);

      // Construir ZIP: db + fotos
      final archive = Archive();
      final dbBytes = await snap.readAsBytes();
      archive.addFile(ArchiveFile('pitwall.sqlite', dbBytes.length, dbBytes));

      int numFotos = 0;
      final dirFotos = await FotosVerificacion.carpeta();
      if (await dirFotos.exists()) {
        await for (final ent in dirFotos.list()) {
          if (ent is! File) continue;
          final bytes = await ent.readAsBytes();
          archive.addFile(ArchiveFile(
              'fotos/${p.basename(ent.path)}', bytes.length, bytes));
          numFotos++;
        }
      }

      final zipped = Uint8List.fromList(ZipEncoder().encode(archive) ?? []);
      final stream = Stream<List<int>>.fromIterable([zipped]);

      final auth = ref.read(googleAuthServiceProvider);
      final cli = await auth
          .clienteAutenticado()
          .timeout(const Duration(seconds: 30));
      try {
        final api = drive.DriveApi(cli);
        final existente = await obtenerBackup();
        final media = drive.Media(stream, zipped.length);
        if (existente == null || existente.nombre != _nombreArchivo) {
          // No hay un backup con el nombre actual: creamos uno (los legacy
          // se quedan donde estaban).
          await api.files.create(
            drive.File()
              ..name = _nombreArchivo
              ..description =
                  'Copia de PitWall (BD + fotos de verificaciones).',
            uploadMedia: media,
          );
        } else {
          await api.files.update(
            drive.File()..name = _nombreArchivo,
            existente.id,
            uploadMedia: media,
          );
        }
      } finally {
        cli.close();
      }
      await snap.delete();
      return ResultadoBackup(
          ok: true,
          mensaje:
              'Copia subida (${(zipped.length / 1024).toStringAsFixed(1)} KB · '
              '$numFotos fotos).');
    } catch (e) {
      return ResultadoBackup(ok: false, mensaje: '$e');
    }
  }

  /// Descarga el backup de Drive y reemplaza el archivo local.
  /// Importante: tras restaurar hay que reiniciar la app para que Drift
  /// reabra la conexión sobre el archivo nuevo.
  Future<ResultadoBackup> descargarYRestaurar() async {
    try {
      final info = await obtenerBackup();
      if (info == null) {
        return ResultadoBackup(
          ok: false,
          mensaje: 'No hay copia en Drive.',
        );
      }
      final auth = ref.read(googleAuthServiceProvider);
      final cli = await auth
          .clienteAutenticado()
          .timeout(const Duration(seconds: 30));
      try {
        final api = drive.DriveApi(cli);
        final media = await api.files
            .get(
              info.id,
              downloadOptions: drive.DownloadOptions.fullMedia,
            )
            .timeout(const Duration(seconds: 60)) as drive.Media;

        // Acumular en BytesBuilder (mucho más rápido que List.addAll por chunk).
        final builder = BytesBuilder(copy: false);
        await for (final chunk in media.stream
            .timeout(const Duration(seconds: 60))) {
          builder.add(chunk);
        }
        final bytes = builder.takeBytes();

        // Determinar si es ZIP (backup nuevo) o .db crudo (backup viejo).
        final esZip = info.nombre.toLowerCase().endsWith('.zip') ||
            (bytes.length > 4 &&
                bytes[0] == 0x50 &&
                bytes[1] == 0x4B); // "PK"

        Uint8List dbBytes;
        int numFotos = 0;
        Map<String, Uint8List> fotos = {};
        if (esZip) {
          final archive = ZipDecoder().decodeBytes(bytes);
          ArchiveFile? dbEntry;
          for (final f in archive) {
            if (!f.isFile) continue;
            final nm = f.name;
            if (nm == 'pitwall.sqlite' ||
                nm.endsWith('/pitwall.sqlite') ||
                nm == 'resisbarna.sqlite' ||
                nm.endsWith('/resisbarna.sqlite')) {
              dbEntry = f;
            } else if (nm.startsWith('fotos/')) {
              fotos[p.basename(f.name)] =
                  Uint8List.fromList(f.content as List<int>);
              numFotos++;
            }
          }
          if (dbEntry == null) {
            throw 'El ZIP de backup no contiene la base de datos.';
          }
          dbBytes = Uint8List.fromList(dbEntry.content as List<int>);
        } else {
          dbBytes = bytes;
        }

        // Escribir BD a archivo TEMPORAL primero.
        final local = await _archivoBdLocal();
        final tmpRestore = File('${local.path}.restoring');
        await tmpRestore.writeAsBytes(dbBytes, flush: true);

        // Cerrar la BD para liberar el archivo y reemplazarlo.
        final db = ref.read(dbProvider);
        try {
          await db.close().timeout(const Duration(seconds: 5));
        } catch (_) {}

        if (await local.exists()) await local.delete();
        await tmpRestore.rename(local.path);

        // Volcar fotos a la carpeta local.
        if (fotos.isNotEmpty) {
          final dirFotos = await FotosVerificacion.carpeta();
          for (final e in fotos.entries) {
            await File(p.join(dirFotos.path, e.key))
                .writeAsBytes(e.value, flush: true);
          }
        }

        // Invalidar provider para que se reabra al re-acceder.
        ref.invalidate(dbProvider);

        final extra = numFotos > 0 ? ' · $numFotos fotos' : '';
        return ResultadoBackup(
          ok: true,
          mensaje:
              'Copia restaurada (${(bytes.length / 1024).toStringAsFixed(1)} KB$extra). '
              'Cierra y vuelve a abrir la app para que los cambios surtan efecto.',
        );
      } finally {
        cli.close();
      }
    } catch (e) {
      return ResultadoBackup(ok: false, mensaje: '$e');
    }
  }
}

final driveBackupServiceProvider = Provider<DriveBackupService>((ref) {
  return DriveBackupService(ref);
});

/// Estado en pantalla con info del backup remoto.
final infoBackupProvider = FutureProvider.autoDispose<BackupInfo?>((ref) async {
  return ref.read(driveBackupServiceProvider).obtenerBackup();
});
