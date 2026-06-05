import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                  motivo: 'Ajuste manual (ficha de piloto)',
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
          SnackBar(content: Text('No se pudo guardar: $e')),
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
    final activo = ref.read(campeonatoActivoProvider)!;
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Quitar del campeonato'),
        content: Text(
          '¿Quitar a ${_nombre.text} de "${activo.nombre}"?\n\n'
          'El piloto no se borra, solo se desinscribe de este campeonato.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Quitar'),
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
        title: Text(esNuevo ? 'Nuevo piloto' : 'Editar piloto'),
        actions: [
          if (!esNuevo)
            IconButton(
              tooltip: 'Quitar del campeonato',
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
            _Seccion(titulo: 'Datos personales'),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nombre,
              decoration: const InputDecoration(
                labelText: 'Nombre y apellidos *',
                prefixIcon: Icon(Icons.person_outline),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Indica el nombre' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _telefono,
              decoration: const InputDecoration(
                labelText: 'Teléfono',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _email,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _palmares,
              decoration: const InputDecoration(
                labelText: 'Palmarés histórico',
                helperText: 'Ej: "Top 3 Resisbarna 2025", "WES 2023-2024"',
                prefixIcon: Icon(Icons.emoji_events_outlined),
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              value: _esCoordinadora,
              onChanged: (v) => setState(() => _esCoordinadora = v),
              title: const Text('Piloto de coordinadora'),
              subtitle: const Text(
                  'Si está activado, los equipos en los que participe no pagarán cuota.'),
              secondary: const Icon(Icons.shield_outlined),
            ),
            const SizedBox(height: 28),
            _Seccion(titulo: 'En este campeonato'),
            const SizedBox(height: 12),
            if (usaCreditos)
              DropdownButtonFormField<String>(
                initialValue: _categoria,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  prefixIcon: Icon(Icons.workspace_premium_outlined),
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
                    decoration: const InputDecoration(
                      labelText: 'Créditos iniciales',
                      helperText: 'Sugerido según categoría',
                    ),
                    keyboardType: TextInputType.number,
                    validator: _validarEntero,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _creditosActuales,
                    decoration: const InputDecoration(
                      labelText: 'Créditos actuales',
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
              decoration: const InputDecoration(
                labelText: 'Palmarés en este campeonato',
                prefixIcon: Icon(Icons.military_tech_outlined),
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
              label: Text(esNuevo ? 'Crear piloto' : 'Guardar cambios'),
            ),
          ],
        ),
      ),
    );
  }

  String? _validarEntero(String? v) {
    if (v == null || v.trim().isEmpty) return 'Indica un número';
    final n = int.tryParse(v.trim());
    if (n == null) return 'Tiene que ser un número entero';
    if (n < 0) return 'No puede ser negativo';
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
