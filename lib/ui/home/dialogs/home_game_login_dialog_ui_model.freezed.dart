// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_game_login_dialog_ui_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeGameLoginState {

 int get loginStatus; String? get nickname; String? get avatarUrl; String? get authToken; String? get webToken; Map? get releaseInfo; RsiGameLibraryData? get libraryData; String? get installPath; bool? get isDeviceSupportWinHello;
/// Create a copy of HomeGameLoginState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeGameLoginStateCopyWith<HomeGameLoginState> get copyWith => _$HomeGameLoginStateCopyWithImpl<HomeGameLoginState>(this as HomeGameLoginState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeGameLoginState&&(identical(other.loginStatus, loginStatus) || other.loginStatus == loginStatus)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.authToken, authToken) || other.authToken == authToken)&&(identical(other.webToken, webToken) || other.webToken == webToken)&&const DeepCollectionEquality().equals(other.releaseInfo, releaseInfo)&&(identical(other.libraryData, libraryData) || other.libraryData == libraryData)&&(identical(other.installPath, installPath) || other.installPath == installPath)&&(identical(other.isDeviceSupportWinHello, isDeviceSupportWinHello) || other.isDeviceSupportWinHello == isDeviceSupportWinHello));
}


@override
int get hashCode => Object.hash(runtimeType,loginStatus,nickname,avatarUrl,authToken,webToken,const DeepCollectionEquality().hash(releaseInfo),libraryData,installPath,isDeviceSupportWinHello);

@override
String toString() {
  return 'HomeGameLoginState(loginStatus: $loginStatus, nickname: $nickname, avatarUrl: $avatarUrl, authToken: $authToken, webToken: $webToken, releaseInfo: $releaseInfo, libraryData: $libraryData, installPath: $installPath, isDeviceSupportWinHello: $isDeviceSupportWinHello)';
}


}

/// @nodoc
abstract mixin class $HomeGameLoginStateCopyWith<$Res>  {
  factory $HomeGameLoginStateCopyWith(HomeGameLoginState value, $Res Function(HomeGameLoginState) _then) = _$HomeGameLoginStateCopyWithImpl;
@useResult
$Res call({
 int loginStatus, String? nickname, String? avatarUrl, String? authToken, String? webToken, Map? releaseInfo, RsiGameLibraryData? libraryData, String? installPath, bool? isDeviceSupportWinHello
});




}
/// @nodoc
class _$HomeGameLoginStateCopyWithImpl<$Res>
    implements $HomeGameLoginStateCopyWith<$Res> {
  _$HomeGameLoginStateCopyWithImpl(this._self, this._then);

  final HomeGameLoginState _self;
  final $Res Function(HomeGameLoginState) _then;

/// Create a copy of HomeGameLoginState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loginStatus = null,Object? nickname = freezed,Object? avatarUrl = freezed,Object? authToken = freezed,Object? webToken = freezed,Object? releaseInfo = freezed,Object? libraryData = freezed,Object? installPath = freezed,Object? isDeviceSupportWinHello = freezed,}) {
  return _then(_self.copyWith(
loginStatus: null == loginStatus ? _self.loginStatus : loginStatus // ignore: cast_nullable_to_non_nullable
as int,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,authToken: freezed == authToken ? _self.authToken : authToken // ignore: cast_nullable_to_non_nullable
as String?,webToken: freezed == webToken ? _self.webToken : webToken // ignore: cast_nullable_to_non_nullable
as String?,releaseInfo: freezed == releaseInfo ? _self.releaseInfo : releaseInfo // ignore: cast_nullable_to_non_nullable
as Map?,libraryData: freezed == libraryData ? _self.libraryData : libraryData // ignore: cast_nullable_to_non_nullable
as RsiGameLibraryData?,installPath: freezed == installPath ? _self.installPath : installPath // ignore: cast_nullable_to_non_nullable
as String?,isDeviceSupportWinHello: freezed == isDeviceSupportWinHello ? _self.isDeviceSupportWinHello : isDeviceSupportWinHello // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeGameLoginState].
extension HomeGameLoginStatePatterns on HomeGameLoginState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginStatus value)  $default,){
final _that = this;
switch (_that) {
case _LoginStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginStatus value)?  $default,){
final _that = this;
switch (_that) {
case _LoginStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int loginStatus,  String? nickname,  String? avatarUrl,  String? authToken,  String? webToken,  Map? releaseInfo,  RsiGameLibraryData? libraryData,  String? installPath,  bool? isDeviceSupportWinHello)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginStatus() when $default != null:
return $default(_that.loginStatus,_that.nickname,_that.avatarUrl,_that.authToken,_that.webToken,_that.releaseInfo,_that.libraryData,_that.installPath,_that.isDeviceSupportWinHello);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int loginStatus,  String? nickname,  String? avatarUrl,  String? authToken,  String? webToken,  Map? releaseInfo,  RsiGameLibraryData? libraryData,  String? installPath,  bool? isDeviceSupportWinHello)  $default,) {final _that = this;
switch (_that) {
case _LoginStatus():
return $default(_that.loginStatus,_that.nickname,_that.avatarUrl,_that.authToken,_that.webToken,_that.releaseInfo,_that.libraryData,_that.installPath,_that.isDeviceSupportWinHello);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int loginStatus,  String? nickname,  String? avatarUrl,  String? authToken,  String? webToken,  Map? releaseInfo,  RsiGameLibraryData? libraryData,  String? installPath,  bool? isDeviceSupportWinHello)?  $default,) {final _that = this;
switch (_that) {
case _LoginStatus() when $default != null:
return $default(_that.loginStatus,_that.nickname,_that.avatarUrl,_that.authToken,_that.webToken,_that.releaseInfo,_that.libraryData,_that.installPath,_that.isDeviceSupportWinHello);case _:
  return null;

}
}

}

