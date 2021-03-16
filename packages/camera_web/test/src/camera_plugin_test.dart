@TestOn('chrome')

import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:camera_web/camera_web.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:mocktail/mocktail.dart';

class MockRegistrar extends Mock implements Registrar {}

void main() {
  group('CameraPlugin', () {
    group('registerWith', () {
      test('creates an instance', () {
        CameraPlugin.registerWith(MockRegistrar());
        expect(CameraPlatform.instance, isNotNull);
      });
    });
  });
}
