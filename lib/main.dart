import 'dart:async';

import 'package:face_net_authentication/client/firebase_core.dart';
import 'package:face_net_authentication/config.dart';
import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/pages/login/login_page.dart';
import 'package:face_net_authentication/router/navigator.dart';
import 'package:face_net_authentication/routes.dart';
import 'package:face_net_authentication/utils/logger.dart';
import 'package:flutter/material.dart';

void main() async {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      setupServices();

      Config config = locator<Config>();
      await config.loadEnvVariables();
      if (config.isEmpty('API_SCHEME')) {
        if (['localhost', '127.0.0.1', '10.0.2.2', '0.0.0.0']
            .contains(config.get('API_HOST'))) {
          config.set('API_SCHEME', 'http');
        } else {
          config.set('API_SCHEME', 'https');
        }
      }
      if (config.isEmpty('API_PORT')) {
        if (config.get('API_SCHEME') == 'http') {
          config.set('API_PORT', '8080');
        } else {
          config.set('API_PORT', '');
        }
      }

      FirebaseCoreRepository firebaseCoreRepository =
          locator<FirebaseCoreRepository>();

      await firebaseCoreRepository.initialApp();

      runApp(MyApp());
    },
    (error, stack) => logger.e(error),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      navigatorKey: locator<ScreenRouter>().navigatorKey,
      routes: getRoutes(),
      initialRoute: LoginPage.NAME,
    );
  }
}
