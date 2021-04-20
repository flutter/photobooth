import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class MockImage extends Mock implements ui.Image {}

class MockByteBuffer extends Mock implements ByteBuffer {}

void main() {
  group('Asset', () {
    test('does not support value equality', () {
      final image = MockImage();
      final name = 'name';
      final buffer = MockByteBuffer();
      final bytes = Uint8List.fromList([]);
      final assetA = Asset(
        name: name,
        image: image,
        buffer: buffer,
        bytes: bytes,
      );
      final assetB = Asset(
        name: name,
        image: image,
        buffer: buffer,
        bytes: bytes,
      );
      expect(assetA, isNot(equals(assetB)));
    });
  });
}
