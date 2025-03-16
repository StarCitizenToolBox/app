// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'multi_window_manager.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MultiWindowAppState _$MultiWindowAppStateFromJson(Map<String, dynamic> json) {
  return _MultiWindowAppState.fromJson(json);
}

/// @nodoc
mixin _$MultiWindowAppState {
  String get backgroundColor => throw _privateConstructorUsedError;
  String get menuColor => throw _privateConstructorUsedError;
  String get micaColor => throw _privateConstructorUsedError;
  String? get languageCode => throw _privateConstructorUsedError;
  String? get countryCode => throw _privateConstructorUsedError;

  /// Serializes this MultiWindowAppState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MultiWindowAppState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MultiWindowAppStateCopyWith<MultiWindowAppState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MultiWindowAppStateCopyWith<$Res> {
  factory $MultiWindowAppStateCopyWith(
          MultiWindowAppState value, $Res Function(MultiWindowAppState) then) =
      _$MultiWindowAppStateCopyWithImpl<$Res, MultiWindowAppState>;
  @useResult
  $Res call(
      {String backgroundColor,
      String menuColor,
      String micaColor,
      String? languageCode,
      String? countryCode});
}

/// @nodoc
class _$MultiWindowAppStateCopyWithImpl<$Res, $Val extends MultiWindowAppState>
    implements $MultiWindowAppStateCopyWith<$Res> {
  _$MultiWindowAppStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MultiWindowAppState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? backgroundColor = null,
    Object? menuColor = null,
    Object? micaColor = null,
    Object? languageCode = freezed,
    Object? countryCode = freezed,
  }) {
    return _then(_value.copyWith(
      backgroundColor: null == backgroundColor
          ? _value.backgroundColor
          : backgroundColor // ignore: cast_nullable_to_non_nullable
              as String,
      menuColor: null == menuColor
          ? _value.menuColor
          : menuColor // ignore: cast_nullable_to_non_nullable
              as String,
      micaColor: null == micaColor
          ? _value.micaColor
          : micaColor // ignore: cast_nullable_to_non_nullable
              as String,
      languageCode: freezed == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String?,
      countryCode: freezed == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MultiWindowAppStateImplCopyWith<$Res>
    implements $MultiWindowAppStateCopyWith<$Res> {
  factory _$$MultiWindowAppStateImplCopyWith(_$MultiWindowAppStateImpl value,
          $Res Function(_$MultiWindowAppStateImpl) then) =
      __$$MultiWindowAppStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String backgroundColor,
      String menuColor,
      String micaColor,
      String? languageCode,
      String? countryCode});
}

/// @nodoc
class __$$MultiWindowAppStateImplCopyWithImpl<$Res>
    extends _$MultiWindowAppStateCopyWithImpl<$Res, _$MultiWindowAppStateImpl>
    implements _$$MultiWindowAppStateImplCopyWith<$Res> {
  __$$MultiWindowAppStateImplCopyWithImpl(_$MultiWindowAppStateImpl _value,
      $Res Function(_$MultiWindowAppStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of MultiWindowAppState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? backgroundColor = null,
    Object? menuColor = null,
    Object? micaColor = null,
    Object? languageCode = freezed,
    Object? countryCode = freezed,
  }) {
    return _then(_$MultiWindowAppStateImpl(
      backgroundColor: null == backgroundColor
          ? _value.backgroundColor
          : backgroundColor // ignore: cast_nullable_to_non_nullable
              as String,
      menuColor: null == menuColor
          ? _value.menuColor
          : menuColor // ignore: cast_nullable_to_non_nullable
              as String,
      micaColor: null == micaColor
          ? _value.micaColor
          : micaColor // ignore: cast_nullable_to_non_nullable
              as String,
      languageCode: freezed == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String?,
      countryCode: freezed == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MultiWindowAppStateImpl implements _MultiWindowAppState {
  const _$MultiWindowAppStateImpl(
      {required this.backgroundColor,
      required this.menuColor,
      required this.micaColor,
      this.languageCode,
      this.countryCode});

  factory _$MultiWindowAppStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$MultiWindowAppStateImplFromJson(json);

  @override
  final String backgroundColor;
  @override
  final String menuColor;
  @override
  final String micaColor;
  @override
  final String? languageCode;
  @override
  final String? countryCode;

  @override
  String toString() {
    return 'MultiWindowAppState(backgroundColor: $backgroundColor, menuColor: $menuColor, micaColor: $micaColor, languageCode: $languageCode, countryCode: $countryCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MultiWindowAppStateImpl &&
            (identical(other.backgroundColor, backgroundColor) ||
                other.backgroundColor == backgroundColor) &&
            (identical(other.menuColor, menuColor) ||
                other.menuColor == menuColor) &&
            (identical(other.micaColor, micaColor) ||
                other.micaColor == micaColor) &&
            (identical(other.languageCode, languageCode) ||
                other.languageCode == languageCode) &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, backgroundColor, menuColor,
      micaColor, languageCode, countryCode);

  /// Create a copy of MultiWindowAppState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MultiWindowAppStateImplCopyWith<_$MultiWindowAppStateImpl> get copyWith =>
      __$$MultiWindowAppStateImplCopyWithImpl<_$MultiWindowAppStateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MultiWindowAppStateImplToJson(
      this,
    );
  }
}

abstract class _MultiWindowAppState implements MultiWindowAppState {
  const factory _MultiWindowAppState(
      {required final String backgroundColor,
      required final String menuColor,
      required final String micaColor,
      final String? languageCode,
      final String? countryCode}) = _$MultiWindowAppStateImpl;

  factory _MultiWindowAppState.fromJson(Map<String, dynamic> json) =
      _$MultiWindowAppStateImpl.fromJson;

  @override
  String get backgroundColor;
  @override
  String get menuColor;
  @override
  String get micaColor;
  @override
  String? get languageCode;
  @override
  String? get countryCode;

  /// Create a copy of MultiWindowAppState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MultiWindowAppStateImplCopyWith<_$MultiWindowAppStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
