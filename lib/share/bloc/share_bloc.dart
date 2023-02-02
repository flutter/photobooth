import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:cross_file/cross_file.dart';
import 'package:equatable/equatable.dart';
import 'package:image_compositor/image_compositor.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:photos_repository/photos_repository.dart';

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
    bool isSharingEnabled = const bool.fromEnvironment('SHARING_ENABLED'),
  })  : _photosRepository = photosRepository,
        _isSharingEnabled = isSharingEnabled,
        super(const ShareState()) {
    on<ShareViewLoaded>(_onShareViewLoaded);
    on<ShareTapped>(_onShareTapped);
    on<_ShareCompositeSucceeded>(_onShareCompositeSucceeded);
    on<_ShareCompositeFailed>(
      (event, emit) => emit(
        state.copyWith(
          compositeStatus: ShareStatus.failure,
        ),
      ),
    );
  }

  final PhotosRepository _photosRepository;
  final String imageId;
  final CameraImage image;
  final List<PhotoAsset> assets;
  final double aspectRatio;
  final bool _isSharingEnabled;
  final String shareText;

  void _onShareViewLoaded(
    ShareViewLoaded event,
    Emitter<ShareState> emit,
  ) {
    emit(state.copyWith(compositeStatus: ShareStatus.loading));
    unawaited(
      _composite().then(
        (value) => add(_ShareCompositeSucceeded(bytes: value)),
        onError: (_) => add(const _ShareCompositeFailed()),
      ),
    );
  }

  Future<void> _onShareTapped(
    ShareTapped event,
    Emitter<ShareState> emit,
  ) async {
    if (!_isSharingEnabled) return;

    final shareUrl =
        event is ShareOnTwitterTapped ? ShareUrl.twitter : ShareUrl.facebook;

    emit(
      state.copyWith(
        uploadStatus: ShareStatus.initial,
        isDownloadRequested: false,
        isUploadRequested: true,
        shareUrl: shareUrl,
      ),
    );

    if (state.compositeStatus.isLoading) return;
    if (state.uploadStatus.isLoading) return;
    if (state.uploadStatus.isSuccess) return;

    if (state.compositeStatus.isFailure) {
      emit(
        state.copyWith(
          compositeStatus: ShareStatus.loading,
          uploadStatus: ShareStatus.initial,
          isDownloadRequested: false,
          isUploadRequested: true,
          shareUrl: shareUrl,
        ),
      );

      unawaited(
        _composite().then(
          (value) => add(_ShareCompositeSucceeded(bytes: value)),
          onError: (_) => add(const _ShareCompositeFailed()),
        ),
      );
    } else if (state.compositeStatus.isSuccess) {
      emit(
        state.copyWith(
          uploadStatus: ShareStatus.loading,
          isDownloadRequested: false,
          isUploadRequested: true,
          shareUrl: shareUrl,
        ),
      );

      try {
        final shareUrls = await _photosRepository.sharePhoto(
          fileName: _getPhotoFileName(imageId),
          data: state.bytes!,
          shareText: shareText,
        );
        emit(
          state.copyWith(
            uploadStatus: ShareStatus.success,
            isDownloadRequested: false,
            isUploadRequested: true,
            file: state.file,
            bytes: state.bytes,
            explicitShareUrl: shareUrls.explicitShareUrl,
            facebookShareUrl: shareUrls.facebookShareUrl,
            twitterShareUrl: shareUrls.twitterShareUrl,
            shareUrl: shareUrl,
          ),
        );
      } catch (_) {
        emit(
          state.copyWith(
            uploadStatus: ShareStatus.failure,
            isDownloadRequested: false,
            shareUrl: shareUrl,
          ),
        );
      }
    }
  }

  Future<void> _onShareCompositeSucceeded(
    _ShareCompositeSucceeded event,
    Emitter<ShareState> emit,
  ) async {
    final file = XFile.fromData(
      event.bytes,
      mimeType: 'image/png',
      name: _getPhotoFileName(imageId),
    );
    final bytes = event.bytes;

    emit(
      state.copyWith(
        compositeStatus: ShareStatus.success,
        bytes: bytes,
        file: file,
      ),
    );

    if (state.isUploadRequested) {
      emit(
        state.copyWith(
          uploadStatus: ShareStatus.loading,
          bytes: bytes,
          file: file,
          isDownloadRequested: false,
          isUploadRequested: true,
        ),
      );

      try {
        final shareUrls = await _photosRepository.sharePhoto(
          fileName: _getPhotoFileName(imageId),
          data: event.bytes,
          shareText: shareText,
        );
        emit(
          state.copyWith(
            compositeStatus: ShareStatus.success,
            uploadStatus: ShareStatus.success,
            isDownloadRequested: false,
            isUploadRequested: true,
            bytes: bytes,
            file: file,
            explicitShareUrl: shareUrls.explicitShareUrl,
            facebookShareUrl: shareUrls.facebookShareUrl,
            twitterShareUrl: shareUrls.twitterShareUrl,
          ),
        );
      } catch (_) {
        emit(
          state.copyWith(
            compositeStatus: ShareStatus.success,
            uploadStatus: ShareStatus.failure,
            bytes: bytes,
            file: file,
            isDownloadRequested: false,
          ),
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
