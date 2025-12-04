// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'webview_api.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WebViewConfiguration {

 String get title; int get width; int get height; String? get userDataFolder; bool get enableDevtools; bool get transparent; String? get userAgent;
/// Create a copy of WebViewConfiguration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WebViewConfigurationCopyWith<WebViewConfiguration> get copyWith => _$WebViewConfigurationCopyWithImpl<WebViewConfiguration>(this as WebViewConfiguration, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WebViewConfiguration&&(identical(other.title, title) || other.title == title)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.userDataFolder, userDataFolder) || other.userDataFolder == userDataFolder)&&(identical(other.enableDevtools, enableDevtools) || other.enableDevtools == enableDevtools)&&(identical(other.transparent, transparent) || other.transparent == transparent)&&(identical(other.userAgent, userAgent) || other.userAgent == userAgent));
}


@override
int get hashCode => Object.hash(runtimeType,title,width,height,userDataFolder,enableDevtools,transparent,userAgent);

@override
String toString() {
  return 'WebViewConfiguration(title: $title, width: $width, height: $height, userDataFolder: $userDataFolder, enableDevtools: $enableDevtools, transparent: $transparent, userAgent: $userAgent)';
}


}

/// @nodoc
abstract mixin class $WebViewConfigurationCopyWith<$Res>  {
  factory $WebViewConfigurationCopyWith(WebViewConfiguration value, $Res Function(WebViewConfiguration) _then) = _$WebViewConfigurationCopyWithImpl;
@useResult
$Res call({
 String title, int width, int height, String? userDataFolder, bool enableDevtools, bool transparent, String? userAgent
});




}
/// @nodoc
class _$WebViewConfigurationCopyWithImpl<$Res>
    implements $WebViewConfigurationCopyWith<$Res> {
  _$WebViewConfigurationCopyWithImpl(this._self, this._then);

  final WebViewConfiguration _self;
  final $Res Function(WebViewConfiguration) _then;

/// Create a copy of WebViewConfiguration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? width = null,Object? height = null,Object? userDataFolder = freezed,Object? enableDevtools = null,Object? transparent = null,Object? userAgent = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,userDataFolder: freezed == userDataFolder ? _self.userDataFolder : userDataFolder // ignore: cast_nullable_to_non_nullable
as String?,enableDevtools: null == enableDevtools ? _self.enableDevtools : enableDevtools // ignore: cast_nullable_to_non_nullable
as bool,transparent: null == transparent ? _self.transparent : transparent // ignore: cast_nullable_to_non_nullable
as bool,userAgent: freezed == userAgent ? _self.userAgent : userAgent // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WebViewConfiguration].
extension WebViewConfigurationPatterns on WebViewConfiguration {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WebViewConfiguration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WebViewConfiguration() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WebViewConfiguration value)  $default,){
final _that = this;
switch (_that) {
case _WebViewConfiguration():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WebViewConfiguration value)?  $default,){
final _that = this;
switch (_that) {
case _WebViewConfiguration() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  int width,  int height,  String? userDataFolder,  bool enableDevtools,  bool transparent,  String? userAgent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WebViewConfiguration() when $default != null:
return $default(_that.title,_that.width,_that.height,_that.userDataFolder,_that.enableDevtools,_that.transparent,_that.userAgent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  int width,  int height,  String? userDataFolder,  bool enableDevtools,  bool transparent,  String? userAgent)  $default,) {final _that = this;
switch (_that) {
case _WebViewConfiguration():
return $default(_that.title,_that.width,_that.height,_that.userDataFolder,_that.enableDevtools,_that.transparent,_that.userAgent);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  int width,  int height,  String? userDataFolder,  bool enableDevtools,  bool transparent,  String? userAgent)?  $default,) {final _that = this;
switch (_that) {
case _WebViewConfiguration() when $default != null:
return $default(_that.title,_that.width,_that.height,_that.userDataFolder,_that.enableDevtools,_that.transparent,_that.userAgent);case _:
  return null;

}
}

}

/// @nodoc


