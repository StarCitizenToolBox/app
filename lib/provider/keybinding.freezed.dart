// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'keybinding.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$KeybindingState {

 bool get isLoading; String get loadingMessage; String? get errorMessage; String get gamePath; ScKeybindingGameData? get data; List<KbCategory> get categories; ScBindingIndex? get index;/// Working copy of the player's overrides.
 ScRebindMap get rebinds;/// What is on disk, to tell unsaved edits apart.
 ScRebindMap get savedRebinds; Map<int, KbJoystick> get joysticks;/// Name of the connected XInput pad (gp1), if any.
 String? get gamepadName;/// Pending jsN renumbering (old → new) to apply to `<options>` on save.
 Map<int, int> get joystickRenumber; String? get selectedGroupId; String? get selectedActionId; String get query; KeybindingDeviceFilter get deviceFilter; int? get joystickInstanceFilter; bool get onlyModified; bool get onlyConflicts; Set<String> get collapsedCategories;
/// Create a copy of KeybindingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KeybindingStateCopyWith<KeybindingState> get copyWith => _$KeybindingStateCopyWithImpl<KeybindingState>(this as KeybindingState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as KeybindingState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KeybindingState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.loadingMessage, _this.loadingMessage) || other.loadingMessage == _this.loadingMessage)&&(identical(other.errorMessage, _this.errorMessage) || other.errorMessage == _this.errorMessage)&&(identical(other.gamePath, _this.gamePath) || other.gamePath == _this.gamePath)&&(identical(other.data, _this.data) || other.data == _this.data)&&const DeepCollectionEquality().equals(other.categories, _this.categories)&&(identical(other.index, _this.index) || other.index == _this.index)&&const DeepCollectionEquality().equals(other.rebinds, _this.rebinds)&&const DeepCollectionEquality().equals(other.savedRebinds, _this.savedRebinds)&&const DeepCollectionEquality().equals(other.joysticks, _this.joysticks)&&(identical(other.gamepadName, _this.gamepadName) || other.gamepadName == _this.gamepadName)&&const DeepCollectionEquality().equals(other.joystickRenumber, _this.joystickRenumber)&&(identical(other.selectedGroupId, _this.selectedGroupId) || other.selectedGroupId == _this.selectedGroupId)&&(identical(other.selectedActionId, _this.selectedActionId) || other.selectedActionId == _this.selectedActionId)&&(identical(other.query, _this.query) || other.query == _this.query)&&(identical(other.deviceFilter, _this.deviceFilter) || other.deviceFilter == _this.deviceFilter)&&(identical(other.joystickInstanceFilter, _this.joystickInstanceFilter) || other.joystickInstanceFilter == _this.joystickInstanceFilter)&&(identical(other.onlyModified, _this.onlyModified) || other.onlyModified == _this.onlyModified)&&(identical(other.onlyConflicts, _this.onlyConflicts) || other.onlyConflicts == _this.onlyConflicts)&&const DeepCollectionEquality().equals(other.collapsedCategories, _this.collapsedCategories));
}


@override
int get hashCode {
  final _this = this as KeybindingState;
  return Object.hashAll([runtimeType,_this.isLoading,_this.loadingMessage,_this.errorMessage,_this.gamePath,_this.data,const DeepCollectionEquality().hash(_this.categories),_this.index,const DeepCollectionEquality().hash(_this.rebinds),const DeepCollectionEquality().hash(_this.savedRebinds),const DeepCollectionEquality().hash(_this.joysticks),_this.gamepadName,const DeepCollectionEquality().hash(_this.joystickRenumber),_this.selectedGroupId,_this.selectedActionId,_this.query,_this.deviceFilter,_this.joystickInstanceFilter,_this.onlyModified,_this.onlyConflicts,const DeepCollectionEquality().hash(_this.collapsedCategories)]);
}

@override
String toString() {
  final _this = this as KeybindingState;
  return 'KeybindingState(isLoading: ${_this.isLoading}, loadingMessage: ${_this.loadingMessage}, errorMessage: ${_this.errorMessage}, gamePath: ${_this.gamePath}, data: ${_this.data}, categories: ${_this.categories}, index: ${_this.index}, rebinds: ${_this.rebinds}, savedRebinds: ${_this.savedRebinds}, joysticks: ${_this.joysticks}, gamepadName: ${_this.gamepadName}, joystickRenumber: ${_this.joystickRenumber}, selectedGroupId: ${_this.selectedGroupId}, selectedActionId: ${_this.selectedActionId}, query: ${_this.query}, deviceFilter: ${_this.deviceFilter}, joystickInstanceFilter: ${_this.joystickInstanceFilter}, onlyModified: ${_this.onlyModified}, onlyConflicts: ${_this.onlyConflicts}, collapsedCategories: ${_this.collapsedCategories})';
}


}

