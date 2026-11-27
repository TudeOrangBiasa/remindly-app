import 'dart:async';

import 'package:flutter/material.dart';
import 'package:remindly_app/database/app_database.dart';
import 'package:remindly_app/database/mata_kuliah_repo.dart';
import 'package:remindly_app/database/tugas_repo.dart';
import 'package:remindly_app/models/mata_kuliah.dart';
import 'package:remindly_app/models/tugas.dart';
import 'package:remindly_app/widgets/empty_state.dart';
import 'package:sqflite/sqflite.dart';

class _Detail {
  const new({required this.matkul, required this.tugas});

  final MataKuliah matkul;
  final List<Tugas> tugas;
}

class CourseDetailPage extends StatefulWidget {
  const new({required this.courseId, super.key, this.db});

  final int courseId;
  final Database? db;

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  static const _kosong = '0 dari 0 tugas selesai. Tambah tugas pertama.';

  static void _tidakAda() {}

  late Future<Database> _db;
  Future<_Detail>? _detail;

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
      _detail = _baca(db);
    });
  }

  Future<_Detail> _baca(Database db) async {
    final matkul = await MataKuliahRepository(db).perId(widget.courseId);
    final tugas = await TugasRepository(db).daftarPerMatkul(widget.courseId);
    return _Detail(
      matkul: matkul ?? const MataKuliah(nama: 'Mata kuliah'),
      tugas: tugas,
    );
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
    final detail = _detail;
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Mata Kuliah')),
      body: detail == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<_Detail>(
              future: detail,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final data = snapshot.data!;
                final selesai = data.tugas.where((t) => t.selesai).length;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.matkul.nama,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Text(
                            '$selesai dari ${data.tugas.length} tugas selesai',
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: data.tugas.isEmpty
                          ? const EmptyState(message: _kosong, onAdd: _tidakAda)
                          : ListView.builder(
                              itemCount: data.tugas.length,
                              itemBuilder: (context, i) {
                                final t = data.tugas[i];
                                return ListTile(
                                  key: Key('tugas-${t.id}'),
                                  leading: Checkbox(
                                    semanticLabel: 'Selesai ${t.judul}',
                                    value: t.selesai,
                                    onChanged: (_) => _toggle(t),
                                  ),
                                  title: Text(t.judul),
                                  subtitle: Text(_tampil(t.deadline)),
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
