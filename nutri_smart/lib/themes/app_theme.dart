import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      surface: AppColors.lightBg,
    ),
    scaffoldBackgroundColor: AppColors.lightBg,
    textTheme: GoogleFonts.tinosTextTheme(ThemeData.light().textTheme).copyWith(
      displayLarge: GoogleFonts.tinos(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
      titleLarge: GoogleFonts.tinos(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      bodyLarge: GoogleFonts.tinos(color: AppColors.textPrimary),
      bodyMedium: GoogleFonts.tinos(color: AppColors.textSecondary),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: Colors.black.withOpacity(0.05),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightBg,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.tinos(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      surface: AppColors.darkBg,
    ),
    scaffoldBackgroundColor: AppColors.darkBg,
    textTheme: GoogleFonts.tinosTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.tinos(fontWeight: FontWeight.bold, color: AppColors.textDark),
      titleLarge: GoogleFonts.tinos(fontWeight: FontWeight.w600, color: AppColors.textDark),
      bodyLarge: GoogleFonts.tinos(color: AppColors.textDark),
      bodyMedium: GoogleFonts.tinos(color: AppColors.textDark.withOpacity(0.7)),
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkCard,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: Colors.black.withOpacity(0.2),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkBg,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.tinos(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
    ),
  );
}
