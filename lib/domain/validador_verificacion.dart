/// Estado de una validación: nivel (ok/aviso/infraccion) y mensaje en cristiano.
enum NivelValidacion { ok, aviso, infraccion }

class HallazgoValidacion {
  final String campo;
  final NivelValidacion nivel;
  final String mensaje;

  HallazgoValidacion(this.campo, this.nivel, this.mensaje);
}

/// Resultado completo de validar una verificación.
class ResultadoValidacion {
  final List<HallazgoValidacion> hallazgos;
  ResultadoValidacion(this.hallazgos);

  bool get hayInfracciones =>
      hallazgos.any((h) => h.nivel == NivelValidacion.infraccion);
  bool get hayAvisos => hallazgos.any((h) => h.nivel == NivelValidacion.aviso);
  bool get todoOk => hallazgos.isEmpty;
  int get numInfracciones =>
      hallazgos.where((h) => h.nivel == NivelValidacion.infraccion).length;
  int get numAvisos =>
      hallazgos.where((h) => h.nivel == NivelValidacion.aviso).length;
}

/// Entrada para el validador (sin acoplarse al modelo Drift).
class DatosVerificacion {
  final double? pesoInicial;
  final double? pesoFinal;
  final double? pesoMinCoche;
  final int? creditosCoche;
  final int? creditosEquipo;

  final String? motor;

  /// Motor propio: medidas introducidas y referencia del catálogo.
  final String? motorTipo; // 'PROPIO' | 'ORGANIZACION'
  final int? motorRpm;
  final double? motorUms;
  final String? motorRefNombre;
  final int? motorRefRpm;
  final double? motorRefGauss;

  final String? pinonMarca;
  final int? pinonDientes;
  final String? coronaMarca;
  final int? coronaDientes;
  final String? llantaDelMarca;
  final String? llantaDelDimension;
  final String? llantaTraMarca;
  final String? llantaTraDimension;
  final String? trencilla;
  final String? suspension;
  final String? bancada;
  final String? chasis;
  final String? neumatico;

  /// Rango de dientes permitido (inclusive). Tamaño fijo = min == max.
  final int pinonDientesMin;
  final int pinonDientesMax;
  final int coronaDientesMin;
  final int coronaDientesMax;

  /// Conjuntos válidos cargados de los catálogos.
  final Set<String> marcasValidas;
  final Set<String> llantasDelValidas;
  final Set<String> llantasTraValidas;
  final Set<String> bancadasValidas;
  final Set<String> neumaticosValidos;

  DatosVerificacion({
    this.pesoInicial,
    this.pesoFinal,
    this.pesoMinCoche,
    this.creditosCoche,
    this.creditosEquipo,
    this.motor,
    this.motorTipo,
    this.motorRpm,
    this.motorUms,
    this.motorRefNombre,
    this.motorRefRpm,
    this.motorRefGauss,
    this.pinonMarca,
    this.pinonDientes,
    this.coronaMarca,
    this.coronaDientes,
    this.pinonDientesMin = 12,
    this.pinonDientesMax = 12,
    this.coronaDientesMin = 24,
    this.coronaDientesMax = 30,
    this.llantaDelMarca,
    this.llantaDelDimension,
    this.llantaTraMarca,
    this.llantaTraDimension,
    this.trencilla,
    this.suspension,
    this.bancada,
    this.chasis,
    this.neumatico,
    this.marcasValidas = const {},
    this.llantasDelValidas = const {},
    this.llantasTraValidas = const {},
    this.bancadasValidas = const {},
    this.neumaticosValidos = const {},
  });
}

