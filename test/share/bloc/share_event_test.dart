// ignore_for_file: prefer_const_constructors
import 'package:test/test.dart';
import 'package:io_photobooth/share/share.dart';

void main() {
  group('ShareEvent', () {
    final shareText = 'share-text';

    group('ShareViewLoaded', () {
      test('support value equality', () {
        final instanceA = ShareViewLoaded();
        final instanceB = ShareViewLoaded();
        expect(instanceA, equals(instanceB));
      });
    });

    group('ShareOnTwitterTapped', () {
      test('support value equality', () {
        final instanceA = ShareOnTwitterTapped(shareText: shareText);
        final instanceB = ShareOnTwitterTapped(shareText: shareText);
        expect(instanceA, equals(instanceB));
      });
    });

    group('ShareOnFacebookTapped', () {
      test('support value equality', () {
        final instanceA = ShareOnFacebookTapped(shareText: shareText);
        final instanceB = ShareOnFacebookTapped(shareText: shareText);
        expect(instanceA, equals(instanceB));
      });
    });
  });
}
