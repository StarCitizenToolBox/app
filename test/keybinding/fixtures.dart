import 'dart:async';
import 'dart:io';

import 'package:starcitizen_doctor/common/keybinding/sc_input_source.dart';

/// A trimmed defaultProfile.xml with the shapes the real one uses.
const kDefaultProfileXml = '''
<?xml version="1.0" encoding="utf-8"?>
<profile version="1" optionsVersion="2" rebindVersion="2">
  <ActivationModes>
    <ActivationMode name="tap" onPress="0" onHold="0" onRelease="1" multiTap="1" multiTapBlock="1" pressTriggerThreshold="-1" releaseTriggerThreshold="0.25" releaseTriggerDelay="0" retriggerable="0"/>
    <ActivationMode name="press" onPress="1" onHold="0" onRelease="0" multiTap="1" multiTapBlock="1" pressTriggerThreshold="-1" releaseTriggerThreshold="-1" releaseTriggerDelay="0" retriggerable="0"/>
    <ActivationMode name="delayed_press" onPress="1" onHold="0" onRelease="0" multiTap="1" multiTapBlock="1" pressTriggerThreshold="0.25" releaseTriggerThreshold="-1" releaseTriggerDelay="0" retriggerable="0"/>
    <ActivationMode name="double_tap" onPress="1" onHold="0" onRelease="0" multiTap="2" multiTapBlock="1" pressTriggerThreshold="-1" releaseTriggerThreshold="-1" releaseTriggerDelay="0" retriggerable="0"/>
  </ActivationModes>
  <actionmap name="seat_general" version="1" UILabel="@ui_CGSeatGeneral" UICategory="@ui_CCSeatGeneral">
    <action name="v_emergency_exit" activationMode="tap" keyboard="u+lshift" joystick=" " UILabel="@ui_CIEmergencyExit"/>
    <action name="v_operator_mode_cycle_forward" activationMode="tap" keyboard="mouse3" gamepad=" " joystick=" " UILabel="@ui_x"/>
  </actionmap>
  <actionmap name="spaceship_movement" version="18" UILabel="@ui_CGSpaceFlightMovement" UICategory="@ui_CCSpaceFlight">
    <action name="v_strafe_up" onPress="1" onRelease="1" keyboard="space" gamepad=" " joystick="button9" UILabel="@ui_CIStrafeUp"/>
    <action name="v_toggle_landing_system" activationMode="tap" keyboard="n" joystick="button12" gamepad="dpad_down" UILabel="@ui_l"/>
    <action name="v_self_destruct" activationMode="delayed_press_medium" keyboard="backspace" joystick=" " UILabel="@ui_sd">
      <gamepad activationMode="delayed_press_medium" input=" "/>
    </action>
  </actionmap>
  <actionmap name="spaceship_targeting" version="8" UILabel="@ui_t" UICategory="@ui_CCSpaceFlight">
    <action name="lock1" activationMode="tap" keyboard="1" joystick=" " UILabel="@ui_a"/>
    <action name="pin1_hold" activationMode="delayed_press" keyboard=" " joystick=" " UILabel="@ui_b"/>
  </actionmap>
  <actionmap name="player" version="27" UILabel="@ui_CGFPSMovement" UICategory="@ui_CCFPS">
    <action name="gp_group" gamepad="thumbry" UILabel="@ui_c">
      <gamepad><inputdata input="dpad_up"/><inputdata input="thumbr_up"/></gamepad>
    </action>
    <action name="jump" activationMode="press" keyboard="n" UILabel="@ui_j"/>
  </actionmap>
  <actionmap name="debug" version="23">
    <action name="godmode" onPress="1" noModifiers="1" keyboard="f9"/>
  </actionmap>
</profile>
''';

/// The live profile: two VKB sticks recorded, a few player rebinds.
const kActionMapsXml = '''
<ActionMaps>
 <ActionProfiles version="1" optionsVersion="2" rebindVersion="2" profileName="default">
  <options type="keyboard" instance="1" Product="Keyboard  {6F1D2B61-D5A0-11CF-BFC7-444553540000}"/>
  <options type="joystick" instance="1" Product=" VKB-Sim Gladiator NXT R   {0200231D-0000-0000-0000-504944564944}"/>
  <options type="joystick" instance="2" Product=" VKB-Sim Gladiator NXT L   {0201231D-0000-0000-0000-504944564944}">
   <flight_move_strafe_longitudinal invert="1"/>
  </options>
  <modifiers />
  <actionmap name="spaceship_movement">
   <action name="v_strafe_up">
    <rebind input="js1_ "/>
    <rebind input="js2_button5" activationMode="tap"/>
   </action>
  </actionmap>
  <actionmap name="spaceship_targeting">
   <action name="lock1"><rebind input="js1_hat1_left"/></action>
   <action name="pin1_hold"><rebind input="js1_hat1_left"/></action>
  </actionmap>
 </ActionProfiles>
</ActionMaps>
''';

