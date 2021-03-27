import 'dart:html';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

const id = '__cameraId__';

class MockWindow extends Mock implements Window {}

class FakeCameraController extends ValueNotifier<CameraState>
    implements CameraController {
  FakeCameraController(CameraState state) : super(state);

  @override
  String cameraId = id;

  @override
  CameraOptions options = const CameraOptions();

  @override
  void start() {}

  @override
  void stop() {}

  @override
  Future<Uint8List> takePicture() async {
    return Uint8List.fromList([]);
  }

  @override
  Window window = MockWindow();
}

void main() {
  group('Camera', () {
    late CameraController controller;

    setUp(() {
      controller = FakeCameraController(const CameraState.uninitialized());
    });

    group('renders', () {
      testWidgets('default placeholder when uninitialized', (tester) async {
        await tester.pumpWidget(Camera(controller: controller));
        expect(find.byType(SizedBox), findsOneWidget);
      });

      testWidgets('custom placeholder when uninitialized', (tester) async {
        const key = Key('_target_');
        const placeholder = SizedBox(key: key);
        await tester.pumpWidget(Camera(
          controller: controller,
          placeholder: (_) => placeholder,
        ));
        expect(find.byKey(key), findsOneWidget);
      });

      testWidgets('default error when unavailable', (tester) async {
        controller = FakeCameraController(
          const CameraState.unavailable(CameraUnknownException()),
        );

        await tester.pumpWidget(Camera(controller: controller));
        expect(find.byType(SizedBox), findsOneWidget);
      });

      testWidgets('custom error when unavailable', (tester) async {
        controller = FakeCameraController(
          const CameraState.unavailable(CameraUnknownException()),
        );
        const key = Key('_target_');
        const error = SizedBox(key: key);
        await tester.pumpWidget(Camera(
          controller: controller,
          error: (_, __) => error,
        ));
        expect(find.byKey(key), findsOneWidget);
      });

      testWidgets('default preview when available', (tester) async {
        controller = FakeCameraController(const CameraState.available());
        await tester.pumpWidget(Camera(controller: controller));
        expect(find.byType(HtmlElementView), findsOneWidget);
      });

      testWidgets('custom preview when available', (tester) async {
        controller = FakeCameraController(const CameraState.available());
        const key = Key('_target_');
        await tester.pumpWidget(Camera(
          controller: controller,
          preview: (_, preview) => Container(key: key, child: preview),
        ));
        expect(find.byKey(key), findsOneWidget);
        expect(find.byType(HtmlElementView), findsOneWidget);
      });
    });
  });
}
