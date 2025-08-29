# StarCitizenToolBox Flutter/Rust Desktop Application

StarCitizenToolBox is a Flutter desktop application with Rust native bindings designed for Star Citizen players. It provides localization management, game diagnostics, website translations, performance optimization, and various tools for the Star Citizen gaming experience. The app supports Windows, macOS, and Linux platforms using Fluent UI design.

Always reference these instructions first and fallback to additional search or context gathering only when information in these instructions is incomplete or found to be in error.

## Working Effectively

### Initial Setup and Dependencies

Install required dependencies in this exact order:

1. **Install Rust toolchain:**
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
   source ~/.cargo/env
   ```

2. **Install Flutter SDK (stable channel):**
   ```bash
   # Clone Flutter repository
   cd /tmp
   git clone https://github.com/flutter/flutter.git -b stable --depth 1
   export PATH="/tmp/flutter/bin:$PATH"
   flutter --version
   ```
   Note: If Flutter download fails due to network issues, the build can still proceed with existing generated code.

3. **Install essential Rust tools:**
   ```bash
   cargo install cargo-expand
   cargo install 'flutter_rust_bridge_codegen@^2.0.0-dev.0'
   ```

4. **Install cargo-xwin for Windows MSVC cross-compilation from Linux:**
   ```bash
   # Install cargo-xwin for cross-compilation to Windows
   cargo install cargo-xwin
   
   # Add Windows MSVC target
   rustup target add x86_64-pc-windows-msvc
   ```

### Build Process - NEVER CANCEL LONG-RUNNING COMMANDS

Execute these commands in sequence. **NEVER CANCEL** - builds can take 45+ minutes:

1. **Install Flutter dependencies:** (2-3 minutes)
   ```bash
   flutter pub get
   ```

2. **Generate Dart code:** (3-5 minutes)
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **Update Rust dependencies:** (10-15 minutes first time, 2-3 minutes subsequent)
   ```bash
   cd rust && cargo update
   ```

4. **Generate Rust-Dart bridge code:** (5-8 minutes)
   ```bash
   flutter_rust_bridge_codegen generate
   ```

5. **Generate localization files:** (1-2 minutes)
   ```bash
   flutter pub global activate intl_utils
   flutter pub global run intl_utils:generate
   ```

6. **Build Rust components:** (60-90 seconds debug, 110-120 seconds release)
   ```bash
   cd rust
   
   # For native Linux build (limited functionality)
   cargo build --release  # NEVER CANCEL: Takes ~2 minutes
   
   # For Windows MSVC cross-compilation from Linux (recommended)
   cargo xwin build --release --target x86_64-pc-windows-msvc  # NEVER CANCEL: Takes ~3-4 minutes
   ```

7. **Build Flutter application:** (15-25 minutes - NEVER CANCEL)
   ```bash
   flutter build windows -v  # Set timeout to 30+ minutes minimum
   ```

**CRITICAL BUILD TIMING:**
- Complete full build from scratch: **45-60 minutes** - NEVER CANCEL
- Rust release build: **2 minutes** - NEVER CANCEL  
- Flutter application build: **15-25 minutes** - NEVER CANCEL
- Code generation steps: **10-15 minutes total** - NEVER CANCEL

### Platform-Specific Build Requirements

**Windows (Primary Platform):**
- MSBuild tools
- Visual Studio Build Tools or Visual Studio Community
- Windows SDK
- LLVM/Clang (version 18+ recommended)

**Linux (Development/Testing):**
- Basic build tools: `build-essential`, `cmake`, `ninja-build`
- GTK development libraries
- cargo-xwin for Windows MSVC cross-compilation: `cargo install cargo-xwin`
- Windows MSVC target: `rustup target add x86_64-pc-windows-msvc`
- Can build Windows-compatible Rust components via cross-compilation

**macOS:**
- Xcode Command Line Tools
- CMake

### Testing and Validation

**Rust Component Testing:**
```bash
cd rust

# Fast syntax check (1-2 minutes)
cargo check  

