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

  /// Sobrescribe una fila (1-based) de una pestaña con [valores].
  Future<void> escribirFila(String hojaId, String tituloPestana, int fila1,
      List<Object?> valores) async {
    final cli = await _auth.clienteAutenticado();
    try {
      final api = sheets.SheetsApi(cli);
      final rango =
          "'$tituloPestana'!A$fila1:${columnaLetra(valores.length - 1)}$fila1";
      final vr = sheets.ValueRange(values: [valores]);
      await api.spreadsheets.values
          .update(vr, hojaId, rango, valueInputOption: 'USER_ENTERED');
    } finally {
      cli.close();
    }
  }

  /// Borra físicamente una fila (1-based) de una pestaña.
  Future<void> borrarFila(
      String hojaId, String tituloPestana, int fila1) async {
    final cli = await _auth.clienteAutenticado();
    try {
      final api = sheets.SheetsApi(cli);
      final meta = await api.spreadsheets
          .get(hojaId, $fields: 'sheets.properties');
      sheets.SheetProperties? props;
      for (final s in meta.sheets ?? const <sheets.Sheet>[]) {
        if (s.properties?.title == tituloPestana) {
          props = s.properties;
          break;
        }
      }
      final gid = props?.sheetId;
      if (gid == null) return;
      await api.spreadsheets.batchUpdate(
        sheets.BatchUpdateSpreadsheetRequest(requests: [
          sheets.Request(
            deleteDimension: sheets.DeleteDimensionRequest(
              range: sheets.DimensionRange(
                sheetId: gid,
                dimension: 'ROWS',
                startIndex: fila1 - 1,
                endIndex: fila1,
              ),
            ),
          ),
        ]),
        hojaId,
      );
    } finally {
      cli.close();
    }
  }

  /// Escribe una única celda (fila 1-based, columna 0-based).
  Future<void> escribirCelda(String hojaId, String tituloPestana, int fila1,
      int col0, Object? valor) async {
    final cli = await _auth.clienteAutenticado();
    try {
      final api = sheets.SheetsApi(cli);
      final letra = columnaLetra(col0);
      final rango = "'$tituloPestana'!$letra$fila1:$letra$fila1";
      final vr = sheets.ValueRange(values: [
        [valor]
      ]);
      await api.spreadsheets.values
          .update(vr, hojaId, rango, valueInputOption: 'USER_ENTERED');
    } finally {
      cli.close();
    }
  }

  /// Añade [filas] al final de la pestaña. Si se indica [ultimaColumna]
  /// (0-based), el rango se restringe a esa columna para que la API busque
  /// la tabla justo bajo la cabecera conocida, en vez de adivinar entre
  /// bloques de datos sueltos que pueda haber en el resto de la pestaña.
  /// [primeraColumna] (0-based) debe ser la primera columna con contenido en
  /// la cabecera: el "append" de Sheets ubica la tabla ahí y coloca [filas]
  /// en relativo a esa columna, así que [filas] no debe incluir relleno de
  /// columnas vacías a su izquierda (verían su desplazamiento duplicado).
  Future<void> anadirFilas(
      String hojaId, String tituloPestana, List<List<Object?>> filas,
      {int? primeraColumna, int? ultimaColumna}) async {
    if (filas.isEmpty) return;
    final cli = await _auth.clienteAutenticado();
    try {
      final api = sheets.SheetsApi(cli);
      final vr = sheets.ValueRange(values: filas);
      final desde = columnaLetra(primeraColumna ?? 0);
      final rango = ultimaColumna != null
          ? "'$tituloPestana'!$desde:${columnaLetra(ultimaColumna)}"
          : "'$tituloPestana'";
      await api.spreadsheets.values.append(
        vr,
        hojaId,
        rango,
        valueInputOption: 'USER_ENTERED',
        insertDataOption: 'INSERT_ROWS',
      );
    } finally {
      cli.close();
    }
  }

  /// Letra de columna a partir del índice 0-based (0→A, 25→Z, 26→AA…).
  static String columnaLetra(int index) {
    var n = index + 1;
    var s = '';
    while (n > 0) {
      final r = (n - 1) % 26;
      s = String.fromCharCode(65 + r) + s;
      n = (n - 1) ~/ 26;
    }
    return s.isEmpty ? 'A' : s;
  }
}

final googleSheetsServiceProvider = Provider<GoogleSheetsService>((ref) {
  return GoogleSheetsService(ref.watch(googleAuthServiceProvider));
});