class _WebViewConfiguration extends WebViewConfiguration {
  const _WebViewConfiguration({required this.title, required this.width, required this.height, this.userDataFolder, required this.enableDevtools, required this.transparent, this.userAgent}): super._();
  

@override final  String title;
@override final  int width;
@override final  int height;
@override final  String? userDataFolder;
@override final  bool enableDevtools;
@override final  bool transparent;
@override final  String? userAgent;

/// Create a copy of WebViewConfiguration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WebViewConfigurationCopyWith<_WebViewConfiguration> get copyWith => __$WebViewConfigurationCopyWithImpl<_WebViewConfiguration>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WebViewConfiguration&&(identical(other.title, title) || other.title == title)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.userDataFolder, userDataFolder) || other.userDataFolder == userDataFolder)&&(identical(other.enableDevtools, enableDevtools) || other.enableDevtools == enableDevtools)&&(identical(other.transparent, transparent) || other.transparent == transparent)&&(identical(other.userAgent, userAgent) || other.userAgent == userAgent));
}


@override
int get hashCode => Object.hash(runtimeType,title,width,height,userDataFolder,enableDevtools,transparent,userAgent);

@override
String toString() {
  return 'WebViewConfiguration(title: $title, width: $width, height: $height, userDataFolder: $userDataFolder, enableDevtools: $enableDevtools, transparent: $transparent, userAgent: $userAgent)';
}


}

