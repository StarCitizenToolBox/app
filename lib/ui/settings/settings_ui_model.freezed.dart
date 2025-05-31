// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_ui_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SettingsUIState {
  bool get isEnableToolSiteMirrors;
  String get inputGameLaunchECore;
  String? get customLauncherPath;
  String? get customGamePath;
  int get locationCacheSize;
  bool get isUseInternalDNS;

  /// Create a copy of SettingsUIState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SettingsUIStateCopyWith<SettingsUIState> get copyWith =>
      _$SettingsUIStateCopyWithImpl<SettingsUIState>(
          this as SettingsUIState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SettingsUIState &&
            (identical(
                    other.isEnableToolSiteMirrors, isEnableToolSiteMirrors) ||
                other.isEnableToolSiteMirrors == isEnableToolSiteMirrors) &&
            (identical(other.inputGameLaunchECore, inputGameLaunchECore) ||
                other.inputGameLaunchECore == inputGameLaunchECore) &&
            (identical(other.customLauncherPath, customLauncherPath) ||
                other.customLauncherPath == customLauncherPath) &&
            (identical(other.customGamePath, customGamePath) ||
                other.customGamePath == customGamePath) &&
            (identical(other.locationCacheSize, locationCacheSize) ||
                other.locationCacheSize == locationCacheSize) &&
            (identical(other.isUseInternalDNS, isUseInternalDNS) ||
                other.isUseInternalDNS == isUseInternalDNS));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isEnableToolSiteMirrors,
      inputGameLaunchECore,
      customLauncherPath,
      customGamePath,
      locationCacheSize,
      isUseInternalDNS);

  @override
  String toString() {
    return 'SettingsUIState(isEnableToolSiteMirrors: $isEnableToolSiteMirrors, inputGameLaunchECore: $inputGameLaunchECore, customLauncherPath: $customLauncherPath, customGamePath: $customGamePath, locationCacheSize: $locationCacheSize, isUseInternalDNS: $isUseInternalDNS)';
  }
}

/// @nodoc
abstract mixin class $SettingsUIStateCopyWith<$Res> {
  factory $SettingsUIStateCopyWith(
          SettingsUIState value, $Res Function(SettingsUIState) _then) =
      _$SettingsUIStateCopyWithImpl;
  @useResult
  $Res call(
      {bool isEnableToolSiteMirrors,
      String inputGameLaunchECore,
      String? customLauncherPath,
      String? customGamePath,
      int locationCacheSize,
      bool isUseInternalDNS});
}