/// @nodoc
abstract mixin class $KeybindingStateCopyWith<$Res>  {
  factory $KeybindingStateCopyWith(KeybindingState value, $Res Function(KeybindingState) _then) = _$KeybindingStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, String loadingMessage, String? errorMessage, String gamePath, ScKeybindingGameData? data, List<KbCategory> categories, ScBindingIndex? index, ScRebindMap rebinds, ScRebindMap savedRebinds, Map<int, KbJoystick> joysticks, String? gamepadName, Map<int, int> joystickRenumber, String? selectedGroupId, String? selectedActionId, String query, KeybindingDeviceFilter deviceFilter, int? joystickInstanceFilter, bool onlyModified, bool onlyConflicts, Set<String> collapsedCategories
});




}
/// @nodoc
class _$KeybindingStateCopyWithImpl<$Res>
    implements $KeybindingStateCopyWith<$Res> {
  _$KeybindingStateCopyWithImpl(this._self, this._then);

  final KeybindingState _self;
  final $Res Function(KeybindingState) _then;

/// Create a copy of KeybindingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? loadingMessage = null,Object? errorMessage = freezed,Object? gamePath = null,Object? data = freezed,Object? categories = null,Object? index = freezed,Object? rebinds = null,Object? savedRebinds = null,Object? joysticks = null,Object? gamepadName = freezed,Object? joystickRenumber = null,Object? selectedGroupId = freezed,Object? selectedActionId = freezed,Object? query = null,Object? deviceFilter = null,Object? joystickInstanceFilter = freezed,Object? onlyModified = null,Object? onlyConflicts = null,Object? collapsedCategories = null,}) {
  return _then(KeybindingState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,loadingMessage: null == loadingMessage ? _self.loadingMessage : loadingMessage // ignore: cast_nullable_to_non_nullable
as String,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,gamePath: null == gamePath ? _self.gamePath : gamePath // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ScKeybindingGameData?,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<KbCategory>,index: freezed == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as ScBindingIndex?,rebinds: null == rebinds ? _self.rebinds : rebinds // ignore: cast_nullable_to_non_nullable
as ScRebindMap,savedRebinds: null == savedRebinds ? _self.savedRebinds : savedRebinds // ignore: cast_nullable_to_non_nullable
as ScRebindMap,joysticks: null == joysticks ? _self.joysticks : joysticks // ignore: cast_nullable_to_non_nullable
as Map<int, KbJoystick>,gamepadName: freezed == gamepadName ? _self.gamepadName : gamepadName // ignore: cast_nullable_to_non_nullable
as String?,joystickRenumber: null == joystickRenumber ? _self.joystickRenumber : joystickRenumber // ignore: cast_nullable_to_non_nullable
as Map<int, int>,selectedGroupId: freezed == selectedGroupId ? _self.selectedGroupId : selectedGroupId // ignore: cast_nullable_to_non_nullable
as String?,selectedActionId: freezed == selectedActionId ? _self.selectedActionId : selectedActionId // ignore: cast_nullable_to_non_nullable
as String?,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,deviceFilter: null == deviceFilter ? _self.deviceFilter : deviceFilter // ignore: cast_nullable_to_non_nullable
as KeybindingDeviceFilter,joystickInstanceFilter: freezed == joystickInstanceFilter ? _self.joystickInstanceFilter : joystickInstanceFilter // ignore: cast_nullable_to_non_nullable
as int?,onlyModified: null == onlyModified ? _self.onlyModified : onlyModified // ignore: cast_nullable_to_non_nullable
as bool,onlyConflicts: null == onlyConflicts ? _self.onlyConflicts : onlyConflicts // ignore: cast_nullable_to_non_nullable
as bool,collapsedCategories: null == collapsedCategories ? _self.collapsedCategories : collapsedCategories // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [KeybindingState].
extension KeybindingStatePatterns on KeybindingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KeybindingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KeybindingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KeybindingState value)  $default,){
final _that = this;
switch (_that) {
case _KeybindingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KeybindingState value)?  $default,){
final _that = this;
switch (_that) {
case _KeybindingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  String loadingMessage,  String? errorMessage,  String gamePath,  ScKeybindingGameData? data,  List<KbCategory> categories,  ScBindingIndex? index,  ScRebindMap rebinds,  ScRebindMap savedRebinds,  Map<int, KbJoystick> joysticks,  String? gamepadName,  Map<int, int> joystickRenumber,  String? selectedGroupId,  String? selectedActionId,  String query,  KeybindingDeviceFilter deviceFilter,  int? joystickInstanceFilter,  bool onlyModified,  bool onlyConflicts,  Set<String> collapsedCategories)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KeybindingState() when $default != null:
return $default(_that.isLoading,_that.loadingMessage,_that.errorMessage,_that.gamePath,_that.data,_that.categories,_that.index,_that.rebinds,_that.savedRebinds,_that.joysticks,_that.gamepadName,_that.joystickRenumber,_that.selectedGroupId,_that.selectedActionId,_that.query,_that.deviceFilter,_that.joystickInstanceFilter,_that.onlyModified,_that.onlyConflicts,_that.collapsedCategories);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  String loadingMessage,  String? errorMessage,  String gamePath,  ScKeybindingGameData? data,  List<KbCategory> categories,  ScBindingIndex? index,  ScRebindMap rebinds,  ScRebindMap savedRebinds,  Map<int, KbJoystick> joysticks,  String? gamepadName,  Map<int, int> joystickRenumber,  String? selectedGroupId,  String? selectedActionId,  String query,  KeybindingDeviceFilter deviceFilter,  int? joystickInstanceFilter,  bool onlyModified,  bool onlyConflicts,  Set<String> collapsedCategories)  $default,) {final _that = this;
switch (_that) {
case _KeybindingState():
return $default(_that.isLoading,_that.loadingMessage,_that.errorMessage,_that.gamePath,_that.data,_that.categories,_that.index,_that.rebinds,_that.savedRebinds,_that.joysticks,_that.gamepadName,_that.joystickRenumber,_that.selectedGroupId,_that.selectedActionId,_that.query,_that.deviceFilter,_that.joystickInstanceFilter,_that.onlyModified,_that.onlyConflicts,_that.collapsedCategories);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  String loadingMessage,  String? errorMessage,  String gamePath,  ScKeybindingGameData? data,  List<KbCategory> categories,  ScBindingIndex? index,  ScRebindMap rebinds,  ScRebindMap savedRebinds,  Map<int, KbJoystick> joysticks,  String? gamepadName,  Map<int, int> joystickRenumber,  String? selectedGroupId,  String? selectedActionId,  String query,  KeybindingDeviceFilter deviceFilter,  int? joystickInstanceFilter,  bool onlyModified,  bool onlyConflicts,  Set<String> collapsedCategories)?  $default,) {final _that = this;
switch (_that) {
case _KeybindingState() when $default != null:
return $default(_that.isLoading,_that.loadingMessage,_that.errorMessage,_that.gamePath,_that.data,_that.categories,_that.index,_that.rebinds,_that.savedRebinds,_that.joysticks,_that.gamepadName,_that.joystickRenumber,_that.selectedGroupId,_that.selectedActionId,_that.query,_that.deviceFilter,_that.joystickInstanceFilter,_that.onlyModified,_that.onlyConflicts,_that.collapsedCategories);case _:
  return null;

}
}

}

