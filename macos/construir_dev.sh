#!/usr/bin/env bash
# Compila "PitWall Control Dev": la misma app con otro nombre e identificador
# (com.pitwallcontrol.app.dev), con --dart-define=PITWALL_DEV=true: usa
# ~/Documents/pitwall_dev.sqlite y fotos_verificaciones_dev, separados de la
# app real (que usa pitwall.sqlite). Los ajustes también van aparte (otro id).
# Cambia AppInfo.xcconfig solo durante la compilación y lo restaura al acabar.
# Uso: macos/construir_dev.sh   → ~/Desktop/PitWall Control Dev.app
set -euo pipefail
cd "$(dirname "$0")/.."

CONF=macos/Runner/Configs/AppInfo.xcconfig
cp "$CONF" "$CONF.bak"
trap 'mv "$CONF.bak" "$CONF"' EXIT
sed -i '' \
  -e 's/^PRODUCT_NAME = .*/PRODUCT_NAME = PitWall Control Dev/' \
  -e 's/^PRODUCT_BUNDLE_IDENTIFIER = .*/PRODUCT_BUNDLE_IDENTIFIER = com.pitwallcontrol.app.dev/' \
  "$CONF"

flutter build macos --release --config-only --dart-define=PITWALL_DEV=true
xcodebuild -workspace macos/Runner.xcworkspace -scheme Runner \
  -configuration Release -derivedDataPath build/macos-dev \
  ARCHS=arm64 ONLY_ACTIVE_ARCH=YES build

DESTINO="$HOME/Desktop/PitWall Control Dev.app"
rm -rf "$DESTINO"
cp -R "build/macos-dev/Build/Products/Release/PitWall Control Dev.app" "$DESTINO"
echo "Creada: $DESTINO"
