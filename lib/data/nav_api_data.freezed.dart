// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nav_api_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NavApiDocsItemData {
  @JsonKey(name: 'id')
  String get id;
  @JsonKey(name: 'name')
  String get name;
  @JsonKey(name: 'slug')
  String get slug;
  @JsonKey(name: 'abstract')
  String get abstract_;
  @JsonKey(name: 'description')
  String get description;
  @JsonKey(name: 'image')
  NavApiDocsItemImageData get image;
  @JsonKey(name: 'link')
  String get link;
  @JsonKey(name: 'is_sponsored')
  bool get isSponsored;
  @JsonKey(name: 'tags')
  List<NavApiDocsItemTagsItemData> get tags;
  @JsonKey(name: 'updatedAt')
  String get updatedAt;
  @JsonKey(name: 'createdAt')
  String get createdAt;

  /// Create a copy of NavApiDocsItemData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NavApiDocsItemDataCopyWith<NavApiDocsItemData> get copyWith =>
      _$NavApiDocsItemDataCopyWithImpl<NavApiDocsItemData>(
          this as NavApiDocsItemData, _$identity);

  /// Serializes this NavApiDocsItemData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NavApiDocsItemData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.abstract_, abstract_) ||
                other.abstract_ == abstract_) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.link, link) || other.link == link) &&
            (identical(other.isSponsored, isSponsored) ||
                other.isSponsored == isSponsored) &&
            const DeepCollectionEquality().equals(other.tags, tags) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      slug,
      abstract_,
      description,
      image,
      link,
      isSponsored,
      const DeepCollectionEquality().hash(tags),
      updatedAt,
      createdAt);

  @override
  String toString() {
    return 'NavApiDocsItemData(id: $id, name: $name, slug: $slug, abstract_: $abstract_, description: $description, image: $image, link: $link, isSponsored: $isSponsored, tags: $tags, updatedAt: $updatedAt, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $NavApiDocsItemDataCopyWith<$Res> {
  factory $NavApiDocsItemDataCopyWith(
          NavApiDocsItemData value, $Res Function(NavApiDocsItemData) _then) =
      _$NavApiDocsItemDataCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'slug') String slug,
      @JsonKey(name: 'abstract') String abstract_,
      @JsonKey(name: 'description') String description,
      @JsonKey(name: 'image') NavApiDocsItemImageData image,
      @JsonKey(name: 'link') String link,
      @JsonKey(name: 'is_sponsored') bool isSponsored,
      @JsonKey(name: 'tags') List<NavApiDocsItemTagsItemData> tags,
      @JsonKey(name: 'updatedAt') String updatedAt,
      @JsonKey(name: 'createdAt') String createdAt});

  $NavApiDocsItemImageDataCopyWith<$Res> get image;
}

/// @nodoc
class _$NavApiDocsItemDataCopyWithImpl<$Res>
    implements $NavApiDocsItemDataCopyWith<$Res> {
  _$NavApiDocsItemDataCopyWithImpl(this._self, this._then);

  final NavApiDocsItemData _self;
  final $Res Function(NavApiDocsItemData) _then;

  /// Create a copy of NavApiDocsItemData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? abstract_ = null,
    Object? description = null,
    Object? image = null,
    Object? link = null,
    Object? isSponsored = null,
    Object? tags = null,
    Object? updatedAt = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _self.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      abstract_: null == abstract_
          ? _self.abstract_
          : abstract_ // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _self.image
          : image // ignore: cast_nullable_to_non_nullable
              as NavApiDocsItemImageData,
      link: null == link
          ? _self.link
          : link // ignore: cast_nullable_to_non_nullable
              as String,
      isSponsored: null == isSponsored
          ? _self.isSponsored
          : isSponsored // ignore: cast_nullable_to_non_nullable
              as bool,
      tags: null == tags
          ? _self.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<NavApiDocsItemTagsItemData>,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of NavApiDocsItemData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NavApiDocsItemImageDataCopyWith<$Res> get image {
    return $NavApiDocsItemImageDataCopyWith<$Res>(_self.image, (value) {
      return _then(_self.copyWith(image: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _NavApiDocsItemData extends NavApiDocsItemData {
  const _NavApiDocsItemData(
      {@JsonKey(name: 'id') this.id = '',
      @JsonKey(name: 'name') this.name = '',
      @JsonKey(name: 'slug') this.slug = '',
      @JsonKey(name: 'abstract') this.abstract_ = '',
      @JsonKey(name: 'description') this.description = '',
      @JsonKey(name: 'image') this.image = const NavApiDocsItemImageData(),
      @JsonKey(name: 'link') this.link = '',
      @JsonKey(name: 'is_sponsored') this.isSponsored = false,
      @JsonKey(name: 'tags') final List<NavApiDocsItemTagsItemData> tags =
          const <NavApiDocsItemTagsItemData>[],
      @JsonKey(name: 'updatedAt') this.updatedAt = '',
      @JsonKey(name: 'createdAt') this.createdAt = ''})
      : _tags = tags,
        super._();
  factory _NavApiDocsItemData.fromJson(Map<String, dynamic> json) =>
      _$NavApiDocsItemDataFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String id;
  @override
  @JsonKey(name: 'name')
  final String name;
  @override
  @JsonKey(name: 'slug')
  final String slug;
  @override
  @JsonKey(name: 'abstract')
  final String abstract_;
  @override
  @JsonKey(name: 'description')
  final String description;
  @override
  @JsonKey(name: 'image')
  final NavApiDocsItemImageData image;
  @override
  @JsonKey(name: 'link')
  final String link;
  @override
  @JsonKey(name: 'is_sponsored')
  final bool isSponsored;
  final List<NavApiDocsItemTagsItemData> _tags;
  @override
  @JsonKey(name: 'tags')
  List<NavApiDocsItemTagsItemData> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey(name: 'updatedAt')
  final String updatedAt;
  @override
  @JsonKey(name: 'createdAt')
  final String createdAt;

  /// Create a copy of NavApiDocsItemData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NavApiDocsItemDataCopyWith<_NavApiDocsItemData> get copyWith =>
      __$NavApiDocsItemDataCopyWithImpl<_NavApiDocsItemData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$NavApiDocsItemDataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NavApiDocsItemData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.abstract_, abstract_) ||
                other.abstract_ == abstract_) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.link, link) || other.link == link) &&
            (identical(other.isSponsored, isSponsored) ||
                other.isSponsored == isSponsored) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      slug,
      abstract_,
      description,
      image,
      link,
      isSponsored,
      const DeepCollectionEquality().hash(_tags),
      updatedAt,
      createdAt);

  @override
  String toString() {
    return 'NavApiDocsItemData(id: $id, name: $name, slug: $slug, abstract_: $abstract_, description: $description, image: $image, link: $link, isSponsored: $isSponsored, tags: $tags, updatedAt: $updatedAt, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$NavApiDocsItemDataCopyWith<$Res>
    implements $NavApiDocsItemDataCopyWith<$Res> {
  factory _$NavApiDocsItemDataCopyWith(
          _NavApiDocsItemData value, $Res Function(_NavApiDocsItemData) _then) =
      __$NavApiDocsItemDataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'slug') String slug,
      @JsonKey(name: 'abstract') String abstract_,
      @JsonKey(name: 'description') String description,
      @JsonKey(name: 'image') NavApiDocsItemImageData image,
      @JsonKey(name: 'link') String link,
      @JsonKey(name: 'is_sponsored') bool isSponsored,
      @JsonKey(name: 'tags') List<NavApiDocsItemTagsItemData> tags,
      @JsonKey(name: 'updatedAt') String updatedAt,
      @JsonKey(name: 'createdAt') String createdAt});

  @override
  $NavApiDocsItemImageDataCopyWith<$Res> get image;
}

/// @nodoc
class __$NavApiDocsItemDataCopyWithImpl<$Res>
    implements _$NavApiDocsItemDataCopyWith<$Res> {
  __$NavApiDocsItemDataCopyWithImpl(this._self, this._then);

  final _NavApiDocsItemData _self;
  final $Res Function(_NavApiDocsItemData) _then;

  /// Create a copy of NavApiDocsItemData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? abstract_ = null,
    Object? description = null,
    Object? image = null,
    Object? link = null,
    Object? isSponsored = null,
    Object? tags = null,
    Object? updatedAt = null,
    Object? createdAt = null,
  }) {
    return _then(_NavApiDocsItemData(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _self.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      abstract_: null == abstract_
          ? _self.abstract_
          : abstract_ // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _self.image
          : image // ignore: cast_nullable_to_non_nullable
              as NavApiDocsItemImageData,
      link: null == link
          ? _self.link
          : link // ignore: cast_nullable_to_non_nullable
              as String,
      isSponsored: null == isSponsored
          ? _self.isSponsored
          : isSponsored // ignore: cast_nullable_to_non_nullable
              as bool,
      tags: null == tags
          ? _self._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<NavApiDocsItemTagsItemData>,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of NavApiDocsItemData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NavApiDocsItemImageDataCopyWith<$Res> get image {
    return $NavApiDocsItemImageDataCopyWith<$Res>(_self.image, (value) {
      return _then(_self.copyWith(image: value));
    });
  }
}

/// @nodoc
mixin _$NavApiDocsItemImageData {
  @JsonKey(name: 'id')
  String get id;
  @JsonKey(name: 'createdBy')
  NavApiDocsItemImageCreatedByData get createdBy;
  @JsonKey(name: 'title')
  String get title;
  @JsonKey(name: 'original')
  bool get original;
  @JsonKey(name: 'credit')
  String get credit;
  @JsonKey(name: 'source')
  String get source;
  @JsonKey(name: 'license')
  String get license;
  @JsonKey(name: 'caption')
  dynamic get caption;
  @JsonKey(name: 'updatedAt')
  String get updatedAt;
  @JsonKey(name: 'createdAt')
  String get createdAt;
  @JsonKey(name: 'url')
  String get url;
  @JsonKey(name: 'filename')
  String get filename;
  @JsonKey(name: 'mimeType')
  String get mimeType;
  @JsonKey(name: 'filesize')
  int get filesize;
  @JsonKey(name: 'width')
  int get width;
  @JsonKey(name: 'height')
  int get height;
  @JsonKey(name: 'sizes')
  NavApiDocsItemImageSizesData get sizes;

  /// Create a copy of NavApiDocsItemImageData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NavApiDocsItemImageDataCopyWith<NavApiDocsItemImageData> get copyWith =>
      _$NavApiDocsItemImageDataCopyWithImpl<NavApiDocsItemImageData>(
          this as NavApiDocsItemImageData, _$identity);

  /// Serializes this NavApiDocsItemImageData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NavApiDocsItemImageData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.original, original) ||
                other.original == original) &&
            (identical(other.credit, credit) || other.credit == credit) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.license, license) || other.license == license) &&
            const DeepCollectionEquality().equals(other.caption, caption) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.filename, filename) ||
                other.filename == filename) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.filesize, filesize) ||
                other.filesize == filesize) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.sizes, sizes) || other.sizes == sizes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      createdBy,
      title,
      original,
      credit,
      source,
      license,
      const DeepCollectionEquality().hash(caption),
      updatedAt,
      createdAt,
      url,
      filename,
      mimeType,
      filesize,
      width,
      height,
      sizes);

  @override
  String toString() {
    return 'NavApiDocsItemImageData(id: $id, createdBy: $createdBy, title: $title, original: $original, credit: $credit, source: $source, license: $license, caption: $caption, updatedAt: $updatedAt, createdAt: $createdAt, url: $url, filename: $filename, mimeType: $mimeType, filesize: $filesize, width: $width, height: $height, sizes: $sizes)';
  }
}

