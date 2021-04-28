// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:camera/camera.dart';
import 'package:io_photobooth/download/download.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photos_repository/photos_repository.dart';
import 'package:test/test.dart';

class MockPhotosRepository extends Mock implements PhotosRepository {}

const width = 1;
const height = 1;
const data = '';
const image = CameraImage(width: width, height: height, data: data);

void main() {
  group('DownloadBloc', () {
    late PhotosRepository photosRepository;

    setUp(() {
      photosRepository = MockPhotosRepository();
    });

    test('initial state is DownloadState.initial', () {
      expect(
        DownloadBloc(photosRepository: photosRepository).state,
        equals(DownloadState.initial()),
      );
    });

    group('DownloadTapped', () {
      blocTest<DownloadBloc, DownloadState>(
        'emits nothing when status is loading',
        build: () => DownloadBloc(photosRepository: photosRepository),
        seed: () => DownloadState.loading(),
        act: (bloc) => bloc.add(DownloadTapped(image: image, assets: [])),
        expect: () => [],
      );

      blocTest<DownloadBloc, DownloadState>(
        'emits [loading, failure] when composite fails',
        build: () {
          when(
            () => photosRepository.composite(
              width: any(named: 'width'),
              height: any(named: 'height'),
              data: any(named: 'data'),
              layers: any(named: 'layers'),
              aspectRatio: any(named: 'aspectRatio'),
            ),
          ).thenThrow(Exception('oops'));
          return DownloadBloc(photosRepository: photosRepository);
        },
        act: (bloc) => bloc.add(DownloadTapped(image: image, assets: [])),
        expect: () => [
          DownloadState.loading(),
          DownloadState.error(),
        ],
        verify: (_) {
          verify(
            () => photosRepository.composite(
              width: width,
              height: height,
              data: data,
              layers: [],
              aspectRatio: 3 / 4,
            ),
          ).called(1);
        },
      );

      blocTest<DownloadBloc, DownloadState>(
        'emits [loading, success] when composite succeeds',
        build: () {
          when(
            () => photosRepository.composite(
              width: any(named: 'width'),
              height: any(named: 'height'),
              data: any(named: 'data'),
              layers: any(named: 'layers'),
              aspectRatio: any(named: 'aspectRatio'),
            ),
          ).thenAnswer((_) async => Uint8List.fromList([]));
          return DownloadBloc(photosRepository: photosRepository);
        },
        act: (bloc) => bloc.add(DownloadTapped(image: image, assets: [])),
        expect: () => [
          DownloadState.loading(),
          DownloadState.success(file: any(named: 'file')),
        ],
        verify: (_) {
          verify(
            () => photosRepository.composite(
              width: width,
              height: height,
              data: data,
              layers: [],
              aspectRatio: 3 / 4,
            ),
          ).called(1);
        },
      );
    });
  });
}
