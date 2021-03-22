@TestOn('chrome')
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tensorflow_platform_interface/tensorflow_platform_interface.dart';
import 'package:tensorflow_web/tensorflow_web.dart';

class MockRegistrar extends Mock implements Registrar {}

void main() {
  group('TensorflowPlugin', () {
    group('registerWith', () {
      test('creates an instance', () {
        TensorflowPlugin.registerWith(MockRegistrar());
        expect(TensorflowPlatform.instance, isNotNull);
      });
    });
  });
}
