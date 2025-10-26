import 'package:freezed_annotation/freezed_annotation.dart';

part 'citizen_news_data.freezed.dart';

part 'citizen_news_data.g.dart';

@freezed
sealed class CitizenNewsData with _$CitizenNewsData {
  const factory CitizenNewsData({
    @Default(<CitizenNewsVideosItemData>[]) @JsonKey(name: 'videos') List<CitizenNewsVideosItemData> videos,
    @Default(<CitizenNewsArticlesItemData>[]) @JsonKey(name: 'articles') List<CitizenNewsArticlesItemData> articles,
  }) = _CitizenNewsData;

  const CitizenNewsData._();

  factory CitizenNewsData.fromJson(Map<String, Object?> json) => _$CitizenNewsDataFromJson(json);
}

@freezed
sealed class CitizenNewsVideosItemData with _$CitizenNewsVideosItemData {
  const factory CitizenNewsVideosItemData({
    @Default('') @JsonKey(name: 'title') String title,
    @Default('') @JsonKey(name: 'author') String author,
    @Default('') @JsonKey(name: 'description') String description,
    @Default('') @JsonKey(name: 'link') String link,
    @Default('') @JsonKey(name: 'pubDate') String pubDate,
    @Default('') @JsonKey(name: 'postId') String postId,
    @Default(<String>[]) @JsonKey(name: 'detailedDescription') List<String> detailedDescription,
    @Default('') @JsonKey(name: 'tag') String tag,
  }) = _CitizenNewsVideosItemData;

  const CitizenNewsVideosItemData._();

  factory CitizenNewsVideosItemData.fromJson(Map<String, Object?> json) => _$CitizenNewsVideosItemDataFromJson(json);
}

@freezed
sealed class CitizenNewsArticlesItemData with _$CitizenNewsArticlesItemData {
  const factory CitizenNewsArticlesItemData({
    @Default('') @JsonKey(name: 'title') String title,
    @Default('') @JsonKey(name: 'author') String author,
    @Default('') @JsonKey(name: 'description') String description,
    @Default('') @JsonKey(name: 'link') String link,
    @Default('') @JsonKey(name: 'pubDate') String pubDate,
    @Default('') @JsonKey(name: 'postId') String postId,
    @Default(<String>[]) @JsonKey(name: 'detailedDescription') List<String> detailedDescription,
    @Default('') @JsonKey(name: 'tag') String tag,
  }) = _CitizenNewsArticlesItemData;

  const CitizenNewsArticlesItemData._();

  factory CitizenNewsArticlesItemData.fromJson(Map<String, Object?> json) =>
      _$CitizenNewsArticlesItemDataFromJson(json);
}
