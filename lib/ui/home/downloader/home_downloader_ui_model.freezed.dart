// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_downloader_ui_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeDownloaderUIState {

 List<DownloadTaskInfo> get activeTasks; List<DownloadTaskInfo> get waitingTasks; List<DownloadTaskInfo> get stoppedTasks; DownloadGlobalStat? get globalStat;
/// Create a copy of HomeDownloaderUIState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeDownloaderUIStateCopyWith<HomeDownloaderUIState> get copyWith => _$HomeDownloaderUIStateCopyWithImpl<HomeDownloaderUIState>(this as HomeDownloaderUIState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeDownloaderUIState&&const DeepCollectionEquality().equals(other.activeTasks, activeTasks)&&const DeepCollectionEquality().equals(other.waitingTasks, waitingTasks)&&const DeepCollectionEquality().equals(other.stoppedTasks, stoppedTasks)&&(identical(other.globalStat, globalStat) || other.globalStat == globalStat));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(activeTasks),const DeepCollectionEquality().hash(waitingTasks),const DeepCollectionEquality().hash(stoppedTasks),globalStat);

@override
String toString() {
  return 'HomeDownloaderUIState(activeTasks: $activeTasks, waitingTasks: $waitingTasks, stoppedTasks: $stoppedTasks, globalStat: $globalStat)';
}


}

/// @nodoc
abstract mixin class $HomeDownloaderUIStateCopyWith<$Res>  {
  factory $HomeDownloaderUIStateCopyWith(HomeDownloaderUIState value, $Res Function(HomeDownloaderUIState) _then) = _$HomeDownloaderUIStateCopyWithImpl;
@useResult
$Res call({
 List<DownloadTaskInfo> activeTasks, List<DownloadTaskInfo> waitingTasks, List<DownloadTaskInfo> stoppedTasks, DownloadGlobalStat? globalStat
});




}
/// @nodoc
class _$HomeDownloaderUIStateCopyWithImpl<$Res>
    implements $HomeDownloaderUIStateCopyWith<$Res> {
  _$HomeDownloaderUIStateCopyWithImpl(this._self, this._then);

  final HomeDownloaderUIState _self;
  final $Res Function(HomeDownloaderUIState) _then;

/// Create a copy of HomeDownloaderUIState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activeTasks = null,Object? waitingTasks = null,Object? stoppedTasks = null,Object? globalStat = freezed,}) {
  return _then(_self.copyWith(
activeTasks: null == activeTasks ? _self.activeTasks : activeTasks // ignore: cast_nullable_to_non_nullable
as List<DownloadTaskInfo>,waitingTasks: null == waitingTasks ? _self.waitingTasks : waitingTasks // ignore: cast_nullable_to_non_nullable
as List<DownloadTaskInfo>,stoppedTasks: null == stoppedTasks ? _self.stoppedTasks : stoppedTasks // ignore: cast_nullable_to_non_nullable
as List<DownloadTaskInfo>,globalStat: freezed == globalStat ? _self.globalStat : globalStat // ignore: cast_nullable_to_non_nullable
as DownloadGlobalStat?,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeDownloaderUIState].
extension HomeDownloaderUIStatePatterns on HomeDownloaderUIState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeDownloaderUIState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeDownloaderUIState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeDownloaderUIState value)  $default,){
final _that = this;
switch (_that) {
case _HomeDownloaderUIState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeDownloaderUIState value)?  $default,){
final _that = this;
switch (_that) {
case _HomeDownloaderUIState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DownloadTaskInfo> activeTasks,  List<DownloadTaskInfo> waitingTasks,  List<DownloadTaskInfo> stoppedTasks,  DownloadGlobalStat? globalStat)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeDownloaderUIState() when $default != null:
return $default(_that.activeTasks,_that.waitingTasks,_that.stoppedTasks,_that.globalStat);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DownloadTaskInfo> activeTasks,  List<DownloadTaskInfo> waitingTasks,  List<DownloadTaskInfo> stoppedTasks,  DownloadGlobalStat? globalStat)  $default,) {final _that = this;
switch (_that) {
case _HomeDownloaderUIState():
return $default(_that.activeTasks,_that.waitingTasks,_that.stoppedTasks,_that.globalStat);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DownloadTaskInfo> activeTasks,  List<DownloadTaskInfo> waitingTasks,  List<DownloadTaskInfo> stoppedTasks,  DownloadGlobalStat? globalStat)?  $default,) {final _that = this;
switch (_that) {
case _HomeDownloaderUIState() when $default != null:
return $default(_that.activeTasks,_that.waitingTasks,_that.stoppedTasks,_that.globalStat);case _:
  return null;

}
}

}