/// @nodoc
abstract mixin class $NavApiDocsItemImageDataCopyWith<$Res> {
  factory $NavApiDocsItemImageDataCopyWith(NavApiDocsItemImageData value,
          $Res Function(NavApiDocsItemImageData) _then) =
      _$NavApiDocsItemImageDataCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'createdBy') NavApiDocsItemImageCreatedByData createdBy,
      @JsonKey(name: 'title') String title,
      @JsonKey(name: 'original') bool original,
      @JsonKey(name: 'credit') String credit,
      @JsonKey(name: 'source') String source,
      @JsonKey(name: 'license') String license,
      @JsonKey(name: 'caption') dynamic caption,
      @JsonKey(name: 'updatedAt') String updatedAt,
      @JsonKey(name: 'createdAt') String createdAt,
      @JsonKey(name: 'url') String url,
      @JsonKey(name: 'filename') String filename,
      @JsonKey(name: 'mimeType') String mimeType,
      @JsonKey(name: 'filesize') int filesize,
      @JsonKey(name: 'width') int width,
      @JsonKey(name: 'height') int height,
      @JsonKey(name: 'sizes') NavApiDocsItemImageSizesData sizes});

  $NavApiDocsItemImageCreatedByDataCopyWith<$Res> get createdBy;
  $NavApiDocsItemImageSizesDataCopyWith<$Res> get sizes;
}

/// @nodoc
class _$NavApiDocsItemImageDataCopyWithImpl<$Res>
    implements $NavApiDocsItemImageDataCopyWith<$Res> {
  _$NavApiDocsItemImageDataCopyWithImpl(this._self, this._then);

  final NavApiDocsItemImageData _self;
  final $Res Function(NavApiDocsItemImageData) _then;

  /// Create a copy of NavApiDocsItemImageData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdBy = null,
    Object? title = null,
    Object? original = null,
    Object? credit = null,
    Object? source = null,
    Object? license = null,
    Object? caption = freezed,
    Object? updatedAt = null,
    Object? createdAt = null,
    Object? url = null,
    Object? filename = null,
    Object? mimeType = null,
    Object? filesize = null,
    Object? width = null,
    Object? height = null,
    Object? sizes = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _self.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as NavApiDocsItemImageCreatedByData,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      original: null == original
          ? _self.original
          : original // ignore: cast_nullable_to_non_nullable
              as bool,
      credit: null == credit
          ? _self.credit
          : credit // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      license: null == license
          ? _self.license
          : license // ignore: cast_nullable_to_non_nullable
              as String,
      caption: freezed == caption
          ? _self.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as dynamic,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      filename: null == filename
          ? _self.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: null == mimeType
          ? _self.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      filesize: null == filesize
          ? _self.filesize
          : filesize // ignore: cast_nullable_to_non_nullable
              as int,
      width: null == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      sizes: null == sizes
          ? _self.sizes
          : sizes // ignore: cast_nullable_to_non_nullable
              as NavApiDocsItemImageSizesData,
    ));
  }

  /// Create a copy of NavApiDocsItemImageData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NavApiDocsItemImageCreatedByDataCopyWith<$Res> get createdBy {
    return $NavApiDocsItemImageCreatedByDataCopyWith<$Res>(_self.createdBy,
        (value) {
      return _then(_self.copyWith(createdBy: value));
    });
  }

  /// Create a copy of NavApiDocsItemImageData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NavApiDocsItemImageSizesDataCopyWith<$Res> get sizes {
    return $NavApiDocsItemImageSizesDataCopyWith<$Res>(_self.sizes, (value) {
      return _then(_self.copyWith(sizes: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _NavApiDocsItemImageData extends NavApiDocsItemImageData {
  const _NavApiDocsItemImageData(
      {@JsonKey(name: 'id') this.id = '',
      @JsonKey(name: 'createdBy')
      this.createdBy = const NavApiDocsItemImageCreatedByData(),
      @JsonKey(name: 'title') this.title = '',
      @JsonKey(name: 'original') this.original = false,
      @JsonKey(name: 'credit') this.credit = '',
      @JsonKey(name: 'source') this.source = '',
      @JsonKey(name: 'license') this.license = '',
      @JsonKey(name: 'caption') this.caption,
      @JsonKey(name: 'updatedAt') this.updatedAt = '',
      @JsonKey(name: 'createdAt') this.createdAt = '',
      @JsonKey(name: 'url') this.url = '',
      @JsonKey(name: 'filename') this.filename = '',
      @JsonKey(name: 'mimeType') this.mimeType = '',
      @JsonKey(name: 'filesize') this.filesize = 0,
      @JsonKey(name: 'width') this.width = 0,
      @JsonKey(name: 'height') this.height = 0,
      @JsonKey(name: 'sizes')
      this.sizes = const NavApiDocsItemImageSizesData()})
      : super._();
  factory _NavApiDocsItemImageData.fromJson(Map<String, dynamic> json) =>
      _$NavApiDocsItemImageDataFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String id;
  @override
  @JsonKey(name: 'createdBy')
  final NavApiDocsItemImageCreatedByData createdBy;
  @override
  @JsonKey(name: 'title')
  final String title;
  @override
  @JsonKey(name: 'original')
  final bool original;
  @override
  @JsonKey(name: 'credit')
  final String credit;
  @override
  @JsonKey(name: 'source')
  final String source;
  @override
  @JsonKey(name: 'license')
  final String license;
  @override
  @JsonKey(name: 'caption')
  final dynamic caption;
  @override
  @JsonKey(name: 'updatedAt')
  final String updatedAt;
  @override
  @JsonKey(name: 'createdAt')
  final String createdAt;
  @override
  @JsonKey(name: 'url')
  final String url;
  @override
  @JsonKey(name: 'filename')
  final String filename;
  @override
  @JsonKey(name: 'mimeType')
  final String mimeType;
  @override
  @JsonKey(name: 'filesize')
  final int filesize;
  @override
  @JsonKey(name: 'width')
  final int width;
  @override
  @JsonKey(name: 'height')
  final int height;
  @override
  @JsonKey(name: 'sizes')
  final NavApiDocsItemImageSizesData sizes;

  /// Create a copy of NavApiDocsItemImageData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NavApiDocsItemImageDataCopyWith<_NavApiDocsItemImageData> get copyWith =>
      __$NavApiDocsItemImageDataCopyWithImpl<_NavApiDocsItemImageData>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$NavApiDocsItemImageDataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NavApiDocsItemImageData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.original, original) ||
                other.original == original) &&
            (identical(other.credit, credit) || other.credit == credit) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.license, license) || other.license == license) &&
            const DeepCollectionEquality().equals(other.caption, caption) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.filename, filename) ||
                other.filename == filename) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.filesize, filesize) ||
                other.filesize == filesize) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.sizes, sizes) || other.sizes == sizes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      createdBy,
      title,
      original,
      credit,
      source,
      license,
      const DeepCollectionEquality().hash(caption),
      updatedAt,
      createdAt,
      url,
      filename,
      mimeType,
      filesize,
      width,
      height,
      sizes);

  @override
  String toString() {
    return 'NavApiDocsItemImageData(id: $id, createdBy: $createdBy, title: $title, original: $original, credit: $credit, source: $source, license: $license, caption: $caption, updatedAt: $updatedAt, createdAt: $createdAt, url: $url, filename: $filename, mimeType: $mimeType, filesize: $filesize, width: $width, height: $height, sizes: $sizes)';
  }
}

/// @nodoc
abstract mixin class _$NavApiDocsItemImageDataCopyWith<$Res>
    implements $NavApiDocsItemImageDataCopyWith<$Res> {
  factory _$NavApiDocsItemImageDataCopyWith(_NavApiDocsItemImageData value,
          $Res Function(_NavApiDocsItemImageData) _then) =
      __$NavApiDocsItemImageDataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'createdBy') NavApiDocsItemImageCreatedByData createdBy,
      @JsonKey(name: 'title') String title,
      @JsonKey(name: 'original') bool original,
      @JsonKey(name: 'credit') String credit,
      @JsonKey(name: 'source') String source,
      @JsonKey(name: 'license') String license,
      @JsonKey(name: 'caption') dynamic caption,
      @JsonKey(name: 'updatedAt') String updatedAt,
      @JsonKey(name: 'createdAt') String createdAt,
      @JsonKey(name: 'url') String url,
      @JsonKey(name: 'filename') String filename,
      @JsonKey(name: 'mimeType') String mimeType,
      @JsonKey(name: 'filesize') int filesize,
      @JsonKey(name: 'width') int width,
      @JsonKey(name: 'height') int height,
      @JsonKey(name: 'sizes') NavApiDocsItemImageSizesData sizes});

  @override
  $NavApiDocsItemImageCreatedByDataCopyWith<$Res> get createdBy;
  @override
  $NavApiDocsItemImageSizesDataCopyWith<$Res> get sizes;
}

/// @nodoc
class __$NavApiDocsItemImageDataCopyWithImpl<$Res>
    implements _$NavApiDocsItemImageDataCopyWith<$Res> {
  __$NavApiDocsItemImageDataCopyWithImpl(this._self, this._then);

  final _NavApiDocsItemImageData _self;
  final $Res Function(_NavApiDocsItemImageData) _then;

  /// Create a copy of NavApiDocsItemImageData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? createdBy = null,
    Object? title = null,
    Object? original = null,
    Object? credit = null,
    Object? source = null,
    Object? license = null,
    Object? caption = freezed,
    Object? updatedAt = null,
    Object? createdAt = null,
    Object? url = null,
    Object? filename = null,
    Object? mimeType = null,
    Object? filesize = null,
    Object? width = null,
    Object? height = null,
    Object? sizes = null,
  }) {
    return _then(_NavApiDocsItemImageData(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _self.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as NavApiDocsItemImageCreatedByData,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      original: null == original
          ? _self.original
          : original // ignore: cast_nullable_to_non_nullable
              as bool,
      credit: null == credit
          ? _self.credit
          : credit // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      license: null == license
          ? _self.license
          : license // ignore: cast_nullable_to_non_nullable
              as String,
      caption: freezed == caption
          ? _self.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as dynamic,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      filename: null == filename
          ? _self.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: null == mimeType
          ? _self.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      filesize: null == filesize
          ? _self.filesize
          : filesize // ignore: cast_nullable_to_non_nullable
              as int,
      width: null == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      sizes: null == sizes
          ? _self.sizes
          : sizes // ignore: cast_nullable_to_non_nullable
              as NavApiDocsItemImageSizesData,
    ));
  }

  /// Create a copy of NavApiDocsItemImageData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NavApiDocsItemImageCreatedByDataCopyWith<$Res> get createdBy {
    return $NavApiDocsItemImageCreatedByDataCopyWith<$Res>(_self.createdBy,
        (value) {
      return _then(_self.copyWith(createdBy: value));
    });
  }

  /// Create a copy of NavApiDocsItemImageData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NavApiDocsItemImageSizesDataCopyWith<$Res> get sizes {
    return $NavApiDocsItemImageSizesDataCopyWith<$Res>(_self.sizes, (value) {
      return _then(_self.copyWith(sizes: value));
    });
  }
}

