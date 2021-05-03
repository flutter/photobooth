import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:platform_helper/platform_helper.dart';

class MockPlatformHelper extends Mock implements PlatformHelper {}

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

    testWidgets('renders AppTooltip when mobile is false', (tester) async {
      final platformHelper = MockPlatformHelper();
      when(() => platformHelper.isMobile).thenReturn(false);
      const target = Key('__key__');
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: AppTooltipButton(
              message: 'message',
              onPressed: () {},
              platformHelper: platformHelper,
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

    testWidgets(
        'renders tooltip on mobile when mode is visibleUntilInteraction',
        (tester) async {
      final platformHelper = MockPlatformHelper();
      when(() => platformHelper.isMobile).thenReturn(true);
      const target = Key('__key__');
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: AppTooltipButton(
              message: 'message',
              onPressed: () {},
              platformHelper: platformHelper,
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
