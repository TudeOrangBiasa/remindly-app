# Kontrak E2E Remindly (aktif setelah ada UI)

Sumber soal: CRUD mata_kuliah dan tugas, foreign key tugas ke mata_kuliah, sorting deadline terdekat, filter Semua Belum Selesai Selesai Terlambat, warna oranye H-1 dan merah terlambat, guard hapus, form validator, data persist setelah restart.

## Skenario wajib

1. Mata kuliah: tambah, lihat, ubah, hapus. Nama wajib, unik. Hapus dengan tugas aktif ditolak dengan pesan alasan. Hapus selalu konfirmasi dialog.
2. Tugas: tambah dengan pilih matkul, judul wajib, deadline via showDatePicker tidak boleh lewat, prioritas Rendah Sedang Tinggi, tandai selesai via Checkbox. Ubah dan hapus dengan konfirmasi.
3. Daftar: urut deadline terdekat. Filter 4 mode. H-1 oranye, lewat dan belum selesai merah.
4. Detail matkul: list tugas satu matkul, tampilkan hitungan contoh 3 dari 5 tugas selesai.
5. Beranda: hitungan belum selesai, 3 deadline terdekat, hitungan terlambat.
6. Kosong: pesan jelas contoh Belum ada tugas. Tekan tombol + untuk menambah.
7. Persist: tutup penuh lalu buka lagi data masih ada (sqflite).
8. Analyze: flutter analyze zero error zero warning.

## Brief E2E lokal

Jalan di device lokal via mobile-agent-testers. CI tidak jalan emulator. Persona hemat awal: `anna,malik` Android. Brief default eksplorasi plus skenario 1 sampai 7 di atas. Hasil dan log sensitif jangan commit mentah, ikut pola enkripsi mobile-agent-testers jika repo public.
