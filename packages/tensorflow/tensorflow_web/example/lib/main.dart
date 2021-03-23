import 'dart:html';

import 'package:example/ml.dart';
import 'package:flutter/material.dart';
import 'package:js/js_util.dart' as jsutil;
import 'dart:js' as js;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: Column(
          children: [
            TextButton(
              onPressed: () async {
                testJsMethod();
              },
              child: const Text('Hello world'),
            ),
            TextButton(
              onPressed: () async {
                loadModel();
              },
              child: const Text('Load model'),
            ),
            TextButton(
              onPressed: () async {
                final image =
                    document.getElementById('sampleImage') as ImageElement;
                final canvas =
                    CanvasElement(width: image.width, height: image.height);
                canvas.context2D.drawImage(image, 0, 0);
                var imageData = canvas.context2D
                    .getImageData(0, 0, image.width ?? 0, image.height ?? 0);
                final result = await jsutil.promiseToFuture<List<Object>>(
                    estimatePose(CustomImageData(imageData: imageData)));
                //final result = estimatePose(imageData);
                //js.context.callMethod('estimatePose', [imageData]);
              },
              child: const Text('Estimate pose'),
            ),
          ],
        )),
      ),
    );
  }
}
