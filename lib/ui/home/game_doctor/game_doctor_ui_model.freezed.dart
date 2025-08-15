// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_doctor_ui_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeGameDoctorState {

 bool get isChecking; bool get isFixing; String get lastScreenInfo; String get isFixingString; List<MapEntry<String, String>>? get checkResult;
/// Create a copy of HomeGameDoctorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeGameDoctorStateCopyWith<HomeGameDoctorState> get copyWith => _$HomeGameDoctorStateCopyWithImpl<HomeGameDoctorState>(this as HomeGameDoctorState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeGameDoctorState&&(identical(other.isChecking, isChecking) || other.isChecking == isChecking)&&(identical(other.isFixing, isFixing) || other.isFixing == isFixing)&&(identical(other.lastScreenInfo, lastScreenInfo) || other.lastScreenInfo == lastScreenInfo)&&(identical(other.isFixingString, isFixingString) || other.isFixingString == isFixingString)&&const DeepCollectionEquality().equals(other.checkResult, checkResult));
}


@override
int get hashCode => Object.hash(runtimeType,isChecking,isFixing,lastScreenInfo,isFixingString,const DeepCollectionEquality().hash(checkResult));

@override
String toString() {
  return 'HomeGameDoctorState(isChecking: $isChecking, isFixing: $isFixing, lastScreenInfo: $lastScreenInfo, isFixingString: $isFixingString, checkResult: $checkResult)';
}


}

/// @nodoc
abstract mixin class $HomeGameDoctorStateCopyWith<$Res>  {
  factory $HomeGameDoctorStateCopyWith(HomeGameDoctorState value, $Res Function(HomeGameDoctorState) _then) = _$HomeGameDoctorStateCopyWithImpl;
@useResult
$Res call({
 bool isChecking, bool isFixing, String lastScreenInfo, String isFixingString, List<MapEntry<String, String>>? checkResult
});




}
/// @nodoc
class _$HomeGameDoctorStateCopyWithImpl<$Res>
    implements $HomeGameDoctorStateCopyWith<$Res> {
  _$HomeGameDoctorStateCopyWithImpl(this._self, this._then);

  final HomeGameDoctorState _self;
  final $Res Function(HomeGameDoctorState) _then;

/// Create a copy of HomeGameDoctorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isChecking = null,Object? isFixing = null,Object? lastScreenInfo = null,Object? isFixingString = null,Object? checkResult = freezed,}) {
  return _then(_self.copyWith(
isChecking: null == isChecking ? _self.isChecking : isChecking // ignore: cast_nullable_to_non_nullable
as bool,isFixing: null == isFixing ? _self.isFixing : isFixing // ignore: cast_nullable_to_non_nullable
as bool,lastScreenInfo: null == lastScreenInfo ? _self.lastScreenInfo : lastScreenInfo // ignore: cast_nullable_to_non_nullable
as String,isFixingString: null == isFixingString ? _self.isFixingString : isFixingString // ignore: cast_nullable_to_non_nullable
as String,checkResult: freezed == checkResult ? _self.checkResult : checkResult // ignore: cast_nullable_to_non_nullable
as List<MapEntry<String, String>>?,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeGameDoctorState].
extension HomeGameDoctorStatePatterns on HomeGameDoctorState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeGameDoctorState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeGameDoctorState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeGameDoctorState value)  $default,){
final _that = this;
switch (_that) {
case _HomeGameDoctorState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeGameDoctorState value)?  $default,){
final _that = this;
switch (_that) {
case _HomeGameDoctorState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isChecking,  bool isFixing,  String lastScreenInfo,  String isFixingString,  List<MapEntry<String, String>>? checkResult)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeGameDoctorState() when $default != null:
return $default(_that.isChecking,_that.isFixing,_that.lastScreenInfo,_that.isFixingString,_that.checkResult);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isChecking,  bool isFixing,  String lastScreenInfo,  String isFixingString,  List<MapEntry<String, String>>? checkResult)  $default,) {final _that = this;
switch (_that) {
case _HomeGameDoctorState():
return $default(_that.isChecking,_that.isFixing,_that.lastScreenInfo,_that.isFixingString,_that.checkResult);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isChecking,  bool isFixing,  String lastScreenInfo,  String isFixingString,  List<MapEntry<String, String>>? checkResult)?  $default,) {final _that = this;
switch (_that) {
case _HomeGameDoctorState() when $default != null:
return $default(_that.isChecking,_that.isFixing,_that.lastScreenInfo,_that.isFixingString,_that.checkResult);case _:
  return null;

}
}

}

