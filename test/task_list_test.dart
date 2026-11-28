import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remindly_app/database/mata_kuliah_repo.dart';
import 'package:remindly_app/database/tugas_repo.dart';
import 'package:remindly_app/models/mata_kuliah.dart';
import 'package:remindly_app/models/tugas.dart';
import 'package:remindly_app/pages/task_list_page.dart';
import 'package:remindly_app/theme/branding.dart';
import 'package:remindly_app/widgets/status_badge.dart';
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

  group('Filter tugas REM-05c', () {
    Future<void> tanamCampuran(WidgetTester tester, Database db) async {
      final matkul = await bacaDb(
        tester,
        () => MataKuliahRepository(db).tambah(const MataKuliah(nama: 'Kimia')),
      );
      final repo = TugasRepository(db);
      final kini = DateTime.now();
      final lampau = kini.subtract(const Duration(days: 10));
      await bacaDb(
        tester,
        () => repo.tambah(
          Tugas(
            matkulId: matkul,
            judul: 'Lewat',
            deadline: kini.subtract(const Duration(days: 3)),
          ),
          sekarang: lampau,
        ),
      );
      await bacaDb(
        tester,
        () => repo.tambah(
          Tugas(
            matkulId: matkul,
            judul: 'Lewat selesai',
            deadline: kini.subtract(const Duration(days: 2)),
            selesai: true,
          ),
          sekarang: lampau,
        ),
      );
      await bacaDb(
        tester,
        () => repo.tambah(
          Tugas(
            matkulId: matkul,
            judul: 'Aktif',
            deadline: kini.add(const Duration(days: 5)),
          ),
        ),
      );
      await bacaDb(
        tester,
        () => repo.tambah(
          Tugas(
            matkulId: matkul,
            judul: 'Beres',
            deadline: kini.add(const Duration(days: 6)),
            selesai: true,
          ),
        ),
      );
    }

    Future<void> pilih(WidgetTester tester, FilterTugas filter) async {
      await tester.tap(find.byKey(Key('filter-${filter.name}')));
      await tester.pump();
      await biarDbSelesai(tester);
      await tester.pumpAndSettle();
    }

    testWidgets('tiap filter tampilkan himpunan benar', (tester) async {
      final db = await bukaDb(tester);
      await tanamCampuran(tester, db);
      await pumpDaftar(tester, db);

      expect(find.byType(ChoiceChip), findsNWidgets(4));
      expect(judulTerlihat(tester), <String>[
        'Lewat',
        'Lewat selesai',
        'Aktif',
        'Beres',
      ]);

      await pilih(tester, FilterTugas.belumSelesai);
      expect(judulTerlihat(tester), <String>['Lewat', 'Aktif']);

      await pilih(tester, FilterTugas.selesai);
      expect(judulTerlihat(tester), <String>['Lewat selesai', 'Beres']);

      await pilih(tester, FilterTugas.terlambat);
      expect(judulTerlihat(tester), <String>['Lewat']);

      await pilih(tester, FilterTugas.semua);
      expect(judulTerlihat(tester), hasLength(4));
      await tutupDb(tester, db);
    });

    testWidgets('filter kosong tampil pesan filter', (tester) async {
      final db = await bukaDb(tester);
      final matkul = await bacaDb(
        tester,
        () => MataKuliahRepository(db).tambah(const MataKuliah(nama: 'Sains')),
      );
      await bacaDb(
        tester,
        () => TugasRepository(db).tambah(
          Tugas(
            matkulId: matkul,
            judul: 'Aktif',
            deadline: DateTime.now().add(const Duration(days: 2)),
          ),
        ),
      );
      await pumpDaftar(tester, db);

      await pilih(tester, FilterTugas.terlambat);
      expect(find.text('Tidak ada tugas untuk filter ini.'), findsOneWidget);
      expect(find.byType(ListTile), findsNothing);
      await tutupDb(tester, db);
    });
  });

  group('Badge tugas REM-05d', () {
    testWidgets('H-1 oranye, lewat merah, selesai tanpa badge', (tester) async {
      final db = await bukaDb(tester);
      final matkul = await bacaDb(
        tester,
        () => MataKuliahRepository(db).tambah(const MataKuliah(nama: 'Kimia')),
      );
      final repo = TugasRepository(db);
      final kini = DateTime.now();
      final lampau = kini.subtract(const Duration(days: 10));
      Future<int> tanam(
        String judul,
        DateTime deadline, {
        bool selesai = false,
      }) {
        return bacaDb(
          tester,
          () => repo.tambah(
            Tugas(
              matkulId: matkul,
              judul: judul,
              deadline: deadline,
              selesai: selesai,
            ),
            sekarang: lampau,
          ),
        );
      }

      final lewat = await tanam(
        'Lewat',
        kini.subtract(const Duration(days: 3)),
      );
      final lewatSelesai = await tanam(
        'Lewat selesai',
        kini.subtract(const Duration(days: 2)),
        selesai: true,
      );
      final besok = await tanam('Besok', kini.add(const Duration(days: 1)));
      final besokSelesai = await tanam(
        'Besok selesai',
        kini.add(const Duration(days: 1)),
        selesai: true,
      );
      final jauh = await tanam('Jauh', kini.add(const Duration(days: 7)));
      await pumpDaftar(tester, db);

      Finder badgeDi(int id) => find.descendant(
        of: find.byKey(Key('tugas-$id')),
        matching: find.byType(StatusBadge),
      );

      expect(
        find.descendant(of: badgeDi(lewat), matching: find.text('Terlambat')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: badgeDi(besok), matching: find.text('H-1')),
        findsOneWidget,
      );
      Color? warna(int id) {
        final kotak = tester.widget<Container>(
          find.descendant(of: badgeDi(id), matching: find.byType(Container)),
        );
        return (kotak.decoration! as BoxDecoration).color;
      }

      expect(warna(lewat), AppBranding.dangerRed);
      expect(warna(besok), AppBranding.warnOrange);
      expect(badgeDi(lewatSelesai), findsNothing);
      expect(badgeDi(besokSelesai), findsNothing);
      expect(badgeDi(jauh), findsNothing);
      await tutupDb(tester, db);
    });
  });

  group('Hapus tugas #65', () {
    Future<Database> tanamSatu(WidgetTester tester) async {
      final db = await bukaDb(tester);
      final matkul = await bacaDb(
        tester,
        () => MataKuliahRepository(db).tambah(const MataKuliah(nama: 'Mat')),
      );
      await bacaDb(
        tester,
        () => TugasRepository(db).tambah(
          Tugas(
            matkulId: matkul,
            judul: 'PR 1',
            deadline: DateTime.now().add(const Duration(days: 1)),
          ),
        ),
      );
      return db;
    }

    testWidgets('tiap baris ada tombol hapus', (tester) async {
      final db = await tanamSatu(tester);
      await pumpDaftar(tester, db);

      expect(find.byTooltip('Hapus PR 1'), findsOneWidget);
      await tutupDb(tester, db);
    });

    testWidgets('batal pertahankan baris', (tester) async {
      final db = await tanamSatu(tester);
      await pumpDaftar(tester, db);

      await tester.tap(find.byTooltip('Hapus PR 1'));
      await tester.pumpAndSettle();
      expect(find.text('Hapus PR 1?'), findsOneWidget);
      await tester.tap(find.text('Batal'));
      await tester.pumpAndSettle();
      expect(judulTerlihat(tester), <String>['PR 1']);
      await tutupDb(tester, db);
    });

    testWidgets('hapus terkonfirmasi hilangkan baris', (tester) async {
      final db = await tanamSatu(tester);
      await pumpDaftar(tester, db);

      await tester.tap(find.byTooltip('Hapus PR 1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Hapus').last);
      var hilang = false;
      for (var i = 0; i < 25 && !hilang; i++) {
        await tester.pump();
        await biarDbSelesai(tester);
        hilang = find.text('PR 1').evaluate().isEmpty;
      }
      expect(hilang, isTrue);
      expect(find.textContaining('Belum ada tugas'), findsOneWidget);
      await tutupDb(tester, db);
    });
  });
}
