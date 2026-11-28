import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remindly_app/app.dart';
import 'package:remindly_app/theme/branding.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('toggle gelap ganti brightness tiap halaman', (tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(const RemindlyApp());
    });
    await tester.pump();

    BuildContext konteks(String teks) => tester.element(find.text(teks).first);

    expect(Theme.of(konteks('Beranda')).brightness, Brightness.light);
    expect(
      Theme.of(konteks('Beranda')).colorScheme.onSurface,
      AppBranding.lightOnSurface,
    );

    await tester.tap(find.byIcon(Icons.dark_mode_outlined));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(Theme.of(konteks('Beranda')).brightness, Brightness.dark);
    expect(
      Theme.of(konteks('Beranda')).colorScheme.onSurface,
      AppBranding.darkOnSurface,
    );
    expect(
      Theme.of(konteks('Beranda')).colorScheme.primary,
      AppBranding.darkPrimary,
    );

    await tester.tap(find.byIcon(Icons.list_outlined));
    await tester.pump();
    expect(Theme.of(konteks('Tugas')).brightness, Brightness.dark);

    await tester.tap(find.byIcon(Icons.book_outlined));
    await tester.pump();
    expect(Theme.of(konteks('Mata Kuliah')).brightness, Brightness.dark);

    await tester.tap(find.byIcon(Icons.light_mode_outlined));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(Theme.of(konteks('Mata Kuliah')).brightness, Brightness.light);
    expect(
      Theme.of(konteks('Mata Kuliah')).colorScheme.onSurface,
      AppBranding.lightOnSurface,
    );
  });
}
