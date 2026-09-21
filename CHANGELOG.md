# Historial de versiones — PitWall Control

La versión vive en `pubspec.yaml` y se muestra en el menú lateral de la app
(enlaza a "Novedades").

**Criterio de numeración (vMAYOR.MENOR.PARCHE):**
- **v1.0.X** — correcciones y ajustes pequeños (fixes, retoques visuales, textos).
- **v1.X.0** — funcionalidades nuevas (una feature completa).
- **vX.0.0** — cambios muy grandes (rediseños, rupturas de compatibilidad).

Cada cambio que se mergea debe subir la versión y añadir aquí su entrada, en la
sección que toque: **Añadido** (nuevo), **Mejorado** (existente a mejor),
**Corregido** (bugs).

---

## [1.4.0] — 2026-09-21

### Añadido
- **Editar la copa/categoría de un equipo o piloto desde la propia verificación.** En la cabecera de la ficha, junto al nombre, se puede tocar "Copa X" para cambiarla — el cambio aplica solo a esta prueba (no reclasifica al equipo en el resto del campeonato) y es justo la copa que se usa ahí mismo para filtrar catálogos (coches, motores, neumáticos, llantas...) y comprobaciones (piñón/corona, anchura de eje).

## [1.3.1] — 2026-09-21

### Mejorado
- **El apartado "Carrocería" de la ficha de verificación se mueve justo después de elegir el modelo de coche** (antes salía al final, tras piñón/corona/bancada/peso del coche entero).

## [1.3.0] — 2026-09-21

### Añadido
- **Apartado "Carrocería" en la ficha de verificación**, justo después de "Coche": agrupa el peso de carrocería (que antes estaba junto al motor) y añade un nuevo check de estética — "Bien" o "Faltan piezas", con un cuadro de texto para anotar qué piezas faltan cuando aplica. Aparece también en el PDF de verificaciones.

## [1.2.2] — 2026-09-20

### Corregido
- **Inscribir a un piloto en una prueba de un campeonato individual seguía sin mostrar la lista de pilotos** cuando ninguno tenía todavía una "inscripción" (equipo de 1) creada. Ahora la propia hoja de "Inscribir pilotos" lista directamente a los pilotos del campeonato que aún no la tienen (junto con los que ya la tienen) y crea esa inscripción al vuelo, con la copa elegida arriba, al confirmar.

## [1.2.1] — 2026-09-20

### Corregido
- **"Verificaciones" había quedado sin ningún acceso** al quitarla del menú general: ahora tiene su propia entrada en el panel de cada prueba, junto a "Sorteo de motores" y "Resultados" (filtrada a las mangas de esa prueba).
- **Al inscribir a un piloto en una prueba de un campeonato individual, si aún no tenía "inscripción" (equipo de 1) creada, la lista salía vacía** sin explicar por qué. Ahora, si no hay ninguna todavía, aparece un botón para crearla ahí mismo sin salir de la prueba.

## [1.2.0] — 2026-09-20

### Añadido
- **Nuevas categorías en el catálogo**: Grupo 5, Porsche, F1 y F1 Clásicos. Además, "SLOT.IT" pasa a llamarse "Copa Slot.it" y las categorías sueltas "P1"/"P2" se unifican en "Clásicos P1"/"Clásicos P2" (se renombran también en los campeonatos, equipos y catálogos que ya las usaban).

### Mejorado
- **Reglas del campeonato reorganizadas con títulos por bloque**: Créditos, Tesorería y Puntuación, con el tope de créditos junto al interruptor de créditos y las cuotas junto al de tesorería.
- **"Verificaciones" y "Sorteo de motor" ya no están en el menú general**: se siguen abriendo desde dentro de cada prueba, donde ya tenían su acceso.
- **Inscribir en una prueba de un campeonato individual ya no habla de "equipos"**: tanto la pantalla de inscritos como el importador de CSV/Excel y el de Google Sheets muestran "piloto(s)" en vez de "equipo(s)" cuando el campeonato no usa parejas.

## [1.1.0] — 2026-09-08

### Añadido
- **Tabla de puntos de clasificación personalizable por campeonato.** Nueva pantalla "Tabla de puntos" (en Clasificación): edita cuántas posiciones puntúan y cuántos puntos da cada una, o restaura los valores por defecto. Cada campeonato ya guardaba su propia tabla, pero no había forma de editarla desde la app.
- **Check "Altura de motor a pista" en la ficha de verificación.** Conforme / No conforme / sin comprobar (con la plancha, sin medida en mm). Marca infracción automática si es "No conforme" y se refleja en el PDF.
- **"Anchura de eje" delantero y trasero en la ficha de verificación**, con un máximo configurable por copa/categoría en el editor del campeonato. Infracción automática si se supera, con icono ✓/✗ en vivo y fila propia en el PDF.
- **Icono ✓/✗ en vivo para RPM y uMs del motor propio**, junto a los campos, comparando contra la referencia del motor de catálogo elegido (la comprobación ya existía, solo faltaba verse ahí).

### Mejorado
- **Campeonatos individuales ya no piden nombre de equipo al inscribir a un piloto.** El nombre se autocompleta con el del piloto y la pantalla pasa a llamarse "Inscripciones" en vez de "Equipos".
- **Los desplegables de verificación toleran catálogos con nombres duplicados** (bancada, chasis, dientes de piñón/corona): antes, dos filas de catálogo con el mismo nombre hacían crashear la pantalla.

## [1.0.1] — 2026-09-08

### Corregido
- **Exportar el PDF de verificaciones con fotos podía fallar por completo** si alguna foto estaba en un formato que la librería de PDF no sabe decodificar (HEIC en bruto, de datos antiguos). Ahora esa foto se omite en vez de tumbar toda la exportación, y las fotos se comprimen antes de incrustarse (bastaba con mucha menos resolución que la de cámara para una miniatura del PDF).
- **Catálogos con nombres duplicados** (por ejemplo dos bancadas con el mismo nombre) hacían crashear el desplegable correspondiente en la ficha de verificación. Se deduplican al mostrarlos y se limpian los duplicados existentes en la base de datos.

## [1.0.0] — 2026-07-06

Primera versión con verificaciones, catálogos, clasificación, tesorería,
créditos, sorteo de motor e integración con PitWall Manager.
