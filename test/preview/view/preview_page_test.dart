// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/preview/preview.dart';
import '../../helpers/helpers.dart';

void main() {
  group('PreviewPage', () {
    late CameraImage cameraImage;
    const mobileBreakpoint = 600;

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

    test('is routable', () {
      expect(PreviewPage.route(image: cameraImage), isA<MaterialPageRoute>());
    });

    testWidgets('displays a PreviewImage', (tester) async {
      await tester.pumpApp(PreviewPage(
        image: cameraImage,
      ));
      expect(find.byType(PreviewImage), findsOneWidget);
    });

    testWidgets('displays a RetakeButton', (tester) async {
      await tester.pumpApp(PreviewPage(
        image: cameraImage,
      ));
      expect(find.byType(RetakeButton), findsOneWidget);
    });
    testWidgets('tapping on retake photo button does nothing', (tester) async {
      await tester.pumpApp(RetakeButton());
      await tester.tap(find.byType(RetakeButton));
      expect(tester.takeException(), isNull);
    });
    testWidgets('displays a ShareButton', (tester) async {
      await tester.pumpApp(PreviewPage(
        image: cameraImage,
      ));
      expect(find.byType(ShareButton), findsOneWidget);
    });

    testWidgets('displays a DownloadButton', (tester) async {
      await tester.pumpApp(PreviewPage(
        image: cameraImage,
      ));
      expect(find.byType(DownloadButton), findsOneWidget);
    });

    testWidgets('displays a ButtonsLayout', (tester) async {
      await tester.pumpApp(PreviewPage(
        image: cameraImage,
      ));
      expect(find.byType(ButtonsLayout), findsOneWidget);
    });

    testWidgets('displays a DesktopButtonsLayout when width>$mobileBreakpoint',
        (tester) async {
      await tester.pumpApp(PreviewPage(
        image: cameraImage,
      ));
      expect(find.byType(DesktopButtonsLayout), findsOneWidget);
    });

    testWidgets('displays a MobileButtonsLayout when width<=$mobileBreakpoint',
        (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(600, 1000);
      await tester.pumpApp(PreviewPage(
        image: cameraImage,
      ));
      expect(find.byType(MobileButtonsLayout), findsOneWidget);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
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

    testWidgets('tapping on download photo button does nothing',
        (tester) async {
      await tester.pumpApp(PreviewPage(
        image: cameraImage,
      ));
      await tester.tap(find.byType(DownloadButton));
      expect(find.byType(PreviewPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
