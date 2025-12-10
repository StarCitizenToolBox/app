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

// dart format on
