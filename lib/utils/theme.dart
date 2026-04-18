import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color paperColor = Color(0xFFF5F0E6);
  static const Color inkColor = Color(0xFF3E2C1E);
  static const Color accentColor = Color(0xFFC8674B);
  static const Color lightInkColor = Color(0xFF8B7A6B);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: paperColor,
      primaryColor: inkColor,
      colorScheme: const ColorScheme.light(
        primary: inkColor,
        secondary: accentColor,
        surface: paperColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: paperColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.notoSerifSc(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: inkColor,
        ),
        iconTheme: const IconThemeData(color: inkColor),
      ),
      textTheme: TextTheme(
        headlineMedium: GoogleFonts.notoSerifSc(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: inkColor,
        ),
        headlineSmall: GoogleFonts.notoSerifSc(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: inkColor,
        ),
        bodyLarge: GoogleFonts.notoSerifSc(
          fontSize: 18,
          color: inkColor,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.notoSerifSc(
          fontSize: 16,
          color: lightInkColor,
          height: 1.5,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: inkColor,
          foregroundColor: paperColor,
          textStyle: GoogleFonts.notoSerifSc(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
