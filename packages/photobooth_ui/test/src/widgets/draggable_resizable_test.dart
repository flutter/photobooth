// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:platform_helper/platform_helper.dart';

class MockPlatformHelper extends Mock implements PlatformHelper {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final childKey = UniqueKey();
  const size = Size(300, 300);
  final child = SizedBox(key: childKey, width: 100, height: 100);
  late PlatformHelper platformHelper;

  group('DraggableResizable', () {
    setUp(() {
      platformHelper = MockPlatformHelper();

      when(() => platformHelper.isMobile).thenReturn(true);
    });

    testWidgets('renders child by (default)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: DraggableResizable(size: size, child: child)),
      );
      expect(find.byKey(childKey), findsOneWidget);
    });

    group('desktop', () {
      setUp(() {
        when(() => platformHelper.isMobile).thenReturn(false);
      });

      testWidgets('renders child as draggable point', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: DraggableResizable(
              platformHelper: platformHelper,
              size: size,
              child: child,
            ),
          ),
        );
        expect(
          find.byKey(Key('draggableResizable_child_draggablePoint')),
          findsOneWidget,
        );
      });

      testWidgets('child is draggable', (tester) async {
        final onUpdateCalls = <DragUpdate>[];
        await tester.pumpWidget(
          MaterialApp(
            home: DraggableResizable(
              platformHelper: platformHelper,
              onUpdate: onUpdateCalls.add,
              size: size,
              child: child,
            ),
          ),
        );
        final firstLocation = tester.getCenter(
          find.byKey(Key('draggableResizable_child_draggablePoint')),
        );
        await tester.dragFrom(firstLocation, const Offset(200, 300));
        await tester.pump(kThemeAnimationDuration);
        final destination = tester.getCenter(
          find.byKey(Key('draggableResizable_child_draggablePoint')),
        );
        expect(firstLocation == destination, isFalse);
        expect(onUpdateCalls, isNotEmpty);
      });

      testWidgets(
          'top left corner as draggable point renders '
          'when canTransform is true', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: DraggableResizable(
              platformHelper: platformHelper,
              canTransform: true,
              size: size,
              child: child,
            ),
          ),
        );
        expect(
          find.byKey(Key('draggableResizable_topLeft_resizePoint')),
          findsOneWidget,
        );
      });

      testWidgets(
          'top left corner as draggable point does not render '
          'when canTransform is false', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: DraggableResizable(
              platformHelper: platformHelper,
              size: size,
              child: child,
            ),
          ),
        );
        expect(
          find.byKey(Key('draggableResizable_topLeft_resizePoint')),
          findsNothing,
        );
      });

      testWidgets('top left corner point can resize child', (tester) async {
        final onUpdateCalls = <DragUpdate>[];
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(
              children: [
                DraggableResizable(
                  platformHelper: platformHelper,
                  onUpdate: onUpdateCalls.add,
                  canTransform: true,
                  size: size,
                  child: child,
                ),
              ],
            ),
          ),
        );
        final resizePointFinder = find.byKey(
          Key('draggableResizable_topLeft_resizePoint'),
        );
        final childFinder = find.byKey(
          const Key('draggableResizable_child_container'),
        );
        final originalSize = tester.getSize(childFinder);
        final firstLocation = tester.getCenter(resizePointFinder);
        await tester.flingFrom(
          firstLocation,
          Offset(firstLocation.dx - 1, firstLocation.dy - 1),
          3,
        );
        await tester.pump(kThemeAnimationDuration);
        final newSize = tester.getSize(childFinder);
        expect(originalSize == newSize, isFalse);
        expect(onUpdateCalls, isNotEmpty);
      });

      testWidgets(
          'top right corner as draggable point renders '
          'when canTransform is true', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(
              children: [
                DraggableResizable(
                  platformHelper: platformHelper,
                  canTransform: true,
                  size: size,
                  child: child,
                ),
              ],
            ),
          ),
        );
        expect(
          find.byKey(Key('draggableResizable_topRight_resizePoint')),
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
                DraggableResizable(
                  platformHelper: platformHelper,
                  size: size,
                  child: child,
                ),
              ],
            ),
          ),
        );
        expect(
          find.byKey(Key('draggableResizable_topRight_resizePoint')),
          findsNothing,
        );
      });

      testWidgets('top right corner point can resize child', (tester) async {
        final onUpdateCalls = <DragUpdate>[];
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(
              children: [
                DraggableResizable(
                  platformHelper: platformHelper,
                  onUpdate: onUpdateCalls.add,
                  canTransform: true,
                  size: size,
                  child: child,
                ),
              ],
            ),
          ),
        );
        final resizePointFinder = find.byKey(
          Key('draggableResizable_topRight_resizePoint'),
        );
        final childFinder = find.byKey(
          const Key('draggableResizable_child_container'),
        );
        final originalSize = tester.getSize(childFinder);
        final firstLocation = tester.getCenter(resizePointFinder);
        await tester.flingFrom(
          firstLocation,
          Offset(firstLocation.dx + 10, firstLocation.dy + 10),
          3,
        );
        await tester.pump(kThemeAnimationDuration);
        final newSize = tester.getSize(childFinder);
        expect(originalSize == newSize, isFalse);
        expect(onUpdateCalls, isNotEmpty);
      });

      testWidgets(
          'bottom right corner as draggable point renders '
          'when canTransform is true', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(
              children: [
                DraggableResizable(
                  platformHelper: platformHelper,
                  canTransform: true,
                  size: size,
                  child: child,
                ),
              ],
            ),
          ),
        );
        expect(
          find.byKey(Key('draggableResizable_bottomRight_resizePoint')),
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
                DraggableResizable(
                  platformHelper: platformHelper,
                  size: size,
                  child: child,
                ),
              ],
            ),
          ),
        );
        expect(
          find.byKey(Key('draggableResizable_bottomRight_resizePoint')),
          findsNothing,
        );
      });

      testWidgets('bottom right corner point can resize child', (tester) async {
        final onUpdateCalls = <DragUpdate>[];
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(
              children: [
                DraggableResizable(
                  platformHelper: platformHelper,
                  onUpdate: onUpdateCalls.add,
                  canTransform: true,
                  size: size,
                  child: child,
                ),
              ],
            ),
          ),
        );
        final resizePointFinder = find.byKey(
          Key('draggableResizable_bottomRight_resizePoint'),
        );
        final childFinder = find.byKey(
          const Key('draggableResizable_child_container'),
        );
        final originalSize = tester.getSize(childFinder);
        final firstLocation = tester.getCenter(resizePointFinder);
        await tester.flingFrom(
          firstLocation,
          Offset(firstLocation.dx + 10, firstLocation.dy + 10),
          3,
        );
        await tester.pump(kThemeAnimationDuration);
        final newSize = tester.getSize(childFinder);
        expect(originalSize == newSize, isFalse);
        expect(onUpdateCalls, isNotEmpty);
      });

      testWidgets(
          'bottom left corner as draggable point renders '
          'when canTransform is true', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(
              children: [
                DraggableResizable(
                  platformHelper: platformHelper,
                  canTransform: true,
                  size: size,
                  child: child,
                ),
              ],
            ),
          ),
        );
        expect(
          find.byKey(Key('draggableResizable_bottomLeft_resizePoint')),
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
                DraggableResizable(
                  platformHelper: platformHelper,
                  size: size,
                  child: child,
                ),
              ],
            ),
          ),
        );
        expect(
          find.byKey(Key('draggableResizable_bottomLeft_resizePoint')),
          findsNothing,
        );
      });

      testWidgets('bottom left corner point can resize child', (tester) async {
        final onUpdateCalls = <DragUpdate>[];
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(
              children: [
                DraggableResizable(
                  platformHelper: platformHelper,
                  onUpdate: onUpdateCalls.add,
                  canTransform: true,
                  size: size,
                  child: child,
                ),
              ],
            ),
          ),
        );
        final resizePointFinder = find.byKey(
          Key('draggableResizable_bottomLeft_resizePoint'),
        );
        final childFinder = find.byKey(
          const Key('draggableResizable_child_container'),
        );
        final originalSize = tester.getSize(childFinder);
        final firstLocation = tester.getCenter(resizePointFinder);
        await tester.flingFrom(
          firstLocation,
          Offset(firstLocation.dx + 10, firstLocation.dy + 10),
          3,
        );
        await tester.pump(kThemeAnimationDuration);
        final newSize = tester.getSize(childFinder);
        expect(originalSize == newSize, isFalse);
        expect(onUpdateCalls, isNotEmpty);
      });

      testWidgets('delete button does not render when canTransform is false',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: DraggableResizable(
              platformHelper: platformHelper,
              onDelete: () {},
              size: size,
              child: child,
            ),
          ),
        );
        expect(
          find.byKey(Key('draggableResizable_delete_floatingActionIcon')),
          findsNothing,
        );
      });

      testWidgets(
          'delete button does not render when '
          'there is delete callback', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: DraggableResizable(
              platformHelper: platformHelper,
              size: size,
              child: child,
            ),
          ),
        );
        expect(
          find.byKey(Key('draggableResizable_delete_floatingActionIcon')),
          findsNothing,
        );
      });

      testWidgets(
          'delete button renders when canTransform is true and '
          'has delete callback', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: DraggableResizable(
              platformHelper: platformHelper,
              canTransform: true,
              onDelete: () {},
              size: size,
              child: child,
            ),
          ),
        );
        expect(
          find.byKey(Key('draggableResizable_delete_floatingActionIcon')),
          findsOneWidget,
        );
      });

      testWidgets('rotate anchor rotates asset', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: DraggableResizable(
              platformHelper: platformHelper,
              canTransform: true,
              size: size,
              child: child,
            ),
          ),
        );

        final gestureDetector = tester.widget<GestureDetector>(
          find.byKey(Key('draggableResizable_rotate_gestureDetector')),
        );

        gestureDetector.onScaleStart!(
          ScaleStartDetails(localFocalPoint: Offset(0, 0)),
        );
        gestureDetector.onScaleUpdate!(
          ScaleUpdateDetails(localFocalPoint: Offset(1, 1)),
        );
        gestureDetector.onScaleEnd!(ScaleEndDetails());

        await tester.pumpAndSettle();
        final childFinder = find.byKey(
          Key('draggableResizable_child_draggablePoint'),
        );
        final transformFinder = find.ancestor(
          of: childFinder,
          matching: find.byType(Transform),
        );
        final transformWidget = tester.widget<Transform>(transformFinder);
        expect(
          transformWidget.transform,
          isNot(equals(Matrix4.diagonal3Values(1, 1, 1))),
        );
      });

      testWidgets('tapping on rotate icon does nothing', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: DraggableResizable(
              platformHelper: platformHelper,
              canTransform: true,
              size: size,
              child: child,
            ),
          ),
        );

        await tester.tap(
          find.byKey(Key('draggableResizable_rotate_floatingActionIcon')),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
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
                DraggableResizable(
                  onUpdate: onUpdateCalls.add,
                  canTransform: true,
                  platformHelper: platformHelper,
                  size: size,
                  child: child,
                ),
              ],
            ),
          ),
        );
        final childFinder = find.byKey(
          Key('draggableResizable_child_draggablePoint'),
        );
        final origin = tester.getCenter(childFinder);
        final offset = Offset(30, 30);
        await tester.drag(childFinder, offset);
        await tester.pumpAndSettle();

        final destination = tester.getCenter(childFinder);
        expect(origin == destination, isFalse);
        expect(onUpdateCalls, isNotEmpty);
      });

      testWidgets('is resizable', (tester) async {
        final onUpdateCalls = <DragUpdate>[];
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(
              children: [
                DraggableResizable(
                  onUpdate: onUpdateCalls.add,
                  canTransform: true,
                  platformHelper: platformHelper,
                  size: size,
                  child: child,
                ),
              ],
            ),
          ),
        );

        final childFinder = find.byKey(
          Key('draggableResizable_child_draggablePoint'),
        );
        final gestureDetectorFinder = find.descendant(
          of: childFinder,
          matching: find.byType(GestureDetector),
        );
        final gestureDetector =
            tester.widget<GestureDetector>(gestureDetectorFinder);
        gestureDetector.onScaleStart!(ScaleStartDetails(pointerCount: 2));
        gestureDetector.onScaleUpdate!(
          ScaleUpdateDetails(scale: 2, pointerCount: 2),
        );

        await tester.pumpAndSettle();

        expect(onUpdateCalls, isNotEmpty);
      });

      testWidgets('is rotatable', (tester) async {
        final onUpdateCalls = <DragUpdate>[];
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(
              children: [
                DraggableResizable(
                  onUpdate: onUpdateCalls.add,
                  canTransform: true,
                  platformHelper: platformHelper,
                  size: size,
                  child: child,
                ),
              ],
            ),
          ),
        );

        final childFinder = find.byKey(
          Key('draggableResizable_child_draggablePoint'),
        );
        final gestureDetectorFinder = find.descendant(
          of: childFinder,
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
          of: childFinder,
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
                DraggableResizable(
                  onUpdate: onUpdateCalls.add,
                  canTransform: true,
                  platformHelper: platformHelper,
                  size: size,
                  child: child,
                ),
              ],
            ),
          ),
        );

        final childFinder = find.byKey(
          Key('draggableResizable_child_draggablePoint'),
        );
        final gestureDetectorFinder = find.descendant(
          of: childFinder,
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
          of: childFinder,
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