/// @nodoc


class _KeybindingState implements KeybindingState {
  const _KeybindingState({this.isLoading = true, this.loadingMessage = '', this.errorMessage, this.gamePath = '', this.data,  List<KbCategory> categories = const [], this.index,  ScRebindMap rebinds = const {},  ScRebindMap savedRebinds = const {},  Map<int, KbJoystick> joysticks = const {}, this.gamepadName,  Map<int, int> joystickRenumber = const {}, this.selectedGroupId, this.selectedActionId, this.query = '', this.deviceFilter = KeybindingDeviceFilter.all, this.joystickInstanceFilter, this.onlyModified = false, this.onlyConflicts = false,  Set<String> collapsedCategories = const {}}): _categories = categories,_rebinds = rebinds,_savedRebinds = savedRebinds,_joysticks = joysticks,_joystickRenumber = joystickRenumber,_collapsedCategories = collapsedCategories;
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  String loadingMessage;
@override final  String? errorMessage;
@override@JsonKey() final  String gamePath;
@override final  ScKeybindingGameData? data;
 final  List<KbCategory> _categories;
@override@JsonKey() List<KbCategory> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

@override final  ScBindingIndex? index;
/// Working copy of the player's overrides.
 final  ScRebindMap _rebinds;
/// Working copy of the player's overrides.
@override@JsonKey() ScRebindMap get rebinds {
  if (_rebinds is EqualUnmodifiableMapView) return _rebinds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_rebinds);
}

