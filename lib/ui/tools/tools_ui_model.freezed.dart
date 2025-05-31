// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tools_ui_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ToolsUIState {
  bool get working;
  String get scInstalledPath;
  String get rsiLauncherInstalledPath;
  List<String> get scInstallPaths;
  List<String> get rsiLauncherInstallPaths;
  List<ToolsItemData> get items;
  bool get isItemLoading;

  /// Create a copy of ToolsUIState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ToolsUIStateCopyWith<ToolsUIState> get copyWith =>
      _$ToolsUIStateCopyWithImpl<ToolsUIState>(
          this as ToolsUIState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ToolsUIState &&
            (identical(other.working, working) || other.working == working) &&
            (identical(other.scInstalledPath, scInstalledPath) ||
                other.scInstalledPath == scInstalledPath) &&
            (identical(
                    other.rsiLauncherInstalledPath, rsiLauncherInstalledPath) ||
                other.rsiLauncherInstalledPath == rsiLauncherInstalledPath) &&
            const DeepCollectionEquality()
                .equals(other.scInstallPaths, scInstallPaths) &&
            const DeepCollectionEquality().equals(
                other.rsiLauncherInstallPaths, rsiLauncherInstallPaths) &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.isItemLoading, isItemLoading) ||
                other.isItemLoading == isItemLoading));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      working,
      scInstalledPath,
      rsiLauncherInstalledPath,
      const DeepCollectionEquality().hash(scInstallPaths),
      const DeepCollectionEquality().hash(rsiLauncherInstallPaths),
      const DeepCollectionEquality().hash(items),
      isItemLoading);

  @override
  String toString() {
    return 'ToolsUIState(working: $working, scInstalledPath: $scInstalledPath, rsiLauncherInstalledPath: $rsiLauncherInstalledPath, scInstallPaths: $scInstallPaths, rsiLauncherInstallPaths: $rsiLauncherInstallPaths, items: $items, isItemLoading: $isItemLoading)';
  }
}

/// @nodoc
abstract mixin class $ToolsUIStateCopyWith<$Res> {
  factory $ToolsUIStateCopyWith(
          ToolsUIState value, $Res Function(ToolsUIState) _then) =
      _$ToolsUIStateCopyWithImpl;
  @useResult
  $Res call(
      {bool working,
      String scInstalledPath,
      String rsiLauncherInstalledPath,
      List<String> scInstallPaths,
      List<String> rsiLauncherInstallPaths,
      List<ToolsItemData> items,
      bool isItemLoading});
}

/// @nodoc
class _$ToolsUIStateCopyWithImpl<$Res> implements $ToolsUIStateCopyWith<$Res> {
  _$ToolsUIStateCopyWithImpl(this._self, this._then);

  final ToolsUIState _self;
  final $Res Function(ToolsUIState) _then;

