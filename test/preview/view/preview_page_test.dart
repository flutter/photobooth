// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/preview/preview.dart';

import '../../helpers/helpers.dart';

void main() {
  const mobileBreakpoint = 600;
  const width = 1;
  const height = 1;
  final data = Uint8List.fromList([]);
  final cameraImage = CameraImage(
    width: width,
    height: height,
    raw: ImageData(width: width, height: height, data: data),
    thumbnail: ImageData(width: width, height: height, data: data),
  );

  group('PreviewPage', () {
    test('is routable', () {
      expect(
        PreviewPage.route(image: cameraImage),
        isA<MaterialPageRoute>(),
      );
    });

    testWidgets('displays a ButtonsLayout', (tester) async {
      await tester.pumpApp(PreviewPage(image: cameraImage));
      expect(find.byType(ButtonsLayout), findsOneWidget);
    });
  });

  group('ButtonsLayout', () {
    testWidgets('displays a DesktopButtonsLayout when width>$mobileBreakpoint',
        (tester) async {
      await tester.pumpApp(PreviewPage(image: cameraImage));
      expect(find.byType(DesktopButtonsLayout), findsOneWidget);
    });

    testWidgets('displays a MobileButtonsLayout when width<=$mobileBreakpoint',
        (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(600, 1000);
      await tester.pumpApp(PreviewPage(image: cameraImage));
      expect(find.byType(MobileButtonsLayout), findsOneWidget);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });
  });
  group('MobileButtonsLayout', () {
    testWidgets('displays a PreviewImage', (tester) async {
      await tester.pumpApp(PreviewPage(image: cameraImage));
      expect(find.byType(PreviewImage), findsOneWidget);
    });

    testWidgets('displays a RetakeButton', (tester) async {
      await tester.pumpApp(PreviewPage(image: cameraImage));
      expect(find.byType(RetakeButton), findsOneWidget);
    });

    testWidgets('displays a ShareButton', (tester) async {
      await tester.pumpApp(PreviewPage(image: cameraImage));
      expect(find.byType(ShareButton), findsOneWidget);
    });

    testWidgets('displays a DownloadButton', (tester) async {
      await tester.pumpApp(PreviewPage(image: cameraImage));
      expect(find.byType(DownloadButton), findsOneWidget);
    });
  });

  group('DesktopButtonsLayout', () {
    testWidgets('displays a PreviewImage', (tester) async {
      await tester.pumpApp(PreviewPage(image: cameraImage));
      expect(find.byType(PreviewImage), findsOneWidget);
    });

    testWidgets('displays a RetakeButton', (tester) async {
      await tester.pumpApp(PreviewPage(image: cameraImage));
      expect(find.byType(RetakeButton), findsOneWidget);
    });

    testWidgets('displays a ShareButton', (tester) async {
      await tester.pumpApp(PreviewPage(image: cameraImage));
      expect(find.byType(ShareButton), findsOneWidget);
    });

    testWidgets('displays a DownloadButton', (tester) async {
      await tester.pumpApp(PreviewPage(image: cameraImage));
      expect(find.byType(DownloadButton), findsOneWidget);
    });
  });
}
