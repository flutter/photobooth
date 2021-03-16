@TestOn('chrome')

import 'package:camera_web/src/camera_preview.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

const cameraId = 0;

void main() {
  group('CameraPreview', () {
    testWidgets('renders Placeholder in debug mode', (tester) async {
      await tester.pumpWidget(const CameraPreview(cameraId: cameraId));
      expect(find.byType(Placeholder), findsOneWidget);
      expect(find.byType(HtmlElementView), findsNothing);
    });

    testWidgets('renders HtmlElementView in release mode', (tester) async {
      await tester.pumpWidget(
        const CameraPreview(cameraId: cameraId, isDebugMode: false),
      );
      expect(find.byType(Placeholder), findsNothing);
      expect(find.byType(HtmlElementView), findsOneWidget);
    });
  });
}
