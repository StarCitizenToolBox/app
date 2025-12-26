// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_ui_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthUIState {

 bool get isLoading; bool get isLoggedIn; bool get isWaitingForConnection; String? get domain; String? get callbackUrl; String? get stateParameter; String? get nonce; String? get code; String? get error; bool get isDomainTrusted; String? get domainName;
/// Create a copy of AuthUIState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthUIStateCopyWith<AuthUIState> get copyWith => _$AuthUIStateCopyWithImpl<AuthUIState>(this as AuthUIState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthUIState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isLoggedIn, isLoggedIn) || other.isLoggedIn == isLoggedIn)&&(identical(other.isWaitingForConnection, isWaitingForConnection) || other.isWaitingForConnection == isWaitingForConnection)&&(identical(other.domain, domain) || other.domain == domain)&&(identical(other.callbackUrl, callbackUrl) || other.callbackUrl == callbackUrl)&&(identical(other.stateParameter, stateParameter) || other.stateParameter == stateParameter)&&(identical(other.nonce, nonce) || other.nonce == nonce)&&(identical(other.code, code) || other.code == code)&&(identical(other.error, error) || other.error == error)&&(identical(other.isDomainTrusted, isDomainTrusted) || other.isDomainTrusted == isDomainTrusted)&&(identical(other.domainName, domainName) || other.domainName == domainName));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,isLoggedIn,isWaitingForConnection,domain,callbackUrl,stateParameter,nonce,code,error,isDomainTrusted,domainName);

@override
String toString() {
  return 'AuthUIState(isLoading: $isLoading, isLoggedIn: $isLoggedIn, isWaitingForConnection: $isWaitingForConnection, domain: $domain, callbackUrl: $callbackUrl, stateParameter: $stateParameter, nonce: $nonce, code: $code, error: $error, isDomainTrusted: $isDomainTrusted, domainName: $domainName)';
}


}

/// @nodoc
abstract mixin class $AuthUIStateCopyWith<$Res>  {
  factory $AuthUIStateCopyWith(AuthUIState value, $Res Function(AuthUIState) _then) = _$AuthUIStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool isLoggedIn, bool isWaitingForConnection, String? domain, String? callbackUrl, String? stateParameter, String? nonce, String? code, String? error, bool isDomainTrusted, String? domainName
});




}
/// @nodoc
class _$AuthUIStateCopyWithImpl<$Res>
    implements $AuthUIStateCopyWith<$Res> {
  _$AuthUIStateCopyWithImpl(this._self, this._then);

  final AuthUIState _self;
  final $Res Function(AuthUIState) _then;

/// Create a copy of AuthUIState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? isLoggedIn = null,Object? isWaitingForConnection = null,Object? domain = freezed,Object? callbackUrl = freezed,Object? stateParameter = freezed,Object? nonce = freezed,Object? code = freezed,Object? error = freezed,Object? isDomainTrusted = null,Object? domainName = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isLoggedIn: null == isLoggedIn ? _self.isLoggedIn : isLoggedIn // ignore: cast_nullable_to_non_nullable
as bool,isWaitingForConnection: null == isWaitingForConnection ? _self.isWaitingForConnection : isWaitingForConnection // ignore: cast_nullable_to_non_nullable
as bool,domain: freezed == domain ? _self.domain : domain // ignore: cast_nullable_to_non_nullable
as String?,callbackUrl: freezed == callbackUrl ? _self.callbackUrl : callbackUrl // ignore: cast_nullable_to_non_nullable
as String?,stateParameter: freezed == stateParameter ? _self.stateParameter : stateParameter // ignore: cast_nullable_to_non_nullable
as String?,nonce: freezed == nonce ? _self.nonce : nonce // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,isDomainTrusted: null == isDomainTrusted ? _self.isDomainTrusted : isDomainTrusted // ignore: cast_nullable_to_non_nullable
as bool,domainName: freezed == domainName ? _self.domainName : domainName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthUIState].
extension AuthUIStatePatterns on AuthUIState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthUIState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthUIState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthUIState value)  $default,){
final _that = this;
switch (_that) {
case _AuthUIState():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthUIState value)?  $default,){
final _that = this;
switch (_that) {
case _AuthUIState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool isLoggedIn,  bool isWaitingForConnection,  String? domain,  String? callbackUrl,  String? stateParameter,  String? nonce,  String? code,  String? error,  bool isDomainTrusted,  String? domainName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthUIState() when $default != null:
return $default(_that.isLoading,_that.isLoggedIn,_that.isWaitingForConnection,_that.domain,_that.callbackUrl,_that.stateParameter,_that.nonce,_that.code,_that.error,_that.isDomainTrusted,_that.domainName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool isLoggedIn,  bool isWaitingForConnection,  String? domain,  String? callbackUrl,  String? stateParameter,  String? nonce,  String? code,  String? error,  bool isDomainTrusted,  String? domainName)  $default,) {final _that = this;
switch (_that) {
case _AuthUIState():
return $default(_that.isLoading,_that.isLoggedIn,_that.isWaitingForConnection,_that.domain,_that.callbackUrl,_that.stateParameter,_that.nonce,_that.code,_that.error,_that.isDomainTrusted,_that.domainName);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool isLoggedIn,  bool isWaitingForConnection,  String? domain,  String? callbackUrl,  String? stateParameter,  String? nonce,  String? code,  String? error,  bool isDomainTrusted,  String? domainName)?  $default,) {final _that = this;
switch (_that) {
case _AuthUIState() when $default != null:
return $default(_that.isLoading,_that.isLoggedIn,_that.isWaitingForConnection,_that.domain,_that.callbackUrl,_that.stateParameter,_that.nonce,_that.code,_that.error,_that.isDomainTrusted,_that.domainName);case _:
  return null;

}
}

}

