import 'dart:html';

import 'package:flutter/material.dart';
import 'package:tensorflow_web/tensorflow_web.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  ImageData _getImage() {
    final image = document.getElementById('sampleImage') as ImageElement;
    final canvas = CanvasElement(width: image.width, height: image.height);
    canvas.context2D.drawImage(image, 0, 0);
    var imageData = canvas.context2D
        .getImageData(0, 0, image.width ?? 0, image.height ?? 0);
    return imageData;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  TensorflowPlugin().loadModel();
                },
                child: const Text('Load model')),
            TextButton(
              onPressed: () async {
                var imageData = _getImage();
                final result = await TensorflowPlugin().getShoulder(imageData);
                print('Part: ${result.part}');
                print('Score: ${result.score}');
                print(
                    'Position: x=${result.position.x} y=${result.position.y}');
              },
              child: const Text('Left shoulder'),
            ),
            TextButton(
              onPressed: () async {
                var imageData = _getImage();
                final result =
                    await TensorflowPlugin().estimateSinglePose(imageData);
                print('Score: ${result.score}');
                print('Keypoints: ${result.keypoints}');
              },
              child: const Text('Estimate single pose'),
            ),
          ],
        )),
      ),
    );
  }
}
