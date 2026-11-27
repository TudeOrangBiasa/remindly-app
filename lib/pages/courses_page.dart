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

  Future<void> _bukaForm(List<MataKuliah> ada, [MataKuliah? lama]) async {
    final db = await _db;
    if (!mounted) return;
    final nama = TextEditingController(text: lama?.nama);
    final dosen = TextEditingController(text: lama?.dosen);
    final hari = TextEditingController(text: lama?.hari);
    final kunci = GlobalKey<FormState>();
    final simpan = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: Text(lama == null ? 'Mata kuliah baru' : 'Ubah mata kuliah'),
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
                    (m) =>
                        m.id != lama?.id &&
                        m.namaTrim.toLowerCase() == teks.toLowerCase(),
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
                final repo = MataKuliahRepository(db);
                final isi = MataKuliah(
                  id: lama?.id,
                  nama: nama.text,
                  dosen: dosen.text,
                  hari: hari.text,
                );
                await (lama == null ? repo.tambah(isi) : repo.ubah(isi));
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

  Future<void> _hapus(MataKuliah matkul) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: const Text('Hapus mata kuliah?'),
        content: Text('${matkul.nama} akan dihapus permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialog).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialog).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (yakin != true) return;
    final db = await _db;
    try {
      await MataKuliahRepository(db).hapus(matkul.id!);
    } on MatkulHasTugasException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tidak bisa dihapus, masih ada ${e.jumlah} tugas di '
            '${matkul.nama}.',
          ),
        ),
      );
      return;
    }
    unawaited(_muat());
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
                          onTap: () => _bukaForm(data, m),
                          subtitle: Text(
                            [
                              m.dosen,
                              m.hari,
                            ].where((s) => s.trim().isNotEmpty).join(' · '),
                          ),
                          trailing: Semantics(
                            identifier: 'hapus-matkul-${m.id}',
                            container: true,
                            explicitChildNodes: true,
                            child: IconButton(
                              tooltip: 'Hapus ${m.nama}',
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => _hapus(m),
                            ),
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
