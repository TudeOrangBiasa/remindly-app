# E2E Lokal di Device
Repo tester: `TudeOrangBiasa/remindly-testers` (dari template upstream, repo app tetap bersih). Brief fitur: `briefs/remindly.md` di repo tester, cermin `AGENT_BRIEF.md` di repo app.

Keputusan: CI app hanya static analysis, security analysis, PR format checking. E2E jalan di repo tester, verifikasi formal tetap `flutter test` di repo app.

## Prasyarat

1. Flutter 3.47.0 via FVM (`fvm use`), Android SDK dan satu emulator atau HP.
2. Template mobile-agent-testers sudah di-clone terpisah, bukan di repo ini.
3. Secret model (`CLAUDE_CODE_OAUTH_TOKEN` atau `ANTHROPIC_API_KEY`) hanya di mesin lokal atau secret repo tester, bukan di repo app.

## Jalan cepat

1. Token Claude dulu (satu kali, interaktif agar tidak masuk shell history): `gh secret set CLAUDE_CODE_OAUTH_TOKEN --repo TudeOrangBiasa/remindly-testers` atau `ANTHROPIC_API_KEY` untuk API key.
2. Dispatch hemat (2 Android, tanpa iOS): `gh workflow run agent-testers.yml --repo TudeOrangBiasa/remindly-testers -f source_repo=TudeOrangBiasa/remindly-app -f app_dir=. -f app_id=com.remindly.app -f android_personas=anna,malik -f ios_personas=none -f framework=flutter -f brief=briefs/remindly.md`
3. Ambil hasil dari clone repo tester: `bash scripts/collect.sh $(gh run list --repo TudeOrangBiasa/remindly-testers --workflow agent-testers.yml -L 1 --json databaseId -q '.[0].databaseId')`. Kunci privat di `~/.mobile-agent-testers`, jangan commit.
4. Atau drive manual: `flutter run` lalu ikuti `docs/kontrak.md` skenario 1 sampai 7.
5. Kumpulkan bukti: screenshot H-1 oranye dan terlambat merah, video jika ada, log di luar repo.

## Aturan bukti PR

1. PR yang ubah flow wajib isi bagian E2E lokal di template.
2. PR UI wajib gambar. Tanpa gambar, check PR Format gagal.
3. Jangan commit APK, log mentah, atau hasil terenkripsi ke repo app.
