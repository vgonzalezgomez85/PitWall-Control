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
import 'package:package_info_plus/package_info_plus.dart';

import '../../services/changelog.dart';

/// Historial de versiones ("Novedades"), igual que en PitWall Manager:
/// lee CHANGELOG.md y lo muestra agrupado por versión.
class PantallaChangelog extends StatefulWidget {
  const PantallaChangelog({super.key});

  @override
  State<PantallaChangelog> createState() => _PantallaChangelogState();
}

class _PantallaChangelogState extends State<PantallaChangelog> {
  late final Future<List<VersionCambios>> _versiones = cargarChangelog();
  late final Future<PackageInfo> _info = PackageInfo.fromPlatform();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novedades'),
        actions: [
          FutureBuilder<PackageInfo>(
            future: _info,
            builder: (context, snap) {
              final v = snap.data?.version;
              if (v == null) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Text('v$v',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          )),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<VersionCambios>>(
        future: _versiones,
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final versiones = snap.data!;
          if (versiones.isEmpty) {
            return const Center(child: Text('Aún no hay historial.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: versiones.length,
            itemBuilder: (context, i) => _TarjetaVersion(v: versiones[i]),
          );
        },
      ),
    );
  }
}

class _TarjetaVersion extends StatelessWidget {
  const _TarjetaVersion({required this.v});
  final VersionCambios v;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('v${v.version}',
                      style: TextStyle(
                        color: cs.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                      )),
                ),
                const SizedBox(width: 10),
                if (v.fecha.isNotEmpty)
                  Text(v.fecha,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: cs.outline)),
              ],
            ),
            if (v.notas.isNotEmpty) ...[
              const SizedBox(height: 8),
              for (final n in v.notas) _Parrafo(texto: n),
            ],
            for (final s in v.secciones) ...[
              const SizedBox(height: 14),
              _Seccion(seccion: s),
            ],
          ],
        ),
      ),
    );
  }
}

class _Seccion extends StatelessWidget {
  const _Seccion({required this.seccion});
  final SeccionCambios seccion;

  (IconData, Color) _estilo(ColorScheme cs) {
    switch (seccion.titulo) {
      case 'Añadido':
        return (Icons.add_circle_outline, Colors.green.shade700);
      case 'Mejorado':
        return (Icons.trending_up, Colors.blue.shade700);
      case 'Corregido':
        return (Icons.build_outlined, Colors.orange.shade800);
      default:
        return (Icons.info_outline, cs.outline);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (icono, color) = _estilo(cs);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icono, size: 18, color: color),
            const SizedBox(width: 6),
            Text(seccion.titulo,
                style: TextStyle(fontWeight: FontWeight.w700, color: color)),
          ],
        ),
        const SizedBox(height: 6),
        for (final item in seccion.items)
          Padding(
            padding: const EdgeInsets.only(bottom: 6, left: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('·  ', style: TextStyle(color: color)),
                Expanded(child: _Parrafo(texto: item)),
              ],
            ),
          ),
      ],
    );
  }
}

/// Un párrafo con **negrita** ya resuelta a spans.
class _Parrafo extends StatelessWidget {
  const _Parrafo({required this.texto});
  final String texto;

  @override
  Widget build(BuildContext context) {
    final base = DefaultTextStyle.of(context).style.copyWith(
          fontSize: 14,
          height: 1.4,
        );
    return RichText(
      text: TextSpan(
        style: base,
        children: [
          for (final s in segmentar(texto))
            TextSpan(
              text: s.texto,
              style: s.esNegrita
                  ? const TextStyle(fontWeight: FontWeight.w700)
                  : null,
            ),
        ],
      ),
    );
  }
}
