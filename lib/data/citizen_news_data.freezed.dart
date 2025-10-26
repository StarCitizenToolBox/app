// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'citizen_news_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CitizenNewsData {

@JsonKey(name: 'videos') List<CitizenNewsVideosItemData> get videos;@JsonKey(name: 'articles') List<CitizenNewsArticlesItemData> get articles;
/// Create a copy of CitizenNewsData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CitizenNewsDataCopyWith<CitizenNewsData> get copyWith => _$CitizenNewsDataCopyWithImpl<CitizenNewsData>(this as CitizenNewsData, _$identity);

  /// Serializes this CitizenNewsData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CitizenNewsData&&const DeepCollectionEquality().equals(other.videos, videos)&&const DeepCollectionEquality().equals(other.articles, articles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(videos),const DeepCollectionEquality().hash(articles));

@override
String toString() {
  return 'CitizenNewsData(videos: $videos, articles: $articles)';
}


}

/// @nodoc
abstract mixin class $CitizenNewsDataCopyWith<$Res>  {
  factory $CitizenNewsDataCopyWith(CitizenNewsData value, $Res Function(CitizenNewsData) _then) = _$CitizenNewsDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'videos') List<CitizenNewsVideosItemData> videos,@JsonKey(name: 'articles') List<CitizenNewsArticlesItemData> articles
});




}
/// @nodoc
class _$CitizenNewsDataCopyWithImpl<$Res>
    implements $CitizenNewsDataCopyWith<$Res> {
  _$CitizenNewsDataCopyWithImpl(this._self, this._then);

  final CitizenNewsData _self;
  final $Res Function(CitizenNewsData) _then;

/// Create a copy of CitizenNewsData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? videos = null,Object? articles = null,}) {
  return _then(_self.copyWith(
videos: null == videos ? _self.videos : videos // ignore: cast_nullable_to_non_nullable
as List<CitizenNewsVideosItemData>,articles: null == articles ? _self.articles : articles // ignore: cast_nullable_to_non_nullable
as List<CitizenNewsArticlesItemData>,
  ));
}

}


/// Adds pattern-matching-related methods to [CitizenNewsData].
extension CitizenNewsDataPatterns on CitizenNewsData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CitizenNewsData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CitizenNewsData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CitizenNewsData value)  $default,){
final _that = this;
switch (_that) {
case _CitizenNewsData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CitizenNewsData value)?  $default,){
final _that = this;
switch (_that) {
case _CitizenNewsData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'videos')  List<CitizenNewsVideosItemData> videos, @JsonKey(name: 'articles')  List<CitizenNewsArticlesItemData> articles)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CitizenNewsData() when $default != null:
return $default(_that.videos,_that.articles);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'videos')  List<CitizenNewsVideosItemData> videos, @JsonKey(name: 'articles')  List<CitizenNewsArticlesItemData> articles)  $default,) {final _that = this;
switch (_that) {
case _CitizenNewsData():
return $default(_that.videos,_that.articles);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'videos')  List<CitizenNewsVideosItemData> videos, @JsonKey(name: 'articles')  List<CitizenNewsArticlesItemData> articles)?  $default,) {final _that = this;
switch (_that) {
case _CitizenNewsData() when $default != null:
return $default(_that.videos,_that.articles);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CitizenNewsData extends CitizenNewsData {
  const _CitizenNewsData({@JsonKey(name: 'videos') final  List<CitizenNewsVideosItemData> videos = const <CitizenNewsVideosItemData>[], @JsonKey(name: 'articles') final  List<CitizenNewsArticlesItemData> articles = const <CitizenNewsArticlesItemData>[]}): _videos = videos,_articles = articles,super._();
  factory _CitizenNewsData.fromJson(Map<String, dynamic> json) => _$CitizenNewsDataFromJson(json);

 final  List<CitizenNewsVideosItemData> _videos;
@override@JsonKey(name: 'videos') List<CitizenNewsVideosItemData> get videos {
  if (_videos is EqualUnmodifiableListView) return _videos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_videos);
}

 final  List<CitizenNewsArticlesItemData> _articles;
@override@JsonKey(name: 'articles') List<CitizenNewsArticlesItemData> get articles {
  if (_articles is EqualUnmodifiableListView) return _articles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_articles);
}


/// Create a copy of CitizenNewsData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CitizenNewsDataCopyWith<_CitizenNewsData> get copyWith => __$CitizenNewsDataCopyWithImpl<_CitizenNewsData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CitizenNewsDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CitizenNewsData&&const DeepCollectionEquality().equals(other._videos, _videos)&&const DeepCollectionEquality().equals(other._articles, _articles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_videos),const DeepCollectionEquality().hash(_articles));

@override
String toString() {
  return 'CitizenNewsData(videos: $videos, articles: $articles)';
}


}