/// @nodoc


class _HomeDownloaderUIState implements HomeDownloaderUIState {
   _HomeDownloaderUIState({final  List<DownloadTaskInfo> activeTasks = const [], final  List<DownloadTaskInfo> waitingTasks = const [], final  List<DownloadTaskInfo> stoppedTasks = const [], this.globalStat}): _activeTasks = activeTasks,_waitingTasks = waitingTasks,_stoppedTasks = stoppedTasks;
  

 final  List<DownloadTaskInfo> _activeTasks;
@override@JsonKey() List<DownloadTaskInfo> get activeTasks {
  if (_activeTasks is EqualUnmodifiableListView) return _activeTasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_activeTasks);
}

 final  List<DownloadTaskInfo> _waitingTasks;
@override@JsonKey() List<DownloadTaskInfo> get waitingTasks {
  if (_waitingTasks is EqualUnmodifiableListView) return _waitingTasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_waitingTasks);
}

 final  List<DownloadTaskInfo> _stoppedTasks;
@override@JsonKey() List<DownloadTaskInfo> get stoppedTasks {
  if (_stoppedTasks is EqualUnmodifiableListView) return _stoppedTasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stoppedTasks);
}

@override final  DownloadGlobalStat? globalStat;

/// Create a copy of HomeDownloaderUIState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeDownloaderUIStateCopyWith<_HomeDownloaderUIState> get copyWith => __$HomeDownloaderUIStateCopyWithImpl<_HomeDownloaderUIState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeDownloaderUIState&&const DeepCollectionEquality().equals(other._activeTasks, _activeTasks)&&const DeepCollectionEquality().equals(other._waitingTasks, _waitingTasks)&&const DeepCollectionEquality().equals(other._stoppedTasks, _stoppedTasks)&&(identical(other.globalStat, globalStat) || other.globalStat == globalStat));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_activeTasks),const DeepCollectionEquality().hash(_waitingTasks),const DeepCollectionEquality().hash(_stoppedTasks),globalStat);

@override
String toString() {
  return 'HomeDownloaderUIState(activeTasks: $activeTasks, waitingTasks: $waitingTasks, stoppedTasks: $stoppedTasks, globalStat: $globalStat)';
}


}

/// @nodoc
abstract mixin class _$HomeDownloaderUIStateCopyWith<$Res> implements $HomeDownloaderUIStateCopyWith<$Res> {
  factory _$HomeDownloaderUIStateCopyWith(_HomeDownloaderUIState value, $Res Function(_HomeDownloaderUIState) _then) = __$HomeDownloaderUIStateCopyWithImpl;
@override @useResult
$Res call({
 List<DownloadTaskInfo> activeTasks, List<DownloadTaskInfo> waitingTasks, List<DownloadTaskInfo> stoppedTasks, DownloadGlobalStat? globalStat
});




}
/// @nodoc
class __$HomeDownloaderUIStateCopyWithImpl<$Res>
    implements _$HomeDownloaderUIStateCopyWith<$Res> {
  __$HomeDownloaderUIStateCopyWithImpl(this._self, this._then);

  final _HomeDownloaderUIState _self;
  final $Res Function(_HomeDownloaderUIState) _then;

/// Create a copy of HomeDownloaderUIState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activeTasks = null,Object? waitingTasks = null,Object? stoppedTasks = null,Object? globalStat = freezed,}) {
  return _then(_HomeDownloaderUIState(
activeTasks: null == activeTasks ? _self._activeTasks : activeTasks // ignore: cast_nullable_to_non_nullable
as List<DownloadTaskInfo>,waitingTasks: null == waitingTasks ? _self._waitingTasks : waitingTasks // ignore: cast_nullable_to_non_nullable
as List<DownloadTaskInfo>,stoppedTasks: null == stoppedTasks ? _self._stoppedTasks : stoppedTasks // ignore: cast_nullable_to_non_nullable
as List<DownloadTaskInfo>,globalStat: freezed == globalStat ? _self.globalStat : globalStat // ignore: cast_nullable_to_non_nullable
as DownloadGlobalStat?,
  ));
}


}

// dart format on
