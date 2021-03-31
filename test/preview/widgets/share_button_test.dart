// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/preview/preview.dart';
import '../../helpers/helpers.dart';

void main() {
  group('ShareButton', () {
    late CameraImage cameraImage;

    setUp(() {
      const width = 1;
      const height = 1;
      final data = Uint8List.fromList([]);

      cameraImage = CameraImage(
        height: height,
        width: width,
        imageData: ImageData(
          width: width,
          height: height,
          decoded: data,
          data: data,
        ),
      );
    });
    testWidgets('tapping on share photo button opens ShareDialog',
        (tester) async {
      await tester.pumpApp(PreviewPage(
        image: cameraImage,
      ));
      await tester.tap(find.byType(ShareButton));
      await tester.pump();
      await tester.pump(kThemeAnimationDuration);
      expect(find.byType(ShareDialog), findsOneWidget);
    });
  });
}
