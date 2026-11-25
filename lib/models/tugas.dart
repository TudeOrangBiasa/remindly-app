/// Kontrak Tugas, dipakai REM-02 REM-05 REM-08.
/// deadline epoch ms. selesai 0 atau 1 di DB, bool di model.
enum Prioritas { rendah, sedang, tinggi }

extension PrioritasLabel on Prioritas {
  String get label {
    switch (this) {
      case Prioritas.rendah:
        return 'Rendah';
      case Prioritas.sedang:
        return 'Sedang';
      case Prioritas.tinggi:
        return 'Tinggi';
    }
  }
}

class Tugas {
  new({
    required this.matkulId,
    required this.judul,
    required this.deadline,
    this.id,
    this.deskripsi = '',
    this.prioritas = Prioritas.sedang,
    this.selesai = false,
  }) : assert(judul.trim().isNotEmpty, 'judul wajib diisi');

  final int? id;
  final int matkulId;
  final String judul;
  final String deskripsi;
  final DateTime deadline;
  final Prioritas prioritas;
  final bool selesai;

  /// True jika lewat dan belum selesai, dipakai warna merah dan filter.
  bool isTerlambat(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(deadline.year, deadline.month, deadline.day);
    return !selesai && due.isBefore(today);
  }

  /// True jika H-1 dan belum selesai, dipakai warna oranye.
  bool isHampir(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(deadline.year, deadline.month, deadline.day);
    return !selesai && due.difference(today).inDays == 1;
  }
}
