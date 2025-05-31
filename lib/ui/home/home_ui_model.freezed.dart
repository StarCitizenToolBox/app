// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_ui_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HomeUIModelState {
  AppPlacardData? get appPlacardData;
  bool get isFixing;
  String get isFixingString;
  String? get scInstalledPath;
  List<String> get scInstallPaths;
  AppWebLocalizationVersionsData? get webLocalizationVersionsData;
  String get lastScreenInfo;
  List<RssItem>? get rssVideoItems;
  List<RssItem>? get rssTextItems;
  MapEntry<String, bool>? get localizationUpdateInfo;
  List? get scServerStatus;
  List<CountdownFestivalItemData>? get countdownFestivalListData;
  Map<String, bool> get isGameRunning;

  /// Create a copy of HomeUIModelState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HomeUIModelStateCopyWith<HomeUIModelState> get copyWith =>
      _$HomeUIModelStateCopyWithImpl<HomeUIModelState>(
          this as HomeUIModelState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HomeUIModelState &&
            (identical(other.appPlacardData, appPlacardData) ||
                other.appPlacardData == appPlacardData) &&
            (identical(other.isFixing, isFixing) ||
                other.isFixing == isFixing) &&
            (identical(other.isFixingString, isFixingString) ||
                other.isFixingString == isFixingString) &&
            (identical(other.scInstalledPath, scInstalledPath) ||
                other.scInstalledPath == scInstalledPath) &&
            const DeepCollectionEquality()
                .equals(other.scInstallPaths, scInstallPaths) &&
            (identical(other.webLocalizationVersionsData,
                    webLocalizationVersionsData) ||
                other.webLocalizationVersionsData ==
                    webLocalizationVersionsData) &&
            (identical(other.lastScreenInfo, lastScreenInfo) ||
                other.lastScreenInfo == lastScreenInfo) &&
            const DeepCollectionEquality()
                .equals(other.rssVideoItems, rssVideoItems) &&
            const DeepCollectionEquality()
                .equals(other.rssTextItems, rssTextItems) &&
            (identical(other.localizationUpdateInfo, localizationUpdateInfo) ||
                other.localizationUpdateInfo == localizationUpdateInfo) &&
            const DeepCollectionEquality()
                .equals(other.scServerStatus, scServerStatus) &&
            const DeepCollectionEquality().equals(
                other.countdownFestivalListData, countdownFestivalListData) &&
            const DeepCollectionEquality()
                .equals(other.isGameRunning, isGameRunning));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      appPlacardData,
      isFixing,
      isFixingString,
      scInstalledPath,
      const DeepCollectionEquality().hash(scInstallPaths),
      webLocalizationVersionsData,
      lastScreenInfo,
      const DeepCollectionEquality().hash(rssVideoItems),
      const DeepCollectionEquality().hash(rssTextItems),
      localizationUpdateInfo,
      const DeepCollectionEquality().hash(scServerStatus),
      const DeepCollectionEquality().hash(countdownFestivalListData),
      const DeepCollectionEquality().hash(isGameRunning));

  @override
  String toString() {
    return 'HomeUIModelState(appPlacardData: $appPlacardData, isFixing: $isFixing, isFixingString: $isFixingString, scInstalledPath: $scInstalledPath, scInstallPaths: $scInstallPaths, webLocalizationVersionsData: $webLocalizationVersionsData, lastScreenInfo: $lastScreenInfo, rssVideoItems: $rssVideoItems, rssTextItems: $rssTextItems, localizationUpdateInfo: $localizationUpdateInfo, scServerStatus: $scServerStatus, countdownFestivalListData: $countdownFestivalListData, isGameRunning: $isGameRunning)';
  }
}

/// @nodoc
abstract mixin class $HomeUIModelStateCopyWith<$Res> {
  factory $HomeUIModelStateCopyWith(
          HomeUIModelState value, $Res Function(HomeUIModelState) _then) =
      _$HomeUIModelStateCopyWithImpl;
  @useResult
  $Res call(
      {AppPlacardData? appPlacardData,
      bool isFixing,
      String isFixingString,
      String? scInstalledPath,
      List<String> scInstallPaths,
      AppWebLocalizationVersionsData? webLocalizationVersionsData,
      String lastScreenInfo,
      List<RssItem>? rssVideoItems,
      List<RssItem>? rssTextItems,
      MapEntry<String, bool>? localizationUpdateInfo,
      List? scServerStatus,
      List<CountdownFestivalItemData>? countdownFestivalListData,
      Map<String, bool> isGameRunning});
}