/// @nodoc
abstract mixin class _$WebViewConfigurationCopyWith<$Res> implements $WebViewConfigurationCopyWith<$Res> {
  factory _$WebViewConfigurationCopyWith(_WebViewConfiguration value, $Res Function(_WebViewConfiguration) _then) = __$WebViewConfigurationCopyWithImpl;
@override @useResult
$Res call({
 String title, int width, int height, String? userDataFolder, bool enableDevtools, bool transparent, String? userAgent
});




}
/// @nodoc
class __$WebViewConfigurationCopyWithImpl<$Res>
    implements _$WebViewConfigurationCopyWith<$Res> {
  __$WebViewConfigurationCopyWithImpl(this._self, this._then);

  final _WebViewConfiguration _self;
  final $Res Function(_WebViewConfiguration) _then;

/// Create a copy of WebViewConfiguration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? width = null,Object? height = null,Object? userDataFolder = freezed,Object? enableDevtools = null,Object? transparent = null,Object? userAgent = freezed,}) {
  return _then(_WebViewConfiguration(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,userDataFolder: freezed == userDataFolder ? _self.userDataFolder : userDataFolder // ignore: cast_nullable_to_non_nullable
as String?,enableDevtools: null == enableDevtools ? _self.enableDevtools : enableDevtools // ignore: cast_nullable_to_non_nullable
as bool,transparent: null == transparent ? _self.transparent : transparent // ignore: cast_nullable_to_non_nullable
as bool,userAgent: freezed == userAgent ? _self.userAgent : userAgent // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$WebViewEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WebViewEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WebViewEvent()';
}


}

/// @nodoc
class $WebViewEventCopyWith<$Res>  {
$WebViewEventCopyWith(WebViewEvent _, $Res Function(WebViewEvent) __);
}


/// Adds pattern-matching-related methods to [WebViewEvent].
extension WebViewEventPatterns on WebViewEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( WebViewEvent_NavigationStarted value)?  navigationStarted,TResult Function( WebViewEvent_NavigationCompleted value)?  navigationCompleted,TResult Function( WebViewEvent_TitleChanged value)?  titleChanged,TResult Function( WebViewEvent_WebMessage value)?  webMessage,TResult Function( WebViewEvent_WindowClosed value)?  windowClosed,TResult Function( WebViewEvent_Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case WebViewEvent_NavigationStarted() when navigationStarted != null:
return navigationStarted(_that);case WebViewEvent_NavigationCompleted() when navigationCompleted != null:
return navigationCompleted(_that);case WebViewEvent_TitleChanged() when titleChanged != null:
return titleChanged(_that);case WebViewEvent_WebMessage() when webMessage != null:
return webMessage(_that);case WebViewEvent_WindowClosed() when windowClosed != null:
return windowClosed(_that);case WebViewEvent_Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( WebViewEvent_NavigationStarted value)  navigationStarted,required TResult Function( WebViewEvent_NavigationCompleted value)  navigationCompleted,required TResult Function( WebViewEvent_TitleChanged value)  titleChanged,required TResult Function( WebViewEvent_WebMessage value)  webMessage,required TResult Function( WebViewEvent_WindowClosed value)  windowClosed,required TResult Function( WebViewEvent_Error value)  error,}){
final _that = this;
switch (_that) {
case WebViewEvent_NavigationStarted():
return navigationStarted(_that);case WebViewEvent_NavigationCompleted():
return navigationCompleted(_that);case WebViewEvent_TitleChanged():
return titleChanged(_that);case WebViewEvent_WebMessage():
return webMessage(_that);case WebViewEvent_WindowClosed():
return windowClosed(_that);case WebViewEvent_Error():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( WebViewEvent_NavigationStarted value)?  navigationStarted,TResult? Function( WebViewEvent_NavigationCompleted value)?  navigationCompleted,TResult? Function( WebViewEvent_TitleChanged value)?  titleChanged,TResult? Function( WebViewEvent_WebMessage value)?  webMessage,TResult? Function( WebViewEvent_WindowClosed value)?  windowClosed,TResult? Function( WebViewEvent_Error value)?  error,}){
final _that = this;
switch (_that) {
case WebViewEvent_NavigationStarted() when navigationStarted != null:
return navigationStarted(_that);case WebViewEvent_NavigationCompleted() when navigationCompleted != null:
return navigationCompleted(_that);case WebViewEvent_TitleChanged() when titleChanged != null:
return titleChanged(_that);case WebViewEvent_WebMessage() when webMessage != null:
return webMessage(_that);case WebViewEvent_WindowClosed() when windowClosed != null:
return windowClosed(_that);case WebViewEvent_Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String url)?  navigationStarted,TResult Function( String url)?  navigationCompleted,TResult Function( String title)?  titleChanged,TResult Function( String message)?  webMessage,TResult Function()?  windowClosed,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case WebViewEvent_NavigationStarted() when navigationStarted != null:
return navigationStarted(_that.url);case WebViewEvent_NavigationCompleted() when navigationCompleted != null:
return navigationCompleted(_that.url);case WebViewEvent_TitleChanged() when titleChanged != null:
return titleChanged(_that.title);case WebViewEvent_WebMessage() when webMessage != null:
return webMessage(_that.message);case WebViewEvent_WindowClosed() when windowClosed != null:
return windowClosed();case WebViewEvent_Error() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String url)  navigationStarted,required TResult Function( String url)  navigationCompleted,required TResult Function( String title)  titleChanged,required TResult Function( String message)  webMessage,required TResult Function()  windowClosed,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case WebViewEvent_NavigationStarted():
return navigationStarted(_that.url);case WebViewEvent_NavigationCompleted():
return navigationCompleted(_that.url);case WebViewEvent_TitleChanged():
return titleChanged(_that.title);case WebViewEvent_WebMessage():
return webMessage(_that.message);case WebViewEvent_WindowClosed():
return windowClosed();case WebViewEvent_Error():
return error(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String url)?  navigationStarted,TResult? Function( String url)?  navigationCompleted,TResult? Function( String title)?  titleChanged,TResult? Function( String message)?  webMessage,TResult? Function()?  windowClosed,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case WebViewEvent_NavigationStarted() when navigationStarted != null:
return navigationStarted(_that.url);case WebViewEvent_NavigationCompleted() when navigationCompleted != null:
return navigationCompleted(_that.url);case WebViewEvent_TitleChanged() when titleChanged != null:
return titleChanged(_that.title);case WebViewEvent_WebMessage() when webMessage != null:
return webMessage(_that.message);case WebViewEvent_WindowClosed() when windowClosed != null:
return windowClosed();case WebViewEvent_Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class WebViewEvent_NavigationStarted extends WebViewEvent {
  const WebViewEvent_NavigationStarted({required this.url}): super._();
  

 final  String url;

/// Create a copy of WebViewEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WebViewEvent_NavigationStartedCopyWith<WebViewEvent_NavigationStarted> get copyWith => _$WebViewEvent_NavigationStartedCopyWithImpl<WebViewEvent_NavigationStarted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WebViewEvent_NavigationStarted&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,url);

@override
String toString() {
  return 'WebViewEvent.navigationStarted(url: $url)';
}


}