const kEnglishIni = '''
ui_CCSeatGeneral=VEHICLES
ui_CGSeatGeneral=Vehicles - Seats and Operator Modes
ui_CIEmergencyExit=Emergency Exit Seat
ui_x,P=Next Operator Mode
ui_CCSpaceFlight=FLIGHT
ui_CGSpaceFlightMovement=Flight - Movement
ui_CIStrafeUp=Strafe Up (Absolute)
ui_l=Landing System (Toggle)
ui_sd=Self Destruct
ui_t=Vehicles - Targeting
ui_a=Pin Index 1 - Lock / Unlock
ui_b=Pin Index 1 - Pin / Unpin (Hold)
ui_CCFPS=ON FOOT
ui_CGFPSMovement=On Foot - General
ui_c=Look
ui_j=Jump
''';

/// Game-language overlay; entries it lacks fall back to English.
const kChineseIni = '''
ui_CCSpaceFlight=航行
ui_CGSpaceFlightMovement=航行 - 移动
ui_CIStrafeUp=平移：向上（绝对值）
ui_l=着陆系统（切换）
ui_t=载具 - 瞄准
ui_a=标记光标 1 - 锁定/解除已标记目标
''';

const vkbRight = KbInputDevice(id: 'dev-r', name: 'VKB-Sim Gladiator NXT R', vendorId: 0x231D, productId: 0x0200);
const vkbLeft = KbInputDevice(id: 'dev-l', name: 'VKB-Sim Gladiator NXT L', vendorId: 0x231D, productId: 0x0201);
const pedals = KbInputDevice(id: 'dev-p', name: 'T-Rudder', vendorId: 0x044F, productId: 0xB679);
const xpad = KbInputDevice(id: 'xinput0', name: 'Xbox Controller 1', vendorId: 0, productId: 0, isXInput: true);

KbInputEvent eventFrom(KbInputDevice d, String input, {bool released = false}) => KbInputEvent(
  deviceId: d.id,
  deviceName: d.name,
  vendorId: d.vendorId,
  productId: d.productId,
  input: input,
  isXInput: d.isXInput,
  released: released,
);

/// Scriptable devices and input for the keybinding tool.
class FakeInput {
  FakeInput(this.cacheRoot, {List<KbInputDevice>? devices}) : devices = devices ?? [vkbRight, vkbLeft, xpad];

  final String cacheRoot;
  List<KbInputDevice> devices;
  bool gameRunning = false;
  StreamController<KbInputEvent>? _controller;
  int starts = 0;
  int stops = 0;

  bool get capturing => _controller != null && !_controller!.isClosed;

  void emit(KbInputEvent e) => _controller!.add(e);

  late final KeybindingEnvironment env = KeybindingEnvironment(
    cacheRoot: cacheRoot,
    listDevices: () async => devices,
    captureStart: () {
      starts++;
      _controller = StreamController<KbInputEvent>();
      return _controller!.stream;
    },
    captureStop: () async {
      stops++;
      await _controller?.close();
    },
    isGameRunning: () async => gameRunning,
  );
}

/// A fake `...\StarCitizen\LIVE` folder whose Data.p4k extraction is already cached, so no p4k is opened.
class FakeGame {
  FakeGame._(this.root, this.cacheRoot);

  final Directory root;
  final String cacheRoot;

  String get path => root.path;

  File get actionMaps => File('${root.path}\\user\\client\\0\\Profiles\\default\\actionmaps.xml');

  Directory get mappings => Directory('${root.path}\\user\\client\\0\\Controls\\Mappings');

  Directory get backups => Directory('${root.path}\\user\\client\\0\\Profiles\\default\\sctoolbox_backup');

  static Future<FakeGame> create({String actionMaps = kActionMapsXml, String language = 'chinese_(simplified)'}) async {
    final tmp = await Directory.systemTemp.createTemp('sc_keybind_test_');
    final game = Directory('${tmp.path}\\LIVE');
    final cacheRoot = '${tmp.path}\\support';
    final p4k = File('${game.path}\\Data.p4k');
    await p4k.create(recursive: true);
    await p4k.writeAsString('not a real p4k');
    final stat = await p4k.stat();
    final cache = Directory('$cacheRoot\\keybinding_cache\\LIVE\\${stat.size}_${stat.modified.millisecondsSinceEpoch}');
    await cache.create(recursive: true);
    await File('${cache.path}\\defaultProfile.xml').writeAsString(kDefaultProfileXml);
    // With a BOM, like the game's own file.
    await File('${cache.path}\\global_english.ini').writeAsBytes([0xEF, 0xBB, 0xBF, ...kEnglishIni.codeUnits]);
    await File('${game.path}\\build_manifest.id').writeAsString('{"Data": {"Version": "4.9.186.58667"}}');
    await File('${game.path}\\data\\system.cfg').create(recursive: true);
    await File('${game.path}\\data\\system.cfg').writeAsString('sys_spec=4\ng_language=$language\n');
    final loc = File('${game.path}\\data\\Localization\\$language\\global.ini');
    await loc.create(recursive: true);
    await loc.writeAsString(kChineseIni);
    final am = File('${game.path}\\user\\client\\0\\Profiles\\default\\actionmaps.xml');
    await am.create(recursive: true);
    await am.writeAsString(actionMaps);
    return FakeGame._(game, cacheRoot);
  }

  Future<void> dispose() => root.parent.delete(recursive: true);
}
