// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:camera/camera.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:photos_repository/photos_repository.dart';

import '../../helpers/helpers.dart';

class MockPhotosRepository extends Mock implements PhotosRepository {}

class MockPhotoAsset extends Mock implements PhotoAsset {}

class MockAsset extends Mock implements Asset {}

void main() {
  final data = 'data:image/png,${base64.encode(transparentImage)}';
  final image = CameraImage(width: 0, height: 0, data: data);
  final imageData = Uint8List.fromList(transparentImage);
  const aspectRatio = PhotoboothAspectRatio.portrait;
  const imageId = 'image-name';
  const shareText = 'share-text';
  const explicitShareUrl = 'explicit-share-url';
  const twitterShareUrl = 'twitter-share-url';
  const facebookShareUrl = 'facebook-share-url';

  group('ShareBloc', () {
    late PhotosRepository photosRepository;
    late Asset asset;
    late PhotoAsset photoAsset;
    late ShareBloc shareBloc;

    setUpAll(() {
      registerFallbackValue(Uint8List(0));
    });

    setUp(() {
      photosRepository = MockPhotosRepository();
      asset = MockAsset();

      when(() => asset.path).thenReturn('assets/path/asset.png');
      photoAsset = MockPhotoAsset();

      when(() => photoAsset.asset).thenReturn(asset);
      when(() => photoAsset.angle).thenReturn(0.0);
      when(() => photoAsset.constraint).thenReturn(
        PhotoConstraint(width: 1, height: 1),
      );
      when(() => photoAsset.position).thenReturn(
        PhotoAssetPosition(dx: 1, dy: 1),
      );
      when(() => photoAsset.size).thenReturn(
        PhotoAssetSize(width: 1, height: 1),
      );
      shareBloc = ShareBloc(
        photosRepository: photosRepository,
        imageId: imageId,
        image: image,
        assets: [photoAsset],
        shareText: shareText,
        aspectRatio: aspectRatio,
        isSharingEnabled: true,
      );
    });

    test('initial state is ShareState', () {
      expect(shareBloc.state, equals(ShareState()));
    });

    group('ShareViewLoaded', () {
      blocTest<ShareBloc, ShareState>(
        'emits [loading, failure] when compositing fails',
        build: () {
          when(
            () => photosRepository.composite(
              width: any(named: 'width'),
              height: any(named: 'height'),
              data: any(named: 'data'),
              layers: any(named: 'layers'),
              aspectRatio: any(named: 'aspectRatio'),
            ),
          ).thenThrow(Exception());
          return shareBloc;
        },
        act: (bloc) => bloc.add(ShareViewLoaded()),
        expect: () => [
          ShareState(compositeStatus: ShareStatus.loading),
          ShareState(
            compositeStatus: ShareStatus.failure,
            uploadStatus: ShareStatus.initial,
          ),
        ],
      );

      blocTest<ShareBloc, ShareState>(
        'emits [loading, success] when compositing succeeds',
        build: () {
          when(
            () => photosRepository.composite(
              width: any(named: 'width'),
              height: any(named: 'height'),
              data: any(named: 'data'),
              layers: any(named: 'layers'),
              aspectRatio: any(named: 'aspectRatio'),
            ),
          ).thenAnswer((_) async => imageData);
          return shareBloc;
        },
        act: (bloc) => bloc.add(ShareViewLoaded()),
        expect: () => [
          ShareState(compositeStatus: ShareStatus.loading),
          isA<ShareState>().having(
            (s) => s.compositeStatus,
            'compositeStatus',
            ShareStatus.success,
          ),
        ],
      );
    });

    group('ShareOnTwitterTapped', () {
      blocTest<ShareBloc, ShareState>(
        'does nothing when sharing is disabled',
        build: () => ShareBloc(
          photosRepository: photosRepository,
          imageId: imageId,
          image: image,
          assets: [photoAsset],
          shareText: shareText,
          aspectRatio: aspectRatio,
          isSharingEnabled: false,
        ),
        act: (bloc) => bloc.add(ShareOnTwitterTapped()),
        expect: () => [],
      );

      blocTest<ShareBloc, ShareState>(
        'sets isUploadRequested to true with correct shareUrl',
        build: () => shareBloc,
        seed: () => ShareState(compositeStatus: ShareStatus.loading),
        act: (bloc) => bloc.add(ShareOnTwitterTapped()),
        expect: () => [
          ShareState(
            compositeStatus: ShareStatus.loading,
            isUploadRequested: true,
            shareUrl: ShareUrl.twitter,
          ),
        ],
      );

      blocTest<ShareBloc, ShareState>(
        'emits [loading, failure] '
        'when composite status is success and upload fails',
        build: () {
          when(
            () => photosRepository.sharePhoto(
              fileName: any(named: 'fileName'),
              data: any(named: 'data'),
              shareText: any(named: 'shareText'),
            ),
          ).thenThrow(Exception());
          return shareBloc;
        },
        seed: () => ShareState(compositeStatus: ShareStatus.success),
        act: (bloc) => bloc.add(ShareOnTwitterTapped()),
        expect: () => [
          ShareState(
            compositeStatus: ShareStatus.success,
            isUploadRequested: true,
            shareUrl: ShareUrl.twitter,
          ),
          ShareState(
            compositeStatus: ShareStatus.success,
            uploadStatus: ShareStatus.loading,
            isUploadRequested: true,
            shareUrl: ShareUrl.twitter,
          ),
          isA<ShareState>().having(
            (s) => s.uploadStatus,
            'uploadStatus',
            ShareStatus.failure,
          ),
        ],
      );

      blocTest<ShareBloc, ShareState>(
        'emits [loading, success] '
        'when composite status is success and upload succeeds',
        build: () {
          when(
            () => photosRepository.sharePhoto(
              fileName: any(named: 'fileName'),
              data: any(named: 'data'),
              shareText: any(named: 'shareText'),
            ),
          ).thenAnswer(
            (_) async => ShareUrls(
              explicitShareUrl: explicitShareUrl,
              facebookShareUrl: facebookShareUrl,
              twitterShareUrl: twitterShareUrl,
            ),
          );
          return shareBloc;
        },
        seed: () => ShareState(
          compositeStatus: ShareStatus.success,
          bytes: imageData,
        ),
        act: (bloc) => bloc.add(ShareOnTwitterTapped()),
        expect: () => [
          ShareState(
            compositeStatus: ShareStatus.success,
            bytes: imageData,
            isUploadRequested: true,
            shareUrl: ShareUrl.twitter,
          ),
          ShareState(
            compositeStatus: ShareStatus.success,
            uploadStatus: ShareStatus.loading,
            bytes: imageData,
            isUploadRequested: true,
            shareUrl: ShareUrl.twitter,
          ),
          isA<ShareState>().having(
            (s) => s.uploadStatus,
            'uploadStatus',
            ShareStatus.success,
          ),
        ],
      );

      blocTest<ShareBloc, ShareState>(
        'emits [loading, failure] '
        'when composite status is failure and compositing fails',
        build: () {
          when(
            () => photosRepository.composite(
              width: any(named: 'width'),
              height: any(named: 'height'),
              data: any(named: 'data'),
              layers: any(named: 'layers'),
              aspectRatio: any(named: 'aspectRatio'),
            ),
          ).thenThrow(Exception());
          return shareBloc;
        },
        seed: () => ShareState(compositeStatus: ShareStatus.failure),
        act: (bloc) => bloc.add(ShareOnTwitterTapped()),
        expect: () => [
          ShareState(
            compositeStatus: ShareStatus.failure,
            isUploadRequested: true,
            shareUrl: ShareUrl.twitter,
          ),
          ShareState(
            compositeStatus: ShareStatus.loading,
            isUploadRequested: true,
            shareUrl: ShareUrl.twitter,
          ),
          ShareState(
            compositeStatus: ShareStatus.failure,
            uploadStatus: ShareStatus.initial,
            isUploadRequested: true,
            shareUrl: ShareUrl.twitter,
          ),
        ],
      );

      blocTest<ShareBloc, ShareState>(
        'emits [loading, failure] '
        'when composite status is failure and compositing succeeds '
        'but upload fails.',
        build: () {
          when(
            () => photosRepository.composite(
              width: any(named: 'width'),
              height: any(named: 'height'),
              data: any(named: 'data'),
              layers: any(named: 'layers'),
              aspectRatio: any(named: 'aspectRatio'),
            ),
          ).thenAnswer((_) async => imageData);
          when(
            () => photosRepository.sharePhoto(
              fileName: any(named: 'fileName'),
              data: any(named: 'data'),
              shareText: any(named: 'shareText'),
            ),
          ).thenThrow(Exception());
          return shareBloc;
        },
        seed: () => ShareState(compositeStatus: ShareStatus.failure),
        act: (bloc) => bloc.add(ShareOnTwitterTapped()),
        expect: () => [
          ShareState(
            compositeStatus: ShareStatus.failure,
            isUploadRequested: true,
            shareUrl: ShareUrl.twitter,
          ),
          ShareState(
            compositeStatus: ShareStatus.loading,
            isUploadRequested: true,
            shareUrl: ShareUrl.twitter,
          ),
          isA<ShareState>().having(
            (s) => s.compositeStatus,
            'compositeStatus',
            ShareStatus.success,
          ),
          isA<ShareState>().having(
            (s) => s.uploadStatus,
            'uploadStatus',
            ShareStatus.loading,
          ),
          isA<ShareState>().having(
            (s) => s.uploadStatus,
            'uploadStatus',
            ShareStatus.failure,
          ),
        ],
      );

      blocTest<ShareBloc, ShareState>(
        'emits [loading, success] '
        'when composite status is failure and compositing succeeds '
        'and upload succeeds.',
        build: () {
          when(
            () => photosRepository.composite(
              width: any(named: 'width'),
              height: any(named: 'height'),
              data: any(named: 'data'),
              layers: any(named: 'layers'),
              aspectRatio: any(named: 'aspectRatio'),
            ),
          ).thenAnswer((_) async => imageData);
          when(
            () => photosRepository.sharePhoto(
              fileName: any(named: 'fileName'),
              data: any(named: 'data'),
              shareText: any(named: 'shareText'),
            ),
          ).thenAnswer(
            (_) async => ShareUrls(
              explicitShareUrl: explicitShareUrl,
              facebookShareUrl: facebookShareUrl,
              twitterShareUrl: twitterShareUrl,
            ),
          );
          return shareBloc;
        },
        seed: () => ShareState(compositeStatus: ShareStatus.failure),
        act: (bloc) => bloc.add(ShareOnTwitterTapped()),
        expect: () => [
          ShareState(
            compositeStatus: ShareStatus.failure,
            isUploadRequested: true,
            shareUrl: ShareUrl.twitter,
          ),
          ShareState(
            compositeStatus: ShareStatus.loading,
            isUploadRequested: true,
            shareUrl: ShareUrl.twitter,
          ),
          isA<ShareState>().having(
            (s) => s.compositeStatus,
            'compositeStatus',
            ShareStatus.success,
          ),
          isA<ShareState>().having(
            (s) => s.uploadStatus,
            'uploadStatus',
            ShareStatus.loading,
          ),
          isA<ShareState>().having(
            (s) => s.uploadStatus,
            'uploadStatus',
            ShareStatus.success,
          ),
        ],
      );
    });

    group('ShareOnFacebookTapped', () {
      blocTest<ShareBloc, ShareState>(
        'does nothing when sharing is disabled',
        build: () => ShareBloc(
          photosRepository: photosRepository,
          imageId: imageId,
          image: image,
          assets: [photoAsset],
          shareText: shareText,
          aspectRatio: aspectRatio,
          isSharingEnabled: false,
        ),
        act: (bloc) => bloc.add(ShareOnFacebookTapped()),
        expect: () => [],
      );

      blocTest<ShareBloc, ShareState>(
        'sets isUploadRequested to true with correct shareUrl',
        build: () => shareBloc,
        seed: () => ShareState(compositeStatus: ShareStatus.loading),
        act: (bloc) => bloc.add(ShareOnFacebookTapped()),
        expect: () => [
          ShareState(
            compositeStatus: ShareStatus.loading,
            isUploadRequested: true,
            shareUrl: ShareUrl.facebook,
          ),
        ],
      );

      blocTest<ShareBloc, ShareState>(
        'emits [loading, failure] '
        'when composite status is success and upload fails',
        build: () {
          when(
            () => photosRepository.sharePhoto(
              fileName: any(named: 'fileName'),
              data: any(named: 'data'),
              shareText: any(named: 'shareText'),
            ),
          ).thenThrow(Exception());
          return shareBloc;
        },
        seed: () => ShareState(compositeStatus: ShareStatus.success),
        act: (bloc) => bloc.add(ShareOnFacebookTapped()),
        expect: () => [
          ShareState(
            compositeStatus: ShareStatus.success,
            isUploadRequested: true,
            shareUrl: ShareUrl.facebook,
          ),
          ShareState(
            compositeStatus: ShareStatus.success,
            uploadStatus: ShareStatus.loading,
            isUploadRequested: true,
            shareUrl: ShareUrl.facebook,
          ),
          isA<ShareState>().having(
            (s) => s.uploadStatus,
            'uploadStatus',
            ShareStatus.failure,
          ),
        ],
      );

      blocTest<ShareBloc, ShareState>(
        'emits [loading, success] '
        'when composite status is success and upload succeeds',
        build: () {
          when(
            () => photosRepository.sharePhoto(
              fileName: any(named: 'fileName'),
              data: any(named: 'data'),
              shareText: any(named: 'shareText'),
            ),
          ).thenAnswer(
            (_) async => ShareUrls(
              explicitShareUrl: explicitShareUrl,
              facebookShareUrl: facebookShareUrl,
              twitterShareUrl: twitterShareUrl,
            ),
          );
          return shareBloc;
        },
        seed: () => ShareState(
          compositeStatus: ShareStatus.success,
          bytes: imageData,
        ),
        act: (bloc) => bloc.add(ShareOnFacebookTapped()),
        expect: () => [
          ShareState(
            compositeStatus: ShareStatus.success,
            bytes: imageData,
            isUploadRequested: true,
            shareUrl: ShareUrl.facebook,
          ),
          ShareState(
            compositeStatus: ShareStatus.success,
            uploadStatus: ShareStatus.loading,
            bytes: imageData,
            isUploadRequested: true,
            shareUrl: ShareUrl.facebook,
          ),
          isA<ShareState>().having(
            (s) => s.uploadStatus,
            'uploadStatus',
            ShareStatus.success,
          ),
        ],
      );

      blocTest<ShareBloc, ShareState>(
        'emits [loading, failure] '
        'when composite status is failure and compositing fails',
        build: () {
          when(
            () => photosRepository.composite(
              width: any(named: 'width'),
              height: any(named: 'height'),
              data: any(named: 'data'),
              layers: any(named: 'layers'),
              aspectRatio: any(named: 'aspectRatio'),
            ),
          ).thenThrow(Exception());
          return shareBloc;
        },
        seed: () => ShareState(compositeStatus: ShareStatus.failure),
        act: (bloc) => bloc.add(ShareOnFacebookTapped()),
        expect: () => [
          ShareState(
            compositeStatus: ShareStatus.failure,
            isUploadRequested: true,
            shareUrl: ShareUrl.facebook,
          ),
          ShareState(
            compositeStatus: ShareStatus.loading,
            isUploadRequested: true,
            shareUrl: ShareUrl.facebook,
          ),
          ShareState(
            compositeStatus: ShareStatus.failure,
            uploadStatus: ShareStatus.initial,
            isUploadRequested: true,
            shareUrl: ShareUrl.facebook,
          ),
        ],
      );

      blocTest<ShareBloc, ShareState>(
        'emits [loading, failure] '
        'when composite status is failure and compositing succeeds '
        'but upload fails.',
        build: () {
          when(
            () => photosRepository.composite(
              width: any(named: 'width'),
              height: any(named: 'height'),
              data: any(named: 'data'),
              layers: any(named: 'layers'),
              aspectRatio: any(named: 'aspectRatio'),
            ),
          ).thenAnswer((_) async => imageData);
          when(
            () => photosRepository.sharePhoto(
              fileName: any(named: 'fileName'),
              data: any(named: 'data'),
              shareText: any(named: 'shareText'),
            ),
          ).thenThrow(Exception());
          return shareBloc;
        },
        seed: () => ShareState(compositeStatus: ShareStatus.failure),
        act: (bloc) => bloc.add(ShareOnFacebookTapped()),
        expect: () => [
          ShareState(
            compositeStatus: ShareStatus.failure,
            isUploadRequested: true,
            shareUrl: ShareUrl.facebook,
          ),
          ShareState(
            compositeStatus: ShareStatus.loading,
            isUploadRequested: true,
            shareUrl: ShareUrl.facebook,
          ),
          isA<ShareState>().having(
            (s) => s.compositeStatus,
            'compositeStatus',
            ShareStatus.success,
          ),
          isA<ShareState>().having(
            (s) => s.uploadStatus,
            'uploadStatus',
            ShareStatus.loading,
          ),
          isA<ShareState>().having(
            (s) => s.uploadStatus,
            'uploadStatus',
            ShareStatus.failure,
          ),
        ],
      );

      blocTest<ShareBloc, ShareState>(
        'emits [loading, success] '
        'when composite status is failure and compositing succeeds '
        'and upload succeeds.',
        build: () {
          when(
            () => photosRepository.composite(
              width: any(named: 'width'),
              height: any(named: 'height'),
              data: any(named: 'data'),
              layers: any(named: 'layers'),
              aspectRatio: any(named: 'aspectRatio'),
            ),
          ).thenAnswer((_) async => imageData);
          when(
            () => photosRepository.sharePhoto(
              fileName: any(named: 'fileName'),
              data: any(named: 'data'),
              shareText: any(named: 'shareText'),
            ),
          ).thenAnswer(
            (_) async => ShareUrls(
              explicitShareUrl: explicitShareUrl,
              facebookShareUrl: facebookShareUrl,
              twitterShareUrl: twitterShareUrl,
            ),
          );
          return shareBloc;
        },
        seed: () => ShareState(compositeStatus: ShareStatus.failure),
        act: (bloc) => bloc.add(ShareOnFacebookTapped()),
        expect: () => [
          ShareState(
            compositeStatus: ShareStatus.failure,
            isUploadRequested: true,
            shareUrl: ShareUrl.facebook,
          ),
          ShareState(
            compositeStatus: ShareStatus.loading,
            isUploadRequested: true,
            shareUrl: ShareUrl.facebook,
          ),
          isA<ShareState>().having(
            (s) => s.compositeStatus,
            'compositeStatus',
            ShareStatus.success,
          ),
          isA<ShareState>().having(
            (s) => s.uploadStatus,
            'uploadStatus',
            ShareStatus.loading,
          ),
          isA<ShareState>().having(
            (s) => s.uploadStatus,
            'uploadStatus',
            ShareStatus.success,
          ),
        ],
      );
    });
  });
}
