import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:platform_helper/platform_helper.dart';

class MockPlatformHelper extends Mock implements PlatformHelper {}

void main() {
  group('PlatformBuilder', () {
    late PlatformHelper platformHelper;

    setUp(() {
      platformHelper = MockPlatformHelper();
    });

    testWidgets('renders without platform helper parameter', (tester) async {
      await tester.pumpWidget(
        PlatformBuilder(
          mobile: const SizedBox(),
          desktop: const SizedBox(),
        ),
      );
      expect(find.byType(PlatformBuilder), findsOneWidget);
    });

    testWidgets('renders mobile when isMobile: true', (tester) async {
      const mobileKey = Key('__mobile__');
      const desktopKey = Key('__desktop__');

      when(() => platformHelper.isMobile).thenReturn(true);

      await tester.pumpWidget(
        PlatformBuilder(
          mobile: const SizedBox(key: mobileKey),
          desktop: const SizedBox(key: desktopKey),
          platformHelper: platformHelper,
        ),
      );

      expect(find.byKey(mobileKey), findsOneWidget);
      expect(find.byKey(desktopKey), findsNothing);
    });

    testWidgets('renders desktop when isMobile: false', (tester) async {
      const mobileKey = Key('__mobile__');
      const desktopKey = Key('__desktop__');

      when(() => platformHelper.isMobile).thenReturn(false);

      await tester.pumpWidget(
        PlatformBuilder(
          mobile: const SizedBox(key: mobileKey),
          desktop: const SizedBox(key: desktopKey),
          platformHelper: platformHelper,
        ),
      );

      expect(find.byKey(mobileKey), findsNothing);
      expect(find.byKey(desktopKey), findsOneWidget);
    });
  });
}
