import 'package:flutter/material.dart';

import 'package:remindly_app/widgets/empty_state.dart';

class CoursesPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mata Kuliah')),
      body: EmptyState(
        message: 'Belum ada mata kuliah. Tekan tombol + untuk menambah.',
        onAdd: () {},
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
