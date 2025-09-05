// ignore_for_file: invalid_use_of_protected_member

import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/app.dart';

extension ProviderExtension<T> on $Notifier<T> {
  AppGlobalModel get appGlobalModel => ref.read(appGlobalModelProvider.notifier);

  AppGlobalState get appGlobalState => ref.read(appGlobalModelProvider);

  Box<dynamic>? get appConfBox => appGlobalState.appConfBox;
}
