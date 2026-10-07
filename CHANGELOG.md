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

## [1.23.2] — 2026-10-07
### Mejorado
- **Quitar un participante de una verificación libre ahora es un botón visible.** Cada participante tiene una papelera junto a su estado; antes solo se podía con una pulsación larga y no se descubría. Sigue pidiendo confirmación y borra también su verificación.

## [1.23.1] — 2026-10-07
### Mejorado
- **Guía «Cómo conseguirlas» de Google más clara.** Ahora son 7 pasos con los nombres actuales de Google Cloud (Google Auth Platform, «Usuarios externos», «Clientes»), enlaces directos a cada pantalla, aviso de añadir tu cuenta como usuario de prueba (si no, sale el «Error 403: access_denied»), de descargar el JSON porque el secreto solo se ve al crearlo, y de publicar la aplicación para que la conexión no caduque a los 7 días. Incluye un botón al manual con capturas. El diagnóstico del error 403 explica ahora también cómo arreglarlo.

## [1.23.0] — 2026-10-06
### Añadido
- **Las verificaciones guardan el reglamento con el que se hicieron.** Al verificar se guardan también el peso mínimo y los créditos del coche, la referencia del motor propio, la anchura máxima de eje, los fabricantes permitidos y las listas homologadas del catálogo (llantas, bancadas, neumáticos, marcas). Una verificación **validada**, o de un campeonato finalizado o una prueba terminada, se comprueba siempre con esos valores, aunque luego se cambie el catálogo o el campeonato. Así, cambiar por ejemplo el peso mínimo de una carrocería ya no altera las verificaciones de campeonatos cerrados ni las ya validadas.
  - En la ficha sale el aviso **Reglamento congelado** con la fecha y, si algo ha cambiado desde entonces, la lista de qué ha cambiado. Con **Usar el reglamento actual** se puede pasar a los valores de hoy (si está validada, se recalculan sus créditos).
  - Si en una verificación congelada se cambia el coche, el motor o la copa, solo esa parte se recalcula con los valores actuales; el resto sigue igual.
  - Los **créditos** que se descuentan o devuelven al revalidar o sincronizar una verificación usan los créditos del coche con los que se verificó, no los del catálogo de hoy.
  - La rejilla de verificaciones, su Excel, el PDF y el envío a PitWall Manager usan también el reglamento congelado (nombre del coche, mínimos y máximos).
  - Las verificaciones que ya había se congelan solas al abrir esta versión, con el peso mínimo que ya tenían guardado y el resto de valores del catálogo actual.
- **Verificaciones bloqueadas en campeonatos finalizados y pruebas terminadas.** Se abren en solo lectura (con un candado) para no cambiarlas sin querer. Si hace falta corregir algo, **Desbloquear** permite editarla tras confirmar. El sorteo de motores de esas pruebas también queda en solo lectura.
- **Peso mínimo y créditos de los coches por campeonato.** En **Editar campeonato → Coches (verificación)** se pueden fijar el peso mínimo y los créditos de cada coche solo para ese campeonato; lo que se deja vacío sigue al catálogo. **Fijar los valores actuales del catálogo** los copia de una vez, y así se puede cambiar el catálogo para la temporada siguiente sin afectar a la que está en marcha. Al marcar un campeonato como finalizado, sus coches se fijan solos con los valores del catálogo.

## [1.22.0] — 2026-10-05
### Añadido
- **Verificar entre varios, a la vez y sin internet.** Varios Controls (Mac, Windows o Android) pueden verificar la misma prueba al mismo tiempo, cada uno en su dispositivo, y se pasan los cambios por la wifi. No hace falta internet: vale un router sin conexión o el punto de acceso de un móvil. Se abre desde el menú de la prueba, **Verificar entre varios**, o con el nuevo icono de sincronizar en **Verificaciones**.
  - Cada Control se pone un **nombre** (p. ej. «Mesa 1») y todos la misma **clave del evento**. Al encender **Conectar con otros Controls**, se encuentran solos en la red; si el router no lo permite, se añaden escribiendo la IP que sale en la pantalla del otro.
  - Viajan las **verificaciones** (con sus **fotos**), los **borrados**, la **copa** de cada equipo en la prueba y los **cobros** de la tesorería. Se sincroniza solo cada 20 s o con **Sincronizar ahora**. Los cambios pasan de un Control a otro aunque no se hayan sincronizado directamente entre sí.
  - Si dos tocan la misma verificación, **gana el último cambio**. Por eso conviene tener la hora automática en todos; la app avisa si un dispositivo va con la hora desfasada.
  - Los **créditos** no se descuentan dos veces: cada Control calcula los suyos al recibir una verificación validada.
  - Si tienes abierta una verificación y otro Control la cambia, se actualiza en pantalla. Si estabas a medio editar, te avisa para elegir con qué te quedas.
  - Antes del evento, todos deben partir de la **misma copia de datos** (campeonato, prueba, mangas y equipos). La verificación libre no se sincroniza.