/// @nodoc
mixin _$NavApiDocsItemImageCreatedByData {
  @JsonKey(name: 'id')
  String get id;
  @JsonKey(name: 'sub')
  String get sub;
  @JsonKey(name: 'external_provider')
  String get externalProvider;
  @JsonKey(name: 'username')
  String get username;
  @JsonKey(name: 'name')
  String get name;
  @JsonKey(name: 'roles')
  List<String> get roles;
  @JsonKey(name: 'avatar_url')
  String get avatarUrl;
  @JsonKey(name: 'updatedAt')
  String get updatedAt;
  @JsonKey(name: 'createdAt')
  String get createdAt;
  @JsonKey(name: 'email')
  String get email;
  @JsonKey(name: 'loginAttempts')
  int get loginAttempts;
  @JsonKey(name: 'avatar')
  String get avatar;

  /// Create a copy of NavApiDocsItemImageCreatedByData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NavApiDocsItemImageCreatedByDataCopyWith<NavApiDocsItemImageCreatedByData>
      get copyWith => _$NavApiDocsItemImageCreatedByDataCopyWithImpl<
              NavApiDocsItemImageCreatedByData>(
          this as NavApiDocsItemImageCreatedByData, _$identity);

  /// Serializes this NavApiDocsItemImageCreatedByData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NavApiDocsItemImageCreatedByData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sub, sub) || other.sub == sub) &&
            (identical(other.externalProvider, externalProvider) ||
                other.externalProvider == externalProvider) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other.roles, roles) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.loginAttempts, loginAttempts) ||
                other.loginAttempts == loginAttempts) &&
            (identical(other.avatar, avatar) || other.avatar == avatar));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      sub,
      externalProvider,
      username,
      name,
      const DeepCollectionEquality().hash(roles),
      avatarUrl,
      updatedAt,
      createdAt,
      email,
      loginAttempts,
      avatar);

  @override
  String toString() {
    return 'NavApiDocsItemImageCreatedByData(id: $id, sub: $sub, externalProvider: $externalProvider, username: $username, name: $name, roles: $roles, avatarUrl: $avatarUrl, updatedAt: $updatedAt, createdAt: $createdAt, email: $email, loginAttempts: $loginAttempts, avatar: $avatar)';
  }
}

/// @nodoc
abstract mixin class $NavApiDocsItemImageCreatedByDataCopyWith<$Res> {
  factory $NavApiDocsItemImageCreatedByDataCopyWith(
          NavApiDocsItemImageCreatedByData value,
          $Res Function(NavApiDocsItemImageCreatedByData) _then) =
      _$NavApiDocsItemImageCreatedByDataCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'sub') String sub,
      @JsonKey(name: 'external_provider') String externalProvider,
      @JsonKey(name: 'username') String username,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'roles') List<String> roles,
      @JsonKey(name: 'avatar_url') String avatarUrl,
      @JsonKey(name: 'updatedAt') String updatedAt,
      @JsonKey(name: 'createdAt') String createdAt,
      @JsonKey(name: 'email') String email,
      @JsonKey(name: 'loginAttempts') int loginAttempts,
      @JsonKey(name: 'avatar') String avatar});
}

/// @nodoc
class _$NavApiDocsItemImageCreatedByDataCopyWithImpl<$Res>
    implements $NavApiDocsItemImageCreatedByDataCopyWith<$Res> {
  _$NavApiDocsItemImageCreatedByDataCopyWithImpl(this._self, this._then);

  final NavApiDocsItemImageCreatedByData _self;
  final $Res Function(NavApiDocsItemImageCreatedByData) _then;

  /// Create a copy of NavApiDocsItemImageCreatedByData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sub = null,
    Object? externalProvider = null,
    Object? username = null,
    Object? name = null,
    Object? roles = null,
    Object? avatarUrl = null,
    Object? updatedAt = null,
    Object? createdAt = null,
    Object? email = null,
    Object? loginAttempts = null,
    Object? avatar = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sub: null == sub
          ? _self.sub
          : sub // ignore: cast_nullable_to_non_nullable
              as String,
      externalProvider: null == externalProvider
          ? _self.externalProvider
          : externalProvider // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _self.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      roles: null == roles
          ? _self.roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      avatarUrl: null == avatarUrl
          ? _self.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      loginAttempts: null == loginAttempts
          ? _self.loginAttempts
          : loginAttempts // ignore: cast_nullable_to_non_nullable
              as int,
      avatar: null == avatar
          ? _self.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _NavApiDocsItemImageCreatedByData
    extends NavApiDocsItemImageCreatedByData {
  const _NavApiDocsItemImageCreatedByData(
      {@JsonKey(name: 'id') this.id = '',
      @JsonKey(name: 'sub') this.sub = '',
      @JsonKey(name: 'external_provider') this.externalProvider = '',
      @JsonKey(name: 'username') this.username = '',
      @JsonKey(name: 'name') this.name = '',
      @JsonKey(name: 'roles') final List<String> roles = const <String>[],
      @JsonKey(name: 'avatar_url') this.avatarUrl = '',
      @JsonKey(name: 'updatedAt') this.updatedAt = '',
      @JsonKey(name: 'createdAt') this.createdAt = '',
      @JsonKey(name: 'email') this.email = '',
      @JsonKey(name: 'loginAttempts') this.loginAttempts = 0,
      @JsonKey(name: 'avatar') this.avatar = ''})
      : _roles = roles,
        super._();
  factory _NavApiDocsItemImageCreatedByData.fromJson(
          Map<String, dynamic> json) =>
      _$NavApiDocsItemImageCreatedByDataFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String id;
  @override
  @JsonKey(name: 'sub')
  final String sub;
  @override
  @JsonKey(name: 'external_provider')
  final String externalProvider;
  @override
  @JsonKey(name: 'username')
  final String username;
  @override
  @JsonKey(name: 'name')
  final String name;
  final List<String> _roles;
  @override
  @JsonKey(name: 'roles')
  List<String> get roles {
    if (_roles is EqualUnmodifiableListView) return _roles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_roles);
  }

  @override
  @JsonKey(name: 'avatar_url')
  final String avatarUrl;
  @override
  @JsonKey(name: 'updatedAt')
  final String updatedAt;
  @override
  @JsonKey(name: 'createdAt')
  final String createdAt;
  @override
  @JsonKey(name: 'email')
  final String email;
  @override
  @JsonKey(name: 'loginAttempts')
  final int loginAttempts;
  @override
  @JsonKey(name: 'avatar')
  final String avatar;

  /// Create a copy of NavApiDocsItemImageCreatedByData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NavApiDocsItemImageCreatedByDataCopyWith<_NavApiDocsItemImageCreatedByData>
      get copyWith => __$NavApiDocsItemImageCreatedByDataCopyWithImpl<
          _NavApiDocsItemImageCreatedByData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$NavApiDocsItemImageCreatedByDataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NavApiDocsItemImageCreatedByData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sub, sub) || other.sub == sub) &&
            (identical(other.externalProvider, externalProvider) ||
                other.externalProvider == externalProvider) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._roles, _roles) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.loginAttempts, loginAttempts) ||
                other.loginAttempts == loginAttempts) &&
            (identical(other.avatar, avatar) || other.avatar == avatar));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      sub,
      externalProvider,
      username,
      name,
      const DeepCollectionEquality().hash(_roles),
      avatarUrl,
      updatedAt,
      createdAt,
      email,
      loginAttempts,
      avatar);

  @override
  String toString() {
    return 'NavApiDocsItemImageCreatedByData(id: $id, sub: $sub, externalProvider: $externalProvider, username: $username, name: $name, roles: $roles, avatarUrl: $avatarUrl, updatedAt: $updatedAt, createdAt: $createdAt, email: $email, loginAttempts: $loginAttempts, avatar: $avatar)';
  }
}

/// @nodoc
abstract mixin class _$NavApiDocsItemImageCreatedByDataCopyWith<$Res>
    implements $NavApiDocsItemImageCreatedByDataCopyWith<$Res> {
  factory _$NavApiDocsItemImageCreatedByDataCopyWith(
          _NavApiDocsItemImageCreatedByData value,
          $Res Function(_NavApiDocsItemImageCreatedByData) _then) =
      __$NavApiDocsItemImageCreatedByDataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'sub') String sub,
      @JsonKey(name: 'external_provider') String externalProvider,
      @JsonKey(name: 'username') String username,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'roles') List<String> roles,
      @JsonKey(name: 'avatar_url') String avatarUrl,
      @JsonKey(name: 'updatedAt') String updatedAt,
      @JsonKey(name: 'createdAt') String createdAt,
      @JsonKey(name: 'email') String email,
      @JsonKey(name: 'loginAttempts') int loginAttempts,
      @JsonKey(name: 'avatar') String avatar});
}

/// @nodoc
class __$NavApiDocsItemImageCreatedByDataCopyWithImpl<$Res>
    implements _$NavApiDocsItemImageCreatedByDataCopyWith<$Res> {
  __$NavApiDocsItemImageCreatedByDataCopyWithImpl(this._self, this._then);

  final _NavApiDocsItemImageCreatedByData _self;
  final $Res Function(_NavApiDocsItemImageCreatedByData) _then;

  /// Create a copy of NavApiDocsItemImageCreatedByData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? sub = null,
    Object? externalProvider = null,
    Object? username = null,
    Object? name = null,
    Object? roles = null,
    Object? avatarUrl = null,
    Object? updatedAt = null,
    Object? createdAt = null,
    Object? email = null,
    Object? loginAttempts = null,
    Object? avatar = null,
  }) {
    return _then(_NavApiDocsItemImageCreatedByData(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sub: null == sub
          ? _self.sub
          : sub // ignore: cast_nullable_to_non_nullable
              as String,
      externalProvider: null == externalProvider
          ? _self.externalProvider
          : externalProvider // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _self.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      roles: null == roles
          ? _self._roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      avatarUrl: null == avatarUrl
          ? _self.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      loginAttempts: null == loginAttempts
          ? _self.loginAttempts
          : loginAttempts // ignore: cast_nullable_to_non_nullable
              as int,
      avatar: null == avatar
          ? _self.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$NavApiDocsItemImageSizesThumbnailData {
  @JsonKey(name: 'url')
  String get url;
  @JsonKey(name: 'width')
  int get width;
  @JsonKey(name: 'height')
  int get height;
  @JsonKey(name: 'mimeType')
  String get mimeType;
  @JsonKey(name: 'filesize')
  int get filesize;
  @JsonKey(name: 'filename')
  String get filename;

  /// Create a copy of NavApiDocsItemImageSizesThumbnailData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NavApiDocsItemImageSizesThumbnailDataCopyWith<
          NavApiDocsItemImageSizesThumbnailData>
      get copyWith => _$NavApiDocsItemImageSizesThumbnailDataCopyWithImpl<
              NavApiDocsItemImageSizesThumbnailData>(
          this as NavApiDocsItemImageSizesThumbnailData, _$identity);

  /// Serializes this NavApiDocsItemImageSizesThumbnailData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NavApiDocsItemImageSizesThumbnailData &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.filesize, filesize) ||
                other.filesize == filesize) &&
            (identical(other.filename, filename) ||
                other.filename == filename));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, url, width, height, mimeType, filesize, filename);

  @override
  String toString() {
    return 'NavApiDocsItemImageSizesThumbnailData(url: $url, width: $width, height: $height, mimeType: $mimeType, filesize: $filesize, filename: $filename)';
  }
}

/// @nodoc
abstract mixin class $NavApiDocsItemImageSizesThumbnailDataCopyWith<$Res> {
  factory $NavApiDocsItemImageSizesThumbnailDataCopyWith(
          NavApiDocsItemImageSizesThumbnailData value,
          $Res Function(NavApiDocsItemImageSizesThumbnailData) _then) =
      _$NavApiDocsItemImageSizesThumbnailDataCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'url') String url,
      @JsonKey(name: 'width') int width,
      @JsonKey(name: 'height') int height,
      @JsonKey(name: 'mimeType') String mimeType,
      @JsonKey(name: 'filesize') int filesize,
      @JsonKey(name: 'filename') String filename});
}

