@TestOn('!chrome')

import 'package:flutter_test/flutter_test.dart';
import 'package:platform_helper/platform_helper.dart';

void main() {
  group('MobilePlatformHelper', () {
    test('returns true', () async {
      final helper = const PlatformHelper();
      expect(helper.isMobile, true);
    });
  });
}
