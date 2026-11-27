import 'package:flutter/material.dart';

/// Hand-tuned Material 3 Expressive color tokens computed in OKLCH
/// from the Plum Stacked Tabs brand seed (hue 288).
abstract final class AppBranding {
  /// oklch(0.47 0.23 288) — contrast 7.69:1 vs lightOnPrimary
  static const Color lightPrimary = Color(0xFF5E2BD0);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);

  /// oklch(0.975 0.012 288)
  static const Color lightSurface = Color(0xFFF6F6FF);

  /// oklch(0.21 0.06 278) — contrast 16.63:1 vs lightSurface
  static const Color lightOnSurface = Color(0xFF131433);

  /// oklch(0.79 0.14 288) — contrast 9.52:1 vs darkSurface
  static const Color darkPrimary = Color(0xFFB6ABFF);

  /// oklch(0.25 0.12 288) — contrast 8.12:1 vs darkPrimary
  static const Color darkOnPrimary = Color(0xFF230D56);

  /// oklch(0.16 0.025 288)
  static const Color darkSurface = Color(0xFF0D0B17);

  /// oklch(0.94 0.015 288) — contrast 16.32:1 vs darkSurface
  static const Color darkOnSurface = Color(0xFFEAEAF5);

  /// oklch(0.56 0.165 55) — H-1 warning amber, contrast 4.89:1 vs onWarn
  static const Color warnOrange = Color(0xFFBA5200);

  /// oklch(0.56 0.21 22) — overdue coral-red, contrast 5.18:1 vs onWarn
  static const Color dangerRed = Color(0xFFD41F37);
  static const Color onWarn = Color(0xFFFFFFFF);
}
