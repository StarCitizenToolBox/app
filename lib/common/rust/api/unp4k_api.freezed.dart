// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unp4k_api.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DcbRecordItem {

 String get path; BigInt get index;
/// Create a copy of DcbRecordItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DcbRecordItemCopyWith<DcbRecordItem> get copyWith => _$DcbRecordItemCopyWithImpl<DcbRecordItem>(this as DcbRecordItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DcbRecordItem&&(identical(other.path, path) || other.path == path)&&(identical(other.index, index) || other.index == index));
}


@override
int get hashCode => Object.hash(runtimeType,path,index);

@override
String toString() {
  return 'DcbRecordItem(path: $path, index: $index)';
}


}

/// @nodoc
abstract mixin class $DcbRecordItemCopyWith<$Res>  {
  factory $DcbRecordItemCopyWith(DcbRecordItem value, $Res Function(DcbRecordItem) _then) = _$DcbRecordItemCopyWithImpl;
@useResult
$Res call({
 String path, BigInt index
});




}
/// @nodoc
class _$DcbRecordItemCopyWithImpl<$Res>
    implements $DcbRecordItemCopyWith<$Res> {
  _$DcbRecordItemCopyWithImpl(this._self, this._then);

  final DcbRecordItem _self;
  final $Res Function(DcbRecordItem) _then;

/// Create a copy of DcbRecordItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? index = null,}) {
  return _then(_self.copyWith(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as BigInt,
  ));
}

}


/// Adds pattern-matching-related methods to [DcbRecordItem].
extension DcbRecordItemPatterns on DcbRecordItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DcbRecordItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DcbRecordItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DcbRecordItem value)  $default,){
final _that = this;
switch (_that) {
case _DcbRecordItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DcbRecordItem value)?  $default,){
final _that = this;
switch (_that) {
case _DcbRecordItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String path,  BigInt index)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DcbRecordItem() when $default != null:
return $default(_that.path,_that.index);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String path,  BigInt index)  $default,) {final _that = this;
switch (_that) {
case _DcbRecordItem():
return $default(_that.path,_that.index);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String path,  BigInt index)?  $default,) {final _that = this;
switch (_that) {
case _DcbRecordItem() when $default != null:
return $default(_that.path,_that.index);case _:
  return null;

}
}

}

/// @nodoc


class _DcbRecordItem implements DcbRecordItem {
  const _DcbRecordItem({required this.path, required this.index});
  

@override final  String path;
@override final  BigInt index;

/// Create a copy of DcbRecordItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DcbRecordItemCopyWith<_DcbRecordItem> get copyWith => __$DcbRecordItemCopyWithImpl<_DcbRecordItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DcbRecordItem&&(identical(other.path, path) || other.path == path)&&(identical(other.index, index) || other.index == index));
}


@override
int get hashCode => Object.hash(runtimeType,path,index);

@override
String toString() {
  return 'DcbRecordItem(path: $path, index: $index)';
}


}

/// @nodoc
abstract mixin class _$DcbRecordItemCopyWith<$Res> implements $DcbRecordItemCopyWith<$Res> {
  factory _$DcbRecordItemCopyWith(_DcbRecordItem value, $Res Function(_DcbRecordItem) _then) = __$DcbRecordItemCopyWithImpl;
@override @useResult
$Res call({
 String path, BigInt index
});




}
/// @nodoc
class __$DcbRecordItemCopyWithImpl<$Res>
    implements _$DcbRecordItemCopyWith<$Res> {
  __$DcbRecordItemCopyWithImpl(this._self, this._then);

  final _DcbRecordItem _self;
  final $Res Function(_DcbRecordItem) _then;

/// Create a copy of DcbRecordItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? index = null,}) {
  return _then(_DcbRecordItem(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as BigInt,
  ));
}


}

/// @nodoc
mixin _$DcbSearchMatch {

 BigInt get lineNumber; String get lineContent;
/// Create a copy of DcbSearchMatch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DcbSearchMatchCopyWith<DcbSearchMatch> get copyWith => _$DcbSearchMatchCopyWithImpl<DcbSearchMatch>(this as DcbSearchMatch, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DcbSearchMatch&&(identical(other.lineNumber, lineNumber) || other.lineNumber == lineNumber)&&(identical(other.lineContent, lineContent) || other.lineContent == lineContent));
}


@override
int get hashCode => Object.hash(runtimeType,lineNumber,lineContent);

@override
String toString() {
  return 'DcbSearchMatch(lineNumber: $lineNumber, lineContent: $lineContent)';
}


}

