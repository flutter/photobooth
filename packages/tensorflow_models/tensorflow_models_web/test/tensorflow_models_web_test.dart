@TestOn('chrome')

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tensorflow_models_platform_interface/tensorflow_models_platform_interface.dart';
import 'package:tensorflow_models_web/tensorflow_models_web.dart';
import 'package:tensorflow_models_web/src/posenet/posenet.dart' as posenet;

class MockRegistrar extends Mock implements Registrar {}

class MockPosenet extends Mock implements posenet.PoseNet {}

class TestPosenet {
  Future<posenet.PoseNet> load([posenet.ModelConfig? config]) async {
    return MockPosenet();
  }
}

void main() {
  group('TensorflowModelsPlugin', () {
    group('registerWith', () {
      test('creates an instance', () {
        TensorflowModelsPlugin.registerWith(MockRegistrar());
        expect(TensorflowModelsPlatform.instance, isNotNull);
      });
    });
  });
}