/// @nodoc


class _AuthUIState implements AuthUIState {
  const _AuthUIState({this.isLoading = false, this.isLoggedIn = false, this.isWaitingForConnection = false, this.domain, this.callbackUrl, this.stateParameter, this.nonce, this.code, this.error, this.isDomainTrusted = false, this.domainName});
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isLoggedIn;
@override@JsonKey() final  bool isWaitingForConnection;
@override final  String? domain;
@override final  String? callbackUrl;
@override final  String? stateParameter;
@override final  String? nonce;
@override final  String? code;
@override final  String? error;
@override@JsonKey() final  bool isDomainTrusted;
@override final  String? domainName;

/// Create a copy of AuthUIState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthUIStateCopyWith<_AuthUIState> get copyWith => __$AuthUIStateCopyWithImpl<_AuthUIState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthUIState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isLoggedIn, isLoggedIn) || other.isLoggedIn == isLoggedIn)&&(identical(other.isWaitingForConnection, isWaitingForConnection) || other.isWaitingForConnection == isWaitingForConnection)&&(identical(other.domain, domain) || other.domain == domain)&&(identical(other.callbackUrl, callbackUrl) || other.callbackUrl == callbackUrl)&&(identical(other.stateParameter, stateParameter) || other.stateParameter == stateParameter)&&(identical(other.nonce, nonce) || other.nonce == nonce)&&(identical(other.code, code) || other.code == code)&&(identical(other.error, error) || other.error == error)&&(identical(other.isDomainTrusted, isDomainTrusted) || other.isDomainTrusted == isDomainTrusted)&&(identical(other.domainName, domainName) || other.domainName == domainName));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,isLoggedIn,isWaitingForConnection,domain,callbackUrl,stateParameter,nonce,code,error,isDomainTrusted,domainName);

@override
String toString() {
  return 'AuthUIState(isLoading: $isLoading, isLoggedIn: $isLoggedIn, isWaitingForConnection: $isWaitingForConnection, domain: $domain, callbackUrl: $callbackUrl, stateParameter: $stateParameter, nonce: $nonce, code: $code, error: $error, isDomainTrusted: $isDomainTrusted, domainName: $domainName)';
}


}

/// @nodoc
abstract mixin class _$AuthUIStateCopyWith<$Res> implements $AuthUIStateCopyWith<$Res> {
  factory _$AuthUIStateCopyWith(_AuthUIState value, $Res Function(_AuthUIState) _then) = __$AuthUIStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool isLoggedIn, bool isWaitingForConnection, String? domain, String? callbackUrl, String? stateParameter, String? nonce, String? code, String? error, bool isDomainTrusted, String? domainName
});




}
/// @nodoc
class __$AuthUIStateCopyWithImpl<$Res>
    implements _$AuthUIStateCopyWith<$Res> {
  __$AuthUIStateCopyWithImpl(this._self, this._then);

  final _AuthUIState _self;
  final $Res Function(_AuthUIState) _then;

/// Create a copy of AuthUIState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? isLoggedIn = null,Object? isWaitingForConnection = null,Object? domain = freezed,Object? callbackUrl = freezed,Object? stateParameter = freezed,Object? nonce = freezed,Object? code = freezed,Object? error = freezed,Object? isDomainTrusted = null,Object? domainName = freezed,}) {
  return _then(_AuthUIState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isLoggedIn: null == isLoggedIn ? _self.isLoggedIn : isLoggedIn // ignore: cast_nullable_to_non_nullable
as bool,isWaitingForConnection: null == isWaitingForConnection ? _self.isWaitingForConnection : isWaitingForConnection // ignore: cast_nullable_to_non_nullable
as bool,domain: freezed == domain ? _self.domain : domain // ignore: cast_nullable_to_non_nullable
as String?,callbackUrl: freezed == callbackUrl ? _self.callbackUrl : callbackUrl // ignore: cast_nullable_to_non_nullable
as String?,stateParameter: freezed == stateParameter ? _self.stateParameter : stateParameter // ignore: cast_nullable_to_non_nullable
as String?,nonce: freezed == nonce ? _self.nonce : nonce // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,isDomainTrusted: null == isDomainTrusted ? _self.isDomainTrusted : isDomainTrusted // ignore: cast_nullable_to_non_nullable
as bool,domainName: freezed == domainName ? _self.domainName : domainName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
