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
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import 'exportar_config.dart';

/// Pregunta el idioma de la exportación (recuerda el último usado). Devuelve
/// null si se cancela.
Future<IdiomaExport?> elegirIdiomaExport(
    BuildContext context, WidgetRef ref) async {
  final actual = ref.read(idiomaExportProvider);
  final sel = await showDialog<IdiomaExport>(
    context: context,
    builder: (_) => SimpleDialog(
      title: const Text('Idioma del PDF'),
      children: [
        for (final i in IdiomaExport.values)
          ListTile(
            leading: Icon(i == actual
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked),
            title: Text(i.etiqueta),
            onTap: () => Navigator.pop(context, i),
          ),
      ],
    ),
  );
  if (sel != null) {
    await ref.read(idiomaExportProvider.notifier).set(sel);
  }
  return sel;
}

/// Exporta el PDF generado por [generar].
///
/// - En escritorio: diálogo "guardar como…".
/// - En Android/iOS no existe ese diálogo, así que se abre la hoja de
///   compartir del sistema (guardar en Archivos/Drive, enviar, imprimir…).
///
/// Centraliza el flujo (elegir destino · "Generando…" · guardar · errores)
/// para todas las pantallas con botón de exportar.
Future<void> guardarPdf(
  BuildContext context, {
  required String sugerido,
  required Future<Uint8List> Function() generar,
}) async {
  final messenger = ScaffoldMessenger.of(context);
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      messenger.showSnackBar(const SnackBar(
        content: Text('Generando PDF…'),
        duration: Duration(seconds: 2),
      ));
      final bytes = await generar();
      await Printing.sharePdf(bytes: bytes, filename: sugerido);
      return;
    }

    final destino = await getSaveLocation(
      acceptedTypeGroups: [
        const XTypeGroup(label: 'PDF', extensions: ['pdf']),
      ],
      suggestedName: sugerido,
    );
    if (destino == null) return;

    messenger.showSnackBar(const SnackBar(
      content: Text('Generando PDF…'),
      duration: Duration(seconds: 2),
    ));

    final bytes = await generar();
    var ruta = destino.path;
    if (!ruta.toLowerCase().endsWith('.pdf')) ruta = '$ruta.pdf';
    await File(ruta).writeAsBytes(bytes);

    messenger.showSnackBar(SnackBar(
      content: Text('PDF guardado en $ruta'),
      duration: const Duration(seconds: 3),
    ));
  } catch (e) {
    messenger.showSnackBar(
      SnackBar(content: Text('Error al generar PDF: $e')),
    );
  }
}

/// Guarda un archivo cualquiera (Excel, CSV, JSON…) generado por [generar].
///
/// - En escritorio: diálogo "guardar como…".
/// - En Android/iOS no existe ese diálogo (`getSaveLocation` no está
///   implementado y lanza error), así que se abre la hoja de compartir del
///   sistema para guardarlo en Archivos/Drive, enviarlo, etc.
///
/// Para PDF usar [guardarPdf].
Future<void> guardarArchivo(
  BuildContext context, {
  required String sugerido,
  required String etiqueta,
  required String extension,
  required String mime,
  required Future<List<int>> Function() generar,
}) async {
  final messenger = ScaffoldMessenger.of(context);
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      messenger.showSnackBar(SnackBar(
        content: Text('Generando $etiqueta…'),
        duration: const Duration(seconds: 2),
      ));
      final bytes = await generar();
      final tmp = await getTemporaryDirectory();
      final ruta = p.join(tmp.path, sugerido);
      await File(ruta).writeAsBytes(bytes);
      await SharePlus.instance.share(ShareParams(
        files: [XFile(ruta, mimeType: mime, name: sugerido)],
      ));
      return;
    }

    final destino = await getSaveLocation(
      acceptedTypeGroups: [
        XTypeGroup(label: etiqueta, extensions: [extension]),
      ],
      suggestedName: sugerido,
    );
    if (destino == null) return;

    final bytes = await generar();
    var ruta = destino.path;
    if (!ruta.toLowerCase().endsWith('.$extension')) ruta = '$ruta.$extension';
    await File(ruta).writeAsBytes(bytes);

    messenger.showSnackBar(SnackBar(
      content: Text('$etiqueta guardado en $ruta'),
      duration: const Duration(seconds: 3),
    ));
  } catch (e) {
    messenger.showSnackBar(
      SnackBar(content: Text('Error al exportar $etiqueta: $e')),
    );
  }
}

/// Exporta un Excel (.xlsx). Ver [guardarArchivo].
Future<void> guardarExcel(
  BuildContext context, {
  required String sugerido,
  required Future<List<int>> Function() generar,
}) =>
    guardarArchivo(
      context,
      sugerido: sugerido,
      etiqueta: 'Excel',
      extension: 'xlsx',
      mime:
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      generar: generar,
    );

/// Exporta un CSV en UTF-8 con BOM (para que Excel lea bien los acentos).
/// Ver [guardarArchivo].
Future<void> guardarCsv(
  BuildContext context, {
  required String sugerido,
  required Future<String> Function() generar,
}) =>
    guardarArchivo(
      context,
      sugerido: sugerido,
      etiqueta: 'CSV',
      extension: 'csv',
      mime: 'text/csv',
      generar: () async => utf8.encode('\uFEFF${await generar()}'),
    );

/// Convierte un nombre en un fragmento seguro para nombre de fichero.
String slugArchivo(String nombre) => nombre
    .trim()
    .replaceAll(RegExp(r'\s+'), '_')
    .replaceAll(RegExp(r'[^A-Za-z0-9_\-]'), '');
