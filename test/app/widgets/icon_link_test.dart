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
  group('IconLink', () {
    testWidgets('opens link when tapped', (tester) async {
      final mock = MockUrlLauncher();
      UrlLauncherPlatform.instance = mock;
      when(() => mock.canLaunch(any())).thenAnswer((_) async => true);
      when(() => mock.launch(
            any(),
            useSafariVC: true,
            useWebView: false,
            enableJavaScript: false,
            enableDomStorage: false,
            universalLinksOnly: false,
            headers: const {},
          )).thenAnswer((_) async => true);

      await tester.pumpApp(
        IconLink(
          link: 'https://example.com',
          icon: Icon(Icons.image),
        ),
      );

      await tester.tap(find.byType(IconLink));
      await tester.pumpAndSettle();

      verify(() => mock.launch(
            'https://example.com',
            useSafariVC: true,
            useWebView: false,
            enableJavaScript: false,
            enableDomStorage: false,
            universalLinksOnly: false,
            headers: const {},
          )).called(1);
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
