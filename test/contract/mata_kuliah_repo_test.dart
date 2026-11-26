import 'package:flutter_test/flutter_test.dart';
import 'package:remindly_app/database/app_database.dart';
import 'package:remindly_app/database/mata_kuliah_repo.dart';
import 'package:remindly_app/models/mata_kuliah.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<Database> openRepoDb() {
  return openDatabase(
    inMemoryDatabasePath,
    version: AppDatabase.version,
    onConfigure: AppDatabase.onConfigure,
    onCreate: AppDatabase.onCreate,
    onUpgrade: AppDatabase.onUpgrade,
  );
}

Future<void> insertTugasMentah(Database db, int matkulId, String judul) {
  return db.insert(AppDatabase.tugasTable, <String, Object?>{
    'matkul_id': matkulId,
    'judul': judul,
    'deskripsi': '',
    'deadline': DateTime(2026, 5, 11).millisecondsSinceEpoch,
    'prioritas': 'Tinggi',
    'selesai': 0,
  });
}

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Repo matkul REM-02b', () {
    test('roundtrip tambah baca ubah hapus', () async {
      final db = await openRepoDb();
      final repo = MataKuliahRepository(db);

      final id = await repo.tambah(
        const MataKuliah(nama: ' Matematika ', dosen: 'Bu Ana', hari: 'Senin'),
      );
      final tersimpan = await repo.perId(id);
      expect(tersimpan?.nama, 'Matematika');
      expect(tersimpan?.dosen, 'Bu Ana');

      final daftar = await repo.semua();
      expect(daftar.map((m) => m.nama), <String>['Matematika']);

      await repo.ubah(
        MataKuliah(id: id, nama: 'Fisika', dosen: 'Pak Budi', hari: 'Selasa'),
      );
      expect((await repo.perId(id))?.nama, 'Fisika');

      await repo.hapus(id);
      expect(await repo.perId(id), isNull);
      expect(await repo.semua(), isEmpty);
      await db.close();
    });

    test('duplikat beda kapital ditolak', () async {
      final db = await openRepoDb();
      final repo = MataKuliahRepository(db);

      await repo.tambah(const MataKuliah(nama: 'Matematika'));
      await expectLater(
        () => repo.tambah(const MataKuliah(nama: 'MATEMATIKA')),
        throwsA(isA<DatabaseException>()),
      );
      await db.close();
    });

    test('nama blank ditolak, ubah tanpa id ditolak', () async {
      final db = await openRepoDb();
      final repo = MataKuliahRepository(db);

      await expectLater(
        () => repo.tambah(const MataKuliah(nama: '   ')),
        throwsA(isA<ArgumentError>()),
      );
      await expectLater(
        () => repo.ubah(const MataKuliah(id: 1, nama: '  ')),
        throwsA(isA<ArgumentError>()),
      );
      await expectLater(
        () => repo.ubah(const MataKuliah(nama: 'Tanpa id')),
        throwsA(isA<ArgumentError>()),
      );
      await db.close();
    });

    test('hapus matkul bertugas ditolak dengan jumlah', () async {
      final db = await openRepoDb();
      final repo = MataKuliahRepository(db);

      final id = await repo.tambah(const MataKuliah(nama: 'Kimia'));
      await insertTugasMentah(db, id, 'PR 1');
      await insertTugasMentah(db, id, 'PR 2');

      try {
        await repo.hapus(id);
        fail('hapus harus ditolak');
      } on MatkulHasTugasException catch (e) {
        expect(e.jumlah, 2);
      }
      expect(await repo.perId(id), isNotNull);
      await db.close();
    });

    test('ubah ke nama duplikat ditolak', () async {
      final db = await openRepoDb();
      final repo = MataKuliahRepository(db);

      await repo.tambah(const MataKuliah(nama: 'Biologi'));
      final id = await repo.tambah(const MataKuliah(nama: 'Sejarah'));
      await expectLater(
        () => repo.ubah(MataKuliah(id: id, nama: 'BIOLOGI')),
        throwsA(isA<DatabaseException>()),
      );
      await db.close();
    });
  });
}
