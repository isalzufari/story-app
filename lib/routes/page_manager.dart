import 'dart:async';

import 'package:flutter/material.dart';

class PageManager extends ChangeNotifier {
  late Completer<dynamic> _completer;

  Future<dynamic> waitForResult() async {
    _completer = Completer<dynamic>();
    return _completer.future;
  }

  void returnData(dynamic value) {
    _completer.complete(value);
  }
}
