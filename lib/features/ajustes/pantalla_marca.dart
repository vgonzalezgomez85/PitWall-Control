import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/exportar_config.dart';

/// Configuración global de la marca que aparece en los PDF: título de la
/// cabecera y lema del pie. Se usa en todas las exportaciones.
class PantallaMarca extends ConsumerStatefulWidget {
  const PantallaMarca({super.key});

  @override
  ConsumerState<PantallaMarca> createState() => _PantallaMarcaState();
}

class _PantallaMarcaState extends ConsumerState<PantallaMarca> {
  late final TextEditingController _titulo;
  late final TextEditingController _lema;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    final cfg = ref.read(marcaConfigProvider);
    _titulo = TextEditingController(text: cfg.titulo);
    _lema = TextEditingController(text: cfg.lema);
  }

  @override
  void dispose() {
    _titulo.dispose();
    _lema.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    setState(() => _guardando = true);
    await ref
        .read(marcaConfigProvider.notifier)
        .guardar(_titulo.text.trim(), _lema.text.trim());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Marca guardada')),
    );
    setState(() => _guardando = false);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Marca de las exportaciones')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Estos textos aparecen en todos los PDF que genera la app: el '
            'título en la cabecera y el lema en el pie.',
            style: TextStyle(color: cs.outline),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _titulo,
            decoration: const InputDecoration(
              labelText: 'Título (cabecera)',
              helperText: 'Ej: RESISBARNA',
              prefixIcon: Icon(Icons.title),
            ),
            textCapitalization: TextCapitalization.characters,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _lema,
            decoration: const InputDecoration(
              labelText: 'Lema (pie de página)',
              helperText: 'Ej: RESISBARNA · resistencias de slot en Barcelona',
              prefixIcon: Icon(Icons.notes),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _guardando ? null : _guardar,
            icon: _guardando
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.check),
            label: const Text('Guardar marca'),
          ),
          const SizedBox(height: 16),
          Card(
            color: cs.surfaceContainerHighest,
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'El idioma de cada PDF se elige al exportar (Español, English, '
                'Italiano, Français).',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
