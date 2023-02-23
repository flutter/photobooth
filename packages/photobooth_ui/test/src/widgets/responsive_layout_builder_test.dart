import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

import '../helpers/helpers.dart';

void main() {
  group('ResponsiveLayout', () {
    testWidgets('displays a large layout if medium is not provided',
        (tester) async {
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.medium, 800));
      const smallKey = Key('__small__');
      const largeKey = Key('__large__');

      await tester.pumpWidget(
        ResponsiveLayoutBuilder(
          small: (_, __) => const SizedBox(key: smallKey),
          large: (_, __) => const SizedBox(key: largeKey),
        ),
      );

      expect(find.byKey(smallKey), findsNothing);
      expect(find.byKey(largeKey), findsOneWidget);
    });

    testWidgets('displays a medium layout', (tester) async {
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.small + 1, 800));
      const smallKey = Key('__small__');
      const mediumKey = Key('__medium__');
      const largeKey = Key('__large__');

      await tester.pumpWidget(
        ResponsiveLayoutBuilder(
          small: (_, __) => const SizedBox(key: smallKey),
          medium: (_, __) => const SizedBox(key: mediumKey),
          large: (_, __) => const SizedBox(key: largeKey),
        ),
      );

      expect(find.byKey(smallKey), findsNothing);
      expect(find.byKey(mediumKey), findsOneWidget);
      expect(find.byKey(largeKey), findsNothing);
    });

    testWidgets('displays a large layout if xLarge is not provided',
        (tester) async {
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.large + 1, 800));
      const smallKey = Key('__small__');
      const largeKey = Key('__large__');

      await tester.pumpWidget(
        ResponsiveLayoutBuilder(
          small: (_, __) => const SizedBox(key: smallKey),
          large: (_, __) => const SizedBox(key: largeKey),
        ),
      );

      expect(find.byKey(smallKey), findsNothing);
      expect(find.byKey(largeKey), findsOneWidget);
    });

    testWidgets('displays a xLarge layout', (tester) async {
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.large + 1, 800));
      const smallKey = Key('__small__');
      const largeKey = Key('__large__');
      const xLargeKey = Key('__xLarge__');

      await tester.pumpWidget(
        ResponsiveLayoutBuilder(
          small: (_, __) => const SizedBox(key: smallKey),
          large: (_, __) => const SizedBox(key: largeKey),
          xLarge: (_, __) => const SizedBox(key: xLargeKey),
        ),
      );

      expect(find.byKey(smallKey), findsNothing);
      expect(find.byKey(largeKey), findsNothing);
      expect(find.byKey(xLargeKey), findsOneWidget);
    });

    testWidgets('displays a large layout', (tester) async {
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.large, 800));
      const smallKey = Key('__small__');
      const largeKey = Key('__large__');
      const xLargeKey = Key('__xLarge__');

      await tester.pumpWidget(
        ResponsiveLayoutBuilder(
          small: (_, __) => const SizedBox(key: smallKey),
          large: (_, __) => const SizedBox(key: largeKey),
          xLarge: (_, __) => const SizedBox(key: xLargeKey),
        ),
      );

      expect(find.byKey(largeKey), findsOneWidget);
      expect(find.byKey(smallKey), findsNothing);
      expect(find.byKey(xLargeKey), findsNothing);
    });

    testWidgets('displays a small layout', (tester) async {
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.small, 800));
      const smallKey = Key('__small__');
      const largeKey = Key('__large__');

      await tester.pumpWidget(
        ResponsiveLayoutBuilder(
          small: (_, __) => const SizedBox(key: smallKey),
          large: (_, __) => const SizedBox(key: largeKey),
        ),
      );

      expect(find.byKey(largeKey), findsNothing);
      expect(find.byKey(smallKey), findsOneWidget);
    });

    testWidgets('displays child when available (large)', (tester) async {
      const smallKey = Key('__small__');
      const largeKey = Key('__large__');
      const childKey = Key('__child__');

      await tester.pumpWidget(
        ResponsiveLayoutBuilder(
          small: (_, child) => SizedBox(key: smallKey, child: child),
          large: (_, child) => SizedBox(key: largeKey, child: child),
          child: const SizedBox(key: childKey),
        ),
      );

      expect(find.byKey(largeKey), findsOneWidget);
      expect(find.byKey(smallKey), findsNothing);
      expect(find.byKey(childKey), findsOneWidget);
    });

    testWidgets('displays child when available (small)', (tester) async {
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.small, 800));

      const smallKey = Key('__small__');
      const largeKey = Key('__large__');
      const childKey = Key('__child__');

      await tester.pumpWidget(
        ResponsiveLayoutBuilder(
          small: (_, child) => SizedBox(key: smallKey, child: child),
          large: (_, child) => SizedBox(key: largeKey, child: child),
          child: const SizedBox(key: childKey),
        ),
      );

      expect(find.byKey(largeKey), findsNothing);
      expect(find.byKey(smallKey), findsOneWidget);
      expect(find.byKey(childKey), findsOneWidget);

      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });
  });
}
