// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'aria2c.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Aria2cModelState implements DiagnosticableTreeMixin {
  String get aria2cDir;
  Aria2c? get aria2c;
  Aria2GlobalStat? get aria2globalStat;

  /// Create a copy of Aria2cModelState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $Aria2cModelStateCopyWith<Aria2cModelState> get copyWith =>
      _$Aria2cModelStateCopyWithImpl<Aria2cModelState>(
          this as Aria2cModelState, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'Aria2cModelState'))
      ..add(DiagnosticsProperty('aria2cDir', aria2cDir))
      ..add(DiagnosticsProperty('aria2c', aria2c))
      ..add(DiagnosticsProperty('aria2globalStat', aria2globalStat));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Aria2cModelState &&
            (identical(other.aria2cDir, aria2cDir) ||
                other.aria2cDir == aria2cDir) &&
            (identical(other.aria2c, aria2c) || other.aria2c == aria2c) &&
            (identical(other.aria2globalStat, aria2globalStat) ||
                other.aria2globalStat == aria2globalStat));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, aria2cDir, aria2c, aria2globalStat);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Aria2cModelState(aria2cDir: $aria2cDir, aria2c: $aria2c, aria2globalStat: $aria2globalStat)';
  }
}

/// @nodoc
abstract mixin class $Aria2cModelStateCopyWith<$Res> {
  factory $Aria2cModelStateCopyWith(
          Aria2cModelState value, $Res Function(Aria2cModelState) _then) =
      _$Aria2cModelStateCopyWithImpl;
  @useResult
  $Res call(
      {String aria2cDir, Aria2c? aria2c, Aria2GlobalStat? aria2globalStat});
}

/// @nodoc
class _$Aria2cModelStateCopyWithImpl<$Res>
    implements $Aria2cModelStateCopyWith<$Res> {
  _$Aria2cModelStateCopyWithImpl(this._self, this._then);

  final Aria2cModelState _self;
  final $Res Function(Aria2cModelState) _then;

  /// Create a copy of Aria2cModelState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? aria2cDir = null,
    Object? aria2c = freezed,
    Object? aria2globalStat = freezed,
  }) {
    return _then(_self.copyWith(
      aria2cDir: null == aria2cDir
          ? _self.aria2cDir
          : aria2cDir // ignore: cast_nullable_to_non_nullable
              as String,
      aria2c: freezed == aria2c
          ? _self.aria2c
          : aria2c // ignore: cast_nullable_to_non_nullable
              as Aria2c?,
      aria2globalStat: freezed == aria2globalStat
          ? _self.aria2globalStat
          : aria2globalStat // ignore: cast_nullable_to_non_nullable
              as Aria2GlobalStat?,
    ));
  }
}

/// @nodoc

class _Aria2cModelState
    with DiagnosticableTreeMixin
    implements Aria2cModelState {
  const _Aria2cModelState(
      {required this.aria2cDir, this.aria2c, this.aria2globalStat});

  @override
  final String aria2cDir;
  @override
  final Aria2c? aria2c;
  @override
  final Aria2GlobalStat? aria2globalStat;

  /// Create a copy of Aria2cModelState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$Aria2cModelStateCopyWith<_Aria2cModelState> get copyWith =>
      __$Aria2cModelStateCopyWithImpl<_Aria2cModelState>(this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'Aria2cModelState'))
      ..add(DiagnosticsProperty('aria2cDir', aria2cDir))
      ..add(DiagnosticsProperty('aria2c', aria2c))
      ..add(DiagnosticsProperty('aria2globalStat', aria2globalStat));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Aria2cModelState &&
            (identical(other.aria2cDir, aria2cDir) ||
                other.aria2cDir == aria2cDir) &&
            (identical(other.aria2c, aria2c) || other.aria2c == aria2c) &&
            (identical(other.aria2globalStat, aria2globalStat) ||
                other.aria2globalStat == aria2globalStat));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, aria2cDir, aria2c, aria2globalStat);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Aria2cModelState(aria2cDir: $aria2cDir, aria2c: $aria2c, aria2globalStat: $aria2globalStat)';
  }
}

/// @nodoc
abstract mixin class _$Aria2cModelStateCopyWith<$Res>
    implements $Aria2cModelStateCopyWith<$Res> {
  factory _$Aria2cModelStateCopyWith(
          _Aria2cModelState value, $Res Function(_Aria2cModelState) _then) =
      __$Aria2cModelStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String aria2cDir, Aria2c? aria2c, Aria2GlobalStat? aria2globalStat});
}

/// @nodoc
class __$Aria2cModelStateCopyWithImpl<$Res>
    implements _$Aria2cModelStateCopyWith<$Res> {
  __$Aria2cModelStateCopyWithImpl(this._self, this._then);

  final _Aria2cModelState _self;
  final $Res Function(_Aria2cModelState) _then;

  /// Create a copy of Aria2cModelState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? aria2cDir = null,
    Object? aria2c = freezed,
    Object? aria2globalStat = freezed,
  }) {
    return _then(_Aria2cModelState(
      aria2cDir: null == aria2cDir
          ? _self.aria2cDir
          : aria2cDir // ignore: cast_nullable_to_non_nullable
              as String,
      aria2c: freezed == aria2c
          ? _self.aria2c
          : aria2c // ignore: cast_nullable_to_non_nullable
              as Aria2c?,
      aria2globalStat: freezed == aria2globalStat
          ? _self.aria2globalStat
          : aria2globalStat // ignore: cast_nullable_to_non_nullable
              as Aria2GlobalStat?,
    ));
  }
}

// dart format on
