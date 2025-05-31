// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nav_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NavState {
  List<NavApiDocsItemData>? get items;
  String get errorInfo;

  /// Create a copy of NavState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NavStateCopyWith<NavState> get copyWith =>
      _$NavStateCopyWithImpl<NavState>(this as NavState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NavState &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.errorInfo, errorInfo) ||
                other.errorInfo == errorInfo));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(items), errorInfo);

  @override
  String toString() {
    return 'NavState(items: $items, errorInfo: $errorInfo)';
  }
}

/// @nodoc
abstract mixin class $NavStateCopyWith<$Res> {
  factory $NavStateCopyWith(NavState value, $Res Function(NavState) _then) =
      _$NavStateCopyWithImpl;
  @useResult
  $Res call({List<NavApiDocsItemData>? items, String errorInfo});
}

/// @nodoc
class _$NavStateCopyWithImpl<$Res> implements $NavStateCopyWith<$Res> {
  _$NavStateCopyWithImpl(this._self, this._then);

  final NavState _self;
  final $Res Function(NavState) _then;

  /// Create a copy of NavState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = freezed,
    Object? errorInfo = null,
  }) {
    return _then(_self.copyWith(
      items: freezed == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<NavApiDocsItemData>?,
      errorInfo: null == errorInfo
          ? _self.errorInfo
          : errorInfo // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _NavState implements NavState {
  const _NavState({final List<NavApiDocsItemData>? items, this.errorInfo = ""})
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

  /// Create a copy of NavState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NavStateCopyWith<_NavState> get copyWith =>
      __$NavStateCopyWithImpl<_NavState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NavState &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.errorInfo, errorInfo) ||
                other.errorInfo == errorInfo));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_items), errorInfo);

  @override
  String toString() {
    return 'NavState(items: $items, errorInfo: $errorInfo)';
  }
}

/// @nodoc
abstract mixin class _$NavStateCopyWith<$Res>
    implements $NavStateCopyWith<$Res> {
  factory _$NavStateCopyWith(_NavState value, $Res Function(_NavState) _then) =
      __$NavStateCopyWithImpl;
  @override
  @useResult
  $Res call({List<NavApiDocsItemData>? items, String errorInfo});
}

/// @nodoc
class __$NavStateCopyWithImpl<$Res> implements _$NavStateCopyWith<$Res> {
  __$NavStateCopyWithImpl(this._self, this._then);

  final _NavState _self;
  final $Res Function(_NavState) _then;

  /// Create a copy of NavState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = freezed,
    Object? errorInfo = null,
  }) {
    return _then(_NavState(
      items: freezed == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<NavApiDocsItemData>?,
      errorInfo: null == errorInfo
          ? _self.errorInfo
          : errorInfo // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
