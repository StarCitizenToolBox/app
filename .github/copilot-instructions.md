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
   cargo build --release  # NEVER CANCEL: Takes ~2 minutes
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
- Limited functionality (desktop app designed primarily for Windows)

**macOS:**
- Xcode Command Line Tools
- CMake

### Wine + Windows MSVC Cross-Compilation (Linux/macOS)

For developers on Linux/macOS who want to validate Rust code against the Windows MSVC toolchain without running Windows natively:

**Prerequisites:**
```bash
# Ubuntu/Debian
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y wine64 wine32:i386

# macOS (with Homebrew)
brew install --cask wine-stable

# Add Windows MSVC target to Rust
rustup target add x86_64-pc-windows-msvc
```

**Install Windows MSVC Build Tools via Wine:**
1. **Download Visual Studio Build Tools:**
   ```bash
   # Create Wine prefix for isolated environment
   export WINEPREFIX="$HOME/.wine_msvc"
   winecfg  # Set to Windows 10 mode

   # Download VS Build Tools (replace URL with current version)
   wget -O /tmp/vs_buildtools.exe "https://aka.ms/vs/17/release/vs_buildtools.exe"
   ```

2. **Install MSVC components:**
   ```bash
   # Install with minimal required components
   wine /tmp/vs_buildtools.exe --quiet --wait --add Microsoft.VisualStudio.Workload.VCTools \
     --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 \
     --add Microsoft.VisualStudio.Component.Windows10SDK.20348
   ```

3. **Configure Rust to use Wine MSVC:**
   Create `~/.cargo/config.toml`:
   ```toml
   [target.x86_64-pc-windows-msvc]
   linker = "lld-link"
   ar = "llvm-lib"
   
   [env]
   CC_x86_64_pc_windows_msvc = "wine cl.exe"
   CXX_x86_64_pc_windows_msvc = "wine cl.exe"
   AR_x86_64_pc_windows_msvc = "wine lib.exe"
   CARGO_TARGET_X86_64_PC_WINDOWS_MSVC_LINKER = "wine link.exe"
   ```

**Alternative: Using xwin (Recommended for CI/CD):**
```bash
# Install xwin for Microsoft CRT/SDK download
cargo install xwin

# Download Windows SDK and CRT
xwin --accept-license splat --output ~/.xwin

# Configure Rust to use xwin
export XWIN_ARCH=x86_64
export XWIN_CACHE_DIR=~/.xwin
cat >> ~/.cargo/config.toml << 'EOF'
[target.x86_64-pc-windows-msvc]
linker = "lld-link"
ar = "llvm-lib"
runner = "wine"

[env]
CC_x86_64_pc_windows_msvc = "clang-cl"
CXX_x86_64_pc_windows_msvc = "clang-cl"
AR_x86_64_pc_windows_msvc = "llvm-lib"
CFLAGS_x86_64_pc_windows_msvc = "/imsvc ~/.xwin/crt/include /imsvc ~/.xwin/sdk/include/ucrt /imsvc ~/.xwin/sdk/include/um /imsvc ~/.xwin/sdk/include/shared"
RUSTFLAGS = "-Lnative=~/.xwin/crt/lib/x86_64 -Lnative=~/.xwin/sdk/lib/um/x86_64 -Lnative=~/.xwin/sdk/lib/ucrt/x86_64"
EOF
```

### Testing and Validation

**Rust Component Testing:**
```bash
cd rust
cargo check  # Fast syntax check (1-2 minutes)
cargo test   # Run Rust unit tests (5-10 minutes - NEVER CANCEL)
```

**Windows MSVC Cross-Compilation Validation (Linux/macOS):**
```bash
cd rust
# Quick MSVC syntax check (3-5 minutes with Wine - NEVER CANCEL)
cargo check --target x86_64-pc-windows-msvc

# Alternative with xwin (2-3 minutes)
RUSTFLAGS="-Lnative=$HOME/.xwin/crt/lib/x86_64 -Lnative=$HOME/.xwin/sdk/lib/um/x86_64 -Lnative=$HOME/.xwin/sdk/lib/ucrt/x86_64" \
  cargo check --target x86_64-pc-windows-msvc
```

**Flutter Testing:**
```bash
flutter test  # Run Flutter widget tests (2-5 minutes)
```

**Linting and Code Quality:**
```bash
flutter analyze          # Dart/Flutter linting (30-60 seconds)
cd rust && cargo clippy  # Rust linting (2-3 minutes)
cd rust && cargo clippy --target x86_64-pc-windows-msvc  # Windows MSVC linting (3-5 minutes - NEVER CANCEL)
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
```

**Extended validation for critical changes:**
```bash
# Windows MSVC compatibility check (Linux/macOS developers)
cd rust && cargo check --target x86_64-pc-windows-msvc  # MSVC compatibility (3-5 minutes - NEVER CANCEL)
cd rust && cargo clippy --target x86_64-pc-windows-msvc # MSVC linting (3-5 minutes - NEVER CANCEL)
```

