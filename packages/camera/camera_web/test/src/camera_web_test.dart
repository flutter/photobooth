@TestOn('chrome')

import 'dart:html';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:camera_web/camera_web.dart';
import 'package:flutter/widgets.dart' show Widget;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWindow extends Mock implements Window {}

class MockNavigator extends Mock implements Navigator {}

class MockMediaDevices extends Mock implements MediaDevices {}

void main() {
  group('Camera', () {
    late int textureId;
    late Window window;
    late Navigator navigator;
    late MediaDevices mediaDevices;
    late VideoElement videoElement;

    setUp(() async {
      window = MockWindow();
      navigator = MockNavigator();
      mediaDevices = MockMediaDevices();
      videoElement = VideoElement()
        ..src = 'https://www.w3schools.com/tags/mov_bbb.mp4'
        ..preload = 'true'
        ..width = 10
        ..height = 10;
      when(() => window.navigator).thenReturn(navigator);
      when(() => navigator.mediaDevices).thenReturn(mediaDevices);
      when(
        () => mediaDevices.getUserMedia(any()),
      ).thenAnswer((_) async => videoElement.captureStream());
      CameraPlatform.instance = CameraPlugin()..window = window;
      textureId = await CameraPlatform.instance.create(const CameraOptions());
    });

    testWidgets('$CameraPlugin is the live instance', (tester) async {
      expect(CameraPlatform.instance, isA<CameraPlugin>());
    });

    test('can init', () {
      expect(CameraPlatform.instance.init(), completes);
    });

    test('can dispose', () {
      expect(CameraPlatform.instance.dispose(textureId), completes);
    });

    test('can play', () async {
      expect(CameraPlatform.instance.play(textureId), completes);
    });

    test('can stop', () async {
      expect(CameraPlatform.instance.stop(textureId), completes);
    });

    test('can takePicture', () async {
      await CameraPlatform.instance.play(textureId);
      expect(CameraPlatform.instance.takePicture(textureId), completes);
    });

    test('can build view', () {
      expect(
        CameraPlatform.instance.buildView(textureId),
        isInstanceOf<Widget>(),
      );
    });

    test('can getMediaDevices', () {
      expect(CameraPlatform.instance.getMediaDevices(), completes);
    });

    test('can getDefaultDeviceId', () {
      expect(CameraPlatform.instance.getDefaultDeviceId(), completes);
    });
  });
}
