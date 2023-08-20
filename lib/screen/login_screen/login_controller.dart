import 'package:face_net_authentication/service/camera.service.dart';
import 'package:face_net_authentication/service/face_detector_service.dart';
import 'package:face_net_authentication/service/ml_service.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class LoginScreenController extends SuperController {
  MLService _mlService = MLService.instance;
  // FaceDetectorService _mlKitService = locator<FaceDetectorService>();
  // CameraService _cameraService = locator<CameraService>();
  bool loading = false;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onDetached() {
    // TODO: implement onDetached
  }

  @override
  void onInactive() {
    // TODO: implement onInactive
  }

  @override
  void onPaused() {
    // TODO: implement onPaused
  }

  @override
  void onResumed() {
    // TODO: implement onResumed
  }
}