## [1.21.2] — 2026-10-05

### Corregido
- **Excel con fotos: en el móvil las fotos no salían en su sitio.** En iPhone/iPad (y en la vista previa y Numbers del Mac) todas las fotos se amontonaban arriba a la izquierda. Esos visores colocan las imágenes por su posición absoluta y miden las columnas de otra forma que Excel; ahora el archivo la incluye calculada a su medida, y cada foto cae en su fila y su columna. En Excel y LibreOffice se sigue viendo igual.

## [1.21.1] — 2026-10-05

### Mejorado
- **Excel de la verificación libre: incluye la foto del catálogo del coche.** Nueva columna «Foto catálogo» justo antes de las fotos de la verificación, para comparar de un vistazo el coche de referencia con el que se ha verificado. Si ningún coche de la sesión tiene foto en el catálogo, la columna no aparece.

## [1.21.0] — 2026-10-05

### Añadido
- **Cobrar desde la verificación.** Si el campeonato gestiona tesorería, la verificación de cada equipo tiene un bloque **Tesorería** con el mismo formulario que la tesorería de la prueba: Pagat / Coordinadora / Club, observaciones, pago rápido, «Coord. + piloto», «Coord. total», wildcard y limpiar. Se guarda al momento y se ve igual desde la tesorería de la prueba (y al revés), así que no hace falta salir de la verificación para cobrar. No aparece en la verificación libre ni en campeonatos sin tesorería.

## [1.20.0] — 2026-10-05

### Añadido
- **Verificación libre: exportar a Excel con las fotos.** Nuevo botón junto al del PDF en la sesión. Genera un `.xlsx` con una fila por participante y las mismas columnas que el resumen de verificaciones (fuera de reglamento en rojo y una columna con los motivos); al final de cada fila van **todas sus fotos incrustadas**, una por columna, como miniatura dentro de la celda. Al ampliarlas en Excel se ven a 800 px. Una foto que no se pueda leer (p. ej. HEIC antigua) sale como «(foto no compatible)» en vez de fallar.

## [1.19.1] — 2026-10-05

### Mejorado
- **Nueva sesión de verificación libre, igual que un campeonato nuevo.**
  - Empieza **en blanco**: ya no copia copas, anchuras, fabricantes ni sorteo de la sesión anterior.
  - Nuevo apartado **Motor** con **Sorteo / Propio / Mixto**: con Sorteo o Propio, la verificación no pregunta el tipo de motor. Las sesiones que ya existían quedan como Mixto.
  - Se quita **Transmisión**: los dientes de piñón y corona salen del catálogo de engranajes de la copa, igual que en los campeonatos. El rango de dientes deja de comprobarse también en las sesiones libres.

## [1.19.0] — 2026-10-05

### Añadido
- **El tipo de motor se elige al crear el campeonato.** Nuevo apartado «Motor (verificación)» con tres opciones: **Sorteo** (motores de la organización), **Propio** (cada equipo trae el suyo) o **Mixto** (se marca en cada verificación, como hasta ahora). Con Sorteo o Propio, la verificación ya no muestra el selector «Organización / Propio»: usa directamente el del campeonato. El rango del sorteo solo aparece con Sorteo o Mixto. Los campeonatos que ya existían quedan como Mixto.

## [1.18.2] — 2026-10-05

### Mejorado
- **Nuevo campeonato con las cuotas de tesorería en blanco.** Pagat, Coordinadora y Club ya no vienen rellenos con 25 / 11 / 14. Si el campeonato gestiona tesorería, el Pagat es obligatorio; Coordinadora o Club vacíos cuentan como 0 (y siguen teniendo que sumar el Pagat).

## [1.18.1] — 2026-10-05

### Mejorado
- **Nuevo campeonato sin copas marcadas de serie.** Antes venían marcadas GT, GT2 y Copa Slot.it; ahora el formulario empieza sin ninguna y eliges las del campeonato (sigue haciendo falta al menos una para guardar).

