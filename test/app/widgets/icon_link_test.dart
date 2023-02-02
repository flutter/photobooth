// ignore_for_file: prefer_const_constructors

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

void main() {
  setUpAll(() {
    registerFallbackValue(LaunchOptions());
  });

  group('IconLink', () {
    testWidgets('opens link when tapped', (tester) async {
      final originalUrlLauncher = UrlLauncherPlatform.instance;
      final mock = MockUrlLauncher();
      UrlLauncherPlatform.instance = mock;
      when(() => mock.canLaunch(any())).thenAnswer((_) async => true);
      when(() => mock.launchUrl(any(), any())).thenAnswer((_) async => true);

      await tester.pumpApp(
        IconLink(
          link: 'https://example.com',
          icon: Icon(Icons.image),
        ),
      );

      await tester.tap(find.byType(IconLink));
      await tester.pumpAndSettle();

      verify(() => mock.launchUrl('https://example.com', any())).called(1);

      UrlLauncherPlatform.instance = originalUrlLauncher;
    });
  });

  group('FlutterIconLink', () {
    testWidgets('renders IconLink widget with a proper link', (tester) async {
      await tester.pumpApp(FlutterIconLink());
      final widget = tester.widget<IconLink>(find.byType(IconLink));
      expect(widget.link, equals(flutterDevExternalLink));
    });
  });

  group('FirebaseIconLink', () {
    testWidgets('renders IconLink widget with a proper link', (tester) async {
      await tester.pumpApp(FirebaseIconLink());
      final widget = tester.widget<IconLink>(find.byType(IconLink));
      expect(widget.link, equals(firebaseExternalLink));
    });
  });
}
