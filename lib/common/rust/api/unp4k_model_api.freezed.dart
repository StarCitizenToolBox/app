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

// dart format on