/// @nodoc
class _$NavApiDocsItemImageSizesThumbnailDataCopyWithImpl<$Res>
    implements $NavApiDocsItemImageSizesThumbnailDataCopyWith<$Res> {
  _$NavApiDocsItemImageSizesThumbnailDataCopyWithImpl(this._self, this._then);

  final NavApiDocsItemImageSizesThumbnailData _self;
  final $Res Function(NavApiDocsItemImageSizesThumbnailData) _then;

  /// Create a copy of NavApiDocsItemImageSizesThumbnailData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? width = null,
    Object? height = null,
    Object? mimeType = null,
    Object? filesize = null,
    Object? filename = null,
  }) {
    return _then(_self.copyWith(
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      width: null == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: null == mimeType
          ? _self.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      filesize: null == filesize
          ? _self.filesize
          : filesize // ignore: cast_nullable_to_non_nullable
              as int,
      filename: null == filename
          ? _self.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _NavApiDocsItemImageSizesThumbnailData
    extends NavApiDocsItemImageSizesThumbnailData {
  const _NavApiDocsItemImageSizesThumbnailData(
      {@JsonKey(name: 'url') this.url = '',
      @JsonKey(name: 'width') this.width = 0,
      @JsonKey(name: 'height') this.height = 0,
      @JsonKey(name: 'mimeType') this.mimeType = '',
      @JsonKey(name: 'filesize') this.filesize = 0,
      @JsonKey(name: 'filename') this.filename = ''})
      : super._();
  factory _NavApiDocsItemImageSizesThumbnailData.fromJson(
          Map<String, dynamic> json) =>
      _$NavApiDocsItemImageSizesThumbnailDataFromJson(json);

  @override
  @JsonKey(name: 'url')
  final String url;
  @override
  @JsonKey(name: 'width')
  final int width;
  @override
  @JsonKey(name: 'height')
  final int height;
  @override
  @JsonKey(name: 'mimeType')
  final String mimeType;
  @override
  @JsonKey(name: 'filesize')
  final int filesize;
  @override
  @JsonKey(name: 'filename')
  final String filename;

  /// Create a copy of NavApiDocsItemImageSizesThumbnailData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NavApiDocsItemImageSizesThumbnailDataCopyWith<
          _NavApiDocsItemImageSizesThumbnailData>
      get copyWith => __$NavApiDocsItemImageSizesThumbnailDataCopyWithImpl<
          _NavApiDocsItemImageSizesThumbnailData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$NavApiDocsItemImageSizesThumbnailDataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NavApiDocsItemImageSizesThumbnailData &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.filesize, filesize) ||
                other.filesize == filesize) &&
            (identical(other.filename, filename) ||
                other.filename == filename));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, url, width, height, mimeType, filesize, filename);

  @override
  String toString() {
    return 'NavApiDocsItemImageSizesThumbnailData(url: $url, width: $width, height: $height, mimeType: $mimeType, filesize: $filesize, filename: $filename)';
  }
}

/// @nodoc
abstract mixin class _$NavApiDocsItemImageSizesThumbnailDataCopyWith<$Res>
    implements $NavApiDocsItemImageSizesThumbnailDataCopyWith<$Res> {
  factory _$NavApiDocsItemImageSizesThumbnailDataCopyWith(
          _NavApiDocsItemImageSizesThumbnailData value,
          $Res Function(_NavApiDocsItemImageSizesThumbnailData) _then) =
      __$NavApiDocsItemImageSizesThumbnailDataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'url') String url,
      @JsonKey(name: 'width') int width,
      @JsonKey(name: 'height') int height,
      @JsonKey(name: 'mimeType') String mimeType,
      @JsonKey(name: 'filesize') int filesize,
      @JsonKey(name: 'filename') String filename});
}

/// @nodoc
class __$NavApiDocsItemImageSizesThumbnailDataCopyWithImpl<$Res>
    implements _$NavApiDocsItemImageSizesThumbnailDataCopyWith<$Res> {
  __$NavApiDocsItemImageSizesThumbnailDataCopyWithImpl(this._self, this._then);

  final _NavApiDocsItemImageSizesThumbnailData _self;
  final $Res Function(_NavApiDocsItemImageSizesThumbnailData) _then;

  /// Create a copy of NavApiDocsItemImageSizesThumbnailData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? url = null,
    Object? width = null,
    Object? height = null,
    Object? mimeType = null,
    Object? filesize = null,
    Object? filename = null,
  }) {
    return _then(_NavApiDocsItemImageSizesThumbnailData(
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      width: null == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: null == mimeType
          ? _self.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      filesize: null == filesize
          ? _self.filesize
          : filesize // ignore: cast_nullable_to_non_nullable
              as int,
      filename: null == filename
          ? _self.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$NavApiDocsItemImageSizesData {
  @JsonKey(name: 'thumbnail')
  NavApiDocsItemImageSizesThumbnailData get thumbnail;
  @JsonKey(name: 'preload')
  NavApiDocsItemImageSizesPreloadData get preload;
  @JsonKey(name: 'card')
  NavApiDocsItemImageSizesCardData get card;
  @JsonKey(name: 'tablet')
  NavApiDocsItemImageSizesTabletData get tablet;
  @JsonKey(name: 'avatar')
  NavApiDocsItemImageSizesAvatarData get avatar;

  /// Create a copy of NavApiDocsItemImageSizesData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NavApiDocsItemImageSizesDataCopyWith<NavApiDocsItemImageSizesData>
      get copyWith => _$NavApiDocsItemImageSizesDataCopyWithImpl<
              NavApiDocsItemImageSizesData>(
          this as NavApiDocsItemImageSizesData, _$identity);

  /// Serializes this NavApiDocsItemImageSizesData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NavApiDocsItemImageSizesData &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.preload, preload) || other.preload == preload) &&
            (identical(other.card, card) || other.card == card) &&
            (identical(other.tablet, tablet) || other.tablet == tablet) &&
            (identical(other.avatar, avatar) || other.avatar == avatar));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, thumbnail, preload, card, tablet, avatar);

  @override
  String toString() {
    return 'NavApiDocsItemImageSizesData(thumbnail: $thumbnail, preload: $preload, card: $card, tablet: $tablet, avatar: $avatar)';
  }
}

/// @nodoc
abstract mixin class $NavApiDocsItemImageSizesDataCopyWith<$Res> {
  factory $NavApiDocsItemImageSizesDataCopyWith(
          NavApiDocsItemImageSizesData value,
          $Res Function(NavApiDocsItemImageSizesData) _then) =
      _$NavApiDocsItemImageSizesDataCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'thumbnail')
      NavApiDocsItemImageSizesThumbnailData thumbnail,
      @JsonKey(name: 'preload') NavApiDocsItemImageSizesPreloadData preload,
      @JsonKey(name: 'card') NavApiDocsItemImageSizesCardData card,
      @JsonKey(name: 'tablet') NavApiDocsItemImageSizesTabletData tablet,
      @JsonKey(name: 'avatar') NavApiDocsItemImageSizesAvatarData avatar});

  $NavApiDocsItemImageSizesThumbnailDataCopyWith<$Res> get thumbnail;
  $NavApiDocsItemImageSizesPreloadDataCopyWith<$Res> get preload;
  $NavApiDocsItemImageSizesCardDataCopyWith<$Res> get card;
  $NavApiDocsItemImageSizesTabletDataCopyWith<$Res> get tablet;
  $NavApiDocsItemImageSizesAvatarDataCopyWith<$Res> get avatar;
}

/// @nodoc
class _$NavApiDocsItemImageSizesDataCopyWithImpl<$Res>
    implements $NavApiDocsItemImageSizesDataCopyWith<$Res> {
  _$NavApiDocsItemImageSizesDataCopyWithImpl(this._self, this._then);

  final NavApiDocsItemImageSizesData _self;
  final $Res Function(NavApiDocsItemImageSizesData) _then;

  /// Create a copy of NavApiDocsItemImageSizesData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? thumbnail = null,
    Object? preload = null,
    Object? card = null,
    Object? tablet = null,
    Object? avatar = null,
  }) {
    return _then(_self.copyWith(
      thumbnail: null == thumbnail
          ? _self.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as NavApiDocsItemImageSizesThumbnailData,
      preload: null == preload
          ? _self.preload
          : preload // ignore: cast_nullable_to_non_nullable
              as NavApiDocsItemImageSizesPreloadData,
      card: null == card
          ? _self.card
          : card // ignore: cast_nullable_to_non_nullable
              as NavApiDocsItemImageSizesCardData,
      tablet: null == tablet
          ? _self.tablet
          : tablet // ignore: cast_nullable_to_non_nullable
              as NavApiDocsItemImageSizesTabletData,
      avatar: null == avatar
          ? _self.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as NavApiDocsItemImageSizesAvatarData,
    ));
  }

  /// Create a copy of NavApiDocsItemImageSizesData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NavApiDocsItemImageSizesThumbnailDataCopyWith<$Res> get thumbnail {
    return $NavApiDocsItemImageSizesThumbnailDataCopyWith<$Res>(_self.thumbnail,
        (value) {
      return _then(_self.copyWith(thumbnail: value));
    });
  }

  /// Create a copy of NavApiDocsItemImageSizesData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NavApiDocsItemImageSizesPreloadDataCopyWith<$Res> get preload {
    return $NavApiDocsItemImageSizesPreloadDataCopyWith<$Res>(_self.preload,
        (value) {
      return _then(_self.copyWith(preload: value));
    });
  }

  /// Create a copy of NavApiDocsItemImageSizesData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NavApiDocsItemImageSizesCardDataCopyWith<$Res> get card {
    return $NavApiDocsItemImageSizesCardDataCopyWith<$Res>(_self.card, (value) {
      return _then(_self.copyWith(card: value));
    });
  }

  /// Create a copy of NavApiDocsItemImageSizesData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NavApiDocsItemImageSizesTabletDataCopyWith<$Res> get tablet {
    return $NavApiDocsItemImageSizesTabletDataCopyWith<$Res>(_self.tablet,
        (value) {
      return _then(_self.copyWith(tablet: value));
    });
  }

  /// Create a copy of NavApiDocsItemImageSizesData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NavApiDocsItemImageSizesAvatarDataCopyWith<$Res> get avatar {
    return $NavApiDocsItemImageSizesAvatarDataCopyWith<$Res>(_self.avatar,
        (value) {
      return _then(_self.copyWith(avatar: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _NavApiDocsItemImageSizesData extends NavApiDocsItemImageSizesData {
  const _NavApiDocsItemImageSizesData(
      {@JsonKey(name: 'thumbnail')
      this.thumbnail = const NavApiDocsItemImageSizesThumbnailData(),
      @JsonKey(name: 'preload')
      this.preload = const NavApiDocsItemImageSizesPreloadData(),
      @JsonKey(name: 'card')
      this.card = const NavApiDocsItemImageSizesCardData(),
      @JsonKey(name: 'tablet')
      this.tablet = const NavApiDocsItemImageSizesTabletData(),
      @JsonKey(name: 'avatar')
      this.avatar = const NavApiDocsItemImageSizesAvatarData()})
      : super._();
  factory _NavApiDocsItemImageSizesData.fromJson(Map<String, dynamic> json) =>
      _$NavApiDocsItemImageSizesDataFromJson(json);

  @override
  @JsonKey(name: 'thumbnail')
  final NavApiDocsItemImageSizesThumbnailData thumbnail;
  @override
  @JsonKey(name: 'preload')
  final NavApiDocsItemImageSizesPreloadData preload;
  @override
  @JsonKey(name: 'card')
  final NavApiDocsItemImageSizesCardData card;
  @override
  @JsonKey(name: 'tablet')
  final NavApiDocsItemImageSizesTabletData tablet;
  @override
  @JsonKey(name: 'avatar')
  final NavApiDocsItemImageSizesAvatarData avatar;

  /// Create a copy of NavApiDocsItemImageSizesData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NavApiDocsItemImageSizesDataCopyWith<_NavApiDocsItemImageSizesData>
      get copyWith => __$NavApiDocsItemImageSizesDataCopyWithImpl<
          _NavApiDocsItemImageSizesData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$NavApiDocsItemImageSizesDataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NavApiDocsItemImageSizesData &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.preload, preload) || other.preload == preload) &&
            (identical(other.card, card) || other.card == card) &&
            (identical(other.tablet, tablet) || other.tablet == tablet) &&
            (identical(other.avatar, avatar) || other.avatar == avatar));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, thumbnail, preload, card, tablet, avatar);

  @override
  String toString() {
    return 'NavApiDocsItemImageSizesData(thumbnail: $thumbnail, preload: $preload, card: $card, tablet: $tablet, avatar: $avatar)';
  }
}

