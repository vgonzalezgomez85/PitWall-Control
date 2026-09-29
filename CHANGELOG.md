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

## [1.12.0] — 2026-09-26

### Añadido
- **Cambios a mano en las mangas el día de carrera:**
  - **Renumerar carriles** (botón en el detalle de la manga, solo campeonatos individuales): vuelve a asignar los carriles por puntos, de más a menos, 1 al número de carriles de la manga y luego D1, D2…
  - **Intercambiar carril con…** en el menú de cada piloto de la manga.
  - **Pisters editables** en "Editar manga" (solo individuales): elige qué manga hace de pisters en esta, o ninguna.
  - **Aviso de carriles repetidos** en el detalle de la manga, con los pilotos afectados.
  - **Dar de baja de la prueba** a un piloto que se borra: desde Inscritos, desde el menú del piloto en el detalle de la manga o con el botón rojo en "Editar mangas". Lo quita de Inscritos y de su manga; el resto de carriles no cambia (se puede renumerar después).

### Corregido
- **"Quitar" en Inscritos dejaba al piloto dentro de su manga.** Ahora es "Dar de baja" y lo quita de las dos. Y "Quitar de la manga" lo devuelve a Inscritos como pendiente de manga.
- **"Editar mangas" no se refrescaba** al mover o quitar un piloto hasta volver a abrir la pantalla.
- **Al mover un piloto a otra manga se llevaba su carril**, y podía quedar repetido en la manga de destino. Ahora llega sin carril, para asignárselo allí.

## [1.11.0] — 2026-09-26

### Añadido
- **Generar mangas: asignar carril y pisters automáticamente (solo campeonatos individuales).** Dos opciones nuevas en el asistente, desmarcadas por defecto:
  - **Asignar carril automáticamente**: dentro de cada manga, por puntos de más a menos, los pilotos salen en los carriles 1 al número de carriles y, si hay más, D1, D2… (descansos).
  - **Asignar pisters**: entre las mangas del mismo día. Con 2 mangas, los de la 2ª hacen de pisters en la 1ª y viceversa; con 3, los de la 3ª en la 1ª, los de la 1ª en la 2ª y los de la 2ª en la 3ª; con 4, 1ª↔2ª y 3ª↔4ª (con más mangas, parejas y, si son impares, las tres últimas en ciclo).
  - Se ven en la vista previa, en el detalle de la manga ("Pisters: pilotos de…" con sus nombres) y en el PDF de mangas.

### Corregido
- **Las mangas creadas con el asistente se guardaban siempre con 10 carriles**, fuese cual fuese el número elegido. Ahora guardan los carriles del asistente.

## [1.10.2] — 2026-09-25

### Corregido
- **El generador de mangas dejaba carriles vacíos en la última manga del día.** Con 17 pilotos el jueves y 6 carriles salían 3 mangas de 6 + 6 + 5, con la de 5 al final. Ahora se hacen tantas mangas como carriles completos se puedan llenar y lo que sobra se reparte entre ellas: 17 → 2 mangas de 9 + 8 (13 → 7 + 6; 16 → 8 + 8). Si se fuerzan más mangas a mano, la manga con menos pilotos va delante y la última siempre llena los carriles (17 en 3 → 5 + 6 + 6).
- **Los equipos sin día preferido se quedaban fuera ("sin manga") si las mangas ya estaban llenas.** Ahora van a la manga con menos equipos.

## [1.10.1] — 2026-09-25

### Corregido
- **En campeonatos individuales, las inscripciones desde Google Sheets o archivo no reconocían a los pilotos nuevos.** Solo se buscaba por nombre de equipo, así que un piloto dado de alta desde la hoja de pilotos (que aún no tiene su equipo de un piloto) salía como "No reconocido" / "No existe". Ahora, en formato individual, también se busca por el nombre del piloto del campeonato y, si no tiene equipo, se le crea con la copa del campeonato, igual que al inscribirlo a mano. Vale para "Actualizar desde Drive", "Vincular Google Sheet" y "Desde archivo CSV / Excel".
- **El resumen de "Actualizar desde Drive" en Inscritos muestra los nombres no reconocidos**, para saber qué revisar en la hoja.

## [1.10.0] — 2026-09-23

