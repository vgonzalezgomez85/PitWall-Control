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
  /// - [pruebasDisputadas]: pruebas ya disputadas (con resultados de alguien).
  ///   Un piloto que no puntúa una prueba disputada cuenta **0** en ella, y ese
  ///   0 es su peor resultado, que entra en el descarte (no se trata como "—").
  /// - [ordenarPorNeto]: durante la temporada se ordena por puntos BRUTOS;
  ///   solo al terminar la última prueba del campeonato se ordena por NETOS
  ///   (cuando los descartes ya son definitivos).
  static List<FilaClasificacion> calcular({
    required List<PilotoBase> pilotos,
    required Map<int, FilaResultados> resultadosPorPiloto,
    required int numDescartes,
    Set<int> pruebasDisputadas = const {},
    bool ordenarPorNeto = false,
  }) {
    final out = <FilaClasificacion>[];
    for (final p in pilotos) {
      final r = resultadosPorPiloto[p.pilotoId] ??
          FilaResultados(const {}, const {});
      final puntos = Map<int, int>.from(r.puntosPorPrueba);
      // Toda prueba disputada en la que el piloto no puntuó cuenta como 0.
      for (final pid in pruebasDisputadas) {
        puntos.putIfAbsent(pid, () => 0);
      }

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
    // Orden: por BRUTO durante la temporada; por NETO al cierre del
    // campeonato. El otro total actúa de desempate, y después el nombre.
    out.sort((a, b) {
      final primario = ordenarPorNeto
          ? b.totalNeto.compareTo(a.totalNeto)
          : b.totalBruto.compareTo(a.totalBruto);
      if (primario != 0) return primario;
      final secundario = ordenarPorNeto
          ? b.totalBruto.compareTo(a.totalBruto)
          : b.totalNeto.compareTo(a.totalNeto);
      if (secundario != 0) return secundario;
      return a.pilotoNombre.compareTo(b.pilotoNombre);
    });
    asignarPosiciones(out);
    return out;
  }

  /// Asigna posiciones con ranking denso: los pilotos empatados (mismo total
  /// neto y mismo bruto) comparten posición y la siguiente NO se salta
  /// (1, 1, 2, 3, 3, 4…). La lista debe venir ya ordenada.
  static void asignarPosiciones(List<FilaClasificacion> filas) {
    var posicion = 0;
    for (var i = 0; i < filas.length; i++) {
      final empatado = i > 0 &&
          filas[i].totalNeto == filas[i - 1].totalNeto &&
          filas[i].totalBruto == filas[i - 1].totalBruto;
      if (!empatado) posicion++;
      filas[i].posicion = posicion;
    }
  }
}

/// Datos base de un piloto para entrar en el cálculo de la clasificación.
class PilotoBase {
  final int pilotoId;
  final String nombre;
  final int equipoId;
  final String equipoNombre;
  final String copa;
  final String categoria;
  final int creditosIniciales;
  final int creditosActuales;

  PilotoBase({
    required this.pilotoId,
    required this.nombre,
    required this.equipoId,
    required this.equipoNombre,
    required this.copa,
    required this.categoria,
    required this.creditosIniciales,
    required this.creditosActuales,
  });

  /// Alias del constructor, mantenido por compatibilidad con los llamadores.
  static PilotoBase crear({
    required int pilotoId,
    required String nombre,
    required int equipoId,
    required String equipoNombre,
    required String copa,
    required String categoria,
    required int creditosIniciales,
    required int creditosActuales,
  }) {
    return PilotoBase(
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
