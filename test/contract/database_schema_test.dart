import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:remindly_app/database/app_database.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<Database> openSchema({String? path, int? version}) {
  return openDatabase(
    path ?? inMemoryDatabasePath,
    version: version ?? AppDatabase.version,
    onConfigure: AppDatabase.onConfigure,
    onCreate: AppDatabase.onCreate,
    onUpgrade: AppDatabase.onUpgrade,
  );
}

Future<int> insertMatkul(Database db, String nama) {
  return db.insert(AppDatabase.mataKuliahTable, <String, Object?>{
    'nama': nama,
    'dosen': '',
    'hari': '',
  });
}

Future<int> insertTugas(
  Database db,
  int matkulId, {
  String prioritas = 'Tinggi',
}) {
  return db.insert(AppDatabase.tugasTable, <String, Object?>{
    'matkul_id': matkulId,
    'judul': 'PR 1',
    'deskripsi': '',
    'deadline': DateTime(2026, 5, 11).millisecondsSinceEpoch,
    'prioritas': prioritas,
    'selesai': 0,
  });
}

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Skema v1 REM-02a', () {
    test('entry point AppDatabase.open buat 2 tabel', () async {
      final db = await AppDatabase.open(path: inMemoryDatabasePath);
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type = 'table' "
        "AND name IN ('mata_kuliah', 'tugas')",
      );
      expect(
        tables.map((row) => row['name']),
        containsAll(<String>['mata_kuliah', 'tugas']),
      );
      await db.close();
    });

    test('nama duplikat ditolak, case-insensitive', () async {
      final db = await openSchema();
      await insertMatkul(db, 'Matematika');
      await expectLater(
        () => insertMatkul(db, 'Matematika'),
        throwsA(isA<DatabaseException>()),
      );
      await expectLater(
        () => insertMatkul(db, 'MATEMATIKA'),
        throwsA(isA<DatabaseException>()),
      );
      await db.close();
    });

    test('tugas matkul tak ada gagal', () async {
      final db = await openSchema();
      await expectLater(
        () => insertTugas(db, 999),
        throwsA(isA<DatabaseException>()),
      );
      await db.close();
    });

    test('index deadline ada', () async {
      final db = await openSchema();
      final indexes = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type = 'index' "
        "AND name IN ('idx_tugas_deadline', 'idx_tugas_matkul_deadline')",
      );
      expect(
        indexes.map((row) => row['name']),
        containsAll(<String>[
          'idx_tugas_deadline',
          'idx_tugas_matkul_deadline',
        ]),
      );
      await db.close();
    });

    test('foreign_keys ON dan hapus matkul bertugas ditolak', () async {
      final db = await openSchema();
      final pragma = await db.rawQuery('PRAGMA foreign_keys');
      expect(pragma.single['foreign_keys'], 1);
      final id = await insertMatkul(db, 'Fisika');
      await insertTugas(db, id);
      await expectLater(
        () => db.delete(
          AppDatabase.mataKuliahTable,
          where: 'id = ?',
          whereArgs: <Object?>[id],
        ),
        throwsA(isA<DatabaseException>()),
      );
      await db.close();
    });

    test('prioritas di luar Rendah Sedang Tinggi ditolak', () async {
      final db = await openSchema();
      final id = await insertMatkul(db, 'Kimia');
      await expectLater(
        () => insertTugas(db, id, prioritas: 'Darurat'),
        throwsA(isA<DatabaseException>()),
      );
      await db.close();
    });

    test('jalur upgrade jalan di file yang sama, data utuh', () async {
      final dir = await Directory.systemTemp.createTemp('remindly_schema');
      try {
        final path = p.join(dir.path, 'remindly.db');
        final v1 = await openSchema(path: path, version: 1);
        final id = await insertMatkul(v1, 'Biologi');
        await insertTugas(v1, id);
        await v1.close();

        final v2 = await openSchema(path: path, version: 2);
        expect(await v2.getVersion(), 2);
        final rows = await v2.query(AppDatabase.tugasTable);
        expect(rows, hasLength(1));
        await v2.close();
      } finally {
        await dir.delete(recursive: true);
      }
    });
  });
}