/// @nodoc
abstract mixin class _$NavApiDocsItemImageSizesDataCopyWith<$Res>
    implements $NavApiDocsItemImageSizesDataCopyWith<$Res> {
  factory _$NavApiDocsItemImageSizesDataCopyWith(
          _NavApiDocsItemImageSizesData value,
          $Res Function(_NavApiDocsItemImageSizesData) _then) =
      __$NavApiDocsItemImageSizesDataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'thumbnail')
      NavApiDocsItemImageSizesThumbnailData thumbnail,
      @JsonKey(name: 'preload') NavApiDocsItemImageSizesPreloadData preload,
      @JsonKey(name: 'card') NavApiDocsItemImageSizesCardData card,
      @JsonKey(name: 'tablet') NavApiDocsItemImageSizesTabletData tablet,
      @JsonKey(name: 'avatar') NavApiDocsItemImageSizesAvatarData avatar});

  @override
  $NavApiDocsItemImageSizesThumbnailDataCopyWith<$Res> get thumbnail;
  @override
  $NavApiDocsItemImageSizesPreloadDataCopyWith<$Res> get preload;
  @override
  $NavApiDocsItemImageSizesCardDataCopyWith<$Res> get card;
  @override
  $NavApiDocsItemImageSizesTabletDataCopyWith<$Res> get tablet;
  @override
  $NavApiDocsItemImageSizesAvatarDataCopyWith<$Res> get avatar;
}

/// @nodoc
class __$NavApiDocsItemImageSizesDataCopyWithImpl<$Res>
    implements _$NavApiDocsItemImageSizesDataCopyWith<$Res> {
  __$NavApiDocsItemImageSizesDataCopyWithImpl(this._self, this._then);

  final _NavApiDocsItemImageSizesData _self;
  final $Res Function(_NavApiDocsItemImageSizesData) _then;

  /// Create a copy of NavApiDocsItemImageSizesData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? thumbnail = null,
    Object? preload = null,
    Object? card = null,
    Object? tablet = null,
    Object? avatar = null,
  }) {
    return _then(_NavApiDocsItemImageSizesData(
      thumbnail: null == thumbnail
          ? _self.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as NavApiDocsItemImageSizesThumbnailData,
      preload: null == preload
          ? _self.preload
          : preload // ignore: cast_nullable_to_non_nullable
              as NavApiDocsItemImageSizesPreloadData,
      card: null == card
          ? _self.card
          : card // ignore: cast_nullable_to_non_nullable
              as NavApiDocsItemImageSizesCardData,
      tablet: null == tablet
          ? _self.tablet
          : tablet // ignore: cast_nullable_to_non_nullable
              as NavApiDocsItemImageSizesTabletData,
      avatar: null == avatar
          ? _self.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as NavApiDocsItemImageSizesAvatarData,
    ));
  }

  /// Create a copy of NavApiDocsItemImageSizesData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NavApiDocsItemImageSizesThumbnailDataCopyWith<$Res> get thumbnail {
    return $NavApiDocsItemImageSizesThumbnailDataCopyWith<$Res>(_self.thumbnail,
        (value) {
      return _then(_self.copyWith(thumbnail: value));
    });
  }

  /// Create a copy of NavApiDocsItemImageSizesData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NavApiDocsItemImageSizesPreloadDataCopyWith<$Res> get preload {
    return $NavApiDocsItemImageSizesPreloadDataCopyWith<$Res>(_self.preload,
        (value) {
      return _then(_self.copyWith(preload: value));
    });
  }

  /// Create a copy of NavApiDocsItemImageSizesData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NavApiDocsItemImageSizesCardDataCopyWith<$Res> get card {
    return $NavApiDocsItemImageSizesCardDataCopyWith<$Res>(_self.card, (value) {
      return _then(_self.copyWith(card: value));
    });
  }

  /// Create a copy of NavApiDocsItemImageSizesData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NavApiDocsItemImageSizesTabletDataCopyWith<$Res> get tablet {
    return $NavApiDocsItemImageSizesTabletDataCopyWith<$Res>(_self.tablet,
        (value) {
      return _then(_self.copyWith(tablet: value));
    });
  }

  /// Create a copy of NavApiDocsItemImageSizesData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NavApiDocsItemImageSizesAvatarDataCopyWith<$Res> get avatar {
    return $NavApiDocsItemImageSizesAvatarDataCopyWith<$Res>(_self.avatar,
        (value) {
      return _then(_self.copyWith(avatar: value));
    });
  }
}

/// @nodoc
mixin _$NavApiDocsItemImageSizesPreloadData {
  @JsonKey(name: 'url')
  dynamic get url;
  @JsonKey(name: 'width')
  dynamic get width;
  @JsonKey(name: 'height')
  dynamic get height;
  @JsonKey(name: 'mimeType')
  dynamic get mimeType;
  @JsonKey(name: 'filesize')
  dynamic get filesize;
  @JsonKey(name: 'filename')
  dynamic get filename;

  /// Create a copy of NavApiDocsItemImageSizesPreloadData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NavApiDocsItemImageSizesPreloadDataCopyWith<
          NavApiDocsItemImageSizesPreloadData>
      get copyWith => _$NavApiDocsItemImageSizesPreloadDataCopyWithImpl<
              NavApiDocsItemImageSizesPreloadData>(
          this as NavApiDocsItemImageSizesPreloadData, _$identity);

  /// Serializes this NavApiDocsItemImageSizesPreloadData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NavApiDocsItemImageSizesPreloadData &&
            const DeepCollectionEquality().equals(other.url, url) &&
            const DeepCollectionEquality().equals(other.width, width) &&
            const DeepCollectionEquality().equals(other.height, height) &&
            const DeepCollectionEquality().equals(other.mimeType, mimeType) &&
            const DeepCollectionEquality().equals(other.filesize, filesize) &&
            const DeepCollectionEquality().equals(other.filename, filename));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(url),
      const DeepCollectionEquality().hash(width),
      const DeepCollectionEquality().hash(height),
      const DeepCollectionEquality().hash(mimeType),
      const DeepCollectionEquality().hash(filesize),
      const DeepCollectionEquality().hash(filename));

  @override
  String toString() {
    return 'NavApiDocsItemImageSizesPreloadData(url: $url, width: $width, height: $height, mimeType: $mimeType, filesize: $filesize, filename: $filename)';
  }
}

/// @nodoc
abstract mixin class $NavApiDocsItemImageSizesPreloadDataCopyWith<$Res> {
  factory $NavApiDocsItemImageSizesPreloadDataCopyWith(
          NavApiDocsItemImageSizesPreloadData value,
          $Res Function(NavApiDocsItemImageSizesPreloadData) _then) =
      _$NavApiDocsItemImageSizesPreloadDataCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'url') dynamic url,
      @JsonKey(name: 'width') dynamic width,
      @JsonKey(name: 'height') dynamic height,
      @JsonKey(name: 'mimeType') dynamic mimeType,
      @JsonKey(name: 'filesize') dynamic filesize,
      @JsonKey(name: 'filename') dynamic filename});
}

/// @nodoc
class _$NavApiDocsItemImageSizesPreloadDataCopyWithImpl<$Res>
    implements $NavApiDocsItemImageSizesPreloadDataCopyWith<$Res> {
  _$NavApiDocsItemImageSizesPreloadDataCopyWithImpl(this._self, this._then);

  final NavApiDocsItemImageSizesPreloadData _self;
  final $Res Function(NavApiDocsItemImageSizesPreloadData) _then;

  /// Create a copy of NavApiDocsItemImageSizesPreloadData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? mimeType = freezed,
    Object? filesize = freezed,
    Object? filename = freezed,
  }) {
    return _then(_self.copyWith(
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as dynamic,
      width: freezed == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as dynamic,
      height: freezed == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as dynamic,
      mimeType: freezed == mimeType
          ? _self.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as dynamic,
      filesize: freezed == filesize
          ? _self.filesize
          : filesize // ignore: cast_nullable_to_non_nullable
              as dynamic,
      filename: freezed == filename
          ? _self.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _NavApiDocsItemImageSizesPreloadData
    extends NavApiDocsItemImageSizesPreloadData {
  const _NavApiDocsItemImageSizesPreloadData(
      {@JsonKey(name: 'url') this.url,
      @JsonKey(name: 'width') this.width,
      @JsonKey(name: 'height') this.height,
      @JsonKey(name: 'mimeType') this.mimeType,
      @JsonKey(name: 'filesize') this.filesize,
      @JsonKey(name: 'filename') this.filename})
      : super._();
  factory _NavApiDocsItemImageSizesPreloadData.fromJson(
          Map<String, dynamic> json) =>
      _$NavApiDocsItemImageSizesPreloadDataFromJson(json);

  @override
  @JsonKey(name: 'url')
  final dynamic url;
  @override
  @JsonKey(name: 'width')
  final dynamic width;
  @override
  @JsonKey(name: 'height')
  final dynamic height;
  @override
  @JsonKey(name: 'mimeType')
  final dynamic mimeType;
  @override
  @JsonKey(name: 'filesize')
  final dynamic filesize;
  @override
  @JsonKey(name: 'filename')
  final dynamic filename;

  /// Create a copy of NavApiDocsItemImageSizesPreloadData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NavApiDocsItemImageSizesPreloadDataCopyWith<
          _NavApiDocsItemImageSizesPreloadData>
      get copyWith => __$NavApiDocsItemImageSizesPreloadDataCopyWithImpl<
          _NavApiDocsItemImageSizesPreloadData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$NavApiDocsItemImageSizesPreloadDataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NavApiDocsItemImageSizesPreloadData &&
            const DeepCollectionEquality().equals(other.url, url) &&
            const DeepCollectionEquality().equals(other.width, width) &&
            const DeepCollectionEquality().equals(other.height, height) &&
            const DeepCollectionEquality().equals(other.mimeType, mimeType) &&
            const DeepCollectionEquality().equals(other.filesize, filesize) &&
            const DeepCollectionEquality().equals(other.filename, filename));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(url),
      const DeepCollectionEquality().hash(width),
      const DeepCollectionEquality().hash(height),
      const DeepCollectionEquality().hash(mimeType),
      const DeepCollectionEquality().hash(filesize),
      const DeepCollectionEquality().hash(filename));

  @override
  String toString() {
    return 'NavApiDocsItemImageSizesPreloadData(url: $url, width: $width, height: $height, mimeType: $mimeType, filesize: $filesize, filename: $filename)';
  }
}

/// @nodoc
abstract mixin class _$NavApiDocsItemImageSizesPreloadDataCopyWith<$Res>
    implements $NavApiDocsItemImageSizesPreloadDataCopyWith<$Res> {
  factory _$NavApiDocsItemImageSizesPreloadDataCopyWith(
          _NavApiDocsItemImageSizesPreloadData value,
          $Res Function(_NavApiDocsItemImageSizesPreloadData) _then) =
      __$NavApiDocsItemImageSizesPreloadDataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'url') dynamic url,
      @JsonKey(name: 'width') dynamic width,
      @JsonKey(name: 'height') dynamic height,
      @JsonKey(name: 'mimeType') dynamic mimeType,
      @JsonKey(name: 'filesize') dynamic filesize,
      @JsonKey(name: 'filename') dynamic filename});
}

