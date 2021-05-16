import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:cross_file/cross_file.dart';
import 'package:equatable/equatable.dart';
import 'package:image_compositor/image_compositor.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:photos_repository/photos_repository.dart';
import 'package:very_good_analysis/very_good_analysis.dart';

part 'share_event.dart';
part 'share_state.dart';

class ShareBloc extends Bloc<ShareEvent, ShareState> {
  ShareBloc({
    required PhotosRepository photosRepository,
    required this.imageId,
    required this.image,
    required this.assets,
    required this.aspectRatio,
    required this.shareText,
    bool isSharingEnabled = const bool.fromEnvironment(
      'SHARING_ENABLED',
      defaultValue: false,
    ),
  })  : _photosRepository = photosRepository,
        _isSharingEnabled = isSharingEnabled,
        super(const ShareState());

  final PhotosRepository _photosRepository;
  final String imageId;
  final CameraImage image;
  final List<PhotoAsset> assets;
  final double aspectRatio;
  final bool _isSharingEnabled;
  final String shareText;

  @override
  Stream<ShareState> mapEventToState(ShareEvent event) async* {
    if (event is ShareViewLoaded) {
      yield* _mapShareViewLoadedToState(event, state);
    } else if (event is ShareTapped) {
      yield* _mapShareTappedToState(event, state);
    } else if (event is _ShareCompositeSucceeded) {
      yield* _mapShareCompositeSucceededToState(event, state);
    } else if (event is _ShareCompositeFailed) {
      yield state.copyWith(compositeStatus: ShareStatus.failure);
    }
  }

  Stream<ShareState> _mapShareViewLoadedToState(
    ShareViewLoaded event,
    ShareState state,
  ) async* {
    yield state.copyWith(compositeStatus: ShareStatus.loading);
    unawaited(
      _composite().then(
        (value) => add(_ShareCompositeSucceeded(bytes: value)),
        onError: (_) => add(const _ShareCompositeFailed()),
      ),
    );
  }

  Stream<ShareState> _mapShareTappedToState(
    ShareTapped event,
    ShareState state,
  ) async* {
    if (!_isSharingEnabled) return;

    final shareUrl =
        event is ShareOnTwitterTapped ? ShareUrl.twitter : ShareUrl.facebook;

    yield state.copyWith(
      uploadStatus: ShareStatus.initial,
      isDownloadRequested: false,
      isUploadRequested: true,
      shareUrl: shareUrl,
    );

    if (state.compositeStatus.isLoading) return;
    if (state.uploadStatus.isLoading) return;
    if (state.uploadStatus.isSuccess) return;

    if (state.compositeStatus.isFailure) {
      yield state.copyWith(
        compositeStatus: ShareStatus.loading,
        uploadStatus: ShareStatus.initial,
        isDownloadRequested: false,
        isUploadRequested: true,
        shareUrl: shareUrl,
      );

      unawaited(
        _composite().then(
          (value) => add(_ShareCompositeSucceeded(bytes: value)),
          onError: (_) => add(const _ShareCompositeFailed()),
        ),
      );
    } else if (state.compositeStatus.isSuccess) {
      yield state.copyWith(
        uploadStatus: ShareStatus.loading,
        isDownloadRequested: false,
        isUploadRequested: true,
        shareUrl: shareUrl,
      );

      try {
        final shareUrls = await _photosRepository.sharePhoto(
          fileName: _getPhotoFileName(imageId),
          data: state.bytes!,
          shareText: shareText,
        );
        yield state.copyWith(
          uploadStatus: ShareStatus.success,
          isDownloadRequested: false,
          isUploadRequested: true,
          file: state.file,
          bytes: state.bytes,
          explicitShareUrl: shareUrls.explicitShareUrl,
          facebookShareUrl: shareUrls.facebookShareUrl,
          twitterShareUrl: shareUrls.twitterShareUrl,
          shareUrl: shareUrl,
        );
      } catch (_) {
        yield state.copyWith(
          uploadStatus: ShareStatus.failure,
          isDownloadRequested: false,
          shareUrl: shareUrl,
        );
      }
    }
  }

  Stream<ShareState> _mapShareCompositeSucceededToState(
    _ShareCompositeSucceeded event,
    ShareState state,
  ) async* {
    final file = XFile.fromData(
      event.bytes,
      mimeType: 'image/png',
      name: _getPhotoFileName(imageId),
    );
    final bytes = event.bytes;

    yield state.copyWith(
      compositeStatus: ShareStatus.success,
      bytes: bytes,
      file: file,
    );

    if (state.isUploadRequested) {
      yield state.copyWith(
        uploadStatus: ShareStatus.loading,
        bytes: bytes,
        file: file,
        isDownloadRequested: false,
        isUploadRequested: true,
      );

      try {
        final shareUrls = await _photosRepository.sharePhoto(
          fileName: _getPhotoFileName(imageId),
          data: event.bytes,
          shareText: shareText,
        );
        yield state.copyWith(
          compositeStatus: ShareStatus.success,
          uploadStatus: ShareStatus.success,
          isDownloadRequested: false,
          isUploadRequested: true,
          bytes: bytes,
          file: file,
          explicitShareUrl: shareUrls.explicitShareUrl,
          facebookShareUrl: shareUrls.facebookShareUrl,
          twitterShareUrl: shareUrls.twitterShareUrl,
        );
      } catch (_) {
        yield state.copyWith(
          compositeStatus: ShareStatus.success,
          uploadStatus: ShareStatus.failure,
          bytes: bytes,
          file: file,
          isDownloadRequested: false,
        );
      }
    }
  }

  Future<Uint8List> _composite() async {
    final composite = await _photosRepository.composite(
      aspectRatio: aspectRatio,
      data: image.data,
      width: image.width,
      height: image.height,
      layers: [
        ...assets.map(
          (l) => CompositeLayer(
            angle: l.angle,
            assetPath: 'assets/${l.asset.path}',
            constraints: Vector2D(l.constraint.width, l.constraint.height),
            position: Vector2D(l.position.dx, l.position.dy),
            size: Vector2D(l.size.width, l.size.height),
          ),
        )
      ],
    );
    return Uint8List.fromList(composite);
  }

  String _getPhotoFileName(String photoName) => '$photoName.png';
}
