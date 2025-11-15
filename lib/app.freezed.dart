// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppGlobalState {

 String? get deviceUUID; String? get applicationSupportDir; String? get applicationBinaryModuleDir; AppVersionData? get networkVersionData; ThemeConf get themeConf; Locale? get appLocale; Box? get appConfBox; dynamic get windowsVersion;
/// Create a copy of AppGlobalState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppGlobalStateCopyWith<AppGlobalState> get copyWith => _$AppGlobalStateCopyWithImpl<AppGlobalState>(this as AppGlobalState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppGlobalState&&(identical(other.deviceUUID, deviceUUID) || other.deviceUUID == deviceUUID)&&(identical(other.applicationSupportDir, applicationSupportDir) || other.applicationSupportDir == applicationSupportDir)&&(identical(other.applicationBinaryModuleDir, applicationBinaryModuleDir) || other.applicationBinaryModuleDir == applicationBinaryModuleDir)&&(identical(other.networkVersionData, networkVersionData) || other.networkVersionData == networkVersionData)&&(identical(other.themeConf, themeConf) || other.themeConf == themeConf)&&(identical(other.appLocale, appLocale) || other.appLocale == appLocale)&&(identical(other.appConfBox, appConfBox) || other.appConfBox == appConfBox)&&const DeepCollectionEquality().equals(other.windowsVersion, windowsVersion));
}


@override
int get hashCode => Object.hash(runtimeType,deviceUUID,applicationSupportDir,applicationBinaryModuleDir,networkVersionData,themeConf,appLocale,appConfBox,const DeepCollectionEquality().hash(windowsVersion));

@override
String toString() {
  return 'AppGlobalState(deviceUUID: $deviceUUID, applicationSupportDir: $applicationSupportDir, applicationBinaryModuleDir: $applicationBinaryModuleDir, networkVersionData: $networkVersionData, themeConf: $themeConf, appLocale: $appLocale, appConfBox: $appConfBox, windowsVersion: $windowsVersion)';
}


}