/// @nodoc
abstract mixin class $DcbSearchMatchCopyWith<$Res>  {
  factory $DcbSearchMatchCopyWith(DcbSearchMatch value, $Res Function(DcbSearchMatch) _then) = _$DcbSearchMatchCopyWithImpl;
@useResult
$Res call({
 BigInt lineNumber, String lineContent
});




}
/// @nodoc
class _$DcbSearchMatchCopyWithImpl<$Res>
    implements $DcbSearchMatchCopyWith<$Res> {
  _$DcbSearchMatchCopyWithImpl(this._self, this._then);

  final DcbSearchMatch _self;
  final $Res Function(DcbSearchMatch) _then;

/// Create a copy of DcbSearchMatch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lineNumber = null,Object? lineContent = null,}) {
  return _then(_self.copyWith(
lineNumber: null == lineNumber ? _self.lineNumber : lineNumber // ignore: cast_nullable_to_non_nullable
as BigInt,lineContent: null == lineContent ? _self.lineContent : lineContent // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DcbSearchMatch].
extension DcbSearchMatchPatterns on DcbSearchMatch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DcbSearchMatch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DcbSearchMatch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DcbSearchMatch value)  $default,){
final _that = this;
switch (_that) {
case _DcbSearchMatch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DcbSearchMatch value)?  $default,){
final _that = this;
switch (_that) {
case _DcbSearchMatch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BigInt lineNumber,  String lineContent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DcbSearchMatch() when $default != null:
return $default(_that.lineNumber,_that.lineContent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BigInt lineNumber,  String lineContent)  $default,) {final _that = this;
switch (_that) {
case _DcbSearchMatch():
return $default(_that.lineNumber,_that.lineContent);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BigInt lineNumber,  String lineContent)?  $default,) {final _that = this;
switch (_that) {
case _DcbSearchMatch() when $default != null:
return $default(_that.lineNumber,_that.lineContent);case _:
  return null;

}
}

}

/// @nodoc


class _DcbSearchMatch implements DcbSearchMatch {
  const _DcbSearchMatch({required this.lineNumber, required this.lineContent});
  

@override final  BigInt lineNumber;
@override final  String lineContent;

/// Create a copy of DcbSearchMatch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DcbSearchMatchCopyWith<_DcbSearchMatch> get copyWith => __$DcbSearchMatchCopyWithImpl<_DcbSearchMatch>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DcbSearchMatch&&(identical(other.lineNumber, lineNumber) || other.lineNumber == lineNumber)&&(identical(other.lineContent, lineContent) || other.lineContent == lineContent));
}


@override
int get hashCode => Object.hash(runtimeType,lineNumber,lineContent);

@override
String toString() {
  return 'DcbSearchMatch(lineNumber: $lineNumber, lineContent: $lineContent)';
}


}

/// @nodoc
abstract mixin class _$DcbSearchMatchCopyWith<$Res> implements $DcbSearchMatchCopyWith<$Res> {
  factory _$DcbSearchMatchCopyWith(_DcbSearchMatch value, $Res Function(_DcbSearchMatch) _then) = __$DcbSearchMatchCopyWithImpl;
@override @useResult
$Res call({
 BigInt lineNumber, String lineContent
});




}
/// @nodoc
class __$DcbSearchMatchCopyWithImpl<$Res>
    implements _$DcbSearchMatchCopyWith<$Res> {
  __$DcbSearchMatchCopyWithImpl(this._self, this._then);

  final _DcbSearchMatch _self;
  final $Res Function(_DcbSearchMatch) _then;

/// Create a copy of DcbSearchMatch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lineNumber = null,Object? lineContent = null,}) {
  return _then(_DcbSearchMatch(
lineNumber: null == lineNumber ? _self.lineNumber : lineNumber // ignore: cast_nullable_to_non_nullable
as BigInt,lineContent: null == lineContent ? _self.lineContent : lineContent // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$DcbSearchResult {

 String get path; BigInt get index; List<DcbSearchMatch> get matches;
/// Create a copy of DcbSearchResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DcbSearchResultCopyWith<DcbSearchResult> get copyWith => _$DcbSearchResultCopyWithImpl<DcbSearchResult>(this as DcbSearchResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DcbSearchResult&&(identical(other.path, path) || other.path == path)&&(identical(other.index, index) || other.index == index)&&const DeepCollectionEquality().equals(other.matches, matches));
}


@override
int get hashCode => Object.hash(runtimeType,path,index,const DeepCollectionEquality().hash(matches));

@override
String toString() {
  return 'DcbSearchResult(path: $path, index: $index, matches: $matches)';
}


}

/// @nodoc
abstract mixin class $DcbSearchResultCopyWith<$Res>  {
  factory $DcbSearchResultCopyWith(DcbSearchResult value, $Res Function(DcbSearchResult) _then) = _$DcbSearchResultCopyWithImpl;
@useResult
$Res call({
 String path, BigInt index, List<DcbSearchMatch> matches
});




}
/// @nodoc
class _$DcbSearchResultCopyWithImpl<$Res>
    implements $DcbSearchResultCopyWith<$Res> {
  _$DcbSearchResultCopyWithImpl(this._self, this._then);

  final DcbSearchResult _self;
  final $Res Function(DcbSearchResult) _then;

/// Create a copy of DcbSearchResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? index = null,Object? matches = null,}) {
  return _then(_self.copyWith(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as BigInt,matches: null == matches ? _self.matches : matches // ignore: cast_nullable_to_non_nullable
as List<DcbSearchMatch>,
  ));
}

}


/// Adds pattern-matching-related methods to [DcbSearchResult].
extension DcbSearchResultPatterns on DcbSearchResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DcbSearchResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DcbSearchResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DcbSearchResult value)  $default,){
final _that = this;
switch (_that) {
case _DcbSearchResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DcbSearchResult value)?  $default,){
final _that = this;
switch (_that) {
case _DcbSearchResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String path,  BigInt index,  List<DcbSearchMatch> matches)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DcbSearchResult() when $default != null:
return $default(_that.path,_that.index,_that.matches);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String path,  BigInt index,  List<DcbSearchMatch> matches)  $default,) {final _that = this;
switch (_that) {
case _DcbSearchResult():
return $default(_that.path,_that.index,_that.matches);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String path,  BigInt index,  List<DcbSearchMatch> matches)?  $default,) {final _that = this;
switch (_that) {
case _DcbSearchResult() when $default != null:
return $default(_that.path,_that.index,_that.matches);case _:
  return null;

}
}

}

/// @nodoc


class _DcbSearchResult implements DcbSearchResult {
  const _DcbSearchResult({required this.path, required this.index, required final  List<DcbSearchMatch> matches}): _matches = matches;
  

@override final  String path;
@override final  BigInt index;
 final  List<DcbSearchMatch> _matches;
@override List<DcbSearchMatch> get matches {
  if (_matches is EqualUnmodifiableListView) return _matches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_matches);
}


