/// Datos mínimos de un equipo inscrito para el generador.
class EquipoSemilla {
  final int equipoId;
  final String nombre;
  final String copa;
  /// Puntuación de seed (mayor = mejor seed). Suma de puntos brutos de
  /// pilotos del equipo. Si no hay puntos en el campeonato, se usa el saldo
  /// del año anterior; si tampoco, 0.
  final num puntuacion;
  /// Día preferido por el equipo, p.ej. "Jueves", "Viernes". null si da igual.
  final String? preferenciaDia;

  EquipoSemilla({
    required this.equipoId,
    required this.nombre,
    required this.copa,
    required this.puntuacion,
    this.preferenciaDia,
  });
}

/// Resultado: una manga con su lista ordenada de equipos.
/// El carril NO se asigna aquí — se hace antes de carrera.
class MangaGenerada {
  final String nombre;
  final List<EquipoSemilla> equipos;

  MangaGenerada({required this.nombre, required this.equipos});

  num get puntuacionTotal =>
      equipos.fold<num>(0, (s, e) => s + e.puntuacion);
}

/// Resultado completo del generador.
class ResultadoGeneracion {
  final List<MangaGenerada> mangas;
  /// Equipos cuya preferencia de día no encuentra manga de ese día.
  /// Quedan sin asignar; el usuario decide qué hacer con ellos.
  final List<EquipoSemilla> sinManga;

  ResultadoGeneracion({required this.mangas, required this.sinManga});
}

/// Configuración del generador.
class ConfigGenerador {
  final List<String> nombresMangas;
  /// Tamaño máximo de cada manga. Por defecto 10.
  final int tamMaxManga;
  final int? semillaAleatoria;

  const ConfigGenerador({
    required this.nombresMangas,
    this.tamMaxManga = 10,
    this.semillaAleatoria,
  });
}

