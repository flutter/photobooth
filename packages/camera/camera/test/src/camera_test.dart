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

    testWidgets('renders placeholder (default)', (tester) async {
      when(() => controller.value).thenReturn(
        const CameraState.uninitialized(),
      );
      await tester.pumpWidget(Camera(controller: controller));
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('renders placeholder (custom)', (tester) async {
      when(() => controller.value).thenReturn(
        const CameraState.uninitialized(),
      );
      const key = Key('__target__');
      const widget = SizedBox(key: key);
      await tester.pumpWidget(
        Camera(controller: controller, placeholder: (_) => widget),
      );
      expect(find.byKey(key), findsOneWidget);
    });

    testWidgets('renders error (default)', (tester) async {
      when(() => controller.value).thenReturn(
        const CameraState.unavailable(CameraUnknownException()),
      );
      await tester.pumpWidget(Camera(controller: controller));
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('renders error (custom)', (tester) async {
      when(() => controller.value).thenReturn(
        const CameraState.unavailable(CameraUnknownException()),
      );
      const key = Key('__target__');
      const widget = SizedBox(key: key);
      await tester.pumpWidget(
        Camera(controller: controller, error: (_, __) => widget),
      );
      expect(find.byKey(key), findsOneWidget);
    });

    testWidgets('renders preview (default)', (tester) async {
      const key = Key('__target__');
      const widget = SizedBox(key: key);
      const textureId = 0;
      when(() => controller.textureId).thenReturn(textureId);
      when(() => controller.value).thenReturn(const CameraState.available());
      when(() => platform.buildView(textureId)).thenReturn(widget);
      await tester.pumpWidget(Camera(controller: controller));
      expect(find.byKey(key), findsOneWidget);
    });

    testWidgets('renders preview (custom)', (tester) async {
      const key = Key('__target__');
      const previewKey = Key('__preview__');
      const preview = SizedBox(key: previewKey);
      const textureId = 0;
      when(() => controller.textureId).thenReturn(textureId);
      when(() => controller.value).thenReturn(const CameraState.available());
      when(() => platform.buildView(textureId)).thenReturn(preview);
      await tester.pumpWidget(
        Camera(
          controller: controller,
          preview: (_, preview) => SizedBox(key: key, child: preview),
        ),
      );
      expect(find.byKey(key), findsOneWidget);
      expect(find.byKey(previewKey), findsOneWidget);
    });
  });
}
