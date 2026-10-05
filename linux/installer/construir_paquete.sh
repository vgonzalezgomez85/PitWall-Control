#!/usr/bin/env bash
# Empaqueta el build de Linux de PitWall Control en un .deb (Debian/Ubuntu)
# y un .tar.gz (cualquier distribución).
# Requiere haber ejecutado antes "flutter build linux --release".
# Uso: linux/installer/construir_paquete.sh [carpeta_salida]
set -euo pipefail

RAIZ="$(cd "$(dirname "$0")/../.." && pwd)"
SALIDA="${1:-$RAIZ/installer_output}"
VERSION="$(grep '^version:' "$RAIZ/pubspec.yaml" | sed 's/version: *//; s/+.*//')"
BUNDLE="$RAIZ/build/linux/x64/release/bundle"
NOMBRE="pitwall-control"
ICONO="$RAIZ/linux/installer/pitwall-control.png"

[ -x "$BUNDLE/$NOMBRE" ] || { echo "Falta $BUNDLE/$NOMBRE: ejecuta antes flutter build linux --release" >&2; exit 1; }
mkdir -p "$SALIDA"

# --- .deb -------------------------------------------------------------------
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
PKG="$TMP/pkg"
mkdir -p "$PKG/DEBIAN" "$PKG/opt/$NOMBRE" "$PKG/usr/bin" \
         "$PKG/usr/share/applications" "$PKG/usr/share/icons/hicolor/256x256/apps"
cp -a "$BUNDLE/." "$PKG/opt/$NOMBRE/"
ln -s "/opt/$NOMBRE/$NOMBRE" "$PKG/usr/bin/$NOMBRE"
cp "$ICONO" "$PKG/usr/share/icons/hicolor/256x256/apps/$NOMBRE.png"
cat > "$PKG/usr/share/applications/$NOMBRE.desktop" <<DESKTOP
[Desktop Entry]
Type=Application
Name=PitWall Control
Comment=Gestor de campeonatos de slot
Exec=/opt/$NOMBRE/$NOMBRE
Icon=$NOMBRE
Terminal=false
Categories=Utility;Office;
StartupWMClass=$NOMBRE
DESKTOP
TAM_KB="$(du -sk "$PKG/opt" | cut -f1)"
cat > "$PKG/DEBIAN/control" <<CONTROL
Package: $NOMBRE
Version: $VERSION
Section: utils
Priority: optional
Architecture: amd64
Depends: libgtk-3-0, libstdc++6
Installed-Size: $TAM_KB
Maintainer: Víctor González Gómez <vgonzalezgomez@outlook.es>
Description: PitWall Control - gestor de campeonatos de slot
 Gestión offline de campeonatos de slot: pruebas, mangas, verificaciones
 técnicas, catálogos, tesorería y sincronización con Google Sheets.
CONTROL
dpkg-deb -Zgzip --root-owner-group --build "$PKG" "$SALIDA/PitWallControl-$VERSION-linux-amd64.deb" >/dev/null

# --- .tar.gz ----------------------------------------------------------------
TARDIR="$TMP/PitWallControl-$VERSION"
mkdir -p "$TARDIR"
cp -a "$BUNDLE/." "$TARDIR/"
cp "$ICONO" "$TARDIR/$NOMBRE.png"
tar -C "$TMP" -czf "$SALIDA/PitWallControl-$VERSION-linux-amd64.tar.gz" "PitWallControl-$VERSION"

echo "Generados en $SALIDA:"
ls -1 "$SALIDA" | grep "PitWallControl-$VERSION-linux"