### Añadido
- **Fotos de coche sincronizadas con Google Sheets/Drive.** En la hoja de coches, una columna **FOTO** con el enlace de Drive de la imagen (Compartir → Copiar enlace):
  - **Actualizar desde Drive** descarga la foto (reducida a JPEG de 1600 px como máximo) y la asigna al coche. Solo se vuelve a descargar si cambia el enlace; una celda vacía no borra la foto local.
  - **Subir al Sheet** sube a Drive (carpeta "PitWall Control - Fotos coches") las fotos que solo están en la app y escribe su enlace en la hoja, solo si la celda FOTO está vacía.
  - Los vínculos de hoja ya creados detectan la columna FOTO por su cabecera, sin tener que volver a importar. No sirven las imágenes pegadas dentro de la celda ni `=IMAGE()`: tiene que ser el enlace en texto.

## [1.9.5] — 2026-09-23

### Mejorado
- **Chasis deja de tener copa: en la verificación salen siempre todos.** Antes, un chasis sin copa no se podía usar y el desplegable salía vacío (la hoja de chasis no tiene columna de copa). La pantalla de Chasis ya no pide copas, y el Excel de catálogos exporta los chasis sin la columna Copas.

## [1.9.4] — 2026-09-23

### Corregido
- **"Actualizar desde Drive" duplicaba el catálogo entero la primera vez que la hoja tenía columna ID.** Las filas locales aún no tenían ID, así que ninguna casaba y se creaban todas de nuevo. Ahora, si una fila de la hoja no casa por ID, se adopta la fila local sin ID con la misma clave (nombre+marca en coches, código en marcas, nombre+copas en motores, etc.): se le asigna el ID y se actualiza en vez de duplicarla. Vale para todos los catálogos.

## [1.9.3] — 2026-09-23

### Corregido
- **Al cambiar la copa en la verificación, el desplegable de coches seguía mostrando coches de otra copa.** Si ningún coche tenía la copa exacta, se mostraban los de todas las copas del campeonato (p. ej. los GT3 al pasar a LMP-2). Ahora solo salen los de la copa elegida y, si no hay ninguno, el campo lo avisa.
- **Las copas se comparan ignorando guiones, puntos y espacios**, además de mayúsculas: "LMP-2", "LMP 2" y "LMP2" cuentan como la misma copa en todos los filtros de la verificación.

## [1.9.2] — 2026-09-23

### Corregido
- **Los gauss (uMs) del motor propio se comprobaban como mínimo y son un máximo.** La ficha de verificación ahora muestra "Máx" bajo uMs, y marca como infracción un imán por encima de la referencia del catálogo (antes lo hacía con uno por debajo).

## [1.9.1] — 2026-09-23

### Corregido
- **La copa cambiada desde la ficha de verificación no se veía fuera de ella.** La lista de Verificaciones, Inscritos y Editar mangas seguían mostrando la copa del equipo (p. ej. LMP) aunque en esa prueba corriera otra. Ahora muestran la copa de la prueba, y la lista de Verificaciones se actualiza al volver de la ficha. El generador de mangas también agrupa por la copa de la prueba.

## [1.9.0] — 2026-09-22

### Añadido
- **Campo "minutos por carril" en Generar mangas.** Junto a los carriles, calcula la duración real de una manga (carriles × minutos por carril) y espacia los horarios sugeridos por esa duración exacta en vez de un salto fijo de 2 horas.
- **Nueva pantalla "Puntuación previa" en Pilotos**, para importar desde Excel/CSV la puntuación de temporada anterior de los pilotos ya inscritos en el campeonato activo (cruzando por nombre). Sirve como semilla de orden solo para "Generar mangas" en la primera prueba de un campeonato nuevo; en cuanto hay resultados propios, la clasificación real toma el relevo sola. Si una celda trae una fórmula sin calcular (p. ej. VLOOKUP sin valor en caché), la vista previa lo avisa en vez de guardar un 0 en silencio.

## [1.8.1] — 2026-09-22

### Corregido
- **El generador de mangas repetía el mismo horario sugerido a partir de la tercera manga del mismo día** (p. ej. dos mangas seguidas a "Jueves 23:00"). Ahora cada manga adicional del día suma 2 horas (21:00, 23:00, 01:00...).
- **El número de mangas sugerido redondeaba siempre hacia arriba**, dejando a veces una manga casi vacía (13 equipos con máximo 6 → 6+6+1). Ahora solo se añade una manga extra si el resto por repartir supera la mitad del máximo por manga; si no, se reparte entre las mangas existentes aunque acaben un poco por encima del máximo (13 → 7+6; 15 y 15 → 2 mangas de 8+7 cada día, no 3).

