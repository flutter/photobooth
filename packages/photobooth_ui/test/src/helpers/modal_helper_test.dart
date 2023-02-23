import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:platform_helper/platform_helper.dart';

import '../helpers/helpers.dart';

class MockPlatformHelper extends Mock implements PlatformHelper {}

void main() {
  late PlatformHelper platformHelper;

  group('showAppModal', () {
    setUp(() {
      platformHelper = MockPlatformHelper();
    });

    testWidgets('renders without platform helper injected', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => showAppModal<void>(
                context: context,
                portraitChild: const Text('portrait'),
                landscapeChild: const Text('landscape'),
              ),
              child: const Text('open app modal'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open app modal'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('shows portraitChild on mobile', (tester) async {
      when(() => platformHelper.isMobile).thenReturn(true);
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => showAppModal<void>(
                context: context,
                platformHelper: platformHelper,
                portraitChild: const Text('portrait'),
                landscapeChild: const Text('landscape'),
              ),
              child: const Text('open app modal'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open app modal'));
      await tester.pumpAndSettle();
      expect(find.text('portrait'), findsOneWidget);
    });

    testWidgets('shows portraitChild sheet on portrait', (tester) async {
      when(() => platformHelper.isMobile).thenReturn(false);
      tester.setPortraitDisplaySize();
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => showAppModal<void>(
                context: context,
                platformHelper: platformHelper,
                portraitChild: const Text('portrait'),
                landscapeChild: const Text('landscape'),
              ),
              child: const Text('open app modal'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open app modal'));
      await tester.pumpAndSettle();
      expect(find.text('portrait'), findsOneWidget);
    });

    testWidgets('shows landscapeChild when landscape and no mobile',
        (tester) async {
      when(() => platformHelper.isMobile).thenReturn(false);
      tester.setLandscapeDisplaySize();
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => showAppModal<void>(
                context: context,
                platformHelper: platformHelper,
                portraitChild: const Text('portrait'),
                landscapeChild: const Text('landscape'),
              ),
              child: const Text('open app modal'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open app modal'));
      await tester.pumpAndSettle();
      expect(find.text('landscape'), findsOneWidget);
    });
  });
}
