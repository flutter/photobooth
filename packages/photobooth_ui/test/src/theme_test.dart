// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

void main() {
  group('PhotoboothTheme.themeData', () {
    test('is defined', () {
      expect(PhotoboothTheme.themeData, isA<ThemeData>());
    });
  });
}
