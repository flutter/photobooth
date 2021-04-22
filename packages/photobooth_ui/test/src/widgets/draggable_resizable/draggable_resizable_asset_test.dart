// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:platform_helper/platform_helper.dart';

import '../../../helpers/constants.dart';

class MockImage extends Mock implements ui.Image {}

class MockPlatformHelper extends Mock implements PlatformHelper {}

class MockAsset extends Mock implements Asset {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Asset asset;
  late ui.Image image;
  late PlatformHelper platformHelper;

  group('DraggableResizableAsset', () {
    setUp(() {
      image = MockImage();
      asset = MockAsset();
      platformHelper = MockPlatformHelper();

      when(() => image.width).thenReturn(100);
      when(() => image.height).thenReturn(100);
      when(() => asset.image).thenReturn(image);
      when(() => asset.bytes).thenReturn(Uint8List.fromList(transparentImage));
      when(() => platformHelper.isMobile).thenReturn(true);
    });

    testWidgets('renders Image by (default)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: DraggableResizableAsset(asset: asset)),
      );
      expect(find.byType(Image), findsOneWidget);
    });

    group('desktop', () {
      late ui.Image image;
      late Asset asset;

      setUp(() {
        image = MockImage();
        asset = MockAsset();

        when(() => image.width).thenReturn(200);
        when(() => image.height).thenReturn(222);
        when(() => asset.image).thenReturn(image);
        when(() => asset.bytes)
            .thenReturn(Uint8List.fromList(transparentImage));
        when(() => platformHelper.isMobile).thenReturn(false);
      });

      testWidgets('renders image as draggable point', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: DraggableResizableAsset(
              asset: asset,
              platformHelper: platformHelper,
            ),
          ),
        );
        expect(
          find.byKey(Key('draggableResizableAsset_image_draggablePoint')),
          findsOneWidget,
        );
      });

      testWidgets('image is draggable', (tester) async {
        final onUpdateCalls = <DragUpdate>[];
        await tester.pumpWidget(
          MaterialApp(
            home: DraggableResizableAsset(
              asset: asset,
              platformHelper: platformHelper,
              onUpdate: onUpdateCalls.add,
            ),
          ),
        );
        final firstLocation = tester.getCenter(
          find.byKey(Key('draggableResizableAsset_image_draggablePoint')),
        );
        await tester.dragFrom(firstLocation, const Offset(200.0, 300.0));
        await tester.pump(kThemeAnimationDuration);
        final destination = tester.getCenter(
          find.byKey(Key('draggableResizableAsset_image_draggablePoint')),
        );
        expect(firstLocation == destination, false);
        expect(onUpdateCalls, isNotEmpty);
      });

      testWidgets(
          'top left corner as draggable point renders '
          'when canTransform is true', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: DraggableResizableAsset(
              asset: asset,
              platformHelper: platformHelper,
              canTransform: true,
            ),
          ),
        );
        expect(
          find.byKey(Key('draggableResizableAsset_topLeft_resizePoint')),
          findsOneWidget,
        );
      });

      testWidgets(
          'top left corner as draggable point does not render '
          'when canTransform is false', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: DraggableResizableAsset(
              asset: asset,
              platformHelper: platformHelper,
              canTransform: false,
            ),
          ),
        );
        expect(
          find.byKey(Key('draggableResizableAsset_topLeft_resizePoint')),
          findsNothing,
        );
      });

      testWidgets('top left corner point can resize image', (tester) async {
        final onUpdateCalls = <DragUpdate>[];
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: DraggableResizableAsset(
                    asset: asset,
                    platformHelper: platformHelper,
                    onUpdate: onUpdateCalls.add,
                    canTransform: true,
                  ),
                ),
              ],
            ),
          ),
        );
        final resizePointFinder = find.byKey(
          Key('draggableResizableAsset_topLeft_resizePoint'),
        );
        final imageFinder = find.byKey(
          const Key('draggableResizableAsset_asset_image'),
        );
        final originalSize = tester.getSize(imageFinder);
        final firstLocation = tester.getCenter(resizePointFinder);
        await tester.flingFrom(
          firstLocation,
          Offset(firstLocation.dx - 1, firstLocation.dy - 1),
          3,
        );
        await tester.pump(kThemeAnimationDuration);
        final newSize = tester.getSize(imageFinder);
        expect(originalSize == newSize, false);
        expect(onUpdateCalls, isNotEmpty);
      });

      testWidgets(
          'top right corner as draggable point renders '
          'when canTransform is true', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: DraggableResizableAsset(
                    asset: asset,
                    platformHelper: platformHelper,
                    canTransform: true,
                  ),
                ),
              ],
            ),
          ),
        );
        expect(
          find.byKey(Key('draggableResizableAsset_topRight_resizePoint')),
          findsOneWidget,
        );
      });

      testWidgets(
          'top right corner as draggable point does not render '
          'when canTransform is false', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: DraggableResizableAsset(
                    asset: asset,
                    platformHelper: platformHelper,
                    canTransform: false,
                  ),
                ),
              ],
            ),
          ),
        );
        expect(
          find.byKey(Key('draggableResizableAsset_topRight_resizePoint')),
          findsNothing,
        );
      });

      testWidgets('top right corner point can resize image', (tester) async {
        final onUpdateCalls = <DragUpdate>[];
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: DraggableResizableAsset(
                    asset: asset,
                    platformHelper: platformHelper,
                    onUpdate: onUpdateCalls.add,
                    canTransform: true,
                  ),
                ),
              ],
            ),
          ),
        );
        final resizePointFinder = find.byKey(
          Key('draggableResizableAsset_topRight_resizePoint'),
        );
        final imageFinder = find.byKey(
          const Key('draggableResizableAsset_asset_image'),
        );
        final originalSize = tester.getSize(imageFinder);
        final firstLocation = tester.getCenter(resizePointFinder);
        await tester.flingFrom(
          firstLocation,
          Offset(firstLocation.dx + 10, firstLocation.dy + 10),
          3,
        );
        await tester.pump(kThemeAnimationDuration);
        final newSize = tester.getSize(imageFinder);
        expect(originalSize == newSize, false);
        expect(onUpdateCalls, isNotEmpty);
      });

      testWidgets(
          'bottom right corner as draggable point renders '
          'when canTransform is true', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: DraggableResizableAsset(
                    asset: asset,
                    platformHelper: platformHelper,
                    canTransform: true,
                  ),
                ),
              ],
            ),
          ),
        );
        expect(
          find.byKey(Key('draggableResizableAsset_bottomRight_resizePoint')),
          findsOneWidget,
        );
      });

      testWidgets(
          'bottom right corner as draggable point does not render '
          'when canTransform is false', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: DraggableResizableAsset(
                    asset: asset,
                    platformHelper: platformHelper,
                    canTransform: false,
                  ),
                ),
              ],
            ),
          ),
        );
        expect(
          find.byKey(Key('draggableResizableAsset_bottomRight_resizePoint')),
          findsNothing,
        );
      });

      testWidgets('bottom right corner point can resize image', (tester) async {
        final onUpdateCalls = <DragUpdate>[];
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: DraggableResizableAsset(
                    asset: asset,
                    platformHelper: platformHelper,
                    onUpdate: onUpdateCalls.add,
                    canTransform: true,
                  ),
                ),
              ],
            ),
          ),
        );
        final resizePointFinder = find.byKey(
          Key('draggableResizableAsset_bottomRight_resizePoint'),
        );
        final imageFinder = find.byKey(
          const Key('draggableResizableAsset_asset_image'),
        );
        final originalSize = tester.getSize(imageFinder);
        final firstLocation = tester.getCenter(resizePointFinder);
        await tester.flingFrom(
          firstLocation,
          Offset(firstLocation.dx + 10, firstLocation.dy + 10),
          3,
        );
        await tester.pump(kThemeAnimationDuration);
        final newSize = tester.getSize(imageFinder);
        expect(originalSize == newSize, false);
        expect(onUpdateCalls, isNotEmpty);
      });

      testWidgets(
          'bottom left corner as draggable point renders '
          'when canTransform is true', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: DraggableResizableAsset(
                    asset: asset,
                    platformHelper: platformHelper,
                    canTransform: true,
                  ),
                ),
              ],
            ),
          ),
        );
        expect(
          find.byKey(Key('draggableResizableAsset_bottomLeft_resizePoint')),
          findsOneWidget,
        );
      });

      testWidgets(
          'bottom left corner as draggable point does not render '
          'when canTransform is false', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: DraggableResizableAsset(
                    asset: asset,
                    platformHelper: platformHelper,
                    canTransform: false,
                  ),
                ),
              ],
            ),
          ),
        );
        expect(
          find.byKey(Key('draggableResizableAsset_bottomLeft_resizePoint')),
          findsNothing,
        );
      });

      testWidgets('bottom left corner point can resize image', (tester) async {
        final onUpdateCalls = <DragUpdate>[];
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: DraggableResizableAsset(
                    asset: asset,
                    platformHelper: platformHelper,
                    onUpdate: onUpdateCalls.add,
                    canTransform: true,
                  ),
                ),
              ],
            ),
          ),
        );
        final resizePointFinder = find.byKey(
          Key('draggableResizableAsset_bottomLeft_resizePoint'),
        );
        final imageFinder = find.byKey(
          const Key('draggableResizableAsset_asset_image'),
        );
        final originalSize = tester.getSize(imageFinder);
        final firstLocation = tester.getCenter(resizePointFinder);
        await tester.flingFrom(
          firstLocation,
          Offset(firstLocation.dx + 10, firstLocation.dy + 10),
          3,
        );
        await tester.pump(kThemeAnimationDuration);
        final newSize = tester.getSize(imageFinder);
        expect(originalSize == newSize, false);
        expect(onUpdateCalls, isNotEmpty);
      });

      testWidgets(
          'delete button does not render when canTransform is false'
          'and there is not delete callback', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: DraggableResizableAsset(
              asset: asset,
              platformHelper: platformHelper,
              canTransform: false,
            ),
          ),
        );
        expect(
          find.byKey(Key('draggableResizableAsset_delete_image')),
          findsNothing,
        );
      });

      testWidgets(
          'delete button renders when canTransform is true and '
          'has delete callback', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: DraggableResizableAsset(
              asset: asset,
              platformHelper: platformHelper,
              canTransform: true,
              onDelete: () {},
            ),
          ),
        );
        expect(
          find.byKey(Key('draggableResizableAsset_delete_image')),
          findsOneWidget,
        );
      });

      testWidgets('rotate anchor rotates asset', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: DraggableResizableAsset(
              asset: asset,
              platformHelper: platformHelper,
              canTransform: true,
            ),
          ),
        );

        final gestureDetector = tester.widget<GestureDetector>(
          find.byKey(Key('draggableResizableAsset_rotate_gestureDetector')),
        );
        gestureDetector.onScaleUpdate!(
          ScaleUpdateDetails(localFocalPoint: Offset(1, 1)),
        );

        await tester.pumpAndSettle();
        final imageFinder = find.byKey(
          Key('draggableResizableAsset_image_draggablePoint'),
        );
        final transformFinder = find.ancestor(
          of: imageFinder,
          matching: find.byType(Transform),
        );
        final transformWidget = tester.widget<Transform>(transformFinder);
        expect(
          transformWidget.transform,
          isNot(equals(Matrix4.diagonal3Values(1, 1, 1))),
        );
      });
    });

    group('mobile', () {
      setUp(() {
        when(() => platformHelper.isMobile).thenReturn(true);
      });
      testWidgets('is draggable', (tester) async {
        final onUpdateCalls = <DragUpdate>[];
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(
              children: [
                DraggableResizableAsset(
                  asset: asset,
                  onUpdate: onUpdateCalls.add,
                  canTransform: true,
                  platformHelper: platformHelper,
                ),
              ],
            ),
          ),
        );
        final imageFinder = find.byKey(
          Key('draggableResizableAsset_image_draggablePoint'),
        );
        final origin = tester.getCenter(imageFinder);
        final offset = Offset(30, 30);
        await tester.drag(imageFinder, offset);
        await tester.pumpAndSettle();

        final destination = tester.getCenter(imageFinder);
        expect(origin == destination, false);
        expect(onUpdateCalls, isNotEmpty);
      });

      testWidgets('is resizable', (tester) async {
        final onUpdateCalls = <DragUpdate>[];
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(
              children: [
                DraggableResizableAsset(
                  asset: asset,
                  onUpdate: onUpdateCalls.add,
                  canTransform: true,
                  platformHelper: platformHelper,
                ),
              ],
            ),
          ),
        );

        final imageFinder = find.byKey(
          Key('draggableResizableAsset_image_draggablePoint'),
        );
        final gestureDetectorFinder = find.descendant(
          of: imageFinder,
          matching: find.byType(GestureDetector),
        );
        final gestureDetector =
            tester.widget<GestureDetector>(gestureDetectorFinder);
        gestureDetector.onScaleStart!(ScaleStartDetails(pointerCount: 2));
        gestureDetector.onScaleUpdate!(
          ScaleUpdateDetails(scale: 2, pointerCount: 2),
        );

        await tester.pumpAndSettle();

        final transformFinder = find.ancestor(
          of: imageFinder,
          matching: find.byType(Transform),
        );
        final transformWidget = tester.widget<Transform>(transformFinder);
        expect(
          transformWidget.transform,
          isNot(equals(Matrix4.diagonal3Values(1, 1, 1))),
        );
        expect(onUpdateCalls, isNotEmpty);
      });

      testWidgets('is rotatable', (tester) async {
        final onUpdateCalls = <DragUpdate>[];
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(
              children: [
                DraggableResizableAsset(
                  asset: asset,
                  onUpdate: onUpdateCalls.add,
                  canTransform: true,
                  platformHelper: platformHelper,
                ),
              ],
            ),
          ),
        );

        final imageFinder = find.byKey(
          Key('draggableResizableAsset_image_draggablePoint'),
        );
        final gestureDetectorFinder = find.descendant(
          of: imageFinder,
          matching: find.byType(GestureDetector),
        );
        final gestureDetector =
            tester.widget<GestureDetector>(gestureDetectorFinder);
        gestureDetector.onScaleStart!(ScaleStartDetails(pointerCount: 2));
        gestureDetector.onScaleUpdate!(
          ScaleUpdateDetails(rotation: 2, pointerCount: 2),
        );

        await tester.pumpAndSettle();

        final transformFinder = find.ancestor(
          of: imageFinder,
          matching: find.byType(Transform),
        );
        final transformWidget = tester.widget<Transform>(transformFinder);
        expect(
          transformWidget.transform,
          isNot(equals(Matrix4.diagonal3Values(1, 1, 1))),
        );
        expect(onUpdateCalls, isNotEmpty);
      });

      testWidgets('rotation is continuous', (tester) async {
        final onUpdateCalls = <DragUpdate>[];
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(
              children: [
                DraggableResizableAsset(
                  asset: asset,
                  onUpdate: onUpdateCalls.add,
                  canTransform: true,
                  platformHelper: platformHelper,
                ),
              ],
            ),
          ),
        );

        final imageFinder = find.byKey(
          Key('draggableResizableAsset_image_draggablePoint'),
        );
        final gestureDetectorFinder = find.descendant(
          of: imageFinder,
          matching: find.byType(GestureDetector),
        );
        final gestureDetector =
            tester.widget<GestureDetector>(gestureDetectorFinder);
        gestureDetector.onScaleStart!(ScaleStartDetails(pointerCount: 2));
        gestureDetector.onScaleUpdate!(
          ScaleUpdateDetails(rotation: 2, pointerCount: 2),
        );

        await tester.pumpAndSettle();

        final transformFinder = find.ancestor(
          of: imageFinder,
          matching: find.byType(Transform),
        );
        final transformA = tester.widget<Transform>(transformFinder).transform;

        gestureDetector.onScaleStart!(ScaleStartDetails(pointerCount: 2));
        gestureDetector.onScaleUpdate!(
          ScaleUpdateDetails(rotation: 2, pointerCount: 2),
        );

        await tester.pumpAndSettle();

        final transformB = tester.widget<Transform>(transformFinder).transform;

        expect(transformA, isNot(equals(transformB)));
      });
    });
  });
}
