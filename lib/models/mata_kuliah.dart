class MataKuliah {
  const new({required this.nama, this.id, this.dosen = '', this.hari = ''})
    : assert(nama.length > 0, 'nama wajib diisi');

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
