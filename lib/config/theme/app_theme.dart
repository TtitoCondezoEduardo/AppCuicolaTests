import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF7B5BFA);
  static const Color backgroundColor = Color(0xFF0E0E10);
  static const Color surfaceColor = Color(0xFF1A1A1C);
  static const Color textColor = Colors.white;
  static const Color hintColor = Colors.white70;

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: backgroundColor,
    primaryColor: primaryColor,
    hintColor: hintColor,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF1A1A1C),
      hintStyle: TextStyle(color: Colors.white70),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textColor),
      bodyMedium: TextStyle(color: textColor),
      labelLarge: TextStyle(color: textColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: textColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: EdgeInsets.symmetric(vertical: 16),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: primaryColor),
        foregroundColor: textColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    ),
  );
}
