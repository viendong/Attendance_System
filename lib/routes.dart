import 'package:face_net_authentication/base/base_binding.dart';
import 'package:face_net_authentication/base/base_statefull.dart';
import 'package:face_net_authentication/pages/class/class_binding.dart';
import 'package:face_net_authentication/pages/class/class_page.dart';
import 'package:face_net_authentication/pages/login/login_binding.dart';
import 'package:face_net_authentication/pages/login/login_page.dart';
import 'package:face_net_authentication/pages/student/student_binding.dart';
import 'package:face_net_authentication/pages/student/student_page.dart';
import 'package:face_net_authentication/pages/teacher/teacher_binding.dart';
import 'package:face_net_authentication/pages/teacher/teacher_page.dart';
import 'package:flutter/material.dart';

Widget Function(BuildContext) _prepareWidget(
  BaseStatefulWidget widget,
  BaseBinding binding,
) {
  return (context) {
    binding.dependencies();
    return widget;
  };
}

Map<String, Widget Function(BuildContext)> getRoutes() {
  return {
    LoginPage.NAME: _prepareWidget(
      LoginPage(),
      LoginBinding(),
    ),
    StudentHomePage.NAME: _prepareWidget(
      StudentHomePage(),
      StudentBinding(),
    ),
    TeacherHomePage.NAME: _prepareWidget(
      TeacherHomePage(),
      TeacherBinding(),
    ),
    ClassPage.NAME: _prepareWidget(
      ClassPage(),
      ClassBinding(),
    ),
    // '/': (context) {
    //   return FaceDetectorView();
    // },
    // SignUp.NAME: _prepareWidget(
    //   SignUp(),
    //   SignUpBinding(),
    // ),
  };
}
