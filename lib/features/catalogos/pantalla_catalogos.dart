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

import '../../core/idioma.dart';
import '../../core/proveedores.dart';
import '../../data/database/app_database.dart';
import '../../services/excel_catalogos.dart';
import '../../services/exportar_pdf.dart';
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

String _resumenCopas(Textos l, List<String> copas) {
  if (copas.isEmpty) return l.sinCopaCategoria;
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
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: context.l.buscarPuntos,
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
                    hint: Text(context.l.copa),
                    borderRadius: BorderRadius.circular(12),
                    items: [
                      DropdownMenuItem<String?>(
                          value: null, child: Text(context.l.todas)),
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
              error: (e, _) => Center(child: Text(context.l.errorDetalle('$e'))),
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
                  return _Vacio(texto: context.l.sinCoincidencias);
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

  static const _numTabs = 10;

  List<String> _titulos(Textos l) => [
        l.coches,
        l.marcas,
        l.llantas,
        l.engranajes,
        l.motores,
        l.bancadas,
        l.chasis,
        l.neumaticos,
        l.copas,
        l.clubs,
      ];

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: _numTabs, vsync: this);
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
    final l = context.l;
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(SnackBar(
      content: Text(l.actualizandoDesdeDrive),
      duration: const Duration(seconds: 2),
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
    final l = context.l;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    messenger.showSnackBar(SnackBar(
      content: Text(l.calculandoCambiosSubir),
      duration: const Duration(seconds: 2),
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
      messenger.showSnackBar(SnackBar(content: Text(l.errorDetalle('$e'))));
    }
  }

  /// Exporta los 10 catálogos a un .xlsx (una pestaña por catálogo) para
  /// editarlo cómodamente en Excel y devolverlo con «Importar Excel».
  Future<void> _exportarExcel() => guardarExcel(
        context,
        sugerido:
            'catalogos-pitwall-${DateTime.now().toIso8601String().substring(0, 10)}.xlsx',
        generar: () => exportarCatalogosExcel(ref.read(dbProvider), l: context.l),
      );

  /// Reimporta el .xlsx editado: actualiza las filas con ID y crea las que no
  /// lo tienen. Nunca borra: lo que quites de la hoja se queda en la app.
  Future<void> _importarExcel() async {
    final l = context.l;
    final messenger = ScaffoldMessenger.of(context);
    final xfile = await openFile(acceptedTypeGroups: [
      const XTypeGroup(label: 'Excel', extensions: ['xlsx']),
    ]);
    if (xfile == null || !mounted) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.importarCatalogosExcelTitulo),
        content: Text(l.importarCatalogosExcelTexto),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l.cancelar)),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l.importar)),
        ],
      ),
    );
    if (confirmar != true) return;

    try {
      messenger.showSnackBar(SnackBar(
          content: Text(l.importando), duration: const Duration(seconds: 2)));
      final bytes = await File(xfile.path).readAsBytes();
      final res = await importarCatalogosExcel(ref.read(dbProvider), bytes,
          l: l);
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(l.importacionCompletada),
          content: SingleChildScrollView(
            child: Text(
              '${l.resumenCreadosActualizados(res.totalCreados, res.totalActualizados)}\n\n'
              '${[
                for (final e in {...res.creados.keys, ...res.actualizados.keys})
                  l.catalogoImportadoLinea(
                      e, res.creados[e] ?? 0, res.actualizados[e] ?? 0)
              ].join('\n')}'
              '${res.hojasIgnoradas.isEmpty ? '' : '\n\n${l.pestanasIgnoradasAviso(res.hojasIgnoradas.map((h) => '• $h').join('\n'))}'}'
              '${res.errores.isEmpty ? '' : '\n\n${l.erroresEtiqueta(res.errores.take(10).join('\n'))}'}',
            ),
          ),
          actions: [
            FilledButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l.ok)),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      messenger
          .showSnackBar(SnackBar(content: Text(l.errorAlImportar('$e'))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l.menuCatalogos),
        actions: [
          PopupMenuButton<String>(
            tooltip: context.l.todoCatalogoExcel,
            icon: const Icon(Icons.table_view_outlined),
            onSelected: (op) =>
                op == 'exportar' ? _exportarExcel() : _importarExcel(),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'exportar',
                child: ListTile(
                  leading: const Icon(Icons.download_outlined),
                  title: Text(context.l.exportarTodoExcel),
                  subtitle: Text(context.l.unaPestanaPorCatalogo),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'importar',
                child: ListTile(
                  leading: const Icon(Icons.upload_file_outlined),
                  title: Text(context.l.importarExcelEditado),
                  subtitle: Text(context.l.actualizaPorIdCreaNuevos),
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
                  tooltip: context.l.bajarDesdeDriveCon(
                      v.fila.hojaNombre, v.fila.pestanaTitulo),
                  icon: const Icon(Icons.sync),
                  onPressed: () => _actualizarDesdeDrive(v, tipo),
                ),
                IconButton(
                  tooltip: context.l.subirMisCambiosSheet,
                  icon: const Icon(Icons.cloud_upload_outlined),
                  onPressed: () => _subirAlSheet(v, tipo),
                ),
              ],
            );
          }),
          IconButton(
            tooltip: context.l.importarPestanaActual,
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
          tabs: _titulos(context.l).map((t) => Tab(text: t)).toList(),
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
        heroTag: 'fab_coches',
        onPressed: () => _editarCoche(context, ref, null),
        icon: const Icon(Icons.add),
        label: Text(context.l.coche),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: context.l.buscarCochePuntos,
                      isDense: true,
                    ),
                    onChanged: (v) =>
                        setState(() => _busqueda = v.trim().toLowerCase()),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String?>(
                  value: _copaFiltro,
                  hint: Text(context.l.copa),
                  borderRadius: BorderRadius.circular(12),
                  items: [
                    DropdownMenuItem<String?>(
                        value: null, child: Text(context.l.todasLasCopas)),
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
              error: (e, _) => Center(child: Text(context.l.errorDetalle('$e'))),
              data: (xs) {
                if (xs.isEmpty) return _Vacio(texto: context.l.sinCoches);
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
                  return _Vacio(texto: context.l.sinCoincidencias);
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
                    '${c.marca}  ·  '
                    '${context.l.pesoYCreditos(c.pesoMin.toStringAsFixed(2), '${c.creditosCoche >= 0 ? '+' : ''}${c.creditosCoche}')}'
                    '\n${context.l.copasEtiqueta(_resumenCopas(context.l, _decodeCopas(c.copasJson)))}',
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
                    itemBuilder: (_) => [
                      PopupMenuItem(value: 'editar', child: Text(context.l.editar)),
                      PopupMenuItem(value: 'borrar', child: Text(context.l.eliminar)),
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
    final l = context.l;
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
          titulo: c == null ? l.nuevoCoche : l.editarCoche,
          copasIniciales: copasIniciales,
          contenidoExtra: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SelectorFotoCoche(foto: foto),
              const SizedBox(height: 8),
              TextField(
                controller: nombre,
                decoration: InputDecoration(
                    labelText: l.nombreCompletoObligatorio,
                    helperText: l.nombreCompletoEjemplo),
              ),
              TextField(
                controller: marca,
                decoration: InputDecoration(labelText: l.marcaObligatoria),
              ),
              TextField(
                controller: modelo,
                decoration: InputDecoration(labelText: l.modeloObligatorio),
              ),
              TextField(
                controller: peso,
                decoration: InputDecoration(
                    labelText: l.pesoMinimoObligatorio,
                    helperText: l.pesoMinimoAyuda,
                    helperMaxLines: 2),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              TextField(
                controller: cred,
                decoration: InputDecoration(
                    labelText: l.creditosCoche,
                    helperText: l.creditosCocheAyuda),
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
    final l = context.l;
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
        SnackBar(content: Text(l.noSePudoAnadirFoto('$e'))),
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
                    label: Text(context.l.galeria),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _elegir(context, ImageSource.camera),
                    icon: const Icon(Icons.camera_alt_outlined, size: 18),
                    label: Text(context.l.camara),
                  ),
                  if (path != null)
                    IconButton(
                      tooltip: context.l.quitarFoto,
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
              Text(context.l.copasDondeAplica,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.primary)),
              const SizedBox(height: 4),
              Text(
                _copas.isEmpty
                    ? context.l.copasSinMarcarAviso
                    : context.l.copasMarcarAviso,
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
            child: Text(context.l.cancelar)),
        FilledButton(
            onPressed: () =>
                Navigator.pop(context, (ok: true, copas: _copas)),
            child: Text(context.l.guardar)),
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
      vacio: context.l.sinMarcas,
      textoBuscable: (m) => '${m.codigo} ${m.nombre}',
      fab: FloatingActionButton.extended(
        heroTag: 'fab_marcas',
        onPressed: () => _editar(context, ref, null),
        icon: const Icon(Icons.add),
        label: Text(context.l.marca),
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
            itemBuilder: (_) => [
              PopupMenuItem(value: 'editar', child: Text(context.l.editar)),
              PopupMenuItem(value: 'borrar', child: Text(context.l.eliminar)),
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
        title: Text(m == null ? context.l.nuevaMarca : context.l.editarMarca),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: codigo,
              decoration: InputDecoration(
                  labelText: context.l.codigoObligatorio,
                  helperText: context.l.marcaCodigoEjemplo),
              textCapitalization: TextCapitalization.characters,
            ),
            TextField(
              controller: nombre,
              decoration:
                  InputDecoration(labelText: context.l.nombreCompletoObligatorio),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.l.cancelar)),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(context.l.guardar)),
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
      vacio: context.l.sinLlantas,
      textoBuscable: (l) => '${l.dimension} ${l.tipo}',
      copasJsonDe: (l) => l.copasJson,
      copas: copas,
      fab: FloatingActionButton.extended(
        heroTag: 'fab_llantas',
        onPressed: () => _editar(context, ref, null),
        icon: const Icon(Icons.add),
        label: Text(context.l.llanta),
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
            '\n${context.l.copasEtiqueta(_resumenCopas(context.l, _decodeCopas(l.copasJson)))}',
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
            itemBuilder: (_) => [
              PopupMenuItem(value: 'editar', child: Text(context.l.editar)),
              PopupMenuItem(value: 'borrar', child: Text(context.l.eliminar)),
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
        titulo: l == null ? context.l.nuevaLlanta : context.l.editarLlanta,
        copasIniciales: copasIni,
        contenidoExtra: StatefulBuilder(
          builder: (ctx, setSt) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: dim,
                decoration: InputDecoration(
                    labelText: context.l.dimensionObligatoria,
                    helperText: context.l.llantaDimensionEjemplo),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: tipo,
                decoration: InputDecoration(labelText: context.l.tipoCampo),
                items: [
                  DropdownMenuItem(
                      value: 'DELANTERA', child: Text(context.l.delantera)),
                  DropdownMenuItem(
                      value: 'TRASERA', child: Text(context.l.trasera)),
                  DropdownMenuItem(
                      value: 'AMBAS', child: Text(context.l.ambas)),
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
      vacio: context.l.sinEngranajes,
      textoBuscable: (g) => '${g.diametro ?? ''} ${g.dientes} ${g.tipo}',
      copasJsonDe: (g) => g.copasJson,
      copas: copas,
      fab: FloatingActionButton.extended(
        heroTag: 'fab_engranajes',
        onPressed: () => _editar(context, ref, null),
        icon: const Icon(Icons.add),
        label: Text(context.l.engranaje),
      ),
      item: (g) => Card(
        child: ListTile(
          leading: Icon(
            g.tipo == 'PINON'
                ? Icons.settings_outlined
                : Icons.album_outlined,
            color: cs.primary,
          ),
          title: Text(
              '${g.diametro != null ? '⌀${g.diametro} · ' : ''}${context.l.nDientes(g.dientes)}'),
          subtitle: Text(
            '${g.tipo == 'PINON' ? context.l.pinon : context.l.corona}'
            '\n${context.l.copasEtiqueta(_resumenCopas(context.l, _decodeCopas(g.copasJson)))}',
          ),
          isThreeLine: true,
          trailing: PopupMenuButton<String>(
            onSelected: (op) async {
              if (op == 'editar') {
                _editar(context, ref, g);
              } else if (op == 'borrar') {
                final ok = await _confirmarBorrar(
                    context, '${g.tipo} ${g.dientes}d');
                if (ok) {
                  await ref.read(repoCatalogosProvider).borrarEngranaje(g.id);
                }
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(value: 'editar', child: Text(context.l.editar)),
              PopupMenuItem(value: 'borrar', child: Text(context.l.eliminar)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _editar(
      BuildContext context, WidgetRef ref, CatalogoEngranaje? g) async {
    final diametro =
        TextEditingController(text: g?.diametro?.toString() ?? '');
    final dientes = TextEditingController(text: g?.dientes.toString() ?? '');
    String tipo = g?.tipo ?? 'PINON';
    final copasIni = g == null ? <String>{} : _decodeCopas(g.copasJson).toSet();
    final res = await showDialog<({bool ok, Set<String> copas})>(
      context: context,
      builder: (_) => _DialogoCocheBancada(
        titulo: g == null ? context.l.nuevoEngranaje : context.l.editarEngranaje,
        copasIniciales: copasIni,
        contenidoExtra: StatefulBuilder(
          builder: (ctx, setSt) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: tipo,
                decoration: InputDecoration(labelText: context.l.tipoCampo),
                items: [
                  DropdownMenuItem(
                      value: 'PINON', child: Text(context.l.pinon)),
                  DropdownMenuItem(
                      value: 'CORONA', child: Text(context.l.corona)),
                ],
                onChanged: (v) => setSt(() => tipo = v ?? 'PINON'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: diametro,
                decoration: InputDecoration(
                    labelText: context.l.diametro,
                    helperText: context.l.diametroEjemplo),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: dientes,
                decoration: InputDecoration(
                    labelText: context.l.dientesObligatorio,
                    helperText: context.l.dientesEjemplo),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
    );
    if (res == null || !res.ok) return;
    final dia = double.tryParse(diametro.text.trim().replaceAll(',', '.'));
    final d = int.tryParse(dientes.text.trim());
    if (d == null) return;
    final copasJson = json.encode(res.copas.toList());
    final repo = ref.read(repoCatalogosProvider);
    if (g == null) {
      await repo.crearEngranaje(
          tipo: tipo, diametro: dia, dientes: d, copasJson: copasJson);
    } else {
      await repo.actualizarEngranaje(g.id, tipo, dia, d, copasJson: copasJson);
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
      vacio: context.l.sinMotores,
      textoBuscable: (mo) => mo.nombre,
      copasJsonDe: (mo) => mo.copasJson,
      copas: copas,
      fab: FloatingActionButton.extended(
        heroTag: 'fab_motores',
        onPressed: () => _editar(context, ref, null),
        icon: const Icon(Icons.add),
        label: Text(context.l.motor),
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
              '${medidas.isEmpty ? context.l.sinMedidas : medidas}'
              '\n${context.l.copasEtiqueta(_resumenCopas(context.l, _decodeCopas(mo.copasJson)))}',
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
              itemBuilder: (_) => [
                PopupMenuItem(value: 'editar', child: Text(context.l.editar)),
                PopupMenuItem(value: 'borrar', child: Text(context.l.eliminar)),
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
        titulo: mo == null ? context.l.nuevoMotor : context.l.editarMotor,
        copasIniciales: copasIniciales,
        contenidoExtra: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombre,
              decoration: InputDecoration(
                  labelText: context.l.motorObligatorio,
                  helperText: context.l.motorIdentificadorAyuda),
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
// CHASIS (sin copa: en la verificación se usan siempre todos)
// =====================================================
class _TabChasis extends ConsumerWidget {
  const _TabChasis();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _SimpleTab(
      vacio: context.l.sinChasis,
      botonLabel: context.l.chasis,
      tituloNuevo: context.l.nuevoChasis,
      observar: (r) => r.watch(chasisCatalogoProvider),
      titulo: (c) => c.nombre,
      onCrear: (txt) => ref.read(repoCatalogosProvider).crearChasis(txt),
      onEditar: (item, txt) =>
          ref.read(repoCatalogosProvider).actualizarChasis(item.id, txt),
      onBorrar: (item) =>
          ref.read(repoCatalogosProvider).borrarChasis(item.id),
      hint: context.l.chasisEjemplo,
    );
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
      vacio: context.l.sinBancadas,
      textoBuscable: (b) => b.nombre,
      copasJsonDe: (b) => b.copasJson,
      copas: copas,
      fab: FloatingActionButton.extended(
        heroTag: 'fab_bancadas',
        onPressed: () => _editar(context, ref, null),
        icon: const Icon(Icons.add),
        label: Text(context.l.bancada),
      ),
      item: (b) => Card(
        child: ListTile(
          title: Text(b.nombre),
          subtitle: Text(
              context.l.copasEtiqueta(_resumenCopas(context.l, _decodeCopas(b.copasJson)))),
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
            itemBuilder: (_) => [
              PopupMenuItem(value: 'editar', child: Text(context.l.editar)),
              PopupMenuItem(value: 'borrar', child: Text(context.l.eliminar)),
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
        titulo: b == null ? context.l.nuevaBancada : context.l.editarBancada,
        copasIniciales: copasIni,
        contenidoExtra: TextField(
          controller: nombre,
          autofocus: true,
          decoration: InputDecoration(
              labelText: context.l.nombreObligatorio,
              helperText: context.l.bancadaEjemplo),
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
      vacio: context.l.sinNeumaticos,
      textoBuscable: (n) => '${n.nombre} ${n.referencia ?? ''}',
      copasJsonDe: (n) => n.copasJson,
      copas: copas,
      fab: FloatingActionButton.extended(
        heroTag: 'fab_neumaticos',
        onPressed: () => _editar(context, ref, null),
        icon: const Icon(Icons.add),
        label: Text(context.l.neumatico),
      ),
      item: (n) => Card(
        child: ListTile(
          leading: const Icon(Icons.circle_outlined),
          title: Text(n.nombre),
          subtitle: Text(
            '${n.referencia ?? context.l.sinReferencia}'
            '\n${context.l.copasEtiqueta(_resumenCopas(context.l, _decodeCopas(n.copasJson)))}',
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
            itemBuilder: (_) => [
              PopupMenuItem(value: 'editar', child: Text(context.l.editar)),
              PopupMenuItem(value: 'borrar', child: Text(context.l.eliminar)),
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
        titulo: n == null ? context.l.nuevoNeumatico : context.l.editarNeumatico,
        copasIniciales: copasIni,
        contenidoExtra: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nombre,
                decoration: InputDecoration(
                    labelText: context.l.nombreObligatorio,
                    helperText: context.l.neumaticoEjemplo)),
            TextField(
                controller: ref_,
                decoration: InputDecoration(
                    labelText: context.l.referenciaOpcional)),
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
      vacio: context.l.sinCopas,
      botonLabel: context.l.copa,
      tituloNuevo: context.l.nuevaCopa,
      observar: (r) => r.watch(copasCatalogoProvider),
      titulo: (b) => b.nombre,
      onCrear: (txt) => ref.read(repoCatalogosProvider).crearCopa(txt),
      onEditar: (item, txt) =>
          ref.read(repoCatalogosProvider).actualizarCopa(item.id, txt),
      onBorrar: (item) =>
          ref.read(repoCatalogosProvider).borrarCopa(item.id),
      hint: context.l.copaEjemplo,
    );
  }
}

class _TabClubs extends ConsumerWidget {
  const _TabClubs();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _SimpleTab(
      vacio: context.l.sinClubs,
      botonLabel: context.l.club,
      tituloNuevo: context.l.nuevoClub,
      observar: (r) => r.watch(clubsCatalogoProvider),
      titulo: (b) => b.nombre,
      onCrear: (txt) => ref.read(repoCatalogosProvider).crearClub(txt),
      onEditar: (item, txt) =>
          ref.read(repoCatalogosProvider).actualizarClub(item.id, txt),
      onBorrar: (item) =>
          ref.read(repoCatalogosProvider).borrarClub(item.id),
      hint: context.l.clubNombreEjemplo,
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
    required this.tituloNuevo,
    required this.observar,
    required this.titulo,
    required this.onCrear,
    required this.onEditar,
    required this.onBorrar,
    required this.hint,
  });

  final String vacio;
  final String botonLabel;

  /// Título del diálogo al crear (p. ej. «Nuevo Chasis»); el literal viene de
  /// los textos, no se compone con `botonLabel`.
  final String tituloNuevo;
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
        heroTag: null,
        onPressed: () => _editar(context, null),
        icon: const Icon(Icons.add),
        label: Text(widget.botonLabel),
      ),
      body: lista.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(context.l.errorDetalle('$e'))),
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
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: context.l.buscarPuntos,
                    isDense: true,
                  ),
                  onChanged: (v) =>
                      setState(() => _busqueda = v.trim().toLowerCase()),
                ),
              ),
              Expanded(
                child: filtrados.isEmpty
                    ? _Vacio(
                        texto: xs.isEmpty
                            ? widget.vacio
                            : context.l.sinCoincidencias)
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
                                itemBuilder: (_) => [
                                  PopupMenuItem(
                                      value: 'editar', child: Text(context.l.editar)),
                                  PopupMenuItem(
                                      value: 'borrar', child: Text(context.l.eliminar)),
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
        title: Text(item == null ? widget.tituloNuevo : context.l.editar),
        content: TextField(
          controller: t,
          autofocus: true,
          decoration: InputDecoration(
              labelText: context.l.nombreObligatorio, helperText: widget.hint),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.l.cancelar)),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(context.l.guardar)),
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
          context.l.vacioPulsaAnadir(texto),
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
      title: Text(context.l.eliminar),
      content: Text(context.l.eliminarFichaTexto(nombre)),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l.cancelar)),
        FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l.eliminar)),
      ],
    ),
  );
  return ok ?? false;
}
