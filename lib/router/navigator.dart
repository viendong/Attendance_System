import 'dart:io';

import 'package:face_net_authentication/base/base_binding.dart';
import 'package:face_net_authentication/pages/and_face/face_view.dart';
import 'package:face_net_authentication/pages/face/face_view.dart';
import 'package:flutter/material.dart';

class ScreenRouter {
  ScreenRouter();

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  Future<T?> goToSubview<T>(Widget screen, {BaseBinding? binding}) async {
    final data = await _navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (context) {
          if (binding != null) {
            binding.dependencies();
          }
          return screen;
        },
      ),
    );
    return data;
  }

  Future<T?> goToFaceDetector<T>() async {
    if (Platform.isAndroid) {
      final data = await _navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (context) {
            return SignUp();
          },
        ),
      );
      return data;
    } else {
      final data = await _navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (context) {
            return FaceDetectorView();
          },
        ),
      );
      return data;
    }
  }

  void goToAndRemoveCurrent(String routeName, {dynamic arguments}) {
    _navigatorKey.currentState!.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  Future<void> goTo(String routeName) async {
    _navigatorKey.currentState!.pushNamed(routeName);
  }

  void goBack({
    dynamic value,
  }) {
    _navigatorKey.currentState!.pop(value);
  }
}
