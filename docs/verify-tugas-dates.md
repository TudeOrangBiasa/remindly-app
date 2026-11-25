---
name: verify-tugas-dates
description: Verifikasi logika tanggal deadline Tugas. Pakai saat ubah lib/models/tugas.dart.
---

Target: `isTerlambat` dan `isHampir` di `lib/models/tugas.dart`. Salah hitung membuat badge dan filter salah pada batas hari.

Sifat yang dibuktikan:

1. `selesai` menonaktifkan kedua status, untuk semua input.
2. Keduanya tidak pernah aktif bersamaan.
3. Putusan hanya ikut tanggal kalender, bebas jam.
4. Batas bulan, batas tahun, kabisat, tengah malam tepat.

Perintah: `flutter test test/contract/tugas_dates_property_test.dart`

Batas: 300 input acak seed 42 per sifat, hari 2020 sampai 2028. Di luar itu tidak terbukti.

Cakupan: `lib/models/tugas.dart` saja.
Sync commit: e34b30b. Pindah sync hanya setelah run ulang pada commit baru. Pernah gagal pada varian guard `selesai` dilepas.
