=== Resisbarna Sync ===
Contributors: resisbarna
Tags: slot, racing, championship, rest-api
Requires at least: 6.0
Tested up to: 6.5
Stable tag: 0.1.0
License: GPLv2 or later

Recibe datos desde la app Resisbarna y los publica con shortcodes.

== Descripción ==

Plugin auxiliar para resisbarna.es. La app de gestión Resisbarna envía
clasificaciones, pruebas, pilotos, equipos y verificaciones a este plugin
vía REST API. El plugin los almacena (Custom Post Types + tabla custom de
clasificación) y ofrece shortcodes para mostrarlos en cualquier página.

== Instalación ==

1. Comprime la carpeta `resisbarna-sync/` como ZIP.
2. En tu WordPress: Plugins → Añadir nuevo → Subir → activar.
3. Crea una contraseña de aplicación: Usuarios → Tu perfil → Contraseñas
   de aplicación. Anota usuario + contraseña generada.
4. En la app Resisbarna: Ajustes → WordPress → pega la URL del sitio,
   usuario y application password.
5. Pulsa "Publicar en web".

== Shortcodes ==

* `[resisbarna_clasificacion campeonato="resisbarna-2026"]`
  Tabla pivote pilotos × pruebas con descartes y total neto.
  Opcional: `copa="GT"`, `limite="200"`.

* `[resisbarna_calendario campeonato="resisbarna-2026"]`
  Tarjetas con las pruebas ordenadas.

* `[resisbarna_pilotos campeonato="resisbarna-2026"]`
  Tabla con pilotos, categoría, créditos, palmarés.

* `[resisbarna_equipos campeonato="resisbarna-2026"]`
  Tabla con equipos y sus pilotos.

* `[resisbarna_prueba uid="prueba-1"]`
  Detalle de una prueba con resultados.

* `[resisbarna_verificaciones prueba="prueba-1"]`
  Tabla con verificaciones técnicas.

== Endpoints REST ==

Todos requieren autenticación con application password
(Basic Auth: usuario:contraseña).

* GET  /wp-json/resisbarna/v1/ping
* POST /wp-json/resisbarna/v1/clasificacion
* POST /wp-json/resisbarna/v1/pilotos
* POST /wp-json/resisbarna/v1/equipos
* POST /wp-json/resisbarna/v1/pruebas
* POST /wp-json/resisbarna/v1/verificaciones

== Changelog ==

= 0.1.0 =
* Primera versión.
