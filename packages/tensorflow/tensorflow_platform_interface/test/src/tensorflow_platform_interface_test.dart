import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:tensorflow_platform_interface/tensorflow_platform_interface.dart';

class MockTensorflowPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements TensorflowPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TensorflowPlatform', () {
    test('instance returns valid TensorflowPlatform', () {
      final instance = TensorflowPlatform.instance;
      expect(instance, isNotNull);
    });

    test('instance can be overriden', () {
      final mockPlatform = MockTensorflowPlatform();
      TensorflowPlatform.instance = mockPlatform;
      final instance = TensorflowPlatform.instance;
      expect(
        instance,
        equals(mockPlatform),
      );
    });
  });
}
