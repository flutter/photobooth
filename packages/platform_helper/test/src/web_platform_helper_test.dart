@TestOn('chrome')
library;

import 'dart:html' as html;
import 'package:mocktail/mocktail.dart';
import 'package:platform_helper/src/web.dart';
import 'package:test/test.dart';

class MockWindow extends Mock implements html.Window {}

class MockNavigator extends Mock implements html.Navigator {}

void main() {
  group('WebPlatformHelper', () {
    late html.Window window;
    late html.Navigator navigator;

    setUp(() {
      window = MockWindow();
      navigator = MockNavigator();

      when(() => window.navigator).thenReturn(navigator);
      when(() => navigator.userAgent).thenReturn('iphone');
    });

    test('returns true when user agent is in browser from mobile', () {
      final helper = PlatformHelper()..window = window;
      expect(helper.isMobile, true);
    });

    test('returns false by default', () {
      final helper = PlatformHelper();
      expect(helper.isMobile, false);
    });
  });
}