/// @nodoc
abstract mixin class _$CitizenNewsDataCopyWith<$Res> implements $CitizenNewsDataCopyWith<$Res> {
  factory _$CitizenNewsDataCopyWith(_CitizenNewsData value, $Res Function(_CitizenNewsData) _then) = __$CitizenNewsDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'videos') List<CitizenNewsVideosItemData> videos,@JsonKey(name: 'articles') List<CitizenNewsArticlesItemData> articles
});




}
/// @nodoc
class __$CitizenNewsDataCopyWithImpl<$Res>
    implements _$CitizenNewsDataCopyWith<$Res> {
  __$CitizenNewsDataCopyWithImpl(this._self, this._then);

  final _CitizenNewsData _self;
  final $Res Function(_CitizenNewsData) _then;

/// Create a copy of CitizenNewsData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? videos = null,Object? articles = null,}) {
  return _then(_CitizenNewsData(
videos: null == videos ? _self._videos : videos // ignore: cast_nullable_to_non_nullable
as List<CitizenNewsVideosItemData>,articles: null == articles ? _self._articles : articles // ignore: cast_nullable_to_non_nullable
as List<CitizenNewsArticlesItemData>,
  ));
}


}


/// @nodoc
mixin _$CitizenNewsVideosItemData {

@JsonKey(name: 'title') String get title;@JsonKey(name: 'author') String get author;@JsonKey(name: 'description') String get description;@JsonKey(name: 'link') String get link;@JsonKey(name: 'pubDate') String get pubDate;@JsonKey(name: 'postId') String get postId;@JsonKey(name: 'detailedDescription') List<String> get detailedDescription;@JsonKey(name: 'tag') String get tag;
/// Create a copy of CitizenNewsVideosItemData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CitizenNewsVideosItemDataCopyWith<CitizenNewsVideosItemData> get copyWith => _$CitizenNewsVideosItemDataCopyWithImpl<CitizenNewsVideosItemData>(this as CitizenNewsVideosItemData, _$identity);

  /// Serializes this CitizenNewsVideosItemData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CitizenNewsVideosItemData&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.description, description) || other.description == description)&&(identical(other.link, link) || other.link == link)&&(identical(other.pubDate, pubDate) || other.pubDate == pubDate)&&(identical(other.postId, postId) || other.postId == postId)&&const DeepCollectionEquality().equals(other.detailedDescription, detailedDescription)&&(identical(other.tag, tag) || other.tag == tag));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,author,description,link,pubDate,postId,const DeepCollectionEquality().hash(detailedDescription),tag);

@override
String toString() {
  return 'CitizenNewsVideosItemData(title: $title, author: $author, description: $description, link: $link, pubDate: $pubDate, postId: $postId, detailedDescription: $detailedDescription, tag: $tag)';
}


}

