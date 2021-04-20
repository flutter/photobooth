// ignore_for_file: prefer_const_constructors
import 'package:bloc_test/bloc_test.dart';
import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class MockCameraImage extends Mock implements CameraImage {}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await Assets.load();
  group('PhotoboothBloc', () {
    late CameraImage image;

    setUp(() {
      image = MockCameraImage();
    });

    test('initial state is PhotoboothState', () {
      expect(PhotoboothBloc().state, equals(PhotoboothState()));
    });

    group('PhotoCaptured', () {
      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits updated state with image',
        build: () => PhotoboothBloc(),
        act: (bloc) => bloc.add(PhotoCaptured(image: image)),
        expect: () => [PhotoboothState(image: image)],
      );
    });

    group('PhotoCharacterToggled', () {
      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits updated state with character '
        'when character did not exist (android)',
        build: () => PhotoboothBloc(),
        act: (bloc) => bloc.add(
          PhotoCharacterToggled(character: Assets.android),
        ),
        expect: () => [
          PhotoboothState(
            characters: [PhotoAsset(id: 0, asset: Assets.android)],
            selectedAssetId: 0,
          )
        ],
      );

      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits updated state with character '
        'when character did not exist (dash)',
        build: () => PhotoboothBloc(),
        act: (bloc) => bloc.add(PhotoCharacterToggled(character: Assets.dash)),
        expect: () => [
          PhotoboothState(
            characters: [PhotoAsset(id: 0, asset: Assets.dash)],
            selectedAssetId: 0,
          )
        ],
      );

      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits updated state with character '
        'when character did not exist (sparky)',
        build: () => PhotoboothBloc(),
        act: (bloc) =>
            bloc.add(PhotoCharacterToggled(character: Assets.sparky)),
        expect: () => [
          PhotoboothState(
            characters: [PhotoAsset(id: 0, asset: Assets.sparky)],
            selectedAssetId: 0,
          )
        ],
      );

      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits updated state with character '
        'when character did exist (android)',
        build: () => PhotoboothBloc(),
        seed: () => PhotoboothState(
          characters: [PhotoAsset(id: 0, asset: Assets.android)],
        ),
        act: (bloc) => bloc.add(
          PhotoCharacterToggled(character: Assets.android),
        ),
        expect: () => [PhotoboothState()],
      );

      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits updated state with character '
        'when character did exist (dash)',
        build: () => PhotoboothBloc(),
        seed: () => PhotoboothState(
          characters: [PhotoAsset(id: 0, asset: Assets.dash)],
        ),
        act: (bloc) => bloc.add(
          PhotoCharacterToggled(character: Assets.dash),
        ),
        expect: () => [PhotoboothState()],
      );

      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits updated state with character '
        'when character did exist (sparky)',
        build: () => PhotoboothBloc(),
        seed: () => PhotoboothState(
          characters: [PhotoAsset(id: 0, asset: Assets.sparky)],
        ),
        act: (bloc) => bloc.add(
          PhotoCharacterToggled(character: Assets.sparky),
        ),
        expect: () => [PhotoboothState()],
      );
    });

    group('PhotoCharacterDragged', () {
      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits updated state',
        build: () => PhotoboothBloc(),
        seed: () => PhotoboothState(
          characters: [PhotoAsset(id: 0, asset: Assets.sparky)],
        ),
        act: (bloc) => bloc.add(
          PhotoCharacterDragged(
            character: PhotoAsset(id: 0, asset: Assets.sparky),
            update: DragUpdate(
              position: Offset(42, 42),
              constraints: Size(42, 42),
              size: Size(42, 42),
            ),
          ),
        ),
        expect: () => [
          PhotoboothState(
            characters: [
              PhotoAsset(
                id: 0,
                asset: Assets.sparky,
                position: PhotoAssetPosition(dx: 42, dy: 42),
                constraint: PhotoConstraint(width: 42, height: 42),
                size: PhotoAssetSize(width: 42, height: 42),
              ),
            ],
            selectedAssetId: 0,
          )
        ],
      );
    });

    group('PhotoStickerTapped', () {
      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits updated state with sticker',
        build: () => PhotoboothBloc(),
        act: (bloc) => bloc.add(
          PhotoStickerTapped(sticker: Assets.banana),
        ),
        expect: () => [
          PhotoboothState(
            stickers: [PhotoAsset(id: 0, asset: Assets.banana)],
            selectedAssetId: 0,
          )
        ],
      );
    });

    group('PhotoStickerDragged', () {
      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits updated state',
        build: () => PhotoboothBloc(),
        seed: () => PhotoboothState(
          stickers: [PhotoAsset(id: 0, asset: Assets.banana)],
        ),
        act: (bloc) => bloc.add(
          PhotoStickerDragged(
            sticker: PhotoAsset(id: 0, asset: Assets.banana),
            update: DragUpdate(
              position: Offset(42, 42),
              constraints: Size(42, 42),
              size: Size(42, 42),
            ),
          ),
        ),
        expect: () => [
          PhotoboothState(
            stickers: [
              PhotoAsset(
                id: 0,
                asset: Assets.banana,
                position: PhotoAssetPosition(dx: 42, dy: 42),
                constraint: PhotoConstraint(width: 42, height: 42),
                size: PhotoAssetSize(width: 42, height: 42),
              ),
            ],
            selectedAssetId: 0,
          )
        ],
      );
    });

    group('PhotoClearStickersTapped', () {
      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits updated state with no stickers',
        build: () => PhotoboothBloc(),
        seed: () => PhotoboothState(
          stickers: [PhotoAsset(id: 0, asset: Assets.banana)],
        ),
        act: (bloc) => bloc.add(PhotoClearStickersTapped()),
        expect: () => [PhotoboothState()],
      );
    });

    group('PhotoClearAllTapped', () {
      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits updated state with no characters or stickers',
        build: () => PhotoboothBloc(),
        seed: () => PhotoboothState(
          characters: [PhotoAsset(id: 0, asset: Assets.dash)],
          stickers: [PhotoAsset(id: 0, asset: Assets.banana)],
        ),
        act: (bloc) => bloc.add(PhotoClearAllTapped()),
        expect: () => [PhotoboothState()],
      );
    });

    group('PhotoTapped', () {
      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits updated state with no selectedAssetId',
        build: () => PhotoboothBloc(),
        seed: () => PhotoboothState(
          characters: [PhotoAsset(id: 0, asset: Assets.dash)],
          stickers: [PhotoAsset(id: 0, asset: Assets.banana)],
          selectedAssetId: 0,
        ),
        act: (bloc) => bloc.add(PhotoTapped()),
        expect: () => [
          PhotoboothState(
            characters: [PhotoAsset(id: 0, asset: Assets.dash)],
            stickers: [PhotoAsset(id: 0, asset: Assets.banana)],
          ),
        ],
      );
    });
  });
}
