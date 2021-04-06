// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/decoration/decoration.dart';
import '../../helpers/helpers.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await Assets.load();

  group('ResizebleSticker', () {
    testWidgets('renders', (tester) async {
      await tester.pumpApp(Material(
        child: ResizebleSticker(
          sticker: Assets.dash,
        ),
      ));
      expect(find.byType(ResizebleSticker), findsOneWidget);
    });

    testWidgets('image as draggable point renders', (tester) async {
      await tester.pumpApp(Material(
        child: ResizebleSticker(
          sticker: Assets.dash,
        ),
      ));
      expect(
          find.byKey(
            Key('resizableSticker_image_draggablePoint'),
          ),
          findsOneWidget);
    });

    testWidgets('image is draggable', (tester) async {
      await tester.pumpApp(Material(
        child: ResizebleSticker(
          sticker: Assets.dash,
        ),
      ));
      final firstLocation = tester
          .getCenter(find.byKey(Key('resizableSticker_image_draggablePoint')));
      await tester.dragFrom(firstLocation, const Offset(200.0, 300.0));
      await tester.pump(kThemeAnimationDuration);
      final destination = tester
          .getCenter(find.byKey(Key('resizableSticker_image_draggablePoint')));
      expect(firstLocation == destination, false);
    });

    testWidgets('top left corner as draggable point renders', (tester) async {
      await tester.pumpApp(Material(
        child: ResizebleSticker(
          sticker: Assets.dash,
        ),
      ));
      expect(
          find.byKey(
            Key('resizableSticker_topLeft_draggablePoint'),
          ),
          findsOneWidget);
    });

    testWidgets('top left corner point can resize image', (tester) async {
      await tester.pumpApp(
        Material(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: ResizebleSticker(
                  sticker: Assets.dash,
                ),
              ),
            ],
          ),
        ),
      );
      final draggablePointFinder =
          find.byKey(Key('resizableSticker_topLeft_draggablePoint'));
      final imageFinder = find.byType(Image);

      final originalSize = tester.getSize(imageFinder);
      final firstLocation = tester.getCenter(draggablePointFinder);
      await tester.dragFrom(
          firstLocation, Offset(firstLocation.dx + 10, firstLocation.dy + 10));
      await tester.pump(kThemeAnimationDuration);
      final newSize = tester.getSize(imageFinder);
      expect(originalSize == newSize, false);
    });

    testWidgets('top right corner as draggable point renders', (tester) async {
      await tester.pumpApp(Material(
        child: ResizebleSticker(
          sticker: Assets.dash,
        ),
      ));
      expect(
          find.byKey(
            Key('resizableSticker_topRight_draggablePoint'),
          ),
          findsOneWidget);
    });

    testWidgets('top right corner point can resize image', (tester) async {
      await tester.pumpApp(
        Material(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: ResizebleSticker(
                  sticker: Assets.dash,
                ),
              ),
            ],
          ),
        ),
      );
      final draggablePointFinder =
          find.byKey(Key('resizableSticker_topRight_draggablePoint'));
      final imageFinder = find.byType(Image);

      final originalSize = tester.getSize(imageFinder);
      final firstLocation = tester.getCenter(draggablePointFinder);
      await tester.dragFrom(
          firstLocation, Offset(firstLocation.dx + 10, firstLocation.dy + 10));
      await tester.pump(kThemeAnimationDuration);
      final newSize = tester.getSize(imageFinder);
      expect(originalSize == newSize, false);
    });

    testWidgets('bottom right corner as draggable point renders',
        (tester) async {
      await tester.pumpApp(Material(
        child: ResizebleSticker(
          sticker: Assets.dash,
        ),
      ));
      expect(
          find.byKey(
            Key('resizableSticker_bottomRight_draggablePoint'),
          ),
          findsOneWidget);
    });

    testWidgets('bottom right corner point can resize image', (tester) async {
      await tester.pumpApp(
        Material(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: ResizebleSticker(
                  sticker: Assets.dash,
                ),
              ),
            ],
          ),
        ),
      );
      final draggablePointFinder =
          find.byKey(Key('resizableSticker_bottomRight_draggablePoint'));
      final imageFinder = find.byType(Image);

      final originalSize = tester.getSize(imageFinder);
      final firstLocation = tester.getCenter(draggablePointFinder);
      await tester.dragFrom(
          firstLocation, Offset(firstLocation.dx + 10, firstLocation.dy + 10));
      await tester.pump(kThemeAnimationDuration);
      final newSize = tester.getSize(imageFinder);
      expect(originalSize == newSize, false);
    });

    testWidgets('bottom left corner as draggable point renders',
        (tester) async {
      await tester.pumpApp(Material(
        child: ResizebleSticker(
          sticker: Assets.dash,
        ),
      ));
      expect(
          find.byKey(
            Key('resizableSticker_bottomLeft_draggablePoint'),
          ),
          findsOneWidget);
    });

    testWidgets('bottom left corner point can resize image', (tester) async {
      await tester.pumpApp(
        Material(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: ResizebleSticker(
                  sticker: Assets.dash,
                ),
              ),
            ],
          ),
        ),
      );
      final draggablePointFinder =
          find.byKey(Key('resizableSticker_bottomLeft_draggablePoint'));
      final imageFinder = find.byType(Image);

      final originalSize = tester.getSize(imageFinder);
      final firstLocation = tester.getCenter(draggablePointFinder);
      await tester.dragFrom(
          firstLocation, Offset(firstLocation.dx + 10, firstLocation.dy + 10));
      await tester.pump(kThemeAnimationDuration);
      final newSize = tester.getSize(imageFinder);
      expect(originalSize == newSize, false);
    });
  });
}