class GeneradorMangas {
  /// Distribuye los equipos en mangas según las reglas de Resisbarna:
  ///
  /// **Preferencia de día estricta**: un equipo con preferencia "Jueves"
  /// SOLO va a mangas cuyo nombre contiene "Jueves". Si no hay manga de ese
  /// día, el equipo queda en `sinManga`.
  ///
  /// Para cada GRUPO de mangas del mismo día, se aplica la regla de reparto:
  /// - Máx `tamMaxManga` por manga (default 10).
  /// - Para 11 equipos del mismo día en 2 mangas: 5 + 6.
  /// - 12+: reparto igualado; impar → 1ª manga MÁS equipos.
  ///
  /// Los equipos sin preferencia de día se distribuyen entre las mangas
  /// que aún tengan hueco, llenando primero las que tienen más capacidad.
  ///
  /// Dentro de cada manga: orden por puntuación descendente.
  /// NO se asignan carriles aquí.
  static ResultadoGeneracion generar({
    required List<EquipoSemilla> equipos,
    required ConfigGenerador config,
  }) {
    if (equipos.isEmpty) {
      return ResultadoGeneracion(mangas: const [], sinManga: const []);
    }
    final numMangas = config.nombresMangas.length;
    if (numMangas == 0) {
      throw ArgumentError('Indica al menos un nombre de manga');
    }

    // Ordenar por puntuación descendente; desempate por nombre.
    final ranking = [...equipos]
      ..sort((a, b) {
        final c = b.puntuacion.compareTo(a.puntuacion);
        return c != 0 ? c : a.nombre.compareTo(b.nombre);
      });

    final cubos = List.generate(numMangas, (_) => <EquipoSemilla>[]);
    final sinManga = <EquipoSemilla>[];
    final colocados = <int>{};

    // Calcular qué mangas pertenecen a cada día (por el nombre)
    // Mapa día → lista de índices de manga
    final mangasPorDia = <String, List<int>>{};
    for (var i = 0; i < numMangas; i++) {
      final nom = _norm(config.nombresMangas[i]);
      for (final dia in const ['jueves', 'viernes', 'sabado', 'domingo',
          'lunes', 'martes', 'miercoles']) {
        if (nom.contains(dia)) {
          mangasPorDia.putIfAbsent(dia, () => []).add(i);
          break;
        }
      }
    }

    // PASO 1: agrupar equipos por preferencia de día y repartirlos
    // exclusivamente en las mangas de ese día.
    final equiposPorDia = <String, List<EquipoSemilla>>{};
    final sinPreferencia = <EquipoSemilla>[];
    for (final eq in ranking) {
      final pref = (eq.preferenciaDia ?? '').trim();
      if (pref.isEmpty) {
        sinPreferencia.add(eq);
        continue;
      }
      final norm = _norm(pref);
      String? diaClave;
      for (final d in const ['jueves', 'viernes', 'sabado', 'domingo',
          'lunes', 'martes', 'miercoles']) {
        if (norm.contains(d)) {
          diaClave = d;
          break;
        }
      }
      if (diaClave == null) {
        sinPreferencia.add(eq);
        continue;
      }
      equiposPorDia.putIfAbsent(diaClave, () => []).add(eq);
    }

    // Repartir equipos de cada día en sus mangas, aplicando regla 5+6/etc.
    for (final entrada in equiposPorDia.entries) {
      final dia = entrada.key;
      final eqs = entrada.value;
      final indices = mangasPorDia[dia];
      if (indices == null || indices.isEmpty) {
        // No hay manga para este día → equipos sin manga
        sinManga.addAll(eqs);
        continue;
      }
      final tamanos = _distribuirEquipos(eqs.length, indices.length,
          tamMax: config.tamMaxManga);
      var idxLocal = 0;
      for (final eq in eqs) {
        while (idxLocal < indices.length &&
            cubos[indices[idxLocal]].length >= tamanos[idxLocal]) {
          idxLocal++;
        }
        if (idxLocal >= indices.length) {
          sinManga.add(eq);
          continue;
        }
        cubos[indices[idxLocal]].add(eq);
        colocados.add(eq.equipoId);
      }
    }

    // PASO 2: equipos sin preferencia → llenan las mangas restantes.
    // Estrategia: ir poniéndolos donde haya más hueco respecto a tamMax,
    // priorizando las mangas de orden bajo (primeras mangas).
    final huecos = List.generate(
      numMangas,
      (i) => config.tamMaxManga - cubos[i].length,
    );
    for (final eq in sinPreferencia) {
      // Buscar el primer cubo con hueco
      int idx = -1;
      for (var i = 0; i < numMangas; i++) {
        if (huecos[i] > 0) {
          if (idx == -1 || huecos[i] > huecos[idx]) idx = i;
        }
      }
      if (idx == -1) {
        sinManga.add(eq);
        continue;
      }
      cubos[idx].add(eq);
      huecos[idx]--;
    }

    // Reordenar cada manga por puntuación descendente
    for (final cubo in cubos) {
      cubo.sort((a, b) => b.puntuacion.compareTo(a.puntuacion));
    }

    final out = <MangaGenerada>[];
    for (var i = 0; i < numMangas; i++) {
      out.add(MangaGenerada(
        nombre: config.nombresMangas[i],
        equipos: cubos[i],
      ));
    }
    return ResultadoGeneracion(mangas: out, sinManga: sinManga);
  }

  /// Calcula cuántos equipos van en cada manga.
  ///
  /// Regla:
  /// - 1..tamMax equipos → 1 manga con todos (acumulando hasta tamMax)
  /// - 11 equipos → 5 + 6 (1ª con menos, caso especial)
  /// - 12+ equipos → reparto lo más igualado posible. Si la división es
  ///   impar, las primeras mangas tienen 1 equipo más que las últimas.
  static List<int> _distribuirEquipos(int total, int numMangas,
      {int tamMax = 10}) {
    if (total <= 0 || numMangas <= 0) return [];
    if (numMangas == 1) return [total];

    if (total == 11 && numMangas == 2) {
      return [5, 6];
    }

    final base = total ~/ numMangas;
    final resto = total % numMangas;
    return List.generate(
      numMangas,
      (i) => i < resto ? base + 1 : base,
    );
  }