/// @nodoc
class __$NavApiDocsItemImageSizesPreloadDataCopyWithImpl<$Res>
    implements _$NavApiDocsItemImageSizesPreloadDataCopyWith<$Res> {
  __$NavApiDocsItemImageSizesPreloadDataCopyWithImpl(this._self, this._then);

  final _NavApiDocsItemImageSizesPreloadData _self;
  final $Res Function(_NavApiDocsItemImageSizesPreloadData) _then;

  /// Create a copy of NavApiDocsItemImageSizesPreloadData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? url = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? mimeType = freezed,
    Object? filesize = freezed,
    Object? filename = freezed,
  }) {
    return _then(_NavApiDocsItemImageSizesPreloadData(
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as dynamic,
      width: freezed == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as dynamic,
      height: freezed == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as dynamic,
      mimeType: freezed == mimeType
          ? _self.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as dynamic,
      filesize: freezed == filesize
          ? _self.filesize
          : filesize // ignore: cast_nullable_to_non_nullable
              as dynamic,
      filename: freezed == filename
          ? _self.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
mixin _$NavApiDocsItemImageSizesCardData {
  @JsonKey(name: 'url')
  String get url;
  @JsonKey(name: 'width')
  int get width;
  @JsonKey(name: 'height')
  int get height;
  @JsonKey(name: 'mimeType')
  String get mimeType;
  @JsonKey(name: 'filesize')
  int get filesize;
  @JsonKey(name: 'filename')
  String get filename;

  /// Create a copy of NavApiDocsItemImageSizesCardData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NavApiDocsItemImageSizesCardDataCopyWith<NavApiDocsItemImageSizesCardData>
      get copyWith => _$NavApiDocsItemImageSizesCardDataCopyWithImpl<
              NavApiDocsItemImageSizesCardData>(
          this as NavApiDocsItemImageSizesCardData, _$identity);

  /// Serializes this NavApiDocsItemImageSizesCardData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NavApiDocsItemImageSizesCardData &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.filesize, filesize) ||
                other.filesize == filesize) &&
            (identical(other.filename, filename) ||
                other.filename == filename));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, url, width, height, mimeType, filesize, filename);

  @override
  String toString() {
    return 'NavApiDocsItemImageSizesCardData(url: $url, width: $width, height: $height, mimeType: $mimeType, filesize: $filesize, filename: $filename)';
  }
}

/// @nodoc
abstract mixin class $NavApiDocsItemImageSizesCardDataCopyWith<$Res> {
  factory $NavApiDocsItemImageSizesCardDataCopyWith(
          NavApiDocsItemImageSizesCardData value,
          $Res Function(NavApiDocsItemImageSizesCardData) _then) =
      _$NavApiDocsItemImageSizesCardDataCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'url') String url,
      @JsonKey(name: 'width') int width,
      @JsonKey(name: 'height') int height,
      @JsonKey(name: 'mimeType') String mimeType,
      @JsonKey(name: 'filesize') int filesize,
      @JsonKey(name: 'filename') String filename});
}

/// @nodoc
class _$NavApiDocsItemImageSizesCardDataCopyWithImpl<$Res>
    implements $NavApiDocsItemImageSizesCardDataCopyWith<$Res> {
  _$NavApiDocsItemImageSizesCardDataCopyWithImpl(this._self, this._then);

  final NavApiDocsItemImageSizesCardData _self;
  final $Res Function(NavApiDocsItemImageSizesCardData) _then;

  /// Create a copy of NavApiDocsItemImageSizesCardData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? width = null,
    Object? height = null,
    Object? mimeType = null,
    Object? filesize = null,
    Object? filename = null,
  }) {
    return _then(_self.copyWith(
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      width: null == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: null == mimeType
          ? _self.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      filesize: null == filesize
          ? _self.filesize
          : filesize // ignore: cast_nullable_to_non_nullable
              as int,
      filename: null == filename
          ? _self.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _NavApiDocsItemImageSizesCardData
    extends NavApiDocsItemImageSizesCardData {
  const _NavApiDocsItemImageSizesCardData(
      {@JsonKey(name: 'url') this.url = '',
      @JsonKey(name: 'width') this.width = 0,
      @JsonKey(name: 'height') this.height = 0,
      @JsonKey(name: 'mimeType') this.mimeType = '',
      @JsonKey(name: 'filesize') this.filesize = 0,
      @JsonKey(name: 'filename') this.filename = ''})
      : super._();
  factory _NavApiDocsItemImageSizesCardData.fromJson(
          Map<String, dynamic> json) =>
      _$NavApiDocsItemImageSizesCardDataFromJson(json);

  @override
  @JsonKey(name: 'url')
  final String url;
  @override
  @JsonKey(name: 'width')
  final int width;
  @override
  @JsonKey(name: 'height')
  final int height;
  @override
  @JsonKey(name: 'mimeType')
  final String mimeType;
  @override
  @JsonKey(name: 'filesize')
  final int filesize;
  @override
  @JsonKey(name: 'filename')
  final String filename;

  /// Create a copy of NavApiDocsItemImageSizesCardData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NavApiDocsItemImageSizesCardDataCopyWith<_NavApiDocsItemImageSizesCardData>
      get copyWith => __$NavApiDocsItemImageSizesCardDataCopyWithImpl<
          _NavApiDocsItemImageSizesCardData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$NavApiDocsItemImageSizesCardDataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NavApiDocsItemImageSizesCardData &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.filesize, filesize) ||
                other.filesize == filesize) &&
            (identical(other.filename, filename) ||
                other.filename == filename));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, url, width, height, mimeType, filesize, filename);

  @override
  String toString() {
    return 'NavApiDocsItemImageSizesCardData(url: $url, width: $width, height: $height, mimeType: $mimeType, filesize: $filesize, filename: $filename)';
  }
}

/// @nodoc
abstract mixin class _$NavApiDocsItemImageSizesCardDataCopyWith<$Res>
    implements $NavApiDocsItemImageSizesCardDataCopyWith<$Res> {
  factory _$NavApiDocsItemImageSizesCardDataCopyWith(
          _NavApiDocsItemImageSizesCardData value,
          $Res Function(_NavApiDocsItemImageSizesCardData) _then) =
      __$NavApiDocsItemImageSizesCardDataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'url') String url,
      @JsonKey(name: 'width') int width,
      @JsonKey(name: 'height') int height,
      @JsonKey(name: 'mimeType') String mimeType,
      @JsonKey(name: 'filesize') int filesize,
      @JsonKey(name: 'filename') String filename});
}

/// @nodoc
class __$NavApiDocsItemImageSizesCardDataCopyWithImpl<$Res>
    implements _$NavApiDocsItemImageSizesCardDataCopyWith<$Res> {
  __$NavApiDocsItemImageSizesCardDataCopyWithImpl(this._self, this._then);

  final _NavApiDocsItemImageSizesCardData _self;
  final $Res Function(_NavApiDocsItemImageSizesCardData) _then;

  /// Create a copy of NavApiDocsItemImageSizesCardData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? url = null,
    Object? width = null,
    Object? height = null,
    Object? mimeType = null,
    Object? filesize = null,
    Object? filename = null,
  }) {
    return _then(_NavApiDocsItemImageSizesCardData(
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      width: null == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: null == mimeType
          ? _self.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      filesize: null == filesize
          ? _self.filesize
          : filesize // ignore: cast_nullable_to_non_nullable
              as int,
      filename: null == filename
          ? _self.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$NavApiDocsItemImageSizesTabletData {
  @JsonKey(name: 'url')
  String get url;
  @JsonKey(name: 'width')
  int get width;
  @JsonKey(name: 'height')
  int get height;
  @JsonKey(name: 'mimeType')
  String get mimeType;
  @JsonKey(name: 'filesize')
  int get filesize;
  @JsonKey(name: 'filename')
  String get filename;

  /// Create a copy of NavApiDocsItemImageSizesTabletData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NavApiDocsItemImageSizesTabletDataCopyWith<
          NavApiDocsItemImageSizesTabletData>
      get copyWith => _$NavApiDocsItemImageSizesTabletDataCopyWithImpl<
              NavApiDocsItemImageSizesTabletData>(
          this as NavApiDocsItemImageSizesTabletData, _$identity);

  /// Serializes this NavApiDocsItemImageSizesTabletData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NavApiDocsItemImageSizesTabletData &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.filesize, filesize) ||
                other.filesize == filesize) &&
            (identical(other.filename, filename) ||
                other.filename == filename));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, url, width, height, mimeType, filesize, filename);

  @override
  String toString() {
    return 'NavApiDocsItemImageSizesTabletData(url: $url, width: $width, height: $height, mimeType: $mimeType, filesize: $filesize, filename: $filename)';
  }
}

/// @nodoc
abstract mixin class $NavApiDocsItemImageSizesTabletDataCopyWith<$Res> {
  factory $NavApiDocsItemImageSizesTabletDataCopyWith(
          NavApiDocsItemImageSizesTabletData value,
          $Res Function(NavApiDocsItemImageSizesTabletData) _then) =
      _$NavApiDocsItemImageSizesTabletDataCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'url') String url,
      @JsonKey(name: 'width') int width,
      @JsonKey(name: 'height') int height,
      @JsonKey(name: 'mimeType') String mimeType,
      @JsonKey(name: 'filesize') int filesize,
      @JsonKey(name: 'filename') String filename});
}

/// @nodoc
class _$NavApiDocsItemImageSizesTabletDataCopyWithImpl<$Res>
    implements $NavApiDocsItemImageSizesTabletDataCopyWith<$Res> {
  _$NavApiDocsItemImageSizesTabletDataCopyWithImpl(this._self, this._then);

  final NavApiDocsItemImageSizesTabletData _self;
  final $Res Function(NavApiDocsItemImageSizesTabletData) _then;

  /// Create a copy of NavApiDocsItemImageSizesTabletData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? width = null,
    Object? height = null,
    Object? mimeType = null,
    Object? filesize = null,
    Object? filename = null,
  }) {
    return _then(_self.copyWith(
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      width: null == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: null == mimeType
          ? _self.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      filesize: null == filesize
          ? _self.filesize
          : filesize // ignore: cast_nullable_to_non_nullable
              as int,
      filename: null == filename
          ? _self.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _NavApiDocsItemImageSizesTabletData
    extends NavApiDocsItemImageSizesTabletData {
  const _NavApiDocsItemImageSizesTabletData(
      {@JsonKey(name: 'url') this.url = '',
      @JsonKey(name: 'width') this.width = 0,
      @JsonKey(name: 'height') this.height = 0,
      @JsonKey(name: 'mimeType') this.mimeType = '',
      @JsonKey(name: 'filesize') this.filesize = 0,
      @JsonKey(name: 'filename') this.filename = ''})
      : super._();
  factory _NavApiDocsItemImageSizesTabletData.fromJson(
          Map<String, dynamic> json) =>
      _$NavApiDocsItemImageSizesTabletDataFromJson(json);

  @override
  @JsonKey(name: 'url')
  final String url;
  @override
  @JsonKey(name: 'width')
  final int width;
  @override
  @JsonKey(name: 'height')
  final int height;
  @override
  @JsonKey(name: 'mimeType')
  final String mimeType;
  @override
  @JsonKey(name: 'filesize')
  final int filesize;
  @override
  @JsonKey(name: 'filename')
  final String filename;

  /// Create a copy of NavApiDocsItemImageSizesTabletData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NavApiDocsItemImageSizesTabletDataCopyWith<
          _NavApiDocsItemImageSizesTabletData>
      get copyWith => __$NavApiDocsItemImageSizesTabletDataCopyWithImpl<
          _NavApiDocsItemImageSizesTabletData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$NavApiDocsItemImageSizesTabletDataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NavApiDocsItemImageSizesTabletData &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.filesize, filesize) ||
                other.filesize == filesize) &&
            (identical(other.filename, filename) ||
                other.filename == filename));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, url, width, height, mimeType, filesize, filename);

  @override
  String toString() {
    return 'NavApiDocsItemImageSizesTabletData(url: $url, width: $width, height: $height, mimeType: $mimeType, filesize: $filesize, filename: $filename)';
  }
}

