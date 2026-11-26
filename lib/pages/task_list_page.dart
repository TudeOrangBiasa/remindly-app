import 'package:flutter/material.dart';

import 'package:remindly_app/database/app_database.dart';
import 'package:remindly_app/pages/task_form_page.dart';
import 'package:remindly_app/widgets/empty_state.dart';
import 'package:sqflite/sqflite.dart';

class TaskListPage extends StatefulWidget {
  const new({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  late final Future<Database> _db = AppDatabase.open();

  Future<void> _bukaForm() async {
    final db = await _db;
    if (!mounted) return;
    await Navigator.of(
      context,
    ).push<bool>(MaterialPageRoute<bool>(builder: (_) => TaskFormPage(db: db)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tugas')),
      body: EmptyState(
        message: 'Belum ada tugas. Tekan tombol + untuk menambah.',
        onAdd: _bukaForm,
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Tambah tugas',
        onPressed: _bukaForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}
