import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/sounds/sounds.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import '../../helpers/helpers.dart';
import '../../helpers/sound_method_channel.dart';

class MockAnimationController extends Mock implements AnimationController {}

class MockCanvas extends Mock implements Canvas {}

class MockPaint extends Mock implements Paint {}

class RectFake extends Fake implements Rect {}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupSoundpoolMethodChannel();
  await Sounds.load();

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

    test('verifies should not repaint', () async {
      final timePainter = TimerPainter(animation: animation, countdown: 3);
      expect(timePainter.shouldRepaint(timePainter), false);
    });

    test('counter is blue with value 3', () async {
      final timePainter = TimerPainter(animation: animation, countdown: 3);
      final blue = timePainter.calculateColor();
      expect(blue, PhotoboothColors.blue);
    });

    test('counter is orange with value 2', () async {
      final timePainter = TimerPainter(animation: animation, countdown: 2);
      final blue = timePainter.calculateColor();
      expect(blue, PhotoboothColors.orange);
    });

    test('counter is green with value 1', () async {
      final timePainter = TimerPainter(animation: animation, countdown: 1);
      final blue = timePainter.calculateColor();
      expect(blue, PhotoboothColors.green);
    });

    test('verify paints correctly', () {
      when(() => animation.value).thenReturn(2);

      final canvas = MockCanvas();

      TimerPainter(
        animation: animation,
        countdown: 3,
      )..paint(canvas, const Size(200, 200));

      verify(() => canvas.drawCircle(any(), any(), any())).called(1);
      verify(() => canvas.drawArc(any(), any(), any(), any(), any())).called(1);
    });
  });
}
