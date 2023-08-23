import 'dart:io';

import 'package:flutter/material.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/enum/state.dart';
import 'package:story_app/data/model/request_login.dart';
import 'package:story_app/data/preferences/token.dart';

class LoginProvider extends ChangeNotifier {
  final ApiService apiService;
  final Token token;

  LoginProvider(this.apiService, this.token);

  ResultState? _loginState;
  ResultState? get loginState => _loginState;

  String _loginMessage = "";
  String get loginMessage => _loginMessage;

  Future<dynamic> login(LoginRequest request) async {
    try {
      _loginState = ResultState.loading;
      notifyListeners();

      final loginResult = await apiService.login(request);
      print(loginResult);
      if (loginResult.error != true) {
        _loginState = ResultState.hasData;
        token.setToken(loginResult.loginResult?.token ?? "");

        _loginMessage = loginResult.message ?? "Login Success!";
      } else {
        _loginState = ResultState.noData;

        _loginMessage = loginResult.message ?? "Login Failed!";
      }
    } on SocketException {
      _loginState = ResultState.error;

      _loginMessage = "Error: No Internet Connection";
    } catch (e) {
      _loginState = ResultState.error;

      _loginMessage = "Error: $e";
    } finally {
      notifyListeners();
    }
  }
}
