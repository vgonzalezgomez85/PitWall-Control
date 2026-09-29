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
  /// Distribuye los equipos en mangas según las reglas de reparto:
  ///
  /// **Preferencia de día estricta**: un equipo con preferencia "Jueves"
  /// SOLO va a mangas cuyo nombre contiene "Jueves". Si no hay manga de ese
  /// día, el equipo queda en `sinManga`.
  ///
  /// Para cada GRUPO de mangas del mismo día, se aplica la regla de reparto:
  /// - `tamMaxManga` = carriles (default 10). La última manga del día nunca
  ///   deja carriles vacíos si se puede evitar (ver [_distribuirEquipos]).
  /// - Los equipos con MÁS puntos van a la manga más TARDÍA del día
  ///   (las mangas se llenan de la última a la primera).
  ///
  /// Los equipos sin preferencia de día se distribuyen entre las mangas
  /// que aún tengan hueco, llenando primero las que tienen más capacidad;
  /// si todas están llenas, van a la manga con menos equipos.
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
    // Los equipos van en ranking descendente y las mangas del día se llenan
    // de la ÚLTIMA a la PRIMERA: los equipos con más puntos corren en la
    // manga más tardía del día.
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
      // Orden de llenado: última manga del día primero.
      final ordenLlenado = [for (var k = indices.length - 1; k >= 0; k--) k];
      var pos = 0;
      for (final eq in eqs) {
        while (pos < ordenLlenado.length &&
            cubos[indices[ordenLlenado[pos]]].length >=
                tamanos[ordenLlenado[pos]]) {
          pos++;
        }
        if (pos >= ordenLlenado.length) {
          sinManga.add(eq);
          continue;
        }
        cubos[indices[ordenLlenado[pos]]].add(eq);
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
      // La manga con más hueco; si todas están llenas (las mangas pueden
      // pasar del número de carriles), la que tenga menos equipos.
      var idx = 0;
      for (var i = 1; i < numMangas; i++) {
        if (huecos[i] > huecos[idx]) idx = i;
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
  /// Reparto lo más igualado posible; lo que sobra de la división decide
  /// qué mangas llevan un equipo más. La ÚLTIMA manga no puede dejar
  /// carriles vacíos, así que:
  /// - Si las mangas no llegan a llenar los carriles (`base < tamMax`), el
  ///   equipo de más va a las ÚLTIMAS: 17 con 6 carriles en 3 mangas →
  ///   5 + 6 + 6; 11 con 10 en 2 → 5 + 6.
  /// - Si todas llenan los carriles, va a las PRIMERAS: 17 con 6 en 2
  ///   mangas → 9 + 8.
  static List<int> _distribuirEquipos(int total, int numMangas,
      {int tamMax = 10}) {
    if (total <= 0 || numMangas <= 0) return [];
    if (numMangas == 1) return [total];

    final base = total ~/ numMangas;
    final resto = total % numMangas;
    final extraAlFinal = base < tamMax;
    return List.generate(numMangas, (i) {
      final conExtra = extraAlFinal ? i >= numMangas - resto : i < resto;
      return conExtra ? base + 1 : base;
    });
  }

  /// Calcula automáticamente el número de mangas necesario según el total
  /// de equipos y el tamaño máximo por manga (carriles).
  ///
  /// Tantas mangas como carriles completos se puedan llenar (hacia abajo):
  /// ninguna manga deja carriles vacíos y lo que sobra se reparte entre
  /// ellas, aunque pasen un poco del número de carriles (los equipos rotan).
  /// P.ej. con 6 carriles: 13 → 2 mangas (7+6); 16 → 8+8; 17 → 9+8.
  /// Con menos equipos que carriles, una sola manga.
  static int numMangasSugerido({required int totalEquipos, int tamMax = 10}) {
    if (totalEquipos <= tamMax) return 1;
    return totalEquipos ~/ tamMax;
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
  ///
  /// [duracionMangaMinutos] espacia el horario sugerido de cada manga del
  /// mismo día esa cantidad exacta de minutos (duración real de una manga:
  /// carriles × minutos por carril), en vez de un salto fijo de 2 horas.
  static List<String> sugerirMangasPorPreferencia({
    required List<EquipoSemilla> equipos,
    int tamMax = 10,
    int duracionMangaMinutos = 120,
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
      final num = numMangasSugerido(totalEquipos: total, tamMax: tamMax)
          .clamp(1, 10);
      for (var i = 0; i < num; i++) {
        // Slots empezando a las 21:00, separados por la duración real de
        // una manga (carriles × minutos por carril) para que cada manga
        // del mismo día tenga un horario distinto y realista.
        final minutosDesde21 = i * duracionMangaMinutos;
        final totalMin = (21 * 60 + minutosDesde21) % (24 * 60);
        final horaNum = totalMin ~/ 60;
        final minNum = totalMin % 60;
        final hora =
            '${horaNum.toString().padLeft(2, '0')}:${minNum.toString().padLeft(2, '0')}';
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

  /// Carriles de salida para una manga de [numEquipos] ya ordenada por
  /// puntuación descendente (solo individuales): los primeros [carriles]
  /// salen del 1 al N y el resto descansan D1, D2…
  static List<String> carrilesSalida(int numEquipos, int carriles) => [
        for (var i = 0; i < numEquipos; i++)
          i < carriles ? '${i + 1}' : 'D${i - carriles + 1}',
      ];

  /// Qué manga hace de pisters en cada una (solo individuales). Devuelve,
  /// para cada índice de [nombresMangas], el índice de la manga cuyos
  /// pilotos hacen de pisters en ella (o null si va sola en su día).
  ///
  /// Se empareja dentro de cada día, en el orden en que aparecen:
  /// - 2 mangas: 1↔2. 4: 1↔2 y 3↔4. Número par → siempre parejas.
  /// - 3 mangas: la 3ª hace de pisters en la 1ª, la 1ª en la 2ª y la 2ª en
  ///   la 3ª. Número impar (5, 7…) → parejas y las tres últimas en ese ciclo.
  static List<int?> asignarPisters(List<String> nombresMangas) {
    final porDia = <String, List<int>>{};
    for (var i = 0; i < nombresMangas.length; i++) {
      porDia.putIfAbsent(_diaDe(nombresMangas[i]) ?? '', () => []).add(i);
    }
    final out = List<int?>.filled(nombresMangas.length, null);
    for (final g in porDia.values) {
      final n = g.length;
      if (n < 2) continue;
      final parejas = n.isEven ? n : n - 3;
      for (var k = 0; k < parejas; k += 2) {
        out[g[k]] = g[k + 1];
        out[g[k + 1]] = g[k];
      }
      if (n.isOdd) {
        final a = g[n - 3], b = g[n - 2], c = g[n - 1];
        out[a] = c;
        out[b] = a;
        out[c] = b;
      }
    }
    return out;
  }

  static String? _diaDe(String nombre) {
    final nom = _norm(nombre);
    for (final dia in const ['jueves', 'viernes', 'sabado', 'domingo',
        'lunes', 'martes', 'miercoles']) {
      if (nom.contains(dia)) return dia;
    }
    return null;
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
