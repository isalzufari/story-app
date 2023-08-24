import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPageManager extends ChangeNotifier {
  late Completer<LatLng> _completer;

  Future<LatLng> waitForResult() async {
    _completer = Completer<LatLng>();
    return _completer.future;
  }

  void returnData(LatLng value) {
    _completer.complete(value);
  }
}
