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
import 'package:intl/intl.dart';

import '../../core/proveedores.dart';
import '../../services/exportar_pdf.dart';
import '../../services/generador_pdf_verificaciones.dart';
import '../verificaciones/editor_verificacion.dart';
import '../verificaciones/lista_verificaciones.dart';
import 'editor_sesion_libre.dart';
import 'repositorio_verificacion_libre.dart';

/// Listado de sesiones de verificación libre (sin campeonato ni prueba).
class PantallaVerificacionLibre extends ConsumerWidget {
  const PantallaVerificacionLibre({super.key});

  Future<void> _nuevaSesion(BuildContext context) async {
    final nav = Navigator.of(context);
    final pruebaId = await nav.push<int>(
      MaterialPageRoute(builder: (_) => const EditorSesionLibre()),
    );
    if (pruebaId == null) return;
    nav.push(MaterialPageRoute(
      builder: (_) => PantallaSesionLibre(pruebaId: pruebaId),
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sesionesAsync = ref.watch(sesionesLibresProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Verificación libre')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _nuevaSesion(context),
        icon: const Icon(Icons.add),
        label: const Text('Nueva sesión'),
      ),
      body: sesionesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (sesiones) {
          if (sesiones.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.fact_check_outlined,
                        size: 96, color: cs.outline),
                    const SizedBox(height: 16),
                    Text('Aún no hay sesiones',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      'Verifica coches sin montar un campeonato: una carrera '
                      'esporádica, un control en el club… Crea una sesión, '
                      'añade participantes y exporta el PDF.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 96),
            children: [
              for (final s in sesiones)
                Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: cs.primaryContainer,
                      child: Icon(Icons.fact_check_outlined,
                          color: cs.onPrimaryContainer),
                    ),
                    title: Text(s.nombre),
                    subtitle: Text([
                      describirSesion(s),
                      '${s.participantes} participantes · '
                          '${s.validadas} validadas',
                    ].where((t) => t.isNotEmpty).join('\n')),
                    isThreeLine: describirSesion(s).isNotEmpty,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) =>
                          PantallaSesionLibre(pruebaId: s.prueba.id),
                    )),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// "dd/MM/yyyy · lugar · copas" (omite lo que no haya).
String describirSesion(SesionLibre s) => [
      if (s.prueba.fecha != null)
        DateFormat('dd/MM/yyyy').format(s.prueba.fecha!),
      if (s.prueba.sede?.trim().isNotEmpty ?? false) s.prueba.sede!.trim(),
      if (s.copas.isNotEmpty) s.copas.join(', '),
    ].join(' · ');

/// Una sesión: lista de participantes con su verificación, alta rápida de
/// participantes, reglamento y exportación a PDF.
class PantallaSesionLibre extends ConsumerWidget {
  const PantallaSesionLibre({super.key, required this.pruebaId});

  final int pruebaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sesionAsync = ref.watch(sesionLibreProvider(pruebaId));
    return sesionAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (s) {
        if (s == null) {
          return const Scaffold(
              body: Center(child: Text('La sesión ya no existe.')));
        }
        final descripcion = describirSesion(s);
        return PantallaVerificaciones(
          mangaId: s.mangaId,
          titulo: s.nombre,
          subtitulo: descripcion.isEmpty ? null : descripcion,
          vacioTitulo: 'Aún no hay participantes',
          vacioTexto: 'Pulsa "Añadir participante" para verificar su coche.',
          botonFlotante: FloatingActionButton.extended(
            onPressed: () => _anadirParticipante(context, ref, s),
            icon: const Icon(Icons.person_add_alt_1),
            label: const Text('Añadir participante'),
          ),
          onQuitar: (fila) => ref
              .read(repoVerificacionLibreProvider)
              .quitarParticipante(sesion: s, equipoId: fila.equipo.id),
          acciones: [
            IconButton(
              tooltip: 'Reglamento y datos de la sesión',
              icon: const Icon(Icons.tune),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => EditorSesionLibre(pruebaId: pruebaId),
              )),
            ),
            IconButton(
              tooltip: 'Exportar verificaciones (PDF)',
              icon: const Icon(Icons.picture_as_pdf_outlined),
              onPressed: s.conVerificacion == 0
                  ? null
                  : () async {
                      final idi = await elegirIdiomaExport(context, ref);
                      if (idi == null || !context.mounted) return;
                      guardarPdf(
                        context,
                        sugerido:
                            'verificaciones-${slugArchivo(s.nombre)}.pdf',
                        generar: () => ref
                            .read(generadorPdfVerificacionesProvider)
                            .generar(pruebaId: pruebaId, idioma: idi),
                      );
                    },
            ),
            IconButton(
              tooltip: 'Eliminar sesión',
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _borrar(context, ref, s),
            ),
          ],
        );
      },
    );
  }

  Future<void> _borrar(
      BuildContext context, WidgetRef ref, SesionLibre s) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar sesión'),
        content: Text('Se borrarán "${s.nombre}", sus participantes y '
            'todas sus verificaciones. No se puede deshacer.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Eliminar')),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final nav = Navigator.of(context);
    await ref.read(repoVerificacionLibreProvider).borrarSesion(s.prueba.id);
    nav.pop();
  }

  Future<void> _anadirParticipante(
      BuildContext context, WidgetRef ref, SesionLibre s) async {
    if (s.copas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Configura antes las copas en el reglamento de la '
              'sesión.')));
      return;
    }
    final db = ref.read(dbProvider);
    final nombresPilotos = (await db.select(db.pilotos).get())
        .map((p) => p.nombre)
        .toSet()
        .toList()
      ..sort();
    if (!context.mounted) return;
    final datos = await showDialog<_NuevoParticipante>(
      context: context,
      builder: (_) =>
          _DialogoParticipante(copas: s.copas, pilotos: nombresPilotos),
    );
    if (datos == null || !context.mounted) return;
    final nav = Navigator.of(context);
    final equipoId =
        await ref.read(repoVerificacionLibreProvider).anadirParticipante(
              sesion: s,
              piloto1: datos.piloto1,
              piloto2: datos.piloto2,
              equipo: datos.equipo,
              copa: datos.copa,
            );
    // Directo a la verificación: es lo siguiente que se va a hacer.
    nav.push(MaterialPageRoute(
      builder: (_) =>
          EditorVerificacion(mangaId: s.mangaId, equipoId: equipoId),
    ));
  }
}

