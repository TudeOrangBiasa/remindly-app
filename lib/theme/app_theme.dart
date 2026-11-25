import 'package:flutter/material.dart';
import 'package:remindly_app/theme/branding.dart';

/// Theme tunggal. Pages hanya pakai Theme.of, tidak bikin ThemeData sendiri.
abstract final class AppTheme {
  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      colorScheme: const ColorScheme.light(
        primary: AppBranding.lightPrimary,
        surface: AppBranding.lightSurface,
        onSurface: AppBranding.lightOnSurface,
        error: AppBranding.dangerRed,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: const StadiumBorder(),
          minimumSize: const Size(48, 48),
        ),
      ),
    );
  }

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      colorScheme: const ColorScheme.dark(
        primary: AppBranding.darkPrimary,
        onPrimary: AppBranding.darkOnPrimary,
        surface: AppBranding.darkSurface,
        onSurface: AppBranding.darkOnSurface,
        error: AppBranding.dangerRed,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: const StadiumBorder(),
          minimumSize: const Size(48, 48),
        ),
      ),
    );
  }
}
