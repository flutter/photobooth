import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

void main() {
  group('Asset', () {
    test('does not support value equality', () {
      const name = 'image';
      const path = 'path/to/image.png';
      const size = Size(10, 10);
      const assetA = Asset(name: name, path: path, size: size);
      const assetB = Asset(name: name, path: path, size: size);
      expect(assetA, isNot(equals(assetB)));
    });
  });
}
