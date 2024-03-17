// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppGlobalState {
  String? get deviceUUID => throw _privateConstructorUsedError;
  String? get applicationSupportDir => throw _privateConstructorUsedError;
  String? get applicationBinaryModuleDir => throw _privateConstructorUsedError;
  AppVersionData? get networkVersionData => throw _privateConstructorUsedError;
  ThemeConf get themeConf => throw _privateConstructorUsedError;
  Locale? get appLocale => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AppGlobalStateCopyWith<AppGlobalState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppGlobalStateCopyWith<$Res> {
  factory $AppGlobalStateCopyWith(
          AppGlobalState value, $Res Function(AppGlobalState) then) =
      _$AppGlobalStateCopyWithImpl<$Res, AppGlobalState>;
  @useResult
  $Res call(
      {String? deviceUUID,
      String? applicationSupportDir,
      String? applicationBinaryModuleDir,
      AppVersionData? networkVersionData,
      ThemeConf themeConf,
      Locale? appLocale});

  $ThemeConfCopyWith<$Res> get themeConf;
}

/// @nodoc
class _$AppGlobalStateCopyWithImpl<$Res, $Val extends AppGlobalState>
    implements $AppGlobalStateCopyWith<$Res> {
  _$AppGlobalStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceUUID = freezed,
    Object? applicationSupportDir = freezed,
    Object? applicationBinaryModuleDir = freezed,
    Object? networkVersionData = freezed,
    Object? themeConf = null,
    Object? appLocale = freezed,
  }) {
    return _then(_value.copyWith(
      deviceUUID: freezed == deviceUUID
          ? _value.deviceUUID
          : deviceUUID // ignore: cast_nullable_to_non_nullable
              as String?,
      applicationSupportDir: freezed == applicationSupportDir
          ? _value.applicationSupportDir
          : applicationSupportDir // ignore: cast_nullable_to_non_nullable
              as String?,
      applicationBinaryModuleDir: freezed == applicationBinaryModuleDir
          ? _value.applicationBinaryModuleDir
          : applicationBinaryModuleDir // ignore: cast_nullable_to_non_nullable
              as String?,
      networkVersionData: freezed == networkVersionData
          ? _value.networkVersionData
          : networkVersionData // ignore: cast_nullable_to_non_nullable
              as AppVersionData?,
      themeConf: null == themeConf
          ? _value.themeConf
          : themeConf // ignore: cast_nullable_to_non_nullable
              as ThemeConf,
      appLocale: freezed == appLocale
          ? _value.appLocale
          : appLocale // ignore: cast_nullable_to_non_nullable
              as Locale?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ThemeConfCopyWith<$Res> get themeConf {
    return $ThemeConfCopyWith<$Res>(_value.themeConf, (value) {
      return _then(_value.copyWith(themeConf: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AppGlobalStateImplCopyWith<$Res>
    implements $AppGlobalStateCopyWith<$Res> {
  factory _$$AppGlobalStateImplCopyWith(_$AppGlobalStateImpl value,
          $Res Function(_$AppGlobalStateImpl) then) =
      __$$AppGlobalStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? deviceUUID,
      String? applicationSupportDir,
      String? applicationBinaryModuleDir,
      AppVersionData? networkVersionData,
      ThemeConf themeConf,
      Locale? appLocale});

  @override
  $ThemeConfCopyWith<$Res> get themeConf;
}

/// @nodoc
class __$$AppGlobalStateImplCopyWithImpl<$Res>
    extends _$AppGlobalStateCopyWithImpl<$Res, _$AppGlobalStateImpl>
    implements _$$AppGlobalStateImplCopyWith<$Res> {
  __$$AppGlobalStateImplCopyWithImpl(
      _$AppGlobalStateImpl _value, $Res Function(_$AppGlobalStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceUUID = freezed,
    Object? applicationSupportDir = freezed,
    Object? applicationBinaryModuleDir = freezed,
    Object? networkVersionData = freezed,
    Object? themeConf = null,
    Object? appLocale = freezed,
  }) {
    return _then(_$AppGlobalStateImpl(
      deviceUUID: freezed == deviceUUID
          ? _value.deviceUUID
          : deviceUUID // ignore: cast_nullable_to_non_nullable
              as String?,
      applicationSupportDir: freezed == applicationSupportDir
          ? _value.applicationSupportDir
          : applicationSupportDir // ignore: cast_nullable_to_non_nullable
              as String?,
      applicationBinaryModuleDir: freezed == applicationBinaryModuleDir
          ? _value.applicationBinaryModuleDir
          : applicationBinaryModuleDir // ignore: cast_nullable_to_non_nullable
              as String?,
      networkVersionData: freezed == networkVersionData
          ? _value.networkVersionData
          : networkVersionData // ignore: cast_nullable_to_non_nullable
              as AppVersionData?,
      themeConf: null == themeConf
          ? _value.themeConf
          : themeConf // ignore: cast_nullable_to_non_nullable
              as ThemeConf,
      appLocale: freezed == appLocale
          ? _value.appLocale
          : appLocale // ignore: cast_nullable_to_non_nullable
              as Locale?,
    ));
  }
}

/// @nodoc

class _$AppGlobalStateImpl implements _AppGlobalState {
  const _$AppGlobalStateImpl(
      {this.deviceUUID,
      this.applicationSupportDir,
      this.applicationBinaryModuleDir,
      this.networkVersionData,
      this.themeConf = const ThemeConf(),
      this.appLocale});

  @override
  final String? deviceUUID;
  @override
  final String? applicationSupportDir;
  @override
  final String? applicationBinaryModuleDir;
  @override
  final AppVersionData? networkVersionData;
  @override
  @JsonKey()
  final ThemeConf themeConf;
  @override
  final Locale? appLocale;

  @override
  String toString() {
    return 'AppGlobalState(deviceUUID: $deviceUUID, applicationSupportDir: $applicationSupportDir, applicationBinaryModuleDir: $applicationBinaryModuleDir, networkVersionData: $networkVersionData, themeConf: $themeConf, appLocale: $appLocale)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppGlobalStateImpl &&
            (identical(other.deviceUUID, deviceUUID) ||
                other.deviceUUID == deviceUUID) &&
            (identical(other.applicationSupportDir, applicationSupportDir) ||
                other.applicationSupportDir == applicationSupportDir) &&
            (identical(other.applicationBinaryModuleDir,
                    applicationBinaryModuleDir) ||
                other.applicationBinaryModuleDir ==
                    applicationBinaryModuleDir) &&
            (identical(other.networkVersionData, networkVersionData) ||
                other.networkVersionData == networkVersionData) &&
            (identical(other.themeConf, themeConf) ||
                other.themeConf == themeConf) &&
            (identical(other.appLocale, appLocale) ||
                other.appLocale == appLocale));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      deviceUUID,
      applicationSupportDir,
      applicationBinaryModuleDir,
      networkVersionData,
      themeConf,
      appLocale);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppGlobalStateImplCopyWith<_$AppGlobalStateImpl> get copyWith =>
      __$$AppGlobalStateImplCopyWithImpl<_$AppGlobalStateImpl>(
          this, _$identity);
}

abstract class _AppGlobalState implements AppGlobalState {
  const factory _AppGlobalState(
      {final String? deviceUUID,
      final String? applicationSupportDir,
      final String? applicationBinaryModuleDir,
      final AppVersionData? networkVersionData,
      final ThemeConf themeConf,
      final Locale? appLocale}) = _$AppGlobalStateImpl;

  @override
  String? get deviceUUID;
  @override
  String? get applicationSupportDir;
  @override
  String? get applicationBinaryModuleDir;
  @override
  AppVersionData? get networkVersionData;
  @override
  ThemeConf get themeConf;
  @override
  Locale? get appLocale;
  @override
  @JsonKey(ignore: true)
  _$$AppGlobalStateImplCopyWith<_$AppGlobalStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ThemeConf {
  Color get backgroundColor => throw _privateConstructorUsedError;
  Color get menuColor => throw _privateConstructorUsedError;
  Color get micaColor => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ThemeConfCopyWith<ThemeConf> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ThemeConfCopyWith<$Res> {
  factory $ThemeConfCopyWith(ThemeConf value, $Res Function(ThemeConf) then) =
      _$ThemeConfCopyWithImpl<$Res, ThemeConf>;
  @useResult
  $Res call({Color backgroundColor, Color menuColor, Color micaColor});
}

/// @nodoc
class _$ThemeConfCopyWithImpl<$Res, $Val extends ThemeConf>
    implements $ThemeConfCopyWith<$Res> {
  _$ThemeConfCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? backgroundColor = null,
    Object? menuColor = null,
    Object? micaColor = null,
  }) {
    return _then(_value.copyWith(
      backgroundColor: null == backgroundColor
          ? _value.backgroundColor
          : backgroundColor // ignore: cast_nullable_to_non_nullable
              as Color,
      menuColor: null == menuColor
          ? _value.menuColor
          : menuColor // ignore: cast_nullable_to_non_nullable
              as Color,
      micaColor: null == micaColor
          ? _value.micaColor
          : micaColor // ignore: cast_nullable_to_non_nullable
              as Color,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ThemeConfImplCopyWith<$Res>
    implements $ThemeConfCopyWith<$Res> {
  factory _$$ThemeConfImplCopyWith(
          _$ThemeConfImpl value, $Res Function(_$ThemeConfImpl) then) =
      __$$ThemeConfImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Color backgroundColor, Color menuColor, Color micaColor});
}

/// @nodoc
class __$$ThemeConfImplCopyWithImpl<$Res>
    extends _$ThemeConfCopyWithImpl<$Res, _$ThemeConfImpl>
    implements _$$ThemeConfImplCopyWith<$Res> {
  __$$ThemeConfImplCopyWithImpl(
      _$ThemeConfImpl _value, $Res Function(_$ThemeConfImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? backgroundColor = null,
    Object? menuColor = null,
    Object? micaColor = null,
  }) {
    return _then(_$ThemeConfImpl(
      backgroundColor: null == backgroundColor
          ? _value.backgroundColor
          : backgroundColor // ignore: cast_nullable_to_non_nullable
              as Color,
      menuColor: null == menuColor
          ? _value.menuColor
          : menuColor // ignore: cast_nullable_to_non_nullable
              as Color,
      micaColor: null == micaColor
          ? _value.micaColor
          : micaColor // ignore: cast_nullable_to_non_nullable
              as Color,
    ));
  }
}

/// @nodoc

class _$ThemeConfImpl implements _ThemeConf {
  const _$ThemeConfImpl(
      {this.backgroundColor = const Color(0xbf132431),
      this.menuColor = const Color(0xf2132431),
      this.micaColor = const Color(0xff0a3142)});

  @override
  @JsonKey()
  final Color backgroundColor;
  @override
  @JsonKey()
  final Color menuColor;
  @override
  @JsonKey()
  final Color micaColor;

  @override
  String toString() {
    return 'ThemeConf(backgroundColor: $backgroundColor, menuColor: $menuColor, micaColor: $micaColor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ThemeConfImpl &&
            (identical(other.backgroundColor, backgroundColor) ||
                other.backgroundColor == backgroundColor) &&
            (identical(other.menuColor, menuColor) ||
                other.menuColor == menuColor) &&
            (identical(other.micaColor, micaColor) ||
                other.micaColor == micaColor));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, backgroundColor, menuColor, micaColor);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ThemeConfImplCopyWith<_$ThemeConfImpl> get copyWith =>
      __$$ThemeConfImplCopyWithImpl<_$ThemeConfImpl>(this, _$identity);
}

abstract class _ThemeConf implements ThemeConf {
  const factory _ThemeConf(
      {final Color backgroundColor,
      final Color menuColor,
      final Color micaColor}) = _$ThemeConfImpl;

  @override
  Color get backgroundColor;
  @override
  Color get menuColor;
  @override
  Color get micaColor;
  @override
  @JsonKey(ignore: true)
  _$$ThemeConfImplCopyWith<_$ThemeConfImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
