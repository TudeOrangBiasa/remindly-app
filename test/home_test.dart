import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remindly_app/database/app_database.dart';
import 'package:remindly_app/database/mata_kuliah_repo.dart';
import 'package:remindly_app/database/tugas_repo.dart';
import 'package:remindly_app/models/mata_kuliah.dart';
import 'package:remindly_app/models/tugas.dart';
import 'package:remindly_app/pages/home_page.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'test_helpers.dart';

Future<int> tanamTugas(
  WidgetTester tester,
  Database db,
  int matkulId,
  String judul,
  DateTime deadline, {
  bool selesai = false,
}) {
  return bacaDb(
    tester,
    () => db.insert(AppDatabase.tugasTable, <String, Object?>{
      'matkul_id': matkulId,
      'judul': judul,
      'deskripsi': '',
      'deadline': deadline.millisecondsSinceEpoch,
      'prioritas': 'Tinggi',
      'selesai': selesai ? 1 : 0,
    }),
  );
}

String angka(WidgetTester tester, String kunci) {
  return tester.widget<Text>(find.byKey(Key(kunci))).data ?? '';
}

Future<void> pumpBeranda(WidgetTester tester, Database db) async {
  await tester.pumpWidget(MaterialApp(home: HomePage(db: db)));
  await tester.pump();
  await biarDbSelesai(tester);
  await tester.pump();
  await biarDbSelesai(tester);
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Beranda REM-06a', () {
    testWidgets('angka benar lawan data', (tester) async {
      final db = await bukaDb(tester);
      final matkul = await bacaDb(
        tester,
        () =>
            MataKuliahRepository(db)
                .tambah(const MataKuliah(nama: 'Matematika')),
      );
      final kemarin = DateTime.now().subtract(const Duration(days: 1));
      final besok = DateTime.now().add(const Duration(days: 1));
      final lusa = DateTime.now().add(const Duration(days: 5));
      await tanamTugas(tester, db, matkul, 'Lewat', kemarin);
      await tanamTugas(tester, db, matkul, 'Besok', besok);
      await tanamTugas(tester, db, matkul, 'Selesai', lusa, selesai: true);
      await pumpBeranda(tester, db);

      expect(angka(tester, 'angka-belum'), '2');
      expect(angka(tester, 'angka-terlambat'), '1');
      await tutupDb(tester, db);
    });

    testWidgets('3 terdekat urut dan terbatas', (tester) async {
      final db = await bukaDb(tester);
      final matkul = await bacaDb(
        tester,
        () => MataKuliahRepository(db).tambah(const MataKuliah(nama: 'F')),
      );
      final repo = TugasRepository(db);
      for (final d in [20, 5, 11, 2]) {
        await bacaDb(
          tester,
          () => repo.tambah(
            Tugas(
              matkulId: matkul,
              judul: 'H$d',
              deadline: DateTime.now().add(Duration(days: d)),
            ),
          ),
        );
      }
      await pumpBeranda(tester, db);

      final judul = tester
          .widgetList<ListTile>(find.byType(ListTile))
          .map((t) => (t.title! as Text).data!);
      expect(judul, <String>['H2', 'H5', 'H11']);
      await tutupDb(tester, db);
    });

    testWidgets('badge H-1 dan terlambat tampil', (tester) async {
      final db = await bukaDb(tester);
      final matkul = await bacaDb(
        tester,
        () => MataKuliahRepository(db).tambah(const MataKuliah(nama: 'K')),
      );
      final repo = TugasRepository(db);
      await bacaDb(
        tester,
        () => repo.tambah(
          Tugas(
            matkulId: matkul,
            judul: 'Besok',
            deadline: DateTime.now().add(const Duration(days: 1)),
          ),
        ),
      );
      await tanamTugas(
        tester,
        db,
        matkul,
        'Lewat',
        DateTime.now().subtract(const Duration(days: 1)),
      );
      await pumpBeranda(tester, db);

      expect(find.text('H-1'), findsOneWidget);
      expect(find.text('Terlambat'), findsWidgets);
      await tutupDb(tester, db);
    });

    testWidgets('kosong tampil nol pesan tombol', (tester) async {
      final db = await bukaDb(tester);
      await pumpBeranda(tester, db);

      expect(angka(tester, 'angka-belum'), '0');
      expect(angka(tester, 'angka-terlambat'), '0');
      expect(find.textContaining('Belum ada tugas'), findsOneWidget);
      expect(find.text('Tambah'), findsWidgets);
      await tutupDb(tester, db);
    });
  });
}
