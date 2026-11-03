{
  description = "StarCitizenToolBox (SC汉化盒子) development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forAllSystems (
        pkgs:
        let
          # Native libraries the Rust crate (wry/tao, rodio, librqbit, notify-rust)
          # and the Flutter Linux runner link against through pkg-config.
          linkLibs = with pkgs; [
            gtk3
            glib
            gdk-pixbuf
            pango
            cairo
            atk
            harfbuzz
            libepoxy
            webkitgtk_4_1
            libsoup_3
            openssl
            alsa-lib
            dbus
          ];

          # Loaded with dlopen at runtime (wgpu, winit-style X11/Wayland, ORT),
          # so they need to be on LD_LIBRARY_PATH rather than the RPATH.
          runtimeLibs = with pkgs; [
            vulkan-loader
            libGL
            libxkbcommon
            wayland
            libx11
            libxcursor
            libxrandr
            libxi
            libxcb
            stdenv.cc.cc.lib
          ];

          # ffigen (run by the codegen) parses C headers with libclang, which
          # does not know where glibc's headers live on NixOS.
          frb-codegen = pkgs.writeShellScriptBin "flutter_rust_bridge_codegen" ''
            export CPATH="${pkgs.glibc.dev}/include''${CPATH:+:$CPATH}"
            exec ${pkgs.flutter_rust_bridge_codegen}/bin/flutter_rust_bridge_codegen "$@"
          '';

          # Regenerates everything listed under "Code generation" in AGENTS.md.
          sct-codegen = pkgs.writeShellApplication {
            name = "sct-codegen";
            text = ''
              flutter pub get
              dart run build_runner build --delete-conflicting-outputs
              flutter_rust_bridge_codegen generate
              flutter pub global activate intl_utils
              flutter pub global run intl_utils:generate
            '';
          };

          # Same checks CI runs (flutter_test.yml / rust_test.yml).
          sct-check = pkgs.writeShellApplication {
            name = "sct-check";
            text = ''
              # Cargokit's build tool is a nested package; analyze fails without it.
              (cd rust_builder/cargokit/build_tool && dart pub get)
              flutter analyze
              flutter test
              (cd rust && cargo clippy && cargo test)
            '';
          };
        in
        {
          # clangStdenv: Flutter's Linux runner is built with clang++, and
          # the rustup toolchain links through the same `cc`.
          default = pkgs.mkShell.override { stdenv = pkgs.clangStdenv; } {
            packages = with pkgs; [
              flutter
              # Cargokit builds the crate with `rustup run stable cargo build`,
              # so the toolchain comes from rustup, not nixpkgs' rustc.
              rustup
              frb-codegen
              cargo-expand

              cmake
              ninja
              pkg-config
              git

              # file_picker shells out to zenity on Linux.
              zenity

              sct-codegen
              sct-check
            ];

            buildInputs = linkLibs ++ runtimeLibs;

            LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath runtimeLibs;

            # HTTPS inside the WebKit WebView.
            GIO_EXTRA_MODULES = "${pkgs.glib-networking}/lib/gio/modules";

            shellHook = ''
              # GTK file dialogs and settings abort without the schemas.
              export XDG_DATA_DIRS="${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}''${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"
              # `flutter pub global` executables (intl_utils).
              export PATH="$HOME/.pub-cache/bin:$PATH"
              # `dart run` / `dart pub` need it to resolve `sdk: flutter` packages.
              export FLUTTER_ROOT="$(dirname "$(dirname "$(command -v flutter)")")"

              # Checkouts on NTFS (core.fileMode=false) lose the exec bit Cargokit's
              # CMake step needs; the file is 100755 in git.
              root="$(git rev-parse --show-toplevel 2>/dev/null || echo .)"
              chmod +x "$root/rust_builder/cargokit/run_build_tool.sh" 2>/dev/null || true

              if ! rustup toolchain list 2>/dev/null | grep -q '^stable'; then
                echo "rustup has no stable toolchain yet; Cargokit installs it on the first build,"
                echo "or run: rustup toolchain install stable"
              fi
              echo "StarCitizenToolBox dev shell: flutter $(flutter --version 2>/dev/null | head -1 | cut -d' ' -f2), frb $(flutter_rust_bridge_codegen --version 2>/dev/null | awk '{print $2}')"
              echo "  sct-codegen  build_runner + flutter_rust_bridge + intl_utils"
              echo "  sct-check    flutter analyze/test + cargo clippy/test"
            '';
          };
        }
      );

      formatter = forAllSystems (pkgs: pkgs.nixfmt);
    };
}
