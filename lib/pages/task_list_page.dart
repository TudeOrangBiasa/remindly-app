import 'dart:async';

import 'package:flutter/material.dart';

import 'package:remindly_app/database/app_database.dart';
import 'package:remindly_app/database/tugas_repo.dart';
import 'package:remindly_app/models/tugas.dart';
import 'package:remindly_app/pages/task_form_page.dart';
import 'package:remindly_app/widgets/empty_state.dart';
import 'package:sqflite/sqflite.dart';

class TaskListPage extends StatefulWidget {
  const new({super.key, this.db});

  final Database? db;

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  late Future<Database> _db;
  Future<List<Tugas>>? _daftar;

  @override
  void initState() {
    super.initState();
    _db = widget.db != null ? Future.value(widget.db) : AppDatabase.open();
    unawaited(_muat());
  }

  Future<void> _muat() async {
    final db = await _db;
    if (!mounted) return;
    setState(() {
      _daftar = TugasRepository(db).daftar(FilterTugas.semua);
    });
  }

  Future<void> _bukaForm() async {
    final db = await _db;
    if (!mounted) return;
    final simpan = await Navigator.of(
      context,
    ).push<bool>(MaterialPageRoute<bool>(builder: (_) => TaskFormPage(db: db)));
    if (simpan == true) unawaited(_muat());
  }

  Future<void> _ubah(Tugas tugas) async {
    final db = await _db;
    if (!mounted) return;
    final simpan = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => TaskFormPage(db: db, awal: tugas),
      ),
    );
    if (simpan == true) unawaited(_muat());
  }

  Future<void> _toggle(Tugas tugas) async {
    final db = await _db;
    if (!mounted) return;
    await TugasRepository(db).toggleSelesai(tugas.id!);
    unawaited(_muat());
  }

  String _tampil(DateTime d) => '${d.day}/${d.month}/${d.year}';

  @override
  Widget build(BuildContext context) {
    final daftar = _daftar;
    return Scaffold(
      appBar: AppBar(title: const Text('Tugas')),
      body: daftar == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<Tugas>>(
              future: daftar,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final tugas = snapshot.data!;
                if (tugas.isEmpty) {
                  return EmptyState(
                    message: 'Belum ada tugas. Tekan tombol + untuk menambah.',
                    onAdd: _bukaForm,
                  );
                }
                return ListView.builder(
                  itemCount: tugas.length,
                  itemBuilder: (context, i) {
                    final t = tugas[i];
                    return ListTile(
                      key: Key('tugas-${t.id}'),
                      leading: Checkbox(
                        semanticLabel: 'Selesai ${t.judul}',
                        value: t.selesai,
                        onChanged: (_) => _toggle(t),
                      ),
                      title: Text(t.judul),
                      subtitle: Text(_tampil(t.deadline)),
                      onTap: () => _ubah(t),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Tambah tugas',
        onPressed: _bukaForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}