/// Create a copy of DcbSearchResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DcbSearchResultCopyWith<_DcbSearchResult> get copyWith => __$DcbSearchResultCopyWithImpl<_DcbSearchResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DcbSearchResult&&(identical(other.path, path) || other.path == path)&&(identical(other.index, index) || other.index == index)&&const DeepCollectionEquality().equals(other._matches, _matches));
}


@override
int get hashCode => Object.hash(runtimeType,path,index,const DeepCollectionEquality().hash(_matches));

@override
String toString() {
  return 'DcbSearchResult(path: $path, index: $index, matches: $matches)';
}


}

/// @nodoc
abstract mixin class _$DcbSearchResultCopyWith<$Res> implements $DcbSearchResultCopyWith<$Res> {
  factory _$DcbSearchResultCopyWith(_DcbSearchResult value, $Res Function(_DcbSearchResult) _then) = __$DcbSearchResultCopyWithImpl;
@override @useResult
$Res call({
 String path, BigInt index, List<DcbSearchMatch> matches
});




}
/// @nodoc
class __$DcbSearchResultCopyWithImpl<$Res>
    implements _$DcbSearchResultCopyWith<$Res> {
  __$DcbSearchResultCopyWithImpl(this._self, this._then);

  final _DcbSearchResult _self;
  final $Res Function(_DcbSearchResult) _then;

/// Create a copy of DcbSearchResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? index = null,Object? matches = null,}) {
  return _then(_DcbSearchResult(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as BigInt,matches: null == matches ? _self._matches : matches // ignore: cast_nullable_to_non_nullable
as List<DcbSearchMatch>,
  ));
}


}

/// @nodoc
mixin _$DdsDebugInfo {

 String get requestedPath; String get basePath; String get baseKey; String? get baseReal; BigInt get partCount; List<DdsPartInfo> get parts;
/// Create a copy of DdsDebugInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DdsDebugInfoCopyWith<DdsDebugInfo> get copyWith => _$DdsDebugInfoCopyWithImpl<DdsDebugInfo>(this as DdsDebugInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DdsDebugInfo&&(identical(other.requestedPath, requestedPath) || other.requestedPath == requestedPath)&&(identical(other.basePath, basePath) || other.basePath == basePath)&&(identical(other.baseKey, baseKey) || other.baseKey == baseKey)&&(identical(other.baseReal, baseReal) || other.baseReal == baseReal)&&(identical(other.partCount, partCount) || other.partCount == partCount)&&const DeepCollectionEquality().equals(other.parts, parts));
}


@override
int get hashCode => Object.hash(runtimeType,requestedPath,basePath,baseKey,baseReal,partCount,const DeepCollectionEquality().hash(parts));

@override
String toString() {
  return 'DdsDebugInfo(requestedPath: $requestedPath, basePath: $basePath, baseKey: $baseKey, baseReal: $baseReal, partCount: $partCount, parts: $parts)';
}


}

/// @nodoc
abstract mixin class $DdsDebugInfoCopyWith<$Res>  {
  factory $DdsDebugInfoCopyWith(DdsDebugInfo value, $Res Function(DdsDebugInfo) _then) = _$DdsDebugInfoCopyWithImpl;
@useResult
$Res call({
 String requestedPath, String basePath, String baseKey, String? baseReal, BigInt partCount, List<DdsPartInfo> parts
});




}
/// @nodoc
class _$DdsDebugInfoCopyWithImpl<$Res>
    implements $DdsDebugInfoCopyWith<$Res> {
  _$DdsDebugInfoCopyWithImpl(this._self, this._then);

  final DdsDebugInfo _self;
  final $Res Function(DdsDebugInfo) _then;

/// Create a copy of DdsDebugInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requestedPath = null,Object? basePath = null,Object? baseKey = null,Object? baseReal = freezed,Object? partCount = null,Object? parts = null,}) {
  return _then(_self.copyWith(
requestedPath: null == requestedPath ? _self.requestedPath : requestedPath // ignore: cast_nullable_to_non_nullable
as String,basePath: null == basePath ? _self.basePath : basePath // ignore: cast_nullable_to_non_nullable
as String,baseKey: null == baseKey ? _self.baseKey : baseKey // ignore: cast_nullable_to_non_nullable
as String,baseReal: freezed == baseReal ? _self.baseReal : baseReal // ignore: cast_nullable_to_non_nullable
as String?,partCount: null == partCount ? _self.partCount : partCount // ignore: cast_nullable_to_non_nullable
as BigInt,parts: null == parts ? _self.parts : parts // ignore: cast_nullable_to_non_nullable
as List<DdsPartInfo>,
  ));
}

}


/// Adds pattern-matching-related methods to [DdsDebugInfo].
extension DdsDebugInfoPatterns on DdsDebugInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DdsDebugInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DdsDebugInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DdsDebugInfo value)  $default,){
final _that = this;
switch (_that) {
case _DdsDebugInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DdsDebugInfo value)?  $default,){
final _that = this;
switch (_that) {
case _DdsDebugInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String requestedPath,  String basePath,  String baseKey,  String? baseReal,  BigInt partCount,  List<DdsPartInfo> parts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DdsDebugInfo() when $default != null:
return $default(_that.requestedPath,_that.basePath,_that.baseKey,_that.baseReal,_that.partCount,_that.parts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String requestedPath,  String basePath,  String baseKey,  String? baseReal,  BigInt partCount,  List<DdsPartInfo> parts)  $default,) {final _that = this;
switch (_that) {
case _DdsDebugInfo():
return $default(_that.requestedPath,_that.basePath,_that.baseKey,_that.baseReal,_that.partCount,_that.parts);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String requestedPath,  String basePath,  String baseKey,  String? baseReal,  BigInt partCount,  List<DdsPartInfo> parts)?  $default,) {final _that = this;
switch (_that) {
case _DdsDebugInfo() when $default != null:
return $default(_that.requestedPath,_that.basePath,_that.baseKey,_that.baseReal,_that.partCount,_that.parts);case _:
  return null;

}
}

}

