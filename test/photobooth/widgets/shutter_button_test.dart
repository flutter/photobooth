import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

import '../../helpers/helpers.dart';

class MockAnimationController extends Mock implements AnimationController {}

class MockCanvas extends Mock implements Canvas {}

class MockPaint extends Mock implements Paint {}

class RectFake extends Fake implements Rect {}

class MockAudioPlayer extends Mock implements AudioPlayer {}

void main() {
  late AudioPlayer audioPlayer;

  setUp(() {
    audioPlayer = MockAudioPlayer();
    when(() => audioPlayer.setAsset(any())).thenAnswer((_) async => null);
    when(() => audioPlayer.load()).thenAnswer((_) async {});
    when(() => audioPlayer.play()).thenAnswer((_) async {});
    when(() => audioPlayer.pause()).thenAnswer((_) async {});
    when(() => audioPlayer.stop()).thenAnswer((_) async {});
    when(() => audioPlayer.seek(any())).thenAnswer((_) async {});
    when(() => audioPlayer.dispose()).thenAnswer((_) async {});
    when(() => audioPlayer.playerStateStream).thenAnswer(
      (_) => Stream.fromIterable(
        [
          PlayerState(true, ProcessingState.ready),
        ],
      ),
    );
  });

  group('ShutterButton', () {
    testWidgets('renders', (tester) async {
      await tester.pumpApp(ShutterButton(onCountdownComplete: () {}));
      expect(find.byType(ShutterButton), findsOneWidget);
    });

    testWidgets('renders CameraButton when animation has not started',
        (tester) async {
      await tester.pumpApp(ShutterButton(onCountdownComplete: () {}));
      expect(find.byType(CameraButton), findsOneWidget);
      expect(find.byType(CountdownTimer), findsNothing);
    });

    testWidgets('renders CountdownTimer when clicks on CameraButton with audio',
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(ShutterButton(
          onCountdownComplete: () {},
          audioPlayer: () => audioPlayer,
        ));
        await tester.tap(find.byType(CameraButton));
        await tester.pump();
        expect(find.byType(CountdownTimer), findsOneWidget);
        await tester.pumpAndSettle();
        verify(() => audioPlayer.setAsset(any())).called(1);
        verify(() => audioPlayer.play()).called(2);
        verify(() => audioPlayer.pause()).called(1);
      });
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

      TimerPainter(animation: animation, countdown: 3)
          .paint(canvas, const Size(200, 200));

      verify(() => canvas.drawCircle(any(), any(), any())).called(1);
      verify(() => canvas.drawArc(any(), any(), any(), any(), any())).called(1);
    });
  });
}
