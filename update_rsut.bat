flutter_rust_bridge_codegen --rust-input rust\src\api.rs --dart-output .\lib\common\rust\bridge_generated.dart --dart-decl-output .\lib\common\rust\bridge_definitions.dart
dart run build_runner build