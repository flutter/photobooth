@TestOn('chrome')
import 'dart:html';

import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:camera_web/src/web_camera.dart';
import 'package:flutter/widgets.dart' show HtmlElementView, SizedBox;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWindow extends Mock implements Window {}

class MockDocument extends Mock implements Document {}

class MockNavigator extends Mock implements Navigator {}

class MockMediaDevices extends Mock implements MediaDevices {}

class MockMediaStream extends Mock implements MediaStream {}

const cameraId = 0;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('WebCamera', () {
    late Window window;
    late WebCamera camera;

    setUp(() {
      window = MockWindow();
      camera = WebCamera(cameraId, window: window);
    });

    test('can be initialized without a window', () {
      expect(() => WebCamera(cameraId), returnsNormally);
    });

    test('can be initialized with a custom window', () {
      expect(() => WebCamera(cameraId, window: window), returnsNormally);
    });

    group('isSupported', () {
      test('returns true when navigator has mediaDevices', () {
        final navigator = MockNavigator();
        final mediaDevices = MockMediaDevices();
        when(() => window.navigator).thenReturn(navigator);
        when(() => navigator.mediaDevices).thenReturn(mediaDevices);
        expect(camera.isSupported, isTrue);
      });

      test('returns false when navigator does not have mediaDevices', () {
        final navigator = MockNavigator();
        when(() => window.navigator).thenReturn(navigator);
        when(() => navigator.mediaDevices).thenReturn(null);
        expect(camera.isSupported, isFalse);
      });
    });

    group('getPreview', () {
      test('throws UnsupportedError when camera is not supported', () {
        final navigator = MockNavigator();
        when(() => window.navigator).thenReturn(navigator);
        when(() => navigator.mediaDevices).thenReturn(null);
        expect(
          () async => await camera.getPreview(),
          throwsA(isA<UnsupportedError>()),
        );
      });

      test('returns getUserMedia when camera is supported', () async {
        final navigator = MockNavigator();
        final mediaDevices = MockMediaDevices();
        final mediaStream = MockMediaStream();
        when(() => window.navigator).thenReturn(navigator);
        when(() => navigator.mediaDevices).thenReturn(mediaDevices);
        when(
          () => mediaDevices.getUserMedia(any()),
        ).thenAnswer((_) async => mediaStream);
        expect(await camera.getPreview(), equals(mediaStream));
        verify(() => mediaDevices.getUserMedia({'video': true})).called(1);
      });
    });

    group('buildPreview', () {
      test('returns SizedBox when camera is not supported', () {
        final navigator = MockNavigator();
        when(() => window.navigator).thenReturn(navigator);
        when(() => navigator.mediaDevices).thenReturn(null);
        expect(camera.buildPreview(), isA<SizedBox>());
      });

      test('returns HtmlElementView when camera is supported', () async {
        final navigator = MockNavigator();
        final mediaDevices = MockMediaDevices();
        when(() => window.navigator).thenReturn(navigator);
        when(() => navigator.mediaDevices).thenReturn(mediaDevices);
        when(
          () => mediaDevices.getUserMedia(any()),
        ).thenAnswer((_) async => MediaStream());
        final dynamic preview = camera.buildPreview();
        expect(preview.child, isA<HtmlElementView>());
      });
    });

    group('stopPreview', () {
      test('returns normally', () {
        expect(() => camera.stopPreview(), returnsNormally);
      });
    });

    group('takePicture', () {
      test('returns dataUrl', () async {
        final navigator = MockNavigator();
        final mediaDevices = MockMediaDevices();
        when(() => window.navigator).thenReturn(navigator);
        when(() => navigator.mediaDevices).thenReturn(mediaDevices);
        when(
          () => mediaDevices.getUserMedia(any()),
        ).thenAnswer((_) async => MediaStream());
        camera.buildPreview();
        final imageData = await camera.takePicture();
        expect(imageData, isNotNull);
      });
    });

    group('availableCameras', () {
      test('returns empty list if camera is not supported', () async {
        final navigator = MockNavigator();
        when(() => window.navigator).thenReturn(navigator);
        when(() => navigator.mediaDevices).thenReturn(null);
        expect(await camera.availableCameras(), isEmpty);
      });

      test('returns only supported devices when camera is supported', () async {
        final navigator = MockNavigator();
        final mediaDevices = MockMediaDevices();
        final devices = [
          {
            'kind': 'audioinput',
            'label': 'audio0',
          },
          {
            'kind': 'videoinput',
            'label': 'video0',
          },
          {
            'kind': 'videoinput',
            'label': 'video1',
          }
        ];
        when(() => window.navigator).thenReturn(navigator);
        when(() => navigator.mediaDevices).thenReturn(mediaDevices);
        when(mediaDevices.enumerateDevices).thenAnswer((_) async => devices);
        expect(
          await camera.availableCameras(),
          equals([
            CameraDescription(
              name: 'video0',
              lensDirection: CameraLensDirection.front,
              sensorOrientation: 0,
            ),
            CameraDescription(
              name: 'video1',
              lensDirection: CameraLensDirection.front,
              sensorOrientation: 0,
            )
          ]),
        );
      });
    });
  });
}