/// @nodoc


class _LoginStatus implements HomeGameLoginState {
   _LoginStatus({required this.loginStatus, this.nickname, this.avatarUrl, this.authToken, this.webToken, final  Map? releaseInfo, this.libraryData, this.installPath, this.isDeviceSupportWinHello}): _releaseInfo = releaseInfo;
  

@override final  int loginStatus;
@override final  String? nickname;
@override final  String? avatarUrl;
@override final  String? authToken;
@override final  String? webToken;
 final  Map? _releaseInfo;
@override Map? get releaseInfo {
  final value = _releaseInfo;
  if (value == null) return null;
  if (_releaseInfo is EqualUnmodifiableMapView) return _releaseInfo;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  RsiGameLibraryData? libraryData;
@override final  String? installPath;
@override final  bool? isDeviceSupportWinHello;

/// Create a copy of HomeGameLoginState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginStatusCopyWith<_LoginStatus> get copyWith => __$LoginStatusCopyWithImpl<_LoginStatus>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginStatus&&(identical(other.loginStatus, loginStatus) || other.loginStatus == loginStatus)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.authToken, authToken) || other.authToken == authToken)&&(identical(other.webToken, webToken) || other.webToken == webToken)&&const DeepCollectionEquality().equals(other._releaseInfo, _releaseInfo)&&(identical(other.libraryData, libraryData) || other.libraryData == libraryData)&&(identical(other.installPath, installPath) || other.installPath == installPath)&&(identical(other.isDeviceSupportWinHello, isDeviceSupportWinHello) || other.isDeviceSupportWinHello == isDeviceSupportWinHello));
}


@override
int get hashCode => Object.hash(runtimeType,loginStatus,nickname,avatarUrl,authToken,webToken,const DeepCollectionEquality().hash(_releaseInfo),libraryData,installPath,isDeviceSupportWinHello);

@override
String toString() {
  return 'HomeGameLoginState(loginStatus: $loginStatus, nickname: $nickname, avatarUrl: $avatarUrl, authToken: $authToken, webToken: $webToken, releaseInfo: $releaseInfo, libraryData: $libraryData, installPath: $installPath, isDeviceSupportWinHello: $isDeviceSupportWinHello)';
}


}

/// @nodoc
abstract mixin class _$LoginStatusCopyWith<$Res> implements $HomeGameLoginStateCopyWith<$Res> {
  factory _$LoginStatusCopyWith(_LoginStatus value, $Res Function(_LoginStatus) _then) = __$LoginStatusCopyWithImpl;
@override @useResult
$Res call({
 int loginStatus, String? nickname, String? avatarUrl, String? authToken, String? webToken, Map? releaseInfo, RsiGameLibraryData? libraryData, String? installPath, bool? isDeviceSupportWinHello
});




}
/// @nodoc
class __$LoginStatusCopyWithImpl<$Res>
    implements _$LoginStatusCopyWith<$Res> {
  __$LoginStatusCopyWithImpl(this._self, this._then);

  final _LoginStatus _self;
  final $Res Function(_LoginStatus) _then;

/// Create a copy of HomeGameLoginState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loginStatus = null,Object? nickname = freezed,Object? avatarUrl = freezed,Object? authToken = freezed,Object? webToken = freezed,Object? releaseInfo = freezed,Object? libraryData = freezed,Object? installPath = freezed,Object? isDeviceSupportWinHello = freezed,}) {
  return _then(_LoginStatus(
loginStatus: null == loginStatus ? _self.loginStatus : loginStatus // ignore: cast_nullable_to_non_nullable
as int,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,authToken: freezed == authToken ? _self.authToken : authToken // ignore: cast_nullable_to_non_nullable
as String?,webToken: freezed == webToken ? _self.webToken : webToken // ignore: cast_nullable_to_non_nullable
as String?,releaseInfo: freezed == releaseInfo ? _self._releaseInfo : releaseInfo // ignore: cast_nullable_to_non_nullable
as Map?,libraryData: freezed == libraryData ? _self.libraryData : libraryData // ignore: cast_nullable_to_non_nullable
as RsiGameLibraryData?,installPath: freezed == installPath ? _self.installPath : installPath // ignore: cast_nullable_to_non_nullable
as String?,isDeviceSupportWinHello: freezed == isDeviceSupportWinHello ? _self.isDeviceSupportWinHello : isDeviceSupportWinHello // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
