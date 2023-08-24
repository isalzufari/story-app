import 'package:json_annotation/json_annotation.dart';
import 'story.dart';

part 'stories.g.dart';

@JsonSerializable()
class Stories {
  bool? error;
  String? message;
  List<Story>? listStory;

  Stories({this.error, this.message, this.listStory});

  factory Stories.fromJson(Map<String, dynamic> json) =>
      _$StoriesFromJson(json);

  Map<String, dynamic> toJson() => _$StoriesToJson(this);
}
