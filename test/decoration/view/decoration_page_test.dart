import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/decoration/decoration.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import '../../helpers/helpers.dart';

void main() {
  const width = 1;
  const height = 1;
  final data = Uint8List.fromList([]);
  final image = ImageData(width: width, height: height, data: data);
  group('DecorationPage', () {
    test('is routable', () {
      expect(DecorationPage.route(image: image), isA<MaterialPageRoute>());
    });

    testWidgets('renders PreviewImage', (tester) async {
      await tester.pumpApp(DecorationPage(
        image: image,
      ));
      expect(find.byType(PreviewImage), findsOneWidget);
    });

    testWidgets('renders OpenStickersButton', (tester) async {
      await tester.pumpApp(DecorationPage(
        image: image,
      ));
      expect(find.byType(OpenStickersButton), findsOneWidget);
    });

    testWidgets('renders GoToPreviewButton', (tester) async {
      await tester.pumpApp(DecorationPage(
        image: image,
      ));
      expect(find.byType(GoToPreviewButton), findsOneWidget);
    });

    testWidgets('renders PhotoboothBackButton', (tester) async {
      await tester.pumpApp(DecorationPage(
        image: image,
      ));
      expect(find.byKey(const Key('decorationPage_backButton_iconButton')),
          findsOneWidget);
    });
  });

  group('BackButton', () {
    testWidgets('dismiss when tapping', (tester) async {
      const initialPage = Key('__target__');
      await tester.pumpApp(Builder(
        builder: (context) {
          return ElevatedButton(
            key: initialPage,
            onPressed: () => Navigator.of(context).push(
              DecorationPage.route(image: image),
            ),
            child: const SizedBox(),
          );
        },
      ));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(DecorationPage), findsOneWidget);
      expect(find.byKey(initialPage), findsNothing);

      final backButtonFinder =
          find.byKey(const Key('decorationPage_backButton_iconButton'));
      await tester.ensureVisible(backButtonFinder);
      await tester.tap(backButtonFinder);
      await tester.pumpAndSettle();
      await tester.pump();

      expect(find.byType(DecorationPage), findsNothing);
      expect(find.byKey(initialPage), findsOneWidget);
    });
  });
}
