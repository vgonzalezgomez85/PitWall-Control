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
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Identidad visual del ecosistema PitWall, con los mismos tokens que
/// PitWall Lap (`src/ui/theme.ts`): fondo azul-negro, superficies escalonadas,
/// rojo de marca como acento (más profundo en los rellenos, para que el texto
/// blanco se lea) y semáforo de estados. Tipografía Saira Condensed (títulos)
/// / Saira (texto) / IBM Plex Mono (números), como la web.
///
/// Los esquemas se definen color a color: `ColorScheme.fromSeed` inventaba
/// tonos (rosas, granates) que no son de la marca.
class TemaApp {
  // Acentos de marca.
  static const rojo = Color(0xFFEF4651);
  static const cian = Color(0xFF22B8D6);
  static const ambar = Color(0xFFF59E0B);
  static const verde = Color(0xFF22C55E);

  /// Rojo para rellenos con texto blanco encima (4,6:1 de contraste; el rojo
  /// de marca a secas se queda en 3,7:1).
  static const rojoRelleno = Color(0xFFD23E47);

  static ThemeData claro() => _crear(Brightness.light);
  static ThemeData oscuro() => _crear(Brightness.dark);

  /// Fuente monoespaciada de marca, para números (puntos, tiempos, etc.).
  static TextStyle mono({double? fontSize, FontWeight? fontWeight, Color? color}) =>
      GoogleFonts.ibmPlexMono(
          fontSize: fontSize, fontWeight: fontWeight, color: color);

  static const _oscuro = ColorScheme(
    brightness: Brightness.dark,
    primary: rojo,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFF2A1014),
    onPrimaryContainer: Color(0xFFFFD9DC),
    secondary: Color(0xFFCFD5DC),
    onSecondary: Color(0xFF0A0D13),
    // Selección en menús y barras: superficie elevada, sin teñir.
    secondaryContainer: Color(0xFF232B3A),
    onSecondaryContainer: Colors.white,
    tertiary: ambar,
    onTertiary: Color(0xFF1A1205),
    tertiaryContainer: Color(0xFF3A2A0A),
    onTertiaryContainer: Color(0xFFFFE2B0),
    error: Color(0xFFFF6B6B),
    onError: Color(0xFF2A0A0A),
    errorContainer: Color(0xFF7A2230),
    onErrorContainer: Color(0xFFFFD9DC),
    surface: Color(0xFF0A0D13),
    onSurface: Colors.white,
    onSurfaceVariant: Color(0xFFCFD5DC),
    surfaceDim: Color(0xFF07090E),
    surfaceBright: Color(0xFF232B3A),
    surfaceContainerLowest: Color(0xFF07090E),
    surfaceContainerLow: Color(0xFF10141C),
    surfaceContainer: Color(0xFF141923),
    surfaceContainerHigh: Color(0xFF1C2330),
    surfaceContainerHighest: Color(0xFF232B3A),
    outline: Color(0xFF8B949E),
    outlineVariant: Color(0xFF262E3B),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFFE6EDF3),
    onInverseSurface: Color(0xFF0A0D13),
    inversePrimary: rojoRelleno,
    surfaceTint: Colors.transparent,
  );

  static const _claro = ColorScheme(
    brightness: Brightness.light,
    primary: rojoRelleno,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFFDE4E6),
    onPrimaryContainer: Color(0xFF5C0F17),
    secondary: Color(0xFF3A4350),
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFE4E8EE),
    onSecondaryContainer: Color(0xFF0A0D13),
    tertiary: Color(0xFFB45309),
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFFDEBC8),
    onTertiaryContainer: Color(0xFF4A2A05),
    error: Color(0xFFC62828),
    onError: Colors.white,
    errorContainer: Color(0xFFFDE2E2),
    onErrorContainer: Color(0xFF5C0F17),
    surface: Color(0xFFF6F7F9),
    onSurface: Color(0xFF0A0D13),
    onSurfaceVariant: Color(0xFF3A4350),
    surfaceDim: Color(0xFFE4E8EE),
    surfaceBright: Colors.white,
    surfaceContainerLowest: Colors.white,
    surfaceContainerLow: Colors.white,
    surfaceContainer: Color(0xFFF0F2F5),
    surfaceContainerHigh: Color(0xFFE9ECF0),
    surfaceContainerHighest: Color(0xFFE2E6EB),
    outline: Color(0xFF6B7480),
    outlineVariant: Color(0xFFD9DDE3),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFF141923),
    onInverseSurface: Colors.white,
    inversePrimary: rojo,
    surfaceTint: Colors.transparent,
  );

  static ThemeData _crear(Brightness brillo) {
    final oscuro = brillo == Brightness.dark;
    final esquema = oscuro ? _oscuro : _claro;
    final base = ThemeData(useMaterial3: true, colorScheme: esquema);

    // Tipografía: Saira de base; Saira Condensed en títulos/display.
    final saira = GoogleFonts.sairaTextTheme(base.textTheme);
    TextStyle cond(TextStyle? s, FontWeight w) =>
        GoogleFonts.sairaCondensed(textStyle: s, fontWeight: w, letterSpacing: 0.2);
    final texto = saira.copyWith(
      displayLarge: cond(saira.displayLarge, FontWeight.w800),
      displayMedium: cond(saira.displayMedium, FontWeight.w800),
      displaySmall: cond(saira.displaySmall, FontWeight.w700),
      headlineLarge: cond(saira.headlineLarge, FontWeight.w700),
      headlineMedium: cond(saira.headlineMedium, FontWeight.w700),
      headlineSmall: cond(saira.headlineSmall, FontWeight.w700),
      titleLarge: cond(saira.titleLarge, FontWeight.w700),
      titleMedium: saira.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      bodyLarge: saira.bodyLarge?.copyWith(fontSize: 16),
      labelLarge: saira.labelLarge?.copyWith(fontSize: 16),
    );
    // Rellenos rojos: el rojo profundo, con texto blanco.
    const relleno = rojoRelleno;
    final fondo = esquema.surface;

    return base.copyWith(
      scaffoldBackgroundColor: fondo,
      canvasColor: fondo,
      visualDensity: VisualDensity.comfortable,
      textTheme: texto,
      extensions: [oscuro ? ColoresEstado.oscuro : ColoresEstado.claro],
      dividerTheme: DividerThemeData(color: esquema.outlineVariant),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: relleno,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 52),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: esquema.onSurface,
          side: BorderSide(color: oscuro ? const Color(0xFF3A4350) : esquema.outline),
          minimumSize: const Size(0, 52),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: esquema.primary),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: relleno,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        // Claro: tarjetas blancas sobre el gris del fondo, como la web.
        color: oscuro ? esquema.surfaceContainer : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: esquema.outlineVariant),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: oscuro ? const Color(0xFF3A4350) : esquema.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: esquema.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: fondo,
        surfaceTintColor: Colors.transparent,
        foregroundColor: esquema.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.sairaCondensed(
          color: esquema.onSurface,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        indicatorColor: esquema.primary,
        labelColor: esquema.onSurface,
        unselectedLabelColor: esquema.outline,
        dividerColor: esquema.outlineVariant,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: esquema.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        indicatorColor: esquema.primaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((s) => IconThemeData(
            color: s.contains(WidgetState.selected)
                ? esquema.primary
                : esquema.onSurfaceVariant)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: esquema.surfaceContainer,
        surfaceTintColor: Colors.transparent,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: esquema.surfaceContainer,
        surfaceTintColor: Colors.transparent,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: esquema.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: esquema.inverseSurface,
        contentTextStyle: TextStyle(color: esquema.onInverseSurface),
        behavior: SnackBarBehavior.floating,
      ),
      chipTheme: ChipThemeData(
        selectedColor: esquema.primaryContainer,
        side: BorderSide(color: esquema.outlineVariant),
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? relleno : null),
        thumbColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? Colors.white : null),
      ),
    );
  }
}

