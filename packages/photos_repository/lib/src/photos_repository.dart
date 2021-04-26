import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

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

/// {@template photos_repository}
/// Repository that persists photos in a Firebase Storage.
/// {@endtemplate
class PhotosRepository {
  /// {@macro photos_repository}
  const PhotosRepository({
    required FirebaseStorage firebaseStorage,
  }) : _firebaseStorage = firebaseStorage;

  /// An instance of the Firebase Storage
  final FirebaseStorage _firebaseStorage;

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

    try {
      await reference.putData(photoData);
    } catch (e, st) {
      throw UploadPhotoException(
        'Uploading photo $photoName failed. '
        'Couldn\'t upload data to ${reference.fullPath}.'
        'Error: $e. StackTrace: $st',
      );
    }
  }
}
