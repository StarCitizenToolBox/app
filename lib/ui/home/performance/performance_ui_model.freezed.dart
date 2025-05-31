// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'performance_ui_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HomePerformanceUIState {
  bool get showGraphicsPerformanceTip;
  bool get enabled;
  Map<String, List<GamePerformanceData>>? get performanceMap;
  String get workingString;

  /// Create a copy of HomePerformanceUIState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HomePerformanceUIStateCopyWith<HomePerformanceUIState> get copyWith =>
      _$HomePerformanceUIStateCopyWithImpl<HomePerformanceUIState>(
          this as HomePerformanceUIState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HomePerformanceUIState &&
            (identical(other.showGraphicsPerformanceTip,
                    showGraphicsPerformanceTip) ||
                other.showGraphicsPerformanceTip ==
                    showGraphicsPerformanceTip) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            const DeepCollectionEquality()
                .equals(other.performanceMap, performanceMap) &&
            (identical(other.workingString, workingString) ||
                other.workingString == workingString));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      showGraphicsPerformanceTip,
      enabled,
      const DeepCollectionEquality().hash(performanceMap),
      workingString);

  @override
  String toString() {
    return 'HomePerformanceUIState(showGraphicsPerformanceTip: $showGraphicsPerformanceTip, enabled: $enabled, performanceMap: $performanceMap, workingString: $workingString)';
  }
}

/// @nodoc
abstract mixin class $HomePerformanceUIStateCopyWith<$Res> {
  factory $HomePerformanceUIStateCopyWith(HomePerformanceUIState value,
          $Res Function(HomePerformanceUIState) _then) =
      _$HomePerformanceUIStateCopyWithImpl;
  @useResult
  $Res call(
      {bool showGraphicsPerformanceTip,
      bool enabled,
      Map<String, List<GamePerformanceData>>? performanceMap,
      String workingString});
}

/// @nodoc
class _$HomePerformanceUIStateCopyWithImpl<$Res>
    implements $HomePerformanceUIStateCopyWith<$Res> {
  _$HomePerformanceUIStateCopyWithImpl(this._self, this._then);

  final HomePerformanceUIState _self;
  final $Res Function(HomePerformanceUIState) _then;

  /// Create a copy of HomePerformanceUIState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? showGraphicsPerformanceTip = null,
    Object? enabled = null,
    Object? performanceMap = freezed,
    Object? workingString = null,
  }) {
    return _then(_self.copyWith(
      showGraphicsPerformanceTip: null == showGraphicsPerformanceTip
          ? _self.showGraphicsPerformanceTip
          : showGraphicsPerformanceTip // ignore: cast_nullable_to_non_nullable
              as bool,
      enabled: null == enabled
          ? _self.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      performanceMap: freezed == performanceMap
          ? _self.performanceMap
          : performanceMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<GamePerformanceData>>?,
      workingString: null == workingString
          ? _self.workingString
          : workingString // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _HomePerformanceUIState implements HomePerformanceUIState {
  _HomePerformanceUIState(
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

  /// Create a copy of HomePerformanceUIState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HomePerformanceUIStateCopyWith<_HomePerformanceUIState> get copyWith =>
      __$HomePerformanceUIStateCopyWithImpl<_HomePerformanceUIState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HomePerformanceUIState &&
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

  @override
  String toString() {
    return 'HomePerformanceUIState(showGraphicsPerformanceTip: $showGraphicsPerformanceTip, enabled: $enabled, performanceMap: $performanceMap, workingString: $workingString)';
  }
}

/// @nodoc
abstract mixin class _$HomePerformanceUIStateCopyWith<$Res>
    implements $HomePerformanceUIStateCopyWith<$Res> {
  factory _$HomePerformanceUIStateCopyWith(_HomePerformanceUIState value,
          $Res Function(_HomePerformanceUIState) _then) =
      __$HomePerformanceUIStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool showGraphicsPerformanceTip,
      bool enabled,
      Map<String, List<GamePerformanceData>>? performanceMap,
      String workingString});
}

/// @nodoc
class __$HomePerformanceUIStateCopyWithImpl<$Res>
    implements _$HomePerformanceUIStateCopyWith<$Res> {
  __$HomePerformanceUIStateCopyWithImpl(this._self, this._then);

  final _HomePerformanceUIState _self;
  final $Res Function(_HomePerformanceUIState) _then;

  /// Create a copy of HomePerformanceUIState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? showGraphicsPerformanceTip = null,
    Object? enabled = null,
    Object? performanceMap = freezed,
    Object? workingString = null,
  }) {
    return _then(_HomePerformanceUIState(
      showGraphicsPerformanceTip: null == showGraphicsPerformanceTip
          ? _self.showGraphicsPerformanceTip
          : showGraphicsPerformanceTip // ignore: cast_nullable_to_non_nullable
              as bool,
      enabled: null == enabled
          ? _self.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      performanceMap: freezed == performanceMap
          ? _self._performanceMap
          : performanceMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<GamePerformanceData>>?,
      workingString: null == workingString
          ? _self.workingString
          : workingString // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
