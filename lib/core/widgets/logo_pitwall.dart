import 'package:flutter/material.dart';

import '../tema.dart';

/// Logo/glyph de PitWall dibujado vectorialmente (mismo mark del icono de la
/// app y del resto del ecosistema): squircle + chevron ">" + caja roja.
/// Nítido a cualquier tamaño y adaptado al color del tema.
class LogoPitwall extends StatelessWidget {
  const LogoPitwall({super.key, this.size = 40, this.color, this.colorCaja});

  final double size;

  /// Color del contorno y del chevron (por defecto, el color de texto del tema).
  final Color? color;

  /// Color de la caja (por defecto, el rojo de marca).
  final Color? colorCaja;

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.onSurface;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _LogoPainter(c, colorCaja ?? TemaApp.rojo)),
    );
  }
}

class _LogoPainter extends CustomPainter {
  _LogoPainter(this.color, this.caja);
  final Color color;
  final Color caja;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 100; // el glyph está definido en un lienzo 100x100

    final trazo = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.5 * s
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    // Squircle exterior.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(6 * s, 6 * s, 88 * s, 88 * s),
        Radius.circular(22 * s),
      ),
      trazo,
    );

    // Chevron ">".
    final chevron = Path()
      ..moveTo(30 * s, 34 * s)
      ..lineTo(51 * s, 50 * s)
      ..lineTo(30 * s, 66 * s);
    canvas.drawPath(
      chevron,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8 * s
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Caja (el "cursor").
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(56 * s, 58 * s, 17 * s, 11 * s),
        Radius.circular(3 * s),
      ),
      Paint()..color = caja,
    );
  }

  @override
  bool shouldRepaint(_LogoPainter old) =>
      old.color != color || old.caja != caja;
}
