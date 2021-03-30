import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/preview/preview.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockCameraPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements CameraPlatform {}

class FakeCameraOptions extends Fake implements CameraOptions {}

class MockCameraController extends Mock implements CameraController {}

void main() {
  const cameraId = 1;
  group('PhotoboothPage', () {
    late CameraPlatform platform;

    setUpAll(() {
      registerFallbackValue<CameraOptions>(FakeCameraOptions());
    });

    setUp(() {
      platform = MockCameraPlatform();
      CameraPlatform.instance = platform;
      when(() => platform.init()).thenAnswer((_) async => {});
      when(() => platform.create(any())).thenAnswer((_) async => cameraId);
      when(() => platform.play(any())).thenAnswer((_) async => {});
      when(() => platform.dispose(any())).thenAnswer((_) async => {});
    });

    test('is routable', () {
      expect(PhotoboothPage.route(), isA<MaterialPageRoute>());
    });

    testWidgets('renders PhotoboothView', (tester) async {
      await tester.pumpApp(const PhotoboothPage());
      expect(find.byType(PhotoboothView), findsOneWidget);
    });
  });

  group('PhotoboothView', () {
    late CameraPlatform platform;
    late CameraController controller;

    setUp(() {
      platform = MockCameraPlatform();
      CameraPlatform.instance = platform;
      controller = MockCameraController();
    });

    testWidgets('renders placholder when initializing', (tester) async {
      when(() => controller.value).thenReturn(
        const CameraState.uninitialized(),
      );
      await tester.pumpApp(PhotoboothView(controller: controller));
      expect(find.byType(PhotoboothPlaceholder), findsOneWidget);
    });

    testWidgets('renders error when unavailable', (tester) async {
      when(() => controller.value).thenReturn(
        const CameraState.unavailable(CameraUnknownException()),
      );
      await tester.pumpApp(PhotoboothView(controller: controller));
      expect(find.byType(PhotoboothError), findsOneWidget);
    });

    testWidgets('renders preview when available', (tester) async {
      const key = Key('__target__');
      const preview = SizedBox(key: key);
      when(() => platform.buildView(cameraId)).thenReturn(preview);
      when(() => controller.value).thenReturn(const CameraState.available());
      when(() => controller.textureId).thenReturn(cameraId);

      await tester.pumpApp(PhotoboothView(controller: controller));

      expect(find.byType(PhotoboothPreview), findsOneWidget);
      expect(find.byKey(key), findsOneWidget);
    });

    testWidgets('navigates to PreviewPage photo is taken', (tester) async {
      const key = Key('__target__');
      const preview = SizedBox(key: key);
      final image = CameraImage(
        data: Uint8List.fromList([]),
        width: 1,
        height: 1,
      );
      when(() => platform.buildView(cameraId)).thenReturn(preview);
      when(() => controller.value).thenReturn(const CameraState.available());
      when(() => controller.textureId).thenReturn(cameraId);
      when(() => controller.takePicture()).thenAnswer((_) async => image);
      when(() => controller.play()).thenAnswer((_) async => {});
      when(() => controller.stop()).thenAnswer((_) async => {});

      await tester.pumpApp(PhotoboothView(controller: controller));

      expect(find.byType(PhotoboothPreview), findsOneWidget);
      expect(find.byKey(key), findsOneWidget);

      await tester.tap(
        find.byKey(const Key('photoboothPreview_photo_floatingActionButton')),
      );

      await tester.pumpAndSettle();
      final previewPage = tester.widget<PreviewPage>(find.byType(PreviewPage));
      expect(previewPage.image, equals(image));

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.byType(PhotoboothPreview), findsOneWidget);
    });
  });
}
