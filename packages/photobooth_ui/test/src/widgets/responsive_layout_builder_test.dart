import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

void main() {
  group('ResponsiveLayout', () {
    testWidgets('displays a desktop layout', (tester) async {
      const mobileKey = Key('__mobile__');
      const desktopKey = Key('__desktop__');

      await tester.pumpWidget(ResponsiveLayoutBuilder(
        mobile: (_, __) => const SizedBox(key: mobileKey),
        desktop: (_, __) => const SizedBox(key: desktopKey),
      ));

      expect(find.byKey(desktopKey), findsOneWidget);
      expect(find.byKey(mobileKey), findsNothing);
    });

    testWidgets('displays a mobile layout', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(
        PhotoboothBreakpoints.mobile,
        1000,
      );
      const mobileKey = Key('__mobile__');
      const desktopKey = Key('__desktop__');

      await tester.pumpWidget(ResponsiveLayoutBuilder(
        mobile: (_, __) => const SizedBox(key: mobileKey),
        desktop: (_, __) => const SizedBox(key: desktopKey),
      ));

      expect(find.byKey(desktopKey), findsNothing);
      expect(find.byKey(mobileKey), findsOneWidget);

      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });

    testWidgets('displays child when available (desktop)', (tester) async {
      const mobileKey = Key('__mobile__');
      const desktopKey = Key('__desktop__');
      const childKey = Key('__child__');

      await tester.pumpWidget(ResponsiveLayoutBuilder(
        mobile: (_, child) => SizedBox(key: mobileKey, child: child),
        desktop: (_, child) => SizedBox(key: desktopKey, child: child),
        child: const SizedBox(key: childKey),
      ));

      expect(find.byKey(desktopKey), findsOneWidget);
      expect(find.byKey(mobileKey), findsNothing);
      expect(find.byKey(childKey), findsOneWidget);
    });

    testWidgets('displays child when available (mobile)', (tester) async {
      const mobileKey = Key('__mobile__');
      const desktopKey = Key('__desktop__');
      const childKey = Key('__child__');

      tester.binding.window.physicalSizeTestValue = const Size(
        PhotoboothBreakpoints.mobile,
        1000,
      );

      await tester.pumpWidget(ResponsiveLayoutBuilder(
        mobile: (_, child) => SizedBox(key: mobileKey, child: child),
        desktop: (_, child) => SizedBox(key: desktopKey, child: child),
        child: const SizedBox(key: childKey),
      ));

      expect(find.byKey(desktopKey), findsNothing);
      expect(find.byKey(mobileKey), findsOneWidget);
      expect(find.byKey(childKey), findsOneWidget);

      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });
  });
}
