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
import 'dart:isolate';
import 'dart:typed_data';

import '../../data/database/app_database.dart';
import '../../services/fotos_verificacion.dart';
import '../../services/xlsx_con_fotos.dart';
import '../verificaciones/pantalla_rejilla_verificaciones.dart';
import 'repositorio_verificacion_libre.dart';

/// Excel (.xlsx) de una sesión de verificación libre: una fila por
/// participante con las columnas del resumen de verificaciones (fuera de
/// reglamento en rojo, más una columna con los motivos), la foto del coche
/// en el catálogo y las fotos de la verificación incrustadas al final.
Future<Uint8List> generarExcelSesionLibre(
    AppDatabase db, SesionLibre sesion) async {
  final camp = sesion.reglamento;
  final filas = await cargarRejilla(db, camp, sesion.prueba.id);
  // Foto de referencia del catálogo de cada coche (por id).
  final fotoCoche = {
    for (final c in await db.select(db.catalogoCoches).get())
      if (c.fotoPath != null) c.id: c.fotoPath!,
  };

  final celdas = <List<CeldaXlsx>>[];
  final fotos = <List<Uint8List>>[];
  final fotosCatalogo = <Uint8List?>[];
  for (final f in filas) {
    final motivos = <String>[];
    final fila = <CeldaXlsx>[CeldaXlsx(nombreFilaRejilla(f))];
    for (final col in columnasRejilla) {
      final c = col.celda(f, camp);
      if (c.infraccion != null) motivos.add('${col.titulo}: ${c.infraccion}');
      fila.add(CeldaXlsx(c.texto, mal: c.infraccion != null));
    }
    fila.add(CeldaXlsx(motivos.join('; '), mal: motivos.isNotEmpty));
    celdas.add(fila);
    fotos.add(await _fotosDe(f.v));
    final ruta = fotoCoche[f.v?.cocheCatalogoId];
    fotosCatalogo.add(ruta == null ? null : await _leer(ruta));
  }

  final hoja = HojaConFotos(
    nombre: sesion.nombre,
    cabecera: [
      'Piloto / equipo',
      for (final c in columnasRejilla) c.titulo,
      'Fuera de reglamento',
    ],
    // Anchos aproximados a los de la pantalla (px → caracteres).
    anchos: [32, for (final c in columnasRejilla) c.ancho / 7, 50],
    filas: celdas,
    fotos: fotos,
    fotoReferencia: fotosCatalogo,
    tituloReferencia: 'Foto catálogo',
  );
  return _enOtroHilo(hoja);
}

/// Recomprimir decenas de fotos bloquearía la interfaz: se hace fuera del
/// hilo principal. Función aparte para que el cierre solo capture [hoja]
/// (no la base de datos, que no se puede pasar a otro isolate).
Future<Uint8List> _enOtroHilo(HojaConFotos hoja) =>
    Isolate.run(() => generarXlsxConFotos(hoja));

/// Bytes de las fotos de la verificación, en su orden; las que ya no están
/// en disco se omiten.
Future<List<Uint8List>> _fotosDe(Verificacione? v) async {
  if (v == null || v.fotosJson.isEmpty) return const [];
  final out = <Uint8List>[];
  try {
    final raw = jsonDecode(v.fotosJson);
    if (raw is! List) return const [];
    for (final e in raw) {
      final bytes = await _leer(e.toString());
      if (bytes != null) out.add(bytes);
    }
  } catch (_) {}
  return out;
}

/// Bytes de una foto guardada (verificación o catálogo); null si ya no está.
Future<Uint8List?> _leer(String entrada) async {
  try {
    final f = await FotosVerificacion.resolver(entrada);
    return await f.exists() ? await f.readAsBytes() : null;
  } catch (_) {
    return null;
  }
}
