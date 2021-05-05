// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/landing/landing.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import '../../helpers/helpers.dart';

void main() {
  group('LandingPage', () {
    testWidgets('renders landing view', (tester) async {
      await tester.pumpApp(const LandingPage());
      expect(find.byType(LandingView), findsOneWidget);
    });
  });

  group('LandingView', () {
    testWidgets('renders background', (tester) async {
      await tester.pumpApp(const LandingView());
      expect(find.byKey(Key('landingPage_background')), findsOneWidget);
    });

    testWidgets('renders heading', (tester) async {
      await tester.pumpApp(const LandingView());
      expect(find.byKey(Key('landingPage_heading_text')), findsOneWidget);
    });

    testWidgets('renders image', (tester) async {
      await tester.pumpApp(const LandingView());
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('renders image on small screens', (tester) async {
      tester.setDisplaySize(const Size(PhotoboothBreakpoints.small, 1000));
      await tester.pumpApp(const LandingView());
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('renders subheading', (tester) async {
      await tester.pumpApp(const LandingView());
      expect(find.byKey(Key('landingPage_subheading_text')), findsOneWidget);
    });

    testWidgets('renders take photo button', (tester) async {
      await tester.pumpApp(const LandingView());
      expect(find.byType(LandingTakePhotoButton), findsOneWidget);
    });

    testWidgets('renders black footer', (tester) async {
      await tester.pumpApp(const LandingView());
      await tester.ensureVisible(find.byType(BlackFooter, skipOffstage: false));
      await tester.pumpAndSettle();
      expect(find.byType(BlackFooter), findsOneWidget);
    });

    testWidgets('tapping on take photo button navigates to PhotoboothPage',
        (tester) async {
      await runZonedGuarded(() async {
        await tester.pumpApp(const LandingView());
        await tester.ensureVisible(find.byType(
          LandingTakePhotoButton,
          skipOffstage: false,
        ));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(
          LandingTakePhotoButton,
          skipOffstage: false,
        ));
        await tester.pumpAndSettle();
      }, (_, __) {});

      expect(find.byType(PhotoboothPage), findsOneWidget);
      expect(find.byType(LandingView), findsNothing);
    });
  });
}
