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
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/idioma.dart';
import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import 'repositorio_pilotos.dart';

class EditorPiloto extends ConsumerStatefulWidget {
  const EditorPiloto({super.key, this.pilotoId});

  final int? pilotoId;

  @override
  ConsumerState<EditorPiloto> createState() => _EditorPilotoState();
}

class _EditorPilotoState extends ConsumerState<EditorPiloto> {
  final _formKey = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _palmares = TextEditingController();
  final _telefono = TextEditingController();
  final _email = TextEditingController();
  final _creditosIniciales = TextEditingController();
  final _creditosActuales = TextEditingController();
  final _palmaresLocal = TextEditingController();

  String _categoria = 'BRONCE';
  bool _esCoordinadora = false;
  bool _cargando = true;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    if (widget.pilotoId == null) {
      _aplicarCategoria('BRONCE');
      setState(() => _cargando = false);
      return;
    }

    final db = ref.read(dbProvider);
    final activo = ref.read(campeonatoActivoProvider)!;

    final piloto = await (db.select(db.pilotos)
          ..where((t) => t.id.equals(widget.pilotoId!)))
        .getSingle();
    final perfil = await (db.select(db.pilotoCampeonato)
          ..where((t) =>
              t.pilotoId.equals(widget.pilotoId!) &
              t.campeonatoId.equals(activo.id)))
        .getSingleOrNull();

    _nombre.text = piloto.nombre;
    _palmares.text = piloto.palmaresGlobal ?? '';
    _telefono.text = piloto.telefono ?? '';
    _email.text = piloto.email ?? '';
    _esCoordinadora = piloto.esCoordinadora;
    if (perfil != null) {
      _categoria = perfil.categoria;
      _creditosIniciales.text = perfil.creditosIniciales.toString();
      _creditosActuales.text = perfil.creditosActuales.toString();
      _palmaresLocal.text = perfil.palmaresLocal ?? '';
    } else {
      _aplicarCategoria(_categoria);
    }