# Cross-compilation check for Windows MSVC from Linux (2-3 minutes)
cargo xwin check --target x86_64-pc-windows-msvc

# Run Rust unit tests (5-10 minutes - NEVER CANCEL)
cargo test   
```

**Flutter Testing:**
```bash
flutter test  # Run Flutter widget tests (2-5 minutes)
```

**Linting and Code Quality:**
```bash
flutter analyze          # Dart/Flutter linting (30-60 seconds)
cd rust && cargo clippy  # Rust linting (2-3 minutes)

# Cross-compilation linting for Windows MSVC from Linux (3-4 minutes)
cd rust && cargo xwin clippy --target x86_64-pc-windows-msvc
```

### Manual Validation Requirements

After building, always perform these validation steps:

1. **Verify application starts:**
   ```bash
   # Windows
   ./build/windows/x64/runner/Release/starcitizen_doctor.exe
   
   # Linux (limited functionality)
   ./build/linux/x64/release/bundle/starcitizen_doctor
   ```

2. **Test core functionality:**
   - Application launches without crashes
   - Main navigation works
   - Settings panel accessible
   - Localization switching functional

**Note:** Full UI testing requires Windows environment. Linux builds have limited functionality.

### Cross-compilation with cargo-xwin

For Linux developers who need to build Windows-compatible Rust components, cargo-xwin provides seamless cross-compilation to Windows MSVC targets without requiring Windows or Visual Studio.

**Setup cargo-xwin:**
```bash
# Install cargo-xwin
cargo install cargo-xwin

# Add Windows MSVC target
rustup target add x86_64-pc-windows-msvc
```

**Using cargo-xwin:**
```bash
cd rust

# Check/validate Windows compatibility
cargo xwin check --target x86_64-pc-windows-msvc

# Build for Windows MSVC
cargo xwin build --release --target x86_64-pc-windows-msvc

# Test Windows-specific code paths
cargo xwin test --target x86_64-pc-windows-msvc

# Lint for Windows target
cargo xwin clippy --target x86_64-pc-windows-msvc
```

**Benefits:**
- Cross-compile Windows MSVC binaries from Linux
- Validate Windows-specific dependencies and APIs
- Test Windows code paths without Windows environment
- Faster development cycle for Windows-targeted features

## Project Structure and Key Files

### Entry Points and Main Code
- **Main application:** `lib/main.dart` - Flutter app entry point with multi-window support
- **App configuration:** `lib/app.dart` - Application state, routing, theming, and localization
- **Rust bridge:** `lib/common/rust/` - Generated Rust-Dart interop code
- **UI modules:** `lib/ui/` - All user interface components organized by feature

### Build Configuration
- **Flutter config:** `pubspec.yaml` - Dependencies, assets, build settings
- **Rust config:** `rust/Cargo.toml` - Native dependencies and build settings
- **Rust bridge:** `flutter_rust_bridge.yaml` - Bridge code generation settings
- **Analysis:** `analysis_options.yaml` - Dart/Flutter linting rules

### Build System Files
- **Rust builder:** `rust_builder/` - Custom Rust compilation integration with cargokit
- **Platform builds:** `windows/`, `linux/`, `macos/` - Platform-specific build configurations
- **CI/CD:** `.github/workflows/windows_nightly.yml` - Automated build pipeline

### Generated Code (DO NOT EDIT)
- `lib/generated/` - Auto-generated localization files
- `lib/**/*.g.dart` - Generated JSON serialization code
- `lib/**/*.freezed.dart` - Generated immutable data classes
- `lib/common/rust/` - Generated Rust-Dart bridge code

## Development Workflow

### Making Changes

1. **For Dart/Flutter changes:**
   ```bash
   # After UI or logic changes
   dart run build_runner build --delete-conflicting-outputs
   flutter analyze
   ```

2. **For Rust changes:**
   ```bash
   cd rust
   cargo check  # Quick validation
   
   # Cross-compilation validation for Windows MSVC from Linux
   cargo xwin check --target x86_64-pc-windows-msvc
   
   flutter_rust_bridge_codegen generate  # Regenerate bridge if API changed
   ```

3. **For localization changes:**
   ```bash
   flutter pub global run intl_utils:generate
   ```

### Pre-commit Validation

Always run before committing changes:
```bash
flutter analyze                    # Dart linting (required for CI)
cd rust && cargo clippy           # Rust linting  
flutter test                      # Widget tests
cd rust && cargo test            # Rust tests

