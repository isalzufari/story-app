import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:story_app/data/model/base_response.dart';
import 'package:story_app/data/model/detail_story.dart';
import 'package:story_app/data/model/stories.dart';
import 'package:story_app/data/model/login.dart';
import 'package:story_app/data/model/request_add_story.dart';
import 'package:story_app/data/model/request_login.dart';
import 'package:story_app/data/model/request_register.dart';
import 'package:story_app/data/preferences/token.dart';

class ApiService {
  static const String _baseUrl = "https://story-api.dicoding.dev/v1";
  static const Duration timeout = Duration(seconds: 5);
  static final Uri _loginEndpoint = Uri.parse("$_baseUrl/login");
  static final Uri _registerEndpoint = Uri.parse("$_baseUrl/register");
  static final Uri _storiesEndpoint = Uri.parse("$_baseUrl/stories");

  Uri _detailStoryEndpoint(String id) => Uri.parse("$_baseUrl/stories/$id");

  Future<Login> login(LoginRequest request) async {
    final response = await http
        .post(_loginEndpoint, body: request.toJson())
        .timeout(timeout);
    var login = Login.fromJson(json.decode(response.body));

    if (_isResponseSuccess(response.statusCode)) {
      return login;
    } else {
      throw Exception("${response.statusCode} - ${login.message}");
    }
  }

  Future<BaseResponse> register(RegisterRequest request) async {
    final response = await http
        .post(_registerEndpoint, body: request.toJson())
        .timeout(timeout);

    var baseResponse = BaseResponse.fromJson(json.decode(response.body));

    if (_isResponseSuccess(response.statusCode)) {
      return baseResponse;
    } else {
      throw Exception("${response.statusCode} - ${baseResponse.message}");
    }
  }

  Future<Stories> getStories() async {
    var tokenPref = Token();
    var token = await tokenPref.getToken();

    final response = await http.get(_storiesEndpoint, headers: {
      'Authorization': 'Bearer $token',
    }).timeout(timeout);

    var stories = Stories.fromJson(json.decode(response.body));
    if (_isResponseSuccess(response.statusCode)) {
      return stories;
    } else {
      throw Exception("${response.statusCode} - ${stories.message}");
    }
  }

  Future<DetailStory> getDetailStory(String id) async {
    var tokenPref = Token();
    var token = await tokenPref.getToken();

    final response = await http.get(_detailStoryEndpoint(id), headers: {
      'Authorization': 'Bearer $token',
    }).timeout(timeout);

    var detailStory = DetailStory.fromJson(json.decode(response.body));

    if (_isResponseSuccess(response.statusCode)) {
      return detailStory;
    } else {
      throw Exception("${response.statusCode} - ${detailStory.message}");
    }
  }

  Future<BaseResponse> addStory(AddStoryRequest story) async {
    var tokenPref = Token();
    var token = await tokenPref.getToken();

    final request = http.MultipartRequest('POST', _storiesEndpoint);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['description'] = story.description;
    request.files.add(http.MultipartFile(
      'photo',
      story.photo.readAsBytes().asStream(),
      story.photo.lengthSync(),
      filename: story.photo.path.split('/').last,
    ));
    if (story.lat != null) {
      request.fields['lat'] = story.lat.toString();
      request.fields['lon'] = story.lon.toString();
    }

    final response = await request.send().timeout(timeout);

    if (_isResponseSuccess(response.statusCode)) {
      String responseBody = await response.stream.bytesToString();
      return BaseResponse.fromJson(json.decode(responseBody));
    } else {
      throw Exception("${response.statusCode} - Error when upload story");
    }
  }

  _isResponseSuccess(int statusCode) => (statusCode >= 200 && statusCode < 300);
}
