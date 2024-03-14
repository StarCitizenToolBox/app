// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_downloader_ui_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HomeDownloaderUIState {
  List<Aria2Task> get tasks => throw _privateConstructorUsedError;
  List<Aria2Task> get waitingTasks => throw _privateConstructorUsedError;
  List<Aria2Task> get stoppedTasks => throw _privateConstructorUsedError;
  Aria2GlobalStat? get globalStat => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HomeDownloaderUIStateCopyWith<HomeDownloaderUIState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeDownloaderUIStateCopyWith<$Res> {
  factory $HomeDownloaderUIStateCopyWith(HomeDownloaderUIState value,
          $Res Function(HomeDownloaderUIState) then) =
      _$HomeDownloaderUIStateCopyWithImpl<$Res, HomeDownloaderUIState>;
  @useResult
  $Res call(
      {List<Aria2Task> tasks,
      List<Aria2Task> waitingTasks,
      List<Aria2Task> stoppedTasks,
      Aria2GlobalStat? globalStat});
}

/// @nodoc
class _$HomeDownloaderUIStateCopyWithImpl<$Res,
        $Val extends HomeDownloaderUIState>
    implements $HomeDownloaderUIStateCopyWith<$Res> {
  _$HomeDownloaderUIStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tasks = null,
    Object? waitingTasks = null,
    Object? stoppedTasks = null,
    Object? globalStat = freezed,
  }) {
    return _then(_value.copyWith(
      tasks: null == tasks
          ? _value.tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<Aria2Task>,
      waitingTasks: null == waitingTasks
          ? _value.waitingTasks
          : waitingTasks // ignore: cast_nullable_to_non_nullable
              as List<Aria2Task>,
      stoppedTasks: null == stoppedTasks
          ? _value.stoppedTasks
          : stoppedTasks // ignore: cast_nullable_to_non_nullable
              as List<Aria2Task>,
      globalStat: freezed == globalStat
          ? _value.globalStat
          : globalStat // ignore: cast_nullable_to_non_nullable
              as Aria2GlobalStat?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HomeDownloaderUIStateImplCopyWith<$Res>
    implements $HomeDownloaderUIStateCopyWith<$Res> {
  factory _$$HomeDownloaderUIStateImplCopyWith(
          _$HomeDownloaderUIStateImpl value,
          $Res Function(_$HomeDownloaderUIStateImpl) then) =
      __$$HomeDownloaderUIStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Aria2Task> tasks,
      List<Aria2Task> waitingTasks,
      List<Aria2Task> stoppedTasks,
      Aria2GlobalStat? globalStat});
}

/// @nodoc
class __$$HomeDownloaderUIStateImplCopyWithImpl<$Res>
    extends _$HomeDownloaderUIStateCopyWithImpl<$Res,
        _$HomeDownloaderUIStateImpl>
    implements _$$HomeDownloaderUIStateImplCopyWith<$Res> {
  __$$HomeDownloaderUIStateImplCopyWithImpl(_$HomeDownloaderUIStateImpl _value,
      $Res Function(_$HomeDownloaderUIStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tasks = null,
    Object? waitingTasks = null,
    Object? stoppedTasks = null,
    Object? globalStat = freezed,
  }) {
    return _then(_$HomeDownloaderUIStateImpl(
      tasks: null == tasks
          ? _value._tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<Aria2Task>,
      waitingTasks: null == waitingTasks
          ? _value._waitingTasks
          : waitingTasks // ignore: cast_nullable_to_non_nullable
              as List<Aria2Task>,
      stoppedTasks: null == stoppedTasks
          ? _value._stoppedTasks
          : stoppedTasks // ignore: cast_nullable_to_non_nullable
              as List<Aria2Task>,
      globalStat: freezed == globalStat
          ? _value.globalStat
          : globalStat // ignore: cast_nullable_to_non_nullable
              as Aria2GlobalStat?,
    ));
  }
}

/// @nodoc

class _$HomeDownloaderUIStateImpl implements _HomeDownloaderUIState {
  _$HomeDownloaderUIStateImpl(
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

  @override
  String toString() {
    return 'HomeDownloaderUIState(tasks: $tasks, waitingTasks: $waitingTasks, stoppedTasks: $stoppedTasks, globalStat: $globalStat)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeDownloaderUIStateImpl &&
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

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeDownloaderUIStateImplCopyWith<_$HomeDownloaderUIStateImpl>
      get copyWith => __$$HomeDownloaderUIStateImplCopyWithImpl<
          _$HomeDownloaderUIStateImpl>(this, _$identity);
}

abstract class _HomeDownloaderUIState implements HomeDownloaderUIState {
  factory _HomeDownloaderUIState(
      {final List<Aria2Task> tasks,
      final List<Aria2Task> waitingTasks,
      final List<Aria2Task> stoppedTasks,
      final Aria2GlobalStat? globalStat}) = _$HomeDownloaderUIStateImpl;

  @override
  List<Aria2Task> get tasks;
  @override
  List<Aria2Task> get waitingTasks;
  @override
  List<Aria2Task> get stoppedTasks;
  @override
  Aria2GlobalStat? get globalStat;
  @override
  @JsonKey(ignore: true)
  _$$HomeDownloaderUIStateImplCopyWith<_$HomeDownloaderUIStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
