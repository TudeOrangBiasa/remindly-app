import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Skema v1 sesuai docs/specs/01-database.md.
abstract final class AppDatabase {
  static const int version = 1;
  static const String mataKuliahTable = 'mata_kuliah';
  static const String tugasTable = 'tugas';

  static Future<Database> open({String? path}) async {
    final dbPath = path ?? p.join(await getDatabasesPath(), 'remindly.db');
    return await openDatabase(
      dbPath,
      version: version,
      onConfigure: onConfigure,
      onCreate: onCreate,
      onUpgrade: onUpgrade,
    );
  }

  static Future<void> onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  static Future<void> onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE $mataKuliahTable(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nama TEXT NOT NULL COLLATE NOCASE UNIQUE,
  dosen TEXT NOT NULL DEFAULT '',
  hari TEXT NOT NULL DEFAULT ''
)''');
    await db.execute('''
CREATE TABLE $tugasTable(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  matkul_id INTEGER NOT NULL REFERENCES $mataKuliahTable(id) ON DELETE RESTRICT,
  judul TEXT NOT NULL,
  deskripsi TEXT NOT NULL DEFAULT '',
  deadline INTEGER NOT NULL,
  prioritas TEXT NOT NULL DEFAULT 'Sedang'
    CHECK (prioritas IN ('Rendah', 'Sedang', 'Tinggi')),
  selesai INTEGER NOT NULL DEFAULT 0
)''');
    await db.execute(
      'CREATE INDEX idx_tugas_deadline ON $tugasTable(deadline)',
    );
    await db.execute(
      'CREATE INDEX idx_tugas_matkul_deadline '
      'ON $tugasTable(matkul_id, deadline)',
    );
  }

  static Future<void> onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {}
}
