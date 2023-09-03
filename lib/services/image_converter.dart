import 'dart:typed_data';

import 'package:image/image.dart' as imglib;
import 'package:camera/camera.dart';

imglib.Image convertToImage(CameraImage image) {
  try {
    if (image.format.group == ImageFormatGroup.yuv420) {
      return _convertYUV420(image);
    } else if (image.format.group == ImageFormatGroup.bgra8888) {
      return _convertBGRA8888(image);
    } else if (image.format.group == ImageFormatGroup.nv21) {
      return testConvert(image);
    }
    throw Exception('Image format not supported');
  } catch (e) {
    print("ERROR:" + e.toString());
  }
  throw Exception('Image format not supported');
}

// imglib.Image _convertBGRA8888(CameraImage image) {
//   return imglib.Image.fromBytes(
//     width: image.width,
//     height: image.height,
//     bytes: image.planes[0].bytes,
//     format: imglib.Format.bgra8888,
//   );
// }

imglib.Image _convertBGRA8888(CameraImage cameraImage) {
    imglib.Image img = imglib.Image.fromBytes(
        width: cameraImage.planes[0].width!,
        height: cameraImage.planes[0].height!,
        bytes: cameraImage.planes[0].bytes.buffer,
        order: imglib.ChannelOrder.bgra);
    return img;
  }

// imglib.Image _convertYUV420(CameraImage image) {
//   int width = image.width;
//   int height = image.height;
//   var img = imglib.Image(width, height);
//   const int hexFF = 0xFF000000;
//   final int uvyButtonStride = image.planes[1].bytesPerRow;
//   final int? uvPixelStride = image.planes[1].bytesPerPixel;
//   for (int x = 0; x < width; x++) {
//     for (int y = 0; y < height; y++) {
//       final int uvIndex =
//           uvPixelStride! * (x / 2).floor() + uvyButtonStride * (y / 2).floor();
//       final int index = y * width + x;
//       final yp = image.planes[0].bytes[index];
//       final up = image.planes[1].bytes[uvIndex];
//       final vp = image.planes[2].bytes[uvIndex];
//       int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
//       int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
//           .round()
//           .clamp(0, 255);
//       int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
//       img.data[index] = hexFF | (b << 16) | (g << 8) | r;
//     }
//   }

//   return img;
// }

imglib.Image _convertYUV420(CameraImage cameraImage) {
    final imageWidth = cameraImage.width;
    final imageHeight = cameraImage.height;

    final yBuffer = cameraImage.planes[0].bytes;
    final uBuffer = cameraImage.planes[1].bytes;
    final vBuffer = cameraImage.planes[2].bytes;

    final int yRowStride = cameraImage.planes[0].bytesPerRow;
    final int yPixelStride = cameraImage.planes[0].bytesPerPixel!;

    final int uvRowStride = cameraImage.planes[1].bytesPerRow;
    final int uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    final image = imglib.Image(width: imageWidth, height: imageHeight);

    for (int h = 0; h < imageHeight; h++) {
      int uvh = (h / 2).floor();

      for (int w = 0; w < imageWidth; w++) {
        int uvw = (w / 2).floor();

        final yIndex = (h * yRowStride) + (w * yPixelStride);

        // Y plane should have positive values belonging to [0...255]
        final int y = yBuffer[yIndex];

        // U/V Values are subsampled i.e. each pixel in U/V chanel in a
        // YUV_420 image act as chroma value for 4 neighbouring pixels
        final int uvIndex = (uvh * uvRowStride) + (uvw * uvPixelStride);

        // U/V values ideally fall under [-0.5, 0.5] range. To fit them into
        // [0, 255] range they are scaled up and centered to 128.
        // Operation below brings U/V values to [-128, 127].
        final int u = uBuffer[uvIndex];
        final int v = vBuffer[uvIndex];

        // Compute RGB values per formula above.
        int r = (y + v * 1436 / 1024 - 179).round();
        int g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
        int b = (y + u * 1814 / 1024 - 227).round();

        r = r.clamp(0, 255);
        g = g.clamp(0, 255);
        b = b.clamp(0, 255);

        image.setPixelRgb(w, h, r, g, b);
      }
    }
    return image;
  }

imglib.Image convertNV21ToImage(CameraImage cameraImage) {
  // Extract the bytes from the CameraImage
  final yuvBytes = cameraImage.planes[0].bytes;
  final vuBytes = cameraImage.planes[1].bytes;

  // Create a new Image instance
  final image = imglib.Image(
    width: cameraImage.width,
    height: cameraImage.height,
  );

  // Convert NV21 to RGB
  convertNV21ToRGB(
    yuvBytes,
    vuBytes,
    cameraImage.width,
    cameraImage.height,
    image,
  );

  return image;
}

void convertNV21ToRGB(Uint8List yuvBytes, Uint8List vuBytes, int width,
    int height, imglib.Image image) {
  // Conversion logic from NV21 to RGB
  // ...

  // Example conversion logic using the `imageLib` package
  // This is just a placeholder and may not be the most efficient method
  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      final yIndex = y * width + x;
      final uvIndex = (y ~/ 2) * (width ~/ 2) + (x ~/ 2);

      final yValue = yuvBytes[yIndex];
      final uValue = vuBytes[uvIndex * 2];
      final vValue = vuBytes[uvIndex * 2 + 1];

      // Convert YUV to RGB
      final r = yValue + 1.402 * (vValue - 128);
      final g = yValue - 0.344136 * (uValue - 128) - 0.714136 * (vValue - 128);
      final b = yValue + 1.772 * (uValue - 128);

      // Set the RGB pixel values in the Image instance
      image.setPixelRgba(x, y, r.toInt(), g.toInt(), b.toInt(), 255);
    }
  }
}

imglib.Image testConvert(CameraImage cameraImage) {
   final int width = cameraImage.width;
    final int height = cameraImage.height;
    final imglib.Image rgbImage = imglib.Image( width: width, height: height);

    final Uint8List planeBytes = cameraImage.planes[0].bytes;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int pixelIndex = y * width + x;
        final int yValue = planeBytes[pixelIndex];

        // Set YUV values for U and V to neutral values (128)
        final int uValue = 128;
        final int vValue = 128;

        // Convert YUV to RGB
        final int c = yValue - 16;
        final int d = uValue - 128;
        final int e = vValue - 128;

        final int r = (298 * c + 409 * e + 128) >> 8;
        final int g = (298 * c - 100 * d - 208) >> 8;
        final int b = (298 * c + 516 * d + 128) >> 8;

        // Ensure RGB values are within valid range
        final red = r.clamp(0, 255);
        final green = g.clamp(0, 255);
        final blue = b.clamp(0, 255);

        // Set the pixel color in the RGB image
        final color = imglib.ColorRgb8(red, green, blue);
        rgbImage.setPixel(x, y, color);
        }
    }

    return rgbImage;
}