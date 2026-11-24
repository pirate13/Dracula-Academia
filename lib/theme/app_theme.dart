import 'package:flutter/material.dart';

abstract final class Palette {
  static const background = Color(0xFF111019);
  static const panel = Color(0xFF211D2A);
  static const raised = Color(0xFF302634);
  static const wine = Color(0xFF842B45);
  static const bright = Color(0xFFC75B78);
  static const parchment = Color(0xFFF0E3D5);
  static const ink = Color(0xFFF1E7DF);
  static const muted = Color(0xFFB9A9B7);
  static const gold = Color(0xFFD0AF7B);
  static const border = Color(0xFF50404D);
}

abstract final class AppTheme {
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Palette.background,
    colorScheme: const ColorScheme.dark(
      primary: Palette.bright,
      secondary: Palette.gold,
      surface: Palette.panel,
      onSurface: Palette.ink,
    ),
    fontFamily: 'Georgia',
    dividerColor: Palette.border,
    textTheme: const TextTheme(
      headlineMedium: TextStyle(fontSize: 29, fontWeight: FontWeight.w700, color: Palette.ink, height: 1.14),
      titleLarge: TextStyle(fontSize: 21, fontWeight: FontWeight.w700, color: Palette.parchment),
      bodyMedium: TextStyle(fontSize: 14, height: 1.55, color: Palette.ink),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? Palette.wine : Colors.transparent),
      side: const BorderSide(color: Palette.gold),
      checkColor: const WidgetStatePropertyAll(Palette.parchment),
    ),
  );
}
