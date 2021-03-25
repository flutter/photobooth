import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/landing/landing.dart';

import '../../helpers/helpers.dart';

void main() {
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

    testWidgets('tapping on take photo button does nothing', (tester) async {
      await tester.pumpApp(const LandingView());
      await tester.tap(find.byType(ElevatedButton));
      expect(find.byType(LandingView), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
