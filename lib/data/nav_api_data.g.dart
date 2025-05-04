// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nav_api_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NavApiDocsItemDataImpl _$$NavApiDocsItemDataImplFromJson(
        Map<String, dynamic> json) =>
    _$NavApiDocsItemDataImpl(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      abstract_: json['abstract'] as String? ?? '',
      description: json['description'] as String? ?? '',
      image: json['image'] == null
          ? const NavApiDocsItemImageData()
          : NavApiDocsItemImageData.fromJson(
              json['image'] as Map<String, dynamic>),
      link: json['link'] as String? ?? '',
      isSponsored: json['is_sponsored'] as bool? ?? false,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => NavApiDocsItemTagsItemData.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const <NavApiDocsItemTagsItemData>[],
      updatedAt: json['updatedAt'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
    );

Map<String, dynamic> _$$NavApiDocsItemDataImplToJson(
        _$NavApiDocsItemDataImpl instance) =>
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

_$NavApiDocsItemImageDataImpl _$$NavApiDocsItemImageDataImplFromJson(
        Map<String, dynamic> json) =>
    _$NavApiDocsItemImageDataImpl(
      id: json['id'] as String? ?? '',
      createdBy: json['createdBy'] == null
          ? const NavApiDocsItemImageCreatedByData()
          : NavApiDocsItemImageCreatedByData.fromJson(
              json['createdBy'] as Map<String, dynamic>),
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
              json['sizes'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$NavApiDocsItemImageDataImplToJson(
        _$NavApiDocsItemImageDataImpl instance) =>
    <String, dynamic>{
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

_$NavApiDocsItemImageCreatedByDataImpl
    _$$NavApiDocsItemImageCreatedByDataImplFromJson(
            Map<String, dynamic> json) =>
        _$NavApiDocsItemImageCreatedByDataImpl(
          id: json['id'] as String? ?? '',
          sub: json['sub'] as String? ?? '',
          externalProvider: json['external_provider'] as String? ?? '',
          username: json['username'] as String? ?? '',
          name: json['name'] as String? ?? '',
          roles: (json['roles'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList() ??
              const <String>[],
          avatarUrl: json['avatar_url'] as String? ?? '',
          updatedAt: json['updatedAt'] as String? ?? '',
          createdAt: json['createdAt'] as String? ?? '',
          email: json['email'] as String? ?? '',
          loginAttempts: (json['loginAttempts'] as num?)?.toInt() ?? 0,
          avatar: json['avatar'] as String? ?? '',
        );

Map<String, dynamic> _$$NavApiDocsItemImageCreatedByDataImplToJson(
        _$NavApiDocsItemImageCreatedByDataImpl instance) =>
    <String, dynamic>{
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

_$NavApiDocsItemImageSizesThumbnailDataImpl
    _$$NavApiDocsItemImageSizesThumbnailDataImplFromJson(
            Map<String, dynamic> json) =>
        _$NavApiDocsItemImageSizesThumbnailDataImpl(
          url: json['url'] as String? ?? '',
          width: (json['width'] as num?)?.toInt() ?? 0,
          height: (json['height'] as num?)?.toInt() ?? 0,
          mimeType: json['mimeType'] as String? ?? '',
          filesize: (json['filesize'] as num?)?.toInt() ?? 0,
          filename: json['filename'] as String? ?? '',
        );

Map<String, dynamic> _$$NavApiDocsItemImageSizesThumbnailDataImplToJson(
        _$NavApiDocsItemImageSizesThumbnailDataImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'width': instance.width,
      'height': instance.height,
      'mimeType': instance.mimeType,
      'filesize': instance.filesize,
      'filename': instance.filename,
    };

_$NavApiDocsItemImageSizesDataImpl _$$NavApiDocsItemImageSizesDataImplFromJson(
        Map<String, dynamic> json) =>
    _$NavApiDocsItemImageSizesDataImpl(
      thumbnail: json['thumbnail'] == null
          ? const NavApiDocsItemImageSizesThumbnailData()
          : NavApiDocsItemImageSizesThumbnailData.fromJson(
              json['thumbnail'] as Map<String, dynamic>),
      preload: json['preload'] == null
          ? const NavApiDocsItemImageSizesPreloadData()
          : NavApiDocsItemImageSizesPreloadData.fromJson(
              json['preload'] as Map<String, dynamic>),
      card: json['card'] == null
          ? const NavApiDocsItemImageSizesCardData()
          : NavApiDocsItemImageSizesCardData.fromJson(
              json['card'] as Map<String, dynamic>),
      tablet: json['tablet'] == null
          ? const NavApiDocsItemImageSizesTabletData()
          : NavApiDocsItemImageSizesTabletData.fromJson(
              json['tablet'] as Map<String, dynamic>),
      avatar: json['avatar'] == null
          ? const NavApiDocsItemImageSizesAvatarData()
          : NavApiDocsItemImageSizesAvatarData.fromJson(
              json['avatar'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$NavApiDocsItemImageSizesDataImplToJson(
        _$NavApiDocsItemImageSizesDataImpl instance) =>
    <String, dynamic>{
      'thumbnail': instance.thumbnail,
      'preload': instance.preload,
      'card': instance.card,
      'tablet': instance.tablet,
      'avatar': instance.avatar,
    };

_$NavApiDocsItemImageSizesPreloadDataImpl
    _$$NavApiDocsItemImageSizesPreloadDataImplFromJson(
            Map<String, dynamic> json) =>
        _$NavApiDocsItemImageSizesPreloadDataImpl(
          url: json['url'],
          width: json['width'],
          height: json['height'],
          mimeType: json['mimeType'],
          filesize: json['filesize'],
          filename: json['filename'],
        );

Map<String, dynamic> _$$NavApiDocsItemImageSizesPreloadDataImplToJson(
        _$NavApiDocsItemImageSizesPreloadDataImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'width': instance.width,
      'height': instance.height,
      'mimeType': instance.mimeType,
      'filesize': instance.filesize,
      'filename': instance.filename,
    };

_$NavApiDocsItemImageSizesCardDataImpl
    _$$NavApiDocsItemImageSizesCardDataImplFromJson(
            Map<String, dynamic> json) =>
        _$NavApiDocsItemImageSizesCardDataImpl(
          url: json['url'] as String? ?? '',
          width: (json['width'] as num?)?.toInt() ?? 0,
          height: (json['height'] as num?)?.toInt() ?? 0,
          mimeType: json['mimeType'] as String? ?? '',
          filesize: (json['filesize'] as num?)?.toInt() ?? 0,
          filename: json['filename'] as String? ?? '',
        );

Map<String, dynamic> _$$NavApiDocsItemImageSizesCardDataImplToJson(
        _$NavApiDocsItemImageSizesCardDataImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'width': instance.width,
      'height': instance.height,
      'mimeType': instance.mimeType,
      'filesize': instance.filesize,
      'filename': instance.filename,
    };

_$NavApiDocsItemImageSizesTabletDataImpl
    _$$NavApiDocsItemImageSizesTabletDataImplFromJson(
            Map<String, dynamic> json) =>
        _$NavApiDocsItemImageSizesTabletDataImpl(
          url: json['url'] as String? ?? '',
          width: (json['width'] as num?)?.toInt() ?? 0,
          height: (json['height'] as num?)?.toInt() ?? 0,
          mimeType: json['mimeType'] as String? ?? '',
          filesize: (json['filesize'] as num?)?.toInt() ?? 0,
          filename: json['filename'] as String? ?? '',
        );

Map<String, dynamic> _$$NavApiDocsItemImageSizesTabletDataImplToJson(
        _$NavApiDocsItemImageSizesTabletDataImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'width': instance.width,
      'height': instance.height,
      'mimeType': instance.mimeType,
      'filesize': instance.filesize,
      'filename': instance.filename,
    };

_$NavApiDocsItemImageSizesAvatarDataImpl
    _$$NavApiDocsItemImageSizesAvatarDataImplFromJson(
            Map<String, dynamic> json) =>
        _$NavApiDocsItemImageSizesAvatarDataImpl(
          url: json['url'] as String? ?? '',
          width: (json['width'] as num?)?.toInt() ?? 0,
          height: (json['height'] as num?)?.toInt() ?? 0,
          mimeType: json['mimeType'] as String? ?? '',
          filesize: (json['filesize'] as num?)?.toInt() ?? 0,
          filename: json['filename'] as String? ?? '',
        );

Map<String, dynamic> _$$NavApiDocsItemImageSizesAvatarDataImplToJson(
        _$NavApiDocsItemImageSizesAvatarDataImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'width': instance.width,
      'height': instance.height,
      'mimeType': instance.mimeType,
      'filesize': instance.filesize,
      'filename': instance.filename,
    };

_$NavApiDocsItemTagsItemDataImpl _$$NavApiDocsItemTagsItemDataImplFromJson(
        Map<String, dynamic> json) =>
    _$NavApiDocsItemTagsItemDataImpl(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
    );

Map<String, dynamic> _$$NavApiDocsItemTagsItemDataImplToJson(
        _$NavApiDocsItemTagsItemDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'updatedAt': instance.updatedAt,
      'createdAt': instance.createdAt,
    };

_$NavApiDataImpl _$$NavApiDataImplFromJson(Map<String, dynamic> json) =>
    _$NavApiDataImpl(
      docs: (json['docs'] as List<dynamic>?)
              ?.map(
                  (e) => NavApiDocsItemData.fromJson(e as Map<String, dynamic>))
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

Map<String, dynamic> _$$NavApiDataImplToJson(_$NavApiDataImpl instance) =>
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
