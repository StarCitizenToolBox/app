import 'package:starcitizen_doctor/common/helper/system_helper.dart';
import 'package:starcitizen_doctor/common/rust/api/input_capture_api.dart' as input_api;

/// A joystick / gamepad the OS reports.
class KbInputDevice {
  const KbInputDevice({
    required this.id,
    required this.name,
    required this.vendorId,
    required this.productId,
    this.isXInput = false,
  });

  final String id;
  final String name;
  final int vendorId;
  final int productId;
  final bool isXInput;
}

/// One captured input: `input` is the game token without the jsN_/gpN_ prefix (`button3`, `hat1_up`, `rotz`).
class KbInputEvent {
  const KbInputEvent({
    required this.deviceId,
    required this.deviceName,
    required this.vendorId,
    required this.productId,
    required this.input,
    this.isXInput = false,
    this.released = false,
  });

  final String deviceId;
  final String deviceName;
  final int vendorId;
  final int productId;
  final String input;
  final bool isXInput;

  /// A button / trigger going up (the backend reports presses and releases for those).
  final bool released;

  /// Buttons and triggers report press + release; axes and hats only report movement.
  bool get hasRelease => !RegExp(r'^(hat\d|thumb[lr][xy]$|[xyz]$|rot[xyz]$|slider)').hasMatch(input);
}

/// Where the keybinding tool gets devices, input and system state from. The app uses the Rust
/// HID/XInput backend; tests substitute scripted devices and events.
class KeybindingEnvironment {
  const KeybindingEnvironment({
    required this.cacheRoot,
    required this.listDevices,
    required this.captureStart,
    required this.captureStop,
    required this.isGameRunning,
  });

  /// Folder for the per-game-version defaultProfile.xml / global.ini cache.
  final String cacheRoot;
  final Future<List<KbInputDevice>> Function() listDevices;
  final Stream<KbInputEvent> Function() captureStart;
  final Future<void> Function() captureStop;
  final Future<bool> Function() isGameRunning;

  factory KeybindingEnvironment.system(String cacheRoot) => KeybindingEnvironment(
    cacheRoot: cacheRoot,
    listDevices: () async => [
      for (final d in await input_api.inputListDevices())
        KbInputDevice(
          id: d.id,
          name: d.name,
          vendorId: d.vendorId,
          productId: d.productId,
          isXInput: d.kind == input_api.InputDeviceKind.xInput,
        ),
    ],
    captureStart: () => input_api.inputCaptureStart().map(
      (e) => KbInputEvent(
        deviceId: e.deviceId,
        deviceName: e.deviceName,
        vendorId: e.vendorId,
        productId: e.productId,
        input: e.input,
        released: e.value == 0 && !RegExp(r'^(thumb[lr][xy]|[xyz]|rot[xyz]|slider\d)$').hasMatch(e.input),
        isXInput: e.kind == input_api.InputDeviceKind.xInput,
      ),
    ),
    captureStop: input_api.inputCaptureStop,
    // getPID matches substrings; the full exe name keeps starcitizen_doctor.exe (this app) out.
    isGameRunning: () async => (await SystemHelper.getPID('StarCitizen.exe')).isNotEmpty,
  );
}
