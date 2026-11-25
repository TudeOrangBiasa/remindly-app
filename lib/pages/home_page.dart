import 'package:flutter/material.dart';

import 'package:remindly_app/widgets/empty_state.dart';

class HomePage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Beranda')),
      body: EmptyState(
        message: 'Belum ada tugas. Tekan tombol + untuk menambah.',
        onAdd: () {},
      ),
    );
  }
}
