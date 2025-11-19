// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_log_tracker_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PartyRoomGameLogTrackerProviderState {

 String get location; int get kills; int get deaths; DateTime? get gameStartTime; List<String> get killedIds;// 本次迭代新增的击杀ID
 List<String> get deathIds;
/// Create a copy of PartyRoomGameLogTrackerProviderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartyRoomGameLogTrackerProviderStateCopyWith<PartyRoomGameLogTrackerProviderState> get copyWith => _$PartyRoomGameLogTrackerProviderStateCopyWithImpl<PartyRoomGameLogTrackerProviderState>(this as PartyRoomGameLogTrackerProviderState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PartyRoomGameLogTrackerProviderState&&(identical(other.location, location) || other.location == location)&&(identical(other.kills, kills) || other.kills == kills)&&(identical(other.deaths, deaths) || other.deaths == deaths)&&(identical(other.gameStartTime, gameStartTime) || other.gameStartTime == gameStartTime)&&const DeepCollectionEquality().equals(other.killedIds, killedIds)&&const DeepCollectionEquality().equals(other.deathIds, deathIds));
}


@override
int get hashCode => Object.hash(runtimeType,location,kills,deaths,gameStartTime,const DeepCollectionEquality().hash(killedIds),const DeepCollectionEquality().hash(deathIds));

@override
String toString() {
  return 'PartyRoomGameLogTrackerProviderState(location: $location, kills: $kills, deaths: $deaths, gameStartTime: $gameStartTime, killedIds: $killedIds, deathIds: $deathIds)';
}


}

/// @nodoc
abstract mixin class $PartyRoomGameLogTrackerProviderStateCopyWith<$Res>  {
  factory $PartyRoomGameLogTrackerProviderStateCopyWith(PartyRoomGameLogTrackerProviderState value, $Res Function(PartyRoomGameLogTrackerProviderState) _then) = _$PartyRoomGameLogTrackerProviderStateCopyWithImpl;
@useResult
$Res call({
 String location, int kills, int deaths, DateTime? gameStartTime, List<String> killedIds, List<String> deathIds
});




}
/// @nodoc
class _$PartyRoomGameLogTrackerProviderStateCopyWithImpl<$Res>
    implements $PartyRoomGameLogTrackerProviderStateCopyWith<$Res> {
  _$PartyRoomGameLogTrackerProviderStateCopyWithImpl(this._self, this._then);

  final PartyRoomGameLogTrackerProviderState _self;
  final $Res Function(PartyRoomGameLogTrackerProviderState) _then;

/// Create a copy of PartyRoomGameLogTrackerProviderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? location = null,Object? kills = null,Object? deaths = null,Object? gameStartTime = freezed,Object? killedIds = null,Object? deathIds = null,}) {
  return _then(_self.copyWith(
location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,kills: null == kills ? _self.kills : kills // ignore: cast_nullable_to_non_nullable
as int,deaths: null == deaths ? _self.deaths : deaths // ignore: cast_nullable_to_non_nullable
as int,gameStartTime: freezed == gameStartTime ? _self.gameStartTime : gameStartTime // ignore: cast_nullable_to_non_nullable
as DateTime?,killedIds: null == killedIds ? _self.killedIds : killedIds // ignore: cast_nullable_to_non_nullable
as List<String>,deathIds: null == deathIds ? _self.deathIds : deathIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [PartyRoomGameLogTrackerProviderState].
extension PartyRoomGameLogTrackerProviderStatePatterns on PartyRoomGameLogTrackerProviderState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PartyRoomGameLogTrackerProviderState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PartyRoomGameLogTrackerProviderState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PartyRoomGameLogTrackerProviderState value)  $default,){
final _that = this;
switch (_that) {
case _PartyRoomGameLogTrackerProviderState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PartyRoomGameLogTrackerProviderState value)?  $default,){
final _that = this;
switch (_that) {
case _PartyRoomGameLogTrackerProviderState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String location,  int kills,  int deaths,  DateTime? gameStartTime,  List<String> killedIds,  List<String> deathIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PartyRoomGameLogTrackerProviderState() when $default != null:
return $default(_that.location,_that.kills,_that.deaths,_that.gameStartTime,_that.killedIds,_that.deathIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String location,  int kills,  int deaths,  DateTime? gameStartTime,  List<String> killedIds,  List<String> deathIds)  $default,) {final _that = this;
switch (_that) {
case _PartyRoomGameLogTrackerProviderState():
return $default(_that.location,_that.kills,_that.deaths,_that.gameStartTime,_that.killedIds,_that.deathIds);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String location,  int kills,  int deaths,  DateTime? gameStartTime,  List<String> killedIds,  List<String> deathIds)?  $default,) {final _that = this;
switch (_that) {
case _PartyRoomGameLogTrackerProviderState() when $default != null:
return $default(_that.location,_that.kills,_that.deaths,_that.gameStartTime,_that.killedIds,_that.deathIds);case _:
  return null;

}
}

}

/// @nodoc


class _PartyRoomGameLogTrackerProviderState implements PartyRoomGameLogTrackerProviderState {
  const _PartyRoomGameLogTrackerProviderState({this.location = '', this.kills = 0, this.deaths = 0, this.gameStartTime, final  List<String> killedIds = const [], final  List<String> deathIds = const []}): _killedIds = killedIds,_deathIds = deathIds;
  

@override@JsonKey() final  String location;
@override@JsonKey() final  int kills;
@override@JsonKey() final  int deaths;
@override final  DateTime? gameStartTime;
 final  List<String> _killedIds;
@override@JsonKey() List<String> get killedIds {
  if (_killedIds is EqualUnmodifiableListView) return _killedIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_killedIds);
}

// 本次迭代新增的击杀ID
 final  List<String> _deathIds;
// 本次迭代新增的击杀ID
@override@JsonKey() List<String> get deathIds {
  if (_deathIds is EqualUnmodifiableListView) return _deathIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_deathIds);
}


