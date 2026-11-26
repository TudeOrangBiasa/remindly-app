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

  factory fromMap(Map<String, Object?> map) {
    return Tugas(
      id: map['id'] as int?,
      matkulId: map['matkul_id']! as int,
      judul: map['judul']! as String,
      deskripsi: map['deskripsi'] as String? ?? '',
      deadline: DateTime.fromMillisecondsSinceEpoch(map['deadline']! as int),
      prioritas: Prioritas.values.firstWhere(
        (e) => e.label == map['prioritas'],
      ),
      selesai: (map['selesai']! as int) == 1,
    );
  }

  final int? id;
  final int matkulId;
  final String judul;
  final String deskripsi;
  final DateTime deadline;
  final Prioritas prioritas;
  final bool selesai;

  bool isTerlambat(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(deadline.year, deadline.month, deadline.day);
    return !selesai && due.isBefore(today);
  }

  bool isHampir(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(deadline.year, deadline.month, deadline.day);
    return !selesai && due.difference(today).inDays == 1;
  }
}
