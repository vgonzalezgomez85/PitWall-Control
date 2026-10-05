# Entorno para compilar PitWall Control para Linux x86_64 desde otro sistema
# (p. ej. un Mac). Uso: ver construir_linux.sh.
FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl git unzip xz-utils zip rsync file \
      clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev \
      libstdc++-12-dev openjdk-17-jdk-headless dpkg-dev \
    && rm -rf /var/lib/apt/lists/*

# Misma versión de Flutter que en el Mac de desarrollo.
ARG FLUTTER_VERSION=3.44.0
RUN curl -fsSL "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" \
      | tar -xJ -C /opt \
    && git config --global --add safe.directory /opt/flutter
ENV PATH="/opt/flutter/bin:${PATH}"
RUN flutter config --no-analytics --enable-linux-desktop \
    && flutter precache --linux --no-android --no-ios
