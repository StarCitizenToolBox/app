// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nav_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NavState {
  List<NavApiDocsItemData>? get items => throw _privateConstructorUsedError;
  String get errorInfo => throw _privateConstructorUsedError;

  /// Create a copy of NavState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NavStateCopyWith<NavState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NavStateCopyWith<$Res> {
  factory $NavStateCopyWith(NavState value, $Res Function(NavState) then) =
      _$NavStateCopyWithImpl<$Res, NavState>;
  @useResult
  $Res call({List<NavApiDocsItemData>? items, String errorInfo});
}

/// @nodoc
class _$NavStateCopyWithImpl<$Res, $Val extends NavState>
    implements $NavStateCopyWith<$Res> {
  _$NavStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NavState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = freezed,
    Object? errorInfo = null,
  }) {
    return _then(_value.copyWith(
      items: freezed == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<NavApiDocsItemData>?,
      errorInfo: null == errorInfo
          ? _value.errorInfo
          : errorInfo // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NavStateImplCopyWith<$Res>
    implements $NavStateCopyWith<$Res> {
  factory _$$NavStateImplCopyWith(
          _$NavStateImpl value, $Res Function(_$NavStateImpl) then) =
      __$$NavStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<NavApiDocsItemData>? items, String errorInfo});
}

/// @nodoc
class __$$NavStateImplCopyWithImpl<$Res>
    extends _$NavStateCopyWithImpl<$Res, _$NavStateImpl>
    implements _$$NavStateImplCopyWith<$Res> {
  __$$NavStateImplCopyWithImpl(
      _$NavStateImpl _value, $Res Function(_$NavStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of NavState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = freezed,
    Object? errorInfo = null,
  }) {
    return _then(_$NavStateImpl(
      items: freezed == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<NavApiDocsItemData>?,
      errorInfo: null == errorInfo
          ? _value.errorInfo
          : errorInfo // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$NavStateImpl implements _NavState {
  const _$NavStateImpl(
      {final List<NavApiDocsItemData>? items, this.errorInfo = ""})
      : _items = items;

  final List<NavApiDocsItemData>? _items;
  @override
  List<NavApiDocsItemData>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final String errorInfo;

  @override
  String toString() {
    return 'NavState(items: $items, errorInfo: $errorInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NavStateImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.errorInfo, errorInfo) ||
                other.errorInfo == errorInfo));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_items), errorInfo);

  /// Create a copy of NavState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NavStateImplCopyWith<_$NavStateImpl> get copyWith =>
      __$$NavStateImplCopyWithImpl<_$NavStateImpl>(this, _$identity);
}

abstract class _NavState implements NavState {
  const factory _NavState(
      {final List<NavApiDocsItemData>? items,
      final String errorInfo}) = _$NavStateImpl;

  @override
  List<NavApiDocsItemData>? get items;
  @override
  String get errorInfo;

  /// Create a copy of NavState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NavStateImplCopyWith<_$NavStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
