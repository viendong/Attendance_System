import 'package:face_net_authentication/config.dart';
import 'package:face_net_authentication/locator.dart';

class Constants {
  static String githubURL =
      "https://github.com/MCarlomagno/FaceRecognitionAuth/tree/master";

  Config config = locator<Config>();

  String getBaseURL() {
    return 'https://backend-1-w0768385.deta.app';
    // return "${config.get("API_SCHEME")}://${config.get("API_HOST")}${!config.isEmpty("API_PORT") ? ":${config.get("API_PORT")}" : ""}";
  }
}

enum SignInMethod { googleId, appleId }
