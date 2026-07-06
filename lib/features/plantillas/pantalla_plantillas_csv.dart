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

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

/// Una plantilla CSV descargable para usar luego en un importador.
class _Plantilla {
  final String titulo;
  final String descripcion;
  final IconData icono;
  final String archivo;
  final List<String> cabeceras;
  final List<String> ejemplo;
  const _Plantilla({
    required this.titulo,
    required this.descripcion,
    required this.icono,
    required this.archivo,
    required this.cabeceras,
    required this.ejemplo,
  });
}

const _plantillas = <_Plantilla>[
  _Plantilla(
    titulo: 'Pilotos',
    descripcion: 'Para importar pilotos a un campeonato.',
    icono: Icons.people_alt_outlined,
    archivo: 'plantilla-pilotos.csv',
    cabeceras: ['Nombre', 'Categoría', 'Créditos iniciales', 'Créditos actuales', 'Palmarés'],
    ejemplo: ['Juan Ejemplo', 'ORO', '28', '28', 'Top 3 liga 2025'],
  ),
  _Plantilla(
    titulo: 'Equipos (parejas)',
    descripcion: 'Equipos con uno o dos pilotos. Deja en blanco el piloto 2 si es individual.',
    icono: Icons.groups_outlined,
    archivo: 'plantilla-equipos.csv',
    cabeceras: [
      'Equipo', 'Copa',
      'Piloto 1', 'Categoría 1', 'Email 1', 'Teléfono 1',
      'Piloto 2', 'Categoría 2', 'Email 2', 'Teléfono 2',
    ],
    ejemplo: [
      'EQUIPO EJEMPLO', 'GT',
      'Juan Ejemplo', 'ORO', 'juan@ejemplo.com', '600000000',
      'Ana Ejemplo', 'PLATA', 'ana@ejemplo.com', '600000001',
    ],
  ),
  _Plantilla(
    titulo: 'Equipos de resistencia (24H/12H)',
    descripcion: 'Equipos de 3 a 6 pilotos. Deja en blanco los que no uses. '
        'La categoría de cada piloto se toma de su ficha ya importada.',
    icono: Icons.diversity_3_outlined,
    archivo: 'plantilla-equipos-resistencia.csv',
    cabeceras: ['Equipo', 'Copa', 'Piloto 1', 'Piloto 2', 'Piloto 3', 'Piloto 4', 'Piloto 5'],
    ejemplo: ['EQUIPO EJEMPLO', 'GRUPO C1', 'Juan Ejemplo', 'Ana Ejemplo', 'Luis Ejemplo', 'Marta Ejemplo', ''],
  ),
  _Plantilla(
    titulo: 'Inscripciones a una prueba',
    descripcion: 'Equipos que se inscriben a una prueba, con su preferencia de día.',
    icono: Icons.how_to_reg_outlined,
    archivo: 'plantilla-inscripciones.csv',
    cabeceras: ['Equipo', 'Día', 'Notas'],
    ejemplo: ['EQUIPO EJEMPLO', 'Viernes', ''],
  ),
  _Plantilla(
    titulo: 'Catálogo · Coches',
    descripcion: 'Modelos de coche del catálogo.',
    icono: Icons.directions_car_outlined,
    archivo: 'plantilla-coches.csv',
    cabeceras: ['Nombre', 'Marca', 'Modelo', 'Peso mínimo', 'Créditos', 'Copa'],
    ejemplo: ['SCALEAUTO-PORSCHE 911', 'Scaleauto', 'Porsche 911', '17', '0', 'GT'],
  ),
  _Plantilla(
    titulo: 'Catálogo · Motores',
    descripcion: 'Motores homologados (RPM y gauss de referencia).',
    icono: Icons.bolt_outlined,
    archivo: 'plantilla-motores.csv',
    cabeceras: ['Nombre', 'RPM', 'Gauss', 'Copa'],
    ejemplo: ['SLOT.IT 21K', '21000', '350', 'SLOT.IT'],
  ),
  _Plantilla(
    titulo: 'Catálogo · Marcas',
    descripcion: 'Marcas (código corto + nombre).',
    icono: Icons.sell_outlined,
    archivo: 'plantilla-marcas.csv',
    cabeceras: ['Código', 'Nombre'],
    ejemplo: ['SIT', 'Slot.it'],
  ),
  _Plantilla(
    titulo: 'Catálogo · Llantas',
    descripcion: 'Dimensión y tipo (DELANTERA / TRASERA / AMBAS).',
    icono: Icons.circle_outlined,
    archivo: 'plantilla-llantas.csv',
    cabeceras: ['Dimensión', 'Tipo'],
    ejemplo: ['15,8 x 8', 'TRASERA'],
  ),
  _Plantilla(
    titulo: 'Catálogo · Engranajes',
    descripcion: 'Piñones y coronas (tipo, marca, dientes).',
    icono: Icons.settings_outlined,
    archivo: 'plantilla-engranajes.csv',
    cabeceras: ['Tipo', 'Marca', 'Dientes'],
    ejemplo: ['CORONA', 'Slot.it', '28'],
  ),
];

/// Apartado global para descargar plantillas CSV en blanco (con las columnas
/// que reconocen los importadores) y rellenarlas para luego importar.
class PantallaPlantillasCsv extends StatelessWidget {
  const PantallaPlantillasCsv({super.key});

  String _campoCsv(String c) => '"${c.replaceAll('"', '""')}"';

  String _construirCsv(_Plantilla p) {
    final filas = [p.cabeceras, p.ejemplo];
    return filas.map((f) => f.map(_campoCsv).join(',')).join('\r\n');
  }

  Future<void> _descargar(BuildContext context, _Plantilla p) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final destino = await getSaveLocation(
        acceptedTypeGroups: [
          const XTypeGroup(label: 'CSV', extensions: ['csv']),
        ],
        suggestedName: p.archivo,
      );
      if (destino == null) return;
      var ruta = destino.path;
      if (!ruta.toLowerCase().endsWith('.csv')) ruta = '$ruta.csv';
      // BOM UTF-8 para que Excel reconozca los acentos.
      await File(ruta).writeAsString('﻿${_construirCsv(p)}');
      messenger.showSnackBar(
          SnackBar(content: Text('Plantilla guardada en $ruta')));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Plantillas CSV')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: cs.outline),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Descarga la plantilla, rellénala con tus datos (borra la fila '
                    'de ejemplo) y luego impórtala desde la sección correspondiente. '
                    'La primera fila son las columnas: no la cambies.',
                    style: TextStyle(color: cs.onSurface, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ..._plantillas.map((p) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: cs.primaryContainer,
                        child: Icon(p.icono, color: cs.onPrimaryContainer),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.titulo,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium),
                            const SizedBox(height: 2),
                            Text(p.descripcion,
                                style: TextStyle(
                                    color: cs.outline, fontSize: 13)),
                            const SizedBox(height: 6),
                            Text(p.cabeceras.join(' · '),
                                style: TextStyle(
                                    color: cs.primary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.tonalIcon(
                        onPressed: () => _descargar(context, p),
                        icon: const Icon(Icons.download_outlined, size: 18),
                        label: const Text('Descargar'),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
