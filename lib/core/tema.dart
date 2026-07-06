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

/// Identidad visual del ecosistema PitWall: tema oscuro con acento rojo,
/// tipografía Saira Condensed (títulos) / Saira (texto) / IBM Plex Mono
/// (números). Paleta tomada de la landing (misma marca que lap y timer).
class TemaApp {
  // Acentos de marca.
  static const rojo = Color(0xFFEF4651);
  static const cian = Color(0xFF22B8D6);
  static const ambar = Color(0xFFF59E0B);
  static const verde = Color(0xFF22C55E);

  static ThemeData claro() => _crear(Brightness.light);
  static ThemeData oscuro() => _crear(Brightness.dark);

  /// Fuente monoespaciada de marca, para números (puntos, tiempos, etc.).
  static TextStyle mono({double? fontSize, FontWeight? fontWeight, Color? color}) =>
      GoogleFonts.ibmPlexMono(
          fontSize: fontSize, fontWeight: fontWeight, color: color);

  static ColorScheme _esquemaOscuro() {
    return ColorScheme.fromSeed(seedColor: rojo, brightness: Brightness.dark)
        .copyWith(
      primary: rojo,
      onPrimary: Colors.white,
      secondary: cian,
      tertiary: ambar,
      surface: const Color(0xFF121217),
      onSurface: const Color(0xFFF5F5F7),
      onSurfaceVariant: const Color(0xFFB6B6C2),
      surfaceContainerLowest: const Color(0xFF08080A),
      surfaceContainerLow: const Color(0xFF0D0D11),
      surfaceContainer: const Color(0xFF181820),
      surfaceContainerHigh: const Color(0xFF1F1F29),
      surfaceContainerHighest: const Color(0xFF26262F),
      outline: const Color(0xFF76767F),
      outlineVariant: const Color(0xFF2C2C34),
    );
  }

  static ThemeData _crear(Brightness brillo) {
    final esquema = brillo == Brightness.dark
        ? _esquemaOscuro()
        : ColorScheme.fromSeed(seedColor: rojo, brightness: Brightness.light)
            .copyWith(primary: rojo);
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

    return base.copyWith(
      scaffoldBackgroundColor: brillo == Brightness.dark
          ? esquema.surfaceContainerLowest
          : esquema.surface,
      visualDensity: VisualDensity.comfortable,
      textTheme: texto,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 52),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 52),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: esquema.outlineVariant),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: brillo == Brightness.dark
            ? esquema.surfaceContainerLowest
            : esquema.surface,
        foregroundColor: esquema.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.sairaCondensed(
          color: esquema.onSurface,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
