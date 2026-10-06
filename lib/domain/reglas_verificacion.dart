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

/// Reglamento contra el que se comprueba UNA verificación: todo lo que sale
/// del catálogo o del campeonato y no de lo que mide el verificador.
///
/// Se guarda en `verificaciones.reglas_json` al verificar. Así, si después
/// se cambia el catálogo (p. ej. el peso mínimo de una carrocería) o el
/// reglamento del campeonato, las verificaciones ya validadas o de
/// campeonatos cerrados siguen comprobándose con los valores de entonces.
class ReglasVerificacion {
  const ReglasVerificacion({
    this.fechaMs,
    this.copa,
    this.cocheId,
    this.cocheNombre,
    this.pesoMin,
    this.creditosCoche,
    this.motor,
    this.motorRefNombre,
    this.motorRefRpm,
    this.motorRefGauss,
    this.anchuraEjeDelMax,
    this.anchuraEjeTraMax,
    this.marcasPermitidas = const {},
    this.marcasValidas = const {},
    this.llantasDelValidas = const {},
    this.llantasTraValidas = const {},
    this.bancadasValidas = const {},
    this.neumaticosValidos = const {},
  });

  /// Cuándo se tomaron estos valores (ms desde epoch).
  final int? fechaMs;

  /// Copa del equipo en la prueba con la que se calcularon.
  final String? copa;

  /// Coche elegido y sus valores en el campeonato (los del campeonato si los
  /// tiene fijados, si no los del catálogo).
  final int? cocheId;
  final String? cocheNombre;
  final double? pesoMin;
  final int? creditosCoche;

  /// Motor (nombre del catálogo, solo motor propio) y su referencia.
  final String? motor;
  final String? motorRefNombre;
  final int? motorRefRpm;
  final double? motorRefGauss;

  /// Máximos de anchura de eje para la copa (null = no se comprueba).
  final double? anchuraEjeDelMax;
  final double? anchuraEjeTraMax;

  /// Fabricantes permitidos por el campeonato (vacío = sin limitación).
  final Set<String> marcasPermitidas;

  /// Listas homologadas del catálogo (para los avisos de "no catalogado").
  final Set<String> marcasValidas;
  final Set<String> llantasDelValidas;
  final Set<String> llantasTraValidas;
  final Set<String> bancadasValidas;
  final Set<String> neumaticosValidos;

  /// Mezcla: se queda con estos valores salvo las partes indicadas, que se
  /// toman de [actuales]. Se usa cuando, en una verificación congelada, el
  /// verificador cambia el coche, el motor o la copa: esa parte sí tiene
  /// que recalcularse (es otro coche), el resto sigue congelado.
  ReglasVerificacion combinar(
    ReglasVerificacion actuales, {
    bool coche = false,
    bool motor = false,
    bool copa = false,
  }) {
    return ReglasVerificacion(
      fechaMs: fechaMs,
      copa: copa ? actuales.copa : this.copa,
      cocheId: coche ? actuales.cocheId : cocheId,
      cocheNombre: coche ? actuales.cocheNombre : cocheNombre,
      pesoMin: coche ? actuales.pesoMin : pesoMin,
      creditosCoche: coche ? actuales.creditosCoche : creditosCoche,
      motor: motor ? actuales.motor : this.motor,
      motorRefNombre: motor ? actuales.motorRefNombre : motorRefNombre,
      motorRefRpm: motor ? actuales.motorRefRpm : motorRefRpm,
      motorRefGauss: motor ? actuales.motorRefGauss : motorRefGauss,
      anchuraEjeDelMax: copa ? actuales.anchuraEjeDelMax : anchuraEjeDelMax,
      anchuraEjeTraMax: copa ? actuales.anchuraEjeTraMax : anchuraEjeTraMax,
      marcasPermitidas: marcasPermitidas,
      marcasValidas: marcasValidas,
      llantasDelValidas: copa ? actuales.llantasDelValidas : llantasDelValidas,
      llantasTraValidas: copa ? actuales.llantasTraValidas : llantasTraValidas,
      bancadasValidas: bancadasValidas,
      neumaticosValidos: copa ? actuales.neumaticosValidos : neumaticosValidos,
    );
  }

