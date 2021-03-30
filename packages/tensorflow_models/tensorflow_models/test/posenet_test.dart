import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:tensorflow_models/tensorflow_models.dart';
import 'package:tensorflow_models/posenet.dart' as posenet;

class MockTensorflowModelsPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements TensorflowModelsPlatform {}

class MockPoseNet extends Mock implements PoseNet {}

class FakeModelConfig extends Fake implements ModelConfig {}

void main() {
  group('Posenet', () {
    late TensorflowModelsPlatform platform;

    setUpAll(() {
      registerFallbackValue<ModelConfig>(FakeModelConfig());
    });

    setUp(() {
      platform = MockTensorflowModelsPlatform();
      TensorflowModelsPlatform.instance = platform;
    });

    group('load', () {
      test('invokes loadPosenet and returns correct PoseNet', () async {
        final net = MockPoseNet();
        when(() => platform.loadPosenet(any())).thenAnswer((_) async => net);
        expect(await posenet.load(), equals(net));
      });
    });
  });
}
