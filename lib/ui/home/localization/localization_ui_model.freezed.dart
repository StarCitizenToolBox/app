// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'localization_ui_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LocalizationUIState {

 String? get selectedLanguage; String? get installedCommunityInputMethodSupportVersion; InputMethodApiLanguageData? get communityInputMethodLanguageData; Map<String, ScLocalizationData>? get apiLocalizationData; String get workingVersion; MapEntry<bool, String>? get patchStatus; bool? get isInstalledAdvanced; List<String>? get customizeList;
/// Create a copy of LocalizationUIState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocalizationUIStateCopyWith<LocalizationUIState> get copyWith => _$LocalizationUIStateCopyWithImpl<LocalizationUIState>(this as LocalizationUIState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalizationUIState&&(identical(other.selectedLanguage, selectedLanguage) || other.selectedLanguage == selectedLanguage)&&(identical(other.installedCommunityInputMethodSupportVersion, installedCommunityInputMethodSupportVersion) || other.installedCommunityInputMethodSupportVersion == installedCommunityInputMethodSupportVersion)&&(identical(other.communityInputMethodLanguageData, communityInputMethodLanguageData) || other.communityInputMethodLanguageData == communityInputMethodLanguageData)&&const DeepCollectionEquality().equals(other.apiLocalizationData, apiLocalizationData)&&(identical(other.workingVersion, workingVersion) || other.workingVersion == workingVersion)&&(identical(other.patchStatus, patchStatus) || other.patchStatus == patchStatus)&&(identical(other.isInstalledAdvanced, isInstalledAdvanced) || other.isInstalledAdvanced == isInstalledAdvanced)&&const DeepCollectionEquality().equals(other.customizeList, customizeList));
}


@override
int get hashCode => Object.hash(runtimeType,selectedLanguage,installedCommunityInputMethodSupportVersion,communityInputMethodLanguageData,const DeepCollectionEquality().hash(apiLocalizationData),workingVersion,patchStatus,isInstalledAdvanced,const DeepCollectionEquality().hash(customizeList));

@override
String toString() {
  return 'LocalizationUIState(selectedLanguage: $selectedLanguage, installedCommunityInputMethodSupportVersion: $installedCommunityInputMethodSupportVersion, communityInputMethodLanguageData: $communityInputMethodLanguageData, apiLocalizationData: $apiLocalizationData, workingVersion: $workingVersion, patchStatus: $patchStatus, isInstalledAdvanced: $isInstalledAdvanced, customizeList: $customizeList)';
}


}

