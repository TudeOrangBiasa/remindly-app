import 'package:flutter/material.dart';

import 'package:remindly_app/theme/tokens.dart';

/// Empty state standar SRS 3.6. Selalu ada tombol tambah.
class EmptyState extends StatelessWidget {
  const new({required this.message, required this.onAdd, super.key});

  final String message;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}
