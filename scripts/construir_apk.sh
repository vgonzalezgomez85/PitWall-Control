#!/usr/bin/env bash
# Compila el APK de release de PitWall Control y lo deja, con su `version.json`,
# en la carpeta de la web («PitWall Landing/software/pitwall-control/»): la app
# lo consulta para avisar de que hay una versión nueva. Falta desplegarlo con el
# `deploy.sh` de «PitWall Landing».
#
# El APK va firmado con la clave debug del proyecto (android/app/build.gradle.kts):
# es la misma con la que están firmados los APK ya publicados, así que las
# actualizaciones se instalan ENCIMA de la app instalada sin perder los datos. No
# cambiar de clave sin planificar la reinstalación (habría que desinstalar). El
# `versionCode` de Android sale del `+N` del pubspec: cada APK publicado debe
# subirlo (1.33.0+2 → versionCode 2).
#
# El `version.json` solo anota como `descargas` los instaladores de escritorio
# que llevan el número de versión publicado y ya están en la carpeta web: así no
# se avisa nunca de algo que aún no se puede descargar.
#
# Otras ubicaciones: LANDING_DIR=/ruta  ·  no publicar: LANDING_DIR=-
# Regenerar solo el manifiesto (p. ej. al añadir instaladores de escritorio):
#   SOLO_MANIFIESTO=1 scripts/construir_apk.sh
#
# Uso: scripts/construir_apk.sh [directorio-destino]   (por defecto: ~/Desktop)

set -euo pipefail

RAIZ="$(cd "$(dirname "$0")/.." && pwd)"
DEST="${1:-$HOME/Desktop}"

# Java: JAVA_HOME si está definido; si no, el JDK de Homebrew (no está enlazado
# al PATH en esta máquina).
if [ -z "${JAVA_HOME:-}" ]; then
  for jdk in /opt/homebrew/opt/openjdk@21 /opt/homebrew/opt/openjdk@17; do
    if [ -x "$jdk/bin/java" ]; then export JAVA_HOME="$jdk"; break; fi
  done
fi
if [ -z "${JAVA_HOME:-}" ]; then
  echo "error: no encuentro JAVA_HOME (ni un JDK de Homebrew en /opt/homebrew/opt)" >&2
  exit 1
fi
export PATH="$JAVA_HOME/bin:$PATH"

# SDK de Android (el local.properties del repo ya apunta aquí en esta máquina;
# lo escribimos si falta).
export ANDROID_HOME="${ANDROID_HOME:-/opt/homebrew/share/android-commandlinetools}"
if [ ! -f "$RAIZ/android/local.properties" ]; then
  echo "sdk.dir=$ANDROID_HOME" > "$RAIZ/android/local.properties"
fi

VERSION="$(grep '^version:' "$RAIZ/pubspec.yaml" | sed 's/version: *//; s/+.*//')"
LANDING="${LANDING_DIR:-$HOME/PitWall Landing}"
WEB="$LANDING/software/pitwall-control"

if [ "${SOLO_MANIFIESTO:-0}" != "1" ]; then
  echo "==> flutter build apk --release (v$VERSION)"
  (cd "$RAIZ" && flutter build apk --release)

  ORIGEN="$RAIZ/build/app/outputs/flutter-apk/app-release.apk"
  OUT="$DEST/PitWallControl-$VERSION.apk"
  mkdir -p "$DEST"
  cp "$ORIGEN" "$OUT"
  echo
  echo "==> APK: $OUT"
  ls -lh "$OUT"
  echo "sha256: $(shasum -a 256 "$OUT" | cut -d' ' -f1)"
fi

if [ "$LANDING" = "-" ] || [ ! -d "$LANDING" ]; then
  [ "$LANDING" = "-" ] || echo "aviso: no existe «$LANDING»; no se publica nada" >&2
  exit 0
fi

mkdir -p "$WEB"
if [ "${SOLO_MANIFIESTO:-0}" != "1" ]; then
  cp "$DEST/PitWallControl-$VERSION.apk" "$WEB/PitWallControl.apk"
fi
if [ ! -f "$WEB/PitWallControl.apk" ]; then
  echo "error: falta $WEB/PitWallControl.apk (sin SOLO_MANIFIESTO=1 se copia sola)" >&2
  exit 1
fi

# ── Instaladores de escritorio de ESTA versión que ya estén publicados ────────
MACOS=""; WINDOWS=""; LINUX=""; LINUX_DEB=""
for fichero in "$WEB"/*"$VERSION"*; do
  [ -e "$fichero" ] || continue
  nombre="$(basename "$fichero")"
  case "$nombre" in
    *.tar.gz) [ -n "$LINUX" ] || LINUX="$nombre" ;;
    *.deb)    [ -n "$LINUX_DEB" ] || LINUX_DEB="$nombre" ;;
    *.zip)    [ -n "$MACOS" ] || MACOS="$nombre" ;;
    *.exe)    [ -n "$WINDOWS" ] || WINDOWS="$nombre" ;;
  esac
done
# La app de escritorio de Linux usa el .tar.gz; si solo hay .deb, vale ese.
[ -n "$LINUX" ] || LINUX="$LINUX_DEB"

DESCARGAS="{"
SEPARADOR=""
for clave_valor in "macos:$MACOS" "windows:$WINDOWS" "linux:$LINUX" "linux-deb:$LINUX_DEB"; do
  clave="${clave_valor%%:*}"
  valor="${clave_valor#*:}"
  [ -n "$valor" ] || continue
  DESCARGAS="$DESCARGAS$SEPARADOR\"$clave\": \"$valor\""
  SEPARADOR=", "
done
DESCARGAS="$DESCARGAS}"

BYTES="$(stat -f%z "$WEB/PitWallControl.apk" 2>/dev/null || stat -c%s "$WEB/PitWallControl.apk")"
SHA="$(shasum -a 256 "$WEB/PitWallControl.apk" | cut -d' ' -f1)"
NOTAS_JSON="$(printf '%s' "${NOTAS:-}" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g')"

printf '{\n  "version": "%s",\n  "apk": "PitWallControl.apk",\n  "bytes": %s,\n  "sha256": "%s",\n  "notas": "%s",\n  "descargas": %s\n}\n' \
  "$VERSION" "$BYTES" "$SHA" "$NOTAS_JSON" "$DESCARGAS" > "$WEB/version.json"

echo
echo "==> Web: $WEB (PitWallControl.apk + version.json)"
cat "$WEB/version.json"
echo "Falta desplegar: $LANDING/deploy.sh"
