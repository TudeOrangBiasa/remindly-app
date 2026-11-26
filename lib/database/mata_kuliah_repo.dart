import 'package:remindly_app/database/app_database.dart';
import 'package:remindly_app/models/mata_kuliah.dart';
import 'package:sqflite/sqflite.dart';

class MatkulHasTugasException implements Exception {
  const new(this.jumlah);

  final int jumlah;
}

class MataKuliahRepository {
  new(this.db);

  final Database db;

  Future<int> tambah(MataKuliah matkul) async {
    _wajibNama(matkul);
    return await db.insert(AppDatabase.mataKuliahTable, <String, Object?>{
      'nama': matkul.namaTrim,
      'dosen': matkul.dosen.trim(),
      'hari': matkul.hari.trim(),
    });
  }

  Future<List<MataKuliah>> semua() async {
    final rows = await db.query(
      AppDatabase.mataKuliahTable,
      orderBy: 'nama COLLATE NOCASE ASC',
    );
    return rows.map(MataKuliah.fromMap).toList();
  }

  Future<MataKuliah?> perId(int id) async {
    final rows = await db.query(
      AppDatabase.mataKuliahTable,
      where: 'id = ?',
      whereArgs: <Object?>[id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return MataKuliah.fromMap(rows.first);
  }

  Future<int> ubah(MataKuliah matkul) async {
    _wajibNama(matkul);
    final id = matkul.id;
    if (id == null) throw ArgumentError('ubah butuh id');
    return await db.update(
      AppDatabase.mataKuliahTable,
      <String, Object?>{
        'nama': matkul.namaTrim,
        'dosen': matkul.dosen.trim(),
        'hari': matkul.hari.trim(),
      },
      where: 'id = ?',
      whereArgs: <Object?>[id],
    );
  }

  Future<void> hapus(int id) async {
    final jumlah =
        Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(*) FROM ${AppDatabase.tugasTable} '
            'WHERE matkul_id = ?',
            <Object?>[id],
          ),
        ) ??
        0;
    if (jumlah > 0) throw MatkulHasTugasException(jumlah);
    await db.delete(
      AppDatabase.mataKuliahTable,
      where: 'id = ?',
      whereArgs: <Object?>[id],
    );
  }

  void _wajibNama(MataKuliah matkul) {
    if (matkul.namaTrim.isEmpty) throw ArgumentError('nama wajib diisi');
  }
}
