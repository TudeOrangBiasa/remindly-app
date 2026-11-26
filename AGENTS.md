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
3. REM-04: `lib/pages/courses_page.dart`, `lib/models/mata_kuliah.dart`, flow courses.
4. REM-05: `lib/pages/task_*`, `lib/models/tugas.dart`, flow tasks.
5. REM-06: `lib/pages/home_page.dart`, `lib/pages/course_detail_page.dart`, flow home.
6. REM-07: `lib/theme/*`, `lib/widgets/*`, `assets/*`.
7. REM-08: `test/contract/*`, `docs/verification.md`, `docs/verify-*`.
8. REM-09: `docs/e2e-local.md`, `maestro/flows/*`, bukti device di PR.

## Sebelum push

1. Format, analyze, test hijau lokal.
2. Gate pre-PR: skill `.agents/skills/precommit-unslop/` + `.agents/skills/precommit-no-comments/`, lalu verification hijau.
3. Judul PR `[REM-xx]` plus checklist, body ikut `.github/pull_request_template.md`. Screenshot jika label UI.
4. Jangan commit `build/`, `*.apk`, `*.log`, hasil E2E mentah.
