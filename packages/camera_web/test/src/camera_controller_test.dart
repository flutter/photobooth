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

void main() {
  group('CameraController', () {
    group('initialze', () {
      test('completes when uninitialized', () {
        final controller = CameraController();
        expect(controller.initialize(), completes);
      });

      test('throws CameraException when disposed', () async {
        final controller = CameraController();
        await controller.dispose();
        expect(controller.initialize(), throwsA(isA<CameraException>()));
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
        final platform = MockCameraPlatform();
        CameraPlatform.instance = platform;
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
        final platform = MockCameraPlatform();
        CameraPlatform.instance = platform;
        when(() => platform.buildPreview(any())).thenReturn(cameraPreview);
        final controller = CameraController();
        await controller.initialize();
        expect(controller.buildPreview(), equals(cameraPreview));
      });
    });

    group('dispose', () {
      test('completes', () {
        final controller = CameraController();
        expect(controller.dispose(), completes);
      });
    });
  });
}
