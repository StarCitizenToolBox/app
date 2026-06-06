// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unp4k_model_api.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ModelConvertBytesResult {

 bool get success; Uint8List? get glbBytes; String? get errorCode; String? get errorMessage; List<String> get warnings;
/// Create a copy of ModelConvertBytesResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModelConvertBytesResultCopyWith<ModelConvertBytesResult> get copyWith => _$ModelConvertBytesResultCopyWithImpl<ModelConvertBytesResult>(this as ModelConvertBytesResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModelConvertBytesResult&&(identical(other.success, success) || other.success == success)&&const DeepCollectionEquality().equals(other.glbBytes, glbBytes)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other.warnings, warnings));
}


@override
int get hashCode => Object.hash(runtimeType,success,const DeepCollectionEquality().hash(glbBytes),errorCode,errorMessage,const DeepCollectionEquality().hash(warnings));

@override
String toString() {
  return 'ModelConvertBytesResult(success: $success, glbBytes: $glbBytes, errorCode: $errorCode, errorMessage: $errorMessage, warnings: $warnings)';
}


}

/// @nodoc
abstract mixin class $ModelConvertBytesResultCopyWith<$Res>  {
  factory $ModelConvertBytesResultCopyWith(ModelConvertBytesResult value, $Res Function(ModelConvertBytesResult) _then) = _$ModelConvertBytesResultCopyWithImpl;
@useResult
$Res call({
 bool success, Uint8List? glbBytes, String? errorCode, String? errorMessage, List<String> warnings
});




}
/// @nodoc
class _$ModelConvertBytesResultCopyWithImpl<$Res>
    implements $ModelConvertBytesResultCopyWith<$Res> {
  _$ModelConvertBytesResultCopyWithImpl(this._self, this._then);

  final ModelConvertBytesResult _self;
  final $Res Function(ModelConvertBytesResult) _then;

/// Create a copy of ModelConvertBytesResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? glbBytes = freezed,Object? errorCode = freezed,Object? errorMessage = freezed,Object? warnings = null,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,glbBytes: freezed == glbBytes ? _self.glbBytes : glbBytes // ignore: cast_nullable_to_non_nullable
as Uint8List?,errorCode: freezed == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,warnings: null == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ModelConvertBytesResult].
extension ModelConvertBytesResultPatterns on ModelConvertBytesResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModelConvertBytesResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModelConvertBytesResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModelConvertBytesResult value)  $default,){
final _that = this;
switch (_that) {
case _ModelConvertBytesResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModelConvertBytesResult value)?  $default,){
final _that = this;
switch (_that) {
case _ModelConvertBytesResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  Uint8List? glbBytes,  String? errorCode,  String? errorMessage,  List<String> warnings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModelConvertBytesResult() when $default != null:
return $default(_that.success,_that.glbBytes,_that.errorCode,_that.errorMessage,_that.warnings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  Uint8List? glbBytes,  String? errorCode,  String? errorMessage,  List<String> warnings)  $default,) {final _that = this;
switch (_that) {
case _ModelConvertBytesResult():
return $default(_that.success,_that.glbBytes,_that.errorCode,_that.errorMessage,_that.warnings);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  Uint8List? glbBytes,  String? errorCode,  String? errorMessage,  List<String> warnings)?  $default,) {final _that = this;
switch (_that) {
case _ModelConvertBytesResult() when $default != null:
return $default(_that.success,_that.glbBytes,_that.errorCode,_that.errorMessage,_that.warnings);case _:
  return null;

}
}

}

/// @nodoc


class _ModelConvertBytesResult implements ModelConvertBytesResult {
  const _ModelConvertBytesResult({required this.success, this.glbBytes, this.errorCode, this.errorMessage, required final  List<String> warnings}): _warnings = warnings;
  

@override final  bool success;
@override final  Uint8List? glbBytes;
@override final  String? errorCode;
@override final  String? errorMessage;
 final  List<String> _warnings;
@override List<String> get warnings {
  if (_warnings is EqualUnmodifiableListView) return _warnings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_warnings);
}


