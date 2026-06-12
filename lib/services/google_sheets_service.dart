import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis/sheets/v4.dart' as sheets;

import 'google_auth_service.dart';

/// Resumen de una hoja de cálculo.
class HojaResumen {
  final String id;
  final String nombre;
  final DateTime? modificada;

  HojaResumen({required this.id, required this.nombre, this.modificada});
}

/// Pestaña dentro de una hoja.
class PestanaResumen {
  final String titulo;
  final int sheetId;

  PestanaResumen({required this.titulo, required this.sheetId});
}

/// Servicio para listar y leer Google Sheets.
class GoogleSheetsService {
  GoogleSheetsService(this._auth);
  final GoogleAuthService _auth;

  /// Lista las hojas de cálculo accesibles del usuario (limitado).
  Future<List<HojaResumen>> listarHojas({int limite = 50, String? buscar}) async {
    final cli = await _auth.clienteAutenticado();
    try {
      final api = drive.DriveApi(cli);
      var q = "mimeType='application/vnd.google-apps.spreadsheet' and trashed=false";
      if (buscar != null && buscar.isNotEmpty) {
        final esc = buscar.replaceAll("'", r"\'");
        q = "$q and name contains '$esc'";
      }
      final res = await api.files.list(
        q: q,
        pageSize: limite,
        orderBy: 'modifiedTime desc',
        $fields: 'files(id,name,modifiedTime)',
      );
      return (res.files ?? [])
          .map((f) => HojaResumen(
                id: f.id!,
                nombre: f.name ?? 'Sin título',
                modificada: f.modifiedTime,
              ))
          .toList();
    } finally {
      cli.close();
    }
  }

  /// Lista las pestañas de una hoja.
  Future<List<PestanaResumen>> listarPestanas(String hojaId) async {
    final cli = await _auth.clienteAutenticado();
    try {
      final api = sheets.SheetsApi(cli);
      final hoja = await api.spreadsheets.get(hojaId);
      return (hoja.sheets ?? [])
          .where((s) => s.properties != null)
          .map((s) => PestanaResumen(
                titulo: s.properties!.title ?? 'Sin nombre',
                sheetId: s.properties!.sheetId ?? 0,
              ))
          .toList();
    } finally {
      cli.close();
    }
  }

  /// Lee una pestaña entera como `List<List<String>>`.
  Future<List<List<String>>> leerPestana(
      String hojaId, String tituloPestana) async {
    final cli = await _auth.clienteAutenticado();
    try {
      final api = sheets.SheetsApi(cli);
      // Rango = nombre de pestaña (lee todo lo que tenga valores)
      final res = await api.spreadsheets.values.get(
        hojaId,
        "'$tituloPestana'",
        valueRenderOption: 'FORMATTED_VALUE',
        dateTimeRenderOption: 'FORMATTED_STRING',
      );
      final filas = res.values ?? [];
      return filas
          .map((fila) => fila.map((c) => (c ?? '').toString()).toList())
          .toList();
    } finally {
      cli.close();
    }
  }
}

final googleSheetsServiceProvider = Provider<GoogleSheetsService>((ref) {
  return GoogleSheetsService(ref.watch(googleAuthServiceProvider));
});
