import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remindly_app/database/mata_kuliah_repo.dart';
import 'package:remindly_app/database/tugas_repo.dart';
import 'package:remindly_app/models/mata_kuliah.dart';
import 'package:remindly_app/models/tugas.dart';
import 'package:remindly_app/pages/course_detail_page.dart';
import 'package:remindly_app/pages/home_page.dart';
import 'package:remindly_app/pages/task_form_page.dart';
import 'package:remindly_app/pages/task_list_page.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'test_helpers.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  Future<int> tanamMatkul(Database db, WidgetTester tester) {
    return bacaDb(
      tester,
      () => MataKuliahRepository(db).tambah(const MataKuliah(nama: 'Fisika')),
    );
  }

  Future<void> tanamTugas(
    Database db,
    WidgetTester tester,
    int matkul, {
    bool selesai = false,
  }) {
    return bacaDb(
      tester,
      () => TugasRepository(db).tambah(
        Tugas(
          matkulId: matkul,
          judul: 'PR 1',
          deadline: DateTime.now().add(const Duration(days: 1)),
          selesai: selesai,
        ),
      ),
    );
  }

  Future<void> tunggu(WidgetTester tester, Finder target) async {
    for (var i = 0; i < 20; i++) {
      await tester.pump();
      await biarDbSelesai(tester);
      await tester.pump();
      if (target.evaluate().isNotEmpty) return;
    }
  }

  Future<void> pumpBeranda(WidgetTester tester, Database db) async {
    await tester.pumpWidget(MaterialApp(home: HomePage(db: db)));
    await tunggu(tester, find.text('Tugas terdekat'));
  }

  Future<void> pumpDaftar(WidgetTester tester, Database db) async {
    await tester.pumpWidget(MaterialApp(home: TaskListPage(db: db)));
    await tunggu(tester, find.text('PR 1'));
  }

  group('Navigasi 03b', () {
    testWidgets('baris beranda buka detail dan kembali refresh', (
      tester,
    ) async {
      final db = await bukaDb(tester);
      final matkul = await tanamMatkul(db, tester);
      await tanamTugas(db, tester, matkul);
      await pumpBeranda(tester, db);

      await tester.tap(find.text('PR 1').first);
      await tunggu(tester, find.text('0 dari 1 tugas selesai'));
      expect(find.byType(CourseDetailPage), findsOneWidget);
      expect(find.text('0 dari 1 tugas selesai'), findsOneWidget);

      await tester.tap(find.byTooltip('Back'));
      await tunggu(tester, find.text('PR 1'));
      expect(find.byType(HomePage), findsOneWidget);
      expect(find.text('PR 1'), findsOneWidget);
      await tutupDb(tester, db);
    });

    testWidgets('baris tugas buka form ubah dan simpan refresh', (
      tester,
    ) async {
      final db = await bukaDb(tester);
      final matkul = await tanamMatkul(db, tester);
      await tanamTugas(db, tester, matkul);
      await pumpDaftar(tester, db);

      await tester.tap(find.text('PR 1'));
      await tunggu(tester, find.byType(TaskFormPage));
      expect(find.byType(TaskFormPage), findsOneWidget);

      await tester.enterText(find.byKey(const Key('judul')), 'PR 1 revisi');
      await tester.tap(find.byKey(const Key('simpan')));
      await tester.pump();
      await biarDbSelesai(tester);
      await tester.pumpAndSettle();
      await biarDbSelesai(tester);
      await tester.pump();
      await tester.pump();

      expect(find.byType(TaskListPage), findsOneWidget);
      expect(find.text('PR 1 revisi'), findsOneWidget);
      await tutupDb(tester, db);
    });

    testWidgets('fab beranda buka form dan batal kembali', (tester) async {
      final db = await bukaDb(tester);
      await pumpBeranda(tester, db);

      await tester.tap(find.byTooltip('Tambah tugas'));
      await tunggu(tester, find.byType(TaskFormPage));
      expect(find.byType(TaskFormPage), findsOneWidget);

      await tester.tap(find.byTooltip('Back'));
      await tunggu(
        tester,
        find.text('Belum ada tugas. Tekan tombol + untuk menambah.'),
      );
      expect(find.byType(HomePage), findsOneWidget);
      expect(
        find.text('Belum ada tugas. Tekan tombol + untuk menambah.'),
        findsOneWidget,
      );
      await tutupDb(tester, db);
    });
  });
}
