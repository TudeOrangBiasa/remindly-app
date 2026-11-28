import 'package:flutter/material.dart';

import 'package:remindly_app/database/app_database.dart';
import 'package:remindly_app/database/tugas_repo.dart';
import 'package:remindly_app/models/tugas.dart';
import 'package:remindly_app/pages/course_detail_page.dart';
import 'package:remindly_app/pages/task_form_page.dart';
import 'package:remindly_app/theme/theme_mode_scope.dart';
import 'package:remindly_app/theme/tokens.dart';
import 'package:remindly_app/widgets/empty_state.dart';
import 'package:remindly_app/widgets/status_badge.dart';
import 'package:sqflite/sqflite.dart';

class _Ringkas {
  const new({
    required this.belum,
    required this.terlambat,
    required this.terdekat,
  });

  final int belum;
  final int terlambat;
  final List<Tugas> terdekat;
}

class HomePage extends StatefulWidget {
  const new({super.key, this.db});

  final Database? db;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<Database> _db;

  @override
  void initState() {
    super.initState();
    _db = widget.db != null ? Future.value(widget.db) : AppDatabase.open();
  }

  Future<_Ringkas> _muat(DateTime sekarang) async {
    final db = await _db;
    final semua = await TugasRepository(db).daftar(FilterTugas.semua);
    var terlambat = 0;
    for (final t in semua) {
      if (t.isTerlambat(sekarang)) terlambat++;
    }
    return _Ringkas(
      belum: semua.where((t) => !t.selesai).length,
      terlambat: terlambat,
      terdekat: semua.where((t) => !t.selesai).take(3).toList(),
    );
  }

  Future<void> _bukaForm() async {
    final db = await _db;
    if (!mounted) return;
    await Navigator.of(
      context,
    ).push<bool>(MaterialPageRoute<bool>(builder: (_) => TaskFormPage(db: db)));
    if (mounted) setState(() {});
  }

  String _tampil(DateTime d) => '${d.day}/${d.month}/${d.year}';

  @override
  Widget build(BuildContext context) {
    final sekarang = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
        actions: const [ThemeModeButton()],
      ),
      body: FutureBuilder<_Ringkas>(
        future: _muat(sekarang),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(AppTokens.spaceM),
            children: [
              Row(
                children: [
                  Expanded(
                    child: _Angka(
                      kunci: 'angka-belum',
                      label: 'Belum selesai',
                      nilai: data.belum,
                    ),
                  ),
                  const SizedBox(width: AppTokens.spaceM),
                  Expanded(
                    child: _Angka(
                      kunci: 'angka-terlambat',
                      label: 'Terlambat',
                      nilai: data.terlambat,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTokens.spaceL),
              Text(
                'Tugas terdekat',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppTokens.spaceS),
              if (data.terdekat.isEmpty)
                EmptyState(
                  message: 'Belum ada tugas. Tekan tombol + untuk menambah.',
                  onAdd: _bukaForm,
                )
              else
                for (final t in data.terdekat)
                  Semantics(
                    identifier: 'beranda-${t.id}',
                    container: true,
                    explicitChildNodes: true,
                    child: ListTile(
                      key: Key('beranda-${t.id}'),
                      contentPadding: EdgeInsets.zero,
                      title: Text(t.judul),
                      subtitle: Text(_tampil(t.deadline)),
                      trailing: t.isTerlambat(sekarang)
                          ? const StatusBadge.terlambat()
                          : t.isHampir(sekarang)
                          ? const StatusBadge.hampir()
                          : null,
                      onTap: () async {
                        final db = await _db;
                        if (!context.mounted) return;
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                CourseDetailPage(courseId: t.matkulId, db: db),
                          ),
                        );
                      },
                    ),
                  ),
            ],
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

class _Angka extends StatelessWidget {
  const new({required this.kunci, required this.label, required this.nilai});

  final String kunci;
  final String label;
  final int nilai;
  @override
  Widget build(BuildContext context) {
    return Semantics(
      identifier: kunci,
      container: true,
      explicitChildNodes: true,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppTokens.spaceM),
          child: Column(
            children: [
              Text(
                '$nilai',
                key: Key(kunci),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
