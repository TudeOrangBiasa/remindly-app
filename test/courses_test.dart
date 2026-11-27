import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remindly_app/database/mata_kuliah_repo.dart';
import 'package:remindly_app/database/tugas_repo.dart';
import 'package:remindly_app/models/mata_kuliah.dart';
import 'package:remindly_app/models/tugas.dart';
import 'package:remindly_app/pages/courses_page.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'test_helpers.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  Future<void> tambahLewatForm(
    WidgetTester tester, {
    required String nama,
    String dosen = '',
    String hari = '',
  }) async {
    await tester.tap(find.byTooltip('Tambah mata kuliah'));
    await biarDbSelesai(tester);
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, 'Nama'), nama);
    if (dosen.isNotEmpty) {
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Dosen'),
        dosen,
      );
    }
    if (hari.isNotEmpty) {
      await tester.enterText(find.widgetWithText(TextFormField, 'Hari'), hari);
    }
    await tester.tap(find.text('Simpan'));
    await tester.pump();
    await biarDbSelesai(tester);
    await tester.pumpAndSettle();
    await biarDbSelesai(tester);
    await tester.pump();
    await tester.pump();
  }

  group('CoursesPage tambah', () {
    testWidgets('tambah tampil di list', (tester) async {
      final db = await bukaDb(tester);
      await tester.pumpWidget(MaterialApp(home: CoursesPage(db: db)));
      await biarDbSelesai(tester);
      await tester.pump();

      expect(find.textContaining('Belum ada mata kuliah'), findsOneWidget);
      await tambahLewatForm(
        tester,
        nama: 'Matematika',
        dosen: 'Bu Ani',
        hari: 'Senin',
      );

      expect(find.text('Matematika'), findsOneWidget);
      expect(find.text('Bu Ani · Senin'), findsOneWidget);
      final jumlah = await bacaDb(
        tester,
        () => MataKuliahRepository(db).semua().then((d) => d.length),
      );
      expect(jumlah, 1);
      await tutupDb(tester, db);
    });

    testWidgets('nama kosong ditolak', (tester) async {
      final db = await bukaDb(tester);
      await tester.pumpWidget(MaterialApp(home: CoursesPage(db: db)));
      await biarDbSelesai(tester);
      await tester.pump();

      await tester.tap(find.byTooltip('Tambah mata kuliah'));
      await biarDbSelesai(tester);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Simpan'));
      await tester.pump();

      expect(find.text('Nama wajib diisi'), findsOneWidget);
      final jumlah = await bacaDb(
        tester,
        () => MataKuliahRepository(db).semua().then((d) => d.length),
      );
      expect(jumlah, 0);
      await tutupDb(tester, db);
    });

    testWidgets('nama duplikat ditolak tanpa peduli kapital', (tester) async {
      final db = await bukaDb(tester);
      await bacaDb(
        tester,
        () =>
            MataKuliahRepository(db)
                .tambah(const MataKuliah(nama: 'Matematika')),
      );
      await tester.pumpWidget(MaterialApp(home: CoursesPage(db: db)));
      await biarDbSelesai(tester);
      await tester.pump();

      await tambahLewatForm(tester, nama: 'matematika');

      expect(find.text('Nama sudah ada'), findsOneWidget);
      final jumlah = await bacaDb(
        tester,
        () => MataKuliahRepository(db).semua().then((d) => d.length),
      );
      expect(jumlah, 1);
      await tutupDb(tester, db);
    });
  });

  group('CoursesPage ubah hapus', () {
    Future<void> pumpAda(WidgetTester tester, Database db) async {
      await tester.pumpWidget(MaterialApp(home: CoursesPage(db: db)));
      await biarDbSelesai(tester);
      await tester.pump();
      await tester.pump();
    }

    testWidgets('ubah tersimpan', (tester) async {
      final db = await bukaDb(tester);
      await bacaDb(
        tester,
        () =>
            MataKuliahRepository(db)
                .tambah(const MataKuliah(nama: 'Fisika', dosen: 'Bu Ani')),
      );
      await pumpAda(tester, db);

      await tester.tap(find.text('Fisika'));
      await biarDbSelesai(tester);
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nama'),
        'Fisika Dasar',
      );
      await tester.tap(find.text('Simpan'));
      await tester.pump();
      await biarDbSelesai(tester);
      await tester.pumpAndSettle();
      await biarDbSelesai(tester);
      await tester.pump();
      await tester.pump();

      expect(find.text('Fisika Dasar'), findsOneWidget);
      final semua = await bacaDb(
        tester,
        () => MataKuliahRepository(db).semua(),
      );
      expect(semua.single.nama, 'Fisika Dasar');
      expect(semua.single.dosen, 'Bu Ani');
      await tutupDb(tester, db);
    });

    testWidgets('hapus kosong minta konfirmasi', (tester) async {
      final db = await bukaDb(tester);
      final id = await bacaDb(
        tester,
        () => MataKuliahRepository(db).tambah(const MataKuliah(nama: 'Kimia')),
      );
      await pumpAda(tester, db);

      await tester.tap(find.byTooltip('Hapus Kimia'));
      await tester.pumpAndSettle();
      expect(find.text('Hapus Kimia?'), findsOneWidget);
      await tester.tap(find.text('Hapus'));
      await tester.pump();
      await biarDbSelesai(tester);
      await tester.pumpAndSettle();
      await biarDbSelesai(tester);
      await tester.pump();
      await tester.pump();

      expect(find.text('Kimia'), findsNothing);
      expect(
        await bacaDb(tester, () => MataKuliahRepository(db).perId(id)),
        isNull,
      );
      await tutupDb(tester, db);
    });

    testWidgets('hapus bertugas ditolak dengan jumlah', (tester) async {
      final db = await bukaDb(tester);
      final id = await bacaDb(
        tester,
        () =>
            MataKuliahRepository(db).tambah(const MataKuliah(nama: 'Biologi')),
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
      await pumpAda(tester, db);

      await tester.tap(find.byTooltip('Hapus Biologi'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Hapus'));
      await tester.pump();
      await biarDbSelesai(tester);
      await tester.pumpAndSettle();

      expect(
        find.text('Tidak bisa hapus: masih ada 1 tugas di Biologi'),
        findsOneWidget,
      );
      expect(find.text('Biologi'), findsOneWidget);
      expect(
        await bacaDb(tester, () => MataKuliahRepository(db).perId(id)),
        isNotNull,
      );
      await tutupDb(tester, db);
    });
  });
}
