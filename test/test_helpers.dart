import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:remindly_app/database/app_database.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

int _dbN = 0;

Future<Database> bukaDb(WidgetTester tester) async {
  late Database db;
  final n = _dbN++;
  await tester.runAsync(() async {
    final dir = await Directory.systemTemp.createTemp('remindly_test');
    db = await openDatabase(
      '${dir.path}/t$n.db',
      version: AppDatabase.version,
      onConfigure: AppDatabase.onConfigure,
      onCreate: AppDatabase.onCreate,
      onUpgrade: AppDatabase.onUpgrade,
    );
  });
  return db;
}

Future<void> biarDbSelesai(WidgetTester tester) async {
  await tester.runAsync(() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
  });
  await tester.pump();
}

Future<T> bacaDb<T>(WidgetTester tester, Future<T> Function() kerja) async {
  late T hasil;
  await tester.runAsync(() async {
    hasil = await kerja();
  });
  return hasil;
}

Future<void> tutupDb(WidgetTester tester, Database db) async {
  final path = db.path;
  await tester.runAsync(() async {
    await db.close();
    await File(path).delete();
    await Directory(File(path).parent.path).delete();
  });
}
