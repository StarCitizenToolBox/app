// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rsi_launcher_enhance_dialog_ui.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RSILauncherStateData {
  String get version => throw _privateConstructorUsedError;
  asar_api.RsiLauncherAsarData get data => throw _privateConstructorUsedError;
  String get serverData => throw _privateConstructorUsedError;
  bool get isPatchInstalled => throw _privateConstructorUsedError;
  String? get enabledLocalization => throw _privateConstructorUsedError;
  bool? get enableDownloaderBoost => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RSILauncherStateDataCopyWith<RSILauncherStateData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RSILauncherStateDataCopyWith<$Res> {
  factory $RSILauncherStateDataCopyWith(RSILauncherStateData value,
          $Res Function(RSILauncherStateData) then) =
      _$RSILauncherStateDataCopyWithImpl<$Res, RSILauncherStateData>;
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
class _$RSILauncherStateDataCopyWithImpl<$Res,
        $Val extends RSILauncherStateData>
    implements $RSILauncherStateDataCopyWith<$Res> {
  _$RSILauncherStateDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as asar_api.RsiLauncherAsarData,
      serverData: null == serverData
          ? _value.serverData
          : serverData // ignore: cast_nullable_to_non_nullable
              as String,
      isPatchInstalled: null == isPatchInstalled
          ? _value.isPatchInstalled
          : isPatchInstalled // ignore: cast_nullable_to_non_nullable
              as bool,
      enabledLocalization: freezed == enabledLocalization
          ? _value.enabledLocalization
          : enabledLocalization // ignore: cast_nullable_to_non_nullable
              as String?,
      enableDownloaderBoost: freezed == enableDownloaderBoost
          ? _value.enableDownloaderBoost
          : enableDownloaderBoost // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RSILauncherStateDataImplCopyWith<$Res>
    implements $RSILauncherStateDataCopyWith<$Res> {
  factory _$$RSILauncherStateDataImplCopyWith(_$RSILauncherStateDataImpl value,
          $Res Function(_$RSILauncherStateDataImpl) then) =
      __$$RSILauncherStateDataImplCopyWithImpl<$Res>;
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
class __$$RSILauncherStateDataImplCopyWithImpl<$Res>
    extends _$RSILauncherStateDataCopyWithImpl<$Res, _$RSILauncherStateDataImpl>
    implements _$$RSILauncherStateDataImplCopyWith<$Res> {
  __$$RSILauncherStateDataImplCopyWithImpl(_$RSILauncherStateDataImpl _value,
      $Res Function(_$RSILauncherStateDataImpl) _then)
      : super(_value, _then);

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
    return _then(_$RSILauncherStateDataImpl(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as asar_api.RsiLauncherAsarData,
      serverData: null == serverData
          ? _value.serverData
          : serverData // ignore: cast_nullable_to_non_nullable
              as String,
      isPatchInstalled: null == isPatchInstalled
          ? _value.isPatchInstalled
          : isPatchInstalled // ignore: cast_nullable_to_non_nullable
              as bool,
      enabledLocalization: freezed == enabledLocalization
          ? _value.enabledLocalization
          : enabledLocalization // ignore: cast_nullable_to_non_nullable
              as String?,
      enableDownloaderBoost: freezed == enableDownloaderBoost
          ? _value.enableDownloaderBoost
          : enableDownloaderBoost // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc

class _$RSILauncherStateDataImpl implements _RSILauncherStateData {
  const _$RSILauncherStateDataImpl(
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

  @override
  String toString() {
    return 'RSILauncherStateData(version: $version, data: $data, serverData: $serverData, isPatchInstalled: $isPatchInstalled, enabledLocalization: $enabledLocalization, enableDownloaderBoost: $enableDownloaderBoost)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RSILauncherStateDataImpl &&
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

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RSILauncherStateDataImplCopyWith<_$RSILauncherStateDataImpl>
      get copyWith =>
          __$$RSILauncherStateDataImplCopyWithImpl<_$RSILauncherStateDataImpl>(
              this, _$identity);
}

abstract class _RSILauncherStateData implements RSILauncherStateData {
  const factory _RSILauncherStateData(
      {required final String version,
      required final asar_api.RsiLauncherAsarData data,
      required final String serverData,
      final bool isPatchInstalled,
      final String? enabledLocalization,
      final bool? enableDownloaderBoost}) = _$RSILauncherStateDataImpl;

  @override
  String get version;
  @override
  asar_api.RsiLauncherAsarData get data;
  @override
  String get serverData;
  @override
  bool get isPatchInstalled;
  @override
  String? get enabledLocalization;
  @override
  bool? get enableDownloaderBoost;
  @override
  @JsonKey(ignore: true)
  _$$RSILauncherStateDataImplCopyWith<_$RSILauncherStateDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}
