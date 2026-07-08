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
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import '../../services/excel_catalogos.dart';
import '../../services/fotos_verificacion.dart';
import '../google/actualizador_drive.dart';
import '../google/repositorio_hojas_vinculadas.dart';
import '../google/subidor_catalogo.dart';
import 'importar_catalogo.dart';
import 'pantalla_subir_sheet.dart';
import 'repositorio_catalogos.dart';

/// Copas disponibles del catálogo, para ofrecerlas como opciones.
/// OBSERVA la tabla (no es un FutureProvider de una sola lectura): si no, al
/// crear una copa nueva el selector seguiría con la lista cacheada hasta
/// reiniciar la app. No es autoDispose, para que sobreviva al ciclo de vida
/// del diálogo que la consume.
final _copasDisponiblesProvider = StreamProvider<List<String>>((ref) {
  final db = ref.watch(repoCatalogosProvider).db;
  return db
      .select(db.catalogoCopas)
      .watch()
      .map((lista) => lista.map((c) => c.nombre).toList()..sort());
});

List<String> _decodeCopas(String? s) {
  if (s == null || s.isEmpty) return const [];
  try {
    final r = json.decode(s);
    if (r is List) return r.map((e) => e.toString()).toList();
  } catch (_) {}
  return const [];
}

String _resumenCopas(List<String> copas) {
  if (copas.isEmpty) return 'Todas';
  return copas.join(', ');
}

/// Lista de catálogo con buscador y (opcional) filtro por copa. Reutilizable
/// por todas las pestañas.
class _ListaCatalogo<T> extends StatefulWidget {
  const _ListaCatalogo({
    super.key,
    required this.datos,
    required this.textoBuscable,
    required this.item,
    required this.fab,
    required this.vacio,
    this.copasJsonDe,
    this.copas = const [],
  });

  final AsyncValue<List<T>> datos;
  final String Function(T) textoBuscable;
  final Widget Function(T) item;
  final Widget fab;
  final String vacio;

  /// Si no es null y hay copas, muestra un filtro por copa.
  final String? Function(T)? copasJsonDe;
  final List<String> copas;

  @override
  State<_ListaCatalogo<T>> createState() => _ListaCatalogoState<T>();
}

class _ListaCatalogoState<T> extends State<_ListaCatalogo<T>> {
  String _busqueda = '';
  String? _copaFiltro;

