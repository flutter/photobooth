// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photos_repository/photos_repository.dart';

class MockFirebaseStorage extends Mock
    implements firebase_storage.FirebaseStorage {}

class MockReference extends Mock implements firebase_storage.Reference {}

class MockUploadTask extends Mock implements firebase_storage.UploadTask {}

class MockTaskSnapshot extends Mock implements firebase_storage.TaskSnapshot {}

class FakeUint8List extends Fake implements Uint8List {}

class FakeSettableMetadata extends Fake
    implements firebase_storage.SettableMetadata {}

typedef UploadTaskSnapshot = FutureOr<firebase_storage.TaskSnapshot> Function(
  firebase_storage.TaskSnapshot,
);

void main() {
  setUpAll(() {
    registerFallbackValue<Uint8List>(FakeUint8List());
    registerFallbackValue<firebase_storage.UploadTask>(MockUploadTask());
    registerFallbackValue<firebase_storage.TaskSnapshot>(MockTaskSnapshot());
    registerFallbackValue<firebase_storage.SettableMetadata>(
      FakeSettableMetadata(),
    );
    registerFallbackValue<UploadTaskSnapshot>((_) async => MockTaskSnapshot());
  });

  group('UploadPhotoException', () {
    test('sets message', () {
      final exception = UploadPhotoException('msg');
      expect(exception.message, 'msg');
    });

    test('overrides toString with message', () {
      final exception = UploadPhotoException('msg');
      expect(exception.toString(), 'msg');
    });
  });

  group('PhotosRepository', () {
    late firebase_storage.FirebaseStorage firebaseStorage;
    late PhotosRepository photosRepository;

    late firebase_storage.Reference reference;
    late firebase_storage.UploadTask uploadTask;
    late firebase_storage.TaskSnapshot taskSnapshot;

    const userId = 'mock-user-id';
    const uuid = 'mock-uuid';
    final photoData = Uint8List(0);

    const referenceFullPath = 'photos/$userId/$uuid.jpg';

    setUp(() {
      firebaseStorage = MockFirebaseStorage();
      photosRepository = PhotosRepository(
        firebaseStorage: firebaseStorage,
        uuidGenerator: () => uuid,
      );

      reference = MockReference();
      uploadTask = MockUploadTask();
      taskSnapshot = MockTaskSnapshot();

      when(() => firebaseStorage.ref(any())).thenReturn(reference);
      when(() => reference.putData(any())).thenAnswer((_) => uploadTask);
      when(() => reference.fullPath).thenReturn(referenceFullPath);
      when(
        () => uploadTask.then<firebase_storage.TaskSnapshot>(
          any(),
          onError: any(named: 'onError'),
        ),
      ).thenAnswer((invocation) async {
        (invocation.positionalArguments.first as Function).call(taskSnapshot);
        return taskSnapshot;
      });
    });

    group('uploadPhoto', () {
      test('calls firebaseStorage.ref with appropriate path', () async {
        await photosRepository.uploadPhoto(userId, photoData);
        verify(() => firebaseStorage.ref('photos/$userId/$uuid.jpg')).called(1);
      });

      test('calls putData on reference', () async {
        await photosRepository.uploadPhoto(userId, photoData);
        verify(() => reference.putData(photoData)).called(1);
      });

      test(
          'throws UploadPhotoException '
          'when uuid generator throws', () async {
        photosRepository = PhotosRepository(
          firebaseStorage: firebaseStorage,
          uuidGenerator: () => throw Exception(),
        );

        expect(
          () async => await photosRepository.uploadPhoto(userId, photoData),
          throwsA(isA<UploadPhotoException>()),
        );
      });

      test(
          'throws UploadPhotoException '
          'when firebaseStorage.ref throws', () async {
        when(() => firebaseStorage.ref(any())).thenThrow(() => Exception());

        expect(
          () async => await photosRepository.uploadPhoto(userId, photoData),
          throwsA(isA<UploadPhotoException>()),
        );
      });

      test(
          'throws UploadPhotoException '
          'when reference.putData throws', () async {
        when(() => reference.putData(photoData)).thenThrow(() => Exception());
        expect(
          () async => await photosRepository.uploadPhoto(userId, photoData),
          throwsA(isA<UploadPhotoException>()),
        );
      });
    });
  });
}
