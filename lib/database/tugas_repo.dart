import 'package:remindly_app/database/app_database.dart';
import 'package:remindly_app/models/tugas.dart';
import 'package:sqflite/sqflite.dart';

enum FilterTugas { semua, belumSelesai, selesai, terlambat }

class TugasRepository {
  new(this.db);

  final Database db;

  Future<int> tambah(Tugas tugas, {DateTime? sekarang}) async {
    _wajibValid(tugas, sekarang ?? DateTime.now());
    return await db.insert(AppDatabase.tugasTable, <String, Object?>{
      'matkul_id': tugas.matkulId,
      'judul': tugas.judul.trim(),
      'deskripsi': tugas.deskripsi.trim(),
      'deadline': tugas.deadline.millisecondsSinceEpoch,
      'prioritas': tugas.prioritas.label,
      'selesai': tugas.selesai ? 1 : 0,
    });
  }

  Future<int> ubah(Tugas tugas, {DateTime? sekarang}) async {
    _wajibValid(tugas, sekarang ?? DateTime.now());
    final id = tugas.id;
    if (id == null) throw ArgumentError('ubah butuh id');
    return await db.update(
      AppDatabase.tugasTable,
      <String, Object?>{
        'matkul_id': tugas.matkulId,
        'judul': tugas.judul.trim(),
        'deskripsi': tugas.deskripsi.trim(),
        'deadline': tugas.deadline.millisecondsSinceEpoch,
        'prioritas': tugas.prioritas.label,
        'selesai': tugas.selesai ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: <Object?>[id],
    );
  }

  Future<List<Tugas>> daftarPerMatkul(int matkulId) async {
    final rows = await db.query(
      AppDatabase.tugasTable,
      where: 'matkul_id = ?',
      whereArgs: <Object?>[matkulId],
      orderBy: 'deadline ASC, id ASC',
    );
    return rows.map(Tugas.fromMap).toList();
  }

  Future<List<Tugas>> daftar(FilterTugas filter, {DateTime? sekarang}) async {
    final where = <String>[];
    final args = <Object?>[];
    switch (filter) {
      case FilterTugas.semua:
        break;
      case FilterTugas.belumSelesai:
        where.add('selesai = 0');
      case FilterTugas.selesai:
        where.add('selesai = 1');
      case FilterTugas.terlambat:
        final now = sekarang ?? DateTime.now();
        final hariIni = DateTime(
          now.year,
          now.month,
          now.day,
        ).millisecondsSinceEpoch;
        where
          ..add('selesai = 0')
          ..add('deadline < ?');
        args.add(hariIni);
    }
    final rows = await db.query(
      AppDatabase.tugasTable,
      where: where.isEmpty ? null : where.join(' AND '),
      whereArgs: args.isEmpty ? null : args,
      orderBy: 'deadline ASC, id ASC',
    );
    return rows.map(Tugas.fromMap).toList();
  }

  Future<Tugas?> perId(int id) async {
    final rows = await db.query(
      AppDatabase.tugasTable,
      where: 'id = ?',
      whereArgs: <Object?>[id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Tugas.fromMap(rows.first);
  }

  Future<Tugas?> toggleSelesai(int id) async {
    final changed = await db.rawUpdate(
      'UPDATE ${AppDatabase.tugasTable} SET selesai = 1 - selesai '
      'WHERE id = ?',
      <Object?>[id],
    );
    if (changed == 0) return null;
    return await perId(id);
  }

  void _wajibValid(Tugas tugas, DateTime now) {
    if (tugas.judul.trim().isEmpty) throw ArgumentError('judul wajib diisi');
    final hariIni = DateTime(now.year, now.month, now.day);
    final batas = DateTime(
      tugas.deadline.year,
      tugas.deadline.month,
      tugas.deadline.day,
    );
    if (batas.isBefore(hariIni)) {
      throw ArgumentError('deadline tidak boleh lewat');
    }
  }
}
