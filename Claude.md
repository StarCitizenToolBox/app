# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

StarCitizenToolBox ("SC汉化盒子") — Flutter + Rust desktop app for Star Citizen players. Provides game localization, diagnostics, performance optimization, P4K archive browsing, audio playback, and more. Windows primary platform; Linux/macOS limited.

Package name: `starcitizen_doctor` (v3.1.1+81). Published on Microsoft Store via MSIX packaging.

## Build Commands

**Quick validation (5-10 min):**
```bash
flutter analyze && cd rust && cargo check
```

**Full build (45-60 min — NEVER CANCEL):**
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
cd rust && cargo update && cd ..
flutter_rust_bridge_codegen generate
flutter pub global activate intl_utils
flutter pub global run intl_utils:generate
flutter build windows -v
```

**Code generation (run after relevant changes):**
```bash
dart run build_runner build --delete-conflicting-outputs  # Dart model changes
flutter_rust_bridge_codegen generate                       # Rust API signature changes
flutter pub global run intl_utils:generate                 # Localization string changes
```

**Testing:**
```bash
flutter test                    # Widget tests
cd rust && cargo test           # Rust unit tests
cd rust && cargo clippy         # Rust linting
```

**CRITICAL: NEVER CANCEL builds.** Flutter build takes 15-25 min; full build 45-60 min.

## Generated Files (DO NOT EDIT)

- `lib/**/*.g.dart` — JSON serialization
- `lib/**/*.freezed.dart` — Immutable data classes
- `lib/common/rust/` — Rust-Dart bridge (configured in `flutter_rust_bridge.yaml`)
- `lib/generated/` — Localization strings

## Architecture

### Layered Structure

1. **Rust layer** (`rust/src/api/`) — Heavy computation: P4K extraction, BitTorrent downloads, ONNX inference, audio decoding (Wwise/OGG), WebView (wry), Win32 interop, HTTP with DNS-over-HTTPS. Each concern is a separate `.rs` module.

2. **Bridge layer** (`lib/common/rust/`) — Auto-generated Dart bindings from `flutter_rust_bridge`. Higher-level wrappers: `rust_audio_player.dart`, `rust_webview_controller.dart`, `http_package.dart`.

3. **State layer** — Every feature has a `*_ui_model.dart` with a `@freezed` state class + `@riverpod` notifier. Cross-cutting providers in `lib/provider/`. Global singleton `AppGlobalModel` in `lib/app.dart`. Notifiers have a shared extension (`lib/common/utils/provider.dart`) for easy access to `appGlobalModel`, `appGlobalState`, `appConfBox`.

4. **UI layer** (`lib/ui/`) — `fluent_ui` (Fluent Design, NOT Material), `hooks_riverpod` for state, `go_router` for routing. Acrylic/mica effects via `flutter_acrylic`.

### Routing (GoRouter)

Defined in `lib/app.dart`:
```
/                    -> SplashUI
/index               -> IndexUI (main shell)
  /index/downloader          -> HomeDownloaderUI
  /index/game_doctor         -> HomeGameDoctorUI
  /index/performance         -> HomePerformanceUI
  /index/advanced_localization -> AdvancedLocalizationUI
/tools               -> shell only
  /tools/unp4kc              -> UnP4kcUI
  /tools/dcb_viewer          -> DcbViewerUI (path via state.extra)
/guide               -> GuideUI
```

### Feature Modules

- `lib/ui/home/` — Largest module, sub-features: `downloader/`, `game_doctor/`, `localization/`, `performance/`, `input_method/`
- `lib/ui/tools/` — P4K browser, log analyzer, DCB viewer
- `lib/ui/party_room/` — Multiplayer session feature
- `lib/ui/auth/`, `settings/`, `about/`, `guide/`, `webview/`

### Rust API Modules

Each `rust/src/api/*.rs` maps to a Dart binding in `lib/common/rust/api/`:
- `unp4k_api.rs` / `unp4k_model_api.rs` — P4K archive extraction & 3D model preview
- `downloader_api.rs` — BitTorrent downloads (librqbit)
- `audio_api.rs` — Audio playback (ww2ogg → vorbis → rodio)
- `http_api.rs` — HTTP client with DoH (reqwest + hickory-resolver)
- `win32_api.rs` — Registry, process management, WMI
- `webview_api.rs` — Embedded browser (wry/tao)
- `ort_api.rs` — ONNX Runtime ML inference
- `asar_api.rs` — Electron ASAR archive reading

### Shared Utilities (`lib/common/`)

- `conf/` — App constants (`conf.dart`), binary paths (`binary_conf.dart`), remote URLs (`url_conf.dart`)
- `helper/` — Game log analyzer, system helper, yearly report analyzer
- `io/` — Rust-backed HTTP client, DNS-over-HTTPS
- `rust/` — Generated bridge + Dart wrappers (audio player, webview controller, HTTP)
- `utils/` — Async helpers, logging, multi-window manager, Riverpod provider extension, URL scheme handler

## Key Tech Stack

| Layer | Technology |
|---|---|
| UI | `fluent_ui` (NOT Material), `flutter_acrylic` |
| State | Riverpod code-gen (`@riverpod` + `@freezed`), `hooks_riverpod` |
| Routing | `go_router` |
| Native | Rust via `flutter_rust_bridge` 2.12.0 |
| Storage | `hive_ce` |
| Networking | `dio`, `grpc`, Rust `reqwest` |
| Window | `window_manager` (custom fork), `desktop_multi_window` |

## Lint Configuration

- Base: `flutter_lints/flutter.yaml`
- Custom lint plugin enabled (`riverpod_lint`)
- `invalid_annotation_target: ignore` (needed for freezed/json_annotation field renames)
- Generated files excluded from analysis (`*.g.dart`, `*.freezed.dart`, `generated/`)

## CI Requirements

CI fails if `flutter analyze` or Rust tests fail. Run both before committing:
```bash
flutter analyze && cd rust && cargo clippy && cargo test
flutter test
```

## Required Tools

- Flutter SDK (stable, Dart ^3.8.0)
- Rust toolchain + `cargo-expand`
- `flutter_rust_bridge_codegen@^2.0.0-dev.0` (pinned 2.12.0 in project)
- MSBuild + Visual Studio Build Tools + Windows SDK
- LLVM 18+ (Windows)
