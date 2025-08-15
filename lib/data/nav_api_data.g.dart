// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nav_api_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NavApiDocsItemData _$NavApiDocsItemDataFromJson(
  Map<String, dynamic> json,
) => _NavApiDocsItemData(
  id: json['id'] as String? ?? '',
  name: json['name'] as String? ?? '',
  slug: json['slug'] as String? ?? '',
  abstract_: json['abstract'] as String? ?? '',
  description: json['description'] as String? ?? '',
  image: json['image'] == null
      ? const NavApiDocsItemImageData()
      : NavApiDocsItemImageData.fromJson(json['image'] as Map<String, dynamic>),
  link: json['link'] as String? ?? '',
  isSponsored: json['is_sponsored'] as bool? ?? false,
  tags:
      (json['tags'] as List<dynamic>?)
          ?.map(
            (e) =>
                NavApiDocsItemTagsItemData.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <NavApiDocsItemTagsItemData>[],
  updatedAt: json['updatedAt'] as String? ?? '',
  createdAt: json['createdAt'] as String? ?? '',
);

Map<String, dynamic> _$NavApiDocsItemDataToJson(_NavApiDocsItemData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'abstract': instance.abstract_,
      'description': instance.description,
      'image': instance.image,
      'link': instance.link,
      'is_sponsored': instance.isSponsored,
      'tags': instance.tags,
      'updatedAt': instance.updatedAt,
      'createdAt': instance.createdAt,
    };

_NavApiDocsItemImageData _$NavApiDocsItemImageDataFromJson(
  Map<String, dynamic> json,
) => _NavApiDocsItemImageData(
  id: json['id'] as String? ?? '',
  createdBy: json['createdBy'] == null
      ? const NavApiDocsItemImageCreatedByData()
      : NavApiDocsItemImageCreatedByData.fromJson(
          json['createdBy'] as Map<String, dynamic>,
        ),
  title: json['title'] as String? ?? '',
  original: json['original'] as bool? ?? false,
  credit: json['credit'] as String? ?? '',
  source: json['source'] as String? ?? '',
  license: json['license'] as String? ?? '',
  caption: json['caption'],
  updatedAt: json['updatedAt'] as String? ?? '',
  createdAt: json['createdAt'] as String? ?? '',
  url: json['url'] as String? ?? '',
  filename: json['filename'] as String? ?? '',
  mimeType: json['mimeType'] as String? ?? '',
  filesize: (json['filesize'] as num?)?.toInt() ?? 0,
  width: (json['width'] as num?)?.toInt() ?? 0,
  height: (json['height'] as num?)?.toInt() ?? 0,
  sizes: json['sizes'] == null
      ? const NavApiDocsItemImageSizesData()
      : NavApiDocsItemImageSizesData.fromJson(
          json['sizes'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$NavApiDocsItemImageDataToJson(
  _NavApiDocsItemImageData instance,
) => <String, dynamic>{
  'id': instance.id,
  'createdBy': instance.createdBy,
  'title': instance.title,
  'original': instance.original,
  'credit': instance.credit,
  'source': instance.source,
  'license': instance.license,
  'caption': instance.caption,
  'updatedAt': instance.updatedAt,
  'createdAt': instance.createdAt,
  'url': instance.url,
  'filename': instance.filename,
  'mimeType': instance.mimeType,
  'filesize': instance.filesize,
  'width': instance.width,
  'height': instance.height,
  'sizes': instance.sizes,
};

_NavApiDocsItemImageCreatedByData _$NavApiDocsItemImageCreatedByDataFromJson(
  Map<String, dynamic> json,
) => _NavApiDocsItemImageCreatedByData(
  id: json['id'] as String? ?? '',
  sub: json['sub'] as String? ?? '',
  externalProvider: json['external_provider'] as String? ?? '',
  username: json['username'] as String? ?? '',
  name: json['name'] as String? ?? '',
  roles:
      (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  avatarUrl: json['avatar_url'] as String? ?? '',
  updatedAt: json['updatedAt'] as String? ?? '',
  createdAt: json['createdAt'] as String? ?? '',
  email: json['email'] as String? ?? '',
  loginAttempts: (json['loginAttempts'] as num?)?.toInt() ?? 0,
  avatar: json['avatar'] as String? ?? '',
);

Map<String, dynamic> _$NavApiDocsItemImageCreatedByDataToJson(
  _NavApiDocsItemImageCreatedByData instance,
) => <String, dynamic>{
  'id': instance.id,
  'sub': instance.sub,
  'external_provider': instance.externalProvider,
  'username': instance.username,
  'name': instance.name,
  'roles': instance.roles,
  'avatar_url': instance.avatarUrl,
  'updatedAt': instance.updatedAt,
  'createdAt': instance.createdAt,
  'email': instance.email,
  'loginAttempts': instance.loginAttempts,
  'avatar': instance.avatar,
};

_NavApiDocsItemImageSizesThumbnailData
_$NavApiDocsItemImageSizesThumbnailDataFromJson(Map<String, dynamic> json) =>
    _NavApiDocsItemImageSizesThumbnailData(
      url: json['url'] as String? ?? '',
      width: (json['width'] as num?)?.toInt() ?? 0,
      height: (json['height'] as num?)?.toInt() ?? 0,
      mimeType: json['mimeType'] as String? ?? '',
      filesize: (json['filesize'] as num?)?.toInt() ?? 0,
      filename: json['filename'] as String? ?? '',
    );

Map<String, dynamic> _$NavApiDocsItemImageSizesThumbnailDataToJson(
  _NavApiDocsItemImageSizesThumbnailData instance,
) => <String, dynamic>{
  'url': instance.url,
  'width': instance.width,
  'height': instance.height,
  'mimeType': instance.mimeType,
  'filesize': instance.filesize,
  'filename': instance.filename,
};

_NavApiDocsItemImageSizesData _$NavApiDocsItemImageSizesDataFromJson(
  Map<String, dynamic> json,
) => _NavApiDocsItemImageSizesData(
  thumbnail: json['thumbnail'] == null
      ? const NavApiDocsItemImageSizesThumbnailData()
      : NavApiDocsItemImageSizesThumbnailData.fromJson(
          json['thumbnail'] as Map<String, dynamic>,
        ),
  preload: json['preload'] == null
      ? const NavApiDocsItemImageSizesPreloadData()
      : NavApiDocsItemImageSizesPreloadData.fromJson(
          json['preload'] as Map<String, dynamic>,
        ),
  card: json['card'] == null
      ? const NavApiDocsItemImageSizesCardData()
      : NavApiDocsItemImageSizesCardData.fromJson(
          json['card'] as Map<String, dynamic>,
        ),
  tablet: json['tablet'] == null
      ? const NavApiDocsItemImageSizesTabletData()
      : NavApiDocsItemImageSizesTabletData.fromJson(
          json['tablet'] as Map<String, dynamic>,
        ),
  avatar: json['avatar'] == null
      ? const NavApiDocsItemImageSizesAvatarData()
      : NavApiDocsItemImageSizesAvatarData.fromJson(
          json['avatar'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$NavApiDocsItemImageSizesDataToJson(
  _NavApiDocsItemImageSizesData instance,
) => <String, dynamic>{
  'thumbnail': instance.thumbnail,
  'preload': instance.preload,
  'card': instance.card,
  'tablet': instance.tablet,
  'avatar': instance.avatar,
};

_NavApiDocsItemImageSizesPreloadData
_$NavApiDocsItemImageSizesPreloadDataFromJson(Map<String, dynamic> json) =>
    _NavApiDocsItemImageSizesPreloadData(
      url: json['url'],
      width: json['width'],
      height: json['height'],
      mimeType: json['mimeType'],
      filesize: json['filesize'],
      filename: json['filename'],
    );

Map<String, dynamic> _$NavApiDocsItemImageSizesPreloadDataToJson(
  _NavApiDocsItemImageSizesPreloadData instance,
) => <String, dynamic>{
  'url': instance.url,
  'width': instance.width,
  'height': instance.height,
  'mimeType': instance.mimeType,
  'filesize': instance.filesize,
  'filename': instance.filename,
};

_NavApiDocsItemImageSizesCardData _$NavApiDocsItemImageSizesCardDataFromJson(
  Map<String, dynamic> json,
) => _NavApiDocsItemImageSizesCardData(
  url: json['url'] as String? ?? '',
  width: (json['width'] as num?)?.toInt() ?? 0,
  height: (json['height'] as num?)?.toInt() ?? 0,
  mimeType: json['mimeType'] as String? ?? '',
  filesize: (json['filesize'] as num?)?.toInt() ?? 0,
  filename: json['filename'] as String? ?? '',
);

Map<String, dynamic> _$NavApiDocsItemImageSizesCardDataToJson(
  _NavApiDocsItemImageSizesCardData instance,
) => <String, dynamic>{
  'url': instance.url,
  'width': instance.width,
  'height': instance.height,
  'mimeType': instance.mimeType,
  'filesize': instance.filesize,
  'filename': instance.filename,
};

_NavApiDocsItemImageSizesTabletData
_$NavApiDocsItemImageSizesTabletDataFromJson(Map<String, dynamic> json) =>
    _NavApiDocsItemImageSizesTabletData(
      url: json['url'] as String? ?? '',
      width: (json['width'] as num?)?.toInt() ?? 0,
      height: (json['height'] as num?)?.toInt() ?? 0,
      mimeType: json['mimeType'] as String? ?? '',
      filesize: (json['filesize'] as num?)?.toInt() ?? 0,
      filename: json['filename'] as String? ?? '',
    );

Map<String, dynamic> _$NavApiDocsItemImageSizesTabletDataToJson(
  _NavApiDocsItemImageSizesTabletData instance,
) => <String, dynamic>{
  'url': instance.url,
  'width': instance.width,
  'height': instance.height,
  'mimeType': instance.mimeType,
  'filesize': instance.filesize,
  'filename': instance.filename,
};

_NavApiDocsItemImageSizesAvatarData
_$NavApiDocsItemImageSizesAvatarDataFromJson(Map<String, dynamic> json) =>
    _NavApiDocsItemImageSizesAvatarData(
      url: json['url'] as String? ?? '',
      width: (json['width'] as num?)?.toInt() ?? 0,
      height: (json['height'] as num?)?.toInt() ?? 0,
      mimeType: json['mimeType'] as String? ?? '',
      filesize: (json['filesize'] as num?)?.toInt() ?? 0,
      filename: json['filename'] as String? ?? '',
    );

Map<String, dynamic> _$NavApiDocsItemImageSizesAvatarDataToJson(
  _NavApiDocsItemImageSizesAvatarData instance,
) => <String, dynamic>{
  'url': instance.url,
  'width': instance.width,
  'height': instance.height,
  'mimeType': instance.mimeType,
  'filesize': instance.filesize,
  'filename': instance.filename,
};

_NavApiDocsItemTagsItemData _$NavApiDocsItemTagsItemDataFromJson(
  Map<String, dynamic> json,
) => _NavApiDocsItemTagsItemData(
  id: json['id'] as String? ?? '',
  name: json['name'] as String? ?? '',
  slug: json['slug'] as String? ?? '',
  updatedAt: json['updatedAt'] as String? ?? '',
  createdAt: json['createdAt'] as String? ?? '',
);

Map<String, dynamic> _$NavApiDocsItemTagsItemDataToJson(
  _NavApiDocsItemTagsItemData instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'slug': instance.slug,
  'updatedAt': instance.updatedAt,
  'createdAt': instance.createdAt,
};

_NavApiData _$NavApiDataFromJson(Map<String, dynamic> json) => _NavApiData(
  docs:
      (json['docs'] as List<dynamic>?)
          ?.map((e) => NavApiDocsItemData.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <NavApiDocsItemData>[],
  hasNextPage: json['hasNextPage'] as bool? ?? false,
  hasPrevPage: json['hasPrevPage'] as bool? ?? false,
  limit: (json['limit'] as num?)?.toInt() ?? 0,
  nextPage: json['nextPage'],
  page: (json['page'] as num?)?.toInt() ?? 0,
  pagingCounter: (json['pagingCounter'] as num?)?.toInt() ?? 0,
  prevPage: json['prevPage'],
  totalDocs: (json['totalDocs'] as num?)?.toInt() ?? 0,
  totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$NavApiDataToJson(_NavApiData instance) =>
    <String, dynamic>{
      'docs': instance.docs,
      'hasNextPage': instance.hasNextPage,
      'hasPrevPage': instance.hasPrevPage,
      'limit': instance.limit,
      'nextPage': instance.nextPage,
      'page': instance.page,
      'pagingCounter': instance.pagingCounter,
      'prevPage': instance.prevPage,
      'totalDocs': instance.totalDocs,
      'totalPages': instance.totalPages,
    };
