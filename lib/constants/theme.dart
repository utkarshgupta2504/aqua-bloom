import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary Colors
  static const Color primaryBlue = Color(0xFF4FC3F7); // Sky blue
  static const Color accentYellow = Color(0xFFFFD54F); // Sunny yellow
  static const Color accentGreen = Color(0xFF81C784); // Mint green
  static const Color backgroundWhite = Color(0xFFFFFBF7); // Soft cream white

  // Additional Colors
  static const Color darkBlue = Color(0xFF0288D1);
  static const Color lightBlue = Color(0xFFB3E5FC);
  static const Color textDark = Color(0xFF2C3E50);
  static const Color textLight = Color(0xFF7F8C8D);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryBlue,
        secondary: accentYellow,
        tertiary: accentGreen,
        background: backgroundWhite,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: textDark,
        onBackground: textDark,
        onSurface: textDark,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData.light().textTheme.copyWith(
          displayLarge: const TextStyle(
            color: textDark,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: const TextStyle(
            color: textDark,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: const TextStyle(color: textDark),
          bodyMedium: const TextStyle(color: textLight),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textDark),
        titleTextStyle: TextStyle(
          color: textDark,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
