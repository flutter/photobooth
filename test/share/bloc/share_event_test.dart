import 'package:camera/camera.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:test/test.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class MockCameraImage extends Mock implements CameraImage {}

class MockAsset extends Mock implements Asset {}

class MockPhotoAsset extends Mock implements PhotoAsset {}

class MockDragUpdate extends Mock implements DragUpdate {}

void main() {
  group('ShareEvent', () {
    final imageName = 'image-name';
    final shareText = 'share-text';

    group('ShareOnTwitter', () {
      test('support value equality', () {
        final image = MockCameraImage();
        final assets = [MockPhotoAsset()];
        final instanceA = ShareOnTwitter(
          image: image,
          imageName: imageName,
          shareText: shareText,
          assets: assets,
        );
        final instanceB = ShareOnTwitter(
          image: image,
          imageName: imageName,
          shareText: shareText,
          assets: assets,
        );
        expect(instanceA, equals(instanceB));
      });
    });

    group('ShareOnFacebook', () {
      test('support value equality', () {
        final image = MockCameraImage();
        final assets = [MockPhotoAsset()];
        final instanceA = ShareOnFacebook(
          image: image,
          imageName: imageName,
          shareText: shareText,
          assets: assets,
        );
        final instanceB = ShareOnFacebook(
          image: image,
          imageName: imageName,
          shareText: shareText,
          assets: assets,
        );
        expect(instanceA, equals(instanceB));
      });
    });
  });
}
