import 'package:flutter/material.dart';

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
