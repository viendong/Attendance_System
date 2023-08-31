import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img; // Import the image package.

class MyWidget extends StatelessWidget {
  const MyWidget({
    super.key,
    this.image,
  });

  final img.Image? image;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Image.memory(
        Uint8List.fromList(img.encodePng(this.image!)),
      ),
    );
  }
}
