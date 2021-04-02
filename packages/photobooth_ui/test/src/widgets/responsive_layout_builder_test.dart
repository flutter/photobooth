import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

void main() {
  group('ResponsiveLayout', () {
    testWidgets('displays a DesktopButtonsLayout', (tester) async {
      const mobileKey = Key('__mobile__');
      const desktopKey = Key('__desktop__');

      await tester.pumpWidget(ResponsiveLayoutBuilder(
        mobile: (_) => const SizedBox(key: mobileKey),
        desktop: (_) => const SizedBox(key: desktopKey),
      ));

      expect(find.byKey(desktopKey), findsOneWidget);
      expect(find.byKey(mobileKey), findsNothing);
    });

    testWidgets('displays a MobileButtonsLayout', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(
        PhotoboothBreakpoints.mobile,
        1000,
      );
      const mobileKey = Key('__mobile__');
      const desktopKey = Key('__desktop__');

      await tester.pumpWidget(ResponsiveLayoutBuilder(
        mobile: (_) => const SizedBox(key: mobileKey),
        desktop: (_) => const SizedBox(key: desktopKey),
      ));

      expect(find.byKey(desktopKey), findsNothing);
      expect(find.byKey(mobileKey), findsOneWidget);

      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });
  });
}