/// @nodoc
abstract mixin class $CitizenNewsVideosItemDataCopyWith<$Res>  {
  factory $CitizenNewsVideosItemDataCopyWith(CitizenNewsVideosItemData value, $Res Function(CitizenNewsVideosItemData) _then) = _$CitizenNewsVideosItemDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'title') String title,@JsonKey(name: 'author') String author,@JsonKey(name: 'description') String description,@JsonKey(name: 'link') String link,@JsonKey(name: 'pubDate') String pubDate,@JsonKey(name: 'postId') String postId,@JsonKey(name: 'detailedDescription') List<String> detailedDescription,@JsonKey(name: 'tag') String tag
});




}
/// @nodoc
class _$CitizenNewsVideosItemDataCopyWithImpl<$Res>
    implements $CitizenNewsVideosItemDataCopyWith<$Res> {
  _$CitizenNewsVideosItemDataCopyWithImpl(this._self, this._then);

  final CitizenNewsVideosItemData _self;
  final $Res Function(CitizenNewsVideosItemData) _then;

/// Create a copy of CitizenNewsVideosItemData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? author = null,Object? description = null,Object? link = null,Object? pubDate = null,Object? postId = null,Object? detailedDescription = null,Object? tag = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,link: null == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String,pubDate: null == pubDate ? _self.pubDate : pubDate // ignore: cast_nullable_to_non_nullable
as String,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,detailedDescription: null == detailedDescription ? _self.detailedDescription : detailedDescription // ignore: cast_nullable_to_non_nullable
as List<String>,tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CitizenNewsVideosItemData].
extension CitizenNewsVideosItemDataPatterns on CitizenNewsVideosItemData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CitizenNewsVideosItemData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CitizenNewsVideosItemData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CitizenNewsVideosItemData value)  $default,){
final _that = this;
switch (_that) {
case _CitizenNewsVideosItemData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CitizenNewsVideosItemData value)?  $default,){
final _that = this;
switch (_that) {
case _CitizenNewsVideosItemData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'title')  String title, @JsonKey(name: 'author')  String author, @JsonKey(name: 'description')  String description, @JsonKey(name: 'link')  String link, @JsonKey(name: 'pubDate')  String pubDate, @JsonKey(name: 'postId')  String postId, @JsonKey(name: 'detailedDescription')  List<String> detailedDescription, @JsonKey(name: 'tag')  String tag)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CitizenNewsVideosItemData() when $default != null:
return $default(_that.title,_that.author,_that.description,_that.link,_that.pubDate,_that.postId,_that.detailedDescription,_that.tag);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'title')  String title, @JsonKey(name: 'author')  String author, @JsonKey(name: 'description')  String description, @JsonKey(name: 'link')  String link, @JsonKey(name: 'pubDate')  String pubDate, @JsonKey(name: 'postId')  String postId, @JsonKey(name: 'detailedDescription')  List<String> detailedDescription, @JsonKey(name: 'tag')  String tag)  $default,) {final _that = this;
switch (_that) {
case _CitizenNewsVideosItemData():
return $default(_that.title,_that.author,_that.description,_that.link,_that.pubDate,_that.postId,_that.detailedDescription,_that.tag);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'title')  String title, @JsonKey(name: 'author')  String author, @JsonKey(name: 'description')  String description, @JsonKey(name: 'link')  String link, @JsonKey(name: 'pubDate')  String pubDate, @JsonKey(name: 'postId')  String postId, @JsonKey(name: 'detailedDescription')  List<String> detailedDescription, @JsonKey(name: 'tag')  String tag)?  $default,) {final _that = this;
switch (_that) {
case _CitizenNewsVideosItemData() when $default != null:
return $default(_that.title,_that.author,_that.description,_that.link,_that.pubDate,_that.postId,_that.detailedDescription,_that.tag);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CitizenNewsVideosItemData extends CitizenNewsVideosItemData {
  const _CitizenNewsVideosItemData({@JsonKey(name: 'title') this.title = '', @JsonKey(name: 'author') this.author = '', @JsonKey(name: 'description') this.description = '', @JsonKey(name: 'link') this.link = '', @JsonKey(name: 'pubDate') this.pubDate = '', @JsonKey(name: 'postId') this.postId = '', @JsonKey(name: 'detailedDescription') final  List<String> detailedDescription = const <String>[], @JsonKey(name: 'tag') this.tag = ''}): _detailedDescription = detailedDescription,super._();
  factory _CitizenNewsVideosItemData.fromJson(Map<String, dynamic> json) => _$CitizenNewsVideosItemDataFromJson(json);

@override@JsonKey(name: 'title') final  String title;
@override@JsonKey(name: 'author') final  String author;
@override@JsonKey(name: 'description') final  String description;
@override@JsonKey(name: 'link') final  String link;
@override@JsonKey(name: 'pubDate') final  String pubDate;
@override@JsonKey(name: 'postId') final  String postId;
 final  List<String> _detailedDescription;
@override@JsonKey(name: 'detailedDescription') List<String> get detailedDescription {
  if (_detailedDescription is EqualUnmodifiableListView) return _detailedDescription;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_detailedDescription);
}

@override@JsonKey(name: 'tag') final  String tag;

/// Create a copy of CitizenNewsVideosItemData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CitizenNewsVideosItemDataCopyWith<_CitizenNewsVideosItemData> get copyWith => __$CitizenNewsVideosItemDataCopyWithImpl<_CitizenNewsVideosItemData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CitizenNewsVideosItemDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CitizenNewsVideosItemData&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.description, description) || other.description == description)&&(identical(other.link, link) || other.link == link)&&(identical(other.pubDate, pubDate) || other.pubDate == pubDate)&&(identical(other.postId, postId) || other.postId == postId)&&const DeepCollectionEquality().equals(other._detailedDescription, _detailedDescription)&&(identical(other.tag, tag) || other.tag == tag));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,author,description,link,pubDate,postId,const DeepCollectionEquality().hash(_detailedDescription),tag);

@override
String toString() {
  return 'CitizenNewsVideosItemData(title: $title, author: $author, description: $description, link: $link, pubDate: $pubDate, postId: $postId, detailedDescription: $detailedDescription, tag: $tag)';
}


}

/// @nodoc
abstract mixin class _$CitizenNewsVideosItemDataCopyWith<$Res> implements $CitizenNewsVideosItemDataCopyWith<$Res> {
  factory _$CitizenNewsVideosItemDataCopyWith(_CitizenNewsVideosItemData value, $Res Function(_CitizenNewsVideosItemData) _then) = __$CitizenNewsVideosItemDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'title') String title,@JsonKey(name: 'author') String author,@JsonKey(name: 'description') String description,@JsonKey(name: 'link') String link,@JsonKey(name: 'pubDate') String pubDate,@JsonKey(name: 'postId') String postId,@JsonKey(name: 'detailedDescription') List<String> detailedDescription,@JsonKey(name: 'tag') String tag
});




}
/// @nodoc
class __$CitizenNewsVideosItemDataCopyWithImpl<$Res>
    implements _$CitizenNewsVideosItemDataCopyWith<$Res> {
  __$CitizenNewsVideosItemDataCopyWithImpl(this._self, this._then);

  final _CitizenNewsVideosItemData _self;
  final $Res Function(_CitizenNewsVideosItemData) _then;

/// Create a copy of CitizenNewsVideosItemData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? author = null,Object? description = null,Object? link = null,Object? pubDate = null,Object? postId = null,Object? detailedDescription = null,Object? tag = null,}) {
  return _then(_CitizenNewsVideosItemData(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,link: null == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String,pubDate: null == pubDate ? _self.pubDate : pubDate // ignore: cast_nullable_to_non_nullable
as String,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,detailedDescription: null == detailedDescription ? _self._detailedDescription : detailedDescription // ignore: cast_nullable_to_non_nullable
as List<String>,tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CitizenNewsArticlesItemData {

@JsonKey(name: 'title') String get title;@JsonKey(name: 'author') String get author;@JsonKey(name: 'description') String get description;@JsonKey(name: 'link') String get link;@JsonKey(name: 'pubDate') String get pubDate;@JsonKey(name: 'postId') String get postId;@JsonKey(name: 'detailedDescription') List<String> get detailedDescription;@JsonKey(name: 'tag') String get tag;
/// Create a copy of CitizenNewsArticlesItemData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CitizenNewsArticlesItemDataCopyWith<CitizenNewsArticlesItemData> get copyWith => _$CitizenNewsArticlesItemDataCopyWithImpl<CitizenNewsArticlesItemData>(this as CitizenNewsArticlesItemData, _$identity);

  /// Serializes this CitizenNewsArticlesItemData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CitizenNewsArticlesItemData&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.description, description) || other.description == description)&&(identical(other.link, link) || other.link == link)&&(identical(other.pubDate, pubDate) || other.pubDate == pubDate)&&(identical(other.postId, postId) || other.postId == postId)&&const DeepCollectionEquality().equals(other.detailedDescription, detailedDescription)&&(identical(other.tag, tag) || other.tag == tag));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,author,description,link,pubDate,postId,const DeepCollectionEquality().hash(detailedDescription),tag);

@override
String toString() {
  return 'CitizenNewsArticlesItemData(title: $title, author: $author, description: $description, link: $link, pubDate: $pubDate, postId: $postId, detailedDescription: $detailedDescription, tag: $tag)';
}


}

/// @nodoc
abstract mixin class $CitizenNewsArticlesItemDataCopyWith<$Res>  {
  factory $CitizenNewsArticlesItemDataCopyWith(CitizenNewsArticlesItemData value, $Res Function(CitizenNewsArticlesItemData) _then) = _$CitizenNewsArticlesItemDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'title') String title,@JsonKey(name: 'author') String author,@JsonKey(name: 'description') String description,@JsonKey(name: 'link') String link,@JsonKey(name: 'pubDate') String pubDate,@JsonKey(name: 'postId') String postId,@JsonKey(name: 'detailedDescription') List<String> detailedDescription,@JsonKey(name: 'tag') String tag
});




}
/// @nodoc
class _$CitizenNewsArticlesItemDataCopyWithImpl<$Res>
    implements $CitizenNewsArticlesItemDataCopyWith<$Res> {
  _$CitizenNewsArticlesItemDataCopyWithImpl(this._self, this._then);

  final CitizenNewsArticlesItemData _self;
  final $Res Function(CitizenNewsArticlesItemData) _then;

/// Create a copy of CitizenNewsArticlesItemData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? author = null,Object? description = null,Object? link = null,Object? pubDate = null,Object? postId = null,Object? detailedDescription = null,Object? tag = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,link: null == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String,pubDate: null == pubDate ? _self.pubDate : pubDate // ignore: cast_nullable_to_non_nullable
as String,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,detailedDescription: null == detailedDescription ? _self.detailedDescription : detailedDescription // ignore: cast_nullable_to_non_nullable
as List<String>,tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CitizenNewsArticlesItemData].
extension CitizenNewsArticlesItemDataPatterns on CitizenNewsArticlesItemData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CitizenNewsArticlesItemData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CitizenNewsArticlesItemData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CitizenNewsArticlesItemData value)  $default,){
final _that = this;
switch (_that) {
case _CitizenNewsArticlesItemData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CitizenNewsArticlesItemData value)?  $default,){
final _that = this;
switch (_that) {
case _CitizenNewsArticlesItemData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'title')  String title, @JsonKey(name: 'author')  String author, @JsonKey(name: 'description')  String description, @JsonKey(name: 'link')  String link, @JsonKey(name: 'pubDate')  String pubDate, @JsonKey(name: 'postId')  String postId, @JsonKey(name: 'detailedDescription')  List<String> detailedDescription, @JsonKey(name: 'tag')  String tag)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CitizenNewsArticlesItemData() when $default != null:
return $default(_that.title,_that.author,_that.description,_that.link,_that.pubDate,_that.postId,_that.detailedDescription,_that.tag);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'title')  String title, @JsonKey(name: 'author')  String author, @JsonKey(name: 'description')  String description, @JsonKey(name: 'link')  String link, @JsonKey(name: 'pubDate')  String pubDate, @JsonKey(name: 'postId')  String postId, @JsonKey(name: 'detailedDescription')  List<String> detailedDescription, @JsonKey(name: 'tag')  String tag)  $default,) {final _that = this;
switch (_that) {
case _CitizenNewsArticlesItemData():
return $default(_that.title,_that.author,_that.description,_that.link,_that.pubDate,_that.postId,_that.detailedDescription,_that.tag);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'title')  String title, @JsonKey(name: 'author')  String author, @JsonKey(name: 'description')  String description, @JsonKey(name: 'link')  String link, @JsonKey(name: 'pubDate')  String pubDate, @JsonKey(name: 'postId')  String postId, @JsonKey(name: 'detailedDescription')  List<String> detailedDescription, @JsonKey(name: 'tag')  String tag)?  $default,) {final _that = this;
switch (_that) {
case _CitizenNewsArticlesItemData() when $default != null:
return $default(_that.title,_that.author,_that.description,_that.link,_that.pubDate,_that.postId,_that.detailedDescription,_that.tag);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CitizenNewsArticlesItemData extends CitizenNewsArticlesItemData {
  const _CitizenNewsArticlesItemData({@JsonKey(name: 'title') this.title = '', @JsonKey(name: 'author') this.author = '', @JsonKey(name: 'description') this.description = '', @JsonKey(name: 'link') this.link = '', @JsonKey(name: 'pubDate') this.pubDate = '', @JsonKey(name: 'postId') this.postId = '', @JsonKey(name: 'detailedDescription') final  List<String> detailedDescription = const <String>[], @JsonKey(name: 'tag') this.tag = ''}): _detailedDescription = detailedDescription,super._();
  factory _CitizenNewsArticlesItemData.fromJson(Map<String, dynamic> json) => _$CitizenNewsArticlesItemDataFromJson(json);

@override@JsonKey(name: 'title') final  String title;
@override@JsonKey(name: 'author') final  String author;
@override@JsonKey(name: 'description') final  String description;
@override@JsonKey(name: 'link') final  String link;
@override@JsonKey(name: 'pubDate') final  String pubDate;
@override@JsonKey(name: 'postId') final  String postId;
 final  List<String> _detailedDescription;
@override@JsonKey(name: 'detailedDescription') List<String> get detailedDescription {
  if (_detailedDescription is EqualUnmodifiableListView) return _detailedDescription;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_detailedDescription);
}

@override@JsonKey(name: 'tag') final  String tag;

/// Create a copy of CitizenNewsArticlesItemData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CitizenNewsArticlesItemDataCopyWith<_CitizenNewsArticlesItemData> get copyWith => __$CitizenNewsArticlesItemDataCopyWithImpl<_CitizenNewsArticlesItemData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CitizenNewsArticlesItemDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CitizenNewsArticlesItemData&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.description, description) || other.description == description)&&(identical(other.link, link) || other.link == link)&&(identical(other.pubDate, pubDate) || other.pubDate == pubDate)&&(identical(other.postId, postId) || other.postId == postId)&&const DeepCollectionEquality().equals(other._detailedDescription, _detailedDescription)&&(identical(other.tag, tag) || other.tag == tag));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,author,description,link,pubDate,postId,const DeepCollectionEquality().hash(_detailedDescription),tag);

@override
String toString() {
  return 'CitizenNewsArticlesItemData(title: $title, author: $author, description: $description, link: $link, pubDate: $pubDate, postId: $postId, detailedDescription: $detailedDescription, tag: $tag)';
}


}

/// @nodoc
abstract mixin class _$CitizenNewsArticlesItemDataCopyWith<$Res> implements $CitizenNewsArticlesItemDataCopyWith<$Res> {
  factory _$CitizenNewsArticlesItemDataCopyWith(_CitizenNewsArticlesItemData value, $Res Function(_CitizenNewsArticlesItemData) _then) = __$CitizenNewsArticlesItemDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'title') String title,@JsonKey(name: 'author') String author,@JsonKey(name: 'description') String description,@JsonKey(name: 'link') String link,@JsonKey(name: 'pubDate') String pubDate,@JsonKey(name: 'postId') String postId,@JsonKey(name: 'detailedDescription') List<String> detailedDescription,@JsonKey(name: 'tag') String tag
});




}
/// @nodoc
class __$CitizenNewsArticlesItemDataCopyWithImpl<$Res>
    implements _$CitizenNewsArticlesItemDataCopyWith<$Res> {
  __$CitizenNewsArticlesItemDataCopyWithImpl(this._self, this._then);

  final _CitizenNewsArticlesItemData _self;
  final $Res Function(_CitizenNewsArticlesItemData) _then;

/// Create a copy of CitizenNewsArticlesItemData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? author = null,Object? description = null,Object? link = null,Object? pubDate = null,Object? postId = null,Object? detailedDescription = null,Object? tag = null,}) {
  return _then(_CitizenNewsArticlesItemData(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,link: null == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String,pubDate: null == pubDate ? _self.pubDate : pubDate // ignore: cast_nullable_to_non_nullable
as String,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,detailedDescription: null == detailedDescription ? _self._detailedDescription : detailedDescription // ignore: cast_nullable_to_non_nullable
as List<String>,tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