/// @nodoc
abstract mixin class $AppGlobalStateCopyWith<$Res>  {
  factory $AppGlobalStateCopyWith(AppGlobalState value, $Res Function(AppGlobalState) _then) = _$AppGlobalStateCopyWithImpl;
@useResult
$Res call({
 String? deviceUUID, String? applicationSupportDir, String? applicationBinaryModuleDir, AppVersionData? networkVersionData, ThemeConf themeConf, Locale? appLocale, Box? appConfBox, dynamic windowsVersion
});


$ThemeConfCopyWith<$Res> get themeConf;

}
/// @nodoc
class _$AppGlobalStateCopyWithImpl<$Res>
    implements $AppGlobalStateCopyWith<$Res> {
  _$AppGlobalStateCopyWithImpl(this._self, this._then);

  final AppGlobalState _self;
  final $Res Function(AppGlobalState) _then;

/// Create a copy of AppGlobalState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceUUID = freezed,Object? applicationSupportDir = freezed,Object? applicationBinaryModuleDir = freezed,Object? networkVersionData = freezed,Object? themeConf = null,Object? appLocale = freezed,Object? appConfBox = freezed,Object? windowsVersion = freezed,}) {
  return _then(_self.copyWith(
deviceUUID: freezed == deviceUUID ? _self.deviceUUID : deviceUUID // ignore: cast_nullable_to_non_nullable
as String?,applicationSupportDir: freezed == applicationSupportDir ? _self.applicationSupportDir : applicationSupportDir // ignore: cast_nullable_to_non_nullable
as String?,applicationBinaryModuleDir: freezed == applicationBinaryModuleDir ? _self.applicationBinaryModuleDir : applicationBinaryModuleDir // ignore: cast_nullable_to_non_nullable
as String?,networkVersionData: freezed == networkVersionData ? _self.networkVersionData : networkVersionData // ignore: cast_nullable_to_non_nullable
as AppVersionData?,themeConf: null == themeConf ? _self.themeConf : themeConf // ignore: cast_nullable_to_non_nullable
as ThemeConf,appLocale: freezed == appLocale ? _self.appLocale : appLocale // ignore: cast_nullable_to_non_nullable
as Locale?,appConfBox: freezed == appConfBox ? _self.appConfBox : appConfBox // ignore: cast_nullable_to_non_nullable
as Box?,windowsVersion: freezed == windowsVersion ? _self.windowsVersion : windowsVersion // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}
/// Create a copy of AppGlobalState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ThemeConfCopyWith<$Res> get themeConf {
  
  return $ThemeConfCopyWith<$Res>(_self.themeConf, (value) {
    return _then(_self.copyWith(themeConf: value));
  });
}
}


/// Adds pattern-matching-related methods to [AppGlobalState].
extension AppGlobalStatePatterns on AppGlobalState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppGlobalState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppGlobalState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppGlobalState value)  $default,){
final _that = this;
switch (_that) {
case _AppGlobalState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppGlobalState value)?  $default,){
final _that = this;
switch (_that) {
case _AppGlobalState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? deviceUUID,  String? applicationSupportDir,  String? applicationBinaryModuleDir,  AppVersionData? networkVersionData,  ThemeConf themeConf,  Locale? appLocale,  Box? appConfBox,  dynamic windowsVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppGlobalState() when $default != null:
return $default(_that.deviceUUID,_that.applicationSupportDir,_that.applicationBinaryModuleDir,_that.networkVersionData,_that.themeConf,_that.appLocale,_that.appConfBox,_that.windowsVersion);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? deviceUUID,  String? applicationSupportDir,  String? applicationBinaryModuleDir,  AppVersionData? networkVersionData,  ThemeConf themeConf,  Locale? appLocale,  Box? appConfBox,  dynamic windowsVersion)  $default,) {final _that = this;
switch (_that) {
case _AppGlobalState():
return $default(_that.deviceUUID,_that.applicationSupportDir,_that.applicationBinaryModuleDir,_that.networkVersionData,_that.themeConf,_that.appLocale,_that.appConfBox,_that.windowsVersion);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? deviceUUID,  String? applicationSupportDir,  String? applicationBinaryModuleDir,  AppVersionData? networkVersionData,  ThemeConf themeConf,  Locale? appLocale,  Box? appConfBox,  dynamic windowsVersion)?  $default,) {final _that = this;
switch (_that) {
case _AppGlobalState() when $default != null:
return $default(_that.deviceUUID,_that.applicationSupportDir,_that.applicationBinaryModuleDir,_that.networkVersionData,_that.themeConf,_that.appLocale,_that.appConfBox,_that.windowsVersion);case _:
  return null;

}
}

}

/// @nodoc


class _AppGlobalState implements AppGlobalState {
  const _AppGlobalState({this.deviceUUID, this.applicationSupportDir, this.applicationBinaryModuleDir, this.networkVersionData, this.themeConf = const ThemeConf(), this.appLocale, this.appConfBox, this.windowsVersion = 10});
  

@override final  String? deviceUUID;
@override final  String? applicationSupportDir;
@override final  String? applicationBinaryModuleDir;
@override final  AppVersionData? networkVersionData;
@override@JsonKey() final  ThemeConf themeConf;
@override final  Locale? appLocale;
@override final  Box? appConfBox;
@override@JsonKey() final  dynamic windowsVersion;

/// Create a copy of AppGlobalState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppGlobalStateCopyWith<_AppGlobalState> get copyWith => __$AppGlobalStateCopyWithImpl<_AppGlobalState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppGlobalState&&(identical(other.deviceUUID, deviceUUID) || other.deviceUUID == deviceUUID)&&(identical(other.applicationSupportDir, applicationSupportDir) || other.applicationSupportDir == applicationSupportDir)&&(identical(other.applicationBinaryModuleDir, applicationBinaryModuleDir) || other.applicationBinaryModuleDir == applicationBinaryModuleDir)&&(identical(other.networkVersionData, networkVersionData) || other.networkVersionData == networkVersionData)&&(identical(other.themeConf, themeConf) || other.themeConf == themeConf)&&(identical(other.appLocale, appLocale) || other.appLocale == appLocale)&&(identical(other.appConfBox, appConfBox) || other.appConfBox == appConfBox)&&const DeepCollectionEquality().equals(other.windowsVersion, windowsVersion));
}


@override
int get hashCode => Object.hash(runtimeType,deviceUUID,applicationSupportDir,applicationBinaryModuleDir,networkVersionData,themeConf,appLocale,appConfBox,const DeepCollectionEquality().hash(windowsVersion));

