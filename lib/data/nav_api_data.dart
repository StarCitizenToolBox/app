import 'package:freezed_annotation/freezed_annotation.dart';

part 'nav_api_data.freezed.dart';

part 'nav_api_data.g.dart';

@freezed
abstract class NavApiDocsItemData with _$NavApiDocsItemData {
  const factory NavApiDocsItemData({
    @Default('') @JsonKey(name: 'id') String id,
    @Default('') @JsonKey(name: 'name') String name,
    @Default('') @JsonKey(name: 'slug') String slug,
    @Default('') @JsonKey(name: 'abstract') String abstract_,
    @Default('') @JsonKey(name: 'description') String description,
    @Default(NavApiDocsItemImageData())
    @JsonKey(name: 'image')
    NavApiDocsItemImageData image,
    @Default('') @JsonKey(name: 'link') String link,
    @Default(false) @JsonKey(name: 'is_sponsored') bool isSponsored,
    @Default(<NavApiDocsItemTagsItemData>[])
    @JsonKey(name: 'tags')
    List<NavApiDocsItemTagsItemData> tags,
    @Default('') @JsonKey(name: 'updatedAt') String updatedAt,
    @Default('') @JsonKey(name: 'createdAt') String createdAt,
  }) = _NavApiDocsItemData;

  const NavApiDocsItemData._();

  factory NavApiDocsItemData.fromJson(Map<String, Object?> json) =>
      _$NavApiDocsItemDataFromJson(json);
}

@freezed
abstract class NavApiDocsItemImageData with _$NavApiDocsItemImageData {
  const factory NavApiDocsItemImageData({
    @Default('') @JsonKey(name: 'id') String id,
    @Default(NavApiDocsItemImageCreatedByData())
    @JsonKey(name: 'createdBy')
    NavApiDocsItemImageCreatedByData createdBy,
    @Default('') @JsonKey(name: 'title') String title,
    @Default(false) @JsonKey(name: 'original') bool original,
    @Default('') @JsonKey(name: 'credit') String credit,
    @Default('') @JsonKey(name: 'source') String source,
    @Default('') @JsonKey(name: 'license') String license,
    @JsonKey(name: 'caption') dynamic caption,
    @Default('') @JsonKey(name: 'updatedAt') String updatedAt,
    @Default('') @JsonKey(name: 'createdAt') String createdAt,
    @Default('') @JsonKey(name: 'url') String url,
    @Default('') @JsonKey(name: 'filename') String filename,
    @Default('') @JsonKey(name: 'mimeType') String mimeType,
    @Default(0) @JsonKey(name: 'filesize') int filesize,
    @Default(0) @JsonKey(name: 'width') int width,
    @Default(0) @JsonKey(name: 'height') int height,
    @Default(NavApiDocsItemImageSizesData())
    @JsonKey(name: 'sizes')
    NavApiDocsItemImageSizesData sizes,
  }) = _NavApiDocsItemImageData;

  const NavApiDocsItemImageData._();

  factory NavApiDocsItemImageData.fromJson(Map<String, Object?> json) =>
      _$NavApiDocsItemImageDataFromJson(json);
}

@freezed
abstract class NavApiDocsItemImageCreatedByData with _$NavApiDocsItemImageCreatedByData {
  const factory NavApiDocsItemImageCreatedByData({
    @Default('') @JsonKey(name: 'id') String id,
    @Default('') @JsonKey(name: 'sub') String sub,
    @Default('') @JsonKey(name: 'external_provider') String externalProvider,
    @Default('') @JsonKey(name: 'username') String username,
    @Default('') @JsonKey(name: 'name') String name,
    @Default(<String>[]) @JsonKey(name: 'roles') List<String> roles,
    @Default('') @JsonKey(name: 'avatar_url') String avatarUrl,
    @Default('') @JsonKey(name: 'updatedAt') String updatedAt,
    @Default('') @JsonKey(name: 'createdAt') String createdAt,
    @Default('') @JsonKey(name: 'email') String email,
    @Default(0) @JsonKey(name: 'loginAttempts') int loginAttempts,
    @Default('') @JsonKey(name: 'avatar') String avatar,
  }) = _NavApiDocsItemImageCreatedByData;

