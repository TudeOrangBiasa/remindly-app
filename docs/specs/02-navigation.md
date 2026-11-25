# Spec 02 Navigasi 5 halaman

Acuan SRS 2.2 dan 3.3 sampai 3.5.

## Halaman

1. Beranda: hitungan belum selesai, 3 deadline terdekat, hitungan terlambat.
2. Daftar: sorting deadline menaik, filter Semua Belum Selesai Selesai Terlambat, warna oranye H-1 dan merah terlambat belum selesai.
3. Tambah atau Ubah: Form plus TextFormField validator, showDatePicker, dropdown prioritas, dropdown matkul.
4. Detail Matkul: list tugas satu matkul plus hitungan contoh 3 dari 5 selesai.
5. Matkul: CRUD matkul.

## Navigasi

1. Root memakai NavigationBar minimal 3 destinasi: Beranda, Daftar, Matkul.
2. Detail dan form dibuka via push, kembali bawa hasil refresh.
3. Empty state jelas di tiap list kosong.

## Bukti selesai

1. Navigasi manual 5 halaman tanpa error.
2. `flutter analyze` nol warning.
3. Screenshot tiap halaman dilampirkan di PR UI.