@override
String toString() {
  return 'AppGlobalState(deviceUUID: $deviceUUID, applicationSupportDir: $applicationSupportDir, applicationBinaryModuleDir: $applicationBinaryModuleDir, networkVersionData: $networkVersionData, themeConf: $themeConf, appLocale: $appLocale, appConfBox: $appConfBox, windowsVersion: $windowsVersion)';
}


}

/// @nodoc
abstract mixin class _$AppGlobalStateCopyWith<$Res> implements $AppGlobalStateCopyWith<$Res> {
  factory _$AppGlobalStateCopyWith(_AppGlobalState value, $Res Function(_AppGlobalState) _then) = __$AppGlobalStateCopyWithImpl;
@override @useResult
$Res call({
 String? deviceUUID, String? applicationSupportDir, String? applicationBinaryModuleDir, AppVersionData? networkVersionData, ThemeConf themeConf, Locale? appLocale, Box? appConfBox, dynamic windowsVersion
});


@override $ThemeConfCopyWith<$Res> get themeConf;

}
/// @nodoc
class __$AppGlobalStateCopyWithImpl<$Res>
    implements _$AppGlobalStateCopyWith<$Res> {
  __$AppGlobalStateCopyWithImpl(this._self, this._then);

  final _AppGlobalState _self;
  final $Res Function(_AppGlobalState) _then;

/// Create a copy of AppGlobalState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceUUID = freezed,Object? applicationSupportDir = freezed,Object? applicationBinaryModuleDir = freezed,Object? networkVersionData = freezed,Object? themeConf = null,Object? appLocale = freezed,Object? appConfBox = freezed,Object? windowsVersion = freezed,}) {
  return _then(_AppGlobalState(
deviceUUID: freezed == deviceUUID ? _self.deviceUUID : deviceUUID // ignore: cast_nullable_to_non_nullable
as String?,applicationSupportDir: freezed == applicationSupportDir ? _self.applicationSupportDir : applicationSupportDir // ignore: cast_nullable_to_non_nullable
as String?,applicationBinaryModuleDir: freezed == applicationBinaryModuleDir ? _self.applicationBinaryModuleDir : applicationBinaryModuleDir // ignore: cast_nullable_to_non_nullable
as String?,networkVersionData: freezed == networkVersionData ? _self.networkVersionData : networkVersionData // ignore: cast_nullable_to_non_nullable
as AppVersionData?,themeConf: null == themeConf ? _self.themeConf : themeConf // ignore: cast_nullable_to_non_nullable
as ThemeConf,appLocale: freezed == appLocale ? _self.appLocale : appLocale // ignore: cast_nullable_to_non_nullable
as Locale?,appConfBox: freezed == appConfBox ? _self.appConfBox : appConfBox // ignore: cast_nullable_to_non_nullable
as Box?,windowsVersion: freezed == windowsVersion ? _self.windowsVersion : windowsVersion // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}

/// Create a copy of AppGlobalState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ThemeConfCopyWith<$Res> get themeConf {
  
  return $ThemeConfCopyWith<$Res>(_self.themeConf, (value) {
    return _then(_self.copyWith(themeConf: value));
  });
}
}

/// @nodoc
mixin _$ThemeConf {

 Color get backgroundColor; Color get menuColor; Color get micaColor;
/// Create a copy of ThemeConf
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThemeConfCopyWith<ThemeConf> get copyWith => _$ThemeConfCopyWithImpl<ThemeConf>(this as ThemeConf, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThemeConf&&(identical(other.backgroundColor, backgroundColor) || other.backgroundColor == backgroundColor)&&(identical(other.menuColor, menuColor) || other.menuColor == menuColor)&&(identical(other.micaColor, micaColor) || other.micaColor == micaColor));
}


@override
int get hashCode => Object.hash(runtimeType,backgroundColor,menuColor,micaColor);

@override
String toString() {
  return 'ThemeConf(backgroundColor: $backgroundColor, menuColor: $menuColor, micaColor: $micaColor)';
}


}

