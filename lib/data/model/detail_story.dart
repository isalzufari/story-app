import 'package:json_annotation/json_annotation.dart';

import 'story.dart';

part 'detail_story.g.dart';

@JsonSerializable()
class DetailStory {
  bool? error;
  String? message;
  Story? story;

  DetailStory({this.error, this.message, this.story});

  factory DetailStory.fromJson(Map<String, dynamic> json) =>
      _$DetailStoryFromJson(json);

  Map<String, dynamic> toJson() => _$DetailStoryToJson(this);
}
