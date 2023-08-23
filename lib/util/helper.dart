import 'package:flutter/material.dart';

afterBuildWidgetCallback(VoidCallback callback) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    callback.call();
  });
}
