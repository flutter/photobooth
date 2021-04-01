import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/preview/preview.dart';
import '../../helpers/helpers.dart';

void main() {
  group('ShareDialog', () {
    const width = 1;
    const height = 1;
    final data = Uint8List.fromList([]);
    final cameraImage = CameraImage(
      width: width,
      height: height,
      raw: ImageData(width: width, height: height, data: data),
      thumbnail: ImageData(width: width, height: height, data: data),
    );

    testWidgets('displays a TwitterButton', (tester) async {
      await tester.pumpApp(ShareDialog(
        cameraImage: cameraImage,
      ));
      expect(find.byType(TwitterButton), findsOneWidget);
    });

    testWidgets('tapping on TwitterButton does nothing', (tester) async {
      await tester.pumpApp(ShareDialog(
        cameraImage: cameraImage,
      ));
      await tester.tap(find.byType(TwitterButton));
      expect(find.byType(ShareDialog), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('displays a FacebookButton', (tester) async {
      await tester.pumpApp(ShareDialog(
        cameraImage: cameraImage,
      ));
      expect(find.byType(FacebookButton), findsOneWidget);
    });

    testWidgets('tapping on FacebookButton does nothing', (tester) async {
      await tester.pumpApp(ShareDialog(
        cameraImage: cameraImage,
      ));
      await tester.tap(find.byType(FacebookButton));
      expect(find.byType(ShareDialog), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('taps on close will dismiss the popup', (tester) async {
      await tester.pumpApp(ShareDialog(
        cameraImage: cameraImage,
      ));
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();
      expect(find.byType(ShareDialog), findsNothing);
    });
  });
}
