// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'input_method_dialog_ui_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InputMethodDialogUIState {
  Map<String, String>? get keyMaps => throw _privateConstructorUsedError;
  Map<String, String>? get worldMaps => throw _privateConstructorUsedError;
  bool get enableAutoCopy => throw _privateConstructorUsedError;

  /// Create a copy of InputMethodDialogUIState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InputMethodDialogUIStateCopyWith<InputMethodDialogUIState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InputMethodDialogUIStateCopyWith<$Res> {
  factory $InputMethodDialogUIStateCopyWith(InputMethodDialogUIState value,
          $Res Function(InputMethodDialogUIState) then) =
      _$InputMethodDialogUIStateCopyWithImpl<$Res, InputMethodDialogUIState>;
  @useResult
  $Res call(
      {Map<String, String>? keyMaps,
      Map<String, String>? worldMaps,
      bool enableAutoCopy});
}

/// @nodoc
class _$InputMethodDialogUIStateCopyWithImpl<$Res,
        $Val extends InputMethodDialogUIState>
    implements $InputMethodDialogUIStateCopyWith<$Res> {
  _$InputMethodDialogUIStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InputMethodDialogUIState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? keyMaps = freezed,
    Object? worldMaps = freezed,
    Object? enableAutoCopy = null,
  }) {
    return _then(_value.copyWith(
      keyMaps: freezed == keyMaps
          ? _value.keyMaps
          : keyMaps // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      worldMaps: freezed == worldMaps
          ? _value.worldMaps
          : worldMaps // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      enableAutoCopy: null == enableAutoCopy
          ? _value.enableAutoCopy
          : enableAutoCopy // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InputMethodDialogUIStateImplCopyWith<$Res>
    implements $InputMethodDialogUIStateCopyWith<$Res> {
  factory _$$InputMethodDialogUIStateImplCopyWith(
          _$InputMethodDialogUIStateImpl value,
          $Res Function(_$InputMethodDialogUIStateImpl) then) =
      __$$InputMethodDialogUIStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, String>? keyMaps,
      Map<String, String>? worldMaps,
      bool enableAutoCopy});
}

/// @nodoc
class __$$InputMethodDialogUIStateImplCopyWithImpl<$Res>
    extends _$InputMethodDialogUIStateCopyWithImpl<$Res,
        _$InputMethodDialogUIStateImpl>
    implements _$$InputMethodDialogUIStateImplCopyWith<$Res> {
  __$$InputMethodDialogUIStateImplCopyWithImpl(
      _$InputMethodDialogUIStateImpl _value,
      $Res Function(_$InputMethodDialogUIStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of InputMethodDialogUIState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? keyMaps = freezed,
    Object? worldMaps = freezed,
    Object? enableAutoCopy = null,
  }) {
    return _then(_$InputMethodDialogUIStateImpl(
      freezed == keyMaps
          ? _value._keyMaps
          : keyMaps // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      freezed == worldMaps
          ? _value._worldMaps
          : worldMaps // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      enableAutoCopy: null == enableAutoCopy
          ? _value.enableAutoCopy
          : enableAutoCopy // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$InputMethodDialogUIStateImpl implements _InputMethodDialogUIState {
  _$InputMethodDialogUIStateImpl(
      final Map<String, String>? keyMaps, final Map<String, String>? worldMaps,
      {this.enableAutoCopy = false})
      : _keyMaps = keyMaps,
        _worldMaps = worldMaps;

  final Map<String, String>? _keyMaps;
  @override
  Map<String, String>? get keyMaps {
    final value = _keyMaps;
    if (value == null) return null;
    if (_keyMaps is EqualUnmodifiableMapView) return _keyMaps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, String>? _worldMaps;
  @override
  Map<String, String>? get worldMaps {
    final value = _worldMaps;
    if (value == null) return null;
    if (_worldMaps is EqualUnmodifiableMapView) return _worldMaps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final bool enableAutoCopy;

  @override
  String toString() {
    return 'InputMethodDialogUIState(keyMaps: $keyMaps, worldMaps: $worldMaps, enableAutoCopy: $enableAutoCopy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InputMethodDialogUIStateImpl &&
            const DeepCollectionEquality().equals(other._keyMaps, _keyMaps) &&
            const DeepCollectionEquality()
                .equals(other._worldMaps, _worldMaps) &&
            (identical(other.enableAutoCopy, enableAutoCopy) ||
                other.enableAutoCopy == enableAutoCopy));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_keyMaps),
      const DeepCollectionEquality().hash(_worldMaps),
      enableAutoCopy);

  /// Create a copy of InputMethodDialogUIState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InputMethodDialogUIStateImplCopyWith<_$InputMethodDialogUIStateImpl>
      get copyWith => __$$InputMethodDialogUIStateImplCopyWithImpl<
          _$InputMethodDialogUIStateImpl>(this, _$identity);
}

abstract class _InputMethodDialogUIState implements InputMethodDialogUIState {
  factory _InputMethodDialogUIState(
      final Map<String, String>? keyMaps, final Map<String, String>? worldMaps,
      {final bool enableAutoCopy}) = _$InputMethodDialogUIStateImpl;

  @override
  Map<String, String>? get keyMaps;
  @override
  Map<String, String>? get worldMaps;
  @override
  bool get enableAutoCopy;

  /// Create a copy of InputMethodDialogUIState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InputMethodDialogUIStateImplCopyWith<_$InputMethodDialogUIStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
