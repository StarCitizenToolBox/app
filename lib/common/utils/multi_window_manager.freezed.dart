// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'multi_window_manager.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MultiWindowAppState {

 String get backgroundColor; String get menuColor; String get micaColor; List<String> get gameInstallPaths; String? get languageCode; String? get countryCode;
/// Create a copy of MultiWindowAppState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MultiWindowAppStateCopyWith<MultiWindowAppState> get copyWith => _$MultiWindowAppStateCopyWithImpl<MultiWindowAppState>(this as MultiWindowAppState, _$identity);

  /// Serializes this MultiWindowAppState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MultiWindowAppState&&(identical(other.backgroundColor, backgroundColor) || other.backgroundColor == backgroundColor)&&(identical(other.menuColor, menuColor) || other.menuColor == menuColor)&&(identical(other.micaColor, micaColor) || other.micaColor == micaColor)&&const DeepCollectionEquality().equals(other.gameInstallPaths, gameInstallPaths)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,backgroundColor,menuColor,micaColor,const DeepCollectionEquality().hash(gameInstallPaths),languageCode,countryCode);

@override
String toString() {
  return 'MultiWindowAppState(backgroundColor: $backgroundColor, menuColor: $menuColor, micaColor: $micaColor, gameInstallPaths: $gameInstallPaths, languageCode: $languageCode, countryCode: $countryCode)';
}


}

