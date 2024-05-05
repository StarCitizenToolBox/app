// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'localization_ui_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LocalizationUIState {
  String? get selectedLanguage => throw _privateConstructorUsedError;
  Map<String, ScLocalizationData>? get apiLocalizationData =>
      throw _privateConstructorUsedError;
  String get workingVersion => throw _privateConstructorUsedError;
  MapEntry<bool, String>? get patchStatus => throw _privateConstructorUsedError;
  bool? get isInstalledAdvanced => throw _privateConstructorUsedError;
  List<String>? get customizeList => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LocalizationUIStateCopyWith<LocalizationUIState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocalizationUIStateCopyWith<$Res> {
  factory $LocalizationUIStateCopyWith(
          LocalizationUIState value, $Res Function(LocalizationUIState) then) =
      _$LocalizationUIStateCopyWithImpl<$Res, LocalizationUIState>;
  @useResult
  $Res call(
      {String? selectedLanguage,
      Map<String, ScLocalizationData>? apiLocalizationData,
      String workingVersion,
      MapEntry<bool, String>? patchStatus,
      bool? isInstalledAdvanced,
      List<String>? customizeList});
}

/// @nodoc
class _$LocalizationUIStateCopyWithImpl<$Res, $Val extends LocalizationUIState>
    implements $LocalizationUIStateCopyWith<$Res> {
  _$LocalizationUIStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedLanguage = freezed,
    Object? apiLocalizationData = freezed,
    Object? workingVersion = null,
    Object? patchStatus = freezed,
    Object? isInstalledAdvanced = freezed,
    Object? customizeList = freezed,
  }) {
    return _then(_value.copyWith(
      selectedLanguage: freezed == selectedLanguage
          ? _value.selectedLanguage
          : selectedLanguage // ignore: cast_nullable_to_non_nullable
              as String?,
      apiLocalizationData: freezed == apiLocalizationData
          ? _value.apiLocalizationData
          : apiLocalizationData // ignore: cast_nullable_to_non_nullable
              as Map<String, ScLocalizationData>?,
      workingVersion: null == workingVersion
          ? _value.workingVersion
          : workingVersion // ignore: cast_nullable_to_non_nullable
              as String,
      patchStatus: freezed == patchStatus
          ? _value.patchStatus
          : patchStatus // ignore: cast_nullable_to_non_nullable
              as MapEntry<bool, String>?,
      isInstalledAdvanced: freezed == isInstalledAdvanced
          ? _value.isInstalledAdvanced
          : isInstalledAdvanced // ignore: cast_nullable_to_non_nullable
              as bool?,
      customizeList: freezed == customizeList
          ? _value.customizeList
          : customizeList // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocalizationUIStateImplCopyWith<$Res>
    implements $LocalizationUIStateCopyWith<$Res> {
  factory _$$LocalizationUIStateImplCopyWith(_$LocalizationUIStateImpl value,
          $Res Function(_$LocalizationUIStateImpl) then) =
      __$$LocalizationUIStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? selectedLanguage,
      Map<String, ScLocalizationData>? apiLocalizationData,
      String workingVersion,
      MapEntry<bool, String>? patchStatus,
      bool? isInstalledAdvanced,
      List<String>? customizeList});
}

/// @nodoc
class __$$LocalizationUIStateImplCopyWithImpl<$Res>
    extends _$LocalizationUIStateCopyWithImpl<$Res, _$LocalizationUIStateImpl>
    implements _$$LocalizationUIStateImplCopyWith<$Res> {
  __$$LocalizationUIStateImplCopyWithImpl(_$LocalizationUIStateImpl _value,
      $Res Function(_$LocalizationUIStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedLanguage = freezed,
    Object? apiLocalizationData = freezed,
    Object? workingVersion = null,
    Object? patchStatus = freezed,
    Object? isInstalledAdvanced = freezed,
    Object? customizeList = freezed,
  }) {
    return _then(_$LocalizationUIStateImpl(
      selectedLanguage: freezed == selectedLanguage
          ? _value.selectedLanguage
          : selectedLanguage // ignore: cast_nullable_to_non_nullable
              as String?,
      apiLocalizationData: freezed == apiLocalizationData
          ? _value._apiLocalizationData
          : apiLocalizationData // ignore: cast_nullable_to_non_nullable
              as Map<String, ScLocalizationData>?,
      workingVersion: null == workingVersion
          ? _value.workingVersion
          : workingVersion // ignore: cast_nullable_to_non_nullable
              as String,
      patchStatus: freezed == patchStatus
          ? _value.patchStatus
          : patchStatus // ignore: cast_nullable_to_non_nullable
              as MapEntry<bool, String>?,
      isInstalledAdvanced: freezed == isInstalledAdvanced
          ? _value.isInstalledAdvanced
          : isInstalledAdvanced // ignore: cast_nullable_to_non_nullable
              as bool?,
      customizeList: freezed == customizeList
          ? _value._customizeList
          : customizeList // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc

class _$LocalizationUIStateImpl implements _LocalizationUIState {
  _$LocalizationUIStateImpl(
      {this.selectedLanguage,
      final Map<String, ScLocalizationData>? apiLocalizationData,
      this.workingVersion = "",
      this.patchStatus,
      this.isInstalledAdvanced,
      final List<String>? customizeList})
      : _apiLocalizationData = apiLocalizationData,
        _customizeList = customizeList;

  @override
  final String? selectedLanguage;
  final Map<String, ScLocalizationData>? _apiLocalizationData;
  @override
  Map<String, ScLocalizationData>? get apiLocalizationData {
    final value = _apiLocalizationData;
    if (value == null) return null;
    if (_apiLocalizationData is EqualUnmodifiableMapView)
      return _apiLocalizationData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final String workingVersion;
  @override
  final MapEntry<bool, String>? patchStatus;
  @override
  final bool? isInstalledAdvanced;
  final List<String>? _customizeList;
  @override
  List<String>? get customizeList {
    final value = _customizeList;
    if (value == null) return null;
    if (_customizeList is EqualUnmodifiableListView) return _customizeList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'LocalizationUIState(selectedLanguage: $selectedLanguage, apiLocalizationData: $apiLocalizationData, workingVersion: $workingVersion, patchStatus: $patchStatus, isInstalledAdvanced: $isInstalledAdvanced, customizeList: $customizeList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocalizationUIStateImpl &&
            (identical(other.selectedLanguage, selectedLanguage) ||
                other.selectedLanguage == selectedLanguage) &&
            const DeepCollectionEquality()
                .equals(other._apiLocalizationData, _apiLocalizationData) &&
            (identical(other.workingVersion, workingVersion) ||
                other.workingVersion == workingVersion) &&
            (identical(other.patchStatus, patchStatus) ||
                other.patchStatus == patchStatus) &&
            (identical(other.isInstalledAdvanced, isInstalledAdvanced) ||
                other.isInstalledAdvanced == isInstalledAdvanced) &&
            const DeepCollectionEquality()
                .equals(other._customizeList, _customizeList));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      selectedLanguage,
      const DeepCollectionEquality().hash(_apiLocalizationData),
      workingVersion,
      patchStatus,
      isInstalledAdvanced,
      const DeepCollectionEquality().hash(_customizeList));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LocalizationUIStateImplCopyWith<_$LocalizationUIStateImpl> get copyWith =>
      __$$LocalizationUIStateImplCopyWithImpl<_$LocalizationUIStateImpl>(
          this, _$identity);
}

abstract class _LocalizationUIState implements LocalizationUIState {
  factory _LocalizationUIState(
      {final String? selectedLanguage,
      final Map<String, ScLocalizationData>? apiLocalizationData,
      final String workingVersion,
      final MapEntry<bool, String>? patchStatus,
      final bool? isInstalledAdvanced,
      final List<String>? customizeList}) = _$LocalizationUIStateImpl;

  @override
  String? get selectedLanguage;
  @override
  Map<String, ScLocalizationData>? get apiLocalizationData;
  @override
  String get workingVersion;
  @override
  MapEntry<bool, String>? get patchStatus;
  @override
  bool? get isInstalledAdvanced;
  @override
  List<String>? get customizeList;
  @override
  @JsonKey(ignore: true)
  _$$LocalizationUIStateImplCopyWith<_$LocalizationUIStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
