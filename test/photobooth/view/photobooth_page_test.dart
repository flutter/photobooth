import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/preview/preview.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tensorflow_models/tensorflow_models.dart' as tf_models;

import '../../helpers/helpers.dart';

class MockCameraPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements CameraPlatform {}

class MockTensorflowModelsPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements tf_models.TensorflowModelsPlatform {}

class FakeCameraOptions extends Fake implements CameraOptions {}

class MockImage extends Mock implements ui.Image {}

class MockPoseNet extends Mock implements tf_models.PoseNet {}

class MockPose extends Mock implements tf_models.Pose {}

class FakeModelConfig extends Fake implements tf_models.ModelConfig {}

class FakeImageData extends Fake implements tf_models.ImageData {}

class FakeSinglePersonInterfaceConfig extends Fake
    implements tf_models.SinglePersonInterfaceConfig {}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await Assets.load();

  const cameraId = 1;

  setUpAll(() {
    registerFallbackValue<CameraOptions>(FakeCameraOptions());
    registerFallbackValue<tf_models.ModelConfig>(FakeModelConfig());
    registerFallbackValue<tf_models.ImageData>(FakeImageData());
    registerFallbackValue<tf_models.SinglePersonInterfaceConfig>(
      FakeSinglePersonInterfaceConfig(),
    );
  });

  group('PhotoboothPage', () {
    late CameraPlatform cameraPlatform;
    late tf_models.TensorflowModelsPlatform tensorflowModelsPlatform;
    late tf_models.PoseNet posenet;

    setUp(() {
      cameraPlatform = MockCameraPlatform();
      CameraPlatform.instance = cameraPlatform;
      when(() => cameraPlatform.init()).thenAnswer((_) async => {});
      when(
        () => cameraPlatform.create(any()),
      ).thenAnswer((_) async => cameraId);
      when(() => cameraPlatform.play(any())).thenAnswer((_) async => {});
      when(() => cameraPlatform.stop(any())).thenAnswer((_) async => {});
      when(
        () => cameraPlatform.imageStream(any()),
      ).thenAnswer((_) => const Stream<CameraImage>.empty());
      when(() => cameraPlatform.dispose(any())).thenAnswer((_) async => {});

      posenet = MockPoseNet();
      tensorflowModelsPlatform = MockTensorflowModelsPlatform();
      tf_models.TensorflowModelsPlatform.instance = tensorflowModelsPlatform;
      when(
        () => tensorflowModelsPlatform.loadPosenet(any()),
      ).thenAnswer((_) async => posenet);
    });

    test('is routable', () {
      expect(PhotoboothPage.route(), isA<MaterialPageRoute>());
    });

    testWidgets('renders Camera', (tester) async {
      await tester.pumpApp(const PhotoboothPage());
      expect(find.byType(Camera), findsOneWidget);
    });

    testWidgets('renders placholder when initializing', (tester) async {
      await tester.pumpApp(const PhotoboothPage());
      expect(find.byType(PhotoboothPlaceholder), findsOneWidget);
    });

    testWidgets('renders error when unavailable', (tester) async {
      when(
        () => cameraPlatform.create(any()),
      ).thenThrow(const CameraUnknownException());
      await tester.pumpApp(const PhotoboothPage());
      await tester.pumpAndSettle();
      expect(find.byType(PhotoboothError), findsOneWidget);
    });

    testWidgets('renders error when not allowed', (tester) async {
      when(
        () => cameraPlatform.create(any()),
      ).thenThrow(const CameraNotAllowedException());
      await tester.pumpApp(const PhotoboothPage());
      await tester.pumpAndSettle();
      expect(find.byType(PhotoboothError), findsOneWidget);
    });

    testWidgets('renders preview when available', (tester) async {
      const key = Key('__target__');
      const preview = SizedBox(key: key);
      when(() => cameraPlatform.buildView(cameraId)).thenReturn(preview);

      await tester.pumpApp(const PhotoboothPage());
      await tester.pumpAndSettle();

      expect(find.byType(PhotoboothPreview), findsOneWidget);
      expect(find.byKey(key), findsOneWidget);
    });

    testWidgets('renders dash, sparky, and android buttons', (tester) async {
      const key = Key('__target__');
      const preview = SizedBox(key: key);
      when(() => cameraPlatform.buildView(cameraId)).thenReturn(preview);

      await tester.pumpApp(const PhotoboothPage());
      await tester.pumpAndSettle();

      expect(find.byType(CharacterIconButton), findsNWidgets(3));
    });

    testWidgets('renders dash in preview when poses are detected',
        (tester) async {
      const key = Key('__target__');
      const preview = SizedBox(key: key);
      const width = 1;
      const height = 1;
      const keypoint = tf_models.Keypoint(
        part: 'leftShoulder',
        score: 0.5,
        position: tf_models.Vector2D(x: 0, y: 0),
      );
      final data = Uint8List.fromList([]);
      final pose = MockPose();
      final image = CameraImage(
        height: height,
        width: width,
        raw: ImageData(width: width, height: height, data: data),
        thumbnail: ImageData(width: width, height: height, data: data),
      );
      when(() => cameraPlatform.buildView(cameraId)).thenReturn(preview);
      when(() => cameraPlatform.imageStream(cameraId))
          .thenAnswer((_) => Stream.value(image));
      when(
        () => posenet.estimateSinglePose(any(), config: any(named: 'config')),
      ).thenAnswer((_) async => pose);
      when(() => pose.score).thenReturn(0.5);
      when(() => pose.keypoints).thenReturn([keypoint]);

      await tester.runAsync(() async {
        await tester.pumpApp(const PhotoboothPage(enablePoseDetection: true));
        await untilCalled(() => cameraPlatform.imageStream(cameraId));
        await tester.pumpAndSettle();
        await tester.pump();
        expect(
          find.byKey(const Key('photoboothView_posePainter_customPainter')),
          findsOneWidget,
        );
      });
    });

    testWidgets('navigates to PreviewPage photo is taken', (tester) async {
      const key = Key('__target__');
      const preview = SizedBox(key: key);
      const keypoint = tf_models.Keypoint(
        part: 'leftShoulder',
        score: 0.9,
        position: tf_models.Vector2D(x: 0, y: 0),
      );
      final pose = MockPose();
      final image = CameraImage(
        raw: ImageData(
          data: Uint8List.fromList(transparentImage),
          width: 4,
          height: 4,
        ),
        thumbnail: ImageData(
          data: Uint8List.fromList(transparentImage),
          width: 4,
          height: 4,
        ),
        width: 4,
        height: 4,
      );
      when(() => cameraPlatform.buildView(cameraId)).thenReturn(preview);
      when(() => cameraPlatform.imageStream(cameraId))
          .thenAnswer((_) => Stream.value(image));
      when(
        () => cameraPlatform.takePicture(cameraId),
      ).thenAnswer((_) async => image);
      when(
        () => posenet.estimateSinglePose(any(), config: any(named: 'config')),
      ).thenAnswer((_) async => pose);
      when(() => pose.score).thenReturn(0.9);
      when(() => pose.keypoints).thenReturn([keypoint]);

      await tester.runAsync(() async {
        await tester.pumpApp(const PhotoboothPage(enablePoseDetection: true));
        await untilCalled(() => cameraPlatform.imageStream(cameraId));
        await tester.pumpAndSettle();
        await tester.pump();
        expect(
          find.byKey(const Key('photoboothView_posePainter_customPainter')),
          findsOneWidget,
        );
      });

      await tester.tap(
        find.byKey(const Key('photoboothPreview_photo_floatingActionButton')),
      );

      await tester.pumpAndSettle();
      final previewPage = tester.widget<PreviewPage>(find.byType(PreviewPage));
      expect(previewPage.image, isNotNull);

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.byType(PhotoboothPreview), findsOneWidget);
    });
  });

  group('PosePainter', () {
    test('should not repaint if image and pose are the same', () {
      final pose = MockPose();
      final image = MockImage();

      when(() => pose.score).thenReturn(0);

      final painterA = PosePainter(pose: pose, image: image);
      final painterB = PosePainter(pose: pose, image: image);

      expect(painterA.shouldRepaint(painterB), isFalse);
    });

    test('should repaint if image changes', () {
      final pose = MockPose();
      final imageA = MockImage();
      final imageB = MockImage();

      when(() => pose.score).thenReturn(0);

      final painterA = PosePainter(pose: pose, image: imageA);
      final painterB = PosePainter(pose: pose, image: imageB);

      expect(painterA.shouldRepaint(painterB), isTrue);
    });

    test('should repaint if pose score changes', () {
      final poseA = MockPose();
      final poseB = MockPose();
      final image = MockImage();

      when(() => poseA.score).thenReturn(0);
      when(() => poseB.score).thenReturn(0.5);

      final painterA = PosePainter(pose: poseA, image: image);
      final painterB = PosePainter(pose: poseB, image: image);

      expect(painterA.shouldRepaint(painterB), isTrue);
    });
  });
}