/// What is on disk, to tell unsaved edits apart.
 final  ScRebindMap _savedRebinds;
/// What is on disk, to tell unsaved edits apart.
@override@JsonKey() ScRebindMap get savedRebinds {
  if (_savedRebinds is EqualUnmodifiableMapView) return _savedRebinds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_savedRebinds);
}

 final  Map<int, KbJoystick> _joysticks;
@override@JsonKey() Map<int, KbJoystick> get joysticks {
  if (_joysticks is EqualUnmodifiableMapView) return _joysticks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_joysticks);
}

/// Name of the connected XInput pad (gp1), if any.
@override final  String? gamepadName;
/// Pending jsN renumbering (old → new) to apply to `<options>` on save.
 final  Map<int, int> _joystickRenumber;
/// Pending jsN renumbering (old → new) to apply to `<options>` on save.
@override@JsonKey() Map<int, int> get joystickRenumber {
  if (_joystickRenumber is EqualUnmodifiableMapView) return _joystickRenumber;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_joystickRenumber);
}

@override final  String? selectedGroupId;
@override final  String? selectedActionId;
@override@JsonKey() final  String query;
@override@JsonKey() final  KeybindingDeviceFilter deviceFilter;
@override final  int? joystickInstanceFilter;
@override@JsonKey() final  bool onlyModified;
@override@JsonKey() final  bool onlyConflicts;
 final  Set<String> _collapsedCategories;
@override@JsonKey() Set<String> get collapsedCategories {
  if (_collapsedCategories is EqualUnmodifiableSetView) return _collapsedCategories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_collapsedCategories);
}


/// Create a copy of KeybindingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KeybindingStateCopyWith<_KeybindingState> get copyWith => __$KeybindingStateCopyWithImpl<_KeybindingState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _KeybindingState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.loadingMessage, loadingMessage) || other.loadingMessage == loadingMessage)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.gamePath, gamePath) || other.gamePath == gamePath)&&(identical(other.data, data) || other.data == data)&&const DeepCollectionEquality().equals(other.categories, _categories)&&(identical(other.index, index) || other.index == index)&&const DeepCollectionEquality().equals(other.rebinds, _rebinds)&&const DeepCollectionEquality().equals(other.savedRebinds, _savedRebinds)&&const DeepCollectionEquality().equals(other.joysticks, _joysticks)&&(identical(other.gamepadName, gamepadName) || other.gamepadName == gamepadName)&&const DeepCollectionEquality().equals(other.joystickRenumber, _joystickRenumber)&&(identical(other.selectedGroupId, selectedGroupId) || other.selectedGroupId == selectedGroupId)&&(identical(other.selectedActionId, selectedActionId) || other.selectedActionId == selectedActionId)&&(identical(other.query, query) || other.query == query)&&(identical(other.deviceFilter, deviceFilter) || other.deviceFilter == deviceFilter)&&(identical(other.joystickInstanceFilter, joystickInstanceFilter) || other.joystickInstanceFilter == joystickInstanceFilter)&&(identical(other.onlyModified, onlyModified) || other.onlyModified == onlyModified)&&(identical(other.onlyConflicts, onlyConflicts) || other.onlyConflicts == onlyConflicts)&&const DeepCollectionEquality().equals(other.collapsedCategories, _collapsedCategories));
}


@override
int get hashCode {
    return Object.hashAll([runtimeType,isLoading,loadingMessage,errorMessage,gamePath,data,const DeepCollectionEquality().hash(_categories),index,const DeepCollectionEquality().hash(_rebinds),const DeepCollectionEquality().hash(_savedRebinds),const DeepCollectionEquality().hash(_joysticks),gamepadName,const DeepCollectionEquality().hash(_joystickRenumber),selectedGroupId,selectedActionId,query,deviceFilter,joystickInstanceFilter,onlyModified,onlyConflicts,const DeepCollectionEquality().hash(_collapsedCategories)]);
}