/// Create a copy of ModelConvertBytesResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModelConvertBytesResultCopyWith<_ModelConvertBytesResult> get copyWith => __$ModelConvertBytesResultCopyWithImpl<_ModelConvertBytesResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModelConvertBytesResult&&(identical(other.success, success) || other.success == success)&&const DeepCollectionEquality().equals(other.glbBytes, glbBytes)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other._warnings, _warnings));
}


@override
int get hashCode => Object.hash(runtimeType,success,const DeepCollectionEquality().hash(glbBytes),errorCode,errorMessage,const DeepCollectionEquality().hash(_warnings));

@override
String toString() {
  return 'ModelConvertBytesResult(success: $success, glbBytes: $glbBytes, errorCode: $errorCode, errorMessage: $errorMessage, warnings: $warnings)';
}


}

/// @nodoc
abstract mixin class _$ModelConvertBytesResultCopyWith<$Res> implements $ModelConvertBytesResultCopyWith<$Res> {
  factory _$ModelConvertBytesResultCopyWith(_ModelConvertBytesResult value, $Res Function(_ModelConvertBytesResult) _then) = __$ModelConvertBytesResultCopyWithImpl;
@override @useResult
$Res call({
 bool success, Uint8List? glbBytes, String? errorCode, String? errorMessage, List<String> warnings
});




}
/// @nodoc
class __$ModelConvertBytesResultCopyWithImpl<$Res>
    implements _$ModelConvertBytesResultCopyWith<$Res> {
  __$ModelConvertBytesResultCopyWithImpl(this._self, this._then);

  final _ModelConvertBytesResult _self;
  final $Res Function(_ModelConvertBytesResult) _then;

/// Create a copy of ModelConvertBytesResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? glbBytes = freezed,Object? errorCode = freezed,Object? errorMessage = freezed,Object? warnings = null,}) {
  return _then(_ModelConvertBytesResult(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,glbBytes: freezed == glbBytes ? _self.glbBytes : glbBytes // ignore: cast_nullable_to_non_nullable
as Uint8List?,errorCode: freezed == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,warnings: null == warnings ? _self._warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
mixin _$ModelConvertOptions {

 bool get embedTextures; bool get overwrite; int? get maxTextureSize;
/// Create a copy of ModelConvertOptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModelConvertOptionsCopyWith<ModelConvertOptions> get copyWith => _$ModelConvertOptionsCopyWithImpl<ModelConvertOptions>(this as ModelConvertOptions, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModelConvertOptions&&(identical(other.embedTextures, embedTextures) || other.embedTextures == embedTextures)&&(identical(other.overwrite, overwrite) || other.overwrite == overwrite)&&(identical(other.maxTextureSize, maxTextureSize) || other.maxTextureSize == maxTextureSize));
}


@override
int get hashCode => Object.hash(runtimeType,embedTextures,overwrite,maxTextureSize);

@override
String toString() {
  return 'ModelConvertOptions(embedTextures: $embedTextures, overwrite: $overwrite, maxTextureSize: $maxTextureSize)';
}


}

/// @nodoc
abstract mixin class $ModelConvertOptionsCopyWith<$Res>  {
  factory $ModelConvertOptionsCopyWith(ModelConvertOptions value, $Res Function(ModelConvertOptions) _then) = _$ModelConvertOptionsCopyWithImpl;
@useResult
$Res call({
 bool embedTextures, bool overwrite, int? maxTextureSize
});




}
/// @nodoc
class _$ModelConvertOptionsCopyWithImpl<$Res>
    implements $ModelConvertOptionsCopyWith<$Res> {
  _$ModelConvertOptionsCopyWithImpl(this._self, this._then);

  final ModelConvertOptions _self;
  final $Res Function(ModelConvertOptions) _then;

/// Create a copy of ModelConvertOptions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? embedTextures = null,Object? overwrite = null,Object? maxTextureSize = freezed,}) {
  return _then(_self.copyWith(
embedTextures: null == embedTextures ? _self.embedTextures : embedTextures // ignore: cast_nullable_to_non_nullable
as bool,overwrite: null == overwrite ? _self.overwrite : overwrite // ignore: cast_nullable_to_non_nullable
as bool,maxTextureSize: freezed == maxTextureSize ? _self.maxTextureSize : maxTextureSize // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ModelConvertOptions].
extension ModelConvertOptionsPatterns on ModelConvertOptions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModelConvertOptions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModelConvertOptions() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModelConvertOptions value)  $default,){
final _that = this;
switch (_that) {
case _ModelConvertOptions():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModelConvertOptions value)?  $default,){
final _that = this;
switch (_that) {
case _ModelConvertOptions() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool embedTextures,  bool overwrite,  int? maxTextureSize)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModelConvertOptions() when $default != null:
return $default(_that.embedTextures,_that.overwrite,_that.maxTextureSize);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool embedTextures,  bool overwrite,  int? maxTextureSize)  $default,) {final _that = this;
switch (_that) {
case _ModelConvertOptions():
return $default(_that.embedTextures,_that.overwrite,_that.maxTextureSize);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool embedTextures,  bool overwrite,  int? maxTextureSize)?  $default,) {final _that = this;
switch (_that) {
case _ModelConvertOptions() when $default != null:
return $default(_that.embedTextures,_that.overwrite,_that.maxTextureSize);case _:
  return null;

}
}

}

/// @nodoc


class _ModelConvertOptions implements ModelConvertOptions {
  const _ModelConvertOptions({required this.embedTextures, required this.overwrite, this.maxTextureSize});
  

@override final  bool embedTextures;
@override final  bool overwrite;
@override final  int? maxTextureSize;

/// Create a copy of ModelConvertOptions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModelConvertOptionsCopyWith<_ModelConvertOptions> get copyWith => __$ModelConvertOptionsCopyWithImpl<_ModelConvertOptions>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModelConvertOptions&&(identical(other.embedTextures, embedTextures) || other.embedTextures == embedTextures)&&(identical(other.overwrite, overwrite) || other.overwrite == overwrite)&&(identical(other.maxTextureSize, maxTextureSize) || other.maxTextureSize == maxTextureSize));
}


@override
int get hashCode => Object.hash(runtimeType,embedTextures,overwrite,maxTextureSize);

@override
String toString() {
  return 'ModelConvertOptions(embedTextures: $embedTextures, overwrite: $overwrite, maxTextureSize: $maxTextureSize)';
}


}

