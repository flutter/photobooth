// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/landing/landing.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
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
      expect(find.byType(TakePhotoButton), findsOneWidget);
    });

    testWidgets('tapping on take photo button navigates to PhotoboothPage',
        (tester) async {
      await runZonedGuarded(() async {
        await tester.pumpApp(const LandingView());
        await tester.ensureVisible(find.byType(TakePhotoButton));
        await tester.tap(find.byType(TakePhotoButton));
        await tester.pumpAndSettle();
      }, (_, __) {});

      expect(find.byType(PhotoboothPage), findsOneWidget);
      expect(find.byType(LandingView), findsNothing);
    });
  });
}
