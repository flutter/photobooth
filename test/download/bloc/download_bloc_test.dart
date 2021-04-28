// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:camera/camera.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_compositor/image_compositor.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/download/download.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photos_repository/photos_repository.dart';

class MockPhotosRepository extends Mock implements PhotosRepository {}

const width = 1;
const height = 1;
const data = '';
const imageId = '0';
const image = CameraImage(width: width, height: height, data: data);

final assets = [
  PhotoAsset(
    id: '0',
    asset: Assets.dash,
  ),
];

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await Assets.load();
  group('DownloadBloc', () {
    late PhotosRepository photosRepository;

    setUp(() {
      photosRepository = MockPhotosRepository();
    });

    test('initial state is DownloadState.initial', () {
      expect(
        DownloadBloc(
          image: image,
          imageId: imageId,
          assets: assets,
          photosRepository: photosRepository,
        ).state,
        equals(DownloadState.initial()),
      );
    });

    group('DownloadTapped', () {
      final compositeData = Uint8List.fromList([]);
      blocTest<DownloadBloc, DownloadState>(
        'emits nothing when status is loading',
        build: () => DownloadBloc(
          image: image,
          imageId: imageId,
          assets: assets,
          photosRepository: photosRepository,
        ),
        seed: () => DownloadState.loading(),
        act: (bloc) => bloc.add(DownloadTapped()),
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
          return DownloadBloc(
            image: image,
            imageId: imageId,
            assets: [],
            photosRepository: photosRepository,
          );
        },
        act: (bloc) => bloc.add(DownloadTapped()),
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
        'emits [loading, success] when composite succeeds (no layers)',
        build: () {
          when(
            () => photosRepository.composite(
              width: any(named: 'width'),
              height: any(named: 'height'),
              data: any(named: 'data'),
              layers: any(named: 'layers'),
              aspectRatio: any(named: 'aspectRatio'),
            ),
          ).thenAnswer((_) async => compositeData);
          return DownloadBloc(
            image: image,
            imageId: imageId,
            assets: [],
            photosRepository: photosRepository,
          );
        },
        act: (bloc) => bloc.add(DownloadTapped()),
        expect: () => [
          DownloadState.loading(),
          isA<DownloadState>().having(
            (s) => s.file,
            'file',
            isA<XFile>().having((x) => x.mimeType, 'type', 'image/jpeg'),
          ),
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
        'emits [loading, success] when composite succeeds (layers)',
        build: () {
          when(
            () => photosRepository.composite(
              width: any(named: 'width'),
              height: any(named: 'height'),
              data: any(named: 'data'),
              layers: any(named: 'layers'),
              aspectRatio: any(named: 'aspectRatio'),
            ),
          ).thenAnswer((_) async => compositeData);
          return DownloadBloc(
            image: image,
            imageId: imageId,
            assets: assets,
            photosRepository: photosRepository,
          );
        },
        act: (bloc) => bloc.add(DownloadTapped()),
        expect: () => [
          DownloadState.loading(),
          isA<DownloadState>().having(
            (s) => s.file,
            'file',
            isA<XFile>().having((x) => x.mimeType, 'type', 'image/jpeg'),
          ),
        ],
        verify: (_) {
          verify(
            () => photosRepository.composite(
              width: width,
              height: height,
              data: data,
              layers: any(
                named: 'layers',
                that: isA<List<CompositeLayer>>().having(
                  (e) => e.first.assetPath,
                  'assetPath',
                  'assets/${assets.first.asset.path}',
                ),
              ),
              aspectRatio: 3 / 4,
            ),
          ).called(1);
        },
      );
    });
  });
}