/// @nodoc
abstract mixin class $WebViewEvent_NavigationStartedCopyWith<$Res> implements $WebViewEventCopyWith<$Res> {
  factory $WebViewEvent_NavigationStartedCopyWith(WebViewEvent_NavigationStarted value, $Res Function(WebViewEvent_NavigationStarted) _then) = _$WebViewEvent_NavigationStartedCopyWithImpl;
@useResult
$Res call({
 String url
});




}
/// @nodoc
class _$WebViewEvent_NavigationStartedCopyWithImpl<$Res>
    implements $WebViewEvent_NavigationStartedCopyWith<$Res> {
  _$WebViewEvent_NavigationStartedCopyWithImpl(this._self, this._then);

  final WebViewEvent_NavigationStarted _self;
  final $Res Function(WebViewEvent_NavigationStarted) _then;

/// Create a copy of WebViewEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? url = null,}) {
  return _then(WebViewEvent_NavigationStarted(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class WebViewEvent_NavigationCompleted extends WebViewEvent {
  const WebViewEvent_NavigationCompleted({required this.url}): super._();
  

 final  String url;

/// Create a copy of WebViewEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WebViewEvent_NavigationCompletedCopyWith<WebViewEvent_NavigationCompleted> get copyWith => _$WebViewEvent_NavigationCompletedCopyWithImpl<WebViewEvent_NavigationCompleted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WebViewEvent_NavigationCompleted&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,url);

@override
String toString() {
  return 'WebViewEvent.navigationCompleted(url: $url)';
}


}

/// @nodoc
abstract mixin class $WebViewEvent_NavigationCompletedCopyWith<$Res> implements $WebViewEventCopyWith<$Res> {
  factory $WebViewEvent_NavigationCompletedCopyWith(WebViewEvent_NavigationCompleted value, $Res Function(WebViewEvent_NavigationCompleted) _then) = _$WebViewEvent_NavigationCompletedCopyWithImpl;
@useResult
$Res call({
 String url
});




}
/// @nodoc
class _$WebViewEvent_NavigationCompletedCopyWithImpl<$Res>
    implements $WebViewEvent_NavigationCompletedCopyWith<$Res> {
  _$WebViewEvent_NavigationCompletedCopyWithImpl(this._self, this._then);

  final WebViewEvent_NavigationCompleted _self;
  final $Res Function(WebViewEvent_NavigationCompleted) _then;

/// Create a copy of WebViewEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? url = null,}) {
  return _then(WebViewEvent_NavigationCompleted(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class WebViewEvent_TitleChanged extends WebViewEvent {
  const WebViewEvent_TitleChanged({required this.title}): super._();
  

 final  String title;

/// Create a copy of WebViewEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WebViewEvent_TitleChangedCopyWith<WebViewEvent_TitleChanged> get copyWith => _$WebViewEvent_TitleChangedCopyWithImpl<WebViewEvent_TitleChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WebViewEvent_TitleChanged&&(identical(other.title, title) || other.title == title));
}


@override
int get hashCode => Object.hash(runtimeType,title);

@override
String toString() {
  return 'WebViewEvent.titleChanged(title: $title)';
}


}

/// @nodoc
abstract mixin class $WebViewEvent_TitleChangedCopyWith<$Res> implements $WebViewEventCopyWith<$Res> {
  factory $WebViewEvent_TitleChangedCopyWith(WebViewEvent_TitleChanged value, $Res Function(WebViewEvent_TitleChanged) _then) = _$WebViewEvent_TitleChangedCopyWithImpl;
@useResult
$Res call({
 String title
});




}
/// @nodoc
class _$WebViewEvent_TitleChangedCopyWithImpl<$Res>
    implements $WebViewEvent_TitleChangedCopyWith<$Res> {
  _$WebViewEvent_TitleChangedCopyWithImpl(this._self, this._then);

  final WebViewEvent_TitleChanged _self;
  final $Res Function(WebViewEvent_TitleChanged) _then;

/// Create a copy of WebViewEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? title = null,}) {
  return _then(WebViewEvent_TitleChanged(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class WebViewEvent_WebMessage extends WebViewEvent {
  const WebViewEvent_WebMessage({required this.message}): super._();
  

 final  String message;

/// Create a copy of WebViewEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WebViewEvent_WebMessageCopyWith<WebViewEvent_WebMessage> get copyWith => _$WebViewEvent_WebMessageCopyWithImpl<WebViewEvent_WebMessage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WebViewEvent_WebMessage&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'WebViewEvent.webMessage(message: $message)';
}


}

/// @nodoc
abstract mixin class $WebViewEvent_WebMessageCopyWith<$Res> implements $WebViewEventCopyWith<$Res> {
  factory $WebViewEvent_WebMessageCopyWith(WebViewEvent_WebMessage value, $Res Function(WebViewEvent_WebMessage) _then) = _$WebViewEvent_WebMessageCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$WebViewEvent_WebMessageCopyWithImpl<$Res>
    implements $WebViewEvent_WebMessageCopyWith<$Res> {
  _$WebViewEvent_WebMessageCopyWithImpl(this._self, this._then);

  final WebViewEvent_WebMessage _self;
  final $Res Function(WebViewEvent_WebMessage) _then;

/// Create a copy of WebViewEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(WebViewEvent_WebMessage(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class WebViewEvent_WindowClosed extends WebViewEvent {
  const WebViewEvent_WindowClosed(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WebViewEvent_WindowClosed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WebViewEvent.windowClosed()';
}


}




/// @nodoc


class WebViewEvent_Error extends WebViewEvent {
  const WebViewEvent_Error({required this.message}): super._();
  

 final  String message;

/// Create a copy of WebViewEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WebViewEvent_ErrorCopyWith<WebViewEvent_Error> get copyWith => _$WebViewEvent_ErrorCopyWithImpl<WebViewEvent_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WebViewEvent_Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'WebViewEvent.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $WebViewEvent_ErrorCopyWith<$Res> implements $WebViewEventCopyWith<$Res> {
  factory $WebViewEvent_ErrorCopyWith(WebViewEvent_Error value, $Res Function(WebViewEvent_Error) _then) = _$WebViewEvent_ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$WebViewEvent_ErrorCopyWithImpl<$Res>
    implements $WebViewEvent_ErrorCopyWith<$Res> {
  _$WebViewEvent_ErrorCopyWithImpl(this._self, this._then);

  final WebViewEvent_Error _self;
  final $Res Function(WebViewEvent_Error) _then;

/// Create a copy of WebViewEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(WebViewEvent_Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$WebViewNavigationState {

 String get url; String get title; bool get canGoBack; bool get canGoForward; bool get isLoading;
/// Create a copy of WebViewNavigationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WebViewNavigationStateCopyWith<WebViewNavigationState> get copyWith => _$WebViewNavigationStateCopyWithImpl<WebViewNavigationState>(this as WebViewNavigationState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WebViewNavigationState&&(identical(other.url, url) || other.url == url)&&(identical(other.title, title) || other.title == title)&&(identical(other.canGoBack, canGoBack) || other.canGoBack == canGoBack)&&(identical(other.canGoForward, canGoForward) || other.canGoForward == canGoForward)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,url,title,canGoBack,canGoForward,isLoading);

@override
String toString() {
  return 'WebViewNavigationState(url: $url, title: $title, canGoBack: $canGoBack, canGoForward: $canGoForward, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $WebViewNavigationStateCopyWith<$Res>  {
  factory $WebViewNavigationStateCopyWith(WebViewNavigationState value, $Res Function(WebViewNavigationState) _then) = _$WebViewNavigationStateCopyWithImpl;
@useResult
$Res call({
 String url, String title, bool canGoBack, bool canGoForward, bool isLoading
});




}
/// @nodoc
class _$WebViewNavigationStateCopyWithImpl<$Res>
    implements $WebViewNavigationStateCopyWith<$Res> {
  _$WebViewNavigationStateCopyWithImpl(this._self, this._then);

  final WebViewNavigationState _self;
  final $Res Function(WebViewNavigationState) _then;

/// Create a copy of WebViewNavigationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,Object? title = null,Object? canGoBack = null,Object? canGoForward = null,Object? isLoading = null,}) {
  return _then(_self.copyWith(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,canGoBack: null == canGoBack ? _self.canGoBack : canGoBack // ignore: cast_nullable_to_non_nullable
as bool,canGoForward: null == canGoForward ? _self.canGoForward : canGoForward // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WebViewNavigationState].
extension WebViewNavigationStatePatterns on WebViewNavigationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WebViewNavigationState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WebViewNavigationState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WebViewNavigationState value)  $default,){
final _that = this;
switch (_that) {
case _WebViewNavigationState():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WebViewNavigationState value)?  $default,){
final _that = this;
switch (_that) {
case _WebViewNavigationState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String url,  String title,  bool canGoBack,  bool canGoForward,  bool isLoading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WebViewNavigationState() when $default != null:
return $default(_that.url,_that.title,_that.canGoBack,_that.canGoForward,_that.isLoading);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String url,  String title,  bool canGoBack,  bool canGoForward,  bool isLoading)  $default,) {final _that = this;
switch (_that) {
case _WebViewNavigationState():
return $default(_that.url,_that.title,_that.canGoBack,_that.canGoForward,_that.isLoading);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String url,  String title,  bool canGoBack,  bool canGoForward,  bool isLoading)?  $default,) {final _that = this;
switch (_that) {
case _WebViewNavigationState() when $default != null:
return $default(_that.url,_that.title,_that.canGoBack,_that.canGoForward,_that.isLoading);case _:
  return null;

}
}

}

/// @nodoc


class _WebViewNavigationState extends WebViewNavigationState {
  const _WebViewNavigationState({required this.url, required this.title, required this.canGoBack, required this.canGoForward, required this.isLoading}): super._();
  

@override final  String url;
@override final  String title;
@override final  bool canGoBack;
@override final  bool canGoForward;
@override final  bool isLoading;

/// Create a copy of WebViewNavigationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WebViewNavigationStateCopyWith<_WebViewNavigationState> get copyWith => __$WebViewNavigationStateCopyWithImpl<_WebViewNavigationState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WebViewNavigationState&&(identical(other.url, url) || other.url == url)&&(identical(other.title, title) || other.title == title)&&(identical(other.canGoBack, canGoBack) || other.canGoBack == canGoBack)&&(identical(other.canGoForward, canGoForward) || other.canGoForward == canGoForward)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,url,title,canGoBack,canGoForward,isLoading);

@override
String toString() {
  return 'WebViewNavigationState(url: $url, title: $title, canGoBack: $canGoBack, canGoForward: $canGoForward, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$WebViewNavigationStateCopyWith<$Res> implements $WebViewNavigationStateCopyWith<$Res> {
  factory _$WebViewNavigationStateCopyWith(_WebViewNavigationState value, $Res Function(_WebViewNavigationState) _then) = __$WebViewNavigationStateCopyWithImpl;
@override @useResult
$Res call({
 String url, String title, bool canGoBack, bool canGoForward, bool isLoading
});




}
/// @nodoc
class __$WebViewNavigationStateCopyWithImpl<$Res>
    implements _$WebViewNavigationStateCopyWith<$Res> {
  __$WebViewNavigationStateCopyWithImpl(this._self, this._then);

  final _WebViewNavigationState _self;
  final $Res Function(_WebViewNavigationState) _then;

/// Create a copy of WebViewNavigationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,Object? title = null,Object? canGoBack = null,Object? canGoForward = null,Object? isLoading = null,}) {
  return _then(_WebViewNavigationState(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,canGoBack: null == canGoBack ? _self.canGoBack : canGoBack // ignore: cast_nullable_to_non_nullable
as bool,canGoForward: null == canGoForward ? _self.canGoForward : canGoForward // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
