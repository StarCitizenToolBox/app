// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'input_method_hotkey_service.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InputMethodHotkeyState {

 bool get enabled; bool get isRunning; bool get isCapturing; ime.ImeHotkey get hotkey; bool get gameOnly; bool get autoSend; InputMethodHotkeyChatMode get chatMode; int? get windowX; int? get windowY; String? get errorMessage;
/// Create a copy of InputMethodHotkeyState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InputMethodHotkeyStateCopyWith<InputMethodHotkeyState> get copyWith => _$InputMethodHotkeyStateCopyWithImpl<InputMethodHotkeyState>(this as InputMethodHotkeyState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as InputMethodHotkeyState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InputMethodHotkeyState&&(identical(other.enabled, _this.enabled) || other.enabled == _this.enabled)&&(identical(other.isRunning, _this.isRunning) || other.isRunning == _this.isRunning)&&(identical(other.isCapturing, _this.isCapturing) || other.isCapturing == _this.isCapturing)&&(identical(other.hotkey, _this.hotkey) || other.hotkey == _this.hotkey)&&(identical(other.gameOnly, _this.gameOnly) || other.gameOnly == _this.gameOnly)&&(identical(other.autoSend, _this.autoSend) || other.autoSend == _this.autoSend)&&(identical(other.chatMode, _this.chatMode) || other.chatMode == _this.chatMode)&&(identical(other.windowX, _this.windowX) || other.windowX == _this.windowX)&&(identical(other.windowY, _this.windowY) || other.windowY == _this.windowY)&&(identical(other.errorMessage, _this.errorMessage) || other.errorMessage == _this.errorMessage));
}


@override
int get hashCode {
  final _this = this as InputMethodHotkeyState;
  return Object.hash(runtimeType,_this.enabled,_this.isRunning,_this.isCapturing,_this.hotkey,_this.gameOnly,_this.autoSend,_this.chatMode,_this.windowX,_this.windowY,_this.errorMessage);
}

@override
String toString() {
  final _this = this as InputMethodHotkeyState;
  return 'InputMethodHotkeyState(enabled: ${_this.enabled}, isRunning: ${_this.isRunning}, isCapturing: ${_this.isCapturing}, hotkey: ${_this.hotkey}, gameOnly: ${_this.gameOnly}, autoSend: ${_this.autoSend}, chatMode: ${_this.chatMode}, windowX: ${_this.windowX}, windowY: ${_this.windowY}, errorMessage: ${_this.errorMessage})';
}


}