/// @nodoc
abstract mixin class $LocalizationUIStateCopyWith<$Res>  {
  factory $LocalizationUIStateCopyWith(LocalizationUIState value, $Res Function(LocalizationUIState) _then) = _$LocalizationUIStateCopyWithImpl;
@useResult
$Res call({
 String? selectedLanguage, String? installedCommunityInputMethodSupportVersion, InputMethodApiLanguageData? communityInputMethodLanguageData, Map<String, ScLocalizationData>? apiLocalizationData, String workingVersion, MapEntry<bool, String>? patchStatus, bool? isInstalledAdvanced, List<String>? customizeList
});




}
/// @nodoc
class _$LocalizationUIStateCopyWithImpl<$Res>
    implements $LocalizationUIStateCopyWith<$Res> {
  _$LocalizationUIStateCopyWithImpl(this._self, this._then);

  final LocalizationUIState _self;
  final $Res Function(LocalizationUIState) _then;

/// Create a copy of LocalizationUIState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedLanguage = freezed,Object? installedCommunityInputMethodSupportVersion = freezed,Object? communityInputMethodLanguageData = freezed,Object? apiLocalizationData = freezed,Object? workingVersion = null,Object? patchStatus = freezed,Object? isInstalledAdvanced = freezed,Object? customizeList = freezed,}) {
  return _then(_self.copyWith(
selectedLanguage: freezed == selectedLanguage ? _self.selectedLanguage : selectedLanguage // ignore: cast_nullable_to_non_nullable
as String?,installedCommunityInputMethodSupportVersion: freezed == installedCommunityInputMethodSupportVersion ? _self.installedCommunityInputMethodSupportVersion : installedCommunityInputMethodSupportVersion // ignore: cast_nullable_to_non_nullable
as String?,communityInputMethodLanguageData: freezed == communityInputMethodLanguageData ? _self.communityInputMethodLanguageData : communityInputMethodLanguageData // ignore: cast_nullable_to_non_nullable
as InputMethodApiLanguageData?,apiLocalizationData: freezed == apiLocalizationData ? _self.apiLocalizationData : apiLocalizationData // ignore: cast_nullable_to_non_nullable
as Map<String, ScLocalizationData>?,workingVersion: null == workingVersion ? _self.workingVersion : workingVersion // ignore: cast_nullable_to_non_nullable
as String,patchStatus: freezed == patchStatus ? _self.patchStatus : patchStatus // ignore: cast_nullable_to_non_nullable
as MapEntry<bool, String>?,isInstalledAdvanced: freezed == isInstalledAdvanced ? _self.isInstalledAdvanced : isInstalledAdvanced // ignore: cast_nullable_to_non_nullable
as bool?,customizeList: freezed == customizeList ? _self.customizeList : customizeList // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [LocalizationUIState].
extension LocalizationUIStatePatterns on LocalizationUIState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocalizationUIState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocalizationUIState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocalizationUIState value)  $default,){
final _that = this;
switch (_that) {
case _LocalizationUIState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocalizationUIState value)?  $default,){
final _that = this;
switch (_that) {
case _LocalizationUIState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? selectedLanguage,  String? installedCommunityInputMethodSupportVersion,  InputMethodApiLanguageData? communityInputMethodLanguageData,  Map<String, ScLocalizationData>? apiLocalizationData,  String workingVersion,  MapEntry<bool, String>? patchStatus,  bool? isInstalledAdvanced,  List<String>? customizeList)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocalizationUIState() when $default != null:
return $default(_that.selectedLanguage,_that.installedCommunityInputMethodSupportVersion,_that.communityInputMethodLanguageData,_that.apiLocalizationData,_that.workingVersion,_that.patchStatus,_that.isInstalledAdvanced,_that.customizeList);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? selectedLanguage,  String? installedCommunityInputMethodSupportVersion,  InputMethodApiLanguageData? communityInputMethodLanguageData,  Map<String, ScLocalizationData>? apiLocalizationData,  String workingVersion,  MapEntry<bool, String>? patchStatus,  bool? isInstalledAdvanced,  List<String>? customizeList)  $default,) {final _that = this;
switch (_that) {
case _LocalizationUIState():
return $default(_that.selectedLanguage,_that.installedCommunityInputMethodSupportVersion,_that.communityInputMethodLanguageData,_that.apiLocalizationData,_that.workingVersion,_that.patchStatus,_that.isInstalledAdvanced,_that.customizeList);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? selectedLanguage,  String? installedCommunityInputMethodSupportVersion,  InputMethodApiLanguageData? communityInputMethodLanguageData,  Map<String, ScLocalizationData>? apiLocalizationData,  String workingVersion,  MapEntry<bool, String>? patchStatus,  bool? isInstalledAdvanced,  List<String>? customizeList)?  $default,) {final _that = this;
switch (_that) {
case _LocalizationUIState() when $default != null:
return $default(_that.selectedLanguage,_that.installedCommunityInputMethodSupportVersion,_that.communityInputMethodLanguageData,_that.apiLocalizationData,_that.workingVersion,_that.patchStatus,_that.isInstalledAdvanced,_that.customizeList);case _:
  return null;

}
}

}

/// @nodoc


