// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ime_hotkey_api.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ImeHotkeyEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ImeHotkeyEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ImeHotkeyEvent()';
}


}

/// @nodoc
class $ImeHotkeyEventCopyWith<$Res>  {
$ImeHotkeyEventCopyWith(ImeHotkeyEvent _, $Res Function(ImeHotkeyEvent) __);
}


/// Adds pattern-matching-related methods to [ImeHotkeyEvent].
extension ImeHotkeyEventPatterns on ImeHotkeyEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ImeHotkeyEvent_Submit value)?  submit,TResult Function( ImeHotkeyEvent_Sent value)?  sent,TResult Function( ImeHotkeyEvent_SendFailed value)?  sendFailed,TResult Function( ImeHotkeyEvent_WindowMoved value)?  windowMoved,TResult Function( ImeHotkeyEvent_HotkeyCaptured value)?  hotkeyCaptured,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ImeHotkeyEvent_Submit() when submit != null:
return submit(_that);case ImeHotkeyEvent_Sent() when sent != null:
return sent(_that);case ImeHotkeyEvent_SendFailed() when sendFailed != null:
return sendFailed(_that);case ImeHotkeyEvent_WindowMoved() when windowMoved != null:
return windowMoved(_that);case ImeHotkeyEvent_HotkeyCaptured() when hotkeyCaptured != null:
return hotkeyCaptured(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ImeHotkeyEvent_Submit value)  submit,required TResult Function( ImeHotkeyEvent_Sent value)  sent,required TResult Function( ImeHotkeyEvent_SendFailed value)  sendFailed,required TResult Function( ImeHotkeyEvent_WindowMoved value)  windowMoved,required TResult Function( ImeHotkeyEvent_HotkeyCaptured value)  hotkeyCaptured,}){
final _that = this;
switch (_that) {
case ImeHotkeyEvent_Submit():
return submit(_that);case ImeHotkeyEvent_Sent():
return sent(_that);case ImeHotkeyEvent_SendFailed():
return sendFailed(_that);case ImeHotkeyEvent_WindowMoved():
return windowMoved(_that);case ImeHotkeyEvent_HotkeyCaptured():
return hotkeyCaptured(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ImeHotkeyEvent_Submit value)?  submit,TResult? Function( ImeHotkeyEvent_Sent value)?  sent,TResult? Function( ImeHotkeyEvent_SendFailed value)?  sendFailed,TResult? Function( ImeHotkeyEvent_WindowMoved value)?  windowMoved,TResult? Function( ImeHotkeyEvent_HotkeyCaptured value)?  hotkeyCaptured,}){
final _that = this;
switch (_that) {
case ImeHotkeyEvent_Submit() when submit != null:
return submit(_that);case ImeHotkeyEvent_Sent() when sent != null:
return sent(_that);case ImeHotkeyEvent_SendFailed() when sendFailed != null:
return sendFailed(_that);case ImeHotkeyEvent_WindowMoved() when windowMoved != null:
return windowMoved(_that);case ImeHotkeyEvent_HotkeyCaptured() when hotkeyCaptured != null:
return hotkeyCaptured(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( BigInt id,  String text)?  submit,TResult Function( BigInt id)?  sent,TResult Function( BigInt id,  ImeSendFailure reason)?  sendFailed,TResult Function( int x,  int y)?  windowMoved,TResult Function( ImeHotkey hotkey)?  hotkeyCaptured,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ImeHotkeyEvent_Submit() when submit != null:
return submit(_that.id,_that.text);case ImeHotkeyEvent_Sent() when sent != null:
return sent(_that.id);case ImeHotkeyEvent_SendFailed() when sendFailed != null:
return sendFailed(_that.id,_that.reason);case ImeHotkeyEvent_WindowMoved() when windowMoved != null:
return windowMoved(_that.x,_that.y);case ImeHotkeyEvent_HotkeyCaptured() when hotkeyCaptured != null:
return hotkeyCaptured(_that.hotkey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( BigInt id,  String text)  submit,required TResult Function( BigInt id)  sent,required TResult Function( BigInt id,  ImeSendFailure reason)  sendFailed,required TResult Function( int x,  int y)  windowMoved,required TResult Function( ImeHotkey hotkey)  hotkeyCaptured,}) {final _that = this;
switch (_that) {
case ImeHotkeyEvent_Submit():
return submit(_that.id,_that.text);case ImeHotkeyEvent_Sent():
return sent(_that.id);case ImeHotkeyEvent_SendFailed():
return sendFailed(_that.id,_that.reason);case ImeHotkeyEvent_WindowMoved():
return windowMoved(_that.x,_that.y);case ImeHotkeyEvent_HotkeyCaptured():
return hotkeyCaptured(_that.hotkey);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( BigInt id,  String text)?  submit,TResult? Function( BigInt id)?  sent,TResult? Function( BigInt id,  ImeSendFailure reason)?  sendFailed,TResult? Function( int x,  int y)?  windowMoved,TResult? Function( ImeHotkey hotkey)?  hotkeyCaptured,}) {final _that = this;
switch (_that) {
case ImeHotkeyEvent_Submit() when submit != null:
return submit(_that.id,_that.text);case ImeHotkeyEvent_Sent() when sent != null:
return sent(_that.id);case ImeHotkeyEvent_SendFailed() when sendFailed != null:
return sendFailed(_that.id,_that.reason);case ImeHotkeyEvent_WindowMoved() when windowMoved != null:
return windowMoved(_that.x,_that.y);case ImeHotkeyEvent_HotkeyCaptured() when hotkeyCaptured != null:
return hotkeyCaptured(_that.hotkey);case _:
  return null;

}
}

}

/// @nodoc


class ImeHotkeyEvent_Submit extends ImeHotkeyEvent {
  const ImeHotkeyEvent_Submit({required this.id, required this.text}): super._();
  

 final  BigInt id;
 final  String text;

/// Create a copy of ImeHotkeyEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImeHotkeyEvent_SubmitCopyWith<ImeHotkeyEvent_Submit> get copyWith => _$ImeHotkeyEvent_SubmitCopyWithImpl<ImeHotkeyEvent_Submit>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ImeHotkeyEvent_Submit&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,text);
}

@override
String toString() {
    return 'ImeHotkeyEvent.submit(id: $id, text: $text)';
}


}

