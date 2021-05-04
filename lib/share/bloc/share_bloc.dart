import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:file_selector/file_selector.dart';
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
    bool isSharingEnabled = true,
  })  : _photosRepository = photosRepository,
        _isSharingEnabled = isSharingEnabled,
        super(const ShareInitial());

  final PhotosRepository _photosRepository;
  final String imageId;
  final CameraImage image;
  final List<PhotoAsset> assets;
  final bool _isSharingEnabled;

  @override
  Stream<ShareState> mapEventToState(ShareEvent event) async* {
    if (event is ShareViewLoaded) {
      yield* _mapShareViewLoadedToState(event, state);
    } else if (event is ShareDownloadTapped) {
      yield* _mapShareDownloadTappedToState(event, state);
    } else if (event is ShareTapped) {
      yield* _mapShareTappedToState(event, state);
    } else if (event is _ShareCompositeSucceeded) {
      final file = XFile.fromData(
        event.bytes,
        mimeType: 'image/jpeg',
        name: '$imageId.jpg',
      );
      yield state is ShareCompositeInProgressAndDownloadRequested
          ? ShareCompositeSuccessAndDownloadRequested(
              bytes: event.bytes,
              file: file,
            )
          : ShareCompositeSuccess(bytes: event.bytes, file: file);
    } else if (event is _ShareCompositeFailed) {
      yield const ShareCompositeFailure();
    }
  }

  Stream<ShareState> _mapShareViewLoadedToState(
    ShareViewLoaded event,
    ShareState state,
  ) async* {
    if (state is! ShareInitial) return;
    yield const ShareCompositeInProgress();

    unawaited(
      _composite().then(
        (value) => add(_ShareCompositeSucceeded(bytes: value)),
        onError: (_) => add(const _ShareCompositeFailed()),
      ),
    );
  }

  Stream<ShareState> _mapShareDownloadTappedToState(
    ShareDownloadTapped event,
    ShareState state,
  ) async* {
    if (state is ShareCompositeInProgress) {
      yield const ShareCompositeInProgressAndDownloadRequested();
    } else if (state is ShareCompositeSuccess) {
      yield ShareCompositeSuccessAndDownloadRequested(
        file: state.file,
        bytes: state.bytes,
      );
    } else if (state is ShareCompositeFailure) {
      yield const ShareCompositeInProgressAndUploadRequested();
      unawaited(
        _composite().then(
          (value) => add(_ShareCompositeSucceeded(bytes: value)),
          onError: (_) => add(const _ShareCompositeFailed()),
        ),
      );
    }
  }

  Stream<ShareState> _mapShareTappedToState(
    ShareTapped event,
    ShareState state,
  ) async* {
    if (!_isSharingEnabled) return;
    if (state is ShareUploadInProgress) return;
    if (state is ShareUploadSuccess) return;

    if (state is ShareCompositeInProgress) {
      yield const ShareCompositeInProgressAndUploadRequested();
    } else if (state is ShareCompositeFailure) {
      unawaited(
        _composite().then(
          (value) => add(_ShareCompositeSucceeded(bytes: value)),
          onError: (_) => add(const _ShareCompositeFailed()),
        ),
      );
    } else if (state is ShareCompositeSuccess) {
      yield ShareUploadInProgress(file: state.file, bytes: state.bytes);
      try {
        final shareUrls = await _photosRepository.sharePhoto(
          fileName: _getPhotoFileName(imageId),
          data: state.bytes,
          shareText: event.shareText,
        );
        yield event is ShareOnTwitterTapped
            ? ShareOnTwitterSuccess(
                file: state.file,
                bytes: state.bytes,
                facebookShareUrl: shareUrls.facebookShareUrl,
                twitterShareUrl: shareUrls.twitterShareUrl,
              )
            : ShareOnFacebookSuccess(
                file: state.file,
                bytes: state.bytes,
                facebookShareUrl: shareUrls.facebookShareUrl,
                twitterShareUrl: shareUrls.twitterShareUrl,
              );
      } catch (error, stackTrace) {
        yield ShareUploadFailure(file: state.file, bytes: state.bytes);
        addError(error, stackTrace);
      }
    }
  }

  Future<Uint8List> _composite() async {
    final composite = await _photosRepository.composite(
      aspectRatio: image.aspectRatio(),
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
            scale: l.scale,
            size: Vector2D(l.size.width, l.size.height),
          ),
        )
      ],
    );
    return Uint8List.fromList(composite);
  }

  String _getPhotoFileName(String photoName) => '$photoName.jpg';
}

extension on CameraImage {
  double aspectRatio() => width > height ? 4 / 3 : 3 / 4;
}
