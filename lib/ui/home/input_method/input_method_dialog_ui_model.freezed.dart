// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'input_method_dialog_ui_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InputMethodDialogUIState {

 Map<String, String>? get keyMaps; Map<String, String>? get worldMaps; bool get enableAutoCopy; bool get isEnableAutoTranslate; bool get isAutoTranslateWorking;
/// Create a copy of InputMethodDialogUIState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InputMethodDialogUIStateCopyWith<InputMethodDialogUIState> get copyWith => _$InputMethodDialogUIStateCopyWithImpl<InputMethodDialogUIState>(this as InputMethodDialogUIState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InputMethodDialogUIState&&const DeepCollectionEquality().equals(other.keyMaps, keyMaps)&&const DeepCollectionEquality().equals(other.worldMaps, worldMaps)&&(identical(other.enableAutoCopy, enableAutoCopy) || other.enableAutoCopy == enableAutoCopy)&&(identical(other.isEnableAutoTranslate, isEnableAutoTranslate) || other.isEnableAutoTranslate == isEnableAutoTranslate)&&(identical(other.isAutoTranslateWorking, isAutoTranslateWorking) || other.isAutoTranslateWorking == isAutoTranslateWorking));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(keyMaps),const DeepCollectionEquality().hash(worldMaps),enableAutoCopy,isEnableAutoTranslate,isAutoTranslateWorking);

@override
String toString() {
  return 'InputMethodDialogUIState(keyMaps: $keyMaps, worldMaps: $worldMaps, enableAutoCopy: $enableAutoCopy, isEnableAutoTranslate: $isEnableAutoTranslate, isAutoTranslateWorking: $isAutoTranslateWorking)';
}


}

/// @nodoc
abstract mixin class $InputMethodDialogUIStateCopyWith<$Res>  {
  factory $InputMethodDialogUIStateCopyWith(InputMethodDialogUIState value, $Res Function(InputMethodDialogUIState) _then) = _$InputMethodDialogUIStateCopyWithImpl;
@useResult
$Res call({
 Map<String, String>? keyMaps, Map<String, String>? worldMaps, bool enableAutoCopy, bool isEnableAutoTranslate, bool isAutoTranslateWorking
});




}
/// @nodoc
class _$InputMethodDialogUIStateCopyWithImpl<$Res>
    implements $InputMethodDialogUIStateCopyWith<$Res> {
  _$InputMethodDialogUIStateCopyWithImpl(this._self, this._then);

  final InputMethodDialogUIState _self;
  final $Res Function(InputMethodDialogUIState) _then;

/// Create a copy of InputMethodDialogUIState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? keyMaps = freezed,Object? worldMaps = freezed,Object? enableAutoCopy = null,Object? isEnableAutoTranslate = null,Object? isAutoTranslateWorking = null,}) {
  return _then(_self.copyWith(
keyMaps: freezed == keyMaps ? _self.keyMaps : keyMaps // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,worldMaps: freezed == worldMaps ? _self.worldMaps : worldMaps // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,enableAutoCopy: null == enableAutoCopy ? _self.enableAutoCopy : enableAutoCopy // ignore: cast_nullable_to_non_nullable
as bool,isEnableAutoTranslate: null == isEnableAutoTranslate ? _self.isEnableAutoTranslate : isEnableAutoTranslate // ignore: cast_nullable_to_non_nullable
as bool,isAutoTranslateWorking: null == isAutoTranslateWorking ? _self.isAutoTranslateWorking : isAutoTranslateWorking // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [InputMethodDialogUIState].
extension InputMethodDialogUIStatePatterns on InputMethodDialogUIState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InputMethodDialogUIState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InputMethodDialogUIState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InputMethodDialogUIState value)  $default,){
final _that = this;
switch (_that) {
case _InputMethodDialogUIState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InputMethodDialogUIState value)?  $default,){
final _that = this;
switch (_that) {
case _InputMethodDialogUIState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, String>? keyMaps,  Map<String, String>? worldMaps,  bool enableAutoCopy,  bool isEnableAutoTranslate,  bool isAutoTranslateWorking)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InputMethodDialogUIState() when $default != null:
return $default(_that.keyMaps,_that.worldMaps,_that.enableAutoCopy,_that.isEnableAutoTranslate,_that.isAutoTranslateWorking);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, String>? keyMaps,  Map<String, String>? worldMaps,  bool enableAutoCopy,  bool isEnableAutoTranslate,  bool isAutoTranslateWorking)  $default,) {final _that = this;
switch (_that) {
case _InputMethodDialogUIState():
return $default(_that.keyMaps,_that.worldMaps,_that.enableAutoCopy,_that.isEnableAutoTranslate,_that.isAutoTranslateWorking);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, String>? keyMaps,  Map<String, String>? worldMaps,  bool enableAutoCopy,  bool isEnableAutoTranslate,  bool isAutoTranslateWorking)?  $default,) {final _that = this;
switch (_that) {
case _InputMethodDialogUIState() when $default != null:
return $default(_that.keyMaps,_that.worldMaps,_that.enableAutoCopy,_that.isEnableAutoTranslate,_that.isAutoTranslateWorking);case _:
  return null;

}
}

}

