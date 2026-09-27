// Debug-only entrypoint for UI automation (Dart MCP server / flutter_driver).
// Run with: SCTOOLBOX_NO_ADMIN=1 flutter run -d windows -t test_driver/mcp_main.dart
import 'package:flutter_driver/driver_extension.dart';
import 'package:starcitizen_doctor/main.dart' as app;

Future<void> main(List<String> args) async {
  enableFlutterDriverExtension();
  await app.main(args);
}
