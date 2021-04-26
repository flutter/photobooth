// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

void main() {
  group('AnimatedCharacters', () {
    group('AnimatedAndroid', () {
      test('is an AnimatedSprite', () {
        expect(AnimatedAndroid(), isA<AnimatedSprite>());
      });
    });

    group('AnimatedDino', () {
      test('is an AnimatedSprite', () {
        expect(AnimatedDino(), isA<AnimatedSprite>());
      });
    });

    group('AnimatedDash', () {
      test('is an AnimatedSprite', () {
        expect(AnimatedDash(), isA<AnimatedSprite>());
      });
    });

    group('AnimatedSparky', () {
      test('is an AnimatedSprite', () {
        expect(AnimatedSparky(), isA<AnimatedSprite>());
      });
    });
  });
}
