import 'dart:html';

import 'package:example/ml.dart';
import 'package:flutter/material.dart';

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
                final result = getLeftShoulder(imageData);
                print(result);
              },
              child: const Text('Left shoulder'),
            ),
          ],
        )),
      ),
    );
  }
}
