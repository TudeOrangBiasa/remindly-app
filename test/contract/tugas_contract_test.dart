import 'package:flutter_test/flutter_test.dart';
import 'package:remindly_app/models/tugas.dart';

void main() {
  group('Kontrak Tugas', () {
    test('terlambat berarti lewat dan belum selesai', () {
      final t = Tugas(matkulId: 1, judul: 'UT', deadline: DateTime(2026));
      expect(t.isTerlambat(DateTime(2026, 1, 2)), isTrue);
    });

    test('selesai tidak dihitung terlambat', () {
      final t = Tugas(
        matkulId: 1,
        judul: 'UT',
        deadline: DateTime(2026),
        selesai: true,
      );
      expect(t.isTerlambat(DateTime(2026, 1, 2)), isFalse);
    });

    test('H-1 terdeteksi sekali', () {
      final t = Tugas(
        matkulId: 1,
        judul: 'UT',
        deadline: DateTime(2026, 5, 11),
      );
      expect(t.isHampir(DateTime(2026, 5, 10)), isTrue);
      expect(t.isHampir(DateTime(2026, 5, 9)), isFalse);
    });
  });
}
