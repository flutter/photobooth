// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/preview/preview.dart';
import '../../helpers/helpers.dart';

void main() {
  const width = 1;
  const height = 1;
  final data = Uint8List.fromList([]);
  final cameraImage = CameraImage(
    width: width,
    height: height,
    raw: ImageData(width: width, height: height, data: data),
    thumbnail: ImageData(width: width, height: height, data: data),
  );

  group('ShareButton', () {
    testWidgets('tapping on share photo button opens ShareDialog',
        (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(800, 800);
      tester.binding.window.devicePixelRatioTestValue = 1;
      await tester.pumpApp(PreviewPage(
        image: cameraImage,
      ));
      await tester.tap(find.byType(ShareButton));
      await tester.pumpAndSettle();
      expect(find.byType(ShareDialog), findsOneWidget);
    });
  });
}
