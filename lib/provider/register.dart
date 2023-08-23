import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/enum/state.dart';
import 'package:story_app/data/model/request_register.dart';

class RegisterProvider extends ChangeNotifier {
  final ApiService apiService;

  RegisterProvider(this.apiService);

  ResultState? _registerState;
  ResultState? get registerState => _registerState;

  String _registerMessage = "";
  String get registerMessage => _registerMessage;

  Future<dynamic> register(RegisterRequest request) async {
    try {
      _registerState = ResultState.loading;
      notifyListeners();

      final registerResult = await apiService.register(request);
      print(registerResult);
      if (registerResult.error != true) {
        _registerState = ResultState.hasData;

        _registerMessage = registerResult.message ?? "Account Created!";
      } else {
        _registerState = ResultState.noData;

        _registerMessage = registerResult.message ?? "Register Failed";
      }
    } on SocketException {
      _registerState = ResultState.error;

      return _registerMessage = "Error: No Internet Connection!";
    } catch (e) {
      _registerState = ResultState.error;

      _registerMessage = "Error: $e";
    } finally {
      notifyListeners();
    }
  }
}
