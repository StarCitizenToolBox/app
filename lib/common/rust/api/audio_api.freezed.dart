// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_api.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AudioPlaybackState {

 String? get currentSourcePath; int? get durationMs; int get positionMs; bool get isPlaying; bool get isPaused; double get volume;
/// Create a copy of AudioPlaybackState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudioPlaybackStateCopyWith<AudioPlaybackState> get copyWith => _$AudioPlaybackStateCopyWithImpl<AudioPlaybackState>(this as AudioPlaybackState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudioPlaybackState&&(identical(other.currentSourcePath, currentSourcePath) || other.currentSourcePath == currentSourcePath)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.positionMs, positionMs) || other.positionMs == positionMs)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused)&&(identical(other.volume, volume) || other.volume == volume));
}


@override
int get hashCode => Object.hash(runtimeType,currentSourcePath,durationMs,positionMs,isPlaying,isPaused,volume);

@override
String toString() {
  return 'AudioPlaybackState(currentSourcePath: $currentSourcePath, durationMs: $durationMs, positionMs: $positionMs, isPlaying: $isPlaying, isPaused: $isPaused, volume: $volume)';
}


}

/// @nodoc
abstract mixin class $AudioPlaybackStateCopyWith<$Res>  {
  factory $AudioPlaybackStateCopyWith(AudioPlaybackState value, $Res Function(AudioPlaybackState) _then) = _$AudioPlaybackStateCopyWithImpl;
@useResult
$Res call({
 String? currentSourcePath, int? durationMs, int positionMs, bool isPlaying, bool isPaused, double volume
});




}
/// @nodoc
class _$AudioPlaybackStateCopyWithImpl<$Res>
    implements $AudioPlaybackStateCopyWith<$Res> {
  _$AudioPlaybackStateCopyWithImpl(this._self, this._then);

  final AudioPlaybackState _self;
  final $Res Function(AudioPlaybackState) _then;

/// Create a copy of AudioPlaybackState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentSourcePath = freezed,Object? durationMs = freezed,Object? positionMs = null,Object? isPlaying = null,Object? isPaused = null,Object? volume = null,}) {
  return _then(_self.copyWith(
currentSourcePath: freezed == currentSourcePath ? _self.currentSourcePath : currentSourcePath // ignore: cast_nullable_to_non_nullable
as String?,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,positionMs: null == positionMs ? _self.positionMs : positionMs // ignore: cast_nullable_to_non_nullable
as int,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [AudioPlaybackState].
extension AudioPlaybackStatePatterns on AudioPlaybackState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AudioPlaybackState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AudioPlaybackState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AudioPlaybackState value)  $default,){
final _that = this;
switch (_that) {
case _AudioPlaybackState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AudioPlaybackState value)?  $default,){
final _that = this;
switch (_that) {
case _AudioPlaybackState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? currentSourcePath,  int? durationMs,  int positionMs,  bool isPlaying,  bool isPaused,  double volume)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AudioPlaybackState() when $default != null:
return $default(_that.currentSourcePath,_that.durationMs,_that.positionMs,_that.isPlaying,_that.isPaused,_that.volume);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? currentSourcePath,  int? durationMs,  int positionMs,  bool isPlaying,  bool isPaused,  double volume)  $default,) {final _that = this;
switch (_that) {
case _AudioPlaybackState():
return $default(_that.currentSourcePath,_that.durationMs,_that.positionMs,_that.isPlaying,_that.isPaused,_that.volume);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? currentSourcePath,  int? durationMs,  int positionMs,  bool isPlaying,  bool isPaused,  double volume)?  $default,) {final _that = this;
switch (_that) {
case _AudioPlaybackState() when $default != null:
return $default(_that.currentSourcePath,_that.durationMs,_that.positionMs,_that.isPlaying,_that.isPaused,_that.volume);case _:
  return null;

}
}

}

/// @nodoc


class _AudioPlaybackState implements AudioPlaybackState {
  const _AudioPlaybackState({this.currentSourcePath, this.durationMs, required this.positionMs, required this.isPlaying, required this.isPaused, required this.volume});
  

@override final  String? currentSourcePath;
@override final  int? durationMs;
@override final  int positionMs;
@override final  bool isPlaying;
@override final  bool isPaused;
@override final  double volume;

/// Create a copy of AudioPlaybackState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AudioPlaybackStateCopyWith<_AudioPlaybackState> get copyWith => __$AudioPlaybackStateCopyWithImpl<_AudioPlaybackState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AudioPlaybackState&&(identical(other.currentSourcePath, currentSourcePath) || other.currentSourcePath == currentSourcePath)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.positionMs, positionMs) || other.positionMs == positionMs)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused)&&(identical(other.volume, volume) || other.volume == volume));
}


@override
int get hashCode => Object.hash(runtimeType,currentSourcePath,durationMs,positionMs,isPlaying,isPaused,volume);

@override
String toString() {
  return 'AudioPlaybackState(currentSourcePath: $currentSourcePath, durationMs: $durationMs, positionMs: $positionMs, isPlaying: $isPlaying, isPaused: $isPaused, volume: $volume)';
}


}

/// @nodoc
abstract mixin class _$AudioPlaybackStateCopyWith<$Res> implements $AudioPlaybackStateCopyWith<$Res> {
  factory _$AudioPlaybackStateCopyWith(_AudioPlaybackState value, $Res Function(_AudioPlaybackState) _then) = __$AudioPlaybackStateCopyWithImpl;
@override @useResult
$Res call({
 String? currentSourcePath, int? durationMs, int positionMs, bool isPlaying, bool isPaused, double volume
});




}
/// @nodoc
class __$AudioPlaybackStateCopyWithImpl<$Res>
    implements _$AudioPlaybackStateCopyWith<$Res> {
  __$AudioPlaybackStateCopyWithImpl(this._self, this._then);

  final _AudioPlaybackState _self;
  final $Res Function(_AudioPlaybackState) _then;

/// Create a copy of AudioPlaybackState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentSourcePath = freezed,Object? durationMs = freezed,Object? positionMs = null,Object? isPlaying = null,Object? isPaused = null,Object? volume = null,}) {
  return _then(_AudioPlaybackState(
currentSourcePath: freezed == currentSourcePath ? _self.currentSourcePath : currentSourcePath // ignore: cast_nullable_to_non_nullable
as String?,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,positionMs: null == positionMs ? _self.positionMs : positionMs // ignore: cast_nullable_to_non_nullable
as int,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
