import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:mocktail/mocktail.dart';

class MockImage extends Mock implements ui.Image {}

class MockByteBuffer extends Mock implements ByteBuffer {}

void main() {
  group('Asset', () {
    test('supports value equality', () {
      final image = MockImage();
      final buffer = MockByteBuffer();
      final bytes = Uint8List.fromList([]);
      final assetA = Asset(image: image, buffer: buffer, bytes: bytes);
      final assetB = Asset(image: image, buffer: buffer, bytes: bytes);
      expect(assetA, equals(assetB));
    });
  });
}
