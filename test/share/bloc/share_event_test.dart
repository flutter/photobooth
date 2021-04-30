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
    final imageId = 'image-id';
    final shareText = 'share-text';

    group('ShareOnTwitterTapped', () {
      test('support value equality', () {
        final image = MockCameraImage();
        final assets = [MockPhotoAsset()];
        final instanceA = ShareOnTwitterTapped(
          image: image,
          imageId: imageId,
          shareText: shareText,
          assets: assets,
        );
        final instanceB = ShareOnTwitterTapped(
          image: image,
          imageId: imageId,
          shareText: shareText,
          assets: assets,
        );
        expect(instanceA, equals(instanceB));
      });
    });

    group('ShareOnFacebookTapped', () {
      test('support value equality', () {
        final image = MockCameraImage();
        final assets = [MockPhotoAsset()];
        final instanceA = ShareOnFacebookTapped(
          image: image,
          imageId: imageId,
          shareText: shareText,
          assets: assets,
        );
        final instanceB = ShareOnFacebookTapped(
          image: image,
          imageId: imageId,
          shareText: shareText,
          assets: assets,
        );
        expect(instanceA, equals(instanceB));
      });
    });
  });
}
