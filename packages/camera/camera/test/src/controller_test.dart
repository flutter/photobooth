import 'package:camera/camera.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCameraPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements CameraPlatform {}

class FakeCameraOptions extends Fake implements CameraOptions {}

void main() {
  const textureId = 1;
  group('CameraController', () {
    late CameraPlatform platform;

    setUpAll(() {
      registerFallbackValue(FakeCameraOptions());
    });

    setUp(() {
      platform = MockCameraPlatform();
      when(() => platform.init()).thenAnswer((_) async => {});
      when(() => platform.create(any())).thenAnswer((_) async => textureId);
      CameraPlatform.instance = platform;
    });

    test('initial state is uninitialized', () {
      final controller = CameraController();
      expect(controller.value.status, equals(CameraStatus.uninitialized));
    });

    group('initialize', () {
      test('initializes textureId', () async {
        final controller = CameraController();
        await controller.initialize();
        expect(controller.textureId, equals(textureId));
      });

      test('initializes camera platform', () async {
        final controller = CameraController();
        verifyNever(() => platform.init());
        await controller.initialize();
        verify(() => platform.init()).called(1);
      });

      test('updates state to available on success', () async {
        final controller = CameraController();
        await controller.initialize();
        expect(controller.value.status, equals(CameraStatus.available));
      });

      test('updates state to unavailable on CameraException', () async {
        const exception = CameraUnknownException();
        when(() => platform.create(any())).thenThrow(exception);
        final controller = CameraController();
        await controller.initialize();
        expect(controller.value.status, equals(CameraStatus.unavailable));
        expect(controller.value.error, equals(exception));
      });

      test('updates state to unavailable on Exception', () async {
        final exception = Exception();
        when(() => platform.create(any())).thenThrow(exception);
        final controller = CameraController();
        await controller.initialize();
        expect(controller.value.status, equals(CameraStatus.unavailable));
        expect(controller.value.error, isA<CameraUnknownException>());
      });
    });

    group('play', () {
      late CameraController controller;

      setUp(() async {
        controller = CameraController();
        await controller.initialize();
      });

      test('invokes CameraPlatform.play', () {
        when(() => platform.play(any())).thenAnswer((_) async => {});
        expect(controller.play(), completes);
        verify(() => platform.play(textureId)).called(1);
      });
    });

    group('stop', () {
      late CameraController controller;

      setUp(() async {
        controller = CameraController();
        await controller.initialize();
      });

      test('invokes CameraPlatform.stop', () {
        when(() => platform.stop(any())).thenAnswer((_) async => {});
        expect(controller.stop(), completes);
        verify(() => platform.stop(textureId)).called(1);
      });
    });

    group('takePicture', () {
      late CameraController controller;

      setUp(() async {
        controller = CameraController();
        await controller.initialize();
      });

      test('invokes CameraPlatform.takePicture', () async {
        const image = CameraImage(data: '', width: 1, height: 1);
        when(() => platform.takePicture(any())).thenAnswer((_) async => image);
        expect(await controller.takePicture(), equals(image));
        verify(() => platform.takePicture(textureId)).called(1);
      });
    });

    group('dispose', () {
      test('invokes CameraPlatform.dispose', () async {
        final controller = CameraController();
        await controller.initialize();
        when(() => platform.dispose(any())).thenAnswer((_) async => {});
        await controller.dispose();
        verify(() => platform.dispose(textureId)).called(1);
        expect(controller.value.status, equals(CameraStatus.uninitialized));
      });
    });
  });
}
