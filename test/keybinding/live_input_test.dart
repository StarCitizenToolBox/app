import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starcitizen_doctor/ui/tools/keybinding/widgets/keyboard_keys.dart';
import 'package:starcitizen_doctor/ui/tools/keybinding/widgets/live_input.dart';

import 'fixtures.dart';

void main() {
  testWidgets('buttons stay lit until released; axes and hats flash', (tester) async {
    final live = LiveInput();
    live.feed('gp:shoulderl', eventFrom(xpad, 'shoulderl'));
    live.feed('js1:hat1_up', eventFrom(vkbRight, 'hat1_up'));
    live.feed('gp:thumblx', eventFrom(xpad, 'thumblx'));
    expect(live.value, {'gp:shoulderl', 'js1:hat1_up', 'gp:thumblx'});
    await tester.pump(const Duration(seconds: 1));
    expect(live.value, {'gp:shoulderl'}, reason: 'the held bumper stays; flashes are gone');
    live.release('gp:shoulderl');
    expect(live.value, isEmpty);
    live.dispose();
  });

  testWidgets('a held input goes dark after 5 seconds without a release', (tester) async {
    final live = LiveInput();
    live.press('kb:lalt');
    await tester.pump(const Duration(seconds: 4));
    expect(live.value, {'kb:lalt'});
    await tester.pump(const Duration(seconds: 2));
    expect(live.value, isEmpty);
    live.dispose();
  });

  test('Right Shift with the Windows scan-code physical id is recognised by its logical key', () {
    // What the Windows embedder reports for Right Shift.
    const down = KeyDownEvent(
      physicalKey: PhysicalKeyboardKey(0x1600000036),
      logicalKey: LogicalKeyboardKey.shiftRight,
      timeStamp: Duration.zero,
    );
    expect(scKeyFor(down), 'rshift');
    final live = LiveInput();
    live.onKey(down);
    expect(live.value, {'kb:rshift'});
    live.onKey(
      const KeyUpEvent(
        physicalKey: PhysicalKeyboardKey(0x1600000036),
        logicalKey: LogicalKeyboardKey.shiftRight,
        timeStamp: Duration.zero,
      ),
    );
    expect(live.value, isEmpty);
    live.dispose();
  });
}