/// @nodoc
class _$HomeUIModelStateCopyWithImpl<$Res>
    implements $HomeUIModelStateCopyWith<$Res> {
  _$HomeUIModelStateCopyWithImpl(this._self, this._then);

  final HomeUIModelState _self;
  final $Res Function(HomeUIModelState) _then;

  /// Create a copy of HomeUIModelState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appPlacardData = freezed,
    Object? isFixing = null,
    Object? isFixingString = null,
    Object? scInstalledPath = freezed,
    Object? scInstallPaths = null,
    Object? webLocalizationVersionsData = freezed,
    Object? lastScreenInfo = null,
    Object? rssVideoItems = freezed,
    Object? rssTextItems = freezed,
    Object? localizationUpdateInfo = freezed,
    Object? scServerStatus = freezed,
    Object? countdownFestivalListData = freezed,
    Object? isGameRunning = null,
  }) {
    return _then(_self.copyWith(
      appPlacardData: freezed == appPlacardData
          ? _self.appPlacardData
          : appPlacardData // ignore: cast_nullable_to_non_nullable
              as AppPlacardData?,
      isFixing: null == isFixing
          ? _self.isFixing
          : isFixing // ignore: cast_nullable_to_non_nullable
              as bool,
      isFixingString: null == isFixingString
          ? _self.isFixingString
          : isFixingString // ignore: cast_nullable_to_non_nullable
              as String,
      scInstalledPath: freezed == scInstalledPath
          ? _self.scInstalledPath
          : scInstalledPath // ignore: cast_nullable_to_non_nullable
              as String?,
      scInstallPaths: null == scInstallPaths
          ? _self.scInstallPaths
          : scInstallPaths // ignore: cast_nullable_to_non_nullable
              as List<String>,
      webLocalizationVersionsData: freezed == webLocalizationVersionsData
          ? _self.webLocalizationVersionsData
          : webLocalizationVersionsData // ignore: cast_nullable_to_non_nullable
              as AppWebLocalizationVersionsData?,
      lastScreenInfo: null == lastScreenInfo
          ? _self.lastScreenInfo
          : lastScreenInfo // ignore: cast_nullable_to_non_nullable
              as String,
      rssVideoItems: freezed == rssVideoItems
          ? _self.rssVideoItems
          : rssVideoItems // ignore: cast_nullable_to_non_nullable
              as List<RssItem>?,
      rssTextItems: freezed == rssTextItems
          ? _self.rssTextItems
          : rssTextItems // ignore: cast_nullable_to_non_nullable
              as List<RssItem>?,
      localizationUpdateInfo: freezed == localizationUpdateInfo
          ? _self.localizationUpdateInfo
          : localizationUpdateInfo // ignore: cast_nullable_to_non_nullable
              as MapEntry<String, bool>?,
      scServerStatus: freezed == scServerStatus
          ? _self.scServerStatus
          : scServerStatus // ignore: cast_nullable_to_non_nullable
              as List?,
      countdownFestivalListData: freezed == countdownFestivalListData
          ? _self.countdownFestivalListData
          : countdownFestivalListData // ignore: cast_nullable_to_non_nullable
              as List<CountdownFestivalItemData>?,
      isGameRunning: null == isGameRunning
          ? _self.isGameRunning
          : isGameRunning // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
    ));
  }
}

/// @nodoc

class _HomeUIModelState implements HomeUIModelState {
  _HomeUIModelState(
      {this.appPlacardData,
      this.isFixing = false,
      this.isFixingString = "",
      this.scInstalledPath,
      final List<String> scInstallPaths = const [],
      this.webLocalizationVersionsData,
      this.lastScreenInfo = "",
      final List<RssItem>? rssVideoItems,
      final List<RssItem>? rssTextItems,
      this.localizationUpdateInfo,
      final List? scServerStatus,
      final List<CountdownFestivalItemData>? countdownFestivalListData,
      final Map<String, bool> isGameRunning = const {}})
      : _scInstallPaths = scInstallPaths,
        _rssVideoItems = rssVideoItems,
        _rssTextItems = rssTextItems,
        _scServerStatus = scServerStatus,
        _countdownFestivalListData = countdownFestivalListData,
        _isGameRunning = isGameRunning;

