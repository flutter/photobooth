import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/landing/landing.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route<dynamic> {}

class FakeRoutePhotobooth extends Fake implements Route<PhotoboothPage> {}

void main() {
  setUpAll(() {
    registerFallbackValue<Route<dynamic>>(FakeRoute());
    registerFallbackValue<Route<PhotoboothPage>>(FakeRoutePhotobooth());
  });
  group('LandingPage', () {
    testWidgets('renders landing view', (tester) async {
      await tester.pumpApp(const LandingPage());
      expect(find.byType(LandingView), findsOneWidget);
    });
  });

  group('LandingView', () {
    testWidgets('renders take photo button', (tester) async {
      await tester.pumpApp(const LandingView());
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('tapping on take photo button navigates to PhotoboothPage',
        (tester) async {
      final observer = MockNavigatorObserver();
      tester.binding.window.physicalSizeTestValue = const Size(600, 1000);

      await tester.pumpApp(const LandingView(), navigatorObserver: observer);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      verify(() => observer.didPush(any<Route<PhotoboothPage>>(), any()))
          .called(1);
    });
  });
}
