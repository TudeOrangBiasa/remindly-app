import 'package:flutter/material.dart';

import 'package:remindly_app/theme/tokens.dart';

class EmptyState extends StatelessWidget {
  const new({required this.message, required this.onAdd, super.key});

  final String message;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : AppTokens.motionMedium;
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: duration,
      builder: (context, value, child) => Opacity(opacity: value, child: child),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppTokens.spaceL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: AppTokens.spaceM),
              FilledButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add),
                label: const Text('Tambah'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
