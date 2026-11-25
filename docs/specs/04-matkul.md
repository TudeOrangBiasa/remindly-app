# Spec 04 Mata Kuliah CRUD

Acuan SRS 3.1 dan 3.6. Pemilik: `lib/pages/courses_page.dart`,
`lib/models/mata_kuliah.dart`, flow `maestro/flows/courses.yaml`.

## Aturan

1. Nama trim non kosong. Duplikat case-insensitive ditolak dengan pesan.
2. Dosen dan hari opsional, trim.
3. Tambah dan ubah pakai `Form` plus `TextFormField` validator.
4. Hapus selalu dialog konfirmasi.
5. Hapus matkul yang masih punya tugas ditolak. Pesan menyebut jumlah
   tugas yang menahan. Guard ini di database (FK RESTRICT), UI hanya
   menampilkan alasan.
6. List kosong: "Belum ada mata kuliah. Tekan tombol + untuk menambah."

## Bukti selesai

1. `flutter analyze` nol issue, `flutter test` hijau.
2. Flow Maestro tambah, duplikat ditolak, hapus diblokir, hapus kosong.