## [1.18.0] — 2026-10-05

### Añadido
- **Los desplegables de la verificación ponen primero lo más usado.** Coche, motor del catálogo, marca y dientes de piñón y corona, materiales, llantas (marca y dimensión), bancada, chasis, neumático y trencilla se ordenan según cuántas veces se ha elegido cada opción en las verificaciones guardadas; lo que nunca se ha usado queda detrás, en el orden de siempre. Cada desplegable cuenta por separado (la marca del piñón no influye en la de la corona) y el orden se actualiza solo al guardar.

## [1.17.8] — 2026-10-05

### Mejorado
- **El campeonato ya no pide «Transmisión (verificación)».** Los dientes de piñón y corona ya se eligen en la verificación del catálogo de engranajes de la copa/categoría del equipo, así que el rango del campeonato sobraba (y era el mismo para todas las copas). Se quita del formulario de crear/editar campeonato y ya no salta infracción ni aviso en la rejilla por ese rango. La **verificación libre** mantiene su propio rango de dientes.

## [1.17.7] — 2026-10-04

### Corregido
- **Generar mangas (individual): los carriles de la vista previa no se guardaban.** El interruptor «Asignar carril automáticamente» venía apagado, pero la vista previa numeraba 1, 2, 3… igualmente, así que parecía que las mangas se creaban con carril. Ahora viene encendido y, si lo apagas, la vista previa muestra «—» en vez de un número.

### Mejorado
- **Asignar carriles a mano, más rápido.** En el detalle de la manga, toca un equipo (o «Cambiar carril» en su menú) y sale una **cuadrícula con todos los carriles**: los libres se ven vacíos y los ocupados con el nombre de quien está. Toca uno libre para moverlo ahí, o uno ocupado para **intercambiarlos**. Sin teclado, y sin poder repetir carril ni poner uno que no existe («Escribir a mano…» sigue disponible para casos especiales).
- **La manga muestra los carriles libres** («Libre») entre los ocupados, para ver la parrilla de un vistazo. Toca uno para elegir qué equipo sale ahí. Los equipos sin carril aparecen al final, en su propio apartado.

## [1.17.6] — 2026-10-04

### Mejorado
- **"Enviar verificaciones a PitWall" ya no envía las fotos**, solo los datos de cada verificación (pesos, motor, piñón, corona, llantas, observaciones…). El envío es mucho más rápido y ligero y ya no falla por tamaño con muchas verificaciones. Las fotos siguen en Control (editor y PDF).

## [1.17.5] — 2026-10-04

### Corregido
- **"Enviar verificaciones a PitWall" daba error 500** cuando había muchas verificaciones con fotos: el envío pesaba demasiado. Ahora las fotos se reducen a 1280 px en JPEG al enviarlas (las de la app no se tocan) y se espera hasta 2 minutos a que acabe. Necesita PitWall Manager 1.42.1 o posterior para envíos grandes.

## [1.17.4] — 2026-10-04

### Corregido
- **Android no podía hablar con PitWall.** En tablets y móviles Android, "Enviar a PitWall", "Ver carreras" (enviar verificaciones) y "Traer resultados" fallaban aunque PitWall apareciera en la lista: Android bloquea por defecto las conexiones `http://` sin cifrar, que es como funciona PitWall Manager en la red local. Ahora se permiten.

### Mejorado
- **Búsqueda de PitWall más fiable.** Si Android falla al resolver el PitWall anunciado en la red, se reintenta en vez de perderlo. Y además de la búsqueda Bonjour/mDNS se prueba la red local directamente, así que PitWall aparece aunque el router bloquee los anuncios de red.

## [1.17.3] — 2026-10-04

### Corregido
- **Autodescubrir PitWall en Android.** En tablets y móviles Android salía "La búsqueda automática no está disponible": faltaba el permiso para escuchar anuncios de red local (multicast) por Wi‑Fi. Ahora los PitWall de la red aparecen en la lista.

## [1.17.2] — 2026-10-04

### Corregido
- **Autodescubrir PitWall en macOS.** "Enviar a PitWall", "Enviar verificaciones a PitWall" y "Traer resultados de PitWall" no encontraban PitWall Manager en la red: la app declaraba a macOS el servicio Bonjour antiguo (`_voltrace-manager`) y el sistema bloqueaba la búsqueda. Ahora aparece en la lista sin tener que escribir la IP.

