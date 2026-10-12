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
// stores (e.g. Apple App Store, Google Play) is permitted. See LICENSE-EXCEPTION.
package com.pitwallcontrol.app

import android.content.Intent
import android.net.Uri
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

/**
 * Abre el instalador de Android para el APK descargado en la caché de la app
 * (aviso de versión nueva, `servicio_actualizacion.dart`). El fichero va por el
 * FileProvider (`${applicationId}.instalador`) con permiso de lectura para el
 * instalador, que es otro proceso. Devuelve `false` si no se puede abrir: Dart
 * cae entonces al navegador, igual que en PitWall Lap.
 */
class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CANAL)
            .setMethodCallHandler { llamada, resultado ->
                if (llamada.method != "instalarApk") {
                    resultado.notImplemented()
                    return@setMethodCallHandler
                }
                val ruta = llamada.argument<String>("ruta")
                if (ruta == null) {
                    resultado.success(false)
                    return@setMethodCallHandler
                }
                resultado.success(abrirInstalador(ruta))
            }
    }

    private fun abrirInstalador(ruta: String): Boolean = try {
        val uri: Uri = FileProvider.getUriForFile(this, "$packageName.instalador", File(ruta))
        val intent = Intent(Intent.ACTION_VIEW).apply {
            setDataAndType(uri, "application/vnd.android.package-archive")
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }
        startActivity(intent)
        true
    } catch (_: Exception) {
        false
    }

    private companion object {
        const val CANAL = "pitwall/actualizacion"
    }
}
