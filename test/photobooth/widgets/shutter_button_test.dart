import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import '../../helpers/helpers.dart';

class MockAnimationController extends Mock implements AnimationController {}

class MockCanvas extends Mock implements Canvas {}

class MockPaint extends Mock implements Paint {}

class RectFake extends Fake implements Rect {}

void main() {
  group('ShutterButton', () {
    testWidgets('renders', (tester) async {
      await tester.pumpApp(ShutterButton(
        onCountdownComplete: () {},
      ));
      expect(find.byType(ShutterButton), findsOneWidget);
    });

    testWidgets('renders CameraButton when animation didnt start',
        (tester) async {
      await tester.pumpApp(ShutterButton(
        onCountdownComplete: () {},
      ));
      expect(find.byType(CameraButton), findsOneWidget);
      expect(find.byType(CountdownTimer), findsNothing);
    });

    testWidgets('renders CountdownTimer when clicks on CameraButton',
        (tester) async {
      await tester.pumpApp(ShutterButton(
        onCountdownComplete: () {},
      ));
      await tester.tap(find.byType(CameraButton));
      await tester.pump();
      expect(find.byType(CountdownTimer), findsOneWidget);
    });
  });

  group('TimerPainter', () {
    late AnimationController animation;

    setUp(() {
      animation = MockAnimationController();
      registerFallbackValue<Paint>(Paint());
      registerFallbackValue<Offset>(const Offset(200, 200));
      registerFallbackValue<Rect>(RectFake());
    });

    test('calculate correct colors', () async {
      final timePainter = TimerPainter(animation: animation);
      final blue = timePainter.calculateColor(2);
      expect(blue, PhotoboothColors.blue);
      final orange = timePainter.calculateColor(4);
      expect(orange, PhotoboothColors.orange);
      final green = timePainter.calculateColor(10);
      expect(green, PhotoboothColors.green);
    });

    test('verify paints correctly', () {
      when(() => animation.value).thenReturn(2);

      final canvas = MockCanvas();

      TimerPainter(animation: animation)..paint(canvas, const Size(200, 200));

      verify(() => canvas.drawCircle(any(), any(), any())).called(1);
      verify(() => canvas.drawArc(any(), any(), any(), any(), any())).called(1);
    });
  });
}
