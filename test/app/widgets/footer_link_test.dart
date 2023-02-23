// ignore_for_file: prefer_const_constructors
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/external_links/external_links.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../helpers/helpers.dart';

class MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

bool findTextAndTap(InlineSpan visitor, String text) {
  if (visitor is TextSpan && visitor.text == text) {
    (visitor.recognizer! as TapGestureRecognizer).onTap?.call();

    return false;
  }

  return true;
}

bool tapTextSpan(RichText richText, String text) {
  final isTapped = !richText.text.visitChildren(
    (visitor) => findTextAndTap(visitor, text),
  );

  return isTapped;
}

void main() {
  setUpAll(() {
    registerFallbackValue(LaunchOptions());
  });

  group('FooterLink', () {
    late UrlLauncherPlatform originalUrlLauncher;

    setUp(() {
      originalUrlLauncher = UrlLauncherPlatform.instance;
    });

    tearDown(() {
      UrlLauncherPlatform.instance = originalUrlLauncher;
    });

    testWidgets('opens link when tapped', (tester) async {
      final mock = MockUrlLauncher();
      UrlLauncherPlatform.instance = mock;
      when(() => mock.canLaunch(any())).thenAnswer((_) async => true);
      when(() => mock.launchUrl(any(), any())).thenAnswer((_) async => true);
      await tester.pumpApp(
        FooterLink(
          link: 'https://example.com',
          text: 'Link',
        ),
      );

      await tester.tap(find.byType(FooterLink));
      await tester.pumpAndSettle();

      verify(() => mock.launchUrl('https://example.com', any())).called(1);
    });

    group('MadeWith', () {
      late UrlLauncherPlatform mock;

      setUp(() {
        mock = MockUrlLauncher();
        UrlLauncherPlatform.instance = mock;
      });

      testWidgets('opens the Flutter website when tapped', (tester) async {
        when(() => mock.canLaunch(any())).thenAnswer((_) async => true);
        when(() => mock.launchUrl(any(), any())).thenAnswer((_) async => true);
        await tester.pumpApp(FooterMadeWithLink());

        final flutterTextFinder = find.byWidgetPredicate(
          (widget) => widget is RichText && tapTextSpan(widget, 'Flutter'),
        );
        await tester.tap(flutterTextFinder);
        await tester.pumpAndSettle();

        verify(() => mock.launchUrl(flutterDevExternalLink, any()));
      });

      testWidgets('opens the Firebase website when tapped', (tester) async {
        when(() => mock.canLaunch(any())).thenAnswer((_) async => true);
        when(() => mock.launchUrl(any(), any())).thenAnswer((_) async => true);
        await tester.pumpApp(FooterMadeWithLink());

        final flutterTextFinder = find.byWidgetPredicate(
          (widget) => widget is RichText && tapTextSpan(widget, 'Firebase'),
        );
        await tester.tap(flutterTextFinder);
        await tester.pumpAndSettle();

        verify(() => mock.launchUrl(firebaseExternalLink, any()));
      });
    });

    group('Google IO', () {
      testWidgets('renders FooterLink with a proper link', (tester) async {
        await tester.pumpApp(FooterGoogleIOLink());

        final widget = tester.widget<FooterLink>(
          find.byType(FooterLink),
        );

        expect(widget.link, equals(googleIOExternalLink));
      });
    });

    group('Codelab', () {
      testWidgets('renders FooterLink with a proper link', (tester) async {
        await tester.pumpApp(FooterCodelabLink());

        final widget = tester.widget<FooterLink>(
          find.byType(FooterLink),
        );

        expect(
          widget.link,
          equals(
            'https://firebase.google.com/codelabs/firebase-get-to-know-flutter#0',
          ),
        );
      });
    });

    group('How Its Made', () {
      testWidgets('renders FooterLink with a proper link', (tester) async {
        await tester.pumpApp(FooterHowItsMadeLink());

        final widget = tester.widget<FooterLink>(
          find.byType(FooterLink),
        );

        expect(
          widget.link,
          equals(
            'https://medium.com/flutter/how-its-made-i-o-photo-booth-3b8355d35883',
          ),
        );
      });
    });

    group('Terms of Service', () {
      testWidgets('renders FooterLink with a proper link', (tester) async {
        await tester.pumpApp(FooterTermsOfServiceLink());

        final widget = tester.widget<FooterLink>(
          find.byType(FooterLink),
        );

        expect(
          widget.link,
          equals(
            'https://policies.google.com/terms',
          ),
        );
      });
    });

    group('Privacy Policy', () {
      testWidgets('renders FooterLink with a proper link', (tester) async {
        await tester.pumpApp(FooterPrivacyPolicyLink());

        final widget = tester.widget<FooterLink>(
          find.byType(FooterLink),
        );

        expect(
          widget.link,
          equals(
            'https://policies.google.com/privacy',
          ),
        );
      });
    });
  });
}
