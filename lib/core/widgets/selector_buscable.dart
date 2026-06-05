import 'package:flutter/material.dart';

/// Campo de formulario con apariencia de dropdown que abre un diálogo
/// con buscador. Pensado para reemplazar a `DropdownButtonFormField` cuando
/// la lista de opciones es larga (pilotos, coches, equipos…).
///
/// Uso típico:
/// ```dart
/// SelectorBuscable<Piloto>(
///   etiqueta: 'Piloto',
///   icono: Icons.person_outline,
///   valor: _piloto,
///   opciones: pilotos,
///   etiquetaOpcion: (p) => p.nombre,
///   subtituloOpcion: (p) => p.email,
///   onCambio: (p) => setState(() => _piloto = p),
/// )
/// ```
class SelectorBuscable<T> extends StatelessWidget {
  const SelectorBuscable({
    super.key,
    required this.etiqueta,
    required this.valor,
    required this.opciones,
    required this.etiquetaOpcion,
    required this.onCambio,
    this.icono,
    this.subtituloOpcion,
    this.helper,
    this.permitirVacio = true,
    this.textoVacio = '— sin asignar —',
    this.titulo,
    this.validator,
  });

  final String etiqueta;
  final IconData? icono;
  final String? helper;
  final T? valor;
  final List<T> opciones;
  final String Function(T) etiquetaOpcion;
  final String? Function(T)? subtituloOpcion;
  final void Function(T?) onCambio;
  final bool permitirVacio;
  final String textoVacio;
  final String? titulo;
  final String? Function(T?)? validator;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final texto = valor == null ? textoVacio : etiquetaOpcion(valor as T);
    final controlador = TextEditingController(text: texto);
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () async {
        final sel = await _abrirSelector(context);
        if (sel != null) onCambio(sel.value);
      },
      child: IgnorePointer(
        child: TextFormField(
          controller: controlador,
          readOnly: true,
          decoration: InputDecoration(
            labelText: etiqueta,
            helperText: helper,
            prefixIcon: icono == null ? null : Icon(icono),
            suffixIcon: const Icon(Icons.arrow_drop_down),
            hintStyle: TextStyle(color: cs.outline),
          ),
          validator: (_) =>
              validator == null ? null : validator!(valor),
        ),
      ),
    );
  }

  Future<_Sel<T>?> _abrirSelector(BuildContext context) {
    return showDialog<_Sel<T>>(
      context: context,
      builder: (_) => _DialogoBuscador<T>(
        titulo: titulo ?? etiqueta,
        opciones: opciones,
        etiquetaOpcion: etiquetaOpcion,
        subtituloOpcion: subtituloOpcion,
        permitirVacio: permitirVacio,
        textoVacio: textoVacio,
      ),
    );
  }
}

class _Sel<T> {
  final T? value;
  _Sel(this.value);
}

class _DialogoBuscador<T> extends StatefulWidget {
  const _DialogoBuscador({
    required this.titulo,
    required this.opciones,
    required this.etiquetaOpcion,
    required this.subtituloOpcion,
    required this.permitirVacio,
    required this.textoVacio,
  });

  final String titulo;
  final List<T> opciones;
  final String Function(T) etiquetaOpcion;
  final String? Function(T)? subtituloOpcion;
  final bool permitirVacio;
  final String textoVacio;

  @override
  State<_DialogoBuscador<T>> createState() => _DialogoBuscadorState<T>();
}

class _DialogoBuscadorState<T> extends State<_DialogoBuscador<T>> {
  String _filtro = '';

  String _norm(String s) =>
      s.toLowerCase().replaceAll(RegExp(r'[áàä]'), 'a')
        .replaceAll(RegExp(r'[éèë]'), 'e')
        .replaceAll(RegExp(r'[íìï]'), 'i')
        .replaceAll(RegExp(r'[óòö]'), 'o')
        .replaceAll(RegExp(r'[úùü]'), 'u');

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final f = _norm(_filtro);
    final filtradas = _filtro.isEmpty
        ? widget.opciones
        : widget.opciones.where((o) {
            final t = _norm(widget.etiquetaOpcion(o));
            final s = widget.subtituloOpcion == null
                ? ''
                : _norm(widget.subtituloOpcion!(o) ?? '');
            return t.contains(f) || s.contains(f);
          }).toList();

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(widget.titulo,
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: TextField(
                autofocus: true,
                onChanged: (v) => setState(() => _filtro = v),
                decoration: InputDecoration(
                  hintText: 'Buscar…',
                  prefixIcon: const Icon(Icons.search),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Expanded(
              child: filtradas.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text('Sin resultados para "$_filtro"',
                            style: TextStyle(color: cs.outline)),
                      ),
                    )
                  : ListView.separated(
                      itemCount: filtradas.length +
                          (widget.permitirVacio && _filtro.isEmpty ? 1 : 0),
                      separatorBuilder: (_, _) => const Divider(height: 0),
                      itemBuilder: (_, i) {
                        if (widget.permitirVacio && _filtro.isEmpty) {
                          if (i == 0) {
                            return ListTile(
                              leading: const Icon(Icons.cancel_outlined),
                              title: Text(widget.textoVacio,
                                  style: TextStyle(color: cs.outline)),
                              onTap: () =>
                                  Navigator.of(context).pop(_Sel<T>(null)),
                            );
                          }
                          i -= 1;
                        }
                        final op = filtradas[i];
                        final sub = widget.subtituloOpcion?.call(op);
                        return ListTile(
                          title: Text(widget.etiquetaOpcion(op)),
                          subtitle:
                              sub == null || sub.isEmpty ? null : Text(sub),
                          onTap: () =>
                              Navigator.of(context).pop(_Sel<T>(op)),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
