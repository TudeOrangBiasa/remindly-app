# Spec 01 Database sqflite

Acuan SRS 2.3 dan 4.3. Fondasi paling berisiko, kerjakan pertama.

## Skema

1. `mata_kuliah(id INTEGER PK, nama TEXT UNIQUE NOT NULL, dosen TEXT, hari TEXT)`.
2. `tugas(id INTEGER PK, matkul_id INTEGER NOT NULL FK ke mata_kuliah ON DELETE RESTRICT, judul TEXT NOT NULL, deskripsi TEXT, deadline INTEGER NOT NULL epoch ms, prioritas TEXT CHECK Rendah Sedang Tinggi, selesai INTEGER 0 atau 1)`.
3. Index `tugas(deadline)` dan `tugas(matkul_id, deadline)`.

## Aturan

1. Nama matkul trim, non kosong, unik case-insensitive.
2. Judul trim non kosong.
3. Deadline tidak boleh lewat saat create dan update, bandingkan tanggal kalender bukan jam.
4. Hapus matkul dengan tugas aktif ditolak dengan pesan alasan, jangan cascade.
5. Hapus tugas dan matkul kosong wajib konfirmasi di UI, di layer DB sediakan delete eksplisit.
6. Query per matkul untuk halaman detail: `daftarPerMatkul(matkulId)` urut deadline menaik, pakai index `tugas(matkul_id, deadline)`.

## Migrasi

1. `onCreate` v1 buat 2 tabel plus index.
2. `onConfigure` aktifkan `PRAGMA foreign_keys = ON`.
3. Tulis migrasi v2 dummy di test agar pola terbukti.

## Bukti selesai

1. `flutter test test/database_test.dart` hijau, cover insert, unik, FK guard, sorting deadline.
2. Tutup buka ulang persist terbukti di E2E lokal.
