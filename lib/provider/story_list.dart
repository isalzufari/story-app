import 'dart:io';

import 'package:flutter/material.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/enum/state.dart';

import '../data/model/story.dart';

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

  int? pageItems = 1;
  int sizeItems = 10;

  Future<dynamic> getStories({bool isRefresh = false}) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      if (isRefresh) {
        pageItems = 1;
        _stories.clear();
      }

      final storiesResult = await apiService.getStories(pageItems!, sizeItems);

      if (storiesResult.listStory?.isNotEmpty == true) {
        _state = ResultState.hasData;
        _stories.addAll(storiesResult.listStory ?? List.empty());

        _message = storiesResult.message ?? "Get Stories Success!";
        pageItems = pageItems! + 1;
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
