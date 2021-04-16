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
  final image = CameraImage(width: width, height: height, data: data);

  group('PreviewPage', () {
    test('is routable', () {
      expect(PreviewPage.route(image: image), isA<MaterialPageRoute>());
    });

    testWidgets('displays a PreviewImage', (tester) async {
      await tester.pumpApp(PreviewPage(image: image));
      expect(find.byType(PreviewImage), findsOneWidget);
    });

    testWidgets('displays a RetakeButton', (tester) async {
      await tester.pumpApp(PreviewPage(image: image));
      expect(
        find.byKey(const Key('previewPage_retake_elevatedButton')),
        findsOneWidget,
      );
    });

    testWidgets('displays a ShareButton', (tester) async {
      await tester.pumpApp(PreviewPage(image: image));
      expect(
        find.byKey(const Key('previewPage_share_elevatedButton')),
        findsOneWidget,
      );
    });

    testWidgets('displays a DownloadButton', (tester) async {
      await tester.pumpApp(PreviewPage(image: image));
      expect(
        find.byKey(const Key('previewPage_download_elevatedButton')),
        findsOneWidget,
      );
    });
  });

  group('ShareButton', () {
    testWidgets('tapping on share photo button opens ShareDialog',
        (tester) async {
      final shareButtonFinder = find.byKey(
        const Key('previewPage_share_elevatedButton'),
      );
      await tester.pumpApp(PreviewPage(image: image));

      await tester.ensureVisible(shareButtonFinder);
      await tester.tap(shareButtonFinder);
      await tester.pumpAndSettle();

      expect(find.byType(ShareDialog), findsOneWidget);
    });
  });

  group('DownloadButton', () {
    testWidgets('tapping on download photo button completes', (tester) async {
      final downloadButtonFinder = find.byKey(
        const Key('previewPage_download_elevatedButton'),
      );
      await tester.pumpApp(PreviewPage(image: image));

      await tester.ensureVisible(downloadButtonFinder);
      await tester.tap(downloadButtonFinder);

      expect(tester.takeException(), isNull);
    });
  });

  group('RetakeButton', () {
    testWidgets('tapping on retake button pops', (tester) async {
      const initialPage = Key('__target__');
      await tester.pumpApp(Builder(
        builder: (context) {
          return ElevatedButton(
            key: initialPage,
            onPressed: () => Navigator.of(context).push(
              PreviewPage.route(image: image),
            ),
            child: const SizedBox(),
          );
        },
      ));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(PreviewPage), findsOneWidget);
      expect(find.byKey(initialPage), findsNothing);

      final retakeButtonFinder = find.byKey(
        const Key('previewPage_retake_elevatedButton'),
      );
      await tester.ensureVisible(retakeButtonFinder);
      await tester.tap(retakeButtonFinder);
      await tester.pumpAndSettle();

      expect(find.byType(PreviewPage), findsNothing);
      expect(find.byKey(initialPage), findsOneWidget);
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