  /// Create a copy of ToolsUIState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? working = null,
    Object? scInstalledPath = null,
    Object? rsiLauncherInstalledPath = null,
    Object? scInstallPaths = null,
    Object? rsiLauncherInstallPaths = null,
    Object? items = null,
    Object? isItemLoading = null,
  }) {
    return _then(_self.copyWith(
      working: null == working
          ? _self.working
          : working // ignore: cast_nullable_to_non_nullable
              as bool,
      scInstalledPath: null == scInstalledPath
          ? _self.scInstalledPath
          : scInstalledPath // ignore: cast_nullable_to_non_nullable
              as String,
      rsiLauncherInstalledPath: null == rsiLauncherInstalledPath
          ? _self.rsiLauncherInstalledPath
          : rsiLauncherInstalledPath // ignore: cast_nullable_to_non_nullable
              as String,
      scInstallPaths: null == scInstallPaths
          ? _self.scInstallPaths
          : scInstallPaths // ignore: cast_nullable_to_non_nullable
              as List<String>,
      rsiLauncherInstallPaths: null == rsiLauncherInstallPaths
          ? _self.rsiLauncherInstallPaths
          : rsiLauncherInstallPaths // ignore: cast_nullable_to_non_nullable
              as List<String>,
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ToolsItemData>,
      isItemLoading: null == isItemLoading
          ? _self.isItemLoading
          : isItemLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _ToolsUIState implements ToolsUIState {
  _ToolsUIState(
      {this.working = false,
      this.scInstalledPath = "",
      this.rsiLauncherInstalledPath = "",
      final List<String> scInstallPaths = const [],
      final List<String> rsiLauncherInstallPaths = const [],
      final List<ToolsItemData> items = const [],
      this.isItemLoading = false})
      : _scInstallPaths = scInstallPaths,
        _rsiLauncherInstallPaths = rsiLauncherInstallPaths,
        _items = items;

  @override
  @JsonKey()
  final bool working;
  @override
  @JsonKey()
  final String scInstalledPath;
  @override
  @JsonKey()
  final String rsiLauncherInstalledPath;
  final List<String> _scInstallPaths;
  @override
  @JsonKey()
  List<String> get scInstallPaths {
    if (_scInstallPaths is EqualUnmodifiableListView) return _scInstallPaths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scInstallPaths);
  }

  final List<String> _rsiLauncherInstallPaths;
  @override
  @JsonKey()
  List<String> get rsiLauncherInstallPaths {
    if (_rsiLauncherInstallPaths is EqualUnmodifiableListView)
      return _rsiLauncherInstallPaths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rsiLauncherInstallPaths);
  }

  final List<ToolsItemData> _items;
  @override
  @JsonKey()
  List<ToolsItemData> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey()
  final bool isItemLoading;

  /// Create a copy of ToolsUIState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ToolsUIStateCopyWith<_ToolsUIState> get copyWith =>
      __$ToolsUIStateCopyWithImpl<_ToolsUIState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ToolsUIState &&
            (identical(other.working, working) || other.working == working) &&
            (identical(other.scInstalledPath, scInstalledPath) ||
                other.scInstalledPath == scInstalledPath) &&
            (identical(
                    other.rsiLauncherInstalledPath, rsiLauncherInstalledPath) ||
                other.rsiLauncherInstalledPath == rsiLauncherInstalledPath) &&
            const DeepCollectionEquality()
                .equals(other._scInstallPaths, _scInstallPaths) &&
            const DeepCollectionEquality().equals(
                other._rsiLauncherInstallPaths, _rsiLauncherInstallPaths) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.isItemLoading, isItemLoading) ||
                other.isItemLoading == isItemLoading));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      working,
      scInstalledPath,
      rsiLauncherInstalledPath,
      const DeepCollectionEquality().hash(_scInstallPaths),
      const DeepCollectionEquality().hash(_rsiLauncherInstallPaths),
      const DeepCollectionEquality().hash(_items),
      isItemLoading);

  @override
  String toString() {
    return 'ToolsUIState(working: $working, scInstalledPath: $scInstalledPath, rsiLauncherInstalledPath: $rsiLauncherInstalledPath, scInstallPaths: $scInstallPaths, rsiLauncherInstallPaths: $rsiLauncherInstallPaths, items: $items, isItemLoading: $isItemLoading)';
  }
}

/// @nodoc
abstract mixin class _$ToolsUIStateCopyWith<$Res>
    implements $ToolsUIStateCopyWith<$Res> {
  factory _$ToolsUIStateCopyWith(
          _ToolsUIState value, $Res Function(_ToolsUIState) _then) =
      __$ToolsUIStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool working,
      String scInstalledPath,
      String rsiLauncherInstalledPath,
      List<String> scInstallPaths,
      List<String> rsiLauncherInstallPaths,
      List<ToolsItemData> items,
      bool isItemLoading});
}

/// @nodoc
class __$ToolsUIStateCopyWithImpl<$Res>
    implements _$ToolsUIStateCopyWith<$Res> {
  __$ToolsUIStateCopyWithImpl(this._self, this._then);

  final _ToolsUIState _self;
  final $Res Function(_ToolsUIState) _then;

  /// Create a copy of ToolsUIState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? working = null,
    Object? scInstalledPath = null,
    Object? rsiLauncherInstalledPath = null,
    Object? scInstallPaths = null,
    Object? rsiLauncherInstallPaths = null,
    Object? items = null,
    Object? isItemLoading = null,
  }) {
    return _then(_ToolsUIState(
      working: null == working
          ? _self.working
          : working // ignore: cast_nullable_to_non_nullable
              as bool,
      scInstalledPath: null == scInstalledPath
          ? _self.scInstalledPath
          : scInstalledPath // ignore: cast_nullable_to_non_nullable
              as String,
      rsiLauncherInstalledPath: null == rsiLauncherInstalledPath
          ? _self.rsiLauncherInstalledPath
          : rsiLauncherInstalledPath // ignore: cast_nullable_to_non_nullable
              as String,
      scInstallPaths: null == scInstallPaths
          ? _self._scInstallPaths
          : scInstallPaths // ignore: cast_nullable_to_non_nullable
              as List<String>,
      rsiLauncherInstallPaths: null == rsiLauncherInstallPaths
          ? _self._rsiLauncherInstallPaths
          : rsiLauncherInstallPaths // ignore: cast_nullable_to_non_nullable
              as List<String>,
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ToolsItemData>,
      isItemLoading: null == isItemLoading
          ? _self.isItemLoading
          : isItemLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