/// @nodoc
abstract mixin class _$NavApiDocsItemImageSizesTabletDataCopyWith<$Res>
    implements $NavApiDocsItemImageSizesTabletDataCopyWith<$Res> {
  factory _$NavApiDocsItemImageSizesTabletDataCopyWith(
          _NavApiDocsItemImageSizesTabletData value,
          $Res Function(_NavApiDocsItemImageSizesTabletData) _then) =
      __$NavApiDocsItemImageSizesTabletDataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'url') String url,
      @JsonKey(name: 'width') int width,
      @JsonKey(name: 'height') int height,
      @JsonKey(name: 'mimeType') String mimeType,
      @JsonKey(name: 'filesize') int filesize,
      @JsonKey(name: 'filename') String filename});
}

/// @nodoc
class __$NavApiDocsItemImageSizesTabletDataCopyWithImpl<$Res>
    implements _$NavApiDocsItemImageSizesTabletDataCopyWith<$Res> {
  __$NavApiDocsItemImageSizesTabletDataCopyWithImpl(this._self, this._then);

  final _NavApiDocsItemImageSizesTabletData _self;
  final $Res Function(_NavApiDocsItemImageSizesTabletData) _then;

  /// Create a copy of NavApiDocsItemImageSizesTabletData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? url = null,
    Object? width = null,
    Object? height = null,
    Object? mimeType = null,
    Object? filesize = null,
    Object? filename = null,
  }) {
    return _then(_NavApiDocsItemImageSizesTabletData(
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      width: null == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: null == mimeType
          ? _self.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      filesize: null == filesize
          ? _self.filesize
          : filesize // ignore: cast_nullable_to_non_nullable
              as int,
      filename: null == filename
          ? _self.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$NavApiDocsItemImageSizesAvatarData {
  @JsonKey(name: 'url')
  String get url;
  @JsonKey(name: 'width')
  int get width;
  @JsonKey(name: 'height')
  int get height;
  @JsonKey(name: 'mimeType')
  String get mimeType;
  @JsonKey(name: 'filesize')
  int get filesize;
  @JsonKey(name: 'filename')
  String get filename;

  /// Create a copy of NavApiDocsItemImageSizesAvatarData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NavApiDocsItemImageSizesAvatarDataCopyWith<
          NavApiDocsItemImageSizesAvatarData>
      get copyWith => _$NavApiDocsItemImageSizesAvatarDataCopyWithImpl<
              NavApiDocsItemImageSizesAvatarData>(
          this as NavApiDocsItemImageSizesAvatarData, _$identity);

  /// Serializes this NavApiDocsItemImageSizesAvatarData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NavApiDocsItemImageSizesAvatarData &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.filesize, filesize) ||
                other.filesize == filesize) &&
            (identical(other.filename, filename) ||
                other.filename == filename));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, url, width, height, mimeType, filesize, filename);

  @override
  String toString() {
    return 'NavApiDocsItemImageSizesAvatarData(url: $url, width: $width, height: $height, mimeType: $mimeType, filesize: $filesize, filename: $filename)';
  }
}

/// @nodoc
abstract mixin class $NavApiDocsItemImageSizesAvatarDataCopyWith<$Res> {
  factory $NavApiDocsItemImageSizesAvatarDataCopyWith(
          NavApiDocsItemImageSizesAvatarData value,
          $Res Function(NavApiDocsItemImageSizesAvatarData) _then) =
      _$NavApiDocsItemImageSizesAvatarDataCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'url') String url,
      @JsonKey(name: 'width') int width,
      @JsonKey(name: 'height') int height,
      @JsonKey(name: 'mimeType') String mimeType,
      @JsonKey(name: 'filesize') int filesize,
      @JsonKey(name: 'filename') String filename});
}

/// @nodoc
class _$NavApiDocsItemImageSizesAvatarDataCopyWithImpl<$Res>
    implements $NavApiDocsItemImageSizesAvatarDataCopyWith<$Res> {
  _$NavApiDocsItemImageSizesAvatarDataCopyWithImpl(this._self, this._then);

  final NavApiDocsItemImageSizesAvatarData _self;
  final $Res Function(NavApiDocsItemImageSizesAvatarData) _then;

  /// Create a copy of NavApiDocsItemImageSizesAvatarData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? width = null,
    Object? height = null,
    Object? mimeType = null,
    Object? filesize = null,
    Object? filename = null,
  }) {
    return _then(_self.copyWith(
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      width: null == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: null == mimeType
          ? _self.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      filesize: null == filesize
          ? _self.filesize
          : filesize // ignore: cast_nullable_to_non_nullable
              as int,
      filename: null == filename
          ? _self.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _NavApiDocsItemImageSizesAvatarData
    extends NavApiDocsItemImageSizesAvatarData {
  const _NavApiDocsItemImageSizesAvatarData(
      {@JsonKey(name: 'url') this.url = '',
      @JsonKey(name: 'width') this.width = 0,
      @JsonKey(name: 'height') this.height = 0,
      @JsonKey(name: 'mimeType') this.mimeType = '',
      @JsonKey(name: 'filesize') this.filesize = 0,
      @JsonKey(name: 'filename') this.filename = ''})
      : super._();
  factory _NavApiDocsItemImageSizesAvatarData.fromJson(
          Map<String, dynamic> json) =>
      _$NavApiDocsItemImageSizesAvatarDataFromJson(json);

  @override
  @JsonKey(name: 'url')
  final String url;
  @override
  @JsonKey(name: 'width')
  final int width;
  @override
  @JsonKey(name: 'height')
  final int height;
  @override
  @JsonKey(name: 'mimeType')
  final String mimeType;
  @override
  @JsonKey(name: 'filesize')
  final int filesize;
  @override
  @JsonKey(name: 'filename')
  final String filename;

  /// Create a copy of NavApiDocsItemImageSizesAvatarData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NavApiDocsItemImageSizesAvatarDataCopyWith<
          _NavApiDocsItemImageSizesAvatarData>
      get copyWith => __$NavApiDocsItemImageSizesAvatarDataCopyWithImpl<
          _NavApiDocsItemImageSizesAvatarData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$NavApiDocsItemImageSizesAvatarDataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NavApiDocsItemImageSizesAvatarData &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.filesize, filesize) ||
                other.filesize == filesize) &&
            (identical(other.filename, filename) ||
                other.filename == filename));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, url, width, height, mimeType, filesize, filename);

  @override
  String toString() {
    return 'NavApiDocsItemImageSizesAvatarData(url: $url, width: $width, height: $height, mimeType: $mimeType, filesize: $filesize, filename: $filename)';
  }
}

/// @nodoc
abstract mixin class _$NavApiDocsItemImageSizesAvatarDataCopyWith<$Res>
    implements $NavApiDocsItemImageSizesAvatarDataCopyWith<$Res> {
  factory _$NavApiDocsItemImageSizesAvatarDataCopyWith(
          _NavApiDocsItemImageSizesAvatarData value,
          $Res Function(_NavApiDocsItemImageSizesAvatarData) _then) =
      __$NavApiDocsItemImageSizesAvatarDataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'url') String url,
      @JsonKey(name: 'width') int width,
      @JsonKey(name: 'height') int height,
      @JsonKey(name: 'mimeType') String mimeType,
      @JsonKey(name: 'filesize') int filesize,
      @JsonKey(name: 'filename') String filename});
}

/// @nodoc
class __$NavApiDocsItemImageSizesAvatarDataCopyWithImpl<$Res>
    implements _$NavApiDocsItemImageSizesAvatarDataCopyWith<$Res> {
  __$NavApiDocsItemImageSizesAvatarDataCopyWithImpl(this._self, this._then);

  final _NavApiDocsItemImageSizesAvatarData _self;
  final $Res Function(_NavApiDocsItemImageSizesAvatarData) _then;

  /// Create a copy of NavApiDocsItemImageSizesAvatarData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? url = null,
    Object? width = null,
    Object? height = null,
    Object? mimeType = null,
    Object? filesize = null,
    Object? filename = null,
  }) {
    return _then(_NavApiDocsItemImageSizesAvatarData(
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      width: null == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: null == mimeType
          ? _self.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      filesize: null == filesize
          ? _self.filesize
          : filesize // ignore: cast_nullable_to_non_nullable
              as int,
      filename: null == filename
          ? _self.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$NavApiDocsItemTagsItemData {
  @JsonKey(name: 'id')
  String get id;
  @JsonKey(name: 'name')
  String get name;
  @JsonKey(name: 'slug')
  String get slug;
  @JsonKey(name: 'updatedAt')
  String get updatedAt;
  @JsonKey(name: 'createdAt')
  String get createdAt;

  /// Create a copy of NavApiDocsItemTagsItemData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NavApiDocsItemTagsItemDataCopyWith<NavApiDocsItemTagsItemData>
      get copyWith =>
          _$NavApiDocsItemTagsItemDataCopyWithImpl<NavApiDocsItemTagsItemData>(
              this as NavApiDocsItemTagsItemData, _$identity);

  /// Serializes this NavApiDocsItemTagsItemData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NavApiDocsItemTagsItemData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, slug, updatedAt, createdAt);

  @override
  String toString() {
    return 'NavApiDocsItemTagsItemData(id: $id, name: $name, slug: $slug, updatedAt: $updatedAt, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $NavApiDocsItemTagsItemDataCopyWith<$Res> {
  factory $NavApiDocsItemTagsItemDataCopyWith(NavApiDocsItemTagsItemData value,
          $Res Function(NavApiDocsItemTagsItemData) _then) =
      _$NavApiDocsItemTagsItemDataCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'slug') String slug,
      @JsonKey(name: 'updatedAt') String updatedAt,
      @JsonKey(name: 'createdAt') String createdAt});
}

/// @nodoc
class _$NavApiDocsItemTagsItemDataCopyWithImpl<$Res>
    implements $NavApiDocsItemTagsItemDataCopyWith<$Res> {
  _$NavApiDocsItemTagsItemDataCopyWithImpl(this._self, this._then);

  final NavApiDocsItemTagsItemData _self;
  final $Res Function(NavApiDocsItemTagsItemData) _then;

  /// Create a copy of NavApiDocsItemTagsItemData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? updatedAt = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _self.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _NavApiDocsItemTagsItemData extends NavApiDocsItemTagsItemData {
  const _NavApiDocsItemTagsItemData(
      {@JsonKey(name: 'id') this.id = '',
      @JsonKey(name: 'name') this.name = '',
      @JsonKey(name: 'slug') this.slug = '',
      @JsonKey(name: 'updatedAt') this.updatedAt = '',
      @JsonKey(name: 'createdAt') this.createdAt = ''})
      : super._();
  factory _NavApiDocsItemTagsItemData.fromJson(Map<String, dynamic> json) =>
      _$NavApiDocsItemTagsItemDataFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String id;
  @override
  @JsonKey(name: 'name')
  final String name;
  @override
  @JsonKey(name: 'slug')
  final String slug;
  @override
  @JsonKey(name: 'updatedAt')
  final String updatedAt;
  @override
  @JsonKey(name: 'createdAt')
  final String createdAt;

  /// Create a copy of NavApiDocsItemTagsItemData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NavApiDocsItemTagsItemDataCopyWith<_NavApiDocsItemTagsItemData>
      get copyWith => __$NavApiDocsItemTagsItemDataCopyWithImpl<
          _NavApiDocsItemTagsItemData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$NavApiDocsItemTagsItemDataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NavApiDocsItemTagsItemData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, slug, updatedAt, createdAt);

  @override
  String toString() {
    return 'NavApiDocsItemTagsItemData(id: $id, name: $name, slug: $slug, updatedAt: $updatedAt, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$NavApiDocsItemTagsItemDataCopyWith<$Res>
    implements $NavApiDocsItemTagsItemDataCopyWith<$Res> {
  factory _$NavApiDocsItemTagsItemDataCopyWith(
          _NavApiDocsItemTagsItemData value,
          $Res Function(_NavApiDocsItemTagsItemData) _then) =
      __$NavApiDocsItemTagsItemDataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'slug') String slug,
      @JsonKey(name: 'updatedAt') String updatedAt,
      @JsonKey(name: 'createdAt') String createdAt});
}

