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

  /// Uploads photo to the [FirebaseStorage].
  Future<void> uploadPhoto(String photoName, Uint8List photoData) async {
    Reference reference;
    try {
      reference = _firebaseStorage.ref('uploads/$photoName');
    } catch (e, st) {
      throw UploadPhotoException(
        'Uploading photo $photoName failed. '
        'Couldn\'t get storage reference \'uploads/$photoName\'.'
        'Error: $e. StackTrace: $st',
      );
    }
    if (await _photoExists(reference)) return;
    try {
      await reference.putData(photoData);
    } catch (error, stackTrace) {
      throw UploadPhotoException(
        'Uploading photo $photoName failed. '
        'Couldn\'t upload data to ${reference.fullPath}.'
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
}
