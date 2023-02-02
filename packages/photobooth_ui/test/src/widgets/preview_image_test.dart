// ignore_for_file: prefer_const_constructors
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

import '../../helpers/helpers.dart';

void main() {
  final data = 'data:image/png,${base64.encode(transparentImage)}';

  group('PreviewImage', () {
    testWidgets('renders with height and width', (tester) async {
      await tester.pumpWidget(
        PreviewImage(
          data: data,
          height: 100,
          width: 100,
        ),
      );
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('anti-aliasing is enabled', (tester) async {
      await tester.pumpWidget(
        PreviewImage(
          data: data,
          height: 100,
          width: 100,
        ),
      );
      final image = tester.widget<Image>(find.byType(Image));
      expect(image.isAntiAlias, isTrue);
    });

    testWidgets('renders without width as parameter', (tester) async {
      await tester.pumpWidget(PreviewImage(data: data, height: 100));
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('renders without height as parameter', (tester) async {
      await tester.pumpWidget(PreviewImage(data: data, width: 100));
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('renders without height/width as parameter', (tester) async {
      await tester.pumpWidget(PreviewImage(data: data));
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('renders error with empty image', (tester) async {
      await tester.pumpWidget(PreviewImage(data: ''));
      await tester.pumpAndSettle();
      final exception = tester.takeException();
      expect(exception, isNotNull);
      expect(find.byKey(const Key('previewImage_errorText')), findsOneWidget);
    });
  });
}
