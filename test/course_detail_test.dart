import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remindly_app/database/mata_kuliah_repo.dart';
import 'package:remindly_app/database/tugas_repo.dart';
import 'package:remindly_app/models/mata_kuliah.dart';
import 'package:remindly_app/models/tugas.dart';
import 'package:remindly_app/pages/course_detail_page.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'test_helpers.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  Future<void> pumpDetail(WidgetTester tester, Database db, int id) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CourseDetailPage(courseId: id, db: db),
      ),
    );
    await biarDbSelesai(tester);
    await tester.pump();
    await tester.pump();
  }

  group('CourseDetailPage hitungan', () {
    testWidgets('3 dari 5 benar', (tester) async {
      final db = await bukaDb(tester);
      final id = await bacaDb(
        tester,
        () => MataKuliahRepository(db).tambah(const MataKuliah(nama: 'Fisika')),
      );
      final repo = TugasRepository(db);
      for (var i = 0; i < 5; i++) {
        await bacaDb(
          tester,
          () => repo.tambah(
            Tugas(
              matkulId: id,
              judul: 'T$i',
              deadline: DateTime.now().add(Duration(days: i + 1)),
              selesai: i < 3,
            ),
          ),
        );
      }
      await pumpDetail(tester, db, id);

      expect(find.text('Fisika'), findsOneWidget);
      expect(find.text('3 dari 5 tugas selesai'), findsOneWidget);
      await tutupDb(tester, db);
    });

    testWidgets('toggle ubah hitungan langsung', (tester) async {
      final db = await bukaDb(tester);
      final id = await bacaDb(
        tester,
        () => MataKuliahRepository(db).tambah(const MataKuliah(nama: 'Fisika')),
      );
      await bacaDb(
        tester,
        () => TugasRepository(db).tambah(
          Tugas(
            matkulId: id,
            judul: 'PR 1',
            deadline: DateTime.now().add(const Duration(days: 1)),
          ),
        ),
      );
      await pumpDetail(tester, db, id);
      expect(find.text('0 dari 1 tugas selesai'), findsOneWidget);

      await tester.tap(find.bySemanticsLabel('Selesai PR 1'));
      for (var i = 0; i < 20; i++) {
        await tester.pump();
        await biarDbSelesai(tester);
        if (find.text('1 dari 1 tugas selesai').evaluate().isNotEmpty) break;
      }

      expect(find.text('1 dari 1 tugas selesai'), findsOneWidget);
      await tutupDb(tester, db);
    });

    testWidgets('kosong tampil nol', (tester) async {
      final db = await bukaDb(tester);
      final id = await bacaDb(
        tester,
        () => MataKuliahRepository(db).tambah(const MataKuliah(nama: 'Fisika')),
      );
      await pumpDetail(tester, db, id);

      expect(find.text('0 dari 0 tugas selesai'), findsOneWidget);
      expect(find.textContaining('Tambah tugas pertama'), findsOneWidget);
      await tutupDb(tester, db);
    });
  });
}
