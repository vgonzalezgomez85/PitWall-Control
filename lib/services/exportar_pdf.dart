import 'dart:io';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

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

/// Convierte un nombre en un fragmento seguro para nombre de fichero.
String slugArchivo(String nombre) => nombre
    .trim()
    .replaceAll(RegExp(r'\s+'), '_')
    .replaceAll(RegExp(r'[^A-Za-z0-9_\-]'), '');