/// @nodoc


class _DdsDebugInfo implements DdsDebugInfo {
  const _DdsDebugInfo({required this.requestedPath, required this.basePath, required this.baseKey, this.baseReal, required this.partCount, required final  List<DdsPartInfo> parts}): _parts = parts;
  

@override final  String requestedPath;
@override final  String basePath;
@override final  String baseKey;
@override final  String? baseReal;
@override final  BigInt partCount;
 final  List<DdsPartInfo> _parts;
@override List<DdsPartInfo> get parts {
  if (_parts is EqualUnmodifiableListView) return _parts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_parts);
}


/// Create a copy of DdsDebugInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DdsDebugInfoCopyWith<_DdsDebugInfo> get copyWith => __$DdsDebugInfoCopyWithImpl<_DdsDebugInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DdsDebugInfo&&(identical(other.requestedPath, requestedPath) || other.requestedPath == requestedPath)&&(identical(other.basePath, basePath) || other.basePath == basePath)&&(identical(other.baseKey, baseKey) || other.baseKey == baseKey)&&(identical(other.baseReal, baseReal) || other.baseReal == baseReal)&&(identical(other.partCount, partCount) || other.partCount == partCount)&&const DeepCollectionEquality().equals(other._parts, _parts));
}


@override
int get hashCode => Object.hash(runtimeType,requestedPath,basePath,baseKey,baseReal,partCount,const DeepCollectionEquality().hash(_parts));

@override
String toString() {
  return 'DdsDebugInfo(requestedPath: $requestedPath, basePath: $basePath, baseKey: $baseKey, baseReal: $baseReal, partCount: $partCount, parts: $parts)';
}


}

/// @nodoc
abstract mixin class _$DdsDebugInfoCopyWith<$Res> implements $DdsDebugInfoCopyWith<$Res> {
  factory _$DdsDebugInfoCopyWith(_DdsDebugInfo value, $Res Function(_DdsDebugInfo) _then) = __$DdsDebugInfoCopyWithImpl;
@override @useResult
$Res call({
 String requestedPath, String basePath, String baseKey, String? baseReal, BigInt partCount, List<DdsPartInfo> parts
});




}
/// @nodoc
class __$DdsDebugInfoCopyWithImpl<$Res>
    implements _$DdsDebugInfoCopyWith<$Res> {
  __$DdsDebugInfoCopyWithImpl(this._self, this._then);

  final _DdsDebugInfo _self;
  final $Res Function(_DdsDebugInfo) _then;

/// Create a copy of DdsDebugInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requestedPath = null,Object? basePath = null,Object? baseKey = null,Object? baseReal = freezed,Object? partCount = null,Object? parts = null,}) {
  return _then(_DdsDebugInfo(
requestedPath: null == requestedPath ? _self.requestedPath : requestedPath // ignore: cast_nullable_to_non_nullable
as String,basePath: null == basePath ? _self.basePath : basePath // ignore: cast_nullable_to_non_nullable
as String,baseKey: null == baseKey ? _self.baseKey : baseKey // ignore: cast_nullable_to_non_nullable
as String,baseReal: freezed == baseReal ? _self.baseReal : baseReal // ignore: cast_nullable_to_non_nullable
as String?,partCount: null == partCount ? _self.partCount : partCount // ignore: cast_nullable_to_non_nullable
as BigInt,parts: null == parts ? _self._parts : parts // ignore: cast_nullable_to_non_nullable
as List<DdsPartInfo>,
  ));
}


}

/// @nodoc
mixin _$DdsPartInfo {

 BigInt get index; String get path;
/// Create a copy of DdsPartInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DdsPartInfoCopyWith<DdsPartInfo> get copyWith => _$DdsPartInfoCopyWithImpl<DdsPartInfo>(this as DdsPartInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DdsPartInfo&&(identical(other.index, index) || other.index == index)&&(identical(other.path, path) || other.path == path));
}


@override
int get hashCode => Object.hash(runtimeType,index,path);

@override
String toString() {
  return 'DdsPartInfo(index: $index, path: $path)';
}


}

/// @nodoc
abstract mixin class $DdsPartInfoCopyWith<$Res>  {
  factory $DdsPartInfoCopyWith(DdsPartInfo value, $Res Function(DdsPartInfo) _then) = _$DdsPartInfoCopyWithImpl;
@useResult
$Res call({
 BigInt index, String path
});




}
/// @nodoc
class _$DdsPartInfoCopyWithImpl<$Res>
    implements $DdsPartInfoCopyWith<$Res> {
  _$DdsPartInfoCopyWithImpl(this._self, this._then);

  final DdsPartInfo _self;
  final $Res Function(DdsPartInfo) _then;

/// Create a copy of DdsPartInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? index = null,Object? path = null,}) {
  return _then(_self.copyWith(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as BigInt,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DdsPartInfo].
extension DdsPartInfoPatterns on DdsPartInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DdsPartInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DdsPartInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DdsPartInfo value)  $default,){
final _that = this;
switch (_that) {
case _DdsPartInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DdsPartInfo value)?  $default,){
final _that = this;
switch (_that) {
case _DdsPartInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BigInt index,  String path)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DdsPartInfo() when $default != null:
return $default(_that.index,_that.path);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BigInt index,  String path)  $default,) {final _that = this;
switch (_that) {
case _DdsPartInfo():
return $default(_that.index,_that.path);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BigInt index,  String path)?  $default,) {final _that = this;
switch (_that) {
case _DdsPartInfo() when $default != null:
return $default(_that.index,_that.path);case _:
  return null;

}
}

}

/// @nodoc