  /// Calcula automáticamente el número de mangas necesario según el total
  /// de equipos y el tamaño máximo por manga.
  static int numMangasSugerido({required int totalEquipos, int tamMax = 10}) {
    if (totalEquipos <= 0) return 1;
    if (totalEquipos <= tamMax) return 1;
    return (totalEquipos / tamMax).ceil();
  }

  /// Sugiere nombres de mangas según el número.
  static List<String> sugerirNombresMangas(int numMangas) {
    const dias = ['Jueves 21:00', 'Jueves 23:00', 'Viernes 21:00',
        'Viernes 23:00', 'Sábado 18:00', 'Sábado 21:00'];
    return List.generate(
      numMangas,
      (i) => i < dias.length ? dias[i] : 'Manga ${i + 1}',
    );
  }

  /// Sugiere una estructura de mangas a partir de las preferencias de día
  /// de los equipos. Para cada día presente, calcula cuántas mangas hacen
  /// falta (basado en tamMax) y genera nombres como "Jueves 21:00".
  ///
  /// Equipos sin preferencia se incluyen como capacidad extra en las mangas
  /// existentes — no se crean mangas adicionales solo para ellos.
  static List<String> sugerirMangasPorPreferencia({
    required List<EquipoSemilla> equipos,
    int tamMax = 10,
  }) {
    final porDia = <String, int>{};
    int sinPref = 0;
    for (final e in equipos) {
      final p = (e.preferenciaDia ?? '').trim();
      if (p.isEmpty) { sinPref++; continue; }
      final norm = _norm(p);
      String? dia;
      for (final d in const ['jueves', 'viernes', 'sabado', 'domingo',
          'lunes', 'martes', 'miercoles']) {
        if (norm.contains(d)) { dia = d; break; }
      }
      if (dia == null) { sinPref++; continue; }
      porDia.update(dia, (v) => v + 1, ifAbsent: () => 1);
    }
    // Orden estándar de días
    const orden = ['lunes', 'martes', 'miercoles', 'jueves',
        'viernes', 'sabado', 'domingo'];
    final out = <String>[];
    final entradas = porDia.entries.toList()
      ..sort((a, b) =>
          orden.indexOf(a.key).compareTo(orden.indexOf(b.key)));
    for (final e in entradas) {
      final total = e.value; // equipos exclusivos de ese día
      final num = (total / tamMax).ceil().clamp(1, 10);
      for (var i = 0; i < num; i++) {
        final hora = i == 0 ? '21:00' : '23:00';
        out.add('${_capitalizar(e.key)} $hora');
      }
    }
    // Si solo hay equipos sin preferencia, una manga genérica
    if (out.isEmpty && sinPref > 0) {
      final num = (sinPref / tamMax).ceil().clamp(1, 10);
      for (var i = 0; i < num; i++) {
        out.add('Manga ${i + 1}');
      }
    }
    return out;
  }

  static String _capitalizar(String s) {
    if (s.isEmpty) return s;
    if (s == 'miercoles') return 'Miércoles';
    if (s == 'sabado') return 'Sábado';
    return s[0].toUpperCase() + s.substring(1);
  }

  static String _norm(String s) {
    return s
        .toLowerCase()
        .replaceAll(RegExp(r'[áàä]'), 'a')
        .replaceAll(RegExp(r'[éèë]'), 'e')
        .replaceAll(RegExp(r'[íìï]'), 'i')
        .replaceAll(RegExp(r'[óòö]'), 'o')
        .replaceAll(RegExp(r'[úùü]'), 'u')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
