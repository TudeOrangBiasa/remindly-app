import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remindly_app/app.dart';
import 'package:remindly_app/pages/courses_page.dart';
import 'package:remindly_app/pages/home_page.dart';
import 'package:remindly_app/pages/task_list_page.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  Future<void> pompaSampai(WidgetTester tester, Finder target) async {
    for (var i = 0; i < 20; i++) {
      await tester.pump();
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 200));
      });
      await tester.pump();
      if (target.evaluate().isNotEmpty) return;
    }
  }

  testWidgets('RemindlyApp tiga destinasi bergantian', (tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(const RemindlyApp());
    });
    await pompaSampai(
      tester,
      find.text('Belum ada tugas. Tekan tombol + untuk menambah.'),
    );

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text('Beranda'), findsWidgets);
    expect(find.bySemanticsIdentifier('halaman-beranda'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.list_outlined));
    await pompaSampai(
      tester,
      find.text('Belum ada tugas. Tekan tombol + untuk menambah.'),
    );

    expect(find.byType(TaskListPage), findsOneWidget);
    expect(find.byType(HomePage), findsNothing);
    expect(find.text('Tugas'), findsWidgets);
    expect(
      find.text('Belum ada tugas. Tekan tombol + untuk menambah.'),
      findsOneWidget,
    );
    expect(find.bySemanticsIdentifier('halaman-tugas'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.book_outlined));
    await tester.pumpAndSettle();

    expect(find.byType(CoursesPage), findsOneWidget);
    expect(find.text('Mata Kuliah'), findsOneWidget);
    expect(find.bySemanticsIdentifier('halaman-matkul'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.home_outlined));
    await pompaSampai(
      tester,
      find.text('Belum ada tugas. Tekan tombol + untuk menambah.'),
    );

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(CoursesPage), findsNothing);
    expect(find.bySemanticsIdentifier('halaman-beranda'), findsOneWidget);
  });
}
