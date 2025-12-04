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