/// @nodoc
abstract mixin class $ImeHotkeyEvent_SubmitCopyWith<$Res> implements $ImeHotkeyEventCopyWith<$Res> {
  factory $ImeHotkeyEvent_SubmitCopyWith(ImeHotkeyEvent_Submit value, $Res Function(ImeHotkeyEvent_Submit) _then) = _$ImeHotkeyEvent_SubmitCopyWithImpl;
@useResult
$Res call({
 BigInt id, String text
});




}
/// @nodoc
class _$ImeHotkeyEvent_SubmitCopyWithImpl<$Res>
    implements $ImeHotkeyEvent_SubmitCopyWith<$Res> {
  _$ImeHotkeyEvent_SubmitCopyWithImpl(this._self, this._then);

  final ImeHotkeyEvent_Submit _self;
  final $Res Function(ImeHotkeyEvent_Submit) _then;

/// Create a copy of ImeHotkeyEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = null,}) {
  return _then(ImeHotkeyEvent_Submit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as BigInt,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ImeHotkeyEvent_Sent extends ImeHotkeyEvent {
  const ImeHotkeyEvent_Sent({required this.id}): super._();
  

 final  BigInt id;

/// Create a copy of ImeHotkeyEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImeHotkeyEvent_SentCopyWith<ImeHotkeyEvent_Sent> get copyWith => _$ImeHotkeyEvent_SentCopyWithImpl<ImeHotkeyEvent_Sent>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ImeHotkeyEvent_Sent&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id);
}

@override
String toString() {
    return 'ImeHotkeyEvent.sent(id: $id)';
}


}

/// @nodoc
abstract mixin class $ImeHotkeyEvent_SentCopyWith<$Res> implements $ImeHotkeyEventCopyWith<$Res> {
  factory $ImeHotkeyEvent_SentCopyWith(ImeHotkeyEvent_Sent value, $Res Function(ImeHotkeyEvent_Sent) _then) = _$ImeHotkeyEvent_SentCopyWithImpl;
@useResult
$Res call({
 BigInt id
});




}
/// @nodoc
class _$ImeHotkeyEvent_SentCopyWithImpl<$Res>
    implements $ImeHotkeyEvent_SentCopyWith<$Res> {
  _$ImeHotkeyEvent_SentCopyWithImpl(this._self, this._then);

  final ImeHotkeyEvent_Sent _self;
  final $Res Function(ImeHotkeyEvent_Sent) _then;

/// Create a copy of ImeHotkeyEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(ImeHotkeyEvent_Sent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as BigInt,
  ));
}


}

/// @nodoc


class ImeHotkeyEvent_SendFailed extends ImeHotkeyEvent {
  const ImeHotkeyEvent_SendFailed({required this.id, required this.reason}): super._();
  

 final  BigInt id;
 final  ImeSendFailure reason;

/// Create a copy of ImeHotkeyEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImeHotkeyEvent_SendFailedCopyWith<ImeHotkeyEvent_SendFailed> get copyWith => _$ImeHotkeyEvent_SendFailedCopyWithImpl<ImeHotkeyEvent_SendFailed>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ImeHotkeyEvent_SendFailed&&(identical(other.id, id) || other.id == id)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,reason);
}

