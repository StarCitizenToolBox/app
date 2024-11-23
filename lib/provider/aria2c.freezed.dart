// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'aria2c.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Aria2cModelState {
  String get aria2cDir => throw _privateConstructorUsedError;
  Aria2c? get aria2c => throw _privateConstructorUsedError;
  Aria2GlobalStat? get aria2globalStat => throw _privateConstructorUsedError;

  /// Create a copy of Aria2cModelState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $Aria2cModelStateCopyWith<Aria2cModelState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $Aria2cModelStateCopyWith<$Res> {
  factory $Aria2cModelStateCopyWith(
          Aria2cModelState value, $Res Function(Aria2cModelState) then) =
      _$Aria2cModelStateCopyWithImpl<$Res, Aria2cModelState>;
  @useResult
  $Res call(
      {String aria2cDir, Aria2c? aria2c, Aria2GlobalStat? aria2globalStat});
}

/// @nodoc
class _$Aria2cModelStateCopyWithImpl<$Res, $Val extends Aria2cModelState>
    implements $Aria2cModelStateCopyWith<$Res> {
  _$Aria2cModelStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Aria2cModelState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? aria2cDir = null,
    Object? aria2c = freezed,
    Object? aria2globalStat = freezed,
  }) {
    return _then(_value.copyWith(
      aria2cDir: null == aria2cDir
          ? _value.aria2cDir
          : aria2cDir // ignore: cast_nullable_to_non_nullable
              as String,
      aria2c: freezed == aria2c
          ? _value.aria2c
          : aria2c // ignore: cast_nullable_to_non_nullable
              as Aria2c?,
      aria2globalStat: freezed == aria2globalStat
          ? _value.aria2globalStat
          : aria2globalStat // ignore: cast_nullable_to_non_nullable
              as Aria2GlobalStat?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$Aria2cModelStateImplCopyWith<$Res>
    implements $Aria2cModelStateCopyWith<$Res> {
  factory _$$Aria2cModelStateImplCopyWith(_$Aria2cModelStateImpl value,
          $Res Function(_$Aria2cModelStateImpl) then) =
      __$$Aria2cModelStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String aria2cDir, Aria2c? aria2c, Aria2GlobalStat? aria2globalStat});
}

/// @nodoc
class __$$Aria2cModelStateImplCopyWithImpl<$Res>
    extends _$Aria2cModelStateCopyWithImpl<$Res, _$Aria2cModelStateImpl>
    implements _$$Aria2cModelStateImplCopyWith<$Res> {
  __$$Aria2cModelStateImplCopyWithImpl(_$Aria2cModelStateImpl _value,
      $Res Function(_$Aria2cModelStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of Aria2cModelState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? aria2cDir = null,
    Object? aria2c = freezed,
    Object? aria2globalStat = freezed,
  }) {
    return _then(_$Aria2cModelStateImpl(
      aria2cDir: null == aria2cDir
          ? _value.aria2cDir
          : aria2cDir // ignore: cast_nullable_to_non_nullable
              as String,
      aria2c: freezed == aria2c
          ? _value.aria2c
          : aria2c // ignore: cast_nullable_to_non_nullable
              as Aria2c?,
      aria2globalStat: freezed == aria2globalStat
          ? _value.aria2globalStat
          : aria2globalStat // ignore: cast_nullable_to_non_nullable
              as Aria2GlobalStat?,
    ));
  }
}

/// @nodoc

class _$Aria2cModelStateImpl
    with DiagnosticableTreeMixin
    implements _Aria2cModelState {
  const _$Aria2cModelStateImpl(
      {required this.aria2cDir, this.aria2c, this.aria2globalStat});

  @override
  final String aria2cDir;
  @override
  final Aria2c? aria2c;
  @override
  final Aria2GlobalStat? aria2globalStat;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Aria2cModelState(aria2cDir: $aria2cDir, aria2c: $aria2c, aria2globalStat: $aria2globalStat)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
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
            other is _$Aria2cModelStateImpl &&
            (identical(other.aria2cDir, aria2cDir) ||
                other.aria2cDir == aria2cDir) &&
            (identical(other.aria2c, aria2c) || other.aria2c == aria2c) &&
            const DeepCollectionEquality()
                .equals(other.aria2globalStat, aria2globalStat));
  }

  @override
  int get hashCode => Object.hash(runtimeType, aria2cDir, aria2c,
      const DeepCollectionEquality().hash(aria2globalStat));

  /// Create a copy of Aria2cModelState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$Aria2cModelStateImplCopyWith<_$Aria2cModelStateImpl> get copyWith =>
      __$$Aria2cModelStateImplCopyWithImpl<_$Aria2cModelStateImpl>(
          this, _$identity);
}

abstract class _Aria2cModelState implements Aria2cModelState {
  const factory _Aria2cModelState(
      {required final String aria2cDir,
      final Aria2c? aria2c,
      final Aria2GlobalStat? aria2globalStat}) = _$Aria2cModelStateImpl;

  @override
  String get aria2cDir;
  @override
  Aria2c? get aria2c;
  @override
  Aria2GlobalStat? get aria2globalStat;

  /// Create a copy of Aria2cModelState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$Aria2cModelStateImplCopyWith<_$Aria2cModelStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
