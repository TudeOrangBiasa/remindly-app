import 'package:flutter/material.dart';

/// Form tambah atau ubah tugas.
/// Full Form plus TextFormField dipasang di REM-05.
/// Fondasi hanya sediakan kerangka agar slicing tidak tabrakan.
class TaskFormPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Tugas')),
      body: const Center(child: Text('Form tugas menyusul di REM-05')),
    );
  }
}
