import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/app.dart';

/// Whether the nebula background drifts and follows window movement.
/// Defaults to on; stored in the `app_conf` box once Hive is ready.
final dynamicBackgroundProvider =
    NotifierProvider<DynamicBackgroundNotifier, bool>(
      DynamicBackgroundNotifier.new,
    );

class DynamicBackgroundNotifier extends Notifier<bool> {
  static const _confKey = "isEnableDynamicBackground";

  @override
  bool build() {
    final box = ref.watch(
      appGlobalModelProvider.select((state) => state.appConfBox),
    );
    return box?.get(_confKey, defaultValue: true) ?? true;
  }

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    await ref.read(appGlobalModelProvider).appConfBox?.put(_confKey, enabled);
  }
}
