// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:camera/camera.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:photos_repository/photos_repository.dart';
import 'package:share_photo_repository/share_photo_repository.dart';
import 'package:test/test.dart';

import '../../helpers/helpers.dart';

class MockSharePhotoRepository extends Mock implements SharePhotoRepository {}

class MockPhotosRepository extends Mock implements PhotosRepository {}

class MockAsset extends Mock implements Asset {}

void main() {
  group('ShareBloc', () {
    final data = 'data:image/png,${base64.encode(transparentImage)}';
    final image = CameraImage(width: 0, height: 0, data: data);
    final imageName = 'image-name';
    final imageFileName = '$imageName.jpg';
    final shareText = 'share-text';
    final twitterShareUrl = 'twitter-share-url';
    final facebookShareUrl = 'facebook-share-url';

    final sharePhotoRepository = MockSharePhotoRepository();
    final photosRepository = MockPhotosRepository();

    setUpAll(() {
      registerFallbackValue(Uint8List(0));
    });

    setUp(() {
      when(() => photosRepository.uploadPhoto(imageFileName, any()))
          .thenAnswer((_) => Future.value());
      when(() => sharePhotoRepository.isSharingEnabled).thenReturn(true);
      when(() => sharePhotoRepository.getShareOnTwitterUrl(
          imageFileName, shareText)).thenReturn(twitterShareUrl);
      when(() => sharePhotoRepository.getShareOnFacebookUrl(
          imageFileName, shareText)).thenReturn(facebookShareUrl);
    });

    tearDown(() {
      reset(photosRepository);
      reset(sharePhotoRepository);
    });

    group('ShareOnTwitter', () {
      blocTest<ShareBloc, ShareState>(
        'calls photosRepository.uploadPhoto with correct arguments',
        build: () => ShareBloc(
          sharePhotoRepository: sharePhotoRepository,
          photosRepository: photosRepository,
        ),
        act: (b) => b.add(
          ShareOnTwitter(
            image: image,
            imageName: imageName,
            shareText: shareText,
            assets: [],
          ),
        ),
        verify: (b) {
          verify(
            () => photosRepository.uploadPhoto(
              imageFileName,
              Uint8List.fromList(transparentImage),
            ),
          ).called(1);
        },
      );

      blocTest<ShareBloc, ShareState>(
        'emits [loading, error] when photosRepository.uploadPhoto throws',
        build: () {
          when(() => photosRepository.uploadPhoto(imageFileName, any()))
              .thenThrow(Exception('e'));
          return ShareBloc(
            sharePhotoRepository: sharePhotoRepository,
            photosRepository: photosRepository,
          );
        },
        act: (b) => b.add(
          ShareOnTwitter(
            image: image,
            imageName: imageName,
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
        'calls sharePhotoRepository.getShareOnTwitterUrl '
        'when isSharingEnabled is true',
        build: () {
          when(() => sharePhotoRepository.isSharingEnabled).thenReturn(true);
          return ShareBloc(
            sharePhotoRepository: sharePhotoRepository,
            photosRepository: photosRepository,
          );
        },
        act: (b) => b.add(
          ShareOnTwitter(
            image: image,
            imageName: imageName,
            shareText: shareText,
            assets: [],
          ),
        ),
        verify: (b) {
          verify(
            () => sharePhotoRepository.getShareOnTwitterUrl(
                imageFileName, shareText),
          );
        },
      );

      blocTest<ShareBloc, ShareState>(
        'emits [loading, error] '
        'when sharePhotoRepository.getShareOnTwitterUrl throws',
        build: () {
          when(() => sharePhotoRepository.isSharingEnabled).thenReturn(true);
          when(() => sharePhotoRepository.getShareOnTwitterUrl(
              imageFileName, shareText)).thenThrow(Exception('e'));
          return ShareBloc(
            sharePhotoRepository: sharePhotoRepository,
            photosRepository: photosRepository,
          );
        },
        act: (b) => b.add(
          ShareOnTwitter(
            image: image,
            imageName: imageName,
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
        build: () {
          return ShareBloc(
            sharePhotoRepository: sharePhotoRepository,
            photosRepository: photosRepository,
          );
        },
        act: (b) => b.add(
          ShareOnTwitter(
            image: image,
            imageName: imageName,
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

    group('ShareOnFacebook', () {
      blocTest<ShareBloc, ShareState>(
        'calls photosRepository.uploadPhoto with correct arguments',
        build: () => ShareBloc(
          sharePhotoRepository: sharePhotoRepository,
          photosRepository: photosRepository,
        ),
        act: (b) => b.add(
          ShareOnFacebook(
            image: image,
            imageName: imageName,
            shareText: shareText,
            assets: [],
          ),
        ),
        verify: (b) {
          verify(
            () => photosRepository.uploadPhoto(
              imageFileName,
              Uint8List.fromList(transparentImage),
            ),
          ).called(1);
        },
      );

      blocTest<ShareBloc, ShareState>(
        'emits [loading, error] when photosRepository.uploadPhoto throws',
        build: () {
          when(() => photosRepository.uploadPhoto(imageFileName, any()))
              .thenThrow(Exception('e'));
          return ShareBloc(
            sharePhotoRepository: sharePhotoRepository,
            photosRepository: photosRepository,
          );
        },
        act: (b) => b.add(
          ShareOnFacebook(
            image: image,
            imageName: imageName,
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
        'calls sharePhotoRepository.getShareOnFacebookUrl '
        'when isSharingEnabled is true',
        build: () {
          when(() => sharePhotoRepository.isSharingEnabled).thenReturn(true);
          return ShareBloc(
            sharePhotoRepository: sharePhotoRepository,
            photosRepository: photosRepository,
          );
        },
        act: (b) => b.add(
          ShareOnFacebook(
            image: image,
            imageName: imageName,
            shareText: shareText,
            assets: [],
          ),
        ),
        verify: (b) {
          verify(
            () => sharePhotoRepository.getShareOnFacebookUrl(
                imageFileName, shareText),
          );
        },
      );

      blocTest<ShareBloc, ShareState>(
        'emits [loading, error] '
        'when sharePhotoRepository.getShareOnFacebookUrl throws',
        build: () {
          when(() => sharePhotoRepository.isSharingEnabled).thenReturn(true);
          when(() => sharePhotoRepository.getShareOnFacebookUrl(
              imageFileName, shareText)).thenThrow(Exception('e'));
          return ShareBloc(
            sharePhotoRepository: sharePhotoRepository,
            photosRepository: photosRepository,
          );
        },
        act: (b) => b.add(
          ShareOnFacebook(
            image: image,
            imageName: imageName,
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
        build: () {
          return ShareBloc(
            sharePhotoRepository: sharePhotoRepository,
            photosRepository: photosRepository,
          );
        },
        act: (b) => b.add(
          ShareOnFacebook(
            image: image,
            imageName: imageName,
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
