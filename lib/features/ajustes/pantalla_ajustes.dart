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
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/entorno.dart';
import '../../core/proveedores.dart';
import '../google/pantalla_backup.dart';
import '../google/pantalla_configuracion_google.dart';
import '../plantillas/pantalla_plantillas_csv.dart';
import 'pantalla_changelog.dart';

/// Ajustes: todo lo que no es el trabajo diario con un campeonato, en un solo
/// sitio (Google, copias, plantillas, apariencia y novedades).
class PantallaAjustes extends ConsumerWidget {
  const PantallaAjustes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final oscuro = ref.watch(temaOscuroProvider);

    void abrir(Widget destino) => Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => destino));

    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          const _Seccion('Datos'),
          _Opcion(
            icono: Icons.cloud_sync_outlined,
            titulo: 'Copias de seguridad',
            subtitulo:
                'Subir o restaurar la copia en Drive, o restaurar desde archivo',
            onTap: () => abrir(const PantallaBackup()),
          ),
          _Opcion(
            icono: Icons.cloud_outlined,
            titulo: 'Google (Sheets y Drive)',
            subtitulo: 'Conectar la cuenta y las credenciales de Google Cloud',
            onTap: () => abrir(const PantallaConfiguracionGoogle()),
          ),
          _Opcion(
            icono: Icons.file_download_outlined,
            titulo: 'Plantillas CSV',
            subtitulo: 'Descargar plantillas para importar pilotos, equipos…',
            onTap: () => abrir(const PantallaPlantillasCsv()),
          ),
          const _Seccion('Apariencia'),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text('Modo oscuro'),
            value: oscuro,
            onChanged: (_) => ref.read(temaOscuroProvider.notifier).alternar(),
          ),
          const _Seccion('Acerca de'),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snap) {
              final v = snap.data?.version;
              return _Opcion(
                icono: Icons.new_releases_outlined,
                titulo: 'Novedades',
                subtitulo: v == null
                    ? 'Historial de versiones'
                    : 'Versión $v${esEntornoDev ? ' DEV' : ''} · historial de versiones',
                onTap: () => abrir(const PantallaChangelog()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Seccion extends StatelessWidget {
  const _Seccion(this.titulo);
  final String titulo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(titulo.toUpperCase(),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              )),
    );
  }
}

class _Opcion extends StatelessWidget {
  const _Opcion({
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
  });

  final IconData icono;
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icono),
      title: Text(titulo),
      subtitle: Text(subtitulo),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
