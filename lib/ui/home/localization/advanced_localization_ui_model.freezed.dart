// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'advanced_localization_ui_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdvancedLocalizationUIState {
  String get workingText;
  Map<String, AppAdvancedLocalizationClassKeysData>? get classMap;
  String? get p4kGlobalIni;
  String? get serverGlobalIni;
  String? get customizeGlobalIni;
  ScLocalizationData? get apiLocalizationData;
  int get p4kGlobalIniLines;
  int get serverGlobalIniLines;
  String get errorMessage;

  /// Create a copy of AdvancedLocalizationUIState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AdvancedLocalizationUIStateCopyWith<AdvancedLocalizationUIState>
      get copyWith => _$AdvancedLocalizationUIStateCopyWithImpl<
              AdvancedLocalizationUIState>(
          this as AdvancedLocalizationUIState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AdvancedLocalizationUIState &&
            (identical(other.workingText, workingText) ||
                other.workingText == workingText) &&
            const DeepCollectionEquality().equals(other.classMap, classMap) &&
            (identical(other.p4kGlobalIni, p4kGlobalIni) ||
                other.p4kGlobalIni == p4kGlobalIni) &&
            (identical(other.serverGlobalIni, serverGlobalIni) ||
                other.serverGlobalIni == serverGlobalIni) &&
            (identical(other.customizeGlobalIni, customizeGlobalIni) ||
                other.customizeGlobalIni == customizeGlobalIni) &&
            (identical(other.apiLocalizationData, apiLocalizationData) ||
                other.apiLocalizationData == apiLocalizationData) &&
            (identical(other.p4kGlobalIniLines, p4kGlobalIniLines) ||
                other.p4kGlobalIniLines == p4kGlobalIniLines) &&
            (identical(other.serverGlobalIniLines, serverGlobalIniLines) ||
                other.serverGlobalIniLines == serverGlobalIniLines) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      workingText,
      const DeepCollectionEquality().hash(classMap),
      p4kGlobalIni,
      serverGlobalIni,
      customizeGlobalIni,
      apiLocalizationData,
      p4kGlobalIniLines,
      serverGlobalIniLines,
      errorMessage);

  @override
  String toString() {
    return 'AdvancedLocalizationUIState(workingText: $workingText, classMap: $classMap, p4kGlobalIni: $p4kGlobalIni, serverGlobalIni: $serverGlobalIni, customizeGlobalIni: $customizeGlobalIni, apiLocalizationData: $apiLocalizationData, p4kGlobalIniLines: $p4kGlobalIniLines, serverGlobalIniLines: $serverGlobalIniLines, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $AdvancedLocalizationUIStateCopyWith<$Res> {
  factory $AdvancedLocalizationUIStateCopyWith(
          AdvancedLocalizationUIState value,
          $Res Function(AdvancedLocalizationUIState) _then) =
      _$AdvancedLocalizationUIStateCopyWithImpl;
  @useResult
  $Res call(
      {String workingText,
      Map<String, AppAdvancedLocalizationClassKeysData>? classMap,
      String? p4kGlobalIni,
      String? serverGlobalIni,
      String? customizeGlobalIni,
      ScLocalizationData? apiLocalizationData,
      int p4kGlobalIniLines,
      int serverGlobalIniLines,
      String errorMessage});
}

