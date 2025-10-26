// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'citizen_news_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CitizenNewsData _$CitizenNewsDataFromJson(
  Map<String, dynamic> json,
) => _CitizenNewsData(
  videos:
      (json['videos'] as List<dynamic>?)
          ?.map(
            (e) =>
                CitizenNewsVideosItemData.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <CitizenNewsVideosItemData>[],
  articles:
      (json['articles'] as List<dynamic>?)
          ?.map(
            (e) =>
                CitizenNewsArticlesItemData.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <CitizenNewsArticlesItemData>[],
);

Map<String, dynamic> _$CitizenNewsDataToJson(_CitizenNewsData instance) =>
    <String, dynamic>{'videos': instance.videos, 'articles': instance.articles};

_CitizenNewsVideosItemData _$CitizenNewsVideosItemDataFromJson(
  Map<String, dynamic> json,
) => _CitizenNewsVideosItemData(
  title: json['title'] as String? ?? '',
  author: json['author'] as String? ?? '',
  description: json['description'] as String? ?? '',
  link: json['link'] as String? ?? '',
  pubDate: json['pubDate'] as String? ?? '',
  postId: json['postId'] as String? ?? '',
  detailedDescription:
      (json['detailedDescription'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  tag: json['tag'] as String? ?? '',
);

Map<String, dynamic> _$CitizenNewsVideosItemDataToJson(
  _CitizenNewsVideosItemData instance,
) => <String, dynamic>{
  'title': instance.title,
  'author': instance.author,
  'description': instance.description,
  'link': instance.link,
  'pubDate': instance.pubDate,
  'postId': instance.postId,
  'detailedDescription': instance.detailedDescription,
  'tag': instance.tag,
};

_CitizenNewsArticlesItemData _$CitizenNewsArticlesItemDataFromJson(
  Map<String, dynamic> json,
) => _CitizenNewsArticlesItemData(
  title: json['title'] as String? ?? '',
  author: json['author'] as String? ?? '',
  description: json['description'] as String? ?? '',
  link: json['link'] as String? ?? '',
  pubDate: json['pubDate'] as String? ?? '',
  postId: json['postId'] as String? ?? '',
  detailedDescription:
      (json['detailedDescription'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  tag: json['tag'] as String? ?? '',
);

Map<String, dynamic> _$CitizenNewsArticlesItemDataToJson(
  _CitizenNewsArticlesItemData instance,
) => <String, dynamic>{
  'title': instance.title,
  'author': instance.author,
  'description': instance.description,
  'link': instance.link,
  'pubDate': instance.pubDate,
  'postId': instance.postId,
  'detailedDescription': instance.detailedDescription,
  'tag': instance.tag,
};