### Mejorado
- **Selector de PitWall** común a los tres diálogos: se ve "Buscando…" unos segundos en vez de decir al instante que no hay nada, hay botón **"Buscar de nuevo"**, se marca el PitWall elegido y, si no has escrito la dirección a mano, se rellena sola con el PitWall encontrado (también si la IP guardada de la otra vez ha cambiado). Se sigue pudiendo escribir IP:puerto a mano.

## [1.17.1] — 2026-10-03

### Corregido
- **Copa equivocada en PDFs y clasificación.** La copa elegida para una prueba (en la inscripción o en la verificación) no salía en varios sitios, que mostraban la copa por defecto del equipo (p. ej. un GT3 RESISBARNA salía como LMP). Ahora usan la copa de la prueba: PDF de verificaciones (y el máximo de anchura de eje que se aplica), PDF de mangas, resultados de la prueba y de cada manga, tesorería de la prueba y los JSON que se envían a PitWall Manager. En la **clasificación general** la columna Copa muestra la copa con la que el piloto corrió su última prueba, y en la **pestaña de cada copa** (HYP, GT3…) muestra esa copa en vez de LMP.

## [1.17.0] — 2026-10-02

### Añadido
- **Tesorería: reparto de la cuota personalizable.** Botón **"Reparto"** arriba en Tesorería para cambiar el Pagat y cuánto va a la **coordinadora** y cuánto al **club** (al tocar uno, el otro se ajusta para que sumen el Pagat; se ve el % de cada parte). Opción para **aplicarlo también a los pagos ya cobrados**: se vuelve a repartir lo que pagó cada equipo con la nueva proporción, sin cambiar lo cobrado. La cuota actual se muestra encima del balance.

### Mejorado
- **Tesorería de la prueba:** si escribes solo el Pagat a mano, coordinadora y club se rellenan solos con la proporción del campeonato. Si el desglose no suma el Pagat sale un aviso con botón **"Repartir"**.
- **Equipos que no pagan** (wildcard o coordinadora) ya no cuentan como pendientes: el contador muestra "X / Y pagados · N no pagan" y la barra llega al 100 %.
- El editor del campeonato no deja guardar una cuota cuyo desglose (coordinadora + club) no sume el Pagat.

### Corregido
- **Tesorería: "Coord. total" no se guardaba.** Se apuntaba un pago de 0 € y el equipo seguía saliendo como pendiente. Ahora queda marcado como exento en esa prueba (como el wildcard), con botón para quitarlo.
- Los totales del campeonato contaban pagos de equipos ya no inscritos en la prueba o exentos, y no cuadraban con la pantalla de la prueba. Ahora usan el mismo cálculo.
- Los campos de un pago se actualizan si cambia lo guardado (al limpiar, recalcular el reparto…), y "Limpiar" borra bien un pago recién creado.

## [1.16.0] — 2026-10-02

### Añadido
- **Verificación: bloques marcados para no saltarse nada.** Cada bloque (coche, peso, estética, motor, ejes, llantas, piñón, corona, bancada, chasis, peso del coche entero y otros) va en un recuadro sombreado con su estado: **ámbar "Pendiente 1/3"** si le falta algún dato, **verde "Hecho"** cuando está completo y **rojo "Revisar"** si algo está fuera de reglamento. Arriba, una barra con los bloques completos y la lista de los que faltan. Anchura de eje solo cuenta si la copa tiene máximo configurado; observaciones y fotos son opcionales.
- **Tesorería de la prueba: buscador** fijo arriba para encontrar rápido a un piloto o equipo (por nombre, piloto o copa; no distingue acentos).
- **Resumen de verificaciones en rejilla**: nuevo apartado **"Resum. Verifi."** en el menú lateral (y en los accesos de Inicio). Muestra las verificaciones de una prueba en una tabla tipo hoja de cálculo, sin fotos, para echar un vistazo rápido. Es solo de consulta: no se edita nada.
  - Una fila por inscrito: estado (validada / borrador / sin verificar), copa, coche, pesos, motor, altura de motor, ejes, piñón, corona, llantas, trencilla, suspensión, bancada, chasis, neumático, carrocería y observaciones.
  - Lo que está **fuera de reglamento sale en rojo** (peso bajo el mínimo, eje por encima del máximo, dientes fuera de rango, marca no permitida, motor que toca, faltan piezas); al pasar el ratón se ve el motivo.
  - Selector de prueba, buscador y filtros: con infracción, sin verificar y en borrador.
  - La cabecera y la columna del piloto se quedan fijas al desplazarte.
  - También se abre desde la propia prueba: opción **"Resum. Verifi."** en el menú de la prueba y botón de rejilla en la pantalla **Verificaciones** (ya con esa prueba elegida).
  - **Exportar a PDF y a Excel** (botón de descarga arriba a la derecha). Exporta lo que se ve: la prueba elegida con el filtro y la búsqueda aplicados. El PDF cabe en una hoja; el Excel marca en rojo las celdas fuera de reglamento y añade una columna con los motivos.

