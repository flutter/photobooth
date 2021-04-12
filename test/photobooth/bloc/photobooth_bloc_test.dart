import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';

void main() {
  group('PhotoboothBloc', () {
    test('initial state is PhotoboothState', () {
      expect(PhotoboothBloc().state, equals(const PhotoboothState()));
    });

    group('PhotoboothAndroidToggled', () {
      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits isAndroidSelected: true when isAndroidSelected is false',
        build: () => PhotoboothBloc(),
        seed: () => const PhotoboothState(isAndroidSelected: false),
        act: (bloc) => bloc.add(const PhotoboothAndroidToggled()),
        expect: () => [
          const PhotoboothState(isAndroidSelected: true),
        ],
      );

      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits isAndroidSelected: false when isAndroidSelected is true',
        build: () => PhotoboothBloc(),
        seed: () => const PhotoboothState(isAndroidSelected: true),
        act: (bloc) => bloc.add(const PhotoboothAndroidToggled()),
        expect: () => [
          const PhotoboothState(isAndroidSelected: false),
        ],
      );
    });

    group('PhotoboothDashToggled', () {
      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits isDashSelected: true when isDashSelected is false',
        build: () => PhotoboothBloc(),
        seed: () => const PhotoboothState(isDashSelected: false),
        act: (bloc) => bloc.add(const PhotoboothDashToggled()),
        expect: () => [
          const PhotoboothState(isDashSelected: true),
        ],
      );

      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits isDashSelected: false when isDashSelected is true',
        build: () => PhotoboothBloc(),
        seed: () => const PhotoboothState(isDashSelected: true),
        act: (bloc) => bloc.add(const PhotoboothDashToggled()),
        expect: () => [
          const PhotoboothState(isDashSelected: false),
        ],
      );
    });

    group('PhotoboothSparkyToggled', () {
      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits isSparkySelected: true when isSparkySelected is false',
        build: () => PhotoboothBloc(),
        seed: () => const PhotoboothState(isSparkySelected: false),
        act: (bloc) => bloc.add(const PhotoboothSparkyToggled()),
        expect: () => [
          const PhotoboothState(isSparkySelected: true),
        ],
      );

      blocTest<PhotoboothBloc, PhotoboothState>(
        'emits isSparkySelected: false when isSparkySelected is true',
        build: () => PhotoboothBloc(),
        seed: () => const PhotoboothState(isSparkySelected: true),
        act: (bloc) => bloc.add(const PhotoboothSparkyToggled()),
        expect: () => [
          const PhotoboothState(isSparkySelected: false),
        ],
      );
    });
  });
}
