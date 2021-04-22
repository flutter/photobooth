// ignore_for_file: prefer_const_constructors
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:test/test.dart';

class MockAsset extends Mock implements Asset {}

void main() {
  group('PhotoboothState', () {
    test('supports value equality', () {
      expect(PhotoboothState(), equals(PhotoboothState()));
    });
  });

  group('PhotoAsset', () {
    group('copyWith', () {
      test('updates asset', () {
        final assetA = MockAsset();
        final assetB = MockAsset();
        expect(
          PhotoAsset(id: '0', asset: assetA).copyWith(asset: assetB).asset,
          equals(assetB),
        );
      });
    });
  });
}
