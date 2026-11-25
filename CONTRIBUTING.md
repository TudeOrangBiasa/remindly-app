# Contributing Remindly, 3 orang paralel

## Branch

1. `main` terkunci, wajib PR, 0 approval cukup, 3 checks hijau.
2. Nama branch: `REM-xx/deskripsi-singkat`, contoh `REM-02/database-sqflite`.
3. Satu PR satu tiket, jangan campur scope.

## Judul PR

Wajib diawali tag: `[REM-xx]`, `[CHORE]`, `[DOCS]`, atau `chore:`, `docs:`, `feat:`, `fix:`. Check `format` gagal jika tidak patuh.

## PR UI

Wajib gambar di deskripsi jika label UI atau judul menyentuh UI. Template sudah ada di `.github/pull_request_template.md`.

## Checks lokal wajib sebelum push

1. `dart format --set-exit-if-changed .`
2. `flutter analyze --fatal-infos --fatal-warnings`
3. `flutter test` jika ubah kontrak di `docs/kontrak.md` atau `docs/verification.md`.
4. E2E lokal dan verifikasi lokal jika ubah flow, bukti tulis di PR.

## Struktur kode yang akan datang

1. `lib/models/`, `lib/database/`, `lib/pages/`, minimal tiga itu sesuai soal.
2. Tambahan yang disarankan: `lib/widgets/`, `lib/theme/`.
3. Dilarang commit `build/`, `*.apk`, `*.log`, hasil E2E mentah.

## Tiket

Ambil dari GitHub Issues label `spec` atau `foundation`. Tanya dulu di issue jika spec tidak jelas, jangan tebak.
