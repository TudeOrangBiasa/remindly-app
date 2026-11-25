# Spec 06 Beranda dan Detail

Acuan SRS 3.4, 3.5, 3.6. Pemilik: `lib/pages/home_page.dart`,
`lib/pages/course_detail_page.dart`, flow `maestro/flows/home.yaml`.

## Beranda

1. Tiga angka: tugas belum selesai, 3 tugas deadline terdekat, tugas
   terlambat. Angka 0 tampil, bukan disembunyikan.
2. Daftar 3 terdekat urut deadline menaik, tiap baris judul plus tanggal
   plus badge jika H-1 atau terlambat.
3. Kosong: "Belum ada tugas. Tekan tombol + untuk menambah."

## Detail mata kuliah

1. Header nama matkul plus hitungan contoh "3 dari 5 tugas selesai".
2. List hanya tugas matkul itu, urut deadline menaik.
3. Selesai via Checkbox langsung ubah hitungan tanpa reload manual.

## Bukti selesai

1. `flutter analyze` nol issue, `flutter test` hijau.
2. Flow Maestro hitungan beranda benar, hitungan detail benar, empty state.
