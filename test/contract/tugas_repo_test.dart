import 'package:flutter_test/flutter_test.dart';
import 'package:remindly_app/database/app_database.dart';
import 'package:remindly_app/database/mata_kuliah_repo.dart';
import 'package:remindly_app/database/tugas_repo.dart';
import 'package:remindly_app/models/mata_kuliah.dart';
import 'package:remindly_app/models/tugas.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

final sekarang = DateTime(2026, 5, 10, 12);

Future<Database> openRepoDb() {
  return openDatabase(
    inMemoryDatabasePath,
    version: AppDatabase.version,
    onConfigure: AppDatabase.onConfigure,
    onCreate: AppDatabase.onCreate,
    onUpgrade: AppDatabase.onUpgrade,
  );
}

Future<int> tambahMatkul(Database db, String nama) {
  return MataKuliahRepository(db).tambah(MataKuliah(nama: nama));
}

Future<int> tanamTugas(
  Database db,
  int matkulId,
  String judul,
  DateTime deadline, {
  bool selesai = false,
}) {
  return db.insert(AppDatabase.tugasTable, <String, Object?>{
    'matkul_id': matkulId,
    'judul': judul,
    'deskripsi': '',
    'deadline': deadline.millisecondsSinceEpoch,
    'prioritas': 'Tinggi',
    'selesai': selesai ? 1 : 0,
  });
}

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Repo tugas REM-02c', () {
    test('daftar urut deadline menaik', () async {
      final db = await openRepoDb();
      final repo = TugasRepository(db);
      final matkul = await tambahMatkul(db, 'Matematika');

      await tanamTugas(db, matkul, 'Belakang', DateTime(2026, 5, 20));
      await tanamTugas(db, matkul, 'Depan', DateTime(2026, 5, 9));
      await tanamTugas(db, matkul, 'Tengah', DateTime(2026, 5, 11));

      final daftar = await repo.daftar(FilterTugas.semua, sekarang: sekarang);
      expect(daftar.map((t) => t.judul), <String>[
        'Depan',
        'Tengah',
        'Belakang',
      ]);
      await db.close();
    });

    test('filter 4 mode ikut isTerlambat', () async {
      final db = await openRepoDb();
      final repo = TugasRepository(db);
      final matkul = await tambahMatkul(db, 'Fisika');

      await tanamTugas(db, matkul, 'Lewat', DateTime(2026, 5, 9));
      await tanamTugas(db, matkul, 'Besok', DateTime(2026, 5, 11));
      await tanamTugas(db, matkul, 'Lusa', DateTime(2026, 5, 20));
      await tanamTugas(
        db,
        matkul,
        'Lewat selesai',
        DateTime(2026, 5, 8),
        selesai: true,
      );

      final semua = await repo.daftar(FilterTugas.semua, sekarang: sekarang);
      expect(semua, hasLength(4));

      final aktif = await repo.daftar(
        FilterTugas.belumSelesai,
        sekarang: sekarang,
      );
      expect(aktif.map((t) => t.judul), <String>['Lewat', 'Besok', 'Lusa']);

      final selesai = await repo.daftar(
        FilterTugas.selesai,
        sekarang: sekarang,
      );
      expect(selesai.map((t) => t.judul), <String>['Lewat selesai']);

      final terlambat = await repo.daftar(
        FilterTugas.terlambat,
        sekarang: sekarang,
      );
      expect(terlambat.map((t) => t.judul), <String>['Lewat']);
      for (final t in terlambat) {
        expect(t.isTerlambat(sekarang), isTrue);
      }
      for (final t in semua) {
        expect(t.isTerlambat(sekarang), terlambat.any((l) => l.id == t.id));
      }
      await db.close();
    });

    test('daftarPerMatkul hanya miliknya urut deadline', () async {
      final db = await openRepoDb();
      final repo = TugasRepository(db);
      final fisika = await tambahMatkul(db, 'Fisika');
      final kimia = await tambahMatkul(db, 'Kimia');

      await tanamTugas(db, fisika, 'Belakang', DateTime(2026, 5, 20));
      await tanamTugas(db, kimia, 'Kimia 1', DateTime(2026, 5, 9));
      await tanamTugas(db, fisika, 'Depan', DateTime(2026, 5, 9));

      final daftar = await repo.daftarPerMatkul(fisika);
      expect(daftar.map((t) => t.judul), <String>['Depan', 'Belakang']);
      expect(await repo.daftarPerMatkul(kimia + 999), isEmpty);
      await db.close();
    });

    test('toggle selesai roundtrip', () async {
      final db = await openRepoDb();
      final repo = TugasRepository(db);
      final matkul = await tambahMatkul(db, 'Kimia');

      final id = await repo.tambah(
        Tugas(matkulId: matkul, judul: 'PR 1', deadline: DateTime(2026, 5, 11)),
        sekarang: sekarang,
      );
      expect((await repo.perId(id))?.selesai, isFalse);

      expect((await repo.toggleSelesai(id))?.selesai, isTrue);
      expect((await repo.perId(id))?.selesai, isTrue);

      expect((await repo.toggleSelesai(id))?.selesai, isFalse);
      expect(await repo.toggleSelesai(999), isNull);
      await db.close();
    });

    test('tambah validasi deadline', () async {
      final db = await openRepoDb();
      final repo = TugasRepository(db);
      final matkul = await tambahMatkul(db, 'Biologi');

      await expectLater(
        () => repo.tambah(
          Tugas(
            matkulId: matkul,
            judul: 'Kemarin',
            deadline: DateTime(2026, 5, 9),
          ),
          sekarang: sekarang,
        ),
        throwsA(isA<ArgumentError>()),
      );
      final hariIni = await repo.tambah(
        Tugas(
          matkulId: matkul,
          judul: 'Hari ini',
          deadline: DateTime(2026, 5, 10, 23, 59),
          prioritas: Prioritas.rendah,
        ),
        sekarang: sekarang,
      );
      final tersimpan = await repo.perId(hariIni);
      expect(tersimpan?.prioritas, Prioritas.rendah);
      await expectLater(
        () => repo.tambah(
          Tugas(
            matkulId: 999,
            judul: 'Tanpa matkul',
            deadline: DateTime(2026, 5, 11),
          ),
          sekarang: sekarang,
        ),
        throwsA(isA<DatabaseException>()),
      );
      await db.close();
    });

    test('ubah roundtrip dan validasi', () async {
      final db = await openRepoDb();
      final repo = TugasRepository(db);
      final matkul = await tambahMatkul(db, 'Matematika');

      final id = await repo.tambah(
        Tugas(matkulId: matkul, judul: 'PR 1', deadline: DateTime(2026, 5, 11)),
        sekarang: sekarang,
      );
      await repo.ubah(
        Tugas(
          id: id,
          matkulId: matkul,
          judul: 'PR 1 revisi',
          deadline: DateTime(2026, 5, 12),
          prioritas: Prioritas.tinggi,
        ),
        sekarang: sekarang,
      );
      final tersimpan = await repo.perId(id);
      expect(tersimpan?.judul, 'PR 1 revisi');
      expect(tersimpan?.prioritas, Prioritas.tinggi);

      await expectLater(
        () => repo.ubah(
          Tugas(
            id: id,
            matkulId: matkul,
            judul: 'Lewat',
            deadline: DateTime(2026, 5, 9),
          ),
          sekarang: sekarang,
        ),
        throwsA(isA<ArgumentError>()),
      );
      await expectLater(
        () => repo.ubah(
          Tugas(
            matkulId: matkul,
            judul: 'Tanpa id',
            deadline: DateTime(2026, 5, 11),
          ),
          sekarang: sekarang,
        ),
        throwsA(isA<ArgumentError>()),
      );
      await db.close();
    });
  });
}
