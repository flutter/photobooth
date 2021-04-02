// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/preview/preview.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

import '../../helpers/helpers.dart';

void main() {
  const width = 1;
  const height = 1;
  final data = Uint8List.fromList([]);
  final image = ImageData(width: width, height: height, data: data);

  group('PreviewPage', () {
    test('is routable', () {
      expect(PreviewPage.route(image: image), isA<MaterialPageRoute>());
    });

    testWidgets('displays a PreviewImage', (tester) async {
      await tester.pumpApp(PreviewPage(image: image));
      expect(find.byType(PreviewImage), findsOneWidget);
    });

    testWidgets('displays a PreviewImage', (tester) async {
      await tester.pumpApp(PreviewPage(image: image));
      expect(find.byType(PreviewImage), findsOneWidget);
    });

    testWidgets('displays a RetakeButton', (tester) async {
      await tester.pumpApp(PreviewPage(image: image));
      expect(find.byType(RetakeButton), findsOneWidget);
    });

    testWidgets('displays a ShareButton', (tester) async {
      await tester.pumpApp(PreviewPage(image: image));
      expect(find.byType(ShareButton), findsOneWidget);
    });

    testWidgets('displays a DownloadButton', (tester) async {
      await tester.pumpApp(PreviewPage(image: image));
      expect(find.byType(DownloadButton), findsOneWidget);
    });
  });

  group('ResponsiveLayout', () {
    testWidgets('displays a DesktopButtonsLayout', (tester) async {
      await tester.pumpApp(PreviewPage(image: image));
      expect(find.byType(DesktopButtonsLayout), findsOneWidget);
    });

    testWidgets('displays a MobileButtonsLayout', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(
        PhotoboothBreakpoints.mobile,
        1000,
      );
      await tester.pumpApp(PreviewPage(image: image));
      expect(find.byType(MobileButtonsLayout), findsOneWidget);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });
  });
}