  @override
  final AppPlacardData? appPlacardData;
  @override
  @JsonKey()
  final bool isFixing;
  @override
  @JsonKey()
  final String isFixingString;
  @override
  final String? scInstalledPath;
  final List<String> _scInstallPaths;
  @override
  @JsonKey()
  List<String> get scInstallPaths {
    if (_scInstallPaths is EqualUnmodifiableListView) return _scInstallPaths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scInstallPaths);
  }

  @override
  final AppWebLocalizationVersionsData? webLocalizationVersionsData;
  @override
  @JsonKey()
  final String lastScreenInfo;
  final List<RssItem>? _rssVideoItems;
  @override
  List<RssItem>? get rssVideoItems {
    final value = _rssVideoItems;
    if (value == null) return null;
    if (_rssVideoItems is EqualUnmodifiableListView) return _rssVideoItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<RssItem>? _rssTextItems;
  @override
  List<RssItem>? get rssTextItems {
    final value = _rssTextItems;
    if (value == null) return null;
    if (_rssTextItems is EqualUnmodifiableListView) return _rssTextItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final MapEntry<String, bool>? localizationUpdateInfo;
  final List? _scServerStatus;
  @override
  List? get scServerStatus {
    final value = _scServerStatus;
    if (value == null) return null;
    if (_scServerStatus is EqualUnmodifiableListView) return _scServerStatus;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<CountdownFestivalItemData>? _countdownFestivalListData;
  @override
  List<CountdownFestivalItemData>? get countdownFestivalListData {
    final value = _countdownFestivalListData;
    if (value == null) return null;
    if (_countdownFestivalListData is EqualUnmodifiableListView)
      return _countdownFestivalListData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, bool> _isGameRunning;
  @override
  @JsonKey()
  Map<String, bool> get isGameRunning {
    if (_isGameRunning is EqualUnmodifiableMapView) return _isGameRunning;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_isGameRunning);
  }

  /// Create a copy of HomeUIModelState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HomeUIModelStateCopyWith<_HomeUIModelState> get copyWith =>
      __$HomeUIModelStateCopyWithImpl<_HomeUIModelState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HomeUIModelState &&
            (identical(other.appPlacardData, appPlacardData) ||
                other.appPlacardData == appPlacardData) &&
            (identical(other.isFixing, isFixing) ||
                other.isFixing == isFixing) &&
            (identical(other.isFixingString, isFixingString) ||
                other.isFixingString == isFixingString) &&
            (identical(other.scInstalledPath, scInstalledPath) ||
                other.scInstalledPath == scInstalledPath) &&
            const DeepCollectionEquality()
                .equals(other._scInstallPaths, _scInstallPaths) &&
            (identical(other.webLocalizationVersionsData,
                    webLocalizationVersionsData) ||
                other.webLocalizationVersionsData ==
                    webLocalizationVersionsData) &&
            (identical(other.lastScreenInfo, lastScreenInfo) ||
                other.lastScreenInfo == lastScreenInfo) &&
            const DeepCollectionEquality()
                .equals(other._rssVideoItems, _rssVideoItems) &&
            const DeepCollectionEquality()
                .equals(other._rssTextItems, _rssTextItems) &&
            (identical(other.localizationUpdateInfo, localizationUpdateInfo) ||
                other.localizationUpdateInfo == localizationUpdateInfo) &&
            const DeepCollectionEquality()
                .equals(other._scServerStatus, _scServerStatus) &&
            const DeepCollectionEquality().equals(
                other._countdownFestivalListData, _countdownFestivalListData) &&
            const DeepCollectionEquality()
                .equals(other._isGameRunning, _isGameRunning));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      appPlacardData,
      isFixing,
      isFixingString,
      scInstalledPath,
      const DeepCollectionEquality().hash(_scInstallPaths),
      webLocalizationVersionsData,
      lastScreenInfo,
      const DeepCollectionEquality().hash(_rssVideoItems),
      const DeepCollectionEquality().hash(_rssTextItems),
      localizationUpdateInfo,
      const DeepCollectionEquality().hash(_scServerStatus),
      const DeepCollectionEquality().hash(_countdownFestivalListData),
      const DeepCollectionEquality().hash(_isGameRunning));

  @override
  String toString() {
    return 'HomeUIModelState(appPlacardData: $appPlacardData, isFixing: $isFixing, isFixingString: $isFixingString, scInstalledPath: $scInstalledPath, scInstallPaths: $scInstallPaths, webLocalizationVersionsData: $webLocalizationVersionsData, lastScreenInfo: $lastScreenInfo, rssVideoItems: $rssVideoItems, rssTextItems: $rssTextItems, localizationUpdateInfo: $localizationUpdateInfo, scServerStatus: $scServerStatus, countdownFestivalListData: $countdownFestivalListData, isGameRunning: $isGameRunning)';
  }
}

