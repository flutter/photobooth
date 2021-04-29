import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

extension PhotoboothWidgetTester on WidgetTester {
  void setDisplaySize(Size size) {
    binding.window.physicalSizeTestValue = size;
    binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      binding.window.clearPhysicalSizeTestValue();
      binding.window.clearDevicePixelRatioTestValue();
    });
  }
}

void main() {
  group('ResponsiveLayout', () {
    testWidgets('displays a desktop layout if wide is not provided',
        (tester) async {
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.desktop + 1, 800));
      const mobileKey = Key('__mobile__');
      const desktopKey = Key('__desktop__');
      const wideKey = Key('__wide__');

      await tester.pumpWidget(ResponsiveLayoutBuilder(
        mobile: (_, __) => const SizedBox(key: mobileKey),
        desktop: (_, __) => const SizedBox(key: desktopKey),
      ));

      expect(find.byKey(mobileKey), findsNothing);
      expect(find.byKey(desktopKey), findsOneWidget);
      expect(find.byKey(wideKey), findsNothing);
    });
    testWidgets('displays a wide desktop layout', (tester) async {
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.desktop + 1, 800));
      const mobileKey = Key('__mobile__');
      const desktopKey = Key('__desktop__');
      const wideKey = Key('__wide__');

      await tester.pumpWidget(ResponsiveLayoutBuilder(
        mobile: (_, __) => const SizedBox(key: mobileKey),
        desktop: (_, __) => const SizedBox(key: desktopKey),
        wideDesktop: (_, __) => const SizedBox(key: wideKey),
      ));

      expect(find.byKey(mobileKey), findsNothing);
      expect(find.byKey(desktopKey), findsNothing);
      expect(find.byKey(wideKey), findsOneWidget);
    });

    testWidgets('displays a desktop layout', (tester) async {
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.desktop, 800));
      const mobileKey = Key('__mobile__');
      const desktopKey = Key('__desktop__');
      const wideKey = Key('__wide__');

      await tester.pumpWidget(ResponsiveLayoutBuilder(
        mobile: (_, __) => const SizedBox(key: mobileKey),
        desktop: (_, __) => const SizedBox(key: desktopKey),
        wideDesktop: (_, __) => const SizedBox(key: wideKey),
      ));

      expect(find.byKey(desktopKey), findsOneWidget);
      expect(find.byKey(mobileKey), findsNothing);
      expect(find.byKey(wideKey), findsNothing);
    });

    testWidgets('displays a mobile layout', (tester) async {
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.mobile, 800));
      const mobileKey = Key('__mobile__');
      const desktopKey = Key('__desktop__');

      await tester.pumpWidget(ResponsiveLayoutBuilder(
        mobile: (_, __) => const SizedBox(key: mobileKey),
        desktop: (_, __) => const SizedBox(key: desktopKey),
      ));

      expect(find.byKey(desktopKey), findsNothing);
      expect(find.byKey(mobileKey), findsOneWidget);
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
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.mobile, 800));

      const mobileKey = Key('__mobile__');
      const desktopKey = Key('__desktop__');
      const childKey = Key('__child__');

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
