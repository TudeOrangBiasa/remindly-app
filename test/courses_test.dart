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

  Future<void> tungguDb(WidgetTester tester) async {
    await tester.pump();
    await biarDbSelesai(tester);
    await tester.pumpAndSettle();
    await biarDbSelesai(tester);
    await tester.pump();
  }

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
    await tungguDb(tester);
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

  Future<Database> bukaDenganMatkul(
    WidgetTester tester,
    List<String> nama,
  ) async {
    final db = await bukaDb(tester);
    final repo = MataKuliahRepository(db);
    for (final n in nama) {
      await bacaDb(tester, () => repo.tambah(MataKuliah(nama: n)));
    }
    await tester.pumpWidget(MaterialApp(home: CoursesPage(db: db)));
    await biarDbSelesai(tester);
    await tester.pump();
    return db;
  }

  Future<List<String>> namaDiDb(WidgetTester tester, Database db) async {
    final d = await bacaDb(tester, () => MataKuliahRepository(db).semua());
    return d.map((m) => m.nama).toList();
  }

  Future<void> isi(WidgetTester tester, String label, String teks) {
    return tester.enterText(find.widgetWithText(TextFormField, label), teks);
  }

  group('CoursesPage ubah', () {
    testWidgets('ubah tersimpan', (tester) async {
      final db = await bukaDenganMatkul(tester, ['Matematika']);

      await tester.tap(find.text('Matematika'));
      await biarDbSelesai(tester);
      await tester.pumpAndSettle();
      expect(find.text('Ubah mata kuliah'), findsOneWidget);
      await isi(tester, 'Nama', 'Kalkulus');
      await isi(tester, 'Dosen', 'Pak Budi');
      await tester.tap(find.text('Simpan'));
      await tungguDb(tester);

      expect(find.text('Kalkulus'), findsOneWidget);
      expect(find.text('Pak Budi'), findsOneWidget);
      expect(await namaDiDb(tester, db), ['Kalkulus']);
      await tutupDb(tester, db);
    });

    testWidgets('ubah nama sendiri bukan duplikat', (tester) async {
      final db = await bukaDenganMatkul(tester, ['Matematika']);

      await tester.tap(find.text('Matematika'));
      await biarDbSelesai(tester);
      await tester.pumpAndSettle();
      await isi(tester, 'Hari', 'Rabu');
      await tester.tap(find.text('Simpan'));
      await tungguDb(tester);

      expect(find.text('Nama sudah ada'), findsNothing);
      expect(find.text('Rabu'), findsOneWidget);
      await tutupDb(tester, db);
    });

    testWidgets('ubah ke nama matkul lain ditolak', (tester) async {
      final db = await bukaDenganMatkul(tester, ['Fisika', 'Matematika']);

      await tester.tap(find.text('Matematika'));
      await biarDbSelesai(tester);
      await tester.pumpAndSettle();
      await isi(tester, 'Nama', 'fisika');
      await tester.tap(find.text('Simpan'));
      await tester.pump();

      expect(find.text('Nama sudah ada'), findsOneWidget);
      expect(await namaDiDb(tester, db), ['Fisika', 'Matematika']);
      await tutupDb(tester, db);
    });
  });

  group('CoursesPage hapus', () {
    testWidgets('hapus kosong minta konfirmasi', (tester) async {
      final db = await bukaDenganMatkul(tester, ['Matematika']);

      await tester.tap(find.byTooltip('Hapus Matematika'));
      await tester.pumpAndSettle();
      expect(find.text('Hapus mata kuliah?'), findsOneWidget);
      await tester.tap(find.text('Batal'));
      await tungguDb(tester);
      expect(await namaDiDb(tester, db), ['Matematika']);

      await tester.tap(find.byTooltip('Hapus Matematika'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Hapus'));
      await tungguDb(tester);

      expect(find.text('Matematika'), findsNothing);
      expect(find.textContaining('Belum ada mata kuliah'), findsOneWidget);
      expect(await namaDiDb(tester, db), isEmpty);
      await tutupDb(tester, db);
    });

    testWidgets('hapus bertugas ditolak dengan alasan', (tester) async {
      final db = await bukaDenganMatkul(tester, ['Matematika']);
      await bacaDb(tester, () async {
        final id = (await MataKuliahRepository(db).semua()).single.id!;
        for (final j in ['PR 1', 'PR 2']) {
          await TugasRepository(db).tambah(
            Tugas(
              matkulId: id,
              judul: j,
              deadline: DateTime.now().add(const Duration(days: 3)),
            ),
          );
        }
      });

      await tester.tap(find.byTooltip('Hapus Matematika'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Hapus'));
      await tungguDb(tester);

      expect(
        find.text('Tidak bisa dihapus, masih ada 2 tugas di Matematika.'),
        findsOneWidget,
      );
      expect(await namaDiDb(tester, db), ['Matematika']);
      await tutupDb(tester, db);
    });
  });
}
