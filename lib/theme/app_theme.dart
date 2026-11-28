import 'package:flutter/material.dart';
import 'package:remindly_app/theme/branding.dart';
import 'package:remindly_app/theme/tokens.dart';

abstract final class AppTheme {
  static ThemeData light() {
    return _data(
      const ColorScheme.light(
        primary: AppBranding.lightPrimary,
        surface: AppBranding.lightSurface,
        onSurface: AppBranding.lightOnSurface,
        error: AppBranding.dangerRed,
      ),
    );
  }

  static ThemeData dark() {
    return _data(
      const ColorScheme.dark(
        primary: AppBranding.darkPrimary,
        onPrimary: AppBranding.darkOnPrimary,
        surface: AppBranding.darkSurface,
        onSurface: AppBranding.darkOnSurface,
        error: AppBranding.dangerRed,
      ),
    );
  }

  static ThemeData _data(ColorScheme scheme) {
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: const StadiumBorder(),
          minimumSize: const Size(AppTokens.touchTarget, AppTokens.touchTarget),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
}
