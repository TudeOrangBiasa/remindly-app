class MataKuliah {
  const new({required this.nama, this.id, this.dosen = '', this.hari = ''})
    : assert(nama.length > 0, 'nama wajib diisi');

  factory fromMap(Map<String, Object?> map) {
    return MataKuliah(
      id: map['id'] as int?,
      nama: map['nama']! as String,
      dosen: map['dosen'] as String? ?? '',
      hari: map['hari'] as String? ?? '',
    );
  }

  final int? id;
  final String nama;
  final String dosen;
  final String hari;

  String get namaTrim => nama.trim();

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'id': id,
      'nama': namaTrim,
      'dosen': dosen.trim(),
      'hari': hari.trim(),
    };
  }
}
