// ignore_for_file: prefer_const_constructors
import 'package:test/test.dart';

import 'package:tensorflow_web/tensorflow_web.dart';

void main() {
  group('TensorflowWeb', () {
    test('can be instantiated', () {
      expect(TensorflowPlugin(), isNotNull);
    });
  });
}