/// @nodoc
abstract mixin class _$ModelConvertOptionsCopyWith<$Res> implements $ModelConvertOptionsCopyWith<$Res> {
  factory _$ModelConvertOptionsCopyWith(_ModelConvertOptions value, $Res Function(_ModelConvertOptions) _then) = __$ModelConvertOptionsCopyWithImpl;
@override @useResult
$Res call({
 bool embedTextures, bool overwrite, int? maxTextureSize
});




}
/// @nodoc
class __$ModelConvertOptionsCopyWithImpl<$Res>
    implements _$ModelConvertOptionsCopyWith<$Res> {
  __$ModelConvertOptionsCopyWithImpl(this._self, this._then);

  final _ModelConvertOptions _self;
  final $Res Function(_ModelConvertOptions) _then;

/// Create a copy of ModelConvertOptions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? embedTextures = null,Object? overwrite = null,Object? maxTextureSize = freezed,}) {
  return _then(_ModelConvertOptions(
embedTextures: null == embedTextures ? _self.embedTextures : embedTextures // ignore: cast_nullable_to_non_nullable
as bool,overwrite: null == overwrite ? _self.overwrite : overwrite // ignore: cast_nullable_to_non_nullable
as bool,maxTextureSize: freezed == maxTextureSize ? _self.maxTextureSize : maxTextureSize // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$ModelConvertResult {

 bool get success; String? get outputPath; String? get errorCode; String? get errorMessage; List<String> get warnings;
/// Create a copy of ModelConvertResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModelConvertResultCopyWith<ModelConvertResult> get copyWith => _$ModelConvertResultCopyWithImpl<ModelConvertResult>(this as ModelConvertResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModelConvertResult&&(identical(other.success, success) || other.success == success)&&(identical(other.outputPath, outputPath) || other.outputPath == outputPath)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other.warnings, warnings));
}


@override
int get hashCode => Object.hash(runtimeType,success,outputPath,errorCode,errorMessage,const DeepCollectionEquality().hash(warnings));

@override
String toString() {
  return 'ModelConvertResult(success: $success, outputPath: $outputPath, errorCode: $errorCode, errorMessage: $errorMessage, warnings: $warnings)';
}


}

/// @nodoc
abstract mixin class $ModelConvertResultCopyWith<$Res>  {
  factory $ModelConvertResultCopyWith(ModelConvertResult value, $Res Function(ModelConvertResult) _then) = _$ModelConvertResultCopyWithImpl;
@useResult
$Res call({
 bool success, String? outputPath, String? errorCode, String? errorMessage, List<String> warnings
});




}
/// @nodoc
class _$ModelConvertResultCopyWithImpl<$Res>
    implements $ModelConvertResultCopyWith<$Res> {
  _$ModelConvertResultCopyWithImpl(this._self, this._then);

  final ModelConvertResult _self;
  final $Res Function(ModelConvertResult) _then;

/// Create a copy of ModelConvertResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? outputPath = freezed,Object? errorCode = freezed,Object? errorMessage = freezed,Object? warnings = null,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,outputPath: freezed == outputPath ? _self.outputPath : outputPath // ignore: cast_nullable_to_non_nullable
as String?,errorCode: freezed == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,warnings: null == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ModelConvertResult].
extension ModelConvertResultPatterns on ModelConvertResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModelConvertResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModelConvertResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModelConvertResult value)  $default,){
final _that = this;
switch (_that) {
case _ModelConvertResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModelConvertResult value)?  $default,){
final _that = this;
switch (_that) {
case _ModelConvertResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  String? outputPath,  String? errorCode,  String? errorMessage,  List<String> warnings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModelConvertResult() when $default != null:
return $default(_that.success,_that.outputPath,_that.errorCode,_that.errorMessage,_that.warnings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  String? outputPath,  String? errorCode,  String? errorMessage,  List<String> warnings)  $default,) {final _that = this;
switch (_that) {
case _ModelConvertResult():
return $default(_that.success,_that.outputPath,_that.errorCode,_that.errorMessage,_that.warnings);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  String? outputPath,  String? errorCode,  String? errorMessage,  List<String> warnings)?  $default,) {final _that = this;
switch (_that) {
case _ModelConvertResult() when $default != null:
return $default(_that.success,_that.outputPath,_that.errorCode,_that.errorMessage,_that.warnings);case _:
  return null;

}
}

}

