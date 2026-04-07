# StarCitizenToolBox Development Guide

Flutter + Rust desktop application for Star Citizen players. Windows primary platform, limited Linux/macOS support.

## Build Process - CRITICAL TIMING

**NEVER CANCEL builds** - they take 45-60 minutes from scratch.

Full build sequence:
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
cd rust && cargo update && cd ..
flutter_rust_bridge_codegen generate
flutter pub global activate intl_utils
flutter pub global run intl_utils:generate
flutter build windows -v  # 15-25 min
```

Quick validation (5-10 min):
```bash
flutter analyze && cd rust && cargo check
```

## Code Generation Dependencies

Generated files (DO NOT EDIT):
- `lib/**/*.g.dart` - JSON serialization
- `lib/**/*.freezed.dart` - Immutable data classes  
- `lib/common/rust/` - Rust-Dart bridge
- `lib/generated/` - Localization

Regenerate after changes:
```bash
dart run build_runner build --delete-conflicting-outputs  # Dart codegen
flutter_rust_bridge_codegen generate                       # Rust API changes
flutter pub global run intl_utils:generate                 # Localization
```

## Required Tools

- Flutter SDK (stable channel)
- Rust toolchain + cargo-expand
- `flutter_rust_bridge_codegen@^2.0.0-dev.0`
- MSBuild + Visual Studio Build Tools + Windows SDK (Windows)
- LLVM 18+ (Windows)

## Testing & Quality

```bash
flutter analyze                    # Dart linting (required for CI)
cd rust && cargo clippy           # Rust linting
flutter test                      # Widget tests
cd rust && cargo test             # Rust unit tests
```

## Architecture

- **UI**: Flutter + Fluent UI (Windows-native look)
- **State**: Riverpod with code generation
- **Routing**: GoRouter
- **Native**: Rust via flutter_rust_bridge (`rust/src/api/*.rs`)
- **Storage**: Hive for local data
- **Localization**: flutter_intl

## Key Directories

- `lib/ui/` - Feature-based UI modules
- `lib/common/rust/` - Generated Rust bridge code
- `rust/src/api/` - Rust native API definitions
- `rust_builder/` - Custom Rust build integration
- `packages/sct_dev_tools/` - Local dev utilities

## Platform Notes

- Windows: Full functionality, primary target
- Linux: Limited functionality, requires GTK + webkit2gtk-4.1
- macOS: Build support but not primary focus

## CI Requirements

CI fails if `flutter analyze` or Rust tests fail. Always run both before committing.

## Reference

See `.github/copilot-instructions.md` for detailed setup and workflow documentation.
