import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:photos_repository/photos_repository.dart';

part 'share_event.dart';
part 'share_state.dart';

class ShareBloc extends Bloc<ShareEvent, ShareState> {
  ShareBloc({
    required PhotosRepository photosRepository,
    bool isSharingEnabled = false,
  })  : _photosRepository = photosRepository,
        _isSharingEnabled = isSharingEnabled,
        super(const ShareState.initial());

  final PhotosRepository _photosRepository;
  final bool _isSharingEnabled;

  @override
  Stream<ShareState> mapEventToState(
    ShareEvent event,
  ) async* {
    if (event is ShareOnTwitterTapped) {
      yield* _mapShareOnTwitterTappedToState(event);
    } else if (event is ShareOnFacebookTapped) {
      yield* _mapShareOnFacebookTappedToState(event);
    }
  }

  Stream<ShareState> _mapShareOnTwitterTappedToState(
    ShareOnTwitterTapped event,
  ) async* {
    if (!_isSharingEnabled) return;
    yield const ShareState.loading();
    try {
      final photoFileName = _getPhotoFileName(event.imageId);
      final data = _getBytes(event.image.data);

      await _photosRepository.uploadPhoto(photoFileName, data);

      final shareUrl = _photosRepository.twitterShareUrl(
        photoFileName,
        event.shareText,
      );

      yield ShareState.success(shareUrl: shareUrl);
    } catch (e, st) {
      yield const ShareState.error();
      addError(e, st);
    }
  }

  Stream<ShareState> _mapShareOnFacebookTappedToState(
    ShareOnFacebookTapped event,
  ) async* {
    if (!_isSharingEnabled) return;
    yield const ShareState.loading();
    try {
      final photoFileName = _getPhotoFileName(event.imageId);
      final data = _getBytes(event.image.data);

      await _photosRepository.uploadPhoto(photoFileName, data);

      final shareUrl = _photosRepository.facebookShareUrl(
        photoFileName,
        event.shareText,
      );

      yield ShareState.success(shareUrl: shareUrl);
    } catch (e, st) {
      yield const ShareState.error();
      addError(e, st);
    }
  }

  String _getPhotoFileName(String photoName) => '$photoName.jpg';

  Uint8List _getBytes(String dataUri) {
    return Uint8List.fromList(base64.decode(dataUri.split(',')[1]));
  }
}