/// @nodoc
abstract mixin class $InputMethodHotkeyStateCopyWith<$Res>  {
  factory $InputMethodHotkeyStateCopyWith(InputMethodHotkeyState value, $Res Function(InputMethodHotkeyState) _then) = _$InputMethodHotkeyStateCopyWithImpl;
@useResult
$Res call({
 bool enabled, bool isRunning, bool isCapturing, ime.ImeHotkey hotkey, bool gameOnly, bool autoSend, InputMethodHotkeyChatMode chatMode, int? windowX, int? windowY, String? errorMessage
});




}
/// @nodoc
class _$InputMethodHotkeyStateCopyWithImpl<$Res>
    implements $InputMethodHotkeyStateCopyWith<$Res> {
  _$InputMethodHotkeyStateCopyWithImpl(this._self, this._then);

  final InputMethodHotkeyState _self;
  final $Res Function(InputMethodHotkeyState) _then;

/// Create a copy of InputMethodHotkeyState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,Object? isRunning = null,Object? isCapturing = null,Object? hotkey = null,Object? gameOnly = null,Object? autoSend = null,Object? chatMode = null,Object? windowX = freezed,Object? windowY = freezed,Object? errorMessage = freezed,}) {
  return _then(InputMethodHotkeyState(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,isRunning: null == isRunning ? _self.isRunning : isRunning // ignore: cast_nullable_to_non_nullable
as bool,isCapturing: null == isCapturing ? _self.isCapturing : isCapturing // ignore: cast_nullable_to_non_nullable
as bool,hotkey: null == hotkey ? _self.hotkey : hotkey // ignore: cast_nullable_to_non_nullable
as ime.ImeHotkey,gameOnly: null == gameOnly ? _self.gameOnly : gameOnly // ignore: cast_nullable_to_non_nullable
as bool,autoSend: null == autoSend ? _self.autoSend : autoSend // ignore: cast_nullable_to_non_nullable
as bool,chatMode: null == chatMode ? _self.chatMode : chatMode // ignore: cast_nullable_to_non_nullable
as InputMethodHotkeyChatMode,windowX: freezed == windowX ? _self.windowX : windowX // ignore: cast_nullable_to_non_nullable
as int?,windowY: freezed == windowY ? _self.windowY : windowY // ignore: cast_nullable_to_non_nullable
as int?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [InputMethodHotkeyState].
extension InputMethodHotkeyStatePatterns on InputMethodHotkeyState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InputMethodHotkeyState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InputMethodHotkeyState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InputMethodHotkeyState value)  $default,){
final _that = this;
switch (_that) {
case _InputMethodHotkeyState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InputMethodHotkeyState value)?  $default,){
final _that = this;
switch (_that) {
case _InputMethodHotkeyState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool enabled,  bool isRunning,  bool isCapturing,  ime.ImeHotkey hotkey,  bool gameOnly,  bool autoSend,  InputMethodHotkeyChatMode chatMode,  int? windowX,  int? windowY,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InputMethodHotkeyState() when $default != null:
return $default(_that.enabled,_that.isRunning,_that.isCapturing,_that.hotkey,_that.gameOnly,_that.autoSend,_that.chatMode,_that.windowX,_that.windowY,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool enabled,  bool isRunning,  bool isCapturing,  ime.ImeHotkey hotkey,  bool gameOnly,  bool autoSend,  InputMethodHotkeyChatMode chatMode,  int? windowX,  int? windowY,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _InputMethodHotkeyState():
return $default(_that.enabled,_that.isRunning,_that.isCapturing,_that.hotkey,_that.gameOnly,_that.autoSend,_that.chatMode,_that.windowX,_that.windowY,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool enabled,  bool isRunning,  bool isCapturing,  ime.ImeHotkey hotkey,  bool gameOnly,  bool autoSend,  InputMethodHotkeyChatMode chatMode,  int? windowX,  int? windowY,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _InputMethodHotkeyState() when $default != null:
return $default(_that.enabled,_that.isRunning,_that.isCapturing,_that.hotkey,_that.gameOnly,_that.autoSend,_that.chatMode,_that.windowX,_that.windowY,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _InputMethodHotkeyState implements InputMethodHotkeyState {
  const _InputMethodHotkeyState({this.enabled = false, this.isRunning = false, this.isCapturing = false, this.hotkey = _defaultHotkey, this.gameOnly = true, this.autoSend = true, this.chatMode = InputMethodHotkeyChatMode.openBeforeSend, this.windowX, this.windowY, this.errorMessage});
  

@override@JsonKey() final  bool enabled;
@override@JsonKey() final  bool isRunning;
@override@JsonKey() final  bool isCapturing;
@override@JsonKey() final  ime.ImeHotkey hotkey;
@override@JsonKey() final  bool gameOnly;
@override@JsonKey() final  bool autoSend;
@override@JsonKey() final  InputMethodHotkeyChatMode chatMode;
@override final  int? windowX;
@override final  int? windowY;
@override final  String? errorMessage;

/// Create a copy of InputMethodHotkeyState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InputMethodHotkeyStateCopyWith<_InputMethodHotkeyState> get copyWith => __$InputMethodHotkeyStateCopyWithImpl<_InputMethodHotkeyState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InputMethodHotkeyState&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.isRunning, isRunning) || other.isRunning == isRunning)&&(identical(other.isCapturing, isCapturing) || other.isCapturing == isCapturing)&&(identical(other.hotkey, hotkey) || other.hotkey == hotkey)&&(identical(other.gameOnly, gameOnly) || other.gameOnly == gameOnly)&&(identical(other.autoSend, autoSend) || other.autoSend == autoSend)&&(identical(other.chatMode, chatMode) || other.chatMode == chatMode)&&(identical(other.windowX, windowX) || other.windowX == windowX)&&(identical(other.windowY, windowY) || other.windowY == windowY)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode {
    return Object.hash(runtimeType,enabled,isRunning,isCapturing,hotkey,gameOnly,autoSend,chatMode,windowX,windowY,errorMessage);
}

@override
String toString() {
    return 'InputMethodHotkeyState(enabled: $enabled, isRunning: $isRunning, isCapturing: $isCapturing, hotkey: $hotkey, gameOnly: $gameOnly, autoSend: $autoSend, chatMode: $chatMode, windowX: $windowX, windowY: $windowY, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$InputMethodHotkeyStateCopyWith<$Res> implements $InputMethodHotkeyStateCopyWith<$Res> {
  factory _$InputMethodHotkeyStateCopyWith(_InputMethodHotkeyState value, $Res Function(_InputMethodHotkeyState) _then) = __$InputMethodHotkeyStateCopyWithImpl;
@override @useResult
$Res call({
 bool enabled, bool isRunning, bool isCapturing, ime.ImeHotkey hotkey, bool gameOnly, bool autoSend, InputMethodHotkeyChatMode chatMode, int? windowX, int? windowY, String? errorMessage
});




}
/// @nodoc
class __$InputMethodHotkeyStateCopyWithImpl<$Res>
    implements _$InputMethodHotkeyStateCopyWith<$Res> {
  __$InputMethodHotkeyStateCopyWithImpl(this._self, this._then);

  final _InputMethodHotkeyState _self;
  final $Res Function(_InputMethodHotkeyState) _then;

/// Create a copy of InputMethodHotkeyState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,Object? isRunning = null,Object? isCapturing = null,Object? hotkey = null,Object? gameOnly = null,Object? autoSend = null,Object? chatMode = null,Object? windowX = freezed,Object? windowY = freezed,Object? errorMessage = freezed,}) {
  return _then(_InputMethodHotkeyState(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,isRunning: null == isRunning ? _self.isRunning : isRunning // ignore: cast_nullable_to_non_nullable
as bool,isCapturing: null == isCapturing ? _self.isCapturing : isCapturing // ignore: cast_nullable_to_non_nullable
as bool,hotkey: null == hotkey ? _self.hotkey : hotkey // ignore: cast_nullable_to_non_nullable
as ime.ImeHotkey,gameOnly: null == gameOnly ? _self.gameOnly : gameOnly // ignore: cast_nullable_to_non_nullable
as bool,autoSend: null == autoSend ? _self.autoSend : autoSend // ignore: cast_nullable_to_non_nullable
as bool,chatMode: null == chatMode ? _self.chatMode : chatMode // ignore: cast_nullable_to_non_nullable
as InputMethodHotkeyChatMode,windowX: freezed == windowX ? _self.windowX : windowX // ignore: cast_nullable_to_non_nullable
as int?,windowY: freezed == windowY ? _self.windowY : windowY // ignore: cast_nullable_to_non_nullable
as int?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
