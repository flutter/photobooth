import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class PreviewPage extends StatelessWidget {
  const PreviewPage({Key? key, required this.image}) : super(key: key);

  final CameraImage image;

  static Route route({required CameraImage image}) {
    return MaterialPageRoute(builder: (_) => PreviewPage(image: image));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Image.memory(
          Uint8List.fromList(image.imageData.decoded),
          width: image.width.toDouble(),
          height: image.height.toDouble(),
          errorBuilder: (context, error, stackTrace) {
            return Text('Error, $error, $stackTrace');
          },
        ),
      ),
    );
  }
}
