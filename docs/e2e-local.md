# E2E Lokal dengan Maestro

E2E tidak jalan di CI. Setiap slice fitur diverifikasi lokal dengan
Maestro di emulator atau HP. Maestro jadi verifikasi E2E formal:
flow lolos berarti fitur terbukti di layar.

## Pasang sekali

`curl -Ls https://get.maestro.mobile.dev | bash`, lalu emulator atau
HP tersambung via `adb devices`.

## Loop per slice

1. Implementasi slice di branch `REM-xx`.
2. `flutter run` atau install APK debug.
3. Jalan flow yang relevan: `maestro test maestro/flows/smoke.yaml`.
4. Slice baru wajib tambah flow di `maestro/flows/` ikut pola smoke.
5. Flow merah berarti slice belum boleh merge, tanpa kecuali.

## Flow yang ada

1. `smoke.yaml`: buka app, 3 destinasi navigasi tampil, empty state benar.

## Jebakan yang sudah terbukti

1. Flutter mematikan semantics tree. `main.dart` menyalakan via
   `ensureSemantics` khusus debug. Jangan hapus.
2. Matcher Maestro exact. Desc tab ada suffix `Tab x of 3`, jadi tap
   pakai wildcard contoh `Tugas.*`.
3. Frame pertama debug lambat. Flow mulai dengan `extendedWaitUntil`
   60 detik, bukan `assertVisible` langsung.

## Aturan bukti PR

1. PR yang ubah flow wajib isi bagian E2E lokal di template plus hasil
   `maestro test`.
2. PR UI wajib gambar. Tanpa gambar, check PR Format gagal.
3. Jangan commit APK, log mentah, atau video ke repo app.
