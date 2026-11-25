# E2E Lokal per Fitur

E2E tidak jalan di CI. Setiap slice fitur diverifikasi agen secara lokal
di emulator atau HP. mobile-agent-testers dipakai sebagai pola
verifikasi, bukan sebagai workflow CI.

## Loop per slice

1. Implementasi slice di branch `REM-xx`.
2. `flutter run` di emulator atau HP.
3. Agen berperan sebagai mahasiswa dan menjalankan `AGENT_BRIEF.md`
   yang relevan dengan slice itu, 2 persona hemat (`anna,malik`).
4. Butuh screenshot terjadwal: clone harness ke `/tmp` sekali saja,
   pakai `scripts/android/screen.py` dan `type.py` plus `adb` untuk
   lihat dan ketik layar. Jangan vendor harness ke repo ini.
5. Tempel screenshot H-1 oranye dan terlambat merah di PR.

## Aturan bukti PR

1. PR yang ubah flow wajib isi bagian E2E lokal di template.
2. PR UI wajib gambar. Tanpa gambar, check PR Format gagal.
3. Jangan commit APK, log mentah, atau hasil E2E ke repo app.

## Hubungan dengan verifikasi formal

Verifikasi formal (`flutter test`, property test glados) membuktikan
logika kode. E2E agentic membuktikan perilaku di layar. Keduanya wajib
hijau sebelum merge slice fitur.
