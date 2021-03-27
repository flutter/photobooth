import 'dart:html';

import 'package:camera/camera.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWindow extends Mock implements Window {}

class MockNavigator extends Mock implements Navigator {}

class MockMediaDevices extends Mock implements MediaDevices {}

class MockMediaStream extends Mock implements MediaStream {}

class MockDomException extends Mock implements DomException {}

void main() {
  group('CameraController', () {
    test('initial state is uninitialized', () {
      final controller = CameraController();
      expect(controller.value, equals(const CameraState.uninitialized()));
    });

    group('start', () {
      test('state is unavailable when camera is not supported', () {
        final window = MockWindow();
        final navigator = MockNavigator();
        when(() => window.navigator).thenReturn(navigator);
        when(() => navigator.mediaDevices).thenReturn(null);

        final controller = CameraController(window: window)..start();

        expect(
          controller.value,
          equals(const CameraState.unavailable(CameraNotSupportedException())),
        );
      });

      test(
          'state is unavailable (not found) when '
          'NotFoundError occurs.', () {
        final window = MockWindow();
        final navigator = MockNavigator();
        final mediaDevices = MockMediaDevices();
        final exception = MockDomException();
        when(() => exception.name).thenReturn('NotFoundError');
        when(() => window.navigator).thenReturn(navigator);
        when(() => navigator.mediaDevices).thenReturn(mediaDevices);
        when(() => mediaDevices.getUserMedia(any())).thenThrow(exception);

        final controller = CameraController(window: window)..start();

        final state = controller.value;
        expect(state.status, equals(CameraStatus.unavailable));
        expect(state.error, isA<CameraNotFoundException>());
      });

      test(
          'state is unavailable (not found) '
          'when DevicesNotFoundError occurs.', () {
        final window = MockWindow();
        final navigator = MockNavigator();
        final mediaDevices = MockMediaDevices();
        final exception = MockDomException();
        when(() => exception.name).thenReturn('DevicesNotFoundError');
        when(() => window.navigator).thenReturn(navigator);
        when(() => navigator.mediaDevices).thenReturn(mediaDevices);
        when(() => mediaDevices.getUserMedia(any())).thenThrow(exception);

        final controller = CameraController(window: window)..start();

        final state = controller.value;
        expect(state.status, equals(CameraStatus.unavailable));
        expect(state.error, isA<CameraNotFoundException>());
      });

      test(
          'state is unavailable (not readable) '
          'when NotReadableError occurs.', () {
        final window = MockWindow();
        final navigator = MockNavigator();
        final mediaDevices = MockMediaDevices();
        final exception = MockDomException();
        when(() => exception.name).thenReturn('NotReadableError');
        when(() => window.navigator).thenReturn(navigator);
        when(() => navigator.mediaDevices).thenReturn(mediaDevices);
        when(() => mediaDevices.getUserMedia(any())).thenThrow(exception);

        final controller = CameraController(window: window)..start();

        final state = controller.value;
        expect(state.status, equals(CameraStatus.unavailable));
        expect(state.error, isA<CameraNotReadableException>());
      });

      test(
          'state is unavailable (not readable) '
          'when TrackStartError occurs.', () {
        final window = MockWindow();
        final navigator = MockNavigator();
        final mediaDevices = MockMediaDevices();
        final exception = MockDomException();
        when(() => exception.name).thenReturn('TrackStartError');
        when(() => window.navigator).thenReturn(navigator);
        when(() => navigator.mediaDevices).thenReturn(mediaDevices);
        when(() => mediaDevices.getUserMedia(any())).thenThrow(exception);

        final controller = CameraController(window: window)..start();

        final state = controller.value;
        expect(state.status, equals(CameraStatus.unavailable));
        expect(state.error, isA<CameraNotReadableException>());
      });

      test(
          'state is unavailable (overconstrained) '
          'when OverconstrainedError occurs.', () {
        final window = MockWindow();
        final navigator = MockNavigator();
        final mediaDevices = MockMediaDevices();
        final exception = MockDomException();
        when(() => exception.name).thenReturn('OverconstrainedError');
        when(() => window.navigator).thenReturn(navigator);
        when(() => navigator.mediaDevices).thenReturn(mediaDevices);
        when(() => mediaDevices.getUserMedia(any())).thenThrow(exception);

        final controller = CameraController(window: window)..start();

        final state = controller.value;
        expect(state.status, equals(CameraStatus.unavailable));
        expect(state.error, isA<CameraOverconstrainedException>());
      });

      test(
          'state is unavailable (overconstrained) '
          'when ConstraintNotSatisfiedError occurs.', () {
        final window = MockWindow();
        final navigator = MockNavigator();
        final mediaDevices = MockMediaDevices();
        final exception = MockDomException();
        when(() => exception.name).thenReturn('ConstraintNotSatisfiedError');
        when(() => window.navigator).thenReturn(navigator);
        when(() => navigator.mediaDevices).thenReturn(mediaDevices);
        when(() => mediaDevices.getUserMedia(any())).thenThrow(exception);

        final controller = CameraController(window: window)..start();

        final state = controller.value;
        expect(state.status, equals(CameraStatus.unavailable));
        expect(state.error, isA<CameraOverconstrainedException>());
      });

      test(
          'state is unavailable (not allowed) '
          'when NotAllowedError occurs.', () {
        final window = MockWindow();
        final navigator = MockNavigator();
        final mediaDevices = MockMediaDevices();
        final exception = MockDomException();
        when(() => exception.name).thenReturn('NotAllowedError');
        when(() => window.navigator).thenReturn(navigator);
        when(() => navigator.mediaDevices).thenReturn(mediaDevices);
        when(() => mediaDevices.getUserMedia(any())).thenThrow(exception);

        final controller = CameraController(window: window)..start();

        final state = controller.value;
        expect(state.status, equals(CameraStatus.unavailable));
        expect(state.error, isA<CameraNotAllowedException>());
      });

      test(
          'state is unavailable (not allowed) '
          'when PermissionDeniedError occurs.', () {
        final window = MockWindow();
        final navigator = MockNavigator();
        final mediaDevices = MockMediaDevices();
        final exception = MockDomException();
        when(() => exception.name).thenReturn('PermissionDeniedError');
        when(() => window.navigator).thenReturn(navigator);
        when(() => navigator.mediaDevices).thenReturn(mediaDevices);
        when(() => mediaDevices.getUserMedia(any())).thenThrow(exception);

        final controller = CameraController(window: window)..start();

        final state = controller.value;
        expect(state.status, equals(CameraStatus.unavailable));
        expect(state.error, isA<CameraNotAllowedException>());
      });

      test(
          'state is unavailable (type error) '
          'when TypeError occurs.', () {
        final window = MockWindow();
        final navigator = MockNavigator();
        final mediaDevices = MockMediaDevices();
        final exception = MockDomException();
        when(() => exception.name).thenReturn('TypeError');
        when(() => window.navigator).thenReturn(navigator);
        when(() => navigator.mediaDevices).thenReturn(mediaDevices);
        when(() => mediaDevices.getUserMedia(any())).thenThrow(exception);

        final controller = CameraController(window: window)..start();

        final state = controller.value;
        expect(state.status, equals(CameraStatus.unavailable));
        expect(state.error, isA<CameraTypeException>());
      });

      test(
          'state is unavailable (unknown error) '
          'when other DomException occurs.', () {
        final window = MockWindow();
        final navigator = MockNavigator();
        final mediaDevices = MockMediaDevices();
        final exception = MockDomException();
        when(() => exception.name).thenReturn('garbage');
        when(() => window.navigator).thenReturn(navigator);
        when(() => navigator.mediaDevices).thenReturn(mediaDevices);
        when(() => mediaDevices.getUserMedia(any())).thenThrow(exception);

        final controller = CameraController(window: window)..start();

        final state = controller.value;
        expect(state.status, equals(CameraStatus.unavailable));
        expect(state.error, isA<CameraUnknownException>());
      });

      test(
          'state is unavailable (unknown) '
          'when unrecognized error occurs.', () {
        final window = MockWindow();
        final navigator = MockNavigator();
        final mediaDevices = MockMediaDevices();
        final exception = Exception();
        when(() => window.navigator).thenReturn(navigator);
        when(() => navigator.mediaDevices).thenReturn(mediaDevices);
        when(() => mediaDevices.getUserMedia(any())).thenThrow(exception);

        final controller = CameraController(window: window)..start();

        final state = controller.value;
        expect(state.status, equals(CameraStatus.unavailable));
        expect(state.error, isA<CameraUnknownException>());
      });

      test('throws StateError when called multiple times', () {
        final window = MockWindow();
        final navigator = MockNavigator();
        when(() => window.navigator).thenReturn(navigator);
        when(() => navigator.mediaDevices).thenReturn(null);

        final controller = CameraController(window: window)..start();

        expect(
          controller.value,
          equals(const CameraState.unavailable(CameraNotSupportedException())),
        );
        expect(controller.start, throwsStateError);
      });

      test('state is available when stream is created successfully', () async {
        final window = MockWindow();
        final navigator = MockNavigator();
        final mediaDevices = MockMediaDevices();
        final mediaStream = MediaStream();
        when(() => window.navigator).thenReturn(navigator);
        when(() => navigator.mediaDevices).thenReturn(mediaDevices);
        when(
          () => mediaDevices.getUserMedia(any()),
        ).thenAnswer((_) async => mediaStream);

        final controller = CameraController(window: window)..start();
        await untilCalled(() => mediaDevices.getUserMedia(any()));
        expect(controller.value, equals(const CameraState.available()));
      });
    });

    group('stop', () {
      test('resets state to uninitialized', () async {
        final window = MockWindow();
        final navigator = MockNavigator();
        final mediaDevices = MockMediaDevices();
        final mediaStream = MediaStream();
        when(() => window.navigator).thenReturn(navigator);
        when(() => navigator.mediaDevices).thenReturn(mediaDevices);
        when(
          () => mediaDevices.getUserMedia(any()),
        ).thenAnswer((_) async => mediaStream);

        final controller = CameraController(window: window)..start();
        await untilCalled(() => mediaDevices.getUserMedia(any()));
        expect(controller.value, equals(const CameraState.available()));

        controller.stop();

        expect(controller.value, equals(const CameraState.uninitialized()));
      });
    });

    group('dispose', () {
      test('resets state to uninitialized', () async {
        final window = MockWindow();
        final navigator = MockNavigator();
        final mediaDevices = MockMediaDevices();
        final mediaStream = MediaStream();
        when(() => window.navigator).thenReturn(navigator);
        when(() => navigator.mediaDevices).thenReturn(mediaDevices);
        when(
          () => mediaDevices.getUserMedia(any()),
        ).thenAnswer((_) async => mediaStream);

        final controller = CameraController(window: window)..start();
        await untilCalled(() => mediaDevices.getUserMedia(any()));
        expect(controller.value, equals(const CameraState.available()));

        controller.dispose();

        expect(controller.value, equals(const CameraState.uninitialized()));
      });
    });

    group('takePicture', () {
      test('returns image data', () async {
        final window = MockWindow();
        final navigator = MockNavigator();
        final mediaDevices = MockMediaDevices();
        final mediaStream = MediaStream();
        when(() => window.navigator).thenReturn(navigator);
        when(() => navigator.mediaDevices).thenReturn(mediaDevices);
        when(
          () => mediaDevices.getUserMedia(any()),
        ).thenAnswer((_) async => mediaStream);

        final controller = CameraController(window: window)..start();
        await untilCalled(() => mediaDevices.getUserMedia(any()));
        expect(controller.value, equals(const CameraState.available()));

        final image = await controller.takePicture();
        expect(image, isNotNull);
      });
    });
  });
}
