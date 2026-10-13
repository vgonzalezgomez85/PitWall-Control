#!/usr/bin/env bash
# Capturas para el manual de la web (ver lib/main_capturas.dart).
#
# Compila la app con el punto de entrada de capturas (base de datos de demo
# anonimizada, tema oscuro), la abre con una ventana de tamaño fijo y va
# capturando cada pantalla cuando la app avisa de que está lista.
#
# Uso: scripts/capturar_manual.sh [idioma] [carpeta-destino]
#   idioma: es (por defecto), ca, en, fr, it
#   destino: por defecto, «~/PitWall Landing/manual/img»
#   RECOMPILAR=0 para reutilizar el binario ya compilado (útil para los
#   idiomas: el binario lee el idioma del entorno, no hace falta recompilar).
#
# La base de demo se prepara aparte (copia anonimizada de la base real):
#   cp ~/Documents/pitwall.sqlite /tmp/pitwall_capturas.sqlite   + anonimizar
#
# El parche de ventana (macos/Runner/MainFlutterWindow.swift) es TEMPORAL:
# hay que revertirlo al acabar (git checkout macos/Runner/MainFlutterWindow.swift).
set -euo pipefail

RAIZ="$(cd "$(dirname "$0")/.." && pwd)"
IDIOMA="${1:-es}"
DESTINO="${2:-$HOME/PitWall Landing/manual/img}"
DIR=/tmp/capturas
DB=/tmp/pitwall_capturas.sqlite
APP="$RAIZ/build/capturas/Build/Products/Release/PitWall Control.app"
VENTANA=/tmp/pitwall_capturas_ventana.txt

[ -f "$DB" ] || { echo "error: falta la base de demo $DB" >&2; exit 1; }
mkdir -p "$DESTINO"

if [ "${RECOMPILAR:-1}" = "1" ]; then
  echo "==> compilando (lib/main_capturas.dart)"
  (cd "$RAIZ" && flutter build macos --release --config-only -t lib/main_capturas.dart)
  (cd "$RAIZ" && xcodebuild -workspace macos/Runner.xcworkspace -scheme Runner \
      -configuration Release -derivedDataPath build/capturas \
      ARCHS=arm64 ONLY_ACTIVE_ARCH=YES build >/dev/null)
fi

# La app se captura a sí misma (sin permisos de Grabación de pantalla) y
# termina sola al acabar la lista de pantallas.
rm -rf "$DIR"; mkdir -p "$DIR"
echo "==> abriendo la app ($IDIOMA)"
CAPTURAS=1 CAPTURAS_DIR="$DIR" CAPTURAS_DB="$DB" CAPTURAS_IDIOMA="$IDIOMA" \
  "$APP/Contents/MacOS/PitWall Control" >/dev/null 2>&1 &
APP_PID=$!
trap 'kill $APP_PID 2>/dev/null || true' EXIT

echo "==> capturando (la app se cierra al terminar)"
for _ in $(seq 1 600); do
  if ! kill -0 "$APP_PID" 2>/dev/null; then break; fi
  sleep 1
done
wait "$APP_PID" 2>/dev/null || true

sufijo=""; [ "$IDIOMA" = "es" ] || sufijo=".$IDIOMA"
for png in "$DIR"/*.png; do
  [ -e "$png" ] || continue
  id="$(basename "$png" .png)"
  sips --resampleWidth 1500 "$png" >/dev/null
  cp "$png" "$DESTINO/$id$sufijo.png"
  echo "  ✓ $id$sufijo.png"
done

if [ -f "$DIR/error.txt" ]; then
  echo "--- error de la app:" >&2; cat "$DIR/error.txt" >&2
fi
# Deja FLUTTER_TARGET apuntando otra vez a la app normal.
if [ "${RECOMPILAR:-1}" = "1" ]; then
  (cd "$RAIZ" && flutter build macos --release --config-only >/dev/null)
fi
echo "==> listo: capturas en $DESTINO"
