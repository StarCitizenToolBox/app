// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nav_api_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NavApiDocsItemData _$NavApiDocsItemDataFromJson(Map<String, dynamic> json) {
  return _NavApiDocsItemData.fromJson(json);
}

/// @nodoc
mixin _$NavApiDocsItemData {
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'slug')
  String get slug => throw _privateConstructorUsedError;
  @JsonKey(name: 'abstract')
  String get abstract_ => throw _privateConstructorUsedError;
  @JsonKey(name: 'description')
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'image')
  NavApiDocsItemImageData get image => throw _privateConstructorUsedError;
  @JsonKey(name: 'link')
  String get link => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_sponsored')
  bool get isSponsored => throw _privateConstructorUsedError;
  @JsonKey(name: 'tags')
  List<NavApiDocsItemTagsItemData> get tags =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'updatedAt')
  String get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdAt')
  String get createdAt => throw _privateConstructorUsedError;

  /// Serializes this NavApiDocsItemData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NavApiDocsItemData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NavApiDocsItemDataCopyWith<NavApiDocsItemData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NavApiDocsItemDataCopyWith<$Res> {
  factory $NavApiDocsItemDataCopyWith(
          NavApiDocsItemData value, $Res Function(NavApiDocsItemData) then) =
      _$NavApiDocsItemDataCopyWithImpl<$Res, NavApiDocsItemData>;
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
class _$NavApiDocsItemDataCopyWithImpl<$Res, $Val extends NavApiDocsItemData>
    implements $NavApiDocsItemDataCopyWith<$Res> {
  _$NavApiDocsItemDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      abstract_: null == abstract_
          ? _value.abstract_
          : abstract_ // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as NavApiDocsItemImageData,
      link: null == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String,
      isSponsored: null == isSponsored
          ? _value.isSponsored
          : isSponsored // ignore: cast_nullable_to_non_nullable
              as bool,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<NavApiDocsItemTagsItemData>,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of NavApiDocsItemData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NavApiDocsItemImageDataCopyWith<$Res> get image {
    return $NavApiDocsItemImageDataCopyWith<$Res>(_value.image, (value) {
      return _then(_value.copyWith(image: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NavApiDocsItemDataImplCopyWith<$Res>
    implements $NavApiDocsItemDataCopyWith<$Res> {
  factory _$$NavApiDocsItemDataImplCopyWith(_$NavApiDocsItemDataImpl value,
          $Res Function(_$NavApiDocsItemDataImpl) then) =
      __$$NavApiDocsItemDataImplCopyWithImpl<$Res>;
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
class __$$NavApiDocsItemDataImplCopyWithImpl<$Res>
    extends _$NavApiDocsItemDataCopyWithImpl<$Res, _$NavApiDocsItemDataImpl>
    implements _$$NavApiDocsItemDataImplCopyWith<$Res> {
  __$$NavApiDocsItemDataImplCopyWithImpl(_$NavApiDocsItemDataImpl _value,
      $Res Function(_$NavApiDocsItemDataImpl) _then)
      : super(_value, _then);

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
    return _then(_$NavApiDocsItemDataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      abstract_: null == abstract_
          ? _value.abstract_
          : abstract_ // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as NavApiDocsItemImageData,
      link: null == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String,
      isSponsored: null == isSponsored
          ? _value.isSponsored
          : isSponsored // ignore: cast_nullable_to_non_nullable
              as bool,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<NavApiDocsItemTagsItemData>,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NavApiDocsItemDataImpl extends _NavApiDocsItemData {
  const _$NavApiDocsItemDataImpl(
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

  factory _$NavApiDocsItemDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$NavApiDocsItemDataImplFromJson(json);

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

  @override
  String toString() {
    return 'NavApiDocsItemData(id: $id, name: $name, slug: $slug, abstract_: $abstract_, description: $description, image: $image, link: $link, isSponsored: $isSponsored, tags: $tags, updatedAt: $updatedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NavApiDocsItemDataImpl &&
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

  /// Create a copy of NavApiDocsItemData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NavApiDocsItemDataImplCopyWith<_$NavApiDocsItemDataImpl> get copyWith =>
      __$$NavApiDocsItemDataImplCopyWithImpl<_$NavApiDocsItemDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NavApiDocsItemDataImplToJson(
      this,
    );
  }
}

abstract class _NavApiDocsItemData extends NavApiDocsItemData {
  const factory _NavApiDocsItemData(
          {@JsonKey(name: 'id') final String id,
          @JsonKey(name: 'name') final String name,
          @JsonKey(name: 'slug') final String slug,
          @JsonKey(name: 'abstract') final String abstract_,
          @JsonKey(name: 'description') final String description,
          @JsonKey(name: 'image') final NavApiDocsItemImageData image,
          @JsonKey(name: 'link') final String link,
          @JsonKey(name: 'is_sponsored') final bool isSponsored,
          @JsonKey(name: 'tags') final List<NavApiDocsItemTagsItemData> tags,
          @JsonKey(name: 'updatedAt') final String updatedAt,
          @JsonKey(name: 'createdAt') final String createdAt}) =
      _$NavApiDocsItemDataImpl;
  const _NavApiDocsItemData._() : super._();

  factory _NavApiDocsItemData.fromJson(Map<String, dynamic> json) =
      _$NavApiDocsItemDataImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String get id;
  @override
  @JsonKey(name: 'name')
  String get name;
  @override
  @JsonKey(name: 'slug')
  String get slug;
  @override
  @JsonKey(name: 'abstract')
  String get abstract_;
  @override
  @JsonKey(name: 'description')
  String get description;
  @override
  @JsonKey(name: 'image')
  NavApiDocsItemImageData get image;
  @override
  @JsonKey(name: 'link')
  String get link;
  @override
  @JsonKey(name: 'is_sponsored')
  bool get isSponsored;
  @override
  @JsonKey(name: 'tags')
  List<NavApiDocsItemTagsItemData> get tags;
  @override
  @JsonKey(name: 'updatedAt')
  String get updatedAt;
  @override
  @JsonKey(name: 'createdAt')
  String get createdAt;

  /// Create a copy of NavApiDocsItemData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NavApiDocsItemDataImplCopyWith<_$NavApiDocsItemDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NavApiDocsItemImageData _$NavApiDocsItemImageDataFromJson(
    Map<String, dynamic> json) {
  return _NavApiDocsItemImageData.fromJson(json);
}

/// @nodoc
mixin _$NavApiDocsItemImageData {
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdBy')
  NavApiDocsItemImageCreatedByData get createdBy =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'title')
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'original')
  bool get original => throw _privateConstructorUsedError;
  @JsonKey(name: 'credit')
  String get credit => throw _privateConstructorUsedError;
  @JsonKey(name: 'source')
  String get source => throw _privateConstructorUsedError;
  @JsonKey(name: 'license')
  String get license => throw _privateConstructorUsedError;
  @JsonKey(name: 'caption')
  dynamic get caption => throw _privateConstructorUsedError;
  @JsonKey(name: 'updatedAt')
  String get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdAt')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'url')
  String get url => throw _privateConstructorUsedError;
  @JsonKey(name: 'filename')
  String get filename => throw _privateConstructorUsedError;
  @JsonKey(name: 'mimeType')
  String get mimeType => throw _privateConstructorUsedError;
  @JsonKey(name: 'filesize')
  int get filesize => throw _privateConstructorUsedError;
  @JsonKey(name: 'width')
  int get width => throw _privateConstructorUsedError;
  @JsonKey(name: 'height')
  int get height => throw _privateConstructorUsedError;
  @JsonKey(name: 'sizes')
  NavApiDocsItemImageSizesData get sizes => throw _privateConstructorUsedError;

  /// Serializes this NavApiDocsItemImageData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NavApiDocsItemImageData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NavApiDocsItemImageDataCopyWith<NavApiDocsItemImageData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NavApiDocsItemImageDataCopyWith<$Res> {
  factory $NavApiDocsItemImageDataCopyWith(NavApiDocsItemImageData value,
          $Res Function(NavApiDocsItemImageData) then) =
      _$NavApiDocsItemImageDataCopyWithImpl<$Res, NavApiDocsItemImageData>;
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
class _$NavApiDocsItemImageDataCopyWithImpl<$Res,
        $Val extends NavApiDocsItemImageData>
    implements $NavApiDocsItemImageDataCopyWith<$Res> {
  _$NavApiDocsItemImageDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as NavApiDocsItemImageCreatedByData,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      original: null == original
          ? _value.original
          : original // ignore: cast_nullable_to_non_nullable
              as bool,
      credit: null == credit
          ? _value.credit
          : credit // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      license: null == license
          ? _value.license
          : license // ignore: cast_nullable_to_non_nullable
              as String,
      caption: freezed == caption
          ? _value.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as dynamic,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      filename: null == filename
          ? _value.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      filesize: null == filesize
          ? _value.filesize
          : filesize // ignore: cast_nullable_to_non_nullable
              as int,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      sizes: null == sizes
          ? _value.sizes
          : sizes // ignore: cast_nullable_to_non_nullable
              as NavApiDocsItemImageSizesData,
    ) as $Val);
  }

  /// Create a copy of NavApiDocsItemImageData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NavApiDocsItemImageCreatedByDataCopyWith<$Res> get createdBy {
    return $NavApiDocsItemImageCreatedByDataCopyWith<$Res>(_value.createdBy,
        (value) {
      return _then(_value.copyWith(createdBy: value) as $Val);
    });
  }

  /// Create a copy of NavApiDocsItemImageData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NavApiDocsItemImageSizesDataCopyWith<$Res> get sizes {
    return $NavApiDocsItemImageSizesDataCopyWith<$Res>(_value.sizes, (value) {
      return _then(_value.copyWith(sizes: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NavApiDocsItemImageDataImplCopyWith<$Res>
    implements $NavApiDocsItemImageDataCopyWith<$Res> {
  factory _$$NavApiDocsItemImageDataImplCopyWith(
          _$NavApiDocsItemImageDataImpl value,
          $Res Function(_$NavApiDocsItemImageDataImpl) then) =
      __$$NavApiDocsItemImageDataImplCopyWithImpl<$Res>;
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
class __$$NavApiDocsItemImageDataImplCopyWithImpl<$Res>
    extends _$NavApiDocsItemImageDataCopyWithImpl<$Res,
        _$NavApiDocsItemImageDataImpl>
    implements _$$NavApiDocsItemImageDataImplCopyWith<$Res> {
  __$$NavApiDocsItemImageDataImplCopyWithImpl(
      _$NavApiDocsItemImageDataImpl _value,
      $Res Function(_$NavApiDocsItemImageDataImpl) _then)
      : super(_value, _then);

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
    return _then(_$NavApiDocsItemImageDataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as NavApiDocsItemImageCreatedByData,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      original: null == original
          ? _value.original
          : original // ignore: cast_nullable_to_non_nullable
              as bool,
      credit: null == credit
          ? _value.credit
          : credit // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      license: null == license
          ? _value.license
          : license // ignore: cast_nullable_to_non_nullable
              as String,
      caption: freezed == caption
          ? _value.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as dynamic,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      filename: null == filename
          ? _value.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      filesize: null == filesize
          ? _value.filesize
          : filesize // ignore: cast_nullable_to_non_nullable
              as int,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      sizes: null == sizes
          ? _value.sizes
          : sizes // ignore: cast_nullable_to_non_nullable
              as NavApiDocsItemImageSizesData,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NavApiDocsItemImageDataImpl extends _NavApiDocsItemImageData {
  const _$NavApiDocsItemImageDataImpl(
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

  factory _$NavApiDocsItemImageDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$NavApiDocsItemImageDataImplFromJson(json);

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

  @override
  String toString() {
    return 'NavApiDocsItemImageData(id: $id, createdBy: $createdBy, title: $title, original: $original, credit: $credit, source: $source, license: $license, caption: $caption, updatedAt: $updatedAt, createdAt: $createdAt, url: $url, filename: $filename, mimeType: $mimeType, filesize: $filesize, width: $width, height: $height, sizes: $sizes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NavApiDocsItemImageDataImpl &&
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

  /// Create a copy of NavApiDocsItemImageData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NavApiDocsItemImageDataImplCopyWith<_$NavApiDocsItemImageDataImpl>
      get copyWith => __$$NavApiDocsItemImageDataImplCopyWithImpl<
          _$NavApiDocsItemImageDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NavApiDocsItemImageDataImplToJson(
      this,
    );
  }
}

abstract class _NavApiDocsItemImageData extends NavApiDocsItemImageData {
  const factory _NavApiDocsItemImageData(
          {@JsonKey(name: 'id') final String id,
          @JsonKey(name: 'createdBy')
          final NavApiDocsItemImageCreatedByData createdBy,
          @JsonKey(name: 'title') final String title,
          @JsonKey(name: 'original') final bool original,
          @JsonKey(name: 'credit') final String credit,
          @JsonKey(name: 'source') final String source,
          @JsonKey(name: 'license') final String license,
          @JsonKey(name: 'caption') final dynamic caption,
          @JsonKey(name: 'updatedAt') final String updatedAt,
          @JsonKey(name: 'createdAt') final String createdAt,
          @JsonKey(name: 'url') final String url,
          @JsonKey(name: 'filename') final String filename,
          @JsonKey(name: 'mimeType') final String mimeType,
          @JsonKey(name: 'filesize') final int filesize,
          @JsonKey(name: 'width') final int width,
          @JsonKey(name: 'height') final int height,
          @JsonKey(name: 'sizes') final NavApiDocsItemImageSizesData sizes}) =
      _$NavApiDocsItemImageDataImpl;
  const _NavApiDocsItemImageData._() : super._();

  factory _NavApiDocsItemImageData.fromJson(Map<String, dynamic> json) =
      _$NavApiDocsItemImageDataImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String get id;
  @override
  @JsonKey(name: 'createdBy')
  NavApiDocsItemImageCreatedByData get createdBy;
  @override
  @JsonKey(name: 'title')
  String get title;
  @override
  @JsonKey(name: 'original')
  bool get original;
  @override
  @JsonKey(name: 'credit')
  String get credit;
  @override
  @JsonKey(name: 'source')
  String get source;
  @override
  @JsonKey(name: 'license')
  String get license;
  @override
  @JsonKey(name: 'caption')
  dynamic get caption;
  @override
  @JsonKey(name: 'updatedAt')
  String get updatedAt;
  @override
  @JsonKey(name: 'createdAt')
  String get createdAt;
  @override
  @JsonKey(name: 'url')
  String get url;
  @override
  @JsonKey(name: 'filename')
  String get filename;
  @override
  @JsonKey(name: 'mimeType')
  String get mimeType;
  @override
  @JsonKey(name: 'filesize')
  int get filesize;
  @override
  @JsonKey(name: 'width')
  int get width;
  @override
  @JsonKey(name: 'height')
  int get height;
  @override
  @JsonKey(name: 'sizes')
  NavApiDocsItemImageSizesData get sizes;

  /// Create a copy of NavApiDocsItemImageData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NavApiDocsItemImageDataImplCopyWith<_$NavApiDocsItemImageDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

NavApiDocsItemImageCreatedByData _$NavApiDocsItemImageCreatedByDataFromJson(
    Map<String, dynamic> json) {
  return _NavApiDocsItemImageCreatedByData.fromJson(json);
}

/// @nodoc
mixin _$NavApiDocsItemImageCreatedByData {
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'sub')
  String get sub => throw _privateConstructorUsedError;
  @JsonKey(name: 'external_provider')
  String get externalProvider => throw _privateConstructorUsedError;
  @JsonKey(name: 'username')
  String get username => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'roles')
  List<String> get roles => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String get avatarUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'updatedAt')
  String get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdAt')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'email')
  String get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'loginAttempts')
  int get loginAttempts => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar')
  String get avatar => throw _privateConstructorUsedError;

  /// Serializes this NavApiDocsItemImageCreatedByData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NavApiDocsItemImageCreatedByData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NavApiDocsItemImageCreatedByDataCopyWith<NavApiDocsItemImageCreatedByData>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NavApiDocsItemImageCreatedByDataCopyWith<$Res> {
  factory $NavApiDocsItemImageCreatedByDataCopyWith(
          NavApiDocsItemImageCreatedByData value,
          $Res Function(NavApiDocsItemImageCreatedByData) then) =
      _$NavApiDocsItemImageCreatedByDataCopyWithImpl<$Res,
          NavApiDocsItemImageCreatedByData>;
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
class _$NavApiDocsItemImageCreatedByDataCopyWithImpl<$Res,
        $Val extends NavApiDocsItemImageCreatedByData>
    implements $NavApiDocsItemImageCreatedByDataCopyWith<$Res> {
  _$NavApiDocsItemImageCreatedByDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sub: null == sub
          ? _value.sub
          : sub // ignore: cast_nullable_to_non_nullable
              as String,
      externalProvider: null == externalProvider
          ? _value.externalProvider
          : externalProvider // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      roles: null == roles
          ? _value.roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      avatarUrl: null == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      loginAttempts: null == loginAttempts
          ? _value.loginAttempts
          : loginAttempts // ignore: cast_nullable_to_non_nullable
              as int,
      avatar: null == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NavApiDocsItemImageCreatedByDataImplCopyWith<$Res>
    implements $NavApiDocsItemImageCreatedByDataCopyWith<$Res> {
  factory _$$NavApiDocsItemImageCreatedByDataImplCopyWith(
          _$NavApiDocsItemImageCreatedByDataImpl value,
          $Res Function(_$NavApiDocsItemImageCreatedByDataImpl) then) =
      __$$NavApiDocsItemImageCreatedByDataImplCopyWithImpl<$Res>;
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
class __$$NavApiDocsItemImageCreatedByDataImplCopyWithImpl<$Res>
    extends _$NavApiDocsItemImageCreatedByDataCopyWithImpl<$Res,
        _$NavApiDocsItemImageCreatedByDataImpl>
    implements _$$NavApiDocsItemImageCreatedByDataImplCopyWith<$Res> {
  __$$NavApiDocsItemImageCreatedByDataImplCopyWithImpl(
      _$NavApiDocsItemImageCreatedByDataImpl _value,
      $Res Function(_$NavApiDocsItemImageCreatedByDataImpl) _then)
      : super(_value, _then);

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
    return _then(_$NavApiDocsItemImageCreatedByDataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sub: null == sub
          ? _value.sub
          : sub // ignore: cast_nullable_to_non_nullable
              as String,
      externalProvider: null == externalProvider
          ? _value.externalProvider
          : externalProvider // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      roles: null == roles
          ? _value._roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      avatarUrl: null == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      loginAttempts: null == loginAttempts
          ? _value.loginAttempts
          : loginAttempts // ignore: cast_nullable_to_non_nullable
              as int,
      avatar: null == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NavApiDocsItemImageCreatedByDataImpl
    extends _NavApiDocsItemImageCreatedByData {
  const _$NavApiDocsItemImageCreatedByDataImpl(
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

  factory _$NavApiDocsItemImageCreatedByDataImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$NavApiDocsItemImageCreatedByDataImplFromJson(json);

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

  @override
  String toString() {
    return 'NavApiDocsItemImageCreatedByData(id: $id, sub: $sub, externalProvider: $externalProvider, username: $username, name: $name, roles: $roles, avatarUrl: $avatarUrl, updatedAt: $updatedAt, createdAt: $createdAt, email: $email, loginAttempts: $loginAttempts, avatar: $avatar)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NavApiDocsItemImageCreatedByDataImpl &&
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

  /// Create a copy of NavApiDocsItemImageCreatedByData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NavApiDocsItemImageCreatedByDataImplCopyWith<
          _$NavApiDocsItemImageCreatedByDataImpl>
      get copyWith => __$$NavApiDocsItemImageCreatedByDataImplCopyWithImpl<
          _$NavApiDocsItemImageCreatedByDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NavApiDocsItemImageCreatedByDataImplToJson(
      this,
    );
  }
}

abstract class _NavApiDocsItemImageCreatedByData
    extends NavApiDocsItemImageCreatedByData {
  const factory _NavApiDocsItemImageCreatedByData(
          {@JsonKey(name: 'id') final String id,
          @JsonKey(name: 'sub') final String sub,
          @JsonKey(name: 'external_provider') final String externalProvider,
          @JsonKey(name: 'username') final String username,
          @JsonKey(name: 'name') final String name,
          @JsonKey(name: 'roles') final List<String> roles,
          @JsonKey(name: 'avatar_url') final String avatarUrl,
          @JsonKey(name: 'updatedAt') final String updatedAt,
          @JsonKey(name: 'createdAt') final String createdAt,
          @JsonKey(name: 'email') final String email,
          @JsonKey(name: 'loginAttempts') final int loginAttempts,
          @JsonKey(name: 'avatar') final String avatar}) =
      _$NavApiDocsItemImageCreatedByDataImpl;
  const _NavApiDocsItemImageCreatedByData._() : super._();

  factory _NavApiDocsItemImageCreatedByData.fromJson(
          Map<String, dynamic> json) =
      _$NavApiDocsItemImageCreatedByDataImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String get id;
  @override
  @JsonKey(name: 'sub')
  String get sub;
  @override
  @JsonKey(name: 'external_provider')
  String get externalProvider;
  @override
  @JsonKey(name: 'username')
  String get username;
  @override
  @JsonKey(name: 'name')
  String get name;
  @override
  @JsonKey(name: 'roles')
  List<String> get roles;
  @override
  @JsonKey(name: 'avatar_url')
  String get avatarUrl;
  @override
  @JsonKey(name: 'updatedAt')
  String get updatedAt;
  @override
  @JsonKey(name: 'createdAt')
  String get createdAt;
  @override
  @JsonKey(name: 'email')
  String get email;
  @override
  @JsonKey(name: 'loginAttempts')
  int get loginAttempts;
  @override
  @JsonKey(name: 'avatar')
  String get avatar;

  /// Create a copy of NavApiDocsItemImageCreatedByData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NavApiDocsItemImageCreatedByDataImplCopyWith<
          _$NavApiDocsItemImageCreatedByDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

NavApiDocsItemImageSizesThumbnailData
    _$NavApiDocsItemImageSizesThumbnailDataFromJson(Map<String, dynamic> json) {
  return _NavApiDocsItemImageSizesThumbnailData.fromJson(json);
}

/// @nodoc
mixin _$NavApiDocsItemImageSizesThumbnailData {
  @JsonKey(name: 'url')
  String get url => throw _privateConstructorUsedError;
  @JsonKey(name: 'width')
  int get width => throw _privateConstructorUsedError;
  @JsonKey(name: 'height')
  int get height => throw _privateConstructorUsedError;
  @JsonKey(name: 'mimeType')
  String get mimeType => throw _privateConstructorUsedError;
  @JsonKey(name: 'filesize')
  int get filesize => throw _privateConstructorUsedError;
  @JsonKey(name: 'filename')
  String get filename => throw _privateConstructorUsedError;

  /// Serializes this NavApiDocsItemImageSizesThumbnailData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NavApiDocsItemImageSizesThumbnailData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NavApiDocsItemImageSizesThumbnailDataCopyWith<
          NavApiDocsItemImageSizesThumbnailData>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NavApiDocsItemImageSizesThumbnailDataCopyWith<$Res> {
  factory $NavApiDocsItemImageSizesThumbnailDataCopyWith(
          NavApiDocsItemImageSizesThumbnailData value,
          $Res Function(NavApiDocsItemImageSizesThumbnailData) then) =
      _$NavApiDocsItemImageSizesThumbnailDataCopyWithImpl<$Res,
          NavApiDocsItemImageSizesThumbnailData>;
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
class _$NavApiDocsItemImageSizesThumbnailDataCopyWithImpl<$Res,
        $Val extends NavApiDocsItemImageSizesThumbnailData>
    implements $NavApiDocsItemImageSizesThumbnailDataCopyWith<$Res> {
  _$NavApiDocsItemImageSizesThumbnailDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      filesize: null == filesize
          ? _value.filesize
          : filesize // ignore: cast_nullable_to_non_nullable
              as int,
      filename: null == filename
          ? _value.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NavApiDocsItemImageSizesThumbnailDataImplCopyWith<$Res>
    implements $NavApiDocsItemImageSizesThumbnailDataCopyWith<$Res> {
  factory _$$NavApiDocsItemImageSizesThumbnailDataImplCopyWith(
          _$NavApiDocsItemImageSizesThumbnailDataImpl value,
          $Res Function(_$NavApiDocsItemImageSizesThumbnailDataImpl) then) =
      __$$NavApiDocsItemImageSizesThumbnailDataImplCopyWithImpl<$Res>;
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
class __$$NavApiDocsItemImageSizesThumbnailDataImplCopyWithImpl<$Res>
    extends _$NavApiDocsItemImageSizesThumbnailDataCopyWithImpl<$Res,
        _$NavApiDocsItemImageSizesThumbnailDataImpl>
    implements _$$NavApiDocsItemImageSizesThumbnailDataImplCopyWith<$Res> {
  __$$NavApiDocsItemImageSizesThumbnailDataImplCopyWithImpl(
      _$NavApiDocsItemImageSizesThumbnailDataImpl _value,
      $Res Function(_$NavApiDocsItemImageSizesThumbnailDataImpl) _then)
      : super(_value, _then);

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
    return _then(_$NavApiDocsItemImageSizesThumbnailDataImpl(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      filesize: null == filesize
          ? _value.filesize
          : filesize // ignore: cast_nullable_to_non_nullable
              as int,
      filename: null == filename
          ? _value.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NavApiDocsItemImageSizesThumbnailDataImpl
    extends _NavApiDocsItemImageSizesThumbnailData {
  const _$NavApiDocsItemImageSizesThumbnailDataImpl(
      {@JsonKey(name: 'url') this.url = '',
      @JsonKey(name: 'width') this.width = 0,
      @JsonKey(name: 'height') this.height = 0,
      @JsonKey(name: 'mimeType') this.mimeType = '',
      @JsonKey(name: 'filesize') this.filesize = 0,
      @JsonKey(name: 'filename') this.filename = ''})
      : super._();

  factory _$NavApiDocsItemImageSizesThumbnailDataImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$NavApiDocsItemImageSizesThumbnailDataImplFromJson(json);

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

  @override
  String toString() {
    return 'NavApiDocsItemImageSizesThumbnailData(url: $url, width: $width, height: $height, mimeType: $mimeType, filesize: $filesize, filename: $filename)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NavApiDocsItemImageSizesThumbnailDataImpl &&
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

  /// Create a copy of NavApiDocsItemImageSizesThumbnailData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NavApiDocsItemImageSizesThumbnailDataImplCopyWith<
          _$NavApiDocsItemImageSizesThumbnailDataImpl>
      get copyWith => __$$NavApiDocsItemImageSizesThumbnailDataImplCopyWithImpl<
          _$NavApiDocsItemImageSizesThumbnailDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NavApiDocsItemImageSizesThumbnailDataImplToJson(
      this,
    );
  }
}

abstract class _NavApiDocsItemImageSizesThumbnailData
    extends NavApiDocsItemImageSizesThumbnailData {
  const factory _NavApiDocsItemImageSizesThumbnailData(
          {@JsonKey(name: 'url') final String url,
          @JsonKey(name: 'width') final int width,
          @JsonKey(name: 'height') final int height,
          @JsonKey(name: 'mimeType') final String mimeType,
          @JsonKey(name: 'filesize') final int filesize,
          @JsonKey(name: 'filename') final String filename}) =
      _$NavApiDocsItemImageSizesThumbnailDataImpl;
  const _NavApiDocsItemImageSizesThumbnailData._() : super._();

  factory _NavApiDocsItemImageSizesThumbnailData.fromJson(
          Map<String, dynamic> json) =
      _$NavApiDocsItemImageSizesThumbnailDataImpl.fromJson;

  @override
  @JsonKey(name: 'url')
  String get url;
  @override
  @JsonKey(name: 'width')
  int get width;
  @override
  @JsonKey(name: 'height')
  int get height;
  @override
  @JsonKey(name: 'mimeType')
  String get mimeType;
  @override
  @JsonKey(name: 'filesize')
  int get filesize;
  @override
  @JsonKey(name: 'filename')
  String get filename;

  /// Create a copy of NavApiDocsItemImageSizesThumbnailData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NavApiDocsItemImageSizesThumbnailDataImplCopyWith<
          _$NavApiDocsItemImageSizesThumbnailDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

NavApiDocsItemImageSizesData _$NavApiDocsItemImageSizesDataFromJson(
    Map<String, dynamic> json) {
  return _NavApiDocsItemImageSizesData.fromJson(json);
}

/// @nodoc
mixin _$NavApiDocsItemImageSizesData {
  @JsonKey(name: 'thumbnail')
  NavApiDocsItemImageSizesThumbnailData get thumbnail =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'preload')
  NavApiDocsItemImageSizesPreloadData get preload =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'card')
  NavApiDocsItemImageSizesCardData get card =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'tablet')
  NavApiDocsItemImageSizesTabletData get tablet =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar')
  NavApiDocsItemImageSizesAvatarData get avatar =>
      throw _privateConstructorUsedError;

  /// Serializes this NavApiDocsItemImageSizesData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NavApiDocsItemImageSizesData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NavApiDocsItemImageSizesDataCopyWith<NavApiDocsItemImageSizesData>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NavApiDocsItemImageSizesDataCopyWith<$Res> {
  factory $NavApiDocsItemImageSizesDataCopyWith(
          NavApiDocsItemImageSizesData value,
          $Res Function(NavApiDocsItemImageSizesData) then) =
      _$NavApiDocsItemImageSizesDataCopyWithImpl<$Res,
          NavApiDocsItemImageSizesData>;
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
class _$NavApiDocsItemImageSizesDataCopyWithImpl<$Res,
        $Val extends NavApiDocsItemImageSizesData>
    implements $NavApiDocsItemImageSizesDataCopyWith<$Res> {
  _$NavApiDocsItemImageSizesDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      thumbnail: null == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as NavApiDocsItemImageSizesThumbnailData,
      preload: null == preload
          ? _value.preload
          : preload // ignore: cast_nullable_to_non_nullable
              as NavApiDocsItemImageSizesPreloadData,
      card: null == card
          ? _value.card
          : card // ignore: cast_nullable_to_non_nullable
              as NavApiDocsItemImageSizesCardData,
      tablet: null == tablet
          ? _value.tablet
          : tablet // ignore: cast_nullable_to_non_nullable
              as NavApiDocsItemImageSizesTabletData,
      avatar: null == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as NavApiDocsItemImageSizesAvatarData,
    ) as $Val);
  }

  /// Create a copy of NavApiDocsItemImageSizesData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NavApiDocsItemImageSizesThumbnailDataCopyWith<$Res> get thumbnail {
    return $NavApiDocsItemImageSizesThumbnailDataCopyWith<$Res>(
        _value.thumbnail, (value) {
      return _then(_value.copyWith(thumbnail: value) as $Val);
    });
  }

  /// Create a copy of NavApiDocsItemImageSizesData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NavApiDocsItemImageSizesPreloadDataCopyWith<$Res> get preload {
    return $NavApiDocsItemImageSizesPreloadDataCopyWith<$Res>(_value.preload,
        (value) {
      return _then(_value.copyWith(preload: value) as $Val);
    });
  }

  /// Create a copy of NavApiDocsItemImageSizesData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NavApiDocsItemImageSizesCardDataCopyWith<$Res> get card {
    return $NavApiDocsItemImageSizesCardDataCopyWith<$Res>(_value.card,
        (value) {
      return _then(_value.copyWith(card: value) as $Val);
    });
  }

  /// Create a copy of NavApiDocsItemImageSizesData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NavApiDocsItemImageSizesTabletDataCopyWith<$Res> get tablet {
    return $NavApiDocsItemImageSizesTabletDataCopyWith<$Res>(_value.tablet,
        (value) {
      return _then(_value.copyWith(tablet: value) as $Val);
    });
  }

  /// Create a copy of NavApiDocsItemImageSizesData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NavApiDocsItemImageSizesAvatarDataCopyWith<$Res> get avatar {
    return $NavApiDocsItemImageSizesAvatarDataCopyWith<$Res>(_value.avatar,
        (value) {
      return _then(_value.copyWith(avatar: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NavApiDocsItemImageSizesDataImplCopyWith<$Res>
    implements $NavApiDocsItemImageSizesDataCopyWith<$Res> {
  factory _$$NavApiDocsItemImageSizesDataImplCopyWith(
          _$NavApiDocsItemImageSizesDataImpl value,
          $Res Function(_$NavApiDocsItemImageSizesDataImpl) then) =
      __$$NavApiDocsItemImageSizesDataImplCopyWithImpl<$Res>;
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
class __$$NavApiDocsItemImageSizesDataImplCopyWithImpl<$Res>
    extends _$NavApiDocsItemImageSizesDataCopyWithImpl<$Res,
        _$NavApiDocsItemImageSizesDataImpl>
    implements _$$NavApiDocsItemImageSizesDataImplCopyWith<$Res> {
  __$$NavApiDocsItemImageSizesDataImplCopyWithImpl(
      _$NavApiDocsItemImageSizesDataImpl _value,
      $Res Function(_$NavApiDocsItemImageSizesDataImpl) _then)
      : super(_value, _then);

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
    return _then(_$NavApiDocsItemImageSizesDataImpl(
      thumbnail: null == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as NavApiDocsItemImageSizesThumbnailData,
      preload: null == preload
          ? _value.preload
          : preload // ignore: cast_nullable_to_non_nullable
              as NavApiDocsItemImageSizesPreloadData,
      card: null == card
          ? _value.card
          : card // ignore: cast_nullable_to_non_nullable
              as NavApiDocsItemImageSizesCardData,
      tablet: null == tablet
          ? _value.tablet
          : tablet // ignore: cast_nullable_to_non_nullable
              as NavApiDocsItemImageSizesTabletData,
      avatar: null == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as NavApiDocsItemImageSizesAvatarData,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NavApiDocsItemImageSizesDataImpl extends _NavApiDocsItemImageSizesData {
  const _$NavApiDocsItemImageSizesDataImpl(
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

  factory _$NavApiDocsItemImageSizesDataImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$NavApiDocsItemImageSizesDataImplFromJson(json);

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

  @override
  String toString() {
    return 'NavApiDocsItemImageSizesData(thumbnail: $thumbnail, preload: $preload, card: $card, tablet: $tablet, avatar: $avatar)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NavApiDocsItemImageSizesDataImpl &&
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

  /// Create a copy of NavApiDocsItemImageSizesData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NavApiDocsItemImageSizesDataImplCopyWith<
          _$NavApiDocsItemImageSizesDataImpl>
      get copyWith => __$$NavApiDocsItemImageSizesDataImplCopyWithImpl<
          _$NavApiDocsItemImageSizesDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NavApiDocsItemImageSizesDataImplToJson(
      this,
    );
  }
}

abstract class _NavApiDocsItemImageSizesData
    extends NavApiDocsItemImageSizesData {
  const factory _NavApiDocsItemImageSizesData(
      {@JsonKey(name: 'thumbnail')
      final NavApiDocsItemImageSizesThumbnailData thumbnail,
      @JsonKey(name: 'preload')
      final NavApiDocsItemImageSizesPreloadData preload,
      @JsonKey(name: 'card') final NavApiDocsItemImageSizesCardData card,
      @JsonKey(name: 'tablet') final NavApiDocsItemImageSizesTabletData tablet,
      @JsonKey(name: 'avatar')
      final NavApiDocsItemImageSizesAvatarData
          avatar}) = _$NavApiDocsItemImageSizesDataImpl;
  const _NavApiDocsItemImageSizesData._() : super._();

  factory _NavApiDocsItemImageSizesData.fromJson(Map<String, dynamic> json) =
      _$NavApiDocsItemImageSizesDataImpl.fromJson;

  @override
  @JsonKey(name: 'thumbnail')
  NavApiDocsItemImageSizesThumbnailData get thumbnail;
  @override
  @JsonKey(name: 'preload')
  NavApiDocsItemImageSizesPreloadData get preload;
  @override
  @JsonKey(name: 'card')
  NavApiDocsItemImageSizesCardData get card;
  @override
  @JsonKey(name: 'tablet')
  NavApiDocsItemImageSizesTabletData get tablet;
  @override
  @JsonKey(name: 'avatar')
  NavApiDocsItemImageSizesAvatarData get avatar;

  /// Create a copy of NavApiDocsItemImageSizesData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NavApiDocsItemImageSizesDataImplCopyWith<
          _$NavApiDocsItemImageSizesDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

NavApiDocsItemImageSizesPreloadData
    _$NavApiDocsItemImageSizesPreloadDataFromJson(Map<String, dynamic> json) {
  return _NavApiDocsItemImageSizesPreloadData.fromJson(json);
}

/// @nodoc
mixin _$NavApiDocsItemImageSizesPreloadData {
  @JsonKey(name: 'url')
  dynamic get url => throw _privateConstructorUsedError;
  @JsonKey(name: 'width')
  dynamic get width => throw _privateConstructorUsedError;
  @JsonKey(name: 'height')
  dynamic get height => throw _privateConstructorUsedError;
  @JsonKey(name: 'mimeType')
  dynamic get mimeType => throw _privateConstructorUsedError;
  @JsonKey(name: 'filesize')
  dynamic get filesize => throw _privateConstructorUsedError;
  @JsonKey(name: 'filename')
  dynamic get filename => throw _privateConstructorUsedError;

  /// Serializes this NavApiDocsItemImageSizesPreloadData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NavApiDocsItemImageSizesPreloadData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NavApiDocsItemImageSizesPreloadDataCopyWith<
          NavApiDocsItemImageSizesPreloadData>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NavApiDocsItemImageSizesPreloadDataCopyWith<$Res> {
  factory $NavApiDocsItemImageSizesPreloadDataCopyWith(
          NavApiDocsItemImageSizesPreloadData value,
          $Res Function(NavApiDocsItemImageSizesPreloadData) then) =
      _$NavApiDocsItemImageSizesPreloadDataCopyWithImpl<$Res,
          NavApiDocsItemImageSizesPreloadData>;
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
class _$NavApiDocsItemImageSizesPreloadDataCopyWithImpl<$Res,
        $Val extends NavApiDocsItemImageSizesPreloadData>
    implements $NavApiDocsItemImageSizesPreloadDataCopyWith<$Res> {
  _$NavApiDocsItemImageSizesPreloadDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as dynamic,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as dynamic,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as dynamic,
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as dynamic,
      filesize: freezed == filesize
          ? _value.filesize
          : filesize // ignore: cast_nullable_to_non_nullable
              as dynamic,
      filename: freezed == filename
          ? _value.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NavApiDocsItemImageSizesPreloadDataImplCopyWith<$Res>
    implements $NavApiDocsItemImageSizesPreloadDataCopyWith<$Res> {
  factory _$$NavApiDocsItemImageSizesPreloadDataImplCopyWith(
          _$NavApiDocsItemImageSizesPreloadDataImpl value,
          $Res Function(_$NavApiDocsItemImageSizesPreloadDataImpl) then) =
      __$$NavApiDocsItemImageSizesPreloadDataImplCopyWithImpl<$Res>;
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
class __$$NavApiDocsItemImageSizesPreloadDataImplCopyWithImpl<$Res>
    extends _$NavApiDocsItemImageSizesPreloadDataCopyWithImpl<$Res,
        _$NavApiDocsItemImageSizesPreloadDataImpl>
    implements _$$NavApiDocsItemImageSizesPreloadDataImplCopyWith<$Res> {
  __$$NavApiDocsItemImageSizesPreloadDataImplCopyWithImpl(
      _$NavApiDocsItemImageSizesPreloadDataImpl _value,
      $Res Function(_$NavApiDocsItemImageSizesPreloadDataImpl) _then)
      : super(_value, _then);

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
    return _then(_$NavApiDocsItemImageSizesPreloadDataImpl(
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as dynamic,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as dynamic,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as dynamic,
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as dynamic,
      filesize: freezed == filesize
          ? _value.filesize
          : filesize // ignore: cast_nullable_to_non_nullable
              as dynamic,
      filename: freezed == filename
          ? _value.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NavApiDocsItemImageSizesPreloadDataImpl
    extends _NavApiDocsItemImageSizesPreloadData {
  const _$NavApiDocsItemImageSizesPreloadDataImpl(
      {@JsonKey(name: 'url') this.url,
      @JsonKey(name: 'width') this.width,
      @JsonKey(name: 'height') this.height,
      @JsonKey(name: 'mimeType') this.mimeType,
      @JsonKey(name: 'filesize') this.filesize,
      @JsonKey(name: 'filename') this.filename})
      : super._();

  factory _$NavApiDocsItemImageSizesPreloadDataImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$NavApiDocsItemImageSizesPreloadDataImplFromJson(json);

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

  @override
  String toString() {
    return 'NavApiDocsItemImageSizesPreloadData(url: $url, width: $width, height: $height, mimeType: $mimeType, filesize: $filesize, filename: $filename)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NavApiDocsItemImageSizesPreloadDataImpl &&
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

  /// Create a copy of NavApiDocsItemImageSizesPreloadData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NavApiDocsItemImageSizesPreloadDataImplCopyWith<
          _$NavApiDocsItemImageSizesPreloadDataImpl>
      get copyWith => __$$NavApiDocsItemImageSizesPreloadDataImplCopyWithImpl<
          _$NavApiDocsItemImageSizesPreloadDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NavApiDocsItemImageSizesPreloadDataImplToJson(
      this,
    );
  }
}

abstract class _NavApiDocsItemImageSizesPreloadData
    extends NavApiDocsItemImageSizesPreloadData {
  const factory _NavApiDocsItemImageSizesPreloadData(
          {@JsonKey(name: 'url') final dynamic url,
          @JsonKey(name: 'width') final dynamic width,
          @JsonKey(name: 'height') final dynamic height,
          @JsonKey(name: 'mimeType') final dynamic mimeType,
          @JsonKey(name: 'filesize') final dynamic filesize,
          @JsonKey(name: 'filename') final dynamic filename}) =
      _$NavApiDocsItemImageSizesPreloadDataImpl;
  const _NavApiDocsItemImageSizesPreloadData._() : super._();

  factory _NavApiDocsItemImageSizesPreloadData.fromJson(
          Map<String, dynamic> json) =
      _$NavApiDocsItemImageSizesPreloadDataImpl.fromJson;

  @override
  @JsonKey(name: 'url')
  dynamic get url;
  @override
  @JsonKey(name: 'width')
  dynamic get width;
  @override
  @JsonKey(name: 'height')
  dynamic get height;
  @override
  @JsonKey(name: 'mimeType')
  dynamic get mimeType;
  @override
  @JsonKey(name: 'filesize')
  dynamic get filesize;
  @override
  @JsonKey(name: 'filename')
  dynamic get filename;

  /// Create a copy of NavApiDocsItemImageSizesPreloadData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NavApiDocsItemImageSizesPreloadDataImplCopyWith<
          _$NavApiDocsItemImageSizesPreloadDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

NavApiDocsItemImageSizesCardData _$NavApiDocsItemImageSizesCardDataFromJson(
    Map<String, dynamic> json) {
  return _NavApiDocsItemImageSizesCardData.fromJson(json);
}

/// @nodoc
mixin _$NavApiDocsItemImageSizesCardData {
  @JsonKey(name: 'url')
  String get url => throw _privateConstructorUsedError;
  @JsonKey(name: 'width')
  int get width => throw _privateConstructorUsedError;
  @JsonKey(name: 'height')
  int get height => throw _privateConstructorUsedError;
  @JsonKey(name: 'mimeType')
  String get mimeType => throw _privateConstructorUsedError;
  @JsonKey(name: 'filesize')
  int get filesize => throw _privateConstructorUsedError;
  @JsonKey(name: 'filename')
  String get filename => throw _privateConstructorUsedError;

  /// Serializes this NavApiDocsItemImageSizesCardData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NavApiDocsItemImageSizesCardData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NavApiDocsItemImageSizesCardDataCopyWith<NavApiDocsItemImageSizesCardData>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NavApiDocsItemImageSizesCardDataCopyWith<$Res> {
  factory $NavApiDocsItemImageSizesCardDataCopyWith(
          NavApiDocsItemImageSizesCardData value,
          $Res Function(NavApiDocsItemImageSizesCardData) then) =
      _$NavApiDocsItemImageSizesCardDataCopyWithImpl<$Res,
          NavApiDocsItemImageSizesCardData>;
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
class _$NavApiDocsItemImageSizesCardDataCopyWithImpl<$Res,
        $Val extends NavApiDocsItemImageSizesCardData>
    implements $NavApiDocsItemImageSizesCardDataCopyWith<$Res> {
  _$NavApiDocsItemImageSizesCardDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      filesize: null == filesize
          ? _value.filesize
          : filesize // ignore: cast_nullable_to_non_nullable
              as int,
      filename: null == filename
          ? _value.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NavApiDocsItemImageSizesCardDataImplCopyWith<$Res>
    implements $NavApiDocsItemImageSizesCardDataCopyWith<$Res> {
  factory _$$NavApiDocsItemImageSizesCardDataImplCopyWith(
          _$NavApiDocsItemImageSizesCardDataImpl value,
          $Res Function(_$NavApiDocsItemImageSizesCardDataImpl) then) =
      __$$NavApiDocsItemImageSizesCardDataImplCopyWithImpl<$Res>;
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
class __$$NavApiDocsItemImageSizesCardDataImplCopyWithImpl<$Res>
    extends _$NavApiDocsItemImageSizesCardDataCopyWithImpl<$Res,
        _$NavApiDocsItemImageSizesCardDataImpl>
    implements _$$NavApiDocsItemImageSizesCardDataImplCopyWith<$Res> {
  __$$NavApiDocsItemImageSizesCardDataImplCopyWithImpl(
      _$NavApiDocsItemImageSizesCardDataImpl _value,
      $Res Function(_$NavApiDocsItemImageSizesCardDataImpl) _then)
      : super(_value, _then);

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
    return _then(_$NavApiDocsItemImageSizesCardDataImpl(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      filesize: null == filesize
          ? _value.filesize
          : filesize // ignore: cast_nullable_to_non_nullable
              as int,
      filename: null == filename
          ? _value.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NavApiDocsItemImageSizesCardDataImpl
    extends _NavApiDocsItemImageSizesCardData {
  const _$NavApiDocsItemImageSizesCardDataImpl(
      {@JsonKey(name: 'url') this.url = '',
      @JsonKey(name: 'width') this.width = 0,
      @JsonKey(name: 'height') this.height = 0,
      @JsonKey(name: 'mimeType') this.mimeType = '',
      @JsonKey(name: 'filesize') this.filesize = 0,
      @JsonKey(name: 'filename') this.filename = ''})
      : super._();

  factory _$NavApiDocsItemImageSizesCardDataImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$NavApiDocsItemImageSizesCardDataImplFromJson(json);

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

  @override
  String toString() {
    return 'NavApiDocsItemImageSizesCardData(url: $url, width: $width, height: $height, mimeType: $mimeType, filesize: $filesize, filename: $filename)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NavApiDocsItemImageSizesCardDataImpl &&
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

  /// Create a copy of NavApiDocsItemImageSizesCardData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NavApiDocsItemImageSizesCardDataImplCopyWith<
          _$NavApiDocsItemImageSizesCardDataImpl>
      get copyWith => __$$NavApiDocsItemImageSizesCardDataImplCopyWithImpl<
          _$NavApiDocsItemImageSizesCardDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NavApiDocsItemImageSizesCardDataImplToJson(
      this,
    );
  }
}

abstract class _NavApiDocsItemImageSizesCardData
    extends NavApiDocsItemImageSizesCardData {
  const factory _NavApiDocsItemImageSizesCardData(
          {@JsonKey(name: 'url') final String url,
          @JsonKey(name: 'width') final int width,
          @JsonKey(name: 'height') final int height,
          @JsonKey(name: 'mimeType') final String mimeType,
          @JsonKey(name: 'filesize') final int filesize,
          @JsonKey(name: 'filename') final String filename}) =
      _$NavApiDocsItemImageSizesCardDataImpl;
  const _NavApiDocsItemImageSizesCardData._() : super._();

  factory _NavApiDocsItemImageSizesCardData.fromJson(
          Map<String, dynamic> json) =
      _$NavApiDocsItemImageSizesCardDataImpl.fromJson;

  @override
  @JsonKey(name: 'url')
  String get url;
  @override
  @JsonKey(name: 'width')
  int get width;
  @override
  @JsonKey(name: 'height')
  int get height;
  @override
  @JsonKey(name: 'mimeType')
  String get mimeType;
  @override
  @JsonKey(name: 'filesize')
  int get filesize;
  @override
  @JsonKey(name: 'filename')
  String get filename;

  /// Create a copy of NavApiDocsItemImageSizesCardData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NavApiDocsItemImageSizesCardDataImplCopyWith<
          _$NavApiDocsItemImageSizesCardDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

NavApiDocsItemImageSizesTabletData _$NavApiDocsItemImageSizesTabletDataFromJson(
    Map<String, dynamic> json) {
  return _NavApiDocsItemImageSizesTabletData.fromJson(json);
}

/// @nodoc
mixin _$NavApiDocsItemImageSizesTabletData {
  @JsonKey(name: 'url')
  String get url => throw _privateConstructorUsedError;
  @JsonKey(name: 'width')
  int get width => throw _privateConstructorUsedError;
  @JsonKey(name: 'height')
  int get height => throw _privateConstructorUsedError;
  @JsonKey(name: 'mimeType')
  String get mimeType => throw _privateConstructorUsedError;
  @JsonKey(name: 'filesize')
  int get filesize => throw _privateConstructorUsedError;
  @JsonKey(name: 'filename')
  String get filename => throw _privateConstructorUsedError;

  /// Serializes this NavApiDocsItemImageSizesTabletData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NavApiDocsItemImageSizesTabletData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NavApiDocsItemImageSizesTabletDataCopyWith<
          NavApiDocsItemImageSizesTabletData>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NavApiDocsItemImageSizesTabletDataCopyWith<$Res> {
  factory $NavApiDocsItemImageSizesTabletDataCopyWith(
          NavApiDocsItemImageSizesTabletData value,
          $Res Function(NavApiDocsItemImageSizesTabletData) then) =
      _$NavApiDocsItemImageSizesTabletDataCopyWithImpl<$Res,
          NavApiDocsItemImageSizesTabletData>;
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
class _$NavApiDocsItemImageSizesTabletDataCopyWithImpl<$Res,
        $Val extends NavApiDocsItemImageSizesTabletData>
    implements $NavApiDocsItemImageSizesTabletDataCopyWith<$Res> {
  _$NavApiDocsItemImageSizesTabletDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      filesize: null == filesize
          ? _value.filesize
          : filesize // ignore: cast_nullable_to_non_nullable
              as int,
      filename: null == filename
          ? _value.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NavApiDocsItemImageSizesTabletDataImplCopyWith<$Res>
    implements $NavApiDocsItemImageSizesTabletDataCopyWith<$Res> {
  factory _$$NavApiDocsItemImageSizesTabletDataImplCopyWith(
          _$NavApiDocsItemImageSizesTabletDataImpl value,
          $Res Function(_$NavApiDocsItemImageSizesTabletDataImpl) then) =
      __$$NavApiDocsItemImageSizesTabletDataImplCopyWithImpl<$Res>;
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
class __$$NavApiDocsItemImageSizesTabletDataImplCopyWithImpl<$Res>
    extends _$NavApiDocsItemImageSizesTabletDataCopyWithImpl<$Res,
        _$NavApiDocsItemImageSizesTabletDataImpl>
    implements _$$NavApiDocsItemImageSizesTabletDataImplCopyWith<$Res> {
  __$$NavApiDocsItemImageSizesTabletDataImplCopyWithImpl(
      _$NavApiDocsItemImageSizesTabletDataImpl _value,
      $Res Function(_$NavApiDocsItemImageSizesTabletDataImpl) _then)
      : super(_value, _then);

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
    return _then(_$NavApiDocsItemImageSizesTabletDataImpl(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      filesize: null == filesize
          ? _value.filesize
          : filesize // ignore: cast_nullable_to_non_nullable
              as int,
      filename: null == filename
          ? _value.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NavApiDocsItemImageSizesTabletDataImpl
    extends _NavApiDocsItemImageSizesTabletData {
  const _$NavApiDocsItemImageSizesTabletDataImpl(
      {@JsonKey(name: 'url') this.url = '',
      @JsonKey(name: 'width') this.width = 0,
      @JsonKey(name: 'height') this.height = 0,
      @JsonKey(name: 'mimeType') this.mimeType = '',
      @JsonKey(name: 'filesize') this.filesize = 0,
      @JsonKey(name: 'filename') this.filename = ''})
      : super._();

  factory _$NavApiDocsItemImageSizesTabletDataImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$NavApiDocsItemImageSizesTabletDataImplFromJson(json);

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

  @override
  String toString() {
    return 'NavApiDocsItemImageSizesTabletData(url: $url, width: $width, height: $height, mimeType: $mimeType, filesize: $filesize, filename: $filename)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NavApiDocsItemImageSizesTabletDataImpl &&
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

  /// Create a copy of NavApiDocsItemImageSizesTabletData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NavApiDocsItemImageSizesTabletDataImplCopyWith<
          _$NavApiDocsItemImageSizesTabletDataImpl>
      get copyWith => __$$NavApiDocsItemImageSizesTabletDataImplCopyWithImpl<
          _$NavApiDocsItemImageSizesTabletDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NavApiDocsItemImageSizesTabletDataImplToJson(
      this,
    );
  }
}

abstract class _NavApiDocsItemImageSizesTabletData
    extends NavApiDocsItemImageSizesTabletData {
  const factory _NavApiDocsItemImageSizesTabletData(
          {@JsonKey(name: 'url') final String url,
          @JsonKey(name: 'width') final int width,
          @JsonKey(name: 'height') final int height,
          @JsonKey(name: 'mimeType') final String mimeType,
          @JsonKey(name: 'filesize') final int filesize,
          @JsonKey(name: 'filename') final String filename}) =
      _$NavApiDocsItemImageSizesTabletDataImpl;
  const _NavApiDocsItemImageSizesTabletData._() : super._();

  factory _NavApiDocsItemImageSizesTabletData.fromJson(
          Map<String, dynamic> json) =
      _$NavApiDocsItemImageSizesTabletDataImpl.fromJson;

  @override
  @JsonKey(name: 'url')
  String get url;
  @override
  @JsonKey(name: 'width')
  int get width;
  @override
  @JsonKey(name: 'height')
  int get height;
  @override
  @JsonKey(name: 'mimeType')
  String get mimeType;
  @override
  @JsonKey(name: 'filesize')
  int get filesize;
  @override
  @JsonKey(name: 'filename')
  String get filename;

  /// Create a copy of NavApiDocsItemImageSizesTabletData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NavApiDocsItemImageSizesTabletDataImplCopyWith<
          _$NavApiDocsItemImageSizesTabletDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

NavApiDocsItemImageSizesAvatarData _$NavApiDocsItemImageSizesAvatarDataFromJson(
    Map<String, dynamic> json) {
  return _NavApiDocsItemImageSizesAvatarData.fromJson(json);
}

/// @nodoc
mixin _$NavApiDocsItemImageSizesAvatarData {
  @JsonKey(name: 'url')
  String get url => throw _privateConstructorUsedError;
  @JsonKey(name: 'width')
  int get width => throw _privateConstructorUsedError;
  @JsonKey(name: 'height')
  int get height => throw _privateConstructorUsedError;
  @JsonKey(name: 'mimeType')
  String get mimeType => throw _privateConstructorUsedError;
  @JsonKey(name: 'filesize')
  int get filesize => throw _privateConstructorUsedError;
  @JsonKey(name: 'filename')
  String get filename => throw _privateConstructorUsedError;

  /// Serializes this NavApiDocsItemImageSizesAvatarData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NavApiDocsItemImageSizesAvatarData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NavApiDocsItemImageSizesAvatarDataCopyWith<
          NavApiDocsItemImageSizesAvatarData>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NavApiDocsItemImageSizesAvatarDataCopyWith<$Res> {
  factory $NavApiDocsItemImageSizesAvatarDataCopyWith(
          NavApiDocsItemImageSizesAvatarData value,
          $Res Function(NavApiDocsItemImageSizesAvatarData) then) =
      _$NavApiDocsItemImageSizesAvatarDataCopyWithImpl<$Res,
          NavApiDocsItemImageSizesAvatarData>;
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
class _$NavApiDocsItemImageSizesAvatarDataCopyWithImpl<$Res,
        $Val extends NavApiDocsItemImageSizesAvatarData>
    implements $NavApiDocsItemImageSizesAvatarDataCopyWith<$Res> {
  _$NavApiDocsItemImageSizesAvatarDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      filesize: null == filesize
          ? _value.filesize
          : filesize // ignore: cast_nullable_to_non_nullable
              as int,
      filename: null == filename
          ? _value.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NavApiDocsItemImageSizesAvatarDataImplCopyWith<$Res>
    implements $NavApiDocsItemImageSizesAvatarDataCopyWith<$Res> {
  factory _$$NavApiDocsItemImageSizesAvatarDataImplCopyWith(
          _$NavApiDocsItemImageSizesAvatarDataImpl value,
          $Res Function(_$NavApiDocsItemImageSizesAvatarDataImpl) then) =
      __$$NavApiDocsItemImageSizesAvatarDataImplCopyWithImpl<$Res>;
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
class __$$NavApiDocsItemImageSizesAvatarDataImplCopyWithImpl<$Res>
    extends _$NavApiDocsItemImageSizesAvatarDataCopyWithImpl<$Res,
        _$NavApiDocsItemImageSizesAvatarDataImpl>
    implements _$$NavApiDocsItemImageSizesAvatarDataImplCopyWith<$Res> {
  __$$NavApiDocsItemImageSizesAvatarDataImplCopyWithImpl(
      _$NavApiDocsItemImageSizesAvatarDataImpl _value,
      $Res Function(_$NavApiDocsItemImageSizesAvatarDataImpl) _then)
      : super(_value, _then);

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
    return _then(_$NavApiDocsItemImageSizesAvatarDataImpl(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      filesize: null == filesize
          ? _value.filesize
          : filesize // ignore: cast_nullable_to_non_nullable
              as int,
      filename: null == filename
          ? _value.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NavApiDocsItemImageSizesAvatarDataImpl
    extends _NavApiDocsItemImageSizesAvatarData {
  const _$NavApiDocsItemImageSizesAvatarDataImpl(
      {@JsonKey(name: 'url') this.url = '',
      @JsonKey(name: 'width') this.width = 0,
      @JsonKey(name: 'height') this.height = 0,
      @JsonKey(name: 'mimeType') this.mimeType = '',
      @JsonKey(name: 'filesize') this.filesize = 0,
      @JsonKey(name: 'filename') this.filename = ''})
      : super._();

  factory _$NavApiDocsItemImageSizesAvatarDataImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$NavApiDocsItemImageSizesAvatarDataImplFromJson(json);

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

  @override
  String toString() {
    return 'NavApiDocsItemImageSizesAvatarData(url: $url, width: $width, height: $height, mimeType: $mimeType, filesize: $filesize, filename: $filename)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NavApiDocsItemImageSizesAvatarDataImpl &&
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

  /// Create a copy of NavApiDocsItemImageSizesAvatarData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NavApiDocsItemImageSizesAvatarDataImplCopyWith<
          _$NavApiDocsItemImageSizesAvatarDataImpl>
      get copyWith => __$$NavApiDocsItemImageSizesAvatarDataImplCopyWithImpl<
          _$NavApiDocsItemImageSizesAvatarDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NavApiDocsItemImageSizesAvatarDataImplToJson(
      this,
    );
  }
}

abstract class _NavApiDocsItemImageSizesAvatarData
    extends NavApiDocsItemImageSizesAvatarData {
  const factory _NavApiDocsItemImageSizesAvatarData(
          {@JsonKey(name: 'url') final String url,
          @JsonKey(name: 'width') final int width,
          @JsonKey(name: 'height') final int height,
          @JsonKey(name: 'mimeType') final String mimeType,
          @JsonKey(name: 'filesize') final int filesize,
          @JsonKey(name: 'filename') final String filename}) =
      _$NavApiDocsItemImageSizesAvatarDataImpl;
  const _NavApiDocsItemImageSizesAvatarData._() : super._();

  factory _NavApiDocsItemImageSizesAvatarData.fromJson(
          Map<String, dynamic> json) =
      _$NavApiDocsItemImageSizesAvatarDataImpl.fromJson;

  @override
  @JsonKey(name: 'url')
  String get url;
  @override
  @JsonKey(name: 'width')
  int get width;
  @override
  @JsonKey(name: 'height')
  int get height;
  @override
  @JsonKey(name: 'mimeType')
  String get mimeType;
  @override
  @JsonKey(name: 'filesize')
  int get filesize;
  @override
  @JsonKey(name: 'filename')
  String get filename;

  /// Create a copy of NavApiDocsItemImageSizesAvatarData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NavApiDocsItemImageSizesAvatarDataImplCopyWith<
          _$NavApiDocsItemImageSizesAvatarDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

NavApiDocsItemTagsItemData _$NavApiDocsItemTagsItemDataFromJson(
    Map<String, dynamic> json) {
  return _NavApiDocsItemTagsItemData.fromJson(json);
}

/// @nodoc
mixin _$NavApiDocsItemTagsItemData {
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'slug')
  String get slug => throw _privateConstructorUsedError;
  @JsonKey(name: 'updatedAt')
  String get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdAt')
  String get createdAt => throw _privateConstructorUsedError;

  /// Serializes this NavApiDocsItemTagsItemData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NavApiDocsItemTagsItemData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NavApiDocsItemTagsItemDataCopyWith<NavApiDocsItemTagsItemData>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NavApiDocsItemTagsItemDataCopyWith<$Res> {
  factory $NavApiDocsItemTagsItemDataCopyWith(NavApiDocsItemTagsItemData value,
          $Res Function(NavApiDocsItemTagsItemData) then) =
      _$NavApiDocsItemTagsItemDataCopyWithImpl<$Res,
          NavApiDocsItemTagsItemData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'slug') String slug,
      @JsonKey(name: 'updatedAt') String updatedAt,
      @JsonKey(name: 'createdAt') String createdAt});
}

/// @nodoc
class _$NavApiDocsItemTagsItemDataCopyWithImpl<$Res,
        $Val extends NavApiDocsItemTagsItemData>
    implements $NavApiDocsItemTagsItemDataCopyWith<$Res> {
  _$NavApiDocsItemTagsItemDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NavApiDocsItemTagsItemDataImplCopyWith<$Res>
    implements $NavApiDocsItemTagsItemDataCopyWith<$Res> {
  factory _$$NavApiDocsItemTagsItemDataImplCopyWith(
          _$NavApiDocsItemTagsItemDataImpl value,
          $Res Function(_$NavApiDocsItemTagsItemDataImpl) then) =
      __$$NavApiDocsItemTagsItemDataImplCopyWithImpl<$Res>;
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
class __$$NavApiDocsItemTagsItemDataImplCopyWithImpl<$Res>
    extends _$NavApiDocsItemTagsItemDataCopyWithImpl<$Res,
        _$NavApiDocsItemTagsItemDataImpl>
    implements _$$NavApiDocsItemTagsItemDataImplCopyWith<$Res> {
  __$$NavApiDocsItemTagsItemDataImplCopyWithImpl(
      _$NavApiDocsItemTagsItemDataImpl _value,
      $Res Function(_$NavApiDocsItemTagsItemDataImpl) _then)
      : super(_value, _then);

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
    return _then(_$NavApiDocsItemTagsItemDataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NavApiDocsItemTagsItemDataImpl extends _NavApiDocsItemTagsItemData {
  const _$NavApiDocsItemTagsItemDataImpl(
      {@JsonKey(name: 'id') this.id = '',
      @JsonKey(name: 'name') this.name = '',
      @JsonKey(name: 'slug') this.slug = '',
      @JsonKey(name: 'updatedAt') this.updatedAt = '',
      @JsonKey(name: 'createdAt') this.createdAt = ''})
      : super._();

  factory _$NavApiDocsItemTagsItemDataImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$NavApiDocsItemTagsItemDataImplFromJson(json);

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

  @override
  String toString() {
    return 'NavApiDocsItemTagsItemData(id: $id, name: $name, slug: $slug, updatedAt: $updatedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NavApiDocsItemTagsItemDataImpl &&
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

  /// Create a copy of NavApiDocsItemTagsItemData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NavApiDocsItemTagsItemDataImplCopyWith<_$NavApiDocsItemTagsItemDataImpl>
      get copyWith => __$$NavApiDocsItemTagsItemDataImplCopyWithImpl<
          _$NavApiDocsItemTagsItemDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NavApiDocsItemTagsItemDataImplToJson(
      this,
    );
  }
}

abstract class _NavApiDocsItemTagsItemData extends NavApiDocsItemTagsItemData {
  const factory _NavApiDocsItemTagsItemData(
          {@JsonKey(name: 'id') final String id,
          @JsonKey(name: 'name') final String name,
          @JsonKey(name: 'slug') final String slug,
          @JsonKey(name: 'updatedAt') final String updatedAt,
          @JsonKey(name: 'createdAt') final String createdAt}) =
      _$NavApiDocsItemTagsItemDataImpl;
  const _NavApiDocsItemTagsItemData._() : super._();

  factory _NavApiDocsItemTagsItemData.fromJson(Map<String, dynamic> json) =
      _$NavApiDocsItemTagsItemDataImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String get id;
  @override
  @JsonKey(name: 'name')
  String get name;
  @override
  @JsonKey(name: 'slug')
  String get slug;
  @override
  @JsonKey(name: 'updatedAt')
  String get updatedAt;
  @override
  @JsonKey(name: 'createdAt')
  String get createdAt;

  /// Create a copy of NavApiDocsItemTagsItemData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NavApiDocsItemTagsItemDataImplCopyWith<_$NavApiDocsItemTagsItemDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

NavApiData _$NavApiDataFromJson(Map<String, dynamic> json) {
  return _NavApiData.fromJson(json);
}

/// @nodoc
mixin _$NavApiData {
  @JsonKey(name: 'docs')
  List<NavApiDocsItemData> get docs => throw _privateConstructorUsedError;
  @JsonKey(name: 'hasNextPage')
  bool get hasNextPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'hasPrevPage')
  bool get hasPrevPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'limit')
  int get limit => throw _privateConstructorUsedError;
  @JsonKey(name: 'nextPage')
  dynamic get nextPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'page')
  int get page => throw _privateConstructorUsedError;
  @JsonKey(name: 'pagingCounter')
  int get pagingCounter => throw _privateConstructorUsedError;
  @JsonKey(name: 'prevPage')
  dynamic get prevPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'totalDocs')
  int get totalDocs => throw _privateConstructorUsedError;
  @JsonKey(name: 'totalPages')
  int get totalPages => throw _privateConstructorUsedError;

  /// Serializes this NavApiData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NavApiData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NavApiDataCopyWith<NavApiData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NavApiDataCopyWith<$Res> {
  factory $NavApiDataCopyWith(
          NavApiData value, $Res Function(NavApiData) then) =
      _$NavApiDataCopyWithImpl<$Res, NavApiData>;
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
class _$NavApiDataCopyWithImpl<$Res, $Val extends NavApiData>
    implements $NavApiDataCopyWith<$Res> {
  _$NavApiDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      docs: null == docs
          ? _value.docs
          : docs // ignore: cast_nullable_to_non_nullable
              as List<NavApiDocsItemData>,
      hasNextPage: null == hasNextPage
          ? _value.hasNextPage
          : hasNextPage // ignore: cast_nullable_to_non_nullable
              as bool,
      hasPrevPage: null == hasPrevPage
          ? _value.hasPrevPage
          : hasPrevPage // ignore: cast_nullable_to_non_nullable
              as bool,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      nextPage: freezed == nextPage
          ? _value.nextPage
          : nextPage // ignore: cast_nullable_to_non_nullable
              as dynamic,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      pagingCounter: null == pagingCounter
          ? _value.pagingCounter
          : pagingCounter // ignore: cast_nullable_to_non_nullable
              as int,
      prevPage: freezed == prevPage
          ? _value.prevPage
          : prevPage // ignore: cast_nullable_to_non_nullable
              as dynamic,
      totalDocs: null == totalDocs
          ? _value.totalDocs
          : totalDocs // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NavApiDataImplCopyWith<$Res>
    implements $NavApiDataCopyWith<$Res> {
  factory _$$NavApiDataImplCopyWith(
          _$NavApiDataImpl value, $Res Function(_$NavApiDataImpl) then) =
      __$$NavApiDataImplCopyWithImpl<$Res>;
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
class __$$NavApiDataImplCopyWithImpl<$Res>
    extends _$NavApiDataCopyWithImpl<$Res, _$NavApiDataImpl>
    implements _$$NavApiDataImplCopyWith<$Res> {
  __$$NavApiDataImplCopyWithImpl(
      _$NavApiDataImpl _value, $Res Function(_$NavApiDataImpl) _then)
      : super(_value, _then);

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
    return _then(_$NavApiDataImpl(
      docs: null == docs
          ? _value._docs
          : docs // ignore: cast_nullable_to_non_nullable
              as List<NavApiDocsItemData>,
      hasNextPage: null == hasNextPage
          ? _value.hasNextPage
          : hasNextPage // ignore: cast_nullable_to_non_nullable
              as bool,
      hasPrevPage: null == hasPrevPage
          ? _value.hasPrevPage
          : hasPrevPage // ignore: cast_nullable_to_non_nullable
              as bool,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      nextPage: freezed == nextPage
          ? _value.nextPage
          : nextPage // ignore: cast_nullable_to_non_nullable
              as dynamic,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      pagingCounter: null == pagingCounter
          ? _value.pagingCounter
          : pagingCounter // ignore: cast_nullable_to_non_nullable
              as int,
      prevPage: freezed == prevPage
          ? _value.prevPage
          : prevPage // ignore: cast_nullable_to_non_nullable
              as dynamic,
      totalDocs: null == totalDocs
          ? _value.totalDocs
          : totalDocs // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NavApiDataImpl extends _NavApiData {
  const _$NavApiDataImpl(
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

  factory _$NavApiDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$NavApiDataImplFromJson(json);

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

  @override
  String toString() {
    return 'NavApiData(docs: $docs, hasNextPage: $hasNextPage, hasPrevPage: $hasPrevPage, limit: $limit, nextPage: $nextPage, page: $page, pagingCounter: $pagingCounter, prevPage: $prevPage, totalDocs: $totalDocs, totalPages: $totalPages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NavApiDataImpl &&
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

  /// Create a copy of NavApiData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NavApiDataImplCopyWith<_$NavApiDataImpl> get copyWith =>
      __$$NavApiDataImplCopyWithImpl<_$NavApiDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NavApiDataImplToJson(
      this,
    );
  }
}

abstract class _NavApiData extends NavApiData {
  const factory _NavApiData(
      {@JsonKey(name: 'docs') final List<NavApiDocsItemData> docs,
      @JsonKey(name: 'hasNextPage') final bool hasNextPage,
      @JsonKey(name: 'hasPrevPage') final bool hasPrevPage,
      @JsonKey(name: 'limit') final int limit,
      @JsonKey(name: 'nextPage') final dynamic nextPage,
      @JsonKey(name: 'page') final int page,
      @JsonKey(name: 'pagingCounter') final int pagingCounter,
      @JsonKey(name: 'prevPage') final dynamic prevPage,
      @JsonKey(name: 'totalDocs') final int totalDocs,
      @JsonKey(name: 'totalPages') final int totalPages}) = _$NavApiDataImpl;
  const _NavApiData._() : super._();

  factory _NavApiData.fromJson(Map<String, dynamic> json) =
      _$NavApiDataImpl.fromJson;

  @override
  @JsonKey(name: 'docs')
  List<NavApiDocsItemData> get docs;
  @override
  @JsonKey(name: 'hasNextPage')
  bool get hasNextPage;
  @override
  @JsonKey(name: 'hasPrevPage')
  bool get hasPrevPage;
  @override
  @JsonKey(name: 'limit')
  int get limit;
  @override
  @JsonKey(name: 'nextPage')
  dynamic get nextPage;
  @override
  @JsonKey(name: 'page')
  int get page;
  @override
  @JsonKey(name: 'pagingCounter')
  int get pagingCounter;
  @override
  @JsonKey(name: 'prevPage')
  dynamic get prevPage;
  @override
  @JsonKey(name: 'totalDocs')
  int get totalDocs;
  @override
  @JsonKey(name: 'totalPages')
  int get totalPages;

  /// Create a copy of NavApiData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NavApiDataImplCopyWith<_$NavApiDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