  const NavApiDocsItemImageCreatedByData._();

  factory NavApiDocsItemImageCreatedByData.fromJson(
      Map<String, Object?> json) =>
      _$NavApiDocsItemImageCreatedByDataFromJson(json);
}

@freezed
abstract class NavApiDocsItemImageSizesThumbnailData
    with _$NavApiDocsItemImageSizesThumbnailData {
  const factory NavApiDocsItemImageSizesThumbnailData({
    @Default('') @JsonKey(name: 'url') String url,
    @Default(0) @JsonKey(name: 'width') int width,
    @Default(0) @JsonKey(name: 'height') int height,
    @Default('') @JsonKey(name: 'mimeType') String mimeType,
    @Default(0) @JsonKey(name: 'filesize') int filesize,
    @Default('') @JsonKey(name: 'filename') String filename,
  }) = _NavApiDocsItemImageSizesThumbnailData;

  const NavApiDocsItemImageSizesThumbnailData._();

  factory NavApiDocsItemImageSizesThumbnailData.fromJson(
      Map<String, Object?> json) =>
      _$NavApiDocsItemImageSizesThumbnailDataFromJson(json);
}

@freezed
abstract class NavApiDocsItemImageSizesData with _$NavApiDocsItemImageSizesData {
  const factory NavApiDocsItemImageSizesData({
    @Default(NavApiDocsItemImageSizesThumbnailData())
    @JsonKey(name: 'thumbnail')
    NavApiDocsItemImageSizesThumbnailData thumbnail,
    @Default(NavApiDocsItemImageSizesPreloadData())
    @JsonKey(name: 'preload')
    NavApiDocsItemImageSizesPreloadData preload,
    @Default(NavApiDocsItemImageSizesCardData())
    @JsonKey(name: 'card')
    NavApiDocsItemImageSizesCardData card,
    @Default(NavApiDocsItemImageSizesTabletData())
    @JsonKey(name: 'tablet')
    NavApiDocsItemImageSizesTabletData tablet,
    @Default(NavApiDocsItemImageSizesAvatarData())
    @JsonKey(name: 'avatar')
    NavApiDocsItemImageSizesAvatarData avatar,
  }) = _NavApiDocsItemImageSizesData;

  const NavApiDocsItemImageSizesData._();

  factory NavApiDocsItemImageSizesData.fromJson(Map<String, Object?> json) =>
      _$NavApiDocsItemImageSizesDataFromJson(json);
}

@freezed
abstract class NavApiDocsItemImageSizesPreloadData
    with _$NavApiDocsItemImageSizesPreloadData {
  const factory NavApiDocsItemImageSizesPreloadData({
    @JsonKey(name: 'url') dynamic url,
    @JsonKey(name: 'width') dynamic width,
    @JsonKey(name: 'height') dynamic height,
    @JsonKey(name: 'mimeType') dynamic mimeType,
    @JsonKey(name: 'filesize') dynamic filesize,
    @JsonKey(name: 'filename') dynamic filename,
  }) = _NavApiDocsItemImageSizesPreloadData;

  const NavApiDocsItemImageSizesPreloadData._();

  factory NavApiDocsItemImageSizesPreloadData.fromJson(
      Map<String, Object?> json) =>
      _$NavApiDocsItemImageSizesPreloadDataFromJson(json);
}

@freezed
abstract class NavApiDocsItemImageSizesCardData with _$NavApiDocsItemImageSizesCardData {
  const factory NavApiDocsItemImageSizesCardData({
    @Default('') @JsonKey(name: 'url') String url,
    @Default(0) @JsonKey(name: 'width') int width,
    @Default(0) @JsonKey(name: 'height') int height,
    @Default('') @JsonKey(name: 'mimeType') String mimeType,
    @Default(0) @JsonKey(name: 'filesize') int filesize,
    @Default('') @JsonKey(name: 'filename') String filename,
  }) = _NavApiDocsItemImageSizesCardData;

