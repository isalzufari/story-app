import 'dart:ffi';
import 'dart:io';

class AddStoryRequest {
  String description;
  File photo;
  Float? lat;
  Float? lon;

  AddStoryRequest(
      {required this.description, required this.photo, this.lat, this.lon});
}
