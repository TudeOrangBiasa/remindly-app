import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remindly_app/database/mata_kuliah_repo.dart';
import 'package:remindly_app/database/tugas_repo.dart';
import 'package:remindly_app/models/mata_kuliah.dart';
import 'package:remindly_app/models/tugas.dart';
import 'package:remindly_app/pages/task_form_page.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'test_helpers.dart';

Future<void> pumpForm(WidgetTester tester, Database db, {Tugas? awal}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: TaskFormPage(db: db, awal: awal),
    ),
  );
  await tester.pump();
  await biarDbSelesai(tester);
}

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Form tugas REM-05a', () {
    testWidgets('simpan tugas valid', (tester) async {
      final db = await bukaDb(tester);
      await bacaDb(
        tester,
        () =>
            MataKuliahRepository(db)
                .tambah(const MataKuliah(nama: 'Matematika')),
      );
      await pumpForm(tester, db);

      await tester.tap(find.byKey(const Key('matkul')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Matematika').last);
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('judul')), 'PR 1');
      await tester.tap(find.byKey(const Key('deadline')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('simpan')));
      await tester.pump();
      await biarDbSelesai(tester);
      await tester.pumpAndSettle();

      final daftar = await bacaDb(
        tester,
        () => TugasRepository(db).daftar(FilterTugas.semua),
      );
      expect(daftar, hasLength(1));
      expect(daftar.single.judul, 'PR 1');
      expect(find.byKey(const Key('simpan')), findsNothing);
      await tutupDb(tester, db);
    });

    testWidgets('judul kosong ditolak', (tester) async {
      final db = await bukaDb(tester);
      await bacaDb(
        tester,
        () => MataKuliahRepository(db).tambah(const MataKuliah(nama: 'Fisika')),
      );
      await pumpForm(tester, db);

      await tester.tap(find.byKey(const Key('simpan')));
      await tester.pumpAndSettle();

      expect(find.text('Judul wajib diisi.'), findsOneWidget);
      expect(find.text('Pilih mata kuliah.'), findsOneWidget);
      expect(find.text('Pilih batas waktu.'), findsOneWidget);
      final daftar = await bacaDb(
        tester,
        () => TugasRepository(db).daftar(FilterTugas.semua),
      );
      expect(daftar, isEmpty);
      await tutupDb(tester, db);
    });

    testWidgets('tanpa matkul tampil pesan', (tester) async {
      final db = await bukaDb(tester);
      await pumpForm(tester, db);

      expect(find.textContaining('Belum ada mata kuliah'), findsOneWidget);
      expect(find.byKey(const Key('simpan')), findsNothing);
      await tutupDb(tester, db);
    });

    testWidgets('ubah prefill dan simpan', (tester) async {
      final db = await bukaDb(tester);
      final matkul = await bacaDb(
        tester,
        () => MataKuliahRepository(db).tambah(const MataKuliah(nama: 'Kimia')),
      );
      final tugasRepo = TugasRepository(db);
      final besok = DateTime.now().add(const Duration(days: 1));
      final id = await bacaDb(
        tester,
        () => tugasRepo.tambah(
          Tugas(matkulId: matkul, judul: 'PR lama', deadline: besok),
        ),
      );
      final awal = await bacaDb(tester, () => tugasRepo.perId(id));

      await pumpForm(tester, db, awal: awal);
      expect(find.text('PR lama'), findsOneWidget);

      await tester.enterText(find.byKey(const Key('judul')), 'PR baru');
      await tester.tap(find.byKey(const Key('simpan')));
      await tester.pump();
      await biarDbSelesai(tester);
      await tester.pumpAndSettle();

      expect(
        (await bacaDb(tester, () => tugasRepo.perId(id)))?.judul,
        'PR baru',
      );
      await tutupDb(tester, db);
    });
  });
}