@override
String toString() {
    return 'KeybindingState(isLoading: $isLoading, loadingMessage: $loadingMessage, errorMessage: $errorMessage, gamePath: $gamePath, data: $data, categories: $categories, index: $index, rebinds: $rebinds, savedRebinds: $savedRebinds, joysticks: $joysticks, gamepadName: $gamepadName, joystickRenumber: $joystickRenumber, selectedGroupId: $selectedGroupId, selectedActionId: $selectedActionId, query: $query, deviceFilter: $deviceFilter, joystickInstanceFilter: $joystickInstanceFilter, onlyModified: $onlyModified, onlyConflicts: $onlyConflicts, collapsedCategories: $collapsedCategories)';
}


}

/// @nodoc
abstract mixin class _$KeybindingStateCopyWith<$Res> implements $KeybindingStateCopyWith<$Res> {
  factory _$KeybindingStateCopyWith(_KeybindingState value, $Res Function(_KeybindingState) _then) = __$KeybindingStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String loadingMessage, String? errorMessage, String gamePath, ScKeybindingGameData? data, List<KbCategory> categories, ScBindingIndex? index, ScRebindMap rebinds, ScRebindMap savedRebinds, Map<int, KbJoystick> joysticks, String? gamepadName, Map<int, int> joystickRenumber, String? selectedGroupId, String? selectedActionId, String query, KeybindingDeviceFilter deviceFilter, int? joystickInstanceFilter, bool onlyModified, bool onlyConflicts, Set<String> collapsedCategories
});




}
/// @nodoc
class __$KeybindingStateCopyWithImpl<$Res>
    implements _$KeybindingStateCopyWith<$Res> {
  __$KeybindingStateCopyWithImpl(this._self, this._then);

  final _KeybindingState _self;
  final $Res Function(_KeybindingState) _then;

/// Create a copy of KeybindingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? loadingMessage = null,Object? errorMessage = freezed,Object? gamePath = null,Object? data = freezed,Object? categories = null,Object? index = freezed,Object? rebinds = null,Object? savedRebinds = null,Object? joysticks = null,Object? gamepadName = freezed,Object? joystickRenumber = null,Object? selectedGroupId = freezed,Object? selectedActionId = freezed,Object? query = null,Object? deviceFilter = null,Object? joystickInstanceFilter = freezed,Object? onlyModified = null,Object? onlyConflicts = null,Object? collapsedCategories = null,}) {
  return _then(_KeybindingState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,loadingMessage: null == loadingMessage ? _self.loadingMessage : loadingMessage // ignore: cast_nullable_to_non_nullable
as String,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,gamePath: null == gamePath ? _self.gamePath : gamePath // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ScKeybindingGameData?,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<KbCategory>,index: freezed == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as ScBindingIndex?,rebinds: null == rebinds ? _self._rebinds : rebinds // ignore: cast_nullable_to_non_nullable
as ScRebindMap,savedRebinds: null == savedRebinds ? _self._savedRebinds : savedRebinds // ignore: cast_nullable_to_non_nullable
as ScRebindMap,joysticks: null == joysticks ? _self._joysticks : joysticks // ignore: cast_nullable_to_non_nullable
as Map<int, KbJoystick>,gamepadName: freezed == gamepadName ? _self.gamepadName : gamepadName // ignore: cast_nullable_to_non_nullable
as String?,joystickRenumber: null == joystickRenumber ? _self._joystickRenumber : joystickRenumber // ignore: cast_nullable_to_non_nullable
as Map<int, int>,selectedGroupId: freezed == selectedGroupId ? _self.selectedGroupId : selectedGroupId // ignore: cast_nullable_to_non_nullable
as String?,selectedActionId: freezed == selectedActionId ? _self.selectedActionId : selectedActionId // ignore: cast_nullable_to_non_nullable
as String?,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,deviceFilter: null == deviceFilter ? _self.deviceFilter : deviceFilter // ignore: cast_nullable_to_non_nullable
as KeybindingDeviceFilter,joystickInstanceFilter: freezed == joystickInstanceFilter ? _self.joystickInstanceFilter : joystickInstanceFilter // ignore: cast_nullable_to_non_nullable
as int?,onlyModified: null == onlyModified ? _self.onlyModified : onlyModified // ignore: cast_nullable_to_non_nullable
as bool,onlyConflicts: null == onlyConflicts ? _self.onlyConflicts : onlyConflicts // ignore: cast_nullable_to_non_nullable
as bool,collapsedCategories: null == collapsedCategories ? _self._collapsedCategories : collapsedCategories // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}


}

// dart format on
