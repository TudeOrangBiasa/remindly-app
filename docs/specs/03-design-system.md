# Spec 03 Design system M3 Expressive

Acuan SRS 2.6 dan skill lokal `material-design-3-expressive`.

## Keputusan

1. Paket komunitas `material_3_expressive` 1.2.x, bukan Material 3 biasa.
2. Flutter `>=3.47.0` via FVM, token `Springs` untuk motion, shape `RoundedPolygon` seperlunya.
3. Jangan custom elevation bayangan, pakai tonal surface. Jaga kontras AA dan target sentuh 48px.

## Token

1. Light dan dark hand-tuned, jangan dynamic color penuh di v1.
2. Peran semantik: primary, surface, surface-container, on-primary.
3. Tipografi ikut skala bawaan paket, jangan skala 57px penuh.

## Komponen

1. Pill button untuk aksi utama tambah dan simpan.
2. Floating label textfield untuk semua form.
3. Badge oranye H-1 dan merah terlambat, jangan hanya warna, sertakan label teks.
4. Mode gelap wajib bisa toggle dan tidak merusak kontras badge.

## Bukti selesai

1. Screenshot light dan dark untuk Beranda dan Daftar.
2. Audit kontras dan reduced motion dicatat di PR.
