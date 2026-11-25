import 'package:flutter/material.dart';

import 'package:remindly_app/theme/branding.dart';
import 'package:remindly_app/theme/tokens.dart';

/// Badge status deadline. Oranye H-1, merah terlambat.
/// Selalu ada label teks, bukan warna saja.
class StatusBadge extends StatelessWidget {
  const new hampir({super.key}) : _kind = _Kind.hampir;
  const new terlambat({super.key}) : _kind = _Kind.terlambat;

  final _Kind _kind;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = _kind == _Kind.hampir
        ? AppBranding.warnOrange
        : AppBranding.dangerRed;
    final label = _kind == _Kind.hampir ? 'H-1' : 'Terlambat';
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTokens.spaceS,
        vertical: AppTokens.spaceXS,
      ),
      decoration: BoxDecoration(
        color: bg.withValues(alpha: isDark ? 0.9 : 1),
        borderRadius: BorderRadius.circular(AppTokens.badgeRadius),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall
            ?.copyWith(color: AppBranding.onWarn, fontWeight: FontWeight.w700),
      ),
    );
  }
}

enum _Kind { hampir, terlambat }
