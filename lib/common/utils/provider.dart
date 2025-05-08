import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:starcitizen_doctor/app.dart';

extension ProviderExtension on AutoDisposeNotifier {
  AppGlobalModel get appGlobalModel =>
      ref.read(appGlobalModelProvider.notifier);

  AppGlobalState get appGlobalState => ref.read(appGlobalModelProvider);

  Box<dynamic>? get appConfBox => appGlobalState.appConfBox;
}