  @override
  Widget build(BuildContext context) {
    final conCopa = widget.copasJsonDe != null && widget.copas.isNotEmpty;
    return Scaffold(
      floatingActionButton: widget.fab,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Buscar…',
                      isDense: true,
                    ),
                    onChanged: (v) =>
                        setState(() => _busqueda = v.trim().toLowerCase()),
                  ),
                ),
                if (conCopa) ...[
                  const SizedBox(width: 8),
                  DropdownButton<String?>(
                    value: _copaFiltro,
                    hint: const Text('Copa'),
                    borderRadius: BorderRadius.circular(12),
                    items: [
                      const DropdownMenuItem<String?>(
                          value: null, child: Text('Todas')),
                      for (final c in widget.copas)
                        DropdownMenuItem<String?>(value: c, child: Text(c)),
                    ],
                    onChanged: (v) => setState(() => _copaFiltro = v),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: widget.datos.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (xs) {
                if (xs.isEmpty) return _Vacio(texto: widget.vacio);
                final filtradas = xs.where((x) {
                  if (_busqueda.isNotEmpty &&
                      !widget
                          .textoBuscable(x)
                          .toLowerCase()
                          .contains(_busqueda)) {
                    return false;
                  }
                  if (conCopa && _copaFiltro != null) {
                    final cps = _decodeCopas(widget.copasJsonDe!(x) ?? '');
                    if (cps.isNotEmpty && !cps.contains(_copaFiltro)) {
                      return false;
                    }
                  }
                  return true;
                }).toList();
                if (filtradas.isEmpty) {
                  return const _Vacio(texto: 'Sin coincidencias');
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
                  itemCount: filtradas.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 4),
                  itemBuilder: (_, i) => widget.item(filtradas[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PantallaCatalogos extends ConsumerStatefulWidget {
  const PantallaCatalogos({super.key});

  @override
  ConsumerState<PantallaCatalogos> createState() => _PantallaCatalogosState();
}

class _PantallaCatalogosState extends ConsumerState<PantallaCatalogos>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  static const _titulos = [
    'Coches', 'Marcas', 'Llantas', 'Engranajes', 'Motores', 'Bancadas', 'Chasis', 'Neumáticos', 'Copas', 'Clubs',
  ];

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: _titulos.length, vsync: this);
    // Refrescar el appbar (botón de sync) al cambiar de pestaña.
    _tabs.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  TipoCatalogo _tipoActual() {
    switch (_tabs.index) {
      case 0: return TipoCatalogo.coches;
      case 1: return TipoCatalogo.marcas;
      case 2: return TipoCatalogo.llantas;
      case 3: return TipoCatalogo.engranajes;
      case 4: return TipoCatalogo.motores;
      case 5: return TipoCatalogo.bancadas;
      case 6: return TipoCatalogo.chasis;
      case 7: return TipoCatalogo.neumaticos;
      case 8: return TipoCatalogo.copas;
      default: return TipoCatalogo.clubs;
    }
  }

  Future<void> _actualizarDesdeDrive(VinculoHoja v, TipoCatalogo tipo) async {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(const SnackBar(
      content: Text('Actualizando desde Drive…'),
      duration: Duration(seconds: 2),
    ));
    final res =
        await ref.read(actualizadorDriveProvider).actualizarCatalogo(v, tipo);
    if (!mounted) return;
    messenger.showSnackBar(SnackBar(
      content: Text(res.ok ? '✓ ${res.mensaje}' : '✗ ${res.mensaje}'),
      duration: const Duration(seconds: 5),
    ));
  }

  Future<void> _subirAlSheet(VinculoHoja v, TipoCatalogo tipo) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    messenger.showSnackBar(const SnackBar(
      content: Text('Calculando cambios para subir…'),
      duration: Duration(seconds: 2),
    ));
    try {
      final plan = await ref.read(subidorCatalogoProvider).preparar(v, tipo);
      if (!mounted) return;
      if (plan.error != null) {
        messenger.showSnackBar(SnackBar(content: Text('✗ ${plan.error}')));
        return;
      }
      navigator.push(MaterialPageRoute(
        builder: (_) => PantallaSubirSheet(plan: plan),
      ));
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  /// Exporta los 10 catálogos a un .xlsx (una pestaña por catálogo) para
  /// editarlo cómodamente en Excel y devolverlo con «Importar Excel».
  Future<void> _exportarExcel() async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      messenger.showSnackBar(const SnackBar(
          content: Text('Generando Excel…'), duration: Duration(seconds: 2)));
      final bytes = await exportarCatalogosExcel(ref.read(dbProvider));
      final sugerido =
          'catalogos-pitwall-${DateTime.now().toIso8601String().substring(0, 10)}.xlsx';

      if (Platform.isAndroid || Platform.isIOS) {
        final dir = await getApplicationDocumentsDirectory();
        final ruta = p.join(dir.path, sugerido);
        await File(ruta).writeAsBytes(bytes);
        messenger.showSnackBar(SnackBar(content: Text('Excel guardado en $ruta')));
        return;
      }

      final destino = await getSaveLocation(
        acceptedTypeGroups: [
          const XTypeGroup(label: 'Excel', extensions: ['xlsx']),
        ],
        suggestedName: sugerido,
      );
      if (destino == null) return;
      var ruta = destino.path;
      if (!ruta.toLowerCase().endsWith('.xlsx')) ruta = '$ruta.xlsx';
      await File(ruta).writeAsBytes(bytes);
      messenger.showSnackBar(SnackBar(content: Text('Catálogos exportados en $ruta')));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Error al exportar: $e')));
    }
  }

  /// Reimporta el .xlsx editado: actualiza las filas con ID y crea las que no
  /// lo tienen. Nunca borra: lo que quites de la hoja se queda en la app.
  Future<void> _importarExcel() async {
    final messenger = ScaffoldMessenger.of(context);
    final xfile = await openFile(acceptedTypeGroups: [
      const XTypeGroup(label: 'Excel', extensions: ['xlsx']),
    ]);
    if (xfile == null || !mounted) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Importar catálogos desde Excel'),
        content: const Text(
            'Se actualizarán las filas que tengan ID y se crearán las que no lo '
            'tengan.\n\nNo se borra nada: las fichas que quites de la hoja '
            'seguirán en la app.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Importar')),
        ],
      ),
    );
    if (confirmar != true) return;

    try {
      messenger.showSnackBar(const SnackBar(
          content: Text('Importando…'), duration: Duration(seconds: 2)));
      final bytes = await File(xfile.path).readAsBytes();
      final res = await importarCatalogosExcel(ref.read(dbProvider), bytes);
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Importación completada'),
          content: SingleChildScrollView(
            child: Text(
              '${res.resumen}\n\n'
              '${[
                for (final e in {...res.creados.keys, ...res.actualizados.keys})
                  '• $e: ${res.creados[e] ?? 0} nuevos, ${res.actualizados[e] ?? 0} actualizados'
              ].join('\n')}'
              '${res.hojasIgnoradas.isEmpty ? '' : '\n\n⚠ Estas pestañas no se han importado porque su nombre no coincide con ningún catálogo:\n${res.hojasIgnoradas.map((h) => '• $h').join('\n')}\nNo renombres las pestañas del fichero exportado.'}'
              '${res.errores.isEmpty ? '' : '\n\nErrores:\n${res.errores.take(10).join('\n')}'}',
            ),
          ),
          actions: [
            FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK')),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text('Error al importar: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogos'),
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Todo el catálogo en Excel',
            icon: const Icon(Icons.table_view_outlined),
            onSelected: (op) =>
                op == 'exportar' ? _exportarExcel() : _importarExcel(),
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'exportar',
                child: ListTile(
                  leading: Icon(Icons.download_outlined),
                  title: Text('Exportar todo a Excel'),
                  subtitle: Text('Una pestaña por catálogo'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'importar',
                child: ListTile(
                  leading: Icon(Icons.upload_file_outlined),
                  title: Text('Importar Excel editado'),
                  subtitle: Text('Actualiza por ID y crea los nuevos'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          Consumer(builder: (context, ref, _) {
            final tipo = _tipoActual();
            final vinculoAsync =
                ref.watch(vinculoEntidadProvider('catalogo_${tipo.name}'));
            final v = vinculoAsync.asData?.value;
            if (v == null) return const SizedBox.shrink();
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip:
                      'Bajar desde Drive (${v.fila.hojaNombre} · ${v.fila.pestanaTitulo})',
                  icon: const Icon(Icons.sync),
                  onPressed: () => _actualizarDesdeDrive(v, tipo),
                ),
                IconButton(
                  tooltip: 'Subir mis cambios al Sheet',
                  icon: const Icon(Icons.cloud_upload_outlined),
                  onPressed: () => _subirAlSheet(v, tipo),
                ),
              ],
            );
          }),
          IconButton(
            tooltip: 'Importar la pestaña actual',
            icon: const Icon(Icons.file_upload_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    PantallaImportarCatalogo(tipo: _tipoActual()),
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabs,
          isScrollable: true,
          tabs: _titulos.map((t) => Tab(text: t)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: const [
          _TabCoches(),
          _TabMarcas(),
          _TabLlantas(),
          _TabEngranajes(),
          _TabMotores(),
          _TabBancadas(),
          _TabChasis(),
          _TabNeumaticos(),
          _TabCopas(),
          _TabClubs(),
        ],
      ),
    );
  }
}

// =====================================================
// COCHES
// =====================================================
class _TabCoches extends ConsumerStatefulWidget {
  const _TabCoches();

  @override
  ConsumerState<_TabCoches> createState() => _TabCochesState();
}

class _TabCochesState extends ConsumerState<_TabCoches> {
  String _busqueda = '';
  String? _copaFiltro;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final lista = ref.watch(cochesCatalogoProvider);
    final copas = ref.watch(_copasDisponiblesProvider).asData?.value ?? const [];
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _editarCoche(context, ref, null),
        icon: const Icon(Icons.add),
        label: const Text('Coche'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Buscar coche…',
                      isDense: true,
                    ),
                    onChanged: (v) =>
                        setState(() => _busqueda = v.trim().toLowerCase()),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String?>(
                  value: _copaFiltro,
                  hint: const Text('Copa'),
                  borderRadius: BorderRadius.circular(12),
                  items: [
                    const DropdownMenuItem<String?>(
                        value: null, child: Text('Todas las copas')),
                    for (final c in copas)
                      DropdownMenuItem<String?>(value: c, child: Text(c)),
                  ],
                  onChanged: (v) => setState(() => _copaFiltro = v),
                ),
              ],
            ),
          ),
          Expanded(
            child: lista.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (xs) {
                if (xs.isEmpty) return const _Vacio(texto: 'Sin coches');
                final filtradas = xs.where((c) {
                  if (_busqueda.isNotEmpty &&
                      !'${c.nombre} ${c.marca} ${c.modelo}'
                          .toLowerCase()
                          .contains(_busqueda)) {
                    return false;
                  }
                  if (_copaFiltro != null) {
                    final cps = _decodeCopas(c.copasJson);
                    // Los coches "todos" (sin copa) aplican a todas las copas.
                    if (cps.isNotEmpty && !cps.contains(_copaFiltro)) {
                      return false;
                    }
                  }
                  return true;
                }).toList();
                if (filtradas.isEmpty) {
                  return const _Vacio(texto: 'Sin coincidencias');
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
                  itemCount: filtradas.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 4),
                  itemBuilder: (_, i) {
                    final c = filtradas[i];
              return Card(
                child: ListTile(
                  leading: c.fotoPath == null
                      ? Icon(Icons.directions_car_outlined, color: cs.primary)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 48,
                            height: 48,
                            child: FutureBuilder<File>(
                              future:
                                  FotosVerificacion.resolver(c.fotoPath!),
                              builder: (ctx, snap) {
                                final f = snap.data;
                                if (f == null || !f.existsSync()) {
                                  return Icon(Icons.directions_car_outlined,
                                      color: cs.primary);
                                }
                                return Image.file(f, fit: BoxFit.cover);
                              },
                            ),
                          ),
                        ),
                  title: Text(c.nombre,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    '${c.marca}  ·  Peso mín ${c.pesoMin.toStringAsFixed(2)}g  '
                    '·  Créd ${c.creditosCoche >= 0 ? '+' : ''}${c.creditosCoche}'
                    '\nCopas: ${_resumenCopas(_decodeCopas(c.copasJson))}',
                  ),
                  isThreeLine: true,
                  trailing: PopupMenuButton<String>(
                    onSelected: (op) async {
                      if (op == 'editar') {
                        _editarCoche(context, ref, c);
                      } else if (op == 'borrar') {
                        final ok = await _confirmarBorrar(context, c.nombre);
                        if (ok) {
                          await ref
                              .read(repoCatalogosProvider)
                              .borrarCoche(c.id);
                        }
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'editar', child: Text('Editar')),
                      PopupMenuItem(value: 'borrar', child: Text('Eliminar')),
                    ],
                  ),
                ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editarCoche(
      BuildContext context, WidgetRef ref, CatalogoCoche? c) async {
    final nombre = TextEditingController(text: c?.nombre ?? '');
    final marca = TextEditingController(text: c?.marca ?? '');
    final modelo = TextEditingController(text: c?.modelo ?? '');
    final peso = TextEditingController(
        text: c?.pesoMin.toStringAsFixed(2) ?? '17,00');
    final cred = TextEditingController(text: c?.creditosCoche.toString() ?? '0');
    final copasIniciales = c == null ? <String>{} : _decodeCopas(c.copasJson).toSet();
    final foto = ValueNotifier<String?>(c?.fotoPath);

    final res = await showDialog<({bool ok, Set<String> copas})>(
      context: context,
      builder: (_) {
        return _DialogoCocheBancada(
          titulo: c == null ? 'Nuevo coche' : 'Editar coche',
          copasIniciales: copasIniciales,
          contenidoExtra: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SelectorFotoCoche(foto: foto),
              const SizedBox(height: 8),
              TextField(
                controller: nombre,
                decoration: const InputDecoration(
                    labelText: 'Nombre completo *',
                    helperText: 'Ej: SCALEAUTO-BMW M8 GTE'),
              ),
              TextField(
                controller: marca,
                decoration: const InputDecoration(labelText: 'Marca *'),
              ),
              TextField(
                controller: modelo,
                decoration: const InputDecoration(labelText: 'Modelo *'),
              ),
              TextField(
                controller: peso,
                decoration:
                    const InputDecoration(labelText: 'Peso mínimo (g) *'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              TextField(
                controller: cred,
                decoration: const InputDecoration(
                    labelText: 'Créditos coche',
                    helperText: 'Negativo o positivo'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        );
      },
    );
    if (res == null || !res.ok) return;
    final pesoNum =
        double.tryParse(peso.text.trim().replaceAll(',', '.')) ?? 17.0;
    final credNum = int.tryParse(cred.text.trim()) ?? 0;
    final copasJson = json.encode(res.copas.toList());
    final repo = ref.read(repoCatalogosProvider);
    if (c == null) {
      await repo.crearCoche(
        nombre: nombre.text.trim(),
        marca: marca.text.trim(),
        modelo: modelo.text.trim(),
        pesoMin: pesoNum,
        creditosCoche: credNum,
        copasJson: copasJson,
        fotoPath: foto.value,
      );
    } else {
      await repo.actualizarCoche(
        c.id,
        CatalogoCochesCompanion(
          nombre: Value(nombre.text.trim()),
          marca: Value(marca.text.trim()),
          modelo: Value(modelo.text.trim()),
          pesoMin: Value(pesoNum),
          creditosCoche: Value(credNum),
          copasJson: Value(copasJson),
          fotoPath: Value(foto.value),
        ),
      );
    }
  }
}

/// Selector de foto del coche (galería o cámara) con miniatura.
class _SelectorFotoCoche extends StatelessWidget {
  const _SelectorFotoCoche({required this.foto});
  final ValueNotifier<String?> foto;

  Future<void> _elegir(BuildContext context, ImageSource src) async {
    try {
      final xfile = await ImagePicker().pickImage(
        source: src,
        imageQuality: 75,
        maxWidth: 1600,
      );
      if (xfile == null) return;
      final dir = await FotosVerificacion.carpeta();
      final ts = DateTime.now().millisecondsSinceEpoch;
      final ext = p.extension(xfile.path).isEmpty ? '.jpg' : p.extension(xfile.path);
      final nombre = 'coche-$ts$ext';
      await File(xfile.path).copy(p.join(dir.path, nombre));
      foto.value = nombre;
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo añadir la foto: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ValueListenableBuilder<String?>(
      valueListenable: foto,
      builder: (context, path, _) {
        return Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 72,
                height: 72,
                child: path == null
                    ? Container(
                        color: cs.surfaceContainerHighest,
                        child: Icon(Icons.directions_car_outlined,
                            color: cs.outline, size: 32),
                      )
                    : FutureBuilder<File>(
                        future: FotosVerificacion.resolver(path),
                        builder: (ctx, snap) {
                          final f = snap.data;
                          if (f == null || !f.existsSync()) {
                            return Container(
                              color: cs.surfaceContainerHighest,
                              child: const Icon(Icons.broken_image_outlined),
                            );
                          }
                          return Image.file(f, fit: BoxFit.cover);
                        },
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _elegir(context, ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined, size: 18),
                    label: const Text('Galería'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _elegir(context, ImageSource.camera),
                    icon: const Icon(Icons.camera_alt_outlined, size: 18),
                    label: const Text('Cámara'),
                  ),
                  if (path != null)
                    IconButton(
                      tooltip: 'Quitar foto',
                      onPressed: () => foto.value = null,
                      icon: const Icon(Icons.delete_outline),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Diálogo reutilizable que añade un multi-selector de copas al final.
class _DialogoCocheBancada extends ConsumerStatefulWidget {
  const _DialogoCocheBancada({
    required this.titulo,
    required this.copasIniciales,
    required this.contenidoExtra,
  });
  final String titulo;
  final Set<String> copasIniciales;
  final Widget contenidoExtra;

  @override
  ConsumerState<_DialogoCocheBancada> createState() =>
      _DialogoCocheBancadaState();
}

class _DialogoCocheBancadaState extends ConsumerState<_DialogoCocheBancada> {
  late Set<String> _copas;

  @override
  void initState() {
    super.initState();
    _copas = {...widget.copasIniciales};
  }

  @override
  Widget build(BuildContext context) {
    final disponibles = ref.watch(_copasDisponiblesProvider);
    return AlertDialog(
      title: Text(widget.titulo),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.contenidoExtra,
              const SizedBox(height: 16),
              Text('Copas donde aplica',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.primary)),
              const SizedBox(height: 4),
              Text(
                _copas.isEmpty
                    ? 'Sin marcar = aplica a todas las copas.'
                    : 'Marca solo las copas donde es válido.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              disponibles.when(
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('$e'),
                data: (lista) {
                  final todas = {...lista, ..._copas}.toList()..sort();
                  return Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: todas
                        .map((c) => FilterChip(
                              label: Text(c),
                              selected: _copas.contains(c),
                              onSelected: (v) => setState(() {
                                if (v) {
                                  _copas.add(c);
                                } else {
                                  _copas.remove(c);
                                }
                              }),
                            ))
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () =>
                Navigator.pop(context, (ok: false, copas: _copas)),
            child: const Text('Cancelar')),
        FilledButton(
            onPressed: () =>
                Navigator.pop(context, (ok: true, copas: _copas)),
            child: const Text('Guardar')),
      ],
    );
  }
}

// =====================================================
// MARCAS
// =====================================================
class _TabMarcas extends ConsumerWidget {
  const _TabMarcas();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _ListaCatalogo<CatalogoMarca>(
      datos: ref.watch(marcasCatalogoProvider),
      vacio: 'Sin marcas',
      textoBuscable: (m) => '${m.codigo} ${m.nombre}',
      fab: FloatingActionButton.extended(
        onPressed: () => _editar(context, ref, null),
        icon: const Icon(Icons.add),
        label: const Text('Marca'),
      ),
      item: (m) => Card(
        child: ListTile(
          leading: CircleAvatar(child: Text(m.codigo)),
          title: Text(m.nombre),
          trailing: PopupMenuButton<String>(
            onSelected: (op) async {
              if (op == 'editar') {
                _editar(context, ref, m);
              } else if (op == 'borrar') {
                final ok = await _confirmarBorrar(context, m.nombre);
                if (ok) {
                  await ref.read(repoCatalogosProvider).borrarMarca(m.id);
                }
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'editar', child: Text('Editar')),
              PopupMenuItem(value: 'borrar', child: Text('Eliminar')),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _editar(
      BuildContext context, WidgetRef ref, CatalogoMarca? m) async {
    final codigo = TextEditingController(text: m?.codigo ?? '');
    final nombre = TextEditingController(text: m?.nombre ?? '');
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(m == null ? 'Nueva marca' : 'Editar marca'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: codigo,
              decoration: const InputDecoration(
                  labelText: 'Código *', helperText: 'Ej: SIT, SCA, SLP'),
              textCapitalization: TextCapitalization.characters,
            ),
            TextField(
              controller: nombre,
              decoration: const InputDecoration(labelText: 'Nombre completo *'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Guardar')),
        ],
      ),
    );
    if (ok != true) return;
    final repo = ref.read(repoCatalogosProvider);
    if (m == null) {
      await repo.crearMarca(codigo.text.trim(), nombre.text.trim());
    } else {
      await repo.actualizarMarca(m.id, codigo.text.trim(), nombre.text.trim());
    }
  }
}

// =====================================================
// LLANTAS
// =====================================================
class _TabLlantas extends ConsumerWidget {
  const _TabLlantas();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final copas = ref.watch(_copasDisponiblesProvider).asData?.value ?? const [];
    return _ListaCatalogo<CatalogoLlanta>(
      datos: ref.watch(llantasCatalogoProvider),
      vacio: 'Sin llantas',
      textoBuscable: (l) => '${l.dimension} ${l.tipo}',
      copasJsonDe: (l) => l.copasJson,
      copas: copas,
      fab: FloatingActionButton.extended(
        heroTag: 'fab_llantas',
        onPressed: () => _editar(context, ref, null),
        icon: const Icon(Icons.add),
        label: const Text('Llanta'),
      ),
      item: (l) => Card(
        child: ListTile(
          leading: Icon(
            l.tipo == 'DELANTERA'
                ? Icons.arrow_upward
                : l.tipo == 'TRASERA'
                    ? Icons.arrow_downward
                    : Icons.swap_vert,
            color: cs.primary,
          ),
          title: Text(l.dimension),
          subtitle: Text(
            '${l.tipo}'
            '\nCopas: ${_resumenCopas(_decodeCopas(l.copasJson))}',
          ),
          isThreeLine: true,
          trailing: PopupMenuButton<String>(
            onSelected: (op) async {
              if (op == 'editar') {
                _editar(context, ref, l);
              } else if (op == 'borrar') {
                final ok = await _confirmarBorrar(context, l.dimension);
                if (ok) {
                  await ref.read(repoCatalogosProvider).borrarLlanta(l.id);
                }
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'editar', child: Text('Editar')),
              PopupMenuItem(value: 'borrar', child: Text('Eliminar')),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _editar(
      BuildContext context, WidgetRef ref, CatalogoLlanta? l) async {
    final dim = TextEditingController(text: l?.dimension ?? '');
    String tipo = l?.tipo ?? 'DELANTERA';
    final copasIni = l == null ? <String>{} : _decodeCopas(l.copasJson).toSet();
    final res = await showDialog<({bool ok, Set<String> copas})>(
      context: context,
      builder: (_) => _DialogoCocheBancada(
        titulo: l == null ? 'Nueva llanta' : 'Editar llanta',
        copasIniciales: copasIni,
        contenidoExtra: StatefulBuilder(
          builder: (ctx, setSt) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: dim,
                decoration: const InputDecoration(
                    labelText: 'Dimensión *',
                    helperText: 'Ej: 15,8 x 8 PL'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: tipo,
                decoration: const InputDecoration(labelText: 'Tipo'),
                items: const [
                  DropdownMenuItem(value: 'DELANTERA', child: Text('Delantera')),
                  DropdownMenuItem(value: 'TRASERA', child: Text('Trasera')),
                  DropdownMenuItem(value: 'AMBAS', child: Text('Ambas')),
                ],
                onChanged: (v) => setSt(() => tipo = v ?? 'DELANTERA'),
              ),
            ],
          ),
        ),
      ),
    );
    if (res == null || !res.ok) return;
    final d = dim.text.trim();
    if (d.isEmpty) return;
    final copasJson = json.encode(res.copas.toList());
    final repo = ref.read(repoCatalogosProvider);
    if (l == null) {
      await repo.crearLlanta(d, tipo, copasJson: copasJson);
    } else {
      await repo.actualizarLlanta(l.id, d, tipo, copasJson: copasJson);
    }
  }
}

// =====================================================
// ENGRANAJES (piñones y coronas)
// =====================================================

class _TabEngranajes extends ConsumerWidget {
  const _TabEngranajes();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final copas = ref.watch(_copasDisponiblesProvider).asData?.value ?? const [];
    return _ListaCatalogo<CatalogoEngranaje>(
      datos: ref.watch(engranajesCatalogoProvider),
      vacio: 'Sin engranajes',
      textoBuscable: (g) => '${g.marca} ${g.dientes} ${g.tipo}',
      copasJsonDe: (g) => g.copasJson,
      copas: copas,
      fab: FloatingActionButton.extended(
        heroTag: 'fab_engranajes',
        onPressed: () => _editar(context, ref, null),
        icon: const Icon(Icons.add),
        label: const Text('Engranaje'),
      ),
      item: (g) => Card(
        child: ListTile(
          leading: Icon(
            g.tipo == 'PINON'
                ? Icons.settings_outlined
                : Icons.album_outlined,
            color: cs.primary,
          ),
          title: Text('${g.marca} · ${g.dientes} dientes'),
          subtitle: Text(
            '${g.tipo == 'PINON' ? 'Piñón' : 'Corona'}'
            '\nCopas: ${_resumenCopas(_decodeCopas(g.copasJson))}',
          ),
          isThreeLine: true,
          trailing: PopupMenuButton<String>(
            onSelected: (op) async {
              if (op == 'editar') {
                _editar(context, ref, g);
              } else if (op == 'borrar') {
                final ok = await _confirmarBorrar(
                    context, '${g.marca} ${g.dientes}d');
                if (ok) {
                  await ref.read(repoCatalogosProvider).borrarEngranaje(g.id);
                }
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'editar', child: Text('Editar')),
              PopupMenuItem(value: 'borrar', child: Text('Eliminar')),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _editar(
      BuildContext context, WidgetRef ref, CatalogoEngranaje? g) async {
    final marca = TextEditingController(text: g?.marca ?? '');
    final dientes = TextEditingController(text: g?.dientes.toString() ?? '');
    String tipo = g?.tipo ?? 'PINON';
    final copasIni = g == null ? <String>{} : _decodeCopas(g.copasJson).toSet();
    final res = await showDialog<({bool ok, Set<String> copas})>(
      context: context,
      builder: (_) => _DialogoCocheBancada(
        titulo: g == null ? 'Nuevo engranaje' : 'Editar engranaje',
        copasIniciales: copasIni,
        contenidoExtra: StatefulBuilder(
          builder: (ctx, setSt) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: tipo,
                decoration: const InputDecoration(labelText: 'Tipo'),
                items: const [
                  DropdownMenuItem(value: 'PINON', child: Text('Piñón')),
                  DropdownMenuItem(value: 'CORONA', child: Text('Corona')),
                ],
                onChanged: (v) => setSt(() => tipo = v ?? 'PINON'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: marca,
                decoration: const InputDecoration(
                    labelText: 'Marca *', helperText: 'Ej: Slot.it, Scaleauto'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: dientes,
                decoration: const InputDecoration(
                    labelText: 'Dientes *',
                    helperText: 'Ej: 12 piñón, 28 corona'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
    );
    if (res == null || !res.ok) return;
    final m = marca.text.trim();
    final d = int.tryParse(dientes.text.trim());
    if (m.isEmpty || d == null) return;
    final copasJson = json.encode(res.copas.toList());
    final repo = ref.read(repoCatalogosProvider);
    if (g == null) {
      await repo.crearEngranaje(
          tipo: tipo, marca: m, dientes: d, copasJson: copasJson);
    } else {
      await repo.actualizarEngranaje(g.id, tipo, m, d, copasJson: copasJson);
    }
  }
}

// =====================================================
// MOTORES (con copas)
// =====================================================

class _TabMotores extends ConsumerWidget {
  const _TabMotores();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final copas = ref.watch(_copasDisponiblesProvider).asData?.value ?? const [];
    return _ListaCatalogo<CatalogoMotore>(
      datos: ref.watch(motoresCatalogoProvider),
      vacio: 'Sin motores',
      textoBuscable: (mo) => mo.nombre,
      copasJsonDe: (mo) => mo.copasJson,
      copas: copas,
      fab: FloatingActionButton.extended(
        heroTag: 'fab_motores',
        onPressed: () => _editar(context, ref, null),
        icon: const Icon(Icons.add),
        label: const Text('Motor'),
      ),
      item: (mo) {
        final medidas = [
          if (mo.rpm != null) '${mo.rpm} RPM',
          if (mo.gauss != null) '${mo.gauss} gauss',
        ].join(' · ');
        return Card(
          child: ListTile(
            leading: Icon(Icons.bolt_outlined, color: cs.primary),
            title: Text(mo.nombre,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(
              '${medidas.isEmpty ? 'Sin medidas' : medidas}'
              '\nCopas: ${_resumenCopas(_decodeCopas(mo.copasJson))}',
            ),
            isThreeLine: true,
            trailing: PopupMenuButton<String>(
              onSelected: (op) async {
                if (op == 'editar') {
                  _editar(context, ref, mo);
                } else if (op == 'borrar') {
                  final ok = await _confirmarBorrar(context, mo.nombre);
                  if (ok) {
                    await ref.read(repoCatalogosProvider).borrarMotor(mo.id);
                  }
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'editar', child: Text('Editar')),
                PopupMenuItem(value: 'borrar', child: Text('Eliminar')),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _editar(
      BuildContext context, WidgetRef ref, CatalogoMotore? mo) async {
    final nombre = TextEditingController(text: mo?.nombre ?? '');
    final rpm = TextEditingController(text: mo?.rpm?.toString() ?? '');
    final gauss = TextEditingController(text: mo?.gauss?.toString() ?? '');
    final copasIniciales =
        mo == null ? <String>{} : _decodeCopas(mo.copasJson).toSet();

    final res = await showDialog<({bool ok, Set<String> copas})>(
      context: context,
      builder: (_) => _DialogoCocheBancada(
        titulo: mo == null ? 'Nuevo motor' : 'Editar motor',
        copasIniciales: copasIniciales,
        contenidoExtra: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombre,
              decoration: const InputDecoration(
                  labelText: 'Motor *', helperText: 'Identificador o modelo'),
            ),
            TextField(
              controller: rpm,
              decoration: const InputDecoration(labelText: 'RPM'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: gauss,
              decoration: const InputDecoration(labelText: 'Gauss'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
      ),
    );
    if (res == null || !res.ok) return;
    final n = nombre.text.trim();
    if (n.isEmpty) return;
    final rpmNum = int.tryParse(rpm.text.trim());
    final gaussNum =
        double.tryParse(gauss.text.trim().replaceAll(',', '.'));
    final copasJson = json.encode(res.copas.toList());
    final repo = ref.read(repoCatalogosProvider);
    if (mo == null) {
      await repo.crearMotor(
          nombre: n, rpm: rpmNum, gauss: gaussNum, copasJson: copasJson);
    } else {
      await repo.actualizarMotor(
        mo.id,
        CatalogoMotoresCompanion(
          nombre: Value(n),
          rpm: Value(rpmNum),
          gauss: Value(gaussNum),
          copasJson: Value(copasJson),
        ),
      );
    }
  }
}

// =====================================================
// CHASIS (con copas, similar a bancadas)
// =====================================================
class _TabChasis extends ConsumerWidget {
  const _TabChasis();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copas = ref.watch(_copasDisponiblesProvider).asData?.value ?? const [];
    return _ListaCatalogo<CatalogoChasi>(
      datos: ref.watch(chasisCatalogoProvider),
      vacio: 'Sin chasis',
      textoBuscable: (c) => c.nombre,
      copasJsonDe: (c) => c.copasJson,
      copas: copas,
      fab: FloatingActionButton.extended(
        onPressed: () => _editar(context, ref, null),
        icon: const Icon(Icons.add),
        label: const Text('Chasis'),
      ),
      item: (c) => Card(
        child: ListTile(
          title: Text(c.nombre),
          subtitle:
              Text('Copas: ${_resumenCopas(_decodeCopas(c.copasJson))}'),
          trailing: PopupMenuButton<String>(
            onSelected: (op) async {
              if (op == 'editar') {
                _editar(context, ref, c);
              } else if (op == 'borrar') {
                final ok = await _confirmarBorrar(context, c.nombre);
                if (ok) {
                  await ref.read(repoCatalogosProvider).borrarChasis(c.id);
                }
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'editar', child: Text('Editar')),
              PopupMenuItem(value: 'borrar', child: Text('Eliminar')),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _editar(
      BuildContext context, WidgetRef ref, CatalogoChasi? c) async {
    final nombre = TextEditingController(text: c?.nombre ?? '');
    final copasIni = c == null ? <String>{} : _decodeCopas(c.copasJson).toSet();
    final res = await showDialog<({bool ok, Set<String> copas})>(
      context: context,
      builder: (_) => _DialogoCocheBancada(
        titulo: c == null ? 'Nuevo chasis' : 'Editar chasis',
        copasIniciales: copasIni,
        contenidoExtra: TextField(
          controller: nombre,
          autofocus: true,
          decoration: const InputDecoration(
              labelText: 'Nombre *', helperText: 'Ej: SCALEAUTO 0,5'),
        ),
      ),
    );
    if (res == null || !res.ok || nombre.text.trim().isEmpty) return;
    final repo = ref.read(repoCatalogosProvider);
    final copasJson = json.encode(res.copas.toList());
    if (c == null) {
      await repo.crearChasis(nombre.text.trim());
      final lista = await repo.db.select(repo.db.catalogoChasis).get();
      final creado = lista.lastWhere((x) => x.nombre == nombre.text.trim());
      await (repo.db.update(repo.db.catalogoChasis)
            ..where((t) => t.id.equals(creado.id)))
          .write(CatalogoChasisCompanion(copasJson: Value(copasJson)));
    } else {
      await (repo.db.update(repo.db.catalogoChasis)
            ..where((t) => t.id.equals(c.id)))
          .write(CatalogoChasisCompanion(
              nombre: Value(nombre.text.trim()),
              copasJson: Value(copasJson)));
    }
  }
}

// =====================================================
// SIMPLES (Bancadas / Neumáticos / Copas / Clubs)
// =====================================================
class _TabBancadas extends ConsumerWidget {
  const _TabBancadas();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copas = ref.watch(_copasDisponiblesProvider).asData?.value ?? const [];
    return _ListaCatalogo<CatalogoBancada>(
      datos: ref.watch(bancadasCatalogoProvider),
      vacio: 'Sin bancadas',
      textoBuscable: (b) => b.nombre,
      copasJsonDe: (b) => b.copasJson,
      copas: copas,
      fab: FloatingActionButton.extended(
        onPressed: () => _editar(context, ref, null),
        icon: const Icon(Icons.add),
        label: const Text('Bancada'),
      ),
      item: (b) => Card(
        child: ListTile(
          title: Text(b.nombre),
          subtitle:
              Text('Copas: ${_resumenCopas(_decodeCopas(b.copasJson))}'),
          trailing: PopupMenuButton<String>(
            onSelected: (op) async {
              if (op == 'editar') {
                _editar(context, ref, b);
              } else if (op == 'borrar') {
                final ok = await _confirmarBorrar(context, b.nombre);
                if (ok) {
                  await ref.read(repoCatalogosProvider).borrarBancada(b.id);
                }
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'editar', child: Text('Editar')),
              PopupMenuItem(value: 'borrar', child: Text('Eliminar')),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _editar(
      BuildContext context, WidgetRef ref, CatalogoBancada? b) async {
    final nombre = TextEditingController(text: b?.nombre ?? '');
    final copasIni = b == null ? <String>{} : _decodeCopas(b.copasJson).toSet();
    final res = await showDialog<({bool ok, Set<String> copas})>(
      context: context,
      builder: (_) => _DialogoCocheBancada(
        titulo: b == null ? 'Nueva bancada' : 'Editar bancada',
        copasIniciales: copasIni,
        contenidoExtra: TextField(
          controller: nombre,
          autofocus: true,
          decoration: const InputDecoration(
              labelText: 'Nombre *', helperText: 'Ej: Slot.it 1,0 carbono'),
        ),
      ),
    );
    if (res == null || !res.ok || nombre.text.trim().isEmpty) return;
    final repo = ref.read(repoCatalogosProvider);
    final copasJson = json.encode(res.copas.toList());
    if (b == null) {
      await repo.crearBancada(nombre.text.trim());
      final lista = await repo.db.select(repo.db.catalogoBancadas).get();
      final creado = lista.lastWhere((x) => x.nombre == nombre.text.trim());
      await (repo.db.update(repo.db.catalogoBancadas)
            ..where((t) => t.id.equals(creado.id)))
          .write(CatalogoBancadasCompanion(copasJson: Value(copasJson)));
    } else {
      await (repo.db.update(repo.db.catalogoBancadas)
            ..where((t) => t.id.equals(b.id)))
          .write(CatalogoBancadasCompanion(
              nombre: Value(nombre.text.trim()),
              copasJson: Value(copasJson)));
    }
  }
}

class _TabNeumaticos extends ConsumerWidget {
  const _TabNeumaticos();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copas = ref.watch(_copasDisponiblesProvider).asData?.value ?? const [];
    return _ListaCatalogo<CatalogoNeumatico>(
      datos: ref.watch(neumaticosCatalogoProvider),
      vacio: 'Sin neumáticos',
      textoBuscable: (n) => '${n.nombre} ${n.referencia ?? ''}',
      copasJsonDe: (n) => n.copasJson,
      copas: copas,
      fab: FloatingActionButton.extended(
        onPressed: () => _editar(context, ref, null),
        icon: const Icon(Icons.add),
        label: const Text('Neumático'),
      ),
      item: (n) => Card(
        child: ListTile(
          leading: const Icon(Icons.circle_outlined),
          title: Text(n.nombre),
          subtitle: Text(
            '${n.referencia ?? 'Sin referencia'}'
            '\nCopas: ${_resumenCopas(_decodeCopas(n.copasJson))}',
          ),
          isThreeLine: true,
          trailing: PopupMenuButton<String>(
            onSelected: (op) async {
              if (op == 'editar') {
                _editar(context, ref, n);
              } else if (op == 'borrar') {
                final ok = await _confirmarBorrar(context, n.nombre);
                if (ok) {
                  await ref.read(repoCatalogosProvider).borrarNeumatico(n.id);
                }
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'editar', child: Text('Editar')),
              PopupMenuItem(value: 'borrar', child: Text('Eliminar')),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _editar(
      BuildContext context, WidgetRef ref, CatalogoNeumatico? n) async {
    final nombre = TextEditingController(text: n?.nombre ?? '');
    final ref_ = TextEditingController(text: n?.referencia ?? '');
    final copasIni = n == null ? <String>{} : _decodeCopas(n.copasJson).toSet();
    final res = await showDialog<({bool ok, Set<String> copas})>(
      context: context,
      builder: (_) => _DialogoCocheBancada(
        titulo: n == null ? 'Nuevo neumático' : 'Editar neumático',
        copasIniciales: copasIni,
        contenidoExtra: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nombre,
                decoration: const InputDecoration(
                    labelText: 'Nombre *',
                    helperText: 'Ej: AS25 19,0 NEGRO')),
            TextField(
                controller: ref_,
                decoration:
                    const InputDecoration(labelText: 'Referencia (opcional)')),
          ],
        ),
      ),
    );
    if (res == null || !res.ok) return;
    final repo = ref.read(repoCatalogosProvider);
    final r = ref_.text.trim().isEmpty ? null : ref_.text.trim();
    final copasJson = json.encode(res.copas.toList());
    if (n == null) {
      await repo.crearNeumatico(nombre.text.trim(), r, copasJson: copasJson);
    } else {
      await repo.actualizarNeumatico(n.id, nombre.text.trim(), r,
          copasJson: copasJson);
    }
  }
}

class _TabCopas extends ConsumerWidget {
  const _TabCopas();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _SimpleTab(
      vacio: 'Sin copas',
      botonLabel: 'Copa',
      observar: (r) => r.watch(copasCatalogoProvider),
      titulo: (b) => b.nombre,
      onCrear: (txt) => ref.read(repoCatalogosProvider).crearCopa(txt),
      onEditar: (item, txt) =>
          ref.read(repoCatalogosProvider).actualizarCopa(item.id, txt),
      onBorrar: (item) =>
          ref.read(repoCatalogosProvider).borrarCopa(item.id),
      hint: 'Ej: GT, GT2, LMP, HYP',
    );
  }
}

class _TabClubs extends ConsumerWidget {
  const _TabClubs();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _SimpleTab(
      vacio: 'Sin clubs',
      botonLabel: 'Club',
      observar: (r) => r.watch(clubsCatalogoProvider),
      titulo: (b) => b.nombre,
      onCrear: (txt) => ref.read(repoCatalogosProvider).crearClub(txt),
      onEditar: (item, txt) =>
          ref.read(repoCatalogosProvider).actualizarClub(item.id, txt),
      onBorrar: (item) =>
          ref.read(repoCatalogosProvider).borrarClub(item.id),
      hint: 'Ej: EL SOT, GASCLAVAT, SLOTMANIA',
    );
  }
}

// =====================================================
// HELPERS
// =====================================================
class _SimpleTab<T> extends ConsumerStatefulWidget {
  const _SimpleTab({
    required this.vacio,
    required this.botonLabel,
    required this.observar,
    required this.titulo,
    required this.onCrear,
    required this.onEditar,
    required this.onBorrar,
    required this.hint,
  });

  final String vacio;
  final String botonLabel;
  final AsyncValue<List<T>> Function(WidgetRef) observar;
  final String Function(T) titulo;
  final Future<void> Function(String) onCrear;
  final Future<void> Function(T, String) onEditar;
  final Future<void> Function(T) onBorrar;
  final String hint;

  @override
  ConsumerState<_SimpleTab<T>> createState() => _SimpleTabState<T>();
}

class _SimpleTabState<T> extends ConsumerState<_SimpleTab<T>> {
  String _busqueda = '';

  @override
  Widget build(BuildContext context) {
    final lista = widget.observar(ref);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _editar(context, null),
        icon: const Icon(Icons.add),
        label: Text(widget.botonLabel),
      ),
      body: lista.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (xs) {
          final filtrados = _busqueda.isEmpty
              ? xs
              : xs
                  .where((x) =>
                      widget.titulo(x).toLowerCase().contains(_busqueda))
                  .toList();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                child: TextField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Buscar…',
                    isDense: true,
                  ),
                  onChanged: (v) =>
                      setState(() => _busqueda = v.trim().toLowerCase()),
                ),
              ),
              Expanded(
                child: filtrados.isEmpty
                    ? _Vacio(
                        texto: xs.isEmpty ? widget.vacio : 'Sin coincidencias')
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
                        itemCount: filtrados.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 4),
                        itemBuilder: (_, i) {
                          final x = filtrados[i];
                          return Card(
                            child: ListTile(
                              title: Text(widget.titulo(x)),
                              trailing: PopupMenuButton<String>(
                                onSelected: (op) async {
                                  if (op == 'editar') {
                                    _editar(context, x);
                                  } else if (op == 'borrar') {
                                    final ok = await _confirmarBorrar(
                                        context, widget.titulo(x));
                                    if (ok) await widget.onBorrar(x);
                                  }
                                },
                                itemBuilder: (_) => const [
                                  PopupMenuItem(
                                      value: 'editar', child: Text('Editar')),
                                  PopupMenuItem(
                                      value: 'borrar', child: Text('Eliminar')),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _editar(BuildContext context, T? item) async {
    final t =
        TextEditingController(text: item == null ? '' : widget.titulo(item));
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(item == null ? 'Nuevo ${widget.botonLabel}' : 'Editar'),
        content: TextField(
          controller: t,
          autofocus: true,
          decoration:
              InputDecoration(labelText: 'Nombre *', helperText: widget.hint),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Guardar')),
        ],
      ),
    );
    if (ok != true || t.text.trim().isEmpty) return;
    if (item == null) {
      await widget.onCrear(t.text.trim());
    } else {
      await widget.onEditar(item, t.text.trim());
    }
  }
}

class _Vacio extends StatelessWidget {
  const _Vacio({required this.texto});
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          '$texto.\nPulsa el + para añadir.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).colorScheme.outline),
        ),
      ),
    );
  }
}

Future<bool> _confirmarBorrar(BuildContext context, String nombre) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Eliminar'),
      content: Text('¿Eliminar "$nombre"?'),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar')),
        FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar')),
      ],
    ),
  );
  return ok ?? false;
}
