@TestOn('!chrome')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:image_compositor/image_compositor.dart';

void main() {
  group('ImageCompositor', () {
    test('is unsupported in other platforms', () {
      final compositor = ImageCompositor();
      expect(
        () => compositor.composite(
          data: '',
          width: 1,
          height: 1,
          layers: [],
          aspectRatio: 1,
        ),
        throwsUnsupportedError,
      );
    });
  });
}
