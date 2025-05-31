// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
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
  List<Aria2Task> get tasks;
  List<Aria2Task> get waitingTasks;
  List<Aria2Task> get stoppedTasks;
  Aria2GlobalStat? get globalStat;

  /// Create a copy of HomeDownloaderUIState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HomeDownloaderUIStateCopyWith<HomeDownloaderUIState> get copyWith =>
      _$HomeDownloaderUIStateCopyWithImpl<HomeDownloaderUIState>(
          this as HomeDownloaderUIState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HomeDownloaderUIState &&
            const DeepCollectionEquality().equals(other.tasks, tasks) &&
            const DeepCollectionEquality()
                .equals(other.waitingTasks, waitingTasks) &&
            const DeepCollectionEquality()
                .equals(other.stoppedTasks, stoppedTasks) &&
            (identical(other.globalStat, globalStat) ||
                other.globalStat == globalStat));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(tasks),
      const DeepCollectionEquality().hash(waitingTasks),
      const DeepCollectionEquality().hash(stoppedTasks),
      globalStat);

  @override
  String toString() {
    return 'HomeDownloaderUIState(tasks: $tasks, waitingTasks: $waitingTasks, stoppedTasks: $stoppedTasks, globalStat: $globalStat)';
  }
}

/// @nodoc
abstract mixin class $HomeDownloaderUIStateCopyWith<$Res> {
  factory $HomeDownloaderUIStateCopyWith(HomeDownloaderUIState value,
          $Res Function(HomeDownloaderUIState) _then) =
      _$HomeDownloaderUIStateCopyWithImpl;
  @useResult
  $Res call(
      {List<Aria2Task> tasks,
      List<Aria2Task> waitingTasks,
      List<Aria2Task> stoppedTasks,
      Aria2GlobalStat? globalStat});
}

/// @nodoc
class _$HomeDownloaderUIStateCopyWithImpl<$Res>
    implements $HomeDownloaderUIStateCopyWith<$Res> {
  _$HomeDownloaderUIStateCopyWithImpl(this._self, this._then);

  final HomeDownloaderUIState _self;
  final $Res Function(HomeDownloaderUIState) _then;

  /// Create a copy of HomeDownloaderUIState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tasks = null,
    Object? waitingTasks = null,
    Object? stoppedTasks = null,
    Object? globalStat = freezed,
  }) {
    return _then(_self.copyWith(
      tasks: null == tasks
          ? _self.tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<Aria2Task>,
      waitingTasks: null == waitingTasks
          ? _self.waitingTasks
          : waitingTasks // ignore: cast_nullable_to_non_nullable
              as List<Aria2Task>,
      stoppedTasks: null == stoppedTasks
          ? _self.stoppedTasks
          : stoppedTasks // ignore: cast_nullable_to_non_nullable
              as List<Aria2Task>,
      globalStat: freezed == globalStat
          ? _self.globalStat
          : globalStat // ignore: cast_nullable_to_non_nullable
              as Aria2GlobalStat?,
    ));
  }
}

/// @nodoc

class _HomeDownloaderUIState implements HomeDownloaderUIState {
  _HomeDownloaderUIState(
      {final List<Aria2Task> tasks = const [],
      final List<Aria2Task> waitingTasks = const [],
      final List<Aria2Task> stoppedTasks = const [],
      this.globalStat})
      : _tasks = tasks,
        _waitingTasks = waitingTasks,
        _stoppedTasks = stoppedTasks;

  final List<Aria2Task> _tasks;
  @override
  @JsonKey()
  List<Aria2Task> get tasks {
    if (_tasks is EqualUnmodifiableListView) return _tasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tasks);
  }

  final List<Aria2Task> _waitingTasks;
  @override
  @JsonKey()
  List<Aria2Task> get waitingTasks {
    if (_waitingTasks is EqualUnmodifiableListView) return _waitingTasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_waitingTasks);
  }

  final List<Aria2Task> _stoppedTasks;
  @override
  @JsonKey()
  List<Aria2Task> get stoppedTasks {
    if (_stoppedTasks is EqualUnmodifiableListView) return _stoppedTasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stoppedTasks);
  }

  @override
  final Aria2GlobalStat? globalStat;

  /// Create a copy of HomeDownloaderUIState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HomeDownloaderUIStateCopyWith<_HomeDownloaderUIState> get copyWith =>
      __$HomeDownloaderUIStateCopyWithImpl<_HomeDownloaderUIState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HomeDownloaderUIState &&
            const DeepCollectionEquality().equals(other._tasks, _tasks) &&
            const DeepCollectionEquality()
                .equals(other._waitingTasks, _waitingTasks) &&
            const DeepCollectionEquality()
                .equals(other._stoppedTasks, _stoppedTasks) &&
            (identical(other.globalStat, globalStat) ||
                other.globalStat == globalStat));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_tasks),
      const DeepCollectionEquality().hash(_waitingTasks),
      const DeepCollectionEquality().hash(_stoppedTasks),
      globalStat);

  @override
  String toString() {
    return 'HomeDownloaderUIState(tasks: $tasks, waitingTasks: $waitingTasks, stoppedTasks: $stoppedTasks, globalStat: $globalStat)';
  }
}

/// @nodoc
abstract mixin class _$HomeDownloaderUIStateCopyWith<$Res>
    implements $HomeDownloaderUIStateCopyWith<$Res> {
  factory _$HomeDownloaderUIStateCopyWith(_HomeDownloaderUIState value,
          $Res Function(_HomeDownloaderUIState) _then) =
      __$HomeDownloaderUIStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<Aria2Task> tasks,
      List<Aria2Task> waitingTasks,
      List<Aria2Task> stoppedTasks,
      Aria2GlobalStat? globalStat});
}

/// @nodoc
class __$HomeDownloaderUIStateCopyWithImpl<$Res>
    implements _$HomeDownloaderUIStateCopyWith<$Res> {
  __$HomeDownloaderUIStateCopyWithImpl(this._self, this._then);

  final _HomeDownloaderUIState _self;
  final $Res Function(_HomeDownloaderUIState) _then;

  /// Create a copy of HomeDownloaderUIState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? tasks = null,
    Object? waitingTasks = null,
    Object? stoppedTasks = null,
    Object? globalStat = freezed,
  }) {
    return _then(_HomeDownloaderUIState(
      tasks: null == tasks
          ? _self._tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<Aria2Task>,
      waitingTasks: null == waitingTasks
          ? _self._waitingTasks
          : waitingTasks // ignore: cast_nullable_to_non_nullable
              as List<Aria2Task>,
      stoppedTasks: null == stoppedTasks
          ? _self._stoppedTasks
          : stoppedTasks // ignore: cast_nullable_to_non_nullable
              as List<Aria2Task>,
      globalStat: freezed == globalStat
          ? _self.globalStat
          : globalStat // ignore: cast_nullable_to_non_nullable
              as Aria2GlobalStat?,
    ));
  }
}

// dart format on