/// @nodoc
abstract mixin class _$HomeUIModelStateCopyWith<$Res>
    implements $HomeUIModelStateCopyWith<$Res> {
  factory _$HomeUIModelStateCopyWith(
          _HomeUIModelState value, $Res Function(_HomeUIModelState) _then) =
      __$HomeUIModelStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {AppPlacardData? appPlacardData,
      bool isFixing,
      String isFixingString,
      String? scInstalledPath,
      List<String> scInstallPaths,
      AppWebLocalizationVersionsData? webLocalizationVersionsData,
      String lastScreenInfo,
      List<RssItem>? rssVideoItems,
      List<RssItem>? rssTextItems,
      MapEntry<String, bool>? localizationUpdateInfo,
      List? scServerStatus,
      List<CountdownFestivalItemData>? countdownFestivalListData,
      Map<String, bool> isGameRunning});
}

/// @nodoc
class __$HomeUIModelStateCopyWithImpl<$Res>
    implements _$HomeUIModelStateCopyWith<$Res> {
  __$HomeUIModelStateCopyWithImpl(this._self, this._then);

  final _HomeUIModelState _self;
  final $Res Function(_HomeUIModelState) _then;

  /// Create a copy of HomeUIModelState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? appPlacardData = freezed,
    Object? isFixing = null,
    Object? isFixingString = null,
    Object? scInstalledPath = freezed,
    Object? scInstallPaths = null,
    Object? webLocalizationVersionsData = freezed,
    Object? lastScreenInfo = null,
    Object? rssVideoItems = freezed,
    Object? rssTextItems = freezed,
    Object? localizationUpdateInfo = freezed,
    Object? scServerStatus = freezed,
    Object? countdownFestivalListData = freezed,
    Object? isGameRunning = null,
  }) {
    return _then(_HomeUIModelState(
      appPlacardData: freezed == appPlacardData
          ? _self.appPlacardData
          : appPlacardData // ignore: cast_nullable_to_non_nullable
              as AppPlacardData?,
      isFixing: null == isFixing
          ? _self.isFixing
          : isFixing // ignore: cast_nullable_to_non_nullable
              as bool,
      isFixingString: null == isFixingString
          ? _self.isFixingString
          : isFixingString // ignore: cast_nullable_to_non_nullable
              as String,
      scInstalledPath: freezed == scInstalledPath
          ? _self.scInstalledPath
          : scInstalledPath // ignore: cast_nullable_to_non_nullable
              as String?,
      scInstallPaths: null == scInstallPaths
          ? _self._scInstallPaths
          : scInstallPaths // ignore: cast_nullable_to_non_nullable
              as List<String>,
      webLocalizationVersionsData: freezed == webLocalizationVersionsData
          ? _self.webLocalizationVersionsData
          : webLocalizationVersionsData // ignore: cast_nullable_to_non_nullable
              as AppWebLocalizationVersionsData?,
      lastScreenInfo: null == lastScreenInfo
          ? _self.lastScreenInfo
          : lastScreenInfo // ignore: cast_nullable_to_non_nullable
              as String,
      rssVideoItems: freezed == rssVideoItems
          ? _self._rssVideoItems
          : rssVideoItems // ignore: cast_nullable_to_non_nullable
              as List<RssItem>?,
      rssTextItems: freezed == rssTextItems
          ? _self._rssTextItems
          : rssTextItems // ignore: cast_nullable_to_non_nullable
              as List<RssItem>?,
      localizationUpdateInfo: freezed == localizationUpdateInfo
          ? _self.localizationUpdateInfo
          : localizationUpdateInfo // ignore: cast_nullable_to_non_nullable
              as MapEntry<String, bool>?,
      scServerStatus: freezed == scServerStatus
          ? _self._scServerStatus
          : scServerStatus // ignore: cast_nullable_to_non_nullable
              as List?,
      countdownFestivalListData: freezed == countdownFestivalListData
          ? _self._countdownFestivalListData
          : countdownFestivalListData // ignore: cast_nullable_to_non_nullable
              as List<CountdownFestivalItemData>?,
      isGameRunning: null == isGameRunning
          ? _self._isGameRunning
          : isGameRunning // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
    ));
  }
}

// dart format on