    if (mounted) setState(() => _cargando = false);
  }

  void _aplicarCategoria(String cat) {
    _categoria = cat;
    final sugerido = creditosInicialesPorCategoria[cat] ?? 28;
    if (_creditosIniciales.text.isEmpty || widget.pilotoId == null) {
      _creditosIniciales.text = sugerido.toString();
      _creditosActuales.text = sugerido.toString();
    }
  }

  @override
  void dispose() {
    _nombre.dispose();
    _palmares.dispose();
    _telefono.dispose();
    _email.dispose();
    _creditosIniciales.dispose();
    _creditosActuales.dispose();
    _palmaresLocal.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    final l = context.l;
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);

    final activo = ref.read(campeonatoActivoProvider)!;
    final repo = ref.read(repoPilotosProvider);

    try {
      if (widget.pilotoId == null) {
        await repo.crear(
          nombre: _nombre.text.trim(),
          palmaresGlobal: _txtOrNull(_palmares),
          telefono: _txtOrNull(_telefono),
          email: _txtOrNull(_email),
          campeonatoId: activo.id,
          categoria: _categoria,
          creditosIniciales: int.parse(_creditosIniciales.text),
          creditosActuales: int.parse(_creditosActuales.text),
          palmaresLocal: _txtOrNull(_palmaresLocal),
        );
      } else {
        // Detectar cambio manual de créditos para registrarlo en el log.
        final db = ref.read(dbProvider);
        final perfilPrev = await (db.select(db.pilotoCampeonato)
              ..where((t) =>
                  t.pilotoId.equals(widget.pilotoId!) &
                  t.campeonatoId.equals(activo.id)))
            .getSingleOrNull();
        final nuevoActual = int.parse(_creditosActuales.text);
        await repo.actualizar(
          pilotoId: widget.pilotoId!,
          campeonatoId: activo.id,
          nombre: _nombre.text.trim(),
          palmaresGlobal: _txtOrNull(_palmares),
          telefono: _txtOrNull(_telefono),
          email: _txtOrNull(_email),
          categoria: _categoria,
          creditosIniciales: int.parse(_creditosIniciales.text),
          creditosActuales: nuevoActual,
          palmaresLocal: _txtOrNull(_palmaresLocal),
        );
        if (perfilPrev != null &&
            perfilPrev.creditosActuales != nuevoActual) {
          final delta = nuevoActual - perfilPrev.creditosActuales;
          await db.into(db.movimientosCreditos).insert(
                MovimientosCreditosCompanion.insert(
                  pilotoId: widget.pilotoId!,
                  campeonatoId: activo.id,
                  delta: delta,
                  saldoResultante: nuevoActual,
                  motivo: l.motivoAjusteManual,
                ),
              );
        }
      }
      // Actualizar el flag esCoordinadora (no está en el repo, lo hago directo)
      final db = ref.read(dbProvider);
      final pilotoIdParaUpdate = widget.pilotoId ??
          (await (db.select(db.pilotos)
                ..where((t) => t.nombre.equals(_nombre.text.trim())))
              .getSingle())
              .id;
      await (db.update(db.pilotos)
            ..where((t) => t.id.equals(pilotoIdParaUpdate)))
          .write(PilotosCompanion(
              esCoordinadora: Value(_esCoordinadora)));
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l.noSePudoGuardar('$e'))),
        );
        setState(() => _guardando = false);
      }
    }
  }

  String? _txtOrNull(TextEditingController c) {
    final t = c.text.trim();
    return t.isEmpty ? null : t;
  }

  Future<void> _quitarDelCampeonato() async {
    final l = context.l;
    final activo = ref.read(campeonatoActivoProvider)!;
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.quitarDelCampeonato),
        content: Text(l.quitarDelCampeonatoTexto(_nombre.text, activo.nombre)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.cancelar),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.quitar),
          ),
        ],
      ),
    );
    if (confirmar != true) return;

    await ref.read(repoPilotosProvider).quitarDeCampeonato(
          pilotoId: widget.pilotoId!,
          campeonatoId: activo.id,
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final esNuevo = widget.pilotoId == null;
    final activo = ref.watch(campeonatoActivoProvider);
    final usaCreditos = activo?.usaCreditos ?? true;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            esNuevo ? context.l.nuevoPiloto : context.l.editarPiloto),
        actions: [
          if (!esNuevo)
            IconButton(
              tooltip: context.l.quitarDelCampeonato,
              icon: const Icon(Icons.person_remove_outlined),
              onPressed: _quitarDelCampeonato,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _Seccion(titulo: context.l.datosPersonales),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nombre,
              decoration: InputDecoration(
                labelText: context.l.nombreYApellidos,
                prefixIcon: const Icon(Icons.person_outline),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? context.l.indicaElNombre
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _telefono,
              decoration: InputDecoration(
                labelText: context.l.telefono,
                prefixIcon: const Icon(Icons.phone_outlined),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _email,
              decoration: InputDecoration(
                labelText: context.l.email,
                prefixIcon: const Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _palmares,
              decoration: InputDecoration(
                labelText: context.l.palmaresHistorico,
                helperText: context.l.palmaresEjemplo,
                prefixIcon: const Icon(Icons.emoji_events_outlined),
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              value: _esCoordinadora,
              onChanged: (v) => setState(() => _esCoordinadora = v),
              title: Text(context.l.pilotoCoordinadora),
              subtitle: Text(context.l.pilotoCoordinadoraTexto),
              secondary: const Icon(Icons.shield_outlined),
            ),
            const SizedBox(height: 28),
            _Seccion(titulo: context.l.enEsteCampeonato),
            const SizedBox(height: 12),
            if (usaCreditos)
              DropdownButtonFormField<String>(
                initialValue: _categoria,
                decoration: InputDecoration(
                  labelText: context.l.categoria,
                  prefixIcon: const Icon(Icons.workspace_premium_outlined),
                ),
                items: categorias
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) {
                  if (v == null) return;
                  setState(() {
                    _categoria = v;
                    final sugerido = creditosInicialesPorCategoria[v] ?? 28;
                    if (widget.pilotoId == null) {
                      _creditosIniciales.text = sugerido.toString();
                      _creditosActuales.text = sugerido.toString();
                    }
                  });
                },
              ),
            if (usaCreditos) const SizedBox(height: 12),
            if (usaCreditos) Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _creditosIniciales,
                    decoration: InputDecoration(
                      labelText: context.l.creditosIniciales,
                      helperText: context.l.sugeridoSegunCategoria,
                    ),
                    keyboardType: TextInputType.number,
                    validator: _validarEntero,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _creditosActuales,
                    decoration: InputDecoration(
                      labelText: context.l.creditosActuales,
                    ),
                    keyboardType: TextInputType.number,
                    validator: _validarEntero,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _palmaresLocal,
              decoration: InputDecoration(
                labelText: context.l.palmaresLocal,
                prefixIcon: const Icon(Icons.military_tech_outlined),
              ),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _guardando ? null : _guardar,
              icon: _guardando
                  ? const SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check),
              label: Text(
                  esNuevo ? context.l.crearPiloto : context.l.guardarCambios),
            ),
          ],
        ),
      ),
    );
  }

  String? _validarEntero(String? v) {
    final l = context.l;
    if (v == null || v.trim().isEmpty) return l.indicaUnNumero;
    final n = int.tryParse(v.trim());
    if (n == null) return l.tieneQueSerEntero;
    if (n < 0) return l.noPuedeSerNegativo;
    return null;
  }
}

class _Seccion extends StatelessWidget {
  const _Seccion({required this.titulo});
  final String titulo;

  @override
  Widget build(BuildContext context) {
    return Text(titulo,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ));
  }
}
