// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

import '../../../helpers/helpers.dart';

class MockImage extends Mock implements ui.Image {}

class MockAsset extends Mock implements Asset {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ui.Image image;
  late Asset asset;

  group('MobileDraggableResizableImage', () {
    setUp(() {
      image = MockImage();
      asset = MockAsset();

      when(() => image.width).thenReturn(100);
      when(() => image.height).thenReturn(100);
      when(() => asset.image).thenReturn(image);
      when(() => asset.bytes).thenReturn(Uint8List.fromList(transparentImage));
    });

    testWidgets('is draggable', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Stack(
            children: [
              MobileDraggableResizableImage(
                image: asset.bytes,
                height: asset.image.height.toDouble(),
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
                image: asset.bytes,
                height: asset.image.height.toDouble(),
              ),
            ],
          ),
        ),
      );

      final imageFinder =
          find.byKey(Key('mobileDraggableResizableImage_image'));
      final origin = tester.getCenter(imageFinder);
      final originalSize = tester.getSize(imageFinder);

      // create two touches:
      final touch1 = await tester.startGesture(origin.translate(-5, 0));
      final touch2 = await tester.startGesture(origin.translate(5, 0));

      // zoom in:
      await touch1.moveBy(Offset(-8, 0));
      await touch2.moveBy(Offset(8, 0));
      await tester.pump();

      // cancel touches:
      await touch1.cancel();
      await touch2.cancel();
      final finalSize = tester.getSize(imageFinder);
      expect(originalSize == finalSize, false);
    });

    testWidgets('is resizable 2', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Stack(
            children: [
              MobileDraggableResizableImage(
                image: asset.bytes,
                height: asset.image.height.toDouble(),
              ),
            ],
          ),
        ),
      );

      final imageFinder =
          find.byKey(Key('mobileDraggableResizableImage_image'));
      final childCenter = tester.getCenter(imageFinder);
      final originalSize = tester.getSize(imageFinder);

      final scaleStart1 = Offset(childCenter.dx - 5.0, childCenter.dy);
      final scaleStart2 = Offset(childCenter.dx + 5.0, childCenter.dy);
      final scaleEnd1 = Offset(childCenter.dx - 8.0, childCenter.dy);
      final scaleEnd2 = Offset(childCenter.dx + 8.0, childCenter.dy);
      final gesture = await tester.createGesture();
      final gesture2 = await tester.createGesture();
      await gesture.down(scaleStart1);
      await gesture2.down(scaleStart2);
      await tester.pump();
      await gesture.moveTo(scaleEnd1);
      await gesture2.moveTo(scaleEnd2);
      await tester.pump();
      await gesture.up();
      await gesture2.up();
      await tester.pumpAndSettle();
      final finalSize = tester.getSize(imageFinder);
      expect(originalSize == finalSize, false);
    });
  });
}
