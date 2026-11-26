import 'package:flutter/material.dart';

import 'package:remindly_app/database/mata_kuliah_repo.dart';
import 'package:remindly_app/database/tugas_repo.dart';
import 'package:remindly_app/models/mata_kuliah.dart';
import 'package:remindly_app/models/tugas.dart';
import 'package:remindly_app/theme/tokens.dart';
import 'package:sqflite/sqflite.dart';

class TaskFormPage extends StatefulWidget {
  const new({required this.db, super.key, this.awal});

  final Database db;
  final Tugas? awal;

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _judul = TextEditingController();
  final _deadline = TextEditingController();
  int? _matkulId;
  DateTime? _tanggal;
  Prioritas _prioritas = Prioritas.sedang;
  bool _menyimpan = false;

  bool get _ubah => widget.awal != null;

  @override
  void initState() {
    super.initState();
    final awal = widget.awal;
    if (awal != null) {
      _matkulId = awal.matkulId;
      _judul.text = awal.judul;
      _tanggal = awal.deadline;
      _prioritas = awal.prioritas;
      _deadline.text = _tampil(awal.deadline);
    }
  }

  @override
  void dispose() {
    _judul.dispose();
    _deadline.dispose();
    super.dispose();
  }

  String _tampil(DateTime d) => '${d.day}/${d.month}/${d.year}';

  Future<void> _pilihTanggal() async {
    final hariIni = DateTime.now();
    final hari = DateTime(hariIni.year, hariIni.month, hariIni.day);
    final pilih = await showDatePicker(
      context: context,
      initialDate: _tanggal ?? hari,
      firstDate: hari,
      lastDate: DateTime(hari.year + 5),
    );
    if (pilih != null) {
      setState(() {
        _tanggal = pilih;
        _deadline.text = _tampil(pilih);
      });
    }
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _menyimpan = true);
    try {
      final repo = TugasRepository(widget.db);
      final awal = widget.awal;
      if (awal == null) {
        await repo.tambah(
          Tugas(
            matkulId: _matkulId!,
            judul: _judul.text,
            deadline: _tanggal!,
            prioritas: _prioritas,
          ),
        );
      } else {
        await repo.ubah(
          Tugas(
            id: awal.id,
            matkulId: _matkulId!,
            judul: _judul.text,
            deadline: _tanggal!,
            prioritas: _prioritas,
            selesai: awal.selesai,
          ),
        );
      }
      if (mounted) Navigator.of(context).pop(true);
    } on DatabaseException catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menyimpan, coba lagi.')),
        );
      }
    } finally {
      if (mounted) setState(() => _menyimpan = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_ubah ? 'Ubah Tugas' : 'Tambah Tugas')),
      body: FutureBuilder<List<MataKuliah>>(
        future: MataKuliahRepository(widget.db).semua(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final matkul = snapshot.data!;
          if (matkul.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada mata kuliah. Tambah dulu di halaman Matkul.',
              ),
            );
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(AppTokens.spaceM),
              children: [
                DropdownButtonFormField<int>(
                  key: const Key('matkul'),
                  initialValue: _matkulId,
                  decoration: const InputDecoration(labelText: 'Mata kuliah'),
                  items: [
                    for (final m in matkul)
                      DropdownMenuItem(value: m.id, child: Text(m.nama)),
                  ],
                  validator: (v) => v == null ? 'Pilih mata kuliah.' : null,
                  onChanged: (v) => setState(() => _matkulId = v),
                ),
                const SizedBox(height: AppTokens.spaceM),
                TextFormField(
                  key: const Key('judul'),
                  controller: _judul,
                  decoration: const InputDecoration(labelText: 'Judul'),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Judul wajib diisi.'
                      : null,
                ),
                const SizedBox(height: AppTokens.spaceM),
                TextFormField(
                  key: const Key('deadline'),
                  controller: _deadline,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: 'Batas waktu'),
                  onTap: _pilihTanggal,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Pilih batas waktu.';
                    final t = _tanggal;
                    if (t == null) return 'Pilih batas waktu.';
                    final hariIni = DateTime.now();
                    final hari = DateTime(
                      hariIni.year,
                      hariIni.month,
                      hariIni.day,
                    );
                    final batas = DateTime(t.year, t.month, t.day);
                    if (batas.isBefore(hari)) return 'Tanggal lewat ditolak.';
                    return null;
                  },
                ),
                const SizedBox(height: AppTokens.spaceM),
                SegmentedButton<Prioritas>(
                  segments: const [
                    ButtonSegment(
                      value: Prioritas.rendah,
                      label: Text('Rendah'),
                    ),
                    ButtonSegment(
                      value: Prioritas.sedang,
                      label: Text('Sedang'),
                    ),
                    ButtonSegment(
                      value: Prioritas.tinggi,
                      label: Text('Tinggi'),
                    ),
                  ],
                  selected: {_prioritas},
                  onSelectionChanged: (s) =>
                      setState(() => _prioritas = s.single),
                ),
                const SizedBox(height: AppTokens.spaceL),
                FilledButton(
                  key: const Key('simpan'),
                  onPressed: _menyimpan ? null : _simpan,
                  child: const Text('Simpan'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
