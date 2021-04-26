// ignore_for_file: prefer_const_constructors
import 'package:share_photo_repository/share_photo_repository.dart';
import 'package:test/test.dart';

void main() {
  group('SharePhotoRepository', () {
    test('can be instantiated', () {
      expect(
        SharePhotoRepository(
          isSharingEnabled: false,
          shareUrl: 'share-url',
        ),
        isNotNull,
      );
    });

    group('isSharingEnabled', () {
      test(
          'returns false '
          'when isSharingEnabled false is passed the constructor', () {
        final repository = SharePhotoRepository(
          isSharingEnabled: false,
          shareUrl: 'share-url',
        );
        expect(
          repository.isSharingEnabled,
          isFalse,
        );
      });

      test(
          'returns true '
          'when isSharingEnabled true is passed the constructor', () {
        final repository = SharePhotoRepository(
          isSharingEnabled: true,
          shareUrl: 'share-url',
        );
        expect(
          repository.isSharingEnabled,
          isTrue,
        );
      });
    });

    group('getShareOnTwitterUrl', () {
      test('returns correct link', () {
        final repository = SharePhotoRepository(
          isSharingEnabled: true,
          shareUrl: 'http://example.com/share',
        );

        final twitterLink = repository.getShareOnTwitterUrl('photo.jpg');
        expect(
          twitterLink,
          equals(
            'https://twitter.com/intent/tweet?url=http://example.com/share/photo.jpg',
          ),
        );
      });
    });

    group('getShareOnFacebookUrl', () {
      test('returns correct link', () {
        final repository = SharePhotoRepository(
          isSharingEnabled: true,
          shareUrl: 'http://example.com/share',
        );

        final twitterLink = repository.getShareOnFacebookUrl('photo.jpg');
        expect(
          twitterLink,
          equals(
            'https://www.facebook.com/sharer.php?u=http://example.com/share/photo.jpg',
          ),
        );
      });
    });
  });
}