/// @nodoc


class _InputMethodDialogUIState implements InputMethodDialogUIState {
   _InputMethodDialogUIState(final  Map<String, String>? keyMaps, final  Map<String, String>? worldMaps, {this.enableAutoCopy = false, this.isEnableAutoTranslate = false, this.isAutoTranslateWorking = false}): _keyMaps = keyMaps,_worldMaps = worldMaps;
  

 final  Map<String, String>? _keyMaps;
@override Map<String, String>? get keyMaps {
  final value = _keyMaps;
  if (value == null) return null;
  if (_keyMaps is EqualUnmodifiableMapView) return _keyMaps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, String>? _worldMaps;
@override Map<String, String>? get worldMaps {
  final value = _worldMaps;
  if (value == null) return null;
  if (_worldMaps is EqualUnmodifiableMapView) return _worldMaps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey() final  bool enableAutoCopy;
@override@JsonKey() final  bool isEnableAutoTranslate;
@override@JsonKey() final  bool isAutoTranslateWorking;

/// Create a copy of InputMethodDialogUIState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InputMethodDialogUIStateCopyWith<_InputMethodDialogUIState> get copyWith => __$InputMethodDialogUIStateCopyWithImpl<_InputMethodDialogUIState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InputMethodDialogUIState&&const DeepCollectionEquality().equals(other._keyMaps, _keyMaps)&&const DeepCollectionEquality().equals(other._worldMaps, _worldMaps)&&(identical(other.enableAutoCopy, enableAutoCopy) || other.enableAutoCopy == enableAutoCopy)&&(identical(other.isEnableAutoTranslate, isEnableAutoTranslate) || other.isEnableAutoTranslate == isEnableAutoTranslate)&&(identical(other.isAutoTranslateWorking, isAutoTranslateWorking) || other.isAutoTranslateWorking == isAutoTranslateWorking));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_keyMaps),const DeepCollectionEquality().hash(_worldMaps),enableAutoCopy,isEnableAutoTranslate,isAutoTranslateWorking);

@override
String toString() {
  return 'InputMethodDialogUIState(keyMaps: $keyMaps, worldMaps: $worldMaps, enableAutoCopy: $enableAutoCopy, isEnableAutoTranslate: $isEnableAutoTranslate, isAutoTranslateWorking: $isAutoTranslateWorking)';
}


}

/// @nodoc
abstract mixin class _$InputMethodDialogUIStateCopyWith<$Res> implements $InputMethodDialogUIStateCopyWith<$Res> {
  factory _$InputMethodDialogUIStateCopyWith(_InputMethodDialogUIState value, $Res Function(_InputMethodDialogUIState) _then) = __$InputMethodDialogUIStateCopyWithImpl;
@override @useResult
$Res call({
 Map<String, String>? keyMaps, Map<String, String>? worldMaps, bool enableAutoCopy, bool isEnableAutoTranslate, bool isAutoTranslateWorking
});




}
/// @nodoc
class __$InputMethodDialogUIStateCopyWithImpl<$Res>
    implements _$InputMethodDialogUIStateCopyWith<$Res> {
  __$InputMethodDialogUIStateCopyWithImpl(this._self, this._then);

  final _InputMethodDialogUIState _self;
  final $Res Function(_InputMethodDialogUIState) _then;

/// Create a copy of InputMethodDialogUIState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? keyMaps = freezed,Object? worldMaps = freezed,Object? enableAutoCopy = null,Object? isEnableAutoTranslate = null,Object? isAutoTranslateWorking = null,}) {
  return _then(_InputMethodDialogUIState(
freezed == keyMaps ? _self._keyMaps : keyMaps // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,freezed == worldMaps ? _self._worldMaps : worldMaps // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,enableAutoCopy: null == enableAutoCopy ? _self.enableAutoCopy : enableAutoCopy // ignore: cast_nullable_to_non_nullable
as bool,isEnableAutoTranslate: null == isEnableAutoTranslate ? _self.isEnableAutoTranslate : isEnableAutoTranslate // ignore: cast_nullable_to_non_nullable
as bool,isAutoTranslateWorking: null == isAutoTranslateWorking ? _self.isAutoTranslateWorking : isAutoTranslateWorking // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
