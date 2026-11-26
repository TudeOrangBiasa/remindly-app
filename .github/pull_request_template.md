## Summary

<Sketsa perubahan: file/diagram + tutup tiket #xx, butuh tiket apa. Satu kalimat per klaim.>

## Checklist format

1. Judul memakai tag `[REM-xx]`, `[CHORE]`, `[DOCS]`, atau `chore:`, `docs:`, `feat:`, `fix:`.
2. Deskripsi menjelaskan apa dan kenapa.
3. Jika label UI atau menyentuh UI, lampirkan screenshot di bawah. PR UI tanpa gambar gagal check PR Format.

## Evidence

- **Before:** <output test gagal / keadaan sebelum>
  **After:** <output test hijau / keadaan sesudah>
- Non-visual: hasil `flutter test`, bukan daftar path file.
- Visual: tabel Before | After, gambar tampil langsung di body, bukan `<details>`.

## Merge Danger

**Door:** one-way atau two-way (hapus yang lain).

**Blast Radius:** satu baris: siapa terdampak + apa yang bisa rusak.

## Screenshots UI (wajib jika ubah UI)

<!-- Tempel gambar di sini. Contoh: ![beranda](url) -->

## Checks lokal yang sudah jalan

1. Static:
2. Security:
3. E2E lokal (jika ubah flow):
4. Verifikasi lokal (jika ubah kontrak):