class _DdsPartInfo implements DdsPartInfo {
  const _DdsPartInfo({required this.index, required this.path});
  

@override final  BigInt index;
@override final  String path;

/// Create a copy of DdsPartInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DdsPartInfoCopyWith<_DdsPartInfo> get copyWith => __$DdsPartInfoCopyWithImpl<_DdsPartInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DdsPartInfo&&(identical(other.index, index) || other.index == index)&&(identical(other.path, path) || other.path == path));
}


@override
int get hashCode => Object.hash(runtimeType,index,path);

@override
String toString() {
  return 'DdsPartInfo(index: $index, path: $path)';
}


}

/// @nodoc
abstract mixin class _$DdsPartInfoCopyWith<$Res> implements $DdsPartInfoCopyWith<$Res> {
  factory _$DdsPartInfoCopyWith(_DdsPartInfo value, $Res Function(_DdsPartInfo) _then) = __$DdsPartInfoCopyWithImpl;
@override @useResult
$Res call({
 BigInt index, String path
});




}
/// @nodoc
class __$DdsPartInfoCopyWithImpl<$Res>
    implements _$DdsPartInfoCopyWith<$Res> {
  __$DdsPartInfoCopyWithImpl(this._self, this._then);

  final _DdsPartInfo _self;
  final $Res Function(_DdsPartInfo) _then;

/// Create a copy of DdsPartInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? index = null,Object? path = null,}) {
  return _then(_DdsPartInfo(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as BigInt,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$DdsPngDebug {

 String get requestedPath; String get basePath; BigInt get partCount; bool get reconstructed; String get decodeMode; int get width; int get height;
/// Create a copy of DdsPngDebug
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DdsPngDebugCopyWith<DdsPngDebug> get copyWith => _$DdsPngDebugCopyWithImpl<DdsPngDebug>(this as DdsPngDebug, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DdsPngDebug&&(identical(other.requestedPath, requestedPath) || other.requestedPath == requestedPath)&&(identical(other.basePath, basePath) || other.basePath == basePath)&&(identical(other.partCount, partCount) || other.partCount == partCount)&&(identical(other.reconstructed, reconstructed) || other.reconstructed == reconstructed)&&(identical(other.decodeMode, decodeMode) || other.decodeMode == decodeMode)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}


@override
int get hashCode => Object.hash(runtimeType,requestedPath,basePath,partCount,reconstructed,decodeMode,width,height);

@override
String toString() {
  return 'DdsPngDebug(requestedPath: $requestedPath, basePath: $basePath, partCount: $partCount, reconstructed: $reconstructed, decodeMode: $decodeMode, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class $DdsPngDebugCopyWith<$Res>  {
  factory $DdsPngDebugCopyWith(DdsPngDebug value, $Res Function(DdsPngDebug) _then) = _$DdsPngDebugCopyWithImpl;
@useResult
$Res call({
 String requestedPath, String basePath, BigInt partCount, bool reconstructed, String decodeMode, int width, int height
});




}
/// @nodoc
class _$DdsPngDebugCopyWithImpl<$Res>
    implements $DdsPngDebugCopyWith<$Res> {
  _$DdsPngDebugCopyWithImpl(this._self, this._then);

  final DdsPngDebug _self;
  final $Res Function(DdsPngDebug) _then;

/// Create a copy of DdsPngDebug
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requestedPath = null,Object? basePath = null,Object? partCount = null,Object? reconstructed = null,Object? decodeMode = null,Object? width = null,Object? height = null,}) {
  return _then(_self.copyWith(
requestedPath: null == requestedPath ? _self.requestedPath : requestedPath // ignore: cast_nullable_to_non_nullable
as String,basePath: null == basePath ? _self.basePath : basePath // ignore: cast_nullable_to_non_nullable
as String,partCount: null == partCount ? _self.partCount : partCount // ignore: cast_nullable_to_non_nullable
as BigInt,reconstructed: null == reconstructed ? _self.reconstructed : reconstructed // ignore: cast_nullable_to_non_nullable
as bool,decodeMode: null == decodeMode ? _self.decodeMode : decodeMode // ignore: cast_nullable_to_non_nullable
as String,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DdsPngDebug].
extension DdsPngDebugPatterns on DdsPngDebug {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DdsPngDebug value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DdsPngDebug() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DdsPngDebug value)  $default,){
final _that = this;
switch (_that) {
case _DdsPngDebug():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DdsPngDebug value)?  $default,){
final _that = this;
switch (_that) {
case _DdsPngDebug() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String requestedPath,  String basePath,  BigInt partCount,  bool reconstructed,  String decodeMode,  int width,  int height)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DdsPngDebug() when $default != null:
return $default(_that.requestedPath,_that.basePath,_that.partCount,_that.reconstructed,_that.decodeMode,_that.width,_that.height);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String requestedPath,  String basePath,  BigInt partCount,  bool reconstructed,  String decodeMode,  int width,  int height)  $default,) {final _that = this;
switch (_that) {
case _DdsPngDebug():
return $default(_that.requestedPath,_that.basePath,_that.partCount,_that.reconstructed,_that.decodeMode,_that.width,_that.height);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String requestedPath,  String basePath,  BigInt partCount,  bool reconstructed,  String decodeMode,  int width,  int height)?  $default,) {final _that = this;
switch (_that) {
case _DdsPngDebug() when $default != null:
return $default(_that.requestedPath,_that.basePath,_that.partCount,_that.reconstructed,_that.decodeMode,_that.width,_that.height);case _:
  return null;

}
}

}

/// @nodoc


class _DdsPngDebug extends DdsPngDebug {
  const _DdsPngDebug({required this.requestedPath, required this.basePath, required this.partCount, required this.reconstructed, required this.decodeMode, required this.width, required this.height}): super._();
  

@override final  String requestedPath;
@override final  String basePath;
@override final  BigInt partCount;
@override final  bool reconstructed;
@override final  String decodeMode;
@override final  int width;
@override final  int height;

/// Create a copy of DdsPngDebug
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DdsPngDebugCopyWith<_DdsPngDebug> get copyWith => __$DdsPngDebugCopyWithImpl<_DdsPngDebug>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DdsPngDebug&&(identical(other.requestedPath, requestedPath) || other.requestedPath == requestedPath)&&(identical(other.basePath, basePath) || other.basePath == basePath)&&(identical(other.partCount, partCount) || other.partCount == partCount)&&(identical(other.reconstructed, reconstructed) || other.reconstructed == reconstructed)&&(identical(other.decodeMode, decodeMode) || other.decodeMode == decodeMode)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}


@override
int get hashCode => Object.hash(runtimeType,requestedPath,basePath,partCount,reconstructed,decodeMode,width,height);

@override
String toString() {
  return 'DdsPngDebug(requestedPath: $requestedPath, basePath: $basePath, partCount: $partCount, reconstructed: $reconstructed, decodeMode: $decodeMode, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class _$DdsPngDebugCopyWith<$Res> implements $DdsPngDebugCopyWith<$Res> {
  factory _$DdsPngDebugCopyWith(_DdsPngDebug value, $Res Function(_DdsPngDebug) _then) = __$DdsPngDebugCopyWithImpl;
@override @useResult
$Res call({
 String requestedPath, String basePath, BigInt partCount, bool reconstructed, String decodeMode, int width, int height
});




}
/// @nodoc
class __$DdsPngDebugCopyWithImpl<$Res>
    implements _$DdsPngDebugCopyWith<$Res> {
  __$DdsPngDebugCopyWithImpl(this._self, this._then);

  final _DdsPngDebug _self;
  final $Res Function(_DdsPngDebug) _then;

/// Create a copy of DdsPngDebug
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requestedPath = null,Object? basePath = null,Object? partCount = null,Object? reconstructed = null,Object? decodeMode = null,Object? width = null,Object? height = null,}) {
  return _then(_DdsPngDebug(
requestedPath: null == requestedPath ? _self.requestedPath : requestedPath // ignore: cast_nullable_to_non_nullable
as String,basePath: null == basePath ? _self.basePath : basePath // ignore: cast_nullable_to_non_nullable
as String,partCount: null == partCount ? _self.partCount : partCount // ignore: cast_nullable_to_non_nullable
as BigInt,reconstructed: null == reconstructed ? _self.reconstructed : reconstructed // ignore: cast_nullable_to_non_nullable
as bool,decodeMode: null == decodeMode ? _self.decodeMode : decodeMode // ignore: cast_nullable_to_non_nullable
as String,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$P4kFileItem {

 String get name; bool get isDirectory; BigInt get size; BigInt get compressedSize; PlatformInt64 get dateModified;
/// Create a copy of P4kFileItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$P4kFileItemCopyWith<P4kFileItem> get copyWith => _$P4kFileItemCopyWithImpl<P4kFileItem>(this as P4kFileItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is P4kFileItem&&(identical(other.name, name) || other.name == name)&&(identical(other.isDirectory, isDirectory) || other.isDirectory == isDirectory)&&(identical(other.size, size) || other.size == size)&&(identical(other.compressedSize, compressedSize) || other.compressedSize == compressedSize)&&(identical(other.dateModified, dateModified) || other.dateModified == dateModified));
}


@override
int get hashCode => Object.hash(runtimeType,name,isDirectory,size,compressedSize,dateModified);

@override
String toString() {
  return 'P4kFileItem(name: $name, isDirectory: $isDirectory, size: $size, compressedSize: $compressedSize, dateModified: $dateModified)';
}


}

/// @nodoc
abstract mixin class $P4kFileItemCopyWith<$Res>  {
  factory $P4kFileItemCopyWith(P4kFileItem value, $Res Function(P4kFileItem) _then) = _$P4kFileItemCopyWithImpl;
@useResult
$Res call({
 String name, bool isDirectory, BigInt size, BigInt compressedSize, PlatformInt64 dateModified
});




}
/// @nodoc
class _$P4kFileItemCopyWithImpl<$Res>
    implements $P4kFileItemCopyWith<$Res> {
  _$P4kFileItemCopyWithImpl(this._self, this._then);

  final P4kFileItem _self;
  final $Res Function(P4kFileItem) _then;

/// Create a copy of P4kFileItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? isDirectory = null,Object? size = null,Object? compressedSize = null,Object? dateModified = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isDirectory: null == isDirectory ? _self.isDirectory : isDirectory // ignore: cast_nullable_to_non_nullable
as bool,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as BigInt,compressedSize: null == compressedSize ? _self.compressedSize : compressedSize // ignore: cast_nullable_to_non_nullable
as BigInt,dateModified: null == dateModified ? _self.dateModified : dateModified // ignore: cast_nullable_to_non_nullable
as PlatformInt64,
  ));
}

}


