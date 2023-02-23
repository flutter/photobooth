// ignore_for_file: prefer_const_constructors
// ignore_for_file: avoid_dynamic_calls
import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_test/flutter_test.dart';
import 'package:image_compositor/image_compositor.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photos_repository/photos_repository.dart';

class MockImageCompositor extends Mock implements ImageCompositor {}

class MockFirebaseStorage extends Mock
    implements firebase_storage.FirebaseStorage {}

class MockReference extends Mock implements firebase_storage.Reference {}

class MockUploadTask extends Mock implements firebase_storage.UploadTask {}

class MockTaskSnapshot extends Mock implements firebase_storage.TaskSnapshot {}

class FakeSettableMetadata extends Fake
    implements firebase_storage.SettableMetadata {}

typedef UploadTaskSnapshot = FutureOr<firebase_storage.TaskSnapshot> Function(
  firebase_storage.TaskSnapshot,
);

void main() {
  setUpAll(() {
    registerFallbackValue(Uint8List(0));
    registerFallbackValue(MockUploadTask());
    registerFallbackValue(MockTaskSnapshot());
    registerFallbackValue(FakeSettableMetadata());
    registerFallbackValue((_) async => MockTaskSnapshot());
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
    late ImageCompositor imageCompositor;
    late firebase_storage.FirebaseStorage firebaseStorage;
    late PhotosRepository photosRepository;

    late firebase_storage.Reference reference;
    late firebase_storage.UploadTask uploadTask;
    late firebase_storage.TaskSnapshot taskSnapshot;

    const photoName = 'photo.jpg';
    final photoData = Uint8List(0);

    const referenceFullPath = 'uploads/$photoName';
    const shareText = 'Share text';

    setUp(() {
      imageCompositor = MockImageCompositor();
      firebaseStorage = MockFirebaseStorage();
      photosRepository = PhotosRepository(
        firebaseStorage: firebaseStorage,
      );

      reference = MockReference();
      uploadTask = MockUploadTask();
      taskSnapshot = MockTaskSnapshot();

      when(() => firebaseStorage.ref(any())).thenReturn(reference);
      when(() => reference.putData(any())).thenAnswer((_) => uploadTask);
      when(() => reference.fullPath).thenReturn(referenceFullPath);
      when(
        () => uploadTask.then<dynamic>(
          any(),
          onError: any(named: 'onError'),
        ),
      ).thenAnswer((invocation) async {
        (invocation.positionalArguments.first as Function).call(taskSnapshot);
        return taskSnapshot;
      });
    });

    group('sharePhoto', () {
      test('calls firebaseStorage.ref with appropriate path', () async {
        await photosRepository.sharePhoto(
          fileName: photoName,
          data: photoData,
          shareText: shareText,
        );
        verify(() => firebaseStorage.ref('uploads/$photoName')).called(1);
      });

      test('calls putData on reference', () async {
        await photosRepository.sharePhoto(
          fileName: photoName,
          data: photoData,
          shareText: shareText,
        );
        verify(() => reference.putData(photoData)).called(1);
      });

      test('does not putData when reference already exists', () async {
        when(() => reference.getDownloadURL()).thenAnswer((_) async => 'url');
        await photosRepository.sharePhoto(
          fileName: photoName,
          data: photoData,
          shareText: shareText,
        );
        verifyNever(() => reference.putData(photoData));
      });

      test('returns correct share urls', () async {
        final shareUrls = await photosRepository.sharePhoto(
          fileName: photoName,
          data: photoData,
          shareText: shareText,
        );
        expect(
          shareUrls.explicitShareUrl,
          equals(
            'https://io-photobooth-dev.web.app/share/photo.jpg',
          ),
        );
        expect(
          shareUrls.facebookShareUrl,
          equals(
            'https://www.facebook.com/sharer.php?u=https://io-photobooth-dev.web.app/share/photo.jpg&quote=Share%20text',
          ),
        );
        expect(
          shareUrls.twitterShareUrl,
          equals(
            'https://twitter.com/intent/tweet?url=https://io-photobooth-dev.web.app/share/photo.jpg&text=Share%20text',
          ),
        );
      });

      test(
          'throws UploadPhotoException '
          'when firebaseStorage.ref throws', () async {
        when(() => firebaseStorage.ref(any())).thenThrow(Exception.new);

        expect(
          () => photosRepository.sharePhoto(
            fileName: photoName,
            data: photoData,
            shareText: shareText,
          ),
          throwsA(isA<UploadPhotoException>()),
        );
      });

      test(
          'throws UploadPhotoException '
          'when reference.putData throws', () async {
        when(() => reference.putData(photoData)).thenThrow(Exception.new);
        expect(
          () => photosRepository.sharePhoto(
            fileName: photoName,
            data: photoData,
            shareText: shareText,
          ),
          throwsA(isA<UploadPhotoException>()),
        );
      });
    });

    group('composite', () {
      const image = <int>[];
      const data = '';
      const width = 4;
      const height = 4;
      const layers = [
        CompositeLayer(
          angle: 0,
          assetPath: 'path',
          constraints: Vector2D(1, 2),
          position: Vector2D(3, 4),
          size: Vector2D(5, 6),
        ),
      ];
      const aspectRatio = 4 / 3;

      setUp(() {
        when(
          () => imageCompositor.composite(
            data: any(named: 'data'),
            width: any(named: 'width'),
            height: any(named: 'height'),
            layers: any(named: 'layers'),
            aspectRatio: any(named: 'aspectRatio'),
          ),
        ).thenAnswer((_) async => image);
        photosRepository = PhotosRepository(
          firebaseStorage: firebaseStorage,
          imageCompositor: imageCompositor,
        );
      });

      test('invokes composite api on ImageCompositor with serialized data',
          () async {
        final actual = await photosRepository.composite(
          width: width,
          height: height,
          data: data,
          layers: layers,
          aspectRatio: aspectRatio,
        );

        expect(actual, equals(image));

        verify(
          () => imageCompositor.composite(
            data: data,
            width: width,
            height: height,
            layers: any(
              named: 'layers',
              that: isA<List<Map<String, dynamic>>>().having(
                (m) => m.first['assetPath'],
                'assetPath',
                layers.first.assetPath,
              ),
            ),
            aspectRatio: aspectRatio,
          ),
        ).called(1);
      });

      test('throws CompositePhotoException when compositor fails', () async {
        when(
          () => imageCompositor.composite(
            data: any(named: 'data'),
            width: any(named: 'width'),
            height: any(named: 'height'),
            layers: any(named: 'layers'),
            aspectRatio: any(named: 'aspectRatio'),
          ),
        ).thenThrow(Exception('oops'));
        expect(
          () => photosRepository.composite(
            width: width,
            height: height,
            data: data,
            layers: layers,
            aspectRatio: aspectRatio,
          ),
          throwsA(
            isA<CompositePhotoException>().having(
              (e) => e.toString(),
              'toString',
              contains('compositing photo failed.'),
            ),
          ),
        );
      });
    });
  });
}