/// Create a copy of PartyRoomGameLogTrackerProviderState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartyRoomGameLogTrackerProviderStateCopyWith<_PartyRoomGameLogTrackerProviderState> get copyWith => __$PartyRoomGameLogTrackerProviderStateCopyWithImpl<_PartyRoomGameLogTrackerProviderState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PartyRoomGameLogTrackerProviderState&&(identical(other.location, location) || other.location == location)&&(identical(other.kills, kills) || other.kills == kills)&&(identical(other.deaths, deaths) || other.deaths == deaths)&&(identical(other.gameStartTime, gameStartTime) || other.gameStartTime == gameStartTime)&&const DeepCollectionEquality().equals(other._killedIds, _killedIds)&&const DeepCollectionEquality().equals(other._deathIds, _deathIds));
}


@override
int get hashCode => Object.hash(runtimeType,location,kills,deaths,gameStartTime,const DeepCollectionEquality().hash(_killedIds),const DeepCollectionEquality().hash(_deathIds));

@override
String toString() {
  return 'PartyRoomGameLogTrackerProviderState(location: $location, kills: $kills, deaths: $deaths, gameStartTime: $gameStartTime, killedIds: $killedIds, deathIds: $deathIds)';
}


}

/// @nodoc
abstract mixin class _$PartyRoomGameLogTrackerProviderStateCopyWith<$Res> implements $PartyRoomGameLogTrackerProviderStateCopyWith<$Res> {
  factory _$PartyRoomGameLogTrackerProviderStateCopyWith(_PartyRoomGameLogTrackerProviderState value, $Res Function(_PartyRoomGameLogTrackerProviderState) _then) = __$PartyRoomGameLogTrackerProviderStateCopyWithImpl;
@override @useResult
$Res call({
 String location, int kills, int deaths, DateTime? gameStartTime, List<String> killedIds, List<String> deathIds
});




}
/// @nodoc
class __$PartyRoomGameLogTrackerProviderStateCopyWithImpl<$Res>
    implements _$PartyRoomGameLogTrackerProviderStateCopyWith<$Res> {
  __$PartyRoomGameLogTrackerProviderStateCopyWithImpl(this._self, this._then);

  final _PartyRoomGameLogTrackerProviderState _self;
  final $Res Function(_PartyRoomGameLogTrackerProviderState) _then;

/// Create a copy of PartyRoomGameLogTrackerProviderState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? location = null,Object? kills = null,Object? deaths = null,Object? gameStartTime = freezed,Object? killedIds = null,Object? deathIds = null,}) {
  return _then(_PartyRoomGameLogTrackerProviderState(
location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,kills: null == kills ? _self.kills : kills // ignore: cast_nullable_to_non_nullable
as int,deaths: null == deaths ? _self.deaths : deaths // ignore: cast_nullable_to_non_nullable
as int,gameStartTime: freezed == gameStartTime ? _self.gameStartTime : gameStartTime // ignore: cast_nullable_to_non_nullable
as DateTime?,killedIds: null == killedIds ? _self._killedIds : killedIds // ignore: cast_nullable_to_non_nullable
as List<String>,deathIds: null == deathIds ? _self._deathIds : deathIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
