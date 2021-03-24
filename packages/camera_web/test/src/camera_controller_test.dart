// ignore_for_file: unnecessary_lambdas

@TestOn('chrome')
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:camera_web/camera_web.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCameraPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements CameraPlatform {}

class MockXFile extends Mock implements XFile {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('CameraController', () {
    late CameraPlatform platform;

    setUp(() {
      platform = MockCameraPlatform();
      CameraPlatform.instance = platform;

      when(() => platform.initializeCamera(any())).thenAnswer((_) async {});
      when(() => platform.dispose(any())).thenAnswer((_) async {});
    });

    group('initialze', () {
      test('completes when uninitialized', () {
        final controller = CameraController();
        expect(controller.initialize(), completes);
        verify(() => platform.initializeCamera(any())).called(1);
      });

      test('throws CameraException when disposed', () async {
        final controller = CameraController();
        await controller.dispose();
        expect(controller.initialize(), throwsA(isA<CameraException>()));
        verifyNever(() => platform.initializeCamera(any()));
      });
    });

    group('buildPreview', () {
      test('throws CameraException when not uninitialized', () {
        final controller = CameraController();
        expect(
          () => controller.buildPreview(),
          throwsA(isA<CameraException>()),
        );
      });

      test('throws CameraException when disposed', () async {
        final controller = CameraController();
        await controller.dispose();
        expect(
          () => controller.buildPreview(),
          throwsA(isA<CameraException>()),
        );
      });

      test('throws CameraException when PlatformException is thrown', () async {
        when(() => platform.buildPreview(any())).thenThrow(
          PlatformException(code: ''),
        );
        final controller = CameraController();
        await controller.initialize();
        expect(
          () => controller.buildPreview(),
          throwsA(isA<CameraException>()),
        );
      });

      test('returns CameraPreview when controller is initialized', () async {
        const cameraPreview = SizedBox();
        when(() => platform.buildPreview(any())).thenReturn(cameraPreview);
        final controller = CameraController();
        await controller.initialize();
        expect(controller.buildPreview(), equals(cameraPreview));
        verify(() => platform.buildPreview(any())).called(1);
      });
    });

    group('takePicture', () {
      test('throws CameraException when not uninitialized', () {
        final controller = CameraController();
        expect(
          () => controller.takePicture(),
          throwsA(isA<CameraException>()),
        );
      });

      test('throws CameraException when disposed', () async {
        final controller = CameraController();
        await controller.dispose();
        expect(
          () => controller.takePicture(),
          throwsA(isA<CameraException>()),
        );
      });

      test('throws CameraException when PlatformException is thrown', () async {
        when(() => platform.takePicture(any())).thenThrow(
          PlatformException(code: ''),
        );
        final controller = CameraController();
        await controller.initialize();
        expect(
          () => controller.takePicture(),
          throwsA(isA<CameraException>()),
        );
      });

      test('returns XFile when controller is initialized', () async {
        final file = MockXFile();
        when(() => platform.takePicture(any())).thenAnswer((_) async => file);
        final controller = CameraController();
        await controller.initialize();
        expect(await controller.takePicture(), equals(file));
        verify(() => platform.takePicture(any())).called(1);
      });
    });

    group('dispose', () {
      test('completes', () {
        final controller = CameraController();
        expect(controller.dispose(), completes);
        verify(() => platform.dispose(any())).called(1);
      });
    });
  });
}
