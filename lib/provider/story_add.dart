import 'dart:io';

import 'package:flutter/material.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/enum/state.dart';
import 'package:story_app/data/model/request_add_story.dart';

class AddStoryProvider extends ChangeNotifier {
  final ApiService apiService;

  AddStoryProvider(this.apiService);

  ResultState? _state;
  ResultState? get state => _state;

  String _message = "";
  String get message => _message;

  Future<dynamic> addStory(AddStoryRequest story) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final detailStoryResult = await apiService.addStory(story);

      if (detailStoryResult.error == true) {
        _state = ResultState.error;

        _message = detailStoryResult.message ?? "Error when uploading!";
      } else {
        _state = ResultState.hasData;

        _message = detailStoryResult.message ?? "Success upload story!";
      }
    } on SocketException {
      _state = ResultState.error;

      _message = "Error: No Internet Connection";
    } catch (e) {
      _state = ResultState.error;

      _message = "Error: $e";
    } finally {
      notifyListeners();
    }
  }
}
