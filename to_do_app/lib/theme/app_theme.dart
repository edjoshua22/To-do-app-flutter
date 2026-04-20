import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const background = Color(0xFFF5F5F5);
  static const card = Color(0xFFFFFFFF);
  static const primary = Color(0xFF111111);
  static const secondary = Color(0xFF888888);
  static const accent = Color(0xFFFFD54F);
  static const divider = Color(0xFFEEEEEE);
  static const border = Color(0xFFDDDDDD);
}

ThemeData appTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      brightness: Brightness.light,
      surface: AppColors.background,
    ),
    scaffoldBackgroundColor: AppColors.background,
  );

  return base.copyWith(
    textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
      bodyColor: AppColors.primary,
      displayColor: AppColors.primary,
    ),
  );
}
