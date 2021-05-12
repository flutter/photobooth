// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class MockAnimationController extends Mock implements AnimationController {}

void main() {
  group('AnimatedPulse', () {
    testWidgets('renders with default settings', (tester) async {
      await tester.pumpWidget(AnimatedPulse(child: SizedBox()));

      /// Pulse Animation
      await tester.pump(defaultPulseDuration);

      /// Time between pulses
      await tester.pump(defaultTimeBetweenPulses);

      /// Start new animation
      await tester.pump(defaultPulseDuration);

      expect(find.byType(CustomPaint), findsOneWidget);
    });

    testWidgets('renders with custom settings', (tester) async {
      const testDuration = Duration(milliseconds: 1);
      await tester.pumpWidget(
        AnimatedPulse(
          pulseDuration: testDuration,
          timeBetweenPulses: testDuration,
          child: SizedBox(),
        ),
      );

      /// Pulse Animation
      await tester.pump(testDuration);

      /// Time between pulses
      await tester.pump(testDuration);

      /// Start new animation
      await tester.pump(testDuration);

      expect(find.byType(CustomPaint), findsOneWidget);
    });
  });

  group('PulsePainter', () {
    test('verifies should repaint', () async {
      final pulsePainter = PulsePainter(MockAnimationController());
      expect(pulsePainter.shouldRepaint(pulsePainter), true);
    });
  });
}
