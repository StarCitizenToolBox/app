// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_doctor_ui_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HomeGameDoctorState {
  bool get isChecking => throw _privateConstructorUsedError;
  bool get isFixing => throw _privateConstructorUsedError;
  String get lastScreenInfo => throw _privateConstructorUsedError;
  String get isFixingString => throw _privateConstructorUsedError;
  List<MapEntry<String, String>>? get checkResult =>
      throw _privateConstructorUsedError;

  /// Create a copy of HomeGameDoctorState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomeGameDoctorStateCopyWith<HomeGameDoctorState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeGameDoctorStateCopyWith<$Res> {
  factory $HomeGameDoctorStateCopyWith(
          HomeGameDoctorState value, $Res Function(HomeGameDoctorState) then) =
      _$HomeGameDoctorStateCopyWithImpl<$Res, HomeGameDoctorState>;
  @useResult
  $Res call(
      {bool isChecking,
      bool isFixing,
      String lastScreenInfo,
      String isFixingString,
      List<MapEntry<String, String>>? checkResult});
}

/// @nodoc
class _$HomeGameDoctorStateCopyWithImpl<$Res, $Val extends HomeGameDoctorState>
    implements $HomeGameDoctorStateCopyWith<$Res> {
  _$HomeGameDoctorStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeGameDoctorState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isChecking = null,
    Object? isFixing = null,
    Object? lastScreenInfo = null,
    Object? isFixingString = null,
    Object? checkResult = freezed,
  }) {
    return _then(_value.copyWith(
      isChecking: null == isChecking
          ? _value.isChecking
          : isChecking // ignore: cast_nullable_to_non_nullable
              as bool,
      isFixing: null == isFixing
          ? _value.isFixing
          : isFixing // ignore: cast_nullable_to_non_nullable
              as bool,
      lastScreenInfo: null == lastScreenInfo
          ? _value.lastScreenInfo
          : lastScreenInfo // ignore: cast_nullable_to_non_nullable
              as String,
      isFixingString: null == isFixingString
          ? _value.isFixingString
          : isFixingString // ignore: cast_nullable_to_non_nullable
              as String,
      checkResult: freezed == checkResult
          ? _value.checkResult
          : checkResult // ignore: cast_nullable_to_non_nullable
              as List<MapEntry<String, String>>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HomeGameDoctorStateImplCopyWith<$Res>
    implements $HomeGameDoctorStateCopyWith<$Res> {
  factory _$$HomeGameDoctorStateImplCopyWith(_$HomeGameDoctorStateImpl value,
          $Res Function(_$HomeGameDoctorStateImpl) then) =
      __$$HomeGameDoctorStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isChecking,
      bool isFixing,
      String lastScreenInfo,
      String isFixingString,
      List<MapEntry<String, String>>? checkResult});
}

/// @nodoc
class __$$HomeGameDoctorStateImplCopyWithImpl<$Res>
    extends _$HomeGameDoctorStateCopyWithImpl<$Res, _$HomeGameDoctorStateImpl>
    implements _$$HomeGameDoctorStateImplCopyWith<$Res> {
  __$$HomeGameDoctorStateImplCopyWithImpl(_$HomeGameDoctorStateImpl _value,
      $Res Function(_$HomeGameDoctorStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of HomeGameDoctorState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isChecking = null,
    Object? isFixing = null,
    Object? lastScreenInfo = null,
    Object? isFixingString = null,
    Object? checkResult = freezed,
  }) {
    return _then(_$HomeGameDoctorStateImpl(
      isChecking: null == isChecking
          ? _value.isChecking
          : isChecking // ignore: cast_nullable_to_non_nullable
              as bool,
      isFixing: null == isFixing
          ? _value.isFixing
          : isFixing // ignore: cast_nullable_to_non_nullable
              as bool,
      lastScreenInfo: null == lastScreenInfo
          ? _value.lastScreenInfo
          : lastScreenInfo // ignore: cast_nullable_to_non_nullable
              as String,
      isFixingString: null == isFixingString
          ? _value.isFixingString
          : isFixingString // ignore: cast_nullable_to_non_nullable
              as String,
      checkResult: freezed == checkResult
          ? _value._checkResult
          : checkResult // ignore: cast_nullable_to_non_nullable
              as List<MapEntry<String, String>>?,
    ));
  }
}

/// @nodoc

class _$HomeGameDoctorStateImpl implements _HomeGameDoctorState {
  _$HomeGameDoctorStateImpl(
      {this.isChecking = false,
      this.isFixing = false,
      this.lastScreenInfo = "",
      this.isFixingString = "",
      final List<MapEntry<String, String>>? checkResult})
      : _checkResult = checkResult;

  @override
  @JsonKey()
  final bool isChecking;
  @override
  @JsonKey()
  final bool isFixing;
  @override
  @JsonKey()
  final String lastScreenInfo;
  @override
  @JsonKey()
  final String isFixingString;
  final List<MapEntry<String, String>>? _checkResult;
  @override
  List<MapEntry<String, String>>? get checkResult {
    final value = _checkResult;
    if (value == null) return null;
    if (_checkResult is EqualUnmodifiableListView) return _checkResult;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'HomeGameDoctorState(isChecking: $isChecking, isFixing: $isFixing, lastScreenInfo: $lastScreenInfo, isFixingString: $isFixingString, checkResult: $checkResult)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeGameDoctorStateImpl &&
            (identical(other.isChecking, isChecking) ||
                other.isChecking == isChecking) &&
            (identical(other.isFixing, isFixing) ||
                other.isFixing == isFixing) &&
            (identical(other.lastScreenInfo, lastScreenInfo) ||
                other.lastScreenInfo == lastScreenInfo) &&
            (identical(other.isFixingString, isFixingString) ||
                other.isFixingString == isFixingString) &&
            const DeepCollectionEquality()
                .equals(other._checkResult, _checkResult));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isChecking,
      isFixing,
      lastScreenInfo,
      isFixingString,
      const DeepCollectionEquality().hash(_checkResult));

  /// Create a copy of HomeGameDoctorState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeGameDoctorStateImplCopyWith<_$HomeGameDoctorStateImpl> get copyWith =>
      __$$HomeGameDoctorStateImplCopyWithImpl<_$HomeGameDoctorStateImpl>(
          this, _$identity);
}

abstract class _HomeGameDoctorState implements HomeGameDoctorState {
  factory _HomeGameDoctorState(
          {final bool isChecking,
          final bool isFixing,
          final String lastScreenInfo,
          final String isFixingString,
          final List<MapEntry<String, String>>? checkResult}) =
      _$HomeGameDoctorStateImpl;

  @override
  bool get isChecking;
  @override
  bool get isFixing;
  @override
  String get lastScreenInfo;
  @override
  String get isFixingString;
  @override
  List<MapEntry<String, String>>? get checkResult;

  /// Create a copy of HomeGameDoctorState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeGameDoctorStateImplCopyWith<_$HomeGameDoctorStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