### Corregido
- **Exportaciones en Android**: los PDF de **mangas**, de **verificaciones de la prueba** y de **créditos**, el CSV de créditos y las **plantillas CSV** daban error en el móvil (abrían un "guardar como" que Android no tiene). Ahora abren la hoja de compartir del sistema, igual que el resto. El Excel de catálogos y el JSON de la tanda, que en el móvil se guardaban en una carpeta interna inaccesible, también se comparten ahora.

## [1.15.2] — 2026-10-02

### Mejorado
- **Inscritos a la prueba: botón para añadir a mano siempre visible** (icono de persona con "+" arriba a la derecha). Antes solo aparecía con la lista vacía.

### Corregido
- **Tesorería: no salían los equipos inscritos a mano desde una manga.** Inscribir desde la manga (o al importar resultados) no los apuntaba a la prueba, que es de donde tira la tesorería. Ahora sí, y al abrir la app se reparan solos los que ya estaban en ese caso.

## [1.15.1] — 2026-10-02

### Corregido
- **Copia de seguridad en Google Drive desde Android**: fallaba con `SocketException: Broken pipe` cuando la copia (con las fotos de las verificaciones) superaba unos 5 MB. Ahora se sube por trozos con reintentos.

## [1.15.0] — 2026-09-29

### Añadido
- **Limitar fabricante** en el campeonato y en el reglamento de las sesiones de verificación libre. Activa el interruptor y elige las marcas permitidas (p. ej. solo SLOT.IT):
  - En la verificación, los desplegables de marca de **piñón, corona, llantas delantera y trasera y trencilla** solo muestran esas marcas.
  - Una marca distinta ya guardada se marca como **infracción** ("no permitida").
  - Una sesión libre nueva copia la limitación de la anterior, como el resto del reglamento.

## [1.14.0] — 2026-09-29

### Añadido
- **Verificación libre: importar participantes desde un archivo o Google Sheets.** Botón de importar en la sesión:
  - **Desde archivo** (CSV o Excel) o **desde Google Sheets** (eliges hoja y pestaña).
  - Reconoce solas las columnas Piloto 1 (o Piloto / Nombre), Piloto 2, Equipo y Copa; se pueden cambiar a mano. Vale también una lista de una sola columna con los nombres.
  - **Copa por defecto** para las filas sin copa o con una copa que no está en la sesión (se avisa en la vista previa).
  - Vista previa para desmarcar filas; los que ya están en la sesión o se repiten en la tabla se saltan.
  - Nueva plantilla **"Participantes de verificación libre"** en Plantillas CSV.

## [1.13.0] — 2026-09-29

### Añadido
- **Verificación libre: verificar coches sin campeonato ni prueba.** Para una carrera esporádica, un control en el club o cualquier otro sitio. Se abre desde **"Verificación libre"** en el menú lateral (y desde la pantalla de inicio aunque aún no haya campeonatos).
  - Cada **sesión** tiene nombre, lugar y fecha, y su propio **reglamento**: copas, anchura de eje por copa, dientes de piñón y corona y rango de motores para el sorteo. Una sesión nueva copia el reglamento de la anterior.
  - **Añadir participante**: piloto (con autocompletado de los pilotos ya existentes), segundo piloto y equipo opcionales, y copa. Se abre directamente su verificación, que es la misma de siempre (autoguardado, fotos, sorteo de motor, validación por copa). Mantén pulsado un participante para quitarlo.
  - **Exportar a PDF** las verificaciones de la sesión. No usa créditos ni tesorería, no se envía a PitWall Manager y las sesiones no aparecen en los campeonatos.

### Mejorado
- La verificación toma el reglamento y los créditos del campeonato de la prueba verificada, en vez del campeonato activo.

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
