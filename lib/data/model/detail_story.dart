class DetailStory {
  bool? error;
  String? message;
  Story? story;

  DetailStory({this.error, this.message, this.story});

  DetailStory.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    story = json['story'] != null ? Story.fromJson(json['story']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['message'] = message;
    if (story != null) {
      data['story'] = story!.toJson();
    }
    return data;
  }
}

class Story {
  String? id;
  String? name;
  String? description;
  String? photoUrl;
  String? createdAt;
  double? lat;
  double? lon;

  Story(
      {this.id,
      this.name,
      this.description,
      this.photoUrl,
      this.createdAt,
      this.lat,
      this.lon});

  Story.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    photoUrl = json['photoUrl'];
    createdAt = json['createdAt'];
    lat = json['lat'];
    lon = json['lon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['photoUrl'] = photoUrl;
    data['createdAt'] = createdAt;
    data['lat'] = lat;
    data['lon'] = lon;
    return data;
  }
}