class _NuevoParticipante {
  _NuevoParticipante(this.piloto1, this.piloto2, this.equipo, this.copa);
  final String piloto1;
  final String? piloto2;
  final String? equipo;
  final String copa;
}

class _DialogoParticipante extends StatefulWidget {
  const _DialogoParticipante({required this.copas, required this.pilotos});
  final List<String> copas;

  /// Nombres del maestro de pilotos, para autocompletar.
  final List<String> pilotos;

  @override
  State<_DialogoParticipante> createState() => _DialogoParticipanteState();
}

class _DialogoParticipanteState extends State<_DialogoParticipante> {
  final _formKey = GlobalKey<FormState>();
  String _piloto1 = '';
  String _piloto2 = '';
  final _equipo = TextEditingController();
  late String _copa = widget.copas.first;

  @override
  void dispose() {
    _equipo.dispose();
    super.dispose();
  }

  Widget _campoPiloto({
    required String etiqueta,
    required ValueChanged<String> onChanged,
    bool obligatorio = false,
    bool autofocus = false,
  }) {
    return Autocomplete<String>(
      optionsBuilder: (v) {
        final q = v.text.trim().toLowerCase();
        if (q.isEmpty) return const Iterable<String>.empty();
        return widget.pilotos.where((n) => n.toLowerCase().contains(q));
      },
      onSelected: onChanged,
      fieldViewBuilder: (context, ctrl, foco, onSubmit) => TextFormField(
        controller: ctrl,
        focusNode: foco,
        autofocus: autofocus,
        decoration: InputDecoration(
          labelText: etiqueta,
          prefixIcon: const Icon(Icons.person_outline),
        ),
        textCapitalization: TextCapitalization.words,
        onChanged: onChanged,
        validator: obligatorio
            ? (v) => (v == null || v.trim().isEmpty) ? 'Obligatorio' : null
            : null,
      ),
    );
  }

  void _aceptar() {
    if (!_formKey.currentState!.validate()) return;
    final p2 = _piloto2.trim();
    final eq = _equipo.text.trim();
    Navigator.pop(
      context,
      _NuevoParticipante(_piloto1.trim(), p2.isEmpty ? null : p2,
          eq.isEmpty ? null : eq, _copa),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Añadir participante'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _campoPiloto(
                etiqueta: 'Piloto *',
                obligatorio: true,
                autofocus: true,
                onChanged: (v) => _piloto1 = v,
              ),
              const SizedBox(height: 12),
              _campoPiloto(
                etiqueta: 'Segundo piloto (opcional)',
                onChanged: (v) => _piloto2 = v,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _equipo,
                decoration: const InputDecoration(
                  labelText: 'Equipo (opcional)',
                  helperText: 'Si se deja vacío, se usa el nombre del piloto',
                  prefixIcon: Icon(Icons.groups_outlined),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _copa,
                decoration: const InputDecoration(
                  labelText: 'Copa / categoría',
                  prefixIcon: Icon(Icons.flag_outlined),
                ),
                items: [
                  for (final c in widget.copas)
                    DropdownMenuItem(value: c, child: Text(c)),
                ],
                onChanged: (v) => setState(() => _copa = v ?? _copa),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _aceptar,
          child: const Text('Añadir y verificar'),
        ),
      ],
    );
  }
}
