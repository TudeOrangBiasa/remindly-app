import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remindly_app/database/mata_kuliah_repo.dart';
import 'package:remindly_app/database/tugas_repo.dart';
import 'package:remindly_app/models/mata_kuliah.dart';
import 'package:remindly_app/models/tugas.dart';
import 'package:remindly_app/pages/task_list_page.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'test_helpers.dart';

Future<void> pumpDaftar(WidgetTester tester, Database db) async {
  await tester.pumpWidget(MaterialApp(home: TaskListPage(db: db)));
  await tester.pump();
  await biarDbSelesai(tester);
  await tester.pumpAndSettle();
}

List<String> judulTerlihat(WidgetTester tester) {
  return tester
      .widgetList<ListTile>(find.byType(ListTile))
      .map((t) => (t.title! as Text).data!)
      .toList();
}

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Daftar tugas REM-05b', () {
    testWidgets('urut deadline menaik', (tester) async {
      final db = await bukaDb(tester);
      final matkul = await bacaDb(
        tester,
        () =>
            MataKuliahRepository(db)
                .tambah(const MataKuliah(nama: 'Matematika')),
      );
      final repo = TugasRepository(db);
      final besok = DateTime.now().add(const Duration(days: 1));
      final lusa = DateTime.now().add(const Duration(days: 20));
      await bacaDb(
        tester,
        () => repo.tambah(
          Tugas(matkulId: matkul, judul: 'Belakang', deadline: lusa),
        ),
      );
      await bacaDb(
        tester,
        () => repo.tambah(
          Tugas(matkulId: matkul, judul: 'Depan', deadline: besok),
        ),
      );
      await pumpDaftar(tester, db);

      expect(judulTerlihat(tester), <String>['Depan', 'Belakang']);
      await tutupDb(tester, db);
    });

    testWidgets('checkbox toggle selesai', (tester) async {
      final db = await bukaDb(tester);
      final matkul = await bacaDb(
        tester,
        () => MataKuliahRepository(db).tambah(const MataKuliah(nama: 'Fisika')),
      );
      final repo = TugasRepository(db);
      final id = await bacaDb(
        tester,
        () => repo.tambah(
          Tugas(
            matkulId: matkul,
            judul: 'PR 1',
            deadline: DateTime.now().add(const Duration(days: 1)),
          ),
        ),
      );
      await pumpDaftar(tester, db);

      final kotak = find.byType(Checkbox).first;
      expect(tester.widget<Checkbox>(kotak).value, isFalse);
      await tester.tap(kotak);
      var centang = false;
      for (var i = 0; i < 20 && !centang; i++) {
        await tester.pump();
        await biarDbSelesai(tester);
        final w = find.byType(Checkbox);
        if (w.evaluate().isNotEmpty) {
          centang = tester.widget<Checkbox>(w.first).value ?? false;
        }
      }
      expect(centang, isTrue);
      expect((await bacaDb(tester, () => repo.perId(id)))?.selesai, isTrue);
      await tutupDb(tester, db);
    });

    testWidgets('kosong tampil pesan', (tester) async {
      final db = await bukaDb(tester);
      await pumpDaftar(tester, db);

      expect(find.textContaining('Belum ada tugas'), findsOneWidget);
      expect(find.byType(Checkbox), findsNothing);
      await tutupDb(tester, db);
    });
  });
}
