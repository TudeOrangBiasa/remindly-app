# Setup Mesin Kontributor

Satu kali per mesin. Semua versi dikunci agar hasil E2E sama.

## Flutter 3.47.0 via FVM

1. Install FVM sekali: `nix run nixpkgs#fvm -- --version`.
2. Di repo: `nix run nixpkgs#fvm -- use 3.47.0 --force`.
3. Pakai terus: `export PATH="$HOME/fvm/versions/3.47.0/bin:$PATH"`.
4. Cek: `flutter --version` harus 3.47.0, Dart 3.13.0.

## Android SDK

1. Perlu: `platform-tools`, `emulator`, `cmdline-tools`, satu system image.
2. Env: `ANDROID_HOME=$HOME/Android/Sdk`, `ANDROID_SDK_ROOT` sama.
3. AVD `remindly`: Pixel 7, API 34 google_apis x86_64.
4. Boot: `emulator -avd remindly -no-window -no-audio -no-snapshot -gpu host`.
5. Wajib GPU host. SwiftShader segfault di semua mode di mesin AMD ini
   (percobaan swiftshader, angle, lavapipe, TCG semua crash, coredump
   SIGSEGV dan SIGILL). Jangan buang waktu coba lagi.

## Java 21

Maestro butuh Java. `nix profile add nixpkgs#temurin-bin`, cek
`java -version` 21. Tanpa ini instalasi Maestro menolak jalan.

## Maestro 2.12.1

1. Install: `curl -Ls https://get.maestro.mobile.dev | bash`.
2. Matikan analitik: `export MAESTRO_CLI_NO_ANALYTICS=1`.
3. Cek: `maestro --version`.
4. Jalan: `maestro test maestro/flows/smoke.yaml` dengan emulator nyala.

## Verifikasi setup

1. `flutter analyze --fatal-infos --fatal-warnings` nol issue.
2. `flutter test` semua hijau.
3. `adb devices` tampil `emulator-5554`.
4. `maestro test maestro/flows/smoke.yaml` 6 langkah COMPLETED.
