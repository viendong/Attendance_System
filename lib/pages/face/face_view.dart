import 'package:camera/camera.dart';
import 'package:face_net_authentication/pages/face/camera_view.dart';
import 'package:face_net_authentication/services/ml_service.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'painters/face_detector_painter.dart';

class FaceDetectorView extends StatefulWidget {
  const FaceDetectorView({
    super.key,
  });

  @override
  State<FaceDetectorView> createState() => _FaceDetectorViewState();
}

class _FaceDetectorViewState extends State<FaceDetectorView> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
        // enableContours: true,
        // enableLandmarks: true,
        ),
  );
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  bool loading = false;
  List<Face> faces = [];

  MLService mlService = MLService();

  var _cameraLensDirection = CameraLensDirection.front;

  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _start();
  }

  void _start() async {
    setState(() {
      loading = true;
    });
    await mlService.initialize();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return IosCameraView(
      customPaint: _customPaint,
      onImage: _iosProcessImage,
      initialCameraLensDirection: _cameraLensDirection,
      setCurrentPrediction: mlService.setCurrentPrediction,
      capture: capture,
      onClose: () {
        Navigator.pop(context, []);
      },
    );
  }

  Future<void> capture() async {
    if (this.faces.isNotEmpty) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Face Captured'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      Navigator.pop(context, mlService.predictedData);
    } else {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Failed'),
          content: Text('Face Not Captured!!! Please Try Again'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<Face?> _iosProcessImage(InputImage inputImage) async {
    if (!_canProcess) return null;
    if (_isBusy) return null;
    _isBusy = true;

    final faces = await _faceDetector.processImage(inputImage);
    this.faces = faces;

    final painter = FaceDetectorPainter(
      faces,
      inputImage.metadata!.size,
      inputImage.metadata!.rotation,
      _cameraLensDirection,
    );
    _customPaint = CustomPaint(painter: painter);

    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
    return faces.isNotEmpty ? faces.first : null;
  }
}
