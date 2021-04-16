// ignore_for_file: prefer_const_constructors
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

void main() {
  const size = Size(42, 42);
  const position = Offset(42, 42);
  const update = DragUpdate(position: position, size: size);

  group('PhotoboothBloc', () {
    test('initial state is PhotoboothState', () {
      expect(PhotoboothBloc().state, equals(PhotoboothState()));
    });

    group('PhotoboothAndroidUpdated', () {
      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits updated android position and size',
        build: () => PhotoboothBloc(),
        act: (bloc) => bloc.add(PhotoboothAndroidUpdated(update: update)),
        expect: () => [
          PhotoboothState(
            android: CharacterAsset.android().copyWith(
              position: CharacterAssetPosition(
                dx: position.dx,
                dy: position.dy,
              ),
              size: CharacterAssetSize(
                width: size.width,
                height: size.height,
              ),
            ),
          ),
        ],
      );
    });

    group('PhotoboothAndroidToggled', () {
      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits isSelected: true when isSelected is false',
        build: () => PhotoboothBloc(),
        act: (bloc) => bloc.add(PhotoboothAndroidToggled()),
        expect: () => [
          PhotoboothState(
            android: CharacterAsset.android().copyWith(isSelected: true),
          ),
        ],
      );

      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits isSelected: false when isSelected is true',
        build: () => PhotoboothBloc(),
        seed: () => PhotoboothState(
          android: CharacterAsset.android().copyWith(isSelected: true),
        ),
        act: (bloc) => bloc.add(PhotoboothAndroidToggled()),
        expect: () => [PhotoboothState()],
      );
    });

    group('PhotoboothDashUpdated', () {
      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits updated dash position and size',
        build: () => PhotoboothBloc(),
        act: (bloc) => bloc.add(PhotoboothDashUpdated(update: update)),
        expect: () => [
          PhotoboothState(
            dash: CharacterAsset.dash().copyWith(
              position: CharacterAssetPosition(
                dx: position.dx,
                dy: position.dy,
              ),
              size: CharacterAssetSize(
                width: size.width,
                height: size.height,
              ),
            ),
          ),
        ],
      );
    });

    group('PhotoboothDashToggled', () {
      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits isSelected: true when isSelected is false',
        build: () => PhotoboothBloc(),
        act: (bloc) => bloc.add(PhotoboothDashToggled()),
        expect: () => [
          PhotoboothState(
            dash: CharacterAsset.dash().copyWith(isSelected: true),
          ),
        ],
      );

      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits isSelected: false when isSelected is true',
        build: () => PhotoboothBloc(),
        seed: () => PhotoboothState(
          dash: CharacterAsset.dash().copyWith(isSelected: true),
        ),
        act: (bloc) => bloc.add(PhotoboothDashToggled()),
        expect: () => [PhotoboothState()],
      );
    });

    group('PhotoboothSparkyUpdated', () {
      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits updated sparky position and size',
        build: () => PhotoboothBloc(),
        act: (bloc) => bloc.add(PhotoboothSparkyUpdated(update: update)),
        expect: () => [
          PhotoboothState(
            sparky: CharacterAsset.sparky().copyWith(
              position: CharacterAssetPosition(
                dx: position.dx,
                dy: position.dy,
              ),
              size: CharacterAssetSize(
                width: size.width,
                height: size.height,
              ),
            ),
          ),
        ],
      );
    });

    group('PhotoboothSparkyToggled', () {
      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits isSelected: true when isSelected is false',
        build: () => PhotoboothBloc(),
        act: (bloc) => bloc.add(PhotoboothSparkyToggled()),
        expect: () => [
          PhotoboothState(
            sparky: CharacterAsset.sparky().copyWith(isSelected: true),
          ),
        ],
      );

      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits isSelected: false when isSelected is true',
        build: () => PhotoboothBloc(),
        seed: () => PhotoboothState(
          sparky: CharacterAsset.sparky().copyWith(isSelected: true),
        ),
        act: (bloc) => bloc.add(PhotoboothSparkyToggled()),
        expect: () => [PhotoboothState()],
      );
    });
  });
}