/// @nodoc
abstract mixin class $MultiWindowAppStateCopyWith<$Res>  {
  factory $MultiWindowAppStateCopyWith(MultiWindowAppState value, $Res Function(MultiWindowAppState) _then) = _$MultiWindowAppStateCopyWithImpl;
@useResult
$Res call({
 String backgroundColor, String menuColor, String micaColor, List<String> gameInstallPaths, String? languageCode, String? countryCode
});




}
/// @nodoc
class _$MultiWindowAppStateCopyWithImpl<$Res>
    implements $MultiWindowAppStateCopyWith<$Res> {
  _$MultiWindowAppStateCopyWithImpl(this._self, this._then);

  final MultiWindowAppState _self;
  final $Res Function(MultiWindowAppState) _then;

/// Create a copy of MultiWindowAppState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? backgroundColor = null,Object? menuColor = null,Object? micaColor = null,Object? gameInstallPaths = null,Object? languageCode = freezed,Object? countryCode = freezed,}) {
  return _then(_self.copyWith(
backgroundColor: null == backgroundColor ? _self.backgroundColor : backgroundColor // ignore: cast_nullable_to_non_nullable
as String,menuColor: null == menuColor ? _self.menuColor : menuColor // ignore: cast_nullable_to_non_nullable
as String,micaColor: null == micaColor ? _self.micaColor : micaColor // ignore: cast_nullable_to_non_nullable
as String,gameInstallPaths: null == gameInstallPaths ? _self.gameInstallPaths : gameInstallPaths // ignore: cast_nullable_to_non_nullable
as List<String>,languageCode: freezed == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String?,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MultiWindowAppState].
extension MultiWindowAppStatePatterns on MultiWindowAppState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MultiWindowAppState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MultiWindowAppState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MultiWindowAppState value)  $default,){
final _that = this;
switch (_that) {
case _MultiWindowAppState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MultiWindowAppState value)?  $default,){
final _that = this;
switch (_that) {
case _MultiWindowAppState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String backgroundColor,  String menuColor,  String micaColor,  List<String> gameInstallPaths,  String? languageCode,  String? countryCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MultiWindowAppState() when $default != null:
return $default(_that.backgroundColor,_that.menuColor,_that.micaColor,_that.gameInstallPaths,_that.languageCode,_that.countryCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String backgroundColor,  String menuColor,  String micaColor,  List<String> gameInstallPaths,  String? languageCode,  String? countryCode)  $default,) {final _that = this;
switch (_that) {
case _MultiWindowAppState():
return $default(_that.backgroundColor,_that.menuColor,_that.micaColor,_that.gameInstallPaths,_that.languageCode,_that.countryCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String backgroundColor,  String menuColor,  String micaColor,  List<String> gameInstallPaths,  String? languageCode,  String? countryCode)?  $default,) {final _that = this;
switch (_that) {
case _MultiWindowAppState() when $default != null:
return $default(_that.backgroundColor,_that.menuColor,_that.micaColor,_that.gameInstallPaths,_that.languageCode,_that.countryCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MultiWindowAppState implements MultiWindowAppState {
  const _MultiWindowAppState({required this.backgroundColor, required this.menuColor, required this.micaColor, required final  List<String> gameInstallPaths, this.languageCode, this.countryCode}): _gameInstallPaths = gameInstallPaths;
  factory _MultiWindowAppState.fromJson(Map<String, dynamic> json) => _$MultiWindowAppStateFromJson(json);

@override final  String backgroundColor;
@override final  String menuColor;
@override final  String micaColor;
 final  List<String> _gameInstallPaths;
@override List<String> get gameInstallPaths {
  if (_gameInstallPaths is EqualUnmodifiableListView) return _gameInstallPaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_gameInstallPaths);
}

@override final  String? languageCode;
@override final  String? countryCode;

/// Create a copy of MultiWindowAppState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MultiWindowAppStateCopyWith<_MultiWindowAppState> get copyWith => __$MultiWindowAppStateCopyWithImpl<_MultiWindowAppState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MultiWindowAppStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MultiWindowAppState&&(identical(other.backgroundColor, backgroundColor) || other.backgroundColor == backgroundColor)&&(identical(other.menuColor, menuColor) || other.menuColor == menuColor)&&(identical(other.micaColor, micaColor) || other.micaColor == micaColor)&&const DeepCollectionEquality().equals(other._gameInstallPaths, _gameInstallPaths)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,backgroundColor,menuColor,micaColor,const DeepCollectionEquality().hash(_gameInstallPaths),languageCode,countryCode);

@override
String toString() {
  return 'MultiWindowAppState(backgroundColor: $backgroundColor, menuColor: $menuColor, micaColor: $micaColor, gameInstallPaths: $gameInstallPaths, languageCode: $languageCode, countryCode: $countryCode)';
}


}

/// @nodoc
abstract mixin class _$MultiWindowAppStateCopyWith<$Res> implements $MultiWindowAppStateCopyWith<$Res> {
  factory _$MultiWindowAppStateCopyWith(_MultiWindowAppState value, $Res Function(_MultiWindowAppState) _then) = __$MultiWindowAppStateCopyWithImpl;
@override @useResult
$Res call({
 String backgroundColor, String menuColor, String micaColor, List<String> gameInstallPaths, String? languageCode, String? countryCode
});




}
/// @nodoc
class __$MultiWindowAppStateCopyWithImpl<$Res>
    implements _$MultiWindowAppStateCopyWith<$Res> {
  __$MultiWindowAppStateCopyWithImpl(this._self, this._then);

  final _MultiWindowAppState _self;
  final $Res Function(_MultiWindowAppState) _then;

/// Create a copy of MultiWindowAppState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? backgroundColor = null,Object? menuColor = null,Object? micaColor = null,Object? gameInstallPaths = null,Object? languageCode = freezed,Object? countryCode = freezed,}) {
  return _then(_MultiWindowAppState(
backgroundColor: null == backgroundColor ? _self.backgroundColor : backgroundColor // ignore: cast_nullable_to_non_nullable
as String,menuColor: null == menuColor ? _self.menuColor : menuColor // ignore: cast_nullable_to_non_nullable
as String,micaColor: null == micaColor ? _self.micaColor : micaColor // ignore: cast_nullable_to_non_nullable
as String,gameInstallPaths: null == gameInstallPaths ? _self._gameInstallPaths : gameInstallPaths // ignore: cast_nullable_to_non_nullable
as List<String>,languageCode: freezed == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String?,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
