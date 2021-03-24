import 'dart:html';

import 'package:flutter/material.dart';
import 'package:tensorflow_web/tensorflow_web.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                final image =
                    document.getElementById('sampleImage') as ImageElement;
                final canvas =
                    CanvasElement(width: image.width, height: image.height);
                canvas.context2D.drawImage(image, 0, 0);
                var imageData = canvas.context2D
                    .getImageData(0, 0, image.width ?? 0, image.height ?? 0);
                final result = await TensorflowPlugin().getShoulder(imageData);
                print(result.part);
                print(result.score);
              },
              child: const Text('Left shoulder'),
            ),
            TextButton(
                onPressed: () {
                  TensorflowPlugin().loadModel();
                },
                child: const Text('Load model'))
          ],
        )),
      ),
    );
  }
}