## [1.8.0] — 2026-09-22

### Mejorado
- **Cambia el criterio de "sin copa/categoría" en el catálogo (coches, motores, llantas, neumáticos, engranajes, bancadas, chasis): antes valía para todas las copas, ahora no se puede usar en ninguna.** Un componente sin copa asignada deja de aparecer en las verificaciones hasta que se le marque explícitamente una; si para una copa concreta no hay ningún componente marcado, ese desplegable sale vacío en vez de mostrar el catálogo entero sin filtrar. Afecta directamente a los catálogos que se acaban de sincronizar con Sheets: hay que revisar y asignar copa a los componentes que la tengan sin rellenar en la hoja para que vuelvan a estar disponibles.

## [1.7.0] — 2026-09-22

### Añadido
- **Engranajes ahora guarda diámetro en vez de marca**, para cuadrar con la hoja real (que ya no tiene columna de marca). Afecta al modelo de datos, la pantalla de edición, la exportación/plantilla Excel y la sincronización con Sheets.
- **Copa/categoría sincronizable en Llantas, Neumáticos, Engranajes y Bancadas**, con el mismo criterio que ya tenían Coches y Motores (antes ni se subía ni se bajaba).

### Corregido
- **Al actualizar Coches desde Drive, la copa/categoría nunca se guardaba** aunque cambiara en la hoja — se quedaba fuera de la comparación y de la escritura.
- **Varios vínculos con Google Sheets apuntaban a pestañas o cabeceras que ya no existían** (renombradas en la hoja después de vincular): Coches y Copas/Categorías buscaban la columna "COPA" en vez de "CATEGORÍA/COPA"; Copas apuntaba a la pestaña "COPAS/CATEG." en vez de "COPASCATEG."; Llantas apuntaba a "DIAMETRO RUEDAS" en vez de "LLANTAS"; Neumáticos apuntaba a "NEUMATICOS" sin tilde en vez de "NEUMÁTICOS"; Engranajes buscaba una columna "MARCA" que ya no existe. Todos corregidos.

## [1.6.0] — 2026-09-22

### Añadido
- **Sincronización por ID extendida a todos los catálogos** (coches, marcas, llantas, engranajes, bancadas, neumáticos, copas y clubs), con el mismo criterio validado en Motores: si la hoja vinculada tiene una columna "ID", subir/bajar/borrar empareja por ese identificador en vez de por el nombre. Cada catálogo sin esa columna sigue funcionando exactamente como antes.

## [1.5.0] — 2026-09-22

### Añadido
- **Sincronización por ID con Google Sheets (piloto: Motores).** La hoja puede tener una columna "ID": si existe, subir y bajar el catálogo empareja las filas por ese identificador en vez de por el nombre, así que un motor con el mismo nombre repetido en varias copas (p. ej. "BOXER 2" en GRUPO C, GT, GT2...) ya no se confunde ni se duplica. Los motores locales sin id reciben uno correlativo automáticamente la primera vez que se suben; las filas nuevas tecleadas directamente en la hoja se importan y se les asigna id igual. Borrar un motor en la app ahora también se puede propagar a la hoja: aparece como "a borrar" en la pantalla de revisión de la subida, para confirmarlo antes de que se borre de verdad. El resto de catálogos (coches, marcas, llantas...) siguen funcionando igual que antes.

### Corregido
- **Al subir el catálogo a Google Sheets, las filas nuevas podían acabar en columnas cada vez más a la derecha** en vez de bajo la cabecera real, si la hoja tenía algún bloque de datos suelto en otra zona. Ahora el añadido de filas fija explícitamente el rango de columnas de la cabecera detectada, así que siempre escribe justo debajo de ella.
- **Los valores decimales (gauss, peso mínimo...) podían llegar a Sheets convertidos en fechas** (p. ej. "5.5" se guardaba como el número de serie de "5 de mayo") por la forma en que Sheets interpreta texto con punto decimal en hojas con configuración regional española. Ahora se envían como números reales, no como texto, así que no hay ninguna conversión de por medio.

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
