/// Datos primarios para calcular la clasificación.
class FilaResultados {
  /// pruebaId → puntos del piloto en esa prueba (suma de mangas si más de una).
  final Map<int, int> puntosPorPrueba;
  /// pruebaId → suma de "a restar" en esa prueba.
  final Map<int, int> aRestarPorPrueba;

  FilaResultados(this.puntosPorPrueba, this.aRestarPorPrueba);
}

/// Resultado calculado para un piloto en la clasificación general.
class FilaClasificacion {
  final int pilotoId;
  final String pilotoNombre;
  final int equipoId;
  final String equipoNombre;
  final String copa;
  final String categoria;
  final int creditosIniciales;
  final int creditosActuales;

  /// Puntos por prueba (no incluye descartes).
  final Map<int, int> puntosPorPrueba;
  /// Pruebas seleccionadas como descarte (con peores puntos).
  final Set<int> pruebasDescartadas;
  /// Suma bruta antes de descartar.
  final int totalBruto;
  /// Suma de los descartes.
  final int totalDescarte;
  /// Total neto = bruto - descarte.
  final int totalNeto;
  /// Créditos restados durante la temporada (suma de "a restar").
  final int totalARestar;

  /// Posición en la clasificación (1 = primero).
  int? posicion;

  FilaClasificacion({
    required this.pilotoId,
    required this.pilotoNombre,
    required this.equipoId,
    required this.equipoNombre,
    required this.copa,
    required this.categoria,
    required this.creditosIniciales,
    required this.creditosActuales,
    required this.puntosPorPrueba,
    required this.pruebasDescartadas,
    required this.totalBruto,
    required this.totalDescarte,
    required this.totalNeto,
    required this.totalARestar,
    this.posicion,
  });
}

class CalculoClasificacion {
  /// Construye la clasificación general aplicando descartes.
  /// - [pilotos]: lista de pilotos con sus datos (id, nombre, equipo, copa, categoría, créditos).
  /// - [resultadosPorPiloto]: mapa pilotoId → FilaResultados.
  /// - [numDescartes]: cuántas pruebas se descartan por piloto (las de peor puntuación).
  static List<FilaClasificacion> calcular({
    required List<_PilotoBase> pilotos,
    required Map<int, FilaResultados> resultadosPorPiloto,
    required int numDescartes,
  }) {
    final out = <FilaClasificacion>[];
    for (final p in pilotos) {
      final r = resultadosPorPiloto[p.pilotoId] ??
          FilaResultados(const {}, const {});
      final puntos = Map<int, int>.from(r.puntosPorPrueba);

      // Identificar las N pruebas con menos puntos como descartes
      final descartadas = <int>{};
      if (numDescartes > 0 && puntos.isNotEmpty) {
        final entradas = puntos.entries.toList()
          ..sort((a, b) => a.value.compareTo(b.value));
        for (var i = 0; i < numDescartes && i < entradas.length; i++) {
          descartadas.add(entradas[i].key);
        }
      }

      final totalBruto = puntos.values.fold<int>(0, (a, b) => a + b);
      final totalDescarte = descartadas.fold<int>(
          0, (acum, pid) => acum + (puntos[pid] ?? 0));
      final totalNeto = totalBruto - totalDescarte;
      final totalAR = r.aRestarPorPrueba.values.fold<int>(0, (a, b) => a + b);

      out.add(FilaClasificacion(
        pilotoId: p.pilotoId,
        pilotoNombre: p.nombre,
        equipoId: p.equipoId,
        equipoNombre: p.equipoNombre,
        copa: p.copa,
        categoria: p.categoria,
        creditosIniciales: p.creditosIniciales,
        creditosActuales: p.creditosActuales,
        puntosPorPrueba: puntos,
        pruebasDescartadas: descartadas,
        totalBruto: totalBruto,
        totalDescarte: totalDescarte,
        totalNeto: totalNeto,
        totalARestar: totalAR,
      ));
    }
    // Ordenar por TOTAL NETO descendente, desempate por totalBruto, luego nombre
    out.sort((a, b) {
      final n = b.totalNeto.compareTo(a.totalNeto);
      if (n != 0) return n;
      final br = b.totalBruto.compareTo(a.totalBruto);
      if (br != 0) return br;
      return a.pilotoNombre.compareTo(b.pilotoNombre);
    });
    // Asignar posiciones
    for (var i = 0; i < out.length; i++) {
      out[i].posicion = i + 1;
    }
    return out;
  }
}

class _PilotoBase {
  final int pilotoId;
  final String nombre;
  final int equipoId;
  final String equipoNombre;
  final String copa;
  final String categoria;
  final int creditosIniciales;
  final int creditosActuales;

  _PilotoBase({
    required this.pilotoId,
    required this.nombre,
    required this.equipoId,
    required this.equipoNombre,
    required this.copa,
    required this.categoria,
    required this.creditosIniciales,
    required this.creditosActuales,
  });
}

/// Helper público para construir [_PilotoBase] desde fuera (factory).
class PilotoBase {
  static _PilotoBase crear({
    required int pilotoId,
    required String nombre,
    required int equipoId,
    required String equipoNombre,
    required String copa,
    required String categoria,
    required int creditosIniciales,
    required int creditosActuales,
  }) {
    return _PilotoBase(
      pilotoId: pilotoId,
      nombre: nombre,
      equipoId: equipoId,
      equipoNombre: equipoNombre,
      copa: copa,
      categoria: categoria,
      creditosIniciales: creditosIniciales,
      creditosActuales: creditosActuales,
    );
  }
}
