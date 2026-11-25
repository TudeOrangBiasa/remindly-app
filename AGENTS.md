# AGENTS.md Remindly, codebase agent-friendly

## Perintah cepat

1. `export PATH="$HOME/fvm/versions/3.47.0/bin:$PATH"`
2. `dart format --set-exit-if-changed .`
3. `flutter analyze --fatal-infos --fatal-warnings`
4. `flutter test`

## Batas slice per fitur

1. Satu PR satu tiket REM-xx, jangan campur database dan UI.
2. Kontrak di `lib/models/` dan `lib/database/` tidak boleh diubah tanpa update `docs/specs/01-database.md` dan test di `test/contract/`.
3. Halaman di `lib/pages/`, komponen di `lib/widgets/`, token di `lib/theme/tokens.dart`. Dilarang hardcode warna, radius, spacing di pages.
4. Form wajib `Form` plus `TextFormField` validator, ikuti SRS 2.5.
5. Badge deadline wajib pakai `StatusBadge` agar oranye H-1 dan merah terlambat konsisten plus label teks.

## File milik siapa

1. REM-02: `lib/database/*`, `lib/models/*`, `test/contract/*`.
2. REM-03: `lib/app.dart`, `lib/pages/*`, NavigationBar.
3. REM-07: `lib/theme/*`, `lib/widgets/*`, `assets/*`.
4. REM-08: `test/contract/*`, `docs/verification.md`.
5. REM-09: `docs/e2e-local.md`, bukti device di PR.

## Sebelum push

1. Format, analyze, test hijau lokal.
2. Judul PR `[REM-xx]` plus checklist, screenshot jika label UI.
3. Jangan commit `build/`, `*.apk`, `*.log`, hasil E2E mentah.