/// @nodoc


class _HomeGameDoctorState implements HomeGameDoctorState {
   _HomeGameDoctorState({this.isChecking = false, this.isFixing = false, this.lastScreenInfo = "", this.isFixingString = "", final  List<MapEntry<String, String>>? checkResult}): _checkResult = checkResult;
  

@override@JsonKey() final  bool isChecking;
@override@JsonKey() final  bool isFixing;
@override@JsonKey() final  String lastScreenInfo;
@override@JsonKey() final  String isFixingString;
 final  List<MapEntry<String, String>>? _checkResult;
@override List<MapEntry<String, String>>? get checkResult {
  final value = _checkResult;
  if (value == null) return null;
  if (_checkResult is EqualUnmodifiableListView) return _checkResult;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of HomeGameDoctorState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeGameDoctorStateCopyWith<_HomeGameDoctorState> get copyWith => __$HomeGameDoctorStateCopyWithImpl<_HomeGameDoctorState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeGameDoctorState&&(identical(other.isChecking, isChecking) || other.isChecking == isChecking)&&(identical(other.isFixing, isFixing) || other.isFixing == isFixing)&&(identical(other.lastScreenInfo, lastScreenInfo) || other.lastScreenInfo == lastScreenInfo)&&(identical(other.isFixingString, isFixingString) || other.isFixingString == isFixingString)&&const DeepCollectionEquality().equals(other._checkResult, _checkResult));
}


@override
int get hashCode => Object.hash(runtimeType,isChecking,isFixing,lastScreenInfo,isFixingString,const DeepCollectionEquality().hash(_checkResult));

@override
String toString() {
  return 'HomeGameDoctorState(isChecking: $isChecking, isFixing: $isFixing, lastScreenInfo: $lastScreenInfo, isFixingString: $isFixingString, checkResult: $checkResult)';
}


}

/// @nodoc
abstract mixin class _$HomeGameDoctorStateCopyWith<$Res> implements $HomeGameDoctorStateCopyWith<$Res> {
  factory _$HomeGameDoctorStateCopyWith(_HomeGameDoctorState value, $Res Function(_HomeGameDoctorState) _then) = __$HomeGameDoctorStateCopyWithImpl;
@override @useResult
$Res call({
 bool isChecking, bool isFixing, String lastScreenInfo, String isFixingString, List<MapEntry<String, String>>? checkResult
});




}
/// @nodoc
class __$HomeGameDoctorStateCopyWithImpl<$Res>
    implements _$HomeGameDoctorStateCopyWith<$Res> {
  __$HomeGameDoctorStateCopyWithImpl(this._self, this._then);

  final _HomeGameDoctorState _self;
  final $Res Function(_HomeGameDoctorState) _then;

/// Create a copy of HomeGameDoctorState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isChecking = null,Object? isFixing = null,Object? lastScreenInfo = null,Object? isFixingString = null,Object? checkResult = freezed,}) {
  return _then(_HomeGameDoctorState(
isChecking: null == isChecking ? _self.isChecking : isChecking // ignore: cast_nullable_to_non_nullable
as bool,isFixing: null == isFixing ? _self.isFixing : isFixing // ignore: cast_nullable_to_non_nullable
as bool,lastScreenInfo: null == lastScreenInfo ? _self.lastScreenInfo : lastScreenInfo // ignore: cast_nullable_to_non_nullable
as String,isFixingString: null == isFixingString ? _self.isFixingString : isFixingString // ignore: cast_nullable_to_non_nullable
as String,checkResult: freezed == checkResult ? _self._checkResult : checkResult // ignore: cast_nullable_to_non_nullable
as List<MapEntry<String, String>>?,
  ));
}


}

// dart format on
