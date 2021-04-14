// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

import '../../../helpers/helpers.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final image = Uint8List.fromList(transparentImage);

  group('MobileDraggableResizableImage', () {
    testWidgets('is draggable', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Stack(
            children: [
              MobileDraggableResizableImage(
                image: image,
                height: 100,
              ),
            ],
          ),
        ),
      );
      final origin = tester.getCenter(
        find.byKey(Key('mobileDraggableResizableImage_image')),
      );
      final offset = Offset(30, 30);
      await tester.drag(find.byType(MobileDraggableResizableImage), offset);
      await tester.pumpAndSettle();

      final destination = tester.getCenter(
        find.byKey(Key('mobileDraggableResizableImage_image')),
      );
      expect(origin == destination, false);
    });

    testWidgets('is resizable 1', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Stack(
            children: [
              MobileDraggableResizableImage(
                image: image,
                height: 100,
              ),
            ],
          ),
        ),
      );

      final imageFinder =
          find.byKey(Key('mobileDraggableResizableImage_image'));

      // create two touches:
      final touch1 = await tester
          .startGesture(tester.getCenter(imageFinder) - const Offset(1, -1));
      await tester.pump();
      final touch2 = await tester
          .startGesture(tester.getCenter(imageFinder) + const Offset(-2, 2));
      await tester.pump();

      // zoom in:
      await touch1.moveBy(Offset(-8, 8));
      await tester.pump();
      await touch2.moveBy(Offset(8, -8));
      await tester.pump();

      // cancel touches:
      await touch1.cancel();
      await touch2.cancel();
      await tester.pumpAndSettle();

      final transformFinder = find.ancestor(
        of: imageFinder,
        matching: find.byType(Transform),
      );
      final transformWidget = tester.widget<Transform>(transformFinder);
      expect(
        transformWidget.transform,
        equals(Matrix4.diagonal3Values(15, 15, 1.0)),
      );
    });
  });
}
