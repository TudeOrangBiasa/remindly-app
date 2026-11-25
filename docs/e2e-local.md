# E2E Lokal di Device

Keputusan: CI hanya static analysis, security analysis, PR format checking. E2E dan verifikasi formal stay di local device.

## Prasyarat

1. Flutter 3.47.0 via FVM (`fvm use`), Android SDK dan satu emulator atau HP.
2. Template mobile-agent-testers sudah di-clone terpisah, bukan di repo ini.
3. Secret model (`CLAUDE_CODE_OAUTH_TOKEN` atau `ANTHROPIC_API_KEY`) hanya di mesin lokal atau secret repo tester, bukan di repo app.

## Jalan cepat

1. Build lokal: `flutter build apk --debug`.
2. Dari repo tester: `gh workflow run agent-testers.yml -f source_repo=TudeOrangBiasa/remindly-app -f app_dir=. -f app_id=com.remindly.app -f android_personas=anna,malik -f ios_personas=none -f framework=flutter`.
3. Atau drive manual: `flutter run` lalu ikuti `docs/kontrak.md` skenario 1 sampai 7.
4. Kumpulkan bukti: screenshot H-1 oranye dan terlambat merah, video jika ada, log di luar repo.

## Aturan bukti PR

1. PR yang ubah flow wajib isi bagian E2E lokal di template.
2. PR UI wajib gambar. Tanpa gambar, check PR Format gagal.
3. Jangan commit APK, log mentah, atau hasil terenkripsi ke repo app.
