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
/// {@endtemplate}
class PhotosRepository {
  /// {@macro photos_repository}
  const PhotosRepository({
    required FirebaseStorage firebaseStorage,
    required String Function() uuidGenerator,
  })  : _firebaseStorage = firebaseStorage,
        _uuidGenerator = uuidGenerator;

  /// An instance of the Firebase Storage
  final FirebaseStorage _firebaseStorage;

  /// A function that generates UUID string
  final String Function() _uuidGenerator;

  /// Uploads photo to the [FirebaseStorage].
  Future<void> uploadPhoto(String userId, Uint8List photoData) async {
    String uuid;
    try {
      uuid = _uuidGenerator();
    } catch (e, st) {
      throw UploadPhotoException(
        'Uploading photo for user $userId failed. '
        'Couldn\'t generate UUID. '
        'Error: $e. StackTrace: $st',
      );
    }

    Reference reference;
    try {
      reference = _firebaseStorage.ref('uploads/$userId/$uuid.jpg');
    } catch (e, st) {
      throw UploadPhotoException(
        'Uploading photo for user $userId failed. '
        'Couldn\'t get storage reference \'uploads/$userId/$uuid.jpg\'.'
        'Error: $e. StackTrace: $st',
      );
    }

    try {
      await reference.putData(photoData);
    } catch (e, st) {
      throw UploadPhotoException(
        'Uploading photo for user $userId failed. '
        'Couldn\'t upload data to ${reference.fullPath}.'
        'Error: $e. StackTrace: $st',
      );
    }
  }
}