/// @nodoc
class _$SettingsUIStateCopyWithImpl<$Res>
    implements $SettingsUIStateCopyWith<$Res> {
  _$SettingsUIStateCopyWithImpl(this._self, this._then);

  final SettingsUIState _self;
  final $Res Function(SettingsUIState) _then;

  /// Create a copy of SettingsUIState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isEnableToolSiteMirrors = null,
    Object? inputGameLaunchECore = null,
    Object? customLauncherPath = freezed,
    Object? customGamePath = freezed,
    Object? locationCacheSize = null,
    Object? isUseInternalDNS = null,
  }) {
    return _then(_self.copyWith(
      isEnableToolSiteMirrors: null == isEnableToolSiteMirrors
          ? _self.isEnableToolSiteMirrors
          : isEnableToolSiteMirrors // ignore: cast_nullable_to_non_nullable
              as bool,
      inputGameLaunchECore: null == inputGameLaunchECore
          ? _self.inputGameLaunchECore
          : inputGameLaunchECore // ignore: cast_nullable_to_non_nullable
              as String,
      customLauncherPath: freezed == customLauncherPath
          ? _self.customLauncherPath
          : customLauncherPath // ignore: cast_nullable_to_non_nullable
              as String?,
      customGamePath: freezed == customGamePath
          ? _self.customGamePath
          : customGamePath // ignore: cast_nullable_to_non_nullable
              as String?,
      locationCacheSize: null == locationCacheSize
          ? _self.locationCacheSize
          : locationCacheSize // ignore: cast_nullable_to_non_nullable
              as int,
      isUseInternalDNS: null == isUseInternalDNS
          ? _self.isUseInternalDNS
          : isUseInternalDNS // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _SettingsUIState implements SettingsUIState {
  _SettingsUIState(
      {this.isEnableToolSiteMirrors = false,
      this.inputGameLaunchECore = "0",
      this.customLauncherPath,
      this.customGamePath,
      this.locationCacheSize = 0,
      this.isUseInternalDNS = false});

  @override
  @JsonKey()
  final bool isEnableToolSiteMirrors;
  @override
  @JsonKey()
  final String inputGameLaunchECore;
  @override
  final String? customLauncherPath;
  @override
  final String? customGamePath;
  @override
  @JsonKey()
  final int locationCacheSize;
  @override
  @JsonKey()
  final bool isUseInternalDNS;

  /// Create a copy of SettingsUIState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SettingsUIStateCopyWith<_SettingsUIState> get copyWith =>
      __$SettingsUIStateCopyWithImpl<_SettingsUIState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SettingsUIState &&
            (identical(
                    other.isEnableToolSiteMirrors, isEnableToolSiteMirrors) ||
                other.isEnableToolSiteMirrors == isEnableToolSiteMirrors) &&
            (identical(other.inputGameLaunchECore, inputGameLaunchECore) ||
                other.inputGameLaunchECore == inputGameLaunchECore) &&
            (identical(other.customLauncherPath, customLauncherPath) ||
                other.customLauncherPath == customLauncherPath) &&
            (identical(other.customGamePath, customGamePath) ||
                other.customGamePath == customGamePath) &&
            (identical(other.locationCacheSize, locationCacheSize) ||
                other.locationCacheSize == locationCacheSize) &&
            (identical(other.isUseInternalDNS, isUseInternalDNS) ||
                other.isUseInternalDNS == isUseInternalDNS));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isEnableToolSiteMirrors,
      inputGameLaunchECore,
      customLauncherPath,
      customGamePath,
      locationCacheSize,
      isUseInternalDNS);

  @override
  String toString() {
    return 'SettingsUIState(isEnableToolSiteMirrors: $isEnableToolSiteMirrors, inputGameLaunchECore: $inputGameLaunchECore, customLauncherPath: $customLauncherPath, customGamePath: $customGamePath, locationCacheSize: $locationCacheSize, isUseInternalDNS: $isUseInternalDNS)';
  }
}

/// @nodoc
abstract mixin class _$SettingsUIStateCopyWith<$Res>
    implements $SettingsUIStateCopyWith<$Res> {
  factory _$SettingsUIStateCopyWith(
          _SettingsUIState value, $Res Function(_SettingsUIState) _then) =
      __$SettingsUIStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool isEnableToolSiteMirrors,
      String inputGameLaunchECore,
      String? customLauncherPath,
      String? customGamePath,
      int locationCacheSize,
      bool isUseInternalDNS});
}

/// @nodoc
class __$SettingsUIStateCopyWithImpl<$Res>
    implements _$SettingsUIStateCopyWith<$Res> {
  __$SettingsUIStateCopyWithImpl(this._self, this._then);

  final _SettingsUIState _self;
  final $Res Function(_SettingsUIState) _then;

  /// Create a copy of SettingsUIState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isEnableToolSiteMirrors = null,
    Object? inputGameLaunchECore = null,
    Object? customLauncherPath = freezed,
    Object? customGamePath = freezed,
    Object? locationCacheSize = null,
    Object? isUseInternalDNS = null,
  }) {
    return _then(_SettingsUIState(
      isEnableToolSiteMirrors: null == isEnableToolSiteMirrors
          ? _self.isEnableToolSiteMirrors
          : isEnableToolSiteMirrors // ignore: cast_nullable_to_non_nullable
              as bool,
      inputGameLaunchECore: null == inputGameLaunchECore
          ? _self.inputGameLaunchECore
          : inputGameLaunchECore // ignore: cast_nullable_to_non_nullable
              as String,
      customLauncherPath: freezed == customLauncherPath
          ? _self.customLauncherPath
          : customLauncherPath // ignore: cast_nullable_to_non_nullable
              as String?,
      customGamePath: freezed == customGamePath
          ? _self.customGamePath
          : customGamePath // ignore: cast_nullable_to_non_nullable
              as String?,
      locationCacheSize: null == locationCacheSize
          ? _self.locationCacheSize
          : locationCacheSize // ignore: cast_nullable_to_non_nullable
              as int,
      isUseInternalDNS: null == isUseInternalDNS
          ? _self.isUseInternalDNS
          : isUseInternalDNS // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