/// Adds pattern-matching-related methods to [P4kFileItem].
extension P4kFileItemPatterns on P4kFileItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _P4kFileItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _P4kFileItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _P4kFileItem value)  $default,){
final _that = this;
switch (_that) {
case _P4kFileItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _P4kFileItem value)?  $default,){
final _that = this;
switch (_that) {
case _P4kFileItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  bool isDirectory,  BigInt size,  BigInt compressedSize,  PlatformInt64 dateModified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _P4kFileItem() when $default != null:
return $default(_that.name,_that.isDirectory,_that.size,_that.compressedSize,_that.dateModified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  bool isDirectory,  BigInt size,  BigInt compressedSize,  PlatformInt64 dateModified)  $default,) {final _that = this;
switch (_that) {
case _P4kFileItem():
return $default(_that.name,_that.isDirectory,_that.size,_that.compressedSize,_that.dateModified);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  bool isDirectory,  BigInt size,  BigInt compressedSize,  PlatformInt64 dateModified)?  $default,) {final _that = this;
switch (_that) {
case _P4kFileItem() when $default != null:
return $default(_that.name,_that.isDirectory,_that.size,_that.compressedSize,_that.dateModified);case _:
  return null;

}
}

}

/// @nodoc


class _P4kFileItem implements P4kFileItem {
  const _P4kFileItem({required this.name, required this.isDirectory, required this.size, required this.compressedSize, required this.dateModified});
  

@override final  String name;
@override final  bool isDirectory;
@override final  BigInt size;
@override final  BigInt compressedSize;
@override final  PlatformInt64 dateModified;

/// Create a copy of P4kFileItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$P4kFileItemCopyWith<_P4kFileItem> get copyWith => __$P4kFileItemCopyWithImpl<_P4kFileItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _P4kFileItem&&(identical(other.name, name) || other.name == name)&&(identical(other.isDirectory, isDirectory) || other.isDirectory == isDirectory)&&(identical(other.size, size) || other.size == size)&&(identical(other.compressedSize, compressedSize) || other.compressedSize == compressedSize)&&(identical(other.dateModified, dateModified) || other.dateModified == dateModified));
}


