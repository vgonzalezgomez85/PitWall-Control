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

import '../../core/proveedores.dart';
import '../equipos/lista_equipos.dart';
import '../equipos/repositorio_equipos.dart';
import '../pilotos/lista_pilotos.dart';

/// «Participantes»: pilotos y equipos del campeonato activo en un solo sitio,
/// con una pestaña para cada uno. Cada pestaña conserva su barra (importar,
/// buscar, botón de alta); las pestañas van dentro de esa barra.
///
/// En formato individual la segunda pestaña se llama «Inscripciones», como la
/// lista de equipos en ese formato.
class PantallaParticipantes extends ConsumerStatefulWidget {
  const PantallaParticipantes({super.key});

  @override
  ConsumerState<PantallaParticipantes> createState() =>
      _PantallaParticipantesState();
}

class _PantallaParticipantesState extends ConsumerState<PantallaParticipantes>
    with SingleTickerProviderStateMixin {
  late final TabController _pestanas = TabController(length: 2, vsync: this)
    ..addListener(() {
      if (_indice != _pestanas.index) setState(() => _indice = _pestanas.index);
    });
  int _indice = 0;

  @override
  void dispose() {
    _pestanas.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activo = ref.watch(campeonatoActivoProvider);
    final esIndividual = maxPilotosEquipo(activo?.formato ?? 'PAREJAS') == 1;
    final barra = TabBar(
      controller: _pestanas,
      tabs: [
        const Tab(text: 'Pilotos'),
        Tab(text: esIndividual ? 'Inscripciones' : 'Equipos'),
      ],
    );

    // IndexedStack y no TabBarView: cada pestaña es un Scaffold con su propia
    // barra, y deslizar movería también las pestañas.
    return IndexedStack(
      index: _indice,
      children: [
        PantallaPilotos(pestanas: barra),
        PantallaEquipos(pestanas: barra),
      ],
    );
  }
}
