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

import '../idioma.dart';

/// Opción de una [AccionBarra] con submenú (p. ej. «Exportar» → PDF / CSV).
class OpcionAccion {
  const OpcionAccion(this.icono, this.etiqueta, this.onTap);
  final IconData icono;
  final String etiqueta;
  final VoidCallback onTap;
}

/// Acción de la barra superior. Si tiene [opciones], al pulsarla se abre un
/// submenú; si no, ejecuta [onPressed].
class AccionBarra {
  const AccionBarra({
    required this.icono,
    required this.etiqueta,
    this.onPressed,
    this.opciones,
    this.principal = true,
    this.habilitada = true,
  });

  final IconData icono;
  final String etiqueta;
  final VoidCallback? onPressed;
  final List<OpcionAccion>? opciones;

  /// Las principales se ven como botón con texto; las demás van al menú «⋯».
  final bool principal;
  final bool habilitada;
}

/// Acciones de una barra superior siempre con texto: las principales como
/// botones y el resto en un menú «⋯». En ventanas estrechas (móvil) todas van
/// al menú, para no desbordar la barra. Sin iconos sueltos: en Android no hay
/// ratón para ver el tooltip.
class AccionesBarra extends StatelessWidget {
  const AccionesBarra(this.acciones, {super.key});

  final List<AccionBarra> acciones;

  /// Por debajo de este ancho todo va al menú «⋯».
  static const anchoMinimoBotones = 700.0;

  @override
  Widget build(BuildContext context) {
    final estrecha =
        MediaQuery.sizeOf(context).width < anchoMinimoBotones;
    final botones = [
      for (final a in acciones)
        if (a.principal && !estrecha) a
    ];
    final enMenu = [
      for (final a in acciones)
        if (!a.principal || estrecha) a
    ];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final a in botones) _Boton(a),
        if (enMenu.isNotEmpty) _MenuMas(enMenu),
        const SizedBox(width: 8),
      ],
    );
  }
}

class _Boton extends StatelessWidget {
  const _Boton(this.accion);
  final AccionBarra accion;

  @override
  Widget build(BuildContext context) {
    final a = accion;
    final opciones = a.opciones;
    if (opciones == null) {
      return TextButton.icon(
        icon: Icon(a.icono),
        label: Text(a.etiqueta),
        onPressed: a.habilitada ? a.onPressed : null,
      );
    }
    return PopupMenuButton<int>(
      enabled: a.habilitada && opciones.isNotEmpty,
      tooltip: '',
      onSelected: (i) => opciones[i].onTap(),
      itemBuilder: (_) => [
        for (var i = 0; i < opciones.length; i++)
          PopupMenuItem(
            value: i,
            child: ListTile(
              leading: Icon(opciones[i].icono),
              title: Text(opciones[i].etiqueta),
              contentPadding: EdgeInsets.zero,
            ),
          ),
      ],
      // El botón solo se dibuja; el toque lo recoge el PopupMenuButton.
      child: IgnorePointer(
        child: TextButton.icon(
          icon: Icon(a.icono),
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [Text(a.etiqueta), const Icon(Icons.arrow_drop_down)],
          ),
          onPressed: a.habilitada && opciones.isNotEmpty ? () {} : null,
        ),
      ),
    );
  }
}

/// Menú «⋯» con el resto de acciones; las que tienen submenú se despliegan
/// como «Acción: opción».
class _MenuMas extends StatelessWidget {
  const _MenuMas(this.acciones);
  final List<AccionBarra> acciones;

  @override
  Widget build(BuildContext context) {
    PopupMenuItem<VoidCallback> item(
            IconData icono, String texto, VoidCallback? onTap) =>
        PopupMenuItem(
          value: onTap,
          enabled: onTap != null,
          child: ListTile(
            leading: Icon(icono),
            title: Text(texto),
            contentPadding: EdgeInsets.zero,
          ),
        );

    return PopupMenuButton<VoidCallback>(
      tooltip: context.l.masOpciones,
      icon: const Icon(Icons.more_vert),
      onSelected: (f) => f(),
      itemBuilder: (_) => [
        for (final a in acciones)
          if (a.opciones == null)
            item(a.icono, a.etiqueta, a.habilitada ? a.onPressed : null)
          else
            for (final o in a.opciones!)
              item(o.icono, '${a.etiqueta}: ${o.etiqueta}',
                  a.habilitada ? o.onTap : null),
      ],
    );
  }
}