@override
String toString() {
    return 'ImeHotkeyEvent.sendFailed(id: $id, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $ImeHotkeyEvent_SendFailedCopyWith<$Res> implements $ImeHotkeyEventCopyWith<$Res> {
  factory $ImeHotkeyEvent_SendFailedCopyWith(ImeHotkeyEvent_SendFailed value, $Res Function(ImeHotkeyEvent_SendFailed) _then) = _$ImeHotkeyEvent_SendFailedCopyWithImpl;
@useResult
$Res call({
 BigInt id, ImeSendFailure reason
});




}
/// @nodoc
class _$ImeHotkeyEvent_SendFailedCopyWithImpl<$Res>
    implements $ImeHotkeyEvent_SendFailedCopyWith<$Res> {
  _$ImeHotkeyEvent_SendFailedCopyWithImpl(this._self, this._then);

  final ImeHotkeyEvent_SendFailed _self;
  final $Res Function(ImeHotkeyEvent_SendFailed) _then;

/// Create a copy of ImeHotkeyEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? reason = null,}) {
  return _then(ImeHotkeyEvent_SendFailed(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as BigInt,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as ImeSendFailure,
  ));
}


}

/// @nodoc


class ImeHotkeyEvent_WindowMoved extends ImeHotkeyEvent {
  const ImeHotkeyEvent_WindowMoved({required this.x, required this.y}): super._();
  

 final  int x;
 final  int y;

/// Create a copy of ImeHotkeyEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImeHotkeyEvent_WindowMovedCopyWith<ImeHotkeyEvent_WindowMoved> get copyWith => _$ImeHotkeyEvent_WindowMovedCopyWithImpl<ImeHotkeyEvent_WindowMoved>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ImeHotkeyEvent_WindowMoved&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y));
}


@override
int get hashCode {
    return Object.hash(runtimeType,x,y);
}

@override
String toString() {
    return 'ImeHotkeyEvent.windowMoved(x: $x, y: $y)';
}


}

/// @nodoc
abstract mixin class $ImeHotkeyEvent_WindowMovedCopyWith<$Res> implements $ImeHotkeyEventCopyWith<$Res> {
  factory $ImeHotkeyEvent_WindowMovedCopyWith(ImeHotkeyEvent_WindowMoved value, $Res Function(ImeHotkeyEvent_WindowMoved) _then) = _$ImeHotkeyEvent_WindowMovedCopyWithImpl;
@useResult
$Res call({
 int x, int y
});




}
/// @nodoc
class _$ImeHotkeyEvent_WindowMovedCopyWithImpl<$Res>
    implements $ImeHotkeyEvent_WindowMovedCopyWith<$Res> {
  _$ImeHotkeyEvent_WindowMovedCopyWithImpl(this._self, this._then);

  final ImeHotkeyEvent_WindowMoved _self;
  final $Res Function(ImeHotkeyEvent_WindowMoved) _then;

/// Create a copy of ImeHotkeyEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? x = null,Object? y = null,}) {
  return _then(ImeHotkeyEvent_WindowMoved(
x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as int,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ImeHotkeyEvent_HotkeyCaptured extends ImeHotkeyEvent {
  const ImeHotkeyEvent_HotkeyCaptured({required this.hotkey}): super._();
  

 final  ImeHotkey hotkey;

/// Create a copy of ImeHotkeyEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImeHotkeyEvent_HotkeyCapturedCopyWith<ImeHotkeyEvent_HotkeyCaptured> get copyWith => _$ImeHotkeyEvent_HotkeyCapturedCopyWithImpl<ImeHotkeyEvent_HotkeyCaptured>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ImeHotkeyEvent_HotkeyCaptured&&(identical(other.hotkey, hotkey) || other.hotkey == hotkey));
}


@override
int get hashCode {
    return Object.hash(runtimeType,hotkey);
}

@override
String toString() {
    return 'ImeHotkeyEvent.hotkeyCaptured(hotkey: $hotkey)';
}


}

/// @nodoc
abstract mixin class $ImeHotkeyEvent_HotkeyCapturedCopyWith<$Res> implements $ImeHotkeyEventCopyWith<$Res> {
  factory $ImeHotkeyEvent_HotkeyCapturedCopyWith(ImeHotkeyEvent_HotkeyCaptured value, $Res Function(ImeHotkeyEvent_HotkeyCaptured) _then) = _$ImeHotkeyEvent_HotkeyCapturedCopyWithImpl;
@useResult
$Res call({
 ImeHotkey hotkey
});




}
/// @nodoc
class _$ImeHotkeyEvent_HotkeyCapturedCopyWithImpl<$Res>
    implements $ImeHotkeyEvent_HotkeyCapturedCopyWith<$Res> {
  _$ImeHotkeyEvent_HotkeyCapturedCopyWithImpl(this._self, this._then);

  final ImeHotkeyEvent_HotkeyCaptured _self;
  final $Res Function(ImeHotkeyEvent_HotkeyCaptured) _then;

/// Create a copy of ImeHotkeyEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? hotkey = null,}) {
  return _then(ImeHotkeyEvent_HotkeyCaptured(
hotkey: null == hotkey ? _self.hotkey : hotkey // ignore: cast_nullable_to_non_nullable
as ImeHotkey,
  ));
}


}

// dart format on
