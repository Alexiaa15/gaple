import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Definisi ThemeData untuk mode terang & gelap.
class AppTheme {
  AppTheme._();

  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      colorSchemeSeed: AppColors.primaryGreen,
      scaffoldBackgroundColor: AppColors.cream,
      cardColor: Colors.white,
      useMaterial3: true,
    );
  }

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      colorSchemeSeed: AppColors.primaryGreen,
      scaffoldBackgroundColor: const Color(0xFF10140E),
      cardColor: const Color(0xFF1C241C),
      useMaterial3: true,
    );
  }
}
