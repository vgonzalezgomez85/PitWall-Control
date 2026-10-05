#!/usr/bin/env bash
# Compila PitWall Control para Linux x86_64 dentro de Docker (sirve desde un
# Mac o desde cualquier sistema con Docker) y genera el .deb y el .tar.gz en
# installer_output/.
# Uso: linux/installer/construir_linux.sh
set -euo pipefail

RAIZ="$(cd "$(dirname "$0")/../.." && pwd)"
IMAGEN="pitwall-control-linux-build"

docker build --platform linux/amd64 -t "$IMAGEN" "$RAIZ/linux/installer"

# Se compila sobre una copia del proyecto (sin build/ ni .dart_tool/ del
# host) para no mezclar rutas ni artefactos de otra plataforma.
docker run --rm --platform linux/amd64 \
  -v "$RAIZ:/src:ro" -v "$RAIZ/installer_output:/salida" \
  "$IMAGEN" bash -euo pipefail -c '
    rsync -a --exclude build --exclude .dart_tool --exclude installer_output \
      --exclude "linux/flutter/ephemeral" --exclude "macos/Pods" /src/ /app/
    cd /app
    flutter pub get
    # Emulando x86_64 en un Mac ARM, Dart falla a veces de forma aleatoria
    # ("Unexpected EINTR errno"): se reintenta.
    for intento in 1 2 3; do
      flutter build linux --release && break
      [ "$intento" = 3 ] && exit 1
      echo "Reintentando la compilación ($intento)..."
    done
    linux/installer/construir_paquete.sh /salida
  '
