// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'performance_ui_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HomePerformanceUIState {
  bool get showGraphicsPerformanceTip => throw _privateConstructorUsedError;
  bool get enabled => throw _privateConstructorUsedError;
  Map<String, List<GamePerformanceData>>? get performanceMap =>
      throw _privateConstructorUsedError;
  String get workingString => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HomePerformanceUIStateCopyWith<HomePerformanceUIState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomePerformanceUIStateCopyWith<$Res> {
  factory $HomePerformanceUIStateCopyWith(HomePerformanceUIState value,
          $Res Function(HomePerformanceUIState) then) =
      _$HomePerformanceUIStateCopyWithImpl<$Res, HomePerformanceUIState>;
  @useResult
  $Res call(
      {bool showGraphicsPerformanceTip,
      bool enabled,
      Map<String, List<GamePerformanceData>>? performanceMap,
      String workingString});
}

/// @nodoc
class _$HomePerformanceUIStateCopyWithImpl<$Res,
        $Val extends HomePerformanceUIState>
    implements $HomePerformanceUIStateCopyWith<$Res> {
  _$HomePerformanceUIStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? showGraphicsPerformanceTip = null,
    Object? enabled = null,
    Object? performanceMap = freezed,
    Object? workingString = null,
  }) {
    return _then(_value.copyWith(
      showGraphicsPerformanceTip: null == showGraphicsPerformanceTip
          ? _value.showGraphicsPerformanceTip
          : showGraphicsPerformanceTip // ignore: cast_nullable_to_non_nullable
              as bool,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      performanceMap: freezed == performanceMap
          ? _value.performanceMap
          : performanceMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<GamePerformanceData>>?,
      workingString: null == workingString
          ? _value.workingString
          : workingString // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HomePerformanceUIStateImplCopyWith<$Res>
    implements $HomePerformanceUIStateCopyWith<$Res> {
  factory _$$HomePerformanceUIStateImplCopyWith(
          _$HomePerformanceUIStateImpl value,
          $Res Function(_$HomePerformanceUIStateImpl) then) =
      __$$HomePerformanceUIStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool showGraphicsPerformanceTip,
      bool enabled,
      Map<String, List<GamePerformanceData>>? performanceMap,
      String workingString});
}

/// @nodoc
class __$$HomePerformanceUIStateImplCopyWithImpl<$Res>
    extends _$HomePerformanceUIStateCopyWithImpl<$Res,
        _$HomePerformanceUIStateImpl>
    implements _$$HomePerformanceUIStateImplCopyWith<$Res> {
  __$$HomePerformanceUIStateImplCopyWithImpl(
      _$HomePerformanceUIStateImpl _value,
      $Res Function(_$HomePerformanceUIStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? showGraphicsPerformanceTip = null,
    Object? enabled = null,
    Object? performanceMap = freezed,
    Object? workingString = null,
  }) {
    return _then(_$HomePerformanceUIStateImpl(
      showGraphicsPerformanceTip: null == showGraphicsPerformanceTip
          ? _value.showGraphicsPerformanceTip
          : showGraphicsPerformanceTip // ignore: cast_nullable_to_non_nullable
              as bool,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      performanceMap: freezed == performanceMap
          ? _value._performanceMap
          : performanceMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<GamePerformanceData>>?,
      workingString: null == workingString
          ? _value.workingString
          : workingString // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$HomePerformanceUIStateImpl implements _HomePerformanceUIState {
  const _$HomePerformanceUIStateImpl(
      {this.showGraphicsPerformanceTip = true,
      this.enabled = false,
      final Map<String, List<GamePerformanceData>>? performanceMap,
      this.workingString = ""})
      : _performanceMap = performanceMap;

  @override
  @JsonKey()
  final bool showGraphicsPerformanceTip;
  @override
  @JsonKey()
  final bool enabled;
  final Map<String, List<GamePerformanceData>>? _performanceMap;
  @override
  Map<String, List<GamePerformanceData>>? get performanceMap {
    final value = _performanceMap;
    if (value == null) return null;
    if (_performanceMap is EqualUnmodifiableMapView) return _performanceMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final String workingString;

  @override
  String toString() {
    return 'HomePerformanceUIState(showGraphicsPerformanceTip: $showGraphicsPerformanceTip, enabled: $enabled, performanceMap: $performanceMap, workingString: $workingString)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomePerformanceUIStateImpl &&
            (identical(other.showGraphicsPerformanceTip,
                    showGraphicsPerformanceTip) ||
                other.showGraphicsPerformanceTip ==
                    showGraphicsPerformanceTip) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            const DeepCollectionEquality()
                .equals(other._performanceMap, _performanceMap) &&
            (identical(other.workingString, workingString) ||
                other.workingString == workingString));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      showGraphicsPerformanceTip,
      enabled,
      const DeepCollectionEquality().hash(_performanceMap),
      workingString);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomePerformanceUIStateImplCopyWith<_$HomePerformanceUIStateImpl>
      get copyWith => __$$HomePerformanceUIStateImplCopyWithImpl<
          _$HomePerformanceUIStateImpl>(this, _$identity);
}

abstract class _HomePerformanceUIState implements HomePerformanceUIState {
  const factory _HomePerformanceUIState(
      {final bool showGraphicsPerformanceTip,
      final bool enabled,
      final Map<String, List<GamePerformanceData>>? performanceMap,
      final String workingString}) = _$HomePerformanceUIStateImpl;

  @override
  bool get showGraphicsPerformanceTip;
  @override
  bool get enabled;
  @override
  Map<String, List<GamePerformanceData>>? get performanceMap;
  @override
  String get workingString;
  @override
  @JsonKey(ignore: true)
  _$$HomePerformanceUIStateImplCopyWith<_$HomePerformanceUIStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
