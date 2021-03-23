import 'dart:html';

import 'package:example/ml.dart';
import 'package:flutter/material.dart';
import 'package:js/js_util.dart' as js_util;

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
                final result = await js_util
                    .promiseToFuture<Object>(getLeftShoulder(imageData));
                final resultParsed = convertPrediction(result);
                print(resultParsed.part);
                print(resultParsed.position.x);
                print(resultParsed.position.y);
                print(resultParsed.score);
              },
              child: const Text('Left shoulder'),
            ),
          ],
        )),
      ),
    );
  }
}
