import 'dart:core';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter/material.dart';

class FaceDetectorService {
  late FaceDetector _faceDetector;
  FaceDetector get faceDetector => _faceDetector;

  List<Face> _faces = [];
  List<Face> get faces => _faces;
  bool get faceDetected => _faces.isNotEmpty;

  void initialize() {
    _faceDetector = GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(
        performanceMode: FaceDetectorMode.accurate,
      ),
    );
  }

  Future<void> detectFacesFromImage(
      {required CameraImage image,
      required InputImageRotation rotation}) async {
    InputImageMetadata _firebaseImageMetadata = InputImageMetadata(
      rotation: rotation,

      // inputImageFormat: InputImageFormat.yuv_420_888,

      format: InputImageFormatValue.fromRawValue(image.format.raw)
          // InputImageFormatMethods.fromRawValue(image.format.raw) for new version
          ??
          InputImageFormat.yuv420,
      size: Size(image.width.toDouble(), image.height.toDouble()),
      bytesPerRow: image.planes.first.bytesPerRow,
    );

    // for mlkit 13
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    InputImage _firebaseVisionImage = InputImage.fromBytes(
      // bytes: image.planes[0].bytes,
      bytes: bytes,
      metadata: _firebaseImageMetadata,
    );
    // for mlkit 13

    _faces = await _faceDetector.processImage(_firebaseVisionImage);
  }

  dispose() {
    _faceDetector.close();
  }
}