/// @nodoc
class __$NavApiDocsItemTagsItemDataCopyWithImpl<$Res>
    implements _$NavApiDocsItemTagsItemDataCopyWith<$Res> {
  __$NavApiDocsItemTagsItemDataCopyWithImpl(this._self, this._then);

  final _NavApiDocsItemTagsItemData _self;
  final $Res Function(_NavApiDocsItemTagsItemData) _then;

  /// Create a copy of NavApiDocsItemTagsItemData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? updatedAt = null,
    Object? createdAt = null,
  }) {
    return _then(_NavApiDocsItemTagsItemData(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _self.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$NavApiData {
  @JsonKey(name: 'docs')
  List<NavApiDocsItemData> get docs;
  @JsonKey(name: 'hasNextPage')
  bool get hasNextPage;
  @JsonKey(name: 'hasPrevPage')
  bool get hasPrevPage;
  @JsonKey(name: 'limit')
  int get limit;
  @JsonKey(name: 'nextPage')
  dynamic get nextPage;
  @JsonKey(name: 'page')
  int get page;
  @JsonKey(name: 'pagingCounter')
  int get pagingCounter;
  @JsonKey(name: 'prevPage')
  dynamic get prevPage;
  @JsonKey(name: 'totalDocs')
  int get totalDocs;
  @JsonKey(name: 'totalPages')
  int get totalPages;

  /// Create a copy of NavApiData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NavApiDataCopyWith<NavApiData> get copyWith =>
      _$NavApiDataCopyWithImpl<NavApiData>(this as NavApiData, _$identity);

  /// Serializes this NavApiData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NavApiData &&
            const DeepCollectionEquality().equals(other.docs, docs) &&
            (identical(other.hasNextPage, hasNextPage) ||
                other.hasNextPage == hasNextPage) &&
            (identical(other.hasPrevPage, hasPrevPage) ||
                other.hasPrevPage == hasPrevPage) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            const DeepCollectionEquality().equals(other.nextPage, nextPage) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.pagingCounter, pagingCounter) ||
                other.pagingCounter == pagingCounter) &&
            const DeepCollectionEquality().equals(other.prevPage, prevPage) &&
            (identical(other.totalDocs, totalDocs) ||
                other.totalDocs == totalDocs) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(docs),
      hasNextPage,
      hasPrevPage,
      limit,
      const DeepCollectionEquality().hash(nextPage),
      page,
      pagingCounter,
      const DeepCollectionEquality().hash(prevPage),
      totalDocs,
      totalPages);

  @override
  String toString() {
    return 'NavApiData(docs: $docs, hasNextPage: $hasNextPage, hasPrevPage: $hasPrevPage, limit: $limit, nextPage: $nextPage, page: $page, pagingCounter: $pagingCounter, prevPage: $prevPage, totalDocs: $totalDocs, totalPages: $totalPages)';
  }
}

/// @nodoc
abstract mixin class $NavApiDataCopyWith<$Res> {
  factory $NavApiDataCopyWith(
          NavApiData value, $Res Function(NavApiData) _then) =
      _$NavApiDataCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'docs') List<NavApiDocsItemData> docs,
      @JsonKey(name: 'hasNextPage') bool hasNextPage,
      @JsonKey(name: 'hasPrevPage') bool hasPrevPage,
      @JsonKey(name: 'limit') int limit,
      @JsonKey(name: 'nextPage') dynamic nextPage,
      @JsonKey(name: 'page') int page,
      @JsonKey(name: 'pagingCounter') int pagingCounter,
      @JsonKey(name: 'prevPage') dynamic prevPage,
      @JsonKey(name: 'totalDocs') int totalDocs,
      @JsonKey(name: 'totalPages') int totalPages});
}

/// @nodoc
class _$NavApiDataCopyWithImpl<$Res> implements $NavApiDataCopyWith<$Res> {
  _$NavApiDataCopyWithImpl(this._self, this._then);

  final NavApiData _self;
  final $Res Function(NavApiData) _then;

  /// Create a copy of NavApiData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? docs = null,
    Object? hasNextPage = null,
    Object? hasPrevPage = null,
    Object? limit = null,
    Object? nextPage = freezed,
    Object? page = null,
    Object? pagingCounter = null,
    Object? prevPage = freezed,
    Object? totalDocs = null,
    Object? totalPages = null,
  }) {
    return _then(_self.copyWith(
      docs: null == docs
          ? _self.docs
          : docs // ignore: cast_nullable_to_non_nullable
              as List<NavApiDocsItemData>,
      hasNextPage: null == hasNextPage
          ? _self.hasNextPage
          : hasNextPage // ignore: cast_nullable_to_non_nullable
              as bool,
      hasPrevPage: null == hasPrevPage
          ? _self.hasPrevPage
          : hasPrevPage // ignore: cast_nullable_to_non_nullable
              as bool,
      limit: null == limit
          ? _self.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      nextPage: freezed == nextPage
          ? _self.nextPage
          : nextPage // ignore: cast_nullable_to_non_nullable
              as dynamic,
      page: null == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      pagingCounter: null == pagingCounter
          ? _self.pagingCounter
          : pagingCounter // ignore: cast_nullable_to_non_nullable
              as int,
      prevPage: freezed == prevPage
          ? _self.prevPage
          : prevPage // ignore: cast_nullable_to_non_nullable
              as dynamic,
      totalDocs: null == totalDocs
          ? _self.totalDocs
          : totalDocs // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _self.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _NavApiData extends NavApiData {
  const _NavApiData(
      {@JsonKey(name: 'docs')
      final List<NavApiDocsItemData> docs = const <NavApiDocsItemData>[],
      @JsonKey(name: 'hasNextPage') this.hasNextPage = false,
      @JsonKey(name: 'hasPrevPage') this.hasPrevPage = false,
      @JsonKey(name: 'limit') this.limit = 0,
      @JsonKey(name: 'nextPage') this.nextPage,
      @JsonKey(name: 'page') this.page = 0,
      @JsonKey(name: 'pagingCounter') this.pagingCounter = 0,
      @JsonKey(name: 'prevPage') this.prevPage,
      @JsonKey(name: 'totalDocs') this.totalDocs = 0,
      @JsonKey(name: 'totalPages') this.totalPages = 0})
      : _docs = docs,
        super._();
  factory _NavApiData.fromJson(Map<String, dynamic> json) =>
      _$NavApiDataFromJson(json);

  final List<NavApiDocsItemData> _docs;
  @override
  @JsonKey(name: 'docs')
  List<NavApiDocsItemData> get docs {
    if (_docs is EqualUnmodifiableListView) return _docs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_docs);
  }

  @override
  @JsonKey(name: 'hasNextPage')
  final bool hasNextPage;
  @override
  @JsonKey(name: 'hasPrevPage')
  final bool hasPrevPage;
  @override
  @JsonKey(name: 'limit')
  final int limit;
  @override
  @JsonKey(name: 'nextPage')
  final dynamic nextPage;
  @override
  @JsonKey(name: 'page')
  final int page;
  @override
  @JsonKey(name: 'pagingCounter')
  final int pagingCounter;
  @override
  @JsonKey(name: 'prevPage')
  final dynamic prevPage;
  @override
  @JsonKey(name: 'totalDocs')
  final int totalDocs;
  @override
  @JsonKey(name: 'totalPages')
  final int totalPages;

  /// Create a copy of NavApiData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NavApiDataCopyWith<_NavApiData> get copyWith =>
      __$NavApiDataCopyWithImpl<_NavApiData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$NavApiDataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NavApiData &&
            const DeepCollectionEquality().equals(other._docs, _docs) &&
            (identical(other.hasNextPage, hasNextPage) ||
                other.hasNextPage == hasNextPage) &&
            (identical(other.hasPrevPage, hasPrevPage) ||
                other.hasPrevPage == hasPrevPage) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            const DeepCollectionEquality().equals(other.nextPage, nextPage) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.pagingCounter, pagingCounter) ||
                other.pagingCounter == pagingCounter) &&
            const DeepCollectionEquality().equals(other.prevPage, prevPage) &&
            (identical(other.totalDocs, totalDocs) ||
                other.totalDocs == totalDocs) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_docs),
      hasNextPage,
      hasPrevPage,
      limit,
      const DeepCollectionEquality().hash(nextPage),
      page,
      pagingCounter,
      const DeepCollectionEquality().hash(prevPage),
      totalDocs,
      totalPages);

  @override
  String toString() {
    return 'NavApiData(docs: $docs, hasNextPage: $hasNextPage, hasPrevPage: $hasPrevPage, limit: $limit, nextPage: $nextPage, page: $page, pagingCounter: $pagingCounter, prevPage: $prevPage, totalDocs: $totalDocs, totalPages: $totalPages)';
  }
}

/// @nodoc
abstract mixin class _$NavApiDataCopyWith<$Res>
    implements $NavApiDataCopyWith<$Res> {
  factory _$NavApiDataCopyWith(
          _NavApiData value, $Res Function(_NavApiData) _then) =
      __$NavApiDataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'docs') List<NavApiDocsItemData> docs,
      @JsonKey(name: 'hasNextPage') bool hasNextPage,
      @JsonKey(name: 'hasPrevPage') bool hasPrevPage,
      @JsonKey(name: 'limit') int limit,
      @JsonKey(name: 'nextPage') dynamic nextPage,
      @JsonKey(name: 'page') int page,
      @JsonKey(name: 'pagingCounter') int pagingCounter,
      @JsonKey(name: 'prevPage') dynamic prevPage,
      @JsonKey(name: 'totalDocs') int totalDocs,
      @JsonKey(name: 'totalPages') int totalPages});
}

/// @nodoc
class __$NavApiDataCopyWithImpl<$Res> implements _$NavApiDataCopyWith<$Res> {
  __$NavApiDataCopyWithImpl(this._self, this._then);

  final _NavApiData _self;
  final $Res Function(_NavApiData) _then;

  /// Create a copy of NavApiData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? docs = null,
    Object? hasNextPage = null,
    Object? hasPrevPage = null,
    Object? limit = null,
    Object? nextPage = freezed,
    Object? page = null,
    Object? pagingCounter = null,
    Object? prevPage = freezed,
    Object? totalDocs = null,
    Object? totalPages = null,
  }) {
    return _then(_NavApiData(
      docs: null == docs
          ? _self._docs
          : docs // ignore: cast_nullable_to_non_nullable
              as List<NavApiDocsItemData>,
      hasNextPage: null == hasNextPage
          ? _self.hasNextPage
          : hasNextPage // ignore: cast_nullable_to_non_nullable
              as bool,
      hasPrevPage: null == hasPrevPage
          ? _self.hasPrevPage
          : hasPrevPage // ignore: cast_nullable_to_non_nullable
              as bool,
      limit: null == limit
          ? _self.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      nextPage: freezed == nextPage
          ? _self.nextPage
          : nextPage // ignore: cast_nullable_to_non_nullable
              as dynamic,
      page: null == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      pagingCounter: null == pagingCounter
          ? _self.pagingCounter
          : pagingCounter // ignore: cast_nullable_to_non_nullable
              as int,
      prevPage: freezed == prevPage
          ? _self.prevPage
          : prevPage // ignore: cast_nullable_to_non_nullable
              as dynamic,
      totalDocs: null == totalDocs
          ? _self.totalDocs
          : totalDocs // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _self.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
