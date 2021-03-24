import 'dart:convert';

@TestOn('chrome')
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:camera_web/camera_web.dart';
import 'package:camera_web/src/web_camera.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:mocktail/mocktail.dart';

class MockRegistrar extends Mock implements Registrar {}

class MockWebCamera extends Mock implements WebCamera {}

const cameraId = 0;
const imageData =
    'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('CameraPlugin', () {
    group('registerWith', () {
      test('creates an instance', () {
        CameraPlugin.registerWith(MockRegistrar());
        expect(CameraPlatform.instance, isNotNull);
      });
    });

    group('initializeCamera', () {
      test('returns normally', () {
        CameraPlugin.registerWith(MockRegistrar());
        expect(
          () => CameraPlatform.instance.initializeCamera(cameraId),
          returnsNormally,
        );
      });
    });

    group('initializeCamera', () {
      test('sets the camera instance', () {
        CameraPlugin.registerWith(MockRegistrar());
        expect(
          () => CameraPlatform.instance.initializeCamera(cameraId),
          returnsNormally,
        );
        expect((CameraPlatform.instance as CameraPlugin).camera, isNotNull);
      });
    });

    group('buildPreview', () {
      test('invokes buildPreview on camera instance', () {
        final camera = MockWebCamera();
        const preview = SizedBox();
        when(camera.buildPreview).thenReturn(preview);
        CameraPlugin.registerWith(MockRegistrar());
        (CameraPlatform.instance as CameraPlugin).camera = camera;
        expect(CameraPlatform.instance.buildPreview(cameraId), equals(preview));
        verify(camera.buildPreview).called(1);
      });
    });

    group('dispose', () {
      test('invokes stopPreview on camera instance', () {
        final camera = MockWebCamera();
        when(camera.stopPreview).thenReturn(null);
        CameraPlugin.registerWith(MockRegistrar());
        (CameraPlatform.instance as CameraPlugin).camera = camera;
        expect(CameraPlatform.instance.dispose(cameraId), completes);
        verify(camera.stopPreview).called(1);
      });
    });

    group('takePicture', () {
      test('invokes takePicture on camera instance', () async {
        final camera = MockWebCamera();
        when(camera.takePicture).thenAnswer((_) async => imageData);
        CameraPlugin.registerWith(MockRegistrar());
        (CameraPlatform.instance as CameraPlugin).camera = camera;
        final actualFile = await CameraPlatform.instance.takePicture(cameraId);
        final expectedFile = XFile.fromData(
          base64.decode(imageData.split(',')[1]),
        );
        final actual = await actualFile.readAsBytes();
        final expected = await expectedFile.readAsBytes();
        expect(actual, equals(expected));
        verify(camera.takePicture).called(1);
      });
    });
  });
}
