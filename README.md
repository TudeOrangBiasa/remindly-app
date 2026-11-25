# Remindly App

Aplikasi Pengingat Tugas Kuliah. Flutter plus Dart. Mahasiswa mencatat tugas kuliah dan batas waktunya.

Status: repo setup, no-code. Kode aplikasi belum ada. Scaffold ini hanya menyiapkan gerbang merge agar 3 kontributor bisa jalan paralel.

## Aturan merge

1. Tolak push langsung ke `main`. Wajib via Pull Request.
2. Wajib 3 checks hijau: Static Analysis, Security, PR Format.
3. Approval boleh dari agen (sesuai keputusan `agents_only`). Manusia tetap boleh review.
4. E2E dan verifikasi formal jalan lokal di device, bukan di CI. CI hanya static analysis, security, dan format PR.
5. Linter target: zero error, zero warning, format wajib pass.
6. PR dengan label UI atau judul bertag UI wajib ada screenshot images di deskripsi PR.

## Struktur doc

1. `docs/kontrak.md`: kontrak skenario E2E yang akan diaktifkan setelah ada UI.
2. `docs/e2e-local.md`: cara jalan E2E lokal di device via Maestro.
3. `docs/verification.md`: definisi verification ringan dan cara jalan lokal.
4. `.github/workflows/`: 3 gerbang CI.
5. `.github/pull_request_template.md`: template PR yang menegakkan format dan screenshot.

## UI

Material 3 Expressive via paket komunitas `material_3_expressive` 1.2.x. Syarat Flutter `>=3.47.0`, SDK `^3.13.0`. Pin lokal via `.fvmrc`. Tidak ada flag global Expressive di core stabil, pakai `StyleVariant` per komponen.

## E2E

CI tidak jalan emulator. E2E Maestro lokal di device, jadi verifikasi E2E formal. Lihat `docs/e2e-local.md`.

## Verifikasi

Ringan saja: `very_good_analysis`, assert kontrak di repository dan model, 4 contract tests, opsional property test `glados`. Detail di `docs/verification.md`.
