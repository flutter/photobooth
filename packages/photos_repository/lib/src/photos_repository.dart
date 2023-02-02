import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_compositor/image_compositor.dart';

/// {@template upload_photo_exception}
/// Exception thrown when upload photo operation failed.
///
/// It contains a [message] field which describes the error.
/// {@endtemplate}
class UploadPhotoException implements Exception {
  /// {@macro upload_photo_exception}
  const UploadPhotoException(this.message);

  /// Description of the failure
  final String message;

  @override
  String toString() => message;
}

/// {@template composite_photo_exception}
/// Exception thrown when composite photo operation failed.
///
/// It contains a [message] field which describes the error.
/// {@endtemplate}
class CompositePhotoException implements Exception {
  /// {@macro composite_photo_exception}
  const CompositePhotoException(this.message);

  /// Description of the failure
  final String message;

  @override
  String toString() => message;
}

/// {@template share_urls}
/// A list of social share urls which are returned by the `sharePhoto` API.
/// {@endtemplate}
class ShareUrls {
  /// {@macro share_urls}
  const ShareUrls({
    required this.explicitShareUrl,
    required this.facebookShareUrl,
    required this.twitterShareUrl,
  });

  /// The share url for explicit sharing.
  final String explicitShareUrl;

  /// The share url for sharing on Facebook.
  final String facebookShareUrl;

  /// The share url for sharing on Twitter.
  final String twitterShareUrl;
}

const _shareUrl = 'https://io-photobooth-dev.web.app/share';

/// {@template photos_repository}
/// Repository that persists photos in a Firebase Storage.
/// {@endtemplate
class PhotosRepository {
  /// {@macro photos_repository}
  PhotosRepository({
    required FirebaseStorage firebaseStorage,
    ImageCompositor? imageCompositor,
  })  : _firebaseStorage = firebaseStorage,
        _imageCompositor = imageCompositor ?? ImageCompositor();

  final FirebaseStorage _firebaseStorage;
  final ImageCompositor _imageCompositor;

  /// Uploads photo to the [FirebaseStorage] if it doesn't already exist
  /// and returns [ShareUrls].
  Future<ShareUrls> sharePhoto({
    required String fileName,
    required Uint8List data,
    required String shareText,
  }) async {
    Reference reference;
    try {
      reference = _firebaseStorage.ref('uploads/$fileName');
    } catch (e, st) {
      throw UploadPhotoException(
        'Uploading photo $fileName failed. '
        "Couldn't get storage reference 'uploads/$fileName'.\n"
        'Error: $e. StackTrace: $st',
      );
    }

    if (await _photoExists(reference)) {
      return ShareUrls(
        explicitShareUrl: _getSharePhotoUrl(fileName),
        facebookShareUrl: _facebookShareUrl(fileName, shareText),
        twitterShareUrl: _twitterShareUrl(fileName, shareText),
      );
    }

    try {
      await reference.putData(data);
    } catch (error, stackTrace) {
      throw UploadPhotoException(
        'Uploading photo $fileName failed. '
        "Couldn't upload data to ${reference.fullPath}.\n"
        'Error: $error. StackTrace: $stackTrace',
      );
    }

    return ShareUrls(
      explicitShareUrl: _getSharePhotoUrl(fileName),
      facebookShareUrl: _facebookShareUrl(fileName, shareText),
      twitterShareUrl: _twitterShareUrl(fileName, shareText),
    );
  }

  /// Given an image ([data]) with the provided [layers]
  /// it will return a ByteArray ([Uint8List]) which represents a
  /// composite of the original [data] and [layers] which is cropped for
  /// the provided [aspectRatio].
  Future<Uint8List> composite({
    required int width,
    required int height,
    required String data,
    required List<CompositeLayer> layers,
    required double aspectRatio,
  }) async {
    try {
      final image = await _imageCompositor.composite(
        data: data,
        width: width,
        height: height,
        layers: layers.map((l) => l.toJson()).toList(),
        aspectRatio: aspectRatio,
      );
      return Uint8List.fromList(image);
    } catch (error, stackTrace) {
      throw CompositePhotoException(
        'compositing photo failed. '
        'Error: $error. StackTrace: $stackTrace',
      );
    }
  }

  Future<bool> _photoExists(Reference reference) async {
    try {
      await reference.getDownloadURL();
      return true;
    } catch (_) {
      return false;
    }
  }

  String _twitterShareUrl(String photoName, String shareText) {
    final encodedShareText = Uri.encodeComponent(shareText);
    return 'https://twitter.com/intent/tweet?url=${_getSharePhotoUrl(photoName)}&text=$encodedShareText';
  }

  String _facebookShareUrl(String photoName, String shareText) {
    final encodedShareText = Uri.encodeComponent(shareText);
    return 'https://www.facebook.com/sharer.php?u=${_getSharePhotoUrl(photoName)}&quote=$encodedShareText';
  }

  String _getSharePhotoUrl(String photoName) => '$_shareUrl/$photoName';
}