  /// Diferencias legibles con [actuales] ("Peso mínimo: 17 g (ahora 18 g)").
  /// Vacía si el reglamento congelado coincide con el actual.
  List<String> diferenciasCon(ReglasVerificacion actuales) {
    String n(num? v) {
      if (v == null) return '—';
      return v == v.roundToDouble() ? v.toStringAsFixed(0) : '$v';
    }

    final out = <String>[];
    void num_(String titulo, num? antes, num? ahora, [String unidad = '']) {
      if (antes == ahora) return;
      final u = unidad.isEmpty ? '' : ' $unidad';
      out.add('$titulo: ${n(antes)}$u (ahora ${n(ahora)}$u)');
    }

    void lista(String titulo, Set<String> antes, Set<String> ahora) {
      final quitadas = antes.difference(ahora);
      final nuevas = ahora.difference(antes);
      if (quitadas.isEmpty && nuevas.isEmpty) return;
      out.add([
        titulo,
        if (nuevas.isNotEmpty) 'añadidas: ${(nuevas.toList()..sort()).join(', ')}',
        if (quitadas.isNotEmpty)
          'quitadas: ${(quitadas.toList()..sort()).join(', ')}',
      ].join(' · '));
    }

    if (cocheNombre != actuales.cocheNombre && cocheId == actuales.cocheId) {
      out.add('Nombre del coche: ${cocheNombre ?? '—'} '
          '(ahora ${actuales.cocheNombre ?? '—'})');
    }
    num_('Peso mínimo', pesoMin, actuales.pesoMin, 'g');
    num_('Créditos del coche', creditosCoche, actuales.creditosCoche);
    num_('RPM máx. del motor', motorRefRpm, actuales.motorRefRpm);
    num_('Imán máx. del motor', motorRefGauss, actuales.motorRefGauss);
    num_('Eje delantero máx.', anchuraEjeDelMax, actuales.anchuraEjeDelMax,
        'mm');
    num_('Eje trasero máx.', anchuraEjeTraMax, actuales.anchuraEjeTraMax,
        'mm');
    lista('Fabricantes permitidos', marcasPermitidas,
        actuales.marcasPermitidas);
    lista('Marcas del catálogo', marcasValidas, actuales.marcasValidas);
    lista('Llantas delanteras', llantasDelValidas, actuales.llantasDelValidas);
    lista('Llantas traseras', llantasTraValidas, actuales.llantasTraValidas);
    lista('Bancadas', bancadasValidas, actuales.bancadasValidas);
    lista('Neumáticos', neumaticosValidos, actuales.neumaticosValidos);
    return out;
  }

  Map<String, dynamic> toJson() => {
        'v': 1,
        'fechaMs': ?fechaMs,
        'copa': ?copa,
        'cocheId': ?cocheId,
        'cocheNombre': ?cocheNombre,
        'pesoMin': ?pesoMin,
        'creditosCoche': ?creditosCoche,
        'motor': ?motor,
        'motorRefNombre': ?motorRefNombre,
        'motorRefRpm': ?motorRefRpm,
        'motorRefGauss': ?motorRefGauss,
        'anchuraEjeDelMax': ?anchuraEjeDelMax,
        'anchuraEjeTraMax': ?anchuraEjeTraMax,
        'marcasPermitidas': _orden(marcasPermitidas),
        'marcasValidas': _orden(marcasValidas),
        'llantasDelValidas': _orden(llantasDelValidas),
        'llantasTraValidas': _orden(llantasTraValidas),
        'bancadasValidas': _orden(bancadasValidas),
        'neumaticosValidos': _orden(neumaticosValidos),
      };

  String codificar() => jsonEncode(toJson());

  /// Lee el JSON guardado; null si está vacío o no se entiende (se tratará
  /// como verificación sin congelar).
  static ReglasVerificacion? decodificar(String? texto) {
    if (texto == null || texto.trim().isEmpty) return null;
    try {
      final raw = jsonDecode(texto);
      if (raw is! Map) return null;
      return ReglasVerificacion.fromJson(raw.cast<String, dynamic>());
    } catch (_) {
      return null;
    }
  }

  factory ReglasVerificacion.fromJson(Map<String, dynamic> j) {
    double? d(Object? v) => v is num ? v.toDouble() : null;
    int? i(Object? v) => v is num ? v.toInt() : null;
    String? s(Object? v) => v?.toString();
    Set<String> c(Object? v) =>
        v is List ? v.map((e) => e.toString()).toSet() : const {};
    return ReglasVerificacion(
      fechaMs: i(j['fechaMs']),
      copa: s(j['copa']),
      cocheId: i(j['cocheId']),
      cocheNombre: s(j['cocheNombre']),
      pesoMin: d(j['pesoMin']),
      creditosCoche: i(j['creditosCoche']),
      motor: s(j['motor']),
      motorRefNombre: s(j['motorRefNombre']),
      motorRefRpm: i(j['motorRefRpm']),
      motorRefGauss: d(j['motorRefGauss']),
      anchuraEjeDelMax: d(j['anchuraEjeDelMax']),
      anchuraEjeTraMax: d(j['anchuraEjeTraMax']),
      marcasPermitidas: c(j['marcasPermitidas']),
      marcasValidas: c(j['marcasValidas']),
      llantasDelValidas: c(j['llantasDelValidas']),
      llantasTraValidas: c(j['llantasTraValidas']),
      bancadasValidas: c(j['bancadasValidas']),
      neumaticosValidos: c(j['neumaticosValidos']),
    );
  }

  static List<String> _orden(Set<String> s) => s.toList()..sort();
}