**CI Pipeline will fail if:**
- Flutter analyze reports errors
- Rust clippy reports errors  
- Any tests fail
- Build process fails
- Windows MSVC compatibility issues (if target enabled)

## Common Issues and Solutions

### Flutter/Dart Issues
- **Build runner conflicts:** Delete generated files and rebuild with `--delete-conflicting-outputs`
- **Dependency conflicts:** Run `flutter pub deps` to check for version conflicts
- **Localization missing:** Ensure `flutter pub global run intl_utils:generate` completed successfully

### Rust Issues  
- **Bridge generation fails:** Verify flutter_rust_bridge_codegen is installed and Rust code compiles
- **Link errors:** Ensure all required system libraries are installed for target platform
- **API changes:** Regenerate bridge code after modifying Rust API signatures

### Wine + MSVC Issues
- **Wine not found:** Install Wine with `sudo apt install wine64 wine32:i386` (Linux) or `brew install --cask wine-stable` (macOS)
- **MSVC tools missing:** Use `xwin` for automated Microsoft CRT/SDK download: `cargo install xwin && xwin --accept-license splat --output ~/.xwin`
- **Link.exe errors:** Configure `~/.cargo/config.toml` with proper MSVC target settings and RUSTFLAGS
- **lib.exe not found:** Ensure `llvm-lib` is installed and properly aliased in cargo config
- **Cross-compilation slow:** First-time setup downloads ~2GB of MSVC tools, subsequent builds are faster
- **Wine prefix issues:** Use dedicated Wine prefix with `export WINEPREFIX="$HOME/.wine_msvc"`
- **Complex native dependencies:** Some crates with extensive C/C++ code (like `ring`, OpenSSL) may fail to cross-compile; consider feature flags to disable problematic dependencies or use alternative crates
- **clang-cl not found:** Install clang with `sudo apt install clang lld llvm` and create symlink: `sudo ln -sf /usr/bin/clang-cl-18 /usr/bin/clang-cl`

### Build Performance
- Use `cargo check` instead of `cargo build` for quick Rust validation
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

# Windows MSVC validation (Linux/macOS - 8-15 minutes total - NEVER CANCEL)
flutter analyze && cd rust && cargo check --target x86_64-pc-windows-msvc

# Full build validation (45-60 minutes - NEVER CANCEL)
flutter pub get && \
dart run build_runner build --delete-conflicting-outputs && \
cd rust && cargo update && cd .. && \
flutter_rust_bridge_codegen generate && \
flutter pub global run intl_utils:generate && \
flutter build windows -v

# Code generation only (5-10 minutes)
dart run build_runner build --delete-conflicting-outputs && \
flutter_rust_bridge_codegen generate && \
flutter pub global run intl_utils:generate

# Test execution (10-15 minutes total - NEVER CANCEL)
flutter test && cd rust && cargo test

# Extended MSVC validation (Linux/macOS - 15-20 minutes total - NEVER CANCEL)
flutter test && \
cd rust && cargo test && \
cargo check --target x86_64-pc-windows-msvc && \
cargo clippy --target x86_64-pc-windows-msvc
```

**Wine + MSVC Setup Commands:**
```bash
# Initial Wine MSVC setup (Linux/macOS - ONE-TIME - 30+ minutes - NEVER CANCEL)
sudo dpkg --add-architecture i386 && sudo apt update && sudo apt install -y wine64 wine32:i386  # Linux
rustup target add x86_64-pc-windows-msvc
cargo install xwin
xwin --accept-license splat --output ~/.xwin

# Configure Rust for MSVC cross-compilation
mkdir -p ~/.cargo
cat >> ~/.cargo/config.toml << 'EOF'
[target.x86_64-pc-windows-msvc]
linker = "lld-link"
ar = "llvm-lib"
runner = "wine"

[env]
CC_x86_64_pc_windows_msvc = "clang-cl"
CXX_x86_64_pc_windows_msvc = "clang-cl" 
AR_x86_64_pc_windows_msvc = "llvm-lib"
RUSTFLAGS_x86_64_pc_windows_msvc = "-Lnative=$HOME/.xwin/crt/lib/x86_64 -Lnative=$HOME/.xwin/sdk/lib/um/x86_64 -Lnative=$HOME/.xwin/sdk/lib/ucrt/x86_64"
EOF
```

**CRITICAL REMINDERS:**
- NEVER CANCEL builds or long-running commands - they can take 45+ minutes
- Always set command timeouts to 60+ minutes for build operations
- Always set command timeouts to 30+ minutes for test operations  
- Wine + MSVC setup: Initial setup takes 30+ minutes, subsequent checks 3-5 minutes
- Wine MSVC cargo check: Set timeout to 10+ minutes for first run, 3-5 minutes thereafter
- Validate changes with both quick checks and full builds before committing
- Use Windows environment for complete functionality testing