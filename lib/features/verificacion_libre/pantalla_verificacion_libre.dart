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

import '../../core/idioma.dart';
import '../../core/proveedores.dart';
import '../../core/widgets/acciones_barra.dart';
import '../../services/exportar_pdf.dart';
import '../../services/generador_pdf_verificaciones.dart';
import '../verificaciones/editor_verificacion.dart';
import '../verificaciones/lista_verificaciones.dart';
import 'editor_sesion_libre.dart';
import 'exportar_excel_sesion_libre.dart';
import 'pantalla_importar_participantes.dart';
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
      appBar: AppBar(title: Text(context.l.menuVerificacionLibre)),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'fab_sesion_libre',
        onPressed: () => _nuevaSesion(context),
        icon: const Icon(Icons.add),
        label: Text(context.l.nuevaSesion),
      ),
      body: sesionesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(context.l.errorDetalle('$e'))),
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
                    Text(context.l.aunNoHaySesiones,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      context.l.sesionesVaciasTexto,
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
                      '${context.l.nParticipantes(s.participantes)} · '
                          '${context.l.nValidadas(s.validadas)}',
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
      error: (e, _) =>
          Scaffold(body: Center(child: Text(context.l.errorDetalle('$e')))),
      data: (s) {
        if (s == null) {
          return Scaffold(
              body: Center(child: Text(context.l.sesionYaNoExiste)));
        }
        final descripcion = describirSesion(s);
        return PantallaVerificaciones(
          mangaId: s.mangaId,
          titulo: s.nombre,
          subtitulo: descripcion.isEmpty ? null : descripcion,
          vacioTitulo: context.l.aunNoHayParticipantes,
          vacioTexto: context.l.pulsaAnadirParticipante,
          botonFlotante: FloatingActionButton.extended(
            heroTag: 'fab_participante_libre',
            onPressed: () => _anadirParticipante(context, ref, s),
            icon: const Icon(Icons.person_add_alt_1),
            label: Text(context.l.anadirParticipante),
          ),
          onQuitar: (fila) => ref
              .read(repoVerificacionLibreProvider)
              .quitarParticipante(sesion: s, equipoId: fila.equipo.id),
          acciones: [
            AccionesBarra([
              AccionBarra(
                icono: Icons.group_add_outlined,
                etiqueta: context.l.importar,
                opciones: [
                  OpcionAccion(
                      Icons.upload_file,
                      context.l.desdeArchivoCsvExcelParentesis,
                      () => _importar(context, s, OrigenParticipantes.archivo)),
                  OpcionAccion(
                      Icons.cloud_outlined,
                      context.l.desdeGoogleSheets,
                      () => _importar(context, s, OrigenParticipantes.sheets)),
                ],
              ),
              AccionBarra(
                icono: Icons.ios_share,
                etiqueta: context.l.exportar,
                habilitada: s.conVerificacion > 0,
                opciones: [
                  OpcionAccion(Icons.picture_as_pdf_outlined, 'PDF', () async {
                    final idi = await elegirIdiomaExport(context, ref);
                    if (idi == null || !context.mounted) return;
                    guardarPdf(
                      context,
                      sugerido: 'verificaciones-${slugArchivo(s.nombre)}.pdf',
                      generar: () => ref
                          .read(generadorPdfVerificacionesProvider)
                          .generar(pruebaId: pruebaId, idioma: idi),
                    );
                  }),
                  OpcionAccion(
                      Icons.table_view_outlined,
                      context.l.excelConFotos,
                      () => guardarExcel(
                            context,
                            sugerido:
                                'verificaciones-${slugArchivo(s.nombre)}.xlsx',
                            generar: () => generarExcelSesionLibre(
                                ref.read(dbProvider), s),
                          )),
                ],
              ),
              AccionBarra(
                icono: Icons.tune,
                etiqueta: context.l.reglamento,
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => EditorSesionLibre(pruebaId: pruebaId),
                )),
              ),
              AccionBarra(
                icono: Icons.delete_outline,
                etiqueta: context.l.eliminarSesion,
                principal: false,
                onPressed: () => _borrar(context, ref, s),
              ),
            ]),
          ],
        );
      },
    );
  }

  Future<void> _importar(BuildContext context, SesionLibre s,
      OrigenParticipantes origen) async {
    final l = context.l;
    final messenger = ScaffoldMessenger.of(context);
    if (s.copas.isEmpty) {
      messenger.showSnackBar(
          SnackBar(content: Text(l.configuraCopasAntes)));
      return;
    }
    final n = await Navigator.of(context).push<int>(MaterialPageRoute(
      builder: (_) => PantallaImportarParticipantes(sesion: s, origen: origen),
    ));
    if (n != null) {
      messenger.showSnackBar(
          SnackBar(content: Text(l.anadidosParticipantes(n))));
    }
  }

  Future<void> _borrar(
      BuildContext context, WidgetRef ref, SesionLibre s) async {
    final l = context.l;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.eliminarSesion),
        content: Text(l.eliminarSesionTexto(s.nombre)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l.cancelar)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l.eliminar)),
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
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l.configuraCopasAntes)));
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
            ? (v) =>
                (v == null || v.trim().isEmpty) ? context.l.obligatorio : null
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
      title: Text(context.l.anadirParticipante),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _campoPiloto(
                etiqueta: context.l.pilotoObligatorio,
                obligatorio: true,
                autofocus: true,
                onChanged: (v) => _piloto1 = v,
              ),
              const SizedBox(height: 12),
              _campoPiloto(
                etiqueta: context.l.segundoPiloto,
                onChanged: (v) => _piloto2 = v,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _equipo,
                decoration: InputDecoration(
                  labelText: context.l.equipoOpcional,
                  helperText: context.l.equipoOpcionalAyuda,
                  prefixIcon: const Icon(Icons.groups_outlined),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _copa,
                decoration: InputDecoration(
                  labelText: context.l.copaCategoria,
                  prefixIcon: const Icon(Icons.flag_outlined),
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
          child: Text(context.l.cancelar),
        ),
        FilledButton(
          onPressed: _aceptar,
          child: Text(context.l.anadirYVerificar),
        ),
      ],
    );
  }
}