@override
int get hashCode => Object.hash(runtimeType,name,isDirectory,size,compressedSize,dateModified);

@override
String toString() {
  return 'P4kFileItem(name: $name, isDirectory: $isDirectory, size: $size, compressedSize: $compressedSize, dateModified: $dateModified)';
}


}

/// @nodoc
abstract mixin class _$P4kFileItemCopyWith<$Res> implements $P4kFileItemCopyWith<$Res> {
  factory _$P4kFileItemCopyWith(_P4kFileItem value, $Res Function(_P4kFileItem) _then) = __$P4kFileItemCopyWithImpl;
@override @useResult
$Res call({
 String name, bool isDirectory, BigInt size, BigInt compressedSize, PlatformInt64 dateModified
});




}
/// @nodoc
class __$P4kFileItemCopyWithImpl<$Res>
    implements _$P4kFileItemCopyWith<$Res> {
  __$P4kFileItemCopyWithImpl(this._self, this._then);

  final _P4kFileItem _self;
  final $Res Function(_P4kFileItem) _then;

/// Create a copy of P4kFileItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? isDirectory = null,Object? size = null,Object? compressedSize = null,Object? dateModified = null,}) {
  return _then(_P4kFileItem(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isDirectory: null == isDirectory ? _self.isDirectory : isDirectory // ignore: cast_nullable_to_non_nullable
as bool,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as BigInt,compressedSize: null == compressedSize ? _self.compressedSize : compressedSize // ignore: cast_nullable_to_non_nullable
as BigInt,dateModified: null == dateModified ? _self.dateModified : dateModified // ignore: cast_nullable_to_non_nullable
as PlatformInt64,
  ));
}


}

/// @nodoc
mixin _$WemDecodeProgress {

 double get progress; Float64List? get waveform; int? get durationMs; bool get isComplete; String? get error; Int16List? get pcmChunk; int? get sampleRate; int? get channels; int get chunkIndex;
/// Create a copy of WemDecodeProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WemDecodeProgressCopyWith<WemDecodeProgress> get copyWith => _$WemDecodeProgressCopyWithImpl<WemDecodeProgress>(this as WemDecodeProgress, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WemDecodeProgress&&(identical(other.progress, progress) || other.progress == progress)&&const DeepCollectionEquality().equals(other.waveform, waveform)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.isComplete, isComplete) || other.isComplete == isComplete)&&(identical(other.error, error) || other.error == error)&&const DeepCollectionEquality().equals(other.pcmChunk, pcmChunk)&&(identical(other.sampleRate, sampleRate) || other.sampleRate == sampleRate)&&(identical(other.channels, channels) || other.channels == channels)&&(identical(other.chunkIndex, chunkIndex) || other.chunkIndex == chunkIndex));
}


@override
int get hashCode => Object.hash(runtimeType,progress,const DeepCollectionEquality().hash(waveform),durationMs,isComplete,error,const DeepCollectionEquality().hash(pcmChunk),sampleRate,channels,chunkIndex);

@override
String toString() {
  return 'WemDecodeProgress(progress: $progress, waveform: $waveform, durationMs: $durationMs, isComplete: $isComplete, error: $error, pcmChunk: $pcmChunk, sampleRate: $sampleRate, channels: $channels, chunkIndex: $chunkIndex)';
}


}

