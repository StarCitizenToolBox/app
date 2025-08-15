// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InputMethodServerState {

 bool get isServerStartup; String? get serverAddressText;
/// Create a copy of InputMethodServerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InputMethodServerStateCopyWith<InputMethodServerState> get copyWith => _$InputMethodServerStateCopyWithImpl<InputMethodServerState>(this as InputMethodServerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InputMethodServerState&&(identical(other.isServerStartup, isServerStartup) || other.isServerStartup == isServerStartup)&&(identical(other.serverAddressText, serverAddressText) || other.serverAddressText == serverAddressText));
}


@override
int get hashCode => Object.hash(runtimeType,isServerStartup,serverAddressText);

@override
String toString() {
  return 'InputMethodServerState(isServerStartup: $isServerStartup, serverAddressText: $serverAddressText)';
}


}

/// @nodoc
abstract mixin class $InputMethodServerStateCopyWith<$Res>  {
  factory $InputMethodServerStateCopyWith(InputMethodServerState value, $Res Function(InputMethodServerState) _then) = _$InputMethodServerStateCopyWithImpl;
@useResult
$Res call({
 bool isServerStartup, String? serverAddressText
});




}
/// @nodoc
class _$InputMethodServerStateCopyWithImpl<$Res>
    implements $InputMethodServerStateCopyWith<$Res> {
  _$InputMethodServerStateCopyWithImpl(this._self, this._then);

  final InputMethodServerState _self;
  final $Res Function(InputMethodServerState) _then;

/// Create a copy of InputMethodServerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isServerStartup = null,Object? serverAddressText = freezed,}) {
  return _then(_self.copyWith(
isServerStartup: null == isServerStartup ? _self.isServerStartup : isServerStartup // ignore: cast_nullable_to_non_nullable
as bool,serverAddressText: freezed == serverAddressText ? _self.serverAddressText : serverAddressText // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [InputMethodServerState].
extension InputMethodServerStatePatterns on InputMethodServerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InputMethodServerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InputMethodServerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InputMethodServerState value)  $default,){
final _that = this;
switch (_that) {
case _InputMethodServerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InputMethodServerState value)?  $default,){
final _that = this;
switch (_that) {
case _InputMethodServerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isServerStartup,  String? serverAddressText)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InputMethodServerState() when $default != null:
return $default(_that.isServerStartup,_that.serverAddressText);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isServerStartup,  String? serverAddressText)  $default,) {final _that = this;
switch (_that) {
case _InputMethodServerState():
return $default(_that.isServerStartup,_that.serverAddressText);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isServerStartup,  String? serverAddressText)?  $default,) {final _that = this;
switch (_that) {
case _InputMethodServerState() when $default != null:
return $default(_that.isServerStartup,_that.serverAddressText);case _:
  return null;

}
}

}

/// @nodoc


class _InputMethodServerState implements InputMethodServerState {
  const _InputMethodServerState({this.isServerStartup = false, this.serverAddressText});
  

@override@JsonKey() final  bool isServerStartup;
@override final  String? serverAddressText;

/// Create a copy of InputMethodServerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InputMethodServerStateCopyWith<_InputMethodServerState> get copyWith => __$InputMethodServerStateCopyWithImpl<_InputMethodServerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InputMethodServerState&&(identical(other.isServerStartup, isServerStartup) || other.isServerStartup == isServerStartup)&&(identical(other.serverAddressText, serverAddressText) || other.serverAddressText == serverAddressText));
}


@override
int get hashCode => Object.hash(runtimeType,isServerStartup,serverAddressText);

@override
String toString() {
  return 'InputMethodServerState(isServerStartup: $isServerStartup, serverAddressText: $serverAddressText)';
}


}

/// @nodoc
abstract mixin class _$InputMethodServerStateCopyWith<$Res> implements $InputMethodServerStateCopyWith<$Res> {
  factory _$InputMethodServerStateCopyWith(_InputMethodServerState value, $Res Function(_InputMethodServerState) _then) = __$InputMethodServerStateCopyWithImpl;
@override @useResult
$Res call({
 bool isServerStartup, String? serverAddressText
});




}
/// @nodoc
class __$InputMethodServerStateCopyWithImpl<$Res>
    implements _$InputMethodServerStateCopyWith<$Res> {
  __$InputMethodServerStateCopyWithImpl(this._self, this._then);

  final _InputMethodServerState _self;
  final $Res Function(_InputMethodServerState) _then;

/// Create a copy of InputMethodServerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isServerStartup = null,Object? serverAddressText = freezed,}) {
  return _then(_InputMethodServerState(
isServerStartup: null == isServerStartup ? _self.isServerStartup : isServerStartup // ignore: cast_nullable_to_non_nullable
as bool,serverAddressText: freezed == serverAddressText ? _self.serverAddressText : serverAddressText // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
