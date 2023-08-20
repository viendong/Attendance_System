import 'package:face_net_authentication/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseCoreRepository {
  factory FirebaseCoreRepository() {
    return _repo;
  }
  FirebaseCoreRepository._();
  static final _repo = FirebaseCoreRepository._();
  static late FirebaseApp app;

  /// Should run when start app
  Future<FirebaseApp?> initialApp() async {
    final initApp = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    app = initApp;
    return app;
  }
}
