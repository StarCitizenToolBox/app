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
  bool get isDaemonRunning => throw _privateConstructorUsedError;
  String get aria2cDir => throw _privateConstructorUsedError;
  Aria2c? get aria2c => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $Aria2cModelStateCopyWith<Aria2cModelState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $Aria2cModelStateCopyWith<$Res> {
  factory $Aria2cModelStateCopyWith(
          Aria2cModelState value, $Res Function(Aria2cModelState) then) =
      _$Aria2cModelStateCopyWithImpl<$Res, Aria2cModelState>;
  @useResult
  $Res call({bool isDaemonRunning, String aria2cDir, Aria2c? aria2c});
}

/// @nodoc
class _$Aria2cModelStateCopyWithImpl<$Res, $Val extends Aria2cModelState>
    implements $Aria2cModelStateCopyWith<$Res> {
  _$Aria2cModelStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isDaemonRunning = null,
    Object? aria2cDir = null,
    Object? aria2c = freezed,
  }) {
    return _then(_value.copyWith(
      isDaemonRunning: null == isDaemonRunning
          ? _value.isDaemonRunning
          : isDaemonRunning // ignore: cast_nullable_to_non_nullable
              as bool,
      aria2cDir: null == aria2cDir
          ? _value.aria2cDir
          : aria2cDir // ignore: cast_nullable_to_non_nullable
              as String,
      aria2c: freezed == aria2c
          ? _value.aria2c
          : aria2c // ignore: cast_nullable_to_non_nullable
              as Aria2c?,
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
  $Res call({bool isDaemonRunning, String aria2cDir, Aria2c? aria2c});
}

/// @nodoc
class __$$Aria2cModelStateImplCopyWithImpl<$Res>
    extends _$Aria2cModelStateCopyWithImpl<$Res, _$Aria2cModelStateImpl>
    implements _$$Aria2cModelStateImplCopyWith<$Res> {
  __$$Aria2cModelStateImplCopyWithImpl(_$Aria2cModelStateImpl _value,
      $Res Function(_$Aria2cModelStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isDaemonRunning = null,
    Object? aria2cDir = null,
    Object? aria2c = freezed,
  }) {
    return _then(_$Aria2cModelStateImpl(
      isDaemonRunning: null == isDaemonRunning
          ? _value.isDaemonRunning
          : isDaemonRunning // ignore: cast_nullable_to_non_nullable
              as bool,
      aria2cDir: null == aria2cDir
          ? _value.aria2cDir
          : aria2cDir // ignore: cast_nullable_to_non_nullable
              as String,
      aria2c: freezed == aria2c
          ? _value.aria2c
          : aria2c // ignore: cast_nullable_to_non_nullable
              as Aria2c?,
    ));
  }
}

/// @nodoc

class _$Aria2cModelStateImpl
    with DiagnosticableTreeMixin
    implements _Aria2cModelState {
  const _$Aria2cModelStateImpl(
      {required this.isDaemonRunning, required this.aria2cDir, this.aria2c});

  @override
  final bool isDaemonRunning;
  @override
  final String aria2cDir;
  @override
  final Aria2c? aria2c;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Aria2cModelState(isDaemonRunning: $isDaemonRunning, aria2cDir: $aria2cDir, aria2c: $aria2c)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Aria2cModelState'))
      ..add(DiagnosticsProperty('isDaemonRunning', isDaemonRunning))
      ..add(DiagnosticsProperty('aria2cDir', aria2cDir))
      ..add(DiagnosticsProperty('aria2c', aria2c));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Aria2cModelStateImpl &&
            (identical(other.isDaemonRunning, isDaemonRunning) ||
                other.isDaemonRunning == isDaemonRunning) &&
            (identical(other.aria2cDir, aria2cDir) ||
                other.aria2cDir == aria2cDir) &&
            (identical(other.aria2c, aria2c) || other.aria2c == aria2c));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isDaemonRunning, aria2cDir, aria2c);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$Aria2cModelStateImplCopyWith<_$Aria2cModelStateImpl> get copyWith =>
      __$$Aria2cModelStateImplCopyWithImpl<_$Aria2cModelStateImpl>(
          this, _$identity);
}

abstract class _Aria2cModelState implements Aria2cModelState {
  const factory _Aria2cModelState(
      {required final bool isDaemonRunning,
      required final String aria2cDir,
      final Aria2c? aria2c}) = _$Aria2cModelStateImpl;

  @override
  bool get isDaemonRunning;
  @override
  String get aria2cDir;
  @override
  Aria2c? get aria2c;
  @override
  @JsonKey(ignore: true)
  _$$Aria2cModelStateImplCopyWith<_$Aria2cModelStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