/// @nodoc
abstract mixin class $WemDecodeProgressCopyWith<$Res>  {
  factory $WemDecodeProgressCopyWith(WemDecodeProgress value, $Res Function(WemDecodeProgress) _then) = _$WemDecodeProgressCopyWithImpl;
@useResult
$Res call({
 double progress, Float64List? waveform, int? durationMs, bool isComplete, String? error, Int16List? pcmChunk, int? sampleRate, int? channels, int chunkIndex
});




}
/// @nodoc
class _$WemDecodeProgressCopyWithImpl<$Res>
    implements $WemDecodeProgressCopyWith<$Res> {
  _$WemDecodeProgressCopyWithImpl(this._self, this._then);

  final WemDecodeProgress _self;
  final $Res Function(WemDecodeProgress) _then;

/// Create a copy of WemDecodeProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? progress = null,Object? waveform = freezed,Object? durationMs = freezed,Object? isComplete = null,Object? error = freezed,Object? pcmChunk = freezed,Object? sampleRate = freezed,Object? channels = freezed,Object? chunkIndex = null,}) {
  return _then(_self.copyWith(
progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,waveform: freezed == waveform ? _self.waveform : waveform // ignore: cast_nullable_to_non_nullable
as Float64List?,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,isComplete: null == isComplete ? _self.isComplete : isComplete // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,pcmChunk: freezed == pcmChunk ? _self.pcmChunk : pcmChunk // ignore: cast_nullable_to_non_nullable
as Int16List?,sampleRate: freezed == sampleRate ? _self.sampleRate : sampleRate // ignore: cast_nullable_to_non_nullable
as int?,channels: freezed == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as int?,chunkIndex: null == chunkIndex ? _self.chunkIndex : chunkIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WemDecodeProgress].
extension WemDecodeProgressPatterns on WemDecodeProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WemDecodeProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WemDecodeProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WemDecodeProgress value)  $default,){
final _that = this;
switch (_that) {
case _WemDecodeProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WemDecodeProgress value)?  $default,){
final _that = this;
switch (_that) {
case _WemDecodeProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double progress,  Float64List? waveform,  int? durationMs,  bool isComplete,  String? error,  Int16List? pcmChunk,  int? sampleRate,  int? channels,  int chunkIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WemDecodeProgress() when $default != null:
return $default(_that.progress,_that.waveform,_that.durationMs,_that.isComplete,_that.error,_that.pcmChunk,_that.sampleRate,_that.channels,_that.chunkIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double progress,  Float64List? waveform,  int? durationMs,  bool isComplete,  String? error,  Int16List? pcmChunk,  int? sampleRate,  int? channels,  int chunkIndex)  $default,) {final _that = this;
switch (_that) {
case _WemDecodeProgress():
return $default(_that.progress,_that.waveform,_that.durationMs,_that.isComplete,_that.error,_that.pcmChunk,_that.sampleRate,_that.channels,_that.chunkIndex);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double progress,  Float64List? waveform,  int? durationMs,  bool isComplete,  String? error,  Int16List? pcmChunk,  int? sampleRate,  int? channels,  int chunkIndex)?  $default,) {final _that = this;
switch (_that) {
case _WemDecodeProgress() when $default != null:
return $default(_that.progress,_that.waveform,_that.durationMs,_that.isComplete,_that.error,_that.pcmChunk,_that.sampleRate,_that.channels,_that.chunkIndex);case _:
  return null;

}
}

}

/// @nodoc


class _WemDecodeProgress implements WemDecodeProgress {
  const _WemDecodeProgress({required this.progress, this.waveform, this.durationMs, required this.isComplete, this.error, this.pcmChunk, this.sampleRate, this.channels, required this.chunkIndex});
  

@override final  double progress;
@override final  Float64List? waveform;
@override final  int? durationMs;
@override final  bool isComplete;
@override final  String? error;
@override final  Int16List? pcmChunk;
@override final  int? sampleRate;
@override final  int? channels;
@override final  int chunkIndex;

/// Create a copy of WemDecodeProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WemDecodeProgressCopyWith<_WemDecodeProgress> get copyWith => __$WemDecodeProgressCopyWithImpl<_WemDecodeProgress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WemDecodeProgress&&(identical(other.progress, progress) || other.progress == progress)&&const DeepCollectionEquality().equals(other.waveform, waveform)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.isComplete, isComplete) || other.isComplete == isComplete)&&(identical(other.error, error) || other.error == error)&&const DeepCollectionEquality().equals(other.pcmChunk, pcmChunk)&&(identical(other.sampleRate, sampleRate) || other.sampleRate == sampleRate)&&(identical(other.channels, channels) || other.channels == channels)&&(identical(other.chunkIndex, chunkIndex) || other.chunkIndex == chunkIndex));
}


@override
int get hashCode => Object.hash(runtimeType,progress,const DeepCollectionEquality().hash(waveform),durationMs,isComplete,error,const DeepCollectionEquality().hash(pcmChunk),sampleRate,channels,chunkIndex);

@override
String toString() {
  return 'WemDecodeProgress(progress: $progress, waveform: $waveform, durationMs: $durationMs, isComplete: $isComplete, error: $error, pcmChunk: $pcmChunk, sampleRate: $sampleRate, channels: $channels, chunkIndex: $chunkIndex)';
}


}

/// @nodoc
abstract mixin class _$WemDecodeProgressCopyWith<$Res> implements $WemDecodeProgressCopyWith<$Res> {
  factory _$WemDecodeProgressCopyWith(_WemDecodeProgress value, $Res Function(_WemDecodeProgress) _then) = __$WemDecodeProgressCopyWithImpl;
@override @useResult
$Res call({
 double progress, Float64List? waveform, int? durationMs, bool isComplete, String? error, Int16List? pcmChunk, int? sampleRate, int? channels, int chunkIndex
});




}
/// @nodoc
class __$WemDecodeProgressCopyWithImpl<$Res>
    implements _$WemDecodeProgressCopyWith<$Res> {
  __$WemDecodeProgressCopyWithImpl(this._self, this._then);

  final _WemDecodeProgress _self;
  final $Res Function(_WemDecodeProgress) _then;

/// Create a copy of WemDecodeProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? progress = null,Object? waveform = freezed,Object? durationMs = freezed,Object? isComplete = null,Object? error = freezed,Object? pcmChunk = freezed,Object? sampleRate = freezed,Object? channels = freezed,Object? chunkIndex = null,}) {
  return _then(_WemDecodeProgress(
progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,waveform: freezed == waveform ? _self.waveform : waveform // ignore: cast_nullable_to_non_nullable
as Float64List?,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,isComplete: null == isComplete ? _self.isComplete : isComplete // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,pcmChunk: freezed == pcmChunk ? _self.pcmChunk : pcmChunk // ignore: cast_nullable_to_non_nullable
as Int16List?,sampleRate: freezed == sampleRate ? _self.sampleRate : sampleRate // ignore: cast_nullable_to_non_nullable
as int?,channels: freezed == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as int?,chunkIndex: null == chunkIndex ? _self.chunkIndex : chunkIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
