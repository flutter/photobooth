import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:photos_repository/photos_repository.dart';
import 'package:share_photo_repository/share_photo_repository.dart';

part 'share_event.dart';
part 'share_state.dart';

class ShareBloc extends Bloc<ShareEvent, ShareState> {
  ShareBloc({
    required SharePhotoRepository sharePhotoRepository,
    required PhotosRepository photosRepository,
  })  : _sharePhotoRepository = sharePhotoRepository,
        _photosRepository = photosRepository,
        super(const ShareState.initial());

  final SharePhotoRepository _sharePhotoRepository;
  final PhotosRepository _photosRepository;

  @override
  Stream<ShareState> mapEventToState(
    ShareEvent event,
  ) async* {
    if (event is ShareOnTwitter) {
      yield* _mapShareOnTwitterToState(event);
    } else if (event is ShareOnFacebook) {
      yield* _mapShareOnFacebookToState(event);
    }
  }

  Stream<ShareState> _mapShareOnTwitterToState(ShareOnTwitter event) async* {
    yield const ShareState.loading();
    try {
      final photoFileName = _getPhotoFileName(event.imageName);
      final data = _getBytes(event.image.data);
      await _photosRepository.uploadPhoto(photoFileName, data);

      var shareUrl = '';
      if (_sharePhotoRepository.isSharingEnabled) {
        shareUrl = _sharePhotoRepository.getShareOnTwitterUrl(
          photoFileName,
          event.shareText,
        );
      }

      yield ShareState.success(shareUrl: shareUrl);
    } catch (e, st) {
      yield const ShareState.error();
      addError(e, st);
    }
  }

  Stream<ShareState> _mapShareOnFacebookToState(ShareOnFacebook event) async* {
    yield const ShareState.loading();
    try {
      final photoFileName = _getPhotoFileName(event.imageName);
      final data = _getBytes(event.image.data);
      await _photosRepository.uploadPhoto(photoFileName, data);

      var shareUrl = '';
      if (_sharePhotoRepository.isSharingEnabled) {
        shareUrl = _sharePhotoRepository.getShareOnFacebookUrl(
          photoFileName,
          event.shareText,
        );
      }

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
