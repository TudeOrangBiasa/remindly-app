# E2E di Repo Ini

Harness mobile-agent-testers di-vendor ke repo ini: `scripts/`,
`personas.json`, `results_public.pem`, `briefs/remindly.md`,
`e2e/AGENT_BRIEF.md`, workflow `agent-testers.yml`. Default hemat:
2 Android (`anna,malik`), tanpa iOS, brief fitur Remindly.

Keputusan: CI app hanya static analysis, security analysis, PR format
checking. E2E jalan via dispatch manual workflow ini, verifikasi formal
tetap `flutter test` di repo app.

## Prasyarat

1. Secret model di repo ini (`CLAUDE_CODE_OAUTH_TOKEN` atau
   `ANTHROPIC_API_KEY`), tidak pernah masuk file.
2. Kunci privat di `~/.mobile-agent-testers`, jangan commit.
   `results_public.pem` di repo aman dibaca publik.

## Jalan cepat

1. Token Claude dulu (satu kali, interaktif agar tidak masuk shell history):
   `gh secret set CLAUDE_CODE_OAUTH_TOKEN --repo TudeOrangBiasa/remindly-app`
2. Dispatch (pakai default hemat):
   `gh workflow run agent-testers.yml --repo TudeOrangBiasa/remindly-app`
3. Ambil hasil:
   `bash scripts/collect.sh $(gh run list --repo TudeOrangBiasa/remindly-app --workflow agent-testers.yml -L 1 --json databaseId -q '.[0].databaseId')`
4. Atau drive manual: `flutter run` lalu ikuti `docs/kontrak.md` skenario
   1 sampai 7.
5. Kumpulkan bukti: screenshot H-1 oranye dan terlambat merah, video jika
   ada, log di luar repo.

## Aturan bukti PR

1. PR yang ubah flow wajib isi bagian E2E lokal di template.
2. PR UI wajib gambar. Tanpa gambar, check PR Format gagal.
3. Jangan commit APK, log mentah, atau hasil terenkripsi ke repo app.
