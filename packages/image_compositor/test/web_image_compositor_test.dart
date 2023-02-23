@TestOn('chrome')
library;

import 'package:image_compositor/src/web.dart';
import 'package:test/test.dart';

void main() {
  group('ImageCompositor', () {
    test('can be instantiated', () {
      expect(ImageCompositor(), isNotNull);
    });
  });
}
