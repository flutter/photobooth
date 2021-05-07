import 'package:camera/camera.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:test/test.dart';

class MockCameraImage extends Mock implements CameraImage {}

class MockAsset extends Mock implements Asset {}

class MockPhotoAsset extends Mock implements PhotoAsset {}

class MockDragUpdate extends Mock implements DragUpdate {}

void main() {
  group('PhotoboothEvent', () {
    group('PhotoCaptured', () {
      test('support value equality', () {
        const aspectRatio = PhotoboothAspectRatio.portrait;
        final image = MockCameraImage();
        final instanceA = PhotoCaptured(aspectRatio: aspectRatio, image: image);
        final instanceB = PhotoCaptured(aspectRatio: aspectRatio, image: image);
        expect(instanceA, equals(instanceB));
      });
    });

    group('PhotoCharacterToggled', () {
      test('support value equality', () {
        final character = MockAsset();
        final instanceA = PhotoCharacterToggled(character: character);
        final instanceB = PhotoCharacterToggled(character: character);
        expect(instanceA, equals(instanceB));
      });
    });

    group('PhotoCharacterDragged', () {
      test('support value equality', () {
        final character = MockPhotoAsset();
        final update = MockDragUpdate();
        final instanceA = PhotoCharacterDragged(
          character: character,
          update: update,
        );
        final instanceB = PhotoCharacterDragged(
          character: character,
          update: update,
        );
        expect(instanceA, equals(instanceB));
      });
    });

    group('PhotoStickerTapped', () {
      test('support value equality', () {
        final sticker = MockAsset();
        final instanceA = PhotoStickerTapped(sticker: sticker);
        final instanceB = PhotoStickerTapped(sticker: sticker);
        expect(instanceA, equals(instanceB));
      });
    });

    group('PhotoStickerDragged', () {
      test('support value equality', () {
        final sticker = MockPhotoAsset();
        final update = MockDragUpdate();
        final instanceA = PhotoStickerDragged(
          sticker: sticker,
          update: update,
        );
        final instanceB = PhotoStickerDragged(
          sticker: sticker,
          update: update,
        );
        expect(instanceA, equals(instanceB));
      });
    });
  });
}
