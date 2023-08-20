import 'dart:async';

// import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/client/firebase/firebase_core_repository.dart';
import 'package:face_net_authentication/page/home.dart';
import 'package:face_net_authentication/screen/login_screen/login_binding.dart';
import 'package:face_net_authentication/screen/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// void main() {
//   setupServices();
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: MyHomePage(),
      initialRoute: LoginScreen.NAME,
      getPages: [
        GetPage(
          name: LoginScreen.NAME,
          page: () => LoginScreen(),
          binding: LoginScreenBinding(),
          transition: Transition.noTransition,
        ),
      ],
    );
  }
}

void main() async {
  runZonedGuarded<Future<void>>(
    () async {
      final firebaseCore = FirebaseCoreRepository();
      await firebaseCore.initialApp();
      runApp(const MyApp());
    },
    (error, stack) {
      print(error.toString());
    },
  );
}