  const NavApiDocsItemImageSizesCardData._();

  factory NavApiDocsItemImageSizesCardData.fromJson(
      Map<String, Object?> json) =>
      _$NavApiDocsItemImageSizesCardDataFromJson(json);
}

@freezed
abstract class NavApiDocsItemImageSizesTabletData
    with _$NavApiDocsItemImageSizesTabletData {
  const factory NavApiDocsItemImageSizesTabletData({
    @Default('') @JsonKey(name: 'url') String url,
    @Default(0) @JsonKey(name: 'width') int width,
    @Default(0) @JsonKey(name: 'height') int height,
    @Default('') @JsonKey(name: 'mimeType') String mimeType,
    @Default(0) @JsonKey(name: 'filesize') int filesize,
    @Default('') @JsonKey(name: 'filename') String filename,
  }) = _NavApiDocsItemImageSizesTabletData;

  const NavApiDocsItemImageSizesTabletData._();

  factory NavApiDocsItemImageSizesTabletData.fromJson(
      Map<String, Object?> json) =>
      _$NavApiDocsItemImageSizesTabletDataFromJson(json);
}

@freezed
abstract class NavApiDocsItemImageSizesAvatarData
    with _$NavApiDocsItemImageSizesAvatarData {
  const factory NavApiDocsItemImageSizesAvatarData({
    @Default('') @JsonKey(name: 'url') String url,
    @Default(0) @JsonKey(name: 'width') int width,
    @Default(0) @JsonKey(name: 'height') int height,
    @Default('') @JsonKey(name: 'mimeType') String mimeType,
    @Default(0) @JsonKey(name: 'filesize') int filesize,
    @Default('') @JsonKey(name: 'filename') String filename,
  }) = _NavApiDocsItemImageSizesAvatarData;

  const NavApiDocsItemImageSizesAvatarData._();

  factory NavApiDocsItemImageSizesAvatarData.fromJson(
      Map<String, Object?> json) =>
      _$NavApiDocsItemImageSizesAvatarDataFromJson(json);
}

@freezed
abstract class NavApiDocsItemTagsItemData with _$NavApiDocsItemTagsItemData {
  const factory NavApiDocsItemTagsItemData({
    @Default('') @JsonKey(name: 'id') String id,
    @Default('') @JsonKey(name: 'name') String name,
    @Default('') @JsonKey(name: 'slug') String slug,
    @Default('') @JsonKey(name: 'updatedAt') String updatedAt,
    @Default('') @JsonKey(name: 'createdAt') String createdAt,
  }) = _NavApiDocsItemTagsItemData;

  const NavApiDocsItemTagsItemData._();

  factory NavApiDocsItemTagsItemData.fromJson(Map<String, Object?> json) =>
      _$NavApiDocsItemTagsItemDataFromJson(json);
}

@freezed
abstract class NavApiData with _$NavApiData {
  const factory NavApiData({
    @Default(<NavApiDocsItemData>[])
    @JsonKey(name: 'docs')
    List<NavApiDocsItemData> docs,
    @Default(false) @JsonKey(name: 'hasNextPage') bool hasNextPage,
    @Default(false) @JsonKey(name: 'hasPrevPage') bool hasPrevPage,
    @Default(0) @JsonKey(name: 'limit') int limit,
    @JsonKey(name: 'nextPage') dynamic nextPage,
    @Default(0) @JsonKey(name: 'page') int page,
    @Default(0) @JsonKey(name: 'pagingCounter') int pagingCounter,
    @JsonKey(name: 'prevPage') dynamic prevPage,
    @Default(0) @JsonKey(name: 'totalDocs') int totalDocs,
    @Default(0) @JsonKey(name: 'totalPages') int totalPages,
  }) = _NavApiData;

  const NavApiData._();

  factory NavApiData.fromJson(Map<String, Object?> json) =>
      _$NavApiDataFromJson(json);
}
