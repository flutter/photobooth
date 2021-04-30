// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:camera/camera.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:photos_repository/photos_repository.dart';
import 'package:test/test.dart';

import '../../helpers/helpers.dart';

class MockPhotosRepository extends Mock implements PhotosRepository {}

class MockAsset extends Mock implements Asset {}

void main() {
  group('ShareBloc', () {
    final data = 'data:image/png,${base64.encode(transparentImage)}';
    final image = CameraImage(width: 0, height: 0, data: data);
    final imageId = 'image-name';
    final imageFileName = '$imageId.jpg';
    final imageData = Uint8List.fromList(transparentImage);
    final shareText = 'share-text';
    final twitterShareUrl = 'twitter-share-url';
    final facebookShareUrl = 'facebook-share-url';

    final photosRepository = MockPhotosRepository();

    setUpAll(() {
      registerFallbackValue(Uint8List(0));
    });

    setUp(() {
      when(() => photosRepository.uploadPhoto(imageFileName, any()))
          .thenAnswer((_) => Future.value());
      when(() => photosRepository.twitterShareUrl(imageFileName, shareText))
          .thenReturn(twitterShareUrl);
      when(() => photosRepository.facebookShareUrl(imageFileName, shareText))
          .thenReturn(facebookShareUrl);
    });

    tearDown(() {
      reset(photosRepository);
    });

    group('ShareOnTwitterTapped', () {
      blocTest<ShareBloc, ShareState>(
        'does nothing when isSharingEnabled is false',
        build: () => ShareBloc(photosRepository: photosRepository),
        act: (b) => b.add(
          ShareOnTwitterTapped(
            image: image,
            imageId: imageId,
            shareText: shareText,
            assets: [],
          ),
        ),
        expect: () => [],
        verify: (_) {
          verifyNever(() => photosRepository.uploadPhoto(any(), any()));
          verifyNever(() => photosRepository.twitterShareUrl(any(), any()));
        },
      );

      blocTest<ShareBloc, ShareState>(
        'calls photosRepository.uploadPhoto with correct arguments',
        build: () => ShareBloc(
          photosRepository: photosRepository,
          isSharingEnabled: true,
        ),
        act: (b) => b.add(
          ShareOnTwitterTapped(
            image: image,
            imageId: imageId,
            shareText: shareText,
            assets: [],
          ),
        ),
        verify: (_) {
          verify(
            () => photosRepository.uploadPhoto(imageFileName, imageData),
          ).called(1);
        },
      );

      blocTest<ShareBloc, ShareState>(
        'emits [loading, error] when photosRepository.uploadPhoto throws',
        build: () {
          when(() => photosRepository.uploadPhoto(imageFileName, any()))
              .thenThrow(Exception('e'));
          return ShareBloc(
            photosRepository: photosRepository,
            isSharingEnabled: true,
          );
        },
        act: (b) => b.add(
          ShareOnTwitterTapped(
            image: image,
            imageId: imageId,
            shareText: shareText,
            assets: [],
          ),
        ),
        errors: () => [
          isA<Exception>(),
        ],
        expect: () => [
          ShareState.loading(),
          ShareState.error(),
        ],
      );

      blocTest<ShareBloc, ShareState>(
        'calls sharePhotoRepository.getShareOnTwitterUrl',
        build: () => ShareBloc(
          photosRepository: photosRepository,
          isSharingEnabled: true,
        ),
        act: (b) => b.add(
          ShareOnTwitterTapped(
            image: image,
            imageId: imageId,
            shareText: shareText,
            assets: [],
          ),
        ),
        verify: (_) {
          verify(
            () => photosRepository.twitterShareUrl(imageFileName, shareText),
          ).called(1);
        },
      );

      blocTest<ShareBloc, ShareState>(
        'emits [loading, error] when twitterShareUrl throws',
        build: () {
          when(
            () => photosRepository.twitterShareUrl(imageFileName, shareText),
          ).thenThrow(Exception('oops'));
          return ShareBloc(
            photosRepository: photosRepository,
            isSharingEnabled: true,
          );
        },
        act: (b) => b.add(
          ShareOnTwitterTapped(
            image: image,
            imageId: imageId,
            shareText: shareText,
            assets: [],
          ),
        ),
        errors: () => [
          isA<Exception>(),
        ],
        expect: () => [
          ShareState.loading(),
          ShareState.error(),
        ],
      );

      blocTest<ShareBloc, ShareState>(
        'emits [loading, success] when operations successfully finish',
        build: () => ShareBloc(
          photosRepository: photosRepository,
          isSharingEnabled: true,
        ),
        act: (b) => b.add(
          ShareOnTwitterTapped(
            image: image,
            imageId: imageId,
            shareText: shareText,
            assets: [],
          ),
        ),
        expect: () => [
          ShareState.loading(),
          ShareState.success(shareUrl: twitterShareUrl),
        ],
      );
    });

    group('ShareOnFacebookTapped', () {
      blocTest<ShareBloc, ShareState>(
        'does nothing when isSharingEnabled is false',
        build: () => ShareBloc(photosRepository: photosRepository),
        act: (b) => b.add(
          ShareOnFacebookTapped(
            image: image,
            imageId: imageId,
            shareText: shareText,
            assets: [],
          ),
        ),
        expect: () => [],
        verify: (_) {
          verifyNever(() => photosRepository.uploadPhoto(any(), any()));
          verifyNever(() => photosRepository.facebookShareUrl(any(), any()));
        },
      );
      blocTest<ShareBloc, ShareState>(
        'calls photosRepository.uploadPhoto with correct arguments',
        build: () => ShareBloc(
          photosRepository: photosRepository,
          isSharingEnabled: true,
        ),
        act: (b) => b.add(
          ShareOnFacebookTapped(
            image: image,
            imageId: imageId,
            shareText: shareText,
            assets: [],
          ),
        ),
        verify: (_) {
          verify(
            () => photosRepository.uploadPhoto(imageFileName, imageData),
          ).called(1);
        },
      );

      blocTest<ShareBloc, ShareState>(
        'emits [loading, error] when photosRepository.uploadPhoto throws',
        build: () {
          when(() => photosRepository.uploadPhoto(imageFileName, any()))
              .thenThrow(Exception('e'));
          return ShareBloc(
            photosRepository: photosRepository,
            isSharingEnabled: true,
          );
        },
        act: (b) => b.add(
          ShareOnFacebookTapped(
            image: image,
            imageId: imageId,
            shareText: shareText,
            assets: [],
          ),
        ),
        errors: () => [
          isA<Exception>(),
        ],
        expect: () => [
          ShareState.loading(),
          ShareState.error(),
        ],
      );

      blocTest<ShareBloc, ShareState>(
        'calls sharePhotoRepository.getShareOnFacebookUrl',
        build: () => ShareBloc(
          photosRepository: photosRepository,
          isSharingEnabled: true,
        ),
        act: (b) => b.add(
          ShareOnFacebookTapped(
            image: image,
            imageId: imageId,
            shareText: shareText,
            assets: [],
          ),
        ),
        verify: (_) {
          verify(
            () => photosRepository.facebookShareUrl(imageFileName, shareText),
          );
        },
      );

      blocTest<ShareBloc, ShareState>(
        'emits [loading, error] '
        'when sharePhotoRepository.getShareOnFacebookUrl throws',
        build: () {
          when(
            () => photosRepository.facebookShareUrl(imageFileName, shareText),
          ).thenThrow(Exception('e'));
          return ShareBloc(
            photosRepository: photosRepository,
            isSharingEnabled: true,
          );
        },
        act: (b) => b.add(
          ShareOnFacebookTapped(
            image: image,
            imageId: imageId,
            shareText: shareText,
            assets: [],
          ),
        ),
        expect: () => [
          ShareState.loading(),
          ShareState.error(),
        ],
        errors: () => [
          isA<Exception>(),
        ],
      );

      blocTest<ShareBloc, ShareState>(
        'emits [loading, success] when operations successfully finish',
        build: () => ShareBloc(
          photosRepository: photosRepository,
          isSharingEnabled: true,
        ),
        act: (b) => b.add(
          ShareOnFacebookTapped(
            image: image,
            imageId: imageId,
            shareText: shareText,
            assets: [],
          ),
        ),
        expect: () => [
          ShareState.loading(),
          ShareState.success(shareUrl: facebookShareUrl),
        ],
      );
    });
  });
}
