// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InputMethodServerState {
  bool get isServerStartup => throw _privateConstructorUsedError;
  String? get serverAddressText => throw _privateConstructorUsedError;

  /// Create a copy of InputMethodServerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InputMethodServerStateCopyWith<InputMethodServerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InputMethodServerStateCopyWith<$Res> {
  factory $InputMethodServerStateCopyWith(InputMethodServerState value,
          $Res Function(InputMethodServerState) then) =
      _$InputMethodServerStateCopyWithImpl<$Res, InputMethodServerState>;
  @useResult
  $Res call({bool isServerStartup, String? serverAddressText});
}

/// @nodoc
class _$InputMethodServerStateCopyWithImpl<$Res,
        $Val extends InputMethodServerState>
    implements $InputMethodServerStateCopyWith<$Res> {
  _$InputMethodServerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InputMethodServerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isServerStartup = null,
    Object? serverAddressText = freezed,
  }) {
    return _then(_value.copyWith(
      isServerStartup: null == isServerStartup
          ? _value.isServerStartup
          : isServerStartup // ignore: cast_nullable_to_non_nullable
              as bool,
      serverAddressText: freezed == serverAddressText
          ? _value.serverAddressText
          : serverAddressText // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InputMethodServerStateImplCopyWith<$Res>
    implements $InputMethodServerStateCopyWith<$Res> {
  factory _$$InputMethodServerStateImplCopyWith(
          _$InputMethodServerStateImpl value,
          $Res Function(_$InputMethodServerStateImpl) then) =
      __$$InputMethodServerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isServerStartup, String? serverAddressText});
}

/// @nodoc
class __$$InputMethodServerStateImplCopyWithImpl<$Res>
    extends _$InputMethodServerStateCopyWithImpl<$Res,
        _$InputMethodServerStateImpl>
    implements _$$InputMethodServerStateImplCopyWith<$Res> {
  __$$InputMethodServerStateImplCopyWithImpl(
      _$InputMethodServerStateImpl _value,
      $Res Function(_$InputMethodServerStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of InputMethodServerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isServerStartup = null,
    Object? serverAddressText = freezed,
  }) {
    return _then(_$InputMethodServerStateImpl(
      isServerStartup: null == isServerStartup
          ? _value.isServerStartup
          : isServerStartup // ignore: cast_nullable_to_non_nullable
              as bool,
      serverAddressText: freezed == serverAddressText
          ? _value.serverAddressText
          : serverAddressText // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$InputMethodServerStateImpl implements _InputMethodServerState {
  const _$InputMethodServerStateImpl(
      {this.isServerStartup = false, this.serverAddressText});

  @override
  @JsonKey()
  final bool isServerStartup;
  @override
  final String? serverAddressText;

  @override
  String toString() {
    return 'InputMethodServerState(isServerStartup: $isServerStartup, serverAddressText: $serverAddressText)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InputMethodServerStateImpl &&
            (identical(other.isServerStartup, isServerStartup) ||
                other.isServerStartup == isServerStartup) &&
            (identical(other.serverAddressText, serverAddressText) ||
                other.serverAddressText == serverAddressText));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isServerStartup, serverAddressText);

  /// Create a copy of InputMethodServerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InputMethodServerStateImplCopyWith<_$InputMethodServerStateImpl>
      get copyWith => __$$InputMethodServerStateImplCopyWithImpl<
          _$InputMethodServerStateImpl>(this, _$identity);
}

abstract class _InputMethodServerState implements InputMethodServerState {
  const factory _InputMethodServerState(
      {final bool isServerStartup,
      final String? serverAddressText}) = _$InputMethodServerStateImpl;

  @override
  bool get isServerStartup;
  @override
  String? get serverAddressText;

  /// Create a copy of InputMethodServerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InputMethodServerStateImplCopyWith<_$InputMethodServerStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