class ValidadorVerificacion {
  /// Aplica todas las reglas. Devuelve los hallazgos. Lista vacía = todo ok.
  static ResultadoValidacion validar(DatosVerificacion d) {
    final hallazgos = <HallazgoValidacion>[];

    // PESO
    if (d.pesoInicial != null && d.pesoMinCoche != null) {
      if (d.pesoInicial! < d.pesoMinCoche!) {
        hallazgos.add(HallazgoValidacion(
          'pesoInicial',
          NivelValidacion.infraccion,
          'Peso inicial ${d.pesoInicial!.toStringAsFixed(2)}g por debajo del mínimo ${d.pesoMinCoche!.toStringAsFixed(2)}g.',
        ));
      }
    }
    if (d.pesoFinal != null && d.pesoMinCoche != null) {
      if (d.pesoFinal! < d.pesoMinCoche!) {
        hallazgos.add(HallazgoValidacion(
          'pesoFinal',
          NivelValidacion.infraccion,
          'Peso final ${d.pesoFinal!.toStringAsFixed(2)}g por debajo del mínimo ${d.pesoMinCoche!.toStringAsFixed(2)}g.',
        ));
      }
    }

    // MOTOR PROPIO — comparar medidas con la referencia del catálogo.
    // Un motor trucado da más RPM y pierde gauss respecto a la referencia.
    if (d.motorTipo == 'PROPIO') {
      if (d.motorRefNombre == null) {
        if (d.motorRpm != null || d.motorUms != null) {
          hallazgos.add(HallazgoValidacion(
            'motor',
            NivelValidacion.aviso,
            'Selecciona el motor del catálogo para comprobar las medidas.',
          ));
        }
      } else {
        if (d.motorRpm != null && d.motorRefRpm != null &&
            d.motorRpm! > d.motorRefRpm!) {
          hallazgos.add(HallazgoValidacion(
            'motorRpm',
            NivelValidacion.infraccion,
            'RPM por encima de la referencia del ${d.motorRefNombre} '
            '(máx ${d.motorRefRpm}, medidas ${d.motorRpm}).',
          ));
        }
        if (d.motorUms != null && d.motorRefGauss != null &&
            d.motorUms! < d.motorRefGauss!) {
          hallazgos.add(HallazgoValidacion(
            'motorUms',
            NivelValidacion.infraccion,
            'Imán por debajo de la referencia del ${d.motorRefNombre} '
            '(mín ${d.motorRefGauss}, medido ${d.motorUms}).',
          ));
        }
      }
    }

    // PIÑÓN — rango (o tamaño fijo) configurado en el campeonato.
    if (d.pinonDientes != null &&
        (d.pinonDientes! < d.pinonDientesMin ||
            d.pinonDientes! > d.pinonDientesMax)) {
      hallazgos.add(HallazgoValidacion(
        'pinonDientes',
        NivelValidacion.infraccion,
        'Piñón fuera de ${_rangoTexto(d.pinonDientesMin, d.pinonDientesMax)} '
        'dientes. Actual: ${d.pinonDientes}.',
      ));
    }

    // CORONA — rango (o tamaño fijo) configurado en el campeonato.
    if (d.coronaDientes != null &&
        (d.coronaDientes! < d.coronaDientesMin ||
            d.coronaDientes! > d.coronaDientesMax)) {
      hallazgos.add(HallazgoValidacion(
        'coronaDientes',
        NivelValidacion.infraccion,
        'Corona fuera de ${_rangoTexto(d.coronaDientesMin, d.coronaDientesMax)} '
        'dientes. Actual: ${d.coronaDientes}.',
      ));
    }

    // Marcas en catálogo
    _verMarca(hallazgos, 'pinonMarca', d.pinonMarca, d.marcasValidas);
    _verMarca(hallazgos, 'coronaMarca', d.coronaMarca, d.marcasValidas);
    _verMarca(hallazgos, 'llantaDelMarca', d.llantaDelMarca, d.marcasValidas);
    _verMarca(hallazgos, 'llantaTraMarca', d.llantaTraMarca, d.marcasValidas);

    // Llantas en catálogo
    _verCatalogo(hallazgos, 'llantaDelDimension', d.llantaDelDimension,
        d.llantasDelValidas, 'Llanta delantera no catalogada');
    _verCatalogo(hallazgos, 'llantaTraDimension', d.llantaTraDimension,
        d.llantasTraValidas, 'Llanta trasera no catalogada');
    _verCatalogo(hallazgos, 'bancada', d.bancada, d.bancadasValidas,
        'Bancada no catalogada');
    _verCatalogo(hallazgos, 'neumatico', d.neumatico, d.neumaticosValidos,
        'Neumático no catalogado');

    // Créditos: solo informativo, sin infracción
    if (d.creditosCoche != null && d.creditosEquipo != null) {
      final balance = d.creditosEquipo! + d.creditosCoche!;
      if (balance < 0) {
        hallazgos.add(HallazgoValidacion(
          'balance',
          NivelValidacion.aviso,
          'Balance de créditos negativo: equipo ${d.creditosEquipo} + coche ${d.creditosCoche} = $balance.',
        ));
      }
    }

    return ResultadoValidacion(hallazgos);
  }

  /// "12" si min==max (tamaño fijo), "24-30" si es un rango.
  static String _rangoTexto(int min, int max) =>
      min == max ? '$min' : '$min-$max';

  static void _verMarca(List<HallazgoValidacion> out, String campo, String? valor,
      Set<String> validas) {
    if (valor == null || valor.isEmpty || validas.isEmpty) return;
    if (!validas.contains(valor)) {
      out.add(HallazgoValidacion(
        campo,
        NivelValidacion.aviso,
        'Marca "$valor" no está en el catálogo.',
      ));
    }
  }

  static void _verCatalogo(List<HallazgoValidacion> out, String campo,
      String? valor, Set<String> validos, String mensaje) {
    if (valor == null || valor.isEmpty || validos.isEmpty) return;
    if (!validos.contains(valor)) {
      out.add(HallazgoValidacion(
          campo, NivelValidacion.aviso, '$mensaje: "$valor".'));
    }
  }
}
