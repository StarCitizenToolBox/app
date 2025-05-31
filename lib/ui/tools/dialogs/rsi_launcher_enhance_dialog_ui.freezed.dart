// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rsi_launcher_enhance_dialog_ui.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RSILauncherStateData {
  String get version;
  asar_api.RsiLauncherAsarData get data;
  String get serverData;
  bool get isPatchInstalled;
  String? get enabledLocalization;
  bool? get enableDownloaderBoost;

  /// Create a copy of RSILauncherStateData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RSILauncherStateDataCopyWith<RSILauncherStateData> get copyWith =>
      _$RSILauncherStateDataCopyWithImpl<RSILauncherStateData>(
          this as RSILauncherStateData, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RSILauncherStateData &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.serverData, serverData) ||
                other.serverData == serverData) &&
            (identical(other.isPatchInstalled, isPatchInstalled) ||
                other.isPatchInstalled == isPatchInstalled) &&
            (identical(other.enabledLocalization, enabledLocalization) ||
                other.enabledLocalization == enabledLocalization) &&
            (identical(other.enableDownloaderBoost, enableDownloaderBoost) ||
                other.enableDownloaderBoost == enableDownloaderBoost));
  }

  @override
  int get hashCode => Object.hash(runtimeType, version, data, serverData,
      isPatchInstalled, enabledLocalization, enableDownloaderBoost);

  @override
  String toString() {
    return 'RSILauncherStateData(version: $version, data: $data, serverData: $serverData, isPatchInstalled: $isPatchInstalled, enabledLocalization: $enabledLocalization, enableDownloaderBoost: $enableDownloaderBoost)';
  }
}

/// @nodoc
abstract mixin class $RSILauncherStateDataCopyWith<$Res> {
  factory $RSILauncherStateDataCopyWith(RSILauncherStateData value,
          $Res Function(RSILauncherStateData) _then) =
      _$RSILauncherStateDataCopyWithImpl;
  @useResult
  $Res call(
      {String version,
      asar_api.RsiLauncherAsarData data,
      String serverData,
      bool isPatchInstalled,
      String? enabledLocalization,
      bool? enableDownloaderBoost});
}

/// @nodoc
class _$RSILauncherStateDataCopyWithImpl<$Res>
    implements $RSILauncherStateDataCopyWith<$Res> {
  _$RSILauncherStateDataCopyWithImpl(this._self, this._then);

  final RSILauncherStateData _self;
  final $Res Function(RSILauncherStateData) _then;

  /// Create a copy of RSILauncherStateData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? data = null,
    Object? serverData = null,
    Object? isPatchInstalled = null,
    Object? enabledLocalization = freezed,
    Object? enableDownloaderBoost = freezed,
  }) {
    return _then(_self.copyWith(
      version: null == version
          ? _self.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as asar_api.RsiLauncherAsarData,
      serverData: null == serverData
          ? _self.serverData
          : serverData // ignore: cast_nullable_to_non_nullable
              as String,
      isPatchInstalled: null == isPatchInstalled
          ? _self.isPatchInstalled
          : isPatchInstalled // ignore: cast_nullable_to_non_nullable
              as bool,
      enabledLocalization: freezed == enabledLocalization
          ? _self.enabledLocalization
          : enabledLocalization // ignore: cast_nullable_to_non_nullable
              as String?,
      enableDownloaderBoost: freezed == enableDownloaderBoost
          ? _self.enableDownloaderBoost
          : enableDownloaderBoost // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc

class _RSILauncherStateData implements RSILauncherStateData {
  const _RSILauncherStateData(
      {required this.version,
      required this.data,
      required this.serverData,
      this.isPatchInstalled = false,
      this.enabledLocalization,
      this.enableDownloaderBoost});

  @override
  final String version;
  @override
  final asar_api.RsiLauncherAsarData data;
  @override
  final String serverData;
  @override
  @JsonKey()
  final bool isPatchInstalled;
  @override
  final String? enabledLocalization;
  @override
  final bool? enableDownloaderBoost;

  /// Create a copy of RSILauncherStateData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RSILauncherStateDataCopyWith<_RSILauncherStateData> get copyWith =>
      __$RSILauncherStateDataCopyWithImpl<_RSILauncherStateData>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RSILauncherStateData &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.serverData, serverData) ||
                other.serverData == serverData) &&
            (identical(other.isPatchInstalled, isPatchInstalled) ||
                other.isPatchInstalled == isPatchInstalled) &&
            (identical(other.enabledLocalization, enabledLocalization) ||
                other.enabledLocalization == enabledLocalization) &&
            (identical(other.enableDownloaderBoost, enableDownloaderBoost) ||
                other.enableDownloaderBoost == enableDownloaderBoost));
  }

  @override
  int get hashCode => Object.hash(runtimeType, version, data, serverData,
      isPatchInstalled, enabledLocalization, enableDownloaderBoost);

  @override
  String toString() {
    return 'RSILauncherStateData(version: $version, data: $data, serverData: $serverData, isPatchInstalled: $isPatchInstalled, enabledLocalization: $enabledLocalization, enableDownloaderBoost: $enableDownloaderBoost)';
  }
}

/// @nodoc
abstract mixin class _$RSILauncherStateDataCopyWith<$Res>
    implements $RSILauncherStateDataCopyWith<$Res> {
  factory _$RSILauncherStateDataCopyWith(_RSILauncherStateData value,
          $Res Function(_RSILauncherStateData) _then) =
      __$RSILauncherStateDataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String version,
      asar_api.RsiLauncherAsarData data,
      String serverData,
      bool isPatchInstalled,
      String? enabledLocalization,
      bool? enableDownloaderBoost});
}

/// @nodoc
class __$RSILauncherStateDataCopyWithImpl<$Res>
    implements _$RSILauncherStateDataCopyWith<$Res> {
  __$RSILauncherStateDataCopyWithImpl(this._self, this._then);

  final _RSILauncherStateData _self;
  final $Res Function(_RSILauncherStateData) _then;

  /// Create a copy of RSILauncherStateData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? version = null,
    Object? data = null,
    Object? serverData = null,
    Object? isPatchInstalled = null,
    Object? enabledLocalization = freezed,
    Object? enableDownloaderBoost = freezed,
  }) {
    return _then(_RSILauncherStateData(
      version: null == version
          ? _self.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as asar_api.RsiLauncherAsarData,
      serverData: null == serverData
          ? _self.serverData
          : serverData // ignore: cast_nullable_to_non_nullable
              as String,
      isPatchInstalled: null == isPatchInstalled
          ? _self.isPatchInstalled
          : isPatchInstalled // ignore: cast_nullable_to_non_nullable
              as bool,
      enabledLocalization: freezed == enabledLocalization
          ? _self.enabledLocalization
          : enabledLocalization // ignore: cast_nullable_to_non_nullable
              as String?,
      enableDownloaderBoost: freezed == enableDownloaderBoost
          ? _self.enableDownloaderBoost
          : enableDownloaderBoost // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

// dart format on