# Cross-compilation validation for Windows MSVC from Linux
cd rust && cargo xwin check --target x86_64-pc-windows-msvc
cd rust && cargo xwin clippy --target x86_64-pc-windows-msvc
```

**CI Pipeline will fail if:**
- Flutter analyze reports errors
- Rust clippy reports errors  
- Any tests fail
- Build process fails

## Common Issues and Solutions

### Flutter/Dart Issues
- **Build runner conflicts:** Delete generated files and rebuild with `--delete-conflicting-outputs`
- **Dependency conflicts:** Run `flutter pub deps` to check for version conflicts
- **Localization missing:** Ensure `flutter pub global run intl_utils:generate` completed successfully

### Rust Issues  
- **Bridge generation fails:** Verify flutter_rust_bridge_codegen is installed and Rust code compiles
- **Link errors:** Ensure all required system libraries are installed for target platform
- **API changes:** Regenerate bridge code after modifying Rust API signatures

### Build Performance
- Use `cargo check` instead of `cargo build` for quick Rust validation
- Use `cargo xwin check --target x86_64-pc-windows-msvc` for quick Windows cross-compilation validation
- Use `flutter analyze` instead of full build for quick Dart validation
- Clean build artifacts if experiencing issues: `flutter clean && cd rust && cargo clean`

## Application Architecture

**UI Framework:** Flutter with Fluent UI design system for Windows-native appearance
**State Management:** Riverpod with code generation for type-safe state management  
**Routing:** GoRouter for navigation with nested routes
**Localization:** Flutter i18n with custom tooling for community translations
**Data Layer:** Hive for local storage, HTTP client for network requests
**Native Integration:** Rust via flutter_rust_bridge for system operations and performance-critical code

## Key Development Commands Reference

```bash
# Quick development validation (5-10 minutes total)
flutter analyze && cd rust && cargo check

# Quick Windows MSVC cross-compilation validation from Linux (6-12 minutes total)
flutter analyze && cd rust && cargo xwin check --target x86_64-pc-windows-msvc

# Full build validation (45-60 minutes - NEVER CANCEL)
flutter pub get && \
dart run build_runner build --delete-conflicting-outputs && \
cd rust && cargo update && cd .. && \
flutter_rust_bridge_codegen generate && \
flutter pub global run intl_utils:generate && \
flutter build windows -v

# Windows MSVC cross-compilation build from Linux (30-45 minutes - NEVER CANCEL)  
flutter pub get && \
dart run build_runner build --delete-conflicting-outputs && \
cd rust && cargo update && \
cargo xwin build --release --target x86_64-pc-windows-msvc && cd .. && \
flutter_rust_bridge_codegen generate && \
flutter pub global run intl_utils:generate

# Code generation only (5-10 minutes)
dart run build_runner build --delete-conflicting-outputs && \
flutter_rust_bridge_codegen generate && \
flutter pub global run intl_utils:generate

# Test execution (10-15 minutes total - NEVER CANCEL)
flutter test && cd rust && cargo test

# Cross-compilation test execution for Windows MSVC from Linux (12-18 minutes - NEVER CANCEL)
flutter test && cd rust && cargo xwin test --target x86_64-pc-windows-msvc
```

**CRITICAL REMINDERS:**
- NEVER CANCEL builds or long-running commands - they can take 45+ minutes
- Always set command timeouts to 60+ minutes for build operations
- Always set command timeouts to 30+ minutes for test operations  
- Validate changes with both quick checks and full builds before committing
- Use Windows environment for complete functionality testing