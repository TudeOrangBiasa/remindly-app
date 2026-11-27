import 'dart:async';

import 'package:flutter/material.dart';
import 'package:remindly_app/database/app_database.dart';
import 'package:remindly_app/database/mata_kuliah_repo.dart';
import 'package:remindly_app/models/mata_kuliah.dart';
import 'package:remindly_app/widgets/empty_state.dart';
import 'package:sqflite/sqflite.dart';

class CoursesPage extends StatefulWidget {
  const new({super.key, this.db});

  final Database? db;

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  late Future<Database> _db;
  Future<List<MataKuliah>>? _daftar;

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
      _daftar = MataKuliahRepository(db).semua();
    });
  }

  Future<void> _bukaForm(List<MataKuliah> ada) async {
    final db = await _db;
    if (!mounted) return;
    final nama = TextEditingController();
    final dosen = TextEditingController();
    final hari = TextEditingController();
    final kunci = GlobalKey<FormState>();
    final simpan = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: const Text('Mata kuliah baru'),
        content: Form(
          key: kunci,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nama,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (nilai) {
                  final teks = (nilai ?? '').trim();
                  if (teks.isEmpty) return 'Nama wajib diisi';
                  final dobel = ada.any(
                    (m) => m.namaTrim.toLowerCase() == teks.toLowerCase(),
                  );
                  if (dobel) return 'Nama sudah ada';
                  return null;
                },
              ),
              TextFormField(
                controller: dosen,
                decoration: const InputDecoration(labelText: 'Dosen'),
              ),
              TextFormField(
                controller: hari,
                decoration: const InputDecoration(labelText: 'Hari'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialog).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () async {
              if (kunci.currentState!.validate()) {
                await MataKuliahRepository(db).tambah(
                  MataKuliah(
                    nama: nama.text,
                    dosen: dosen.text,
                    hari: hari.text,
                  ),
                );
                if (dialog.mounted) Navigator.of(dialog).pop(true);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    if (simpan == true) unawaited(_muat());
  }

  @override
  Widget build(BuildContext context) {
    final daftar = _daftar;
    return Scaffold(
      appBar: AppBar(title: const Text('Mata Kuliah')),
      body: daftar == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<MataKuliah>>(
              future: daftar,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final data = snapshot.data!;
                if (data.isEmpty) {
                  return EmptyState(
                    message:
                        'Belum ada mata kuliah. Tekan tombol + untuk menambah.',
                    onAdd: () => _bukaForm(data),
                  );
                }
                return ListView(
                  children: [
                    for (final m in data)
                      Semantics(
                        identifier: 'baris-matkul-${m.id}',
                        container: true,
                        explicitChildNodes: true,
                        child: ListTile(
                          key: Key('matkul-${m.id}'),
                          title: Text(m.nama),
                          subtitle: Text(
                            [
                              m.dosen,
                              m.hari,
                            ].where((s) => s.trim().isNotEmpty).join(' · '),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
      floatingActionButton: Semantics(
        identifier: 'tambah-matkul',
        container: true,
        explicitChildNodes: true,
        child: FloatingActionButton(
          tooltip: 'Tambah mata kuliah',
          onPressed: () async {
            final db = await _db;
            if (!mounted) return;
            unawaited(MataKuliahRepository(db).semua().then(_bukaForm));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
