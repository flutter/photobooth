@TestOn('!chrome')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:platform_helper/platform_helper.dart';

void main() {
  group('MobilePlatformHelper', () {
    test('returns true', () {
      final helper = PlatformHelper();
      expect(helper.isMobile, true);
    });
  });
}
