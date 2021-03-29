import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCameraController extends Mock implements CameraController {}

class MockCameraPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements CameraPlatform {}

void main() {
  group('Camera', () {
    late CameraPlatform platform;
    late CameraController controller;

    setUp(() {
      platform = MockCameraPlatform();
      CameraPlatform.instance = platform;
      controller = MockCameraController();
      when(() => platform.init()).thenAnswer((_) async {});
    });

    testWidgets('renders placeholder', (tester) async {
      when(() => controller.value).thenReturn(CameraState.uninitialized());
      const key = Key('__target__');
      const widget = SizedBox(key: key);
      await tester.pumpWidget(
        Camera(controller: controller, placeholder: (_) => widget),
      );
      expect(find.byKey(key), findsOneWidget);
    });

    testWidgets('renders error', (tester) async {
      when(() => controller.value).thenReturn(
        CameraState.unavailable(CameraUnknownException()),
      );
      const key = Key('__target__');
      const widget = SizedBox(key: key);
      await tester.pumpWidget(
        Camera(controller: controller, error: (_, __) => widget),
      );
      expect(find.byKey(key), findsOneWidget);
    });

    testWidgets('renders preview', (tester) async {
      const key = Key('__target__');
      const widget = SizedBox(key: key);
      const textureId = 0;
      when(() => controller.textureId).thenReturn(textureId);
      when(() => controller.value).thenReturn(CameraState.available());
      when(() => platform.buildView(textureId)).thenReturn(widget);
      await tester.pumpWidget(
        Camera(controller: controller, preview: (_, preview) => preview),
      );
      expect(find.byKey(key), findsOneWidget);
    });
  });
}