class _LocalizationUIState implements LocalizationUIState {
   _LocalizationUIState({this.selectedLanguage, this.installedCommunityInputMethodSupportVersion, this.communityInputMethodLanguageData, final  Map<String, ScLocalizationData>? apiLocalizationData, this.workingVersion = "", this.patchStatus, this.isInstalledAdvanced, final  List<String>? customizeList}): _apiLocalizationData = apiLocalizationData,_customizeList = customizeList;
  

@override final  String? selectedLanguage;
@override final  String? installedCommunityInputMethodSupportVersion;
@override final  InputMethodApiLanguageData? communityInputMethodLanguageData;
 final  Map<String, ScLocalizationData>? _apiLocalizationData;
@override Map<String, ScLocalizationData>? get apiLocalizationData {
  final value = _apiLocalizationData;
  if (value == null) return null;
  if (_apiLocalizationData is EqualUnmodifiableMapView) return _apiLocalizationData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey() final  String workingVersion;
@override final  MapEntry<bool, String>? patchStatus;
@override final  bool? isInstalledAdvanced;
 final  List<String>? _customizeList;
@override List<String>? get customizeList {
  final value = _customizeList;
  if (value == null) return null;
  if (_customizeList is EqualUnmodifiableListView) return _customizeList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of LocalizationUIState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocalizationUIStateCopyWith<_LocalizationUIState> get copyWith => __$LocalizationUIStateCopyWithImpl<_LocalizationUIState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocalizationUIState&&(identical(other.selectedLanguage, selectedLanguage) || other.selectedLanguage == selectedLanguage)&&(identical(other.installedCommunityInputMethodSupportVersion, installedCommunityInputMethodSupportVersion) || other.installedCommunityInputMethodSupportVersion == installedCommunityInputMethodSupportVersion)&&(identical(other.communityInputMethodLanguageData, communityInputMethodLanguageData) || other.communityInputMethodLanguageData == communityInputMethodLanguageData)&&const DeepCollectionEquality().equals(other._apiLocalizationData, _apiLocalizationData)&&(identical(other.workingVersion, workingVersion) || other.workingVersion == workingVersion)&&(identical(other.patchStatus, patchStatus) || other.patchStatus == patchStatus)&&(identical(other.isInstalledAdvanced, isInstalledAdvanced) || other.isInstalledAdvanced == isInstalledAdvanced)&&const DeepCollectionEquality().equals(other._customizeList, _customizeList));
}


@override
int get hashCode => Object.hash(runtimeType,selectedLanguage,installedCommunityInputMethodSupportVersion,communityInputMethodLanguageData,const DeepCollectionEquality().hash(_apiLocalizationData),workingVersion,patchStatus,isInstalledAdvanced,const DeepCollectionEquality().hash(_customizeList));

@override
String toString() {
  return 'LocalizationUIState(selectedLanguage: $selectedLanguage, installedCommunityInputMethodSupportVersion: $installedCommunityInputMethodSupportVersion, communityInputMethodLanguageData: $communityInputMethodLanguageData, apiLocalizationData: $apiLocalizationData, workingVersion: $workingVersion, patchStatus: $patchStatus, isInstalledAdvanced: $isInstalledAdvanced, customizeList: $customizeList)';
}


}

/// @nodoc
abstract mixin class _$LocalizationUIStateCopyWith<$Res> implements $LocalizationUIStateCopyWith<$Res> {
  factory _$LocalizationUIStateCopyWith(_LocalizationUIState value, $Res Function(_LocalizationUIState) _then) = __$LocalizationUIStateCopyWithImpl;
@override @useResult
$Res call({
 String? selectedLanguage, String? installedCommunityInputMethodSupportVersion, InputMethodApiLanguageData? communityInputMethodLanguageData, Map<String, ScLocalizationData>? apiLocalizationData, String workingVersion, MapEntry<bool, String>? patchStatus, bool? isInstalledAdvanced, List<String>? customizeList
});




}
/// @nodoc
class __$LocalizationUIStateCopyWithImpl<$Res>
    implements _$LocalizationUIStateCopyWith<$Res> {
  __$LocalizationUIStateCopyWithImpl(this._self, this._then);

  final _LocalizationUIState _self;
  final $Res Function(_LocalizationUIState) _then;

/// Create a copy of LocalizationUIState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedLanguage = freezed,Object? installedCommunityInputMethodSupportVersion = freezed,Object? communityInputMethodLanguageData = freezed,Object? apiLocalizationData = freezed,Object? workingVersion = null,Object? patchStatus = freezed,Object? isInstalledAdvanced = freezed,Object? customizeList = freezed,}) {
  return _then(_LocalizationUIState(
selectedLanguage: freezed == selectedLanguage ? _self.selectedLanguage : selectedLanguage // ignore: cast_nullable_to_non_nullable
as String?,installedCommunityInputMethodSupportVersion: freezed == installedCommunityInputMethodSupportVersion ? _self.installedCommunityInputMethodSupportVersion : installedCommunityInputMethodSupportVersion // ignore: cast_nullable_to_non_nullable
as String?,communityInputMethodLanguageData: freezed == communityInputMethodLanguageData ? _self.communityInputMethodLanguageData : communityInputMethodLanguageData // ignore: cast_nullable_to_non_nullable
as InputMethodApiLanguageData?,apiLocalizationData: freezed == apiLocalizationData ? _self._apiLocalizationData : apiLocalizationData // ignore: cast_nullable_to_non_nullable
as Map<String, ScLocalizationData>?,workingVersion: null == workingVersion ? _self.workingVersion : workingVersion // ignore: cast_nullable_to_non_nullable
as String,patchStatus: freezed == patchStatus ? _self.patchStatus : patchStatus // ignore: cast_nullable_to_non_nullable
as MapEntry<bool, String>?,isInstalledAdvanced: freezed == isInstalledAdvanced ? _self.isInstalledAdvanced : isInstalledAdvanced // ignore: cast_nullable_to_non_nullable
as bool?,customizeList: freezed == customizeList ? _self._customizeList : customizeList // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
