import 'package:glados/glados.dart';

import 'package:remindly_app/models/tugas.dart';

DateTime _date(int days) {
  return DateTime.utc(2020).add(Duration(days: days));
}

Tugas _tugas(DateTime deadline, bool selesai) {
  return Tugas(matkulId: 1, judul: 't', deadline: deadline, selesai: selesai);
}

void main() {
  Glados3(
    any.intInRange(0, 3000),
    any.intInRange(0, 3000),
    any.bool,
    ExploreConfig(numRuns: 300),
  ).test('selesai menonaktifkan status', (dueIn, nowIn, selesai) {
    final t = _tugas(_date(dueIn), selesai);
    final now = _date(nowIn);
    if (selesai) {
      expect(t.isTerlambat(now), isFalse);
      expect(t.isHampir(now), isFalse);
    }
    expect(t.isTerlambat(now) && t.isHampir(now), isFalse);
  });

  Glados2(
    any.intInRange(0, 3000),
    any.intInRange(0, 3000),
    ExploreConfig(numRuns: 300),
  ).test('putusan hanya ikut tanggal kalender', (dueIn, nowIn) {
    final due = _date(dueIn);
    final now = _date(nowIn);
    final lateDue = DateTime(due.year, due.month, due.day, 23, 59);
    final earlyNow = DateTime(now.year, now.month, now.day, 0, 1);
    expect(
      _tugas(lateDue, false).isTerlambat(earlyNow),
      _tugas(due, false).isTerlambat(now),
    );
    expect(
      _tugas(lateDue, false).isHampir(earlyNow),
      _tugas(due, false).isHampir(now),
    );
  });

  test('batas bulan', () {
    final t = _tugas(DateTime(2026, 2), false);
    expect(t.isHampir(DateTime(2026, 1, 31)), isTrue);
    expect(t.isTerlambat(DateTime(2026, 1, 31)), isFalse);
  });

  test('batas tahun', () {
    final t = _tugas(DateTime(2027), false);
    expect(t.isHampir(DateTime(2026, 12, 31)), isTrue);
    expect(t.isTerlambat(DateTime(2026, 12, 31)), isFalse);
  });

  test('kabisat', () {
    final t = _tugas(DateTime(2024, 3), false);
    expect(t.isHampir(DateTime(2024, 2, 29)), isTrue);
    expect(t.isTerlambat(DateTime(2024, 2, 29)), isFalse);
  });

  test('tengah malam tepat', () {
    final t = _tugas(DateTime(2026, 5, 11), false);
    expect(t.isTerlambat(DateTime(2026, 5, 11)), isFalse);
    expect(t.isHampir(DateTime(2026, 5, 10, 23, 59, 59)), isTrue);
    expect(t.isTerlambat(DateTime(2026, 5, 12)), isTrue);
  });
}
