// ignore_for_file: prefer_const_constructors
import 'package:flutter/widgets.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:test/test.dart';

void main() {
  group('PhotoboothEvent', () {
    const update = DragUpdate(position: Offset(0, 0), size: Size(0, 0));

    test('PhotoboothAndroidUpdated supports value equality', () {
      final instanceA = PhotoboothAndroidUpdated(update: update);
      final instanceB = PhotoboothAndroidUpdated(update: update);

      expect(instanceA, equals(instanceB));
    });

    test('PhotoboothDashUpdated supports value equality', () {
      final instanceA = PhotoboothDashUpdated(update: update);
      final instanceB = PhotoboothDashUpdated(update: update);

      expect(instanceA, equals(instanceB));
    });

    test('PhotoboothSparkyUpdated supports value equality', () {
      final instanceA = PhotoboothSparkyUpdated(update: update);
      final instanceB = PhotoboothSparkyUpdated(update: update);

      expect(instanceA, equals(instanceB));
    });
  });
}
