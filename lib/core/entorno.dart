// PitWall Control — gestor de campeonatos de slot
// Copyright (C) 2026 Víctor González Gómez <vgonzalezgomez@outlook.es>
//
// This program is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation, either version 3 of the License, or (at your option)
// any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along with
// this program. If not, see <https://www.gnu.org/licenses/>.
//
// Additional permission under GPLv3 section 7: distribution through application

/// Versión "Dev" de la app (`--dart-define=PITWALL_DEV=true`): usa su propia
/// base de datos y carpeta de fotos para poder hacer pruebas sin tocar los
/// datos reales. Ver `macos/construir_dev.sh`.
const bool esEntornoDev = bool.fromEnvironment('PITWALL_DEV');

/// Nombre de la base de datos local (sin extensión).
const String nombreBaseDatos = esEntornoDev ? 'pitwall_dev' : 'pitwall';

/// Carpeta de fotos de verificaciones dentro de Documentos.
const String carpetaFotosVerificaciones =
    esEntornoDev ? 'fotos_verificaciones_dev' : 'fotos_verificaciones';
