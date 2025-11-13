// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
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

 String get version; dynamic get data; String get serverData; bool get isPatchInstalled; String? get enabledLocalization; bool? get enableDownloaderBoost;
/// Create a copy of RSILauncherStateData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RSILauncherStateDataCopyWith<RSILauncherStateData> get copyWith => _$RSILauncherStateDataCopyWithImpl<RSILauncherStateData>(this as RSILauncherStateData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RSILauncherStateData&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.serverData, serverData) || other.serverData == serverData)&&(identical(other.isPatchInstalled, isPatchInstalled) || other.isPatchInstalled == isPatchInstalled)&&(identical(other.enabledLocalization, enabledLocalization) || other.enabledLocalization == enabledLocalization)&&(identical(other.enableDownloaderBoost, enableDownloaderBoost) || other.enableDownloaderBoost == enableDownloaderBoost));
}


@override
int get hashCode => Object.hash(runtimeType,version,const DeepCollectionEquality().hash(data),serverData,isPatchInstalled,enabledLocalization,enableDownloaderBoost);

@override
String toString() {
  return 'RSILauncherStateData(version: $version, data: $data, serverData: $serverData, isPatchInstalled: $isPatchInstalled, enabledLocalization: $enabledLocalization, enableDownloaderBoost: $enableDownloaderBoost)';
}


}

/// @nodoc
abstract mixin class $RSILauncherStateDataCopyWith<$Res>  {
  factory $RSILauncherStateDataCopyWith(RSILauncherStateData value, $Res Function(RSILauncherStateData) _then) = _$RSILauncherStateDataCopyWithImpl;
@useResult
$Res call({
 String version, dynamic data, String serverData, bool isPatchInstalled, String? enabledLocalization, bool? enableDownloaderBoost
});




}
/// @nodoc
class _$RSILauncherStateDataCopyWithImpl<$Res>
    implements $RSILauncherStateDataCopyWith<$Res> {
  _$RSILauncherStateDataCopyWithImpl(this._self, this._then);

  final RSILauncherStateData _self;
  final $Res Function(RSILauncherStateData) _then;

/// Create a copy of RSILauncherStateData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? data = freezed,Object? serverData = null,Object? isPatchInstalled = null,Object? enabledLocalization = freezed,Object? enableDownloaderBoost = freezed,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as dynamic,serverData: null == serverData ? _self.serverData : serverData // ignore: cast_nullable_to_non_nullable
as String,isPatchInstalled: null == isPatchInstalled ? _self.isPatchInstalled : isPatchInstalled // ignore: cast_nullable_to_non_nullable
as bool,enabledLocalization: freezed == enabledLocalization ? _self.enabledLocalization : enabledLocalization // ignore: cast_nullable_to_non_nullable
as String?,enableDownloaderBoost: freezed == enableDownloaderBoost ? _self.enableDownloaderBoost : enableDownloaderBoost // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [RSILauncherStateData].
extension RSILauncherStateDataPatterns on RSILauncherStateData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RSILauncherStateData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RSILauncherStateData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RSILauncherStateData value)  $default,){
final _that = this;
switch (_that) {
case _RSILauncherStateData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RSILauncherStateData value)?  $default,){
final _that = this;
switch (_that) {
case _RSILauncherStateData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String version,  dynamic data,  String serverData,  bool isPatchInstalled,  String? enabledLocalization,  bool? enableDownloaderBoost)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RSILauncherStateData() when $default != null:
return $default(_that.version,_that.data,_that.serverData,_that.isPatchInstalled,_that.enabledLocalization,_that.enableDownloaderBoost);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String version,  dynamic data,  String serverData,  bool isPatchInstalled,  String? enabledLocalization,  bool? enableDownloaderBoost)  $default,) {final _that = this;
switch (_that) {
case _RSILauncherStateData():
return $default(_that.version,_that.data,_that.serverData,_that.isPatchInstalled,_that.enabledLocalization,_that.enableDownloaderBoost);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String version,  dynamic data,  String serverData,  bool isPatchInstalled,  String? enabledLocalization,  bool? enableDownloaderBoost)?  $default,) {final _that = this;
switch (_that) {
case _RSILauncherStateData() when $default != null:
return $default(_that.version,_that.data,_that.serverData,_that.isPatchInstalled,_that.enabledLocalization,_that.enableDownloaderBoost);case _:
  return null;

}
}

}

/// @nodoc


class _RSILauncherStateData implements RSILauncherStateData {
  const _RSILauncherStateData({required this.version, required this.data, required this.serverData, this.isPatchInstalled = false, this.enabledLocalization, this.enableDownloaderBoost});
  

@override final  String version;
@override final  dynamic data;
@override final  String serverData;
@override@JsonKey() final  bool isPatchInstalled;
@override final  String? enabledLocalization;
@override final  bool? enableDownloaderBoost;

/// Create a copy of RSILauncherStateData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RSILauncherStateDataCopyWith<_RSILauncherStateData> get copyWith => __$RSILauncherStateDataCopyWithImpl<_RSILauncherStateData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RSILauncherStateData&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.serverData, serverData) || other.serverData == serverData)&&(identical(other.isPatchInstalled, isPatchInstalled) || other.isPatchInstalled == isPatchInstalled)&&(identical(other.enabledLocalization, enabledLocalization) || other.enabledLocalization == enabledLocalization)&&(identical(other.enableDownloaderBoost, enableDownloaderBoost) || other.enableDownloaderBoost == enableDownloaderBoost));
}


@override
int get hashCode => Object.hash(runtimeType,version,const DeepCollectionEquality().hash(data),serverData,isPatchInstalled,enabledLocalization,enableDownloaderBoost);

@override
String toString() {
  return 'RSILauncherStateData(version: $version, data: $data, serverData: $serverData, isPatchInstalled: $isPatchInstalled, enabledLocalization: $enabledLocalization, enableDownloaderBoost: $enableDownloaderBoost)';
}


}

/// @nodoc
abstract mixin class _$RSILauncherStateDataCopyWith<$Res> implements $RSILauncherStateDataCopyWith<$Res> {
  factory _$RSILauncherStateDataCopyWith(_RSILauncherStateData value, $Res Function(_RSILauncherStateData) _then) = __$RSILauncherStateDataCopyWithImpl;
@override @useResult
$Res call({
 String version, dynamic data, String serverData, bool isPatchInstalled, String? enabledLocalization, bool? enableDownloaderBoost
});




}
/// @nodoc
class __$RSILauncherStateDataCopyWithImpl<$Res>
    implements _$RSILauncherStateDataCopyWith<$Res> {
  __$RSILauncherStateDataCopyWithImpl(this._self, this._then);

  final _RSILauncherStateData _self;
  final $Res Function(_RSILauncherStateData) _then;

/// Create a copy of RSILauncherStateData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? data = freezed,Object? serverData = null,Object? isPatchInstalled = null,Object? enabledLocalization = freezed,Object? enableDownloaderBoost = freezed,}) {
  return _then(_RSILauncherStateData(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as dynamic,serverData: null == serverData ? _self.serverData : serverData // ignore: cast_nullable_to_non_nullable
as String,isPatchInstalled: null == isPatchInstalled ? _self.isPatchInstalled : isPatchInstalled // ignore: cast_nullable_to_non_nullable
as bool,enabledLocalization: freezed == enabledLocalization ? _self.enabledLocalization : enabledLocalization // ignore: cast_nullable_to_non_nullable
as String?,enableDownloaderBoost: freezed == enableDownloaderBoost ? _self.enableDownloaderBoost : enableDownloaderBoost // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
