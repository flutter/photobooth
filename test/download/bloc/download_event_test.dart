// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/download/download.dart';

void main() {
  group('DownloadEvent', () {
    test('DownloadTapped supports value equality', () {
      expect(DownloadTapped(), equals(DownloadTapped()));
    });
  });
}
