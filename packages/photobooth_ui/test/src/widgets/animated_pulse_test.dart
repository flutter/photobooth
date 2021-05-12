// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class MockAnimationController extends Mock implements AnimationController {}

void main() {
  late AnimationController animation;
  setUp(() {
    animation = MockAnimationController();
  });

  group('AnimatedPulse', () {
    testWidgets('renders', (tester) async {
      var isVisible = true;
      await tester.runAsync(() async {
        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) {
              return isVisible
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          isVisible = false;
                        });
                      },
                      child: AnimatedPulse(
                        child: SizedBox(),
                      ),
                    )
                  : SizedBox();
            },
          ),
        );

        await tester.pump(Duration(milliseconds: 6000));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(GestureDetector));
        await tester.pumpAndSettle();
        expect(find.byType(AnimatedPulse), findsNothing);
      });
    });
  });

  group('PulsingPainter', () {
    test('verifies should repaint', () async {
      final pulsingPainter = PulsingPainter(animation);
      expect(pulsingPainter.shouldRepaint(pulsingPainter), true);
    });
  });
}
