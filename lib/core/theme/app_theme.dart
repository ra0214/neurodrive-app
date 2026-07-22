import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color cyanNeuroDrive = Color(0xFF00F1FE);
  
  // Light Theme Colors
  static const Color lightActionPrimary = Color(0xFF007A82);
  static const Color lightBackground = Color(0xFFF7F9FB);
  static const Color lightSurface = Colors.white;
  static const Color lightTextPrimary = Color(0xFF191C1D);
  static const Color lightError = Color(0xFFBA1A1A);
  static const Color lightInputFill = Color(0xFFF1F5F9);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF08132A);
  static const Color darkSurface = Color(0xFF101B33);
  static const Color darkTextPrimary = Color(0xFFD9E2FF);
  static const Color darkError = Color(0xFFFFB4AB);
  static const Color darkInputFill = Color(0xFF1E2738);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: cyanNeuroDrive,
        brightness: Brightness.dark,
        primary: cyanNeuroDrive,
        onPrimary: Colors.black,
        surface: darkSurface,
        onSurface: darkTextPrimary,
        background: darkBackground,
        onBackground: darkTextPrimary,
        error: darkError,
      ),
      scaffoldBackgroundColor: darkBackground,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkInputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: cyanNeuroDrive, width: 1),
        ),
        hintStyle: TextStyle(color: darkTextPrimary.withValues(alpha: 0.38)),
        prefixIconColor: darkTextPrimary.withValues(alpha: 0.54),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cyanNeuroDrive,
          foregroundColor: Colors.black,
          minimumSize: const Size(88, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: lightActionPrimary,
        brightness: Brightness.light,
        primary: lightActionPrimary,
        onPrimary: Colors.white,
        surface: lightSurface,
        onSurface: lightTextPrimary,
        background: lightBackground,
        onBackground: lightTextPrimary,
        error: lightError,
      ),
      scaffoldBackgroundColor: lightBackground,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightInputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightActionPrimary, width: 1),
        ),
        hintStyle: TextStyle(color: lightTextPrimary.withValues(alpha: 0.38)),
        prefixIconColor: lightTextPrimary.withValues(alpha: 0.54),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightActionPrimary,
          foregroundColor: Colors.white,
          minimumSize: const Size(88, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
