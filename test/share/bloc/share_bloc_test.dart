// ignore_for_file: prefer_const_constructors
import 'package:bloc_test/bloc_test.dart';
import 'package:camera/camera.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:test/test.dart';

class MockCameraImage extends Mock implements CameraImage {}

class MockAsset extends Mock implements Asset {}

void main() {
  group('ShareBloc', () {
    final image = MockCameraImage();

    blocTest<ShareBloc, ShareState>(
      'emits [loading, success] when ShareOnTwitter event is added',
      build: () => ShareBloc(),
      act: (b) => b.add(ShareOnTwitter(image: image, assets: [])),
      expect: () => [ShareState.loading(), ShareState.success()],
    );

    blocTest<ShareBloc, ShareState>(
      'emits [loading, error] when ShareOnFacebook event is added',
      build: () => ShareBloc(),
      act: (b) => b.add(ShareOnFacebook(image: image, assets: [])),
      expect: () => [ShareState.loading(), ShareState.error()],
    );
  });
}
