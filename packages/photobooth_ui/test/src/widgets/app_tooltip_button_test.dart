import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

void main() {
  group('AppTooltipButton', () {
    testWidgets('renders AppTooltip', (tester) async {
      const target = Key('__key__');
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: AppTooltipButton(
              message: 'message',
              onPressed: () {},
              child: const SizedBox(key: target),
            ),
          ),
        ),
      );
      expect(find.byType(AppTooltip), findsOneWidget);
      expect(find.byKey(target), findsOneWidget);
      expect(find.text('message'), findsNothing);
    });

    testWidgets('calls onPressed when child is tapped', (tester) async {
      var onPressedCallCount = 0;
      const target = Key('__key__');
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: AppTooltipButton(
              message: 'message',
              onPressed: () => onPressedCallCount++,
              child: const SizedBox(key: target),
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(target), warnIfMissed: false);

      expect(onPressedCallCount, equals(1));
    });

    testWidgets('renders tooltip  when mode is visibleUntilInteraction',
        (tester) async {
      const target = Key('__key__');
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: AppTooltipButton(
              message: 'message',
              onPressed: () {},
              mode: TooltipMode.visibleUntilInteraction,
              child: const SizedBox(key: target),
            ),
          ),
        ),
      );

      expect(find.text('message'), findsOneWidget);

      tester.widget<InkWell>(find.byType(InkWell)).onTap!.call();
      await tester.pumpAndSettle();

      expect(find.text('message'), findsNothing);
    });
  });
}
