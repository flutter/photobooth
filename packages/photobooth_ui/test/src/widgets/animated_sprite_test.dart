// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flame/cache.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

import '../../helpers/helpers.dart';

class MockImages extends Mock implements Images {}

class MockImage extends Mock implements ui.Image {}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AnimatedSprite', () {
    late ui.Image image;
    late Images images;

    setUpAll(() async {
      image = await decodeImageFromList(Uint8List.fromList(transparentImage));
    });

    setUp(() {
      images = MockImages();
      Flame.images = images;
    });

    testWidgets('renders AppCircularProgressIndicator when loading asset',
        (tester) async {
      await tester.pumpWidget(
        AnimatedSprite(
          sprites: Sprites(asset: 'test.png', size: Size(1, 1), frames: 1),
        ),
      );
      expect(find.byType(AppCircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'does not render AppCircularProgressIndicator'
        ' when loading asset and showLoadingIndicator is false',
        (tester) async {
      await tester.pumpWidget(
        AnimatedSprite(
          sprites: Sprites(asset: 'test.png', size: Size(1, 1), frames: 1),
          showLoadingIndicator: false,
        ),
      );
      expect(find.byType(AppCircularProgressIndicator), findsNothing);
    });

    testWidgets('renders SpriteAnimationWidget when asset is loaded (loop)',
        (tester) async {
      await tester.runAsync(() async {
        final images = MockImages();
        when(() => images.load(any())).thenAnswer((_) async => image);
        Flame.images = images;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedSprite(
                sprites: Sprites(
                  asset: 'test.png',
                  size: Size(1, 1),
                  frames: 1,
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        final spriteAnimationFinder = find.byType(SpriteAnimationWidget);
        final widget = tester.widget<SpriteAnimationWidget>(
          spriteAnimationFinder,
        );
        expect(widget.playing, isTrue);
      });
    });

    testWidgets('renders SpriteAnimationWidget when asset is loaded (oneTime)',
        (tester) async {
      await tester.runAsync(() async {
        final images = MockImages();
        when(() => images.load(any())).thenAnswer((_) async => image);
        Flame.images = images;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedSprite(
                sprites: Sprites(
                  asset: 'test.png',
                  size: Size(1, 1),
                  frames: 1,
                ),
                mode: AnimationMode.oneTime,
              ),
            ),
          ),
        );
        await tester.pump();
        final spriteAnimationFinder = find.byType(SpriteAnimationWidget);
        final widget = tester.widget<SpriteAnimationWidget>(
          spriteAnimationFinder,
        );
        expect(widget.playing, isTrue);
      });
    });
  });
}