/// @nodoc
class _$AdvancedLocalizationUIStateCopyWithImpl<$Res>
    implements $AdvancedLocalizationUIStateCopyWith<$Res> {
  _$AdvancedLocalizationUIStateCopyWithImpl(this._self, this._then);

  final AdvancedLocalizationUIState _self;
  final $Res Function(AdvancedLocalizationUIState) _then;

  /// Create a copy of AdvancedLocalizationUIState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workingText = null,
    Object? classMap = freezed,
    Object? p4kGlobalIni = freezed,
    Object? serverGlobalIni = freezed,
    Object? customizeGlobalIni = freezed,
    Object? apiLocalizationData = freezed,
    Object? p4kGlobalIniLines = null,
    Object? serverGlobalIniLines = null,
    Object? errorMessage = null,
  }) {
    return _then(_self.copyWith(
      workingText: null == workingText
          ? _self.workingText
          : workingText // ignore: cast_nullable_to_non_nullable
              as String,
      classMap: freezed == classMap
          ? _self.classMap
          : classMap // ignore: cast_nullable_to_non_nullable
              as Map<String, AppAdvancedLocalizationClassKeysData>?,
      p4kGlobalIni: freezed == p4kGlobalIni
          ? _self.p4kGlobalIni
          : p4kGlobalIni // ignore: cast_nullable_to_non_nullable
              as String?,
      serverGlobalIni: freezed == serverGlobalIni
          ? _self.serverGlobalIni
          : serverGlobalIni // ignore: cast_nullable_to_non_nullable
              as String?,
      customizeGlobalIni: freezed == customizeGlobalIni
          ? _self.customizeGlobalIni
          : customizeGlobalIni // ignore: cast_nullable_to_non_nullable
              as String?,
      apiLocalizationData: freezed == apiLocalizationData
          ? _self.apiLocalizationData
          : apiLocalizationData // ignore: cast_nullable_to_non_nullable
              as ScLocalizationData?,
      p4kGlobalIniLines: null == p4kGlobalIniLines
          ? _self.p4kGlobalIniLines
          : p4kGlobalIniLines // ignore: cast_nullable_to_non_nullable
              as int,
      serverGlobalIniLines: null == serverGlobalIniLines
          ? _self.serverGlobalIniLines
          : serverGlobalIniLines // ignore: cast_nullable_to_non_nullable
              as int,
      errorMessage: null == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _AdvancedLocalizationUIState implements AdvancedLocalizationUIState {
  _AdvancedLocalizationUIState(
      {this.workingText = "",
      final Map<String, AppAdvancedLocalizationClassKeysData>? classMap,
      this.p4kGlobalIni,
      this.serverGlobalIni,
      this.customizeGlobalIni,
      this.apiLocalizationData,
      this.p4kGlobalIniLines = 0,
      this.serverGlobalIniLines = 0,
      this.errorMessage = ""})
      : _classMap = classMap;

  @override
  @JsonKey()
  final String workingText;
  final Map<String, AppAdvancedLocalizationClassKeysData>? _classMap;
  @override
  Map<String, AppAdvancedLocalizationClassKeysData>? get classMap {
    final value = _classMap;
    if (value == null) return null;
    if (_classMap is EqualUnmodifiableMapView) return _classMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? p4kGlobalIni;
  @override
  final String? serverGlobalIni;
  @override
  final String? customizeGlobalIni;
  @override
  final ScLocalizationData? apiLocalizationData;
  @override
  @JsonKey()
  final int p4kGlobalIniLines;
  @override
  @JsonKey()
  final int serverGlobalIniLines;
  @override
  @JsonKey()
  final String errorMessage;

  /// Create a copy of AdvancedLocalizationUIState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AdvancedLocalizationUIStateCopyWith<_AdvancedLocalizationUIState>
      get copyWith => __$AdvancedLocalizationUIStateCopyWithImpl<
          _AdvancedLocalizationUIState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AdvancedLocalizationUIState &&
            (identical(other.workingText, workingText) ||
                other.workingText == workingText) &&
            const DeepCollectionEquality().equals(other._classMap, _classMap) &&
            (identical(other.p4kGlobalIni, p4kGlobalIni) ||
                other.p4kGlobalIni == p4kGlobalIni) &&
            (identical(other.serverGlobalIni, serverGlobalIni) ||
                other.serverGlobalIni == serverGlobalIni) &&
            (identical(other.customizeGlobalIni, customizeGlobalIni) ||
                other.customizeGlobalIni == customizeGlobalIni) &&
            (identical(other.apiLocalizationData, apiLocalizationData) ||
                other.apiLocalizationData == apiLocalizationData) &&
            (identical(other.p4kGlobalIniLines, p4kGlobalIniLines) ||
                other.p4kGlobalIniLines == p4kGlobalIniLines) &&
            (identical(other.serverGlobalIniLines, serverGlobalIniLines) ||
                other.serverGlobalIniLines == serverGlobalIniLines) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      workingText,
      const DeepCollectionEquality().hash(_classMap),
      p4kGlobalIni,
      serverGlobalIni,
      customizeGlobalIni,
      apiLocalizationData,
      p4kGlobalIniLines,
      serverGlobalIniLines,
      errorMessage);

  @override
  String toString() {
    return 'AdvancedLocalizationUIState(workingText: $workingText, classMap: $classMap, p4kGlobalIni: $p4kGlobalIni, serverGlobalIni: $serverGlobalIni, customizeGlobalIni: $customizeGlobalIni, apiLocalizationData: $apiLocalizationData, p4kGlobalIniLines: $p4kGlobalIniLines, serverGlobalIniLines: $serverGlobalIniLines, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$AdvancedLocalizationUIStateCopyWith<$Res>
    implements $AdvancedLocalizationUIStateCopyWith<$Res> {
  factory _$AdvancedLocalizationUIStateCopyWith(
          _AdvancedLocalizationUIState value,
          $Res Function(_AdvancedLocalizationUIState) _then) =
      __$AdvancedLocalizationUIStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String workingText,
      Map<String, AppAdvancedLocalizationClassKeysData>? classMap,
      String? p4kGlobalIni,
      String? serverGlobalIni,
      String? customizeGlobalIni,
      ScLocalizationData? apiLocalizationData,
      int p4kGlobalIniLines,
      int serverGlobalIniLines,
      String errorMessage});
}

/// @nodoc
class __$AdvancedLocalizationUIStateCopyWithImpl<$Res>
    implements _$AdvancedLocalizationUIStateCopyWith<$Res> {
  __$AdvancedLocalizationUIStateCopyWithImpl(this._self, this._then);

  final _AdvancedLocalizationUIState _self;
  final $Res Function(_AdvancedLocalizationUIState) _then;

  /// Create a copy of AdvancedLocalizationUIState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? workingText = null,
    Object? classMap = freezed,
    Object? p4kGlobalIni = freezed,
    Object? serverGlobalIni = freezed,
    Object? customizeGlobalIni = freezed,
    Object? apiLocalizationData = freezed,
    Object? p4kGlobalIniLines = null,
    Object? serverGlobalIniLines = null,
    Object? errorMessage = null,
  }) {
    return _then(_AdvancedLocalizationUIState(
      workingText: null == workingText
          ? _self.workingText
          : workingText // ignore: cast_nullable_to_non_nullable
              as String,
      classMap: freezed == classMap
          ? _self._classMap
          : classMap // ignore: cast_nullable_to_non_nullable
              as Map<String, AppAdvancedLocalizationClassKeysData>?,
      p4kGlobalIni: freezed == p4kGlobalIni
          ? _self.p4kGlobalIni
          : p4kGlobalIni // ignore: cast_nullable_to_non_nullable
              as String?,
      serverGlobalIni: freezed == serverGlobalIni
          ? _self.serverGlobalIni
          : serverGlobalIni // ignore: cast_nullable_to_non_nullable
              as String?,
      customizeGlobalIni: freezed == customizeGlobalIni
          ? _self.customizeGlobalIni
          : customizeGlobalIni // ignore: cast_nullable_to_non_nullable
              as String?,
      apiLocalizationData: freezed == apiLocalizationData
          ? _self.apiLocalizationData
          : apiLocalizationData // ignore: cast_nullable_to_non_nullable
              as ScLocalizationData?,
      p4kGlobalIniLines: null == p4kGlobalIniLines
          ? _self.p4kGlobalIniLines
          : p4kGlobalIniLines // ignore: cast_nullable_to_non_nullable
              as int,
      serverGlobalIniLines: null == serverGlobalIniLines
          ? _self.serverGlobalIniLines
          : serverGlobalIniLines // ignore: cast_nullable_to_non_nullable
              as int,
      errorMessage: null == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