/// Colores de estado (semáforo) del tema: los usan las pantallas en vez de
/// `Colors.green` & cía., para que respeten la paleta y el modo claro/oscuro.
@immutable
class ColoresEstado extends ThemeExtension<ColoresEstado> {
  const ColoresEstado({
    required this.exito,
    required this.exitoSuave,
    required this.aviso,
    required this.avisoSuave,
    required this.info,
  });

  /// Validado, pagado, todo bien.
  final Color exito;
  /// Fondo teñido de éxito (tarjetas, filas).
  final Color exitoSuave;
  /// Pendiente, a revisar, borrador.
  final Color aviso;
  final Color avisoSuave;
  /// Información neutra destacada.
  final Color info;

  static const oscuro = ColoresEstado(
    exito: Color(0xFF4ADE80),
    exitoSuave: Color(0xFF12301C),
    aviso: Color(0xFFFB923C),
    avisoSuave: Color(0xFF3A230F),
    info: Color(0xFF60A5FA),
  );

  static const claro = ColoresEstado(
    exito: Color(0xFF1B7F3B),
    exitoSuave: Color(0xFFE3F5E8),
    aviso: Color(0xFFC2410C),
    avisoSuave: Color(0xFFFFEDD5),
    info: Color(0xFF2C5CDD),
  );

  @override
  ColoresEstado copyWith({
    Color? exito,
    Color? exitoSuave,
    Color? aviso,
    Color? avisoSuave,
    Color? info,
  }) =>
      ColoresEstado(
        exito: exito ?? this.exito,
        exitoSuave: exitoSuave ?? this.exitoSuave,
        aviso: aviso ?? this.aviso,
        avisoSuave: avisoSuave ?? this.avisoSuave,
        info: info ?? this.info,
      );

  @override
  ColoresEstado lerp(ColoresEstado? otro, double t) {
    if (otro == null) return this;
    return ColoresEstado(
      exito: Color.lerp(exito, otro.exito, t)!,
      exitoSuave: Color.lerp(exitoSuave, otro.exitoSuave, t)!,
      aviso: Color.lerp(aviso, otro.aviso, t)!,
      avisoSuave: Color.lerp(avisoSuave, otro.avisoSuave, t)!,
      info: Color.lerp(info, otro.info, t)!,
    );
  }
}

/// Acceso corto: `context.estado.exito`.
extension EstadoEnContexto on BuildContext {
  ColoresEstado get estado =>
      Theme.of(this).extension<ColoresEstado>() ?? ColoresEstado.oscuro;
}