/// @nodoc


class _ModelConvertResult implements ModelConvertResult {
  const _ModelConvertResult({required this.success, this.outputPath, this.errorCode, this.errorMessage, required final  List<String> warnings}): _warnings = warnings;
  

@override final  bool success;
@override final  String? outputPath;
@override final  String? errorCode;
@override final  String? errorMessage;
 final  List<String> _warnings;
@override List<String> get warnings {
  if (_warnings is EqualUnmodifiableListView) return _warnings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_warnings);
}


/// Create a copy of ModelConvertResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModelConvertResultCopyWith<_ModelConvertResult> get copyWith => __$ModelConvertResultCopyWithImpl<_ModelConvertResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModelConvertResult&&(identical(other.success, success) || other.success == success)&&(identical(other.outputPath, outputPath) || other.outputPath == outputPath)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other._warnings, _warnings));
}


@override
int get hashCode => Object.hash(runtimeType,success,outputPath,errorCode,errorMessage,const DeepCollectionEquality().hash(_warnings));

@override
String toString() {
  return 'ModelConvertResult(success: $success, outputPath: $outputPath, errorCode: $errorCode, errorMessage: $errorMessage, warnings: $warnings)';
}


}

/// @nodoc
abstract mixin class _$ModelConvertResultCopyWith<$Res> implements $ModelConvertResultCopyWith<$Res> {
  factory _$ModelConvertResultCopyWith(_ModelConvertResult value, $Res Function(_ModelConvertResult) _then) = __$ModelConvertResultCopyWithImpl;
@override @useResult
$Res call({
 bool success, String? outputPath, String? errorCode, String? errorMessage, List<String> warnings
});




}
/// @nodoc
class __$ModelConvertResultCopyWithImpl<$Res>
    implements _$ModelConvertResultCopyWith<$Res> {
  __$ModelConvertResultCopyWithImpl(this._self, this._then);

  final _ModelConvertResult _self;
  final $Res Function(_ModelConvertResult) _then;

/// Create a copy of ModelConvertResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? outputPath = freezed,Object? errorCode = freezed,Object? errorMessage = freezed,Object? warnings = null,}) {
  return _then(_ModelConvertResult(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,outputPath: freezed == outputPath ? _self.outputPath : outputPath // ignore: cast_nullable_to_non_nullable
as String?,errorCode: freezed == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,warnings: null == warnings ? _self._warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
mixin _$ModelRenderResult {

 bool get success; int get width; int get height; Uint8List? get rgbaData; String? get errorMessage;
/// Create a copy of ModelRenderResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModelRenderResultCopyWith<ModelRenderResult> get copyWith => _$ModelRenderResultCopyWithImpl<ModelRenderResult>(this as ModelRenderResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModelRenderResult&&(identical(other.success, success) || other.success == success)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&const DeepCollectionEquality().equals(other.rgbaData, rgbaData)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,success,width,height,const DeepCollectionEquality().hash(rgbaData),errorMessage);

@override
String toString() {
  return 'ModelRenderResult(success: $success, width: $width, height: $height, rgbaData: $rgbaData, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $ModelRenderResultCopyWith<$Res>  {
  factory $ModelRenderResultCopyWith(ModelRenderResult value, $Res Function(ModelRenderResult) _then) = _$ModelRenderResultCopyWithImpl;
@useResult
$Res call({
 bool success, int width, int height, Uint8List? rgbaData, String? errorMessage
});




}
/// @nodoc
class _$ModelRenderResultCopyWithImpl<$Res>
    implements $ModelRenderResultCopyWith<$Res> {
  _$ModelRenderResultCopyWithImpl(this._self, this._then);

  final ModelRenderResult _self;
  final $Res Function(ModelRenderResult) _then;

/// Create a copy of ModelRenderResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? width = null,Object? height = null,Object? rgbaData = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,rgbaData: freezed == rgbaData ? _self.rgbaData : rgbaData // ignore: cast_nullable_to_non_nullable
as Uint8List?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ModelRenderResult].
extension ModelRenderResultPatterns on ModelRenderResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModelRenderResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModelRenderResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModelRenderResult value)  $default,){
final _that = this;
switch (_that) {
case _ModelRenderResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModelRenderResult value)?  $default,){
final _that = this;
switch (_that) {
case _ModelRenderResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  int width,  int height,  Uint8List? rgbaData,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModelRenderResult() when $default != null:
return $default(_that.success,_that.width,_that.height,_that.rgbaData,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  int width,  int height,  Uint8List? rgbaData,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _ModelRenderResult():
return $default(_that.success,_that.width,_that.height,_that.rgbaData,_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  int width,  int height,  Uint8List? rgbaData,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _ModelRenderResult() when $default != null:
return $default(_that.success,_that.width,_that.height,_that.rgbaData,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _ModelRenderResult implements ModelRenderResult {
  const _ModelRenderResult({required this.success, required this.width, required this.height, this.rgbaData, this.errorMessage});
  

@override final  bool success;
@override final  int width;
@override final  int height;
@override final  Uint8List? rgbaData;
@override final  String? errorMessage;

/// Create a copy of ModelRenderResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModelRenderResultCopyWith<_ModelRenderResult> get copyWith => __$ModelRenderResultCopyWithImpl<_ModelRenderResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModelRenderResult&&(identical(other.success, success) || other.success == success)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&const DeepCollectionEquality().equals(other.rgbaData, rgbaData)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,success,width,height,const DeepCollectionEquality().hash(rgbaData),errorMessage);

@override
String toString() {
  return 'ModelRenderResult(success: $success, width: $width, height: $height, rgbaData: $rgbaData, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$ModelRenderResultCopyWith<$Res> implements $ModelRenderResultCopyWith<$Res> {
  factory _$ModelRenderResultCopyWith(_ModelRenderResult value, $Res Function(_ModelRenderResult) _then) = __$ModelRenderResultCopyWithImpl;
@override @useResult
$Res call({
 bool success, int width, int height, Uint8List? rgbaData, String? errorMessage
});




}
/// @nodoc
class __$ModelRenderResultCopyWithImpl<$Res>
    implements _$ModelRenderResultCopyWith<$Res> {
  __$ModelRenderResultCopyWithImpl(this._self, this._then);

  final _ModelRenderResult _self;
  final $Res Function(_ModelRenderResult) _then;

/// Create a copy of ModelRenderResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? width = null,Object? height = null,Object? rgbaData = freezed,Object? errorMessage = freezed,}) {
  return _then(_ModelRenderResult(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,rgbaData: freezed == rgbaData ? _self.rgbaData : rgbaData // ignore: cast_nullable_to_non_nullable
as Uint8List?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$SessionCreateResult {

 bool get success; String? get sessionId; double get modelRadius; String? get errorMessage;
/// Create a copy of SessionCreateResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionCreateResultCopyWith<SessionCreateResult> get copyWith => _$SessionCreateResultCopyWithImpl<SessionCreateResult>(this as SessionCreateResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionCreateResult&&(identical(other.success, success) || other.success == success)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.modelRadius, modelRadius) || other.modelRadius == modelRadius)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,success,sessionId,modelRadius,errorMessage);

@override
String toString() {
  return 'SessionCreateResult(success: $success, sessionId: $sessionId, modelRadius: $modelRadius, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $SessionCreateResultCopyWith<$Res>  {
  factory $SessionCreateResultCopyWith(SessionCreateResult value, $Res Function(SessionCreateResult) _then) = _$SessionCreateResultCopyWithImpl;
@useResult
$Res call({
 bool success, String? sessionId, double modelRadius, String? errorMessage
});




}
/// @nodoc
class _$SessionCreateResultCopyWithImpl<$Res>
    implements $SessionCreateResultCopyWith<$Res> {
  _$SessionCreateResultCopyWithImpl(this._self, this._then);

  final SessionCreateResult _self;
  final $Res Function(SessionCreateResult) _then;

/// Create a copy of SessionCreateResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? sessionId = freezed,Object? modelRadius = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,modelRadius: null == modelRadius ? _self.modelRadius : modelRadius // ignore: cast_nullable_to_non_nullable
as double,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionCreateResult].
extension SessionCreateResultPatterns on SessionCreateResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionCreateResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionCreateResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionCreateResult value)  $default,){
final _that = this;
switch (_that) {
case _SessionCreateResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionCreateResult value)?  $default,){
final _that = this;
switch (_that) {
case _SessionCreateResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  String? sessionId,  double modelRadius,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionCreateResult() when $default != null:
return $default(_that.success,_that.sessionId,_that.modelRadius,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  String? sessionId,  double modelRadius,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _SessionCreateResult():
return $default(_that.success,_that.sessionId,_that.modelRadius,_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  String? sessionId,  double modelRadius,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _SessionCreateResult() when $default != null:
return $default(_that.success,_that.sessionId,_that.modelRadius,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _SessionCreateResult implements SessionCreateResult {
  const _SessionCreateResult({required this.success, this.sessionId, required this.modelRadius, this.errorMessage});
  

@override final  bool success;
@override final  String? sessionId;
@override final  double modelRadius;
@override final  String? errorMessage;

/// Create a copy of SessionCreateResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionCreateResultCopyWith<_SessionCreateResult> get copyWith => __$SessionCreateResultCopyWithImpl<_SessionCreateResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionCreateResult&&(identical(other.success, success) || other.success == success)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.modelRadius, modelRadius) || other.modelRadius == modelRadius)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,success,sessionId,modelRadius,errorMessage);

@override
String toString() {
  return 'SessionCreateResult(success: $success, sessionId: $sessionId, modelRadius: $modelRadius, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$SessionCreateResultCopyWith<$Res> implements $SessionCreateResultCopyWith<$Res> {
  factory _$SessionCreateResultCopyWith(_SessionCreateResult value, $Res Function(_SessionCreateResult) _then) = __$SessionCreateResultCopyWithImpl;
@override @useResult
$Res call({
 bool success, String? sessionId, double modelRadius, String? errorMessage
});




}
/// @nodoc
class __$SessionCreateResultCopyWithImpl<$Res>
    implements _$SessionCreateResultCopyWith<$Res> {
  __$SessionCreateResultCopyWithImpl(this._self, this._then);

  final _SessionCreateResult _self;
  final $Res Function(_SessionCreateResult) _then;

/// Create a copy of SessionCreateResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? sessionId = freezed,Object? modelRadius = null,Object? errorMessage = freezed,}) {
  return _then(_SessionCreateResult(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,modelRadius: null == modelRadius ? _self.modelRadius : modelRadius // ignore: cast_nullable_to_non_nullable
as double,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$SessionStartResult {

 bool get success; String? get sessionId; String? get errorMessage;
/// Create a copy of SessionStartResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionStartResultCopyWith<SessionStartResult> get copyWith => _$SessionStartResultCopyWithImpl<SessionStartResult>(this as SessionStartResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionStartResult&&(identical(other.success, success) || other.success == success)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,success,sessionId,errorMessage);

@override
String toString() {
  return 'SessionStartResult(success: $success, sessionId: $sessionId, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $SessionStartResultCopyWith<$Res>  {
  factory $SessionStartResultCopyWith(SessionStartResult value, $Res Function(SessionStartResult) _then) = _$SessionStartResultCopyWithImpl;
@useResult
$Res call({
 bool success, String? sessionId, String? errorMessage
});




}
/// @nodoc
class _$SessionStartResultCopyWithImpl<$Res>
    implements $SessionStartResultCopyWith<$Res> {
  _$SessionStartResultCopyWithImpl(this._self, this._then);

  final SessionStartResult _self;
  final $Res Function(SessionStartResult) _then;

/// Create a copy of SessionStartResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? sessionId = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionStartResult].
extension SessionStartResultPatterns on SessionStartResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionStartResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionStartResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionStartResult value)  $default,){
final _that = this;
switch (_that) {
case _SessionStartResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionStartResult value)?  $default,){
final _that = this;
switch (_that) {
case _SessionStartResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  String? sessionId,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionStartResult() when $default != null:
return $default(_that.success,_that.sessionId,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  String? sessionId,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _SessionStartResult():
return $default(_that.success,_that.sessionId,_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  String? sessionId,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _SessionStartResult() when $default != null:
return $default(_that.success,_that.sessionId,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _SessionStartResult implements SessionStartResult {
  const _SessionStartResult({required this.success, this.sessionId, this.errorMessage});
  

@override final  bool success;
@override final  String? sessionId;
@override final  String? errorMessage;

/// Create a copy of SessionStartResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionStartResultCopyWith<_SessionStartResult> get copyWith => __$SessionStartResultCopyWithImpl<_SessionStartResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionStartResult&&(identical(other.success, success) || other.success == success)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,success,sessionId,errorMessage);

@override
String toString() {
  return 'SessionStartResult(success: $success, sessionId: $sessionId, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$SessionStartResultCopyWith<$Res> implements $SessionStartResultCopyWith<$Res> {
  factory _$SessionStartResultCopyWith(_SessionStartResult value, $Res Function(_SessionStartResult) _then) = __$SessionStartResultCopyWithImpl;
@override @useResult
$Res call({
 bool success, String? sessionId, String? errorMessage
});




}
/// @nodoc
class __$SessionStartResultCopyWithImpl<$Res>
    implements _$SessionStartResultCopyWith<$Res> {
  __$SessionStartResultCopyWithImpl(this._self, this._then);

  final _SessionStartResult _self;
  final $Res Function(_SessionStartResult) _then;

/// Create a copy of SessionStartResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? sessionId = freezed,Object? errorMessage = freezed,}) {
  return _then(_SessionStartResult(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$SessionStatusResult {

 bool get exists; bool get ready; bool get failed; String get stage; double get modelRadius; String? get errorMessage;
/// Create a copy of SessionStatusResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionStatusResultCopyWith<SessionStatusResult> get copyWith => _$SessionStatusResultCopyWithImpl<SessionStatusResult>(this as SessionStatusResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionStatusResult&&(identical(other.exists, exists) || other.exists == exists)&&(identical(other.ready, ready) || other.ready == ready)&&(identical(other.failed, failed) || other.failed == failed)&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.modelRadius, modelRadius) || other.modelRadius == modelRadius)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,exists,ready,failed,stage,modelRadius,errorMessage);

@override
String toString() {
  return 'SessionStatusResult(exists: $exists, ready: $ready, failed: $failed, stage: $stage, modelRadius: $modelRadius, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $SessionStatusResultCopyWith<$Res>  {
  factory $SessionStatusResultCopyWith(SessionStatusResult value, $Res Function(SessionStatusResult) _then) = _$SessionStatusResultCopyWithImpl;
@useResult
$Res call({
 bool exists, bool ready, bool failed, String stage, double modelRadius, String? errorMessage
});




}
/// @nodoc
class _$SessionStatusResultCopyWithImpl<$Res>
    implements $SessionStatusResultCopyWith<$Res> {
  _$SessionStatusResultCopyWithImpl(this._self, this._then);

  final SessionStatusResult _self;
  final $Res Function(SessionStatusResult) _then;

/// Create a copy of SessionStatusResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? exists = null,Object? ready = null,Object? failed = null,Object? stage = null,Object? modelRadius = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
exists: null == exists ? _self.exists : exists // ignore: cast_nullable_to_non_nullable
as bool,ready: null == ready ? _self.ready : ready // ignore: cast_nullable_to_non_nullable
as bool,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as bool,stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as String,modelRadius: null == modelRadius ? _self.modelRadius : modelRadius // ignore: cast_nullable_to_non_nullable
as double,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionStatusResult].
extension SessionStatusResultPatterns on SessionStatusResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionStatusResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionStatusResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionStatusResult value)  $default,){
final _that = this;
switch (_that) {
case _SessionStatusResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionStatusResult value)?  $default,){
final _that = this;
switch (_that) {
case _SessionStatusResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool exists,  bool ready,  bool failed,  String stage,  double modelRadius,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionStatusResult() when $default != null:
return $default(_that.exists,_that.ready,_that.failed,_that.stage,_that.modelRadius,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool exists,  bool ready,  bool failed,  String stage,  double modelRadius,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _SessionStatusResult():
return $default(_that.exists,_that.ready,_that.failed,_that.stage,_that.modelRadius,_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool exists,  bool ready,  bool failed,  String stage,  double modelRadius,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _SessionStatusResult() when $default != null:
return $default(_that.exists,_that.ready,_that.failed,_that.stage,_that.modelRadius,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _SessionStatusResult implements SessionStatusResult {
  const _SessionStatusResult({required this.exists, required this.ready, required this.failed, required this.stage, required this.modelRadius, this.errorMessage});
  

@override final  bool exists;
@override final  bool ready;
@override final  bool failed;
@override final  String stage;
@override final  double modelRadius;
@override final  String? errorMessage;

/// Create a copy of SessionStatusResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionStatusResultCopyWith<_SessionStatusResult> get copyWith => __$SessionStatusResultCopyWithImpl<_SessionStatusResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionStatusResult&&(identical(other.exists, exists) || other.exists == exists)&&(identical(other.ready, ready) || other.ready == ready)&&(identical(other.failed, failed) || other.failed == failed)&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.modelRadius, modelRadius) || other.modelRadius == modelRadius)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,exists,ready,failed,stage,modelRadius,errorMessage);

@override
String toString() {
  return 'SessionStatusResult(exists: $exists, ready: $ready, failed: $failed, stage: $stage, modelRadius: $modelRadius, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$SessionStatusResultCopyWith<$Res> implements $SessionStatusResultCopyWith<$Res> {
  factory _$SessionStatusResultCopyWith(_SessionStatusResult value, $Res Function(_SessionStatusResult) _then) = __$SessionStatusResultCopyWithImpl;
@override @useResult
$Res call({
 bool exists, bool ready, bool failed, String stage, double modelRadius, String? errorMessage
});




}
/// @nodoc
class __$SessionStatusResultCopyWithImpl<$Res>
    implements _$SessionStatusResultCopyWith<$Res> {
  __$SessionStatusResultCopyWithImpl(this._self, this._then);

  final _SessionStatusResult _self;
  final $Res Function(_SessionStatusResult) _then;

/// Create a copy of SessionStatusResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? exists = null,Object? ready = null,Object? failed = null,Object? stage = null,Object? modelRadius = null,Object? errorMessage = freezed,}) {
  return _then(_SessionStatusResult(
exists: null == exists ? _self.exists : exists // ignore: cast_nullable_to_non_nullable
as bool,ready: null == ready ? _self.ready : ready // ignore: cast_nullable_to_non_nullable
as bool,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as bool,stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as String,modelRadius: null == modelRadius ? _self.modelRadius : modelRadius // ignore: cast_nullable_to_non_nullable
as double,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
