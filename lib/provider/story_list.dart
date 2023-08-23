import 'dart:io';

import 'package:flutter/material.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/enum/state.dart';

import '../data/model/detail_story.dart';

class ListStoryProvider extends ChangeNotifier {
  final ApiService apiService;

  ListStoryProvider(this.apiService) {
    getStories();
  }

  ResultState? _state;
  ResultState? get state => _state;

  String _message = "";
  String get message => _message;

  final List<Story> _stories = [];
  List<Story> get stories => _stories;

  Future<dynamic> getStories() async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final storiesResult = await apiService.getStories();

      if (storiesResult.listStory?.isNotEmpty == true) {
        _state = ResultState.hasData;
        _stories.clear();
        _stories.addAll(storiesResult.listStory ?? List.empty());

        _message = storiesResult.message ?? "Get Stories Success!";
      } else {
        _state = ResultState.noData;

        _message = storiesResult.message ?? "Get Stories Failed";
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
