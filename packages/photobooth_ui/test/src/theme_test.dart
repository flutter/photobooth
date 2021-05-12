// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

void main() {
  group('PhotoboothTheme themeData', () {
    test('is defined for both small, medium, and standard', () {
      expect(PhotoboothTheme.small, isA<ThemeData>());
      expect(PhotoboothTheme.medium, isA<ThemeData>());
      expect(PhotoboothTheme.standard, isA<ThemeData>());
    });
  });
}
