# Remindly App

Aplikasi Pengingat Tugas Kuliah. Flutter plus Dart. Mahasiswa mencatat tugas kuliah dan batas waktunya.

Status: fondasi merge, slicing fitur jalan. Lihat `docs/peta-jalan.md`.

## Mulai cepat

Prasyarat sesuai OS masing-masing: Flutter 3.47.0 via FVM, Android SDK
plus emulator, Java 17+, Maestro CLI.

1. `fvm use 3.47.0` lalu samakan PATH ke Flutter itu.
2. `flutter pub get && flutter analyze --fatal-infos --fatal-warnings && flutter test`.
3. Nyala emulator lalu `flutter run`.
4. `maestro test maestro/flows/smoke.yaml`.

## Aturan merge

1. Tolak push langsung ke `main`. Wajib via Pull Request.
2. Wajib 3 checks hijau: Static Analysis, Security, PR Format.
3. Approval boleh dari agen (sesuai keputusan `agents_only`). Manusia tetap boleh review.
4. E2E dan verifikasi formal jalan lokal di device, bukan di CI. CI hanya static analysis, security, dan format PR.
5. Linter target: zero error, zero warning, format wajib pass.
6. PR dengan label UI atau judul bertag UI wajib ada screenshot images di deskripsi PR.

## Struktur doc

1. `docs/srs.md`: scope soal yang dikunci.
2. `docs/peta-jalan.md`: status tiket REM-01 sampai REM-09.
3. `docs/specs/`: kontrak per slice 01 sampai 06.
4. `docs/e2e-local.md`: loop E2E Maestro lokal per slice.
5. `docs/verification.md`: verifikasi formal ringan plus property test.
6. `.github/workflows/`: 3 gerbang CI.
7. `.github/pull_request_template.md`: template PR plus format dan screenshot.

## UI

Material 3 Expressive via paket komunitas `material_3_expressive` 1.2.x. Syarat Flutter `>=3.47.0`, SDK `^3.13.0`. Pin lokal via `.fvmrc`. Tidak ada flag global Expressive di core stabil, pakai `StyleVariant` per komponen.

## E2E

CI tidak jalan emulator. E2E Maestro lokal di device, jadi verifikasi E2E formal. Lihat `docs/e2e-local.md`.

## Verifikasi

Ringan saja: `very_good_analysis`, assert kontrak di repository dan model, 4 contract tests, opsional property test `glados`. Detail di `docs/verification.md`.