/// @nodoc
abstract mixin class $ThemeConfCopyWith<$Res>  {
  factory $ThemeConfCopyWith(ThemeConf value, $Res Function(ThemeConf) _then) = _$ThemeConfCopyWithImpl;
@useResult
$Res call({
 Color backgroundColor, Color menuColor, Color micaColor
});




}
/// @nodoc
class _$ThemeConfCopyWithImpl<$Res>
    implements $ThemeConfCopyWith<$Res> {
  _$ThemeConfCopyWithImpl(this._self, this._then);

  final ThemeConf _self;
  final $Res Function(ThemeConf) _then;

/// Create a copy of ThemeConf
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? backgroundColor = null,Object? menuColor = null,Object? micaColor = null,}) {
  return _then(_self.copyWith(
backgroundColor: null == backgroundColor ? _self.backgroundColor : backgroundColor // ignore: cast_nullable_to_non_nullable
as Color,menuColor: null == menuColor ? _self.menuColor : menuColor // ignore: cast_nullable_to_non_nullable
as Color,micaColor: null == micaColor ? _self.micaColor : micaColor // ignore: cast_nullable_to_non_nullable
as Color,
  ));
}

}


/// Adds pattern-matching-related methods to [ThemeConf].
extension ThemeConfPatterns on ThemeConf {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ThemeConf value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ThemeConf() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ThemeConf value)  $default,){
final _that = this;
switch (_that) {
case _ThemeConf():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ThemeConf value)?  $default,){
final _that = this;
switch (_that) {
case _ThemeConf() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Color backgroundColor,  Color menuColor,  Color micaColor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ThemeConf() when $default != null:
return $default(_that.backgroundColor,_that.menuColor,_that.micaColor);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Color backgroundColor,  Color menuColor,  Color micaColor)  $default,) {final _that = this;
switch (_that) {
case _ThemeConf():
return $default(_that.backgroundColor,_that.menuColor,_that.micaColor);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Color backgroundColor,  Color menuColor,  Color micaColor)?  $default,) {final _that = this;
switch (_that) {
case _ThemeConf() when $default != null:
return $default(_that.backgroundColor,_that.menuColor,_that.micaColor);case _:
  return null;

}
}

}

/// @nodoc


class _ThemeConf implements ThemeConf {
  const _ThemeConf({this.backgroundColor = const Color(0xbf132431), this.menuColor = const Color(0xf2132431), this.micaColor = const Color(0xff0a3142)});
  

@override@JsonKey() final  Color backgroundColor;
@override@JsonKey() final  Color menuColor;
@override@JsonKey() final  Color micaColor;

/// Create a copy of ThemeConf
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ThemeConfCopyWith<_ThemeConf> get copyWith => __$ThemeConfCopyWithImpl<_ThemeConf>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ThemeConf&&(identical(other.backgroundColor, backgroundColor) || other.backgroundColor == backgroundColor)&&(identical(other.menuColor, menuColor) || other.menuColor == menuColor)&&(identical(other.micaColor, micaColor) || other.micaColor == micaColor));
}


@override
int get hashCode => Object.hash(runtimeType,backgroundColor,menuColor,micaColor);

@override
String toString() {
  return 'ThemeConf(backgroundColor: $backgroundColor, menuColor: $menuColor, micaColor: $micaColor)';
}


}

/// @nodoc
abstract mixin class _$ThemeConfCopyWith<$Res> implements $ThemeConfCopyWith<$Res> {
  factory _$ThemeConfCopyWith(_ThemeConf value, $Res Function(_ThemeConf) _then) = __$ThemeConfCopyWithImpl;
@override @useResult
$Res call({
 Color backgroundColor, Color menuColor, Color micaColor
});




}
/// @nodoc
class __$ThemeConfCopyWithImpl<$Res>
    implements _$ThemeConfCopyWith<$Res> {
  __$ThemeConfCopyWithImpl(this._self, this._then);

  final _ThemeConf _self;
  final $Res Function(_ThemeConf) _then;

/// Create a copy of ThemeConf
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? backgroundColor = null,Object? menuColor = null,Object? micaColor = null,}) {
  return _then(_ThemeConf(
backgroundColor: null == backgroundColor ? _self.backgroundColor : backgroundColor // ignore: cast_nullable_to_non_nullable
as Color,menuColor: null == menuColor ? _self.menuColor : menuColor // ignore: cast_nullable_to_non_nullable
as Color,micaColor: null == micaColor ? _self.micaColor : micaColor // ignore: cast_nullable_to_non_nullable
as Color,
  ));
}


}

// dart format on
